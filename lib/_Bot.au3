#include-once
Global $g_pBotStopCommand = 0
Global $g_sStopFlagFile = @TempDir & "\NightfallStoryline-stop-" & @AutoItPID & ".flag"
Func _BotStopFile()
    Local $c = ""
    If $g_sForcedChar <> "" Then $c = $g_sForcedChar
    If $c = "" Then $c = $g_sCache_charName
    If $c = "" Or $c = "-" Then $c = IniRead($g_sConfigFile, "Debug", "MainCharName", "")
    $c = StringStripWS(StringRegExpReplace($c, '[\\/:*?"<>|]', "_"), 3)
    If $c = "" Then Return $g_sStopFlagFile
    Return @TempDir & "\NightfallStoryline-stop-" & $c & ".flag"
EndFunc
Func Bot_AllowGameCommand($pCommand)
    If $g_pBotStopCommand <> 0 And $pCommand = $g_pBotStopCommand Then Return True
    Call("_PollStopButton")
    Return Not Bot_UserStopped() And Not $g_bGwDown
EndFunc
Func Bot_CancelCurrentAction()
    If Not $Bot_Core_Initialized Or $g_bGwDown Then Return
    Local $dStop = DllStructCreate("dword command;dword size;dword header")
    DllStructSetData($dStop, "command", DllStructGetData($g_d_Packet, 1))
    DllStructSetData($dStop, "size", 4)
    DllStructSetData($dStop, "header", $GC_I_HEADER_ACTION_CANCEL)
    $g_pBotStopCommand = DllStructGetPtr($dStop)
    Core_Enqueue_($g_pBotStopCommand, DllStructGetSize($dStop))
    $g_pBotStopCommand = 0
    Local $x = Agent_GetAgentInfo(-2, "X")
    Local $y = Agent_GetAgentInfo(-2, "Y")
    If Not IsNumber($x) Or Not IsNumber($y) Then Return
    Local $dMove = DllStructCreate("dword command;float x;float y;float z")
    DllStructSetData($dMove, "command", DllStructGetData($g_d_Move, 1))
    DllStructSetData($dMove, "x", $x)
    DllStructSetData($dMove, "y", $y)
    $g_pBotStopCommand = DllStructGetPtr($dMove)
    Core_Enqueue_($g_pBotStopCommand, DllStructGetSize($dMove))
    $g_pBotStopCommand = 0
EndFunc
Func Bot_ShouldStop()
    Call("_PollStopButton")
    If $g_bGwDown Then Return True
    If FileExists(_BotStopFile()) Then
        $g_bUserPaused = True
        Return True
    EndIf
    If $g_bUserPaused Then Return True
    If $g_sPendingAction = "StopCampaign" Or $g_sPendingAction = "PauseCampaign" Then Return True
    Return False
EndFunc
Func Bot_UserStopped()
    If FileExists(_BotStopFile()) Then
        $g_bUserPaused = True
        Return True
    EndIf
    If $g_bUserPaused Then Return True
    If $g_sPendingAction = "StopCampaign" Or $g_sPendingAction = "PauseCampaign" Then Return True
    Return False
EndFunc
Func Bot_IsInMission($expectedMapID, $expectedType = $GC_I_MAP_TYPE_EXPLORABLE)
    Local $curMap = Map_GetMapID()
    Local $curType = Map_GetInstanceInfo("Type")
    If $curMap <> $expectedMapID Then
        Out("[Bot] No estoy en mission instance: map=" & $curMap & " (esperado " & $expectedMapID & ")")
        Return False
    EndIf
    If $curType <> $expectedType Then
        Out("[Bot] No estoy en EXPLORABLE: type=" & $curType & " (esperado " & $expectedType & ")")
        Return False
    EndIf
    Return True
EndFunc
Func Bot_AbortClean($reason)
    Out("[Bot] ABORT MISSION: " & $reason)
    Return False
EndFunc
Func Bot_Dialog($dialogCode)
    GameEvents_OnDialogSent($dialogCode)
    Ui_Dialog($dialogCode)
EndFunc
Func Bot_Sleep($ms)
    Local $tWait = TimerInit()
    While TimerDiff($tWait) < $ms
        If Bot_ShouldStop() Then Return False
        Local $remaining = $ms - TimerDiff($tWait)
        If $remaining > 500 Then
            Sleep(500)
        Else
            Sleep($remaining)
        EndIf
    WEnd
    Return True
EndFunc