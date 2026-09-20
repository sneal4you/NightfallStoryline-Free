#include-once
Func Travel_FilterNPCs()
    Return Agent_GetAgentsAsObstacles(1200, 85, "_Travel_AgentFilter_NPCsAndGadgets")
EndFunc
Func _Travel_AgentFilter_NPCsAndGadgets($aAgentPtr)
    If Agent_GetAgentInfo($aAgentPtr, "IsGadgetType") Then Return True
    If Agent_GetAgentInfo($aAgentPtr, "IsLivingType") Then
        Local $alleg = Agent_GetAgentInfo($aAgentPtr, "Allegiance")
        If $alleg = $GC_I_ALLEGIANCE_NPC Or $alleg = $GC_I_ALLEGIANCE_ENEMY Then Return True
    EndIf
    Return False
EndFunc
Func Travel_ToOutpost($mapId, $forceWalk = False)
    If Map_GetMapID() = $mapId Then
        Out("[Travel] Already at " & $mapId)
        Return True
    EndIf
    If Not $forceWalk Then
        $forceWalk = (Int(IniRead(@ScriptDir & "\config.ini", "Debug", "ForceWalkThrough", "0")) <> 0)
    EndIf
    If Not $forceWalk And Map_IsMapUnlocked($mapId) And Map_IsOutpost($mapId) Then
        Out("[Travel] Direct travel to unlocked " & $mapId)
        Map_RndTravel($mapId, False)
        Map_WaitMapLoading($mapId, $GC_I_MAP_TYPE_OUTPOST, 90000)
        If Map_GetMapID() = $mapId Then Return True
        Local $curMap = Map_GetMapID()
        Out("[Travel] Direct a " & $mapId & " ignorado desde " & $curMap & " -> re-instanciar origen y reintentar")
        Map_RndTravel($curMap, False)
        Map_WaitMapLoading($curMap, $GC_I_MAP_TYPE_OUTPOST, 90000)
        Sleep(3000)
        Map_RndTravel($mapId, False)
        Map_WaitMapLoading($mapId, $GC_I_MAP_TYPE_OUTPOST, 90000)
        Return (Map_GetMapID() = $mapId)
    EndIf
    If $forceWalk Then
        Out("[Travel] forceWalk=True, walk-through aunque outpost este desbloqueado")
    EndIf
    Return Travel_WalkToLockedOutpost($mapId, $forceWalk)
EndFunc
Func Travel_ToMissionOutpost($missionName)
    Local $outpostId = _Travel_GetMissionOutpost($missionName)
    If $outpostId = 0 Then
        Out("[Travel] No outpost ID known for mission " & $missionName)
        Return False
    EndIf
    Return Travel_ToOutpost($outpostId)
EndFunc
Func Travel_CrossPortal($fromMapId, $toMapId, $toMapType = $GC_I_MAP_TYPE_EXPLORABLE)
    Local $portal = Map_GetExitPortalsCoords($fromMapId, $toMapId)
    If Not IsArray($portal) Then
        Out("[Travel] No portal coords from " & $fromMapId & " to " & $toMapId)
        Return False
    EndIf
    Out("[Travel] Crossing portal to " & $toMapId & " at (" & $portal[0] & ", " & $portal[1] & ")")
    Local $cx = Agent_GetAgentInfo(-2, "X"), $cy = Agent_GetAgentInfo(-2, "Y")
    Local $dPortal = Sqrt(($cx - $portal[0])^2 + ($cy - $portal[1])^2)
    Map_Move($portal[0], $portal[1], 0)
    Local $tWait = TimerInit()
    While Not Bot_ShouldStop() And TimerDiff($tWait) < 15000
        If Map_GetMapID() = $toMapId Or Map_GetInstanceInfo("IsLoading") Then Return True
        Sleep(500)
    WEnd
    Local $cx2 = Agent_GetAgentInfo(-2, "X"), $cy2 = Agent_GetAgentInfo(-2, "Y")
    Local $dPortal2 = Sqrt(($cx2 - $portal[0])^2 + ($cy2 - $portal[1])^2)
    If $dPortal2 > 500 Then
        Out("[Travel] Map_Move no llegó al portal (dist=" & Round($dPortal2) & "u), fallback MoveToFollowPath")
        MoveToFollowPath($portal[0], $portal[1], 0)
    Else
        Out("[Travel] Cerca del portal (dist=" & Round($dPortal2) & "u) pero sin cruzar, esperando...")
    EndIf
    Map_WaitMapLoading($toMapId, $toMapType, 90000)
    Return (Map_GetMapID() = $toMapId)
EndFunc
Func Travel_WalkToLockedOutpost($targetOutpostId, $forceWalk = False)
    Local $currentMap = Map_GetMapID()
    If Not $forceWalk Then
        $forceWalk = (Int(IniRead(@ScriptDir & "\config.ini", "Debug", "ForceWalkThrough", "0")) <> 0)
    EndIf
    Local $path
    Local $startOutpost = $currentMap
    If $forceWalk Then
        $path = Map_GetPathWithPortalCoords($currentMap, $targetOutpostId)
        If Not IsArray($path) Or UBound($path) = 0 Then
            Out("[Travel] ForceWalk: no path desde " & $currentMap & " a " & $targetOutpostId)
            Return False
        EndIf
        Out("[Travel] ForceWalk path desde " & $currentMap & " a " & $targetOutpostId & " con " & UBound($path) & " steps")
    Else
        Local $unlockPath = Map_GetPathToUnlockCity($targetOutpostId)
        If $unlockPath[0] = 0 Then
            Out("[Travel] No path found to " & $targetOutpostId)
            Return False
        EndIf
        $path = $unlockPath[1]
        $startOutpost = $unlockPath[0]
    EndIf
    Local $startIndex = 0
    Local $alreadyOnPath = False
    For $i = 0 To UBound($path) - 1
        If $path[$i][0] = $currentMap Then
            $startIndex = $i
            $alreadyOnPath = True
            ExitLoop
        EndIf
    Next
    If Not $alreadyOnPath And $currentMap <> $startOutpost Then
        If Map_IsOutpost($startOutpost) Then
            Out("[Travel] Walk-through: starting from " & $startOutpost)
            Map_RndTravel($startOutpost, False)
            Map_WaitMapLoading($startOutpost, $GC_I_MAP_TYPE_OUTPOST, 90000)
        EndIf
    EndIf
    Local $questHint = _Travel_GetQuestHintForTarget($targetOutpostId)
    For $i = $startIndex To UBound($path) - 2
        Local $wpX = $path[$i][2]
        Local $wpY = $path[$i][3]
        Local $oldMap = Map_GetMapID()
        Out("[Travel] Walk step " & ($i + 1) & "/" & (UBound($path) - 1) & " from map=" & $oldMap & " -> " & $path[$i+1][1] & " portal=(" & Round($wpX, 0) & ", " & Round($wpY, 0) & ")")
        Local $hintStaticModel = 0
        If $questHint > 0 Then
            Local $candidate = _Travel_GetFerrymanModelForMap(Map_GetMapID(), $questHint)
            If $candidate <> 0 And _Travel_IsStaticGateFerryman($candidate) Then
                $hintStaticModel = $candidate
            EndIf
        EndIf
        If $hintStaticModel <> 0 Then
            Local $hintCoords = _Travel_GetFerrymanCoordsForMap(Map_GetMapID(), $questHint)
            Out("[Travel] Ferryman estático esperado model=" & $hintStaticModel & " coords=(" & $hintCoords[0] & ", " & $hintCoords[1] & ") -> navegar para cargar agent")
            Pathfinder_MoveTo($hintCoords[0], $hintCoords[1], -1, "FilterObstacle", 0, 15000, $g_i_FinisherMode, "")
            If Party_GetPartyContextInfo("IsDefeated") Then
                Out("[Travel] Party defeated, return to outpost")
                Map_ReturnToOutpost(False)
                Return False
            EndIf
            Sleep(500)
            Local $npc = Agent_GetAgentByPlayerNumber($hintStaticModel)
            If $npc = 0 Then
                Out("[Travel] FAIL: ferryman estático model=" & $hintStaticModel & " aún no cargado tras navegar a coords -- abortando step")
                Return False
            EndIf
            Out("[StaticGate] Ferryman cargado tras navegar: id=" & $npc)
            Local $dialogCandidates = _Travel_GetKnownDialogsForFerryman($hintStaticModel)
            _Travel_TalkToStaticGate($npc, $dialogCandidates, $questHint)
        Else
            If Map_GetInstanceInfo("Type") = $GC_I_MAP_TYPE_OUTPOST Then
                Out("[Travel] Map_Move directo al portal (" & Round($wpX, 0) & ", " & Round($wpY, 0) & ")")
                Map_Move($wpX, $wpY, 0)
                Local $knownPatrolFerryman = 0
                If $questHint > 0 Then
                    Local $fm = _Travel_GetFerrymanModelForMap(Map_GetMapID(), $questHint)
                    If $fm <> 0 And Not _Travel_IsStaticGateFerryman($fm) Then
                        $knownPatrolFerryman = $fm
                    EndIf
                EndIf
                Local $waitMs = 120000
                If $knownPatrolFerryman <> 0 Then $waitMs = 8000
                Local $tWait = TimerInit()
                While Not Bot_ShouldStop() And TimerDiff($tWait) < $waitMs And Map_GetMapID() = $oldMap _
                        And Not Map_GetInstanceInfo("IsLoading")
                    Sleep(500)
                    If Mod(TimerDiff($tWait), 5000) < 500 Then
                        Map_Move($wpX, $wpY, 0)
                    EndIf
                WEnd
            Else
                Out("[Travel] cruce KILL-FIRST hacia el objetivo (" & Round($wpX, 0) & ", " & Round($wpY, 0) & ") - Pathfinder ruta fluida + grupo a grupo")
                Local $useIntermediateWPs = False
                If Map_GetMapID() = 432 And $wpX < 16000 And $wpY < -10000 Then
                    $useIntermediateWPs = True
                    Out("[Travel] Mapa 432 detectado -> usar WPs intermedios corredor sur")
                EndIf
                Local $cpPrevPf = $g_iPathfinder_MovementTimeout
                $g_iPathfinder_MovementTimeout = 10000
                If $useIntermediateWPs Then
                    Local $aMap432WPs[4][2] = [ _
                        [1053, -6505], _
                        [4510, -6182], _
                        [6425, -3035], _
                        [$wpX, $wpY]  _
                    ]
                    For $iW432 = 0 To UBound($aMap432WPs) - 1
                        Local $wpx432 = $aMap432WPs[$iW432][0]
                        Local $wpy432 = $aMap432WPs[$iW432][1]
                        Out("[Travel] Mapa 432 WP" & ($iW432+1) & "/" & UBound($aMap432WPs) & " -> (" & $wpx432 & "," & $wpy432 & ")")
                        _Mission_DoNavOnly($wpx432, $wpy432)
                        If Map_GetMapID() <> $oldMap Then ExitLoop
                    Next
                    $g_iPathfinder_MovementTimeout = $cpPrevPf
                    ExitLoop
                EndIf
                Local $cpTry = 0, $cpStuck = 0, $cpTotalNudges = 0, $hIdx = 0
                Local $cpLastX = 999999, $cpLastY = 999999
                While Map_GetMapID() = $oldMap And $cpTry < 70 And Not Bot_ShouldStop()
                    $cpTry += 1
                    If Party_GetPartyContextInfo("IsDefeated") Then ExitLoop
                    If Agent_GetAgentInfo(-2, "IsDead") Then
                        Sleep(3000)
                        ContinueLoop
                    EndIf
                    Local $cpX = Agent_GetAgentInfo(-2, "X"), $cpY = Agent_GetAgentInfo(-2, "Y")
                    Local $cpD = Sqrt(($wpX - $cpX) ^ 2 + ($wpY - $cpY) ^ 2)
                    If $cpD < 300 Then ExitLoop
                    If GetNearestEnemy(1500) <> 0 Then
                        Out("[Travel] grupo en rango -> matar (kill-first)")
                        Combat_ClearZone(1500, 30000)
                        $cpStuck = 0
                        $cpLastX = $cpX
                        $cpLastY = $cpY
                        ContinueLoop
                    EndIf
                    Local $moved = 999999
                    If $cpLastX <> 999999 Then $moved = Sqrt(($cpX - $cpLastX) ^ 2 + ($cpY - $cpLastY) ^ 2)
                    If $moved < 150 Then
                        $cpStuck += 1
                        If $cpStuck >= 2 Then
                            If $cpTotalNudges >= 4 Then
                                Out("[Travel] " & $cpTotalNudges & " nudges acumulados -> long-range al portal final (d=" & Round($cpD) & ")")
                                Local $cpPrevPf2 = $g_iPathfinder_MovementTimeout
                                $g_iPathfinder_MovementTimeout = 25000
                                MoveToFollowPath($wpX, $wpY, 0)
                                Sleep(2000)
                                $g_iPathfinder_MovementTimeout = $cpPrevPf2
                                $cpStuck = 0
                                $cpTotalNudges = 0
                                $cpLastX = Agent_GetAgentInfo(-2, "X")
                                $cpLastY = Agent_GetAgentInfo(-2, "Y")
                                ContinueLoop
                            EndIf
                            $hIdx = Mod($hIdx + 1, 4)
                            Local $dx = ($wpX - $cpX) / $cpD, $dy = ($wpY - $cpY) / $cpD
                            Local $px = -$dy, $py = $dx
                            If $hIdx >= 2 Then
                                $px = $dy
                                $py = -$dx
                            EndIf
                            Local $nudgeDist = 2500
                            Local $nx = $cpX + $px * $nudgeDist, $ny = $cpY + $py * $nudgeDist
                            Out("[Travel] atasco en pared (movió " & Round($moved) & "u) -> nudge perpendicular #" & $hIdx & " dist=" & $nudgeDist)
                            MoveToFollowPath($nx, $ny, 0)
                            Sleep(1500)
                            $cpStuck = 0
                            $cpTotalNudges += 1
                            $cpLastX = $cpX
                            $cpLastY = $cpY
                            ContinueLoop
                        EndIf
                    Else
                        $cpStuck = 0
                    EndIf
                    $cpLastX = $cpX
                    $cpLastY = $cpY
                    Local $stepLen = 4000
                    Local $sx = $wpX, $sy = $wpY
                    If $cpD > $stepLen Then
                        $sx = $cpX + ($wpX - $cpX) * $stepLen / $cpD
                        $sy = $cpY + ($wpY - $cpY) * $stepLen / $cpD
                    EndIf
                    Out("[Travel] paso " & $cpTry & " -> d_portal=" & Round($cpD))
                    MoveToFollowPath($sx, $sy, 600)
                    If Map_GetMapID() <> $oldMap Then ExitLoop
                    Sleep(300)
                WEnd
                $g_iPathfinder_MovementTimeout = $cpPrevPf   
            EndIf
            If Party_GetPartyContextInfo("IsDefeated") Then
                Out("[Travel] Party defeated, return to outpost")
                Map_ReturnToOutpost(False)
                Return False
            EndIf
            If Map_GetMapID() = $oldMap Then
                Out("[Travel] Mapa no cambió -> buscar ferryman")
                _Travel_TalkToGateNPC($wpX, $wpY, $questHint)
            EndIf
        EndIf
        If Map_GetMapID() = $oldMap Or Map_GetInstanceInfo("IsLoading") Or Map_GetMapID() = 0 Then
            WaitLoading()
        Else
            Other_WaitPingStabilized(1500)
        EndIf
        Local $newMap = Map_GetMapID()
        Out("[Travel] Step completado, ahora en map=" & $newMap)
        If $newMap = $oldMap Then
            Out("[Travel] FAIL: no se cruzó el portal en step " & ($i + 1) & ", abortando walk-through")
            Return False
        EndIf
    Next
    Out("[Travel] Walk-through complete, arrived at " & Map_GetMapID())
    Return (Map_GetMapID() = $targetOutpostId)
EndFunc
Func _Travel_GetQuestHintForTarget($targetMapId)
    Switch $targetMapId
        Case $GC_I_MAP_ID_CHAHBEK_VILLAGE_OUTPOST
            Return $GC_I_QUEST_ID_INTOCHAHBEKVILLAGE   
        Case Else
            Return 0
    EndSwitch
EndFunc
Func _Travel_GetKnownDialogsForFerryman($npcModel)
    Switch $npcModel
        Case 4760   
            Local $dialogs[1] = [0x81]
            Return $dialogs
        Case Else
            Local $empty[0]
            Return $empty
    EndSwitch
EndFunc
Func _Travel_IsStaticGateFerryman($npcModel)
    Switch $npcModel
        Case 4760   
            Return True
        Case Else
            Return False
    EndSwitch
EndFunc
Func _Travel_FindKnownFerryman($hintQuestId)
    Local $currentMap = Map_GetMapID()
    Local $modelId = _Travel_GetFerrymanModelForMap($currentMap, $hintQuestId)
    If $modelId = 0 Then Return 0
    Local $npc = Agent_GetAgentByPlayerNumber($modelId)
    If $npc <> 0 Then
        Out("[Gate] Ferryman conocido: map=" & $currentMap & " model=" & $modelId & " id=" & $npc)
        Return $npc
    EndIf
    Out("[Gate] Ferryman esperado model=" & $modelId & " no presente en mapa " & $currentMap)
    Return 0
EndFunc
Func _Travel_GetFerrymanModelForMap($mapId, $questId)
    Switch $questId
        Case $GC_I_QUEST_ID_INTOCHAHBEKVILLAGE   
            Switch $mapId
                Case $GC_I_MAP_ID_KAMADAN_JEWEL_OF_ISTAN   
                    Return 4756   
                Case $GC_I_MAP_ID_CHUURHIR_FIELDS          
                    Return 4760   
            EndSwitch
    EndSwitch
    Return 0
EndFunc
Func _Travel_GetFerrymanCoordsForMap($mapId, $questId)
    Local $coords[2] = [0, 0]
    Switch $questId
        Case $GC_I_QUEST_ID_INTOCHAHBEKVILLAGE   
            Switch $mapId
                Case $GC_I_MAP_ID_CHUURHIR_FIELDS   
                    $coords[0] = 3475
                    $coords[1] = -4906
            EndSwitch
    EndSwitch
    Return $coords
EndFunc
Func _Travel_TalkToStaticGate($npc, $dialogCandidates, $hintQuestId)
    Local $npcX = Agent_GetAgentInfo($npc, "X")
    Local $npcY = Agent_GetAgentInfo($npc, "Y")
    Local $npcModel = Agent_GetAgentInfo($npc, "PlayerNumber")
    Local $myX0 = Agent_GetAgentInfo(-2, "X")
    Local $myY0 = Agent_GetAgentInfo(-2, "Y")
    Local $dist0 = Sqrt(($npcX - $myX0)^2 + ($npcY - $myY0)^2)
    Out("[StaticGate] INIT npc_id=" & $npc & " model=" & $npcModel & " npc_pos=(" & Round($npcX, 0) & "," & Round($npcY, 0) & ") char_pos=(" & Round($myX0, 0) & "," & Round($myY0, 0) & ") dist=" & Round($dist0, 0))
    MoveTo($npcX, $npcY, 0, 30)
    Local $myXf = Agent_GetAgentInfo(-2, "X")
    Local $myYf = Agent_GetAgentInfo(-2, "Y")
    Local $distf = Sqrt(($npcX - $myXf)^2 + ($npcY - $myYf)^2)
    Out("[StaticGate] MoveTo done char_pos=(" & Round($myXf, 0) & "," & Round($myYf, 0) & ") dist_npc=" & Round($distf, 0))
    Local $oldMap = Map_GetMapID()
    Out("[StaticGate] Agent_GoNPC -> abrir dialog window")
    Agent_GoNPC($npc)
    Sleep(3000)
    Local $mapAfterGo = Map_GetMapID()
    If $mapAfterGo <> $oldMap Then
        Out("[StaticGate] OK Mapa cambió tras GoNPC: " & $oldMap & " -> " & $mapAfterGo)
        Return True
    EndIf
    Out("[StaticGate] GoNPC enviado, mapa sigue=" & $mapAfterGo & " (dialog window debería estar abierta)")
    If $hintQuestId > 0 Then
        Out("[StaticGate] === Secuencia quest " & $hintQuestId & " ===")
        Out("[StaticGate] Ui_AboutQuest(" & $hintQuestId & ") packet=0x008" & Hex($hintQuestId, 3) & "03")
        Ui_AboutQuest($hintQuestId)
        Sleep(1200)
        If Map_GetMapID() <> $oldMap Then
            Out("[StaticGate] OK Mapa cambió tras AboutQuest -> map=" & Map_GetMapID())
            Return True
        EndIf
        Out("[StaticGate]   AboutQuest sin efecto (map sigue=" & Map_GetMapID() & ")")
        Out("[StaticGate] Ui_AcceptQuest(" & $hintQuestId & ") packet=0x008" & Hex($hintQuestId, 3) & "01")
        Ui_AcceptQuest($hintQuestId)
        Sleep(1500)
        If Map_GetMapID() <> $oldMap Then
            Out("[StaticGate] OK Mapa cambió tras AcceptQuest -> map=" & Map_GetMapID())
            Return True
        EndIf
        Out("[StaticGate]   AcceptQuest sin efecto (map sigue=" & Map_GetMapID() & ")")
        Out("[StaticGate] Ui_UpdateQuest(" & $hintQuestId & ") packet=0x008" & Hex($hintQuestId, 3) & "04")
        Ui_UpdateQuest($hintQuestId)
        Sleep(2500)
        If Map_GetMapID() <> $oldMap Then
            Out("[StaticGate] OK Mapa cambió tras UpdateQuest -> map=" & Map_GetMapID())
            Return True
        EndIf
        Out("[StaticGate]   UpdateQuest sin efecto (map sigue=" & Map_GetMapID() & ")")
        Out("[StaticGate] Secuencia quest agotada, reabriendo dialog para probar codes raw")
        Agent_GoNPC($npc)
        Sleep(1500)
    EndIf
    If UBound($dialogCandidates) > 0 Then
        Out("[StaticGate] === Enviando " & UBound($dialogCandidates) & " dialog codes conocidos ===")
        For $i = 0 To UBound($dialogCandidates) - 1
            Local $code = $dialogCandidates[$i]
            Out("[StaticGate] Bot_Dialog(0x" & Hex($code, 2) & ") known[" & ($i+1) & "/" & UBound($dialogCandidates) & "]")
            Bot_Dialog($code)
            Sleep(2000)
            Local $mapNow = Map_GetMapID()
            If $mapNow <> $oldMap Then
                Out("[StaticGate] OK Mapa cambió tras 0x" & Hex($code, 2) & " -> map=" & $mapNow)
                Return True
            EndIf
            Out("[StaticGate]   0x" & Hex($code, 2) & " sin cambio (map sigue=" & $mapNow & ")")
        Next
    EndIf
    Local $cascade[6] = [0x82, 0x83, 0x84, 0x85, 0x86, 0x87]
    Out("[StaticGate] === Cascada genérica en sub-menu (sin reabrir) ===")
    For $i = 0 To UBound($cascade) - 1
        Local $code = $cascade[$i]
        Out("[StaticGate] Bot_Dialog(0x" & Hex($code, 2) & ") cascada[" & ($i+1) & "/" & UBound($cascade) & "]")
        Bot_Dialog($code)
        Sleep(2000)
        Local $mapNow = Map_GetMapID()
        If $mapNow <> $oldMap Then
            Out("[StaticGate] OK Mapa cambió tras cascada 0x" & Hex($code, 2) & " -> map=" & $mapNow)
            Return True
        EndIf
        Out("[StaticGate]   cascada 0x" & Hex($code, 2) & " sin cambio")
    Next
    Out("[StaticGate] FAIL agotados todos los intentos")
    Out("[StaticGate]   Char_pos final=(" & Round(Agent_GetAgentInfo(-2, "X"), 0) & "," & Round(Agent_GetAgentInfo(-2, "Y"), 0) & ") dist_npc=" & Round(Sqrt((Agent_GetAgentInfo($npc, "X") - Agent_GetAgentInfo(-2, "X"))^2 + (Agent_GetAgentInfo($npc, "Y") - Agent_GetAgentInfo(-2, "Y"))^2), 0))
    Return False
EndFunc
Func _Travel_TalkToGateNPC($wpX, $wpY, $hintQuestId = 0, $preNpc = 0)
    Out("[Gate] Buscando ferryman cerca de waypoint (" & Round($wpX, 0) & ", " & Round($wpY, 0) & ") hintQuest=" & $hintQuestId)
    Local $npc = $preNpc
    If $npc <> 0 Then
        Out("[Gate] NPC preseleccionado por caller id=" & $npc)
    EndIf
    If $npc = 0 Then
        $npc = _Travel_FindKnownFerryman($hintQuestId)
        If $npc <> 0 Then
            Out("[Gate] Ferryman conocido encontrado por Model ID")
        EndIf
    EndIf
    If $npc = 0 Then
        $npc = GetNearestNPCToXY($wpX, $wpY, 1500, $GC_I_AGENT_TYPE_LIVING, 1, "NPCFilter")
    EndIf
    If $npc = 0 Then
        Out("[Gate] Sin NPC en rango 1500 del waypoint -- buscar cerca del agente")
        $npc = GetNearestNPCToAgent(-2, 1500, $GC_I_AGENT_TYPE_LIVING, 1, "NPCFilter")
    EndIf
    If $npc = 0 Then
        Out("[Gate] No NPC encontrado")
        Return
    EndIf
    Local $npcX = Agent_GetAgentInfo($npc, "X")
    Local $npcY = Agent_GetAgentInfo($npc, "Y")
    Local $npcModel = Agent_GetAgentInfo($npc, "PlayerNumber")
    Local $distToWp = Sqrt(($npcX - $wpX) ^ 2 + ($npcY - $wpY) ^ 2)
    Out("[Gate] NPC id=" & $npc & " model=" & $npcModel & " pos=(" & Round($npcX, 0) & ", " & Round($npcY, 0) & ") dist_wp=" & Round($distToWp, 0))
    MoveToFollowPath($npcX, $npcY)
    Sleep(500)
    Agent_ChangeTarget($npc)
    Sleep(200)
    Agent_GoNPC($npc)
    Sleep(1200)
    Local $oldMap = Map_GetMapID()
    If $hintQuestId > 0 Then
        Out("[Gate] Secuencia quest " & $hintQuestId & ": AboutQuest -> AcceptQuest -> UpdateQuest")
        Out("[Gate] Ui_AboutQuest (intro)")
        Ui_AboutQuest($hintQuestId)
        Sleep(800)
        If Map_GetMapID() <> $oldMap Then
            Out("[Gate] Mapa cambió tras AboutQuest")
            Return
        EndIf
        Out("[Gate] Ui_AcceptQuest")
        Ui_AcceptQuest($hintQuestId)
        Sleep(800)
        If Map_GetMapID() <> $oldMap Then
            Out("[Gate] Mapa cambió tras AcceptQuest")
            Return
        EndIf
        Out("[Gate] Ui_UpdateQuest (enter/travel)")
        Ui_UpdateQuest($hintQuestId)
        Sleep(1800)
        If Map_GetMapID() <> $oldMap Then
            Out("[Gate] Mapa cambió tras UpdateQuest")
            Return
        EndIf
    EndIf
    Local $dialogs[6] = [0x82, 0x84, 0x85, 0x81, 0x83, 0x80]
    For $i = 0 To 5
        Out("[Gate] Probando dialog 0x" & Hex($dialogs[$i], 2))
        Bot_Dialog($dialogs[$i])
        Sleep(1500)
        If Map_GetMapID() <> $oldMap Then
            Out("[Gate] Mapa cambió tras 0x" & Hex($dialogs[$i], 2))
            Return
        EndIf
    Next
    Out("[Gate] Cascada completa sin cambio de mapa")
EndFunc
Func Travel_NavigateNoCombat($destX, $destY, $totalTimeoutMs = 90000)
    Local $startTimer = TimerInit()
    Local $stepNum = 0
    Local $lConsecutiveMoveFail = 0
    Local $lMaxConsecutiveFails = 3
    Out("[Navigate] Inicio: dest=(" & Round($destX, 0) & "," & Round($destY, 0) & ") timeout=" & $totalTimeoutMs & "ms")
    Do
        $stepNum += 1
        If Agent_GetAgentInfo(-2, "IsDead") Then
            Out("[Navigate] Char muerto en step " & $stepNum & " -- abortar")
            Return False
        EndIf
        If Not ProcessExists("gw.exe") Then
            Out("[Navigate] GW.exe ya no existe en step " & $stepNum & " -- abortar")
            Return False
        EndIf
        Local $myX = Agent_GetAgentInfo(-2, "X")
        Local $myY = Agent_GetAgentInfo(-2, "Y")
        If $myX = 0 And $myY = 0 Then
            Out("[Navigate] Pos=(0,0) en step " & $stepNum & " -- char en loading, esperar")
            Sleep(2000)
            ContinueLoop
        EndIf
        Local $dist = Sqrt(($destX - $myX)^2 + ($destY - $myY)^2)
        If $dist < 200 Then
            Out("[Navigate] Llegado al destino step=" & $stepNum & " dist=" & Round($dist, 0))
            Return True
        EndIf
        Out("[Navigate] Step " & $stepNum & " pos=(" & Round($myX, 0) & "," & Round($myY, 0) & ") dist_dest=" & Round($dist, 0))
        Local $lMoveOk = Pathfinder_MoveTo($destX, $destY, -1, "FilterObstacle", 0, 6000, $g_i_FinisherMode, "")
        If Not $lMoveOk Then
            $lConsecutiveMoveFail += 1
            If $lConsecutiveMoveFail >= $lMaxConsecutiveFails Then
                Out("[Navigate] ABORT: " & $lConsecutiveMoveFail & " consecutive Pathfinder_MoveTo failures en step " & $stepNum)
                Return False
            EndIf
        Else
            $lConsecutiveMoveFail = 0
        EndIf
        If Party_GetPartyContextInfo("IsDefeated") Then
            Out("[Navigate] Party defeated en step " & $stepNum)
            Return False
        EndIf
        Sleep(500)
    Until TimerDiff($startTimer) > $totalTimeoutMs
    Out("[Navigate] TIMEOUT tras " & Round(TimerDiff($startTimer)/1000, 1) & "s y " & $stepNum & " steps")
    Return False
EndFunc
Func Travel_ReturnToHomeOutpost()
    Local $phase = _Travel_GuessPhase($g_currentMission)
    Local $home = _Travel_GetHomeOutpostForPhase($phase)
    Out("[Travel] Returning to home outpost (phase=" & $phase & ", map=" & $home & ")")
    Return Travel_ToOutpost($home)
EndFunc
Func _Travel_GuessPhase($missionName)
    Switch $missionName
        Case "M01_Chahbek", "M02_Jokanur", "M03_Blacktide"
            Return "Istan"
        Case "M04_ConsulateDocks", "M05_VentaCemetery", "M06_Kodonur", _
             "M07_PogahnPassage", "M08_RilohnOrModdok"
            Return "Kourna"
        Case "M09_Tihark", "M10_Dasha", "M11_GrandCourt", _
             "M12_JennurOrDzagonur", "M13_NunduBay"
            Return "Vabbi"
        Case "M14_GateOfDesolation", "M15_RuinsOfMorah"
            Return "Desolation"
        Case "M16_GateOfPain", "M17_GateOfMadness", "M18_AbaddonsGate"
            Return "RoT"
        Case Else
            Return "Istan"
    EndSwitch
EndFunc
Func _Travel_GetMissionOutpost($missionName)
    Switch $missionName
        Case "M01_Chahbek"
            Return $GC_I_MAP_ID_CHAHBEK_VILLAGE_OUTPOST         
        Case "M02_Jokanur"
            Return $GC_I_MAP_ID_JOKANUR_DIGGINGS_OUTPOST        
        Case "M03_Blacktide"
            Return $GC_I_MAP_ID_BLACKTIDE_DEN_OUTPOST           
        Case "M04_ConsulateDocks"
            Return $GC_I_MAP_ID_CONSULATE_DOCKS_OUTPOST         
        Case "M05_VentaCemetery"
            Return $GC_I_MAP_ID_VENTA_CEMETERY_OUTPOST          
        Case "M06_Kodonur"
            Return $GC_I_MAP_ID_KODONUR_CROSSROADS_OUTPOST      
        Case "M07_PogahnPassage"
            Return $GC_I_MAP_ID_POGAHN_PASSAGE_OUTPOST          
        Case "M08_RilohnOrModdok"
            Return $GC_I_MAP_ID_RILOHN_REFUGE_OUTPOST           
        Case "M09_Tihark"
            Return $GC_I_MAP_ID_TIHARK_ORCHARD_OUTPOST          
        Case "M10_Dasha"
            Return $GC_I_MAP_ID_DASHA_VESTIBULE_OUTPOST         
        Case "M11_GrandCourt"
            Return $GC_I_MAP_ID_GRAND_COURT_OF_SEBELKEH_OUTPOST 
        Case "M12_JennurOrDzagonur"
            Return $GC_I_MAP_ID_JENNURS_HORDE_OUTPOST           
        Case "M13_NunduBay"
            Return $GC_I_MAP_ID_NUNDU_BAY_OUTPOST               
        Case "M14_GateOfDesolation"
            Return $GC_I_MAP_ID_GATE_OF_DESOLATION_OUTPOST      
        Case "M15_RuinsOfMorah"
            Return $GC_I_MAP_ID_RUINS_OF_MORAH_OUTPOST          
        Case "M16_GateOfPain"
            Return $GC_I_MAP_ID_GATE_OF_PAIN_OUTPOST            
        Case "M17_GateOfMadness"
            Return $GC_I_MAP_ID_GATE_OF_MADNESS_OUTPOST         
        Case "M18_AbaddonsGate"
            Return $GC_I_MAP_ID_ABADDONS_GATE_OUTPOST           
        Case Else
            Return 0
    EndSwitch
EndFunc
Func _Travel_GetHomeOutpostForPhase($phase)
    Switch $phase
        Case "Istan"
            Return $GC_I_MAP_ID_KAMADAN_JEWEL_OF_ISTAN          
        Case "Kourna"
            Return $GC_I_MAP_ID_CONSULATE                       
        Case "Vabbi"
            Return $GC_I_MAP_ID_VENTARIS_REFUGE                 
        Case "Desolation"
            Return $GC_I_MAP_ID_CHANTRY_OF_SECRETS              
        Case "RoT"
            Return $GC_I_MAP_ID_GATE_OF_TORMENT                 
        Case Else
            Return $GC_I_MAP_ID_KAMADAN_JEWEL_OF_ISTAN
    EndSwitch
EndFunc
Func _Travel_GetBotStartOutpost($actionKey)
    Switch $actionKey
        Case "RewardM01"
            Return $GC_I_MAP_ID_CHAHBEK_VILLAGE_OUTPOST
        Case "PrimaryTraining"
            Return 0
        Case "TravelToCliffsOfDohjok"
            Return 0   
        Case "RewardLeavingLegacy"
            Return $GC_I_MAP_ID_JOKANUR_DIGGINGS_OUTPOST
        Case "RM_Step1_ExitToZehlon"
            Return $GC_I_MAP_ID_JOKANUR_DIGGINGS_OUTPOST
        Case "HoningYourSkills", "SecondaryTraining", _
             "ChooseSecondaryProfession", "TheHonorableGeneral", _
             "SignsAndPortents"
            Return $GC_I_MAP_ID_SUNSPEAR_GREAT_HALL
        Case "M02_JokanurDiggings"
            Return $GC_I_MAP_ID_JOKANUR_DIGGINGS_OUTPOST
        Case Else
            Return 0
    EndSwitch
EndFunc
Func Travel_EnsureAtBotOutpost($actionKey)
    Local $targetMap = _Travel_GetBotStartOutpost($actionKey)
    If $targetMap = 0 Then Return True
    Local $currentMap = Map_GetMapID()
    Local $instType   = Map_GetInstanceInfo("Type")
    If $currentMap = $targetMap And $instType = 0 Then
        Inventory_ManageAtOutpost() 
        Return True
    EndIf
    If $currentMap = $targetMap Then
        Out("[Travel] Ya en mapa de inicio explorable (map " & $targetMap & " type=" & $instType & ") - skip travel")
        Return True
    EndIf
    If $instType = 1 Or $instType = 2 Then
        Out("[Travel] En explorable/mision (type=" & $instType & ") - saliendo al outpost...")
        Map_ReturnToOutpost(True)
        $currentMap = Map_GetMapID()
        $instType   = Map_GetInstanceInfo("Type")
        If $currentMap = $targetMap And $instType = 0 Then Return True
    EndIf
    Out("[Travel] Autodetect outpost: " & $actionKey & " -> map " & $targetMap)
    Return Travel_ToOutpost($targetMap)
EndFunc