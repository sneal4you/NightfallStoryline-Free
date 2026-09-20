#include-once
Global $g_sCombatPriorityModels = ""
Global $g_iCombatPriorityRange = 0
Global $g_iCombatPriorityCap = 0
Global $g_tCombatPickDbg = 0
Global $g_iCombatPickLast = 0
Global $g_iKorrFocus = 0
Global $g_iCombatStickyCap = 0
Global $g_iCombatStickyTarget = 0
Global $g_sCombatOnIter = ""
Global $g_bCombatPriorityClerics = True
Global $g_iCombatClericsRange = 1500
Global $g_bCombatPrioritySorcerers = True
Global $g_sCombatProfPriority = ""
Global $g_bCombatPriorityGenerals = True
Global $g_sCombatIgnoreModels = ""
Global $g_iCombatLeashX = 0
Global $g_iCombatLeashY = 0
Global $g_iCombatLeashRange = 0   
Global $g_iCombatEngageTimeoutMs = 0
Global $g_iCombatLosNudges = 0
Global $g_iCombatLosLastEnemy = 0
Global $g_bCombatLastMoveSet = False
Global $g_iCombatLastMoveMs = 0
Global $g_fCombatLastMoveX = 0
Global $g_fCombatLastMoveY = 0
Func _Combat_MapMove($tx, $ty, $tz = 0)
    If Not $g_bCombatLastMoveSet Then
        $g_bCombatLastMoveSet = True
        $g_fCombatLastMoveX = $tx
        $g_fCombatLastMoveY = $ty
        $g_iCombatLastMoveMs = TimerInit()
        Map_Move($tx, $ty, $tz)
        Return
    EndIf
    Local $cx = Agent_GetAgentInfo(-2, "X"), $cy = Agent_GetAgentInfo(-2, "Y")
    Local $dDest = Sqrt(($tx - $g_fCombatLastMoveX)^2 + ($ty - $g_fCombatLastMoveY)^2)
    Local $dMoved = Sqrt(($cx - $g_fCombatLastMoveX)^2 + ($cy - $g_fCombatLastMoveY)^2)
    If $dDest > 100 Or $dMoved > 80 Or TimerDiff($g_iCombatLastMoveMs) > 2500 Then
        $g_fCombatLastMoveX = $tx
        $g_fCombatLastMoveY = $ty
        $g_iCombatLastMoveMs = TimerInit()
        Map_Move($tx, $ty, $tz)
    EndIf
EndFunc
Global $g_bCombatIgnorePets = True
Func _Combat_IsIgnoredModel($model)
    If $g_sCombatIgnoreModels = "" Then Return False
    Local $aIg = StringSplit($g_sCombatIgnoreModels, ",", 2)
    For $im = 0 To UBound($aIg) - 1
        If Number($aIg[$im]) = $model Then Return True
    Next
    Return False
EndFunc
Func _Combat_IsSpirit($ptr, $name = "")
    If Not $g_bCombatIgnoreSpirits Then Return False
    If $name = "" Then $name = Agent_GetAgentInfo($ptr, "Name")
    Return StringInStr($name, "Spirit") <> 0
EndFunc
Func _Combat_IsMinion($ptr, $name = "")
    If Not $g_bCombatIgnoreMinions Then Return False
    If $name = "" Then $name = Agent_GetAgentInfo($ptr, "Name")
    Return StringInStr($name, "Minion") <> 0
EndFunc
Func _Combat_IsRangerPet($modelID)
    If Not $g_bCombatIgnorePets Then Return False
    Switch $modelID
        Case 2517, 2519, 2520, 2521, 2522, 2523, 2524, 2525, _
             2650, 2651, 2738, 2740, 2742, 2744, _
             3578, 3580, 3582, 3584, _
             4096, 4098, 4100, 4102, _
             5081, 5083, 5085, 5087
            Return True
    EndSwitch
    Return False
EndFunc
Global $g_AA_CacheTimer = 0
Global $g_AA_CacheVal = 0
Func _Combat_LivingArray()
    If $g_AA_CacheTimer <> 0 And TimerDiff($g_AA_CacheTimer) < 10000 Then Return $g_AA_CacheVal
    $g_AA_CacheVal = Agent_GetAgentArray($GC_I_AGENT_TYPE_LIVING)
    $g_AA_CacheTimer = TimerInit()
    Return $g_AA_CacheVal
EndFunc
Func Combat_InvalidateLivingCache()
    $g_AA_CacheTimer = 0
EndFunc
Global $g_bCombatGaveUp = False
Global $g_iCombatSkippedEnemy = 0
Global $g_iCombatNoLoSModel = 0
Func Combat_LoadConfig()
    Local $ini = @ScriptDir & "\config.ini"
    Local $sProf = IniRead($ini, "Combat", "ProfPriority", "")
    If $sProf <> "" Then $g_sCombatProfPriority = $sProf
    $g_bCombatIgnoreMinions = (Int(IniRead($ini, "Combat", "IgnoreMinions", "1")) <> 0)
    $g_bCombatIgnorePets = (Int(IniRead($ini, "Combat", "IgnoreRangerPets", "1")) <> 0)
    Out("[Combat] Config: ProfPriority='" & $g_sCombatProfPriority & "' IgnoreMinions=" & $g_bCombatIgnoreMinions & " IgnorePets=" & $g_bCombatIgnorePets)
EndFunc
Func Combat_ClearZone($range = 1300, $timeoutMs = 20000)
    Out("[Combat] ClearZone range=" & $range & "u timeout=" & Round($timeoutMs/1000, 0) & "s")
    $g_bCombatGaveUp = False
    Local $t = TimerInit()
    Local $stateTimer = TimerInit()
    Local $iter = 0
    Local $lastTarget = $g_iCombatStickyTarget
        Local $tReattack = TimerInit()   
    Local $engageTimer = TimerInit()   
    Local $engageLastTgt = -1   
    Local $walkLastDist = 999999, $walkNoProg = 0, $walkSide = 1   
    Local $losLastHP = -1, $losTimer = TimerInit(), $losSide = 1   
    While TimerDiff($t) < $timeoutMs
        $iter += 1
        Local $tIter = TimerInit(), $msNear = 0, $msPri = 0, $msMark = 0, $msWalk = 0, $msCast = 0
        If Bot_ShouldStop() Then
            Out("[Combat] STOP solicitado iter=" & $iter)
            Return False
        EndIf
        If Recovery_IsAtZero() Then
            If Map_GetMapID() > 0 And TimerDiff($t) < 3000 Then
                If $iter <= 3 Then
                    Sleep(500)
                    ContinueLoop
                EndIf
            EndIf
            Out("[Combat] Char en (0,0) iter=" & $iter & " -> abort")
            Return False
        EndIf
        If _Char_IsReallyDead() Then
            Out("[Combat] Char dead iter=" & $iter & " -> abort ClearZone (backoff 1.5s)")
            Sleep(1500)
            Return False
        EndIf
        Cinematic_ProtectStep()
        PartyRecovery_Tick()
        If $g_sCombatOnIter <> "" Then Call($g_sCombatOnIter)
        Local $tSeg = TimerInit()
        Local $enemy = GetNearestEnemy($range)
        $msNear = TimerDiff($tSeg)
        If $enemy = 0 Then
            If $g_iCombatLeashRange > 0 Then
                Local $lcx = Agent_GetAgentInfo(-2, "X"), $lcy = Agent_GetAgentInfo(-2, "Y")
                If $lcx <> 0 Then
                    Local $lcd = Sqrt(($lcx - $g_iCombatLeashX)^2 + ($lcy - $g_iCombatLeashY)^2)
                    If $lcd > $g_iCombatLeashRange Then
                        Out("[Combat] LEASH: char a " & Round($lcd) & "u > " & $g_iCombatLeashRange & "u del ancla (zona limpia) -> volver, fin ClearZone")
                        MoveToFollowPath($g_iCombatLeashX, $g_iCombatLeashY, 0)
                        Return True
                    EndIf
                EndIf
            EndIf
            Out("[Combat] Zona limpia tras " & Round(TimerDiff($t)/1000, 1) & "s iters=" & $iter)
            Return True
        EndIf
        Local $eHPnow = Agent_GetAgentInfo($enemy, "HP")
        Local $losClose = (Agent_GetDistance(-2, $enemy) < 1400)
        If $losClose And $enemy = $g_iCombatLosLastEnemy And Abs($eHPnow - $losLastHP) < 0.01 And ($g_iCombatNoLoSModel = 0 Or Agent_GetAgentInfo($enemy, "PlayerNumber") <> $g_iCombatNoLoSModel) Then
            If TimerDiff($losTimer) > 2500 Then
                Local $lcx = Agent_GetAgentInfo(-2, "X"), $lcy = Agent_GetAgentInfo(-2, "Y")
                Local $lex = Agent_GetAgentInfo($enemy, "X"), $ley = Agent_GetAgentInfo($enemy, "Y")
                Local $ld = Sqrt(($lex - $lcx) ^ 2 + ($ley - $lcy) ^ 2)
                If $ld < 1 Then $ld = 1
                $losSide = -$losSide
                $g_iCombatLosNudges += 1
                Local $nudgeDist = ($g_iCombatLosNudges <= 1) ? 350 : 700
                Out("[Combat] LoS nudge #" & $g_iCombatLosNudges & " dist=" & $nudgeDist & "u (enemy=" & $enemy & ")")
                _Combat_MapMove($lcx - (($ley - $lcy) / $ld) * $nudgeDist * $losSide + (($lex - $lcx) / $ld) * 200, _
                                $lcy + (($lex - $lcx) / $ld) * $nudgeDist * $losSide + (($ley - $lcy) / $ld) * 200, 0)
                Sleep(700)
                $losTimer = TimerInit()
                If $g_iCombatLosNudges >= 3 Then
                    Out("[Combat] 3 LoS nudges sin dañar -> skip enemy (inalcanzable)")
                    $g_iCombatSkippedEnemy = $enemy
                    $g_iCombatLosNudges = 0
                    $g_iCombatLosLastEnemy = 0
                    $g_bCombatGaveUp = True
                    Return True
                EndIf
                ContinueLoop
            EndIf
        Else
            If $enemy <> $g_iCombatLosLastEnemy Then
                $g_iCombatLosNudges = 0
            EndIf
            $g_iCombatLosLastEnemy = $enemy
            $losLastHP = $eHPnow
            $losTimer = TimerInit()
        EndIf
        $tSeg = TimerInit()
        $msPri = TimerDiff($tSeg)
        If $g_iCombatEngageTimeoutMs > 0 Then
            If $enemy <> $engageLastTgt Then
                $engageTimer = TimerInit()   
                $engageLastTgt = $enemy
            ElseIf TimerDiff($engageTimer) > $g_iCombatEngageTimeoutMs Then
                If GetNearestEnemy(800) <> 0 Then
                    $engageTimer = TimerInit()   
                Else
                    Out("[Combat] " & Round($g_iCombatEngageTimeoutMs/1000, 1) & "s sin matar al mismo target (inalcanzable/persiguiendo en vano) -> fin ClearZone, seguir ruta")
                    $g_iCombatSkippedEnemy = $enemy
                    $g_bCombatGaveUp = True
                    Return True
                EndIf
            EndIf
        EndIf
        If TimerDiff($stateTimer) > 2000 Then
            Local $cHP = Round(Agent_GetAgentInfo(-2, "HP")*100, 0)
            Out("[Combat] t=" & Round(TimerDiff($t)/1000, 1) & "s i=" & $iter & " enemy=" & $enemy & " cHP=" & $cHP & "%")
            $stateTimer = TimerInit()
        EndIf
        $tSeg = TimerInit()
        Local $prRange = $range
        If $g_iCombatPriorityRange > $range Then $prRange = $g_iCombatPriorityRange
        Local $priEnemy2 = 0, $stickyAlive = False, $scanCleric = 0, $scanSorc = 0, $stickyPri = False, $nearDist = $range
        _Combat_ScanAll($range, $prRange, $g_sCombatPriorityModels, $lastTarget, $enemy, $priEnemy2, $stickyAlive, $scanCleric, $scanSorc, $stickyPri, $nearDist)
        If $enemy = 0 Then
            Out("[Combat] Zona limpia tras " & Round(TimerDiff($t)/1000, 1) & "s iters=" & $iter)
            Return True
        EndIf
        If $priEnemy2 = 0 And $g_bCombatPriorityGenerals Then $priEnemy2 = _Combat_FindByGeneralName($prRange)
        If $priEnemy2 = 0 And $g_bCombatPriorityClerics Then $priEnemy2 = $scanCleric
        If $priEnemy2 = 0 And $g_bCombatPrioritySorcerers Then $priEnemy2 = $scanSorc
        If $priEnemy2 = 0 And $g_sCombatProfPriority <> "" Then
            Local $profRange2 = $range
            If $profRange2 > 1012 Then $profRange2 = 1012
            Local $profPrio2 = _Combat_FindByProfPriority($g_sCombatProfPriority, $profRange2)
            If $profPrio2 <> 0 Then $priEnemy2 = $profPrio2
        EndIf
        If $g_iKorrFocus <> 0 And (Agent_GetAgentInfo($g_iKorrFocus, "HP") <= 0 Or Agent_GetAgentInfo($g_iKorrFocus, "IsDead")) Then $g_iKorrFocus = 0
        If $g_iKorrFocus <> 0 Then
            $enemy = $g_iKorrFocus
        ElseIf $stickyAlive And Not $stickyPri And $priEnemy2 <> 0 Then
            $enemy = $priEnemy2   
        ElseIf $stickyAlive Then
            If $g_iCombatStickyCap > 0 Then
                Local $stickyDist = Agent_GetDistance(-2, $lastTarget)
                If $stickyDist <= $g_iCombatStickyCap Then
                    $enemy = $lastTarget        
                Else
                    $enemy = $priEnemy2         
                EndIf
            Else
                $enemy = $lastTarget            
            EndIf
        ElseIf $priEnemy2 <> 0 Then
            $enemy = $priEnemy2           
        EndIf
        If $enemy <> $g_iCombatPickLast Or TimerDiff($g_tCombatPickDbg) > 10000 Then
            $g_tCombatPickDbg = TimerInit()
            $g_iCombatPickLast = $enemy
            Local $eMdl = 0
            If $enemy <> 0 Then $eMdl = Agent_GetAgentInfo($enemy, "PlayerNumber")
            Out("[Combat-pick] tgt=" & $enemy & " mdl=" & $eMdl & " sticky=" & $stickyAlive & " stickyPri=" & $stickyPri & " pri2=" & $priEnemy2 & " scanC=" & $scanCleric & " list='" & $g_sCombatPriorityModels & "'")
        EndIf
        If $enemy <> 0 And (Agent_GetAgentInfo($enemy, "HP") <= 0 Or Agent_GetAgentInfo($enemy, "IsDead") Or Agent_GetAgentInfo($enemy, "PlayerNumber") = 0) Then
            $enemy = 0
            $lastTarget = 0
            $g_iCombatStickyTarget = 0
        EndIf
        If $enemy = 0 Then ContinueLoop
        Local $justMarked = False
        If $enemy <> $lastTarget Then
            Agent_ChangeTarget($enemy)
            Sleep(100)
            Agent_CallTarget($enemy)
            Sleep(100)
            Agent_Attack($enemy, False)
            $lastTarget = $enemy
            $g_iCombatStickyTarget = $enemy
            $tReattack = TimerInit()
            $justMarked = True
        ElseIf TimerDiff($tReattack) > 2000 Then
            Agent_Attack($enemy, False)
            $tReattack = TimerInit()
        EndIf
        $msMark = TimerDiff($tSeg)
        $tSeg = TimerInit()
        Local $mvEnemy = $enemy
        If $justMarked Then
            $mvEnemy = GetNearestEnemy($range)   
            If $stickyAlive Then
                $mvEnemy = $lastTarget
            ElseIf $g_sCombatPriorityModels <> "" Then
                Local $pMv = _Combat_FindByModelList($range, $g_sCombatPriorityModels)
                If $pMv <> 0 Then $mvEnemy = $pMv
            EndIf
        EndIf
        If $mvEnemy <> 0 Then
            Local $ecx = Agent_GetAgentInfo(-2, "X"), $ecy = Agent_GetAgentInfo(-2, "Y")
            Local $eex = Agent_GetAgentInfo($mvEnemy, "X"), $eey = Agent_GetAgentInfo($mvEnemy, "Y")
            Local $eDist = Sqrt(($eex - $ecx) ^ 2 + ($eey - $ecy) ^ 2)
            If ($eDist > 400 And $eDist <= 1012 And $eex <> 0) Or ($g_iKorrFocus <> 0 And $eDist <= 3000 And $eex <> 0) Then
                If ($walkLastDist - $eDist) < 120 Then
                    $walkNoProg += 1
                Else
                    $walkNoProg = 0
                EndIf
                $walkLastDist = $eDist
                If $walkNoProg >= 2 Then
                    Local $wux = ($eex - $ecx) / $eDist, $wuy = ($eey - $ecy) / $eDist
                    $walkSide = -$walkSide
                    _Combat_MapMove($ecx - $wuy * 700 * $walkSide + $wux * 300, $ecy + $wux * 700 * $walkSide + $wuy * 300, 0)
                    $walkNoProg = 0
                Else
                    _Combat_MapMove($eex, $eey, 0)   
                EndIf
                Agent_Attack($mvEnemy, False)
                Sleep(400)
            EndIf
        EndIf
        If Agent_GetAgentInfo(-2, "X") = 0 Or _Char_IsReallyDead() Then
            Out("[Combat] Char dead/zero pre-cast iter=" & $iter & " -> abort")
            Return False
        EndIf
        Local $oldAlive = False
        If $enemy <> 0 And Agent_GetAgentInfo($enemy, "HP") > 0 Then
            Local $oldDist = Agent_GetDistance(-2, $enemy)
            If $oldDist <= $range Then $oldAlive = True
        EndIf
        If Not $oldAlive Then
            $enemy = GetNearestEnemy($range)
            If $enemy = 0 Then
                Out("[Combat] Zona limpia tras " & Round(TimerDiff($t)/1000, 1) & "s iters=" & $iter)
                Return True
            EndIf
            If $g_sCombatPriorityModels <> "" Then
                Local $pRe = _Combat_FindByModelList($range, $g_sCombatPriorityModels)
                If $pRe <> 0 Then $enemy = $pRe
            EndIf
        EndIf
        Agent_Attack($enemy, False)
        $msWalk = TimerDiff($tSeg)
        $tSeg = TimerInit()
        $g_bUAIFightActive = True
        Combat_CastNextReady($enemy)
        $g_bUAIFightActive = False
        $msCast = TimerDiff($tSeg)
        If TimerDiff($tIter) > 4000 Then
            Out("[Combat-perf] iter=" & $iter & " total=" & Round(TimerDiff($tIter)) & "ms near=" & Round($msNear) & " pri=" & Round($msPri) & " mark=" & Round($msMark) & " walk=" & Round($msWalk) & " cast=" & Round($msCast))
        EndIf
        Sleep(250)
    WEnd
    Out("[Combat] TIMEOUT " & Round($timeoutMs/1000, 0) & "s sin limpiar zona iters=" & $iter)
    Return False
EndFunc
Func NavFight_MoveKill($aX, $aY, $aTol = 400, $aggroRange = 1500, $timeoutMs = 120000, $aT = "[NavFight] ")
    Out($aT & "MoveKill -> (" & Round($aX) & "," & Round($aY) & ") tol=" & $aTol & " aggro=" & $aggroRange & " timeout=" & Round($timeoutMs/1000) & "s")
    Local $tStart = TimerInit()
    Local $tReport = TimerInit() - 99000
    Local $tReattack = TimerInit()
    Local $lastTarget = 0
    Local $prevX = Agent_GetAgentInfo(-2, "X"), $prevY = Agent_GetAgentInfo(-2, "Y")
    Local $stuckMs = 0, $stuckSide = 1
    Local $inCombat = False  
    Local $tMoveOnly = TimerInit()  
    Local $wasInCombat = False
    While TimerDiff($tMoveOnly) < $timeoutMs
        If Bot_ShouldStop() Then Return False
        If Map_GetMapID() = 0 Or Map_GetInstanceInfo("IsLoading") Then
            Sleep(1200)
            ContinueLoop
        EndIf
        Cinematic_ProtectStep()
        If Party_GetPartyContextInfo("IsDefeated") Then
            Out($aT & "WIPE -> abort MoveKill")
            Return False
        EndIf
        If Map_GetInstanceInfo("Type") = $GC_I_MAP_TYPE_OUTPOST Then
            Out($aT & "OUTPOST detectado -> abort MoveKill (wipe recover?)")
            Return False
        EndIf
        If Agent_GetAgentInfo(-2, "IsDead") Then
            Sleep(3000)
            ContinueLoop
        EndIf
        PartyRecovery_Tick()
        Local $cx = Agent_GetAgentInfo(-2, "X"), $cy = Agent_GetAgentInfo(-2, "Y")
        Local $dist = Sqrt(($aX - $cx)^2 + ($aY - $cy)^2)
        If $dist < $aTol Then
            Local $tArrive = TimerInit()
            While TimerDiff($tArrive) < 3000
                Local $nearEnemy = GetNearestEnemy(2000)
                If $nearEnemy <> 0 Then ExitLoop
                Sleep(250)
            WEnd
            If $nearEnemy = 0 Then
                Out($aT & "DESTINO ALCANZADO d=" & Round($dist) & "u tras " & Round(TimerDiff($tStart)/1000, 1) & "s")
                Return True
            EndIf
            Local $arriveDist = Agent_GetDistance(-2, $nearEnemy)
            If $arriveDist > $aggroRange Then
                Out($aT & "DESTINO ALCANZADO d=" & Round($dist) & "u (enemigo a " & Round($arriveDist) & "u, fuera de aggro) -> avanzar")
                Return True
            EndIf
        EndIf
        If TimerDiff($tReport) > 8000 Then
            Out($aT & "nav d=" & Round($dist) & "u pos=(" & Round($cx) & "," & Round($cy) & ") t=" & Round(TimerDiff($tStart)/1000, 1) & "s")
            $tReport = TimerInit()
        EndIf
        Local $enemy = GetNearestEnemy($aggroRange)
        If $enemy <> 0 Then
            $inCombat = True
            Local $needNewTarget = True
            If $lastTarget <> 0 And Agent_GetAgentInfo($lastTarget, "HP") > 0 And Not Agent_GetAgentInfo($lastTarget, "IsDead") Then
                Local $std = Agent_GetDistance(-2, $lastTarget)
                If $std < $aggroRange And ($g_iCombatStickyCap = 0 Or $std <= $g_iCombatStickyCap) Then
                    $enemy = $lastTarget
                    $needNewTarget = False
                EndIf
            EndIf
            Local $priEnemy = 0
            Local $prioR = $aggroRange
            If $g_iCombatPriorityCap > 0 And $g_iCombatPriorityCap < $prioR Then $prioR = $g_iCombatPriorityCap
            If $g_bCombatPriorityGenerals Then $priEnemy = _Combat_FindByGeneralName($prioR)
            If $priEnemy = 0 And $g_sCombatPriorityModels <> "" Then $priEnemy = _Combat_FindByModelList($prioR, $g_sCombatPriorityModels)
            If $priEnemy = 0 And $g_bCombatPriorityClerics Then $priEnemy = _Combat_FindByProfession($GC_I_PROFESSION_MONK, $prioR)
            If $priEnemy = 0 And $g_bCombatPrioritySorcerers Then $priEnemy = _Combat_FindByProfession($GC_I_PROFESSION_ELEMENTALIST, $prioR)
            If $priEnemy <> 0 Then $enemy = $priEnemy
            If $enemy <> $lastTarget Then
                Agent_ChangeTarget($enemy)
                Sleep(100)
                Agent_CallTarget($enemy)
                Sleep(100)
                Agent_Attack($enemy, False)
                Sleep(100)
                $lastTarget = $enemy
                $tReattack = TimerInit()
            ElseIf TimerDiff($tReattack) > 2000 Then
                Agent_Attack($enemy, False)
                $tReattack = TimerInit()
            EndIf
            Local $ecx = Agent_GetAgentInfo(-2, "X"), $ecy = Agent_GetAgentInfo(-2, "Y")
            Local $eex = Agent_GetAgentInfo($enemy, "X"), $eey = Agent_GetAgentInfo($enemy, "Y")
            If $eex <> 0 Then
                Local $eDist = Sqrt(($eex - $ecx)^2 + ($eey - $ecy)^2)
                If $eDist > 800 Then
                    _Combat_MapMove($eex, $eey, 0)
                EndIf
            EndIf
            $g_bUAIFightActive = True
            Combat_CastNextReady($enemy)
            $g_bUAIFightActive = False
            Sleep(250)
        Else
            If $inCombat Then
                $tMoveOnly = TimerInit()
                $inCombat = False
            EndIf
            $lastTarget = 0  
            If $g_PR_CastLock Then
                Sleep(500)
            Else
                Local $deadCount = 0
                Local $paid = 0
                For $pi = 1 To 8
                    $paid = Party_GetMyPartyHeroInfo($pi, "AgentID")
                    If $paid <> 0 And Agent_GetAgentInfo($paid, "IsDead") Then $deadCount += 1
                Next
                For $pi = 1 To 4
                    $paid = Party_GetMyPartyHenchmanInfo($pi, "AgentID")
                    If $paid <> 0 And Agent_GetAgentInfo($paid, "IsDead") Then $deadCount += 1
                Next
                If $deadCount > 0 Then
                    If TimerDiff($tReport) > 5000 Then
                        Out($aT & "ESPERANDO party (" & $deadCount & " muertos) d=" & Round($dist) & "u")
                        $tReport = TimerInit()
                    EndIf
                    Sleep(500)
                Else
                    _Combat_MapMove($aX, $aY, 0)
                    Local $nx = Agent_GetAgentInfo(-2, "X"), $ny = Agent_GetAgentInfo(-2, "Y")
                    Local $prog = Sqrt(($nx - $prevX)^2 + ($ny - $prevY)^2)
                    If $prog < 50 Then
                        $stuckMs += 250
                        If $stuckMs > 4000 Then
                            Local $wdx = $aX - $nx, $wdy = $aY - $ny
                            Local $wdl = Sqrt($wdx * $wdx + $wdy * $wdy)
                            If $wdl < 1 Then $wdl = 1
                            $stuckSide = -$stuckSide
                            _Combat_MapMove($nx - ($wdy / $wdl) * 600 * $stuckSide + ($wdx / $wdl) * 200, _
                                             $ny + ($wdx / $wdl) * 600 * $stuckSide + ($wdy / $wdl) * 200, 0)
                            Sleep(1500)
                            _Combat_MapMove($aX, $aY, 0)
                            $stuckMs = 0
                        EndIf
                    Else
                        $stuckMs = 0
                    EndIf
                    $prevX = $nx
                    $prevY = $ny
                EndIf
            EndIf
            Sleep(250)
        EndIf
    WEnd
    Out($aT & "TIMEOUT (sin mover " & Round($timeoutMs/1000, 0) & "s) -> abort MoveKill")
    Return False
EndFunc
Func Combat_KillBoss($modelID, $range = 1500, $timeoutMs = 45000, $fightRange1 = 2000, $fightRange2 = 3500)
    Out("[Combat] KillBoss model=" & $modelID & " range=" & $range & "u timeout=" & Round($timeoutMs/1000, 0) & "s")
    Local $t = TimerInit()
    Local $stateTimer = TimerInit()
    Local $iter = 0
    While TimerDiff($t) < $timeoutMs
        $iter += 1
        If Bot_ShouldStop() Then Return False
        If Recovery_IsAtZero() Then Return False
        Cinematic_ProtectStep()
        Local $boss = _Combat_FindByModel($modelID, $range)
        If $boss = 0 Then
            Out("[Combat] Boss model=" & $modelID & " no detectado en " & $range & "u (GetNearestEnemy=0) -> Return True")
            Return True
        EndIf
        If Agent_GetAgentInfo($boss, "IsDead") Then
            Out("[Combat] BOSS KILL id=" & $boss & " model=" & $modelID & " tiempo=" & Round(TimerDiff($t)/1000, 1) & "s")
            Return True
        EndIf
        If TimerDiff($stateTimer) > 2000 Then
            Local $eHP = Round(Agent_GetAgentInfo($boss, "HP")*100, 0)
            Local $cHP = Round(Agent_GetAgentInfo(-2, "HP")*100, 0)
            Local $dist = Agent_GetDistance(-2, $boss)
            Out("[Combat] t=" & Round(TimerDiff($t)/1000, 1) & "s i=" & $iter & " BOSS id=" & $boss & " dist=" & Round($dist, 0) & " eHP=" & $eHP & "% cHP=" & $cHP & "%")
            $stateTimer = TimerInit()
        EndIf
        Agent_ChangeTarget($boss)
        Sleep(100)
        Agent_CallTarget($boss)
        Sleep(100)
        Agent_Attack($boss, False)
        Sleep(100)
        If Agent_GetAgentInfo(-2, "X") = 0 Or _Char_IsReallyDead() Then
            Out("[Combat] KillBoss: char dead/zero pre-cast iter=" & $iter & " -> abort")
            Return False
        EndIf
        $g_bUAIFightActive = True
        Combat_CastNextReady($boss)
        $g_bUAIFightActive = False
        Sleep(500)
    WEnd
    Out("[Combat] TIMEOUT boss model=" & $modelID & " no killed iters=" & $iter)
    Return False
EndFunc
Global $g_iLastMarkedEnemy = 0
Global $g_hMarkTimer = 0          
Global $g_bMarkCallbackDisabled = False   
Func _MarkEnemiesCallback()
    If $g_bMarkCallbackDisabled Then Return
    If $g_sPendingAction = "HoningYourSkills" Or $g_currentPhase = "HoningYourSkills" Then Return
    If $g_hMarkTimer = 0 Then
        $g_hMarkTimer = TimerInit()
    ElseIf TimerDiff($g_hMarkTimer) < 800 Then
        Return
    EndIf
    $g_hMarkTimer = TimerInit()
    If Map_GetMapID() = 0 Then Return
    If Map_GetInstanceInfo("IsLoading") Then Return
    If Agent_GetAgentInfo(-2, "MaxHP") = 0 Then Return
    Local $charX = Agent_GetAgentInfo(-2, "X")
    Local $charY = Agent_GetAgentInfo(-2, "Y")
    If $charX = 0 And $charY = 0 Then
        $g_iLastMarkedEnemy = 0
        Return
    EndIf
    If Agent_GetAgentInfo(-2, "IsDead") Then
        $g_iLastMarkedEnemy = 0
        Return
    EndIf
    Local $markRange = 1300
    If $g_sPendingAction = "M02_JokanurDiggings" Or $g_currentPhase = "M02_JokanurDiggings" Then
        $markRange = 900
    EndIf
    Local $enemy = 0
    If $g_bCombatPriorityGenerals Then $enemy = _Combat_FindByGeneralName($markRange)
    If $enemy = 0 Then $enemy = GetNearestEnemy($markRange)
    If $enemy = 0 Then
        $g_iLastMarkedEnemy = 0
        Return
    EndIf
    If $enemy = $g_iLastMarkedEnemy Then Return
    Agent_CallTarget($enemy)
    $g_iLastMarkedEnemy = $enemy
EndFunc
Func Combat_KillSingle($enemyID, $timeoutMs = 10000, $fightRange1 = 2000, $fightRange2 = 3500)
    If $enemyID = 0 Then Return False
    Local $eHPstart = Agent_GetAgentInfo($enemyID, "HP")
    Out("[Combat] KillSingle id=" & $enemyID & " HP=" & Round($eHPstart*100, 0) & "% timeout=" & Round($timeoutMs/1000, 0) & "s range1=" & $fightRange1 & " range2=" & $fightRange2)
    Local $t = TimerInit()
    While TimerDiff($t) < $timeoutMs
        If Bot_ShouldStop() Then Return False
        If Recovery_IsAtZero() Then Return False
        If Agent_GetAgentInfo($enemyID, "IsDead") Or Agent_GetAgentInfo($enemyID, "HP") <= 0 Then
            Out("[Combat] KillSingle OK: id=" & $enemyID & " muerto tras " & Round(TimerDiff($t)/1000, 1) & "s")
            Return True
        EndIf
        Agent_ChangeTarget($enemyID)
        Sleep(100)
        Agent_CallTarget($enemyID)
        Sleep(100)
        Agent_Attack($enemyID, False)
        Sleep(100)
        If Agent_GetAgentInfo(-2, "X") = 0 Or _Char_IsReallyDead() Then
            Out("[Combat] KillSingle: char dead/zero -> abort")
            Return False
        EndIf
        $g_bUAIFightActive = True
        Combat_CastNextReady($enemyID)
        $g_bUAIFightActive = False
        Sleep(500)
    WEnd
    Out("[Combat] KillSingle TIMEOUT: id=" & $enemyID & " HP=" & Round(Agent_GetAgentInfo($enemyID, "HP")*100, 0) & "%")
    Return False
EndFunc
Func Combat_AnyEnemyNear($range = 500)
    Local $agents = _Combat_LivingArray()
    If Not IsArray($agents) Or $agents[0] = 0 Then Return 0
    Local $myX = Agent_GetAgentInfo(-2, "X")
    Local $myY = Agent_GetAgentInfo(-2, "Y")
    For $i = 1 To $agents[0]
        Local $ptr = $agents[$i]
        If $ptr = 0 Then ContinueLoop
        If Agent_GetAgentInfo($ptr, "Allegiance") <> $GC_I_ALLEGIANCE_ENEMY Then ContinueLoop
        If Agent_GetAgentInfo($ptr, "HP") <= 0 Then ContinueLoop
        If Agent_GetAgentInfo($ptr, "IsDead") > 0 Then ContinueLoop
        If _Combat_IsSpirit($ptr, Agent_GetAgentInfo($ptr, "Name")) Then ContinueLoop
        If _Combat_IsIgnoredModel(Agent_GetAgentInfo($ptr, "PlayerNumber")) Then ContinueLoop
        Local $aX = Agent_GetAgentInfo($ptr, "X")
        Local $aY = Agent_GetAgentInfo($ptr, "Y")
        Local $dist = Sqrt(($aX - $myX)^2 + ($aY - $myY)^2)
        If $dist <= $range Then Return Agent_GetAgentInfo($ptr, "ID")
    Next
    Return 0
EndFunc
Func _Combat_AgentAliveInRange($id, $range)
    If $id = 0 Then Return False
    Local $agents = _Combat_LivingArray()
    If Not IsArray($agents) Or $agents[0] = 0 Then Return False
    Local $myX = Agent_GetAgentInfo(-2, "X")
    Local $myY = Agent_GetAgentInfo(-2, "Y")
    For $i = 1 To $agents[0]
        Local $ptr = $agents[$i]
        If $ptr = 0 Then ContinueLoop
        If Agent_GetAgentInfo($ptr, "ID") <> $id Then ContinueLoop
        If Agent_GetAgentInfo($ptr, "Allegiance") <> $GC_I_ALLEGIANCE_ENEMY Then Return False
        If Agent_GetAgentInfo($ptr, "HP") <= 0 Then Return False
        If Agent_GetAgentInfo($ptr, "IsDead") > 0 Then Return False
        If _Combat_IsSpirit($ptr, Agent_GetAgentInfo($ptr, "Name")) Then Return False
        Local $aX = Agent_GetAgentInfo($ptr, "X")
        Local $aY = Agent_GetAgentInfo($ptr, "Y")
        If Sqrt(($aX - $myX)^2 + ($aY - $myY)^2) > $range Then Return False
        Return True
    Next
    Return False
EndFunc
Func _Combat_ScanAll($range, $prRange, $csvModels, $stickyId, ByRef $oNear, ByRef $oPri, ByRef $oStickyAlive, ByRef $oSearchCleric, ByRef $oSearchSorc, ByRef $oStickyPri, ByRef $oNearDist)
    $oNear = 0
    $oPri = 0
    $oStickyAlive = False
    $oSearchCleric = 0
    $oSearchSorc = 0
    $oStickyPri = False
    $oNearDist = $range
    Local $agents = _Combat_LivingArray()
    If Not IsArray($agents) Or $agents[0] = 0 Then Return
    Local $myX = Agent_GetAgentInfo(-2, "X")
    Local $myY = Agent_GetAgentInfo(-2, "Y")
    Local $aPri[1], $nPri = 0
    If $csvModels <> "" Then
        Local $tmpP = StringSplit($csvModels, ",", 2)
        $nPri = UBound($tmpP)
    EndIf
    Local $bestN = $range, $priRank = 999999, $bestPD = $prRange
    Local $bestCD = $g_iCombatClericsRange, $bestSD = $range
    Local $maxScanDist = ($prRange > $range) ? $prRange : $range
    For $i = 1 To $agents[0]
        Local $ptr = $agents[$i]
        If $ptr = 0 Then ContinueLoop
        Local $aX = Agent_GetAgentInfo($ptr, "X")
        Local $aY = Agent_GetAgentInfo($ptr, "Y")
        Local $dist = Sqrt(($aX - $myX) ^ 2 + ($aY - $myY) ^ 2)
        If $dist > $maxScanDist Then ContinueLoop
        If Agent_GetAgentInfo($ptr, "Allegiance") <> $GC_I_ALLEGIANCE_ENEMY Then ContinueLoop
        If Agent_GetAgentInfo($ptr, "HP") <= 0 Then ContinueLoop
        If Agent_GetAgentInfo($ptr, "IsDead") > 0 Then ContinueLoop
        Local $name = Agent_GetAgentInfo($ptr, "Name")
        If _Combat_IsSpirit($ptr, $name) Then ContinueLoop
        If _Combat_IsMinion($ptr, $name) Then ContinueLoop
        Local $model = Agent_GetAgentInfo($ptr, "PlayerNumber")
        If _Combat_IsRangerPet($model) Then ContinueLoop
        If _Combat_IsIgnoredModel($model) Then ContinueLoop
        Local $id = Agent_GetAgentInfo($ptr, "ID")
        Local $isStickyAgent = ($stickyId <> 0 And $id = $stickyId)
        If $isStickyAgent And $dist <= $range Then $oStickyAlive = True
        If $g_bCombatPriorityClerics And $dist <= $g_iCombatClericsRange And StringInStr($name, "Cleric") Then
            If $dist < $bestCD Then
                $bestCD = $dist
                $oSearchCleric = $id
                If $isStickyAgent Then $oStickyPri = True
            EndIf
        EndIf
        If $g_bCombatPrioritySorcerers And $dist <= $range And (StringInStr($name, "Sorcerer") Or StringInStr($name, "Elementalist")) Then
            If $dist < $bestSD Then
                $bestSD = $dist
                $oSearchSorc = $id
                If $isStickyAgent Then $oStickyPri = True
            EndIf
        EndIf
        If $dist < $bestN Then
            $bestN = $dist
            $oNear = $id
        EndIf
        If $nPri > 0 And $dist <= $prRange Then
            Local $isPri = False
            For $k = 0 To $nPri - 1
                If Number($tmpP[$k]) = $model Then
                    If $k < $priRank Or ($k = $priRank And $dist < $bestPD) Then
                        $priRank = $k
                        $bestPD = $dist
                        $oPri = $id
                    EndIf
                    $isPri = True
                    If $isStickyAgent Then $oStickyPri = True
                    ExitLoop
                EndIf
            Next
            If Not $isPri Then
                Local $mID2 = Agent_GetAgentInfo($ptr, "ModelID")
                For $k = 0 To $nPri - 1
                    If Number($tmpP[$k]) = $mID2 Then
                        If $k < $priRank Or ($k = $priRank And $dist < $bestPD) Then
                            $priRank = $k
                            $bestPD = $dist
                            $oPri = $id
                        EndIf
                        If $isStickyAgent Then $oStickyPri = True
                        ExitLoop
                    EndIf
                Next
            EndIf
        EndIf
    Next
    $oNearDist = $bestN
EndFunc
Func _Combat_FindByModel($modelID, $range)
    Local $agents = _Combat_LivingArray()
    If Not IsArray($agents) Or $agents[0] = 0 Then Return 0
    Local $myX = Agent_GetAgentInfo(-2, "X")
    Local $myY = Agent_GetAgentInfo(-2, "Y")
    Local $bestId = 0
    Local $bestDist = $range
    For $i = 1 To $agents[0]
        Local $ptr = $agents[$i]
        If $ptr = 0 Then ContinueLoop
        If Agent_GetAgentInfo($ptr, "Allegiance") <> $GC_I_ALLEGIANCE_ENEMY Then ContinueLoop
        If Agent_GetAgentInfo($ptr, "HP") <= 0 Then ContinueLoop
        If Agent_GetAgentInfo($ptr, "IsDead") > 0 Then ContinueLoop
        If _Combat_IsSpirit($ptr) Then ContinueLoop
        If Agent_GetAgentInfo($ptr, "PlayerNumber") <> $modelID Then ContinueLoop
        Local $aX = Agent_GetAgentInfo($ptr, "X")
        Local $aY = Agent_GetAgentInfo($ptr, "Y")
        Local $dist = Sqrt(($aX - $myX)^2 + ($aY - $myY)^2)
        If $dist < $bestDist Then
            $bestDist = $dist
            $bestId = Agent_GetAgentInfo($ptr, "ID")
        EndIf
    Next
    Return $bestId
EndFunc
Func _Combat_FindByModelList($range, $aModelList)
    If $aModelList = "" Then Return 0
    Local $models = StringSplit($aModelList, ",", 2)
    Local $agents = _Combat_LivingArray()
    If Not IsArray($agents) Or $agents[0] = 0 Then Return 0
    Local $myX = Agent_GetAgentInfo(-2, "X")
    Local $myY = Agent_GetAgentInfo(-2, "Y")
    Local $bestId = 0, $bestDist = $range
    For $i = 1 To $agents[0]
        Local $ptr = $agents[$i]
        If $ptr = 0 Then ContinueLoop
        If Agent_GetAgentInfo($ptr, "Allegiance") <> $GC_I_ALLEGIANCE_ENEMY Then ContinueLoop
        If Agent_GetAgentInfo($ptr, "HP") <= 0 Then ContinueLoop
        If Agent_GetAgentInfo($ptr, "IsDead") > 0 Then ContinueLoop
        If _Combat_IsSpirit($ptr) Then ContinueLoop
        Local $mn = Agent_GetAgentInfo($ptr, "PlayerNumber")
        Local $match = False
        For $m = 0 To UBound($models) - 1
            If Number($models[$m]) = $mn Then $match = True
        Next
        If Not $match Then
            Local $mnID = Agent_GetAgentInfo($ptr, "ModelID")
            For $m = 0 To UBound($models) - 1
                If Number($models[$m]) = $mnID Then $match = True
            Next
        EndIf
        If Not $match Then ContinueLoop
        Local $aX = Agent_GetAgentInfo($ptr, "X")
        Local $aY = Agent_GetAgentInfo($ptr, "Y")
        Local $dist = Sqrt(($aX - $myX)^2 + ($aY - $myY)^2)
        If $dist < $bestDist Then
            $bestDist = $dist
            $bestId = Agent_GetAgentInfo($ptr, "ID")
        EndIf
    Next
    Return $bestId
EndFunc
Func _Combat_FindByProfession($prof, $range)
    Local $agents = _Combat_LivingArray()
    If Not IsArray($agents) Or $agents[0] = 0 Then Return 0
    Local $myX = Agent_GetAgentInfo(-2, "X")
    Local $myY = Agent_GetAgentInfo(-2, "Y")
    Local $bestId = 0
    Local $bestDist = $range
    For $i = 1 To $agents[0]
        Local $ptr = $agents[$i]
        If $ptr = 0 Then ContinueLoop
        If Agent_GetAgentInfo($ptr, "Allegiance") <> $GC_I_ALLEGIANCE_ENEMY Then ContinueLoop
        If Agent_GetAgentInfo($ptr, "HP") <= 0 Then ContinueLoop
        If Agent_GetAgentInfo($ptr, "IsDead") > 0 Then ContinueLoop
        If _Combat_IsSpirit($ptr) Then ContinueLoop
        If _Combat_IsMinion($ptr) Then ContinueLoop
        If _Combat_IsRangerPet(Agent_GetAgentInfo($ptr, "PlayerNumber")) Then ContinueLoop
        If $g_sCombatIgnoreModels <> "" Then
            Local $pnum = Agent_GetAgentInfo($ptr, "PlayerNumber")
            If StringInStr("," & $g_sCombatIgnoreModels & ",", "," & $pnum & ",") Then ContinueLoop
        EndIf
        Local $aid = Agent_GetAgentInfo($ptr, "ID")
        If UAI_GetAgentProfession($aid) <> $prof Then ContinueLoop
        Local $aX = Agent_GetAgentInfo($ptr, "X")
        Local $aY = Agent_GetAgentInfo($ptr, "Y")
        Local $dist = Sqrt(($aX - $myX)^2 + ($aY - $myY)^2)
        If $dist < $bestDist Then
            $bestDist = $dist
            $bestId = $aid
        EndIf
    Next
    Return $bestId
EndFunc
Func _Combat_FindByProfPriority($csvProfs, $range)
    Local $agents = _Combat_LivingArray()
    If Not IsArray($agents) Or $agents[0] = 0 Then Return 0
    Local $prof = StringSplit($csvProfs, ",", 2)
    If Not IsArray($prof) Then Return 0
    Local $myX = Agent_GetAgentInfo(-2, "X")
    Local $myY = Agent_GetAgentInfo(-2, "Y")
    Local $bestId = 0, $bestRank = 999999, $bestDist = $range
    For $i = 1 To $agents[0]
        Local $ptr = $agents[$i]
        If $ptr = 0 Then ContinueLoop
        If Agent_GetAgentInfo($ptr, "Allegiance") <> $GC_I_ALLEGIANCE_ENEMY Then ContinueLoop
        If Agent_GetAgentInfo($ptr, "HP") <= 0 Then ContinueLoop
        If Agent_GetAgentInfo($ptr, "IsDead") > 0 Then ContinueLoop
        If _Combat_IsSpirit($ptr) Then ContinueLoop
        If _Combat_IsMinion($ptr) Then ContinueLoop
        If _Combat_IsRangerPet(Agent_GetAgentInfo($ptr, "PlayerNumber")) Then ContinueLoop
        If $g_sCombatIgnoreModels <> "" Then
            Local $pnum = Agent_GetAgentInfo($ptr, "PlayerNumber")
            If StringInStr("," & $g_sCombatIgnoreModels & ",", "," & $pnum & ",") Then ContinueLoop
        EndIf
        Local $aX = Agent_GetAgentInfo($ptr, "X")
        Local $aY = Agent_GetAgentInfo($ptr, "Y")
        Local $dist = Sqrt(($aX - $myX)^2 + ($aY - $myY)^2)
        If $dist > $range Then ContinueLoop
        Local $aid = Agent_GetAgentInfo($ptr, "ID")
        Local $p = UAI_GetAgentProfession($aid)
        Local $rank = 999998
        For $r = 0 To UBound($prof) - 1
            If Number($prof[$r]) = $p Then
                $rank = $r
                ExitLoop
            EndIf
        Next
        If $rank < $bestRank Or ($rank = $bestRank And $dist < $bestDist) Then
            $bestRank = $rank
            $bestDist = $dist
            $bestId = $aid
        EndIf
    Next
    Return $bestId
EndFunc
Func _Combat_FindByGeneralName($range)
    Local $agents = _Combat_LivingArray()
    If Not IsArray($agents) Or $agents[0] = 0 Then Return 0
    Local $myX = Agent_GetAgentInfo(-2, "X")
    Local $myY = Agent_GetAgentInfo(-2, "Y")
    Local $bestId = 0
    Local $bestDist = $range
    For $i = 1 To $agents[0]
        Local $ptr = $agents[$i]
        If $ptr = 0 Then ContinueLoop
        If Agent_GetAgentInfo($ptr, "Allegiance") <> $GC_I_ALLEGIANCE_ENEMY Then ContinueLoop
        If Agent_GetAgentInfo($ptr, "HP") <= 0 Then ContinueLoop
        If Agent_GetAgentInfo($ptr, "IsDead") > 0 Then ContinueLoop
        If _Combat_IsSpirit($ptr) Then ContinueLoop
        If _Combat_IsMinion($ptr) Then ContinueLoop
        If _Combat_IsRangerPet(Agent_GetAgentInfo($ptr, "PlayerNumber")) Then ContinueLoop
        If _Combat_IsIgnoredModel(Agent_GetAgentInfo($ptr, "PlayerNumber")) Then ContinueLoop
        Local $name = Agent_GetAgentInfo($ptr, "Name")
        If Not StringInStr($name, "General") Then ContinueLoop
        Local $aX = Agent_GetAgentInfo($ptr, "X")
        Local $aY = Agent_GetAgentInfo($ptr, "Y")
        Local $dist = Sqrt(($aX - $myX)^2 + ($aY - $myY)^2)
        If $dist < $bestDist Then
            $bestDist = $dist
            $bestId = Agent_GetAgentInfo($ptr, "ID")
        EndIf
    Next
    Return $bestId
EndFunc
Func _Combat_LogNearbyEnemies($range = 2600)
    Local $agents = _Combat_LivingArray()
    If Not IsArray($agents) Or $agents[0] = 0 Then Return
    Local $myX = Agent_GetAgentInfo(-2, "X")
    Local $myY = Agent_GetAgentInfo(-2, "Y")
    Local $n = 0
    For $i = 1 To $agents[0]
        Local $ptr = $agents[$i]
        If $ptr = 0 Then ContinueLoop
        If Agent_GetAgentInfo($ptr, "Allegiance") <> $GC_I_ALLEGIANCE_ENEMY Then ContinueLoop
        If Agent_GetAgentInfo($ptr, "HP") <= 0 Then ContinueLoop
        Local $aX = Agent_GetAgentInfo($ptr, "X")
        Local $aY = Agent_GetAgentInfo($ptr, "Y")
        Local $d = Sqrt(($aX - $myX)^2 + ($aY - $myY)^2)
        If $d > $range Then ContinueLoop
        Out("[EnemyDump] model=" & Agent_GetAgentInfo($ptr, "PlayerNumber") & " name='" & Agent_GetAgentInfo($ptr, "Name") & "' d=" & Round($d) & " hp=" & Round(Agent_GetAgentInfo($ptr, "HP") * 100) & "%")
        $n += 1
        If $n >= 14 Then ExitLoop
    Next
EndFunc