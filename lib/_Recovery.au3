#include-once
Global $g_lastPosX = 0
Global $g_lastPosY = 0
Global $g_lastPosTime = 0
Func Recovery_IsAtZero()
    Local $x = Agent_GetAgentInfo(-2, "X")
    Local $y = Agent_GetAgentInfo(-2, "Y")
    Local $maxhp = Agent_GetAgentInfo(-2, "MaxHP")
    Return ($x = 0 And $y = 0 And $maxhp = 0)
EndFunc
Func Recovery_IsOutOfInstance($expectedMapID = -1, $expectedType = -1)
    Local $curMap = Map_GetMapID()
    If $curMap = 0 Then Return True
    If Map_GetInstanceInfo("IsLoading") Then Return True
    If $expectedMapID > 0 And $curMap <> $expectedMapID Then Return True
    If $expectedType >= 0 And Map_GetInstanceInfo("Type") <> $expectedType Then Return True
    Return False
EndFunc
Func Recovery_IsDead()
    If Map_GetInstanceInfo("IsLoading") Then Return False
    If Map_GetMapID() = 0 Then Return False
    Local $hp = Agent_GetAgentInfo(-2, "HP")
    Local $maxHp = Agent_GetAgentInfo(-2, "MaxHP")
    If $maxHp = 0 Then Return False
    If Agent_GetAgentInfo(-2, "X") = 0 And Agent_GetAgentInfo(-2, "Y") = 0 Then Return False
    Return ($hp <= 0)
EndFunc
Func Recovery_IsDefeated()
    Return Party_GetPartyContextInfo("IsDefeated")
EndFunc
Func Recovery_IsDisconnected()
    If Not ProcessExists("gw.exe") Then Return True
    Local $hp = Agent_GetAgentInfo(-2, "HP")
    If @error Then Return True
    Return False
EndFunc
Func Recovery_CheckStuck()
    Local $checkMs = Int(IniRead(@ScriptDir & "\config.ini", "Recovery", "StuckCheckMs", "5500"))
    Local $minMove = Int(IniRead(@ScriptDir & "\config.ini", "Recovery", "StuckMinMove", "140"))
    Local $x = Agent_GetAgentInfo(-2, "X")
    Local $y = Agent_GetAgentInfo(-2, "Y")
    If $g_lastPosTime = 0 Then
        $g_lastPosTime = TimerInit()
        $g_lastPosX = $x
        $g_lastPosY = $y
        Return False
    EndIf
    If TimerDiff($g_lastPosTime) < $checkMs Then Return False
    Local $dx = $x - $g_lastPosX
    Local $dy = $y - $g_lastPosY
    Local $dist = Sqrt($dx * $dx + $dy * $dy)
    $g_lastPosX = $x
    $g_lastPosY = $y
    $g_lastPosTime = TimerInit()
    If $dist < $minMove Then
        Out("[Recovery] Stuck detected (moved " & Round($dist, 1) & " in " & $checkMs & " ms)")
        Return True
    EndIf
    Return False
EndFunc
Func _ResetStuckBaseline()
    $g_lastPosTime = TimerInit()
    $g_lastPosX = Agent_GetAgentInfo(-2, "X")
    $g_lastPosY = Agent_GetAgentInfo(-2, "Y")
    GameEvents_ResetStuck()       
    GameEvents_EnableRescue()     
EndFunc
Func Recovery_Unstuck()
    Local $x = Agent_GetAgentInfo(-2, "X")
    Local $y = Agent_GetAgentInfo(-2, "Y")
    Local $offsetX = Random(-150, 150, 1)
    Local $offsetY = Random(-150, 150, 1)
    Out("[Recovery] Unstuck offset (" & $offsetX & "," & $offsetY & ")")
    MoveTo($x + $offsetX, $y + $offsetY)
    Sleep(1000)
    $g_lastPosX = Agent_GetAgentInfo(-2, "X")
    $g_lastPosY = Agent_GetAgentInfo(-2, "Y")
    $g_lastPosTime = TimerInit()
    Return True
EndFunc
Func Recovery_Resign()
    Out("[Recovery] Resign /resign")
    Chat_SendChat("/resign", "!")
    Sleep(8000)
    Return True
EndFunc
Func Recovery_Relog()
    Out("[Recovery] Relog not implemented. Manual intervention required.")
    Return False
EndFunc