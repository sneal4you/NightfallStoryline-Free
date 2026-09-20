#include-once
Global $g_FT_639Seen = False
Func _FT_DumpState($qid, $tag)
    Local $ls  = Quest_GetQuestInfo($qid, "LogState")
    Local $cr  = Quest_GetQuestInfo($qid, "CanReward")
    Local $mt  = Quest_GetQuestInfo($qid, "MapTo")
    Local $mx  = Quest_GetQuestInfo($qid, "MarkerX")
    Local $my  = Quest_GetQuestInfo($qid, "MarkerY")
    Local $obj = Quest_GetQuestInfo($qid, "Objectives")
    Local $cx  = Agent_GetAgentInfo(-2, "X"), $cy = Agent_GetAgentInfo(-2, "Y")
    Out("[FT] DUMP " & $tag & ": ls=" & $ls & " cr=" & $cr & " mt=" & $mt _
        & " marker=(" & Round($mx) & "," & Round($my) & ") char=(" & Round($cx) & "," & Round($cy) _
        & ") map=" & Map_GetMapID() & " obj='" & $obj & "'")
    Local $arr = Agent_GetAgentArray($GC_I_AGENT_TYPE_LIVING)
    If IsArray($arr) And $arr[0] > 0 Then
        For $i = 1 To $arr[0]
            Local $ptr = $arr[$i]
            If $ptr = 0 Then ContinueLoop
            If Agent_GetAgentInfo($ptr, "Allegiance") <> $GC_I_ALLEGIANCE_ENEMY Then ContinueLoop
            Local $ax = Agent_GetAgentInfo($ptr, "X"), $ay = Agent_GetAgentInfo($ptr, "Y")
            Local $d = Sqrt(($cx-$ax)^2+($cy-$ay)^2)
            If $d > 2500 Then ContinueLoop
            Out("[FT]   FOE '" & Agent_GetAgentInfo($ptr,"Name") & "' model=" & Agent_GetAgentInfo($ptr,"PlayerNumber") _
                & " hp=" & Round(Agent_GetAgentInfo($ptr,"HP")*100) & "% pos=(" & Round($ax) & "," & Round($ay) & ") d=" & Round($d))
        Next
    EndIf
EndFunc
Global $g_FT_SkipIDs = ""
Func _FT_PickupGroundItems($range = 1400, $bForce = False)
    Local $bCombat = (Not $bForce) And (GetNearestEnemy(1012) <> 0)
    Local $items = Agent_GetAgentArray($GC_I_AGENT_TYPE_ITEM)
    If Not IsArray($items) Or $items[0] = 0 Then Return 0
    Local $picked = 0
    For $i = 1 To $items[0]
        Local $ptr = $items[$i]
        If $ptr = 0 Then ContinueLoop
        Local $id = Agent_GetAgentInfo($ptr, "ID")
        If $id = 0 Then ContinueLoop
        If StringInStr($g_FT_SkipIDs, "|" & $id & "|") Then ContinueLoop
        Local $cx = Agent_GetAgentInfo(-2, "X"), $cy = Agent_GetAgentInfo(-2, "Y")
        Local $ix = Agent_GetAgentInfo($ptr, "X"), $iy = Agent_GetAgentInfo($ptr, "Y")
        Local $d = Sqrt(($cx-$ix)^2+($cy-$iy)^2)
        If $d > $range Then ContinueLoop
        Local $nm = Item_GetItemInfoByAgentID($id, "CompleteName")
        If $nm = 0 Then $nm = ""
        Out("[FT] GroundItem id=" & $id & " name='" & $nm & "' pos=(" & Round($ix) & "," & Round($iy) & ") d=" & Round($d) & (($bCombat) ? " [COMBAT]" : ""))
        If $d > 300 Then
            If $bCombat Then ContinueLoop   
            Map_Move($ix, $iy, 0)
            Local $tW = TimerInit()
            While TimerDiff($tW) < 8000
                $cx = Agent_GetAgentInfo(-2,"X")
                $cy = Agent_GetAgentInfo(-2,"Y")
                If Sqrt(($cx-$ix)^2+($cy-$iy)^2) < 200 Then ExitLoop
                If GetNearestEnemy(1012) <> 0 Then Return $picked
                Sleep(400)
            WEnd
        EndIf
        Out("[FT] recogiendo item id=" & $id)
        Item_PickUpItem($id)
        Sleep(800)   
        Local $re = Agent_GetAgentArray($GC_I_AGENT_TYPE_ITEM)
        Local $stillThere = False
        If IsArray($re) And $re[0] > 0 Then
            For $j = 1 To $re[0]
                If $re[$j] <> 0 And Agent_GetAgentInfo($re[$j], "ID") = $id Then
                    $stillThere = True
                    ExitLoop
                EndIf
            Next
        EndIf
        If $stillThere Then
            If $nm = "" Then
                Out("[FT] item id=" & $id & " no recogido (intentar de nuevo despuÃ©s, name vacÃ­o)")
            Else
                Out("[FT] item id=" & $id & " NO recogido â†’ skip (inalcanzable/inv lleno) name='" & $nm & "'")
                $g_FT_SkipIDs &= "|" & $id & "|"
            EndIf
        Else
            Out("[FT] item id=" & $id & " recogido OK")
            $picked += 1
        EndIf
    Next
    Return $picked
EndFunc
Func _FT_NavFightTo($x, $y, $maxMs = 240000)
    Local $t = TimerInit()
    While Not Bot_ShouldStop() And TimerDiff($t) < $maxMs
        If Map_GetMapID() <> $TCOD_COD_MAP_ID Then Return True
        If Agent_GetAgentInfo(-2, "IsDead") Then
            Out("[FT] NavFightTo: char muerto â†’ esperando rez (max 30s)")
            Local $tRez = TimerInit()
            Local $bRezOk = False
            While Not Bot_ShouldStop() And TimerDiff($tRez) < 30000
                If Not Agent_GetAgentInfo(-2, "IsDead") Then
                    Local $rx = Agent_GetAgentInfo(-2, "X"), $ry = Agent_GetAgentInfo(-2, "Y")
                    If $rx <> 0 Or $ry <> 0 Then
                        Out("[FT] NavFightTo: rez OK en (" & Round($rx) & "," & Round($ry) & ") â†’ retomando")
                        Sleep(2500)
                        $bRezOk = True
                        ExitLoop
                    EndIf
                EndIf
                Sleep(500)
            WEnd
            If Not $bRezOk Then
                Out("[FT] NavFightTo: rez TIMEOUT â†’ abortar")
                Return False
            EndIf
            ContinueLoop
        EndIf
        Local $cx = Agent_GetAgentInfo(-2, "X"), $cy = Agent_GetAgentInfo(-2, "Y")
        If Sqrt(($cx-$x)^2+($cy-$y)^2) < 300 Then Return True
        MoveToFollowPath($x, $y, 1200)
        If GetNearestEnemy(1300) <> 0 Then
            Out("[FT] NavFightTo: enemigos â†’ ClearZone")
            Local $czOK = Combat_ClearZone(1250, 25000)
            If Not $czOK Then Combat_ClearZone(1250, 8000)
            _FT_PickupGroundItems(1400, True)
        EndIf
    WEnd
    Return False
EndFunc
Func _FT_FindNpcByName($substr)
    Local $arr = Agent_GetAgentArray($GC_I_AGENT_TYPE_LIVING)
    If Not IsArray($arr) Or $arr[0] = 0 Then Return 0
    For $i = 1 To $arr[0]
        Local $ptr = $arr[$i]
        If $ptr = 0 Then ContinueLoop
        Local $alleg = Agent_GetAgentInfo($ptr, "Allegiance")
        If $alleg <> $GC_I_ALLEGIANCE_NPC And $alleg <> $GC_I_ALLEGIANCE_ALLY Then ContinueLoop
        If StringInStr(Agent_GetAgentInfo($ptr, "Name"), $substr) Then Return Agent_GetAgentInfo($ptr, "ID")
    Next
    Return 0
EndFunc
Func _FT_FindAnyAgentByName($substr)
    Local $arr = Agent_GetAgentArray($GC_I_AGENT_TYPE_LIVING)
    If Not IsArray($arr) Or $arr[0] = 0 Then Return 0
    For $i = 1 To $arr[0]
        Local $ptr = $arr[$i]
        If $ptr = 0 Then ContinueLoop
        If StringInStr(Agent_GetAgentInfo($ptr, "Name"), $substr) Then Return Agent_GetAgentInfo($ptr, "ID")
    Next
    Return 0
EndFunc
Func _FT_TalkMindhebeh($qid, $mx, $my)
    Out("[FT] 6/6 â†’ hablar con Captain Mindhebeh + UpdateQuest")
    _FT_NavFightTo($mx, $my)
    Local $mind = _FT_FindNpcByName("Mindhebeh")
    If $mind = 0 Then $mind = _FT_FindAnyAgentByName("Mindhebeh")
    For $try = 1 To 3
        If $mind <> 0 Then
            Local $px = Agent_GetAgentInfo($mind, "X"), $py = Agent_GetAgentInfo($mind, "Y")
            Out("[FT] Mindhebeh '" & Agent_GetAgentInfo($mind,"Name") & "' en (" & Round($px) & "," & Round($py) & ") try " & $try)
            Map_Move($px, $py, 0)
            Local $tw = TimerInit()
            While TimerDiff($tw) < 12000
                If Sqrt((Agent_GetAgentInfo(-2,"X")-$px)^2+(Agent_GetAgentInfo(-2,"Y")-$py)^2) < 200 Then ExitLoop
                Sleep(400)
            WEnd
            Agent_ChangeTarget($mind)
            Sleep(300)
            Agent_GoNPC($mind)
            Sleep(2500)
        Else
            Out("[FT] Mindhebeh no encontrado (try " & $try & ") â€” dump agentes:")
            _FT_DumpNpcs()
        EndIf
        Out("[FT] Mindhebeh: 'Following the Trail' (0x827F04)")
        Bot_Dialog(0x827F04)
        Sleep(2500)
        Out("[FT] Mindhebeh: 'A bargain' (0x84)")
        Bot_Dialog(0x84)
        Sleep(2500)
        Out("[FT] Mindhebeh: 'We are ready' (0x85)")
        Bot_Dialog(0x85)
        Sleep(3000)
        If Map_GetMapID() <> $TCOD_COD_MAP_ID Then Return True   
        If Quest_GetQuestInfo($qid, "LogState") <= 0 Then Return True
        Local $objAfter = Quest_GetQuestInfo($qid, "Objectives")
        If StringInStr($objAfter, "Nunbe") Then
            Out("[FT] Mindhebeh: objetivo avanzÃ³ a Savage Nunbe â†’ trato cerrado")
            Return True
        EndIf
        $mind = _FT_FindNpcByName("Mindhebeh")
        If $mind = 0 Then $mind = _FT_FindAnyAgentByName("Mindhebeh")
    Next
    Return False
EndFunc
Func _FT_DumpNpcs()
    Local $arr = Agent_GetAgentArray($GC_I_AGENT_TYPE_LIVING)
    If Not IsArray($arr) Or $arr[0] = 0 Then Return
    For $i = 1 To $arr[0]
        Local $ptr = $arr[$i]
        If $ptr = 0 Then ContinueLoop
        Local $alleg = Agent_GetAgentInfo($ptr, "Allegiance")
        If $alleg <> $GC_I_ALLEGIANCE_NPC And $alleg <> $GC_I_ALLEGIANCE_ALLY Then ContinueLoop
        Out("[FT] NPC '" & Agent_GetAgentInfo($ptr,"Name") & "' model=" & Agent_GetAgentInfo($ptr,"PlayerNumber") _
            & " pos=(" & Round(Agent_GetAgentInfo($ptr,"X")) & "," & Round(Agent_GetAgentInfo($ptr,"Y")) & ")")
    Next
EndFunc
Func _FT_SetupPartyTahlkora()
    Out("[FT] SetupParty: Tahlkora+Koss+Dunkoro+Melonni + 3 henchmen BH")
    Local $aHeroes[4] = [$GC_I_HERO_ID_TAHLKORA, $GC_I_HERO_ID_KOSS, $GC_I_HERO_ID_DUNKORO, $GC_I_HERO_ID_MELONNI]
    ReDim $g_aiAutoPartyHeroes[4]
    For $i = 0 To 3
        $g_aiAutoPartyHeroes[$i] = $aHeroes[$i]
    Next
    For $i = 0 To 3
        If _AutoParty_IsHeroInParty($aHeroes[$i]) Then
            Out("[FT] SetupParty: hero " & $aHeroes[$i] & " ya en party â†’ skip")
            ContinueLoop
        EndIf
        Local $pFull = 1 + Party_GetMyPartyInfo("ArrayHeroPartyMemberSize") _
                         + Party_GetMyPartyInfo("ArrayHenchmanPartyMemberSize")
        If $pFull >= 8 Then
            _AutoParty_KickAnyHenchman()
            Sleep(900)
        EndIf
        Out("[FT] SetupParty: Party_AddHero " & $aHeroes[$i])
        Party_AddHero($aHeroes[$i])
        Sleep(1300)
    Next
    Local $heroCount = Party_GetMyPartyInfo("ArrayHeroPartyMemberSize")
    Local $tahlSlot = 0
    For $n = 1 To $heroCount
        If Party_GetMyPartyHeroInfo($n, "HeroID") = $GC_I_HERO_ID_TAHLKORA Then
            $tahlSlot = $n
            ExitLoop
        EndIf
    Next
    If $tahlSlot > 0 Then
        Out("[FT] SetupParty: cargando build Tahlkora (slot " & $tahlSlot & ")")
        Attribute_LoadSkillTemplate($TEAM_TAHLKORA_TEMPLATE, $tahlSlot)
        Sleep(1500)
    Else
        Out("[FT] SetupParty: WARN Tahlkora no encontrada en slots de hero â†’ build no cargada")
    EndIf
    While Not Bot_ShouldStop() And Party_GetMyPartyInfo("ArrayHenchmanPartyMemberSize") > 0
        _AutoParty_KickAnyHenchman()
        Sleep(600)
    WEnd
    Local $aHench[3] = [4600, 4601, 4602]
    For $i = 0 To 2
        If _AutoParty_IsHenchModelInParty($aHench[$i]) Then ContinueLoop
        Local $hAg = Agent_GetAgentByPlayerNumber($aHench[$i])
        If $hAg = 0 Then ContinueLoop
        Local $pFull = 1 + Party_GetMyPartyInfo("ArrayHeroPartyMemberSize") _
                         + Party_GetMyPartyInfo("ArrayHenchmanPartyMemberSize")
        If $pFull >= 8 Then ExitLoop
        Out("[FT] SetupParty: Party_AddNpc henchman model=" & $aHench[$i])
        Party_AddNpc($hAg)
        Sleep(800)
    Next
    Local $pSz = 1 + Party_GetMyPartyInfo("ArrayHeroPartyMemberSize") _
                   + Party_GetMyPartyInfo("ArrayHenchmanPartyMemberSize")
    Out("[FT] SetupParty: FINAL party=" & $pSz & "/8" _
        & " Tahlkora=" & _AutoParty_IsHeroInParty($GC_I_HERO_ID_TAHLKORA) _
        & " Koss=" & _AutoParty_IsHeroInParty($GC_I_HERO_ID_KOSS) _
        & " Dunkoro=" & _AutoParty_IsHeroInParty($GC_I_HERO_ID_DUNKORO) _
        & " Melonni=" & _AutoParty_IsHeroInParty($GC_I_HERO_ID_MELONNI))
EndFunc
Func _FT_AcceptFromJerek($qid, $enquireHex, $acceptHex)
    If Not _BN_EnterPlainsOfJarin() Then Return False
    Local $jerek = _BN_FindJerek()
    If $jerek = 0 Then
        Out("[FT] FAIL: Jerek no encontrado para aceptar")
        Return False
    EndIf
    Local $jx = Agent_GetAgentInfo($jerek, "X"), $jy = Agent_GetAgentInfo($jerek, "Y")
    Map_Move($jx, $jy, 0)
    Local $tNav = TimerInit(), $tRe = TimerInit()
    While Not Bot_ShouldStop() And TimerDiff($tNav) < 20000
        If Sqrt((Agent_GetAgentInfo(-2,"X")-$jx)^2+(Agent_GetAgentInfo(-2,"Y")-$jy)^2) < 300 Then ExitLoop
        If TimerDiff($tRe) >= 2500 Then
            Map_Move($jx, $jy, 0)
            $tRe = TimerInit()
        EndIf
        Sleep(300)
    WEnd
    Out("[FT] Dist a Jerek=" & Round(Sqrt((Agent_GetAgentInfo(-2,"X")-$jx)^2+(Agent_GetAgentInfo(-2,"Y")-$jy)^2)) & "u â†’ aceptar quest 639")
    Agent_ChangeTarget($jerek)
    Sleep(300)
    Agent_GoNPC($jerek)
    Sleep(2000)
    Bot_Dialog($enquireHex)
    Sleep(1500)
    Bot_Dialog($acceptHex)
    Sleep(2000)
    Ui_AboutQuest($qid)
    Sleep(1000)
    Ui_AcceptQuest($qid)
    Sleep(3000)
    Local $ls = Quest_GetQuestInfo($qid, "LogState")
    Out("[FT] Post-accept: ls=" & $ls & " cr=" & Quest_GetQuestInfo($qid,"CanReward") & " mt=" & Quest_GetQuestInfo($qid,"MapTo"))
    Return ($ls > 0)
EndFunc
Func _FT_EnterCliffsOfDohjok()
    Local Const $FT_BH_MAP_ID    = $GC_I_MAP_ID_BEKNUR_HARBOR_2   
    Local Const $FT_BH_PORTAL_X  = -19255
    Local Const $FT_BH_PORTAL_Y  = 14581   
    If Map_GetMapID() = $TCOD_COD_MAP_ID Then Return True
    If Map_GetMapID() <> $FT_BH_MAP_ID Then
        Out("[FT] Travel a Beknur Harbor (" & $FT_BH_MAP_ID & ")")
        If Not Travel_ToOutpost($FT_BH_MAP_ID) Then
            Out("[FT] FAIL travel a Beknur Harbor")
            Return False
        EndIf
    EndIf
    _FT_SetupPartyTahlkora()
    Out("[FT] cruzar portal BHâ†’CoD (" & $FT_BH_PORTAL_X & "," & $FT_BH_PORTAL_Y & ")")
    _TCOD_ForceCrossPortal($FT_BH_PORTAL_X, $FT_BH_PORTAL_Y, $TCOD_COD_MAP_ID, 90000)
    Local $tConfirm = TimerInit()
    While Not Bot_ShouldStop() And TimerDiff($tConfirm) < 15000
        If Map_GetMapID() = $TCOD_COD_MAP_ID Then ExitLoop
        Sleep(500)
    WEnd
    If Map_GetMapID() = $TCOD_COD_MAP_ID Then
        Sleep(2000)
        Pathfinder_SetPathUpdateInterval(2000)
        Cache_SkillBar()
        Out("[FT] nav waypoint BH-entry (12767,-3173)")
        _TCOD_WalkToWaypoint(12767, -3173, 30000, 500)
        Out("[FT] En Cliffs of Dohjok (432)")
        Return True
    EndIf
    Out("[FT] FAIL - no se cruzÃ³ a CoD (map=" & Map_GetMapID() & ")")
    Return False
EndFunc
Func _FT_CoDObjective($qid)
    Local $tStart = TimerInit(), $iter = 0, $map0Count = 0, $zeroCount = 0
        While Not Bot_ShouldStop() And TimerDiff($tStart) < 900000   
        $iter += 1
        Local $m = Map_GetMapID()
        If $m = 0 Then
            $map0Count += 1
            Out("[FT] CoD: map=0 (cargando/desconectado) " & $map0Count & "/6")
            If $map0Count >= 6 Then
                Out("[FT] CoD: ABORT â€” juego no responde 30s (posible crash de GW)")
                Return False
            EndIf
            Sleep(5000)
            ContinueLoop
        EndIf
        $map0Count = 0
        If $m = $GC_I_MAP_ID_BLACKTIDE_DEN_OUTPOST Then
            Out("[FT] CoD: teleport a Blacktide Den (" & $m & ") â†’ Mindhebeh derrotado")
            Return True
        EndIf
        If $m <> $TCOD_COD_MAP_ID Then
            Out("[FT] CoD: mapa inesperado=" & $m & " â†’ abortar")
            Return False
        EndIf
        If Quest_GetQuestInfo($qid, "CanReward") Then
            Out("[FT] CoD: CanReward -> objetivo completado (a cobrar)")
            Return True
        EndIf
        If Quest_GetQuestInfo($qid, "LogState") <= 0 Then
            $zeroCount += 1
            If $zeroCount >= 3 And Not $g_FT_639Seen Then
                Out("[FT] CoD: ls=0 x3 sin haber visto la quest activa -> rancio, FAIL")
                Return False
            EndIf
            If $zeroCount >= 3 Then
                Out("[FT] CoD: ls<=0 x3 -> objetivo completado")
                Return True
            EndIf
            Out("[FT] CoD: ls<=0 (" & $zeroCount & "/3) -> confirmar")
            Sleep(2000)
            ContinueLoop
        EndIf
        $zeroCount = 0
        $g_FT_639Seen = True
        _FT_DumpState($qid, "CoD#" & $iter)
        Local $mx = Quest_GetQuestInfo($qid, "MarkerX")
        Local $my = Quest_GetQuestInfo($qid, "MarkerY")
        Local $objNow = Quest_GetQuestInfo($qid, "Objectives")
        If StringInStr($objNow, "Mindhebeh") Then
            If _FT_TalkMindhebeh($qid, $mx, $my) Then Return True
            Sleep(1500)
            ContinueLoop
        EndIf
        If $mx = 0 And $my = 0 Then
            Combat_ClearZone(1250, 25000)
            Sleep(2000)
            ContinueLoop
        EndIf
        _FT_NavFightTo($mx, $my)
        _FT_PickupGroundItems(2000, True)
        Sleep(500)
        _FT_PickupGroundItems(3000, True)
        Sleep(1500)
    WEnd
    Out("[FT] CoD: TIMEOUT objetivo (ls=" & Quest_GetQuestInfo($qid,"LogState") & ")")
    Return False
EndFunc
Func _FT_RewardNunbe($qid, $rewardHex)
    If Quest_GetQuestInfo($qid, "LogState") > 0 Then $g_FT_639Seen = True
    If Map_GetMapID() <> $GC_I_MAP_ID_BLACKTIDE_DEN_OUTPOST Then
        Out("[FT] Travel a Blacktide Den (" & $GC_I_MAP_ID_BLACKTIDE_DEN_OUTPOST & ") para reward")
        If Not Travel_ToOutpost($GC_I_MAP_ID_BLACKTIDE_DEN_OUTPOST) Then
            Out("[FT] FAIL travel a Blacktide Den")
            Return False
        EndIf
    EndIf
    Sleep(2000)
    _SD_WaitForNPCs(6000)
    Local $nunbe = _FT_FindNpcByName("Nunbe")
    If $nunbe = 0 Then
        Out("[FT] Savage Nunbe no encontrado â€” dump NPCs Blacktide Den:")
        _FT_DumpNpcs()
        Return False
    EndIf
    Local $nx = Agent_GetAgentInfo($nunbe, "X"), $ny = Agent_GetAgentInfo($nunbe, "Y")
    Out("[FT] Savage Nunbe en (" & Round($nx) & "," & Round($ny) & ") â†’ navegar")
    Map_Move($nx, $ny, 0)
    Local $tNav = TimerInit(), $tRe = TimerInit()
    While Not Bot_ShouldStop() And TimerDiff($tNav) < 20000
        If Sqrt((Agent_GetAgentInfo(-2,"X")-$nx)^2+(Agent_GetAgentInfo(-2,"Y")-$ny)^2) < 250 Then ExitLoop
        If TimerDiff($tRe) >= 2500 Then
            Map_Move($nx, $ny, 0)
            $tRe = TimerInit()
        EndIf
        Sleep(300)
    WEnd
    Agent_ChangeTarget($nunbe)
    Sleep(300)
    Agent_GoNPC($nunbe)
    Sleep(2500)
    Ui_RewardQuest($qid)
    Sleep(5000)
    If Quest_GetQuestInfo($qid, "LogState") <= 0 And $g_FT_639Seen Then Return True
    Agent_GoNPC($nunbe)
    Sleep(1500)
    Bot_Dialog(0x84)
    Sleep(1000)
    Bot_Dialog($rewardHex)
    Sleep(5000)
    Out("[FT] Reward Nunbe â†’ ls=" & Quest_GetQuestInfo($qid,"LogState"))
    Return (Quest_GetQuestInfo($qid, "LogState") <= 0 And $g_FT_639Seen)
EndFunc
Func Quest_FollowingTheTrail_Run()
    Local Const $QID = 639
    Local Const $FT_REWARD_HEX  = 0x827F07   
    Local Const $FT_ENQUIRE_HEX = 0x827F03   
    Local Const $FT_ACCEPT_HEX  = 0x827F01   
    Local $ls = Quest_GetQuestInfo($QID, "LogState")
    Local $cr = Quest_GetQuestInfo($QID, "CanReward")
    Local $mt = Quest_GetQuestInfo($QID, "MapTo")
    If $ls > 0 Then $g_FT_639Seen = True
    Out("[FT] === START: ls=" & $ls & " cr=" & $cr & " mt=" & $mt & " map=" & Map_GetMapID() & " ===")
    If $ls <= 0 Then
        If Not _FT_AcceptFromJerek($QID, $FT_ENQUIRE_HEX, $FT_ACCEPT_HEX) Then
            Out("[FT] FAIL: quest 639 no aceptada")
            Return False
        EndIf
    EndIf
    If Quest_GetQuestInfo($QID, "LogState") > 0 Then
        $g_FT_639Seen = True
        If Not _FT_EnterCliffsOfDohjok() Then Return False
        If Not _FT_CoDObjective($QID) Then Return False
    EndIf
    If Quest_GetQuestInfo($QID, "CanReward") Then
        Out("[FT] CanReward -> cobrar con Nunbe")
    ElseIf Quest_GetQuestInfo($QID, "LogState") <= 0 And $g_FT_639Seen Then
        Out("[FT] Quest 639 ya fuera del log (vista activa antes) -> completada")
        Return True
    ElseIf Quest_GetQuestInfo($QID, "LogState") <= 0 Then
        Out("[FT] Quest 639 ls=0 sin haberla visto activa -> rancio, FAIL")
        Return False
    EndIf
    If Not _FT_RewardNunbe($QID, $FT_REWARD_HEX) Then
        Out("[FT] FAIL: reward de Savage Nunbe no completÃ³ (ls=" & Quest_GetQuestInfo($QID,"LogState") & ")")
        Return False
    EndIf
    Out("[FT] Quest 639 COMPLETADA (ls=" & Quest_GetQuestInfo($QID,"LogState") & ")")
    Return True
EndFunc