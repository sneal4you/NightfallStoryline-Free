#include-once
Func _SetLabelIfChanged($ctrl, $value, ByRef $cache)
    If $value == $cache Then Return
    GUICtrlSetData($ctrl, $value)
    $cache = $value
EndFunc
Func UpdateCharList()
    Local $chars = Scanner_GetLoggedCharNames()
    If @error Or $chars = "" Then Return
    GUICtrlSetData($cbx_char_select, "")
    GUICtrlSetData($cbx_char_select, $chars)
EndFunc
Func UpdateUiCharInfo()
    If $BotRunning Then
        _SetLabelIfChanged($g_idStatsTitle, "BOT STATUS: RUNNING", $g_sCache_botRunning)
        GUICtrlSetColor($g_idStatsTitle, $g_clrOk)
    Else
        _SetLabelIfChanged($g_idStatsTitle, "BOT STATUS: STOPPED", $g_sCache_botRunning)
        GUICtrlSetColor($g_idStatsTitle, $g_clrError)
    EndIf
    If Not $Bot_Core_Initialized Then Return
    Local $cname = Agent_GetAgentInfo(-2, "Name")
    If Not @error And $cname <> "" Then
        If $cname <> $g_sCache_charName Then $g_sCache_charName = $cname
    EndIf
    Local $profPrimary = Party_GetPartyProfessionInfo(-2, "Primary")
    Local $profSecondary = Party_GetPartyProfessionInfo(-2, "Secondary")
    If $profPrimary > 0 Then
        Local $profStr = _ProfessionAbbr($profPrimary)
        If $profSecondary > 0 And $profSecondary <> $profPrimary Then $profStr &= "/" & _ProfessionAbbr($profSecondary)
        _SetLabelIfChanged($lbl_charProf, $profStr, $g_sCache_charProf)
    EndIf
    Local $level = Agent_GetAgentInfo(-2, "Level")
    If Not @error Then _SetLabelIfChanged($lbl_level, "NIVEL: " & $level, $g_sCache_level)
    _SetLabelIfChanged($lbl_questLogState, "MISION: " & _UiCurrentMissionName(), $g_sCache_questLog)
    Local $mid = Map_GetMapID()
    _SetLabelIfChanged($lbl_mapId, String($mid), $g_sCache_mapId)
    Local $mapName = _UiMapName($mid)
    _SetLabelIfChanged($lbl_currentState, "MAPA: " & $mapName, $g_sCache_currentState)
    Local $hpAbs = Round(Agent_GetAgentInfo(-2, "CurrentHP"))
    Local $maxhp = Agent_GetAgentInfo(-2, "MaxHP")
    If $maxhp > 0 Then
        Local $hpPct = Round(($hpAbs / $maxhp) * 100)
        _SetLabelIfChanged($lbl_hp, StringFormat("VIDA: %d/%d (%d%%)", $hpAbs, $maxhp, $hpPct), $g_sCache_hp)
    EndIf
    Local $enAbs = Round(Agent_GetAgentInfo(-2, "CurrentEnergy"))
    Local $maxen = Agent_GetAgentInfo(-2, "MaxEnergy")
    If $maxen > 0 Then
        Local $enPct = Round(($enAbs / $maxen) * 100)
        _SetLabelIfChanged($lbl_energy, StringFormat("ENERGIA: %d/%d (%d%%)", $enAbs, $maxen, $enPct), $g_sCache_energy)
    EndIf
    Local $pSize = Party_GetSize()
    Local $pHero = Party_GetHeroCount()
    If Not @error Then
        _SetLabelIfChanged($lbl_party, StringFormat("PARTY: %d total (%d heroes)", $pSize, $pHero), $g_sCache_party)
    EndIf
    Local $tgt = Agent_GetCurrentTarget()
    If $tgt > 0 Then
        Local $targetName = Agent_GetAgentInfo($tgt, "Name")
        If $targetName = "" Or @error Then $targetName = "Agent " & $tgt
        _SetLabelIfChanged($lbl_dist, "TARGET: " & $targetName, $g_sCache_dist)
    Else
        _SetLabelIfChanged($lbl_dist, "TARGET: -", $g_sCache_dist)
    EndIf
    _SetLabelIfChanged($lbl_currentMission, "DIALOG: " & _UiCurrentDialogHint($tgt), $g_sCache_currentMission)
    Local $cx = Round(Agent_GetAgentInfo(-2, "X")), $cy = Round(Agent_GetAgentInfo(-2, "Y"))
    _SetLabelIfChanged($lbl_coords, "COORDS: " & $cx & ", " & $cy, $g_sCache_coords)
EndFunc
Func _UiCurrentMissionName()
    Local $key = $g_currentPhase
    If $key = "" Then $key = $g_sPendingAction
    If $key = "" Then $key = $g_sQueuedPhase
    If $key <> "" Then
        For $i = 0 To UBound($g_aPhases) - 1
            If $g_aPhases[$i][0] = $key Then
                Local $groupName = $g_aPhases[$i][3]
                If StringRegExp($groupName, "^M[0-9][0-9] ") Then Return StringRegExpReplace($groupName, "^M[0-9][0-9] ", "")
                Return _UiPrettyTitle($g_aPhases[$i][1])
            EndIf
        Next
        Return _UiPrettyActionKey($key)
    EndIf
    Local $activeQuestId = World_GetWorldInfo("ActiveQuestID")
    If $activeQuestId > 0 Then
        Local $questName = Quest_GetQuestInfo($activeQuestId, "Name")
        If $questName <> "" Then Return $questName
    EndIf
    Return "-"
EndFunc
Func _UiPrettyTitle($s)
    If $s = "" Then Return "-"
    If StringRegExp($s, "^[A-Z0-9 '!-]+$") Then
        Local $out = "", $nextUpper = True
        $s = StringLower($s)
        For $i = 1 To StringLen($s)
            Local $ch = StringMid($s, $i, 1)
            If $nextUpper And StringRegExp($ch, "[a-z]") Then
                $out &= StringUpper($ch)
                $nextUpper = False
            Else
                $out &= $ch
                $nextUpper = ($ch = " " Or $ch = "-" Or $ch = "'")
            EndIf
        Next
        Return $out
    EndIf
    Return $s
EndFunc
Func _UiPrettyActionKey($key)
    Local $s = StringRegExpReplace($key, "^M[0-9][0-9]_", "")
    $s = StringRegExpReplace($s, "([a-z])([A-Z])", "$1 $2")
    Return _UiPrettyTitle($s)
EndFunc
Func _UiMapName($mapId)
    Switch $mapId
        Case 370
            Return "Kamadan, Jewel of Istan"
        Case 372
            Return "Fahranur, The First City"
        Case 378
            Return "Wehhan Terraces"
        Case 381
            Return "Yohlon Haven"
        Case 382
            Return "Gandara, the Moon Fortress"
        Case 387
            Return "Sunspear Sanctuary"
        Case 401
            Return "Sebelkeh Basilica"
        Case 403
            Return "Honur Hill"
        Case 405
            Return "Sun Docks"
        Case 421
            Return "Venta Cemetery"
        Case 424
            Return "Kodonur Crossroads"
        Case 425
            Return "Rilohn Refuge"
        Case 427
            Return "Moddok Crevice"
        Case 428
            Return "Tihark Orchard"
        Case 429
            Return "Consulate"
        Case 430
            Return "Plains of Jarin"
        Case 431
            Return "Sunspear Great Hall"
        Case 433
            Return "Dzagonur Bastion"
        Case 434
            Return "Dasha Vestibule"
        Case 436
            Return "Command Post"
        Case 449, 818, 819, 820
            Return "Kamadan, Jewel of Istan"
        Case 450
            Return "Gate of Torment"
        Case 458
            Return "Kodonur Crossroads"
        Case 459
            Return "Rilohn Refuge"
        Case 477
            Return "Nundu Bay"
        Case 479
            Return "Champion's Dawn"
        Case 480
            Return "Ruins of Morah"
        Case 481
            Return "Fahranur, The First City"
        Case 488
            Return "Mehtani Keys"
        Case 489
            Return "Kodlonu Hamlet"
        Case 490, 514
            Return "Island of Shehkah"
        Case 491, 515
            Return "Jokanur Diggings"
        Case 492, 516
            Return "Blacktide Den"
        Case 493, 517
            Return "Consulate Docks"
        Case 494
            Return "Gate of Pain"
        Case 495
            Return "Gate of Madness"
        Case 496
            Return "Abaddon's Gate"
        Case 497, 536
            Return "Sunspear Arena"
        Case 518
            Return "Tihark Orchard"
        Case 519
            Return "Dzagonur Bastion"
        Case 523
            Return "Nundu Bay"
        Case 525
            Return "Ruins of Morah"
        Case 527
            Return "Gate of Madness"
        Case 528
            Return "Abaddon's Gate"
        Case 543
            Return "Sun Docks"
        Case 544, 556
            Return "Chahbek Village"
        Case 554
            Return "Dajkah Inlet"
    EndSwitch
    If $mapId > 0 Then Return "Mapa " & $mapId
    Return "-"
EndFunc
Func _UiCurrentDialogHint($target)
    If $target <= 0 Then Return "-"
    Local $activeQuestId = World_GetWorldInfo("ActiveQuestID")
    If $activeQuestId <= 0 Then Return "-"
    Local $ls = Quest_GetQuestInfo($activeQuestId, "LogState")
    Local $code = 0, $kind = ""
    Select
        Case $ls = 33 Or $ls = 34 Or $ls = 35 Or $ls = 2 Or $ls = 3 Or $ls = 19 Or $ls = 79
            $code = Dec("008" & Hex($activeQuestId, 3) & "07")
            $kind = "REWARD"
        Case $ls > 0
            $code = Dec("008" & Hex($activeQuestId, 3) & "04")
            $kind = "UPDATE"
    EndSelect
    If $code = 0 Then Return "-"
    Return $kind & " 0x" & Hex($code, 6)
EndFunc
Func _StateName($state)
    Switch $state
        Case $NF_STATE_IDLE
            Return "IDLE"
        Case $NF_STATE_DETECT_PROGRESS
            Return "DETECT_PROGRESS"
        Case $NF_STATE_ACCEPT_QUEST
            Return "ACCEPT_QUEST"
        Case $NF_STATE_ENTER_MISSION
            Return "ENTER_MISSION"
        Case $NF_STATE_IN_MISSION
            Return "IN_MISSION"
        Case $NF_STATE_DONE
            Return "DONE"
        Case Else
            Return "UNKNOWN"
    EndSwitch
EndFunc
Func _ProfessionAbbr($profID)
    Switch $profID
        Case 1
            Return "W"
        Case 2
            Return "R"
        Case 3
            Return "Mo"
        Case 4
            Return "N"
        Case 5
            Return "Me"
        Case 6
            Return "E"
        Case 7
            Return "A"
        Case 8
            Return "Rt"
        Case 9
            Return "P"
        Case 10
            Return "D"
        Case Else
            Return "?"
    EndSwitch
EndFunc