#include-once
Global Const $M2J_OUTPOST_MAP_ID = $GC_I_MAP_ID_JOKANUR_DIGGINGS_OUTPOST 
Global Const $M2J_NPC_MODEL      = $GC_I_MODEL_ID_NF_GENERIC_B    
Global Const $M2J_NPC_X          = 2888
Global Const $M2J_NPC_Y          = 2207
Global Const $M2J_DIALOG_HELP    = 0x81
Global Const $M2J_DIALOG_READY   = 0x84
Global Const $M2J_KOSS_HERO_ID  = 6     
Global Const $M2J_KIHM_MODEL    = $GC_I_MODEL_ID_NF_KIHM          
Global Const $M2J_CHAR_TEMPLATE = "OgGikms2cV+vD4xLXZcbfFA"  
Global $g_M02_BossDead = False
Global Const $M2J_MAX_ATTEMPTS = 3
Func Quest_M02_JokanurDiggings_Run()
    For $attempt = 1 To $M2J_MAX_ATTEMPTS
        If $attempt > 1 Then
            Out("[M02] === REINTENTO " & $attempt & "/" & $M2J_MAX_ATTEMPTS & " ===")
            $g_GE_NeedsWalkback   = False
            $g_GE_WalkbackStarted = False
            $g_GE_LastCharIsDead  = False
            $g_GE_RescueEnabled   = True
            $g_bResignMode        = False
            Sleep(3000)   
        EndIf
        If _M2J_RunOnce() Then Return True
        Local $retMap  = Map_GetMapID()
        Local $retType = Map_GetInstanceInfo("Type")
        If $retMap = $M2J_OUTPOST_MAP_ID And $retType = $GC_I_MAP_TYPE_OUTPOST Then
            Out("[M02] Derrota en coop -> outpost | quedan " & ($M2J_MAX_ATTEMPTS - $attempt) & " reintentos")
        ElseIf $retMap = $M2J_OUTPOST_MAP_ID Then
            Out("[M02] Fallo en instancia (type=" & $retType & ") -> Map_TravelTo(outpost) + reintentar (quedan " & ($M2J_MAX_ATTEMPTS - $attempt) & ")")
            $g_bResignMode = False
            Map_TravelTo($M2J_OUTPOST_MAP_ID)
            Sleep(3000)
        Else
            Out("[M02] FAIL en mapa inesperado (map=" & $retMap & " type=" & $retType & ") -> abort")
            Return False
        EndIf
    Next
    Out("[M02] FAIL definitivo: " & $M2J_MAX_ATTEMPTS & " intentos agotados")
    Return False
EndFunc
Func _M2J_RunOnce()
    Out("[M02] Start")
    $g_bHasBundle = False
    $g_bMarkCallbackDisabled = False
    $g_iLastMarkedEnemy = 0
    $g_GE_NeedsWalkback = False
    $g_GE_WalkbackStarted = False
    $g_GE_LastCharIsDead = False
    $g_GE_RescueEnabled = True
    $g_M02_BossDead = False
    Local $p0Map  = Map_GetMapID()
    Local $p0Type = Map_GetInstanceInfo("Type")
    Out("[M02] Paso 0: map=" & $p0Map & " type=" & $p0Type & " (necesito map=" & $M2J_OUTPOST_MAP_ID & " type=" & $GC_I_MAP_TYPE_OUTPOST & ")")
    If $p0Map = $M2J_OUTPOST_MAP_ID And $p0Type = $GC_I_MAP_TYPE_EXPLORABLE Then
        Out("[M02] Arranque DENTRO de instancia atascada (type=1) -> Map_TravelTo(outpost) para reiniciar limpio")
        Map_TravelTo($M2J_OUTPOST_MAP_ID)
        Local $tEsc = TimerInit()
        While Not Bot_ShouldStop() And TimerDiff($tEsc) < 30000
            If Map_GetMapID() = $M2J_OUTPOST_MAP_ID And Map_GetInstanceInfo("Type") = $GC_I_MAP_TYPE_OUTPOST Then
                Out("[M02] De vuelta en Jokanur outpost tras " & Round(TimerDiff($tEsc)/1000,1) & "s -> re-entrar")
                ExitLoop
            EndIf
            Sleep(1000)
        WEnd
        If Map_GetInstanceInfo("Type") <> $GC_I_MAP_TYPE_OUTPOST Then
            Out("[M02] FAIL: no se salio de la instancia atascada en 30s")
            Out("[M02] Fallback /resign para salir de la instancia")
            $g_bResignMode = True
            Chat_SendChat("resign", "/")
            Local $tResign = TimerInit()
            While Not Bot_ShouldStop() And TimerDiff($tResign) < 60000
                If Map_GetMapID() = $M2J_OUTPOST_MAP_ID And Map_GetInstanceInfo("Type") = $GC_I_MAP_TYPE_OUTPOST Then
                    Out("[M02] /resign OK: en Jokanur outpost tras " & Round(TimerDiff($tResign) / 1000, 1) & "s")
                    ExitLoop
                EndIf
                Sleep(1000)
            WEnd
            $g_bResignMode = False
            If Map_GetInstanceInfo("Type") <> $GC_I_MAP_TYPE_OUTPOST Then
                Out("[M02] FAIL: ni /resign saco de la instancia en 60s")
                Return False
            EndIf
        EndIf
    ElseIf $p0Map <> $M2J_OUTPOST_MAP_ID Or $p0Type <> $GC_I_MAP_TYPE_OUTPOST Then
        Out("[M02] Viajando a Jokanur Diggings (" & $M2J_OUTPOST_MAP_ID & ")...")
        If Not Travel_ToOutpost($M2J_OUTPOST_MAP_ID) Then
            Out("[M02] FAIL: Travel_ToOutpost devolvio False")
            Return False
        EndIf
        Local $tTravel = TimerInit()
        While Not Bot_ShouldStop() And TimerDiff($tTravel) < 20000
            If Map_GetMapID() = $M2J_OUTPOST_MAP_ID And Map_GetInstanceInfo("Type") = $GC_I_MAP_TYPE_OUTPOST Then
                Out("[M02] OK: en Jokanur outpost tras " & Round(TimerDiff($tTravel)/1000, 1) & "s")
                ExitLoop
            EndIf
            Sleep(500)
        WEnd
        If Map_GetMapID() <> $M2J_OUTPOST_MAP_ID Or Map_GetInstanceInfo("Type") <> $GC_I_MAP_TYPE_OUTPOST Then
            Out("[M02] FAIL: no se llego a Jokanur outpost tras 20s")
            Return False
        EndIf
    Else
        Out("[M02] Ya en Jokanur outpost, skip travel")
    EndIf
    If Map_GetInstanceInfo("Type") = $GC_I_MAP_TYPE_OUTPOST Then
        Out("[M02] Char -> LoadSkillTemplate (build coop, " & $M2J_CHAR_TEMPLATE & ")")
        Attribute_LoadSkillTemplate($M2J_CHAR_TEMPLATE)
        Sleep(800)
        Out("[M02] Subiendo puntos de atributo del char antes de montar equipo")
        $g_iAutoLevelCharLastUnused = -1
        _AutoLevel_ProcessChar()
    EndIf
    If _AutoLevel_FindHeroSlot($M2J_KOSS_HERO_ID) > 0 Then
        Out("[M02] Kick Koss (HeroID=" & $M2J_KOSS_HERO_ID & ")")
        Party_KickHero($M2J_KOSS_HERO_ID)
        Sleep(1000)
        If _AutoLevel_FindHeroSlot($M2J_KOSS_HERO_ID) > 0 Then
            Out("[M02] Koss sigue en party - segundo intento")
            Party_KickHero($M2J_KOSS_HERO_ID)
            Sleep(1000)
        EndIf
    Else
        Out("[M02] Koss no en party - skip kick")
    EndIf
    If Not _AutoParty_IsHenchModelInParty($M2J_KIHM_MODEL) Then
        Local $kihmAg = Agent_GetAgentByPlayerNumber($M2J_KIHM_MODEL)
        If $kihmAg <> 0 Then
            Out("[M02] Party_AddNpc Kihm model=" & $M2J_KIHM_MODEL & " agent=" & $kihmAg)
            Party_AddNpc($kihmAg)
            Sleep(800)
        Else
            Out("[M02] WARN: Kihm model=" & $M2J_KIHM_MODEL & " no encontrado en outpost 491")
        EndIf
    Else
        Out("[M02] Kihm ya en party - skip add")
    EndIf
    If _AutoLevel_FindHeroSlot(9) = 0 Then
        Out("[M02] Melonni (9) no esta -> echar henchman no-monje (Herta) para hacer hueco")
        _AutoParty_KickNonMonkHenchman($M2J_KIHM_MODEL)
        Sleep(1000)
    EndIf
    Local $aM2Heroes[2] = [7, 9]
    For $hh = 0 To UBound($aM2Heroes) - 1
        If _AutoLevel_FindHeroSlot($aM2Heroes[$hh]) = 0 Then
            Out("[M02] Falta heroe ID=" & $aM2Heroes[$hh] & " -> Party_AddHero")
            Party_AddHero($aM2Heroes[$hh])
            Sleep(1000)
            If _AutoLevel_FindHeroSlot($aM2Heroes[$hh]) = 0 Then
                Out("[M02] heroe ID=" & $aM2Heroes[$hh] & " no entro - 2o intento")
                Party_AddHero($aM2Heroes[$hh])
                Sleep(1000)
            EndIf
        Else
            Out("[M02] Heroe ID=" & $aM2Heroes[$hh] & " ya en party")
        EndIf
    Next
    Local $m2GateOK = False
    For $m2Try = 1 To 3
        Local $kossIn = (_AutoLevel_FindHeroSlot($M2J_KOSS_HERO_ID) > 0)
        Local $melIn = (_AutoLevel_FindHeroSlot(9) > 0)
        If Not $kossIn And $melIn Then
            $m2GateOK = True
            ExitLoop
        EndIf
        Out("[M02] GATE equipo: Koss_dentro=" & $kossIn & " Melonni_dentro=" & $melIn & " (intento " & $m2Try & "/3) -> corregir")
        If $kossIn Then
            Party_KickHero($M2J_KOSS_HERO_ID)
            Sleep(1200)
        EndIf
        If Not $melIn Then
            _AutoParty_KickNonMonkHenchman($M2J_KIHM_MODEL)   
            Sleep(800)
            Party_AddHero(9)
            Sleep(1500)
        EndIf
    Next
    If Not $m2GateOK Then
        Out("[M02] ðŸ”´ GATE equipo FALLIDO (Koss fuera + Melonni dentro NO conseguido) -> NO SE ENTRA a la misiÃ³n (reintento de fase)")
        Return False
    EndIf
    Out("[M02] GATE equipo OK: Koss FUERA + Melonni DENTRO -> se puede empezar la coop")
    Out("[M02] Party_FillWithHenchmen para completar a 8/8")
    Party_FillWithHenchmen()
    Sleep(1000)
    If Map_GetInstanceInfo("Type") = $GC_I_MAP_TYPE_OUTPOST Then
        Local Const $M2J_CRIT_SKILLS[3] = [1763, 1816, 1490]   
        Local $m2jMissingSkills = ""
        For $cs = 0 To UBound($M2J_CRIT_SKILLS) - 1
            If Not World_IsSkillLearnt($M2J_CRIT_SKILLS[$cs]) Then
                If $m2jMissingSkills <> "" Then $m2jMissingSkills &= ","
                $m2jMissingSkills &= $M2J_CRIT_SKILLS[$cs]
                Out("[M02] Skill " & $M2J_CRIT_SKILLS[$cs] & " aprendida: NO -> pendiente de recompra")
            Else
                Out("[M02] Skill " & $M2J_CRIT_SKILLS[$cs] & " aprendida: SI")
            EndIf
        Next
        If $m2jMissingSkills <> "" Then
            Out("[M02] Faltan skills criticas (" & $m2jMissingSkills & ") -> viajar a Kamadan para recomprar")
            If Not _M2J_BuyMissingSkills($m2jMissingSkills) Then
                Out("[M02] ðŸ”´ WARN: recompra de skills fallida - las builds podrian cargar con slots vacios")
            EndIf
        EndIf
        Local $tUIReady = TimerInit()
        While TimerDiff($tUIReady) < 8000
            If Not Map_GetInstanceInfo("IsLoading") And Map_GetMapID() = $M2J_OUTPOST_MAP_ID Then ExitLoop
            Sleep(300)
        WEnd
        Sleep(1500)
        Out("[M02] Char -> LoadSkillTemplate (build coop, " & $M2J_CHAR_TEMPLATE & ")")
        For $ct = 1 To 3
            Attribute_LoadSkillTemplate($M2J_CHAR_TEMPLATE)
            Sleep(1800)
            If $ct < 3 Then Out("[M02] Char LoadSkillTemplate retry " & $ct & "/3")
        Next
        Local $dunSlotB = _AutoLevel_FindHeroSlot(7)
        If $dunSlotB > 0 Then
            Out("[M02] Dunkoro slot " & $dunSlotB & " -> LoadSkillTemplate (" & $DUNKORO_TEMPLATE & ")")
            Attribute_LoadSkillTemplate($DUNKORO_TEMPLATE, $dunSlotB)
            Sleep(500)
        EndIf
        Local $melSlotB = _AutoLevel_FindHeroSlot(9)
        If $melSlotB > 0 Then
            Out("[M02] Melonni slot " & $melSlotB & " -> LoadSkillTemplate (" & $MELONNI_TEMPLATE & ")")
            Attribute_LoadSkillTemplate($MELONNI_TEMPLATE, $melSlotB)
            Sleep(500)
            Ui_SetHeroBehavior($melSlotB, 1)
            Out("[M02] Melonni slot " & $melSlotB & " -> Ui_SetHeroBehavior(1) modo defensivo (Guard)")
        EndIf
    EndIf
    $g_GE_NeedsWalkback = False
    $g_GE_WalkbackStarted = False
    $g_GE_LastCharIsDead = False
    $g_GE_RescueEnabled = False
    If Not _M2J_EnterMission() Then
        $g_GE_RescueEnabled = True
        Return False
    EndIf
    Out("[M02] Esperando que el char este cargado en instance...")
    Local $tLoad = TimerInit()
    While Not Bot_ShouldStop() And TimerDiff($tLoad) < 20000
        Local $mhp = Agent_GetAgentInfo(-2, "MaxHP")
        Local $mx  = Agent_GetAgentInfo(-2, "X")
        Local $my  = Agent_GetAgentInfo(-2, "Y")
        If $mhp > 0 And ($mx <> 0 Or $my <> 0) And Not Map_GetInstanceInfo("IsLoading") Then
            Out("[M02] Char cargado tras " & Round(TimerDiff($tLoad)/1000, 1) & "s")
            ExitLoop
        EndIf
        Sleep(500)
    WEnd
    If Agent_GetAgentInfo(-2, "MaxHP") = 0 Then
        Out("[M02] FAIL: char no cargado tras 20s")
        $g_GE_RescueEnabled = True
        Return False
    EndIf
    Sleep(3000)
    Other_WaitPingStabilized(2000)
    Cache_SkillBar()
    Local $m2ZealousInBar = False
    For $m2sb = 1 To 8
        If Skill_GetSkillbarInfo($m2sb, "SkillID") = $GC_I_SKILL_ID_ZEALOUS_RENEWAL Then $m2ZealousInBar = True
    Next
    Out("[M02] Barra char: Zealous Renewal (1763) " & ($m2ZealousInBar ? "PRESENTE" : "FALTA -> build del char no cargo"))
    _M2J_UseConsets()
    Pathfinder_SetPathUpdateInterval(2000)
    Out("[M02] Pathfinder inicializado (interval=2000ms)")
    Out("[M02] Esperando desbloqueo de movimiento...")
    Local $tUnlock = TimerInit()
    Local $refY = Agent_GetAgentInfo(-2, "Y")
    Local $refX = Agent_GetAgentInfo(-2, "X")
    While Not Bot_ShouldStop() And TimerDiff($tUnlock) < 25000
        Map_Move($refX, $refY + 150)
        Sleep(600)
        If Abs(Agent_GetAgentInfo(-2, "Y") - $refY) > 50 Then ExitLoop
    WEnd
    Out("[M02] Movimiento OK tras " & Round(TimerDiff($tUnlock)/1000, 1) & "s")
    Out("[M02] Pre-nav: spawn -> primer grupo (pass-through)")
    If Not _M2J_PassThroughNav(17932, 11868, 15237, 13920, 600, 25000) Then Return False
    If Not _M2J_PassThroughNav(16412, 13020, 15237, 13920, 600, 20000) Then Return False
    If Not _M2J_PassThroughNav(14653, 13463, 15237, 13920, 600, 20000) Then Return False
    If Not _M2J_PassThroughNav(13921, 13337, 15237, 13920, 600, 20000) Then Return False
    If Not _M2J_PassThroughNav(13230, 13230, 15237, 13920, 600, 20000) Then Return False
    Out("[M02] Paso 1 (15237, 13920)")
    If Not _M2J_NavTo(15237, 13920, 600, 25000) Then Return False
    Combat_ClearZone(1250, 60000)
    Out("[M02] Paso 2 (10858, 12927)")
    If Not _M2J_NavTo(10858, 12927, 600, 25000) Then Return False
    Combat_ClearZone(1250, 60000)
    Out("[M02] Paso 3")
    If Not _M2J_DoNavOnly(10831, 17023) Then Return False
    Out("[M02] Paso 4")
    If Not _M2J_DoNavCombat(7827, 18911) Then Return False
    Out("[M02] Paso 5")
    If Not _M2J_DoNavCombat(6390, 15779) Then Return False
    Out("[M02] Paso 6")
    If Not _M2J_DoNavCombat(2207, 16371) Then Return False
    Out("[M02] Paso 7 -> NPC 5596 (13, 14184)")
    If Not _M2J_DoNavOnly(13, 14184) Then Return False
    Local $npc5596 = Agent_GetAgentByPlayerNumber(5596)
    If $npc5596 = 0 Then
        Out("[M02] FAIL NPC 5596 no encontrado")
        Return False
    EndIf
    For $try = 1 To 3
        Out("[M02] NPC 5596 intento " & $try & "/3")
        Agent_GoNPC($npc5596)
        Sleep(1500)
        Bot_Dialog(0x84)
        Sleep(5000)
    Next
    Out("[M02] Paso 8 -> cruzar campana (-3914, 14544)")
    $g_bMarkCallbackDisabled = True
    $g_iLastMarkedEnemy = 0
    _M2J_NavTo(-3914, 14544, 250, 30000)
    Sleep(1500)   
    Out("[M02] Paso 8 pre -> ClearZone inmediata (1300u) antes de Darekh")
    Combat_ClearZone(1250, 60000)
    _M2J_WaitPartyAlive(15000)
    Local $darekhDeadX = 0
    Local $darekhDeadY = 0
    If _M2J_RescanTablet(999999) <> 0 Then
        Out("[M02] Tablet ya en suelo tras ClearZone: Darekh confirmado muerto -> skip persecucion 5596 ENTERA")
    Else
    Local $darekh = _M2J_FindNearestFoe(10000, 5596)
    If $darekh = 0 Then
        Out("[M02] Darekh (5596) no en 10000u, navegando hacia zona sur (-5000, 12000)")
        _M2J_NavTo(-5000, 12000, 1500, 20000)
        Sleep(2000)
        $darekh = _M2J_FindNearestFoe(10000, 5596)
    EndIf
    If $darekh = 0 Then
        Out("[M02] Darekh (5596) no en 10000u, navegando mas al sur (-4500, 10500)")
        _M2J_NavTo(-4500, 10500, 1500, 20000)
        Sleep(2000)
        $darekh = _M2J_FindNearestFoe(10000, 5596)
    EndIf
    If $darekh = 0 Then
        Out("[M02] WARN: Darekh (5596) no encontrado, fallback a cualquier FOE")
        $darekh = _M2J_FindNearestFoe()
    EndIf
    If $darekh <> 0 Then
        Local $darekhModel = Agent_GetAgentInfo($darekh, "PlayerNumber")
        Out("[M02] Paso 8a -> Darekh target=" & $darekh & " Model=" & $darekhModel)
        Local $dkX0 = Agent_GetAgentInfo($darekh, "X")
        Local $dkY0 = Agent_GetAgentInfo($darekh, "Y")
        _M2J_NavTo($dkX0, $dkY0, 800, 20000)
        Sleep(1000)
        _M2J_FocusFireUntilDead($darekh, 90000, $darekhDeadX, $darekhDeadY)
    Else
        Out("[M02] WARN: no se detecto FOE post-campana, fallback pos huida")
        $darekhDeadX = -5290
        $darekhDeadY = 11255
    EndIf
    EndIf
    $g_bMarkCallbackDisabled = False
    $g_iLastMarkedEnemy = 0
    Out("[M02] Paso 8b -> espera estabilizacion party (resurrecciones post-Darekh)")
    _M2J_WaitPartyAlive(12000)
    Out("[M02] Paso 8c -> ClearZone inmediata (1500u) post-Darekh")
    Combat_ClearZone(1250, 30000)
    Out("[M02] Paso 8d -> verificando muerte Darekh (scan tablet + buscar 5596)")
    If _M2J_RescanTablet(999999) <> 0 Then
        Out("[M02] Tablet en suelo: Darekh confirmado muerto (skip persecucion 5596)")
    Else
        Local $darekhStillAlive = _M2J_FindNearestFoe(25000, 5596)
        If $darekhStillAlive <> 0 Then
            Local $dkX = Agent_GetAgentInfo($darekhStillAlive, "X")
            Local $dkY = Agent_GetAgentInfo($darekhStillAlive, "Y")
            Local $dkDist = Sqrt($dkX^2 + $dkY^2)
            Out("[M02] Darekh (5596) SIGUE VIVO! pos=(" & Round($dkX) & "," & Round($dkY) & ") dist=" & Round(Agent_GetDistance(-2, $darekhStillAlive)) & "u")
            _M2J_NavTo($dkX, $dkY, 800, 20000)
            Sleep(1000)
            _M2J_FocusFireUntilDead($darekhStillAlive, 90000, $darekhDeadX, $darekhDeadY)
            _M2J_WaitPartyAlive(12000)
            Combat_ClearZone(1250, 30000)
        Else
            Out("[M02] No hay 5596 -> buscando cualquier FOE superviviente")
            Local $survivor = _M2J_FindNearestFoe(20000)
            If $survivor <> 0 Then
                Local $sModel = Agent_GetAgentInfo($survivor, "PlayerNumber")
                Out("[M02] FOE superviviente model=" & $sModel & " -> matando")
                Local $dummyX = 0, $dummyY = 0
                _M2J_FocusFireUntilDead($survivor, 120000, $dummyX, $dummyY)
                _M2J_WaitPartyAlive(12000)
                Combat_ClearZone(1250, 30000)
            Else
                Out("[M02] No hay FOE en 20000u - Darekh quizas fuera de rango, continuando")
            EndIf
        EndIf
    EndIf
    Out("[M02] Paso 9 -> recoger Stone Tablet (scan mapa completo)")
    _M2J_DisableRescue()
    Sleep(800)
    Local $tabletOk = False
    For $intento = 1 To 5
        Out("[M02] Tablet intento " & $intento & "/5")
        If _M2J_ScanAndPickupTablet(999999) Then
            $tabletOk = True
            ExitLoop
        EndIf
        If $darekhDeadX <> 0 And $darekhDeadY <> 0 Then
            Out("[M02] Tablet intento " & $intento & " fallo -> navegando al punto de muerte de Darekh (" & Round($darekhDeadX) & "," & Round($darekhDeadY) & ") para re-scan")
            _M2J_NavTo($darekhDeadX, $darekhDeadY, 800, 30000)
            Sleep(1500)
        EndIf
        _M2J_DisableRescue()
        Combat_ClearZone(1250, 30000)   
        Sleep(1000)
    Next
    If Not $tabletOk Or Not _M2J_HasTabletBundle() Then
        Out("[M02] FAIL: no se pudo recoger Stone Tablet tras 5 intentos")
        $g_GE_RescueEnabled = True
        Return False
    EndIf
    Out("[M02] OK: bundle Stone Tablet activo (BundleModelID=17055)")
    Out("[M02] Paso 8e -> limpieza TOTAL enemigos en aggro tras el pickup (Darekh ya caido)")
    _M2J_DisableRescue()
    Local $cleanT = TimerInit(), $cleanTries = 0
    While Not Bot_ShouldStop() And TimerDiff($cleanT) < 90000
        If GetNearestEnemy(1500) = 0 Then ExitLoop
        $cleanTries += 1
        Out("[M02] Paso 8e: enemigos vivos en aggro, limpio (iter " & $cleanTries & ")")
        Combat_ClearZone(1250, 30000)
        _M2J_WaitPartyAlive(12000)
        If Agent_GetAgentInfo(-2, "IsDead") Then ExitLoop
    WEnd
    Out("[M02] Paso 8e: zona limpia en aggro (" & $cleanTries & " iteraciones de limpieza)")
    _M2J_DisableRescue()
    Out("[M02] Paso 10 -> Stone Pedestal (-5934, 11249) NAV SOLO CON BUNDLE")
    If Not _Mission_DoNavOnly(-5934, 11249) Then Return False
    If Not _M2J_PlaceTabletAtAltar(-5934, 11249, 300) Then
        Out("[M02] FAIL: no se pudo colocar la tablet en el primer pedestal")
        $g_GE_RescueEnabled = True
        Return False
    EndIf
    Sleep(1000)
    Out("[M02] Paso 11 -> segunda Stone Tablet (-9684, 11108)")
    If Not _Mission_DoNavCombat(-9684, 11108) Then Return False
    _M2J_DisableRescue()
    Sleep(800)
    Out("[M02] Paso 11b -> limpieza TOTAL enemigos en aggro antes del pickup de 2Âª tablet")
    Local $cleanT2 = TimerInit(), $cleanTries2 = 0
    While Not Bot_ShouldStop() And TimerDiff($cleanT2) < 90000
        If GetNearestEnemy(1500) = 0 Then ExitLoop
        $cleanTries2 += 1
        Out("[M02] Paso 11b: enemigos vivos en aggro, limpio (iter " & $cleanTries2 & ")")
        Combat_ClearZone(1250, 30000)
        _M2J_WaitPartyAlive(12000)
        If Agent_GetAgentInfo(-2, "IsDead") Then ExitLoop
    WEnd
    Out("[M02] Paso 11b: zona limpia en aggro (" & $cleanTries2 & " iteraciones de limpieza)")
    Local $tabletPicked = False
    For $intento = 1 To 5
        Out("[M02] Paso 11: scan tablilla 2 intento " & $intento & "/5")
        If _M2J_ScanAndPickupTablet(999999) Then
            $tabletPicked = True
            ExitLoop
        EndIf
        Combat_ClearZone(1250, 15000)
        Sleep(500)
    Next
    If Not $tabletPicked Then Out("[M02] WARN: Stone Tablet 2 no recogida tras 5 intentos")
    Out("[M02] Paso 12 -> zona combate (-9764, 9223) con bundle")
    For $try12 = 1 To 5
        If Not _M2J_HasTabletBundle() Then
            Out("[M02] Tablet no en inventario, volviendo a recogerla (-9684, 11108)")
            _M2J_DoNavOnly(-9684, 11108)
            _M2J_ScanAndPickupTablet(999999)
        EndIf
        If Not _M2J_DoNavCombat(-9764, 9223) Then Return False
        If Not $g_GE_LastCharIsDead Then ExitLoop
        Out("[M02] Muerte detectada, reintento " & $try12 & "/5")
        Sleep(2000)
    Next
    If Not _M2J_HasTabletBundle() Then
        Out("[M02] Paso 12b -> escaneando tablet post-combate...")
        _M2J_ScanAndPickupTablet(999999)
    EndIf
    Out("[M02] Paso 13 -> dropear tablilla 2 al suelo (-11497, 6953)")
    _M2J_DisableRescue()
    If Not _Mission_DoNavOnly(-11497, 6953) Then Return False
    If Not _M2J_DropBundle() Then
        Out("[M02] WARN: drop tablilla 2 fallo, forzando g_bHasBundle=False")
        $g_bHasBundle = False
    EndIf
    Sleep(500)
    Out("[M02] Paso 14")
    If Not _M2J_DoNavCombat(-12281, 9119) Then Return False
    Out("[M02] Paso 15")
    If Not _M2J_DoNavCombat(-13194, 11388) Then Return False
    Out("[M02] Paso 16 -> nav+combate tercera Stone Tablet (-12636, 14091)")
    If Not _Mission_DoNavCombat(-12636, 14091) Then Return False
    _M2J_DisableRescue()
    Sleep(800)
    Combat_ClearZone(1250, 60000)
    _M2J_WaitPartyAlive(12000)
    Out("[M02] Paso 16b -> limpieza TOTAL enemigos en aggro antes del pickup de 3Âª tablet")
    Local $cleanT3 = TimerInit(), $cleanTries3 = 0
    While Not Bot_ShouldStop() And TimerDiff($cleanT3) < 90000
        If GetNearestEnemy(1500) = 0 Then ExitLoop
        $cleanTries3 += 1
        Out("[M02] Paso 16b: enemigos vivos en aggro, limpio (iter " & $cleanTries3 & ")")
        Combat_ClearZone(1250, 30000)
        _M2J_WaitPartyAlive(12000)
        If Agent_GetAgentInfo(-2, "IsDead") Then ExitLoop
    WEnd
    Out("[M02] Paso 16b: zona limpia en aggro (" & $cleanTries3 & " iteraciones de limpieza)")
    Out("[M02] Paso 17 -> pickup tercera Stone Tablet")
    Local $tabletOk3 = False
    For $intento3 = 1 To 5
        Out("[M02] Paso 17: scan tablilla 3 intento " & $intento3 & "/5")
        If _M2J_ScanAndPickupTablet(999999) Then
            $tabletOk3 = True
            ExitLoop
        EndIf
        _M2J_DisableRescue()
        Combat_ClearZone(1250, 20000)   
        Sleep(500)
    Next
    If Not $tabletOk3 Then Out("[M02] WARN: Stone Tablet 3 no recogida tras 5 intentos")
    Out("[M02] Paso 18 -> ClearZone inmediata (1300u) post-tercera tablilla")
    Combat_ClearZone(1250, 10000)
    _M2J_WaitPartyAlive(10000)
    Out("[M02] Paso 19 -> pedestal tablilla 3 (-11928, 6532)")
    _M2J_DisableRescue()
    If Not _Mission_DoNavOnly(-11928, 6532) Then Return False
    Out("[M02] Paso 19b -> colocar tablilla 3 en pedestal (-11928, 6532)")
    If _M2J_HasTabletBundle() Then
        If Not _M2J_DeliverTablet(-11928, 6532, 800) Then
            Out("[M02] WARN: colocar tablilla 3 fallo")
        EndIf
    Else
        Out("[M02] WARN: tablilla 3 no en mano en Paso 19b")
    EndIf
    Sleep(1000)
    Out("[M02] Paso 20 -> recoger tablilla 2 del suelo (~-11497, 6953)")
    Local $tabletFloor = False
    For $intento2b = 1 To 5
        Out("[M02] Paso 20: intento " & $intento2b & "/5")
        If _M2J_ScanAndPickupTablet(999999) Then
            $tabletFloor = True
            ExitLoop
        EndIf
        Sleep(1000)
    Next
    If Not $tabletFloor Then Out("[M02] WARN: tablilla 2 no recogida del suelo")
    Out("[M02] Paso 21 -> pedestal tablilla 2 (-11483, 6534)")
    _M2J_DisableRescue()
    If Not _Mission_DoNavOnly(-11483, 6534) Then Return False
    If _M2J_HasTabletBundle() Then
        If Not _M2J_DeliverTablet(-11483, 6534, 800) Then
            Out("[M02] WARN: colocar tablilla 2 en pedestal fallo")
        EndIf
    Else
        Out("[M02] WARN: tablilla 2 no en mano en Paso 21")
    EndIf
    Sleep(1000)
    $g_GE_RescueEnabled = True
    Out("[M02] Paso 22 -> nav hacia Kahdash")
    If Not _M2J_DoNavCombat(-11709, 5164) Then Return False
    If Not _M2J_DoNavCombat(-11718, 3642) Then Return False
    If Not _M2J_DoNavCombat(-10288, 3433) Then Return False
    Out("[M02] Paso 23 -> buscar Kahdash (model 5597)")
    Local $kahdash = 0
    For $kTry = 1 To 10
        $kahdash = Agent_GetAgentByPlayerNumber(5597)
        If $kahdash <> 0 Then ExitLoop
        Out("[M02] Kahdash no visible, espera " & $kTry & "/10...")
        Sleep(1000)
    Next
    If $kahdash <> 0 Then
        Local $kX = Agent_GetAgentInfo($kahdash, "X")
        Local $kY = Agent_GetAgentInfo($kahdash, "Y")
        Out("[M02] Kahdash en (" & Round($kX) & "," & Round($kY) & ") -> nav a su pos + GoNPC")
        _M2J_NavTo($kX, $kY, 300, 15000)
        Sleep(500)
        For $kDialog = 1 To 3
            Agent_GoNPC($kahdash)
            Sleep(2500)
        Next
    Else
        Out("[M02] WARN: Kahdash model=5597 no encontrado tras 10s, continuando")
    EndIf
    Sleep(1000)
    Out("[M02] Paso 24 -> grupo 1 (-11284, 633) model 5592")
    If Not _M2J_DoNavCombat(-11284, 633) Then Return False
    Out("[M02] Paso 25 -> grupo 2 (-13582, -1400) model 5593")
    If Not _M2J_DoNavCombat(-13582, -1400) Then Return False
    Out("[M02] Paso 26 -> grupo 3 (-11251, -1906) model 5592")
    If Not _M2J_DoNavCombat(-11251, -1906) Then Return False
    Out("[M02] Paso 27 ESCOLTA Kahdash NPC=5597 hasta la puerta (max 240s)")
    $g_GE_RescueEnabled = False
    $g_GE_NeedsWalkback = False
    $g_GE_WalkbackStarted = False
    Local $KAHDASH_FINAL_X = -10489
    Local $KAHDASH_FINAL_Y = -1893
    Local $tEscort = TimerInit()
    Local $cineOk = False
    Local $tLastLog = 0
    Local $tKahdashAtFinal = 0
    While Not Bot_ShouldStop() And TimerDiff($tEscort) < 200000
        If Cinematic_WaitCinematic(1500, 3, True, 1) Then
            $cineOk = True
            ExitLoop
        EndIf
        Local $kAg = Agent_GetAgentByPlayerNumber(5597)
        If $kAg = 0 Then
            Out("[M02] Paso 27 Kahdash NPC=0 (cruzo puerta o murio) -> continuar")
            ExitLoop
        EndIf
        Local $kX = Agent_GetAgentInfo($kAg, "X")
        Local $kY = Agent_GetAgentInfo($kAg, "Y")
        Local $kHP = Agent_GetAgentInfo($kAg, "HP")
        Local $mX = Agent_GetAgentInfo(-2, "X")
        Local $mY = Agent_GetAgentInfo(-2, "Y")
        Local $d = Sqrt(($kX - $mX)^2 + ($kY - $mY)^2)
        Local $dFinal = Sqrt(($kX - $KAHDASH_FINAL_X)^2 + ($kY - $KAHDASH_FINAL_Y)^2)
        If $dFinal < 300 Then
            If $tKahdashAtFinal = 0 Then $tKahdashAtFinal = TimerInit()
            If TimerDiff($tKahdashAtFinal) > 30000 Then
                Out("[M02] Paso 27 Kahdash en pedestal FINAL 30s -> avanzar a Paso 28")
                ExitLoop
            EndIf
        Else
            $tKahdashAtFinal = 0
        EndIf
        If TimerDiff($tEscort) - $tLastLog > 10000 Then
            Out("[M02] Paso 27 Kahdash pos=(" & Round($kX) & "," & Round($kY) & ") HP=" & Round($kHP*100) & "% dist=" & Round($d) & "u dFinal=" & Round($dFinal) & "u")
            $tLastLog = TimerDiff($tEscort)
        EndIf
        If $d > 700 And $dFinal > 600 Then Map_Move($kX, $kY)
        Local $foeNear = _M2J_FindNearestFoe(1500)
        If $foeNear <> 0 Then
            Combat_ClearZone(1250, 6000)
        Else
            Sleep(600)
        EndIf
    WEnd
    $g_GE_RescueEnabled = True
    Out("[M02] Paso 27 fin: cinematica=" & $cineOk & " elapsed=" & Round(TimerDiff($tEscort)/1000,1) & "s")
    Agent_CancelAction()
    Sleep(500)
    Out("[M02] Paso 27 post -> forzar salida del pedestal hacia (-8137,-1480)")
    Map_Move(-8137, -1480)
    Sleep(1500)
    Out("[M02] Paso 28 -> grupo 1 (-8137, -1480) model 5593")
    If Not _M2J_DoNavCombat(-8137, -1480) Then Out("[M02] Paso 28 WARN nav fail")
    Combat_ClearZone(1250, 45000)
    Out("[M02] Paso 29 -> grupo 2 (-6650, -3624) model 5592")
    If Not _M2J_DoNavCombat(-6650, -3624) Then Out("[M02] Paso 29 WARN nav fail")
    Combat_ClearZone(1250, 45000)
    Out("[M02] Paso 30 -> grupo 3 (-5362, -2396) model 5593")
    If Not _M2J_DoNavCombat(-5362, -2396) Then Out("[M02] Paso 30 WARN nav fail")
    Combat_ClearZone(1250, 45000)
    Out("[M02] Paso 31 -> grupo 4 (-3814, -1930) model 5593")
    If Not _M2J_DoNavCombat(-3814, -1930) Then Out("[M02] Paso 31 WARN nav fail")
    Combat_ClearZone(1250, 45000)
    Out("[M02] Paso 32 -> boss final (-3039, -1701) model 4386")
    $g_bMarkCallbackDisabled = True
    $g_iLastMarkedEnemy = 0
    If Not _M2J_DoNavCombat(-3039, -1701) Then Return False
    Sleep(1000)
    Out("[M02] Paso 32 pre-boss -> ClearZone inmediata (1300u) antes del jefe")
    Combat_ClearZone(1250, 60000)
    _M2J_WaitPartyAlive(15000)
    Local $bossDeadX = 0, $bossDeadY = 0
    Local $boss = Agent_GetAgentByPlayerNumber(4386)
    If $boss = 0 Then
        Out("[M02] Boss model=4386 no encontrado, buscando FOE cercano")
        $boss = _M2J_FindNearestFoe(3000)
    EndIf
    If $boss <> 0 Then
        Local $bossModel = Agent_GetAgentInfo($boss, "PlayerNumber")
        Out("[M02] Paso 32a -> boss target=" & $boss & " model=" & $bossModel)
        $g_M02_BossDead = _M2J_FocusFireUntilDead($boss, 120000, $bossDeadX, $bossDeadY)
        If Not $g_M02_BossDead Then
            Out("[M02] WARN: FocusFire boss final devolvio False (wipe/timeout) - boss NO confirmado muerto")
        EndIf
        _M2J_WaitPartyAlive(12000)
        Combat_ClearZone(1250, 30000)
    Else
        Out("[M02] WARN: boss no encontrado en 3000u, ClearZone inmediata (1800u)")
        Combat_ClearZone(1250, 60000)
    EndIf
    $g_bMarkCallbackDisabled = False
    $g_iLastMarkedEnemy = 0
    Out("[M02] Paso 33 -> verificar fin REAL de coop (Kamadan 449) o cinematica final")
    Local $p33Map  = Map_GetMapID()
    Local $p33Type = Map_GetInstanceInfo("Type")
    If $p33Map = $GC_I_MAP_ID_KAMADAN_JEWEL_OF_ISTAN And $p33Type = $GC_I_MAP_TYPE_OUTPOST Then
        Out("[M02] Party en Kamadan (" & $p33Map & ") tras matar al Apocrypha -> coop COMPLETADA")
        $g_GE_RescueEnabled = True
        Return True
    EndIf
    If $p33Map = $M2J_OUTPOST_MAP_ID And $p33Type = $GC_I_MAP_TYPE_OUTPOST Then
        If $g_M02_BossDead Then
            Out("[M02] Party en outpost Jokanur (" & $p33Map & ") + boss 4386 confirmado muerto -> coop COMPLETADA")
            $g_GE_RescueEnabled = True
            Return True
        EndIf
        Out("[M02] En outpost Jokanur (" & $p33Map & ") PERO boss 4386 NO confirmado muerto -> wipe (no acabo la coop) -> reintento")
        $g_GE_RescueEnabled = True
        Return False
    EndIf
    Local $cineOk = Cinematic_WaitCinematic(30000, 5, True, 1)
    Local $p33Map2  = Map_GetMapID()
    Local $p33Type2 = Map_GetInstanceInfo("Type")
    If $p33Map2 = $GC_I_MAP_ID_KAMADAN_JEWEL_OF_ISTAN And $p33Type2 = $GC_I_MAP_TYPE_OUTPOST Then
        Out("[M02] Party en Kamadan (" & $p33Map2 & ") tras espera cinematica -> coop COMPLETADA")
        $g_GE_RescueEnabled = True
        Return True
    EndIf
    If $p33Map2 = $M2J_OUTPOST_MAP_ID And $p33Type2 = $GC_I_MAP_TYPE_OUTPOST Then
        If $g_M02_BossDead Then
            Out("[M02] Party en outpost Jokanur (" & $p33Map2 & ") tras espera cinematica + boss confirmado -> coop COMPLETADA")
            $g_GE_RescueEnabled = True
            Return True
        EndIf
        Out("[M02] En outpost Jokanur (" & $p33Map2 & ") tras espera sin boss confirmado -> wipe (no acabo la coop) -> reintento")
        $g_GE_RescueEnabled = True
        Return False
    EndIf
    If Not $cineOk Then
        Out("[M02] Sin cinematica final y party no en Kamadan (map=" & $p33Map2 & " type=" & $p33Type2 & ") -> mision NO completada -> return-to-outpost + reintentar")
        $g_GE_RescueEnabled = True
        Return False
    EndIf
    $g_GE_RescueEnabled = True
    Out("[M02] Mision completada (cinematica final del Apocrypha skipeada)")
    Return True
EndFunc
Func _M2J_EnterMission()
    If Map_GetMapID() <> $M2J_OUTPOST_MAP_ID Or Map_GetInstanceInfo("Type") <> $GC_I_MAP_TYPE_OUTPOST Then
        Out("[M02] EnterMission: no en outpost Jokanur (map=" & Map_GetMapID() & " type=" & Map_GetInstanceInfo("Type") & ") -> Travel")
        If Not Travel_ToOutpost($M2J_OUTPOST_MAP_ID) Then
            Out("[M02] FAIL travel a Jokanur")
            Return False
        EndIf
        Sleep(2000)
    EndIf
    If Not _M2J_RestorePartyAfterTravel() Then
        Out("[M02] WARN: equipo no restaurado al 100% antes de entrar (se intentara igual)")
    EndIf
    Out("[M02] Nav a NPC 4763")
    If Not _Quests_NavAndOpenDialog($M2J_NPC_X, $M2J_NPC_Y, $M2J_NPC_MODEL) Then
        Out("[M02] FAIL nav/dialog NPC 4763")
        Return False
    EndIf
    Local $m2npc = _Quests_FindNearestNPCByModelToWp($M2J_NPC_MODEL, $M2J_NPC_X, $M2J_NPC_Y)
    If $m2npc = 0 Then
        Out("[M02] FAIL - NPC 4763 no cargado para dialog de entrada")
        Return False
    EndIf
    Out("[M02] Dialog 0x81 (target NPC=" & $m2npc & ")")
    Agent_ChangeTarget($m2npc)
    Sleep(500)
    Bot_Dialog($M2J_DIALOG_HELP)
    Sleep(2000)
    $m2npc = _Quests_FindNearestNPCByModelToWp($M2J_NPC_MODEL, $M2J_NPC_X, $M2J_NPC_Y)
    Out("[M02] Dialog 0x84 -> We are ready (re-target NPC=" & $m2npc & ")")
    If $m2npc <> 0 Then
        Agent_ChangeTarget($m2npc)
        Sleep(500)
    EndIf
    Bot_Dialog($M2J_DIALOG_READY)
    Sleep(1000)
    Out("[M02] Esperando carga de instancia...")
    Local $t = TimerInit()
    Local $bEnteredLoad = False
    While Not Bot_ShouldStop() And TimerDiff($t) < 60000
        If Map_GetInstanceInfo("IsLoading") Then $bEnteredLoad = True
        If $bEnteredLoad And Not Map_GetInstanceInfo("IsLoading") Then ExitLoop
        If Map_GetInstanceInfo("Type") <> $GC_I_MAP_TYPE_OUTPOST Then ExitLoop
        Sleep(300)
    WEnd
    WaitLoading()
    Sleep(2000)
    If Map_GetInstanceInfo("Type") = $GC_I_MAP_TYPE_OUTPOST Then
        Out("[M02] FAIL - no se entro a la instancia en 60s")
        Return False
    EndIf
    Out("[M02] Dentro de instancia type=" & Map_GetInstanceInfo("Type") & " map=" & Map_GetMapID())
    Return True
EndFunc
Func _M2J_KillWithRetarget($modelId, $range, $timeoutMs)
    Local $t = TimerInit()
    While Not Bot_ShouldStop() And TimerDiff($t) < $timeoutMs
        Local $agent = Agent_GetAgentByPlayerNumber($modelId)
        If $agent = 0 Then Return True
        Local $hp = Agent_GetAgentInfo($agent, "HP")
        If $hp <= 0 Then Return True
        Local $cx = Agent_GetAgentInfo(-2, "X")
        Local $cy = Agent_GetAgentInfo(-2, "Y")
        Local $ax = Agent_GetAgentInfo($agent, "X")
        Local $ay = Agent_GetAgentInfo($agent, "Y")
        If Sqrt(($ax-$cx)^2 + ($ay-$cy)^2) > $range Then Return True
        Out("[M02] Retarget model " & $modelId & " HP=" & Round($hp, 2))
        Agent_ChangeTarget($agent)
        Agent_CallTarget($agent)
        Agent_Attack($agent)
        Sleep(3000)
    WEnd
    Out("[M02] WARN: timeout matando model " & $modelId)
    Return False
EndFunc
Func _M2J_FindNearestFoe($range = 5000, $modelFilter = 0)
    Local $agents = Agent_GetAgentArray($GC_I_AGENT_TYPE_LIVING)
    If Not IsArray($agents) Or $agents[0] = 0 Then Return 0
    Local $px = Agent_GetAgentInfo(-2, "X")
    Local $py = Agent_GetAgentInfo(-2, "Y")
    Local $bestPtr = 0
    Local $bestDist = $range
    For $i = 1 To $agents[0]
        Local $ptr = $agents[$i]
        If $ptr = 0 Then ContinueLoop
        If Agent_GetAgentInfo($ptr, "Allegiance") <> $GC_I_ALLEGIANCE_ENEMY Then ContinueLoop
        If Agent_GetAgentInfo($ptr, "HP") <= 0 Then ContinueLoop
        If Agent_GetAgentInfo($ptr, "IsDead") > 0 Then ContinueLoop
        If $modelFilter <> 0 And Agent_GetAgentInfo($ptr, "PlayerNumber") <> $modelFilter Then ContinueLoop
        Local $ax = Agent_GetAgentInfo($ptr, "X")
        Local $ay = Agent_GetAgentInfo($ptr, "Y")
        Local $d = Sqrt(($ax - $px)^2 + ($ay - $py)^2)
        If $d < $bestDist Then
            $bestDist = $d
            $bestPtr = $ptr
        EndIf
    Next
    Return $bestPtr
EndFunc
Func _M2J_FocusFireUntilDead($target, $timeoutMs, ByRef $outDeadX, ByRef $outDeadY)
    Local $t = TimerInit()
    Local $tLog = TimerInit()
    Local $tHeroCheck = TimerInit()
    Local $lastX = Agent_GetAgentInfo($target, "X")
    Local $lastY = Agent_GetAgentInfo($target, "Y")
    While Not Bot_ShouldStop() And TimerDiff($t) < $timeoutMs
        If Bot_ShouldStop() Then Return False
        If Recovery_IsAtZero() Then Return False
        If Map_GetInstanceInfo("Type") = $GC_I_MAP_TYPE_OUTPOST Then
            Out("[M02] FocusFire: InstanceType=outpost -> party derrotada, abort")
            Return False
        EndIf
        If TimerDiff($tHeroCheck) > 5000 Then
            $tHeroCheck = TimerInit()
            Local $heroCount = Party_GetMyPartyInfo("ArrayHeroPartyMemberSize")
            If Not @error And $heroCount > 0 Then
                For $ih = 1 To $heroCount
                    Local $hId = Party_GetMyPartyHeroInfo($ih, "AgentID")
                    If $hId > 0 And Agent_GetAgentInfo($hId, "IsDead") Then
                        Out("[M02] FocusFire: hero muerto (agent=" & $hId & "), esperando revive antes de seguir")
                        _M2J_WaitPartyAlive(20000)
                        ExitLoop
                    EndIf
                Next
            EndIf
        EndIf
        Local $tx  = Agent_GetAgentInfo($target, "X")
        Local $ty  = Agent_GetAgentInfo($target, "Y")
        Local $hp  = Agent_GetAgentInfo($target, "HP")
        Local $dead = Agent_GetAgentInfo($target, "IsDead")
        If $tx = 0 And $ty = 0 And $hp <= 0 Then
            If TimerDiff($tLog) > 3000 Then
                Out("[M02] Darehk fuera de rango (agente descargado), persiguiendo (" & Round($lastX) & "," & Round($lastY) & ")")
                $tLog = TimerInit()
            EndIf
            Map_Move($lastX, $lastY)
            Sleep(400)
            ContinueLoop
        EndIf
        If $dead Or $hp <= 0 Then
            $outDeadX = ($tx <> 0) ? $tx : $lastX
            $outDeadY = ($ty <> 0) ? $ty : $lastY
            Out("[M02] DAREHK MUERTO en (" & Round($outDeadX) & "," & Round($outDeadY) & ")")
            Return True
        EndIf
        If $tx <> 0 Or $ty <> 0 Then
            $lastX = $tx
            $lastY = $ty
        EndIf
        Local $dist = Agent_GetDistance(-2, $target)
        If TimerDiff($tLog) > 3000 Then
            Out("[M02] Darehk HP=" & Round(Agent_GetAgentInfo($target, "HP")*100) & "% dist=" & Round($dist) & "u cHP=" & Round(Agent_GetAgentInfo(-2, "HP")*100) & "%")
            $tLog = TimerInit()
        EndIf
        If $dist > 1300 Then
            MoveToFollowPath($tx, $ty, 0)
            Sleep(600)
            ContinueLoop
        ElseIf $dist > 700 Then
            Map_Move($tx, $ty)
            Sleep(400)
            ContinueLoop
        EndIf
        Agent_ChangeTarget($target)
        Sleep(80)
        Agent_CallTarget($target)
        Sleep(80)
        Agent_Attack($target, False)
        Sleep(80)
        Combat_CastNextReady()
        Sleep(360)
    WEnd
    Out("[M02] WARN: timeout " & Round($timeoutMs/1000) & "s matando Darehk, usando ultima pos")
    $outDeadX = $lastX
    $outDeadY = $lastY
    Return False
EndFunc
Func _M2J_WaitPartyAlive($timeoutMs = 12000)
    Local $t = TimerInit()
    While Not Bot_ShouldStop() And TimerDiff($t) < $timeoutMs
        Local $allAlive = True
        Local $heroCount = Party_GetMyPartyInfo("ArrayHeroPartyMemberSize")
        If Not @error And $heroCount > 0 Then
            For $i = 1 To $heroCount
                Local $hAid = Party_GetMyPartyHeroInfo($i, "AgentID")
                If $hAid > 0 And Agent_GetAgentInfo($hAid, "IsDead") Then
                    $allAlive = False
                    ExitLoop
                EndIf
            Next
        EndIf
        If $allAlive Then
            Local $henchCount = Party_GetMyPartyInfo("ArrayHenchmanPartyMemberSize")
            If Not @error And $henchCount > 0 Then
                For $i = 1 To $henchCount
                    Local $nAid = Party_GetMyPartyHenchmanInfo($i, "AgentID")
                    If $nAid > 0 And Agent_GetAgentInfo($nAid, "IsDead") Then
                        $allAlive = False
                        ExitLoop
                    EndIf
                Next
            EndIf
        EndIf
        If $allAlive Then
            Out("[M02] WaitPartyAlive: party viva tras " & Round(TimerDiff($t)/1000, 1) & "s")
            Return
        EndIf
        Sleep(400)
    WEnd
    Out("[M02] WaitPartyAlive: timeout " & Round($timeoutMs/1000) & "s - alguno sigue muerto, continuando")
EndFunc
Func _M2J_DisableRescue()
    $g_GE_NeedsWalkback = False
    $g_GE_WalkbackStarted = False
    $g_GE_LastCharIsDead = False
EndFunc
Func _M2J_PickupItemByModel($modelId, $range)
    Local $maxAgents = Agent_GetMaxAgents()
    Local $cx = Agent_GetAgentInfo(-2, "X")
    Local $cy = Agent_GetAgentInfo(-2, "Y")
    For $i = 1 To $maxAgents
        If Agent_GetAgentPtr($i) = 0 Then ContinueLoop
        If Agent_GetAgentInfo($i, "Type") <> $GC_I_AGENT_TYPE_ITEM Then ContinueLoop
        Local $ax = Agent_GetAgentInfo($i, "X")
        Local $ay = Agent_GetAgentInfo($i, "Y")
        If Sqrt(($ax-$cx)^2 + ($ay-$cy)^2) > $range Then ContinueLoop
        Local $agentId = Agent_GetAgentInfo($i, "ID")
        If $agentId = 0 Then ContinueLoop
        Local $model = Item_GetItemInfoByAgentID($agentId, "ModelID")
        If $model <> $modelId Then ContinueLoop
        Out("[M02] PickupItem model=" & $modelId & " agentId=" & $agentId)
        Item_PickUpItem($agentId)
        Sleep(1000)
        Return True
    Next
    Out("[M02] WARN: item model=" & $modelId & " no encontrado en " & $range & "u")
    Return False
EndFunc
Func _M2J_HasTabletBundle()
    Return Item_GetInventoryInfo("BundleModelID") = 17055
EndFunc
Func _M2J_ScanAndPickupTablet($maxRange = 2500)
    If Agent_GetAgentInfo(-2, "IsDead") = True Then
        Out("[M02] ScanTablet: char muerto, esperando revive (max 20s)")
        Local $revT = TimerInit()
        While Not Bot_ShouldStop() And TimerDiff($revT) < 20000
            Sleep(2500)
            If Agent_GetAgentInfo(-2, "IsDead") = False Then ExitLoop
        WEnd
        If Agent_GetAgentInfo(-2, "IsDead") = True Then
            Out("[M02] ScanTablet: char sigue muerto tras 20s, abort pickup")
            Return False
        EndIf
        Out("[M02] ScanTablet: char revivido, pickup")
    EndIf
    If Combat_AnyEnemyNear(1500) <> 0 Then
        Out("[M02] ScanTablet: enemies <1500u, limpiando antes de pickup")
        Combat_ClearZone(1250, 30000)
    EndIf
    Local $bestPtr = _M2J_RescanTablet($maxRange)
    If $bestPtr = 0 Then
        Out("[M02] ScanTablet: no encontrada en " & $maxRange & "u")
        Return False
    EndIf
    Local $ax = Agent_GetAgentInfo($bestPtr, "X")
    Local $ay = Agent_GetAgentInfo($bestPtr, "Y")
    Local $agentId = Agent_GetAgentInfo($bestPtr, "ID")
    Local $px = Agent_GetAgentInfo(-2, "X")
    Local $py = Agent_GetAgentInfo(-2, "Y")
    Local $bestDist = Sqrt(($ax - $px)^2 + ($ay - $py)^2)
    Out("[M02] ScanTablet: encontrada d=" & Round($bestDist) & "u en (" & _
        Round($ax) & "," & Round($ay) & ") agentId=" & $agentId)
    Out("[M02] ScanTablet: MoveToFollowPath a la tablet (" & Round($ax) & "," & Round($ay) & ") d=" & Round($bestDist) & "u")
    MoveToFollowPath($ax, $ay, 0)
    Sleep(1500)
    Local $fx = Agent_GetAgentInfo(-2, "X"), $fy = Agent_GetAgentInfo(-2, "Y")
    Local $fDist = Sqrt(($ax - $fx)^2 + ($ay - $fy)^2)
    If $fDist > 120 Then
        Out("[M02] ScanTablet: aun a " & Round($fDist) & "u de la tablet (pathfinder), re-scan y Map_Move corto")
        $freshPtr = _M2J_RescanTablet($maxRange)
        If $freshPtr <> 0 Then
            $ax = Agent_GetAgentInfo($freshPtr, "X")
            $ay = Agent_GetAgentInfo($freshPtr, "Y")
        EndIf
        Map_Move($ax, $ay)
        Sleep(2000)
    EndIf
    For $try = 1 To 3
        Local $freshPtr = _M2J_RescanTablet($maxRange)
        If $freshPtr <> 0 Then
            $ax = Agent_GetAgentInfo($freshPtr, "X")
            $ay = Agent_GetAgentInfo($freshPtr, "Y")
            $agentId = Agent_GetAgentInfo($freshPtr, "ID")
        EndIf
        Local $cx = Agent_GetAgentInfo(-2, "X")
        Local $cy = Agent_GetAgentInfo(-2, "Y")
        Local $distNow = Sqrt(($ax-$cx)^2 + ($ay-$cy)^2)
        If $distNow > 50 Then
            Map_Move($ax, $ay)
            Sleep(1500)
        EndIf
        Out("[M02] PickUpItem intento " & $try & "/3 agentId=" & $agentId & " d=" & Round($distNow) & "u")
        Item_PickUpItem($agentId)
        Sleep(2500)
        If _M2J_HasTabletBundle() And _M2J_TabletGone($ax, $ay) Then
            Agent_CancelAction()
            Sleep(500)
            $g_bHasBundle = True
            Out("[M02] ScanTablet: bundle ACTIVO (BundleModelID=17055) y stone FUERA del suelo -> pickup fisico OK")
            Return True
        EndIf
        If _M2J_HasTabletBundle() Then
            Out("[M02] Bundle ACTIVO en memoria pero stone SIGUE en el suelo -> falso positivo, reintento")
        EndIf
        Out("[M02] Bundle aun no activo, reintento")
    Next
    Out("[M02] ScanTablet: 3 intentos sin activar bundle")
    Return False
EndFunc
Func _M2J_RescanTablet($maxRange = 999999)
    Local $items = Agent_GetAgentArray(0x400)
    If Not IsArray($items) Or $items[0] = 0 Then Return 0
    Local $px = Agent_GetAgentInfo(-2, "X")
    Local $py = Agent_GetAgentInfo(-2, "Y")
    Local $bestPtr = 0
    Local $bestDist = 999999
    For $i = 1 To $items[0]
        Local $ptr = $items[$i]
        If Not Agent_GetAgentInfo($ptr, "CanPickUp") Then ContinueLoop
        Local $x = Agent_GetAgentInfo($ptr, "X")
        Local $y = Agent_GetAgentInfo($ptr, "Y")
        Local $d = Sqrt(($x - $px) * ($x - $px) + ($y - $py) * ($y - $py))
        If $d > $maxRange Then ContinueLoop
        Local $agentId = Agent_GetAgentInfo($ptr, "ID")
        If $agentId = 0 Then ContinueLoop
        Local $model = Item_GetItemInfoByAgentID($agentId, "ModelID")
        If $model <> 17055 Then ContinueLoop
        If $d < $bestDist Then
            $bestDist = $d
            $bestPtr = $ptr
        EndIf
    Next
    If $bestPtr = 0 Then
        Out("[M02] RescanTablet: NOT found (scan items fallo)")
    EndIf
    Return $bestPtr
EndFunc
Func _M2J_TabletGone($x, $y, $tol = 180)
    Local $items = Agent_GetAgentArray(0x400)
    If Not IsArray($items) Or $items[0] = 0 Then Return True
    For $i = 1 To $items[0]
        Local $ptr = $items[$i]
        If Not Agent_GetAgentInfo($ptr, "CanPickUp") Then ContinueLoop
        Local $ix = Agent_GetAgentInfo($ptr, "X")
        Local $iy = Agent_GetAgentInfo($ptr, "Y")
        Local $d = Sqrt(($ix - $x) ^ 2 + ($iy - $y) ^ 2)
        If $d > $tol Then ContinueLoop
        Local $model = Item_GetItemInfoByAgentID(Agent_GetAgentInfo($ptr, "ID"), "ModelID")
        If $model = 17055 Then
            Out("[M02] TabletGone: stone SIGUE en el suelo en (" & Round($ix) & "," & Round($iy) & ") d=" & Round($d) & "u")
            Return False
        EndIf
    Next
    Return True
EndFunc
Func _M2J_NavTo($x, $y, $tol, $timeout, $aggroStopRange = 0)
    Local $cx = Agent_GetAgentInfo(-2, "X")
    Local $cy = Agent_GetAgentInfo(-2, "Y")
    Local $dWp = Sqrt(($x-$cx)^2 + ($y-$cy)^2)
    If $dWp < $tol Then
        Out("[M02] NavTo (" & $x & "," & $y & ") skip: ya en destino d=" & Round($dWp) & "u")
        Return True
    EndIf
    If $aggroStopRange > 0 And Combat_AnyEnemyNear($aggroStopRange) <> 0 Then
        Out("[M02] NavTo aggro-stop pre: enemy <" & $aggroStopRange & "u")
        Return True
    EndIf
    Local $t = TimerInit()
    Local $tLog = TimerInit()
    Local $iter = 0
    Local $tStuck = TimerInit()
    Local $lastX = $cx
    Local $lastY = $cy
    Local $stuckCount = 0   
    Map_Move($x, $y, 650)
    While Not Bot_ShouldStop() And TimerDiff($t) < $timeout
        $iter += 1
        If Map_GetInstanceInfo("Type") = $GC_I_MAP_TYPE_OUTPOST Then
            Out("[M02] NavTo: InstanceType=outpost -> party derrotada, abort nav")
            Return False
        EndIf
        $cx = Agent_GetAgentInfo(-2, "X")
        $cy = Agent_GetAgentInfo(-2, "Y")
        $dWp = Sqrt(($x-$cx)^2 + ($y-$cy)^2)
        If $dWp < $tol Then Return True
        If $aggroStopRange > 0 And Combat_AnyEnemyNear($aggroStopRange) <> 0 Then
            Out("[M02] NavTo aggro-stop: enemy <" & $aggroStopRange & "u (d_wp=" & Round($dWp) & "u)")
            Return True
        EndIf
        If TimerDiff($tLog) > 3000 Then
            Out("[M02] NavTo (" & $x & "," & $y & ") d=" & Round($dWp) & "u")
            $tLog = TimerInit()
        EndIf
        If TimerDiff($tStuck) > 2500 Then
            Local $moved = Sqrt(($cx - $lastX)^2 + ($cy - $lastY)^2)
            If $moved < 50 Then
                $stuckCount += 1
                Local $dx = $x - $cx, $dy = $y - $cy
                Local $len = Sqrt($dx*$dx + $dy*$dy)
                If $len < 1 Then $len = 1
                Local $perpX = -$dy / $len, $perpY = $dx / $len
                Local $side = 1
                If Mod($stuckCount, 2) = 0 Then $side = -1
                Local $mag = 250 + 150 * $stuckCount
                If $mag > 1000 Then $mag = 1000
                Out("[M02] Stuck #" & $stuckCount & " (" & Round($moved) & "u en 2.5s) -> nudge perpendicular lado=" & $side & " mag=" & $mag)
                Map_Move($cx + $perpX*$mag*$side, $cy + $perpY*$mag*$side, 100)
                Sleep(450)
                Map_Move($x, $y, 200)
            Else
                $stuckCount = 0
            EndIf
            $lastX = $cx
            $lastY = $cy
            $tStuck = TimerInit()
        EndIf
        Map_Move($x, $y)
        Sleep(400)
    WEnd
    Out("[M02] WARN: timeout NavTo (" & $x & "," & $y & ") d=" & Round($dWp) & "u")
    Return False
EndFunc
Func _M2J_PassThroughNav($x, $y, $destX, $destY, $tol, $timeout)
    Local $cx = Agent_GetAgentInfo(-2, "X")
    Local $cy = Agent_GetAgentInfo(-2, "Y")
    Local $dWp = Sqrt(($x-$cx)^2 + ($y-$cy)^2)
    Local $dDest = Sqrt(($destX-$cx)^2 + ($destY-$cy)^2)
    If $dDest < $dWp Then
        Out("[M02] PassThrough (" & $x & "," & $y & ") skip: dDest=" & Round($dDest) & "u < dWp=" & Round($dWp) & "u")
        Return True
    EndIf
    Return _M2J_NavTo($x, $y, $tol, $timeout)
EndFunc
Func _M2J_PlaceTabletAtAltar($px, $py, $range)
    If Not $g_bHasBundle Then
        Out("[M02] PlaceTablet SKIP: $g_bHasBundle=False (pickup previo fallo)")
        Return False
    EndIf
    For $try = 1 To 4
        _M2J_NavTo($px, $py, 250, 10000)
        Sleep(300)
        Local $pedestal = _M2J_FindPedestal($px, $py, $range)
        If $pedestal = 0 Then
            Out("[M02] WARN: no gadget en " & $range & "u de (" & $px & "," & $py & ") intento " & $try & "/4")
            ContinueLoop
        EndIf
        Local $cX = Agent_GetAgentInfo($pedestal, "X")
        Local $cY = Agent_GetAgentInfo($pedestal, "Y")
        Out("[M02] PlaceTablet intento " & $try & "/4 slot=" & $pedestal & " pos=(" & _
            Round($cX) & "," & Round($cY) & ")")
        Agent_ChangeTarget($pedestal)
        Sleep(250)
        Agent_GoSignpost($pedestal)
        Sleep(2000)
        If Item_GetInventoryInfo("BundleModelID") = 0 Then
            $g_bHasBundle = False
            Out("[M02] Tablet colocada OK en intento " & $try)
            Return True
        EndIf
        Out("[M02] Tablet no colocada (BundleModelID sigue activo), reintento")
    Next
    Out("[M02] FAIL: no se pudo colocar tablet en (" & $px & "," & $py & ")")
    Return False
EndFunc
Func _M2J_FindPedestal($px, $py, $range)
    Local $maxAgents = Agent_GetMaxAgents()
    Local $bestModel16 = 0
    Local $bestModel16Dist = $range + 1
    Local $bestFallback = 0
    Local $bestFallbackDist = $range + 1
    For $i = 1 To $maxAgents
        If Agent_GetAgentPtr($i) = 0 Then ContinueLoop
        If Agent_GetAgentInfo($i, "Type") <> 0x200 Then ContinueLoop
        Local $ax = Agent_GetAgentInfo($i, "X")
        Local $ay = Agent_GetAgentInfo($i, "Y")
        Local $d = Sqrt(($ax-$px)^2 + ($ay-$py)^2)
        If $d > $range Then ContinueLoop
        If Agent_GetAgentInfo($i, "PlayerNumber") = 16 Then
            If $d < $bestModel16Dist Then
                $bestModel16Dist = $d
                $bestModel16 = $i
            EndIf
        Else
            If $d < $bestFallbackDist Then
                $bestFallbackDist = $d
                $bestFallback = $i
            EndIf
        EndIf
    Next
    If $bestModel16 > 0 Then
        Out("[M02] Pedestal Model=16 slot=" & $bestModel16 & " d=" & Round($bestModel16Dist) & "u")
        Return $bestModel16
    EndIf
    If $bestFallback > 0 Then
        Out("[M02] Pedestal fallback (no Model16) slot=" & $bestFallback & " d=" & Round($bestFallbackDist) & "u")
        Return $bestFallback
    EndIf
    Return 0
EndFunc
Func _M2J_DoNavOnly($x, $y, $tol = 600, $timeout = 30000)
    Return _Mission_DoNavOnly($x, $y)
EndFunc
Func _M2J_DoNavCombat($x, $y, $tol = 600, $timeout = 30000)
    If Not _M2J_NavTo($x, $y, $tol, $timeout, 1300) Then Return False
    Combat_ClearZone(1250, 60000)
    Return True
EndFunc
Func _M2J_DropBundle()
    If Not $g_bHasBundle Then
        Out("[M02] DropBundle SKIP: g_bHasBundle=False")
        Return False
    EndIf
    For $try = 1 To 5
        Out("[M02] DropBundle intento " & $try & "/5")
        Core_ControlAction($GC_I_CONTROL_ACTION_DROP_ITEM)
        Sleep(1500)
        If Item_GetInventoryInfo("BundleModelID") = 0 Then
            $g_bHasBundle = False
            Out("[M02] DropBundle OK: tablilla en el suelo")
            Return True
        EndIf
    Next
    Out("[M02] DropBundle FAIL tras 5 intentos")
    Return False
EndFunc
Func _M2J_DeliverTablet($x, $y, $range = 1200)
    If Not $g_bHasBundle Then
        Out("[M02] DeliverTablet SKIP: g_bHasBundle=False")
        Return False
    EndIf
    For $try = 1 To 4
        _M2J_NavTo($x, $y, 250, 10000)
        Sleep(300)
        Local $gadgetId = Gadget_FindNearestToXY($x, $y, $range)
        If $gadgetId = 0 Then
            Out("[M02] DeliverTablet WARN: no gadget en " & $range & "u de (" & Round($x) & "," & Round($y) & ") intento " & $try & "/4")
            Gadget_LogNearby(2000)
            ContinueLoop
        EndIf
        Local $gX = Agent_GetAgentInfo($gadgetId, "X")
        Local $gY = Agent_GetAgentInfo($gadgetId, "Y")
        Local $gModel = Agent_GetAgentInfo($gadgetId, "PlayerNumber")
        Out("[M02] DeliverTablet intento " & $try & "/4 gadget id=" & $gadgetId & " model=" & $gModel & " pos=(" & Round($gX) & "," & Round($gY) & ")")
        Agent_ChangeTarget($gadgetId)
        Sleep(250)
        Agent_GoSignpost($gadgetId)
        Sleep(2500)
        If Item_GetInventoryInfo("BundleModelID") = 0 Then
            $g_bHasBundle = False
            Out("[M02] DeliverTablet OK: tablilla entregada en intento " & $try)
            Return True
        EndIf
        Out("[M02] DeliverTablet: bundle aun activo tras GoSignpost, reintento")
    Next
    Out("[M02] DeliverTablet FAIL tras 4 intentos")
    Return False
EndFunc
Global $g_aM2J_ConsetModels[3]  = [24859, 24861, 24860]  
Global $g_aM2J_ConsetEffects[3] = [2522, 2521, 2520]
Func _M2J_FindConsetItemByModel($model)
    For $bag = $GC_I_INVENTORY_BACKPACK To $GC_I_INVENTORY_BAG2
        Local $slots = Item_GetBagInfo($bag, "Slots")
        For $sl = 1 To $slots
            Local $pItem = Item_GetItemBySlot($bag, $sl)
            If $pItem = 0 Then ContinueLoop
            If Item_GetItemInfoByPtr($pItem, "ModelID") = $model Then
                Return Item_GetItemInfoByPtr($pItem, "ItemID")
            EndIf
        Next
    Next
    Return 0
EndFunc
Func _M2J_UseConsets()
    Local $T = "[M02-cons] "
    For $c = 0 To 2
        Local $model = $g_aM2J_ConsetModels[$c], $eff = $g_aM2J_ConsetEffects[$c]
        If Agent_GetAgentEffectInfo(-2, $eff, "HasEffect") Then
            Out($T & "conset " & $model & " ya activo")
            ContinueLoop
        EndIf
        Local $itemID = _M2J_FindConsetItemByModel($model)
        If $itemID <> 0 Then
            Item_UseItem($itemID)
            Out($T & "conset " & $model & " activado")
            Sleep(1500)
        Else
            Out($T & "conset " & $model & " no en mochila")
        EndIf
    Next
EndFunc
Func _M2J_RestorePartyAfterTravel()
    Local $T = "[M02-party] "
    For $r = 1 To 3
        If _AutoLevel_FindHeroSlot($M2J_KOSS_HERO_ID) = 0 Then ExitLoop
        Out($T & "Kick Koss (vuelto tras travel) intento " & $r)
        Party_KickHero($M2J_KOSS_HERO_ID)
        Sleep(1200)
    Next
    If Not _AutoParty_IsHenchModelInParty($M2J_KIHM_MODEL) Then
        _AutoParty_KickNonMonkHenchman($M2J_KIHM_MODEL)
        Sleep(800)
    EndIf
    If Not _AutoParty_IsHenchModelInParty($M2J_KIHM_MODEL) Then
        Local $kihmAg = Agent_GetAgentByPlayerNumber($M2J_KIHM_MODEL)
        If $kihmAg <> 0 Then
            Out($T & "Party_AddNpc Kihm model=" & $M2J_KIHM_MODEL & " agent=" & $kihmAg)
            Party_AddNpc($kihmAg)
            Sleep(800)
        Else
            Out($T & "WARN: Kihm model=" & $M2J_KIHM_MODEL & " no encontrado en outpost 491")
        EndIf
    Else
        Out($T & "Kihm ya en party")
    EndIf
    Local $aNeedM2[2] = [7, 9]
    For $h = 0 To 1
        If _AutoLevel_FindHeroSlot($aNeedM2[$h]) = 0 Then
            Out($T & "Hero ID=" & $aNeedM2[$h] & " fuera -> Party_AddHero")
            Party_AddHero($aNeedM2[$h])
            Sleep(1000)
        EndIf
    Next
    Local $kossIn = (_AutoLevel_FindHeroSlot($M2J_KOSS_HERO_ID) > 0)
    Local $melIn  = (_AutoLevel_FindHeroSlot(9) > 0)
    Local $kihmIn = _AutoParty_IsHenchModelInParty($M2J_KIHM_MODEL)
    Out($T & "Estado final: Koss_dentro=" & $kossIn & " Melonni_dentro=" & $melIn & " Kihm_dentro=" & $kihmIn)
    Return (Not $kossIn And $melIn And $kihmIn)
EndFunc
Func _M2J_BuyMissingSkills($sMissingSkillsCSV)
    Local $T = "[M02-buy] "
    If $sMissingSkillsCSV = "" Then Return True
    Out($T & "Travel a Kamadan (" & $BSK_KAMADAN_MAP_ID & ") para recomprar [" & $sMissingSkillsCSV & "]")
    If Not Travel_ToOutpost($BSK_KAMADAN_MAP_ID) Then
        Out($T & "FAIL travel a Kamadan")
        Return False
    EndIf
    Sleep(1500)
    Out($T & "Nav a Skill Merchant 4751 (" & $BSK_MERCHANT_X & "," & $BSK_MERCHANT_Y & ") con rodeo Bendah")
    Map_Move(-11408, 14200, 0)
    Local $tNav = TimerInit()
    While Not Bot_ShouldStop() And TimerDiff($tNav) < 20000
        Local $wx = Agent_GetAgentInfo(-2, "X")
        Local $wy = Agent_GetAgentInfo(-2, "Y")
        If Sqrt(($wx - (-11408))^2 + ($wy - 14200)^2) < 500 Then ExitLoop
        Local $dist = Sqrt(($wx - (-11408))^2 + ($wy - 14200)^2)
        If TimerDiff($tNav) > 5000 And Mod(Int(TimerDiff($tNav) / 2000), 2) = 0 Then
            Out($T & "Anti-stuck rodeo Bendah -> nudge lateral")
            Map_Move($wx - 1500, $wy, 0)
            Sleep(2000)
        EndIf
        Map_Move(-11408, 14200, 0)
        Sleep(500)
    WEnd
    If Not _Quests_NavAndOpenDialog($BSK_MERCHANT_X, $BSK_MERCHANT_Y, $BSK_MERCHANT_MODEL) Then
        Out($T & "FAIL nav/dialog Skill Merchant - intento directo")
        Local $merchantAg = 0
        For $mi = 1 To 5
            $merchantAg = Agent_GetAgentByPlayerNumber($BSK_MERCHANT_MODEL)
            If $merchantAg <> 0 Then ExitLoop
            Sleep(500)
        Next
        If $merchantAg <> 0 Then
            Out($T & "Fallback: merchant encontrado, GoNPC")
            Agent_GoNPC($merchantAg)
            Sleep(2500)
        Else
            Out($T & "FAIL definitivo: merchant no encontrado")
            Return False
        EndIf
    EndIf
    Local $aIds = StringSplit($sMissingSkillsCSV, ",", 2)
    Local $okAll = True
    For $bi = 0 To UBound($aIds) - 1
        Local $sid = Number($aIds[$bi])
        If $sid = 0 Then ContinueLoop
        If World_IsSkillLearnt($sid) Then
            Out($T & "Skill " & $sid & " ya aprendida -> skip")
            ContinueLoop
        EndIf
        Local $bought = False
        For $a = 1 To 2
            Out($T & "Skill_BuySkillByID(" & $sid & ") intento " & $a)
            Skill_BuySkillByID($sid)
            Sleep(2500)
            If World_IsSkillLearnt($sid) Then
                $bought = True
                ExitLoop
            EndIf
        Next
        If $bought Then
            Out($T & "Compra OK: Skill " & $sid & " aprendida")
        Else
            Out($T & "Compra FALLO: Skill " & $sid & " NO aprendida tras 2 intentos (Â¿sin skill points u oro?)")
            $okAll = False
        EndIf
    Next
    Out($T & "Volver a Jokanur (" & $M2J_OUTPOST_MAP_ID & ")")
    If Not Travel_ToOutpost($M2J_OUTPOST_MAP_ID) Then
        Out($T & "FAIL travel de vuelta a Jokanur")
        Return False
    EndIf
    Sleep(1000)
    Return $okAll
EndFunc