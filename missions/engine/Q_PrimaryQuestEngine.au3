#include-once
Func _NF_FindQuestIdByName($substr)
    Local $size = World_GetWorldInfo("QuestLogSize")
    If $size = 0 Then Return 0
    For $i = 0 To $size
        Local $off[5] = [0, 0x18, 0x2C, 0x52C, 0x34 * $i]
        Local $q = Memory_ReadPtr($g_p_BasePointer, $off, "long")
        If Not IsArray($q) Then ContinueLoop
        Local $qid = $q[1]
        If $qid = 0 Then ContinueLoop
        Local $name = Quest_GetQuestInfo($qid, "Name")
        If $name <> "" And $name <> 0 And StringInStr($name, $substr) Then Return $qid
    Next
    Return 0
EndFunc
Func _NF_GetActiveQuestId()
    Local $size = World_GetWorldInfo("QuestLogSize")
    If $size = 0 Then Return 0
    For $i = 0 To $size
        Local $off[5] = [0, 0x18, 0x2C, 0x52C, 0x34 * $i]
        Local $q = Memory_ReadPtr($g_p_BasePointer, $off, "long")
        If Not IsArray($q) Then ContinueLoop
        Local $qid = $q[1]
        If $qid = 0 Then ContinueLoop
        If Quest_GetQuestInfo($qid, "IsCurrentQuest") Then Return $qid
    Next
    For $i = 0 To $size
        Local $off2[5] = [0, 0x18, 0x2C, 0x52C, 0x34 * $i]
        Local $q2 = Memory_ReadPtr($g_p_BasePointer, $off2, "long")
        If Not IsArray($q2) Then ContinueLoop
        Local $qid2 = $q2[1]
        If $qid2 = 0 Then ContinueLoop
        If Not Quest_GetQuestInfo($qid2, "IsCompleted") Then Return $qid2
    Next
    Return 0
EndFunc
Func _NF_FindNpcByName($substr)
    Local $ags = Agent_GetAgentArray($GC_I_AGENT_TYPE_LIVING)
    If Not IsArray($ags) Then Return 0
    For $i = 0 To UBound($ags) - 1
        Local $p = $ags[$i]
        If $p = 0 Then ContinueLoop
        If Agent_GetAgentInfo($p, "IsPlayer") Then ContinueLoop
        If StringInStr(Agent_GetAgentInfo($p, "Name"), $substr) Then Return $p
    Next
    Return 0
EndFunc
Func _NF_GoTalkNpcByName($substr, $maxMs = 90000)
    Local $t = TimerInit()
    While Not Bot_ShouldStop() And TimerDiff($t) < $maxMs
        If Map_GetInstanceInfo("IsLoading") Then
            Sleep(800)
            ContinueLoop
        EndIf
        Local $npc = _NF_FindNpcByName($substr)
        If $npc = 0 Then
            Out("[NFQ] NPC '" & $substr & "' no visible aún")
            Return False
        EndIf
        Local $nx = Agent_GetAgentInfo($npc, "X"), $ny = Agent_GetAgentInfo($npc, "Y")
        Local $cx = Agent_GetAgentInfo(-2, "X"), $cy = Agent_GetAgentInfo(-2, "Y")
        Local $d = Sqrt(($cx-$nx)^2 + ($cy-$ny)^2)
        If $d < 250 Then
            Agent_ChangeTarget($npc)
            Sleep(200)
            Agent_GoNPC($npc)
            Sleep(2500)
            Out("[NFQ] Hablado con '" & $substr & "'")
            Return True
        EndIf
        If Map_GetInstanceInfo("Type") = $GC_I_MAP_TYPE_OUTPOST Then
            Map_Move($nx, $ny, 0)
            Sleep(1200)
        Else
            _Mission_DoNavCombat($nx, $ny)
        EndIf
    WEnd
    Return False
EndFunc
Func _NF_FollowQuestToReward($qid, $shortName = "", $globalTimeoutMs = 1800000, $trustCanReward = True, $combatFirst = False, $talkNpcModel = 0, $allowTravel = True)
    Local $tGlobal = TimerInit()
    Local $lastMarker = ""
    Local $sameMarkerTalks = 0
    Local $tLastDialog = 0
    While TimerDiff($tGlobal) < $globalTimeoutMs
        If Bot_ShouldStop() Then Return False
        If Map_GetInstanceInfo("IsLoading") Then
            Sleep(500)
            ContinueLoop
        EndIf
        Cinematic_ProtectStep()
        Local $st = Quest_GetQuestInfo($qid, "LogState")
        Local $base = BitAND($st, 0x0F)
        Local $cr = Quest_GetQuestInfo($qid, "CanReward")
        If $base = 2 Or $base = 3 Then
            Out("[NFQ] Quest " & $qid & " lista para recompensa (base=" & $base & " state=0x" & Hex($st, 2) & ")")
            Return True
        EndIf
        Local $mtCR = Quest_GetQuestInfo($qid, "MapTo")
        If $trustCanReward And $cr And ($mtCR = 0 Or $mtCR = Map_GetMapID()) Then
            Out("[NFQ] Quest " & $qid & " lista para recompensa (cr=True mt=" & $mtCR & " mapa=" & Map_GetMapID() & ")")
            Return True
        EndIf
        Local $mx = Quest_GetQuestInfo($qid, "MarkerX")
        Local $my = Quest_GetQuestInfo($qid, "MarkerY")
        If Abs($mx) > 2e9 Or Abs($my) > 2e9 Then
            Out("[NFQ] Marcador invalido (" & $mx & "," & $my & ") -> quest aun asentando, re-evaluar")
            Sleep(1000)
            ContinueLoop
        EndIf
        If ($mx = 0 And $my = 0) Or $mx = -1 Then
            Sleep(1000)
            Continueloop
        EndIf
        Local $sig = Round($mx) & "," & Round($my) & "@" & Map_GetMapID()
        Out("[NFQ] Marcador quest " & $qid & " -> (" & Round($mx) & "," & Round($my) & ") map=" & Map_GetMapID())
        Local $mt = Quest_GetQuestInfo($qid, "MapTo")
        If $mt > 0 And $mt <= 1000 And $mt <> Map_GetMapID() And Map_GetInstanceInfo("Type") = $GC_I_MAP_TYPE_OUTPOST Then
            If Not $allowTravel Then
                Static $tLastCrossNFQ = 0
                If Map_GetMapID() = 403 Then
                    Out("[NFQ] en Honur (403) sin travels -> volver a Sunspear 387")
                    Map_TravelTo(387)
                    Map_WaitMapLoading(387, $GC_I_MAP_TYPE_OUTPOST, 60000)
                    Sleep(2000)
                    ContinueLoop
                EndIf
                If TimerDiff($tLastCrossNFQ) > 60000 Then
                    $tLastCrossNFQ = TimerInit()
                    Local $toTypeNFQ = $GC_I_MAP_TYPE_EXPLORABLE
                    If Map_IsOutpost($mt) Then $toTypeNFQ = $GC_I_MAP_TYPE_OUTPOST
                    Out("[NFQ] sin travels: cruce a pie " & Map_GetMapID() & "->" & $mt)
                    Travel_CrossPortal(Map_GetMapID(), $mt, $toTypeNFQ)
                    Sleep(3000)
                Else
                    Sleep(2000)
                EndIf
                ContinueLoop
            EndIf
            Out("[NFQ] MapTo=" & $mt & " != mapa actual -> intentar Map_TravelTo directo")
            Local $mapAntes = Map_GetMapID()
            Map_TravelTo($mt)
            Local $tWait = TimerInit()
            While TimerDiff($tWait) < 10000
                If Map_GetMapID() <> $mapAntes Or Map_GetInstanceInfo("IsLoading") Then ExitLoop
                Sleep(500)
            WEnd
            If Map_GetMapID() <> $mapAntes Or Map_GetInstanceInfo("IsLoading") Then
                Map_WaitMapLoading($mt, $GC_I_MAP_TYPE_OUTPOST, 40000)
                Sleep(500)
                If $shortName <> "" Then
                    Local $pSzNow = 1 + Party_GetMyPartyInfo("ArrayHeroPartyMemberSize") + Party_GetMyPartyInfo("ArrayHenchmanPartyMemberSize")
                    If $pSzNow <= 1 Then _NF_SetupParty($shortName)
                EndIf
                ContinueLoop
            Else
                Out("[NFQ] Map_TravelTo(" & $mt & ") fallido; intentar outpost adyacente 403 (Honur Hill)")
                Local $mapAntes2 = Map_GetMapID()
                Map_TravelTo(403)
                Local $tWait2 = TimerInit()
                While TimerDiff($tWait2) < 10000
                    If Map_GetMapID() <> $mapAntes2 Or Map_GetInstanceInfo("IsLoading") Then ExitLoop
                    Sleep(500)
                WEnd
                Map_WaitMapLoading(403, $GC_I_MAP_TYPE_OUTPOST, 40000)
                Sleep(500)
                If Map_GetMapID() = 403 Then
                    If $shortName <> "" Then
                        Local $pSzAdj = 1 + Party_GetMyPartyInfo("ArrayHeroPartyMemberSize") + Party_GetMyPartyInfo("ArrayHenchmanPartyMemberSize")
                        If $pSzAdj <= 1 Then _NF_SetupParty($shortName)
                    EndIf
                    Out("[NFQ] En 403; re-intentar Map_TravelTo(" & $mt & ") desde aquí")
                    Local $mapAntes3 = Map_GetMapID()
                    Map_TravelTo($mt)
                    Local $tWait3 = TimerInit()
                    While TimerDiff($tWait3) < 10000
                        If Map_GetMapID() <> $mapAntes3 Or Map_GetInstanceInfo("IsLoading") Then ExitLoop
                        Sleep(500)
                    WEnd
                    If Map_GetMapID() <> $mapAntes3 Or Map_GetInstanceInfo("IsLoading") Then
                        Map_WaitMapLoading($mt, $GC_I_MAP_TYPE_OUTPOST, 40000)
                        Sleep(2000)
                        If $shortName <> "" Then
                            Local $pSzAdj2 = 1 + Party_GetMyPartyInfo("ArrayHeroPartyMemberSize") + Party_GetMyPartyInfo("ArrayHenchmanPartyMemberSize")
                            If $pSzAdj2 <= 1 Then _NF_SetupParty($shortName)
                        EndIf
                        ContinueLoop  
                    EndIf
                    Out("[NFQ] En Honur Hill (403); fast-travel a mt=" & $mt & " falló")
                    If $mt > 0 And $mt <> 403 Then
                        Out("[NFQ] mt=" & $mt & " no accesible desde 403 -> Return False")
                        Return False
                    EndIf
                    $mx = Quest_GetQuestInfo($qid, "MarkerX")
                    $my = Quest_GetQuestInfo($qid, "MarkerY")
                EndIf
            EndIf
        EndIf
        If $combatFirst Then
            Local $cfDc = Sqrt(($mx - Agent_GetAgentInfo(-2, "X")) ^ 2 + ($my - Agent_GetAgentInfo(-2, "Y")) ^ 2)
            Local $cfNear = GetNearestEnemy(4000)
            If $cfNear <> 0 Then
                Combat_ClearZone(5000, 20000)
            Else
                Local $cfFar = GetNearestEnemy(10000)
                If $cfFar <> 0 Then
                    Local $efX = Agent_GetAgentInfo($cfFar, "X")
                    Local $efY = Agent_GetAgentInfo($cfFar, "Y")
                    If $efX <> 0 And $efY <> 0 Then
                        Out("[NFQ] Enemigo lejano detectado (" & Round(Sqrt(($efX - Agent_GetAgentInfo(-2, "X"))^2 + ($efY - Agent_GetAgentInfo(-2, "Y"))^2)) & "u) -> ir a por él")
                        Local $cfPf = $g_iPathfinder_MovementTimeout
                        $g_iPathfinder_MovementTimeout = 15000
                        MoveToFollowPath($efX, $efY, 0)
                        $g_iPathfinder_MovementTimeout = $cfPf
                        Sleep(1000)
                        Combat_ClearZone(5000, 20000)
                    EndIf
                ElseIf $cfDc > 5000 Then
                    Local $cfPf2 = $g_iPathfinder_MovementTimeout
                    $g_iPathfinder_MovementTimeout = 8000
                    MoveToFollowPath($mx, $my, 0)
                    $g_iPathfinder_MovementTimeout = $cfPf2
                ElseIf $cfDc > 250 Then
                    Local $cfPf3 = $g_iPathfinder_MovementTimeout
                    $g_iPathfinder_MovementTimeout = 20000
                    MoveToFollowPath($mx, $my, 350)
                    $g_iPathfinder_MovementTimeout = $cfPf3
                Else
                    Sleep(400)  
                EndIf
            EndIf
        Else
            _Mission_DoNavCombat($mx, $my)
        EndIf
        Local $tWaitCombat = TimerInit()
        While GetNearestEnemy(1500) <> 0 And TimerDiff($tWaitCombat) < 8000
            Sleep(1000)
        WEnd
        Local $aakSkipTalk = ($combatFirst And GetNearestEnemy(2200) <> 0)
        Local $near = 0
        If $talkNpcModel > 0 Then $near = _PMP_FindAllyByModel($talkNpcModel)
        If $near = 0 Then $near = _NF_FindNpcNearest($mx, $my, 600)
        If $near <> 0 And Not $aakSkipTalk Then
            Agent_ChangeTarget($near)
            Sleep(200)
            Agent_GoNPC($near)
            Sleep(1000)
            If TimerDiff($tLastDialog) > 20000 Then
                Bot_Dialog(0x85)  
                Sleep(800)
                Local $stepDialog = "0x008" & Hex($qid, 3) & "04"
                Bot_Dialog($stepDialog)
                Out("[NFQ] Dialog paso -> dismiss + " & $stepDialog)
                $tLastDialog = TimerInit()
            EndIf
            Sleep(3000)
        EndIf
        If $sig = $lastMarker Then
            $sameMarkerTalks += 1
            If $sameMarkerTalks = 5 Then
                Local $d05 = "0x008" & Hex($qid, 3) & "05"
                Bot_Dialog($d05)
                Out("[NFQ] Dialog alternativo -> " & $d05)
                Sleep(1000)
            ElseIf $sameMarkerTalks = 8 Then
                Local $d06 = "0x008" & Hex($qid, 3) & "06"
                Bot_Dialog($d06)
                Out("[NFQ] Dialog alternativo -> " & $d06)
                Sleep(1000)
            ElseIf $sameMarkerTalks = 10 Then
                Out("[NFQ] Marcador estancado; esperando combate o evento")
                Sleep(4000)
                $sameMarkerTalks = 0
            EndIf
        Else
            $sameMarkerTalks = 0
            $lastMarker = $sig
        EndIf
        Sleep(1000)
    WEnd
    Out("[NFQ] TIMEOUT siguiendo quest " & $qid)
    Return False
EndFunc
Func _NF_SetupParty($shortName, $targetMap = 0)
    _NF_BuildPartyHere($shortName)
    If $targetMap > 0 And Map_GetMapID() <> $targetMap Then
        If Map_IsMapUnlocked($targetMap) Then
            Out("[NFQ] SetupParty: viajar al outpost de party " & $targetMap)
            Map_TravelTo($targetMap)
            Map_WaitMapLoading($targetMap, $GC_I_MAP_TYPE_OUTPOST, 60000)
            Sleep(3000)
        Else
            Out("[NFQ] SetupParty: outpost " & $targetMap & " NO desbloqueado -> ir ANDANDO directo (sin esperar TravelTo)")
        EndIf
        If Map_GetMapID() <> $targetMap Then
            Out("[NFQ] SetupParty: ir ANDANDO a " & $targetMap & " (con party montado)")
            Travel_WalkToLockedOutpost($targetMap, True)
            Map_WaitMapLoading($targetMap, $GC_I_MAP_TYPE_OUTPOST, 120000)
            Sleep(3000)
        EndIf
        _NF_BuildPartyHere($shortName)
    EndIf
    Local $pfSize = 1 + Party_GetMyPartyInfo("ArrayHeroPartyMemberSize") + Party_GetMyPartyInfo("ArrayHenchmanPartyMemberSize")
    Out("[NFQ] Party lista: " & $pfSize & " miembros")
EndFunc
Func _NF_BuildPartyHere($shortName)
    Local $tReady = TimerInit()
    While TimerDiff($tReady) < 20000 And Not Bot_ShouldStop()
        If Map_GetInstanceInfo("IsLoading") Then
            Sleep(500)
            ContinueLoop
        EndIf
        If Agent_GetAgentInfo(-2, "MaxHP") <= 0 Then
            Sleep(500)
            ContinueLoop
        EndIf
        If Agent_GetAgentInfo(-2, "X") = 0 And Agent_GetAgentInfo(-2, "Y") = 0 Then
            Sleep(500)
            ContinueLoop
        EndIf
        ExitLoop
    WEnd
    If Agent_GetAgentInfo(-2, "MaxHP") <= 0 Or (Agent_GetAgentInfo(-2, "X") = 0 And Agent_GetAgentInfo(-2, "Y") = 0) Then
        Out("[NFQ] BuildParty SKIP: char aun sin cargar tras 20s (MaxHP=" & Agent_GetAgentInfo(-2, "MaxHP") & ") -> no montar party (evita crash GW)")
        Return
    EndIf
    Out("[NFQ] Montar party para '" & $shortName & "' en outpost " & Map_GetMapID())
    Heroes_SetupForMission($shortName)
    Sleep(500)
    Local $mhenloAdded = False
    Local $hAgs = Agent_GetAgentArray($GC_I_AGENT_TYPE_LIVING)
    If IsArray($hAgs) Then
        For $k = 0 To UBound($hAgs) - 1
            If $hAgs[$k] = 0 Then ContinueLoop
            If Agent_GetAgentInfo($hAgs[$k], "IsPlayer") Then ContinueLoop
            If StringInStr(Agent_GetAgentInfo($hAgs[$k], "Name"), "Mhenlo") Then
                Local $mhId = Agent_GetAgentInfo($hAgs[$k], "ID")
                Party_AddNpc($mhId)
                Out("[NFQ] Mhenlo añadido (agentID=" & $mhId & ")")
                $mhenloAdded = True
                Sleep(500)
                ExitLoop
            EndIf
        Next
    EndIf
    If Not $mhenloAdded Then
        Out("[NFQ] Mhenlo no encontrado en outpost " & Map_GetMapID() & "; sin henchman monje aquí")
    EndIf
    Party_FillWithHenchmen()
    Sleep(500)
    If _AutoParty_IsHeroInParty($GC_I_HERO_ID_MASTER_OF_WHISPERS) Then
        _Team_LoadHeroBuild($GC_I_HERO_ID_MASTER_OF_WHISPERS, $TEAM_MASTER_OF_WHISPERS_TEMPLATE, "MasterOfWhispers", $g_aiMoWAttrs)
        Out("[NFQ] Build BIP cargada a Master of Whispers")
    EndIf
EndFunc
Func _NF_FindNpcNearest($x, $y, $maxDist = 600)
    Local $best = 0, $bestD = $maxDist
    Local $ags = Agent_GetAgentArray($GC_I_AGENT_TYPE_LIVING)
    If Not IsArray($ags) Then Return 0
    For $i = 0 To UBound($ags) - 1
        Local $p = $ags[$i]
        If $p = 0 Then ContinueLoop
        If Agent_GetAgentInfo($p, "IsPlayer") Then ContinueLoop
        Local $al = Agent_GetAgentInfo($p, "Allegiance")
        If $al <> $GC_I_ALLEGIANCE_NPC And $al <> $GC_I_ALLEGIANCE_ALLY Then ContinueLoop
        Local $d = Sqrt((Agent_GetAgentInfo($p,"X")-$x)^2 + (Agent_GetAgentInfo($p,"Y")-$y)^2)
        If $d < $bestD Then
            $bestD = $d
            $best = $p
        EndIf
    Next
    Return $best
EndFunc
Func _NF_RunPrimaryQuest($shortName, $giverMap, $questSub, $giverSub, $rewardMap, $rewardSub, $knownQid = 0, $partyMap = 0, $trustCanReward = True, $combatFirst = False)
    Out("[NFQ] ===== " & $shortName & " (motor genérico) =====")
    If Map_GetMapID() <> $giverMap Then
        Out("[NFQ] Travel al outpost del giver (" & $giverMap & ")")
        Map_TravelTo($giverMap)
        Map_WaitMapLoading($giverMap, $GC_I_MAP_TYPE_OUTPOST, 60000)
        Sleep(1000)
    EndIf
    Local $effectivePartyMap = $giverMap
    If $partyMap > 0 And $partyMap <> $giverMap Then
        $effectivePartyMap = $partyMap
    EndIf
    _NF_GoTalkNpcByName($giverSub, 60000)
    Sleep(500)
    Local $qid = $knownQid
    If $qid = 0 Then $qid = _NF_FindQuestIdByName($questSub)
    If $qid <> 0 Then
        Out("[NFQ] Quest '" & $questSub & "' = qid " & $qid & " (0x" & Hex($qid, 3) & ") -> aceptar")
        Quest_AcceptQuest($qid)
        Sleep(500)
        If Quest_GetQuestInfo($qid, "LogState") <= 0 Then
            Local $takeDlg = BitOR(0x800000, BitShift($qid, -8), 0x01)  
            Out("[NFQ] q" & $qid & " NO entró al log -> take-dialog 0x" & Hex($takeDlg, 5) & " con '" & $giverSub & "'")
            For $tk = 1 To 3
                If Quest_GetQuestInfo($qid, "LogState") > 0 Then ExitLoop
                _NF_GoTalkNpcByName($giverSub, 30000)
                Sleep(1000)
                Bot_Dialog($takeDlg)
                Sleep(2200)
            Next
            Out("[NFQ] q" & $qid & " LogState tras take-dialog = " & Quest_GetQuestInfo($qid, "LogState"))
            If Quest_GetQuestInfo($qid, "LogState") <= 0 Then
                Out("[NFQ] " & $shortName & ": no se pudo aceptar q" & $qid & " (ni Quest_AcceptQuest ni take-dialog). ABORT (capturar take-dialog real con toolbox).")
                Return False
            EndIf
        EndIf
    Else
        Out("[NFQ] " & $shortName & ": quest '" & $questSub & "' no localizada por nombre; leyendo quest ACTIVA del log")
        $qid = _NF_GetActiveQuestId()
        If $qid = 0 Then
            Out("[NFQ] " & $shortName & ": no hay quest activa en el log. Coge la quest a mano (hablar con " & $giverSub & ") y reactiva. ABORT SEGURO (sin brute-force).")
            Return False
        EndIf
        Out("[NFQ] Quest activa detectada en el log = qid " & $qid & " (" & Quest_GetQuestInfo($qid, "Name") & ")")
    EndIf
    Quest_ActiveQuest($qid)
    Sleep(500)
    _NF_SetupParty($shortName, $effectivePartyMap)
    If Not _NF_FollowQuestToReward($qid, $shortName, 1800000, $trustCanReward, $combatFirst) Then
        Out("[NFQ] " & $shortName & ": no se llegó al estado de recompensa")
        If Map_GetInstanceInfo("IsExplorable") Then
            Out("[NFQ] Char en explorable tras fallo; viajando a giverMap (" & $giverMap & ") para no quedar perdido")
            Map_TravelTo($giverMap)
            Map_WaitMapLoading($giverMap, $GC_I_MAP_TYPE_OUTPOST, 90000)
        EndIf
        Return False
    EndIf
    If Map_GetMapID() <> $rewardMap Then
        Out("[NFQ] Travel al outpost de recompensa (" & $rewardMap & ")")
        Map_TravelTo($rewardMap)
        Map_WaitMapLoading($rewardMap, $GC_I_MAP_TYPE_OUTPOST, 60000)
        Sleep(3000)
    EndIf
    If Map_GetMapID() <> $rewardMap Then
        Out("[NFQ] Map_TravelTo(" & $rewardMap & ") no llegó (bloqueado) -> ir ANDANDO a " & $rewardMap & " (Travel_WalkToLockedOutpost)")
        Travel_WalkToLockedOutpost($rewardMap, True)
        Map_WaitMapLoading($rewardMap, $GC_I_MAP_TYPE_OUTPOST, 120000)
        Sleep(3000)
    EndIf
    If Map_GetMapID() <> $rewardMap Then
        Out("[NFQ] " & $shortName & ": NO se llegó al outpost de recompensa (" & $rewardMap & "); sigo en " & Map_GetMapID() & ". NO se cobra a ciegas. ABORT.")
        Return False
    EndIf
    If Not _NF_GoTalkNpcByName($rewardSub, 60000) Then
        Out("[NFQ] " & $shortName & ": NPC de recompensa '" & $rewardSub & "' no localizado en " & $rewardMap & ". ABORT (sin cobrar a ciegas).")
        Return False
    EndIf
    Sleep(1000)
    Quest_QuestReward($qid)
    Sleep(2500)
    Local $stAfter = Quest_GetQuestInfo($qid, "LogState")
    If $stAfter <= 0 Or $stAfter >= 0xFF Then
        Out("[NFQ] " & $shortName & ": quest fuera del log tras reward (state=" & $stAfter & ", cr=" & Quest_GetQuestInfo($qid, "CanReward") & ") -> COBRADA. Done.")
        Return True
    EndIf
    Local $baseAfter = BitAND($stAfter, 0x0F)
    Local $crAfter = Quest_GetQuestInfo($qid, "CanReward")
    If ($baseAfter = 2 Or $baseAfter = 3 Or $crAfter) Then
        Out("[NFQ] " & $shortName & ": Quest_QuestReward NO aplicó (sigue lista para reward, state=0x" & Hex($stAfter, 2) & " cr=" & $crAfter & "). ABORT.")
        Return False
    EndIf
    Out("[NFQ] " & $shortName & ": recompensa cobrada y verificada. Done.")
    Return True
EndFunc