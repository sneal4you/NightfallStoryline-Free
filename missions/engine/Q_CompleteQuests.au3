#include-once
Global Const $CQ_KAMADAN_MAP_ID = $GC_I_MAP_ID_KAMADAN_JEWEL_OF_ISTAN    
Global Const $CQ_SANCTUARY_MAP_ID = 456                                   
Global Const $CQ_NPC_QUEST_X = -7874
Global Const $CQ_NPC_QUEST_Y = 9799
Global Const $CQ_NPC_QUEST_MODEL = $GC_I_MODEL_ID_NF_GENERIC_A      
Global Const $CQ_QUEST_REWARD_ID = $GC_I_QUEST_ID_HONINGYOURSKILLS       
Global Const $CQ_QUEST_ACCEPT_ID = $GC_I_QUEST_ID_SECONDARYTRAINING      
Global Const $CQ_NPC_FERRY_X = -7525
Global Const $CQ_NPC_FERRY_Y = 6288
Global Const $CQ_NPC_FERRY_MODEL = $GC_I_MODEL_ID_NF_FERRYMAN        
Global Const $CQ_NPC_TRAINER_X = -9663
Global Const $CQ_NPC_TRAINER_Y = 1506
Global Const $CQ_NPC_TRAINER_MODEL = $GC_I_MODEL_ID_NF_TRAINER_SKILL 
Global Const $CQ_DIALOG_SEC_WARRIOR = 0x184
Global Const $CQ_DIALOG_TEACH_WARRIOR_SKILLS = 0x185
Global Const $CQ_QUEST_NEXT_ID = $GC_I_QUEST_ID_CHOOSEYOURSECONDARYPROFESSION_NF_QUEST 
Func Quest_CompleteQuests_Run()
    Out("[CompleteQuests] Start (delega en Phase04+05+06)")
    If Not Quest_CQ_Phase04_Run() Then Return False
    If Not Quest_CQ_Phase05_Run() Then Return False
    Return Quest_CQ_Phase06_Run()
EndFunc
Func Quest_CQ_Phase04_Run()
    Out("[CQ_Phase04] Travel Kamadan + Reward 649")
    If Not Travel_ToOutpost($CQ_KAMADAN_MAP_ID) Then
        Out("[CQ_Phase04] FAIL travel a Kamadan")
        Return False
    EndIf
    If Not _Quests_NavAndOpenDialog($CQ_NPC_QUEST_X, $CQ_NPC_QUEST_Y, $CQ_NPC_QUEST_MODEL) Then
        Out("[CQ_Phase04] FAIL nav/dialog NPC 4751")
        Return False
    EndIf
    If Not _CQ_RewardVerified($CQ_QUEST_REWARD_ID, $CQ_NPC_QUEST_X, $CQ_NPC_QUEST_Y, $CQ_NPC_QUEST_MODEL) Then
        Out("[CQ_Phase04] FAIL reward 649")
        Return False
    EndIf
    Out("[CQ_Phase04] OK - quest 649 cobrada en Kamadan")
    Return True
EndFunc
Func Quest_CQ_Phase05_Run()
    Out("[CQ_Phase05] Start: Accept 601 + ferryman Chuurhir + 23 NPCs + Reward 601")
    If Map_GetMapID() <> $CQ_KAMADAN_MAP_ID Then
        If Not Travel_ToOutpost($CQ_KAMADAN_MAP_ID) Then
            Out("[CQ_Phase05] FAIL travel a Kamadan")
            Return False
        EndIf
    EndIf
    If Not _Quests_NavAndOpenDialog($CQ_NPC_QUEST_X, $CQ_NPC_QUEST_Y, $CQ_NPC_QUEST_MODEL) Then
        Out("[CQ_Phase05] FAIL nav/dialog NPC 4751")
        Return False
    EndIf
    If Not _CQ_AcceptVerified($CQ_QUEST_ACCEPT_ID, $CQ_NPC_QUEST_X, $CQ_NPC_QUEST_Y, $CQ_NPC_QUEST_MODEL) Then
        Out("[CQ_Phase05] FAIL accept 601")
        Return False
    EndIf
    Local $dialogs[2] = [0x81, 0x84]
    If Not Quests_TalkDialogsArray($CQ_NPC_FERRY_X, $CQ_NPC_FERRY_Y, $dialogs, $CQ_NPC_FERRY_MODEL) Then
        Out("[CQ_Phase05] FAIL ferryman a Chuurhir Fields")
        Return False
    EndIf
    Local $t = TimerInit()
    While Not Bot_ShouldStop() And TimerDiff($t) < 20000 And Map_GetMapID() <> $CQ_SANCTUARY_MAP_ID
        Sleep(500)
    WEnd
    If Map_GetMapID() <> $CQ_SANCTUARY_MAP_ID Then
        Out("[CQ_Phase05] FAIL transicion a Chuurhir Fields (456)")
        Return False
    EndIf
    Out("[CQ_Phase05] Visitar 23 Expert NPCs (dialog 0x7F + 0x84 c/u)")
    Local $aExp[23][3] = [ _
        [4808,  -9663,  1506], _
        [4796,  -9836,  1588], _
        [4813,  -9498,  1426], _
        [4802, -12011,  -639], _
        [4809, -11803, -1311], _
        [4807, -11658, -1414], _
        [4814, -10549, -3349], _
        [4818, -10724, -3364], _
        [4812, -11571, -3726], _
        [4795,  -7149,  1830], _
        [4799,  -6557,  1837], _
        [4801,  -4207, -4446], _
        [4797,  -4480, -4979], _
        [4803,  -3917, -6270], _
        [4804,   -922, -7281], _
        [4806,   -875, -3581], _
        [4805,   -867, -3326], _
        [4810,   1422, -2698], _
        [4811,    693, -1943], _
        [4820,    272,  -934], _
        [4819,     68,  -746], _
        [4800,  -1412,  1577], _
        [4798,  -1769,  1599]  _
    ]
    For $i = 0 To 22
        If Bot_ShouldStop() Then Return False
        Out("[CQ_Phase05] Expert " & ($i + 1) & "/23: model=" & $aExp[$i][0] & " (" & $aExp[$i][1] & "," & $aExp[$i][2] & ")")
        If Not _CQ_TalkExpert($aExp[$i][1], $aExp[$i][2], $aExp[$i][0]) Then
            Out("[CQ_Phase05] FAIL Expert NPC " & ($i + 1) & "/23")
            Return False
        EndIf
        If $i = 0 Then _CQ_CloseSkillPopup()
        Sleep(300)
    Next
    Out("[CQ_Phase05] 23/23 Expert NPCs visitados")
    Out("[CQ_Phase05] Travel_ToOutpost -> Kamadan para reward 601")
    If Not Travel_ToOutpost($CQ_KAMADAN_MAP_ID) Then
        Out("[CQ_Phase05] FAIL travel a Kamadan")
        Return False
    EndIf
    Out("[CQ_Phase05] Llegada a Kamadan, buscando Dehvad")
    If Not _Quests_NavAndOpenDialog($CQ_NPC_QUEST_X, $CQ_NPC_QUEST_Y, $CQ_NPC_QUEST_MODEL) Then
        Out("[CQ_Phase05] FAIL nav Dehvad en Kamadan (reward 601)")
        Return False
    EndIf
    If Not _CQ_RewardVerified(601, $CQ_NPC_QUEST_X, $CQ_NPC_QUEST_Y, $CQ_NPC_QUEST_MODEL, True) Then
        Out("[CQ_Phase05] FAIL reward 601 en Kamadan")
        Return False
    EndIf
    Out("[CQ_Phase05] OK - quest 601 cobrada en Kamadan")
    Return True
EndFunc
Func Quest_CQ_Phase06_Run()
    Out("[CQ_Phase06] Start: secondary Warrior + Reward 596 + Accept 632 (en Kamadan)")
    If Map_GetMapID() <> $CQ_KAMADAN_MAP_ID Then
        If Not Travel_ToOutpost($CQ_KAMADAN_MAP_ID) Then
            Out("[CQ_Phase06] FAIL travel a Kamadan")
            Return False
        EndIf
    EndIf
    If Not _Quests_NavAndOpenDialog($CQ_NPC_QUEST_X, $CQ_NPC_QUEST_Y, $CQ_NPC_QUEST_MODEL) Then
        Out("[CQ_Phase06] FAIL nav Dehvad (secondary Warrior)")
        Return False
    EndIf
    Out("[CQ_Phase06] Bot_Dialog(0x88) -> Warrior secondary")
    Bot_Dialog(0x88)
    Sleep(2500)
    If Not _CQ_RewardVerified(596, $CQ_NPC_QUEST_X, $CQ_NPC_QUEST_Y, $CQ_NPC_QUEST_MODEL, True) Then
        Out("[CQ_Phase06] FAIL reward 596")
        Return False
    EndIf
    Sleep(1000)
    If Not _Quests_NavAndOpenDialog($CQ_NPC_QUEST_X, $CQ_NPC_QUEST_Y, $CQ_NPC_QUEST_MODEL) Then
        Out("[CQ_Phase06] FAIL nav Dehvad (accept 632)")
        Return False
    EndIf
    If Not _CQ_AcceptVerified(632, $CQ_NPC_QUEST_X, $CQ_NPC_QUEST_Y, $CQ_NPC_QUEST_MODEL) Then
        Out("[CQ_Phase06] FAIL accept 632")
        Return False
    EndIf
    Out("[CQ_Phase06] OK - Warrior secondary + Reward 596 + Accept 632 completados en Kamadan")
    Out("[CQ_Phase06] Nav a Skill Merchant Kamadan (-11408, 15491) -> comprar Gash")
    If _Quests_NavAndOpenDialog(-11408, 15491, 4751) Then
        Out("[CQ_Phase06] Skill_BuySkillByID(384) -> Gash (Warrior secondary)")
        Skill_BuySkillByID($GC_I_SKILL_ID_GASH)
        Sleep(2000)
    Else
        Out("[CQ_Phase06] WARN: no abre dialog Skill Merchant - Gash no comprado, continuar")
    EndIf
    Out("[CQ_Phase06] OK - char en Kamadan, quest 596 cobrada, quest 632 aceptada, Gash comprado")
    Return True
EndFunc
Func Quest_CQ_KamadanStart_Run()
    Out("[CQ_KamadanStart] 1/2: Travel a Kamadan")
    If Not Travel_ToOutpost($CQ_KAMADAN_MAP_ID) Then
        Out("[CQ_KamadanStart] FAIL travel a Kamadan")
        Return False
    EndIf
    Out("[CQ_KamadanStart] 2/2: NPC 4751 - Reward 649 + Accept 601")
    If Not _Quests_NavAndOpenDialog($CQ_NPC_QUEST_X, $CQ_NPC_QUEST_Y, $CQ_NPC_QUEST_MODEL) Then
        Out("[CQ_KamadanStart] FAIL nav/dialog NPC 4751")
        Return False
    EndIf
    If Not _CQ_RewardVerified($CQ_QUEST_REWARD_ID, $CQ_NPC_QUEST_X, $CQ_NPC_QUEST_Y, $CQ_NPC_QUEST_MODEL) Then
        Out("[CQ_KamadanStart] FAIL reward 649 no confirmado")
        Return False
    EndIf
    If Not _CQ_AcceptVerified($CQ_QUEST_ACCEPT_ID, $CQ_NPC_QUEST_X, $CQ_NPC_QUEST_Y, $CQ_NPC_QUEST_MODEL) Then
        Out("[CQ_KamadanStart] FAIL accept 601 no confirmado")
        Return False
    EndIf
    Out("[CQ_KamadanStart] OK")
    Return True
EndFunc
Func Quest_CQ_Sanctuary_Run()
    Out("[CQ_Sanctuary] 1/4: Ferryman 4756 -> Sunspear Sanctuary")
    Local $dialogs[2] = [0x81, 0x84]
    If Not Quests_TalkDialogsArray($CQ_NPC_FERRY_X, $CQ_NPC_FERRY_Y, $dialogs, $CQ_NPC_FERRY_MODEL) Then
        Out("[CQ_Sanctuary] FAIL ferryman 4756")
        Return False
    EndIf
    Local $t = TimerInit()
    While Not Bot_ShouldStop() And TimerDiff($t) < 20000 And Map_GetMapID() <> $CQ_SANCTUARY_MAP_ID
        Sleep(500)
    WEnd
    If Map_GetMapID() <> $CQ_SANCTUARY_MAP_ID Then
        Out("[CQ_Sanctuary] FAIL transicion a Sunspear Sanctuary")
        Return False
    EndIf
    Out("[CQ_Sanctuary] 2/4: Nav NPC 4808 + skill trainer dialog")
    If Not _Quests_NavAndOpenDialog($CQ_NPC_TRAINER_X, $CQ_NPC_TRAINER_Y, $CQ_NPC_TRAINER_MODEL) Then
        Out("[CQ_Sanctuary] FAIL nav NPC 4808")
        Return False
    EndIf
    Bot_Dialog(0x7F)       
    Sleep(1500)
    Bot_Dialog(0x84)       
    Sleep(1500)
    _CQ_CloseSkillPopup()
    Out("[CQ_Sanctuary] 3/4: Travel_ToOutpost -> Kamadan + Dehvad - Reward 601 + Warrior secondary + Reward 596")
    If Not Travel_ToOutpost($CQ_KAMADAN_MAP_ID) Then
        Out("[CQ_Sanctuary] FAIL travel a Kamadan")
        Return False
    EndIf
    If Not _Quests_NavAndOpenDialog($CQ_NPC_QUEST_X, $CQ_NPC_QUEST_Y, $CQ_NPC_QUEST_MODEL) Then
        Out("[CQ_Sanctuary] FAIL nav Dehvad en Kamadan (reward 601)")
        Return False
    EndIf
    If Not _CQ_RewardVerified(601, $CQ_NPC_QUEST_X, $CQ_NPC_QUEST_Y, $CQ_NPC_QUEST_MODEL, True) Then
        Out("[CQ_Sanctuary] FAIL reward 601 no confirmado")
        Return False
    EndIf
    If Not _Quests_NavAndOpenDialog($CQ_NPC_QUEST_X, $CQ_NPC_QUEST_Y, $CQ_NPC_QUEST_MODEL) Then
        Out("[CQ_Sanctuary] FAIL nav Dehvad en Kamadan (secondary Warrior)")
        Return False
    EndIf
    Bot_Dialog(0x88)
    Sleep(2500)
    If Not _CQ_RewardVerified(596, $CQ_NPC_QUEST_X, $CQ_NPC_QUEST_Y, $CQ_NPC_QUEST_MODEL, True) Then
        Out("[CQ_Sanctuary] FAIL reward 596 no confirmado")
        Return False
    EndIf
    Out("[CQ_Sanctuary] 4/4: Dehvad - Accept 632")
    Sleep(1000)
    If Not _Quests_NavAndOpenDialog($CQ_NPC_QUEST_X, $CQ_NPC_QUEST_Y, $CQ_NPC_QUEST_MODEL) Then
        Out("[CQ_Sanctuary] FAIL nav Dehvad en Kamadan (accept 632)")
        Return False
    EndIf
    If Not _CQ_AcceptVerified(632, $CQ_NPC_QUEST_X, $CQ_NPC_QUEST_Y, $CQ_NPC_QUEST_MODEL) Then
        Out("[CQ_Sanctuary] FAIL accept 632 no confirmado")
        Return False
    EndIf
    Out("[CQ_Sanctuary] OK")
    Return True
EndFunc
Func Quest_CQ_TravelCD_Run()
    Out("[CQ_TravelCD] Travel directo a Champion's Dawn (479)")
    If Not Travel_ToOutpost($GC_I_MAP_ID_CHAMPIONS_DAWN) Then
        Out("[CQ_TravelCD] FAIL travel a Champion's Dawn")
        Return False
    EndIf
    Out("[CQ_TravelCD] OK")
    Return True
EndFunc
Func _CQ_TalkExpert($x, $y, $modelId)
    Local $rPrev = $g_GE_RescueEnabled
    $g_GE_RescueEnabled = False
    GameEvents_ResetStuck()
    MoveToFollowPath($x, $y, 0, "")
    $g_GE_RescueEnabled = $rPrev
    GameEvents_ResetStuck()
    Local $npc = 0, $tF = TimerInit()
    While TimerDiff($tF) < 5000
        $npc = _Quests_FindNearestNPCByModelToWp($modelId, $x, $y)
        If $npc <> 0 Then ExitLoop
        Sleep(400)
    WEnd
    If $npc = 0 Then
        Out("[CQ] TalkExpert FAIL: model=" & $modelId & " no encontrado tras 5s")
        Return False
    EndIf
    Local $rPrev2 = $g_GE_RescueEnabled
    $g_GE_RescueEnabled = False
    GameEvents_ResetStuck()
    Local $tGo = TimerInit(), $tRe = TimerInit()
    Agent_GoNPC($npc)
    While Not Bot_ShouldStop() And TimerDiff($tGo) < 20000
        If Agent_GetDistance(-2, $npc) < 250 Then ExitLoop
        Sleep(200)
        If TimerDiff($tRe) >= 4000 Then
            Agent_GoNPC($npc)
            $tRe = TimerInit()
        EndIf
    WEnd
    $g_GE_RescueEnabled = $rPrev2
    GameEvents_ResetStuck()
    If Agent_GetDistance(-2, $npc) > 600 Then
        Out("[CQ] TalkExpert FAIL: model=" & $modelId & " GoNPC no logró acercar (>600u)")
        Return False
    EndIf
    Sleep(1000)
    Bot_Dialog(0x7F)
    Sleep(1500)
    Bot_Dialog(0x84)
    Sleep(1500)
    Out("[CQ] TalkExpert OK: model=" & $modelId)
    Return True
EndFunc
Func _CQ_CloseSkillPopup()
    Bot_Dialog(0x9)
    Sleep(400)
    Bot_Dialog(0x80)
    Sleep(400)
    Local $hWin = WinGetHandle("[CLASS:ArenaNet_Dx_Window_Class]")
    If $hWin Then ControlSend($hWin, "", "", "{ESC}")
    Sleep(1500)
EndFunc
Func _CQ_WaitRewarded($questID, $timeoutMs = 6000)
    Local $t = TimerInit()
    While Not Bot_ShouldStop() And TimerDiff($t) < $timeoutMs
        Local $st = Quest_GetQuestInfo($questID, "LogState")
        If $st = 0 Or $st = -1 Then Return True
        Sleep(400)
    WEnd
    Return False
EndFunc
Func _CQ_WaitAccepted($questID, $timeoutMs = 6000)
    Local $t = TimerInit()
    While Not Bot_ShouldStop() And TimerDiff($t) < $timeoutMs
        If Quest_GetQuestInfo($questID, "LogState") > 0 Then Return True
        Sleep(400)
    WEnd
    Return False
EndFunc
Func _CQ_RewardVerified($questID, $npcX, $npcY, $npcModel, $closePopup = False)
    Ui_RewardQuest($questID)
    Sleep(1500)
    If $closePopup Then _CQ_CloseSkillPopup()
    If _CQ_WaitRewarded($questID) Then
        Out("[CQ] Reward(" & $questID & ") OK - quest fuera del log")
        Return True
    EndIf
    Out("[CQ] Reward(" & $questID & ") WARN: sigue en el log -> reintento via GoNPC")
    If Not _Quests_NavAndOpenDialog($npcX, $npcY, $npcModel) Then Return False
    Ui_RewardQuest($questID)
    Sleep(1500)
    If $closePopup Then _CQ_CloseSkillPopup()
    If _CQ_WaitRewarded($questID) Then
        Out("[CQ] Reward(" & $questID & ") OK en reintento")
        Return True
    EndIf
    Out("[CQ] Reward(" & $questID & ") FAIL: LogState=" & Quest_GetQuestInfo($questID, "LogState") & " tras 2 intentos")
    Return False
EndFunc
Func _CQ_AcceptVerified($questID, $npcX, $npcY, $npcModel)
    Ui_AcceptQuest($questID)
    Sleep(1500)
    If _CQ_WaitAccepted($questID) Then
        Out("[CQ] Accept(" & $questID & ") OK - quest en el log")
        Return True
    EndIf
    Local $ls = Quest_GetQuestInfo($questID, "LogState")
    If $ls = 0 Then
        Out("[CQ] Accept(" & $questID & ") - quest ya cobrada previamente (LogState=0) -> skip a done")
        Return True
    EndIf
    Out("[CQ] Accept(" & $questID & ") WARN: no esta en el log -> reintento via GoNPC")
    If Not _Quests_NavAndOpenDialog($npcX, $npcY, $npcModel) Then Return False
    Ui_AcceptQuest($questID)
    Sleep(1500)
    If _CQ_WaitAccepted($questID) Then
        Out("[CQ] Accept(" & $questID & ") OK en reintento")
        Return True
    EndIf
    $ls = Quest_GetQuestInfo($questID, "LogState")
    If $ls = 0 Then
        Out("[CQ] Accept(" & $questID & ") - retry confirma LogState=0 (ya cobrada) -> done")
        Return True
    EndIf
    Out("[CQ] Accept(" & $questID & ") FAIL: LogState=" & $ls & " (probable prereq missing)")
    Return False
EndFunc