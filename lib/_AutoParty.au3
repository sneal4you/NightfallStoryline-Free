#include-once
Global $g_iAutoPartyLastTry = 0
Global $g_iAutoPartyLastLoggedMap = 0
Global $g_iAutoPartyHeroAttempts[3] = [0, 0, 0]
Global Const $AP_MAX_HERO_ATTEMPTS = 3
Global $g_iAutoPartyHenchFailures   = 0
Global $g_iAutoPartyFillFailures    = 0   
Global Const $AP_MAX_HENCH_FAILURES = 5
Global $g_aiAutoPartyHeroes[3] = [$GC_I_HERO_ID_KOSS, $GC_I_HERO_ID_DUNKORO, $GC_I_HERO_ID_MELONNI]
Global $g_aiAutoPartyHenchModels[1] = [4593]
Global $g_aiAutoPartyHenchProfs[2] = [6, 5]
Func AutoParty_Tick()
    If Not $Bot_Core_Initialized Then Return
    Local $mapId = Map_GetMapID()
    If $mapId = 0 Then Return
    If Map_GetInstanceInfo("IsLoading") Then Return
    If Map_GetInstanceInfo("Type") <> $GC_I_MAP_TYPE_OUTPOST Then Return
    If Agent_GetAgentInfo(-2, "MaxHP") <= 0 Then Return
    If Agent_GetAgentInfo(-2, "X") = 0 And Agent_GetAgentInfo(-2, "Y") = 0 Then Return
    If $g_bTeamSetupRunning Then Return
    If $g_bPostTravelQuietUntil <> 0 And TimerDiff($g_bPostTravelQuietUntil) < 4000 Then Return
    If $mapId = 554 Then Return
    If $mapId = 424 Then Return
    If $mapId = 428 Then Return
    If $mapId = 414 Then Return
    If $mapId = 399 Then Return
    If $mapId = $GC_I_MAP_ID_MODDOK_CREVICE_OUTPOST Then Return
    If $mapId = $GC_I_MAP_ID_WEHHAN_TERRACES Then Return
    If $mapId = 433 Then Return
    If $mapId = 477 Then Return
    If $mapId = 387 Then Return
    If $mapId = 478 Then Return
    If $mapId = 480 Then Return
    If $mapId = 450 Then Return
    If $mapId = 494 Or $mapId = 469 Or $mapId = 473 Or $mapId = 495 Or $mapId = 496 Then Return
    If $mapId = 493 Then Return
    If $mapId = $GC_I_MAP_ID_HONUR_HILL Then Return
    If $mapId = $GC_I_MAP_ID_GRAND_COURT_OF_SEBELKEH_OUTPOST Then Return
    If $mapId = $GC_I_MAP_ID_CHANTRY_OF_SECRETS Then Return
    If $mapId = $GC_I_MAP_ID_MIHANU_TOWNSHIP Then Return
    If $mapId = 545 Or $mapId = 437 Then Return
    If $g_bActionRunning Then
        Local $apHs = Party_GetMyPartyInfo("ArrayHeroPartyMemberSize")
        Local $apHn = Party_GetMyPartyInfo("ArrayHenchmanPartyMemberSize")
        Local $apMx = Map_GetAreaInfo($mapId, "MaxPartySize")
        Local $apMonk = _AutoParty_IsHenchModelInParty($GC_I_MODEL_ID_NF_KIHM) _
                     Or _AutoParty_IsHenchModelInParty($GC_I_MODEL_ID_NF_KIHM_BH) _
                     Or _AutoParty_IsHenchModelInParty(4628)
        If $apMx > 1 And (1 + $apHs + $apHn) >= $apMx And $apMonk Then Return
    EndIf
    If $g_iAutoPartyLastTry <> 0 And TimerDiff($g_iAutoPartyLastTry) < 2000 Then Return
    Local $heroes  = Party_GetMyPartyInfo("ArrayHeroPartyMemberSize")
    Local $hench   = Party_GetMyPartyInfo("ArrayHenchmanPartyMemberSize")
    Local $size    = 1 + $heroes + $hench
    Local $maxSize = Map_GetAreaInfo($mapId, "MaxPartySize")
    If $maxSize <= 1 Then
        $g_iAutoPartyLastTry = TimerInit()
        Return
    EndIf
    If $g_iAutoPartyLastLoggedMap <> $mapId Then
        Out("[AutoParty] Map " & $mapId & " outpost. Party " & $size & "/" & $maxSize)
        $g_iAutoPartyLastLoggedMap = $mapId
        For $i = 0 To UBound($g_iAutoPartyHeroAttempts) - 1
            $g_iAutoPartyHeroAttempts[$i] = 0
        Next
        $g_iAutoPartyHenchFailures = 0   
        $g_iAutoPartyFillFailures  = 0   
    EndIf
    If $mapId = $GC_I_MAP_ID_CHAHBEK_VILLAGE_OUTPOST Then
        Local $logState677 = Quest_GetQuestInfo(677, "LogState")
        If $logState677 > 0 Then
            $g_iAutoPartyLastTry = TimerInit()
            Return
        EndIf
    EndIf
    If UBound($g_iAutoPartyHeroAttempts) < UBound($g_aiAutoPartyHeroes) Then
        ReDim $g_iAutoPartyHeroAttempts[UBound($g_aiAutoPartyHeroes)]
    EndIf
    For $i = 0 To UBound($g_aiAutoPartyHeroes) - 1
        Local $heroId = $g_aiAutoPartyHeroes[$i]
        If $heroId = "" Or $heroId = 0 Then ContinueLoop
        If _AutoParty_IsHeroInParty($heroId) Then
            $g_iAutoPartyHeroAttempts[$i] = 0
            ContinueLoop
        EndIf
        If $g_iAutoPartyHeroAttempts[$i] >= $AP_MAX_HERO_ATTEMPTS Then ContinueLoop
        If Not _AutoParty_IsHeroUnlocked($heroId) Then ContinueLoop
        If $size >= $maxSize Then
            Local $kicked = _AutoParty_KickAnyHenchman()
            If Not $kicked Then
                ExitLoop
            EndIf
            Out("[AutoParty] Kick henchman para hacer hueco a hero ID=" & $heroId & " (reset intentos)")
            $size -= 1
            $g_iAutoPartyHeroAttempts[$i] = 0   
            $g_iAutoPartyLastTry = TimerInit()
            Sleep(500)   
            Return       
        EndIf
        Out("[AutoParty] Party_AddHero ID=" & $heroId & " (intento " & ($g_iAutoPartyHeroAttempts[$i]+1) & "/" & $AP_MAX_HERO_ATTEMPTS & ")")
        Party_AddHero($heroId)
        $g_iAutoPartyHeroAttempts[$i] += 1
        $g_iAutoPartyLastTry = TimerInit()
        Return
    Next
    Local $monkModel = $GC_I_MODEL_ID_NF_KIHM                          
    If $mapId = $GC_I_MAP_ID_BEKNUR_HARBOR_2 Then $monkModel = $GC_I_MODEL_ID_NF_KIHM_BH 
    If $mapId = 489 Then $monkModel = 4607                             
    If $g_iAutoPartyHenchFailures < $AP_MAX_HENCH_FAILURES Then
        Local $bMonkInParty = _AutoParty_IsHenchModelInParty($monkModel)
        If Not $bMonkInParty Then
            If $size >= $maxSize Then
                _AutoParty_KickNonMonkHenchman($monkModel)
                $size -= 1
                $g_iAutoPartyHenchFailures += 1
                If $g_iAutoPartyHenchFailures >= $AP_MAX_HENCH_FAILURES Then
                    Out("[AutoParty] Monje model=" & $monkModel & " no encontrado en map=" & $mapId & " tras " & $AP_MAX_HENCH_FAILURES & " intentos (kick) -> deteniendo (party OK sin monje)")
                EndIf
                $g_iAutoPartyLastTry = TimerInit()
                Sleep(600)
                Return
            EndIf
            Local $monkAgent = Agent_GetAgentByPlayerNumber($monkModel)
            If $monkAgent <> 0 Then
                Out("[AutoParty] Party_AddNpc monje model=" & $monkModel & " agent=" & $monkAgent)
                Party_AddNpc($monkAgent)
                $g_iAutoPartyLastTry = TimerInit()
                Return
            Else
                $g_iAutoPartyHenchFailures += 1
                If $g_iAutoPartyHenchFailures >= $AP_MAX_HENCH_FAILURES Then
                    Out("[AutoParty] Monje model=" & $monkModel & " no encontrado en map=" & $mapId & " tras " & $AP_MAX_HENCH_FAILURES & " intentos -> deteniendo (party OK sin monje)")
                EndIf
            EndIf
        Else
            $g_iAutoPartyHenchFailures = 0   
        EndIf
    EndIf
    If $size < $maxSize Then
        For $i = 0 To UBound($g_aiAutoPartyHenchProfs) - 1
            Local $profId = $g_aiAutoPartyHenchProfs[$i]
            Local $hAgent = _AutoParty_FindHenchmanByProf($profId)
            If $hAgent <> 0 And Not _AutoParty_IsHenchAgentInParty($hAgent) Then
                Out("[AutoParty] Fallback prof=" & $profId & " -> Party_AddNpc agent=" & $hAgent)
                Party_AddNpc($hAgent)
                $g_iAutoPartyLastTry = TimerInit()
                Return
            EndIf
        Next
    EndIf
    If $size < $maxSize And $g_iAutoPartyFillFailures < $AP_MAX_HENCH_FAILURES Then
        If Not Party_FillWithHenchmen() Then
            $g_iAutoPartyFillFailures += 1
        EndIf
    EndIf
    $g_iAutoPartyLastTry = TimerInit()
EndFunc
Func _AutoParty_KickAnyHenchman()
    Local $nHench = Party_GetMyPartyInfo("ArrayHenchmanPartyMemberSize")
    If @error Or $nHench <= 0 Then Return False
    Local $hAgentId = Party_GetMyPartyHenchmanInfo(1, "AgentID")
    If $hAgentId = 0 Then Return False
    Out("[AutoParty] Party_KickNpc agent=" & $hAgentId)
    Party_KickNpc($hAgentId)
    Return True
EndFunc
Func _AutoParty_FindHenchmanByProf($profId)
    Local $agents = Agent_GetAgentArray($GC_I_AGENT_TYPE_LIVING)
    If Not IsArray($agents) Or $agents[0] = 0 Then Return 0
    For $i = 1 To $agents[0]
        Local $ptr = $agents[$i]
        If $ptr = 0 Then ContinueLoop
        If Not Agent_GetAgentInfo($ptr, "IsHenchman") Then ContinueLoop
        If Agent_GetAgentInfo($ptr, "Profession") <> $profId Then ContinueLoop
        Return Agent_GetAgentInfo($ptr, "ID")
    Next
    Return 0
EndFunc
Func _AutoParty_IsHenchAgentInParty($agentId)
    Local $nHench = Party_GetMyPartyInfo("ArrayHenchmanPartyMemberSize")
    If @error Then Return False
    For $i = 1 To $nHench
        If Party_GetMyPartyHenchmanInfo($i, "AgentID") = $agentId Then Return True
    Next
    Return False
EndFunc
Func _AutoParty_IsHeroUnlocked($heroId)
    Switch $heroId
        Case $GC_I_HERO_ID_KOSS
            If Quest_GetQuestInfo($GC_I_QUEST_ID_INTOCHAHBEKVILLAGE, 'IsCompleted') = 1 Then Return True
            Return Map_IsMapUnlocked(502)   
        Case $GC_I_HERO_ID_DUNKORO
            Return Map_IsMapUnlocked(491)
        Case $GC_I_HERO_ID_MELONNI
            If Quest_GetQuestInfo(634, "LogState") > 0 Then Return True
            Return False
        Case Else
            Return True
    EndSwitch
EndFunc
Func _AutoParty_IsHeroInParty($heroId)
    Local $nSlots = Party_GetMyPartyInfo("ArrayHeroPartyMemberSize")
    If @error Then Return False
    For $i = 1 To $nSlots
        If Party_GetMyPartyHeroInfo($i, "HeroID") = $heroId Then Return True
    Next
    Return False
EndFunc
Func _AutoParty_IsHenchModelInParty($modelId)
    Local $nHench = Party_GetMyPartyInfo("ArrayHenchmanPartyMemberSize")
    If @error Then Return False
    For $i = 1 To $nHench
        Local $aid = Party_GetMyPartyHenchmanInfo($i, "AgentID")
        If $aid = 0 Then ContinueLoop
        If Agent_GetAgentInfo($aid, "PlayerNumber") = $modelId Then Return True
    Next
    Return False
EndFunc
Func _AutoParty_KickNonMonkHenchman($keepModel)
    Local $nHench = Party_GetMyPartyInfo("ArrayHenchmanPartyMemberSize")
    If @error Or $nHench <= 0 Then Return False
    For $i = 1 To $nHench
        Local $aid = Party_GetMyPartyHenchmanInfo($i, "AgentID")
        If $aid = 0 Then ContinueLoop
        Local $model = Agent_GetAgentInfo($aid, "PlayerNumber")
        If $model = 0 Then ContinueLoop
        If $model <> $keepModel Then
            Out("[AutoParty] Kick henchman model=" & $model & " agent=" & $aid & " (no es monje " & $keepModel & ")")
            Party_KickNpc($aid)
            Return True
        EndIf
    Next
    Return False
EndFunc