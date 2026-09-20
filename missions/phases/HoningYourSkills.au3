#include-once
Func Quest_HoningYourSkills_Run()
    Out("[HoningYourSkills] Orquesta TravelSH + TravelAstra + TravelCD + FarmSunspear + BuySkills + SetupSkillBar + RewardHoning")
    Local $aSteps[7][2] = [ _
        ["TravelToSunspearHall",  "Quest_TravelToSunspearHall_Run"], _
        ["TravelToAstralarium",   "Quest_TravelToAstralarium_Run"], _
        ["TravelToChampionsDawn", "Quest_TravelToChampionsDawn_Run"], _
        ["FarmSunspear",          "Quest_FarmSunspear_Run"], _
        ["BuySkillsKamadan",      "Quest_BuySkillsKamadan_Run"], _
        ["SetupSkillBar",         "Quest_SetupSkillBar_Run"], _
        ["RewardHoningYourSkills","Quest_CQ_Phase04_Run"]  _
    ]
    Local $iStart = _HYS_ResumePoint()
    For $i = $iStart To UBound($aSteps) - 1
        Out("[HoningYourSkills] " & ($i+1) & "/7 -> " & $aSteps[$i][0])
        $g_bAntiIdleTargetLock = ($aSteps[$i][0] = "TravelToSunspearHall")
        Local $ok = Call($aSteps[$i][1])
        If @error Or Not $ok Then
            $g_bAntiIdleTargetLock = False
            Out("[HoningYourSkills] FAIL en " & $aSteps[$i][0])
            Return False
        EndIf
        Sleep(800)
    Next
    $g_bAntiIdleTargetLock = False   
    Out("[HoningYourSkills] OK - char preparado, quest 649 cobrada")
    Return True
EndFunc
Func _HYS_ResumePoint()
    Local $pts    = Sunspear_GetPoints()
    Local $curMap = Map_GetMapID()
    Local $q715   = Quest_GetQuestInfo(715, "LogState")
    If $pts >= 300 Then
        If Quest_GetQuestInfo(649, "LogState") = 0 Then
            Out("[HYS] Resume: q649 cobrada + pts=" & $pts & " -> paso 6 SetupSkillBar (safety, no skip)")
            Return 5
        EndIf
        Out("[HYS] Resume: " & $pts & " pts Sunspear (>=300) -> paso 5 BuySkillsKamadan (luego cobrar q649)")
        Return 4
    EndIf
    If $curMap = $GC_I_MAP_ID_CHAMPIONS_DAWN Then
        Out("[HYS] Resume: mapa=Champion's Dawn (479) -> paso 4 FarmSunspear")
        Return 3
    EndIf
    If $curMap = $GC_I_MAP_ID_THE_ASTRALARIUM Then
        Out("[HYS] Resume: mapa=The Astralarium (502) -> paso 3 TravelToChampionsDawn")
        Return 2
    EndIf
    If $q715 = 33 Then
        Out("[HYS] Resume: quest 715 activa (LogState=33) -> paso 2 TravelToAstralarium")
        Return 1
    EndIf
    Out("[HYS] Resume: inicio completo -> paso 1 TravelToSunspearHall")
    Return 0
EndFunc
Global Const $TSH_DEST_MAP_ID = $GC_I_MAP_ID_SUNSPEAR_GREAT_HALL    
Global Const $TSH_KAMADAN_MAP_ID = $GC_I_MAP_ID_KAMADAN_JEWEL_OF_ISTAN  
Global Const $TSH_PLAINS_MAP_ID = $GC_I_MAP_ID_PLAINS_OF_JARIN         
Global Const $TSH_HENCH1_MODEL = $GC_I_MODEL_ID_NF_HENCH_TYPE1    
Global Const $TSH_HENCH2_MODEL = $GC_I_MODEL_ID_NF_HENCH_TYPE2    
Global Const $TSH_HENCH_AREA_X = -8400
Global Const $TSH_HENCH_AREA_Y = 16800
Global Const $TSH_HENCH_AREA_RANGE = 2500
Global Const $TSH_KAMADAN_EXIT_X = -9800
Global Const $TSH_KAMADAN_EXIT_Y = 18800
Global Const $TSH_PJ_WP0_X = 17000
Global Const $TSH_PJ_WP0_Y = 1500
Global Const $TSH_PJ_WPA_X = 13500
Global Const $TSH_PJ_WPA_Y = 2400
Global Const $TSH_PJ_WPB_X = 5900
Global Const $TSH_PJ_WPB_Y = 1263
Global Const $TSH_PJ_WPC_X = 214
Global Const $TSH_PJ_WPC_Y = 2582
Global Const $TSH_PJ_WPD_X = -1412
Global Const $TSH_PJ_WPD_Y = 2197
Global Const $TSH_PJ_WPE_X = -3127
Global Const $TSH_PJ_WPE_Y = 3705
Global Const $TSH_PJ_PORTAL_X = -3127
Global Const $TSH_PJ_PORTAL_Y = 8000
Global Const $TSH_WP_TOLERANCE = 1500
Func Quest_TravelToSunspearHall_Run()
    Out("[TravelToSunspearHall] Start - manual walk a Sunspear Great Hall (431)")
    Out("[TravelToSunspearHall] 1/5: Item_AcceptAllItems()")
    Item_AcceptAllItems()
    Sleep(800)
    Local $curMap = Map_GetMapID()
    If $curMap <> $TSH_KAMADAN_MAP_ID And $curMap <> $TSH_PLAINS_MAP_ID And $curMap <> $TSH_DEST_MAP_ID Then
        Out("[TravelToSunspearHall] map=" & $curMap & " no es Kamadan/Plains/SH -> Travel_ToOutpost(431)")
        If Not Travel_ToOutpost($TSH_DEST_MAP_ID) Then
            Out("[TravelToSunspearHall] FAIL Travel_ToOutpost(431)")
            Return False
        EndIf
        Sleep(2000)
    EndIf
    If Map_GetMapID() = $TSH_KAMADAN_MAP_ID Then
        Out("[TravelToSunspearHall] 2/5: navegar a zona portal sur (AutoParty rellena party)")
        _TSH_WalkToWaypoint($TSH_HENCH_AREA_X, $TSH_HENCH_AREA_Y, 45000, $TSH_HENCH_AREA_RANGE)
    Else
        Out("[TravelToSunspearHall] 2/5: skip (no en Kamadan, map=" & Map_GetMapID() & ")")
    EndIf
    If Map_GetMapID() = $TSH_KAMADAN_MAP_ID Then
        Out("[TravelToSunspearHall] 3/5: salir por portal sur a Plains of Jarin")
        _TSH_WalkAndWaitMapChange($TSH_KAMADAN_EXIT_X, $TSH_KAMADAN_EXIT_Y, $TSH_PLAINS_MAP_ID, 60000)
    EndIf
    If Map_GetMapID() = $TSH_PLAINS_MAP_ID Then
        Out("[TravelToSunspearHall] 4/5: Plains of Jarin -> walk directo (sin combat)")
        $g_LootNavLock = True   
        _TSH_WalkToWaypoint($TSH_PJ_WP0_X, $TSH_PJ_WP0_Y, 20000, $TSH_WP_TOLERANCE, $TSH_PLAINS_MAP_ID)
        _TSH_WalkToWaypoint($TSH_PJ_WPA_X, $TSH_PJ_WPA_Y, 20000, $TSH_WP_TOLERANCE, $TSH_PLAINS_MAP_ID)
        _TSH_WalkToWaypoint($TSH_PJ_WPB_X, $TSH_PJ_WPB_Y, 20000, $TSH_WP_TOLERANCE, $TSH_PLAINS_MAP_ID)
        _TSH_WalkToWaypoint($TSH_PJ_WPC_X, $TSH_PJ_WPC_Y, 20000, $TSH_WP_TOLERANCE, $TSH_PLAINS_MAP_ID)
        _TSH_WalkToWaypoint($TSH_PJ_WPD_X, $TSH_PJ_WPD_Y, 20000, $TSH_WP_TOLERANCE, $TSH_PLAINS_MAP_ID)
        _TSH_WalkToWaypoint($TSH_PJ_WPE_X, $TSH_PJ_WPE_Y, 20000, $TSH_WP_TOLERANCE, $TSH_PLAINS_MAP_ID)
        If Not _TSH_WalkAndWaitMapChange($TSH_PJ_PORTAL_X, $TSH_PJ_PORTAL_Y, $TSH_DEST_MAP_ID, 20000) Then
            $g_LootNavLock = False
            Out("[TravelToSunspearHall] FAIL 4/5 - no se cruzo el portal a Sunspear Hall")
            Return False
        EndIf
        $g_LootNavLock = False
    EndIf
    If Map_GetMapID() <> $TSH_DEST_MAP_ID Then
        Out("[TravelToSunspearHall] FAIL - mapa final=" & Map_GetMapID() & " (esperado " & $TSH_DEST_MAP_ID & ")")
        Return False
    EndIf
    Out("[TravelToSunspearHall] 6/6a: reward quest 649 'Honing Your Skills'")
    If Not _Quests_NavAndOpenDialog(-2866, 7093, 4751) Then
        Out("[TravelToSunspearHall] WARN - no abre dialog con NPC. Igual ya estamos en Sunspear Hall.")
        Return True
    EndIf
    Out("[TSH] Ui_RewardQuest(649)")
    Ui_RewardQuest(649)
    Sleep(2500)
    Out("[TravelToSunspearHall] 6/6b: re-nav NPC 4751 -> accept 715")
    If Not _Quests_NavAndOpenDialog(-2866, 7093, 4751) Then
        Out("[TravelToSunspearHall] WARN - no re-abre dialog para quest 715")
        Return True
    EndIf
    Out("[TSH] Ui_AcceptQuest(715)")
    Ui_AcceptQuest(715)
    Sleep(2500)
    Out("[TravelToSunspearHall] OK - char en Sunspear Great Hall con quest 715 activa")
    Return True
EndFunc
Func _TSH_AddHenchman($modelID)
    Local $agent = Agent_GetAgentByPlayerNumber($modelID)
    If $agent = 0 Then
        Out("[TSH] No henchman con model=" & $modelID & " encontrado en mapa")
        Return False
    EndIf
    Out("[TSH] Party_AddNpc agent=" & $agent & " model=" & $modelID)
    Party_AddNpc($agent)
    Return True
EndFunc
Func _TSH_WalkToWaypoint($x, $y, $timeoutMs = 30000, $tolerance = 500, $expectedMap = 0)
    Map_Move($x, $y, 0)
    Local $t = TimerInit()
    Local $tMove = TimerInit()
    Local $lastLog = TimerInit()
    Local $startMap = Map_GetMapID()
    Local $tProg = TimerInit(), $lastD = 99999999, $side = 1, $stucks = 0
    While Not Bot_ShouldStop() And TimerDiff($t) < $timeoutMs
        If Bot_ShouldStop() Then Return False
        If Map_GetMapID() = 0 Or Map_GetInstanceInfo("IsLoading") Then
            Sleep(1000)
            ContinueLoop
        EndIf
        If $expectedMap <> 0 And Map_GetMapID() <> $expectedMap Then
            Out("[TSH] mapa cambio " & $startMap & " -> " & Map_GetMapID() & " (expected " & $expectedMap & ") => abort walk")
            Return False
        EndIf
        If Agent_GetAgentInfo(-2, "IsDead") Then
            Out("[TSH] char muerto en walk -> esperando respawn")
            While Not Bot_ShouldStop() And Agent_GetAgentInfo(-2, "IsDead") And TimerDiff($t) < $timeoutMs
                Sleep(1000)
            WEnd
            Map_Move($x, $y, 0)
            Sleep(1000)
        EndIf
        Local $myX = Agent_GetAgentInfo(-2, "X")
        Local $myY = Agent_GetAgentInfo(-2, "Y")
        Local $dist = Sqrt(($myX - $x)^2 + ($myY - $y)^2)
        If $dist < $tolerance Then
            Out("[TSH] WP (" & $x & ", " & $y & ") dist=" & Round($dist, 0) & "u OK")
            Return True
        EndIf
        If TimerDiff($lastLog) >= 10000 Then
            Out("[TSH] walk -> (" & $x & "," & $y & ") dist=" & Round($dist) & "u elapsed=" & Round(TimerDiff($t)/1000) & "s")
            $lastLog = TimerInit()
        EndIf
        If $dist < $lastD - 50 Then
            $lastD = $dist
            $tProg = TimerInit()
            $stucks = 0
        ElseIf TimerDiff($tProg) > 10000 Then
            $stucks += 1
            Local $vx = $x - $myX, $vy = $y - $myY
            Local $vl = Sqrt($vx * $vx + $vy * $vy)
            If $vl > 1 And $stucks <= 3 Then
                Local $px = $myX + (-$vy / $vl) * 400 * $side, $py = $myY + ($vx / $vl) * 400 * $side
                Out("[TSH] walk sin progreso 10s -> sidestep " & $stucks & "/3")
                Map_Move($px, $py, 0)
            EndIf
            $side = -$side
            $tProg = TimerInit()
            $tMove = TimerInit()
            Sleep(400)
            ContinueLoop
        EndIf
        If TimerDiff($tMove) >= 2000 Then
            Map_Move($x, $y, 0)
            $tMove = TimerInit()
        EndIf
        Sleep(150)
    WEnd
    Out("[TSH] WP (" & $x & ", " & $y & ") TIMEOUT")
    Return False
EndFunc
Func _TSH_WalkAndWaitMapChange($x, $y, $targetMap, $timeoutMs = 60000)
    Map_Move($x, $y, 0)
    Local $t = TimerInit()
    Local $tMove = TimerInit()
    Local $lastLog = TimerInit()
    Local $startMap = Map_GetMapID()
    Local $tProg = TimerInit(), $lastD = 99999999, $side = 1, $stucks = 0
    While Not Bot_ShouldStop() And TimerDiff($t) < $timeoutMs
        If Bot_ShouldStop() Then Return False
        If Map_GetMapID() = $targetMap Then
            Out("[TSH] Llegado a map " & $targetMap)
            Return True
        EndIf
        If Map_GetMapID() = 0 Then WaitLoading()
        If Agent_GetAgentInfo(-2, "IsDead") Then
            Out("[TSH] char muerto en walkAndWait -> esperando respawn")
            While Not Bot_ShouldStop() And Agent_GetAgentInfo(-2, "IsDead") And TimerDiff($t) < $timeoutMs
                Sleep(1000)
            WEnd
            If Map_GetMapID() <> $startMap Then
                Out("[TSH] respawn en mapa " & Map_GetMapID() & " (start=" & $startMap & ") => abort walkAndWait")
                Return False
            EndIf
            Map_Move($x, $y, 0)
            Sleep(1000)
        EndIf
        If TimerDiff($tMove) >= 2000 Then
            Map_Move($x, $y, 0)
            $tMove = TimerInit()
        EndIf
        Local $ppX = Agent_GetAgentInfo(-2, "X"), $ppY = Agent_GetAgentInfo(-2, "Y")
        Local $ppD = Sqrt(($ppX - $x)^2 + ($ppY - $y)^2)
        If $ppD < $lastD - 50 Then
            $lastD = $ppD
            $tProg = TimerInit()
            $stucks = 0
        ElseIf TimerDiff($tProg) > 10000 Then
            $stucks += 1
            Local $vx = $x - $ppX, $vy = $y - $ppY
            Local $vl = Sqrt($vx * $vx + $vy * $vy)
            If $vl > 1 And $stucks <= 3 Then
                Out("[TSH] portal sin progreso 10s -> sidestep " & $stucks & "/3")
                Map_Move($ppX + (-$vy / $vl) * 400 * $side, $ppY + ($vx / $vl) * 400 * $side, 0)
            EndIf
            $side = -$side
            $tProg = TimerInit()
            $tMove = TimerInit()
            Sleep(400)
            ContinueLoop
        EndIf
        If TimerDiff($lastLog) >= 10000 Then
            Out("[TSH] walkAndWait -> map=" & Map_GetMapID() & " target=" & $targetMap & " elapsed=" & Round(TimerDiff($t)/1000) & "s")
            $lastLog = TimerInit()
        EndIf
        Sleep(500)
    WEnd
    Out("[TSH] TIMEOUT esperando map " & $targetMap & " (actual=" & Map_GetMapID() & ")")
    Return False
EndFunc
Global Const $TA_HALL_MAP_ID = $GC_I_MAP_ID_SUNSPEAR_GREAT_HALL    
Global Const $TA_PLAINS_MAP_ID = $GC_I_MAP_ID_PLAINS_OF_JARIN         
Global Const $TA_DEST_MAP_ID = $GC_I_MAP_ID_THE_ASTRALARIUM        
Global Const $TA_NPC_X = -2866
Global Const $TA_NPC_Y = 7093
Global Const $TA_NPC_MODEL = $GC_I_MODEL_ID_NF_GENERIC_A           
Global Const $TA_QUEST_REWARD_ID = $GC_I_QUEST_ID_HONINGYOURSKILLS           
Global Const $TA_QUEST_ACCEPT_ID = $GC_I_QUEST_ID_RISINGINTHERANKS_MASTERSERGEANT 
Global Const $TA_HALL_EXIT_X = -3062
Global Const $TA_HALL_EXIT_Y = 4265
Global Const $TA_PJ_WP2_X = -3040
Global Const $TA_PJ_WP2_Y = 3261
Global Const $TA_PJ_WP3_X = -5656
Global Const $TA_PJ_WP3_Y = 2217
Global Const $TA_PJ_WP4_X = -8366
Global Const $TA_PJ_WP4_Y = 7860
Global Const $TA_PJ_WP5_X = -11770
Global Const $TA_PJ_WP5_Y = 9345
Global Const $TA_PJ_WP6_X = -12409
Global Const $TA_PJ_WP6_Y = 11933
Global Const $TA_PJ_WP7_X = -15665
Global Const $TA_PJ_WP7_Y = 14814
Global Const $TA_PJ_WP8_X = -16990
Global Const $TA_PJ_WP8_Y = 18204
Global Const $TA_PJ_WP9_X = -18635
Global Const $TA_PJ_WP9_Y = 16494
Global Const $TA_PJ_WP10_X = -19782
Global Const $TA_PJ_WP10_Y = 16408
Global Const $TA_WP_TOLERANCE = 1500
Func Quest_TravelToAstralarium_Run()
    Out("[TravelToAstralarium] Start - viaje Sunspear Hall -> The Astralarium (502)")
    If Map_IsMapUnlocked($GC_I_MAP_ID_CHAMPIONS_DAWN) And Map_IsOutpost($GC_I_MAP_ID_CHAMPIONS_DAWN) Then
        Out("[TravelToAstralarium] 479 ya desbloqueado -> skip (viaje rapido directo en el paso siguiente)")
        Return True
    EndIf
    If Map_GetMapID() = $TA_HALL_MAP_ID Then
        Out("[TravelToAstralarium] 1/3: salir Sunspear Hall por portal a Plains of Jarin")
        _TA_ForceCrossPortal(-3070, 3700, $TA_PLAINS_MAP_ID, 75000)
    EndIf
    If Map_GetMapID() = $TA_PLAINS_MAP_ID Then
        Out("[TravelToAstralarium] 2/3: Plains of Jarin - 9 waypoints hasta portal Astralarium")
        Out("[TA] WP2 (entrada Plains): (" & $TA_PJ_WP2_X & ", " & $TA_PJ_WP2_Y & ")")
        _TA_WalkToWaypoint($TA_PJ_WP2_X, $TA_PJ_WP2_Y, 25000, $TA_WP_TOLERANCE)
        Out("[TA] WP3 (oeste): (" & $TA_PJ_WP3_X & ", " & $TA_PJ_WP3_Y & ")")
        _TA_WalkToWaypoint($TA_PJ_WP3_X, $TA_PJ_WP3_Y, 25000, $TA_WP_TOLERANCE)
        Out("[TA] WP4 (curva norte): (" & $TA_PJ_WP4_X & ", " & $TA_PJ_WP4_Y & ")")
        _TA_WalkToWaypoint($TA_PJ_WP4_X, $TA_PJ_WP4_Y, 35000, $TA_WP_TOLERANCE)
        Out("[TA] WP5 (noroeste): (" & $TA_PJ_WP5_X & ", " & $TA_PJ_WP5_Y & ")")
        _TA_WalkToWaypoint($TA_PJ_WP5_X, $TA_PJ_WP5_Y, 25000, $TA_WP_TOLERANCE)
        Out("[TA] WP6 (mas norte): (" & $TA_PJ_WP6_X & ", " & $TA_PJ_WP6_Y & ")")
        _TA_WalkToWaypoint($TA_PJ_WP6_X, $TA_PJ_WP6_Y, 25000, $TA_WP_TOLERANCE)
        Out("[TA] WP7 (tras combate): (" & $TA_PJ_WP7_X & ", " & $TA_PJ_WP7_Y & ")")
        _TA_WalkToWaypoint($TA_PJ_WP7_X, $TA_PJ_WP7_Y, 30000, $TA_WP_TOLERANCE)
        Out("[TA] WP8 (norte): (" & $TA_PJ_WP8_X & ", " & $TA_PJ_WP8_Y & ")")
        _TA_WalkToWaypoint($TA_PJ_WP8_X, $TA_PJ_WP8_Y, 25000, $TA_WP_TOLERANCE)
        Out("[TA] WP9 (gira sur): (" & $TA_PJ_WP9_X & ", " & $TA_PJ_WP9_Y & ")")
        _TA_WalkToWaypoint($TA_PJ_WP9_X, $TA_PJ_WP9_Y, 25000, $TA_WP_TOLERANCE)
        Out("[TA] WP10 (justo antes del portal): (" & $TA_PJ_WP10_X & ", " & $TA_PJ_WP10_Y & ")")
        _TA_WalkToWaypoint($TA_PJ_WP10_X, $TA_PJ_WP10_Y, 25000, 800)
        Out("[TA] PORTAL Astralarium (cruce robusto con barrido de offsets)")
        _TA_ForceCrossPortal(-20400, 16800, $TA_DEST_MAP_ID, 60000)
    EndIf
    If Map_GetMapID() <> $TA_DEST_MAP_ID Then
        Out("[TravelToAstralarium] FAIL - mapa final=" & Map_GetMapID() & " (esperado " & $TA_DEST_MAP_ID & ")")
        Return False
    EndIf
    Out("[TravelToAstralarium] OK - char en The Astralarium")
    Return True
EndFunc
Func _TA_WalkToWaypoint($x, $y, $timeoutMs = 30000, $tolerance = 500)
    Map_Move($x, $y, 0)
    Local $t = TimerInit()
    Local $tSkill7 = TimerInit()
    While Not Bot_ShouldStop() And TimerDiff($t) < $timeoutMs
        Local $dx = Agent_GetAgentInfo(-2, "X") - $x
        Local $dy = Agent_GetAgentInfo(-2, "Y") - $y
        Local $dist = Sqrt($dx*$dx + $dy*$dy)
        If $dist < $tolerance Then
            Out("[TA] Llegado a (" & $x & ", " & $y & ") tras " & Round(TimerDiff($t)/1000, 1) & "s (dist=" & Round($dist, 0) & "u)")
            Return True
        EndIf
        If TimerDiff($tSkill7) >= 6000 Then
            Skill_UseSkill(6)
            $tSkill7 = TimerInit()
        EndIf
        Sleep(500)
        If Mod(TimerDiff($t), 5000) < 500 Then Map_Move($x, $y, 0)
    WEnd
    Out("[TA] TIMEOUT " & Round($timeoutMs/1000, 0) & "s llegando a (" & $x & ", " & $y & ")")
    Return False
EndFunc
Func _TA_WalkAndWaitMapChange($x, $y, $targetMap, $timeoutMs = 60000)
    Local $oldMap = Map_GetMapID()
    Map_Move($x, $y, 0)
    Local $t = TimerInit()
    While Not Bot_ShouldStop() And TimerDiff($t) < $timeoutMs
        Local $now = Map_GetMapID()
        If $now = $targetMap Then
            WaitLoading()
            Out("[TA] Llegado a map " & $targetMap & " tras " & Round(TimerDiff($t)/1000, 1) & "s")
            Return True
        EndIf
        If $now <> $oldMap And $now <> 0 And Not Map_GetInstanceInfo("IsLoading") Then
            Out("[TA] Cambio map=" & $now & " (esperado " & $targetMap & "). Salir.")
            ExitLoop
        EndIf
        Sleep(500)
        If Mod(TimerDiff($t), 5000) < 500 Then Map_Move($x, $y, 0)
    WEnd
    Out("[TA] TIMEOUT " & Round($timeoutMs/1000, 0) & "s esperando map " & $targetMap & ", actual=" & Map_GetMapID())
    Return False
EndFunc
Func _TA_ForceCrossPortal($baseX, $baseY, $targetMap, $totalTimeoutMs = 60000)
    Local $offsets[9][2] = [ _
        [0, 0], _           
        [-800, 0], _        
        [0, 400], _         
        [0, -400], _        
        [-500, 400], _      
        [-500, -400], _     
        [-1500, 0], _       
        [-200, 800], _      
        [-200, -800] _      
    ]
    Local $t = TimerInit()
    Local $idx = 0
    Local $lastChange = TimerInit()
    Local $tReemit = TimerInit()
    Local $curX = $baseX, $curY = $baseY
    Map_Move($curX, $curY, 0)
    Out("[TA] ForceCrossPortal centro (" & $baseX & ", " & $baseY & ")")
    While Not Bot_ShouldStop() And TimerDiff($t) < $totalTimeoutMs
        Local $now = Map_GetMapID()
        If $now = $targetMap Then
            Out("[TA] Cruzado portal a map " & $targetMap & " tras " & Round(TimerDiff($t)/1000, 1) & "s (offset idx=" & $idx & ")")
            Return True
        EndIf
        Sleep(400)
        If Map_GetMapID() = $targetMap Then ContinueLoop
        If TimerDiff($tReemit) >= 2500 Then
            Map_Move($curX, $curY, 0)
            $tReemit = TimerInit()
        EndIf
        If TimerDiff($lastChange) >= 5000 Then
            $idx = Mod($idx + 1, 9)
            $curX = $baseX + $offsets[$idx][0]
            $curY = $baseY + $offsets[$idx][1]
            Out("[TA] ForceCrossPortal reintento idx=" & $idx & " Map_Move(" & $curX & ", " & $curY & ")")
            Map_Move($curX, $curY, 0)
            $lastChange = TimerInit()
            $tReemit = TimerInit()
        EndIf
    WEnd
    Out("[TA] ForceCrossPortal TIMEOUT " & Round($totalTimeoutMs/1000, 0) & "s, map actual=" & Map_GetMapID())
    Return False
EndFunc
Global Const $TCD_ASTRA_MAP_ID = $GC_I_MAP_ID_THE_ASTRALARIUM       
Global Const $TCD_PLAINS_MAP_ID = $GC_I_MAP_ID_PLAINS_OF_JARIN         
Global Const $TCD_DEST_MAP_ID = $GC_I_MAP_ID_CHAMPIONS_DAWN          
Global Const $TCD_ASTRA_PORTAL_X = 5000
Global Const $TCD_ASTRA_PORTAL_Y = 800
Global Const $TCD_WP_TOLERANCE = 1500
Global Const $TCD_CD_PORTAL_X = -19200
Global Const $TCD_CD_PORTAL_Y = -13500
Func Quest_TravelToChampionsDawn_Run()
    Out("[TravelToChampionsDawn] Start - viaje Astralarium -> Champion's Dawn (479)")
    If Map_GetMapID() = $TCD_DEST_MAP_ID Then
        Out("[TravelToChampionsDawn] Ya en Champion's Dawn (479)")
        Return True
    EndIf
    If Map_IsMapUnlocked($TCD_DEST_MAP_ID) And Map_IsOutpost($TCD_DEST_MAP_ID) Then
        Out("[TravelToChampionsDawn] 479 desbloqueado -> viaje rapido (con verificacion)")
        For $vt = 1 To 4
            Local $tStab = TimerInit()   
            While TimerDiff($tStab) < 8000 And Agent_GetAgentInfo(-2, "MaxHP") <= 0
                Sleep(500)
            WEnd
            Travel_ToOutpost($TCD_DEST_MAP_ID)
            Local $tArr = TimerInit()     
            While Not Bot_ShouldStop() And TimerDiff($tArr) < 20000 And Map_GetMapID() <> $TCD_DEST_MAP_ID
                Sleep(500)
            WEnd
            If Map_GetMapID() = $TCD_DEST_MAP_ID Then
                Out("[TravelToChampionsDawn] OK - viaje rapido a Champion's Dawn (intento " & $vt & ")")
                Return True
            EndIf
            Out("[TravelToChampionsDawn] viaje rapido intento " & $vt & "/4 no llego (map=" & Map_GetMapID() & ")")
        Next
        Out("[TravelToChampionsDawn] Viaje rapido fallo (4 intentos), fallback a ruta a pie")
    EndIf
    If Map_GetMapID() <> $TCD_DEST_MAP_ID And Map_GetMapID() <> $TCD_ASTRA_MAP_ID And Map_GetMapID() <> $TCD_PLAINS_MAP_ID Then
        If Map_IsMapUnlocked($TCD_ASTRA_MAP_ID) Then
            Out("[TravelToChampionsDawn] en map=" & Map_GetMapID() & " (no 502/430) -> ir a Astralarium 502 para la ruta a pie")
            Travel_ToOutpost($TCD_ASTRA_MAP_ID)
            Local $tA2 = TimerInit()
            While Not Bot_ShouldStop() And TimerDiff($tA2) < 20000 And Map_GetMapID() <> $TCD_ASTRA_MAP_ID
                Sleep(500)
            WEnd
        EndIf
    EndIf
    If Map_GetMapID() = $TCD_ASTRA_MAP_ID Then
        Out("[TravelToChampionsDawn] 1/3: salir Astralarium hacia Plains of Jarin")
        _TCD_ForceCrossPortal($TCD_ASTRA_PORTAL_X, $TCD_ASTRA_PORTAL_Y, $TCD_PLAINS_MAP_ID, 45000)
    EndIf
    If Map_GetMapID() = $TCD_PLAINS_MAP_ID Then
        Out("[TravelToChampionsDawn] 2/3: Plains of Jarin - 14 waypoints norte->sur")
        Local $wps[14][2] = [ _
            [-19031, 13486], _
            [-17794, 11543], _
            [-18424,  9760], _
            [-19500,  7427], _
            [-19609,  4782], _
            [-18957,  3058], _
            [-17527,  1144], _
            [-16683, -1051], _
            [-17357, -2931], _
            [-18491, -5666], _
            [-19202, -7257], _
            [-19208, -9107], _
            [-17172, -10096], _
            [-18293, -12187]  _
        ]
        For $i = 0 To UBound($wps) - 1
            Local $wpX = $wps[$i][0]
            Local $wpY = $wps[$i][1]
            Out("[TCD] WP" & ($i+1) & "/14: (" & $wpX & ", " & $wpY & ")")
            _TCD_WalkToWaypoint($wpX, $wpY, 35000, $TCD_WP_TOLERANCE)
            If Map_GetMapID() <> $TCD_PLAINS_MAP_ID Then
                Out("[TCD] Cambio de map durante waypoints, salir loop")
                ExitLoop
            EndIf
        Next
        If Map_GetMapID() = $TCD_PLAINS_MAP_ID Then
            Out("[TravelToChampionsDawn] 3/3: ForceCrossPortal a Champion's Dawn")
            _TCD_ForceCrossPortal($TCD_CD_PORTAL_X, $TCD_CD_PORTAL_Y, $TCD_DEST_MAP_ID, 60000)
        EndIf
    EndIf
    If Map_GetMapID() <> $TCD_DEST_MAP_ID Then
        Out("[TravelToChampionsDawn] FAIL - mapa final=" & Map_GetMapID() & " (esperado " & $TCD_DEST_MAP_ID & ")")
        Return False
    EndIf
    Out("[TravelToChampionsDawn] OK - char en Champion's Dawn")
    Return True
EndFunc
Func _TCD_WalkToWaypoint($x, $y, $timeoutMs = 30000, $tolerance = 500)
    Map_Move($x, $y, 0)
    Local $t = TimerInit()
    Local $tSkill7 = TimerInit()
    While Not Bot_ShouldStop() And TimerDiff($t) < $timeoutMs
        Local $dx = Agent_GetAgentInfo(-2, "X") - $x
        Local $dy = Agent_GetAgentInfo(-2, "Y") - $y
        Local $dist = Sqrt($dx*$dx + $dy*$dy)
        If $dist < $tolerance Then
            Out("[TCD] Llegado a (" & $x & ", " & $y & ") tras " & Round(TimerDiff($t)/1000, 1) & "s (dist=" & Round($dist, 0) & "u)")
            Return True
        EndIf
        If TimerDiff($tSkill7) >= 6000 Then
            Skill_UseSkill(6)
            $tSkill7 = TimerInit()
        EndIf
        Sleep(500)
        If Mod(TimerDiff($t), 5000) < 500 Then Map_Move($x, $y, 0)
    WEnd
    Out("[TCD] TIMEOUT " & Round($timeoutMs/1000, 0) & "s llegando a (" & $x & ", " & $y & ")")
    Return False
EndFunc
Func _TCD_ForceCrossPortal($baseX, $baseY, $targetMap, $totalTimeoutMs = 60000)
    Local $offsets[9][2] = [ _
        [0, 0], _
        [-800, 0], _
        [800, 0], _
        [0, 400], _
        [0, -400], _
        [-500, 400], _
        [-500, -400], _
        [500, 400], _
        [500, -400] _
    ]
    Local $t = TimerInit()
    Local $idx = 0
    Local $lastChange = TimerInit()
    Local $tReemit = TimerInit()
    Local $curX = $baseX, $curY = $baseY
    Map_Move($curX, $curY, 0)
    Out("[TCD] ForceCrossPortal centro (" & $baseX & ", " & $baseY & ")")
    While Not Bot_ShouldStop() And TimerDiff($t) < $totalTimeoutMs
        Local $now = Map_GetMapID()
        If $now = $targetMap Then
            Out("[TCD] Cruzado portal a map " & $targetMap & " tras " & Round(TimerDiff($t)/1000, 1) & "s (offset idx=" & $idx & ")")
            Local $tLoad = TimerInit()
            While Map_GetInstanceInfo("IsLoading") And TimerDiff($tLoad) < 10000
                Sleep(300)
            WEnd
            Sleep(2000)
            Out("[TCD] Mapa " & $targetMap & " asentado (IsLoading=False)")
            Return True
        EndIf
        Sleep(400)
        If Map_GetMapID() = $targetMap Then ContinueLoop
        If Map_GetMapID() = 0 Or Map_GetInstanceInfo("IsLoading") Then ContinueLoop
        If TimerDiff($tReemit) >= 2500 Then
            Map_Move($curX, $curY, 0)
            $tReemit = TimerInit()
        EndIf
        If TimerDiff($lastChange) >= 5000 Then
            $idx = Mod($idx + 1, 9)
            $curX = $baseX + $offsets[$idx][0]
            $curY = $baseY + $offsets[$idx][1]
            Out("[TCD] ForceCrossPortal reintento idx=" & $idx & " Map_Move(" & $curX & ", " & $curY & ")")
            Map_Move($curX, $curY, 0)
            $lastChange = TimerInit()
            $tReemit = TimerInit()
        EndIf
    WEnd
    Out("[TCD] ForceCrossPortal TIMEOUT, map actual=" & Map_GetMapID())
    Return False
EndFunc
Global Const $FS_OUTPOST_MAP_ID = $GC_I_MAP_ID_CHAMPIONS_DAWN    
Global Const $FS_EXPLORABLE_MAP_ID = $GC_I_MAP_ID_PLAINS_OF_JARIN      
Global Const $FS_PORTAL_CENTER_X = 23831
Global Const $FS_PORTAL_CENTER_Y = 11518
Global Const $FS_PORTAL_FORWARD_X = 23900
Global Const $FS_PORTAL_FORWARD_Y = 16000
Global Const $FS_NPC_BOUNTY_X = -16795
Global Const $FS_NPC_BOUNTY_Y = -12217
Global Const $FS_NPC_BOUNTY_MODEL = $GC_I_MODEL_ID_NF_BOUNTY_PATRON 
Global Const $FS_NPC_BOUNTY_DIALOG = 0x85
Global Const $FS_PRE_FIGHT_X = -16745
Global Const $FS_PRE_FIGHT_Y = -12051
Global Const $FS_ENEMY_AREA_X = -15000
Global Const $FS_ENEMY_AREA_Y = -12700
Global Const $FS_TARGET_POINTS = 300
Global Const $FS_MAX_ITERATIONS = 200
Global Const $FS_FIGHT_TIMEOUT_MS = 90000   
Global Const $FS_SKILL_TEMPLATE = "OgChkSz/V6OgHvVXEs4VAA"
Global Const $FS_KOSS_TEMPLATE = "OQATEJ6Wl4q+FwBWocNACAA"
Global Const $FS_KIHM_MODEL_CD     = 4586       
Global Const $FS_DPS_HENCH_MODEL_CD = 4589      
Func _FS_FarmIssnur($a_targetPts = 500)
    Local Const $KODLONU = 489, $ISSNUR = 486, $SCOUT_MODEL = 4827
    Local Const $SCOUT_X = 26948, $SCOUT_Y = 6274, $BOUNTY_DLG = 0x85
    Out("[FarmIssnur] Start - target " & $a_targetPts & " pts Sunspear (Issnur Isles)")
    Local $iter = 0
    While $iter < 40
        If Bot_ShouldStop() Or Map_GetMapID() = 0 Then Return False
        $iter += 1
        Local $pts = Sunspear_GetPoints()
        Out("[FarmIssnur] Iter " & $iter & " - pts=" & $pts & "/" & $a_targetPts)
        If $pts >= $a_targetPts Then
            Out("[FarmIssnur] OK - target alcanzado (" & $pts & " pts)")
            _FS_ClaimRankReward()
            Return True
        EndIf
        If Map_GetMapID() <> $ISSNUR Then
            If Map_GetMapID() <> $KODLONU Then
                Out("[FarmIssnur] Travel a Kodlonu Hamlet (489)")
                Map_TravelTo($KODLONU)
                Sleep(5000)
            EndIf
            If Map_GetMapID() = $KODLONU Then
                _FS_FillParty(25000)
                Sleep(2000)
                Out("[FarmIssnur] Cruzar portal Kodlonu -> Issnur Isles (_SD_EnterIssnur)")
                _SD_EnterIssnur()
                Sleep(3000)
            EndIf
        EndIf
        If Map_GetMapID() <> $ISSNUR Then
            Out("[FarmIssnur] no en Issnur (map=" & Map_GetMapID() & ") -> reintentar")
            ContinueLoop
        EndIf
        Local $tload = TimerInit()
        While Not Bot_ShouldStop() And TimerDiff($tload) < 15000 And Agent_GetAgentInfo(-2, "X") = 0
            Sleep(1000)
        WEnd
        Local $scout = Agent_GetAgentByPlayerNumber($SCOUT_MODEL)
        If $scout = 0 Then
            _FS_WalkToWaypoint($SCOUT_X, $SCOUT_Y, 30000, 300)
            $scout = Agent_GetAgentByPlayerNumber($SCOUT_MODEL)
        EndIf
        If $scout <> 0 Then
            _FS_WalkToWaypoint(Agent_GetAgentInfo($scout, "X"), Agent_GetAgentInfo($scout, "Y"), 20000, 250)
            For $tb = 1 To 3
                Agent_ChangeTarget($scout)
                Sleep(300)
                Agent_GoNPC($scout)
                Sleep(1600)
                Bot_Dialog($BOUNTY_DLG)
                Sleep(1200)
                If _FS_HasActiveBounty() Then
                    Out("[FarmIssnur] Bounty activado (intento " & $tb & ")")
                    ExitLoop
                EndIf
            Next
            If Not _FS_HasActiveBounty() Then Out("[FarmIssnur] WARN bounty NO activo tras 3 intentos")
        Else
            Out("[FarmIssnur] WARN Scout 4827 no encontrado en Issnur")
        EndIf
        Agent_CancelAction()
        Sleep(150)
        Agent_ChangeTarget(0)
        Local $aSkZ[2][2] = [[21490, -1599], [17666, -2055]]
        For $sz = 0 To 1
            If Recovery_IsAtZero() Or Agent_GetAgentInfo(-2, "IsDead") Then ExitLoop
            If Map_GetMapID() <> $ISSNUR Then ExitLoop
            Out("[FarmIssnur] -> zona skales " & ($sz + 1) & " (" & $aSkZ[$sz][0] & "," & $aSkZ[$sz][1] & ")")
            _FS_WalkToWaypoint($aSkZ[$sz][0], $aSkZ[$sz][1], 35000, 600)
            Local $tFight = TimerInit()
            While Not Bot_ShouldStop() And TimerDiff($tFight) < $FS_FIGHT_TIMEOUT_MS
                If Recovery_IsAtZero() Or Agent_GetAgentInfo(-2, "IsDead") Then ExitLoop
                If GetNearestEnemy(2500) = 0 Then ExitLoop
                Combat_ClearZone(1250, 25000)
            WEnd
        Next
        $g_bResignMode = True
        Chat_SendChat("resign", "/")
        Local $tRet = TimerInit()
        While Not Bot_ShouldStop() And TimerDiff($tRet) < 70000 And Map_GetMapID() = $ISSNUR
            If Party_GetPartyContextInfo("IsDefeated") Then Map_ReturnToOutpost(False)
            Sleep(2500)
        WEnd
        $g_bResignMode = False
        Sleep(2000)
    WEnd
    Out("[FarmIssnur] FAIL tras " & $iter & " iteraciones")
    Return False
EndFunc
Func Quest_FarmSunspear_Run($a_target = $FS_TARGET_POINTS, $a_skipClaim = False, $a_targetLevel = 0)
    If $a_targetLevel > 0 Then
        Out("[FarmSunspear] Start - target NIVEL " & $a_targetLevel & " (farmeo XP, sin bounty)")
    Else
        Out("[FarmSunspear] Start - target " & $a_target & " pts Sunspear" & ($a_skipClaim ? " (skipClaim)" : ""))
    EndIf
    If Map_GetMapID() <> $FS_OUTPOST_MAP_ID _
            Or Map_GetInstanceInfo("Type") <> $GC_I_MAP_TYPE_OUTPOST Then
        Out("[FarmSunspear] No en outpost farm (map=" & Map_GetMapID() & "), Travel_ToOutpost(" & $FS_OUTPOST_MAP_ID & ")")
        If Not Travel_ToOutpost($FS_OUTPOST_MAP_ID) Then
            Out("[FarmSunspear] FAIL travel a outpost farm, abortar")
            Return False
        EndIf
        Sleep(3000)
    EndIf
    If Not _FS_WaitOutpostLoaded(20000) Then
        Out("[FarmSunspear] outpost no termino de cargar (char en 0,0), reintento mas tarde")
        Return False
    EndIf
    Out("[FarmSunspear] Cargando skill template: " & $FS_SKILL_TEMPLATE)
    Attribute_LoadSkillTemplate($FS_SKILL_TEMPLATE)
    Sleep(2000)
    Cache_SkillBar()
    Out("[FarmSunspear] Calentamiento: cruzar portal y volver para fijar spawn point")
    _FS_FillParty(25000)
    _FS_SwapKihmForDPS()      
    If _FS_LearnCrossPortal($FS_PORTAL_CENTER_X, $FS_PORTAL_CENTER_Y, $FS_EXPLORABLE_MAP_ID, 90000) Then
        Sleep(3000)
        _FS_WarmupCrossBack()
        _FS_WaitInOutpost(30000)
        Out("[FarmSunspear] Calentamiento OK - spawn fijado junto al portal")
    Else
        Out("[FarmSunspear] Calentamiento FAIL - continuar sin fijar spawn")
    EndIf
    Local $iter = 0
    While $iter < $FS_MAX_ITERATIONS
        If Bot_ShouldStop() Then
            Out("[FarmSunspear] Stop signal, salir loop (farm incompleto - Return False para no marcar HoningYourSkills como done)")
            Return False
        EndIf
        $iter += 1
        If $a_targetLevel > 0 Then
            Local $lvl = Agent_GetAgentInfo(-2, "Level")
            Out("[FarmSunspear] Iter " & $iter & " - nivel=" & $lvl & "/" & $a_targetLevel & " (farmeo XP)")
            If $lvl >= $a_targetLevel Then
                Out("[FarmSunspear] OK - nivel " & $a_targetLevel & " alcanzado")
                Return True
            EndIf
        EndIf
        Local $pts = Sunspear_GetPoints()
        If $a_targetLevel = 0 Then Out("[FarmSunspear] Iter " & $iter & " - Sunspear pts=" & $pts & "/" & $a_target)
        If $a_targetLevel = 0 And $pts >= $a_target Then
            Sleep(1000)
            Local $pts2 = Sunspear_GetPoints()
            If $pts2 < $a_target Then
                Out("[FarmSunspear] WARN: lectura inestable pts=" & $pts & " pts2=" & $pts2 & " -> ignorar, seguir farmeando")
                ContinueLoop
            EndIf
            Out("[FarmSunspear] OK - target alcanzado (" & $pts & " pts)")
            If $a_skipClaim Then Return True
            Local $claimResult = _FS_ClaimRankReward()
            If $claimResult Then Return True
            If Sunspear_GetPoints() < $a_target Then
                Out("[FarmSunspear] Claim fallo y pts<target -> reanudar farm (lectura inestable)")
                ContinueLoop
            EndIf
            Return False
        EndIf
        If Not _FS_WaitInOutpost(30000) Then
            Local $tLoadW = TimerInit()
            While Not Bot_ShouldStop() And Map_GetInstanceInfo("IsLoading") And TimerDiff($tLoadW) < 120000
                Sleep(2000)
            WEnd
            If Not _FS_WaitInOutpost(10000) And Not Map_GetInstanceInfo("IsLoading") Then
                If Map_GetMapID() = $FS_OUTPOST_MAP_ID Then
                    Out("[FarmSunspear] En map " & $FS_OUTPOST_MAP_ID & " pero MaxHP=0 - Map_RndTravel para forzar recarga")
                    Map_RndTravel($FS_OUTPOST_MAP_ID, False)
                Else
                    Out("[FarmSunspear] No en outpost (map=" & Map_GetMapID() & ") tras 30s - Travel_ToOutpost fallback")
                    Travel_ToOutpost($FS_OUTPOST_MAP_ID)
                EndIf
                Sleep(3000)
            EndIf
            If Not _FS_WaitInOutpost(30000) Then
                Out("[FarmSunspear] FAIL: outpost no cargado tras fallback, abortar")
                Return False
            EndIf
        EndIf
        _FS_FillParty(25000)
        _FS_SwapKihmForDPS()   
        Out("[FarmSunspear] Cruzar portal con auto-learn")
        If Not _FS_LearnCrossPortal( _
                $FS_PORTAL_CENTER_X, $FS_PORTAL_CENTER_Y, _
                $FS_EXPLORABLE_MAP_ID, 90000) Then
            Out("[FarmSunspear] Fail cruzar portal, retry")
            ContinueLoop
        EndIf
        Sleep(3000)
        If $a_targetLevel > 0 Then
        ElseIf _FS_HasActiveBounty() Then
            Out("[FarmSunspear] Bounty Sunspear ya activo - skip NPC talk")
        Else
            Out("[FarmSunspear] Nav a NPC bounty + dialog 0x85")
            _FS_TalkToBountyNPC()
        EndIf
        Out("[FarmSunspear] Map_Move intermedio para romper fijacion al NPC")
        _FS_WalkToWaypoint($FS_PRE_FIGHT_X, $FS_PRE_FIGHT_Y, 15000, 600)
        Out("[FarmSunspear] Combate Ibogas")
        _FS_FightIbogas($FS_ENEMY_AREA_X, $FS_ENEMY_AREA_Y, $FS_FIGHT_TIMEOUT_MS)
        Sleep(4000)
        If Map_GetMapID() = $FS_EXPLORABLE_MAP_ID Then
            Out("[FarmSunspear] Paso 5: resign + return to outpost (defeated=" & Party_GetPartyContextInfo("IsDefeated") & ")")
            $g_bResignMode = True
            Local $rescuePrevResign = $g_GE_RescueEnabled
            $g_GE_RescueEnabled = False
            GameEvents_ResetStuck()
            Chat_SendChat("resign", "/")
            Local $tResignSent = TimerInit()
            Out("[FarmSunspear] /resign enviado")
            Local $tRet = TimerInit()
            Local $tLastReturn = TimerInit() - 99000
            While Not Bot_ShouldStop() And TimerDiff($tRet) < 75000 And Map_GetMapID() = $FS_EXPLORABLE_MAP_ID
                If Party_GetPartyContextInfo("IsDefeated") Then
                    If TimerDiff($tLastReturn) > 10000 Then
                        Map_ReturnToOutpost(False)
                        $tLastReturn = TimerInit()
                    EndIf
                ElseIf TimerDiff($tResignSent) > 15000 Then
                    Chat_SendChat("resign", "/")
                    $tResignSent = TimerInit()
                    Out("[FarmSunspear] /resign reenviado (cooldown 15s)")
                EndIf
                Sleep(2000)
            WEnd
            If Map_GetMapID() = $FS_EXPLORABLE_MAP_ID Then
                Out("[FarmSunspear] ReturnToOutpost fallo (75s), Travel_ToOutpost fallback")
                Travel_ToOutpost($FS_OUTPOST_MAP_ID)
            EndIf
            _FS_WaitInOutpost(45000)
            $g_GE_RescueEnabled = $rescuePrevResign
            $g_bResignMode = False
        EndIf
        Sleep(500)
    WEnd
    Out("[FarmSunspear] Max iteraciones alcanzado (" & $iter & ")")
    Return False
EndFunc
Func _FS_WorldReady()
    If Map_GetMapID() = 0 Then Return False
    If Map_GetInstanceInfo("IsLoading") Then Return False
    If Agent_GetAgentInfo(-2, "MaxHP") = 0 Then Return False
    Return True
EndFunc
Func _FS_WalkToWaypoint($x, $y, $timeoutMs = 30000, $tolerance = 500)
    If _FS_WorldReady() Then Map_Move($x, $y, 0)
    Local $t = TimerInit()
    While Not Bot_ShouldStop() And TimerDiff($t) < $timeoutMs
        If Not _FS_WorldReady() Then
            Sleep(500)
            ContinueLoop
        EndIf
        Local $dx = Agent_GetAgentInfo(-2, "X") - $x
        Local $dy = Agent_GetAgentInfo(-2, "Y") - $y
        Local $dist = Sqrt($dx*$dx + $dy*$dy)
        If $dist < $tolerance Then
            Out("[FS] Llegado a (" & $x & ", " & $y & ") tras " & Round(TimerDiff($t)/1000, 1) & "s (dist=" & Round($dist, 0) & "u)")
            Return True
        EndIf
        Sleep(500)
        If Mod(TimerDiff($t), 3000) < 500 And _FS_WorldReady() Then Map_Move($x, $y, 0)
    WEnd
    Out("[FS] TIMEOUT llegando a (" & $x & ", " & $y & ")")
    Return False
EndFunc
Func _FS_WaitPartyFull($timeoutMs = 10000)
    Local $t = TimerInit()
    Local $mapId = Map_GetMapID()
    Local $maxSize = Map_GetAreaInfo($mapId, "MaxPartySize")
    If $maxSize <= 1 Then Return True
    While Not Bot_ShouldStop() And TimerDiff($t) < $timeoutMs
        Local $heroes = Party_GetMyPartyInfo("ArrayHeroPartyMemberSize")
        Local $hench  = Party_GetMyPartyInfo("ArrayHenchmanPartyMemberSize")
        Local $size   = 1 + $heroes + $hench
        If $size >= $maxSize Then
            Out("[FS] Party lleno " & $size & "/" & $maxSize & " tras " & Round(TimerDiff($t)/1000, 1) & "s")
            Return True
        EndIf
        Sleep(300)
    WEnd
    Out("[FS] WaitPartyFull timeout " & Round($timeoutMs/1000, 0) & "s")
    Return False
EndFunc
Func _FS_WaitOutpostLoaded($maxMs = 20000)
    Local $t = TimerInit()
    While Not Bot_ShouldStop() And TimerDiff($t) < $maxMs
        If Not Map_GetInstanceInfo("IsLoading") _
           And Map_GetMapID() <> 0 _
           And Map_GetInstanceInfo("Type") = $GC_I_MAP_TYPE_OUTPOST Then
            Local $cx = Agent_GetAgentInfo(-2, "X"), $cy = Agent_GetAgentInfo(-2, "Y")
            If $cx <> 0 Or $cy <> 0 Then
                Sleep(1500)   
                Return True
            EndIf
        EndIf
        Sleep(500)
    WEnd
    Return False
EndFunc
Func _FS_SwapKihmForDPS()
    If Map_GetMapID() <> $FS_OUTPOST_MAP_ID Then Return False
    Local $nHench = Party_GetMyPartyInfo("ArrayHenchmanPartyMemberSize")
    Local $kihmAgentId = 0
    Local $hasDpsAlready = False
    For $i = 1 To $nHench
        Local $aid = Party_GetMyPartyHenchmanInfo($i, "AgentID")
        If $aid = 0 Then ContinueLoop
        Local $model = Agent_GetAgentInfo($aid, "PlayerNumber")
        If $model = $FS_KIHM_MODEL_CD Then $kihmAgentId = $aid
        If $model = $FS_DPS_HENCH_MODEL_CD Then $hasDpsAlready = True
    Next
    If $hasDpsAlready Then
        Out("[FS] SwapKihm: Timera ya en party - skip")
        Return True
    EndIf
    If $kihmAgentId <> 0 Then
        Out("[FS] SwapKihm: kickeando Kihm agent_id=" & $kihmAgentId)
        Party_KickNpc($kihmAgentId)
        Sleep(1500)
    EndIf
    Local $agents = Agent_GetAgentArray($GC_I_AGENT_TYPE_LIVING)
    If Not IsArray($agents) Or $agents[0] = 0 Then
        Out("[FS] SwapKihm: array agents vacio - reintentar luego")
        Return False
    EndIf
    For $i = 1 To $agents[0]
        Local $ptr = $agents[$i]
        If $ptr = 0 Then ContinueLoop
        If Agent_GetAgentInfo($ptr, "PlayerNumber") = $FS_DPS_HENCH_MODEL_CD Then
            Local $tid = Agent_GetAgentInfo($ptr, "ID")
            Out("[FS] SwapKihm: anyadiendo Timera agent_id=" & $tid)
            Ui_AddNPC($tid)
            Sleep(1500)
            Return True
        EndIf
    Next
    Out("[FS] SwapKihm: Timera (4589) no encontrada en outpost")
    Return False
EndFunc
Func _FS_FillParty($timeoutMs = 20000)
    Local $mapId   = Map_GetMapID()
    Local $maxSize = Map_GetAreaInfo($mapId, "MaxPartySize")
    If $maxSize <= 1 Then
        Out("[FS] FillParty: maxSize=" & $maxSize & " en map=" & $mapId & " -> nada que rellenar")
        Return True
    EndIf
    Local $tLoad = TimerInit()
    While Map_GetInstanceInfo("IsLoading") And TimerDiff($tLoad) < 10000
        Sleep(300)
    WEnd
    Sleep(1500)
    Local $curSize = 1 + Party_GetMyPartyInfo("ArrayHeroPartyMemberSize") _
                       + Party_GetMyPartyInfo("ArrayHenchmanPartyMemberSize")
    If $curSize >= $maxSize Then
        Out("[FS] FillParty: party ya llena " & $curSize & "/" & $maxSize & " -> skip todo")
        Return True
    EndIf
    If Map_GetMapID() = $FS_OUTPOST_MAP_ID Then
        Local $_cx = Agent_GetAgentInfo(-2, "X")
        Local $_cy = Agent_GetAgentInfo(-2, "Y")
        If $_cx = 0 And $_cy = 0 Then
            Out("[FS] FillParty: char en (0,0) - agente no poblado, skip caminata")
        Else
            Local $_distPortal = Sqrt(($_cx - $FS_PORTAL_CENTER_X)^2 + ($_cy - $FS_PORTAL_CENTER_Y)^2)
            If $_distPortal > 5000 Then
                Out("[FS] FillParty: spawn lejos del portal (" & Round($_distPortal) & "u) -> acercar a henchmen (23717,6408)")
                _FS_WalkToWaypoint(23717, 6408, 30000, 600)
                Sleep(800)
            Else
                Out("[FS] FillParty: char cerca del portal (" & Round($_distPortal) & "u) -> skip caminata a henchmen")
            EndIf
        EndIf
    EndIf
    _FS_LogHenchmenSeen()
    Local $t = TimerInit()
    While Not Bot_ShouldStop() And TimerDiff($t) < $timeoutMs
        Local $size = 1 + Party_GetMyPartyInfo("ArrayHeroPartyMemberSize") _
                        + Party_GetMyPartyInfo("ArrayHenchmanPartyMemberSize")
        If $size >= $maxSize Then
            Out("[FS] Party llena " & $size & "/" & $maxSize)
            Return True
        EndIf
        Party_FillWithHenchmen()
        Sleep(1000)
    WEnd
    Local $sz = 1 + Party_GetMyPartyInfo("ArrayHeroPartyMemberSize") _
                  + Party_GetMyPartyInfo("ArrayHenchmanPartyMemberSize")
    Out("[FS] FillParty fin - party " & $sz & "/" & $maxSize)
    Return ($sz >= $maxSize)
EndFunc
Func _FS_LogHenchmenSeen()
    Local $agents = Agent_GetAgentArray($GC_I_AGENT_TYPE_LIVING)
    If Not IsArray($agents) Or $agents[0] = 0 Then
        Out("[FS] HenchSeen: array de agentes vacio (aun cargando?)")
        Return
    EndIf
    Local $self = Agent_GetAgentInfo(-2, "ID")
    Local $n = 0
    Local $s = ""
    For $i = 1 To $agents[0]
        Local $ptr = $agents[$i]
        If $ptr = 0 Then ContinueLoop
        If Agent_GetAgentInfo($ptr, "ID") = $self Then ContinueLoop
        Local $model = Agent_GetAgentInfo($ptr, "PlayerNumber")
        If $model = 0 Then ContinueLoop   
        $n += 1
        $s &= " [m=" & $model & " h=" & Agent_GetAgentInfo($ptr, "IsHenchman") & " '" & Agent_GetAgentInfo($ptr, "Name") & "']"
    Next
    Out("[FS] AgentsSeen(NPC): " & $n & ":" & $s)
EndFunc
Func _FS_WarmupCrossBack()
    Local $cx = -19200, $cy = -13500
    Local $offsets[9][2] = [ _
        [0, 0], _
        [-800, 0], _
        [800, 0], _
        [0, 400], _
        [0, -400], _
        [-500, 400], _
        [-500, -400], _
        [500, 400], _
        [500, -400] _
    ]
    _FS_WalkToWaypoint($cx, $cy, 20000, 600)
    Local $t = TimerInit()
    Local $idx = 0
    Local $lastChange = TimerInit()
    Local $tReemit = TimerInit()
    Local $curX = $cx, $curY = $cy
    Map_Move($curX, $curY, 0)
    While Not Bot_ShouldStop() And TimerDiff($t) < 30000
        Local $now = Map_GetMapID()
        If $now = $FS_OUTPOST_MAP_ID Then
            Out("[FS] Warmup: de vuelta en CD tras " & Round(TimerDiff($t)/1000, 1) & "s")
            Return True
        EndIf
        If $now = 0 Or Map_GetInstanceInfo("IsLoading") Then
            Sleep(300)
            ContinueLoop
        EndIf
        Sleep(400)
        If Map_GetMapID() = $FS_OUTPOST_MAP_ID Then ContinueLoop
        If TimerDiff($tReemit) >= 2500 Then
            Map_Move($curX, $curY, 0)
            $tReemit = TimerInit()
        EndIf
        If TimerDiff($lastChange) >= 5000 Then
            $idx = Mod($idx + 1, 9)
            $curX = $cx + $offsets[$idx][0]
            $curY = $cy + $offsets[$idx][1]
            Map_Move($curX, $curY, 0)
            $lastChange = TimerInit()
            $tReemit = TimerInit()
        EndIf
    WEnd
    Out("[FS] Warmup: TIMEOUT cruce de vuelta, continuar sin fijar spawn")
    Return False
EndFunc
Func _FS_WaitInOutpost($timeoutMs = 30000)
    Local $t = TimerInit()
    While Not Bot_ShouldStop() And TimerDiff($t) < $timeoutMs
        If Map_GetMapID() = $FS_OUTPOST_MAP_ID _
                And Map_GetInstanceInfo("Type") = $GC_I_MAP_TYPE_OUTPOST _
                And Not Map_GetInstanceInfo("IsLoading") _
                And Agent_GetAgentInfo(-2, "MaxHP") > 0 Then
            Return True
        EndIf
        Sleep(500)
    WEnd
    Return False
EndFunc
Func _FS_TalkToBountyNPC()
    _FS_WalkToWaypoint($FS_NPC_BOUNTY_X, $FS_NPC_BOUNTY_Y, 30000, 260)
    Local $npc = Agent_GetAgentByPlayerNumber($FS_NPC_BOUNTY_MODEL)
    If $npc = 0 Then
        Out("[FS] FAIL: NPC bounty model " & $FS_NPC_BOUNTY_MODEL & " no encontrado")
        Return False
    EndIf
    For $try = 1 To 3
        Out("[FS] Bounty intento " & $try & "/3: ChangeTarget+GoNPC+Bot_Dialog(0x" & Hex($FS_NPC_BOUNTY_DIALOG, 2) & ")")
        Agent_ChangeTarget($npc)
        Sleep(300)
        Agent_GoNPC($npc)
        Sleep(1600)
        Bot_Dialog($FS_NPC_BOUNTY_DIALOG)
        Sleep(1200)
        If _FS_HasActiveBounty() Then
            Out("[FS] Bounty activado tras intento " & $try)
            ExitLoop
        EndIf
    Next
    If Not _FS_HasActiveBounty() Then
        Out("[FS] AVISO: bounty NO activo tras 3 intentos (NPC=" & $FS_NPC_BOUNTY_MODEL & " dialog=0x" & Hex($FS_NPC_BOUNTY_DIALOG, 2) & ") - rank no subira por kill")
    EndIf
    Agent_CancelAction()
    Sleep(100)
    Agent_ChangeTarget(0)
    Sleep(100)
    Agent_CancelAction()
    _FS_StepAwayFrom($FS_NPC_BOUNTY_X, $FS_NPC_BOUNTY_Y, 400, 3000)
    Return True
EndFunc
Func _FS_HasActiveBounty()
    For $i = 0 To UBound($GC_AI_REP_BUFFS_SUNSPEAR) - 1
        If Agent_GetAgentEffectInfo(-2, $GC_AI_REP_BUFFS_SUNSPEAR[$i]) <> 0 Then
            Out("[FS] Bounty activo: SkillID=" & $GC_AI_REP_BUFFS_SUNSPEAR[$i])
            Return True
        EndIf
    Next
    Return False
EndFunc
Func _FS_StepAwayFrom($x, $y, $minDist = 700, $timeoutMs = 12000)
    Local $myX = Agent_GetAgentInfo(-2, "X")
    Local $myY = Agent_GetAgentInfo(-2, "Y")
    Local $dx = $myX - $x
    Local $dy = $myY - $y
    Local $vlen = Sqrt($dx*$dx + $dy*$dy)
    If $vlen < 50 Then
        $dx = 1
        $dy = 1
        $vlen = Sqrt(2)
    EndIf
    Local $scale = ($minDist + 500) / $vlen
    Local $targetX = $myX + $dx * $scale
    Local $targetY = $myY + $dy * $scale
    Out("[FS] StepAwayFrom (" & $x & "," & $y & ") -> Map_Move(" & Round($targetX) & "," & Round($targetY) & ")")
    Map_Move($targetX, $targetY, 0)
    Local $t = TimerInit()
    While Not Bot_ShouldStop() And TimerDiff($t) < $timeoutMs
        $myX = Agent_GetAgentInfo(-2, "X")
        $myY = Agent_GetAgentInfo(-2, "Y")
        Local $distNow = Sqrt(($myX - $x)*($myX - $x) + ($myY - $y)*($myY - $y))
        If $distNow >= $minDist Then
            Out("[FS] StepAwayFrom OK (dist=" & Round($distNow) & "u tras " & Round(TimerDiff($t)/1000, 1) & "s)")
            Return True
        EndIf
        Sleep(500)
        If Mod(TimerDiff($t), 4000) < 500 Then Map_Move($targetX, $targetY, 0)
    WEnd
    Out("[FS] StepAwayFrom TIMEOUT")
    Return False
EndFunc
Func _FS_FightIbogas($x, $y, $timeoutMs)
    Local $startMap = Map_GetMapID()
    Local $t = TimerInit()
    Local $lastEnemySeen = TimerInit()
    Local $tProgress = TimerInit()    
    Local $rescuePrev = $g_GE_RescueEnabled
    $g_GE_RescueEnabled = False
    GameEvents_ResetStuck()
    Local $sLastX = 0, $sLastY = 0
    Local $tStuck = TimerInit()
    Local $tLastMapMove = TimerInit()
    Local $tMapZero = TimerInit()
    Local $lastSameTargetId = 0
    Local $lastSameTargetHP = 0
    Local $tSameTarget = TimerInit()
    Out("[FS] Navegando a zona ibogas (tolerancia 1000u)")
    _FS_WalkToWaypoint($x, $y, 20000, 1000)
    $lastEnemySeen = TimerInit()
    While Not Bot_ShouldStop() And TimerDiff($t) < $timeoutMs
        If Bot_ShouldStop() Then
            $g_GE_RescueEnabled = $rescuePrev
            Return
        EndIf
        If Party_GetPartyContextInfo("IsDefeated") Then
            Out("[FS] Party defeated tras " & Round(TimerDiff($t)/1000, 1) & "s - wait 3s por posible shrine revive")
            Sleep(3000)
            If Party_GetPartyContextInfo("IsDefeated") Then
                Out("[FS] IsDefeated sigue True, salir normalmente")
                $g_GE_RescueEnabled = $rescuePrev
                Return
            EndIf
            Out("[FS] Revivido en shrine - salir del combate para resignar limpiamente")
            $g_GE_RescueEnabled = $rescuePrev
            Return
        EndIf
        Local $now = Map_GetMapID()
        If $now = 0 Or Map_GetInstanceInfo("IsLoading") Or Agent_GetAgentInfo(-2, "MaxHP") = 0 Then
            If TimerDiff($tMapZero) > 30000 Then
                Out("[FS] mundo sin cargar (map=0/loading/MaxHP=0) >30s - salir del combate")
                $g_GE_RescueEnabled = $rescuePrev
                Return
            EndIf
            Sleep(1000)
            ContinueLoop
        EndIf
        $tMapZero = TimerInit()   
        If $now <> $startMap Then
            Out("[FS] Map cambio a " & $now & " (probable return auto)")
            $g_GE_RescueEnabled = $rescuePrev
            Return
        EndIf
        Local $enemy = _FS_GetNearestAnyEnemy(1600)
        Local $enemyFar = 0
        If $enemy = 0 Then
            $enemyFar = _FS_GetNearestEnemyToPoint($x, $y, 2200)
            Local $fbMX = Agent_GetAgentInfo(-2, "X"), $fbMY = Agent_GetAgentInfo(-2, "Y")
            Local $fbX = ($enemyFar <> 0 ? Agent_GetAgentInfo($enemyFar, "X") : 0)
            Local $fbY = ($enemyFar <> 0 ? Agent_GetAgentInfo($enemyFar, "Y") : 0)
            If $enemyFar <> 0 And Sqrt(($fbX - $fbMX)^2 + ($fbY - $fbMY)^2) < 1400 Then
                $enemy = $enemyFar
            EndIf
        EndIf
        If $enemy = 0 Then
            If $enemyFar <> 0 Then
                Local $afMX = Agent_GetAgentInfo(-2, "X"), $afMY = Agent_GetAgentInfo(-2, "Y")
                Local $afX = Agent_GetAgentInfo($enemyFar, "X"), $afY = Agent_GetAgentInfo($enemyFar, "Y")
                Local $afD = Sqrt(($afX - $afMX)^2 + ($afY - $afMY)^2)
                If $afD > 1400 And TimerDiff($tLastMapMove) > 4000 Then
                    Out("[FS] Acercandose a iboga lejana (dist=" & Round($afD) & "u)")
                    Map_Move($afX, $afY, 0)
                    $tLastMapMove = TimerInit()
                EndIf
                If TimerDiff($lastEnemySeen) > 12000 Then
                    Out("[FS] iboga lejana sin cerrar distancia tras 12s -> fin de combate (resign)")
                    $g_GE_RescueEnabled = $rescuePrev
                    Return
                EndIf
            ElseIf TimerDiff($lastEnemySeen) > 12000 Then
                Out("[FS] cluster limpio (sin enemies en 2200u del centro), fin de combate")
                $g_GE_RescueEnabled = $rescuePrev
                Return
            EndIf
            If $enemyFar = 0 Then
                Local $mxN = Agent_GetAgentInfo(-2, "X")
                Local $myN = Agent_GetAgentInfo(-2, "Y")
                If Sqrt(($mxN - $x)^2 + ($myN - $y)^2) > 1200 _
                        And TimerDiff($tLastMapMove) > 4000 Then
                    Map_Move($x, $y, 0)
                    $tLastMapMove = TimerInit()
                EndIf
            EndIf
            Sleep(1500)
            ContinueLoop
        EndIf
        $lastEnemySeen = TimerInit()
        Local $priPrev = $g_sCombatPriorityModels
        Local $lvl6 = _FS_GetNearestEnemyLevel(2200, 6)
        If $lvl6 <> 0 Then $g_sCombatPriorityModels = String(Agent_GetAgentInfo($lvl6, "PlayerNumber"))
        $g_iCombatLeashX = $x
        $g_iCombatLeashY = $y
        $g_iCombatLeashRange = 1800
        Local $prevEngage = $g_iCombatEngageTimeoutMs
        $g_iCombatEngageTimeoutMs = 8000
        Local $eHPnow = Agent_GetAgentInfo($enemy, "HP")
        If $enemy <> $lastSameTargetId Then
            $lastSameTargetId = $enemy
            $lastSameTargetHP = $eHPnow
            $tSameTarget = TimerInit()
        ElseIf $eHPnow < $lastSameTargetHP - 0.01 Then
            $lastSameTargetHP = $eHPnow
            $tSameTarget = TimerInit()
        ElseIf TimerDiff($tSameTarget) > 25000 Then
            Out("[FS] target " & $enemy & " 25s sin bajar HP -> inalcanzable, resignar")
            $g_sCombatPriorityModels = $priPrev
            $g_iCombatLeashRange = 0
            $g_iCombatEngageTimeoutMs = $prevEngage
            $g_GE_RescueEnabled = $rescuePrev
            Return
        EndIf
        Combat_ClearZone(1250, 20000)
        $g_iCombatEngageTimeoutMs = $prevEngage
        $g_iCombatLeashRange = 0
        $g_sCombatPriorityModels = $priPrev
        Sleep(300)
    WEnd
    Out("[FS] Timeout " & Round($timeoutMs/1000, 0) & "s en combate")
    $g_GE_RescueEnabled = $rescuePrev
EndFunc
Func _FS_GetNearestAnyEnemy($range)
    Local $agents = Agent_GetAgentArray($GC_I_AGENT_TYPE_LIVING)
    If Not IsArray($agents) Or $agents[0] = 0 Then Return 0
    Local $myX = Agent_GetAgentInfo(-2, "X")
    Local $myY = Agent_GetAgentInfo(-2, "Y")
    Local $closestId = 0
    Local $closestDist = 999999
    For $i = 1 To $agents[0]
        Local $ptr = $agents[$i]
        If $ptr = 0 Then ContinueLoop
        If Agent_GetAgentInfo($ptr, "Allegiance") <> $GC_I_ALLEGIANCE_ENEMY Then ContinueLoop
        If Agent_GetAgentInfo($ptr, "IsDead") Then ContinueLoop
        Local $aX = Agent_GetAgentInfo($ptr, "X")
        Local $aY = Agent_GetAgentInfo($ptr, "Y")
        Local $dist = Sqrt(($aX-$myX)*($aX-$myX) + ($aY-$myY)*($aY-$myY))
        If $dist > $range Then ContinueLoop
        If $dist < $closestDist Then
            $closestDist = $dist
            $closestId = Agent_GetAgentInfo($ptr, "ID")
        EndIf
    Next
    Return $closestId
EndFunc
Func _FS_GetNearestEnemyToPoint($cx, $cy, $range)
    Local $agents = Agent_GetAgentArray($GC_I_AGENT_TYPE_LIVING)
    If Not IsArray($agents) Or $agents[0] = 0 Then Return 0
    Local $closestId = 0
    Local $closestDist = 999999
    For $i = 1 To $agents[0]
        Local $ptr = $agents[$i]
        If $ptr = 0 Then ContinueLoop
        If Agent_GetAgentInfo($ptr, "Allegiance") <> $GC_I_ALLEGIANCE_ENEMY Then ContinueLoop
        If Agent_GetAgentInfo($ptr, "IsDead") Then ContinueLoop
        If Agent_GetAgentInfo($ptr, "HP") <= 0 Then ContinueLoop
        Local $aX = Agent_GetAgentInfo($ptr, "X")
        Local $aY = Agent_GetAgentInfo($ptr, "Y")
        Local $dist = Sqrt(($aX-$cx)*($aX-$cx) + ($aY-$cy)*($aY-$cy))
        If $dist > $range Then ContinueLoop
        If $dist < $closestDist Then
            $closestDist = $dist
            $closestId = Agent_GetAgentInfo($ptr, "ID")
        EndIf
    Next
    Return $closestId
EndFunc
Func _FS_GetNearestEnemyLevel($range, $level)
    Local $agents = Agent_GetAgentArray($GC_I_AGENT_TYPE_LIVING)
    If Not IsArray($agents) Or $agents[0] = 0 Then Return 0
    Local $myX = Agent_GetAgentInfo(-2, "X")
    Local $myY = Agent_GetAgentInfo(-2, "Y")
    Local $closestId = 0
    Local $closestDist = 999999
    For $i = 1 To $agents[0]
        Local $ptr = $agents[$i]
        If $ptr = 0 Then ContinueLoop
        If Agent_GetAgentInfo($ptr, "Allegiance") <> $GC_I_ALLEGIANCE_ENEMY Then ContinueLoop
        If Agent_GetAgentInfo($ptr, "IsDead") Then ContinueLoop
        If Agent_GetAgentInfo($ptr, "Level") <> $level Then ContinueLoop
        Local $aX = Agent_GetAgentInfo($ptr, "X")
        Local $aY = Agent_GetAgentInfo($ptr, "Y")
        Local $dist = Sqrt(($aX-$myX)*($aX-$myX) + ($aY-$myY)*($aY-$myY))
        If $dist > $range Then ContinueLoop
        If $dist < $closestDist Then
            $closestDist = $dist
            $closestId = Agent_GetAgentInfo($ptr, "ID")
        EndIf
    Next
    Return $closestId
EndFunc
Func _FS_LearnCrossPortal($centerX, $centerY, $targetMap, $totalTimeoutMs = 90000)
    Local $iniFile = @ScriptDir & "\config.ini"
    Local $section = "FarmSunspear"
    Local $tGlobal = TimerInit()
    If Map_GetMapID() = $targetMap Then
        Out("[FS] LearnCrossPortal: ya estamos en map " & $targetMap & " - skip")
        Return True
    EndIf
    Out("[FS] LearnCrossPortal fase 1: centro (" & $centerX & ", " & $centerY & ")")
    _FS_WalkToWaypoint($centerX, $centerY, 25000, 250)
    Sleep(500)
    Local $savedX = Int(IniRead($iniFile, $section, "PortalForwardX", "0"))
    Local $savedY = Int(IniRead($iniFile, $section, "PortalForwardY", "0"))
    If $savedX <> 0 And $savedY <> 0 Then
        Out("[FS] Probando coord guardada (" & $savedX & ", " & $savedY & ")")
        Map_Move($savedX, $savedY, 0)
        Local $tFirst = TimerInit()
        Local $tReemit = TimerInit()
        While TimerDiff($tFirst) < 8000
            Local $mNow = Map_GetMapID()
            If $mNow = $targetMap Then
                WaitLoading()
                Out("[FS] Cruzado con coord guardada en " & Round(TimerDiff($tFirst)/1000, 1) & "s")
                Return True
            EndIf
            If $mNow = 0 Then
                Sleep(500)
                ContinueLoop
            EndIf
            If TimerDiff($tReemit) > 3000 Then
                Map_Move($savedX, $savedY, 0)
                $tReemit = TimerInit()
            EndIf
            Sleep(400)
        WEnd
        Out("[FS] Coord guardada no funciono, iniciar barrido")
    EndIf
    Local $offsets[20][2] = [ _
        [0, 1500], _
        [500, 1500], _
        [-500, 1500], _
        [1000, 1500], _
        [-1000, 1500], _
        [0, 2500], _
        [500, 2500], _
        [-500, 2500], _
        [1000, 2500], _
        [-1000, 2500], _
        [0, 800], _
        [500, 800], _
        [-500, 800], _
        [0, 4000], _
        [500, 4000], _
        [-500, 4000], _
        [2000, 1500], _
        [-2000, 1500], _
        [2000, 2500], _
        [-2000, 2500] _
    ]
    Local $idx = 0
    Local $lastChange = TimerInit()
    Local $tReemit2 = TimerInit()
    Local $nx = $centerX + $offsets[0][0]
    Local $ny = $centerY + $offsets[0][1]
    Map_Move($nx, $ny, 0)
    Out("[FS] Barrido idx=0 -> (" & $nx & ", " & $ny & ")")
    While Not Bot_ShouldStop() And TimerDiff($tGlobal) < $totalTimeoutMs
        Local $now = Map_GetMapID()
        If $now = $targetMap Then
            Local $successX = $centerX + $offsets[$idx][0]
            Local $successY = $centerY + $offsets[$idx][1]
            Out("[FS] CRUZADO! Forward exitoso=(" & $successX & ", " & $successY & ") guardado en config.ini")
            IniWrite($iniFile, $section, "PortalForwardX", String($successX))
            IniWrite($iniFile, $section, "PortalForwardY", String($successY))
            WaitLoading()
            Return True
        EndIf
        If $now = 0 Then
            Sleep(500)
            ContinueLoop
        EndIf
        Sleep(400)
        If TimerDiff($tReemit2) >= 2500 Then
            Map_Move($nx, $ny, 0)
            $tReemit2 = TimerInit()
        EndIf
        If TimerDiff($lastChange) >= 5000 Then
            $idx = Mod($idx + 1, UBound($offsets))
            $nx = $centerX + $offsets[$idx][0]
            $ny = $centerY + $offsets[$idx][1]
            Out("[FS] Barrido idx=" & $idx & " -> (" & $nx & ", " & $ny & ")")
            Map_Move($nx, $ny, 0)
            $lastChange = TimerInit()
            $tReemit2 = TimerInit()
        EndIf
    WEnd
    Out("[FS] LearnCrossPortal TIMEOUT - no se pudo cruzar")
    Return False
EndFunc
Func _FS_CrossPortalPrecise($centerX, $centerY, $forwardX, $forwardY, $targetMap, $totalTimeoutMs = 45000)
    Local $t = TimerInit()
    Out("[FS] CrossPortalPrecise fase 1: centro (" & $centerX & ", " & $centerY & ")")
    _FS_WalkToWaypoint($centerX, $centerY, 25000, 200)
    Sleep(500)
    If TimerDiff($t) >= $totalTimeoutMs Then Return False
    Out("[FS] CrossPortalPrecise fase 2: forward (" & $forwardX & ", " & $forwardY & ")")
    Map_Move($forwardX, $forwardY, 0)
    Local $lastRetry = TimerInit()
    While Not Bot_ShouldStop() And TimerDiff($t) < $totalTimeoutMs
        Local $now = Map_GetMapID()
        If $now = $targetMap Then
            WaitLoading()
            Out("[FS] Cruzado portal a map " & $targetMap & " tras " & Round(TimerDiff($t)/1000, 1) & "s")
            Return True
        EndIf
        Sleep(500)
        If TimerDiff($lastRetry) >= 5000 Then
            Map_Move($forwardX, $forwardY, 0)
            $lastRetry = TimerInit()
        EndIf
    WEnd
    Out("[FS] CrossPortalPrecise TIMEOUT")
    Return False
EndFunc
Func _FS_ClaimRankReward()
    Local $ptsA = Sunspear_GetPoints()
    Sleep(500)
    Local $ptsB = Sunspear_GetPoints()
    If $ptsA < $FS_TARGET_POINTS Or $ptsB < $FS_TARGET_POINTS Then
        Out("[FS] ClaimRankReward ABORT: pts inestables ptsA=" & $ptsA & " ptsB=" & $ptsB & " <" & $FS_TARGET_POINTS & " - volver a farm")
        Return False
    EndIf
    Out("[FS] ClaimRankReward: viajando a Sunspear Great Hall (431) - pts confirmados " & $ptsA & "/" & $ptsB)
    If Not Travel_ToOutpost(431) Then
        Out("[FS] FAIL travel a mapa 431")
        Return False
    EndIf
    Local $ls649 = Quest_GetQuestInfo(649, "LogState")
    Local $ls715 = Quest_GetQuestInfo(715, "LogState")
    Out("[FS] DIAG: pts=" & Sunspear_GetPoints() & " q649=" & $ls649 & " q715=" & $ls715)
    If $ls649 <> -1 And $ls649 <> 0 Then
        Out("[FS] Quest 649 pendiente, cobrar primero")
        If _Quests_NavAndOpenDialog(-2866, 7093, 4751) Then
            Ui_RewardQuest(649)
            Sleep(6000)   
        EndIf
    EndIf
    Local $attempt = 0
    $g_GE_Quest715Removed = False
    While $attempt < 3
        $attempt += 1
        Out("[FS] Intento " & $attempt & "/3 cobrar quest 715")
        If Not _Quests_NavAndOpenDialog(-2866, 7093, 4751) Then
            Out("[FS] FAIL NavAndOpenDialog intento " & $attempt)
            Sleep(2000)
            ContinueLoop
        EndIf
        Ui_AboutQuest(715)
        Sleep(4000)
        Ui_AcceptQuest(715)
        Sleep(4000)
        Ui_RewardQuest(715)
        Sleep(6000)
        $ls715 = Quest_GetQuestInfo(715, "LogState")
        Out("[FS] Post-intento " & $attempt & ": q715 LogState=" & $ls715 & " removed=" & $g_GE_Quest715Removed)
        If $ls715 = -1 Or $ls715 = 0 Or $g_GE_Quest715Removed Then
            Out("[FS] OK quest 715 cobrada en intento " & $attempt)
            Out("[FS] Re-nav NPC 4751 -> accept quest 716 (Rising in the Ranks: First Spear)")
            If _Quests_NavAndOpenDialog(-2866, 7093, 4751) Then
                Ui_AcceptQuest(716)
                Sleep(2500)
                Out("[FS] OK Ui_AcceptQuest(716) enviado")
                Out("[FS] Esperando reward dialog quest 716 (5s)...")
                Sleep(5000)
                Ui_RewardQuest(716)
                Sleep(2500)
                Out("[FS] OK Ui_RewardQuest(716) enviado (First Spear reward: 2000 XP + 15 attr pts)")
            Else
                Out("[FS] WARN: no se pudo abrir dialogo para aceptar quest 716")
            EndIf
            Return True
        EndIf
    WEnd
    Out("[FS] FAIL quest 715 no cobrada tras 3 intentos")
    If Sunspear_GetPoints() >= $FS_TARGET_POINTS Then
        Out("[FS] pts=" & Sunspear_GetPoints() & ">=" & $FS_TARGET_POINTS & " -> Return True aunque fallo dialog")
        Return True
    EndIf
    Return False
EndFunc
Func _FS_ForceCrossPortal($baseX, $baseY, $targetMap, $totalTimeoutMs = 60000)
    Local $offsets[9][2] = [ _
        [0, 0], _
        [800, 0], _
        [-800, 0], _
        [0, 400], _
        [0, -400], _
        [500, 400], _
        [500, -400], _
        [-500, 400], _
        [-500, -400] _
    ]
    Local $t = TimerInit()
    Local $idx = 0
    Local $lastChange = TimerInit()
    Local $tReemit = TimerInit()
    Local $curX = $baseX, $curY = $baseY
    Map_Move($curX, $curY, 0)
    Out("[FS] ForceCrossPortal centro (" & $baseX & ", " & $baseY & ")")
    While Not Bot_ShouldStop() And TimerDiff($t) < $totalTimeoutMs
        Local $now = Map_GetMapID()
        If $now = $targetMap Then
            WaitLoading()
            Out("[FS] Cruzado portal a map " & $targetMap & " tras " & Round(TimerDiff($t)/1000, 1) & "s")
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
            Out("[FS] ForceCrossPortal reintento idx=" & $idx & " Map_Move(" & $curX & ", " & $curY & ")")
            Map_Move($curX, $curY, 0)
            $lastChange = TimerInit()
            $tReemit = TimerInit()
        EndIf
    WEnd
    Return False
EndFunc
Global Const $BSK_KAMADAN_MAP_ID  = $GC_I_MAP_ID_KAMADAN_JEWEL_OF_ISTAN   
Global Const $BSK_SUNSPEAR_MAP_ID = $GC_I_MAP_ID_SUNSPEAR_GREAT_HALL      
Global Const $BSK_MERCHANT_MODEL  = $GC_I_MODEL_ID_NF_GENERIC_A   
Global Const $BSK_MERCHANT_X      = -11408
Global Const $BSK_MERCHANT_Y      = 15491
Global Const $BSK_SKILL_ZEALOUS_RENEWAL        = $GC_I_SKILL_ID_ZEALOUS_RENEWAL        
Global Const $BSK_SKILL_SUNSPEAR_REBIRTH_SIGNET = $GC_I_SKILL_ID_SUNSPEAR_REBIRTH_SIGNET 
Global Const $BSK_SKILL_PIOUS_ASSAULT           = $GC_I_SKILL_ID_PIOUS_ASSAULT          
Global Const $BSK_TRAINER_MODEL   = $GC_I_MODEL_ID_NF_GENERIC_A   
Global Const $BSK_TRAINER_X       = -3317
Global Const $BSK_TRAINER_Y       = 7053
Global Const $BSK_DIALOG_SUNSPEAR_MENU  = 0x801101   
Global Const $BSK_DIALOG_WHIRLWIND      = 0x883B03   
Global Const $BSK_DIALOG_VAMPIRISM      = 0x883E03   
Global Const $BSK_DIALOG_MONK_MENU      = 0x800300   
Global Const $BSK_DIALOG_SIGNET_DEV     = 0x812502   
Global Const $BSK_REWARD_MODEL    = $GC_I_MODEL_ID_NF_GENERIC_A   
Global Const $BSK_REWARD_X        = -2866
Global Const $BSK_REWARD_Y        = 7093
Global Const $BSK_DIALOG_REWARD   = 0x84             
Global Const $BSK_QUEST_716       = $GC_I_QUEST_ID_RISINGINTHERANKS_FIRSTSPEAR 
Global Const $BSK_DIALOG_716_ABOUT  = 0x82CC03       
Global Const $BSK_DIALOG_716_ACCEPT = 0x82CC01       
Global Const $BSK_DIALOG_716_REWARD = 0x82CC07       
Func Quest_BuySkillsKamadan_Run()
    Out("[BuySkillsKamadan] Start - Kamadan: comprar Gash + Zealous Renewal")
    Out("[BSK] Travel a Kamadan (" & $BSK_KAMADAN_MAP_ID & ")")
    If Not Travel_ToOutpost($BSK_KAMADAN_MAP_ID) Then
        Out("[BSK] FAIL travel a Kamadan")
        Return False
    EndIf
    Out("[BSK] Nav a Skill Merchant 4751 (" & $BSK_MERCHANT_X & ", " & $BSK_MERCHANT_Y & ")")
    If Not _Quests_NavAndOpenDialog($BSK_MERCHANT_X, $BSK_MERCHANT_Y, $BSK_MERCHANT_MODEL) Then
        Out("[BSK] FAIL nav/dialog Skill Merchant")
        Return False
    EndIf
    Local $bskSkills[3] = [$BSK_SKILL_ZEALOUS_RENEWAL, $BSK_SKILL_SUNSPEAR_REBIRTH_SIGNET, $BSK_SKILL_PIOUS_ASSAULT]
    Local $bskNames[3] = ["Zealous Renewal", "Sunspear Rebirth Signet", "Pious Assault"]
    For $bskI = 0 To 2
        If World_IsSkillLearnt($bskSkills[$bskI]) Then
            Out("[BSK] " & $bskNames[$bskI] & " (" & $bskSkills[$bskI] & ") ya aprendida -> skip")
            ContinueLoop
        EndIf
        For $bskA = 1 To 2
            Out("[BSK] Skill_BuySkillByID(" & $bskSkills[$bskI] & ") -> " & $bskNames[$bskI] & " intento " & $bskA)
            Skill_BuySkillByID($bskSkills[$bskI])
            Sleep(2500)
            If World_IsSkillLearnt($bskSkills[$bskI]) Then ExitLoop
        Next
        If World_IsSkillLearnt($bskSkills[$bskI]) Then
            Out("[BSK] Compra OK: " & $bskNames[$bskI] & " (" & $bskSkills[$bskI] & ") aprendida")
        Else
            Out("[BSK] Compra FALLO: " & $bskNames[$bskI] & " (" & $bskSkills[$bskI] & ") NO aprendida tras 2 intentos (Â¿sin oro / skill points?)")
        EndIf
    Next
    Out("[BSK] Paso 2: Travel a Sunspear Great Hall (" & $BSK_SUNSPEAR_MAP_ID & ")")
    If Not Travel_ToOutpost($BSK_SUNSPEAR_MAP_ID) Then
        Out("[BSK] FAIL travel a Sunspear Great Hall")
        Return False
    EndIf
    Sleep(1500)
    Out("[BSK] Nav a Sunspear Trainer 4751 (" & $BSK_TRAINER_X & "," & $BSK_TRAINER_Y & ")")
    If Not _Quests_NavAndOpenDialog($BSK_TRAINER_X, $BSK_TRAINER_Y, $BSK_TRAINER_MODEL) Then
        Out("[BSK] FAIL nav/dialog Sunspear Trainer")
        Return False
    EndIf
    Out("[BSK] (hero skills Whirlwind/Vampirism DEFERIDAS a fin de fase 05 - aÃºn sin hero skill points)")
    Out("[BSK] Paso 3: Nav a reward NPC 4751 (" & $BSK_REWARD_X & "," & $BSK_REWARD_Y & ")")
    If Not _Quests_NavAndOpenDialog($BSK_REWARD_X, $BSK_REWARD_Y, $BSK_REWARD_MODEL) Then
        Out("[BSK] WARN: no se pudo abrir dialog reward NPC - continuando")
    Else
        Out("[BSK] Bot_Dialog(0x84) -> recoger reward/blessing")
        Bot_Dialog($BSK_DIALOG_REWARD)
        Sleep(1500)
    EndIf
    Out("[BSK] Volver a Kamadan para quest 649")
    If Not Travel_ToOutpost($BSK_KAMADAN_MAP_ID) Then
        Out("[BSK] FAIL travel a Kamadan (post-Sunspear)")
        Return False
    EndIf
    Sleep(1000)
    Out("[BSK] Nav a First Spear Dehvad 4751 (-7874, 9799) -> reward quest 649")
    If Not _Quests_NavAndOpenDialog(-7874, 9799, 4751, "Dehvad") Then
        Out("[BSK] FAIL nav/dialog First Spear Dehvad")
        Return False
    EndIf
    Ui_RewardQuest(649)
    Sleep(2000)
    Out("[BSK] OK quest 649 cobrada (500 XP + 250 Gold + 10 Sunspear pts)")
    Out("[BSK] Re-nav a First Spear Dehvad -> accept quest 601 (secondary professions)")
    If Not _Quests_NavAndOpenDialog(-7874, 9799, 4751, "Dehvad") Then
        Out("[BSK] WARN: no se pudo re-abrir dialog para quest 601")
    Else
        Ui_AcceptQuest(601)
        Sleep(2000)
        Out("[BSK] OK quest 601 aceptada (500 XP + 200 Gold + 5 Sunspear pts + Battle Commendation)")
    EndIf
    Out("[BSK] OK - fase completada.")
    Return True
EndFunc
Func _BSK_CloseSkillPopup()
    Bot_Dialog(0x9)
    Sleep(400)
    Bot_Dialog(0x80)
    Sleep(400)
    Local $hWin = WinGetHandle("[CLASS:ArenaNet_Dx_Window_Class]")
    If $hWin Then ControlSend($hWin, "", "", "{ESC}")
    Sleep(1500)
EndFunc
Global Const $SSB_MAP_ID           = $GC_I_MAP_ID_JOKANUR_DIGGINGS_OUTPOST 
Global Const $SSB_CHAR_TEMPLATE    = "OgGikms2cV+vD4xLXZcbfFA"  
Global Const $SSB_KOSS_TEMPLATE    = "OQATEFqVj4q+FwBWocNACAA"     
Global Const $SSB_DUNKORO_TEMPLATE = "OwAT0wHCnZlkRAJtE66dteETAA"  
Global Const $SSB_ODURRA_MODEL     = $GC_I_MODEL_ID_NF_ODURRA      
Func Quest_SetupSkillBar_Run()
    Out("[SetupSkillBar] Start - Travel a Champion's Dawn + Jokanur Diggings + cargar skill bars")
    Out("[SSB] Esperando a que AutoParty anada heroes (max 15s)...")
    Local $tWait = TimerInit()
    While Not Bot_ShouldStop() And TimerDiff($tWait) < 15000
        Local $hKoss = _AutoLevel_FindHeroSlot($GC_I_HERO_ID_KOSS)
        Local $hDunk = _AutoLevel_FindHeroSlot($GC_I_HERO_ID_DUNKORO)
        If $hKoss > 0 And $hDunk > 0 Then
            Out("[SSB] Koss y Dunkoro en party tras " & Round(TimerDiff($tWait)/1000, 1) & "s")
            ExitLoop
        EndIf
        Sleep(1000)
    WEnd
    If _AutoLevel_FindHeroSlot($GC_I_HERO_ID_KOSS) = 0 Then
        Out("[SSB] Koss no en party tras 15s -> Heroes_Add('Koss') manual")
        Heroes_Add("Koss")
        Sleep(1000)
    EndIf
    If _AutoLevel_FindHeroSlot($GC_I_HERO_ID_DUNKORO) = 0 Then
        Out("[SSB] Dunkoro no en party tras 15s -> Heroes_Add('Dunkoro') manual")
        Heroes_Add("Dunkoro")
        Sleep(1000)
    EndIf
    Out("[SSB] Char: Attribute_LoadSkillTemplate -> " & $SSB_CHAR_TEMPLATE)
    Attribute_LoadSkillTemplate($SSB_CHAR_TEMPLATE)
    Sleep(1000)
    Local $kossSlot = _AutoLevel_FindHeroSlot($GC_I_HERO_ID_KOSS)
    If $kossSlot > 0 Then
        Out("[SSB] Koss (slot " & $kossSlot & "): Attribute_LoadSkillTemplate")
        Attribute_LoadSkillTemplate($SSB_KOSS_TEMPLATE, $kossSlot)
        Sleep(1000)
    Else
        Out("[SSB] WARN: Koss no encontrado en party")
    EndIf
    Local $dunkoroSlot = _AutoLevel_FindHeroSlot($GC_I_HERO_ID_DUNKORO)
    If $dunkoroSlot > 0 Then
        Out("[SSB] Dunkoro (slot " & $dunkoroSlot & "): Attribute_LoadSkillTemplate")
        Attribute_LoadSkillTemplate($SSB_DUNKORO_TEMPLATE, $dunkoroSlot)
        Sleep(1000)
    Else
        Out("[SSB] WARN: Dunkoro no encontrado en party")
    EndIf
    If Map_IsOutpost(Map_GetMapID()) Then
        If _SSB_IsHenchmanInParty($SSB_ODURRA_MODEL) Then
            Out("[SSB] Odurra ya en party - skip add")
        Else
            Local $myX = Agent_GetAgentInfo(-2, "X")
            Local $myY = Agent_GetAgentInfo(-2, "Y")
            Local $odurraAgent = _Quests_FindNearestNPCByModelToWp($SSB_ODURRA_MODEL, $myX, $myY)
            If $odurraAgent > 0 Then
                Out("[SSB] Odurra (agent " & $odurraAgent & "): Party_AddNpc")
                Party_AddNpc($odurraAgent)
                Sleep(1500)
            Else
                Out("[SSB] WARN: Odurra (Model " & $SSB_ODURRA_MODEL & ") no encontrada en outpost")
            EndIf
        EndIf
    EndIf
    Out("[SSB] OK - skill bars cargadas (char + Koss + Dunkoro).")
    Return True
EndFunc
Func _SSB_IsHenchmanInParty($modelId)
    Local $henchCount = Party_GetMyPartyInfo("HenchmenCount")
    If @error Or $henchCount <= 0 Then Return False
    For $i = 1 To $henchCount
        Local $hAgentId = Party_GetMyPartyHenchmanInfo($i, "AgentID")
        If $hAgentId = 0 Then ContinueLoop
        Local $hModel = Agent_GetAgentInfo($hAgentId, "PlayerNumber")
        If $hModel = $modelId Then Return True
    Next
    Return False
EndFunc