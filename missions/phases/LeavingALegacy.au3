#include-once
Func Quest_LeavingALegacy_Run()
    Out("[LeavingALegacy] Orquesta TravelToCliffsOfDohjok + RewardLeavingLegacy")
    _Team_LoadHeroBuild($GC_I_HERO_ID_KOSS, IniRead($g_sConfigFile, "Debug", "LAL_Build_Koss", "OQATEFaVj4q+FwBWocNACAA"), "Koss")
    Sleep(1500)
    Local $ok = Quest_TravelToCliffsOfDohjok_Run()
    If Not $ok Then
        Out("[LeavingALegacy] FAIL en TravelToCliffsOfDohjok")
        Return False
    EndIf
    Sleep(800)
    $ok = Quest_RewardLeavingLegacy_Run()
    If Not $ok Then
        Out("[LeavingALegacy] FAIL en RewardLeavingLegacy")
        Return False
    EndIf
    Out("[LeavingALegacy] OK")
    Return True
EndFunc
Global Const $TCOD_CD_MAP_ID = $GC_I_MAP_ID_CHAMPIONS_DAWN              
Global Const $TCOD_COD_MAP_ID = $GC_I_MAP_ID_CLIFFS_OF_DOHJOK           
Global Const $TCOD_DEST_MAP_ID = $GC_I_MAP_ID_JOKANUR_DIGGINGS_OUTPOST  
Global Const $TCOD_QUEST_ID = $GC_I_QUEST_ID_LEAVINGALEGACY              
Global Const $TCOD_BOHANNA_MODEL = $GC_I_MODEL_ID_NF_BOHANNA       
Global Const $TCOD_BOHANNA_X = 22884
Global Const $TCOD_BOHANNA_Y = 7641
Global Const $TCOD_BOHANNA_DIALOG = 0x827804
Global Const $TCOD_WP1_X = 23717
Global Const $TCOD_WP1_Y = 6408
Global Const $TCOD_CD_PORTAL_X = 22316
Global Const $TCOD_CD_PORTAL_Y = 5806
Global Const $TCOD_JOK_PORTAL_X = -25897
Global Const $TCOD_JOK_PORTAL_Y = 13949
Global $TCOD_STEPS[][5] = [ _
    ["nav_dialog",  18008,  6024, "Dunkoro dialog",                            "4534:0x827804"], _
    ["nav_only",    13800,  8800, "bypass obstáculo (15268,6320)",              0], _
    ["nav_only",    10000,  6000, "bypass SUR santuario",                       0], _
    ["nav_kill",    -6040,  8402, "enemies model 4416 (3-5)",                  0], _
    ["nav_dialog", -13304,  6457, "quest-giver 4763 dialog",                   "4763:0x84"], _
    ["nav_kill",   -10754,  5118, "arpias model 4410",                         0], _
    ["nav_kill",   -11068,  3296, "enemies model 4409",                        0], _
    ["nav_kill",   -11564,    97, "enemies model 4410",                        0], _
    ["nav_kill",    -9959, -2580, "enemies model 4409",                        0], _
    ["nav_kill",    -6137, -1365, "enemies model 4410",                        0], _
    ["nav_kill",   -14839,  6433, "volver - enemies model 4431",               0], _
    ["nav_kill",   -21262,  8545, "sur-oeste - enemies model 4432",            0], _
    ["stop",            0,     0, "end recorrido CoD",                         0]  _
]
Func Quest_TravelToCliffsOfDohjok_Run()
    Out("[TravelToCliffsOfDohjok] Start - CD->CoD->recorrido->Jokanur (491)")
    If Map_GetMapID() <> $TCOD_CD_MAP_ID And Map_GetMapID() <> $TCOD_COD_MAP_ID And Map_GetMapID() <> $TCOD_DEST_MAP_ID Then
        Out("[TCOD] No en CD/CoD/Jokanur (mapa=" & Map_GetMapID() & ") -> Travel a Champion's Dawn (479)")
        If Not Travel_ToOutpost($TCOD_CD_MAP_ID) Then
            Out("[TCOD] FAIL travel a Champion's Dawn")
            Return False
        EndIf
    EndIf
    If Map_GetMapID() = $TCOD_CD_MAP_ID Then
        Out("[TCOD] PARTE 1/3: en CD, hablar Bohanna + cruzar a CoD")
        Out("[TCOD] 1.1: NPC Quarrymaster Bohanna (model " & $TCOD_BOHANNA_MODEL & ") dialog 0x" & Hex($TCOD_BOHANNA_DIALOG, 6))
        If Not _Quests_NavAndOpenDialog($TCOD_BOHANNA_X, $TCOD_BOHANNA_Y, $TCOD_BOHANNA_MODEL) Then
            Out("[TCOD] FAIL - no se pudo abrir dialog con Bohanna")
            Return False
        EndIf
        Bot_Dialog($TCOD_BOHANNA_DIALOG)
        Sleep(1500)
        Bot_Dialog($TCOD_BOHANNA_DIALOG)
        Sleep(1500)
        Out("[TCOD] 1.2: walk a waypoint (" & $TCOD_WP1_X & "," & $TCOD_WP1_Y & ")")
        _TCOD_WalkToWaypoint($TCOD_WP1_X, $TCOD_WP1_Y, 30000, 400)
        Out("[TCOD] 1.2b: añadir henchmen Kihm (4586) + Herta (4588)")
        Local $agKihm = Agent_GetAgentByPlayerNumber(4586)
        If $agKihm Then
            Party_AddNpc($agKihm)
            Sleep(800)
        EndIf
        Local $agHerta = Agent_GetAgentByPlayerNumber(4588)
        If $agHerta Then
            Party_AddNpc($agHerta)
            Sleep(800)
        EndIf
        Out("[TCOD] 1.3: cruzar portal a CoD (432)")
        _TCOD_ForceCrossPortal($TCOD_CD_PORTAL_X, $TCOD_CD_PORTAL_Y, $TCOD_COD_MAP_ID, 45000)
        If Map_GetMapID() <> $TCOD_COD_MAP_ID Then
            Out("[TCOD] FAIL - no cruzo a CoD, mapa actual=" & Map_GetMapID())
            Return False
        EndIf
    EndIf
    If Map_GetMapID() = $TCOD_COD_MAP_ID Then
        Out("[TCOD] PARTE 2/3: en CoD, recorrido por " & UBound($TCOD_STEPS) & " waypoints")
        Sleep(2000)   
        Pathfinder_SetPathUpdateInterval(2000)
        Cache_SkillBar()
        _TCOD_RunCombatPhase()
    EndIf
    If Map_GetMapID() = $TCOD_COD_MAP_ID Then
        Out("[TCOD] PARTE 3/3: nav Pathfinder al portal SO -> Jokanur Diggings (" & $TCOD_DEST_MAP_ID & ")")
        _Mission_DoNavOnly(-24877, 12954)
        _TCOD_ForceCrossPortal($TCOD_JOK_PORTAL_X, $TCOD_JOK_PORTAL_Y, $TCOD_DEST_MAP_ID, 60000)
    EndIf
    If Map_GetMapID() = $TCOD_DEST_MAP_ID Then
        Out("[TCOD] OK - char en Jokanur Diggings outpost (" & $TCOD_DEST_MAP_ID & ")")
        Return True
    EndIf
    Out("[TCOD] FAIL - mapa final=" & Map_GetMapID() & " (esperado " & $TCOD_DEST_MAP_ID & ")")
    Return False
EndFunc
Func _TCOD_RunCombatPhase()
    Out("[TCOD] RunCombatPhase: " & UBound($TCOD_STEPS) & " steps")
    For $i = 0 To UBound($TCOD_STEPS) - 1
        If Bot_ShouldStop() Then Return False
        If Recovery_IsOutOfInstance($TCOD_COD_MAP_ID) Then Return False
        Cinematic_ProtectStep()
        Local $kind  = $TCOD_STEPS[$i][0]
        Local $x     = $TCOD_STEPS[$i][1]
        Local $y     = $TCOD_STEPS[$i][2]
        Local $label = $TCOD_STEPS[$i][3]
        Out("[TCOD] Step " & ($i+1) & "/" & UBound($TCOD_STEPS) & ": " & $kind & " (" & $x & "," & $y & ") " & $label)
        Switch $kind
            Case "stop"
                Out("[TCOD] Stop alcanzado")
                ExitLoop
            Case "nav_kill"
                If Not _Mission_DoNavKill($x, $y) Then
                    Out("[TCOD] nav_kill fail -> esperar rez y reintentar")
                    If _Mission_WaitForRevive(12000) Then
                        If Not _Mission_DoNavKill($x, $y) Then Return False
                    Else
                        Return False
                    EndIf
                EndIf
            Case "nav_only"
                _Mission_DoNavOnly($x, $y)
            Case "nav_dialog"
                _Mission_DoNavOnly($x, $y)
                Sleep(1500)
                _Mission_DoDialog($TCOD_STEPS[$i][4], $x, $y, $label)
        EndSwitch
    Next
    Return True
EndFunc
Func _TCOD_WalkToWaypoint($x, $y, $timeoutMs = 30000, $tolerance = 500)
    Map_Move($x, $y, 0)
    Local $t = TimerInit()
    Local $tReemit = TimerInit()
    While Not Bot_ShouldStop() And TimerDiff($t) < $timeoutMs
        Local $dx = Agent_GetAgentInfo(-2, "X") - $x
        Local $dy = Agent_GetAgentInfo(-2, "Y") - $y
        Local $dist = Sqrt($dx*$dx + $dy*$dy)
        If $dist < $tolerance Then
            Out("[TCOD] Llegado a (" & $x & ", " & $y & ") tras " & Round(TimerDiff($t)/1000, 1) & "s (dist=" & Round($dist, 0) & "u)")
            Return True
        EndIf
        Sleep(400)
        If TimerDiff($tReemit) >= 2500 Then
            Map_Move($x, $y, 0)
            $tReemit = TimerInit()
        EndIf
    WEnd
    Out("[TCOD] TIMEOUT " & Round($timeoutMs/1000, 0) & "s llegando a (" & $x & ", " & $y & ")")
    Return False
EndFunc
Func _TCOD_ForceCrossPortal($baseX, $baseY, $targetMap, $totalTimeoutMs = 45000)
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
    Out("[TCOD] ForceCrossPortal centro (" & $baseX & ", " & $baseY & ")")
    While Not Bot_ShouldStop() And TimerDiff($t) < $totalTimeoutMs
        Local $now = Map_GetMapID()
        If $now = $targetMap Then
            Out("[TCOD] Cruzado portal a map " & $targetMap & " tras " & Round(TimerDiff($t)/1000, 1) & "s (offset idx=" & $idx & ")")
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
            Out("[TCOD] ForceCrossPortal reintento idx=" & $idx & " Map_Move(" & $curX & ", " & $curY & ")")
            Map_Move($curX, $curY, 0)
            $lastChange = TimerInit()
            $tReemit = TimerInit()
        EndIf
    WEnd
    Out("[TCOD] ForceCrossPortal TIMEOUT " & Round($totalTimeoutMs/1000, 0) & "s, map actual=" & Map_GetMapID())
    Return False
EndFunc
Global Const $RLL_MAP_ID      = $GC_I_MAP_ID_JOKANUR_DIGGINGS_OUTPOST   
Global Const $RLL_QUEST_632   = $GC_I_QUEST_ID_LEAVINGALEGACY            
Global Const $RLL_QUEST_633   = $GC_I_QUEST_ID_THEHONORABLEGENERAL      
Global Const $RLL_NPC_MODEL   = $GC_I_MODEL_ID_NF_GENERIC_B        
Global Const $RLL_NPC_X       = 2888
Global Const $RLL_NPC_Y       = 2207
Func Quest_RewardLeavingLegacy_Run()
    Out("[RewardLeavingLegacy] Start - cobrar 632 + Dunkoro + aceptar 633 con NPC 4763")
    If Map_GetMapID() <> $RLL_MAP_ID Then
        Out("[RLL] FAIL - mapa actual=" & Map_GetMapID() & " (esperado " & $RLL_MAP_ID & " Jokanur outpost)")
        Return False
    EndIf
    Local $q632state = Quest_GetQuestInfo($RLL_QUEST_632, "LogState")
    Local $q632done  = Quest_GetQuestInfo($RLL_QUEST_632, "IsCompleted") = 1
    Local $q633state = Quest_GetQuestInfo($RLL_QUEST_633, "LogState")
    Local $q633active = $q633state > 0
    Out("[RLL] Quest 632: LogState=" & $q632state & " IsCompleted=" & ($q632done ? 1 : 0) _
      & " | Quest 633: LogState=" & $q633state)
    If $q632done And $q633active Then
        Out("[RLL] Quest 632 ya completada y 633 ya activa -> skip, fase OK")
        Return True
    EndIf
    Out("[RLL] Nav a NPC " & $RLL_NPC_MODEL & " en (" & $RLL_NPC_X & ", " & $RLL_NPC_Y & ")")
    If Not _Quests_NavAndOpenDialog($RLL_NPC_X, $RLL_NPC_Y, $RLL_NPC_MODEL) Then
        Out("[RLL] FAIL nav/dialog NPC " & $RLL_NPC_MODEL)
        Return False
    EndIf
    Out("[RLL] Ui_RewardQuest(632) -> 0x827807 'Accept' (cobrar Dunkoro)")
    Ui_RewardQuest($RLL_QUEST_632)
    Sleep(2500)
    Ui_RewardQuest($RLL_QUEST_632)
    Sleep(2500)
    Local $q632doneAfter = Quest_GetQuestInfo($RLL_QUEST_632, "IsCompleted") = 1
    Out("[RLL] Quest 632 IsCompleted tras reward: " & ($q632doneAfter ? "1 OK Dunkoro disponible" : "0 WARN dialog no aplicado"))
    Out("[RLL] Ui_AcceptQuest(633) -> 0x827901 'Sounds like fun!'")
    Ui_AcceptQuest($RLL_QUEST_633)
    Sleep(2500)
    Ui_AcceptQuest($RLL_QUEST_633)
    Sleep(2500)
    Local $q633stateAfter = Quest_GetQuestInfo($RLL_QUEST_633, "LogState")
    Out("[RLL] Quest 633 LogState tras accept: " & $q633stateAfter & ($q633stateAfter > 0 ? " OK aceptada" : " WARN no aplicado"))
    Return True
EndFunc