#include-once
Global Const $BTR_QUEST_ID            = 636
Global Const $BTR_KAMADAN_MAP_ID      = $GC_I_MAP_ID_KAMADAN_JEWEL_OF_ISTAN   
Global Const $BTR_SUNDOCKS_MAP_ID     = $GC_I_MAP_ID_SUN_DOCKS                 
Global Const $BTR_EXPLORABLE_MAP_ID   = $GC_I_MAP_ID_BAD_TIDE_RISING_KAMADAN_EXPLORABLE   
Global Const $BTR_DEHVAD_MODEL = $GC_I_MODEL_ID_NF_GENERIC_A   
Global Const $BTR_DEHVAD_X     = -7874
Global Const $BTR_DEHVAD_Y     =  9799
Global Const $BTR_YURUKARO_MODEL = 110   
Global Const $BTR_YURUKARO_X = -3497    
Global Const $BTR_YURUKARO_Y = 14593
Global Const $BTR_DIALOG_ACCEPT = 0x827C01   
Global Const $BTR_DIALOG_ABOUT  = 0x827C03   
Global Const $BTR_DIALOG_REWARD = 0x827C07   
Func Quest_BadTideRising_Run()
    Out("[BTR] === Bad Tide Rising (Quest 636) START ===")
    If _BTR_RunOnce() Then
        Out("[BTR] OK — quest 636 completada")
        Return True
    EndIf
    Out("[BTR] FAIL — quest 636 no completada")
    Return False
EndFunc
Func _BTR_RunOnce()
    Local $tLoad = TimerInit()
    While Not Bot_ShouldStop() And (Map_GetMapID() = 0 Or Map_GetInstanceInfo("IsLoading"))
        If TimerDiff($tLoad) > 15000 Then
            Out("[BTR] ABORT: timeout esperando carga de mapa")
            Return False
        EndIf
        Sleep(500)
    WEnd
    Local $iCurMap = Map_GetMapID()
    Local $logState = Quest_GetQuestInfo($BTR_QUEST_ID, "LogState")
    Out("[BTR STATUS] RunOnce map=" & $iCurMap & " logState=" & $logState)
    If $iCurMap = $BTR_EXPLORABLE_MAP_ID Then
        Out("[BTR] En Kamadan explorable (422) -> _BTR_DoExplorable + Reward")
        If Not _BTR_DoExplorable() Then Return False
        Return _BTR_DoReward()
    EndIf
    If $iCurMap <> $BTR_KAMADAN_MAP_ID And $iCurMap <> $BTR_SUNDOCKS_MAP_ID Then
        Out("[BTR] Paso 0: Travel a Kamadan (449) - punto de partida obligatorio")
        Map_RndTravel($BTR_KAMADAN_MAP_ID, False)
        Map_WaitMapLoading($BTR_KAMADAN_MAP_ID, $GC_I_MAP_TYPE_OUTPOST)
        $iCurMap = Map_GetMapID()
        Out("[BTR STATUS] Post-Kamadan map=" & $iCurMap)
        If $iCurMap <> $BTR_KAMADAN_MAP_ID Then
            Out("[BTR] ABORT: no se pudo viajar a Kamadan (map=" & $iCurMap & ")")
            Return False
        EndIf
    EndIf
    If $logState <= 0 Then
        Out("[BTR] Paso 1: Accept quest 636 con Dehvad en Kamadan")
        If Not _BTR_AcceptQuest() Then Return False
        $logState = Quest_GetQuestInfo($BTR_QUEST_ID, "LogState")
        Out("[BTR] Post-accept: LogState=" & $logState)
    EndIf
    If $logState > 0 Then
        Out("[BTR] Paso 2: Travel a Sun Docks + Yurukaro")
        If Not _BTR_GoToSunDocksAndTalkYurukaro() Then Return False
        $iCurMap = Map_GetMapID()
        Out("[BTR] Post-Yurukaro: map=" & $iCurMap)
    EndIf
    If Map_GetMapID() = $BTR_EXPLORABLE_MAP_ID Then
        Out("[BTR] En Kamadan explorable -> _BTR_DoExplorable")
        If Not _BTR_DoExplorable() Then Return False
    EndIf
    Return _BTR_DoReward()
EndFunc
Func _BTR_AcceptQuest()
    If Map_GetMapID() <> $BTR_KAMADAN_MAP_ID Then
        Out("[BTR] Accept: Travel a Kamadan (449)")
        If Not Travel_ToOutpost($BTR_KAMADAN_MAP_ID) Then
            Out("[BTR] ABORT: no se pudo viajar a Kamadan")
            Return False
        EndIf
    EndIf
    Local $logState = Quest_GetQuestInfo($BTR_QUEST_ID, "LogState")
    If $logState > 0 Then
        Out("[BTR] Quest 636 ya en log (LogState=" & $logState & ") -> skip accept")
        Return True
    EndIf
    Out("[BTR] Accept: Hablar con Dehvad (4751, -7874, 9799)")
    Local $dehvadNPC = Agent_GetAgentByPlayerNumber($BTR_DEHVAD_MODEL)
    If $dehvadNPC = 0 Then
        Out("[BTR] Dehvad model 4751 no aparece -> fallback quest-giver cercano a (-7874,9799)")
        Local $tBtrFB = TimerInit()
        While TimerDiff($tBtrFB) < 5000 And $dehvadNPC = 0
            $dehvadNPC = GetNearestQuestGiver(6000)
            If $dehvadNPC <> 0 Then
                Local $bfX = Agent_GetAgentInfo($dehvadNPC, "X")
                Local $bfY = Agent_GetAgentInfo($dehvadNPC, "Y")
                Local $bfD = Sqrt(($bfX - $BTR_DEHVAD_X)^2 + ($bfY - $BTR_DEHVAD_Y)^2)
                If $bfD > 800 Then
                    Out("[BTR] Fallback quest-giver en (" & Round($bfX) & "," & Round($bfY) & ") a " & Round($bfD) & "u del waypoint -> descartar")
                    $dehvadNPC = 0
                EndIf
            EndIf
            If $dehvadNPC = 0 Then Sleep(500)
        WEnd
    EndIf
    If $dehvadNPC = 0 Then
        Out("[BTR] FAIL Accept: Dehvad no encontrado por model ni por cercania")
        Return False
    EndIf
    Local $dx = Agent_GetAgentInfo($dehvadNPC, "X")
    Local $dy = Agent_GetAgentInfo($dehvadNPC, "Y")
    MoveTo(Round($dx), Round($dy), 0, 30)
    Sleep(1500)
    Agent_ChangeTarget($dehvadNPC)
    Sleep(300)
    Agent_GoNPC($dehvadNPC)
    Sleep(1200)
    Out("[BTR] Dehvad dialog -> Ui_AboutQuest(636) [0x827C03] para ver si quest disponible")
    Ui_AboutQuest($BTR_QUEST_ID)
    Sleep(1000)
    Local $stateAfterAbout = Quest_GetQuestInfo($BTR_QUEST_ID, "LogState")
    Out("[BTR] Post-AboutQuest: LogState=" & $stateAfterAbout)
    Ui_AcceptQuest($BTR_QUEST_ID)
    Sleep(3000)
    Local $stateAfterAccept = Quest_GetQuestInfo($BTR_QUEST_ID, "LogState")
    Out("[BTR] Post-AcceptQuest: LogState=" & $stateAfterAccept)
    If $stateAfterAccept > 0 Then
        Out("[BTR] Accept OK: quest 636 aceptada (LogState=" & $stateAfterAccept & ")")
        Return True
    EndIf
    Out("[BTR] FAIL Accept: LogState=" & $stateAfterAccept & " -> quest 636 NO disponible en Dehvad (prereq missing o NPC equivocado)")
    Return False
EndFunc
Func _BTR_GoToSunDocksAndTalkYurukaro()
    If Map_GetMapID() <> $BTR_SUNDOCKS_MAP_ID Then
        Out("[BTR] Yurukaro: Map_RndTravel a Sun Docks (543)")
        Map_RndTravel($BTR_SUNDOCKS_MAP_ID, False)
        Map_WaitMapLoading($BTR_SUNDOCKS_MAP_ID, $GC_I_MAP_TYPE_OUTPOST)
        If Map_GetMapID() <> $BTR_SUNDOCKS_MAP_ID Then
            Out("[BTR] Map_RndTravel falló (map=" & Map_GetMapID() & ") -> walk-through portal BTR")
            If Not _BTR_WalkToSunDocksPortal() Then
                Out("[BTR] ABORT: no se pudo entrar a Sun Docks")
                Return False
            EndIf
        EndIf
    EndIf
    Out("[BTR] En Sun Docks (map=" & Map_GetMapID() & ") -> esperando carga de agentes (hasta 20s)")
    Local $yurakAgent = 0
    Local $tFind = TimerInit()
    While Not Bot_ShouldStop() And TimerDiff($tFind) < 20000
        Sleep(1000)
        $yurakAgent = _BTR_FindYurukaro()
        If $yurakAgent <> 0 Then ExitLoop
    WEnd
    If $yurakAgent = 0 Then
        Out("[BTR] FAIL: General Yurukaro no encontrado tras 20s -> dump para diagnóstico")
        _BTR_DumpAgentsInMap()
        Return False
    EndIf
    Out("[BTR] Yurukaro encontrado tras " & Round(TimerDiff($tFind)/1000, 1) & "s")
    Local $yurakX = Agent_GetAgentInfo($yurakAgent, "X")
    Local $yurakY = Agent_GetAgentInfo($yurakAgent, "Y")
    Local $yurakModel = Agent_GetAgentInfo($yurakAgent, "PlayerNumber")
    Out("[BTR] Yurukaro: agent=" & $yurakAgent & " model=" & $yurakModel & " pos=(" & Round($yurakX) & "," & Round($yurakY) & ")")
    Agent_ChangeTarget($yurakAgent)
    Sleep(200)
    Agent_GoNPC($yurakAgent)
    Local $tNav = TimerInit()
    Local $playerX, $playerY, $distYurak
    Do
        $playerX = Agent_GetAgentInfo(-2, "X")
        $playerY = Agent_GetAgentInfo(-2, "Y")
        $distYurak = Sqrt(($playerX - $yurakX)^2 + ($playerY - $yurakY)^2)
        If TimerDiff($tNav) > 25000 Then
            Out("[BTR] WARN: timeout navegando a Yurukaro (dist=" & Round($distYurak) & "u)")
            ExitLoop
        EndIf
        Sleep(400)
    Until $distYurak < 300
    Out("[BTR] Cerca de Yurukaro (dist=" & Round($distYurak) & "u) -> segundo GoNPC para abrir dialog")
    Agent_ChangeTarget($yurakAgent)
    Sleep(200)
    Agent_GoNPC($yurakAgent)
    Sleep(2500)  
    Local $dialogs[3] = [0x84, 0x827C04, 0x827C01]
    Local $dialogNames[3] = ["0x84 (ready)", "0x827C04 (UpdateQuest)", "0x827C01 (AcceptQuest)"]
    Local $mapCambio = False
    For $d = 0 To 2
        If Map_GetMapID() = $BTR_EXPLORABLE_MAP_ID Then
            $mapCambio = True
            ExitLoop
        EndIf
        Out("[BTR] Dialog Yurukaro -> " & $dialogNames[$d])
        Bot_Dialog($dialogs[$d])
        Local $tD = TimerInit()
        While Not Bot_ShouldStop() And Map_GetMapID() <> $BTR_EXPLORABLE_MAP_ID And Map_GetMapID() <> 0
            If TimerDiff($tD) > 5000 Then ExitLoop
            Sleep(300)
        WEnd
    Next
    Local $tWait = TimerInit()
    While Not Bot_ShouldStop() And Map_GetMapID() <> $BTR_EXPLORABLE_MAP_ID
        If TimerDiff($tWait) > 20000 Then
            Out("[BTR] WARN: no se cargó map 422 tras dialogs Yurukaro (map=" & Map_GetMapID() & ")")
            Out("[BTR] CAPTURAR: abrir Toolbox en Sun Docks, hablar con Yurukaro,")
            Out("[BTR]   en Toolbox > Target > Dialog → anotar hex al hacer click 'Enter'")
            Out("[BTR] Yurukaro model=" & $yurakModel & " — actualizar BTR_YURUKARO_MODEL si >0")
            Return False
        EndIf
        If Map_GetInstanceInfo("IsLoading") Then
            Out("[BTR] Cargando mapa 422...")
        EndIf
        Sleep(500)
    WEnd
    Out("[BTR] OK: en Kamadan explorable (map=422)")
    Return True
EndFunc
Func _BTR_DoExplorable()
    Out("[BTR] Explorable (map=422): iniciando clearing de Chaos Rifts")
    If Map_GetMapID() <> $BTR_EXPLORABLE_MAP_ID Then
        Out("[BTR] ABORT Explorable: map=" & Map_GetMapID() & " (esperado 422)")
        Return False
    EndIf
    Local $startX = Round(Agent_GetAgentInfo(-2, "X"))
    Local $startY = Round(Agent_GetAgentInfo(-2, "Y"))
    Out("[BTR] Pos inicial en explorable: (" & $startX & "," & $startY & ")")
    Local $tExpl = TimerInit()
    Local $tMaxExpl = 300000   
    Out("[BTR] ClearZone inicial 6000u desde spawn")
    Combat_ClearZone(6000, 60000)
    Local $logState = Quest_GetQuestInfo($BTR_QUEST_ID, "LogState")
    Out("[BTR] Post-clear1: LogState=" & $logState & " map=" & Map_GetMapID())
    Local $clearRound = 0
    Local $emptyRounds = 0   
    While Not Bot_ShouldStop() And Map_GetMapID() = $BTR_EXPLORABLE_MAP_ID
        $clearRound += 1
        If TimerDiff($tExpl) > $tMaxExpl Then
            Out("[BTR] TIMEOUT 5min en Kamadan explorable -> forzar regreso a Kamadan")
            ExitLoop
        EndIf
        $logState = Quest_GetQuestInfo($BTR_QUEST_ID, "LogState")
        If GetNearestEnemy(6000) = 0 Then
            $emptyRounds += 1
        Else
            $emptyRounds = 0
        EndIf
        Out("[BTR] Explorable round " & $clearRound & ": LogState=" & $logState & " emptyRounds=" & $emptyRounds & " map=" & Map_GetMapID())
        If $emptyRounds >= 12 And $logState > 0 Then
            Out("[BTR] Rifts cerrados (zona limpia " & $emptyRounds & " rounds, ls=" & $logState & ") -> regreso a Kamadan a cobrar")
            ExitLoop
        EndIf
        Out("[BTR] ClearZone 6000u round " & $clearRound)
        Combat_ClearZone(6000, 60000)
        Sleep(2000)  
    WEnd
    If Map_GetMapID() = $BTR_EXPLORABLE_MAP_ID Then
        Out("[BTR] Regreso manual: Map_RndTravel a Kamadan (449)")
        Map_RndTravel($BTR_KAMADAN_MAP_ID, False)
        Map_WaitMapLoading($BTR_KAMADAN_MAP_ID, $GC_I_MAP_TYPE_OUTPOST)
        Sleep(2000)
        Out("[BTR] Mapa tras regreso: " & Map_GetMapID())
    EndIf
    Return True
EndFunc
Func _BTR_DoReward()
    If Map_GetMapID() <> $BTR_KAMADAN_MAP_ID Then
        Out("[BTR] Reward: Travel a Kamadan (449)")
        If Not Travel_ToOutpost($BTR_KAMADAN_MAP_ID) Then
            Out("[BTR] ABORT Reward: no se pudo viajar a Kamadan")
            Return False
        EndIf
    EndIf
    Local $logState = Quest_GetQuestInfo($BTR_QUEST_ID, "LogState")
    Out("[BTR] DoReward: LogState=" & $logState)
    If $logState = 0 Then
        Out("[BTR] Quest 636 LogState=0 -> rewarded correctamente")
        Return True
    EndIf
    If $logState = -1 Then
        Out("[BTR] FAIL DoReward: LogState=-1 (quest 636 nunca en log) - NO asumir completada")
        Return False
    EndIf
    If $logState < 33 Then
        Out("[BTR] WARN: DoReward con LogState=" & $logState & " (objetivos probablemente incompletos)")
        Return False
    EndIf
    Out("[BTR] Reward intento 1: Ui_RewardQuest(636) directo")
    Ui_RewardQuest($BTR_QUEST_ID)
    Sleep(5000)
    $logState = Quest_GetQuestInfo($BTR_QUEST_ID, "LogState")
    Out("[BTR] Reward intento 1 -> LogState=" & $logState)
    If $logState <= 0 Then
        Out("[BTR] Reward OK (intento 1): quest 636 recompensada")
        Return True
    EndIf
    Out("[BTR] Reward WARN: LogState=" & $logState & " -> intento 2: nav+GoNPC+About+Reward")
    If _Quests_NavAndOpenDialog($BTR_DEHVAD_X, $BTR_DEHVAD_Y, $BTR_DEHVAD_MODEL) Then
        Local $dehvadAgent = GetNearestQuestGiver(1500)
        If $dehvadAgent <> 0 Then
            MoveTo($BTR_DEHVAD_X, $BTR_DEHVAD_Y, 0, 30)
            Sleep(1500)
            Agent_ChangeTarget($dehvadAgent)
            Sleep(300)
            Agent_GoNPC($dehvadAgent)
            Sleep(2500)
            Ui_AboutQuest($BTR_QUEST_ID)
            Sleep(1000)
            Ui_RewardQuest($BTR_QUEST_ID)
            Sleep(5000)
            $logState = Quest_GetQuestInfo($BTR_QUEST_ID, "LogState")
            Out("[BTR] Reward intento 2 -> LogState=" & $logState)
        EndIf
    EndIf
    If $logState <= 0 Then
        Out("[BTR] Reward OK (intento 2): quest 636 recompensada")
        Return True
    EndIf
    Out("[BTR] FAIL Reward: LogState=" & $logState & " tras 2 intentos (rifts probablemente aún abiertos)")
    Return False
EndFunc
Func _BTR_WalkToSunDocksPortal()
    If Map_GetMapID() <> $BTR_KAMADAN_MAP_ID Then
        Out("[BTR] WalkToSunDocksPortal: no en Kamadan (map=" & Map_GetMapID() & ")")
        Return False
    EndIf
    Local $ferryX = -5535
    Local $ferryY = 14889
    Gadget_LogNearby(3000)
    Out("[BTR] WalkToSunDocksPortal: Map_Move a ferry (" & $ferryX & "," & $ferryY & ")")
    Map_Move($ferryX, $ferryY, 0)
    Local $tWalk = TimerInit()
    While TimerDiff($tWalk) < 10000
        If Map_GetMapID() = $BTR_SUNDOCKS_MAP_ID Then
            Out("[BTR] WalkToSunDocksPortal: entró auto (walk)")
            Return True
        EndIf
        Sleep(500)
    WEnd
    Local $ferryGadget = Gadget_FindNearestToXY($ferryX, $ferryY, 800)
    If $ferryGadget > 0 Then
        Out("[BTR] WalkToSunDocksPortal: gadget id=" & $ferryGadget & " -> GoSignpost")
        Agent_ChangeTarget($ferryGadget)
        Sleep(300)
        Agent_GoSignpost($ferryGadget)
        Local $tGad = TimerInit()
        While TimerDiff($tGad) < 5000
            If Map_GetMapID() = $BTR_SUNDOCKS_MAP_ID Then
                Out("[BTR] WalkToSunDocksPortal: GoSignpost OK -> Sun Docks")
                Return True
            EndIf
            Sleep(400)
        WEnd
        Out("[BTR] WalkToSunDocksPortal: GoSignpost no cambió mapa -> ForceCrossPortal")
    Else
        Out("[BTR] WalkToSunDocksPortal: sin gadget en 800u -> ForceCrossPortal")
    EndIf
    Local $offsets[9][2] = [[0,0],[-400,0],[400,0],[0,300],[0,-300],[-400,300],[-400,-300],[400,300],[400,-300]]
    Local $t      = TimerInit()
    Local $tReemit = TimerInit()
    Local $tChange = TimerInit()
    Local $idx = 0
    Local $curX = $ferryX, $curY = $ferryY
    Map_Move($curX, $curY, 0)
    Out("[BTR] WalkToSunDocksPortal: ForceCrossPortal (" & $curX & "," & $curY & ")")
    While Not Bot_ShouldStop() And TimerDiff($t) < 45000
        If Map_GetMapID() = $BTR_SUNDOCKS_MAP_ID Then
            Out("[BTR] WalkToSunDocksPortal: cruzado en " & Round(TimerDiff($t)/1000,1) & "s")
            Return True
        EndIf
        Sleep(400)
        If Map_GetMapID() = $BTR_SUNDOCKS_MAP_ID Then ContinueLoop
        If TimerDiff($tReemit) >= 2500 Then
            Map_Move($curX, $curY, 0)
            $tReemit = TimerInit()
        EndIf
        If TimerDiff($tChange) >= 5000 Then
            $idx = Mod($idx + 1, 9)
            $curX = $ferryX + $offsets[$idx][0]
            $curY = $ferryY + $offsets[$idx][1]
            Out("[BTR] WalkToSunDocksPortal: ForceCross offset " & $idx & " (" & $curX & "," & $curY & ")")
            Map_Move($curX, $curY, 0)
            $tChange = TimerInit()
            $tReemit = TimerInit()
        EndIf
    WEnd
    Out("[BTR] WalkToSunDocksPortal: TIMEOUT 45s map=" & Map_GetMapID())
    Return False
EndFunc
Func _BTR_DumpAgentsInMap()
    Out("[BTR] === DUMP AGENTES NPC en map=" & Map_GetMapID() & " ===")
    Local $agents = Agent_GetAgentArray($GC_I_AGENT_TYPE_LIVING)
    If Not IsArray($agents) Then
        Out("[BTR] DUMP: no hay agentes")
        Return
    EndIf
    Local $count = 0
    For $i = 0 To UBound($agents) - 1
        Local $ag = $agents[$i]
        If $ag = 0 Then ContinueLoop
        Local $alleg = Agent_GetAgentInfo($ag, "Allegiance")
        If $alleg <> $GC_I_ALLEGIANCE_NPC And $alleg <> $GC_I_ALLEGIANCE_ALLY Then ContinueLoop
        Local $model = Agent_GetAgentInfo($ag, "PlayerNumber")
        Local $x = Agent_GetAgentInfo($ag, "X")
        Local $y = Agent_GetAgentInfo($ag, "Y")
        Local $name = Agent_GetAgentInfo($ag, "Name")  
        Out("[BTR] DUMP NPC: agent=" & $ag & " model=" & $model & " alleg=" & $alleg & " pos=(" & Round($x) & "," & Round($y) & ") name='" & $name & "'")
        $count += 1
    Next
    Out("[BTR] DUMP: " & $count & " NPCs en mapa")
    Out("[BTR] === FIN DUMP ===")
EndFunc
Func _BTR_FindYurukaro()
    If $BTR_YURUKARO_MODEL > 0 Then
        Local $ag = Agent_GetAgentByPlayerNumber($BTR_YURUKARO_MODEL)
        If $ag <> 0 Then
            Out("[BTR] FindYurukaro: encontrado por Model ID " & $BTR_YURUKARO_MODEL)
            Return $ag
        EndIf
        Out("[BTR] FindYurukaro: model " & $BTR_YURUKARO_MODEL & " no en mapa -> busqueda por alleg=6")
    EndIf
    Out("[BTR] FindYurukaro: buscando NPCs alleg=6 en Sun Docks")
    Local $agents = Agent_GetAgentArray($GC_I_AGENT_TYPE_LIVING)
    If Not IsArray($agents) Then Return 0
    Local $bestAg = 0
    Local $bestDist = 99999
    Local $playerX = Agent_GetAgentInfo(-2, "X")
    Local $playerY = Agent_GetAgentInfo(-2, "Y")
    For $i = 0 To UBound($agents) - 1
        Local $ag = $agents[$i]
        If $ag = 0 Then ContinueLoop
        Local $alleg = Agent_GetAgentInfo($ag, "Allegiance")
        If $alleg <> $GC_I_ALLEGIANCE_NPC Then ContinueLoop
        Local $model = Agent_GetAgentInfo($ag, "PlayerNumber")
        Local $ax = Agent_GetAgentInfo($ag, "X")
        Local $ay = Agent_GetAgentInfo($ag, "Y")
        Local $dist = Sqrt(($ax - $playerX)^2 + ($ay - $playerY)^2)
        Out("[BTR] FindYurukaro: candidato model=" & $model & " alleg=" & $alleg & " dist=" & Round($dist) & " pos=(" & Round($ax) & "," & Round($ay) & ")")
        If $dist < $bestDist Then
            $bestDist = $dist
            $bestAg = $ag
        EndIf
    Next
    If $bestAg <> 0 Then
        Local $model = Agent_GetAgentInfo($bestAg, "PlayerNumber")
        Local $bx = Agent_GetAgentInfo($bestAg, "X")
        Local $by = Agent_GetAgentInfo($bestAg, "Y")
        Out("[BTR] FindYurukaro: seleccionado model=" & $model & " dist=" & Round($bestDist) & " pos=(" & Round($bx) & "," & Round($by) & ")")
        Out("[BTR] INFO: si no es Yurukaro, actualizar BTR_YURUKARO_MODEL=" & $model)
    Else
        Out("[BTR] FindYurukaro: ningún NPC alleg=6 con model>=200 encontrado en Sun Docks")
    EndIf
    Return $bestAg
EndFunc