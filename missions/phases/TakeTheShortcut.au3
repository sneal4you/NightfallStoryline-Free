#include-once
Global Const $TUT_KORMIR_X = 10331
Global Const $TUT_KORMIR_Y = 6387
Global Const $TUT_KORMIR_MODEL = $GC_I_MODEL_ID_NF_KORMIR          
Global Const $TUT_JAHDUGAR_X = 4784
Global Const $TUT_JAHDUGAR_Y = -1881
Global Const $TUT_JAHDUGAR_MODEL = $GC_I_MODEL_ID_NF_GENERIC_A     
Global Const $TUT_QUEST_ID = $GC_I_QUEST_ID_TAKETHESHORTCUT_SKIPTUTORIAL  
Global Const $TUT_DEST_MAP_ID = $GC_I_MAP_ID_CHAHBEK_VILLAGE_OUTPOST    
Func _Tut_IsDone()
    For $i = 1 To 7
        If Party_GetMyPartyHeroInfo($i, "HeroID") = 6 Then Return True
    Next
    Return False
EndFunc
Func Quest_Tutorial_Part1_Run()
    Out("[Tutorial] Part 1/3: cinematic + Kormir (aceptar quest 677)")
    If _Tut_IsDone() Then
        Out("[Tutorial] Part 1: Koss ya en party -> done")
        Return True
    EndIf
    If Map_GetMapID() = $TUT_DEST_MAP_ID Then
        Out("[Tutorial] Part 1: ya en Chahbek (map 544) -> done")
        Return True
    EndIf
    Local $logState677 = Quest_GetQuestInfo($TUT_QUEST_ID, "LogState")
    Out("[Tutorial] Part 1 estado: map=" & Map_GetMapID() & " quest677_LogState=" & $logState677)
    If $logState677 = 33 Or $logState677 = 35 Then
        Out("[Tutorial] Part 1: quest 677 ya aceptada (LogState=" & $logState677 & ") -> done")
        Return True
    EndIf
    Out("[Tutorial] Part 1: Esperar/skip welcome-cinematic")
    Cinematic_WaitAndSkip(8000, 25000)
    Sleep(1500)
    Out("[Tutorial] Part 1: Navegar a Kormir con Map_Move (pathfinder no fiable en map 490)")
    Local $tKorm = TimerInit()
    Local $tReemitK = TimerInit()
    Local $kormReached = False
    Map_Move($TUT_KORMIR_X, $TUT_KORMIR_Y, 0)
    While Not Bot_ShouldStop() And TimerDiff($tKorm) < 60000
        If Map_GetMapID() = 0 Then
            Out("[Tutorial] Part 1 FAIL - map=0 durante navegacion a Kormir (GW crash)")
            Return False
        EndIf
        Local $kx = Agent_GetAgentInfo(-2, "X"), $ky = Agent_GetAgentInfo(-2, "Y")
        If Sqrt(($kx-$TUT_KORMIR_X)^2+($ky-$TUT_KORMIR_Y)^2) < 500 Then
            $kormReached = True
            ExitLoop
        EndIf
        Local $knpc = _Quests_FindNearestNPCByModelToWp($TUT_KORMIR_MODEL, $TUT_KORMIR_X, $TUT_KORMIR_Y)
        If $knpc <> 0 And Agent_GetDistance(-2, $knpc) < 800 Then
            $kormReached = True
            ExitLoop
        EndIf
        If TimerDiff($tReemitK) >= 2500 Then
            Map_Move($TUT_KORMIR_X, $TUT_KORMIR_Y, 0)
            $tReemitK = TimerInit()
        EndIf
        Sleep(300)
    WEnd
    If Not $kormReached Then
        Out("[Tutorial] Part 1 FAIL - no se llego a Kormir en 60s")
        Return False
    EndIf
    Out("[Tutorial] Part 1: Hablar con Kormir (model 4916) - aceptar quest 677")
    Local $accepted = False
    For $try = 1 To 3
        Local $knpc2 = _Quests_FindNearestNPCByModelToWp($TUT_KORMIR_MODEL, $TUT_KORMIR_X, $TUT_KORMIR_Y)
        If $knpc2 <> 0 Then
            Agent_ChangeTarget($knpc2)
            Sleep(300)
            Agent_GoNPC($knpc2)
            Sleep(2000)
        EndIf
        Ui_AcceptQuest($TUT_QUEST_ID)
        Sleep(2500)
        If Agent_HasQuest($TUT_QUEST_ID) Then
            $accepted = True
            ExitLoop
        EndIf
        Out("[Tutorial] Part 1 Kormir intento " & $try & "/3 fallo, esperar 3s")
        Sleep(3000)
    Next
    If Not $accepted Then
        Out("[Tutorial] Part 1 FAIL - no se pudo aceptar quest con Kormir tras 3 intentos")
        Return False
    EndIf
    Out("[Tutorial] Part 1 OK - quest 677 aceptada")
    Return True
EndFunc
Func Quest_Tutorial_Part2_Run()
    Out("[Tutorial] Part 2/3: Jahdugar + portal -> Chahbek + skillbar swap")
    If _Tut_IsDone() Then
        Out("[Tutorial] Part 2: Koss ya en party -> done")
        Return True
    EndIf
    If Map_GetMapID() = $TUT_DEST_MAP_ID Then
        Out("[Tutorial] Part 2: ya en Chahbek (map 544) -> done")
        Return True
    EndIf
    Local $logState677 = Quest_GetQuestInfo($TUT_QUEST_ID, "LogState")
    If $logState677 <> 33 And $logState677 <> 35 Then
        Out("[Tutorial] Part 2 FAIL - quest 677 no aceptada (LogState=" & $logState677 & "); la Parte 1 va primero")
        Return False
    EndIf
    Out("[Tutorial] Part 2: navegar a Jahdugar con marker real del quest + NavigateNoCombat")
    Local $jahFound = False
    Local $walkOK = _Quests_WalkToChahbekShortcut()
    If $walkOK Then
        $jahFound = True
        Out("[Tutorial] Part 2: _Quests_WalkToChahbekShortcut OK (mapa cambiado a Chahbek)")
    Else
        Out("[Tutorial] Part 2: _Quests_WalkToChahbekShortcut fallo - fallback a navegacion directa")
    EndIf
    If Not $jahFound Then
        Local $qmarkX = Quest_GetQuestInfo($TUT_QUEST_ID, "MarkerX")
        Local $qmarkY = Quest_GetQuestInfo($TUT_QUEST_ID, "MarkerY")
        If $qmarkX = 0 And $qmarkY = 0 Then
            $qmarkX = $TUT_JAHDUGAR_X
            $qmarkY = $TUT_JAHDUGAR_Y
        EndIf
        Out("[Tutorial] Part 2: fallback Map_Move al marker=(" & Round($qmarkX) & "," & Round($qmarkY) & ")")
        Local $tJahArr2 = TimerInit()
        Local $tReMap2 = TimerInit()
        Map_Move($qmarkX, $qmarkY, 0)
        Sleep(1500)
        While Not Bot_ShouldStop() And TimerDiff($tJahArr2) < 90000
            If Map_GetMapID() = $TUT_DEST_MAP_ID Then
                $jahFound = True
                ExitLoop
            EndIf
            Local $fj2 = _Quests_FindNearestNPCByModelToWp($TUT_JAHDUGAR_MODEL, $TUT_JAHDUGAR_X, $TUT_JAHDUGAR_Y)
            If $fj2 <> 0 And Agent_GetDistance(-2, $fj2) < 800 Then
                $jahFound = True
                ExitLoop
            EndIf
            If TimerDiff($tReMap2) >= 2500 Then
                Map_Move($qmarkX, $qmarkY, 0)
                $tReMap2 = TimerInit()
            EndIf
            Sleep(300)
        WEnd
    EndIf
    If Not $jahFound Then
        Out("[Tutorial] Part 2 FAIL - no se llego a Jahdugar en 90s")
        Return False
    EndIf
    If Not $walkOK Then
        Out("[Tutorial] Part 2: Hablar con Jahdugar - update quest 677")
        Local $jnpc2 = _Quests_FindNearestNPCByModelToWp($TUT_JAHDUGAR_MODEL, $TUT_JAHDUGAR_X, $TUT_JAHDUGAR_Y)
        If $jnpc2 <> 0 Then
            Agent_ChangeTarget($jnpc2)
            Sleep(300)
            Agent_GoNPC($jnpc2)
            Sleep(2000)
        EndIf
        Ui_UpdateQuest($TUT_QUEST_ID)
        Sleep(2000)
        Out("[Tutorial] Part 2: Dialogos adicionales tras Jahdugar (0x84, 0x85)")
        Bot_Dialog(0x84)
        Sleep(2000)
        Bot_Dialog(0x85)
        Sleep(2000)
        Out("[Tutorial] Part 2: Esperar + skip cinematica")
        Cinematic_WaitAndSkip(15000, 30000)
        Out("[Tutorial] Part 2: Esperando transicion a Map " & $TUT_DEST_MAP_ID & " (Chahbek outpost)")
        Local $t = TimerInit()
        Local $arrived = False
        While Not Bot_ShouldStop() And TimerDiff($t) < 30000
            If Map_GetMapID() = $TUT_DEST_MAP_ID Then
                Out("[Tutorial] Part 2: En Chahbek outpost tras " & Round(TimerDiff($t)/1000, 1) & "s")
                $arrived = True
                ExitLoop
            EndIf
            Sleep(500)
        WEnd
        If Not $arrived Then
            Out("[Tutorial] Part 2 FAIL - TIMEOUT 30s esperando Map " & $TUT_DEST_MAP_ID & " (sigue en " & Map_GetMapID() & ")")
            Return False
        EndIf
    EndIf
    Sleep(2000)
    Out("[Tutorial] Part 2: Intercambiar skill 1 <-> 2 (outpost)")
    Local $s1 = Skill_GetSkillbarInfo(1, "SkillID", 0)
    Local $s2 = Skill_GetSkillbarInfo(2, "SkillID", 0)
    Local $s3 = Skill_GetSkillbarInfo(3, "SkillID", 0)
    Local $s4 = Skill_GetSkillbarInfo(4, "SkillID", 0)
    Local $s5 = Skill_GetSkillbarInfo(5, "SkillID", 0)
    Local $s6 = Skill_GetSkillbarInfo(6, "SkillID", 0)
    Local $s7 = Skill_GetSkillbarInfo(7, "SkillID", 0)
    Local $s8 = Skill_GetSkillbarInfo(8, "SkillID", 0)
    Out("[Tutorial] Part 2 skillbar antes: 1=" & $s1 & " 2=" & $s2)
    Skill_LoadSkillBar($s2, $s1, $s3, $s4, $s5, $s6, $s7, $s8, 0)
    Sleep(800)
    Cache_SkillBar()
    Out("[Tutorial] Part 2 OK - en Chahbek, skill 1<->2 intercambiados")
    Return True
EndFunc
Func Quest_Tutorial_Part3_Run()
    Out("[Tutorial] Part 3/3: Cobrar reward quest 677 con Jahdugar + añadir Koss al party")
    If _Tut_IsDone() Then
        Out("[Tutorial] Part 3: Koss ya en party -> done")
        Return True
    EndIf
    Local $npcJ = 0
    Local $tWait = TimerInit()
    While TimerDiff($tWait) < 12000
        $npcJ = Agent_GetAgentByPlayerNumber($TUT_JAHDUGAR_MODEL)
        If $npcJ <> 0 Then ExitLoop
        Sleep(500)
    WEnd
    If $npcJ = 0 Then
        Out("[Tutorial] Part 3 FAIL - Jahdugar (model 4751) no aparecio en 12s en Chahbek")
        Return False
    EndIf
    Local $jX = Agent_GetAgentInfo($npcJ, "X")
    Local $jY = Agent_GetAgentInfo($npcJ, "Y")
    Out("[Tutorial] Part 3: Jahdugar encontrado id=" & $npcJ & " pos=(" & Round($jX, 0) & "," & Round($jY, 0) & ")")
    MoveTo($jX, $jY, 0, 30)
    Sleep(500)
    Agent_ChangeTarget($npcJ)
    Sleep(200)
    Agent_GoNPC($npcJ)
    Sleep(2500)
    Local $logState677 = Quest_GetQuestInfo($TUT_QUEST_ID, "LogState")
    Out("[Tutorial] Part 3: Quest 677 LogState=" & $logState677 & " antes de cobrar")
    Ui_RewardQuest($TUT_QUEST_ID)
    Sleep(4000)
    $logState677 = Quest_GetQuestInfo($TUT_QUEST_ID, "LogState")
    Out("[Tutorial] Part 3: Quest 677 LogState=" & $logState677 & " post-reward")
    If $logState677 = 33 Or $logState677 = 35 Then
        Out("[Tutorial] Part 3 WARN reward no aplicado (LogState=" & $logState677 & ") - retry")
        MoveTo($jX, $jY, 0, 30)
        Sleep(500)
        Agent_ChangeTarget($npcJ)
        Sleep(200)
        Agent_GoNPC($npcJ)
        Sleep(2500)
        Ui_RewardQuest($TUT_QUEST_ID)
        Sleep(4000)
        $logState677 = Quest_GetQuestInfo($TUT_QUEST_ID, "LogState")
        Out("[Tutorial] Part 3: Quest 677 LogState tras retry=" & $logState677)
        If $logState677 = 33 Or $logState677 = 35 Then
            Out("[Tutorial] Part 3 FAIL - reward no aplicado tras retry")
            Return False
        EndIf
    EndIf
    Heroes_Add("Koss")
    Sleep(1500)
    Local $kossOK = False
    For $i = 1 To 7
        If Party_GetMyPartyHeroInfo($i, "HeroID") = 6 Then
            $kossOK = True
            ExitLoop
        EndIf
    Next
    If Not $kossOK Then
        Sleep(3000)
        For $i = 1 To 7
            If Party_GetMyPartyHeroInfo($i, "HeroID") = 6 Then
                $kossOK = True
                ExitLoop
            EndIf
        Next
    EndIf
    If $kossOK Then
        Party_SetHeroAggression(1, 1)
        Out("[Tutorial] Part 3 OK - Koss en party + Guard, tutorial completo")
    Else
        Out("[Tutorial] Part 3 WARN - Koss no confirmado en party (LogState=" & $logState677 & ")")
    EndIf
    Out("[Tutorial] Part 3 OK - tutorial completo")
    Return True
EndFunc