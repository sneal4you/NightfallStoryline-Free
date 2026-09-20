#include-once
Func Quest_TheHonorableGeneral_Run()
    Out("[TheHonorableGeneral] Delegando a Quest_RecruitMorgahn_Run")
    Local $priPrev = $g_sCombatPriorityModels
    $g_sCombatPriorityModels = IniRead($g_sConfigFile, "Debug", "THG_PriorityModels", "5382,5384")
    Local $ok = Quest_RecruitMorgahn_Run()
    $g_sCombatPriorityModels = $priPrev
    Return $ok
EndFunc
Global Const $RM_OUTPOST_MAP_ID  = $GC_I_MAP_ID_JOKANUR_DIGGINGS_OUTPOST 
Global Const $RM_EXPLORE_MAP_ID  = $GC_I_MAP_ID_ZEHLON_REACH             
Global Const $RM_PREPORTAL_X = 4136
Global Const $RM_PREPORTAL_Y = 4426
Global Const $RM_PORTAL_X = 4448
Global Const $RM_PORTAL_Y = 4488
Global Const $RM_MORGAHN_MODEL   = $GC_I_MODEL_ID_NF_MORGAHN       
Global Const $RM_MORGAHN_X       = 17327
Global Const $RM_MORGAHN_Y       = -4966
Global Const $RM_DIALOG_INTRO    = 0x827904   
Global Const $RM_DIALOG_READY    = 0x84       
Global Const $RM_ODURRA_MODEL    = $GC_I_MODEL_ID_NF_ODURRA        
Global Const $RM_BOSS_MODEL      = $GC_I_MODEL_ID_NF_CORSAIR_CAPTAIN 
Global Const $RM_BOSS_RANGE      = 2000       
Global Const $RM_BOSS_KILL_TIME  = 60000      
Global Const $RM_BOSS_TOTAL_TIME = 180000     
Global Const $RM_POSTPORTAL_X       = 19825
Global Const $RM_POSTPORTAL_Y       = -3170
Global Const $RM_DEST_MAP_ID        = $GC_I_MAP_ID_THE_ASTRALARIUM   
Global Const $RM_REWARD_NPC_MODEL   = $GC_I_MODEL_ID_NF_DAJMIR      
Global Const $RM_REWARD_NPC_X       = -1805
Global Const $RM_REWARD_NPC_Y       = 3804
Global Const $RM_DIALOG_REWARD_633  = 0x827907       
Global Const $RM_DIALOG_ACCEPT_634  = 0x827A01       
Global Const $RM_ASTRA_PORTAL_X     = -4658     
Global Const $RM_ASTRA_PORTAL_Y     = 212
Global Const $RM_ZEHLON_NORTH_X     = 19688     
Global Const $RM_ZEHLON_NORTH_Y     = -3759
Global Const $RM_SP_NPC_X      = 16612      
Global Const $RM_SP_NPC_Y      = -3692
Global Const $RM_SP_DIALOG     = 0x827A04   
Global Const $RM_QUEST_634     = $GC_I_QUEST_ID_SIGNSANDPORTENTS    
Global Const $RM_M02_NPC_MODEL = $GC_I_MODEL_ID_NF_GENERIC_B       
Global Const $RM_M02_NPC_X     = 2888
Global Const $RM_M02_NPC_Y     = 2207
Global Const $RM_M02_DIALOG_1  = 0x81      
Global Const $RM_M02_DIALOG_2  = 0x84      
Global $RM_STEPS[14][5] = [ _
    ["nav_combat", -14495, -17561, "WP1 enemies 4433",                  0], _
    ["nav_combat", -10670, -18098, "WP2 enemies 4434",                  0], _
    ["nav_combat",  -8846, -16605, "WP3 transito",                      0], _
    ["nav_combat",  -4112, -15981, "WP4 transito",                      0], _
    ["nav_combat",   -453, -13103, "WP5 transito",                      0], _
    ["nav_combat",   1462, -11725, "WP6 enemies 4432",                  0], _
    ["nav_combat",   2573, -10775, "WP7 enemies 4440",                  0], _
    ["nav_combat",   4241, -10177, "WP8 transito",                      0], _
    ["nav_combat",   5373,  -9264, "WP9 transito",                      0], _
    ["nav_combat",   7710,  -7198, "WP10 enemies 4442",                 0], _
    ["nav_combat",   9795,  -4933, "WP11 enemies 4419",                 0], _
    ["nav_combat",  11207,  -3756, "WP12 enemies 4433",                 0], _
    ["nav_combat",  10551,  -4420, "WP13 enemies 4433",                 0], _
    ["nav_combat",  13484,  -2496, "WP14 enemies 4433 (pre-Morgahn)",   0]  _
]
Func Quest_RecruitMorgahn_Run()
    Out("[RecruitMorgahn] Delegando a Quest_RM_Step1_ExitToZehlon (flow Astralarium)")
    Return Quest_RM_Step1_ExitToZehlon()
EndFunc
Func Quest_RM_Step1_ExitToZehlon()
    Out("[RM-Step1] Flujo: 1) Dajmir Astralarium -> 2) Zehlon S&P -> 3) Jokanur M02")
    If Map_GetMapID() <> $RM_DEST_MAP_ID Then
        Out("[RM-Step1] Travel_ToOutpost Astralarium (" & $RM_DEST_MAP_ID & ")")
        If Not Travel_ToOutpost($RM_DEST_MAP_ID) Then
            Out("[RM-Step1] FAIL: no se pudo viajar a Astralarium")
            Return False
        EndIf
        Sleep(2000)
    EndIf
    Local $q634pre = Quest_GetQuestInfo($RM_QUEST_634, "LogState")
    Local $q633pre = Quest_GetQuestInfo(633, "LogState")
    If $q634pre > 0 And $q633pre <> 33 And $q633pre <> 35 Then
        Out("[RM-Step1] Quest 634 activa (ls=" & $q634pre & ") y 633 cobrada (ls=" & $q633pre & ") -> skip Dajmir talk")
    Else
        Local $q633ls = Quest_GetQuestInfo(633, "LogState")
        Out("[RM-Step1] q633 LogState=" & $q633ls)
        If $q633ls <> 35 Then
            Out("[RM-Step1] q633 ls=" & $q633ls & " (no es 35) -> ir a Zehlon a reclutar Morgahn")
            If Not _RM_LegacyZehlonMorgahnFlow() Then Return False
            If Map_GetMapID() <> $RM_DEST_MAP_ID Then
                If Not Travel_ToOutpost($RM_DEST_MAP_ID) Then Return False
                Sleep(2000)
            EndIf
        EndIf
        If Quest_GetQuestInfo($RM_QUEST_634, "LogState") > 0 Then
            Out("[RM-Step1] Quest 634 ya activa tras el flujo -> skip re-cobro Dajmir")
        Else
            If Not _RM_TalkDajmirRewardAndAccept() Then Return False
        EndIf
    EndIf
    _RM_EnsurePartyBeforeZehlon()
    _RM_EnsureAttributesAssigned()
    Out("[RM-Step1] Paso 3-7: Quest_SignsAndPortents_Run() - Signs and Portents completo")
    If Not Quest_SignsAndPortents_Run() Then Return False
    $BotRunning = True   
    If Map_GetMapID() <> $RM_OUTPOST_MAP_ID Then
        Out("[RM-Step1] Paso 8: no en Jokanur (map=" & Map_GetMapID() & "), Travel_ToOutpost")
        If Not Travel_ToOutpost($RM_OUTPOST_MAP_ID) Then
            Out("[RM-Step1] FAIL paso 8: no se pudo viajar a Jokanur Diggings")
            Return False
        EndIf
        Sleep(2000)
    EndIf
    Local $hFinal = Party_GetMyPartyInfo("ArrayHeroPartyMemberSize")
    Local $nFinal = Party_GetMyPartyInfo("ArrayHenchmanPartyMemberSize")
    Out("[RM-Step1] Party lista para M02: 1 char + " & $hFinal & " heroes + " & $nFinal & " henchmen")
    Local $q634 = Quest_GetQuestInfo($RM_QUEST_634, "LogState")
    Out("==========================================================================")
    Out("[RM-Step1] >>> FASE 13 COMPLETA <<<")
    Out("[RM-Step1] 1) Travel Astralarium -> Talk Dajmir (Reward 633 + Accept 634)")
    Out("[RM-Step1] 2) Party prep (henchmen + atributos pendientes)")
    Out("[RM-Step1] 3-7) Quest_SignsAndPortents_Run(): Zehlon + Melonni + Inscribed Wall + Jokanur reward 634")
    Out("[RM-Step1] 8) Char en Jokanur (491) con Melonni reclutada | Koss/Kihm los gestiona M02")
    Out("[RM-Step1] Quest 634 LogState=" & $q634 & " | Siguiente: M02_JokanurDiggings")
    Out("==========================================================================")
    _MarkPhaseDone("SignsAndPortents")
    Return True
EndFunc
Func _RM_LegacyZehlonMorgahnFlow()
    Out("[RM-Legacy] Flow Zehlon/Morgahn/bosses (no llamado desde Step1)")
    If Map_GetMapID() <> $RM_DEST_MAP_ID And Map_GetMapID() <> $RM_EXPLORE_MAP_ID Then
        Out("[RM-Step1] Travel_ToOutpost(" & $RM_DEST_MAP_ID & ") - Astralarium")
        If Not Travel_ToOutpost($RM_DEST_MAP_ID) Then
            Out("[RM-Step1] FAIL: no se pudo viajar a Astralarium")
            Return False
        EndIf
        Sleep(2000)
    EndIf
    If Map_GetMapID() = $RM_DEST_MAP_ID Then
        _RM_EnsurePartyBeforeZehlon()
        Out("[RM-Step1] En Astralarium, WalkThroughPortal sur -> Zehlon")
        If Not _RM_WalkThroughPortal($RM_ASTRA_PORTAL_X, $RM_ASTRA_PORTAL_Y, "south", $RM_EXPLORE_MAP_ID, 45000) Then
            Out("[RM-Step1] FAIL: no se pudo cruzar portal a Zehlon")
            Return False
        EndIf
    EndIf
    If Map_GetMapID() <> $RM_EXPLORE_MAP_ID Then
        Out("[RM-Step1] FAIL: tras cross portal no estoy en Zehlon (map=" & Map_GetMapID() & ")")
        Return False
    EndIf
    Pathfinder_SetPathUpdateInterval(2000)
    Cache_SkillBar()
    Out("[RM-Step1] Approach a Morgahn (" & $RM_MORGAHN_X & "," & $RM_MORGAHN_Y & ") via MoveToFollowPath")
    MoveToFollowPath($RM_MORGAHN_X, $RM_MORGAHN_Y, 600)
    Sleep(2000)
    Local $cx = Agent_GetAgentInfo(-2, "X")
    Local $cy = Agent_GetAgentInfo(-2, "Y")
    Local $d = Sqrt(($cx - $RM_MORGAHN_X)^2 + ($cy - $RM_MORGAHN_Y)^2)
    Out("[RM-Step1] Post-approach dist a Morgahn=" & Round($d) & "u")
    If $d > 600 Then
        Out("[RM-Step1] Aun lejos (" & Round($d) & "u), WalkToWaypoint para acercar a <500u")
        _RM_WalkToWaypoint($RM_MORGAHN_X, $RM_MORGAHN_Y, 45000, 500)
        Sleep(1000)
        $cx = Agent_GetAgentInfo(-2, "X")
        $cy = Agent_GetAgentInfo(-2, "Y")
        $d = Sqrt(($cx - $RM_MORGAHN_X)^2 + ($cy - $RM_MORGAHN_Y)^2)
        Out("[RM-Step1] Tras walk extra dist=" & Round($d) & "u")
    EndIf
    Local $rescueWasRm = $g_GE_RescueEnabled
    $g_GE_RescueEnabled = False
    Local $morgahnAgent = 0
    Local $t = TimerInit()
    While Not Bot_ShouldStop() And TimerDiff($t) < 30000
        $morgahnAgent = Agent_GetAgentByPlayerNumber($RM_MORGAHN_MODEL)
        If $morgahnAgent <> 0 Then ExitLoop
        Sleep(1000)
    WEnd
    If $morgahnAgent = 0 Then
        Out("[RM-Step1] FAIL: Morgahn no encontrado en 30s")
        $g_GE_RescueEnabled = $rescueWasRm
        Return False
    EndIf
    Out("[RM-Step1] Morgahn agent=" & $morgahnAgent & " - sleep 15s (rescue inhibido)")
    $g_GE_RescueEnabled = False
    Bot_Sleep(15000)
    $g_GE_LastStuckX = Agent_GetAgentInfo(-2, "X")
    $g_GE_LastStuckY = Agent_GetAgentInfo(-2, "Y")
    $g_GE_StuckTimer = TimerInit()
    $g_GE_RescueEnabled = True
    Local $dialogTimer = TimerInit()
    Local $bossesSpawned = False
    Local $attempts = 0
    While Not Bot_ShouldStop() And TimerDiff($dialogTimer) < 60000
        $attempts += 1
        Out("[RM-Step1] Intento " & $attempts & ": GoNPC + Bot_Dialog(0x827904) + Bot_Dialog(0x84)")
        Agent_GoNPC($morgahnAgent)
        Sleep(2500)
        Bot_Dialog($RM_DIALOG_INTRO)    
        Sleep(2000)
        Bot_Dialog($RM_DIALOG_READY)    
        Sleep(3000)
        If Agent_GetAgentByPlayerNumber($RM_BOSS_MODEL) <> 0 Then
            Out("[RM-Step1] OK - bosses 5386 detectados tras " & $attempts & " intentos")
            $bossesSpawned = True
            ExitLoop
        EndIf
        Out("[RM-Step1] Bosses no spawneados aun, reintentando dialogs en 2s...")
        Sleep(2000)
    WEnd
    If Not $bossesSpawned Then
        Out("[RM-Step1] WARN: tras 60s no detecte bosses 5386 - continuar al combat igual")
    EndIf
    Local $mgX = 17327, $mgY = -4966
    Out("[RM-Step1] GUARDIA junto a Morgahn (" & $mgX & "," & $mgY & ") hasta q633 ls=35")
    Map_Move($mgX, $mgY, 0)
    Sleep(2000)
    $g_iCombatLeashX = $mgX
    $g_iCombatLeashY = $mgY
    $g_iCombatLeashRange = 900
    Local $prevAI_Thg = $g_bAntiIdleTargetLock
    $g_bAntiIdleTargetLock = True
    Local $tGuard = TimerInit()
    Local $tGuardMove = TimerInit()
    Local $tGuardDialog = TimerInit()
    While TimerDiff($tGuard) < 240000
        If Bot_ShouldStop() Then ExitLoop
        If Party_GetPartyContextInfo("IsDefeated") Then ExitLoop
        If Map_GetMapID() <> $RM_EXPLORE_MAP_ID Then ExitLoop
        If Quest_GetQuestInfo(633, "LogState") = 35 Then
            Out("[RM-Step1] q633 ls=35 -> oleadas Kournan MUERTAS (guardia completada)")
            ExitLoop
        EndIf
        If Agent_GetAgentInfo(-2, "IsDead") Then
            Sleep(2500)
            ContinueLoop
        EndIf
        If GetNearestEnemy(1300) <> 0 Then
            Combat_ClearZone(1250, 10000)
        Else
            Local $gx = Agent_GetAgentInfo(-2, "X"), $gy = Agent_GetAgentInfo(-2, "Y")
            If Sqrt(($gx - $mgX) ^ 2 + ($gy - $mgY) ^ 2) > 400 And TimerDiff($tGuardMove) > 4000 Then
                Map_Move($mgX, $mgY, 0)
                $tGuardMove = TimerInit()
            EndIf
            If TimerDiff($tGuardDialog) >= 8000 Then
                $tGuardDialog = TimerInit()
                Local $mgAg = Agent_GetAgentByPlayerNumber($RM_MORGAHN_MODEL)
                If $mgAg <> 0 Then
                    Out("[RM-Step1] Sin enemies en 1300u -> GoNPC + Bot_Dialog(0x827904) para actualizar q633")
                    Agent_GoNPC($mgAg)
                    Sleep(1200)
                    Bot_Dialog($RM_DIALOG_INTRO)
                    Sleep(1200)
                EndIf
            EndIf
            Sleep(800)
        EndIf
    WEnd
    $g_iCombatLeashRange = 0
    $g_bAntiIdleTargetLock = $prevAI_Thg
    If Quest_GetQuestInfo(633, "LogState") <> 35 And Map_GetMapID() = $RM_EXPLORE_MAP_ID Then _
        Out("[RM-Step1] WARN guardia acabÃ³ sin ls=35 (timeout/defeat) - el flujo re-evaluarÃ¡ por estado")
    Sleep(2000)
    If Map_GetMapID() = $RM_EXPLORE_MAP_ID Then
        Out("[RM-Step1] Aun en Zehlon - re-aproximar a Morgahn para update dialog post-bosses")
        MoveToFollowPath($RM_MORGAHN_X, $RM_MORGAHN_Y, 400)
        Sleep(1500)
        $morgahnAgent = Agent_GetAgentByPlayerNumber($RM_MORGAHN_MODEL)
        If $morgahnAgent <> 0 Then
            Local $tPostBoss = TimerInit()
            While Not Bot_ShouldStop() And TimerDiff($tPostBoss) < 20000
                If Quest_GetQuestInfo(633, "LogState") <> 33 Then ExitLoop
                Out("[RM-Step1] GoNPC + Bot_Dialog(0x827904) post-bosses -> update q633")
                Agent_GoNPC($morgahnAgent)
                Sleep(2000)
                Bot_Dialog(0x827904)
                Sleep(3000)
            WEnd
        Else
            Out("[RM-Step1] WARN Morgahn no encontrado para re-dialog post-bosses")
        EndIf
    Else
        Out("[RM-Step1] Ya fuera de Zehlon (map=" & Map_GetMapID() & ") - skip re-dialog Morgahn")
    EndIf
    Local $q633 = Quest_GetQuestInfo(633, "LogState")
    Out("[RM-Step1] Tras boss/dialog: Quest 633 LogState=" & $q633 & "  map=" & Map_GetMapID())
    Local $mapNow = Map_GetMapID()
    If $mapNow = $RM_DEST_MAP_ID Then
        Out("[RM-Step1] Ya en Astralarium (auto-TP quest complete) -> directo a Dajmir")
    ElseIf $mapNow = $RM_EXPLORE_MAP_ID Then
        Out("[RM-Step1] En Zehlon -> WalkThroughPortal norte (" & $RM_POSTPORTAL_X & "," & $RM_POSTPORTAL_Y & ")")
        If Not _RM_WalkThroughPortal($RM_POSTPORTAL_X, $RM_POSTPORTAL_Y, "north", $RM_DEST_MAP_ID, 60000) Then
            Out("[RM-Step1] FAIL: no se pudo cruzar portal norte a Astralarium")
            Return False
        EndIf
        Sleep(2000)
    Else
        Out("[RM-Step1] En outpost " & $mapNow & " (auto-TP a otro outpost) -> Travel_ToOutpost Astralarium")
        If Not Travel_ToOutpost($RM_DEST_MAP_ID) Then
            Out("[RM-Step1] FAIL: Travel_ToOutpost(" & $RM_DEST_MAP_ID & ") fallo")
            Return False
        EndIf
        Sleep(2000)
    EndIf
    If Not _RM_TalkDajmirRewardAndAccept() Then Return False
    Return True
    If Map_GetMapID() <> $RM_DEST_MAP_ID Then
        Out("[RM-Step1] Paso 10: no en Astralarium (map=" & Map_GetMapID() & "), Travel_ToOutpost")
        If Not Travel_ToOutpost($RM_DEST_MAP_ID) Then
            Out("[RM-Step1] FAIL paso 10: no se pudo viajar a Astralarium")
            Return False
        EndIf
        Sleep(2000)
    EndIf
    Out("[RM-Step1] Paso 10: WalkThroughPortal sur -> Zehlon Reach")
    If Not _RM_WalkThroughPortal($RM_ASTRA_PORTAL_X, $RM_ASTRA_PORTAL_Y, "south", $RM_EXPLORE_MAP_ID, 60000) Then
        Out("[RM-Step1] FAIL paso 10: no se pudo cruzar portal sur a Zehlon")
        Return False
    EndIf
    Sleep(2000)
    Out("[RM-Step1] Paso 11: Nav a NPC 5424 en Zehlon (" & $RM_SP_NPC_X & "," & $RM_SP_NPC_Y & ")")
    MoveToFollowPath($RM_SP_NPC_X, $RM_SP_NPC_Y, 400)
    Sleep(2000)
    Local $npc5424z = 0
    Local $tNpc5424 = TimerInit()
    While Not Bot_ShouldStop() And TimerDiff($tNpc5424) < 15000
        $npc5424z = Agent_GetAgentByPlayerNumber($RM_REWARD_NPC_MODEL)   
        If $npc5424z <> 0 Then ExitLoop
        Sleep(1000)
    WEnd
    If $npc5424z = 0 Then
        Out("[RM-Step1] FAIL paso 11: NPC 5424 no encontrado en Zehlon en 15s")
        Return False
    EndIf
    Out("[RM-Step1] NPC 5424 agent=" & $npc5424z & " -> GoNPC + Bot_Dialog(" & Hex($RM_SP_DIALOG, 6) & ") Signs and Portents")
    Agent_GoNPC($npc5424z)
    Sleep(2500)
    Bot_Dialog($RM_SP_DIALOG)   
    Sleep(3000)
    Out("[RM-Step1] Paso 12: WalkThroughPortal norte (" & $RM_POSTPORTAL_X & "," & $RM_POSTPORTAL_Y & ") -> Astralarium")
    If Not _RM_WalkThroughPortal($RM_POSTPORTAL_X, $RM_POSTPORTAL_Y, "north", $RM_DEST_MAP_ID, 60000) Then
        Out("[RM-Step1] WARN paso 12: portal norte fallo, forzando Travel_ToOutpost Astralarium")
        Travel_ToOutpost($RM_DEST_MAP_ID)
        Sleep(2000)
    EndIf
    Out("[RM-Step1] Paso 13: Travel a Jokanur Diggings (" & $RM_OUTPOST_MAP_ID & ")")
    If Not Travel_ToOutpost($RM_OUTPOST_MAP_ID) Then   
        Out("[RM-Step1] FAIL paso 13: no se pudo viajar a Jokanur Diggings")
        Return False
    EndIf
    Sleep(2000)
    Out("[RM-Step1] Paso 13: Nav a NPC 4763 (" & $RM_M02_NPC_X & "," & $RM_M02_NPC_Y & ") -> cobrar mision M02")
    If Not _Quests_NavAndOpenDialog($RM_M02_NPC_X, $RM_M02_NPC_Y, $RM_M02_NPC_MODEL) Then
        Out("[RM-Step1] FAIL paso 13: nav/dialog NPC 4763 en Jokanur")
        Return False
    EndIf
    Bot_Dialog($RM_M02_DIALOG_1)   
    Sleep(2500)
    Bot_Dialog($RM_M02_DIALOG_2)   
    Sleep(3000)
    Local $q634 = Quest_GetQuestInfo($RM_QUEST_634, "LogState")
    Out("==========================================================================")
    Out("[RM-Step1] >>> FASE 13 COMPLETA <<<")
    Out("[RM-Step1] Acciones realizadas:")
    Out("[RM-Step1]   - Travel Astralarium -> WalkThroughPortal sur -> Zehlon Reach")
    Out("[RM-Step1]   - Walk corto a Morgahn (17327,-4966)")
    Out("[RM-Step1]   - Bot_Dialog(0x827904) + Bot_Dialog(0x84) -> spawn Kournan Captains")
    Out("[RM-Step1]   - Kill Model " & $RM_BOSS_MODEL)
    Out("[RM-Step1]   - WalkThroughPortal norte -> Astralarium")
    Out("[RM-Step1]   - Talk Emissary Dajmir -> Reward 633 + Accept 634")
    Out("[RM-Step1]   - WalkThroughPortal sur -> Zehlon Reach -> NPC 5424 (Signs and Portents)")
    Out("[RM-Step1]   - WalkThroughPortal norte -> Astralarium -> Travel Jokanur -> NPC 4763 -> M02")
    Out("[RM-Step1] Quest 634 LogState=" & $q634 & " | Char entrando a instancia M02")
    Out("==========================================================================")
    Local $q633fin = Quest_GetQuestInfo(633, "LogState")
    If $q633fin = 33 Or $q633fin = 35 Then
        Out("[RM-Step1] GATE: q633 ls=" & $q633fin & " SIN COBRAR -> fase NO completa (reintentar)")
        Return False
    EndIf
    If $q634 <= 0 Then
        Out("[RM-Step1] GATE: q634 no aceptada (ls=" & $q634 & ") -> fase NO completa (reintentar)")
        Return False
    EndIf
    Return True
EndFunc
Func Quest_RM_Step2_NavToMorgahn()
    Out("[RM-Step2] Nav-direct path por Zehlon Reach")
    If Map_GetMapID() <> $RM_EXPLORE_MAP_ID Then
        Out("[RM-Step2] FAIL: no en Zehlon Reach")
        Return False
    EndIf
    Sleep(2000)
    Pathfinder_SetPathUpdateInterval(2000)
    Cache_SkillBar()
    If Not _RM_NavDirectPath() Then Return False
    MoveToFollowPath($RM_MORGAHN_X, $RM_MORGAHN_Y, 600)
    Sleep(2000)
    Local $cx = Agent_GetAgentInfo(-2, "X")
    Local $cy = Agent_GetAgentInfo(-2, "Y")
    Local $d = Sqrt(($cx - $RM_MORGAHN_X)^2 + ($cy - $RM_MORGAHN_Y)^2)
    Out("[RM-Step2] Post-approach dist a Morgahn=" & Round($d) & "u")
    If $d > 2000 Then _RM_WalkToWaypoint($RM_MORGAHN_X, $RM_MORGAHN_Y, 30000, 500)
    Return True
EndFunc
Func Quest_RM_Step3_BossFight()
    Out("[RM-Step3] Dialog Morgahn + boss fight 5386")
    If Map_GetMapID() <> $RM_EXPLORE_MAP_ID Then
        Out("[RM-Step3] FAIL: no en Zehlon Reach")
        Return False
    EndIf
    Local $morgahnAgent = 0
    Local $t = TimerInit()
    While Not Bot_ShouldStop() And TimerDiff($t) < 20000
        $morgahnAgent = Agent_GetAgentByPlayerNumber($RM_MORGAHN_MODEL)
        If $morgahnAgent <> 0 Then ExitLoop
        Sleep(1000)
    WEnd
    If $morgahnAgent = 0 Then
        Out("[RM-Step3] FAIL: Morgahn no encontrado en 20s")
        Return False
    EndIf
    Agent_GoNPC($morgahnAgent)
    Sleep(3000)
    Bot_Dialog($RM_DIALOG_READY)
    Sleep(3000)
    Return _RM_KillAllBosses()
EndFunc
Func Quest_RM_Step4_CrossToAstralarium()
    Out("[RM-Step4] Cross portal a Astralarium")
    If Map_GetMapID() = $RM_DEST_MAP_ID Then
        Out("[RM-Step4] Ya en Astralarium, skip")
        Return True
    EndIf
    If Map_GetMapID() <> $RM_EXPLORE_MAP_ID Then
        Out("[RM-Step4] FAIL: no en Zehlon Reach")
        Return False
    EndIf
    _RM_WalkToWaypoint($RM_POSTPORTAL_X, $RM_POSTPORTAL_Y, 45000, 400)
    Return _RM_ForceCrossPortal($RM_POSTPORTAL_X, $RM_POSTPORTAL_Y, $RM_DEST_MAP_ID, 60000)
EndFunc
Func Quest_RM_Step5_RewardAccept()
    Out("[RM-Step5] Reward 633 + Accept 634 en Astralarium")
    If Map_GetMapID() <> $RM_DEST_MAP_ID Then
        Out("[RM-Step5] No en Astralarium, Travel_ToOutpost")
        Travel_ToOutpost($RM_DEST_MAP_ID)
        Sleep(2000)
    EndIf
    If Not _Quests_NavAndOpenDialog($RM_REWARD_NPC_X, $RM_REWARD_NPC_Y, $RM_REWARD_NPC_MODEL) Then
        Out("[RM-Step5] FAIL nav/dialog NPC 5424")
        Return False
    EndIf
    Bot_Dialog($RM_DIALOG_REWARD_633)
    Sleep(2500)
    Bot_Dialog($RM_DIALOG_ACCEPT_634)
    Sleep(2500)
    Bot_Dialog($RM_DIALOG_ACCEPT_634)
    Sleep(2500)
    Local $q634 = Quest_GetQuestInfo($RM_QUEST_634, "LogState")
    Out("[RM-Step5] Quest 634 LogState=" & $q634 & ($q634 > 0 ? " OK aceptada" : " WARN no aplicado"))
    Return ($q634 > 0)
EndFunc
Func _RM_AcceptQuest634InAstralarium()
    Local $ASTRALARIUM = $GC_I_MAP_ID_THE_ASTRALARIUM   
    Local $NPC5424_X = -1805
    Local $NPC5424_Y = 3804
    Local $NPC5424_MODEL = $GC_I_MODEL_ID_NF_DAJMIR          
    If Map_GetMapID() <> $ASTRALARIUM Then
        Out("[RM] Travel a The Astralarium (" & $ASTRALARIUM & ")")
        If Not Travel_ToOutpost($ASTRALARIUM) Then
            Out("[RM] FAIL travel a Astralarium")
            Return False
        EndIf
        Sleep(2000)
    EndIf
    Out("[RM] Nav a NPC 5424 (" & $NPC5424_X & "," & $NPC5424_Y & ") en Astralarium")
    If Not _Quests_NavAndOpenDialog($NPC5424_X, $NPC5424_Y, $NPC5424_MODEL) Then
        Out("[RM] FAIL nav/dialog NPC 5424")
        Return False
    EndIf
    Out("[RM] Bot_Dialog(0x827907) -> Reward quest 633 (idempotente por si falta)")
    Bot_Dialog($RM_DIALOG_REWARD_633)
    Sleep(2500)
    Out("[RM] Bot_Dialog(0x827A01) -> Accept quest 634 'Signs and Portents'")
    Bot_Dialog($RM_DIALOG_ACCEPT_634)
    Sleep(2500)
    Bot_Dialog($RM_DIALOG_ACCEPT_634)
    Sleep(2500)
    Local $q634after = Quest_GetQuestInfo($RM_QUEST_634, "LogState")
    Out("[RM] Quest 634 LogState tras accept: " & $q634after & ($q634after > 0 ? " OK" : " WARN no aplicado"))
    Return ($q634after > 0)
EndFunc
Func _RM_EnsurePartyBeforeZehlon()
    Out("[RM] EnsureParty: aÃ±adiendo heroes (Koss+Dunkoro) + henchmen")
    Local $tWaitKihm = TimerInit()
    While Not Bot_ShouldStop() And TimerDiff($tWaitKihm) < 20000
        If Agent_GetAgentByPlayerNumber($GC_I_MODEL_ID_NF_KIHM) <> 0 Or Agent_GetAgentByPlayerNumber($GC_I_MODEL_ID_NF_KIHM_BH) <> 0 Then
            Out("[RM] EnsureParty: outpost cargado, Kihm visible tras " & Round(TimerDiff($tWaitKihm)/1000, 1) & "s")
            ExitLoop
        EndIf
        Sleep(1000)
    WEnd
    If Agent_GetAgentByPlayerNumber($GC_I_MODEL_ID_NF_KIHM) = 0 And Agent_GetAgentByPlayerNumber($GC_I_MODEL_ID_NF_KIHM_BH) = 0 Then _
        Out("[RM] EnsureParty: WARN Kihm no visible tras 20s (outpost sin Kihm 4593/4602 o carga lenta)")
    If _AutoLevel_FindHeroSlot($GC_I_HERO_ID_KOSS) = 0 Then
        Out("[RM] EnsureParty: Koss no en party -> Party_AddHero")
        Party_AddHero($GC_I_HERO_ID_KOSS)
        Sleep(1200)
    EndIf
    If _AutoLevel_FindHeroSlot($GC_I_HERO_ID_DUNKORO) = 0 Then
        Out("[RM] EnsureParty: Dunkoro no en party -> Party_AddHero")
        Party_AddHero($GC_I_HERO_ID_DUNKORO)
        Sleep(1200)
    EndIf
    _RM_KickNonMonkHenchmen(4593)
    Sleep(600)
    If Not _AutoParty_IsHenchModelInParty($GC_I_MODEL_ID_NF_KIHM) And Not _AutoParty_IsHenchModelInParty($GC_I_MODEL_ID_NF_KIHM_BH) Then
        For $kihmTry = 1 To 5
            Local $kihmAgent = Agent_GetAgentByPlayerNumber($GC_I_MODEL_ID_NF_KIHM)
            If $kihmAgent = 0 Then $kihmAgent = Agent_GetAgentByPlayerNumber($GC_I_MODEL_ID_NF_KIHM_BH)
            If $kihmAgent <> 0 Then
                Out("[RM] EnsureParty: Kihm agent=" & $kihmAgent & " -> Party_AddNpc")
                Party_AddNpc($kihmAgent)
                Sleep(1000)
                If _AutoParty_IsHenchModelInParty($GC_I_MODEL_ID_NF_KIHM) Or _AutoParty_IsHenchModelInParty($GC_I_MODEL_ID_NF_KIHM_BH) Then ExitLoop
            Else
                Out("[RM] EnsureParty: Kihm (4593/4602) no visible aun (intento " & $kihmTry & "/5)")
                Sleep(800)
            EndIf
        Next
        If Not _AutoParty_IsHenchModelInParty($GC_I_MODEL_ID_NF_KIHM) And Not _AutoParty_IsHenchModelInParty($GC_I_MODEL_ID_NF_KIHM_BH) Then _
            Out("[RM] WARN EnsureParty: no se pudo meter a Kihm (4593/4602) en este outpost")
    EndIf
    Out("[RM] EnsureParty: Party_FillWithHenchmen")
    Party_FillWithHenchmen()
    Sleep(1000)
    Local $maxSize = Map_GetAreaInfo(Map_GetMapID(), "MaxPartySize")
    Local $cur = 1 + Party_GetMyPartyInfo("ArrayHeroPartyMemberSize") + Party_GetMyPartyInfo("ArrayHenchmanPartyMemberSize")
    If $maxSize > 1 And $cur < $maxSize Then
        Out("[RM] EnsureParty: aÃºn " & $cur & "/" & $maxSize & " -> volcado + relleno genÃ©rico de henchmen")
        _FS_LogHenchmenSeen()
        _RM_AddAnyHenchmenUpTo($maxSize)
    EndIf
    Local $heroes = Party_GetMyPartyInfo("ArrayHeroPartyMemberSize")
    Local $hench  = Party_GetMyPartyInfo("ArrayHenchmanPartyMemberSize")
    Out("[RM] EnsureParty: party final = 1 player + " & $heroes & " heroes + " & $hench & " henchmen")
EndFunc
Func _RM_AddAnyHenchmenUpTo($maxSize)
    Local $self = Agent_GetAgentInfo(-2, "ID")
    Local $henchNames = "Kihm|Gehraz|Mhenlo|Lina|Zho|Herta|Sogolon|Odurra|Cynn|Devona|Aidan|Talon|Reyna|Nawa|Tubrek|Zana"
    Local $aNames = StringSplit($henchNames, "|", 2)
    For $pass = 1 To $maxSize
        Local $cur = 1 + Party_GetMyPartyInfo("ArrayHeroPartyMemberSize") + Party_GetMyPartyInfo("ArrayHenchmanPartyMemberSize")
        If $cur >= $maxSize Then Return
        Local $agents = Agent_GetAgentArray($GC_I_AGENT_TYPE_LIVING)
        If Not IsArray($agents) Or $agents[0] = 0 Then Return
        Local $added = False
        For $i = 1 To $agents[0]
            Local $ptr = $agents[$i]
            If $ptr = 0 Then ContinueLoop
            If Agent_GetAgentInfo($ptr, "ID") = $self Then ContinueLoop
            If Agent_GetAgentInfo($ptr, "PlayerNumber") = 0 Then ContinueLoop
            Local $nm = Agent_GetAgentInfo($ptr, "Name")
            Local $isHench = False
            For $k = 0 To UBound($aNames) - 1
                If $aNames[$k] <> "" And StringInStr($nm, $aNames[$k]) Then $isHench = True
            Next
            If Not $isHench Then ContinueLoop
            Out("[RM] AddAnyHench: '" & $nm & "' (m=" & Agent_GetAgentInfo($ptr, "PlayerNumber") & ") -> Party_AddNpc")
            Party_AddNpc(Agent_GetAgentInfo($ptr, "ID"))
            Sleep(1200)
            $added = True
            ExitLoop
        Next
        If Not $added Then Return
    Next
EndFunc
Func _RM_EnsureAttributesAssigned()
    Out("[RM] EnsureAttributes: asignando puntos pendientes de char y heroes")
    $g_iAutoLevelLastUnused = 0
    $g_iAutoLevelStuckTicks = 0
    $g_iAutoLevelSkipMask   = 0
    $g_iKossLastUnused      = 0
    $g_iDunkoroLastUnused   = 0
    $g_iMelonniLastUnused   = 0
    Local $tStart = TimerInit()
    Local $ticks  = 0
    Local $charUnused    = 0
    Local $kossSlot      = 0
    Local $kossUnused    = 0
    Local $dunkoroSlot   = 0
    Local $dunkoroUnused = 0
    Local $melonniSlot   = 0
    Local $melonniUnused = 0
    While Not Bot_ShouldStop() And TimerDiff($tStart) < 30000
        $charUnused = Attribute_GetPartyAttributePointInfo(0, "UnusedPoints")
        If @error Then $charUnused = 0
        $kossSlot   = _AutoLevel_FindHeroSlot($GC_I_HERO_ID_KOSS)
        $kossUnused = 0
        If $kossSlot > 0 Then
            $kossUnused = Attribute_GetPartyAttributePointInfo($kossSlot, "UnusedPoints")
            If @error Then $kossUnused = 0
        EndIf
        $dunkoroSlot   = _AutoLevel_FindHeroSlot($GC_I_HERO_ID_DUNKORO)
        $dunkoroUnused = 0
        If $dunkoroSlot > 0 Then
            $dunkoroUnused = Attribute_GetPartyAttributePointInfo($dunkoroSlot, "UnusedPoints")
            If @error Then $dunkoroUnused = 0
        EndIf
        $melonniSlot   = _AutoLevel_FindHeroSlot($GC_I_HERO_ID_MELONNI)
        $melonniUnused = 0
        If $melonniSlot > 0 Then
            $melonniUnused = Attribute_GetPartyAttributePointInfo($melonniSlot, "UnusedPoints")
            If @error Then $melonniUnused = 0
        EndIf
        If $charUnused <= 0 And $kossUnused <= 0 And $dunkoroUnused <= 0 And $melonniUnused <= 0 Then
            Out("[RM] EnsureAttributes: todos asignados en " & $ticks & " ticks")
            Return
        EndIf
        If $charUnused    > 0 Then _AutoLevel_ProcessChar()
        If $kossUnused    > 0 Then _AutoLevel_ProcessKoss()
        If $dunkoroUnused > 0 Then _AutoLevel_ProcessDunkoro()
        If $melonniUnused > 0 Then _AutoLevel_ProcessMelonni()
        $ticks += 1
        Sleep(600)
    WEnd
    Out("[RM] EnsureAttributes: WARN timeout 30s - pueden quedar puntos sin asignar")
EndFunc
Func _RM_EnsureOdurraInParty()
    Local $henchCount = Party_GetMyPartyInfo("HenchmenCount")
    If Not @error And $henchCount > 0 Then
        For $i = 1 To $henchCount
            Local $hAgentId = Party_GetMyPartyHenchmanInfo($i, "AgentID")
            If $hAgentId = 0 Then ContinueLoop
            If Agent_GetAgentInfo($hAgentId, "PlayerNumber") = $RM_ODURRA_MODEL Then
                Out("[RM] Odurra ya en party - skip add")
                Return True
            EndIf
        Next
    EndIf
    Local $myX = Agent_GetAgentInfo(-2, "X")
    Local $myY = Agent_GetAgentInfo(-2, "Y")
    Local $odurraAgent = _Quests_FindNearestNPCByModelToWp($RM_ODURRA_MODEL, $myX, $myY)
    If $odurraAgent > 0 Then
        Out("[RM] Anadiendo Odurra (agent " & $odurraAgent & ") al party")
        Party_AddNpc($odurraAgent)
        Sleep(1500)
        Return True
    EndIf
    Out("[RM] WARN: Odurra (Model " & $RM_ODURRA_MODEL & ") no encontrada en outpost")
    Return False
EndFunc
Func _RM_NavDirectPath()
    Local $total = UBound($RM_STEPS)
    For $i = 0 To $total - 1
        Local $x = $RM_STEPS[$i][1]
        Local $y = $RM_STEPS[$i][2]
        Local $label = $RM_STEPS[$i][3]
        Out("[RM] WP " & ($i+1) & "/" & $total & ": (" & $x & "," & $y & ") " & $label)
        Local $wpTimeout = TimerInit()
        While TimerDiff($wpTimeout) < 180000
            If Bot_ShouldStop() Then Return False
            If Map_GetMapID() <> $RM_EXPLORE_MAP_ID Then
                Out("[RM] Map cambio durante nav -> abort")
                Return False
            EndIf
            Local $cx = Agent_GetAgentInfo(-2, "X")
            Local $cy = Agent_GetAgentInfo(-2, "Y")
            Local $dist = Sqrt(($cx - $x)*($cx - $x) + ($cy - $y)*($cy - $y))
            If $dist < 250 Then ExitLoop
            MoveToFollowPath($x, $y, 600)
            If GetNearestEnemy(1500) <> 0 Then
                Combat_ClearZone(1250, 30000)
            EndIf
        WEnd
    Next
    Return True
EndFunc
Func _RM_WalkThroughPortal($wpX, $wpY, $direction, $targetMap, $timeoutMs = 45000)
    Out("[RM] WalkThroughPortal dir=" & $direction & " WP=(" & $wpX & "," & $wpY & ") -> map " & $targetMap)
    Map_Move($wpX, $wpY, 0)
    Local $tW = TimerInit()
    Local $tWR = TimerInit()
    Local $charWX = 0
    Local $charWY = 0
    While Not Bot_ShouldStop() And TimerDiff($tW) < 25000
        $charWX = Agent_GetAgentInfo(-2, "X")
        $charWY = Agent_GetAgentInfo(-2, "Y")
        If Sqrt(($charWX - $wpX)^2 + ($charWY - $wpY)^2) < 700 Then ExitLoop
        Sleep(300)
        If TimerDiff($tWR) >= 3000 Then
            Map_Move($wpX, $wpY, 0)
            $tWR = TimerInit()
        EndIf
    WEnd
    Local $o1x = 0
    Local $o1y = 0
    Local $o2x = 0
    Local $o2y = 0
    Switch $direction
        Case "south"
            $o1y = -400
            $o2y = -800
            $o1x = 300
            $o2x = -300
        Case "north"
            $o1y = 400
            $o2y = 800
            $o1x = 300
            $o2x = -300
        Case "east"
            $o1x = 400
            $o2x = 800
            $o1y = 300
            $o2y = -300
        Case "west"
            $o1x = -400
            $o2x = -800
            $o1y = 300
            $o2y = -300
        Case Else
            Out("[RM] WalkThroughPortal direction invalida: " & $direction)
            Return False
    EndSwitch
    Local $offsets[7][2] = [ _
        [0,       0      ], _
        [$o1x,    $o1y   ], _
        [$o2x,    $o2y   ], _
        [$o1x,    $o1y   ], _
        [$o2x + $o1x, $o2y + $o1y], _
        [$o1x + $o2x, $o1y + $o2y], _
        [-$o1x,   $o1y   ]  _
    ]
    Local $t     = TimerInit()
    Local $idx   = 0
    Local $tLast = TimerInit()
    Local $tRe   = TimerInit()
    Local $curX  = $wpX + $offsets[0][0]
    Local $curY  = $wpY + $offsets[0][1]
    Map_Move($curX, $curY, 0)
    Out("[RM] CrossPortal inicio offset 0 -> Map_Move(" & $curX & ", " & $curY & ")")
    While Not Bot_ShouldStop() And TimerDiff($t) < $timeoutMs
        If Map_GetMapID() = $targetMap Then
            WaitLoading()
            Out("[RM] Cruzado a " & $targetMap & " tras " & Round(TimerDiff($t)/1000, 1) & "s (offset " & $idx & ")")
            Return True
        EndIf
        Sleep(400)
        If TimerDiff($tRe) >= 2500 Then
            Map_Move($curX, $curY, 0)
            $tRe = TimerInit()
        EndIf
        If TimerDiff($tLast) >= 5000 Then
            $idx  = Mod($idx + 1, 7)
            $curX = $wpX + $offsets[$idx][0]
            $curY = $wpY + $offsets[$idx][1]
            Out("[RM] CrossPortal reintento offset " & $idx & " -> Map_Move(" & $curX & ", " & $curY & ")")
            Map_Move($curX, $curY, 0)
            $tLast = TimerInit()
            $tRe   = TimerInit()
        EndIf
    WEnd
    Out("[RM] WalkThroughPortal TIMEOUT " & Round($timeoutMs/1000, 0) & "s sin cruzar")
    Return False
EndFunc
Func _RM_WalkToWaypoint($x, $y, $timeoutMs = 20000, $tolerance = 350)
    Map_Move($x, $y, 0)
    Local $t = TimerInit()
    Local $tReemit = TimerInit()
    While Not Bot_ShouldStop() And TimerDiff($t) < $timeoutMs
        Local $dx = Agent_GetAgentInfo(-2, "X") - $x
        Local $dy = Agent_GetAgentInfo(-2, "Y") - $y
        Local $dist = Sqrt($dx*$dx + $dy*$dy)
        If $dist < $tolerance Then
            Out("[RM] Llegado a (" & $x & ", " & $y & ") tras " & Round(TimerDiff($t)/1000, 1) & "s (dist=" & Round($dist, 0) & "u)")
            Return True
        EndIf
        Sleep(400)
        If TimerDiff($tReemit) >= 2500 Then
            Map_Move($x, $y, 0)
            $tReemit = TimerInit()
        EndIf
    WEnd
    Out("[RM] TIMEOUT " & Round($timeoutMs/1000) & "s llegando a (" & $x & ", " & $y & ")")
    Return False
EndFunc
Func _RM_ForceCrossPortal($baseX, $baseY, $targetMap, $totalTimeoutMs = 60000)
    Local $offsets[9][2] = [ _
        [0, 0], _
        [800, 0], _
        [0, -400], _
        [0, 400], _
        [500, -400], _
        [500, 400], _
        [1500, 0], _
        [200, -800], _
        [200, 800] _
    ]
    Local $t = TimerInit()
    Local $idx = 0
    Local $lastChange = TimerInit()
    Local $tReemit = TimerInit()
    Local $curX = $baseX, $curY = $baseY
    Map_Move($curX, $curY, 0)
    Out("[RM] CrossPortal centro (" & $baseX & ", " & $baseY & ")")
    While Not Bot_ShouldStop() And TimerDiff($t) < $totalTimeoutMs
        Local $now = Map_GetMapID()
        If $now = $targetMap Then
            WaitLoading()
            Out("[RM] Cruzado portal a " & $targetMap & " tras " & Round(TimerDiff($t)/1000, 1) & "s (offset idx=" & $idx & ")")
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
            Out("[RM] CrossPortal reintento idx=" & $idx & " Map_Move(" & $curX & ", " & $curY & ")")
            Map_Move($curX, $curY, 0)
            $lastChange = TimerInit()
            $tReemit = TimerInit()
        EndIf
    WEnd
    Return False
EndFunc
Func _RM_KillAllBosses()
    Local $totalT = TimerInit()
    Local $killCount = 0
    While Not Bot_ShouldStop() And TimerDiff($totalT) < $RM_BOSS_TOTAL_TIME
        If Map_GetMapID() <> $RM_EXPLORE_MAP_ID Then
            Out("[RM] Mapa cambio durante boss fight -> derrota")
            Return False
        EndIf
        Local $iterT = TimerInit()
        Local $r = Combat_KillBoss($RM_BOSS_MODEL, $RM_BOSS_RANGE, $RM_BOSS_KILL_TIME)
        Local $iterMs = TimerDiff($iterT)
        If $r And $iterMs < 2000 Then
            Out("[RM] No quedan Model " & $RM_BOSS_MODEL & " vivos. Total killed: " & $killCount)
            Return True
        EndIf
        If $r Then $killCount += 1
        Sleep(500)
    WEnd
    Out("[RM] TIMEOUT total " & Round($RM_BOSS_TOTAL_TIME/1000) & "s tras " & $killCount & " kills")
    Return False
EndFunc
Func _RM_TalkDajmirRewardAndAccept()
    If Map_GetMapID() <> $RM_DEST_MAP_ID Then
        Out("[RM-Dajmir] FAIL: no estoy en Astralarium (map=" & Map_GetMapID() & ")")
        Return False
    EndIf
    Local $lsPre = Quest_GetQuestInfo(633, "LogState")
    If $lsPre = 33 Then
        Out("[RM-Dajmir] q633 ls=33 (objetivo INCOMPLETO â€” retrocediÃ³ tras muerte) -> NO cobrar: volver a Zehlon")
        Return False
    EndIf
    Out("[RM-Dajmir] Walk a Emissary Dajmir (Model " & $RM_REWARD_NPC_MODEL & ") en (" & $RM_REWARD_NPC_X & "," & $RM_REWARD_NPC_Y & ")")
    Map_Move($RM_REWARD_NPC_X, $RM_REWARD_NPC_Y, 0)
    Local $tDWalk = TimerInit()
    Local $tDReemit = TimerInit()
    Local $dwX = 0, $dwY = 0
    While Not Bot_ShouldStop() And TimerDiff($tDWalk) < 20000
        $dwX = Agent_GetAgentInfo(-2, "X")
        $dwY = Agent_GetAgentInfo(-2, "Y")
        If Sqrt(($dwX - $RM_REWARD_NPC_X)^2 + ($dwY - $RM_REWARD_NPC_Y)^2) < 600 Then ExitLoop
        Sleep(300)
        If TimerDiff($tDReemit) >= 3000 Then
            Map_Move($RM_REWARD_NPC_X, $RM_REWARD_NPC_Y, 0)
            $tDReemit = TimerInit()
        EndIf
    WEnd
    Sleep(1000)
    Local $dajmirAgent = 0
    Local $t = TimerInit()
    While Not Bot_ShouldStop() And TimerDiff($t) < 15000
        $dajmirAgent = Agent_GetAgentByPlayerNumber($RM_REWARD_NPC_MODEL)
        If $dajmirAgent <> 0 Then ExitLoop
        Sleep(1000)
    WEnd
    If $dajmirAgent = 0 Then
        Out("[RM-Dajmir] FAIL: Dajmir no encontrado en 15s")
        Return False
    EndIf
    Out("[RM-Dajmir] Dajmir agent=" & $dajmirAgent & " -> Reward 633 + Accept 634")
    Agent_ChangeTarget($dajmirAgent)
    Sleep(500)
    Agent_GoNPC($dajmirAgent)
    Sleep(3500)
    Bot_Dialog($RM_DIALOG_REWARD_633)
    Sleep(3500)
    Bot_Dialog($RM_DIALOG_ACCEPT_634)
    Sleep(3500)
    Local $lsAfter = Quest_GetQuestInfo(633, "LogState")
    Out("[RM-Dajmir] Post-dialog q633 ls=" & $lsAfter)
    If $lsAfter = 35 Then
        Out("[RM-Dajmir] q633 sigue en ls=35 - reintento ChangeTarget+GoNPC+Reward")
        Agent_ChangeTarget($dajmirAgent)
        Sleep(500)
        Agent_GoNPC($dajmirAgent)
        Sleep(3500)
        Bot_Dialog($RM_DIALOG_REWARD_633)
        Sleep(3500)
        $lsAfter = Quest_GetQuestInfo(633, "LogState")
        Out("[RM-Dajmir] q633 ls=" & $lsAfter & " tras reintento")
    EndIf
    If $lsAfter = 33 Or $lsAfter = 35 Then
        Out("[RM-Dajmir] q633 NO cobrada (ls=" & $lsAfter & ") -> FAIL para re-evaluar el flujo")
        Return False
    EndIf
    Return True
EndFunc
Func _RM_AcceptQuest633FromGatah()
    If Map_GetMapID() <> $RM_OUTPOST_MAP_ID Then
        Out("[RM-Accept633] Travel_ToOutpost(" & $RM_OUTPOST_MAP_ID & ") - Jokanur")
        If Not Travel_ToOutpost($RM_OUTPOST_MAP_ID) Then
            Out("[RM-Accept633] FAIL: travel a Jokanur fallo")
            Return False
        EndIf
        Sleep(2000)
    EndIf
    Out("[RM-Accept633] Walk a NPC 4763 (Digmaster Gatah) en (2888, 2207)")
    MoveToFollowPath(2888, 2207, 400)
    Sleep(2000)
    Local $gatahAgent = 0
    Local $t = TimerInit()
    While Not Bot_ShouldStop() And TimerDiff($t) < 15000
        $gatahAgent = Agent_GetAgentByPlayerNumber(4763)
        If $gatahAgent <> 0 Then ExitLoop
        Sleep(1000)
    WEnd
    If $gatahAgent = 0 Then
        Out("[RM-Accept633] FAIL: NPC 4763 no encontrado en 15s")
        Return False
    EndIf
    Out("[RM-Accept633] NPC 4763 agent=" & $gatahAgent & " -> GoNPC + Bot_Dialog(0x827901)")
    Agent_GoNPC($gatahAgent)
    Sleep(3000)
    Bot_Dialog(0x827901)
    Sleep(3000)
    Local $q633 = Quest_GetQuestInfo(633, "LogState")
    Out("[RM-Accept633] Quest 633 LogState tras accept = " & $q633)
    If $q633 <= 0 Then
        Out("[RM-Accept633] FAIL: dialog enviado pero quest 633 no en log")
        Return False
    EndIf
    Out("[RM-Accept633] OK - quest 633 aceptada")
    Return True
EndFunc
Func _RM_KickNonMonkHenchmen($keepModel)
    Local $henchCount = Party_GetMyPartyInfo("HenchmenCount")
    If @error Or $henchCount <= 0 Then Return
    For $i = $henchCount To 1 Step -1
        Local $hAgentId = Party_GetMyPartyHenchmanInfo($i, "AgentID")
        If $hAgentId = 0 Then ContinueLoop
        Local $model = Agent_GetAgentInfo($hAgentId, "PlayerNumber")
        If $model <> $keepModel Then
            Out("[RM] KickHenchman model=" & $model & " agentId=" & $hAgentId & " (no es monje " & $keepModel & ")")
            Party_KickNpc($hAgentId)
            Sleep(600)
        EndIf
    Next
EndFunc