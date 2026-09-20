#include-once
Global $g_M03_Route[27][3] = [ _
    [ 6660,  18581, ""       ], _ 
    [ 3218,  15760, ""       ], _ 
    [ 1866,  13041, ""       ], _ 
    [  -68,  13492, ""       ], _ 
    [-1907,  14216, ""       ], _ 
    [ -544,  14272, ""       ], _ 
    [ 1631,  11561, ""       ], _ 
    [  204,   9137, ""       ], _ 
    [ 4045,   6951, ""       ], _ 
    [ 4571,   5455, "besuz"  ], _ 
    [ 4799,   3801, ""       ], _ 
    [ 7642,   -734, ""       ], _ 
    [ 8489,  -1875, ""       ], _ 
    [ 9302,  -5603, ""       ], _ 
    [11024,  -6388, ""       ], _ 
    [ 9493,  -9849, ""       ], _ 
    [-1184, -15370, ""       ], _ 
    [-2365, -16577, ""       ], _ 
    [-4210, -13779, ""       ], _ 
    [-5418, -12201, ""       ], _ 
    [-8281, -12074, ""       ], _ 
    [-9255, -12039, ""       ], _ 
    [ 7346, -10557, "wait5"  ], _ 
    [ 5435, -10068, ""       ], _ 
    [ 4180, -11010, ""       ], _ 
    [ 3338, -11536, ""       ], _ 
    [  609, -13534, "kahyet" ]  _ 
]
Global $g_M03_PickupLoot = True
Global $g_M03_EscortEndedAt = -1
Global $g_M03_SawDefeat = False
Func _M03_FillBlacktideHenchmen()
    Local $aH[7] = [4600, 4602, 4606, 4605, 4601, 4603, 4604]
    For $i = 0 To UBound($aH) - 1
        Local $pFull = 1 + Party_GetMyPartyInfo("ArrayHeroPartyMemberSize") _
                         + Party_GetMyPartyInfo("ArrayHenchmanPartyMemberSize")
        If $pFull >= 8 Then ExitLoop
        If _AutoParty_IsHenchModelInParty($aH[$i]) Then ContinueLoop
        Local $ag = Agent_GetAgentByPlayerNumber($aH[$i])
        If $ag = 0 Then ContinueLoop
        Out("[M03] AddNpc henchman model=" & $aH[$i])
        Party_AddNpc($ag)
        Sleep(800)
    Next
EndFunc
Func _M03_EnterViaNunbe($model)
    Local $n = 0, $tf = TimerInit()
    While Not Bot_ShouldStop() And TimerDiff($tf) < 15000
        $n = Agent_GetAgentByPlayerNumber($model)
        If $n <> 0 Then ExitLoop
        Sleep(500)
    WEnd
    If $n = 0 Then
        Out("[M03] Savage Nunbe (" & $model & ") no encontrado tras 15s")
        Return False
    EndIf
    Local $nx = Agent_GetAgentInfo($n, "X"), $ny = Agent_GetAgentInfo($n, "Y")
    Out("[M03] Nav a Savage Nunbe (" & Round($nx) & "," & Round($ny) & ")")
    Map_Move($nx, $ny, 0)
    Local $t = TimerInit(), $tr = TimerInit()
    While Not Bot_ShouldStop() And TimerDiff($t) < 20000
        If Sqrt((Agent_GetAgentInfo(-2,"X")-$nx)^2+(Agent_GetAgentInfo(-2,"Y")-$ny)^2) < 200 Then ExitLoop
        If TimerDiff($tr) >= 2500 Then
            Map_Move($nx, $ny, 0)
            $tr = TimerInit()
        EndIf
        Sleep(300)
    WEnd
    For $try = 1 To 6
        $n = Agent_GetAgentByPlayerNumber($model)
        If $n <> 0 Then
            Agent_ChangeTarget($n)
            Sleep(300)
            Agent_GoNPC($n)
            Sleep(2500)
        EndIf
        Out("[M03] Nunbe dialog try " & $try & " -> 0x84")
        Bot_Dialog(0x84)
        Sleep(2500)
        If Map_GetInstanceInfo("IsLoading") Or Map_GetInstanceInfo("Type") <> $GC_I_MAP_TYPE_OUTPOST Then
            WaitLoading()
            Sleep(2000)
            If Map_GetInstanceInfo("Type") <> $GC_I_MAP_TYPE_OUTPOST Then Return True
        EndIf
    Next
    Return (Map_GetInstanceInfo("Type") <> $GC_I_MAP_TYPE_OUTPOST)
EndFunc
Func _M03_WaitOutpostLoaded($maxMs = 30000)
    Local $t = TimerInit()
    While Not Bot_ShouldStop() And TimerDiff($t) < $maxMs
        If Not Map_GetInstanceInfo("IsLoading") _
           And Map_GetMapID() <> 0 _
           And Map_GetInstanceInfo("Type") = $GC_I_MAP_TYPE_OUTPOST Then
            Local $cx = Agent_GetAgentInfo(-2, "X"), $cy = Agent_GetAgentInfo(-2, "Y")
            If $cx <> 0 Or $cy <> 0 Then
                Sleep(1500)
                Return True
            EndIf
        EndIf
        Sleep(500)
    WEnd
    Return False
EndFunc
Func _M03_EnsureTahlkoraSkill()
    Local Const $SKILL_SHIELDING_HANDS = 299
    Local Const $TRAINER_X = -11385, $TRAINER_Y = 16140   
    Local $T = "[M03-skill] "
    If World_IsSkillLearnt($SKILL_SHIELDING_HANDS) Then
        Out($T & "skill " & $SKILL_SHIELDING_HANDS & " (Shielding Hands) ya aprendida -> ok")
        Return True
    EndIf
    Out($T & "skill " & $SKILL_SHIELDING_HANDS & " NO aprendida -> comprar en Kamadan (Pikin)")
    If Map_GetMapID() <> $BSK_KAMADAN_MAP_ID Then
        If Not Travel_ToOutpost($BSK_KAMADAN_MAP_ID) Then
            Out($T & "FAIL travel a Kamadan (" & $BSK_KAMADAN_MAP_ID & ")")
            Return False
        EndIf
        Sleep(1500)
    EndIf
    Local $trainer = 0
    Local $tWalk = TimerInit(), $tEmit = TimerInit()
    Map_Move($TRAINER_X, $TRAINER_Y, 0)
    While Not Bot_ShouldStop() And TimerDiff($tWalk) < 30000
        Local $best = 999999.0
        Local $ags = Agent_GetAgentArray($GC_I_AGENT_TYPE_LIVING)
        If IsArray($ags) Then
            For $j = 0 To UBound($ags) - 1
                If $ags[$j] = 0 Then ContinueLoop
                If Agent_GetAgentInfo($ags[$j], "PlayerNumber") <> 4751 Then ContinueLoop
                Local $ttx = Agent_GetAgentInfo($ags[$j], "X"), $tty = Agent_GetAgentInfo($ags[$j], "Y")
                Local $ttd = Sqrt(($ttx - $TRAINER_X)^2 + ($tty - $TRAINER_Y)^2)
                If $ttd < $best Then
                    $best = $ttd
                    $trainer = $ags[$j]
                EndIf
            Next
        EndIf
        If $trainer <> 0 And $best < 300 Then ExitLoop
        If $trainer = 0 And TimerDiff($tWalk) > 15000 Then
            Local $byName = _FT_FindAnyAgentByName("Pikin")
            If $byName <> 0 Then
                Local $bnx = Agent_GetAgentInfo($byName, "X"), $bny = Agent_GetAgentInfo($byName, "Y")
                Local $bnd = Sqrt(($bnx - $TRAINER_X)^2 + ($bny - $TRAINER_Y)^2)
                If $bnd < 1500 Then
                    Out($T & "Pikin por NOMBRE a " & Round($bnd) & "u (modelo/coords a la deriva) -> GoNPC directo")
                    $trainer = $byName
                    ExitLoop
                EndIf
            EndIf
        EndIf
        If TimerDiff($tEmit) >= 2500 Then
            Map_Move($TRAINER_X, $TRAINER_Y, 0)
            $tEmit = TimerInit()
        EndIf
        Sleep(500)
    WEnd
    If $trainer = 0 Then
        Out($T & "Pikin (4751) no encontrado cerca de (" & $TRAINER_X & "," & $TRAINER_Y & ") -> skip compra")
        Return False
    EndIf
    Out($T & "Pikin agent=" & $trainer & " -> GoNPC")
    Agent_GoNPC($trainer)
    Sleep(2500)
    Local $bought = False
    For $a = 1 To 2
        Out($T & "intento " & $a & ": menu Monk (0x800300) + Skill_BuySkillByID(" & $SKILL_SHIELDING_HANDS & ")")
        Bot_Dialog(0x800300)   
        Sleep(2500)
        Skill_BuySkillByID($SKILL_SHIELDING_HANDS)
        Sleep(2500)
        If World_IsSkillLearnt($SKILL_SHIELDING_HANDS) Then
            $bought = True
            ExitLoop
        EndIf
    Next
    If Not $bought Then
        Out($T & "Compra FALLO: skill " & $SKILL_SHIELDING_HANDS & " tras 2 intentos (menu/skillpoints/oro) -> la barra usara fallback")
        Return False
    EndIf
    Out($T & "Compra OK: Shielding Hands (299) aprendida")
    Return True
EndFunc
Func _M03_ApplyTahlkoraBar()
    Local $slot = _AutoLevel_FindHeroSlot($GC_I_HERO_ID_TAHLKORA)
    If $slot <= 0 Then
        Out("[M03-bar] Tahlkora no en party (slot=" & $slot & ") -> no se aplica barra")
        Return False
    EndIf
    Local $aBar[9] = [0, 299, 281, 307, 301, 1396, 1399, 245, 305]   
    If Not World_IsSkillLearnt($aBar[1]) Then
        Local $aCand[4] = [277, 288, 313, 299]
        For $i = 0 To UBound($aCand) - 1
            If World_IsSkillLearnt($aCand[$i]) Then
                Out("[M03-bar] slot1: skill " & 299 & " no aprendida -> sustituto " & $aCand[$i])
                $aBar[1] = $aCand[$i]
                ExitLoop
            EndIf
        Next
    EndIf
    Out("[M03-bar] Tahlkora slot " & $slot & " -> [" & $aBar[1] & "," & $aBar[2] & "," & $aBar[3] & "," & $aBar[4] & "," & $aBar[5] & "," & $aBar[6] & "," & $aBar[7] & "," & $aBar[8] & "]")
    Skill_LoadSkillBar($aBar[1], $aBar[2], $aBar[3], $aBar[4], $aBar[5], $aBar[6], $aBar[7], $aBar[8], $slot)
    Sleep(2500)
    Cache_SkillBar()
    Sleep(800)
    For $s = 1 To 8
        Local $vid = Skill_GetSkillbarInfo($s, "SkillID", $slot)
        If $vid = 0 Then
            Out("[M03-bar] WARN slot " & $s & " vacio (skill " & $aBar[$s] & " no disponible)")
        EndIf
    Next
    Local $v1 = Skill_GetSkillbarInfo(1, "SkillID", $slot)
    Out("[M03-bar] verificado slot1=" & $v1)
    Return ($v1 <> 0)
EndFunc
Func _M03_PickupBundles($range = 1400)
    Local $cx = Agent_GetAgentInfo(-2, "X"), $cy = Agent_GetAgentInfo(-2, "Y")
    Local $items = Agent_GetAgentArray($GC_I_AGENT_TYPE_ITEM)
    If Not IsArray($items) Or $items[0] = 0 Then Return
    For $i = 1 To $items[0]
        Local $ptr = $items[$i]
        If $ptr = 0 Then ContinueLoop
        If Agent_GetAgentInfo($ptr, "ID") <> 0 Then ContinueLoop   
        Local $ix = Agent_GetAgentInfo($ptr, "X"), $iy = Agent_GetAgentInfo($ptr, "Y")
        Local $d = Sqrt(($cx-$ix)^2+($cy-$iy)^2)
        If $d > $range Then ContinueLoop
        Out("[M03] Bundle item (disfraz) agentPtr=" & $ptr & " d=" & Round($d))
        If $d > 300 Then
            Map_Move($ix, $iy, 0)
            Sleep(2000)
        EndIf
        Item_PickUpItem($ptr)
        Sleep(1000)
        Out("[M03] Bundle recogido: BundleModelID=" & Item_GetInventoryInfo("BundleModelID"))
    Next
EndFunc
Func _M03_GoTo($x, $y, $maxMs = 180000)
    Local $t = TimerInit(), $tReemit = TimerInit()
    Local $tProg = TimerInit(), $lastD = 99999999, $side = 1, $stucks = 0
    Map_Move($x, $y, 0)
    While Not Bot_ShouldStop() And TimerDiff($t) < $maxMs
        If $g_bRegistroMode Then Return False
        If Map_GetMapID() = 0 Or Map_GetInstanceInfo("IsLoading") Then
            Sleep(1500)
            ContinueLoop
        EndIf
        If Party_GetPartyContextInfo("IsDefeated") Then
            $g_M03_SawDefeat = True
            Out("[M03] GoTo: PARTY DEFEATED -> abortar (reintento)")
            Return False
        EndIf
        If Map_GetInstanceInfo("Type") = $GC_I_MAP_TYPE_OUTPOST Then Return True
        Cinematic_ProtectStep()
        Local $cx = Agent_GetAgentInfo(-2, "X"), $cy = Agent_GetAgentInfo(-2, "Y")
        Local $d = Sqrt(($cx-$x)^2 + ($cy-$y)^2)
        If $d < 250 Then
            If $g_M03_PickupLoot Then
                Sleep(1000)
                _FT_PickupGroundItems(1400)
                _M03_PickupBundles(1400)
            EndIf
            Return True
        EndIf
        If Agent_GetAgentInfo(-2, "IsDead") Then
            Sleep(2000)
            $tProg = TimerInit()
            ContinueLoop
        EndIf
        If GetNearestEnemy(1400) <> 0 Then
            Combat_ClearZone(1250, 12000)
            If $g_M03_PickupLoot Then
                _FT_PickupGroundItems(1400)
                _M03_PickupBundles(1400)
            EndIf
            Map_Move($x, $y, 0)
            $tReemit = TimerInit()
            $tProg = TimerInit()
            ContinueLoop
        EndIf
        If $d < $lastD - 50 Then
            $lastD = $d
            $tProg = TimerInit()
            $stucks = 0
        ElseIf TimerDiff($tProg) > 15000 Then
            $stucks += 1
            If $stucks > 4 Then
                Out("[M03] GoTo BLOQUEADO a (" & $x & "," & $y & ") tras 4 sidesteps -> FAIL rapido")
                Return False
            EndIf
            Local $vx = $x - $cx, $vy = $y - $cy
            Local $vl = Sqrt($vx * $vx + $vy * $vy)
            If $vl > 1 Then
                Local $px = $cx + (-$vy / $vl) * 600 * $side, $py = $cy + ($vx / $vl) * 600 * $side
                Out("[M03] GoTo sin progreso 15s -> sidestep " & $stucks & "/4 a (" & Round($px) & "," & Round($py) & ")")
                Map_Move($px, $py, 0)
            EndIf
            $side = -$side
            $tProg = TimerInit()
            $tReemit = TimerInit()
            Sleep(500)
            ContinueLoop
        EndIf
        If TimerDiff($tReemit) >= 2500 Then
            Map_Move($x, $y, 0)
            $tReemit = TimerInit()
        EndIf
        Sleep(300)
    WEnd
    Out("[M03] GoTo TIMEOUT a (" & $x & "," & $y & ")")
    Return False
EndFunc
Func _M03_EscortBesuz()
    Out("[M03] ESCOLTA: seguir a Besuz; si se para >6s, adelantar al siguiente WP para desbloquearlo")
    Local $t = TimerInit(), $tMove = TimerInit(), $tCombatCD = TimerInit() - 5000
    Local $lastBzX = -999999, $lastBzY = -999999, $tBzStill = TimerInit(), $tBzMissing = 0
    Local $wpIdx = 10
    Local $pcx = Agent_GetAgentInfo(-2, "X"), $pcy = Agent_GetAgentInfo(-2, "Y")
    Local $bestD = 99999999
    For $j = 10 To UBound($g_M03_Route) - 1
        Local $dj = Sqrt(($pcx - $g_M03_Route[$j][0])^2 + ($pcy - $g_M03_Route[$j][1])^2)
        If $dj < $bestD Then
            $bestD = $dj
            $wpIdx = $j
        EndIf
    Next
    Out("[M03] ESCOLTA: WP mÃ¡s cercano = " & $wpIdx & " (dist " & Round($bestD) & "u)")
    While Not Bot_ShouldStop() And TimerDiff($t) < 1800000
        If Party_GetPartyContextInfo("IsDefeated") Then
            $g_M03_SawDefeat = True
            Out("[M03] ESCOLTA: PARTY DEFEATED -> mision NO completada (reintento)")
            Return False
        EndIf
        If Map_GetInstanceInfo("Type") = $GC_I_MAP_TYPE_OUTPOST Then
            If $g_M03_SawDefeat Then
                Out("[M03] ESCOLTA: outpost tras defeat -> mision NO completada (reintento)")
                Return False
            EndIf
            Out("[M03] ESCOLTA: mision completada (outpost)")
            Return True
        EndIf
        Cinematic_ProtectStep()
        If Agent_GetAgentInfo(-2, "IsDead") Then
            Sleep(2000)
            ContinueLoop
        EndIf
        Local $fnx = Agent_GetAgentInfo(-2, "X"), $fny = Agent_GetAgentInfo(-2, "Y")
        Local $bPastWp18 = (Sqrt(($fnx - $g_M03_Route[18][0])^2 + ($fny - $g_M03_Route[18][1])^2) < 1000)
        Local $bzNow = _FT_FindAnyAgentByName("Besuz")
        If $bzNow = 0 Then
            If $tBzMissing = 0 Then $tBzMissing = TimerInit()
            If TimerDiff($tBzMissing) > 30000 Then
                If $bPastWp18 Then
                    Out("[M03] ESCOLTA: Besuz desaparecido 30s en zona WP18 -> continuar solo hasta Kahyet")
                    $g_M03_EscortEndedAt = 18
                    Return False
                Else
                    While $wpIdx < UBound($g_M03_Route) - 1 And Sqrt(($fnx - $g_M03_Route[$wpIdx][0])^2 + ($fny - $g_M03_Route[$wpIdx][1])^2) < 450
                        $wpIdx += 1
                    WEnd
                    Out("[M03] ESCOLTA: sin Besuz 30s -> avanzar a WP " & $wpIdx)
                    Map_Move($g_M03_Route[$wpIdx][0], $g_M03_Route[$wpIdx][1], 0)
                    $tMove = TimerInit()
                    $tBzMissing = TimerInit()
                EndIf
            EndIf
        Else
            $tBzMissing = 0
            If $bPastWp18 And TimerDiff($tBzStill) > 90000 Then
                Out("[M03] ESCOLTA: Besuz plantado 90s en zona WP18 -> continuar solo hasta Kahyet")
                $g_M03_EscortEndedAt = 18
                Return False
            EndIf
        EndIf
        Local $cx = Agent_GetAgentInfo(-2, "X"), $cy = Agent_GetAgentInfo(-2, "Y")
        If TimerDiff($tCombatCD) > 4000 Then
            Local $foe = GetNearestEnemy(1500)
            If $foe <> 0 Then
                Local $foeX = Agent_GetAgentInfo($foe, "X"), $foeY = Agent_GetAgentInfo($foe, "Y")
                Local $dFoe = Sqrt(($cx - $foeX)^2 + ($cy - $foeY)^2)
                If $dFoe > 1200 Then
                    If TimerDiff($tMove) >= 1500 Then
                        Out("[M03] ESCOLTA: acercando a grupo (" & Round($foeX) & "," & Round($foeY) & ") d=" & Round($dFoe))
                        Map_Move($foeX, $foeY, 0)
                        $tMove = TimerInit()
                    EndIf
                Else
                    Local $czT = TimerInit()
                    Combat_ClearZone(1250, 15000)
                    If TimerDiff($czT) < 300 Then
                        $tCombatCD = TimerInit()
                    EndIf
                EndIf
                ContinueLoop
            EndIf
        EndIf
        Local $bz = _FT_FindAnyAgentByName("Besuz")
        If $bz <> 0 Then
            Local $bzx = Agent_GetAgentInfo($bz, "X"), $bzy = Agent_GetAgentInfo($bz, "Y")
            If Sqrt(($bzx - $lastBzX)^2 + ($bzy - $lastBzY)^2) > 150 Then
                $lastBzX = $bzx
                $lastBzY = $bzy
                $tBzStill = TimerInit()
            EndIf
            Local $dBz = Sqrt(($cx - $bzx)^2 + ($cy - $bzy)^2)
            If $dBz > 350 And TimerDiff($tMove) >= 1000 Then
                Map_Move($bzx, $bzy, 0)
                $tMove = TimerInit()
            ElseIf TimerDiff($tBzStill) > 6000 And TimerDiff($tMove) >= 1500 And Not $bPastWp18 Then
                While $wpIdx < UBound($g_M03_Route) - 1 And Sqrt(($cx - $g_M03_Route[$wpIdx][0])^2 + ($cy - $g_M03_Route[$wpIdx][1])^2) < 450
                    $wpIdx += 1
                WEnd
                Out("[M03] ESCOLTA: Besuz parado -> adelantar a WP " & $wpIdx & " (" & $g_M03_Route[$wpIdx][0] & "," & $g_M03_Route[$wpIdx][1] & ")")
                Map_Move($g_M03_Route[$wpIdx][0], $g_M03_Route[$wpIdx][1], 0)
                $tMove = TimerInit()
                $tBzStill = TimerInit()   
            EndIf
        EndIf
        Sleep(300)
    WEnd
    Out("[M03] ESCOLTA TIMEOUT (30 min)")
    Return False
EndFunc
Func _M03_TalkBesuz()
    For $try = 1 To 8
        Local $bz = _FT_FindAnyAgentByName("Besuz")
        If $bz = 0 Then
            Out("[M03] Besuz no encontrado, reintento " & $try)
            Sleep(1500)
            ContinueLoop
        EndIf
        Local $bzx0 = Agent_GetAgentInfo($bz, "X"), $bzy0 = Agent_GetAgentInfo($bz, "Y")
        Local $cx = Agent_GetAgentInfo(-2, "X"), $cy = Agent_GetAgentInfo(-2, "Y")
        If Sqrt(($cx-$bzx0)^2+($cy-$bzy0)^2) > 350 Then
            Map_Move($bzx0, $bzy0, 0)
            Sleep(1500)
        EndIf
        Out("[M03] hablar con Besuz try " & $try)
        Agent_ChangeTarget($bz)
        Sleep(300)
        Agent_GoNPC($bz)
        Sleep(2000)
        Bot_Dialog(0x84)
        Sleep(2500)
        $bz = _FT_FindAnyAgentByName("Besuz")
        If $bz <> 0 Then
            Local $bzxN = Agent_GetAgentInfo($bz, "X"), $bzyN = Agent_GetAgentInfo($bz, "Y")
            Local $moved = Sqrt(($bzxN-$bzx0)^2+($bzyN-$bzy0)^2)
            Out("[M03] Besuz movimiento=" & Round($moved) & "u")
            If $moved > 30 Then
                Out("[M03] Besuz en marcha -> escolta iniciada")
                Return True
            EndIf
        EndIf
        Out("[M03] Besuz no se movio, reintentando dialogo")
        Sleep(1000)
    Next
    Out("[M03] FAIL: Besuz no inicio escolta tras 8 intentos")
    Return False
EndFunc
Func _M03_FinalFight()
    Out("[M03] PELEA FINAL: esperar 60s antes de atacar")
    Local $wt = TimerInit()
    While Not Bot_ShouldStop() And TimerDiff($wt) < 60000
        If Party_GetPartyContextInfo("IsDefeated") Then
            $g_M03_SawDefeat = True
            Out("[M03] PELEA FINAL: PARTY DEFEATED (espera) -> mision NO completada (reintento)")
            Return False
        EndIf
        If Map_GetInstanceInfo("Type") = $GC_I_MAP_TYPE_OUTPOST Then
            If $g_M03_SawDefeat Then
                Out("[M03] PELEA FINAL: outpost tras defeat -> mision NO completada")
                Return False
            EndIf
            Return True
        EndIf
        Cinematic_ProtectStep()
        Sleep(1000)
    WEnd
    Out("[M03] PELEA FINAL: atacar hasta matar a Kahyet")
    Local $ft = TimerInit()
    While Not Bot_ShouldStop() And TimerDiff($ft) < 300000
        If Party_GetPartyContextInfo("IsDefeated") Then
            $g_M03_SawDefeat = True
            Out("[M03] PELEA FINAL: PARTY DEFEATED (combate) -> mision NO completada (reintento)")
            Return False
        EndIf
        If Map_GetInstanceInfo("Type") = $GC_I_MAP_TYPE_OUTPOST Then
            If $g_M03_SawDefeat Then
                Out("[M03] PELEA FINAL: outpost tras defeat -> mision NO completada")
                Return False
            EndIf
            Out("[M03] Kahyet muerto -> outpost")
            Return True
        EndIf
        Cinematic_ProtectStep()   
        GameEvents_ResetStuck()
        Combat_ClearZone(1250, 12000)
        Sleep(500)
    WEnd
    Out("[M03] PELEA FINAL: TIMEOUT (5 min) sin volver al outpost")
    Return (Map_GetInstanceInfo("Type") = $GC_I_MAP_TYPE_OUTPOST)
EndFunc
Func _M03_Navigate()
    Local $n = UBound($g_M03_Route)
    Local $startWP = 1
    Local $pcx = Agent_GetAgentInfo(-2, "X"), $pcy = Agent_GetAgentInfo(-2, "Y")
    Local $bestD = 99999999, $bestWP = 1
    For $j = 1 To $n - 1
        Local $dj = Sqrt(($pcx - $g_M03_Route[$j][0])^2 + ($pcy - $g_M03_Route[$j][1])^2)
        If $dj < $bestD Then
            $bestD = $dj
            $bestWP = $j
        EndIf
    Next
    If $bestWP > 9 Then
        $startWP = $bestWP
        Out("[M03] retomar escolta desde WP " & $startWP & " (mÃ¡s cercano, dist " & Round($bestD) & ")")
    EndIf
    For $i = $startWP To $n - 1
        If Party_GetPartyContextInfo("IsDefeated") Then
            $g_M03_SawDefeat = True
            Out("[M03] PARTY DEFEATED en WP " & $i & " -> mision NO completada (reintento)")
            Return False
        EndIf
        If Map_GetInstanceInfo("Type") = $GC_I_MAP_TYPE_OUTPOST Then
            If $g_M03_SawDefeat Then
                Out("[M03] type=outpost tras defeat -> mision NO completada (reintento)")
                Return False
            EndIf
            Out("[M03] type=outpost -> mision terminada")
            Return True
        EndIf
        Local $wx = $g_M03_Route[$i][0], $wy = $g_M03_Route[$i][1], $act = $g_M03_Route[$i][2]
        Out("[M03] WP " & $i & "/" & ($n-1) & " -> (" & $wx & "," & $wy & ")" & ($act <> "" ? " [" & $act & "]" : ""))
        If $i = 22 Then
            Local $bz22 = _FT_FindAnyAgentByName("Besuz")
            If $bz22 <> 0 Then
                Local $bzx22 = Agent_GetAgentInfo($bz22, "X"), $bzy22 = Agent_GetAgentInfo($bz22, "Y")
                Out("[M03] WP22 via Besuz (" & Round($bzx22) & "," & Round($bzy22) & ")")
                _M03_GoTo($bzx22, $bzy22, 60000)
            Else
                Out("[M03] WP22: Besuz no encontrado, tramo directo")
            EndIf
            Local $tBzW = TimerInit(), $tBzMove = 0
            While Not Bot_ShouldStop() And TimerDiff($tBzW) < 120000
                Local $bzW = _FT_FindAnyAgentByName("Besuz")
                If $bzW = 0 Then ExitLoop
                Local $bdx = Agent_GetAgentInfo($bzW, "X") - Agent_GetAgentInfo(-2, "X")
                Local $bdy = Agent_GetAgentInfo($bzW, "Y") - Agent_GetAgentInfo(-2, "Y")
                Local $bdBz = Sqrt($bdx * $bdx + $bdy * $bdy)
                If $bdBz < 800 Then
                    Out("[M03] WP22: Besuz cerca (" & Round($bdBz) & "u) -> continuar")
                    ExitLoop
                EndIf
                If TimerDiff($tBzMove) > 3000 Then
                    Map_Move(Agent_GetAgentInfo($bzW, "X"), Agent_GetAgentInfo($bzW, "Y"), 0)
                    $tBzMove = TimerInit()
                EndIf
                Cinematic_ProtectStep()
                Sleep(500)
            WEnd
        EndIf
        If Not _M03_GoTo($wx, $wy, 180000) Then
            Out("[M03] FAIL en WP " & $i)
            Return False
        EndIf
        If $i = 5 Then
            Out("[M03] Disfraz check tras WP5: BundleModelID=" & Item_GetInventoryInfo("BundleModelID"))
            _M03_PickupBundles(3000)
        EndIf
        Switch $act
            Case "besuz"
                If Not _M03_TalkBesuz() Then
                    Out("[M03] FAIL: no se pudo iniciar escolta con Besuz")
                    Return False
                EndIf
                $g_M03_PickupLoot = False
                $g_M03_EscortEndedAt = -1
                Local $escortRet = _M03_EscortBesuz()
                If $g_M03_EscortEndedAt > 0 Then
                    $i = $g_M03_EscortEndedAt
                    Out("[M03] escolta terminada en WP" & $g_M03_EscortEndedAt & " -> continuar ruta desde WP" & ($g_M03_EscortEndedAt + 1))
                    ContinueLoop
                EndIf
                If Not $escortRet Then
                    Out("[M03] FAIL: escolta abortada (timeout 30 min)")
                    Return False
                EndIf
                Return True
            Case "wait5"
                Out("[M03] esperar 5s a Besuz")
                Local $w5 = TimerInit()
                While TimerDiff($w5) < 5000
                    Cinematic_ProtectStep()
                    Sleep(500)
                WEnd
            Case "kahyet"
                If _M03_FinalFight() Then Return True
                Out("[M03] FAIL: pelea final no completada")
                Return False
        EndSwitch
    Next
    Out("[M03] fin de la ruta: type=" & Map_GetInstanceInfo("Type"))
    Return (Map_GetInstanceInfo("Type") = $GC_I_MAP_TYPE_OUTPOST)
EndFunc
Func _M03_TalkBDFerry()
    Gadget_LogNearby(1500)
    Local $gadget = Gadget_FindNearestToXY(-25787, -10817, 800)
    If $gadget <> 0 Then
        Out("[M03] BDFerry: gadget encontrado id=" & $gadget & " -> Agent_GoNPC")
        Agent_ChangeTarget($gadget)
        Sleep(300)
        Agent_GoNPC($gadget)
        Sleep(4000)
        If Map_GetMapID() <> 432 Then
            WaitLoading()
            Return (Map_GetMapID() = 492)
        EndIf
        Out("[M03] BDFerry: GoNPC gadget no cruzo mapa -> probar ferry NPC")
    EndIf
    Local $npc = 0, $tf = TimerInit()
    While TimerDiff($tf) < 10000
        $npc = Agent_GetAgentByPlayerNumber(4749)
        If $npc <> 0 Then ExitLoop
        Sleep(500)
    WEnd
    If $npc = 0 Then
        Out("[M03] BDFerry: model 4749 no encontrado")
        Return False
    EndIf
    Local $nx = Agent_GetAgentInfo($npc,"X"), $ny = Agent_GetAgentInfo($npc,"Y")
    Out("[M03] BDFerry: ferry NPC 4749 pos=(" & Round($nx) & "," & Round($ny) & ")")
    Local $codes[8] = [0x84, 0x85, 0x81, 0x82, 0x86, 0x87, 0x83, 0x80]
    For $try = 1 To 6
        $npc = Agent_GetAgentByPlayerNumber(4749)
        If $npc <> 0 Then
            Agent_ChangeTarget($npc)
            Sleep(300)
            Agent_GoNPC($npc)
            Sleep(2500)
        EndIf
        Local $code = $codes[Mod($try-1, UBound($codes))]
        Out("[M03] BDFerry try " & $try & " -> Bot_Dialog(0x" & Hex($code,2) & ")")
        Bot_Dialog($code)
        Sleep(2500)
        If Map_GetInstanceInfo("IsLoading") Or Map_GetMapID() = 492 Then
            WaitLoading()
            Return (Map_GetMapID() = 492)
        EndIf
    Next
    Return (Map_GetMapID() = 492)
EndFunc
Func _M03_WalkCoDToPortal()
    Local Const $PORTAL_X = -26546
    Local Const $PORTAL_Y = -10889
    Local Const $GADGET_X = -25787  
    Local Const $GADGET_Y = -10817
    For $attempt = 1 To 10
        If Map_GetMapID() <> 432 Then ExitLoop
        If Party_GetPartyContextInfo("IsDefeated") Then
            Out("[M03] CoDToPortal: party defeated en intento " & $attempt)
            Return False
        EndIf
        Local $cx = Agent_GetAgentInfo(-2,"X"), $cy = Agent_GetAgentInfo(-2,"Y")
        Local $dPortal = Sqrt(($cx-$PORTAL_X)^2+($cy-$PORTAL_Y)^2)
        Local $dGadget = Sqrt(($cx-$GADGET_X)^2+($cy-$GADGET_Y)^2)
        Out("[M03] CoDToPortal " & $attempt & "/10 pos=(" & Round($cx) & "," & Round($cy) & ") dPortal=" & Round($dPortal) & " dGadget=" & Round($dGadget))
        If $dPortal > 1500 And $dGadget > 1500 Then
            MoveToFollowPath($PORTAL_X, $PORTAL_Y, 0)
        Else
            Out("[M03] CoDToPortal: cerca, nav al gadget (" & $GADGET_X & "," & $GADGET_Y & ") + ferry")
            MoveToFollowPath($GADGET_X, $GADGET_Y, 0)
            If Map_GetMapID() <> 432 Then ExitLoop
            Map_Move($GADGET_X, $GADGET_Y, 0)
            Sleep(2000)
            If Map_GetMapID() <> 432 Then ExitLoop
            If _M03_TalkBDFerry() Then ExitLoop
        EndIf
        If Map_GetMapID() <> 432 Then ExitLoop
    Next
    WaitLoading()
    Return (Map_GetMapID() = 492)
EndFunc
Func _M03_RewardQ633()
    If Not Quest_GetQuestInfo(633, "CanReward") Then
        Out("[M03-q633] q633 ya no cr=True, nada que hacer")
        Return True
    EndIf
    If Map_GetMapID() <> 0 And Map_GetInstanceInfo("Type") <> $GC_I_MAP_TYPE_OUTPOST Then
        Out("[M03-q633] En explorable map=" & Map_GetMapID() & " -> salir a Sunspear Hall (431)")
        Map_TravelTo($GC_I_MAP_ID_SUNSPEAR_GREAT_HALL)
        WaitLoading()
        Sleep(2000)
    EndIf
    If Map_GetMapID() <> $RM_DEST_MAP_ID Then
        Out("[M03-q633] Travel a Astralarium (" & $RM_DEST_MAP_ID & ")")
        If Not Travel_ToOutpost($RM_DEST_MAP_ID) Then
            Out("[M03-q633] FAIL travel a Astralarium")
            Return False
        EndIf
        Sleep(2000)
    EndIf
    _RM_TalkDajmirRewardAndAccept()
    If Not Quest_GetQuestInfo(633, "CanReward") Then
        Out("[M03-q633] q633 cobrada OK (reward directo)")
        Return True
    EndIf
    Out("[M03-q633] Reward directo fallo -> ejecutar encuentro Morgahn (Zehlon 483)")
    _RM_LegacyZehlonMorgahnFlow()
    If Map_GetMapID() <> $RM_DEST_MAP_ID Then
        Out("[M03-q633] Post-Morgahn: Travel a Astralarium (" & $RM_DEST_MAP_ID & ")")
        If Not Travel_ToOutpost($RM_DEST_MAP_ID) Then
            Out("[M03-q633] FAIL travel a Astralarium post-Morgahn")
            Return False
        EndIf
        Sleep(2000)
    EndIf
    _RM_TalkDajmirRewardAndAccept()
    If Not Quest_GetQuestInfo(633, "CanReward") Then
        Out("[M03-q633] q633 cobrada OK (tras encuentro Morgahn)")
        Return True
    EndIf
    Out("[M03-q633] FAIL: q633 sigue cr=True tras encuentro Morgahn + Dajmir")
    Return False
EndFunc
Func Quest_M03_BlacktideDen_Run()
    Local Const $BD_OUTPOST = $GC_I_MAP_ID_BLACKTIDE_DEN_OUTPOST   
    Out("[M03] === START (v2 desde cero) map=" & Map_GetMapID() & " type=" & Map_GetInstanceInfo("Type") & " ===")
    $g_M03_PickupLoot = True   
    $g_M03_SawDefeat = False   
    If Map_GetMapID() <> 0 And Map_GetInstanceInfo("Type") <> $GC_I_MAP_TYPE_OUTPOST Then
        If Map_GetMapID() = $BD_OUTPOST Then
            Out("[M03] en instancia BD -> resignar (Map_TravelTo " & $BD_OUTPOST & ")")
            Map_TravelTo($BD_OUTPOST)
        ElseIf Map_GetMapID() = 432 Then
            Out("[M03] ya en CoD (432), intentar portal BD (-26546,-10889) directamente")
            If Not _M03_WalkCoDToPortal() Then
                Out("[M03] nav CoD->BD fallÃ³ -> volver a Sunspear Hall (431)")
                Map_TravelTo($GC_I_MAP_ID_SUNSPEAR_GREAT_HALL)
            EndIf
        Else
            Out("[M03] en explorable " & Map_GetMapID() & " -> volver a Sunspear Hall (431)")
            Map_TravelTo($GC_I_MAP_ID_SUNSPEAR_GREAT_HALL)
        EndIf
        _M03_WaitOutpostLoaded(30000)
    EndIf
    _M03_EnsureTahlkoraSkill()
    If Map_GetInstanceInfo("Type") = $GC_I_MAP_TYPE_OUTPOST And Map_GetMapID() <> 0 And Map_GetMapID() <> $BD_OUTPOST Then
        Out("[M03] montar equipo en outpost " & Map_GetMapID() & " antes de viajar a BD")
        Team_SetupFull()
    EndIf
    If Map_GetMapID() <> $BD_OUTPOST Then
        Out("[M03] Intentar viaje directo a BD (" & $BD_OUTPOST & ") via Map_RndTravel")
        Map_RndTravel($BD_OUTPOST, False)
        Map_WaitMapLoading($BD_OUTPOST, $GC_I_MAP_TYPE_OUTPOST, 45000)
        If Map_GetMapID() <> $BD_OUTPOST Then
            Out("[M03] Viaje directo fallÃ³ (map=" & Map_GetMapID() & "), usando Travel_ToOutpost (walk-through)")
            If Not Travel_ToOutpost($BD_OUTPOST) Then
                If Map_GetMapID() = 432 Then
                    Out("[M03] Travel parcial en CoD, retomando nav al portal BD (-26546,-10889)")
                    If Not _M03_WalkCoDToPortal() Then
                        Out("[M03] FAIL: no se llego al portal BD tras reintentos en CoD")
                        Return False
                    EndIf
                Else
                    Out("[M03] FAIL travel a Blacktide Den (map=" & Map_GetMapID() & ")")
                    Return False
                EndIf
            EndIf
        Else
            Out("[M03] BD desbloqueado: viaje directo exitoso a 492")
        EndIf
    EndIf
    If Not _M03_WaitOutpostLoaded(20000) Then
        Out("[M03] FAIL: el outpost no termino de cargar")
        Return False
    EndIf
    Team_SetupFull()
    _M03_FillBlacktideHenchmen()
    _M03_ApplyTahlkoraBar()
    Local $entered = False
    For $et = 1 To 6
        If _M03_EnterViaNunbe(5127) And Map_GetMapID() = $BD_OUTPOST And Map_GetInstanceInfo("Type") <> $GC_I_MAP_TYPE_OUTPOST Then
            $entered = True
            ExitLoop
        ElseIf Map_GetMapID() <> $BD_OUTPOST And Map_GetMapID() <> 0 And Map_GetInstanceInfo("Type") <> $GC_I_MAP_TYPE_OUTPOST Then
            Out("[M03] entrada intento " & $et & ": MAPA EQUIVOCADO " & Map_GetMapID() & " (quest 641) -> resignar+reintentar")
            Map_TravelTo($BD_OUTPOST)
            _M03_WaitOutpostLoaded(20000)
        Else
            Out("[M03] entrada intento " & $et & ": reintentar")
        EndIf
    Next
    If Not $entered Then
        Out("[M03] FAIL: no se entro a la instancia BD (492) tras 6 intentos")
        Return False
    EndIf
    Out("[M03] Dentro de la mision (spawn) map=" & Map_GetMapID() & " type=" & Map_GetInstanceInfo("Type"))
    Pathfinder_SetPathUpdateInterval(750)
    Cache_SkillBar()
    If Not _M03_Navigate() Then
        Out("[M03] navegacion incompleta")
        Return False
    EndIf
    Out("[M03] M03 Blacktide Den COMPLETADA")
    Return True
EndFunc