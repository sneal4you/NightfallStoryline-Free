#include-once
Func Mission_RunSteps(ByRef $steps, $expectedMapID)
    Local $total = UBound($steps)
    Out("[Mission] RunSteps total=" & $total & " expectedMap=" & $expectedMapID)
    For $i = 0 To $total - 1
        If Bot_ShouldStop() Then Return Bot_AbortClean("STOP solicitado en step " & $i)
        If Recovery_IsOutOfInstance($expectedMapID) Then Return Bot_AbortClean("out-of-instance en step " & $i)
        Cinematic_ProtectStep()
        Local $kind = $steps[$i][0]
        Local $x = $steps[$i][1]
        Local $y = $steps[$i][2]
        Local $label = $steps[$i][3]
        Local $agentID = $steps[$i][4]
        Out("[Mission] Step " & ($i+1) & "/" & $total & ": " & $kind & " (" & $x & "," & $y & ") " & $label)
        Local $stepStart = TimerInit()
        Switch $kind
            Case "nav_combat"
                If Not _Mission_DoNavCombat($x, $y) Then
                    Out("[Mission] nav_combat fail -> esperar rez y reintentar step " & ($i+1))
                    If _Mission_WaitForRevive(12000) Then
                        If Not _Mission_DoNavCombat($x, $y) Then Return Bot_AbortClean("nav_combat fail (2 intentos) en " & $label)
                    Else
                        Return Bot_AbortClean("nav_combat fail + no rez en " & $label)
                    EndIf
                EndIf
            Case "nav_kill"
                If Not _Mission_DoNavKill($x, $y) Then
                    Out("[Mission] nav_kill fail -> esperar rez y reintentar step " & ($i+1))
                    If _Mission_WaitForRevive(12000) Then
                        If Not _Mission_DoNavKill($x, $y) Then Return Bot_AbortClean("nav_kill fail (2 intentos) en " & $label)
                    Else
                        Return Bot_AbortClean("nav_kill fail + no rez en " & $label)
                    EndIf
                EndIf
            Case "nav_kill_far"
                If Not _Mission_DoNavKill($x, $y, 5000) Then
                    Out("[Mission] nav_kill_far fail -> esperar rez y reintentar step " & ($i+1))
                    If _Mission_WaitForRevive(12000) Then
                        If Not _Mission_DoNavKill($x, $y, 5000) Then Return Bot_AbortClean("nav_kill_far fail (2 intentos) en " & $label)
                    Else
                        Return Bot_AbortClean("nav_kill_far fail + no rez en " & $label)
                    EndIf
                EndIf
            Case "nav_only"
                If Not _Mission_DoNavOnly($x, $y) Then Return Bot_AbortClean("nav_only fail en " & $label)
            Case "nav_dialog"
                If Not _Mission_DoNavOnly($x, $y) Then Return Bot_AbortClean("nav previo a dialog fail en " & $label)
                Sleep(1500)
                _Mission_DoDialog($agentID, $x, $y, $label)
            Case "gadget_pickup"
                If Not _Mission_DoNavOnly($x, $y) Then Return Bot_AbortClean("nav previo a pickup fail en " & $label)
                Sleep(1500)
                If Not Gadget_Pickup($agentID) Then Return Bot_AbortClean("gadget_pickup fail en " & $label)
            Case "gadget_load"
                If Not _Mission_DoNavOnly($x, $y) Then Return Bot_AbortClean("nav previo a load fail en " & $label)
                Sleep(1500)
                If Not Gadget_LoadCatapult($agentID) Then Return Bot_AbortClean("gadget_load fail en " & $label)
            Case "gadget_fire"
                If Not Gadget_FireCatapult() Then Return Bot_AbortClean("gadget_fire fail en " & $label)
            Case "wait_cinematic"
                Cinematic_WaitAndSkip(20000, 30000)
            Case "stop"
                Out("[Mission] Step stop alcanzado. Mission terminada.")
                ExitLoop
            Case Else
                Out("[Mission] Step kind desconocido: '" & $kind & "' — skip")
        EndSwitch
        Out("[Mission] Step " & ($i+1) & "/" & $total & " OK (" & Round(TimerDiff($stepStart)/1000, 1) & "s)")
    Next
    Out("[Mission] Todos los steps completados")
    Return True
EndFunc
Func _Mission_DoNavCombat($x, $y)
    GameEvents_ResetStuck()   
    Local $myXpre = Agent_GetAgentInfo(-2, "X")
    Local $myYpre = Agent_GetAgentInfo(-2, "Y")
    Local $dist = Sqrt(($x - $myXpre)^2 + ($y - $myYpre)^2)
    Local $mapIDPre = Map_GetMapID()
    Out("[Mission/nav_combat] PRE char=(" & Round($myXpre, 0) & "," & Round($myYpre, 0) & ") -> (" & $x & "," & $y & ") dist=" & Round($dist, 0))
    $g_LootNavLock = True   
    Local $iDeathCountPre = $g_GE_DeathCount   
    Local $tNav = TimerInit()
    If $dist > 3500 Then
        Local $segG = 0, $segStall = 0
        While Not Bot_ShouldStop() And $segG < 20
            $segG += 1
            Local $sgx = Agent_GetAgentInfo(-2, "X"), $sgy = Agent_GetAgentInfo(-2, "Y")
            Local $dRem = Sqrt(($x-$sgx)^2 + ($y-$sgy)^2)
            If $dRem <= 2500 Then ExitLoop
            Local $itX = $sgx + ($x-$sgx)*2500/$dRem, $itY = $sgy + ($y-$sgy)*2500/$dRem
            MoveToFollowPath_Smooth($itX, $itY, 1200)
            If GetNearestEnemy(1400) <> 0 Then Combat_ClearZone(1400, 12000)
            Local $agx = Agent_GetAgentInfo(-2, "X"), $agy = Agent_GetAgentInfo(-2, "Y")
            If Sqrt(($agx-$sgx)^2+($agy-$sgy)^2) < 250 Then
                MoveToFollowPath_Smooth($itX, $itY, 400)   
                $segStall += 1
                If $segStall >= 3 Then ExitLoop   
            Else
                $segStall = 0
            EndIf
            If Map_GetMapID() <> $mapIDPre Or $g_GE_DeathCount > $iDeathCountPre Then ExitLoop
        WEnd
    EndIf
    Local $nudX = Agent_GetAgentInfo(-2, "X"), $nudY = Agent_GetAgentInfo(-2, "Y")
    Local $mapNow = Map_GetMapID()
    If $mapNow = 545 And $dist > 2000 Then
        Out("[Mission/nav_combat] outpost 545: MoveToFollowPath_Smooth directo al destino (sin waypoint)")
        MoveToFollowPath_Smooth($x, $y, 800)
        $nudX = Agent_GetAgentInfo(-2, "X")
        $nudY = Agent_GetAgentInfo(-2, "Y")
        $dist = Sqrt(($x - $nudX)^2 + ($y - $nudY)^2)
        If $dist < 400 Then
            Out("[Mission/nav_combat] outpost 545: llegado tras MoveToFollowPath_Smooth (dist=" & Round($dist) & ")")
            Return True
        EndIf
    EndIf
    Map_Move($x, $y)
    Sleep(5000)
    Local $nudX2 = Agent_GetAgentInfo(-2, "X"), $nudY2 = Agent_GetAgentInfo(-2, "Y")
    Local $nudDistInit = Sqrt(($x - $nudX2)^2 + ($y - $nudY2)^2)
    Local $nudMovedInit = Sqrt(($nudX2 - $nudX)^2 + ($nudY2 - $nudY)^2)
    If $nudMovedInit < 200 And $nudDistInit > 500 Then
        Out("[Mission/nav_combat] Map_Move sin progreso; fallback MoveToFollowPath_Smooth")
        MoveToFollowPath_Smooth($x, $y, 400)
        Sleep(500)
        $nudX2 = Agent_GetAgentInfo(-2, "X")
        $nudY2 = Agent_GetAgentInfo(-2, "Y")
        $nudDistInit = Sqrt(($x - $nudX2)^2 + ($y - $nudY2)^2)
    EndIf
    Local $nudTries = 0, $nudIdx = 0
    Local $nudMaxTries = 10
    While Not Bot_ShouldStop() And $nudTries < $nudMaxTries
        $nudX2 = Agent_GetAgentInfo(-2, "X")
        $nudY2 = Agent_GetAgentInfo(-2, "Y")
        Local $nudMoved = Sqrt(($nudX2 - $nudX)^2 + ($nudY2 - $nudY)^2)
        Local $nudDist = Sqrt(($x - $nudX2)^2 + ($y - $nudY2)^2)
        If $nudDist < 500 Then ExitLoop
        If $nudMoved < 100 Then
            $nudTries += 1
            $nudIdx = Mod($nudIdx + 1, 8)
            Local $ndx = ($x - $nudX2) / $nudDist, $ndy = ($y - $nudY2) / $nudDist
            Local $npx, $npy
            Switch $nudIdx
                Case 0
                    $npx = -$ndy
                    $npy = $ndx
                Case 1
                    $npx = (-$ndy + $ndx) * 0.707
                    $npy = ($ndx + $ndy) * 0.707
                Case 2
                    $npx = $ndx
                    $npy = $ndy
                Case 3
                    $npx = ($ndy + $ndx) * 0.707
                    $npy = (-$ndx + $ndy) * 0.707
                Case 4
                    $npx = $ndy
                    $npy = -$ndx
                Case 5
                    $npx = ($ndy - $ndx) * 0.707
                    $npy = (-$ndx - $ndy) * 0.707
                Case 6
                    $npx = -$ndx
                    $npy = -$ndy
                Case 7
                    $npx = (-$ndy - $ndx) * 0.707
                    $npy = ($ndx - $ndy) * 0.707
            EndSwitch
            Local $nnx = $nudX2 + $npx * 3000, $nny = $nudY2 + $npy * 3000
            Out("[Mission/nav_combat] atasco (mov=" & Round($nudMoved) & ") -> nudge #" & $nudIdx & " dir=(" & Round($npx*100) & "%," & Round($npy*100) & "%)")
            Map_Move($nnx, $nny)
            Local $nudWait = TimerInit()
            While Not Bot_ShouldStop() And TimerDiff($nudWait) < 15000
                Local $nudX3 = Agent_GetAgentInfo(-2, "X"), $nudY3 = Agent_GetAgentInfo(-2, "Y")
                Local $nudDist3 = Sqrt(($nnx - $nudX3)^2 + ($nny - $nudY3)^2)
                If $nudDist3 < 300 Then ExitLoop
                If Mod(Int(TimerDiff($nudWait) / 2000), 2) = 0 And TimerDiff($nudWait) > 2000 Then Map_Move($nnx, $nny)
                Sleep(500)
            WEnd
            Sleep(1000)
        Else
            $nudTries = 0
        EndIf
        $nudX = Agent_GetAgentInfo(-2, "X")
        $nudY = Agent_GetAgentInfo(-2, "Y")
        If Map_GetMapID() <> $mapIDPre Or $g_GE_DeathCount > $iDeathCountPre Then ExitLoop
    WEnd
    Local $navMs = Round(TimerDiff($tNav), 0)
    Local $myXpost = Agent_GetAgentInfo(-2, "X")
    Local $myYpost = Agent_GetAgentInfo(-2, "Y")
    Local $distPost = Sqrt(($x - $myXpost)^2 + ($y - $myYpost)^2)
    Out("[Mission/nav_combat] POST navMs=" & $navMs & " char=(" & Round($myXpost, 0) & "," & Round($myYpost, 0) & ") dist destino=" & Round($distPost, 0))
    Local $mapIDPost = Map_GetMapID()
    If $mapIDPost <> 0 And $mapIDPost <> $mapIDPre Then
        Out("[Mission/nav_combat] Mapa cambio " & $mapIDPre & " -> " & $mapIDPost & " durante nav (cinematic/outro) -> Return True")
        $g_LootNavLock = False
        Return True
    EndIf
    If Recovery_IsAtZero() Or Map_GetInstanceInfo("IsLoading") Or Map_GetMapID() = 0 Then
        Out("[Mission/nav_combat] char en (0,0)/loading/map=0, esperar 5s para confirmar")
        Sleep(5000)
        If Map_GetMapID() = 0 Or Map_GetInstanceInfo("IsLoading") Or Recovery_IsAtZero() Then
            Out("[Mission/nav_combat] map=" & Map_GetMapID() & " loading=" & Map_GetInstanceInfo("IsLoading") & " persiste -> transicion instancia, Return True")
            $g_LootNavLock = False
            Return True
        EndIf
        Out("[Mission/nav_combat] char recupero, seguir con ClearZone")
    EndIf
    If $g_GE_DeathCount > $iDeathCountPre Then
        Out("[Mission/nav_combat] Char murio durante nav (death #" & $g_GE_DeathCount & ") -> abort ClearZone")
        $g_LootNavLock = False
        Return False
    EndIf
    Local $clearOK = Combat_ClearZone(1300, 15000)
    If Not $clearOK Then
        Combat_ClearZone(2500, 5000)
    EndIf
    If Recovery_IsAtZero() Or Agent_GetAgentInfo(-2, "IsDead") Then
        Out("[Mission/nav_combat] Char muerto tras ClearZone -> abort step")
        $g_LootNavLock = False   
        Return False
    EndIf
    GameEvents_ResetStuck()   
    If GetNearestEnemy(2000) = 0 Then
        Local $_lootArr = Agent_GetAgentArray($GC_I_AGENT_TYPE_ITEM)
        If IsArray($_lootArr) And $_lootArr[0] > 0 Then
            Out("[Mission/nav_combat] Recogiendo items del suelo...")
            Loot_PickupNearby(1300)   
            Sleep(1000)
        EndIf
    EndIf
    GameEvents_ResetStuck()   
    _Mission_ReturnToWaypoint($x, $y)   
    $g_LootNavLock = False   
    Return True
EndFunc
Func _Mission_DoNavKill($x, $y, $huntRange = 4500)
    GameEvents_ResetStuck()   
    Local $myXpre = Agent_GetAgentInfo(-2, "X")
    Local $myYpre = Agent_GetAgentInfo(-2, "Y")
    Local $dist = Sqrt(($x - $myXpre)^2 + ($y - $myYpre)^2)
    Out("[Mission/nav_kill] PRE char=(" & Round($myXpre, 0) & "," & Round($myYpre, 0) & ") -> (" & $x & "," & $y & ") dist=" & Round($dist, 0))
    $g_LootNavLock = True
    Local $iDeathCountPre = $g_GE_DeathCount   
    Local $tNav = TimerInit()
    MoveToFollowPath_Smooth($x, $y, 1300)
    Local $navMs = Round(TimerDiff($tNav), 0)
    Local $myXpost = Agent_GetAgentInfo(-2, "X")
    Local $myYpost = Agent_GetAgentInfo(-2, "Y")
    Local $distPost = Sqrt(($x - $myXpost)^2 + ($y - $myYpost)^2)
    Out("[Mission/nav_kill] POST navMs=" & $navMs & " char=(" & Round($myXpost, 0) & "," & Round($myYpost, 0) & ") dist destino=" & Round($distPost, 0))
    If Recovery_IsAtZero() Then
        $g_LootNavLock = False
        Return False
    EndIf
    If $g_GE_DeathCount > $iDeathCountPre Then
        Out("[Mission/nav_kill] Char murio durante nav (death #" & $g_GE_DeathCount & ") -> abort ClearZone")
        $g_LootNavLock = False
        Return False
    EndIf
    Combat_ClearZone(2500, 25000)
    For $hunt = 1 To 3
        If Recovery_IsAtZero() Or Agent_GetAgentInfo(-2, "IsDead") Then ExitLoop
        Local $farEnemy = GetNearestEnemy($huntRange)
        If $farEnemy = 0 Then ExitLoop   
        Local $eX = Agent_GetAgentInfo($farEnemy, "X")
        Local $eY = Agent_GetAgentInfo($farEnemy, "Y")
        Local $eDist = Agent_GetDistance(-2, $farEnemy)
        Out("[Mission/nav_kill] Hunt #" & $hunt & "/3: enemy a " & Round($eDist) & "u -> (" & Round($eX) & "," & Round($eY) & ") -> navegar y limpiar")
        GameEvents_ResetStuck()
        Pathfinder_MoveTo($eX, $eY, -1, "FilterObstacle", 1300, 12000, $g_i_FinisherMode, "_MarkEnemiesCallback")
        Combat_ClearZone(2500, 15000)
    Next
    If Recovery_IsAtZero() Or Agent_GetAgentInfo(-2, "IsDead") Then
        Out("[Mission/nav_kill] Char muerto tras ClearZone -> abort step")
        $g_LootNavLock = False   
        Return False
    EndIf
    GameEvents_ResetStuck()
    If GetNearestEnemy(2000) = 0 Then
        Out("[Mission/nav_kill] Recogiendo items del suelo...")
        Loot_PickupNearby(1300)   
        Sleep(1000)
    Else
        Out("[Mission/nav_kill] Enemies aun presentes (2000u) -> skip loot")
    EndIf
    GameEvents_ResetStuck()   
    _Mission_ReturnToWaypoint($x, $y)   
    $g_LootNavLock = False   
    Return True
EndFunc
Func _Mission_ReturnToWaypoint($x, $y)
    Local $cx = Agent_GetAgentInfo(-2, "X")
    Local $cy = Agent_GetAgentInfo(-2, "Y")
    Local $dist = Sqrt(($x - $cx)^2 + ($y - $cy)^2)
    If $dist <= 300 Then Return True   
    Out("[Mission/return] Char en (" & Round($cx, 0) & "," & Round($cy, 0) & ") esta a " & Round($dist, 0) & "u del waypoint -> re-nav")
    For $attempt = 1 To 3
        Local $startX = Agent_GetAgentInfo(-2, "X")
        Local $startY = Agent_GetAgentInfo(-2, "Y")
        MoveToFollowPath_Smooth($x, $y, 0)
        Local $endX = Agent_GetAgentInfo(-2, "X")
        Local $endY = Agent_GetAgentInfo(-2, "Y")
        Local $endDist = Sqrt(($x - $endX)^2 + ($y - $endY)^2)
        Local $moved = Sqrt(($endX - $startX)^2 + ($endY - $startY)^2)
        Out("[Mission/return] Attempt " & $attempt & "/3 char=(" & Round($endX, 0) & "," & Round($endY, 0) & ") dist=" & Round($endDist, 0) & " movido=" & Round($moved, 0))
        If $endDist <= 300 Then Return True
        If Map_GetMapID() = 0 Then
            Out("[Mission/return] Map=0 (disconnect), abortar reintentos")
            Return True
        EndIf
        If $moved < 200 And $attempt < 3 Then
            Out("[Mission/return] Sin avance (movido " & Round($moved, 0) & "u<200) -> Recovery_Unstuck")
            Recovery_Unstuck()
        EndIf
    Next
    Out("[Mission/return] Tras 3 intentos sigue lejos, continuar al siguiente step")
    Return True
EndFunc
Func _Mission_DoNavThrough($x, $y)
    GameEvents_ResetStuck()
    Local $myXpre = Agent_GetAgentInfo(-2, "X")
    Local $myYpre = Agent_GetAgentInfo(-2, "Y")
    Local $dist0  = Sqrt(($x - $myXpre)^2 + ($y - $myYpre)^2)
    Out("[Mission/nav_through] PRE char=(" & Round($myXpre, 0) & "," & Round($myYpre, 0) & ") -> (" & $x & "," & $y & ") dist=" & Round($dist0, 0))
    $g_LootNavLock = True
    Local $tNav     = TimerInit()
    Local $navOK    = False
    Local $step     = 0        
    Local $unstucks = 0
    Local $prevX    = $myXpre
    Local $prevY    = $myYpre
    While TimerDiff($tNav) < 120000
        If Bot_ShouldStop() Then ExitLoop
        If Map_GetMapID() = 0 Then ExitLoop
        If Recovery_IsAtZero() Or Agent_GetAgentInfo(-2, "IsDead") Then
            Out("[Mission/nav_through] Char muerto -> esperar rez (max 30s)...")
            Local $bNTRevived = False
            Local $tNTRevive = TimerInit()
            While TimerDiff($tNTRevive) < 30000
                If Bot_ShouldStop() Then ExitLoop
                If Map_GetMapID() = 0 Then ExitLoop
                If Not Agent_GetAgentInfo(-2, "IsDead") Then
                    Local $ntRx = Agent_GetAgentInfo(-2, "X")
                    Local $ntRy = Agent_GetAgentInfo(-2, "Y")
                    If $ntRx <> 0 Or $ntRy <> 0 Then
                        Out("[Mission/nav_through] Rez OK en (" & Round($ntRx) & "," & Round($ntRy) & ") -> retomando nav")
                        Sleep(2500)   
                        $bNTRevived = True
                        ExitLoop
                    EndIf
                EndIf
                Sleep(400)
            WEnd
            If Not $bNTRevived Then
                Out("[Mission/nav_through] TIMEOUT rez (30s) -> abort nav")
                ExitLoop
            EndIf
            Local $tWBCancel = TimerInit()
            While TimerDiff($tWBCancel) < 3500
                $g_GE_NeedsWalkback = False
                Sleep(100)
            WEnd
            $prevX    = Agent_GetAgentInfo(-2, "X")
            $prevY    = Agent_GetAgentInfo(-2, "Y")
            $unstucks = 0
            ContinueLoop
        EndIf
        If GetNearestEnemy(2000) <> 0 Then
            Out("[Mission/nav_through] Enemies en 2000u -> ClearZone ANTES de avanzar (step " & $step & ")")
            Local $czPre = Combat_ClearZone(1300, 15000)
            If Not $czPre Or GetNearestEnemy(2000) <> 0 Then
                Combat_ClearZone(2500, 12000)
            EndIf
            Sleep(800)
            ContinueLoop   
        EndIf
        $step += 1
        Local $prevPfTimeout = $g_iPathfinder_MovementTimeout
        $g_iPathfinder_MovementTimeout = 12000
        MoveToFollowPath_Smooth($x, $y, 1200)
        $g_iPathfinder_MovementTimeout = $prevPfTimeout
        Local $cx = Agent_GetAgentInfo(-2, "X")
        Local $cy = Agent_GetAgentInfo(-2, "Y")
        If $cx = 0 And $cy = 0 Then
            Sleep(500)
            ContinueLoop
        EndIf
        Local $d = Sqrt(($x - $cx)^2 + ($y - $cy)^2)
        If $d < 400 Then
            $navOK = True
            ExitLoop
        EndIf
        Local $progress = Sqrt(($cx - $prevX)^2 + ($cy - $prevY)^2)
        If $progress < 150 And $unstucks < 2 Then
            $unstucks += 1
            Out("[Mission/nav_through] Progreso insuficiente (" & Round($progress, 0) & "u<150) -> Unstuck #" & $unstucks)
            GameEvents_ResetStuck()
            Recovery_Unstuck()
            $prevX = Agent_GetAgentInfo(-2, "X")
            $prevY = Agent_GetAgentInfo(-2, "Y")
            ContinueLoop
        ElseIf $progress < 150 And $unstucks >= 2 Then
            Out("[Mission/nav_through] 2 unstucks fallidos -> saltar WP (" & $x & "," & $y & ")")
            ExitLoop
        EndIf
        $prevX = $cx
        $prevY = $cy
        If GetNearestEnemy(2500) <> 0 Then
            Out("[Mission/nav_through] Enemies tras paso " & $step & " -> ClearZone post")
            Local $czPost = Combat_ClearZone(1300, 15000)
            If Not $czPost Or GetNearestEnemy(2500) <> 0 Then
                Combat_ClearZone(2500, 12000)
            EndIf
        EndIf
        Sleep(400)
    WEnd
    Local $navMs = Round(TimerDiff($tNav), 0)
    $g_LootNavLock = False
    Local $myXpost = Agent_GetAgentInfo(-2, "X")
    Local $myYpost = Agent_GetAgentInfo(-2, "Y")
    Local $distPost = Sqrt(($x - $myXpost)^2 + ($y - $myYpost)^2)
    Out("[Mission/nav_through] POST navMs=" & $navMs & "ms steps=" & $step & " char=(" & Round($myXpost, 0) & "," & Round($myYpost, 0) & ") dist=" & Round($distPost, 0) & " ok=" & $navOK)
    If Recovery_IsAtZero() Or Agent_GetAgentInfo(-2, "IsDead") Then
        Out("[Mission/nav_through] Char muerto -> False")
        Return False
    EndIf
    If Map_GetMapID() = 0 Then Return False
    Return $navOK
EndFunc
Func _Mission_DoNavOnly($x, $y)
    Local $myXpre = Agent_GetAgentInfo(-2, "X")
    Local $myYpre = Agent_GetAgentInfo(-2, "Y")
    Local $dist = Sqrt(($x - $myXpre)^2 + ($y - $myYpre)^2)
    Out("[Mission/nav_only] PRE char=(" & Round($myXpre, 0) & "," & Round($myYpre, 0) & ") -> (" & $x & "," & $y & ") dist=" & Round($dist, 0) & " bundle=" & $g_bHasBundle)
    $g_LootNavLock = True
    GameEvents_ResetStuck()   
    Local $tNav = TimerInit()
    Local $navOK = False
    Local $lastProgressX = Agent_GetAgentInfo(-2, "X")
    Local $lastProgressY = Agent_GetAgentInfo(-2, "Y")
    Local $tProgress = TimerInit()
    Local $pfFails = 0
    While TimerDiff($tNav) < 90000
        If Bot_ShouldStop() Then ExitLoop
        If Map_GetMapID() = 0 Then ExitLoop
        Local $cx = Agent_GetAgentInfo(-2, "X")
        Local $cy = Agent_GetAgentInfo(-2, "Y")
        If $cx = 0 And $cy = 0 Then
            Sleep(500)
            ContinueLoop
        EndIf
        If Agent_GetAgentInfo(-2, "IsDead") Then
            Sleep(500)
            ContinueLoop
        EndIf
        Local $d = Sqrt(($x - $cx)^2 + ($y - $cy)^2)
        If $d < 400 Then
            $navOK = True
            ExitLoop
        EndIf
        Local $movedSinceLast = Sqrt(($cx - $lastProgressX)^2 + ($cy - $lastProgressY)^2)
        If $movedSinceLast > 150 Then
            $lastProgressX = $cx
            $lastProgressY = $cy
            $tProgress = TimerInit()
            $pfFails = 0
        EndIf
        If TimerDiff($tProgress) > 20000 Then
            Out("[Mission/nav_only] Sin progreso 20s en (" & Round($cx) & "," & Round($cy) & ") dist=" & Round($d) & " -> abort")
            ExitLoop
        EndIf
        Local $pfInterval = $g_bHasBundle ? 3000 : -1
        Local $pfOK = Pathfinder_MoveTo($x, $y, $pfInterval, "FilterObstacle", 0, 30000, $g_i_FinisherMode, "")
        If Not $pfOK Then
            $pfFails += 1
            Out("[Mission/nav_only] Pathfinder fail " & $pfFails & "/3")
            If $pfFails >= 3 Then ExitLoop
        Else
            $pfFails = 0
        EndIf
        Sleep(150)   
    WEnd
    Local $navMs = Round(TimerDiff($tNav), 0)
    $g_LootNavLock = False   
    Local $myXpost = Agent_GetAgentInfo(-2, "X")
    Local $myYpost = Agent_GetAgentInfo(-2, "Y")
    Local $distPost = Sqrt(($x - $myXpost)^2 + ($y - $myYpost)^2)
    Out("[Mission/nav_only] POST navMs=" & $navMs & " char=(" & Round($myXpost, 0) & "," & Round($myYpost, 0) & ") dist destino=" & Round($distPost, 0) & " ok=" & $navOK)
    If Map_GetMapID() = 0 Then Return False
    Return $navOK
EndFunc
Func _Mission_DoDialog($spec, $x, $y, $label)
    Local $parts = StringSplit($spec, ":", 2)
    If UBound($parts) < 2 Then
        Out("[Mission/nav_dialog] WARN spec invalido '" & $spec & "' en " & $label)
        Return
    EndIf
    Local $modelId = Int($parts[0])
    Local $dialogStr = $parts[1]
    If StringLeft($dialogStr, 2) = "0x" Then $dialogStr = StringMid($dialogStr, 3)
    Local $dialog = Dec($dialogStr)
    Local $npc = _Quests_FindNearestNPCByModelToWp($modelId, $x, $y)
    If $npc = 0 Then
        Out("[Mission/nav_dialog] WARN no NPC model=" & $modelId & " cerca de (" & $x & "," & $y & ") en " & $label)
        Return
    EndIf
    Out("[Mission/nav_dialog] " & $label & " model=" & $modelId & " dialog=0x" & Hex($dialog, 6))
    Agent_GoNPC($npc)
    Local $tGoNPC = TimerInit()
    While TimerDiff($tGoNPC) < 5000
        If Agent_GetAgentInfo(-2, "IsDead") Then ExitLoop   
        Local $distNPC = Agent_GetDistance(-2, $npc)
        If $distNPC > 0 And $distNPC < 250 Then ExitLoop
        Sleep(300)
    WEnd
    Bot_Dialog($dialog)
    Sleep(1500)
    Bot_Dialog($dialog)
    Sleep(1500)
EndFunc
Func _Mission_DoMapMove($x, $y, $timeoutMs = 90000)
    Local $t = TimerInit()
    Agent_CancelAction()
    Sleep(200)
    Map_Move($x, $y)
    Local $lastEmit = TimerInit()
    Local $lastCancel = TimerInit()
    While TimerDiff($t) < $timeoutMs
        If Bot_ShouldStop() Then Return
        If Map_GetMapID() = 0 Then Return
        Local $cx = Agent_GetAgentInfo(-2, "X")
        Local $cy = Agent_GetAgentInfo(-2, "Y")
        If $cx = 0 And $cy = 0 Then Return
        Local $d = Sqrt(($x - $cx)^2 + ($y - $cy)^2)
        If $d < 200 Then
            Out("[Mission/MapMove] llegado a (" & Round($cx, 0) & "," & Round($cy, 0) & ") dist=" & Round($d, 0))
            Return
        EndIf
        If TimerDiff($lastCancel) > 2000 Then
            Agent_CancelAction()
            Sleep(100)
            Map_Move($x, $y)   
            $lastCancel = TimerInit()
            $lastEmit = TimerInit()
            ContinueLoop
        EndIf
        If TimerDiff($lastEmit) > 1500 Then
            Map_Move($x, $y)
            $lastEmit = TimerInit()
        EndIf
        Sleep(250)
    WEnd
    Out("[Mission/MapMove] TIMEOUT " & Round($timeoutMs/1000, 0) & "s")
EndFunc
Func _Mission_WaitForRevive($timeoutMs = 12000)
    Local $t = TimerInit()
    Out("[Mission/WaitRez] Esperando rez del char (max " & Round($timeoutMs/1000, 0) & "s)...")
    While TimerDiff($t) < $timeoutMs
        If Bot_ShouldStop() Then Return False
        If Map_GetMapID() = 0 Then Return False   
        If Not Agent_GetAgentInfo(-2, "IsDead") Then
            Local $rx = Agent_GetAgentInfo(-2, "X")
            Local $ry = Agent_GetAgentInfo(-2, "Y")
            If $rx <> 0 Or $ry <> 0 Then
                Out("[Mission/WaitRez] Char rezado en (" & Round($rx) & "," & Round($ry) & ") tras " & Round(TimerDiff($t)/1000, 1) & "s")
                Sleep(1500)   
                Return True
            EndIf
        EndIf
        Sleep(400)
    WEnd
    Out("[Mission/WaitRez] TIMEOUT " & Round($timeoutMs/1000, 0) & "s -> IsDead=" & Agent_GetAgentInfo(-2, "IsDead") & " map=" & Map_GetMapID())
    Return False
EndFunc