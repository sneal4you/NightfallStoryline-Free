#include-once
Global Const $SP_ASTRALARIUM_MAP_ID = $GC_I_MAP_ID_THE_ASTRALARIUM      
Global Const $SP_ZEHLON_MAP_ID      = $GC_I_MAP_ID_ZEHLON_REACH         
Global Const $SP_JOKANUR_MAP_ID     = $GC_I_MAP_ID_JOKANUR_DIGGINGS_OUTPOST 
Global Const $SP_QUEST_ID           = $GC_I_QUEST_ID_SIGNSANDPORTENTS   
Global Const $SP_ASTRA_EXIT_X       = -4645
Global Const $SP_ASTRA_EXIT_Y       = 228
Global Const $SP_SIGNS_NPC_MODEL    = $GC_I_MODEL_ID_NF_DAJMIR     
Global Const $SP_SIGNS_NPC_X        = 16612
Global Const $SP_SIGNS_NPC_Y        = -3692
Global Const $SP_DIALOG_SIGNS_634   = 0x827A04   
Global Const $SP_MELONNI_MODEL      = $GC_I_MODEL_ID_NF_MELONNI    
Global Const $SP_MELONNI_X          = -1960
Global Const $SP_MELONNI_Y          = -13719
Global Const $SP_DIALOG_MELONNI     = 0x84       
Global Const $SP_NPC15_MODEL        = 15
Global Const $SP_NPC15_X            = -18050
Global Const $SP_NPC15_Y            = -17216
Global Const $SP_DIALOG_WALL_1      = 0x827A04   
Global Const $SP_DIALOG_WALL_2      = 0x84       
Global Const $SP_DIALOG_WALL_3      = 0x85       
Global Const $SP_REWARD_NPC_MODEL   = $GC_I_MODEL_ID_NF_GENERIC_B  
Global Const $SP_REWARD_NPC_X       = 2888
Global Const $SP_REWARD_NPC_Y       = 2207
Global Const $SP_DIALOG_REWARD_634  = 0x827A07   
Global Const $SP_ODURRA_MODEL       = $GC_I_MODEL_ID_NF_ODURRA     
Global Const $SP_HERO_ID_KOSS    = 6    
Global Const $SP_HERO_ID_MELONNI = 9    
Global Const $SP_MONK_MODEL      = $GC_I_MODEL_ID_NF_KIHM          
Global $SP_STEPS_TO_MELONNI[6][5] = [ _
    ["nav_combat", 14254,  -3208, "WP enemy 4434",   0], _
    ["nav_combat", 10400,  -3110, "WP enemy 4443",   0], _
    ["nav_combat",  9343,  -4680, "WP transito",     0], _
    ["nav_combat",  6357,  -6835, "WP enemy 4442",   0], _
    ["nav_combat",  4188,  -8355, "WP enemy 4443",   0], _
    ["nav_combat",  2920, -10160, "WP enemy 4441",   0]  _
]
Global $SP_STEPS_TO_NPC15[8][5] = [ _
    ["nav_combat",  -3943, -14385, "WP1 salida Melonni",    0], _
    ["nav_combat",  -5056, -16494, "WP2 descenso sur",      0], _
    ["nav_combat",  -7066, -17234, "WP3 tramo sur",         0], _
    ["nav_combat", -11934, -17452, "WP4 tramo sur-oeste",   0], _
    ["nav_combat", -15765, -17816, "WP5 aproximacion oeste",0], _
    ["nav_combat", -16948, -17954, "WP6 oeste",             0], _
    ["nav_combat", -17914, -17765, "WP7 alineando X NPC15", 0], _
    ["nav_combat", -18044, -17293, "WP8 sur Inscribed Wall",0]  _
]
Func Quest_SignsAndPortents_Run()
    Out("[SignsAndPortents] Start - paso 1: Travel a Astralarium + cruzar portal sur a Zehlon Reach")
    Local $q634state = Quest_GetQuestInfo($SP_QUEST_ID, "LogState")
    Out("[SP] Quest 634 LogState=" & $q634state)
    If $q634state = 0 Then
        Out("[SP] Quest 634 fuera del log (cobrada) -> fase done")
        Return True
    EndIf
    If $q634state < 0 Then
        Out("[SP] Quest 634 no en log (LogState=" & $q634state & "). Intentando aceptar con Dajmir...")
        Local $spOK = False
        For $spTry = 1 To 3
            If _RM_AcceptQuest634InAstralarium() Then
                $spOK = True
                ExitLoop
            EndIf
            Local $q634check = Quest_GetQuestInfo($SP_QUEST_ID, "LogState")
            If $q634check > 0 Then
                Out("[SP] Accept 634 'fallÃ³' pero quest activa (LogState=" & $q634check & ") -> continuar")
                $spOK = True
                ExitLoop
            EndIf
            Out("[SP] Accept 634 fallÃ³ (intento " & $spTry & "/3) -> reintentar en 4s")
            Sleep(4000)
        Next
        If Not $spOK Then
            Out("[SP] Accept 634 fallÃ³ 3 veces -> FASE FAIL (no se marca done: en char nuevo es fallo real)")
            Return False
        EndIf
        $q634state = Quest_GetQuestInfo($SP_QUEST_ID, "LogState")
        Out("[SP] Quest 634 LogState tras accept=" & $q634state)
        If $q634state <= 0 Then
            Out("[SP] FAIL: quest 634 sigue sin activarse tras accept")
            Return False
        EndIf
    EndIf
    If Map_GetMapID() <> $RM_DEST_MAP_ID And Map_GetMapID() <> $RM_EXPLORE_MAP_ID Then
        Out("[SP] Travel_ToOutpost(" & $RM_DEST_MAP_ID & ") - Astralarium")
        If Not Travel_ToOutpost($RM_DEST_MAP_ID) Then
            Out("[SP] FAIL: no se pudo viajar a Astralarium")
            Return False
        EndIf
        Sleep(2000)
    EndIf
    If Map_GetMapID() = $RM_DEST_MAP_ID Then
        _RM_EnsurePartyBeforeZehlon()
        _RM_EnsureAttributesAssigned()
        Out("[SP] En Astralarium, WalkThroughPortal sur (" & $RM_ASTRA_PORTAL_X & "," & $RM_ASTRA_PORTAL_Y & ") -> Zehlon Reach")
        If Not _RM_WalkThroughPortal($RM_ASTRA_PORTAL_X, $RM_ASTRA_PORTAL_Y, "south", $RM_EXPLORE_MAP_ID, 90000) Then
            Out("[SP] FAIL: no se pudo cruzar portal a Zehlon Reach")
            Return False
        EndIf
    EndIf
    If Map_GetMapID() <> $RM_EXPLORE_MAP_ID Then
        Out("[SP] FAIL: tras cross portal no estoy en Zehlon Reach (map=" & Map_GetMapID() & ")")
        Return False
    EndIf
    Out("[SP] OK - char en Zehlon Reach. Continuando flow completo...")
    Local $markerX, $markerY, $mapTo
    _SP_WaitForValidMarker(634, 15000, $markerX, $markerY, $mapTo)
    Out("[SP] Quest 634 marker=(" & Round($markerX) & "," & Round($markerY) & ") MapTo=" & $mapTo)
    Local $skipNPC5424 = False
    Local $skipMelonni = False
    Local $skipNPC15   = False
    Local $currentObjective = "NPC5424"   
    Local $markerValid = _SP_IsMarkerValid($markerX, $markerY)
    If Not $markerValid Then
        Local $cMX = Agent_GetAgentInfo(-2, "X")
        Local $cMY = Agent_GetAgentInfo(-2, "Y")
        Local $cDToNPC5424 = Sqrt(($cMX - $SP_SIGNS_NPC_X)^2 + ($cMY - $SP_SIGNS_NPC_Y)^2)
        Local $cDToMelonni = Sqrt(($cMX - $SP_MELONNI_X)^2  + ($cMY - $SP_MELONNI_Y)^2)
        Local $cDToNPC15   = Sqrt(($cMX - $SP_NPC15_X)^2    + ($cMY - $SP_NPC15_Y)^2)
        Out("[SP] Marker INVALIDO. Distancias char->NPCs: NPC5424=" & Round($cDToNPC5424) & "u Melonni=" & Round($cDToMelonni) & "u NPC15=" & Round($cDToNPC15) & "u")
        If $cDToNPC15 < 1500 Then
            $currentObjective = "NPC15"
        ElseIf $cDToMelonni < 1500 Then
            $currentObjective = "Melonni"
        Else
            $currentObjective = "NPC5424"
        EndIf
    ElseIf $mapTo = $SP_JOKANUR_MAP_ID Then
        $currentObjective = "Reward"
    ElseIf $mapTo = $RM_EXPLORE_MAP_ID Then
        Local $dToNPC5424 = _SP_DistMarker($markerX, $markerY, $SP_SIGNS_NPC_X, $SP_SIGNS_NPC_Y)
        Local $dToMelonni = _SP_DistMarker($markerX, $markerY, $SP_MELONNI_X, $SP_MELONNI_Y)
        Local $dToNPC15   = _SP_DistMarker($markerX, $markerY, $SP_NPC15_X, $SP_NPC15_Y)
        Out("[SP] Marker distancias (Zehlon): NPC5424=" & Round($dToNPC5424) & "u Melonni=" & Round($dToMelonni) & "u NPC15=" & Round($dToNPC15) & "u")
        Local $minD = $dToNPC5424
        $currentObjective = "NPC5424"
        If $dToMelonni < $minD Then
            $minD = $dToMelonni
            $currentObjective = "Melonni"
        EndIf
        If $dToNPC15 < $minD Then
            $minD = $dToNPC15
            $currentObjective = "NPC15"
        EndIf
    EndIf
    Local $sObjSource = " (via fallback char-pos)"
    If $markerValid Then $sObjSource = " (via marker)"
    Out("[SP] Objective actual: " & $currentObjective & $sObjSource)
    If $currentObjective = "Melonni" Or $currentObjective = "NPC15" Or $currentObjective = "Reward" Then
        $skipNPC5424 = True
        Out("[SP] skip PARTE 2 (objective actual posterior a NPC 5424)")
    EndIf
    If $currentObjective = "NPC15" Or $currentObjective = "Reward" Then
        $skipMelonni = True
        Out("[SP] skip PARTE 3 (objective actual posterior a Melonni)")
    EndIf
    If $currentObjective = "Reward" Then
        $skipNPC15 = True
        Out("[SP] skip PARTE 4 (objective=Reward -> Inscribed Wall ya hecha)")
    EndIf
    If Map_GetMapID() <> $RM_EXPLORE_MAP_ID Then
        Out("[SP] FAIL: no en Zehlon Reach (map=" & Map_GetMapID() & ")")
        Return False
    EndIf
    Sleep(3000)
    Pathfinder_SetPathUpdateInterval(1000)
    Cache_SkillBar()
    If $skipNPC5424 Then
        Out("[SP] 2/6 SKIP - marker indica que NPC 5424 ya hecho")
    Else
        Out("[SP] 2/6: Nav a NPC 5424 en (" & $SP_SIGNS_NPC_X & "," & $SP_SIGNS_NPC_Y & ")")
        If Not _SP_WalkToWaypoint($SP_SIGNS_NPC_X, $SP_SIGNS_NPC_Y, 20000, 600) Then
            Out("[SP] WARN: timeout caminando a NPC 5424 - intentando GoNPC de todas formas")
        EndIf
        Local $npc5424 = 0
        Local $tF5424 = TimerInit()
        While TimerDiff($tF5424) < 5000
            $npc5424 = Agent_GetAgentByPlayerNumber($SP_SIGNS_NPC_MODEL)
            If $npc5424 <> 0 Then ExitLoop
            Sleep(500)
        WEnd
        If $npc5424 = 0 Then
            Out("[SP] WARN PARTE 2: NPC 5424 no encontrado -> quest ya paso por aqui, continuar")
        Else
            Out("[SP] 2/6 NPC 5424 agent=" & $npc5424 & " -> GoNPC")
            Agent_GoNPC($npc5424)
            Sleep(2500)
            _SP_DialogWithRetry($SP_SIGNS_NPC_MODEL, $SP_DIALOG_SIGNS_634, 634, "PARTE 2 NPC 5424")
        EndIf
    EndIf
    If $skipMelonni Then
        Out("[SP] 3/6 SKIP - marker indica que Melonni ya hecho")
    Else
        Local $cmX = Agent_GetAgentInfo(-2, "X")
        Local $cmY = Agent_GetAgentInfo(-2, "Y")
        Local $distToMelonni = Sqrt(($cmX - $SP_MELONNI_X)^2 + ($cmY - $SP_MELONNI_Y)^2)
        If $distToMelonni > 800 Then
            Out("[SP] 3/6: nav directo tramo 1 hacia Melonni (" & UBound($SP_STEPS_TO_MELONNI) & " WPs)")
            If Not _SP_NavDirectPath($SP_STEPS_TO_MELONNI) Then
                Out("[SP] FAIL nav tramo 1")
                _SP_StopBotHere("FAIL PARTE 3 nav tramo 1")
                Return False   
            EndIf
        Else
            Out("[SP] 3/6 SKIP WPs: char ya cerca de Melonni (" & Round($distToMelonni) & "u)")
        EndIf
        Out("[SP] 3/6 aproximando a Melonni (" & $SP_MELONNI_X & "," & $SP_MELONNI_Y & ")")
        _ResetStuckBaseline()
        _SP_WalkToWaypoint($SP_MELONNI_X, $SP_MELONNI_Y, 15000, 400)
        Sleep(800)
        Out("[SP] 3/6 buscando Melonni por model " & $SP_MELONNI_MODEL)
        Local $melonniAgent = Agent_GetAgentByPlayerNumber($SP_MELONNI_MODEL)
        If $melonniAgent = 0 Then
            Out("[SP] WARN PARTE 3: Melonni model " & $SP_MELONNI_MODEL & " no encontrada -> quest ya paso por aqui, continuar")
        Else
            Out("[SP] 3/6 Melonni agent=" & $melonniAgent & " - GoNPC + Bot_Dialog(0x84)")
            Agent_GoNPC($melonniAgent)
            Sleep(2500)
            Bot_Dialog($SP_DIALOG_MELONNI)
            Sleep(3000)
        EndIf
    EndIf
    If $skipNPC15 Then
        Out("[SP] 4/6 SKIP - marker indica que NPC 15 ya hecho")
    Else
        Local $charX = Agent_GetAgentInfo(-2, "X")
        Local $charY = Agent_GetAgentInfo(-2, "Y")
        Local $distToNPC15 = Sqrt(($charX - $SP_NPC15_X)^2 + ($charY - $SP_NPC15_Y)^2)
        If $distToNPC15 > 800 Then
            Out("[SP] 4/6: nav directo tramo 2 hacia NPC Model 15 (" & UBound($SP_STEPS_TO_NPC15) & " WPs)")
            If Not _SP_NavDirectPath($SP_STEPS_TO_NPC15) Then
                Out("[SP] FAIL nav tramo 2")
                _SP_StopBotHere("FAIL PARTE 4 nav tramo 2")
                Return False   
            EndIf
        Else
            Out("[SP] 4/6 SKIP WPs: char ya cerca de NPC 15 (" & Round($distToNPC15) & "u)")
        EndIf
        Out("[SP] 4/6 interactuar con Inscribed Wall")
        If Not _SP_TalkToInscribedWall() Then
            _SP_StopBotHere("FAIL PARTE 4 Inscribed Wall")
            Return False   
        EndIf
    EndIf
    If Map_GetMapID() = $SP_JOKANUR_MAP_ID Then
        Out("[SP] 5/6: ya en Jokanur - skip espera auto-viaje")
    ElseIf $currentObjective = "Reward" Then
        Out("[SP] 5/6: objective=Reward en Zehlon -> Travel directo a Jokanur (muro ya hecho)")
        Travel_ToOutpost($SP_JOKANUR_MAP_ID)
        Sleep(2000)
    Else
        Out("[SP] 5/6: esperando auto-viaje a Jokanur (map " & $SP_JOKANUR_MAP_ID & ")...")
        Local $tAutoTravel = TimerInit()
        While Not Bot_ShouldStop() And Map_GetMapID() <> $SP_JOKANUR_MAP_ID
            If TimerDiff($tAutoTravel) > 30000 Then
                Out("[SP] WARN: auto-viaje no detectado en 30s, forzando Travel")
                Travel_ToOutpost($SP_JOKANUR_MAP_ID)
                ExitLoop
            EndIf
            Sleep(500)
        WEnd
    EndIf
    While Not Bot_ShouldStop() And Map_GetInstanceInfo("IsLoading")
        Sleep(200)
    WEnd
    Sleep(2000)
    Out("[SP] 6/6: Nav a NPC 4763 (" & $SP_REWARD_NPC_X & "," & $SP_REWARD_NPC_Y & ") -> cobrar reward 634")
    If Not _SP_WalkToWaypoint($SP_REWARD_NPC_X, $SP_REWARD_NPC_Y, 20000, 500) Then
        Out("[SP] WARN: timeout caminando a NPC 4763 - intentando GoNPC de todas formas")
    EndIf
    Local $rewardNpc = 0
    Local $tFR = TimerInit()
    While TimerDiff($tFR) < 5000
        $rewardNpc = Agent_GetAgentByPlayerNumber($SP_REWARD_NPC_MODEL)
        If $rewardNpc <> 0 Then ExitLoop
        Sleep(500)
    WEnd
    If $rewardNpc = 0 Then
        Out("[SP] FAIL: NPC 4763 no encontrado en Jokanur")
        _SP_StopBotHere("FAIL PARTE 6 NPC 4763 no encontrado")
        Return False   
    EndIf
    Out("[SP] 6/6 NPC 4763 agent=" & $rewardNpc & " -> GoNPC + Dialog 0x827A07")
    Agent_GoNPC($rewardNpc)
    Sleep(2000)
    _SP_DialogWithRetry($SP_REWARD_NPC_MODEL, $SP_DIALOG_REWARD_634, 634, "PARTE 6 reward 634")
    Local $q634after = Quest_GetQuestInfo($SP_QUEST_ID, "LogState")
    If $q634after <= 0 Then
        Out("[SP] OK - Quest 634 cobrada (LogState=" & $q634after & ")")
        Return True
    EndIf
    Out("[SP] FAIL: Quest 634 sigue en log (LogState=" & $q634after & ") tras reward -> fase NO completada")
    Return False
EndFunc
Func _SP_FindWall($maxRange = 3000)
    Local $charX = Agent_GetAgentInfo(-2, "X")
    Local $charY = Agent_GetAgentInfo(-2, "Y")
    Out("[SP-Wall] Char=(" & Round($charX) & "," & Round($charY) & ") escaneo " & $maxRange & "u")
    Local $maxAgents = Agent_GetMaxAgents()
    Local $bestSlot = 0, $bestType = 0, $bestDist = $maxRange
    For $i = 1 To $maxAgents
        If Agent_GetAgentPtr($i) = 0 Then ContinueLoop
        Local $aX = Agent_GetAgentInfo($i, "X")
        Local $aY = Agent_GetAgentInfo($i, "Y")
        Local $dist = Sqrt(($aX - $charX)^2 + ($aY - $charY)^2)
        If $dist > $maxRange Then ContinueLoop
        Local $type  = Agent_GetAgentInfo($i, "Type")
        Local $model = Agent_GetAgentInfo($i, "PlayerNumber")
        Out("[SP-Wall]   i=" & $i & " t=0x" & Hex($type,4) & " m=" & $model & " d=" & Round($dist))
        If $type = 0xDB And $model = $SP_NPC15_MODEL Then
            $bestSlot = $i
            $bestType = 0xDB
            $bestDist = $dist
            ExitLoop
        EndIf
        If ($type = 0x200 Or $type = 0x400) And $dist < $bestDist Then
            $bestDist = $dist
            $bestSlot = $i
            $bestType = $type
        EndIf
    Next
    Local $result[2] = [$bestSlot, $bestType]
    Return $result
EndFunc
Func _SP_TalkToInscribedWall()
    Local $found = _SP_FindWall(3000)
    Local $wallSlot = $found[0]
    Local $wallType = $found[1]
    If $wallSlot = 0 Then
        Out("[SP-Wall] FAIL: wall no encontrada en 3000u del char")
        Return False
    EndIf
    Local $wX = Agent_GetAgentInfo($wallSlot, "X")
    Local $wY = Agent_GetAgentInfo($wallSlot, "Y")
    Out("[SP-Wall] slot=" & $wallSlot & " type=0x" & Hex($wallType,4) & " pos=(" & Round($wX) & "," & Round($wY) & ")")
    Map_Move($wX, $wY, 0)
    Sleep(1500)
    Agent_CancelAction()
    Sleep(300)
    Agent_ChangeTarget($wallSlot)
    Sleep(300)
    If $wallType = 0xDB Then
        Out("[SP-Wall] GoNPC (living model=" & $SP_NPC15_MODEL & ")")
        Agent_GoNPC($wallSlot)
        Sleep(1500)
    Else
        Out("[SP-Wall] GoSignpost x2 (gadget)")
        Agent_GoSignpost($wallSlot)
        Sleep(700)
        Agent_GoSignpost($wallSlot)
        Sleep(1500)
    EndIf
    Out("[SP-Wall] Bot_Dialog 0x827A04")
    Bot_Dialog($SP_DIALOG_WALL_1)
    Sleep(2500)
    Out("[SP-Wall] Bot_Dialog 0x84")
    Bot_Dialog($SP_DIALOG_WALL_2)
    Sleep(2500)
    Out("[SP-Wall] Bot_Dialog 0x85")
    Bot_Dialog($SP_DIALOG_WALL_3)
    Sleep(2500)
    Return True
EndFunc
Func _SP_NavDirectPath(ByRef $steps)
    Local $n = UBound($steps)
    Local $i = _SP_FindNearestWP($steps, $n)
    If $i > 0 Then Out("[SP] Nav: char cerca de WP " & ($i+1) & "/" & $n & ", saltando " & $i & " WPs anteriores")
    Local $needsRepos = False
    Local $newI      = 0
    Local $x         = 0, $y = 0, $tol = 0
    Local $t         = 0
    Local $combatTries = 0
    Local $cx        = 0, $cy = 0
    Local $nearEnemy = 0
    Local $tNavReemit = TimerInit()
    While Not Bot_ShouldStop() And $i < $n
        If $needsRepos Then
            $needsRepos = False
            $newI = _SP_FindNearestWP($steps, $n)
            Out("[SP] Nav post-walkback: reposicion WP " & ($newI+1) & "/" & $n & " (era " & ($i+1) & ")")
            $i = $newI   
        EndIf
        $x   = $steps[$i][1]
        $y   = $steps[$i][2]
        $tol = ($i = $n - 1) ? 250 : 500
        Out("[SP] WP " & ($i+1) & "/" & $n & " -> (" & $x & "," & $y & ")")
        $t = TimerInit()
        $combatTries = 0
        Map_Move($x, $y, 0)
        $tNavReemit = TimerInit()
        While TimerDiff($t) < 120000
            If Bot_ShouldStop() Then Return False
            If $g_GE_LastCharIsDead Or $g_GE_NeedsWalkback Then
                $needsRepos = True
                $t = TimerInit()
                $combatTries = 0
                Sleep(500)
                ContinueLoop
            EndIf
            If $needsRepos Then ExitLoop   
            If $g_PR_CastLock Then
                Sleep(100)
                ContinueLoop
            EndIf
            $cx = Agent_GetAgentInfo(-2, "X")
            $cy = Agent_GetAgentInfo(-2, "Y")
            If Sqrt(($cx-$x)^2 + ($cy-$y)^2) < $tol Then ExitLoop
            $nearEnemy = GetNearestEnemy(1300)
            If $nearEnemy <> 0 And $combatTries < 30 Then
                Agent_CancelAction()
                Sleep(100)
                Combat_ClearZone(1250, 25000)
                $combatTries += 1
                If $g_GE_LastCharIsDead Or $g_GE_NeedsWalkback Then
                    $needsRepos = True
                    $combatTries = 0
                    $t = TimerInit()
                    ContinueLoop
                EndIf
                $t = TimerInit()
                Map_Move($x, $y, 0)
                $tNavReemit = TimerInit()
                ContinueLoop
            EndIf
            If $nearEnemy = 0 Then $combatTries = 0
            If TimerDiff($tNavReemit) >= 2500 Then
                Map_Move($x, $y, 0)
                $tNavReemit = TimerInit()
            EndIf
            Sleep(200)
        WEnd
        If Not $needsRepos And TimerDiff($t) >= 120000 Then
            Out("[SP] WP " & ($i+1) & " TIMEOUT - abort")
            Return False
        EndIf
        $i += 1
    WEnd
    Return True
EndFunc
Func _SP_FindNearestWP(ByRef $steps, $n)
    Local $cx = Agent_GetAgentInfo(-2, "X")
    Local $cy = Agent_GetAgentInfo(-2, "Y")
    Local $bestIdx = 0
    Local $bestD   = 999999
    For $j = 0 To $n - 1
        Local $d = Sqrt(($cx - $steps[$j][1])^2 + ($cy - $steps[$j][2])^2)
        If $d < $bestD Then
            $bestD   = $d
            $bestIdx = $j
        EndIf
    Next
    Return $bestIdx
EndFunc
Func _SP_WalkToWaypoint($x, $y, $timeoutMs = 30000, $tolerance = 400)
    Map_Move($x, $y, 0)
    Local $t = TimerInit()
    Local $tReemit = TimerInit()
    While Not Bot_ShouldStop() And TimerDiff($t) < $timeoutMs
        Local $dx = Agent_GetAgentInfo(-2, "X") - $x
        Local $dy = Agent_GetAgentInfo(-2, "Y") - $y
        Local $dist = Sqrt($dx*$dx + $dy*$dy)
        If $dist < $tolerance Then
            Out("[SP] Llegado a (" & $x & "," & $y & ") tras " & Round(TimerDiff($t)/1000, 1) & "s")
            Return True
        EndIf
        Sleep(400)
        If TimerDiff($tReemit) >= 2500 Then
            Map_Move($x, $y, 0)
            $tReemit = TimerInit()
        EndIf
    WEnd
    Out("[SP] TIMEOUT llegando a (" & $x & "," & $y & ")")
    Return False
EndFunc
Func _SP_ForceCrossPortal($baseX, $baseY, $targetMap, $totalTimeoutMs = 60000)
    Local $offsets[9][2] = [ _
        [0, 0], _
        [0, -400], _      
        [-400, -400], _   
        [-200, -800], _   
        [0, -1200], _     
        [-600, -600], _   
        [-400, -1200], _  
        [-800, -400], _   
        [-1200, -400] _   
    ]
    Local $t = TimerInit()
    Local $idx = 0
    Local $lastChange = TimerInit()
    Local $tReemit = TimerInit()
    Local $curX = $baseX, $curY = $baseY
    Map_Move($curX, $curY, 0)
    Out("[SP] CrossPortal centro (" & $baseX & "," & $baseY & ") target=" & $targetMap)
    While Not Bot_ShouldStop() And TimerDiff($t) < $totalTimeoutMs
        Local $now = Map_GetMapID()
        If $now = $targetMap Then
            WaitLoading()
            Out("[SP] Cruzado a " & $targetMap & " tras " & Round(TimerDiff($t)/1000, 1) & "s (offset idx=" & $idx & ")")
            Return True
        EndIf
        Sleep(400)
        If TimerDiff($tReemit) >= 2500 Then
            Map_Move($curX, $curY, 0)
            $tReemit = TimerInit()
        EndIf
        If TimerDiff($lastChange) >= 5000 Then
            $idx = Mod($idx + 1, 9)
            $curX = $baseX + $offsets[$idx][0]
            $curY = $baseY + $offsets[$idx][1]
            Out("[SP] CrossPortal reintento idx=" & $idx & " Map_Move(" & $curX & "," & $curY & ")")
            Map_Move($curX, $curY, 0)
            $lastChange = TimerInit()
            $tReemit = TimerInit()
        EndIf
    WEnd
    Return False
EndFunc
Func Quest_SP_Step1_AstralariumToZehlon()
    Out("[SP-Step1] Cross Astralarium -> Zehlon Reach")
    If Map_GetMapID() = $SP_ZEHLON_MAP_ID Then
        Out("[SP-Step1] Ya en Zehlon Reach, skip")
        Return True
    EndIf
    If Map_GetMapID() <> $SP_ASTRALARIUM_MAP_ID Then
        Out("[SP-Step1] FAIL: no en Astralarium (map=" & Map_GetMapID() & ")")
        Return False
    EndIf
    _SP_WalkToWaypoint($SP_ASTRA_EXIT_X, $SP_ASTRA_EXIT_Y, 30000, 400)
    Return _SP_ForceCrossPortal($SP_ASTRA_EXIT_X, $SP_ASTRA_EXIT_Y, $SP_ZEHLON_MAP_ID, 60000)
EndFunc
Func Quest_SP_Step2_TalkNPC5424()
    Out("[SP-Step2] Nav + dialog NPC 5424 en Zehlon Reach")
    If Map_GetMapID() <> $SP_ZEHLON_MAP_ID Then
        Out("[SP-Step2] FAIL: no en Zehlon Reach")
        Return False
    EndIf
    Sleep(1000)
    If Not _Quests_NavAndOpenDialog($SP_SIGNS_NPC_X, $SP_SIGNS_NPC_Y, $SP_SIGNS_NPC_MODEL) Then
        Out("[SP-Step2] FAIL nav/dialog NPC 5424")
        Return False
    EndIf
    Bot_Dialog($SP_DIALOG_SIGNS_634)
    Sleep(2500)
    Return True
EndFunc
Func Quest_SP_Step3_NavToMelonni()
    Out("[SP-Step3] Nav-direct tramo 1 hasta Melonni")
    If Map_GetMapID() <> $SP_ZEHLON_MAP_ID Then
        Out("[SP-Step3] FAIL: no en Zehlon Reach")
        Return False
    EndIf
    Return _SP_NavDirectPath($SP_STEPS_TO_MELONNI)
EndFunc
Func Quest_SP_Step4_TalkMelonni()
    Out("[SP-Step4] Nav + dialog Melonni")
    If Map_GetMapID() <> $SP_ZEHLON_MAP_ID Then
        Out("[SP-Step4] FAIL: no en Zehlon Reach")
        Return False
    EndIf
    Out("[SP-Step4] aproximando a Melonni (MoveTo directo, sin aggro-stop)")
    _ResetStuckBaseline()
    MoveTo($SP_MELONNI_X, $SP_MELONNI_Y, 0, 400)
    Sleep(800)
    Local $melonniAgent = Agent_GetAgentByPlayerNumber($SP_MELONNI_MODEL)
    If $melonniAgent = 0 Then
        Out("[SP-Step4] FAIL: Melonni (model " & $SP_MELONNI_MODEL & ") no encontrada")
        Return False
    EndIf
    Out("[SP-Step4] Melonni agent=" & $melonniAgent & " -> GoNPC + Bot_Dialog(0x84)")
    Agent_GoNPC($melonniAgent)
    Sleep(2500)
    Bot_Dialog($SP_DIALOG_MELONNI)
    Sleep(3000)
    Return True
EndFunc
Func Quest_SP_Step5_NavToNPC15()
    Out("[SP-Step5] Nav-direct tramo 2 hasta Inscribed Wall")
    If Map_GetMapID() <> $SP_ZEHLON_MAP_ID Then
        Out("[SP-Step5] FAIL: no en Zehlon Reach")
        Return False
    EndIf
    Local $cX = Agent_GetAgentInfo(-2, "X")
    Local $cY = Agent_GetAgentInfo(-2, "Y")
    Local $d = Sqrt(($cX - $SP_NPC15_X)^2 + ($cY - $SP_NPC15_Y)^2)
    If $d > 800 Then
        If Not _SP_NavDirectPath($SP_STEPS_TO_NPC15) Then Return False
    Else
        Out("[SP-Step5] SKIP WPs: char ya cerca (" & Round($d) & "u)")
    EndIf
    Return _SP_TalkToInscribedWall()
EndFunc
Func _SP_KickOdurra()
    Local $henchCount = Party_GetMyPartyInfo("HenchmenCount")
    If @error Or $henchCount <= 0 Then Return
    For $i = 1 To $henchCount
        Local $hAgentId = Party_GetMyPartyHenchmanInfo($i, "AgentID")
        If $hAgentId = 0 Then ContinueLoop
        If Agent_GetAgentInfo($hAgentId, "PlayerNumber") = $SP_ODURRA_MODEL Then
            Out("[SP] Quitando Odurra (agent " & $hAgentId & ") del party")
            Party_KickNpc($hAgentId)
            Return
        EndIf
    Next
EndFunc
Func _SP_KickAllHenchmen()
    Local $kicked = 0
    Local $tLimit = TimerInit()
    While TimerDiff($tLimit) < 10000   
        Local $nHench = Party_GetMyPartyInfo("ArrayHenchmanPartyMemberSize")
        If @error Or $nHench <= 0 Then ExitLoop
        Local $aid = Party_GetMyPartyHenchmanInfo(1, "AgentID")
        If $aid = 0 Then ExitLoop
        Local $model = Agent_GetAgentInfo($aid, "PlayerNumber")
        Out("[SP] KickAllHenchmen: echando henchman model=" & $model & " agent=" & $aid)
        Party_KickNpc($aid)
        $kicked += 1
        Sleep(600)
    WEnd
    If $kicked > 0 Then Out("[SP] KickAllHenchmen: " & $kicked & " henchmen echados")
EndFunc
Func _SP_DialogWithRetry($npcModel, $dialogCode, $questId, $label)
    Local $agent = Agent_GetAgentByPlayerNumber($npcModel)
    If $agent = 0 Then
        Out("[SP-Dialog] " & $label & ": NPC model " & $npcModel & " no encontrado")
        Return False
    EndIf
    Local $oldState  = Quest_GetQuestInfo($questId, "LogState")
    Local $oldMarkerX = Quest_GetQuestInfo($questId, "MarkerX")
    Local $oldMarkerY = Quest_GetQuestInfo($questId, "MarkerY")
    Out("[SP-Dialog] " & $label & ": GoNPC(" & $agent & ") + Bot_Dialog(0x" & Hex($dialogCode, 6) & ")")
    Agent_GoNPC($agent)
    Sleep(2500)
    Bot_Dialog($dialogCode)
    Sleep(3500)
    Local $newState  = Quest_GetQuestInfo($questId, "LogState")
    Local $newMarkerX = Quest_GetQuestInfo($questId, "MarkerX")
    Local $newMarkerY = Quest_GetQuestInfo($questId, "MarkerY")
    If $newState <> $oldState Then
        Out("[SP-Dialog] " & $label & " OK - LogState " & $oldState & " -> " & $newState)
        Return True
    EndIf
    If $newMarkerX <> $oldMarkerX Or $newMarkerY <> $oldMarkerY Then
        Out("[SP-Dialog] " & $label & " OK - Marker cambio (objective interno avanzo)")
        Return True
    EndIf
    Out("[SP-Dialog] " & $label & " WARN sin cambios detectables. Continuamos al siguiente paso.")
    Return False
EndFunc
Func _SP_StopBotHere($label)
    Out("[SP] STOP: " & $label & " - bot parado en sitio (no vuelve a base)")
    $BotRunning = False
EndFunc
Func _SP_DistMarker($mx, $my, $px, $py)
    If $mx = 0 And $my = 0 Then Return 999999
    Local $dx = $mx - $px
    Local $dy = $my - $py
    Return Sqrt($dx*$dx + $dy*$dy)
EndFunc
Func _SP_IsMarkerValid($mx, $my)
    If $mx = 0 And $my = 0 Then Return False
    If Abs($mx) > 100000 Or Abs($my) > 100000 Then Return False
    Return True
EndFunc
Func _SP_WaitForValidMarker($questId, $timeoutMs, ByRef $mx, ByRef $my, ByRef $mapTo)
    Local $t = TimerInit()
    While Not Bot_ShouldStop() And TimerDiff($t) < $timeoutMs
        $mx    = Quest_GetQuestInfo($questId, "MarkerX")
        $my    = Quest_GetQuestInfo($questId, "MarkerY")
        $mapTo = Quest_GetQuestInfo($questId, "MapTo")
        If _SP_IsMarkerValid($mx, $my) Then
            Out("[SP] Marker valido tras " & Round(TimerDiff($t)/1000, 1) & "s")
            Return True
        EndIf
        Sleep(1000)
    WEnd
    Out("[SP] WARN marker quest " & $questId & " sigue invalido tras " & Round($timeoutMs/1000) & "s (mx=" & $mx & " my=" & $my & ")")
    Return False
EndFunc
Func _SP_KickHeroById($heroId, $name)
    Local $nSlots = Party_GetMyPartyInfo("ArrayHeroPartyMemberSize")
    If @error Or $nSlots <= 0 Then
        Out("[SP] KickHeroById: party vacÃ­a, skip")
        Return
    EndIf
    For $i = 1 To $nSlots
        If Party_GetMyPartyHeroInfo($i, "HeroID") = $heroId Then
            Out("[SP] Kick hero " & $name & " (HeroID=" & $heroId & ") -> Party_KickHero")
            Party_KickHero($heroId)
            Sleep(1000)
            Return
        EndIf
    Next
    Out("[SP] KickHeroById: hero " & $name & " (ID=" & $heroId & ") no en party, skip")
EndFunc