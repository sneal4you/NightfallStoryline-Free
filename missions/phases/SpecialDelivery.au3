#include-once
Func Quest_SpecialDelivery_Run()
    Local Const $SD_QUEST_ID     = 637
    Local Const $SD_DEHVAD_MODEL = 4751
    Local Const $SD_DEHVAD_X     = -7874
    Local Const $SD_DEHVAD_Y     = 9799
    Local Const $SD_REWARD_HEX   = 0x827D07
    Out("[SD] === Special Delivery (quest 637) START ===")
    Local $tW = TimerInit()
    While Not Bot_ShouldStop() And (Map_GetMapID() = 0 Or Map_GetInstanceInfo("IsLoading"))
        If TimerDiff($tW) > 30000 Then
            Out("[SD] ABORT: timeout esperando mapa")
            Return False
        EndIf
        Sleep(1000)
    WEnd
    Out("[SD] map=" & Map_GetMapID())
    Local $logState = Quest_GetQuestInfo($SD_QUEST_ID, "LogState")
    Local $mapTo    = Quest_GetQuestInfo($SD_QUEST_ID, "MapTo")
    Out("[SD] LogState=" & $logState & " MapTo=" & $mapTo)
    Out("[SD] MarkerX="  & Quest_GetQuestInfo($SD_QUEST_ID, "MarkerX") & _
        " MarkerY=" & Quest_GetQuestInfo($SD_QUEST_ID, "MarkerY"))
    Out("[SD] Location=" & Quest_GetQuestInfo($SD_QUEST_ID, "Location"))
    Out("[SD] CanReward=" & Quest_GetQuestInfo($SD_QUEST_ID, "CanReward"))
    If $logState = 0 Then
        If Quest_GetQuestInfo(638, "LogState") > 0 Then
            Out("[SD] Quest 637 ls=0 + q638 aceptada -> SD completada en sesion previa, done")
            Return True
        EndIf
        Out("[SD] Quest 637 ls=0 y 638 sin aceptar -> SD nunca cobrada (char nuevo). EJECUTAR SD.")
    EndIf
    Select
        Case $mapTo = 431 Or $mapTo = 543  
            Out("[SD] MapTo=" & $mapTo & " â†’ DoReward directo")
            Return _SD_DoReward()  
        Case $mapTo = 486  
            Out("[SD] MapTo=486 â†’ viajando a Kodlonu (instancia fresca)")
            Local $sdJerekOk = False
            If Not _SD_TravelToMap(489, "Kodlonu Hamlet") Then
                Out("[SD] FAIL: no se pudo llegar a Kodlonu")
                Return False
            EndIf
            _SD_AddHenchmen()
            If Not _SD_EnterIssnur() And Map_GetMapID() <> 486 Then
                Out("[SD] FAIL: no se pudo entrar a Issnur")
                Return False
            EndIf
            If _SD_JerekIsFriendly() Then
                Out("[SD] Jerek amistoso -> escolta directa (pacificar ya hecho)")
                If Not _SD_EscortJerek() Then
                    Out("[SD] FAIL: escolta directa fallida")
                    Return False
                EndIf
                If Quest_GetQuestInfo($SD_QUEST_ID, "LogState") <= 0 Then
                    Out("[SD] OK: quest 637 completada tras escolta directa")
                    Return True
                EndIf
                If Quest_GetQuestInfo($SD_QUEST_ID, "MapTo") = 431 Then
                    If Not _SD_TravelToMap(431, "Sunspear Great Hall") Then Return False
                    Local $puubaE = _SD_FindNPC("Puuba")
                    If $puubaE <> 0 Then
                        Agent_GoNPC($puubaE)
                        Sleep(2500)
                        Bot_Dialog(0x827D04)
                        Sleep(5000)
                    EndIf
                EndIf
                Ui_RewardQuest($SD_QUEST_ID)
                Sleep(5000)
                Return Quest_GetQuestInfo($SD_QUEST_ID, "LogState") <= 0
            EndIf
            Out("[SD] Jerek hostil/ausente -> pacificar (FindJerek)")
            $sdJerekOk = _SD_FindJerek()
            If Not $sdJerekOk Then
                Out("[SD] FAIL: Jerek no actualizo la mision -> abortando (no ir a Puuba sin mision actualizada)")
                Return False
            EndIf
            Out("[SD] Jerek OK. Pasando a DoReward (MapTo=" & Quest_GetQuestInfo($SD_QUEST_ID, "MapTo") & ")...")
            Return _SD_DoReward()
        Case Else
            Out("[SD] MapTo=" & $mapTo & " â†’ ejecutando chain completa desde paso 1")
    EndSelect
    If $logState <= 0 Then
        Out("[SD] ls=" & $logState & ": aceptando quest 637 desde Dehvad en Kamadan...")
        If Map_GetMapID() <> 449 Then
            Map_RndTravel(449, False)
            Map_WaitMapLoading(449, $GC_I_MAP_TYPE_OUTPOST)
        EndIf
        Map_Move($SD_DEHVAD_X, $SD_DEHVAD_Y, 0)
        Local $tNav = TimerInit()
        While Not Bot_ShouldStop() And TimerDiff($tNav) < 30000
            Local $px = Agent_GetAgentInfo(-2, "X")
            Local $py = Agent_GetAgentInfo(-2, "Y")
            If Sqrt(($px - $SD_DEHVAD_X)^2 + ($py - $SD_DEHVAD_Y)^2) < 300 Then ExitLoop
            Sleep(400)
        WEnd
        Sleep(1500)  
        Local $d = _SD_FindDehvad($SD_DEHVAD_X, $SD_DEHVAD_Y, $SD_DEHVAD_MODEL)
        If Not $d = 0 Then
            Agent_ChangeTarget($d)
            Sleep(200)
            Agent_GoNPC($d)
            Sleep(2500)
            Ui_AcceptQuest($SD_QUEST_ID)
            Sleep(3000)
            $logState = Quest_GetQuestInfo($SD_QUEST_ID, "LogState")
            Out("[SD] Tras accept Dehvad: LogState=" & $logState)
        Else
            Out("[SD] WARN Dehvad no encontrado cerca de (" & $SD_DEHVAD_X & "," & $SD_DEHVAD_Y & ") -> paso aceptarcion best-effort, continuar")
        EndIf
        If $logState < 0 Then
            Out("[SD] Dehvad no da q637 (LogState sigue -1) -> continuar a Sun Docks/Hayao")
        EndIf
    EndIf
    Out("[SD] Paso 1: Sun Docks para diÃ¡logo con Hayao...")
    If Map_GetMapID() <> 543 Then
        If Map_GetMapID() <> 449 Then
            Map_RndTravel(449, False)
            Map_WaitMapLoading(449, $GC_I_MAP_TYPE_OUTPOST)
        EndIf
        If Not _SD_EnterSunDocks() Then
            Out("[SD] FAIL: no se pudo entrar a Sun Docks (paso 1)")
            Return False
        EndIf
    EndIf
    If Not _SD_FindTalkNPC("Hayao", $SD_QUEST_ID, True) Then
        Out("[SD] FAIL: no se pudo hablar con Hayao en Sun Docks")
        Return False
    EndIf
    Out("[SD] Hayao dialog completado en Sun Docks")
    Map_RndTravel(449, False)
    Map_WaitMapLoading(449, $GC_I_MAP_TYPE_OUTPOST)
    Out("[SD] Paso 2: viajando a Sunspear Great Hall (431)...")
    If Not _SD_TravelToMap(431, "Sunspear Great Hall") Then
        Out("[SD] FAIL: no se pudo llegar a Sunspear Hall")
        Return False
    EndIf
    If Not _SD_FindTalkNPC("Puuba", $SD_QUEST_ID, True) Then
        Out("[SD] FAIL: no se pudo hablar con Puuba en Sunspear Hall")
        Return False
    EndIf
    Out("[SD] Puuba dialog completado.")
    Out("[SD] Paso 3: viajando a Kodlonu Hamlet (489)...")
    If Not _SD_TravelToMap(489, "Kodlonu Hamlet") Then
        Out("[SD] FAIL: no se pudo llegar a Kodlonu Hamlet")
        Return False
    EndIf
    _SD_AddHenchmen()
    Out("[SD] Cruzando portal Kodlonu â†’ Issnur Isles...")
    If Not _SD_EnterIssnur() Then
        Out("[SD] FAIL: no se pudo entrar a Issnur Isles desde Kodlonu")
        Return False
    EndIf
    If Not _SD_FindJerek() Then
        Out("[SD] FAIL: no se pudo encontrar/pacificar a Jerek")
        Return False
    EndIf
    Out("[SD] Jerek pacificado. Codlonu unlocked.")
    Out("[SD] Paso 4a: update Hayao en Sun Docks (0x827D04)...")
    If Map_GetMapID() <> 543 Then
        If Map_GetMapID() <> 449 Then
            Map_RndTravel(449, False)
            Map_WaitMapLoading(449, $GC_I_MAP_TYPE_OUTPOST)
        EndIf
        If Not _SD_EnterSunDocks() Then
            Out("[SD] FAIL: no se pudo entrar a Sun Docks")
            Return False
        EndIf
    EndIf
    Local $hayaoS4 = _SD_FindNPC("Hayao")
    If $hayaoS4 = 0 Then
        Out("[SD] FAIL: Hayao no encontrado en Sun Docks")
        Return False
    EndIf
    Local $hxS4 = Agent_GetAgentInfo($hayaoS4, "X"), $hyS4 = Agent_GetAgentInfo($hayaoS4, "Y")
    Map_Move($hxS4, $hyS4, 0)
    Local $tNavS4 = TimerInit()
    While TimerDiff($tNavS4) < 8000
        If Sqrt((Agent_GetAgentInfo(-2,"X")-$hxS4)^2+(Agent_GetAgentInfo(-2,"Y")-$hyS4)^2) < 300 Then ExitLoop
        Sleep(400)
    WEnd
    Agent_ChangeTarget($hayaoS4)
    Sleep(300)
    Agent_GoNPC($hayaoS4)
    Sleep(2500)
    Out("[SD] Paso 4a: Bot_Dialog(0x827D04)")
    Bot_Dialog(0x827D04)
    Local $tS4 = TimerInit()
    While TimerDiff($tS4) < 8000
        $logState = Quest_GetQuestInfo($SD_QUEST_ID, "LogState")
        If $logState <= 0 Then ExitLoop
        Sleep(500)
    WEnd
    Out("[SD] LogState tras 0x827D04=" & $logState & " MapTo=" & Quest_GetQuestInfo($SD_QUEST_ID, "MapTo"))
    If $logState = 0 Then Return True
    Out("[SD] Paso 4b: reward con Puuba en Sunspear Great Hall (431)...")
    If Not _SD_TravelToMap(431, "Sunspear Great Hall") Then
        Out("[SD] FAIL: no se pudo llegar a Sunspear Hall")
        Return False
    EndIf
    Out("[SD] Paso 4b: 0x827D04 con Puuba en Sunspear Great Hall (431)...")
    If Not _SD_TravelToMap(431, "Sunspear Great Hall") Then
        Out("[SD] FAIL: no se pudo llegar a Sunspear Hall")
        Return False
    EndIf
    _SD_WaitForNPCs(8000)
    Local $puuba4b = _SD_FindNPC("Puuba")
    If $puuba4b = 0 Then
        Out("[SD] FAIL: Puuba no encontrada en Sunspear Hall")
        Return False
    EndIf
    Local $p4bx = Agent_GetAgentInfo($puuba4b, "X"), $p4by = Agent_GetAgentInfo($puuba4b, "Y")
    Map_Move($p4bx, $p4by, 0)
    Local $tNav4b = TimerInit()
    While TimerDiff($tNav4b) < 8000
        If Sqrt((Agent_GetAgentInfo(-2,"X")-$p4bx)^2+(Agent_GetAgentInfo(-2,"Y")-$p4by)^2) < 300 Then ExitLoop
        Sleep(400)
    WEnd
    Agent_ChangeTarget($puuba4b)
    Sleep(300)
    Agent_GoNPC($puuba4b)
    Sleep(2500)
    Out("[SD] Paso 4b: Bot_Dialog(0x827D04)")
    Bot_Dialog(0x827D04)
    Local $tWait4b = TimerInit()
    While TimerDiff($tWait4b) < 8000
        $logState = Quest_GetQuestInfo($SD_QUEST_ID, "LogState")
        If $logState <= 0 Then ExitLoop
        Sleep(500)
    WEnd
    Local $mapTo4b = Quest_GetQuestInfo($SD_QUEST_ID, "MapTo")
    Out("[SD] LogState final=" & $logState & " MapTo=" & $mapTo4b)
    If $logState = 0 Then
        Out("[SD] Quest 637 COMPLETADA")
        Return True
    EndIf
    If $mapTo4b = 486 Then
        Out("[SD] Paso 4c: MapTo=486 â†’ escoltando Jerek en Issnur...")
        If Not _SD_EscortJerek() Then
            Out("[SD] FAIL Paso 4c: escolta fallida")
            Return False
        EndIf
        $logState = Quest_GetQuestInfo($SD_QUEST_ID, "LogState")
        Out("[SD] Tras escolta: ls=" & $logState & " MapTo=" & Quest_GetQuestInfo($SD_QUEST_ID, "MapTo"))
        Return $logState = 0
    EndIf
    Out("[SD] FAIL: LogState=" & $logState & " MapTo=" & $mapTo4b & " sin manejar")
    Return False
EndFunc
Func _SD_WaitForNPCs($timeoutMs = 10000)
    Local $t = TimerInit()
    While Not Bot_ShouldStop() And TimerDiff($t) < $timeoutMs
        If Map_GetInstanceInfo("IsLoading") Then
            Sleep(500)
            ContinueLoop
        EndIf
        Local $agArr = Agent_GetAgentArray($GC_I_AGENT_TYPE_LIVING)
        If IsArray($agArr) Then
            For $i = 0 To UBound($agArr) - 1
                If $agArr[$i] = 0 Then ContinueLoop
                Local $alleg = Agent_GetAgentInfo($agArr[$i], "Allegiance")
                If $alleg = $GC_I_ALLEGIANCE_NPC Or $alleg = $GC_I_ALLEGIANCE_ALLY Then
                    Out("[SD] WaitForNPCs: NPC encontrado tras " & Round(TimerDiff($t)/1000, 1) & "s")
                    Return True
                EndIf
            Next
        EndIf
        Sleep(500)
    WEnd
    Out("[SD] WaitForNPCs: TIMEOUT (" & Round($timeoutMs/1000) & "s) sin NPCs")
    Return False
EndFunc
Func _SD_FindNPC($nameFragment)
    Local $t = TimerInit()
    While TimerDiff($t) < 8000
        Local $agArr = Agent_GetAgentArray($GC_I_AGENT_TYPE_LIVING)
        If IsArray($agArr) Then
            For $i = 0 To UBound($agArr) - 1
                If $agArr[$i] = 0 Then ContinueLoop
                Local $alleg = Agent_GetAgentInfo($agArr[$i], "Allegiance")
                If $alleg <> $GC_I_ALLEGIANCE_NPC And $alleg <> $GC_I_ALLEGIANCE_ALLY Then ContinueLoop
                Local $nm = Agent_GetAgentInfo($agArr[$i], "Name")
                If StringInStr($nm, $nameFragment) Then
                    Out("[SD] FindNPC: '" & $nameFragment & "' encontrado como '" & $nm & "' en " & Round(TimerDiff($t)/1000, 1) & "s")
                    Return $agArr[$i]
                EndIf
            Next
        EndIf
        Sleep(500)
    WEnd
    Out("[SD] FindNPC: '" & $nameFragment & "' NO encontrado en " & Round(8000/1000) & "s")
    Local $agArr2 = Agent_GetAgentArray($GC_I_AGENT_TYPE_LIVING)
    If IsArray($agArr2) Then
        Local $dumped = 0
        For $i = 0 To UBound($agArr2) - 1
            If $agArr2[$i] = 0 Then ContinueLoop
            Local $alleg = Agent_GetAgentInfo($agArr2[$i], "Allegiance")
            If $alleg <> $GC_I_ALLEGIANCE_NPC And $alleg <> $GC_I_ALLEGIANCE_ALLY Then ContinueLoop
            Local $nm = Agent_GetAgentInfo($agArr2[$i], "Name")
            Local $mod = Agent_GetAgentInfo($agArr2[$i], "PlayerNumber")
            Local $aX = Round(Agent_GetAgentInfo($agArr2[$i], "X"))
            Local $aY = Round(Agent_GetAgentInfo($agArr2[$i], "Y"))
            Out("[SD] NPC dump: model=" & $mod & " name='" & $nm & "' pos=(" & $aX & "," & $aY & ")")
            $dumped += 1
            If $dumped >= 20 Then ExitLoop
        Next
    EndIf
    Return 0
EndFunc
Func _SD_TalkToAgent($agent, $questID)
    If $agent = 0 Then Return False
    Local $lsBefore  = Quest_GetQuestInfo($questID, "LogState")
    Local $mapToBef  = Quest_GetQuestInfo($questID, "MapTo")
    Out("[SD] TalkToAgent: LogState antes=" & $lsBefore & " MapTo antes=" & $mapToBef)
    Local $npcX = Agent_GetAgentInfo($agent, "X")
    Local $npcY = Agent_GetAgentInfo($agent, "Y")
    Out("[SD] TalkToAgent: NPC pos=(" & Round($npcX) & "," & Round($npcY) & ")")
    Map_Move($npcX, $npcY, 0)
    Local $tNav = TimerInit()
    While TimerDiff($tNav) < 10000
        Local $myX = Agent_GetAgentInfo(-2, "X")
        Local $myY = Agent_GetAgentInfo(-2, "Y")
        Local $dist = Sqrt(($myX - $npcX)^2 + ($myY - $npcY)^2)
        If $dist < 300 Then ExitLoop
        Sleep(400)
    WEnd
    Local $myX2 = Agent_GetAgentInfo(-2, "X")
    Local $myY2 = Agent_GetAgentInfo(-2, "Y")
    Out("[SD] TalkToAgent: dist=" & Round(Sqrt(($myX2-$npcX)^2+($myY2-$npcY)^2)) & "u")
    Agent_ChangeTarget($agent)
    Sleep(300)
    Agent_GoNPC($agent)
    Sleep(2500)
    Agent_ChangeTarget($agent)
    Sleep(200)
    Agent_GoNPC($agent)
    Sleep(2500)
    Bot_Dialog(0x84)
    Sleep(1000)
    Local $tWait = TimerInit()
    While TimerDiff($tWait) < 8000
        Local $mapToNow = Quest_GetQuestInfo($questID, "MapTo")
        Local $ls = Quest_GetQuestInfo($questID, "LogState")
        If $mapToNow <> $mapToBef Then
            Out("[SD] TalkToAgent: MapTo cambio " & $mapToBef & " â†’ " & $mapToNow & " OK")
            Return True
        EndIf
        If $ls <= 0 Then
            Out("[SD] TalkToAgent: quest completada (LogState=" & $ls & ")")
            Return True
        EndIf
        Sleep(500)
    WEnd
    Local $mapToAf  = Quest_GetQuestInfo($questID, "MapTo")
    Local $lsAfter  = Quest_GetQuestInfo($questID, "LogState")
    Out("[SD] TalkToAgent: MapTo=" & $mapToAf & " LogState=" & $lsAfter & " (sin cambio tras 8s)")
    Return True
EndFunc
Func _SD_FindTalkNPC($nameFragment, $questID, $wait = True)
    Local $agent = 0
    If $wait Then
        $agent = _SD_FindNPC($nameFragment)
    Else
        Local $agArr = Agent_GetAgentArray($GC_I_AGENT_TYPE_LIVING)
        If IsArray($agArr) Then
            For $i = 0 To UBound($agArr) - 1
                If $agArr[$i] = 0 Then ContinueLoop
                Local $alleg = Agent_GetAgentInfo($agArr[$i], "Allegiance")
                If $alleg <> $GC_I_ALLEGIANCE_NPC And $alleg <> $GC_I_ALLEGIANCE_ALLY Then ContinueLoop
                Local $nm = Agent_GetAgentInfo($agArr[$i], "Name")
                If StringInStr($nm, $nameFragment) Then
                    $agent = $agArr[$i]
                    ExitLoop
                EndIf
            Next
        EndIf
    EndIf
    If $agent = 0 Then Return False
    Return _SD_TalkToAgent($agent, $questID)
EndFunc
Func _SD_RewardNPC($nameFragment, $questID, $rewardHex)
    Local $agent = _SD_FindNPC($nameFragment)
    If $agent = 0 Then
        Out("[SD] RewardNPC: '" & $nameFragment & "' no encontrado, probando cualquier NPC...")
        Local $agArr = Agent_GetAgentArray($GC_I_AGENT_TYPE_LIVING)
        If IsArray($agArr) Then
            For $i = 0 To UBound($agArr) - 1
                If $agArr[$i] = 0 Then ContinueLoop
                Local $alleg = Agent_GetAgentInfo($agArr[$i], "Allegiance")
                If $alleg <> $GC_I_ALLEGIANCE_NPC And $alleg <> $GC_I_ALLEGIANCE_ALLY Then ContinueLoop
                $agent = $agArr[$i]
                ExitLoop
            Next
        EndIf
    EndIf
    If $agent = 0 Then
        Out("[SD] RewardNPC: no hay NPCs en el mapa")
        Return False
    EndIf
    Local $nm = Agent_GetAgentInfo($agent, "Name")
    Out("[SD] RewardNPC: GoNPC con '" & $nm & "'...")
    Agent_ChangeTarget($agent)
    Sleep(300)
    Agent_GoNPC($agent)
    Sleep(2500)
    Out("[SD] RewardNPC intento 1: Ui_RewardQuest(" & $questID & ")")
    Ui_RewardQuest($questID)
    Sleep(5000)
    Local $ls = Quest_GetQuestInfo($questID, "LogState")
    Out("[SD] RewardNPC intento 1 â†’ LogState=" & $ls)
    If $ls = 0 Then
        Out("[SD] RewardNPC: quest " & $questID & " COMPLETADA (intento 1)")
        Return True
    EndIf
    Out("[SD] RewardNPC intento 2: AboutQuest + RewardQuest")
    Agent_GoNPC($agent)
    Sleep(1500)
    Ui_AboutQuest($questID)
    Sleep(1000)
    Ui_RewardQuest($questID)
    Sleep(5000)
    $ls = Quest_GetQuestInfo($questID, "LogState")
    Out("[SD] RewardNPC intento 2 â†’ LogState=" & $ls)
    If $ls = 0 Then
        Out("[SD] RewardNPC: quest " & $questID & " COMPLETADA (intento 2)")
        Return True
    EndIf
    Out("[SD] RewardNPC intento 3: Bot_Dialog(" & Hex($rewardHex) & ") directo")
    Agent_GoNPC($agent)
    Sleep(1500)
    Bot_Dialog(0x84)
    Sleep(1000)
    Bot_Dialog(0x84)
    Sleep(1000)
    Bot_Dialog($rewardHex)
    Sleep(5000)
    $ls = Quest_GetQuestInfo($questID, "LogState")
    Out("[SD] RewardNPC intento 3 â†’ LogState=" & $ls)
    If $ls <= 0 Then
        Out("[SD] RewardNPC: quest " & $questID & " COMPLETADA (intento 3)")
        Return True
    EndIf
    Out("[SD] FAIL RewardNPC: LogState=" & $ls & " tras 3 intentos con '" & $nm & "'")
    Return False
EndFunc
Func _SD_EnterSunDocks()
    If Map_GetMapID() <> 449 Then
        Out("[SD] EnterSunDocks: no en Kamadan (map=" & Map_GetMapID() & ")")
        Return False
    EndIf
    Local $px = -5535, $py = 14889
    Out("[SD] EnterSunDocks: Map_Move a portal (" & $px & "," & $py & ")...")
    Map_Move($px, $py, 0)
    Local $t = TimerInit()
    Local $lastX = 0, $lastY = 0, $tStuck = TimerInit()
    While Not Bot_ShouldStop() And TimerDiff($t) < 45000 And Map_GetMapID() = 449
        Sleep(500)
        Local $cx = Agent_GetAgentInfo(-2, "X")
        Local $cy = Agent_GetAgentInfo(-2, "Y")
        If $cx <> 0 And $cy <> 0 Then
            If Abs($cx - $lastX) < 10 And Abs($cy - $lastY) < 10 Then
                If TimerDiff($tStuck) >= 8000 Then
                    Out("[SD] EnterSunDocks: STUCK en (" & Round($cx) & "," & Round($cy) & "), re-enviando Map_Move")
                    Map_Move($px, $py, 0)
                    $tStuck = TimerInit()
                EndIf
            Else
                $lastX = $cx
                $lastY = $cy
                $tStuck = TimerInit()
            EndIf
        EndIf
    WEnd
    If Map_GetMapID() = 543 Then
        Out("[SD] EnterSunDocks: entro automaticamente a Sun Docks")
        _SD_WaitForNPCs(8000)
        Out("[SD] EnterSunDocks: NPCs OK en Sun Docks")
        Return True
    EndIf
    Out("[SD] EnterSunDocks: auto-entry fallo, probando ferryman...")
    Local $ferry = Agent_GetAgentByPlayerNumber(4825)
    If $ferry = 0 Then
        Local $agents = Agent_GetAgentArray($GC_I_AGENT_TYPE_LIVING)
        Local $best = 0, $bestD = 3000
        If IsArray($agents) Then
            For $i = 0 To UBound($agents) - 1
                If $agents[$i] = 0 Then ContinueLoop
                Local $alleg = Agent_GetAgentInfo($agents[$i], "Allegiance")
                If $alleg <> $GC_I_ALLEGIANCE_NPC And $alleg <> $GC_I_ALLEGIANCE_ALLY Then ContinueLoop
                Local $ax = Agent_GetAgentInfo($agents[$i], "X")
                Local $ay = Agent_GetAgentInfo($agents[$i], "Y")
                Local $d = Sqrt(($ax - $px)^2 + ($ay - $py)^2)
                If $d < $bestD Then
                    $bestD = $d
                    $best = $agents[$i]
                EndIf
            Next
        EndIf
        $ferry = $best
    EndIf
    If $ferry = 0 Then
        Out("[SD] EnterSunDocks: no ferryman ni NPC cerca del portal")
        Return False
    EndIf
    Out("[SD] EnterSunDocks: NPC model=" & Agent_GetAgentInfo($ferry, "PlayerNumber") & " -> GoNPC")
    Agent_ChangeTarget($ferry)
    Sleep(300)
    Agent_GoNPC($ferry)
    Sleep(1500)
    Local $dialogs[4] = [0x84, 0x827D04, 0x827D01, 0x827D03]
    Local $dNames[4] = ["ready", "Update", "Accept", "About"]
    Local $oldMap = Map_GetMapID()
    For $d = 0 To 3
        If Map_GetMapID() <> $oldMap Then ExitLoop
        Out("[SD] EnterSunDocks: Ui_Dialog " & $dNames[$d])
        Bot_Dialog($dialogs[$d])
        Local $td = TimerInit()
        While Map_GetMapID() = $oldMap And TimerDiff($td) < 4000
            Sleep(300)
        WEnd
    Next
    Map_WaitMapLoading(543, $GC_I_MAP_TYPE_OUTPOST)
    _SD_WaitForNPCs(8000)
    Out("[SD] EnterSunDocks: mapa final=" & Map_GetMapID())
    Return (Map_GetMapID() = 543)
EndFunc
Func _SD_AddHenchmen()
    Local $aModels[6] = [4607, 4609, 4610, 4611, 4612, 4613]
    If Map_GetInstanceInfo("Type") = $GC_I_MAP_TYPE_OUTPOST Then
        Local $tWaitH = TimerInit()
        While Not Bot_ShouldStop() And TimerDiff($tWaitH) < 15000
            If Agent_GetAgentByPlayerNumber($aModels[0]) <> 0 Then ExitLoop
            Sleep(1000)
        WEnd
    EndIf
    Local $added = 0
    For $j = 0 To 5
        Local $hModel = $aModels[$j]
        If _AutoParty_IsHenchModelInParty($hModel) Then
            Out("[SD] AddHenchmen: model=" & $hModel & " ya en party -> skip")
            ContinueLoop
        EndIf
        Local $hAg = Agent_GetAgentByPlayerNumber($hModel)
        If $hAg = 0 Then
            Out("[SD] AddHenchmen: model=" & $hModel & " no encontrado -> skip")
            ContinueLoop
        EndIf
        Local $hn = Agent_GetAgentInfo($hAg, "Name")
        Out("[SD] AddHenchmen: Party_AddNpc model=" & $hModel & " '" & $hn & "'")
        Party_AddNpc($hAg)
        Sleep(700)
        $added += 1
    Next
    Sleep(500)
    Local $pSz = 1 + Party_GetMyPartyInfo("ArrayHeroPartyMemberSize") _
                   + Party_GetMyPartyInfo("ArrayHenchmanPartyMemberSize")
    Out("[SD] AddHenchmen: " & $added & " aÃ±adidos, party=" & $pSz & "/8")
EndFunc
Func _SD_EnterIssnur()
    If Map_GetMapID() <> 489 Then
        Out("[SD] EnterIssnur: no en Kodlonu (map=" & Map_GetMapID() & ")")
        Return False
    EndIf
    Local $gadgetX = -4401, $gadgetY = -2101
    Local $crossX  = -4901, $crossY  = -2501
    Out("[SD] EnterIssnur: nav al portal (" & $gadgetX & "," & $gadgetY & ")...")
    Map_Move($gadgetX, $gadgetY, 0)
    Local $tPre = TimerInit(), $tRePre = TimerInit()
    While Not Bot_ShouldStop() And TimerDiff($tPre) < 40000
        If Map_GetMapID() = 486 Then ExitLoop
        Local $myX = Agent_GetAgentInfo(-2, "X"), $myY = Agent_GetAgentInfo(-2, "Y")
        If Sqrt(($myX-$gadgetX)^2+($myY-$gadgetY)^2) < 800 Then ExitLoop
        If TimerDiff($tRePre) >= 3000 Then
            Map_Move($gadgetX, $gadgetY, 0)
            $tRePre = TimerInit()
        EndIf
        Sleep(400)
    WEnd
    If Map_GetMapID() = 486 Then
        Map_WaitMapLoading(486, $GC_I_MAP_TYPE_EXPLORABLE)
        _SD_WaitForNPCs(8000)
        Return True
    EndIf
    Local $portalGadget = Gadget_FindNearestToXY($gadgetX, $gadgetY, 600)
    If $portalGadget > 0 Then
        Out("[SD] EnterIssnur: gadget id=" & $portalGadget & " -> GoSignpost")
        Agent_ChangeTarget($portalGadget)
        Sleep(300)
        Agent_GoSignpost($portalGadget)
        Local $tGad = TimerInit()
        While TimerDiff($tGad) < 8000
            If Map_GetMapID() = 486 Then ExitLoop
            Sleep(400)
        WEnd
        If Map_GetMapID() = 486 Then
            Out("[SD] EnterIssnur: GoSignpost OK -> Issnur Isles")
            Map_WaitMapLoading(486, $GC_I_MAP_TYPE_EXPLORABLE)
            _SD_WaitForNPCs(8000)
            Return True
        EndIf
        Out("[SD] EnterIssnur: GoSignpost no cambiÃ³ mapa -> ForceCrossPortal")
    Else
        Out("[SD] EnterIssnur: gadget no encontrado -> ForceCrossPortal")
    EndIf
    Local $offsets[9][2] = [[0,0],[-400,-300],[400,300],[0,-400],[0,400],[-400,300],[-400,-300],[400,-300],[400,300]]
    Local $t = TimerInit(), $tRe = TimerInit(), $tChg = TimerInit()
    Local $idx = 0, $curX = $gadgetX, $curY = $gadgetY
    Map_Move($curX, $curY, 0)
    Out("[SD] EnterIssnur: ForceCrossPortal SW (" & $curX & "," & $curY & ")")
    While Not Bot_ShouldStop() And TimerDiff($t) < 45000
        If Map_GetMapID() = 486 Then ExitLoop
        Sleep(400)
        If Map_GetMapID() = 486 Then ExitLoop
        If TimerDiff($tRe) >= 2500 Then
            Map_Move($curX, $curY, 0)
            $tRe = TimerInit()
        EndIf
        If TimerDiff($tChg) >= 5000 Then
            $idx = Mod($idx + 1, 9)
            $curX = $gadgetX + $offsets[$idx][0]
            $curY = $gadgetY + $offsets[$idx][1]
            Map_Move($curX, $curY, 0)
            $tChg = TimerInit()
            $tRe  = TimerInit()
        EndIf
    WEnd
    If Map_GetMapID() = 486 Then
        Out("[SD] EnterIssnur: ForceCrossPortal OK -> Issnur Isles")
        Map_WaitMapLoading(486, $GC_I_MAP_TYPE_EXPLORABLE)
        _SD_WaitForNPCs(8000)
        Return True
    EndIf
    Out("[SD] EnterIssnur: FAIL (map=" & Map_GetMapID() & ")")
    Return False
EndFunc
Func _SD_JerekIsFriendly()
    Local $tF = TimerInit()
    While Not Bot_ShouldStop() And TimerDiff($tF) < 10000
        Local $agents = Agent_GetAgentArray($GC_I_AGENT_TYPE_LIVING)
        If IsArray($agents) Then
            For $i = 1 To UBound($agents) - 1
                If $agents[$i] = 0 Then ContinueLoop
                If Agent_GetAgentInfo($agents[$i], "PlayerNumber") <> 4892 Then ContinueLoop
                Local $a = Agent_GetAgentInfo($agents[$i], "Allegiance")
                If $a = $GC_I_ALLEGIANCE_NPC Or $a = $GC_I_ALLEGIANCE_ALLY Then Return True
            Next
        EndIf
        Sleep(1000)
    WEnd
    Return False
EndFunc
Func _SD_FindJerek()
    If Map_GetMapID() <> 486 Then
        Out("[SD] FindJerek: no en Issnur (map=" & Map_GetMapID() & ")")
        Return False
    EndIf
    Local $npcX = 13873, $npcY = 1043
    Local $myX0 = Agent_GetAgentInfo(-2, "X"), $myY0 = Agent_GetAgentInfo(-2, "Y")
    Local $dJerek0 = Sqrt(($myX0 - $npcX)^2 + ($myY0 - $npcY)^2)
    Out("[SD] FindJerek: pos=(" & Round($myX0) & "," & Round($myY0) & ") distJerek=" & Round($dJerek0) & "u")
    If $dJerek0 > 1500 Then
        Local $waypoints[3][2] = [[22000, 5500], [16000, 2000], [13873, 1043]]
        For $wi = 0 To 2
            Local $wpX = $waypoints[$wi][0], $wpY = $waypoints[$wi][1]
            Local $myXi = Agent_GetAgentInfo(-2, "X"), $myYi = Agent_GetAgentInfo(-2, "Y")
            If Sqrt(($myXi-$wpX)^2+($myYi-$wpY)^2) < 700 Then ContinueLoop
            Out("[SD] FindJerek: WP" & $wi & " Map_Move(" & $wpX & "," & $wpY & ")...")
            Map_Move($wpX, $wpY, 0)
            Local $tWP = TimerInit(), $tReWP = TimerInit()
            While Not Bot_ShouldStop() And TimerDiff($tWP) < 45000
                Local $cx = Agent_GetAgentInfo(-2, "X"), $cy = Agent_GetAgentInfo(-2, "Y")
                Local $d = Sqrt(($cx - $wpX)^2 + ($cy - $wpY)^2)
                Out("[SD] FindJerek: pos=(" & Round($cx) & "," & Round($cy) & ") dWP=" & Round($d) & "u")
                If $d < 700 Then ExitLoop
                If Sqrt(($cx-$npcX)^2+($cy-$npcY)^2) < 700 Then ExitLoop
                If TimerDiff($tReWP) >= 4000 Then
                    Map_Move($wpX, $wpY, 0)
                    $tReWP = TimerInit()
                EndIf
                Sleep(1000)
            WEnd
        Next
    Else
        Out("[SD] FindJerek: ya cerca de Jerek (" & Round($dJerek0) & "u), saltando navegaciÃ³n")
    EndIf
    Local $myXJ = Agent_GetAgentInfo(-2, "X"), $myYJ = Agent_GetAgentInfo(-2, "Y")
    Out("[SD] FindJerek: pos final=(" & Round($myXJ) & "," & Round($myYJ) & ")")
    Local $closest = Agent_GetAgentByPlayerNumber(4892)
    If $closest = 0 Then
        Local $tWaitNPC = TimerInit()
        While TimerDiff($tWaitNPC) < 10000 And $closest = 0
            $closest = Agent_GetAgentByPlayerNumber(4892)
            If $closest = 0 Then Sleep(500)
        WEnd
    EndIf
    If $closest = 0 Then
        Out("[SD] FindJerek: Jerek NPC no encontrado antes de acercarse -> dump")
        _SD_DumpAllNPCs_BTR()
        Return False
    EndIf
    Local $jx = Agent_GetAgentInfo($closest, "X"), $jy = Agent_GetAgentInfo($closest, "Y")
    Local $nm = Agent_GetAgentInfo($closest, "Name")
    Local $myXc = Agent_GetAgentInfo(-2, "X"), $myYc = Agent_GetAgentInfo(-2, "Y")
    Local $charToJerek = Sqrt(($myXc - $jx)^2 + ($myYc - $jy)^2)
    Out("[SD] FindJerek: '" & $nm & "' pos=(" & Round($jx) & "," & Round($jy) & ") charDist=" & Round($charToJerek) & "u")
    If $charToJerek > 300 Then
        Map_Move($jx, $jy, 0)
        Local $tClose = TimerInit(), $tReClose = TimerInit()
        While Not Bot_ShouldStop() And TimerDiff($tClose) < 15000
            $myXc = Agent_GetAgentInfo(-2, "X")
            $myYc = Agent_GetAgentInfo(-2, "Y")
            If Sqrt(($myXc-$jx)^2+($myYc-$jy)^2) < 300 Then ExitLoop
            If TimerDiff($tReClose) >= 3000 Then
                Map_Move($jx, $jy, 0)
                $tReClose = TimerInit()
            EndIf
            Sleep(400)
        WEnd
    EndIf
    Out("[SD] FindJerek: en rango (<300u), esperando transformaciÃ³n (2s)...")
    Sleep(2000)
    Local $jerekAg = Agent_GetAgentByPlayerNumber(4892)
    Local $jerekAlleg = 0
    If $jerekAg <> 0 Then $jerekAlleg = Agent_GetAgentInfo($jerekAg, "Allegiance")
    Out("[SD] FindJerek: Jerek alleg=" & $jerekAlleg & " (3=ENEMY, 6=NPC)")
    If $jerekAlleg = $GC_I_ALLEGIANCE_ENEMY Then
        Out("[SD] FindJerek: Jerek ENEMIGO -> target + attack hasta pacificar")
        Local $tAttack = TimerInit()
        While Not Bot_ShouldStop() And TimerDiff($tAttack) < 60000
            $jerekAg = Agent_GetAgentByPlayerNumber(4892)
            If $jerekAg = 0 Then ExitLoop
            If Agent_GetAgentInfo($jerekAg, "IsDead") Then
                Out("[SD] FindJerek: Jerek MUERTO tras " & Round(TimerDiff($tAttack)/1000,1) & "s -> fin combate")
                ExitLoop
            EndIf
            $jerekAlleg = Agent_GetAgentInfo($jerekAg, "Allegiance")
            If $jerekAlleg <> $GC_I_ALLEGIANCE_ENEMY Then
                Out("[SD] FindJerek: Jerek pacificado (alleg=" & $jerekAlleg & ") tras " & Round(TimerDiff($tAttack)/1000,1) & "s")
                ExitLoop
            EndIf
            Agent_ChangeTarget($jerekAg)
            Sleep(200)
            Agent_Attack($jerekAg, False)
            Combat_ClearZone(1250, 5000)
        WEnd
    ElseIf $jerekAlleg = $GC_I_ALLEGIANCE_NPC Or $jerekAlleg = $GC_I_ALLEGIANCE_ALLY Then
        Out("[SD] FindJerek: Jerek YA pacificado (alleg=" & $jerekAlleg & ") - skip combate")
    Else
        Out("[SD] FindJerek: Jerek alleg desconocido -> ClearZone fallback")
        Combat_ClearZone(1250, 30000)
    EndIf
    Out("[SD] FindJerek: combate terminado")
    Out("[SD] FindJerek: esperando 15s a que Jerek reaparezca como NPC hablable...")
    Bot_Sleep(15000)
    Local $jerekPC = 0
    Local $tPC = TimerInit()
    While Not Bot_ShouldStop() And TimerDiff($tPC) < 15000 And $jerekPC = 0
        $jerekPC = Agent_GetAgentByPlayerNumber(4892)
        If $jerekPC <> 0 Then
            Local $allegJ = Agent_GetAgentInfo($jerekPC, "Allegiance")
            If $allegJ = $GC_I_ALLEGIANCE_ENEMY Then
                $jerekPC = 0  
            EndIf
        EndIf
        If $jerekPC = 0 Then Sleep(500)
    WEnd
    If $jerekPC = 0 Then
        Out("[SD] FindJerek: Jerek post-combate no encontrado -> dump")
        _SD_DumpAllNPCs_BTR()
        Return False
    EndIf
    $jx = Agent_GetAgentInfo($jerekPC, "X")
    $jy = Agent_GetAgentInfo($jerekPC, "Y")
    $nm = Agent_GetAgentInfo($jerekPC, "Name")
    Local $allegFinal = Agent_GetAgentInfo($jerekPC, "Allegiance")
    Out("[SD] FindJerek: Jerek post-combate '" & $nm & "' alleg=" & $allegFinal & " pos=(" & Round($jx) & "," & Round($jy) & ")")
    Local $myXD = Agent_GetAgentInfo(-2, "X"), $myYD = Agent_GetAgentInfo(-2, "Y")
    Local $dToJ = Sqrt(($myXD-$jx)^2+($myYD-$jy)^2)
    Out("[SD] FindJerek: distancia a Jerek=" & Round($dToJ) & "u")
    If $dToJ > 200 Then
        Map_Move($jx, $jy, 0)
        Local $tNav2 = TimerInit(), $tReNav2 = TimerInit()
        While TimerDiff($tNav2) < 12000
            $myXD = Agent_GetAgentInfo(-2, "X")
            $myYD = Agent_GetAgentInfo(-2, "Y")
            If Sqrt(($myXD-$jx)^2+($myYD-$jy)^2) < 200 Then ExitLoop
            If TimerDiff($tReNav2) >= 3000 Then
                Map_Move($jx, $jy, 0)
                $tReNav2 = TimerInit()
            EndIf
            Sleep(400)
        WEnd
        $myXD = Agent_GetAgentInfo(-2, "X")
        $myYD = Agent_GetAgentInfo(-2, "Y")
        Out("[SD] FindJerek: pos tras nav=(" & Round($myXD) & "," & Round($myYD) & ") dist=" & Round(Sqrt(($myXD-$jx)^2+($myYD-$jy)^2)) & "u")
    EndIf
    Sleep(3000)
    Local $mtPre = Quest_GetQuestInfo(637, "MapTo")
    Local $lsPre = Quest_GetQuestInfo(637, "LogState")
    Out("[SD] FindJerek: pre-dialog MapTo=" & $mtPre & " LogState=" & $lsPre)
    Agent_ChangeTarget($jerekPC)
    Sleep(300)
    Agent_GoNPC($jerekPC)
    Sleep(2500)
    Local $dialogHexes[3] = [0x827D04, 0x84, 0x827904]
    For $dh = 0 To 2
        Out("[SD] FindJerek: Bot_Dialog(" & Hex($dialogHexes[$dh], 6) & ") con Jerek (intento " & ($dh+1) & "/3)")
        Bot_Dialog($dialogHexes[$dh])
        Sleep(3000)
        Local $mtPost = Quest_GetQuestInfo(637, "MapTo")
        Local $lsPost = Quest_GetQuestInfo(637, "LogState")
        Out("[SD] FindJerek: tras dialog MapTo=" & $mtPost & " LogState=" & $lsPost)
        If $mtPost <> $mtPre Or $lsPost <> $lsPre Or $lsPost <= 0 Then
            Out("[SD] FindJerek: quest avanzo con dialog " & Hex($dialogHexes[$dh], 6))
            Return True
        EndIf
        Agent_GoNPC($jerekPC)
        Sleep(1500)
    Next
    Out("[SD] FindJerek: FAIL - ningun dialog hex actualizo la quest tras 3 intentos")
    Return False
EndFunc
Func _SD_DumpAllNPCs_BTR()
    Local $agents = Agent_GetAgentArray($GC_I_AGENT_TYPE_LIVING)
    If Not IsArray($agents) Then
        Out("[SD DUMP] no hay agentes")
        Return
    EndIf
    Out("[SD DUMP] === NPCs/Allies en mapa " & Map_GetMapID() & " ===")
    Local $count = 0
    For $i = 0 To UBound($agents) - 1
        If $agents[$i] = 0 Then ContinueLoop
        Local $alleg = Agent_GetAgentInfo($agents[$i], "Allegiance")
        If $alleg <> $GC_I_ALLEGIANCE_NPC And $alleg <> $GC_I_ALLEGIANCE_ALLY Then ContinueLoop
        Local $model = Agent_GetAgentInfo($agents[$i], "PlayerNumber")
        Local $x = Agent_GetAgentInfo($agents[$i], "X")
        Local $y = Agent_GetAgentInfo($agents[$i], "Y")
        Local $name = Agent_GetAgentInfo($agents[$i], "Name")
        Out("[SD DUMP] model=" & $model & " alleg=" & $alleg & " pos=(" & Round($x) & "," & Round($y) & ") name='" & $name & "'")
        $count += 1
    Next
    Out("[SD DUMP] " & $count & " NPCs/Allies, === FIN ===")
EndFunc
Func _SD_TravelToMap($mapID, $mapName)
    If Map_GetMapID() = $mapID Then Return True
    Out("[SD] Travel: Map_RndTravel a " & $mapName & " (" & $mapID & ") retry loop...")
    For $retry = 1 To 5
        Map_RndTravel($mapID, False)
        Map_WaitMapLoading($mapID, $GC_I_MAP_TYPE_OUTPOST)
        If Map_GetMapID() = $mapID Then
            Out("[SD] En " & $mapName & " (" & $mapID & ") tras " & $retry & " intento(s)")
            _SD_WaitForNPCs(8000)
            Return True
        EndIf
        Out("[SD] Intento " & $retry & " fallo (map=" & Map_GetMapID() & "), esperando 3s...")
        Sleep(3000)
    Next
    Out("[SD] Travel FAIL: no se llego a " & $mapName & " (" & $mapID & ")")
    Return False
EndFunc
Func _SD_FindDehvad($wpX, $wpY, $model)
    Local $best = 0, $bestD = 1000
    Local $agArr = Agent_GetAgentArray($GC_I_AGENT_TYPE_LIVING)
    If Not IsArray($agArr) Then Return 0
    For $i = 0 To UBound($agArr) - 1
        If $agArr[$i] = 0 Then ContinueLoop
        Local $alleg = Agent_GetAgentInfo($agArr[$i], "Allegiance")
        If $alleg <> $GC_I_ALLEGIANCE_NPC And $alleg <> $GC_I_ALLEGIANCE_ALLY Then ContinueLoop
        If Agent_GetAgentInfo($agArr[$i], "PlayerNumber") <> $model Then ContinueLoop
        Local $ax = Agent_GetAgentInfo($agArr[$i], "X")
        Local $ay = Agent_GetAgentInfo($agArr[$i], "Y")
        Local $d = Sqrt(($ax - $wpX)^2 + ($ay - $wpY)^2)
        Local $nm = Agent_GetAgentInfo($agArr[$i], "Name")
        Out("[SD] FindDehvad: model=" & $model & " name='" & $nm & "' pos=(" & Round($ax) & "," & Round($ay) & ") d=" & Round($d))
        If $d < $bestD Then
            $bestD = $d
            $best = $agArr[$i]
        EndIf
    Next
    If $best = 0 Then
        Out("[SD] FindDehvad: model=" & $model & " no aparece -> fallback NPC/ally mas cercano al waypoint (" & $wpX & "," & $wpY & ")")
        For $i = 0 To UBound($agArr) - 1
            If $agArr[$i] = 0 Then ContinueLoop
            Local $alleg2 = Agent_GetAgentInfo($agArr[$i], "Allegiance")
            If $alleg2 <> $GC_I_ALLEGIANCE_NPC And $alleg2 <> $GC_I_ALLEGIANCE_ALLY Then ContinueLoop
            Local $ax2 = Agent_GetAgentInfo($agArr[$i], "X")
            Local $ay2 = Agent_GetAgentInfo($agArr[$i], "Y")
            Local $d2 = Sqrt(($ax2 - $wpX)^2 + ($ay2 - $wpY)^2)
            If $d2 > 800 Then ContinueLoop
            Local $nm2 = Agent_GetAgentInfo($agArr[$i], "Name")
            If $d2 < $bestD Then
                $bestD = $d2
                $best = $agArr[$i]
                Out("[SD] FindDehvad fallback: model=" & Agent_GetAgentInfo($agArr[$i], "PlayerNumber") & " name='" & $nm2 & "' d=" & Round($d2))
            EndIf
        Next
    EndIf
    Return $best
EndFunc
Func _SD_DoReward()
    Local $sd_quest = 637
    Local $logState = Quest_GetQuestInfo($sd_quest, "LogState")
    Local $mapTo    = Quest_GetQuestInfo($sd_quest, "MapTo")
    Out("[SD] DoReward: map=" & Map_GetMapID() & " LogState=" & $logState & " MapTo=" & $mapTo)
    If $logState <= 0 Then
        Out("[SD] DoReward: quest 637 ya completada")
        Return True
    EndIf
    If $mapTo = 543 Then
        Out("[SD] DoReward Fase A: update Hayao (0x827D04) para cambiar MapTo 543â†’431")
        If Map_GetMapID() <> 543 Then
            If Map_GetMapID() <> 449 Then
                Map_RndTravel(449, False)
                Map_WaitMapLoading(449, $GC_I_MAP_TYPE_OUTPOST)
            EndIf
            If Not _SD_EnterSunDocks() Then
                Out("[SD] DoReward FAIL Fase A: no se pudo entrar a Sun Docks")
                Return False
            EndIf
        EndIf
        _SD_WaitForNPCs(8000)
        Local $hayao = _SD_FindNPC("Hayao")
        If $hayao = 0 Then
            Out("[SD] DoReward FAIL Fase A: Hayao no encontrado")
            Return False
        EndIf
        Local $hx = Agent_GetAgentInfo($hayao, "X"), $hy = Agent_GetAgentInfo($hayao, "Y")
        Map_Move($hx, $hy, 0)
        Local $tNavA = TimerInit()
        While TimerDiff($tNavA) < 8000
            If Sqrt((Agent_GetAgentInfo(-2,"X")-$hx)^2+(Agent_GetAgentInfo(-2,"Y")-$hy)^2) < 300 Then ExitLoop
            Sleep(400)
        WEnd
        Agent_ChangeTarget($hayao)
        Sleep(300)
        Agent_GoNPC($hayao)
        Sleep(2500)
        Out("[SD] DoReward Fase A: Bot_Dialog(0x827D04)")
        Bot_Dialog(0x827D04)
        Local $tWaitA = TimerInit()
        While TimerDiff($tWaitA) < 8000
            $mapTo = Quest_GetQuestInfo($sd_quest, "MapTo")
            $logState = Quest_GetQuestInfo($sd_quest, "LogState")
            If $mapTo = 431 Or $logState <= 0 Then ExitLoop
            Sleep(500)
        WEnd
        Out("[SD] DoReward Fase A: MapTo=" & $mapTo & " LogState=" & $logState)
        If $logState <= 0 Then Return True
        If $mapTo <> 431 Then
            Out("[SD] DoReward WARN: MapTo=" & $mapTo & " tras update, esperando en Sunspear Hall de todas formas")
        EndIf
    EndIf
    Out("[SD] DoReward Fase B: 0x827D04 con Puuba en Sunspear Great Hall (431)")
    If Map_GetMapID() <> 431 Then
        If Not _SD_TravelToMap(431, "Sunspear Great Hall") Then
            Out("[SD] DoReward FAIL Fase B: no se pudo llegar a Sunspear Hall")
            Return False
        EndIf
    EndIf
    _SD_WaitForNPCs(8000)
    Local $puubaB = _SD_FindNPC("Puuba")
    If $puubaB = 0 Then
        Out("[SD] DoReward FAIL Fase B: Puuba no encontrada")
        Return False
    EndIf
    Local $pbx = Agent_GetAgentInfo($puubaB, "X"), $pby = Agent_GetAgentInfo($puubaB, "Y")
    Map_Move($pbx, $pby, 0)
    Local $tNavB = TimerInit()
    While TimerDiff($tNavB) < 8000
        If Sqrt((Agent_GetAgentInfo(-2,"X")-$pbx)^2+(Agent_GetAgentInfo(-2,"Y")-$pby)^2) < 300 Then ExitLoop
        Sleep(400)
    WEnd
    Agent_ChangeTarget($puubaB)
    Sleep(300)
    Agent_GoNPC($puubaB)
    Sleep(2500)
    Out("[SD] DoReward Fase B: Bot_Dialog(0x827D04)")
    Bot_Dialog(0x827D04)
    Local $tWaitB = TimerInit(), $mapToB = 431
    While TimerDiff($tWaitB) < 8000
        $logState = Quest_GetQuestInfo($sd_quest, "LogState")
        $mapToB   = Quest_GetQuestInfo($sd_quest, "MapTo")
        If $logState <= 0 Or $mapToB <> 431 Then ExitLoop
        Sleep(500)
    WEnd
    $mapToB = Quest_GetQuestInfo($sd_quest, "MapTo")
    Out("[SD] DoReward Fase B: LogState=" & $logState & " MapTo=" & $mapToB)
    If $logState <= 0 Then
        Out("[SD] DoReward OK: quest 637 completada")
        Return True
    EndIf
    If $mapToB = 431 Then
        Out("[SD] DoReward Fase B: MapTo=431 sin cambio â†’ intentando Ui_RewardQuest(637)")
        Ui_RewardQuest($sd_quest)
        Sleep(5000)
        $logState = Quest_GetQuestInfo($sd_quest, "LogState")
        Out("[SD] DoReward Fase B: LogState tras RewardQuest=" & $logState)
        If $logState <= 0 Then
            Out("[SD] DoReward OK: quest 637 completada via RewardQuest")
            Return True
        EndIf
    EndIf
    If $mapToB = 486 Then
        Out("[SD] DoReward Fase C: MapTo=486 â†’ escoltando Jerek en Issnur...")
        If Not _SD_EscortJerek() Then
            Out("[SD] DoReward FAIL Fase C: escolta fallida")
            Return False
        EndIf
        $logState = Quest_GetQuestInfo($sd_quest, "LogState")
        Local $mapToC = Quest_GetQuestInfo($sd_quest, "MapTo")
        Out("[SD] Tras escolta: ls=" & $logState & " MapTo=" & $mapToC)
        If $logState <= 0 Then Return True
        Out("[SD] Fase C â†’ reward con MapTo=" & $mapToC)
        If $mapToC = 431 Then
            If Not _SD_TravelToMap(431, "Sunspear Great Hall") Then Return False
            Local $puubaC = _SD_FindNPC("Puuba")
            If $puubaC <> 0 Then
                Agent_GoNPC($puubaC)
                Sleep(2500)
                Bot_Dialog(0x827D04)
                Sleep(5000)
            EndIf
            Ui_RewardQuest($sd_quest)
            Sleep(5000)
            Return Quest_GetQuestInfo($sd_quest, "LogState") <= 0
        EndIf
        Ui_RewardQuest($sd_quest)
        Sleep(5000)
        Return Quest_GetQuestInfo($sd_quest, "LogState") <= 0
    EndIf
    Out("[SD] FAIL DoReward: LogState=" & $logState & " MapTo=" & $mapToB & " sin manejar")
    Return False
EndFunc
Func _SD_EscortJerek()
    Out("[SD] EscortJerek: entrando a Issnur (486) para escolta")
    If Map_GetMapID() <> 486 Then
        If Not _SD_TravelToMap(489, "Kodlonu Hamlet") Then Return False
        _SD_AddHenchmen()
        If Not _SD_EnterIssnur() Then Return False
    EndIf
    _SD_WaitForNPCs(10000)
    Out("[SD] EscortJerek: nav hacia Jerek (13873,1043) antes de buscar")
    _Mission_DoNavThrough(13873, 1043)
    Local $jerek = 0, $tFind = TimerInit()
    While Not Bot_ShouldStop() And TimerDiff($tFind) < 20000 And $jerek = 0
        Local $agents = Agent_GetAgentArray($GC_I_AGENT_TYPE_LIVING)
        If IsArray($agents) Then
            For $i = 0 To UBound($agents)-1
                If $agents[$i] = 0 Then ContinueLoop
                If Agent_GetAgentInfo($agents[$i], "PlayerNumber") <> 4892 Then ContinueLoop
                Local $allegE = Agent_GetAgentInfo($agents[$i], "Allegiance")
                If $allegE = $GC_I_ALLEGIANCE_NPC Or $allegE = $GC_I_ALLEGIANCE_ALLY Then
                    $jerek = $agents[$i]
                    ExitLoop
                EndIf
            Next
        EndIf
        If $jerek = 0 Then Sleep(1000)
    WEnd
    If $jerek = 0 Then
        Out("[SD] EscortJerek: amistoso no encontrado, comprobar si esta hostil...")
        Local $hostile = False
        Local $agentsH = Agent_GetAgentArray($GC_I_AGENT_TYPE_LIVING)
        If IsArray($agentsH) Then
            For $i = 1 To UBound($agentsH) - 1
                If $agentsH[$i] = 0 Then ContinueLoop
                If Agent_GetAgentInfo($agentsH[$i], "PlayerNumber") <> 4892 Then ContinueLoop
                If Agent_GetAgentInfo($agentsH[$i], "Allegiance") = $GC_I_ALLEGIANCE_ENEMY Then $hostile = True
            Next
        EndIf
        If $hostile Then
            Out("[SD] EscortJerek: Jerek hostil (instancia fresca) -> pacificar aqui + seguir")
            _SD_FindJerek()
            If _SD_JerekIsFriendly() Then
                $jerek = Agent_GetAgentByPlayerNumber(4892)
                Out("[SD] EscortJerek: pacificado en esta instancia -> siguiendo...")
            EndIf
        EndIf
    EndIf
    If $jerek = 0 Then
        Out("[SD] EscortJerek: Jerek amistoso no encontrado en 20s (+pacificar)")
        Return False
    EndIf
    Out("[SD] EscortJerek: '" & Agent_GetAgentInfo($jerek,"Name") & "' encontrado, siguiendo...")
    Local $mapToEsc = Quest_GetQuestInfo(637, "MapTo")
    Local $tEscort  = TimerInit()
    Local $tSinceTalk = TimerInit()
    Local $tSinceNav  = TimerInit()
    While Not Bot_ShouldStop() And TimerDiff($tEscort) < 300000
        Local $ls2 = Quest_GetQuestInfo(637, "LogState")
        Local $mt2 = Quest_GetQuestInfo(637, "MapTo")
        If $ls2 <= 0 Or $mt2 <> $mapToEsc Then
            Out("[SD] EscortJerek: avance ls=" & $ls2 & " MapTo=" & $mt2)
            Return True
        EndIf
        Local $jx = Agent_GetAgentInfo($jerek, "X"), $jy = Agent_GetAgentInfo($jerek, "Y")
        Local $myX = Agent_GetAgentInfo(-2, "X"), $myY = Agent_GetAgentInfo(-2, "Y")
        Local $dToJ = Sqrt(($myX-$jx)^2+($myY-$jy)^2)
        If $dToJ < 150 And TimerDiff($tSinceTalk) > 15000 Then
            Out("[SD] EscortJerek: Jerek quieto a " & Round($dToJ) & "u -> hablarle para avanzar")
            Agent_ChangeTarget($jerek)
            Sleep(300)
            Agent_GoNPC($jerek)
            Sleep(2000)
            Bot_Dialog(0x827D04)
            Sleep(2500)
            Local $mtAfter = Quest_GetQuestInfo(637, "MapTo")
            Local $lsAfter = Quest_GetQuestInfo(637, "LogState")
            Out("[SD] EscortJerek: tras dialog MapTo=" & $mtAfter & " LogState=" & $lsAfter)
            If $mtAfter <> $mapToEsc Or $lsAfter <= 0 Then
                If $lsAfter <= 0 Then
                    Out("[SD] EscortJerek: LogState=0 -> quest completada via dialog")
                    Return True
                EndIf
                Out("[SD] EscortJerek: MapTo cambio -> continuar")
            EndIf
            $tSinceTalk = TimerInit()
        EndIf
        If $dToJ > 400 And TimerDiff($tSinceNav) > 3000 Then
            Map_Move($jx, $jy, 0)
            $tSinceNav = TimerInit()
        EndIf
        Sleep(500)
    WEnd
    Out("[SD] EscortJerek: timeout 300s sin avance")
    Return False
EndFunc