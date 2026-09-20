#include-once
Global Const $IOTD_KAMADAN_MAP_ID   = $GC_I_MAP_ID_KAMADAN_JEWEL_OF_ISTAN  
Global Const $IOTD_QUEST_NPC_MODEL  = $GC_I_MODEL_ID_NF_GENERIC_A  
Global Const $IOTD_QUEST_NPC_X      = -7874       
Global Const $IOTD_QUEST_NPC_Y      = 9799
Global Const $IOTD_QUEST_ID         = $GC_I_QUEST_ID_ISLEOFTHEDEAD_QUEST 
Global Const $IOTD_MAX_ATTEMPTS     = 3
Global Const $IOTD_PORTAL_X         = 23420       
Global Const $IOTD_PORTAL_Y         = 6445
Global Const $IOTD_CLIFFS_MAP_ID    = $GC_I_MAP_ID_CLIFFS_OF_DOHJOK  
Global Const $IOTD_NERASHI_MODEL    = $GC_I_MODEL_ID_NF_NERASHI    
Global Const $IOTD_NERASHI_X        = 743
Global Const $IOTD_NERASHI_Y        = -2858
Global Const $IOTD_BEKNUR_PORTAL_X  = 14861
Global Const $IOTD_BEKNUR_PORTAL_Y  = -10737
Global Const $IOTD_BEKNUR_MAP_ID    = $GC_I_MAP_ID_BEKNUR_HARBOR_2  
Global Const $IOTD_CHAR_TEMPLATE    = "OgGikms2cV+vD4xLXZcbfFA"  
Global Const $IOTD_KOSS_TEMPLATE    = "OQATEHaWn4q+FwBWocNACAA"
Global Const $IOTD_DUNKORO_TEMPLATE = "OwAT0yXApJnkRAJtE6aFZmETAA"
Global Const $IOTD_MELONNI_TEMPLATE = "OgGikms0cV+vS3BMXZ8OuFAA"
Global Const $IOTD_BH_BRIDGE_X      = -17200   
Global Const $IOTD_BH_BRIDGE_Y      = 12100
Global Const $IOTD_BH_EXIT_X        = -16044   
Global Const $IOTD_BH_EXIT_Y        = 11187
Global Const $IOTD_ISSNUR_MAP_ID    = $GC_I_MAP_ID_ISSNUR_ISLES     
Func Quest_IsleOfTheDead_Run()
    Out("[IotD] ===== ISLE OF THE DEAD =====")
    Local $q635Pre = Quest_GetQuestInfo(635, "LogState")
    Local $q636Pre = Quest_GetQuestInfo(636, "LogState")
    Out("[IotD] AutoDetect: q635 ls=" & $q635Pre & " q636 ls=" & $q636Pre & " mehtaniUnlocked=" & Map_IsMapUnlocked($GC_I_MAP_ID_MEHTANI_KEYS))
    If $q635Pre = 0 And Map_IsMapUnlocked($GC_I_MAP_ID_MEHTANI_KEYS) = 1 Then
        Out("[IotD] AutoDetect: q635 ls=0 + Mehtani desbloqueado -> IotD completada en sesion previa, marcar done")
        Return True
    EndIf
    If $q635Pre = 0 Then
        Out("[IotD] AutoDetect: q635 ls=0 PERO Mehtani SIN desbloquear -> quest nunca aceptada (char nuevo). EJECUTAR IotD.")
    EndIf
    If $q636Pre > 0 Then
        Out("[IotD] AutoDetect: q636 ls=" & $q636Pre & " (siguiente quest en progreso) -> IotD ya completada")
        Return True
    EndIf
    If Quest_GetQuestInfo(633, "CanReward") And Quest_GetQuestInfo(633, "LogState") > 0 Then
        Out("[IotD] q633 CanReward (ls=" & Quest_GetQuestInfo(633, "LogState") & ") bloquea q635 -> cobrar en Astralarium")
        If Map_GetMapID() <> $GC_I_MAP_ID_THE_ASTRALARIUM Then
            If Not Travel_ToOutpost($GC_I_MAP_ID_THE_ASTRALARIUM) Then
                Out("[IotD] WARN: Travel a Astralarium fallo - continuando de todos modos")
            EndIf
            Sleep(2000)
        EndIf
        _RM_TalkDajmirRewardAndAccept()
        Sleep(1000)
        Out("[IotD] Tras Dajmir: q633 ls=" & Quest_GetQuestInfo(633, "LogState") & " cr=" & Quest_GetQuestInfo(633, "CanReward"))
    EndIf
    For $attempt = 1 To $IOTD_MAX_ATTEMPTS
        Out("[IotD] Intento " & $attempt & "/" & $IOTD_MAX_ATTEMPTS)
        $g_GE_RescueEnabled = False
        $g_bResignMode      = False
        Sleep(1000)
        If _IotD_RunOnce() Then Return True
        Local $retType = Map_GetInstanceInfo("Type")
        If Map_GetInstanceInfo("IsLoading") Then Sleep(5000)
        If Map_GetInstanceInfo("Type") = $GC_I_MAP_TYPE_OUTPOST Then
            Out("[IotD] Fallo en outpost -> reintentando en 3s")
            Sleep(3000)
        Else
            Local $isValidIotDMap = (Map_GetMapID() = $IOTD_CLIFFS_MAP_ID) _
                Or (Map_GetMapID() = $IOTD_BEKNUR_MAP_ID) _
                Or (Map_GetMapID() = $IOTD_ISSNUR_MAP_ID) _
                Or (Map_GetMapID() = $GC_I_MAP_ID_KODLONU_HAMLET) _
                Or (Map_GetMapID() = $GC_I_MAP_ID_MEHTANI_KEYS)
            Local $charAlive = (Agent_GetAgentInfo(-2, "HP") > 0)
            If $isValidIotDMap And $charAlive Then
                Out("[IotD] Fallo pero char vivo en zona IotD (map=" & Map_GetMapID() & ") -> reintentar SIN ReturnToOutpost")
                Sleep(3000)
            Else
                $g_GE_RescueEnabled = False
                Out("[IotD] Fallo en instancia (alive=" & $charAlive & " map=" & Map_GetMapID() & ") -> ReturnToOutpost")
                Local $tRet = TimerInit()
                While Not Bot_ShouldStop() And TimerDiff($tRet) < 35000
                    If Map_GetInstanceInfo("IsLoading") Then
                        Sleep(1000)
                        ContinueLoop
                    EndIf
                    If Map_GetInstanceInfo("Type") = $GC_I_MAP_TYPE_OUTPOST Then ExitLoop
                    Map_ReturnToOutpost(False)
                    Sleep(3000)
                WEnd
                If Map_GetInstanceInfo("Type") <> $GC_I_MAP_TYPE_OUTPOST Then
                    Out("[IotD] WARN: ReturnToOutpost fallo en 35s (map=" & Map_GetMapID() & ") -> dejar que RunOnce recupere")
                EndIf
            EndIf
        EndIf
    Next
    Out("[IotD] FAIL definitivo: " & $IOTD_MAX_ATTEMPTS & " intentos agotados")
    Return False
EndFunc
Func _IotD_RunOnce()
    Out("[IotD] RunOnce start")
    Local $tMapWait = TimerInit()
    While (Map_GetMapID() = 0 Or Map_GetInstanceInfo("IsLoading")) And Not Bot_ShouldStop()
        _NF_GwWatchdog()
        If TimerDiff($tMapWait) > 45000 Then
            Out("[IotD] FAIL: mapa no disponible tras 45s (map=" & Map_GetMapID() & ") -> abort")
            Return False
        EndIf
        Out("[IotD] Esperando mapa valido (map=" & Map_GetMapID() & ", loading=" & Map_GetInstanceInfo("IsLoading") & ")...")
        Sleep(2000)
    WEnd
    If Map_GetMapID() = 0 Then
        Out("[IotD] bucle de mapa abortado sin mapa (gw=" & ProcessExists("gw.exe") & ") -> Return False")
        Return False
    EndIf
    Out("[IotD] Mapa disponible: map=" & Map_GetMapID())
    Local $iotdCanRewardState = Quest_GetQuestInfo($IOTD_QUEST_ID, "LogState")
    Out("[IotD] LogState actual quest 635 = " & $iotdCanRewardState)
    Local $iCurMap = Map_GetMapID()
    _IotD_EnsureAttributesAssigned()
    If $iotdCanRewardState > 0 Then
        Local $sNerashiDone = IniRead(@TempDir & "\iotd_checkpoint.ini", "IotD", "NerashiDone", "0")
        If $iCurMap = $GC_I_MAP_ID_KAMADAN_JEWEL_OF_ISTAN And $iotdCanRewardState = 35 Then
            Out("[IotD] Checkpoint: char en Kamadan con quest 635 ls=35 (can-reward) -> cobrar directo")
            $g_GE_RescueEnabled = True
            If _IotD_DoReward() Then
                Out("[IotD] DoReward en Kamadan OK -> quest 635 completada")
                Return True
            EndIf
            Out("[IotD] WARN: DoReward en Kamadan fallo (ls=" & Quest_GetQuestInfo($IOTD_QUEST_ID, "LogState") & ") -> fallback ruta")
        EndIf
        Local $iotdMapTo = Quest_GetQuestInfo($IOTD_QUEST_ID, "MapTo")
        If $iotdMapTo = $IOTD_ISSNUR_MAP_ID Then
            Out("[IotD] MapTo=" & $iotdMapTo & " (Issnur pendiente) aunque char en map=" & $iCurMap & " -> viajar Beknur Harbor y completar Issnur antes de Kodlonu/Mehtani")
            If $iCurMap = $GC_I_MAP_ID_MEHTANI_KEYS And Map_GetInstanceInfo("Type") <> $GC_I_MAP_TYPE_OUTPOST Then
                Out("[IotD] En explorable Mehtani -> Map_ReturnToOutpost(True) antes de Travel a Beknur")
                Map_ReturnToOutpost(True)
                Map_WaitMapLoading(0, $GC_I_MAP_TYPE_OUTPOST, 60000)
                Sleep(2000)
            EndIf
            If Not Travel_ToOutpost($IOTD_BEKNUR_MAP_ID) Then
                Out("[IotD] FAIL: no se llegÃ³ a Beknur Harbor desde map=" & $iCurMap & " (Issnur pendiente)")
                $g_GE_RescueEnabled = True
                Return False
            EndIf
            Return _IotD_DesdeBeknurHarbor()
        EndIf
        If $iCurMap = $GC_I_MAP_ID_KODLONU_HAMLET Then
            If $iotdCanRewardState = 35 Then
                Out("[IotD] Checkpoint: Kodlonu + ls=35 (can-reward) -> Travel Kamadan + cobrar")
                $g_GE_RescueEnabled = True
                If Not Travel_ToOutpost($GC_I_MAP_ID_KAMADAN_JEWEL_OF_ISTAN) Then
                    Out("[IotD] FIX: no se llegÃ³ a Kamadan desde Kodlonu (ls=35)")
                Else
                    If _IotD_DoReward() Then
                        Out("[IotD] DoReward desde Kodlonu OK -> quest 635 completada")
                        Return True
                    EndIf
                    Out("[IotD] WARN: DoReward desde Kodlonu fallo -> fallback ruta Kodlonu")
                EndIf
            EndIf
            Out("[IotD] Checkpoint: char en Kodlonu Hamlet (MapTo=" & $iotdMapTo & ") -> _IotD_DesdeKodlonu (directo)")
            Return _IotD_DesdeKodlonu()
        EndIf
        If $iCurMap = $GC_I_MAP_ID_MEHTANI_KEYS Then
            If $iotdCanRewardState = 35 Then
                Out("[IotD] Checkpoint: Mehtani + ls=35 (can-reward) -> Travel Kamadan + cobrar")
                If Map_GetInstanceInfo("Type") <> $GC_I_MAP_TYPE_OUTPOST Then
                    Out("[IotD] En explorable -> Map_ReturnToOutpost(True) antes de Travel")
                    Map_ReturnToOutpost(True)
                    Map_WaitMapLoading(0, $GC_I_MAP_TYPE_OUTPOST, 60000)
                    Sleep(2000)
                EndIf
                $g_GE_RescueEnabled = True
                If Not Travel_ToOutpost($GC_I_MAP_ID_KAMADAN_JEWEL_OF_ISTAN) Then
                    Out("[IotD] FIX: no se llegÃ³ a Kamadan desde Mehtani (ls=35)")
                Else
                    If _IotD_DoReward() Then
                        Out("[IotD] DoReward desde Mehtani OK -> quest 635 completada")
                        Return True
                    EndIf
                    Out("[IotD] WARN: DoReward desde Mehtani fallo -> fallback Kodlonu")
                EndIf
            EndIf
            Out("[IotD] Checkpoint: char en Mehtani Keys (map=488, MapTo=" & $iotdMapTo & ") -> Travel Kodlonu -> DesdeKodlonu")
            If Map_GetInstanceInfo("Type") <> $GC_I_MAP_TYPE_OUTPOST Then
                Out("[IotD] En explorable -> Map_ReturnToOutpost(True) antes de Travel")
                Map_ReturnToOutpost(True)
                Map_WaitMapLoading(0, $GC_I_MAP_TYPE_OUTPOST, 60000)
                Sleep(2000)
            EndIf
            If Not Travel_ToOutpost($GC_I_MAP_ID_KODLONU_HAMLET) Then
                Out("[IotD] FAIL: no se llegÃ³ a Kodlonu desde Mehtani")
                Return False
            EndIf
            Return _IotD_DesdeKodlonu()
        EndIf
    If $iotdCanRewardState > 33 Then
            Out("[IotD] LogState=" & $iotdCanRewardState & " (Nerashi done: LogState>33) -> ir a Kodlonu/Mehtani")
            IniWrite(@TempDir & "\iotd_checkpoint.ini", "IotD", "NerashiDone", "0")
            If $iCurMap = $GC_I_MAP_ID_KODLONU_HAMLET Then
                Out("[IotD] Char en Kodlonu -> _IotD_DesdeKodlonu (Issnur ya hecha en esta instancia)")
                Return _IotD_DesdeKodlonu()
            EndIf
            If Travel_ToOutpost($GC_I_MAP_ID_KODLONU_HAMLET) Then
                Out("[IotD] En Kodlonu -> _IotD_DesdeKodlonu (skip Issnur)")
                Return _IotD_DesdeKodlonu()
            EndIf
            Out("[IotD] Kodlonu fallido -> fallback Travel Beknur Harbor")
            If Travel_ToOutpost($IOTD_BEKNUR_MAP_ID) Then
                Return _IotD_DesdeBeknurHarbor()
            EndIf
        EndIf
        If $iCurMap = $IOTD_ISSNUR_MAP_ID Then
            Out("[IotD] Checkpoint: char en Issnur (map=" & $iCurMap & ") -> Travel Beknur Harbor")
            If Not Travel_ToOutpost($IOTD_BEKNUR_MAP_ID) Then
                Out("[IotD] FAIL: no se llegÃ³ a Beknur Harbor desde Issnur")
                Return False
            EndIf
            Return _IotD_DesdeBeknurHarbor()
        EndIf
        If $iCurMap = $IOTD_BEKNUR_MAP_ID Then
            Out("[IotD] Checkpoint: ya en Beknur Harbor (map=487) -> saltar a Paso 15")
            Return _IotD_DesdeBeknurHarbor()
        EndIf
        If $sNerashiDone = "1" And $iCurMap = $IOTD_CLIFFS_MAP_ID Then
            Out("[IotD] Checkpoint: Nerashi done en CoD activo (INI=1 map=" & $iCurMap & ") -> Travel Beknur Harbor")
            IniWrite(@TempDir & "\iotd_checkpoint.ini", "IotD", "NerashiDone", "0")
            If Not Travel_ToOutpost($IOTD_BEKNUR_MAP_ID) Then
                Out("[IotD] WARN: no se llegÃ³ a Beknur Harbor -> ruta completa desde Kamadan")
            Else
                Return _IotD_DesdeBeknurHarbor()
            EndIf
        EndIf
    Else
        Out("[IotD] LogState=-1: quest no activa -> limpiar checkpoints, aceptar desde Kamadan")
        IniWrite(@TempDir & "\iotd_checkpoint.ini", "IotD", "NerashiDone", "0")
    EndIf
    Local $isValidOutpost = (Map_GetMapID() = $IOTD_KAMADAN_MAP_ID) Or (Map_GetMapID() = $GC_I_MAP_ID_CHAMPIONS_DAWN)
    If Not $isValidOutpost Then
        Out("[IotD] No en outpost vÃ¡lido (map=" & Map_GetMapID() & ") -> Travel_ToOutpost")
        If Not Travel_ToOutpost($IOTD_KAMADAN_MAP_ID) Then
            Out("[IotD] FAIL: no se pudo volver a Kamadan")
            Return False
        EndIf
    EndIf
    Out("[IotD] Paso 1 -> EnsureAttributesAssigned (char + heroes)")
    _IotD_EnsureAttributesAssigned()
    Out("[IotD] Paso 2 -> nav a NPC quest-giver (model " & $IOTD_QUEST_NPC_MODEL & ")")
    $g_GE_RescueEnabled = True
    Local $iotdLogState = Quest_GetQuestInfo($IOTD_QUEST_ID, "LogState")
    If $iotdLogState > 0 Then
        Out("[IotD] Paso 2 -> quest 635 ya en log (LogState=" & $iotdLogState & "), skip accept")
    Else
        If Not _Mission_DoNavOnly($IOTD_QUEST_NPC_X, $IOTD_QUEST_NPC_Y) Then
            Out("[IotD] FAIL: nav a NPC quest-giver")
            Return False
        EndIf
        Out("[IotD] Paso 2 -> Quests_TalkAcceptQuestWithAbout(635, model " & $IOTD_QUEST_NPC_MODEL & ")")
        If Not Quests_TalkAcceptQuestWithAbout($IOTD_QUEST_NPC_X, $IOTD_QUEST_NPC_Y, $IOTD_QUEST_ID, $IOTD_QUEST_NPC_MODEL) Then
            Out("[IotD] FAIL: quest 635 no aceptada")
            Return False
        EndIf
    EndIf
    Out("[IotD] Paso 2 -> quest 635 OK")
    If Map_GetMapID() = $GC_I_MAP_ID_CHAMPIONS_DAWN Then
        Out("[IotD] Paso 3 -> ya en Champion's Dawn (479), skip travel")
    Else
        Out("[IotD] Paso 3 -> Travel a Champion's Dawn (479)")
        If Not Travel_ToOutpost($GC_I_MAP_ID_CHAMPIONS_DAWN) Then
            Out("[IotD] FAIL: no se llegÃ³ a Champion's Dawn")
            Return False
        EndIf
        Out("[IotD] Paso 3 -> en Champion's Dawn OK")
    EndIf
    Out("[IotD] Paso 4 -> cruzar portal Champion's Dawn -> Cliffs of Dohjok (432)")
    If Not _IotD_WalkThroughPortal($IOTD_PORTAL_X, $IOTD_PORTAL_Y, "south", $IOTD_CLIFFS_MAP_ID, 60000) Then
        Out("[IotD] FAIL: no se cruzo el portal a Cliffs of Dohjok")
        Return False
    EndIf
    Sleep(1500)   
    If Map_GetMapID() <> $IOTD_CLIFFS_MAP_ID Then
        Out("[IotD] ABORT Paso 4: mapa incorrecto tras portal (map=" & Map_GetMapID() & "), esperado=" & $IOTD_CLIFFS_MAP_ID)
        Return False
    EndIf
    Local $iotdEntryX = Agent_GetAgentInfo(-2, "X")
    Local $iotdEntryY = Agent_GetAgentInfo(-2, "Y")
    Out("[IotD] Paso 4 -> en Cliffs of Dohjok OK. Pos entrada: (" & Round($iotdEntryX) & "," & Round($iotdEntryY) & ")")
    Out("[IotD] Paso 4b -> Map_Move directo a primer WP (alejarse portal)")
    Map_Move(18889, 5657, 0)
    Local $tAway = TimerInit()
    Local $tAwayRe = TimerInit()
    While TimerDiff($tAway) < 10000
        If Map_GetMapID() <> $IOTD_CLIFFS_MAP_ID Then
            Out("[IotD] ABORT Paso 4b: cruzamos de vuelta a CD durante alejamiento (map=" & Map_GetMapID() & ")")
            Return False
        EndIf
        Local $cxAway = Agent_GetAgentInfo(-2, "X")
        Local $cyAway = Agent_GetAgentInfo(-2, "Y")
        Local $movedAway = Sqrt(($cxAway - $iotdEntryX)^2 + ($cyAway - $iotdEntryY)^2)
        If $movedAway > 1500 Then
            Out("[IotD] Paso 4b -> char alejado " & Round($movedAway) & "u del portal, continuar")
            ExitLoop
        EndIf
        Sleep(300)
        If TimerDiff($tAwayRe) > 2500 Then
            Map_Move(18889, 5657, 0)
            $tAwayRe = TimerInit()
        EndIf
    WEnd
    If Map_GetMapID() <> $IOTD_CLIFFS_MAP_ID Then
        Out("[IotD] ABORT: salimos de PoJ al final de Paso 4b (map=" & Map_GetMapID() & ")")
        Return False
    EndIf
    Out("[IotD] Paso 4b -> OK. Pos actual: (" & Round(Agent_GetAgentInfo(-2,"X")) & "," & Round(Agent_GetAgentInfo(-2,"Y")) & ")")
    $g_GE_RescueEnabled = False
    Out("[IotD] Paso 4b -> rescue desactivado para explorables")
    Out("[IotD] Paso 5 -> Cliffs of Dohjok: nav+combat todos juntos")
    Local $aWP[8][2] = [ _
        [18889,  5657], _
        [19999,  5056], _
        [16566,  7976], _
        [13211,  7041], _
        [11459,  5175], _
        [ 9450,  5372], _
        [ 3392,  4267], _
        [ -912, -2246]  _
    ]
    For $i = 0 To UBound($aWP) - 1
        If Map_GetMapID() <> $IOTD_CLIFFS_MAP_ID Then
            Out("[IotD] ABORT Paso 5-7 WP" & ($i+1) & ": map=" & Map_GetMapID())
            Return False
        EndIf
        Out("[IotD] Paso 5-7 -> WP" & ($i+1) & "/" & UBound($aWP) & " (" & $aWP[$i][0] & "," & $aWP[$i][1] & ")")
        _Mission_DoNavThrough($aWP[$i][0], $aWP[$i][1])
    Next
    Out("[IotD] Paso 5-7 -> OK")
    If Map_GetMapID() <> $IOTD_CLIFFS_MAP_ID Then
        Out("[IotD] ABORT Paso 8: no en PoJ (map=" & Map_GetMapID() & ")")
        Return False
    EndIf
    Local $lsPreNerashi = Quest_GetQuestInfo($IOTD_QUEST_ID, "LogState")
    Out("[IotD] Paso 8 -> LogState=" & $lsPreNerashi & " (siempre intentar Nerashi en instancia nueva)")
    Out("[IotD] Paso 8 -> Quests_TalkUpdateQuest(635, Nerashi model " & $IOTD_NERASHI_MODEL & ")")
    If Not Quests_TalkUpdateQuest($IOTD_NERASHI_X, $IOTD_NERASHI_Y, $IOTD_QUEST_ID, $IOTD_NERASHI_MODEL, "Nerashi") Then
        Out("[IotD] Paso 8 SKIP: Nerashi no encontrada (quest ya progresada mas alla de 'Seek Nerashi')")
    EndIf
    Local $lsPostNerashi = Quest_GetQuestInfo($IOTD_QUEST_ID, "LogState")
    Out("[IotD] Paso 8 -> OK (LogState post-Nerashi=" & $lsPostNerashi & ")")
    IniWrite(@TempDir & "\iotd_checkpoint.ini", "IotD", "NerashiDone", "1")
    IniWrite(@TempDir & "\iotd_checkpoint.ini", "IotD", "LogStatePostNerashi", $lsPostNerashi)
    Return _IotD_DesdeCoD_Paso9()
EndFunc
Func _IotD_DesdeCoD_Paso9()
    Out("[IotD] DesdeCoD_Paso9 start (map=" & Map_GetMapID() & ")")
    If Map_GetMapID() <> $IOTD_CLIFFS_MAP_ID Then
        Out("[IotD] ABORT Paso 9: no en PoJ (map=" & Map_GetMapID() & ")")
        Return False
    EndIf
    Local $aWP9[4][2] = [ _
        [2200, -2700], _
        [1053, -6505], _
        [4510, -6182], _
        [6425, -3035]  _
    ]
    For $i = 0 To UBound($aWP9) - 1
        If Map_GetMapID() <> $IOTD_CLIFFS_MAP_ID Then
            Out("[IotD] ABORT Paso 9: salimos de CoD antes de WP " & ($i+1) & "/" & UBound($aWP9) & " (map=" & Map_GetMapID() & ")")
            Return False
        EndIf
        Out("[IotD] Paso 9 -> WP " & ($i + 1) & "/" & UBound($aWP9) & " (" & $aWP9[$i][0] & "," & $aWP9[$i][1] & ")")
        If Not _Mission_DoNavOnly($aWP9[$i][0], $aWP9[$i][1]) Then
            Out("[IotD] WARN: Paso 9 WP " & ($i + 1) & " incompleto, continuando")
        EndIf
    Next
    If Map_GetMapID() <> $IOTD_CLIFFS_MAP_ID Then
        Out("[IotD] ABORT Paso 9: salimos de CoD tras WPs (map=" & Map_GetMapID() & ")")
        Return False
    EndIf
    Out("[IotD] Paso 9 -> OK")
    If Map_GetMapID() <> $IOTD_CLIFFS_MAP_ID Then
        Out("[IotD] ABORT Paso 10: no en PoJ (map=" & Map_GetMapID() & ")")
        Return False
    EndIf
    Out("[IotD] Paso 10 -> desvio a grupo 5116 via WPs py4GW")
    If Not _Mission_DoNavOnly(6425, -3035) Then
        Out("[IotD] WARN: Paso 10 WP1 incompleto, continuando")
    EndIf
    If Not _Mission_DoNavOnly(7500, -4200) Then
        Out("[IotD] WARN: Paso 10 WP2 incompleto, continuando")
    EndIf
    If Not _Mission_DoNavOnly(8758, -5358) Then
        Out("[IotD] WARN: Paso 10 WP3 incompleto, continuando")
    EndIf
    If Map_GetMapID() <> $IOTD_CLIFFS_MAP_ID Then
        Out("[IotD] ABORT Paso 10: salimos de CoD durante WPs (map=" & Map_GetMapID() & ")")
        Return False
    EndIf
    Combat_ClearZone(1250, 20000)
    If GetNearestEnemy(2000) <> 0 Then Combat_ClearZone(1250, 10000)
    If Map_GetMapID() <> $IOTD_CLIFFS_MAP_ID Then
        Out("[IotD] ABORT Paso 10: salimos de PoJ (map=" & Map_GetMapID() & ")")
        Return False
    EndIf
    Out("[IotD] Paso 10 -> enemies en 2000u=" & GetNearestEnemy(2000))
    If Map_GetMapID() <> $IOTD_CLIFFS_MAP_ID Then
        Out("[IotD] ABORT Paso 11: no en PoJ (map=" & Map_GetMapID() & ")")
        Return False
    EndIf
    Out("[IotD] Paso 11 -> nav+combat grupo 4421 via WPs py4GW")
    If Not _Mission_DoNavOnly(9000, -6000) Then
        Out("[IotD] WARN: Paso 11 WP1 incompleto, continuando")
    EndIf
    If Not _Mission_DoNavOnly(9702, -7516) Then
        Out("[IotD] WARN: Paso 11 WP2 incompleto, continuando")
    EndIf
    Combat_ClearZone(1250, 20000)
    If GetNearestEnemy(2000) <> 0 Then Combat_ClearZone(1250, 10000)
    If Map_GetMapID() <> $IOTD_CLIFFS_MAP_ID Then
        Out("[IotD] ABORT Paso 11: salimos de PoJ (map=" & Map_GetMapID() & ")")
        Return False
    EndIf
    Out("[IotD] Paso 11 -> enemies en 2000u=" & GetNearestEnemy(2000))
    If Map_GetMapID() <> $IOTD_CLIFFS_MAP_ID Then
        Out("[IotD] ABORT Paso 12: no en CoD (map=" & Map_GetMapID() & ")")
        Return False
    EndIf
    Out("[IotD] Paso 12 -> nav a (11702,-9216) via WPs py4GW")
    If Not _Mission_DoNavOnly(8758, -5358) Then
        Out("[IotD] WARN: Paso 12 WP1 incompleto, continuando")
    EndIf
    If Not _Mission_DoNavOnly(9702, -7516) Then
        Out("[IotD] WARN: Paso 12 WP2 incompleto, continuando")
    EndIf
    If Not _Mission_DoNavOnly(11702, -9216) Then
        Out("[IotD] WARN: Paso 12 WP3 incompleto, continuando")
    EndIf
    If Map_GetMapID() <> $IOTD_CLIFFS_MAP_ID Then
        Out("[IotD] ABORT Paso 12: salimos de CoD (map=" & Map_GetMapID() & ")")
        Return False
    EndIf
    Out("[IotD] Paso 12 -> OK")
    If Map_GetMapID() <> $IOTD_CLIFFS_MAP_ID Then
        Out("[IotD] ABORT Paso 13: no en CoD (map=" & Map_GetMapID() & ")")
        Return False
    EndIf
    Local $curX = Agent_GetAgentInfo(-2, "X")
    If $curX > 13800 Then
        Out("[IotD] Paso 13ab -> SKIP: char ya al este de la pared (x=" & Round($curX) & ")")
    Else
        Local $iBkY = Round(Agent_GetAgentInfo(-2, "Y"))
        While Not Bot_ShouldStop() And $iBkY > -10300
            $iBkY -= 350
            If $iBkY < -10300 Then $iBkY = -10300
            Out("[IotD] Paso 13ab -> nav_only (14057," & $iBkY & ")")
            _Mission_DoNavOnly(14057, $iBkY)
            If Map_GetMapID() <> $IOTD_CLIFFS_MAP_ID Then
                Out("[IotD] ABORT Paso 13ab: map=" & Map_GetMapID())
                Return False
            EndIf
        WEnd
    EndIf
    Out("[IotD] Paso 13c -> nav_only portal (" & $IOTD_BEKNUR_PORTAL_X & "," & $IOTD_BEKNUR_PORTAL_Y & ")")
    _Mission_DoNavOnly($IOTD_BEKNUR_PORTAL_X, $IOTD_BEKNUR_PORTAL_Y)
    If Map_GetMapID() <> $IOTD_CLIFFS_MAP_ID Then
        Out("[IotD] ABORT Paso 13c: map=" & Map_GetMapID())
        Return False
    EndIf
    Out("[IotD] Paso 13 -> OK map=" & Map_GetMapID())
    Out("[IotD] Paso 14 -> nav_only junto portal BH char=(" & Round(Agent_GetAgentInfo(-2,"X")) & "," & Round(Agent_GetAgentInfo(-2,"Y")) & ")")
    _Mission_DoNavOnly($IOTD_BEKNUR_PORTAL_X, $IOTD_BEKNUR_PORTAL_Y)
    Out("[IotD] Paso 14 -> pos=(" & Round(Agent_GetAgentInfo(-2,"X")) & "," & Round(Agent_GetAgentInfo(-2,"Y")) & ") -> ForceCrossPortal -> Beknur Harbor (487)")
    If Not _IotD_ForceCrossPortal($IOTD_BEKNUR_PORTAL_X, $IOTD_BEKNUR_PORTAL_Y, $IOTD_BEKNUR_MAP_ID, 60000) Then
        Out("[IotD] FAIL: no se cruzÃ³ el portal a Beknur Harbor")
        Return False
    EndIf
    Out("[IotD] Paso 14 -> en Beknur Harbor OK")
    Return _IotD_DesdeBeknurHarbor()
EndFunc
Func _IotD_DesdeBeknurHarbor()
    Out("[IotD] DesdeBeknurHarbor start (map=" & Map_GetMapID() & ")")
    Out("[IotD] Paso 15 -> setup party Beknur Harbor (heroes + 4 henchmen)")
    Local $tBH = TimerInit()
    While TimerDiff($tBH) < 10000
        If Not Map_GetInstanceInfo("IsLoading") Then ExitLoop
        Sleep(500)
    WEnd
    Sleep(1500)   
    Out("[IotD] Paso 15 -> verificar heroes en party")
    If _AutoLevel_FindHeroSlot($GC_I_HERO_ID_KOSS) = 0 Then
        Out("[IotD] Paso 15 -> Koss no en party -> Party_AddHero")
        Party_AddHero($GC_I_HERO_ID_KOSS)
        Sleep(1200)
    EndIf
    If _AutoLevel_FindHeroSlot($GC_I_HERO_ID_DUNKORO) = 0 Then
        Out("[IotD] Paso 15 -> Dunkoro no en party -> Party_AddHero")
        Party_AddHero($GC_I_HERO_ID_DUNKORO)
        Sleep(1200)
    EndIf
    If _AutoLevel_FindHeroSlot($GC_I_HERO_ID_MELONNI) = 0 Then
        Out("[IotD] Paso 15 -> Melonni no en party -> Party_AddHero")
        Party_AddHero($GC_I_HERO_ID_MELONNI)
        Sleep(1200)
    EndIf
    Sleep(500)   
    Out("[IotD] Paso 15 -> kick todos los henchmen para setup limpio BH")
    Local $_hSizePre = Party_GetMyPartyInfo("ArrayHenchmanPartyMemberSize")
    For $_hi = $_hSizePre - 1 To 0 Step -1   
        Local $_hAgID = Party_GetMyPartyHenchmanInfo($_hi, "AgentID")
        If $_hAgID <> 0 Then
            Out("[IotD] Paso 15 -> kick hench slot " & $_hi & " AgentID=" & $_hAgID)
            Party_KickNpc($_hAgID)
            Sleep(600)
        EndIf
    Next
    Sleep(1000)
    Local $aIotD_Hench[4] = [4606, 4600, 4601, 4602]
    For $_hi = 0 To 3
        Local $_hModel = $aIotD_Hench[$_hi]
        If _AutoParty_IsHenchModelInParty($_hModel) Then
            Out("[IotD] Paso 15 -> model=" & $_hModel & " ya en party -> skip")
            ContinueLoop
        EndIf
        Local $_hAg = Agent_GetAgentByPlayerNumber($_hModel)
        If $_hAg = 0 Then
            Out("[IotD] Paso 15 -> model=" & $_hModel & " no encontrado en BH -> skip")
            ContinueLoop
        EndIf
        Out("[IotD] Paso 15 -> Party_AddNpc model=" & $_hModel)
        Party_AddNpc($_hAg)
        Sleep(800)
    Next
    Sleep(500)
    Local $partyNow = 1 + Party_GetMyPartyInfo("ArrayHeroPartyMemberSize") _
                        + Party_GetMyPartyInfo("ArrayHenchmanPartyMemberSize")
    Out("[IotD] Paso 15 -> party=" & $partyNow & "/8 tras setup")
    Out("[IotD] Paso 15 -> WalkThroughPortal east -> Issnur Isles (486)")
    If Not _IotD_WalkThroughPortal($IOTD_BH_EXIT_X, $IOTD_BH_EXIT_Y, "east", $IOTD_ISSNUR_MAP_ID, 60000) Then
        Out("[IotD] FAIL: no se cruzÃ³ el portal a Issnur Isles")
        Return False
    EndIf
    Out("[IotD] Paso 15 -> en Issnur Isles OK")
    $g_GE_RescueEnabled = False
    Out("[IotD] Paso 15 -> rescue deshabilitado para Issnur Isles")
    Local $tIS = TimerInit()
    While TimerDiff($tIS) < 8000
        If Not Map_GetInstanceInfo("IsLoading") Then ExitLoop
        Sleep(500)
    WEnd
    Sleep(1000)
    Out("[IotD] Paso 15 -> ClearZone portal entrada Issnur Isles (1300u/8s)")
    Combat_ClearZone(1250, 8000)
    Out("[IotD] Paso 16 -> cadena de combate inicial Issnur Isles")
    Local $aGroups[5][3] = [ _
        [-11252, 11695, 5594], _   
        [ -9592, 10577, 4427], _   
        [ -8588,  8812, 4428], _   
        [ -6482,  8053, 4430], _   
        [ -3318,  7773, 4396]  _   
    ]
    For $i = 0 To 4
        Out("[IotD] Paso 16 -> grupo " & ($i + 1) & "/5 model=" & $aGroups[$i][2] & _
            " (" & $aGroups[$i][0] & "," & $aGroups[$i][1] & ")")
        _Mission_DoNavThrough($aGroups[$i][0], $aGroups[$i][1])
        If GetNearestEnemy(1500) <> 0 Then
            Out("[IotD] Paso 16 -> ClearZone 1500u/10s (grupo " & ($i + 1) & ")")
            Combat_ClearZone(1250, 10000)
        EndIf
    Next
    Out("[IotD] Paso 16 -> cadena inicial OK")
    Out("[IotD] Paso 17 -> nav waypoint intermedio (-631,8292)")
    If Not _Mission_DoNavThrough(-631, 8292) Then
        Out("[IotD] WARN: nav waypoint #67 incompleto, continuando")
    EndIf
    Out("[IotD] Paso 17 -> OK")
    Out("[IotD] Paso 18a -> pre-stop (-597,7000) pre-clear antes de cluster 5107")
    _Mission_DoNavThrough(-597, 7000)
    Combat_ClearZone(1250, 60000)
    Out("[IotD] Paso 18b -> avanzar grupo model 5107 (-597,5490)")
    _Mission_DoNavThrough(-597, 5490)
    _IotD_WaitAliveAndClear(2500, 120000)
    Out("[IotD] Paso 18 -> enemies en 2000u=" & GetNearestEnemy(2000))
    Out("[IotD] Paso 19 -> nav+combat grupo model 5105 (1047,2900)")
    _Mission_DoNavThrough(1047, 2900)
    _IotD_WaitAliveAndClear(2500, 120000)
    Out("[IotD] Paso 19 -> enemies en 2000u=" & GetNearestEnemy(2000))
    Out("[IotD] Paso 20 -> nav waypoint (2329,4083)")
    If Not _Mission_DoNavThrough(2329, 4083) Then
        Out("[IotD] WARN: nav #71 incompleto, continuando")
    EndIf
    Out("[IotD] Paso 20 -> OK")
    Out("[IotD] Paso 21 -> cadena grupos #72-78 Issnur Isles")
    Local $aGrp2[7][3] = [ _
        [ 4091,  4933, 4396], _   
        [ 5857,  2221, 4443], _   
        [ 6331,  4174, 4407], _   
        [ 8689,  3073, 4396], _   
        [10371,  2223, 4428], _   
        [12011,  3687, 4430], _   
        [14478,  2217, 5594]  _   
    ]
    For $i = 0 To 6
        Out("[IotD] Paso 21 -> grupo " & ($i + 1) & "/7 model=" & $aGrp2[$i][2] & _
            " (" & $aGrp2[$i][0] & "," & $aGrp2[$i][1] & ")")
        _Mission_DoNavThrough($aGrp2[$i][0], $aGrp2[$i][1])
        If GetNearestEnemy(1500) <> 0 Then
            Combat_ClearZone(1250, 10000)
        EndIf
    Next
    Out("[IotD] Paso 21 -> cadena #72-78 completada. enemies en 2000u=" & GetNearestEnemy(2000))
    Out("[IotD] Paso 22 -> nav waypoint (15428,5646)")
    If Not _Mission_DoNavThrough(15428, 5646) Then
        Out("[IotD] WARN: nav #79 incompleto, continuando")
    EndIf
    Out("[IotD] Paso 22 -> OK")
    Out("[IotD] Paso 23 -> tres grupos finales #80-82")
    Local $aGrp3[3][3] = [ _
        [16756,  8547, 4436], _   
        [15876, 11377, 4428], _   
        [18901, 12939, 5595]  _   
    ]
    For $i = 0 To 2
        Out("[IotD] Paso 23 -> grupo " & ($i + 1) & "/3 model=" & $aGrp3[$i][2] & _
            " (" & $aGrp3[$i][0] & "," & $aGrp3[$i][1] & ")")
        _Mission_DoNavThrough($aGrp3[$i][0], $aGrp3[$i][1])
        If GetNearestEnemy(1500) <> 0 Then
            Combat_ClearZone(1250, 10000)
        EndIf
    Next
    Out("[IotD] Paso 23 -> grupos #80-82 completados. enemies en 2000u=" & GetNearestEnemy(2000))
    If GetNearestEnemy(3500) <> 0 Then
        Out("[IotD] Paso 23 -> ClearZone final antes de Paso 24 (3500u/20s)")
        _IotD_WaitAliveAndClear(3500, 20000)
    EndIf
    If GetNearestEnemy(2000) <> 0 Then
        Out("[IotD] Paso 23 -> ClearZone ABSOLUTO final (2000u/15s)")
        _IotD_WaitAliveAndClear(2000, 15000)
    EndIf
    Out("[IotD] Paso 23 -> final OK. enemies en 2000u=" & GetNearestEnemy(2000))
    Out("[IotD] Paso 24 -> waypoints #83-87 Issnur Isles (pass-through, no parar)")
    Local $aWP24[4][2] = [ _
        [21286, 11010], _   
        [23467,  8602], _   
        [25969,  7937], _   
        [28886,  6871]  _   
    ]
    For $i = 0 To 3
        Local $wpX = $aWP24[$i][0]
        Local $wpY = $aWP24[$i][1]
        Out("[IotD] Paso 24 -> WP " & ($i + 1) & "/4 (" & $wpX & "," & $wpY & ") pass-through")
        Map_Move($wpX, $wpY, 0)
        Local $tWp = TimerInit()
        Local $tSkill = TimerInit()
        While Not Bot_ShouldStop() And TimerDiff($tWp) < 25000
            Local $cx = Agent_GetAgentInfo(-2, "X")
            Local $cy = Agent_GetAgentInfo(-2, "Y")
            If Sqrt(($cx - $wpX)^2 + ($cy - $wpY)^2) < 1000 Then ExitLoop
            If TimerDiff($tSkill) >= 6000 Then
                Skill_UseSkill(6)
                $tSkill = TimerInit()
            EndIf
            Sleep(200)
        WEnd
    Next
    Out("[IotD] Paso 24 -> waypoints OK (pass-through)")
    Out("[IotD] Paso 25 -> ForceCrossPortal Issnur Isles -> Kodlonu Hamlet (489)")
    If Not _IotD_ForceCrossPortal(28886, 6871, $GC_I_MAP_ID_KODLONU_HAMLET, 60000) Then
        Out("[IotD] FAIL Paso 25: no se cruzÃ³ a Kodlonu Hamlet")
        Return False
    EndIf
    Out("[IotD] Paso 25 -> en Kodlonu Hamlet OK (map=" & Map_GetMapID() & ")")
    Return _IotD_DesdeKodlonu()
EndFunc
Func _IotD_DesdeKodlonu()
    Out("[IotD] DesdeKodlonu start (map=" & Map_GetMapID() & ")")
    If Quest_GetQuestInfo($IOTD_QUEST_ID, "LogState") = 35 Then
        Out("[IotD] DesdeKodlonu: quest 635 ls=35 (can-reward) -> viajar Kamadan y cobrar directo (sin ruta Mehtani)")
        $g_GE_RescueEnabled = True
        If Not Travel_ToOutpost($GC_I_MAP_ID_KAMADAN_JEWEL_OF_ISTAN) Then
            Out("[IotD] FAIL DesdeKodlonu ls=35: no se llego a Kamadan -> continuar ruta normal")
        Else
            If _IotD_DoReward() Then
                Out("[IotD] DoReward desde Kodlonu (ls=35) OK -> quest 635 completada")
                Return True
            EndIf
            Out("[IotD] WARN DoReward desde Kodlonu fallo (ls=35) -> continuar ruta normal")
        EndIf
    EndIf
    Local $tKH = TimerInit()
    While TimerDiff($tKH) < 10000
        If Not Map_GetInstanceInfo("IsLoading") Then ExitLoop
        Sleep(500)
    WEnd
    Sleep(1500)
    Local $_capture = False   
    Out("[IotD] DesdeKodlonu -> setup party (heroes + henchmen Kodlonu)")
    If _AutoLevel_FindHeroSlot($GC_I_HERO_ID_KOSS) = 0 Then
        Party_AddHero($GC_I_HERO_ID_KOSS)
        Sleep(1200)
    EndIf
    If _AutoLevel_FindHeroSlot($GC_I_HERO_ID_DUNKORO) = 0 Then
        Party_AddHero($GC_I_HERO_ID_DUNKORO)
        Sleep(1200)
    EndIf
    If _AutoLevel_FindHeroSlot($GC_I_HERO_ID_MELONNI) = 0 Then
        Party_AddHero($GC_I_HERO_ID_MELONNI)
        Sleep(1200)
    EndIf
    Sleep(500)
    If Not $_capture Then   
    Local $_hSizeKH = Party_GetMyPartyInfo("ArrayHenchmanPartyMemberSize")
    For $_ki = $_hSizeKH - 1 To 0 Step -1
        Local $_kAgID = Party_GetMyPartyHenchmanInfo($_ki, "AgentID")
        If $_kAgID <> 0 Then
            Out("[IotD] DesdeKodlonu -> kick hench slot " & $_ki & " AgentID=" & $_kAgID)
            Party_KickNpc($_kAgID)
            Sleep(600)
        EndIf
    Next
    Sleep(1000)
    Local $_dumpHench = Agent_GetAgentArray($GC_I_AGENT_TYPE_LIVING)
    If IsArray($_dumpHench) Then
        For $_dh = 0 To UBound($_dumpHench) - 1
            If $_dumpHench[$_dh] = 0 Then ContinueLoop
            Local $_dhModel = Agent_GetAgentInfo($_dumpHench[$_dh], "PlayerNumber")
            If $_dhModel < 4500 Or $_dhModel > 4700 Then ContinueLoop
            Out("[IotD] DUMP HENCH: model=" & $_dhModel & " alleg=" & Agent_GetAgentInfo($_dumpHench[$_dh], "Allegiance") & " isHench=" & Agent_GetAgentInfo($_dumpHench[$_dh], "IsHenchman") & " name='" & Agent_GetAgentInfo($_dumpHench[$_dh], "Name") & "'")
        Next
    EndIf
    Local $partyKH = 0
    For $fillTry = 1 To 5
        Party_FillWithHenchmen()
        Sleep(900)
        $partyKH = 1 + Party_GetMyPartyInfo("ArrayHeroPartyMemberSize") _
                     + Party_GetMyPartyInfo("ArrayHenchmanPartyMemberSize")
        Out("[IotD] DesdeKodlonu -> party=" & $partyKH & "/8 (intento " & $fillTry & "/5)")
        If $partyKH >= 8 Then ExitLoop
    Next
    If $partyKH < 8 Then Out("[IotD] WARN: party solo " & $partyKH & "/8 tras 5 intentos de fill")
    EndIf   
    Out("[IotD] Paso 26 -> nav Kodlonu Hamlet (820,-2262)->(4158,-3823)")
    $g_GE_RescueEnabled = True
    If Not _Mission_DoNavOnly(820, -2262) Then
        Out("[IotD] WARN Paso 26 WP1 incompleto, continuando")
    EndIf
    If Not _Mission_DoNavOnly(4158, -3823) Then
        Out("[IotD] WARN Paso 26 WP2 incompleto, continuando")
    EndIf
    Out("[IotD] Paso 26 -> OK")
    Out("[IotD] Paso 27 -> nav_only portal Kodlonu (4320,-3734)")
    _Mission_DoNavOnly(4320, -3734)
    Out("[IotD] Paso 27 -> ForceCrossPortal (4320,-3734) -> Mehtani Keys (488)")
    If Not _IotD_ForceCrossPortal(4320, -3734, $GC_I_MAP_ID_MEHTANI_KEYS, 60000) Then
        Out("[IotD] FAIL Paso 27: no se cruzÃ³ map=" & Map_GetMapID())
        Return False
    EndIf
    Out("[IotD] Paso 27 -> Mehtani Keys OK (map=" & Map_GetMapID() & ")")
    $g_GE_RescueEnabled = False
    Local $tMK = TimerInit()
    While TimerDiff($tMK) < 8000
        If Not Map_GetInstanceInfo("IsLoading") Then ExitLoop
        Sleep(500)
    WEnd
    Sleep(1000)
    If $_capture Then
        Sleep(2500)
        Local $_mkSize = Party_GetMyPartyInfo("ArrayHenchmanPartyMemberSize")
        Out("[IotD] CAPTURA MEHTANI: " & $_mkSize & " henchmen en el party")
        For $_mki = 0 To $_mkSize - 1
            Local $_mkAg = Party_GetMyPartyHenchmanInfo($_mki, "AgentID")
            If $_mkAg <> 0 Then
                Out("[IotD] CAPTURA HENCH: slot=" & $_mki & " model=" & Agent_GetAgentInfo($_mkAg, "PlayerNumber") & " name='" & Agent_GetAgentInfo($_mkAg, "Name") & "'")
            Else
                Out("[IotD] CAPTURA HENCH: slot=" & $_mki & " AgentID=0")
            EndIf
        Next
        Out("[IotD] CAPTURA done -> parar (revertir $_capture cuando $list489 estÃ© bien)")
        Return False
    EndIf
    Out("[IotD] Paso 27 -> ClearZone entrada Mehtani Keys (1300u/8s)")
    Combat_ClearZone(1250, 8000)
    Out("[IotD] Paso 28 -> nav+combat grupo model 5594 (-14868,15834)")
    _Mission_DoNavThrough(-14868, 15834)
    _IotD_WaitAliveAndClear(2000, 60000)
    Out("[IotD] Paso 28 -> enemies en 2000u=" & GetNearestEnemy(2000))
    Out("[IotD] Pasos 29-31 -> ruta Mehtani Keys (14 waypoints)")
    Local $aMK[15][2] = [ _
        [-13544, 12133], _
        [-11965, 10099], _
        [-12042,  9786], _
        [-12824,  7392], _
        [ -9643,  3060], _
        [ -8500,  2400], _
        [ -7383,  1746], _
        [ -7811,  2458], _
        [ -6318,  4432], _
        [ -3899,  6435], _
        [ -1208,  5842], _
        [   363,  3863], _
        [  4339, -2031], _
        [  3548, -5326], _
        [  5892, -8184]  _
    ]
    Local $iMKRestart = 0   
    For $i = 0 To 14
        If Map_GetMapID() <> $GC_I_MAP_ID_MEHTANI_KEYS Then
            Out("[IotD] ABORT P29-31 WP" & ($i+1) & ": map=" & Map_GetMapID() & " (esperado 488)")
            $g_iCombatLeashRange = 0
            Return False
        EndIf
        If Quest_GetQuestInfo($IOTD_QUEST_ID, "LogState") = 35 Then
            Out("[IotD] P29-31 WP" & ($i+1) & ": quest 635 ls=35 (can-reward) -> cortar ruta, ir a cobrar")
            ExitLoop
        EndIf
        $g_iCombatLeashX = $aMK[$i][0]
        $g_iCombatLeashY = $aMK[$i][1]
        $g_iCombatLeashRange = 3500
        If GetNearestEnemy(2500) <> 0 Then
            Out("[IotD] P29-31 -> pre-clear WaitAlive antes de WP" & ($i+1))
            _IotD_WaitAliveAndClear(2500, 45000)
        EndIf
        Out("[IotD] P29-31 WP" & ($i+1) & "/15 -> (" & $aMK[$i][0] & "," & $aMK[$i][1] & ")")
        Local $bNavMK = _Mission_DoNavThrough($aMK[$i][0], $aMK[$i][1])
        Local $bNavMKFail = Not $bNavMK
        If $bNavMKFail Then
            Local $nvMKx = Agent_GetAgentInfo(-2, "X")
            Local $nvMKy = Agent_GetAgentInfo(-2, "Y")
            If $nvMKx <> 0 Or $nvMKy <> 0 Then
                Local $nvMKnx = $aMK[$i][0]
                Local $nvMKny = $aMK[$i][1]
                Local $nvMKd = Sqrt(($nvMKnx - $nvMKx)^2 + ($nvMKny - $nvMKy)^2)
                If $nvMKd > 8000 And $iMKRestart = 0 Then
                    Out("[IotD] P29-31 nav fail WP" & ($i+1) & " con dist restante=" & Round($nvMKd, 0) & "u (pos " & Round($nvMKx, 0) & "," & Round($nvMKy, 0) & ") -> revive remoto -> reiniciar ruta desde WP1")
                    $iMKRestart = 1
                    $i = -1
                    $g_iCombatLeashRange = 0
                    ContinueLoop
                EndIf
                Out("[IotD] P29-31 nav fail WP" & ($i+1) & " (dist restante=" & Round($nvMKd, 0) & "u) -> continuar siguiente WP")
            EndIf
        EndIf
        If GetNearestEnemy(2500) <> 0 Then
            Out("[IotD] P29-31 -> post-clear WaitAlive tras WP" & ($i+1))
            _IotD_WaitAliveAndClear(2500, 45000)
        EndIf
    Next
    $g_iCombatLeashRange = 0   
    Out("[IotD] P29-31 -> ClearZone final en WP14 (5892,-8184)")
    _IotD_WaitAliveAndClear(2500, 45000)
    Out("[IotD] Pasos 29-31 -> OK")
    Out("[IotD] Paso 32 -> Travel a Kamadan (449) para cobrar reward quest 635")
    $g_GE_RescueEnabled = True
    If Not Travel_ToOutpost($GC_I_MAP_ID_KAMADAN_JEWEL_OF_ISTAN) Then
        Out("[IotD] FAIL Paso 32: no se llegÃ³ a Kamadan")
        Return False
    EndIf
    Out("[IotD] Paso 32 -> en Kamadan OK")
    If Not _IotD_DoReward() Then
        Out("[IotD] FAIL Paso 32: reward quest 635 fallido")
        Return False
    EndIf
    $g_GE_RescueEnabled = True
    Out("[IotD] DesdeKodlonu OK")
    Return True
EndFunc
Func _IotD_DoReward()
    Out("[IotD] DoReward -> Kamadan map=" & Map_GetMapID() & " char=(" & Round(Agent_GetAgentInfo(-2,"X")) & "," & Round(Agent_GetAgentInfo(-2,"Y")) & ")")
    Local $st
    Local $stPre = Quest_GetQuestInfo($IOTD_QUEST_ID, "LogState")   
    Local $iIntento
    For $iIntento = 1 To 2
        Local $npcModelThis = $IOTD_QUEST_NPC_MODEL
        If $iIntento = 2 Then
            Out("[IotD] DoReward intento 2 -> fallback quest-giver por cercania (sin model)")
            $npcModelThis = 0
        EndIf
        Out("[IotD] DoReward -> NavAndOpenDialog + Bot_Dialog(reward) [intento " & $iIntento & "]")
        If Not _Quests_NavAndOpenDialog($IOTD_QUEST_NPC_X, $IOTD_QUEST_NPC_Y, $npcModelThis) Then
            Out("[IotD] DoReward FAIL intento " & $iIntento & ": no se pudo navegar al NPC")
            ContinueLoop
        EndIf
        Bot_Dialog(0x00827B07)
        Sleep(5000)
        $st = Quest_GetQuestInfo($IOTD_QUEST_ID, "LogState")
        Out("[IotD] DoReward intento " & $iIntento & " -> LogState=" & $st & " (pre=" & $stPre & ")")
        If $st = 0 Then
            Out("[IotD] DoReward OK: quest 635 completada (intento " & $iIntento & ")")
            Return True
        EndIf
        If $st = -1 Then
            If $stPre > 0 Then
                Out("[IotD] DoReward OK: q635 rewarded (ls " & $stPre & "->-1, saliÃ³ del log)")
                Return True
            EndIf
            Out("[IotD] DoReward FAIL: LogState=-1 (quest 635 nunca en log) - NO asumir completada")
            Return False
        EndIf
        Out("[IotD] DoReward WARN: LogState=" & $st & " -> reintentando")
    Next
    Out("[IotD] DoReward FAIL: LogState=" & $st & " tras 2 intentos")
    Return False
EndFunc
Func _IotD_EnsureAttributesAssigned()
    Out("[IotD] EnsureAttributes start")
    If Map_GetInstanceInfo("Type") <> $GC_I_MAP_TYPE_OUTPOST Then
        Out("[IotD] EnsureAttributes SKIP: char en explorable (type=" & Map_GetInstanceInfo("Type") & ") - cargar templates crashea GW. Continuar sin recargar.")
        Return
    EndIf
    If Agent_GetAgentInfo(-2, "MaxHP") <= 0 Then
        Out("[IotD] EnsureAttributes SKIP: char aun no poblado (MaxHP=0) - LoadSkillTemplate crashea GW.")
        Return
    EndIf
    $g_iAutoLevelLastUnused = 0
    $g_iAutoLevelStuckTicks = 0
    $g_iAutoLevelSkipMask   = 0
    $g_iKossLastUnused      = 0
    $g_iDunkoroLastUnused   = 0
    $g_iMelonniLastUnused   = 0
    Out("[IotD] Char -> LoadSkillTemplate (" & $IOTD_CHAR_TEMPLATE & ")")
    Attribute_LoadSkillTemplate($IOTD_CHAR_TEMPLATE)
    Sleep(300)
    If _AutoLevel_FindHeroSlot($GC_I_HERO_ID_KOSS) = 0 Then
        Out("[IotD] EnsureAttributes: Koss no en party -> Party_AddHero")
        Party_AddHero($GC_I_HERO_ID_KOSS)
        Sleep(1500)
    EndIf
    If _AutoLevel_FindHeroSlot($GC_I_HERO_ID_DUNKORO) = 0 Then
        Out("[IotD] EnsureAttributes: Dunkoro no en party -> Party_AddHero")
        Party_AddHero($GC_I_HERO_ID_DUNKORO)
        Sleep(2500)   
    EndIf
    Local $dunkoroSlotEarly = _AutoLevel_FindHeroSlot($GC_I_HERO_ID_DUNKORO)
    If $dunkoroSlotEarly > 0 Then
        Out("[IotD] Dunkoro slot " & $dunkoroSlotEarly & " -> LoadSkillTemplate (early, " & $IOTD_DUNKORO_TEMPLATE & ")")
        Attribute_LoadSkillTemplate($IOTD_DUNKORO_TEMPLATE, $dunkoroSlotEarly)
        Sleep(800)
        Attribute_LoadSkillTemplate($IOTD_DUNKORO_TEMPLATE, $dunkoroSlotEarly)
        Sleep(500)
    EndIf
    If _AutoLevel_FindHeroSlot($GC_I_HERO_ID_MELONNI) = 0 Then
        Out("[IotD] EnsureAttributes: Melonni no en party -> Party_AddHero")
        Party_AddHero($GC_I_HERO_ID_MELONNI)
        Sleep(1500)
    EndIf
    Local $kossCritMap = Map_GetMapID()
    Local $kossCritType = Map_GetInstanceInfo("Type")
    If $kossCritMap = $IOTD_KAMADAN_MAP_ID And $kossCritType = $GC_I_MAP_TYPE_OUTPOST Then
        Local Const $IOTD_KOSS_CRIT_SKILLS[2] = [$GC_I_SKILL_ID_FOR_GREAT_JUSTICE, $GC_I_SKILL_ID_GASH]
        Local $iotdKossMissing = ""
        For $kc = 0 To UBound($IOTD_KOSS_CRIT_SKILLS) - 1
            If Not World_IsSkillLearnt($IOTD_KOSS_CRIT_SKILLS[$kc]) Then
                If $iotdKossMissing <> "" Then $iotdKossMissing &= ","
                $iotdKossMissing &= $IOTD_KOSS_CRIT_SKILLS[$kc]
                Out("[IotD] Koss skill " & $IOTD_KOSS_CRIT_SKILLS[$kc] & " NO aprendida -> pendiente compra")
            Else
                Out("[IotD] Koss skill " & $IOTD_KOSS_CRIT_SKILLS[$kc] & " aprendida: SI")
            EndIf
        Next
        If $iotdKossMissing <> "" Then
            Out("[IotD] Koss skills criticas faltan (" & $iotdKossMissing & ") -> nav Skill Merchant Kamadan")
            If _Quests_NavAndOpenDialog($BSK_MERCHANT_X, $BSK_MERCHANT_Y, $BSK_MERCHANT_MODEL) Then
                Local $aKossIds = StringSplit($iotdKossMissing, ",", 2)
                For $ki = 0 To UBound($aKossIds) - 1
                    Local $ks = Number($aKossIds[$ki])
                    If $ks = 0 Then ContinueLoop
                    If World_IsSkillLearnt($ks) Then ContinueLoop
                    For $ka = 1 To 2
                        Out("[IotD] Skill_BuySkillByID(" & $ks & ") intento " & $ka)
                        Skill_BuySkillByID($ks)
                        Sleep(2500)
                        If World_IsSkillLearnt($ks) Then ExitLoop
                    Next
                    Out("[IotD] Koss skill " & $ks & ": " & (World_IsSkillLearnt($ks) ? "aprendida OK" : "FALLO"))
                Next
            Else
                Out("[IotD] WARN: nav a Skill Merchant fallo - Koss podria quedar con slots vacios")
            EndIf
        EndIf
    EndIf
    Local $kossSlot    = _AutoLevel_FindHeroSlot($GC_I_HERO_ID_KOSS)
    Local $dunkoroSlot = _AutoLevel_FindHeroSlot($GC_I_HERO_ID_DUNKORO)
    Local $melonniSlot = _AutoLevel_FindHeroSlot($GC_I_HERO_ID_MELONNI)
    If $kossSlot > 0 Then
        Out("[IotD] Koss slot " & $kossSlot & " -> LoadSkillTemplate")
        Attribute_LoadSkillTemplate($IOTD_KOSS_TEMPLATE, $kossSlot)
    Else
        Out("[IotD] WARN: Koss no encontrado en party")
    EndIf
    If $dunkoroSlot > 0 Then
        Out("[IotD] Dunkoro slot " & $dunkoroSlot & " -> LoadSkillTemplate")
        Attribute_LoadSkillTemplate($IOTD_DUNKORO_TEMPLATE, $dunkoroSlot)
    Else
        Out("[IotD] WARN: Dunkoro no encontrado en party")
    EndIf
    If $melonniSlot > 0 Then
        Out("[IotD] Melonni slot " & $melonniSlot & " -> LoadSkillTemplate")
        Attribute_LoadSkillTemplate($IOTD_MELONNI_TEMPLATE, $melonniSlot)
    Else
        Out("[IotD] WARN: Melonni no encontrado en party")
    EndIf
    Local $charUnused = Attribute_GetPartyAttributePointInfo(0, "UnusedPoints")
    If @error Then $charUnused = 0
    If $charUnused <= 0 Then
        Sleep(300)   
        Out("[IotD] EnsureAttributes done (char ya configurado)")
        Return
    EndIf
    Sleep(600)   
    Local $tStart = TimerInit()
    Local $ticks  = 0
    Local $lastUnused = -1
    Local $stuckTicks = 0
    While Not Bot_ShouldStop() And TimerDiff($tStart) < 30000
        $charUnused = Attribute_GetPartyAttributePointInfo(0, "UnusedPoints")
        If @error Then $charUnused = 0
        If $charUnused <= 0 Then
            Out("[IotD] Char atributos OK en " & $ticks & " ticks (Scythe 11, Mysticism 3)")
            ExitLoop
        EndIf
        If $charUnused = $lastUnused Then
            $stuckTicks += 1
            If $stuckTicks >= 3 Then
                Out("[IotD] EnsureAttributes: " & $charUnused & " puntos en cap (no asignables) - salir")
                ExitLoop
            EndIf
        Else
            $stuckTicks = 0
            $lastUnused = $charUnused
        EndIf
        _AutoLevel_ProcessChar()
        $ticks += 1
        Sleep(200)
    WEnd
    If Attribute_GetPartyAttributePointInfo(0, "UnusedPoints") > 0 Then
        Out("[IotD] EnsureAttributes WARN: char aun tiene puntos sin asignar tras 30s")
    EndIf
    Out("[IotD] EnsureAttributes done")
EndFunc
Func _IotD_ForceCrossPortal($baseX, $baseY, $targetMap, $totalTimeoutMs = 60000)
    Local $offsets[9][2] = [ _
        [ 500,  400], _   
        [ 800,    0], _   
        [   0,    0], _   
        [-800,    0], _   
        [   0,  400], _   
        [   0, -400], _   
        [-500,  400], _   
        [-500, -400], _   
        [ 500, -400] _    
    ]
    Local $t        = TimerInit()
    Local $idx      = 8
    Local $lastChange = TimerInit()
    Local $tReemit  = TimerInit()
    Local $curX     = $baseX
    Local $curY     = $baseY
    Map_Move($curX, $curY, 0)
    Out("[IotD] ForceCrossPortal centro (" & $baseX & "," & $baseY & ") -> map " & $targetMap)
    While Not Bot_ShouldStop() And TimerDiff($t) < $totalTimeoutMs
        If Map_GetMapID() = $targetMap Then
            Out("[IotD] Portal cruzado a map " & $targetMap & " en " & Round(TimerDiff($t)/1000, 1) & "s")
            Return True
        EndIf
        Sleep(400)
        If Agent_GetAgentInfo(-2, "IsDead") Then
            Out("[IotD] ForceCrossPortal: char muerto, esperando rez...")
            Local $tFCPDeath = TimerInit()
            Local $bFCPRez   = False
            While Not Bot_ShouldStop() And TimerDiff($tFCPDeath) < 30000
                If Map_GetMapID() = $targetMap Then Return True   
                If Map_GetMapID() = 0 Then ExitLoop
                If Not Agent_GetAgentInfo(-2, "IsDead") Then
                    Local $rezX = Agent_GetAgentInfo(-2, "X")
                    Local $rezY = Agent_GetAgentInfo(-2, "Y")
                    If $rezX <> 0 Or $rezY <> 0 Then
                        Out("[IotD] ForceCrossPortal: rez OK en (" & Round($rezX) & "," & Round($rezY) & "), retomando")
                        Sleep(2000)
                        Map_Move($curX, $curY, 0)
                        $tReemit    = TimerInit()
                        $lastChange = TimerInit()
                        $bFCPRez    = True
                        ExitLoop
                    EndIf
                EndIf
                Sleep(400)
            WEnd
            If Not $bFCPRez Then
                Out("[IotD] ForceCrossPortal: TIMEOUT rez (30s) -> abort portal")
                Return False
            EndIf
            ContinueLoop
        EndIf
        If Map_GetInstanceInfo("IsLoading") Then
            $tReemit    = TimerInit()
            $lastChange = TimerInit()
            ContinueLoop
        EndIf
        If Map_GetMapID() = $targetMap Then
            Out("[IotD] Portal cruzado a map " & $targetMap & " en " & Round(TimerDiff($t)/1000, 1) & "s")
            Return True
        EndIf
        If TimerDiff($tReemit) >= 2500 Then
            Map_Move($curX, $curY, 0)
            $tReemit = TimerInit()
        EndIf
        If TimerDiff($lastChange) >= 5000 Then
            $idx  = Mod($idx + 1, 9)
            $curX = $baseX + $offsets[$idx][0]
            $curY = $baseY + $offsets[$idx][1]
            Out("[IotD] ForceCrossPortal offset " & $idx & " -> Map_Move(" & $curX & "," & $curY & ")")
            Map_Move($curX, $curY, 0)
            $lastChange = TimerInit()
            $tReemit    = TimerInit()
        EndIf
    WEnd
    Out("[IotD] ForceCrossPortal TIMEOUT (" & Round($totalTimeoutMs/1000) & "s), map actual=" & Map_GetMapID())
    Return False
EndFunc
Func _IotD_WalkThroughPortal($wpX, $wpY, $direction, $targetMap, $timeoutMs = 60000)
    Out("[IotD] WalkThroughPortal dir=" & $direction & " WP=(" & $wpX & "," & $wpY & ") -> map " & $targetMap)
    Map_Move($wpX, $wpY, 0)
    Local $tW  = TimerInit()
    Local $tWR = TimerInit()
    While Not Bot_ShouldStop() And TimerDiff($tW) < 25000
        If Map_GetInstanceInfo("IsLoading") Then
            $tWR = TimerInit()
            Sleep(300)
            ContinueLoop
        EndIf
        If Map_GetMapID() = $targetMap Then Return True   
        Local $cx = Agent_GetAgentInfo(-2, "X")
        Local $cy = Agent_GetAgentInfo(-2, "Y")
        If Sqrt(($cx - $wpX)^2 + ($cy - $wpY)^2) < 700 Then ExitLoop
        Sleep(300)
        If TimerDiff($tWR) >= 3000 Then
            Map_Move($wpX, $wpY, 0)
            $tWR = TimerInit()
        EndIf
    WEnd
    Local $o1x = 0, $o1y = 0, $o2x = 0, $o2y = 0
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
            Out("[IotD] WalkThroughPortal direction invalida: " & $direction)
            Return False
    EndSwitch
    Local $offsets[7][2] = [ _
        [0,              0            ], _
        [$o1x,           $o1y         ], _
        [$o2x,           $o2y         ], _
        [$o1x,           $o1y         ], _
        [$o2x + $o1x,    $o2y + $o1y ], _
        [$o1x + $o2x,    $o1y + $o2y ], _
        [-$o1x,          $o1y         ]  _
    ]
    Local $t     = TimerInit()
    Local $idx   = 0
    Local $tLast = TimerInit()
    Local $tRe   = TimerInit()
    Local $curX  = $wpX + $offsets[0][0]
    Local $curY  = $wpY + $offsets[0][1]
    Map_Move($curX, $curY, 0)
    Out("[IotD] WalkThroughPortal offset 0 -> Map_Move(" & $curX & "," & $curY & ")")
    While Not Bot_ShouldStop() And TimerDiff($t) < $timeoutMs
        If Map_GetInstanceInfo("IsLoading") Then
            $tRe   = TimerInit()
            $tLast = TimerInit()
            Sleep(400)
            ContinueLoop
        EndIf
        If Map_GetMapID() = $targetMap Then
            Out("[IotD] WalkThroughPortal cruzado a " & $targetMap & " en " & Round(TimerDiff($t)/1000, 1) & "s (offset " & $idx & ")")
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
            Out("[IotD] WalkThroughPortal offset " & $idx & " -> Map_Move(" & $curX & "," & $curY & ")")
            Map_Move($curX, $curY, 0)
            $tLast = TimerInit()
            $tRe   = TimerInit()
        EndIf
    WEnd
    Out("[IotD] WalkThroughPortal TIMEOUT " & Round($timeoutMs/1000, 0) & "s (map=" & Map_GetMapID() & ")")
    Return False
EndFunc
Func _IotD_WaitAliveAndClear($range, $timeoutMs)
    Local $totalT = TimerInit()
    Local $maxTotal = $timeoutMs * 4 + 60000
    Do
        If Quest_GetQuestInfo($IOTD_QUEST_ID, "LogState") = 35 Then
            Out("[IotD] WaitAliveAndClear: quest 635 ls=35 (can-reward) -> cortar limpieza, ir a cobrar")
            Return
        EndIf
        Local $tw = TimerInit()
        While Not Bot_ShouldStop() And TimerDiff($tw) < 20000
            If Agent_GetAgentInfo(-2, "HP") > 0 Then ExitLoop
            Sleep(500)
        WEnd
        Combat_ClearZone($range, $timeoutMs)
        Sleep(1000)
    Until GetNearestEnemy(2000) = 0 Or TimerDiff($totalT) > $maxTotal
EndFunc