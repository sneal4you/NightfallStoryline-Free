#include-once
Global Const $PT_DEHVAD_WP_X = -7161
Global Const $PT_DEHVAD_WP_Y = 4808
Global Const $PT_DEHVAD_MODEL = $GC_I_MODEL_ID_NF_GENERIC_A        
Global Const $PT_NPC_4815_X = -12106
Global Const $PT_NPC_4815_Y = -767
Global Const $PT_NPC_4815_MODEL = $GC_I_MODEL_ID_NF_TRAINER_PROF   
Global Const $PT_NPC_4817_X = -11504
Global Const $PT_NPC_4817_Y = -1711
Global Const $PT_NPC_4817_MODEL = 4817                              
Global Const $PT_NPC_4756_X = -7404
Global Const $PT_NPC_4756_Y = 5781
Global Const $PT_NPC_4756_MODEL = $GC_I_MODEL_ID_NF_FERRYMAN        
Global Const $PT_QUEST_1_ID = $GC_I_QUEST_ID_PRIMARYTRAINING          
Global Const $PT_QUEST_2_ID = $GC_I_QUEST_ID_HONINGYOURSKILLS         
Global Const $PT_DEST_MAP_ID = $GC_I_MAP_ID_KAMADAN_JEWEL_OF_ISTAN   
Func Quest_PrimaryTraining_Run()
    Out("[PrimaryTraining] Start / Resume check")
    Local $startStep = 1
    Local $logState600 = Quest_GetQuestInfo($PT_QUEST_1_ID, "LogState")
    Local $logState649 = Quest_GetQuestInfo($PT_QUEST_2_ID, "LogState")
    Out("[PrimaryTraining] Estado: quest600=" & $logState600 & " quest649=" & $logState649 & " map=" & Map_GetMapID())
    If $logState649 = 33 Or $logState649 = 35 Then
        If Map_GetMapID() <> 456 Then
            Out("[PrimaryTraining] Quest 649 activa pero map=" & Map_GetMapID() & " (no 456) -> ferryman ya tomado, DONE")
            Return True
        EndIf
        Out("[PrimaryTraining] Resume: quest 649 activa, en map 456 -> paso 4 (ferryman)")
        $startStep = 4
    ElseIf $logState600 = 33 Or $logState600 = 35 Then
        Out("[PrimaryTraining] Resume: quest 600 activa (LogState=" & $logState600 & ") -> paso 2")
        $startStep = 2
    Else
        Out("[PrimaryTraining] Run start -> paso 1 (Dehvad AcceptQuest 600 o 649 directo si 600 hecha)")
    EndIf
    If $startStep <= 1 Then
        Out("[PrimaryTraining] 1/4: Dehvad (4751) AcceptQuest 600 (Primary Training)")
        Local $b600OK = Quests_TalkAcceptQuestWithAbout($PT_DEHVAD_WP_X, $PT_DEHVAD_WP_Y, $PT_QUEST_1_ID, $PT_DEHVAD_MODEL, "Dehvad")
        If $b600OK Then
            Out("[PrimaryTraining] 1/4: quest 600 aceptada (flujo fresh completo)")
        Else
            Out("[PrimaryTraining] 1/4: 600 no aceptable -> probar AcceptQuest 649 directo (600 ya hecha)")
            If Not Quests_TalkAcceptQuestWithAbout($PT_DEHVAD_WP_X, $PT_DEHVAD_WP_Y, $PT_QUEST_2_ID, $PT_DEHVAD_MODEL, "Dehvad") Then
                Out("[PrimaryTraining] 1/4: Dehvad no ofrece ninguna -> ambas hechas? probar ferryman (paso 4)")
                $startStep = 4
            Else
                Out("[PrimaryTraining] 1/4: 649 aceptada directo -> saltar a ferryman (paso 4)")
                Out("[PrimaryTraining] OJO: 600 no se cobró en este run -> skip pasos 2-3")
                $startStep = 4
            EndIf
        EndIf
    EndIf
    If $startStep <= 2 Then
        Out("[PrimaryTraining] 2/4: NPC 4815 dialog 0x7F (entrenador habilidad)")
        If Not Quests_Talk1Dialog($PT_NPC_4815_X, $PT_NPC_4815_Y, 0x7F, $PT_NPC_4815_MODEL) Then
            Out("[PrimaryTraining] FAIL 2/4")
            Return False
        EndIf
        Out("[PrimaryTraining] 2/4: unstuck - mover 0.5s al sureste desde NPC 4815")
        Map_Move($PT_NPC_4815_X + 600, $PT_NPC_4815_Y - 600, 0)
        Sleep(500)
        Out("[PrimaryTraining] 2/4: NPC 4817 Nagozi dialog 0x7F (Expert Dervish)")
        Local $nagozi = _Quests_FindNearestNPCByModelToWp($PT_NPC_4817_MODEL, $PT_NPC_4817_X, $PT_NPC_4817_Y)
        If $nagozi = 0 Then
            Out("[PrimaryTraining] FAIL 2/4 - Nagozi (4817) no encontrado")
            Return False
        EndIf
        Map_Move($PT_NPC_4817_X, $PT_NPC_4817_Y, 0)
        Local $tNag = TimerInit()
        While Not Bot_ShouldStop() And TimerDiff($tNag) < 20000
            If Agent_GetDistance(-2, $nagozi) < 200 Then ExitLoop
            Sleep(300)
        WEnd
        Out("[PrimaryTraining] Nagozi a " & Round(Agent_GetDistance(-2, $nagozi)) & "u - GoNPC + dialog 0x7F")
        Agent_ChangeTarget($nagozi)
        Sleep(300)
        Agent_GoNPC($nagozi)
        Sleep(2500)
        Bot_Dialog(0x7F)
        Sleep(1500)
    EndIf
    If $startStep <= 3 Then
        Out("[PrimaryTraining] 3/4: Dehvad RewardQuest 600 + AcceptQuest 649")
        If Not _Quests_NavAndOpenDialog($PT_DEHVAD_WP_X, $PT_DEHVAD_WP_Y, $PT_DEHVAD_MODEL) Then
            Out("[PrimaryTraining] FAIL 3/4 - no abre dialog con Dehvad")
            Return False
        EndIf
        Out("[PrimaryTraining] Ui_RewardQuest(600) -> 0x825807")
        Ui_RewardQuest($PT_QUEST_1_ID)
        Sleep(3500)   
        Out("[PrimaryTraining] Cerrar popup 'Equip skill' (Ui_Dialog 0x80 + ESC)")
        Bot_Dialog(0x80)
        Sleep(500)
        Local $hWin = WinGetHandle("[CLASS:ArenaNet_Dx_Window_Class]")
        If $hWin Then ControlSend($hWin, "", "", "{ESC}")
        Sleep(1500)
        Out("[PrimaryTraining] Ui_AcceptQuest(649) -> 0x828901 'I'll be back in no time!'")
        If Not Quests_TalkAcceptQuestWithAbout($PT_DEHVAD_WP_X, $PT_DEHVAD_WP_Y, $PT_QUEST_2_ID, $PT_DEHVAD_MODEL) Then
            Out("[PrimaryTraining] FAIL 3/4 - quest 649 NO quedó activa tras accept")
            Return False
        EndIf
    EndIf
    Out("[PrimaryTraining] 4/4: NPC 4756 ferryman dialog 0x81 + 0x84")
    Local $dialogs[2] = [0x81, 0x84]
    If Not Quests_TalkDialogsArray($PT_NPC_4756_X, $PT_NPC_4756_Y, $dialogs, $PT_NPC_4756_MODEL) Then
        Out("[PrimaryTraining] FAIL 4/4 - no completa dialogs con ferryman")
        Return False
    EndIf
    Out("[PrimaryTraining] Esperando transicion a Map " & $PT_DEST_MAP_ID & " (Kamadan)")
    Local $t = TimerInit()
    While Not Bot_ShouldStop() And TimerDiff($t) < 30000
        If Map_GetMapID() = $PT_DEST_MAP_ID Then
            Out("[PrimaryTraining] Llegada a Kamadan tras " & Round(TimerDiff($t)/1000, 1) & "s")
            Return True
        EndIf
        Sleep(500)
    WEnd
    Out("[PrimaryTraining] Ferryman sin transportar en 30s -> fallback Travel_ToOutpost(449)")
    If Travel_ToOutpost($PT_DEST_MAP_ID) Then
        Out("[PrimaryTraining] Fallback OK: ya en Kamadan 449")
        Return True
    EndIf
    Out("[PrimaryTraining] TIMEOUT esperando Kamadan tras fallback (sigue en " & Map_GetMapID() & ")")
    Return False
EndFunc