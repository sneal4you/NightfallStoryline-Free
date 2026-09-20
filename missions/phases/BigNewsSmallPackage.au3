#include-once
Func Quest_BigNewsSmallPackage_Run()
    Local Const $QID = 638
    Local Const $BN_REWARD_HEX = 0x827E07   
    Local $ls = Quest_GetQuestInfo($QID, "LogState")
    Local $mt = Quest_GetQuestInfo($QID, "MapTo")
    Out("[BN] === START: ls=" & $ls & " mt=" & $mt & " ===")
    If $ls <= 0 Then
        Local $sd637 = Quest_GetQuestInfo(637, "LogState")
        If $sd637 > 0 Then
            Out("[BN] FAIL: prereq 637 SpecialDelivery sigue activa (ls=" & $sd637 & ") -> 638 no aceptable. Ejecutar antes la fase SpecialDelivery.")
            Return False
        EndIf
        If Not _SD_TravelToMap(431, "Sunspear Great Hall") Then Return False
        Local $npc = 0, $bestD = 350
        Local $arr = Agent_GetAgentArray($GC_I_AGENT_TYPE_LIVING)
        If IsArray($arr) Then
            For $i = 0 To UBound($arr) - 1
                If $arr[$i] = 0 Then ContinueLoop
                Local $d = Sqrt((Agent_GetAgentInfo($arr[$i],"X") - (-4067))^2 + (Agent_GetAgentInfo($arr[$i],"Y") - 5459)^2)
                If $d < $bestD Then
                    $bestD = $d
                    $npc = $arr[$i]
                EndIf
            Next
        EndIf
        If $npc = 0 Then
            Out("[BN] FAIL: Puuba no encontrada")
            Return False
        EndIf
        Local $npx = Agent_GetAgentInfo($npc, "X")
        Local $npy = Agent_GetAgentInfo($npc, "Y")
        Out("[BN] Puuba: '" & Agent_GetAgentInfo($npc,"Name") & "' en (" & Round($npx) & "," & Round($npy) & ")")
        Map_Move($npx, $npy, 0)
        Local $tW = TimerInit()
        While Not Bot_ShouldStop() And TimerDiff($tW) < 15000
            If Sqrt((Agent_GetAgentInfo(-2,"X")-$npx)^2+(Agent_GetAgentInfo(-2,"Y")-$npy)^2) < 150 Then ExitLoop
            Sleep(300)
        WEnd
        Agent_ChangeTarget($npc)
        Sleep(300)
        Agent_GoNPC($npc)
        Sleep(1500)
        Ui_AboutQuest($QID)
        Sleep(1000)
        Ui_AcceptQuest($QID)
        Sleep(3000)
        $ls = Quest_GetQuestInfo($QID, "LogState")
        $mt = Quest_GetQuestInfo($QID, "MapTo")
        Out("[BN] Post-accept: ls=" & $ls & " mt=" & $mt)
        If $ls <= 0 Then
            Out("[BN] FAIL: quest no aceptada")
            Return False
        EndIf
    EndIf
    For $loop = 1 To 12
        $ls = Quest_GetQuestInfo($QID, "LogState")
        $mt = Quest_GetQuestInfo($QID, "MapTo")
        Out("[BN] Loop " & $loop & ": ls=" & $ls & " mt=" & $mt)
        If $ls <= 0 Then
            Out("[BN] Quest 638 completada!")
            Return True
        EndIf
        Select
            Case $mt = 430 Or $mt = 0
                If Not _BN_EnterPlainsOfJarin() Then Return False
                $ls = Quest_GetQuestInfo($QID, "LogState")
                If $ls <= 0 Then Return True
                Local $jerek = _BN_FindJerek()
                If $jerek = 0 Then
                    Out("[BN] FAIL: Jerek no encontrado en Plains")
                    Return False
                EndIf
                Local $jx = Agent_GetAgentInfo($jerek,"X"), $jy = Agent_GetAgentInfo($jerek,"Y")
                Out("[BN] Jerek: '" & Agent_GetAgentInfo($jerek,"Name") & "' en (" & Round($jx) & "," & Round($jy) & ")")
                Map_Move($jx, $jy, 0)
                Local $tJ = TimerInit(), $tRJ = TimerInit()
                While Not Bot_ShouldStop() And TimerDiff($tJ) < 20000
                    If Sqrt((Agent_GetAgentInfo(-2,"X")-$jx)^2+(Agent_GetAgentInfo(-2,"Y")-$jy)^2) < 120 Then ExitLoop
                    If TimerDiff($tRJ) >= 2500 Then
                        Map_Move($jx, $jy, 0)
                        $tRJ = TimerInit()
                    EndIf
                    Sleep(300)
                WEnd
                Out("[BN] Dist a Jerek=" & Round(Sqrt((Agent_GetAgentInfo(-2,"X")-$jx)^2+(Agent_GetAgentInfo(-2,"Y")-$jy)^2)) & "u")
                If Not _BN_TalkJerek($jerek, $QID, $BN_REWARD_HEX) Then Return False
                $ls = Quest_GetQuestInfo($QID, "LogState")
                $mt = Quest_GetQuestInfo($QID, "MapTo")
                Out("[BN] Post-Jerek: ls=" & $ls & " mt=" & $mt)
                If $ls <= 0 Then Return True
            Case $mt = 488 Or $mt = 489
                Out("[BN] MapTo=" & $mt & " → ir a Mehtani Keys")
                If Not _SD_TravelToMap(489, "Kodlonu Hamlet") Then Return False
                _BN_SetupPartyKodlonu()
                If Not _BN_EnterMehtaniKeys() Then Return False
                If Not _BN_MehtaniObjective($QID) Then Return False
                $ls = Quest_GetQuestInfo($QID, "LogState")
                If $ls <= 0 Then Return True
            Case Else
                Out("[BN] MapTo inesperado: " & $mt & " (ls=" & $ls & ")")
                Return False
        EndSelect
    Next
    Out("[BN] FAIL: 12 loops sin completar (ls=" & Quest_GetQuestInfo($QID,"LogState") & " mt=" & Quest_GetQuestInfo($QID,"MapTo") & ")")
    Return False
EndFunc
Func _BN_SetupPartyKodlonu()
    Local $aHeroes[3] = [$GC_I_HERO_ID_KOSS, $GC_I_HERO_ID_DUNKORO, $GC_I_HERO_ID_MELONNI]
    Out("[BN] SetupParty: comprobando heroes...")
    For $i = 0 To 2
        If _AutoParty_IsHeroInParty($aHeroes[$i]) Then
            Out("[BN] SetupParty: hero " & $aHeroes[$i] & " ya en party → skip")
            ContinueLoop
        EndIf
        Local $pFull = 1 + Party_GetMyPartyInfo("ArrayHeroPartyMemberSize") _
                         + Party_GetMyPartyInfo("ArrayHenchmanPartyMemberSize")
        If $pFull >= 8 Then
            Out("[BN] SetupParty: party llena (" & $pFull & "/8), kickando henchman...")
            _AutoParty_KickAnyHenchman()
            Sleep(900)
        EndIf
        Out("[BN] SetupParty: Party_AddHero " & $aHeroes[$i])
        Party_AddHero($aHeroes[$i])
        Sleep(1200)
    Next
    Local $pSz = 1 + Party_GetMyPartyInfo("ArrayHeroPartyMemberSize") _
                   + Party_GetMyPartyInfo("ArrayHenchmanPartyMemberSize")
    Out("[BN] SetupParty: tras heroes party=" & $pSz & "/8 → añadiendo henchmen")
    _SD_AddHenchmen()
    $pSz = 1 + Party_GetMyPartyInfo("ArrayHeroPartyMemberSize") _
             + Party_GetMyPartyInfo("ArrayHenchmanPartyMemberSize")
    Out("[BN] SetupParty: FINAL party=" & $pSz & "/8")
EndFunc
Func _BN_TalkJerek($jerek, $qid, $rewardHex)
    Local Const $JEREK_X = -4106, $JEREK_Y = 2577, $JEREK_MODEL = 4892
    Local $mtBefore = Quest_GetQuestInfo($qid, "MapTo")
    Local $lsNow = Quest_GetQuestInfo($qid, "LogState")
    Local $crNow = Quest_GetQuestInfo($qid, "CanReward")
    If $lsNow >= 35 Or $crNow = True Or $crNow = 1 Then
        Out("[BN] TalkJerek: paso REWARD (ls=" & $lsNow & " cr=" & $crNow & ") → RewardQuest directo")
        Local $npcR = Agent_GetAgentByPlayerNumber($JEREK_MODEL)
        If $npcR <> 0 Then Agent_GoNPC($npcR)
        Sleep(2500)
        Ui_RewardQuest($qid)
        Sleep(5000)
        If Quest_GetQuestInfo($qid, "LogState") <= 0 Then Return True
        $npcR = Agent_GetAgentByPlayerNumber($JEREK_MODEL)
        If $npcR <> 0 Then Agent_GoNPC($npcR)
        Sleep(2500)
        Bot_Dialog($rewardHex)  
        Sleep(5000)
        If Quest_GetQuestInfo($qid, "LogState") <= 0 Then Return True
        Out("[BN] TalkJerek REWARD: ambos intentos fallaron (ls=" & Quest_GetQuestInfo($qid,"LogState") & ") → fallback a secuencias UpdateQuest")
    EndIf
    Out("[BN] TalkJerek seq1 (TalkUpdateQuest)")
    Quests_TalkUpdateQuest($JEREK_X, $JEREK_Y, $qid, $JEREK_MODEL, "Jerek")
    Sleep(3000)
    Local $mt1 = Quest_GetQuestInfo($qid, "MapTo")
    Local $ls1 = Quest_GetQuestInfo($qid, "LogState")
    Out("[BN] TalkJerek seq1 result: ls=" & $ls1 & " mt=" & $mt1)
    If $ls1 <= 0 Then Return True
    If $mt1 <> $mtBefore Then Return True
    Out("[BN] TalkJerek seq2 (GoNPC model + UpdateQuest)")
    Local $npc2 = Agent_GetAgentByPlayerNumber($JEREK_MODEL)
    If $npc2 <> 0 Then
        Agent_GoNPC($npc2)
        Sleep(3000)
        Ui_UpdateQuest($qid)
        Sleep(3000)
    EndIf
    Local $mt2 = Quest_GetQuestInfo($qid, "MapTo")
    Local $ls2 = Quest_GetQuestInfo($qid, "LogState")
    Out("[BN] TalkJerek seq2 result: ls=" & $ls2 & " mt=" & $mt2)
    If $ls2 <= 0 Then Return True
    If $mt2 <> $mtBefore Then Return True
    Out("[BN] TalkJerek seq3 (Game_Dialog UpdateQuest)")
    Local $npc3 = Agent_GetAgentByPlayerNumber($JEREK_MODEL)
    If $npc3 <> 0 Then Agent_GoNPC($npc3)
    Sleep(2500)
    Bot_Dialog(0x827E04)  
    Sleep(3000)
    Local $mt3 = Quest_GetQuestInfo($qid, "MapTo")
    Local $ls3 = Quest_GetQuestInfo($qid, "LogState")
    Out("[BN] TalkJerek seq3 result: ls=" & $ls3 & " mt=" & $mt3)
    If $ls3 <= 0 Then Return True
    If $mt3 <> $mtBefore Then Return True
    Out("[BN] TalkJerek seq4 (RewardQuest638)")
    Local $npc4 = Agent_GetAgentByPlayerNumber($JEREK_MODEL)
    If $npc4 <> 0 Then Agent_GoNPC($npc4)
    Sleep(2500)
    Ui_RewardQuest($qid)
    Sleep(5000)
    Local $mt4 = Quest_GetQuestInfo($qid, "MapTo")
    Local $ls4 = Quest_GetQuestInfo($qid, "LogState")
    Out("[BN] TalkJerek seq4 result: ls=" & $ls4 & " mt=" & $mt4)
    If $ls4 <= 0 Then Return True
    If $mt4 <> $mtBefore Then Return True
    Out("[BN] TalkJerek seq5 (AcceptReward Game_Dialog)")
    Local $npc5 = Agent_GetAgentByPlayerNumber($JEREK_MODEL)
    If $npc5 <> 0 Then Agent_GoNPC($npc5)
    Sleep(2500)
    Bot_Dialog($rewardHex)  
    Sleep(5000)
    Local $mt5 = Quest_GetQuestInfo($qid, "MapTo")
    Local $ls5 = Quest_GetQuestInfo($qid, "LogState")
    Out("[BN] TalkJerek seq5 result: ls=" & $ls5 & " mt=" & $mt5)
    If $ls5 <= 0 Then Return True
    If $mt5 <> $mtBefore Then Return True
    Out("[BN] FAIL TalkJerek: ninguna secuencia avanzó la quest (ls=" & $ls5 & " mt=" & $mt5 & ")")
    Return False
EndFunc
Func _BN_EnterPlainsOfJarin()
    If Map_GetMapID() = 430 Then Return True
    If Not _SD_TravelToMap(431, "Sunspear Great Hall") Then Return False
    Out("[BN] Party_FillWithHenchmen para SGH antes de salir")
    Party_FillWithHenchmen()
    Sleep(2000)
    Out("[BN] SGH→Plains: nav a gadget (-3294,4022) + GoSignpost")
    Map_Move(-3294, 4022, 0)
    Local $tNav = TimerInit()
    While Not Bot_ShouldStop() And TimerDiff($tNav) < 15000
        Local $cx = Agent_GetAgentInfo(-2, "X"), $cy = Agent_GetAgentInfo(-2, "Y")
        If Sqrt(($cx+3294)^2 + ($cy-4022)^2) < 250 Then ExitLoop
        Sleep(400)
    WEnd
    Local $portalAg = Agent_GetAgentByPlayerNumber(30740)
    If $portalAg <> 0 Then
        Out("[BN] SGH→Plains: GoSignpost gadget agent=" & $portalAg)
        Agent_GoSignpost($portalAg)
    Else
        Out("[BN] SGH→Plains: gadget no encontrado, fallback Map_Move offsets")
    EndIf
    Local $t = TimerInit(), $tRe = TimerInit(), $tOff = TimerInit(), $idx = 0
    Local $offsets[9][2] = [[0,0],[200,-400],[-200,-400],[400,-200],[-400,-200],[0,-600],[600,0],[-600,0],[0,600]]
    While Not Bot_ShouldStop() And TimerDiff($t) < 45000
        If Map_GetMapID() = 430 Then ExitLoop
        If TimerDiff($tRe) >= 3000 Then
            Map_Move(-3294 + $offsets[$idx][0], 4022 + $offsets[$idx][1], 0)
            $tRe = TimerInit()
        EndIf
        If TimerDiff($tOff) >= 6000 Then
            $idx = Mod($idx + 1, 9)
            $tOff = TimerInit()
            $tRe = TimerInit()
        EndIf
        Sleep(400)
    WEnd
    If Map_GetMapID() <> 430 Then
        Out("[BN] FAIL: no se cruzó SGH→Plains (map=" & Map_GetMapID() & ")")
        Return False
    EndIf
    Map_WaitMapLoading(430, $GC_I_MAP_TYPE_EXPLORABLE)
    _SD_WaitForNPCs(6000)
    Out("[BN] En Plains of Jarin (desde SGH)")
    Return True
EndFunc
Func _BN_EnterMehtaniKeys()
    If Map_GetMapID() = 488 And Map_GetInstanceInfo("Type") = $GC_I_MAP_TYPE_EXPLORABLE Then Return True
    If Map_GetMapID() <> 489 Then
        Out("[BN] EnterMehtani: no en Kodlonu (map=" & Map_GetMapID() & ")")
        Return False
    EndIf
    Local $gadgetX = 4395, $gadgetY = -3962
    Local $crossX  = 5000, $crossY  = -3500
    If Not ProcessExists("gw.exe") Then
        Out("[BN] EnterMehtani ABORT: gw.exe ausente (crash)")
        Return False
    EndIf
    Out("[BN] EnterMehtani: nav al gadget (" & $gadgetX & "," & $gadgetY & ")...")
    Map_Move($gadgetX, $gadgetY, 0)
    Local $tPre = TimerInit(), $tRePre = TimerInit()
    While Not Bot_ShouldStop() And TimerDiff($tPre) < 30000
        If Not ProcessExists("gw.exe") Then Return False
        If Map_GetMapID() = 488 And Map_GetInstanceInfo("Type") = $GC_I_MAP_TYPE_EXPLORABLE Then
            Map_WaitMapLoading(488, $GC_I_MAP_TYPE_EXPLORABLE)
            _SD_WaitForNPCs(6000)
            Return True
        EndIf
        Local $myX = Agent_GetAgentInfo(-2, "X"), $myY = Agent_GetAgentInfo(-2, "Y")
        If Sqrt(($myX-$gadgetX)^2+($myY-$gadgetY)^2) < 600 Then ExitLoop
        If TimerDiff($tRePre) >= 3000 Then
            Map_Move($gadgetX, $gadgetY, 0)
            $tRePre = TimerInit()
        EndIf
        Sleep(400)
    WEnd
    Out("[BN] EnterMehtani: cruzando (" & $crossX & "," & $crossY & ")...")
    Map_Move($crossX, $crossY, 0)
    Local $tPortal = TimerInit(), $tRePortal = TimerInit()
    While Not Bot_ShouldStop() And TimerDiff($tPortal) < 30000
        If Not ProcessExists("gw.exe") Then Return False
        If Map_GetMapID() = 488 And Map_GetInstanceInfo("Type") = $GC_I_MAP_TYPE_EXPLORABLE Then ExitLoop
        If Map_GetInstanceInfo("IsLoading") Then
            $tRePortal = TimerInit()
            ContinueLoop
        EndIf
        If TimerDiff($tRePortal) >= 2500 Then
            Map_Move($crossX, $crossY, 0)
            $tRePortal = TimerInit()
        EndIf
        Sleep(400)
    WEnd
    If Map_GetMapID() = 488 And Map_GetInstanceInfo("Type") = $GC_I_MAP_TYPE_EXPLORABLE Then
        Out("[BN] EnterMehtani: cruzado OK (explorable)")
        Map_WaitMapLoading(488, $GC_I_MAP_TYPE_EXPLORABLE)
        _SD_WaitForNPCs(6000)
        Return True
    EndIf
    Out("[BN] EnterMehtani FAIL (map=" & Map_GetMapID() & " type=" & Map_GetInstanceInfo("Type") & ")")
    Return False
EndFunc
Func _BN_FindJerek()
    If Map_GetMapID() <> 430 Then Return 0
    Local $jerek = _SD_FindNPC("Jerek")
    If $jerek <> 0 Then Return $jerek
    Out("[BN] Jerek no visible, navegando por waypoints hacia SGH portal...")
    Local $wps[5][2] = [[13500,2400],[5900,1263],[214,2582],[-1412,2197],[-3127,3705]]
    For $wi = 0 To 4
        $jerek = _SD_FindNPC("Jerek")
        If $jerek <> 0 Then Return $jerek
        Map_Move($wps[$wi][0], $wps[$wi][1], 0)
        Local $tWP = TimerInit(), $tReWP = TimerInit()
        While Not Bot_ShouldStop() And TimerDiff($tWP) < 20000
            $jerek = _SD_FindNPC("Jerek")
            If $jerek <> 0 Then Return $jerek
            Local $cx = Agent_GetAgentInfo(-2,"X"), $cy = Agent_GetAgentInfo(-2,"Y")
            If Sqrt(($cx-$wps[$wi][0])^2+($cy-$wps[$wi][1])^2) < 1200 Then ExitLoop
            If TimerDiff($tReWP) >= 2500 Then
                Map_Move($wps[$wi][0], $wps[$wi][1], 0)
                $tReWP = TimerInit()
            EndIf
            Sleep(500)
        WEnd
    Next
    Return $jerek
EndFunc
Func _BN_FindNPCNearMarker($mx, $my, $radius = 600)
    If Map_GetMapID() <> 430 Then Return 0
    Out("[BN] Navegando a marker (" & Round($mx) & "," & Round($my) & ") para buscar NPC...")
    Map_Move($mx, $my, 0)
    Local $tNav = TimerInit(), $tRe = TimerInit()
    While Not Bot_ShouldStop() And TimerDiff($tNav) < 30000
        Local $cx = Agent_GetAgentInfo(-2, "X"), $cy = Agent_GetAgentInfo(-2, "Y")
        If Sqrt(($cx-$mx)^2+($cy-$my)^2) < 800 Then ExitLoop
        If TimerDiff($tRe) >= 2500 Then
            Map_Move($mx, $my, 0)
            $tRe = TimerInit()
        EndIf
        Sleep(400)
    WEnd
    Out("[BN] Cerca marker, dist=" & Round(Sqrt((Agent_GetAgentInfo(-2,"X")-$mx)^2+(Agent_GetAgentInfo(-2,"Y")-$my)^2)) & "u. Buscando NPCs:")
    Local $arr = Agent_GetAgentArray($GC_I_AGENT_TYPE_LIVING)
    Local $best = 0, $bestD = $radius
    If IsArray($arr) Then
        For $i = 0 To UBound($arr) - 1
            If $arr[$i] = 0 Then ContinueLoop
            Local $alleg = Agent_GetAgentInfo($arr[$i], "Allegiance")
            If $alleg <> $GC_I_ALLEGIANCE_NPC And $alleg <> $GC_I_ALLEGIANCE_ALLY Then ContinueLoop
            Local $ax = Agent_GetAgentInfo($arr[$i], "X")
            Local $ay = Agent_GetAgentInfo($arr[$i], "Y")
            Local $nm = Agent_GetAgentInfo($arr[$i], "Name")
            Local $d = Sqrt(($ax-$mx)^2+($ay-$my)^2)
            Out("[BN] NPC cercano: '" & $nm & "' model=" & Agent_GetAgentInfo($arr[$i],"PlayerNumber") & " pos=(" & Round($ax) & "," & Round($ay) & ") d=" & Round($d) & "u")
            If $d < $bestD Then
                $bestD = $d
                $best = $arr[$i]
            EndIf
        Next
    EndIf
    Return $best
EndFunc
Func _BN_MehtaniObjective($qid)
    If Map_GetMapID() <> 488 Then
        Out("[BN] MehtaniObj: no en Mehtani Keys (map=" & Map_GetMapID() & ")")
        Return False
    EndIf
    Local $mrkX = Quest_GetQuestInfo($qid, "MarkerX")   
    Local $mrkY = Quest_GetQuestInfo($qid, "MarkerY")   
    Out("[BN] Mehtani: marker=(" & $mrkX & "," & $mrkY & ") ls=" & Quest_GetQuestInfo($qid,"LogState") & " mt=" & Quest_GetQuestInfo($qid,"MapTo"))
    If Quest_GetQuestInfo($qid, "LogState") <= 0 Then Return True
    Local $mtNow = Quest_GetQuestInfo($qid, "MapTo")
    If $mtNow <> 488 And $mtNow > 0 Then Return True
    Local $aMKRoute[8][2] = [ _
        [-13544, 12133], _
        [-11965, 10099], _
        [-12042,  9786], _
        [-12824,  7392], _
        [ -9643,  3060], _
        [ -8500,  2400], _
        [ -7383,  1746], _
        [ -7811,  2458]  _
    ]
    Local $iStart = 0, $dBestWP = 999999999
    Local $myX0 = Agent_GetAgentInfo(-2, "X"), $myY0 = Agent_GetAgentInfo(-2, "Y")
    For $i = 0 To UBound($aMKRoute) - 1
        Local $dW = Sqrt(($myX0-$aMKRoute[$i][0])^2 + ($myY0-$aMKRoute[$i][1])^2)
        If $dW < $dBestWP Then
            $dBestWP = $dW
            $iStart = $i
        EndIf
    Next
    For $i = $iStart To UBound($aMKRoute) - 1
        If Map_GetMapID() <> 488 Then Return False
        Local $mtLoop = Quest_GetQuestInfo($qid, "MapTo")
        If Quest_GetQuestInfo($qid, "LogState") <= 0 Then Return True
        If $mtLoop <> 488 And $mtLoop > 0 Then Return True
        Out("[BN] Mehtani WP" & ($i+1) & "/" & UBound($aMKRoute) & " -> (" & $aMKRoute[$i][0] & "," & $aMKRoute[$i][1] & ")")
        If Not _Mission_DoNavThrough($aMKRoute[$i][0], $aMKRoute[$i][1]) Then
            Out("[BN] WARN: Mehtani WP" & ($i+1) & " incompleto - continuando ruta")
        EndIf
    Next
    If Not ProcessExists("gw.exe") Then Return False
    If Quest_GetQuestInfo($qid, "LogState") <= 0 Then Return True
    $mtNow = Quest_GetQuestInfo($qid, "MapTo")
    If $mtNow <> 488 And $mtNow > 0 Then Return True
    Out("[BN] Mehtani: ruta oeste completada -> DoNavCombat al marker")
    _Mission_DoNavCombat($mrkX, $mrkY)
    If Not ProcessExists("gw.exe") Then Return False
    If Quest_GetQuestInfo($qid, "LogState") <= 0 Then Return True
    $mtNow = Quest_GetQuestInfo($qid, "MapTo")
    If $mtNow <> 488 And $mtNow > 0 Then Return True
    Local Const $ITEM_AREA_X = -6800, $ITEM_AREA_Y = -2800
    Local Const $ITEM_RADIUS = 1500
    Out("[BN] Mehtani: nav al área de items (" & $ITEM_AREA_X & "," & $ITEM_AREA_Y & ")...")
    Map_Move($ITEM_AREA_X, $ITEM_AREA_Y, 0)
    Local $tNavArea = TimerInit()
    While TimerDiff($tNavArea) < 8000
        If Not ProcessExists("gw.exe") Then Return False
        Local $cxN = Agent_GetAgentInfo(-2, "X"), $cyN = Agent_GetAgentInfo(-2, "Y")
        If Sqrt(($cxN-$ITEM_AREA_X)^2+($cyN-$ITEM_AREA_Y)^2) < 400 Then ExitLoop
        Sleep(200)
    WEnd
    Out("[BN] Mehtani: recogiendo items del área (por proximidad)...")
    Local $tItem = TimerInit(), $tReNav = TimerInit()
    Local $bDumpedItems = False
    While Not Bot_ShouldStop() And TimerDiff($tItem) < 60000
        If Not ProcessExists("gw.exe") Then Return False
        If Quest_GetQuestInfo($qid, "LogState") <= 0 Then Return True
        Local $mtC = Quest_GetQuestInfo($qid, "MapTo")
        If $mtC <> 488 And $mtC > 0 Then
            Out("[BN] Mehtani: mt=" & $mtC & " → objetivo completado")
            Return True
        EndIf
        Local $items = Agent_GetAgentArray($GC_I_AGENT_TYPE_ITEM)
        Local $nItems = (IsArray($items) And UBound($items) > 0) ? $items[0] : 0
        If Not $bDumpedItems Then
            Out("[BN] Mehtani DUMP items: count=" & $nItems)
            $bDumpedItems = True
        EndIf
        Local $bPickedThisPass = False
        If IsArray($items) And $items[0] > 0 Then
            For $i = 1 To $items[0]
                Local $ptr = $items[$i]
                If $ptr = 0 Then ContinueLoop
                Local $agentId = Agent_GetAgentInfo($ptr, "ID")
                If $agentId = 0 Then ContinueLoop
                Local $iX = Agent_GetAgentInfo($ptr, "X")
                Local $iY = Agent_GetAgentInfo($ptr, "Y")
                Local $dArea = Sqrt(($ITEM_AREA_X-$iX)^2+($ITEM_AREA_Y-$iY)^2)
                Local $iFull = Item_GetItemInfoByAgentID($agentId, "CompleteName")
                If $iFull = 0 Then $iFull = ""
                Out("[BN] GroundItem id=" & $agentId & " name='" & $iFull & "' pos=(" & Round($iX) & "," & Round($iY) & ") dArea=" & Round($dArea) & "u")
                If $dArea > $ITEM_RADIUS Then ContinueLoop
                Local $cx = Agent_GetAgentInfo(-2, "X"), $cy = Agent_GetAgentInfo(-2, "Y")
                Local $dChar = Sqrt(($cx-$iX)^2+($cy-$iY)^2)
                If $dChar > 200 Then
                    Map_Move($iX, $iY, 0)
                    Local $tWalk = TimerInit()
                    While TimerDiff($tWalk) < 6000
                        If Not ProcessExists("gw.exe") Then Return False
                        $cx = Agent_GetAgentInfo(-2, "X")
                        $cy = Agent_GetAgentInfo(-2, "Y")
                        If Sqrt(($cx-$iX)^2+($cy-$iY)^2) < 180 Then ExitLoop
                        Sleep(200)
                    WEnd
                EndIf
                Out("[BN] Mehtani: recogiendo item id=" & $agentId & " '" & $iFull & "'")
                Agent_ChangeTarget($agentId)
                Sleep(150)
                Item_PickUpItem($agentId)
                Sleep(600)
                $bPickedThisPass = True
                $bDumpedItems = False
                If Quest_GetQuestInfo($qid, "LogState") <= 0 Then Return True
                Local $mtP = Quest_GetQuestInfo($qid, "MapTo")
                If $mtP <> 488 And $mtP > 0 Then
                    Out("[BN] Mehtani: item recogido, mt=" & $mtP & " → avanzado")
                    Return True
                EndIf
            Next
        EndIf
        If Not $bPickedThisPass And TimerDiff($tReNav) >= 5000 Then
            Map_Move($ITEM_AREA_X, $ITEM_AREA_Y, 0)
            $tReNav = TimerInit()
        EndIf
        Sleep(500)
    WEnd
    Out("[BN] Mehtani: TIMEOUT (mt=" & Quest_GetQuestInfo($qid,"MapTo") & " ls=" & Quest_GetQuestInfo($qid,"LogState") & ")")
    Return False
EndFunc