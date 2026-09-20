#include-once
Func MoveTo($aX, $aY, $aAggroRange = 1250, $aRandom = 50)
    Local $MyOldMap = Map_GetMapID(), $lMapLoadingOld = Map_GetInstanceInfo("Type")
    Local $lDestX = $aX + Random(-$aRandom, $aRandom)
    Local $lDestY = $aY + Random(-$aRandom, $aRandom)
    If Agent_GetAgentInfo(-2, "IsDead") Then Return False
    Map_Move($lDestX, $lDestY, 0)
    Do
        If Map_GetMapID() <> $MyOldMap Or Map_GetInstanceInfo("Type") <> $lMapLoadingOld Or Agent_GetAgentInfo(-2, "IsDead") Then ExitLoop
        If Agent_GetAgentInfo(-2, "MoveX") == 0 And Agent_GetAgentInfo(-2, "MoveY") == 0 Then
            $lDestX = $aX + Random(-$aRandom, $aRandom)
            $lDestY = $aY + Random(-$aRandom, $aRandom)
            Map_Move($lDestX, $lDestY, 0)
            Sleep(640)
        EndIf
        Map_Move($lDestX, $lDestY, 0)
        UAI_Fight($aX, $aY, $aAggroRange, 3500, $g_i_FinisherMode)
        Sleep(32)
    Until Agent_GetDistanceToXY($lDestX, $lDestY) < 75 Or Map_GetMapID() <> $MyOldMap Or Map_GetInstanceInfo("Type") <> $lMapLoadingOld Or Agent_GetAgentInfo(-2, "IsDead")
EndFunc   
Func Agent_Filter_IsGadgetOrLiving($aAgentPtr)
    If Agent_GetAgentInfo($aAgentPtr, "IsLivingType") Then Return True
    If Agent_GetAgentInfo($aAgentPtr, "IsGadgetType") Then Return True
    Return False
EndFunc
Func Agent_Filter_IsGadget($aAgentPtr)
    If Agent_GetAgentInfo($aAgentPtr, "IsGadgetType") Then Return True
    Return False
EndFunc
Func FilterObstacle()
    If Map_GetInstanceInfo("IsOutpost") Then Return Agent_GetAgentsAsObstacles(1200, 85, "Agent_Filter_IsGadgetOrLiving")
    If Map_GetInstanceInfo("IsExplorable") Then Return Agent_GetAgentsAsObstacles(1200, 85, "Agent_Filter_IsGadget")
    Return 0
EndFunc
Global $g_iCombatCacheMapID = 0
Func _EnsureCombatCache()
    If Map_GetInstanceInfo("Type") <> $GC_I_MAP_TYPE_EXPLORABLE Then Return
    Local $m = Map_GetMapID()
    If $m = $g_iCombatCacheMapID Then Return
    Cache_SkillBar()
    $g_iCombatCacheMapID = $m
EndFunc
Func MoveToFollowPath($aX, $aY, $aAggroRange = 1250, $aCallFunc = "_MarkEnemiesCallback")
    If $g_bRegistroMode Then Return
    If Bot_ShouldStop() Then
        Out("[MoveToFollowPath] SKIP: Bot_ShouldStop")
        Return
    EndIf
    If Map_GetMapID() = 0 Then
        Out("[MoveToFollowPath] SKIP: Map=0 (loading o no en mundo)")
        Return
    EndIf
    If Agent_GetAgentInfo(-2, "IsDead") Then
        Out("[MoveToFollowPath] SKIP: char muerto (evitar crash pathfinder)")
        Return
    EndIf
    If Map_GetInstanceInfo("IsLoading") Then
        Out("[MoveToFollowPath] SKIP: IsLoading=True")
        Return
    EndIf
    If Agent_GetAgentInfo(-2, "MaxHP") = 0 Then
        Out("[MoveToFollowPath] SKIP: char MaxHP=0 (no cargado)")
        Return
    EndIf
    _EnsureCombatCache()
    Pathfinder_MoveTo($aX, $aY, -1, "FilterObstacle", $aAggroRange, 3500, $g_i_FinisherMode, $aCallFunc)
EndFunc
Global $g_MoveSmooth_MinDist = 150     
Global $g_MoveSmooth_CheckMs = 3000    
Global $g_MoveSmooth_SleepMs = 200     
Func MoveToFollowPath_Smooth($aX, $aY, $aAggroRange = 1250, $aCallFunc = "_MarkEnemiesCallback")
    If $g_bRegistroMode Then Return
    If Bot_ShouldStop() Then
        Out("[MoveSmooth] SKIP: Bot_ShouldStop")
        Return
    EndIf
    If Map_GetMapID() = 0 Then
        Out("[MoveSmooth] SKIP: Map=0 (loading o no en mundo)")
        Return
    EndIf
    If Agent_GetAgentInfo(-2, "IsDead") Then
        Out("[MoveSmooth] SKIP: char muerto")
        Return
    EndIf
    If Map_GetInstanceInfo("IsLoading") Then
        Out("[MoveSmooth] SKIP: IsLoading=True")
        Return
    EndIf
    If Agent_GetAgentInfo(-2, "MaxHP") = 0 Then
        Out("[MoveSmooth] SKIP: MaxHP=0 (no cargado)")
        Return
    EndIf
    _EnsureCombatCache()
    Local $startX = Agent_GetAgentInfo(-2, "X")
    Local $startY = Agent_GetAgentInfo(-2, "Y")
    Local $lastX = $startX
    Local $lastY = $startY
    Local $tCheck = TimerInit()
    Local $unstucks = 0
    Local $tStart = TimerInit()
    Local $maxMs = 45000   
    While TimerDiff($tStart) < $maxMs
        If Bot_ShouldStop() Then ExitLoop
        If Map_GetMapID() = 0 Then ExitLoop
        If Agent_GetAgentInfo(-2, "IsDead") Then ExitLoop
        If Map_GetInstanceInfo("IsLoading") Then ExitLoop
        Local $cx = Agent_GetAgentInfo(-2, "X")
        Local $cy = Agent_GetAgentInfo(-2, "Y")
        Local $dist = Sqrt(($aX - $cx)^2 + ($aY - $cy)^2)
        If $dist < 200 Then
            Out("[MoveSmooth] Llegado dist=" & Round($dist, 0) & "u en " & Round(TimerDiff($tStart)/1000, 1) & "s")
            ExitLoop
        EndIf
        If TimerDiff($tCheck) >= $g_MoveSmooth_CheckMs Then
            Local $moved = Sqrt(($cx - $lastX)^2 + ($cy - $lastY)^2)
            If $moved < $g_MoveSmooth_MinDist Then
                $unstucks += 1
                Out("[MoveSmooth] STUCK: solo " & Round($moved, 0) & "u en 3s (dist=" & Round($dist, 0) & "u) -> Unstuck #" & $unstucks)
                If $unstucks >= 3 Then
                    Out("[MoveSmooth] 3 unstucks fallidos -> abort (dist=" & Round($dist, 0) & "u)")
                    ExitLoop
                EndIf
                Recovery_Unstuck()
                Sleep(500)
            Else
                $unstucks = 0   
            EndIf
            $lastX = $cx
            $lastY = $cy
            $tCheck = TimerInit()
        EndIf
        Pathfinder_MoveTo($aX, $aY, $g_MoveSmooth_SleepMs, "FilterObstacle", $aAggroRange, 3500, $g_i_FinisherMode, $aCallFunc)
    WEnd
EndFunc
Func _CountEnemies($range = 0, $modelID = 0)
    Local $agents = Agent_GetAgentArray($GC_I_AGENT_TYPE_LIVING)
    If Not IsArray($agents) Or $agents[0] = 0 Then Return 0
    Local $count = 0
    Local $myX = 0, $myY = 0
    If $range > 0 Then
        $myX = Agent_GetAgentInfo(-2, "X")
        $myY = Agent_GetAgentInfo(-2, "Y")
    EndIf
    For $i = 1 To $agents[0]
        Local $ptr = $agents[$i]
        If $ptr = 0 Then ContinueLoop
        If Agent_GetAgentInfo($ptr, "Allegiance") <> $GC_I_ALLEGIANCE_ENEMY Then ContinueLoop
        If Agent_GetAgentInfo($ptr, "HP") <= 0 Then ContinueLoop
        If Agent_GetAgentInfo($ptr, "IsDead") Then ContinueLoop
        If $modelID <> 0 And Agent_GetAgentInfo($ptr, "PlayerNumber") <> $modelID Then ContinueLoop
        If $range > 0 Then
            Local $aX = Agent_GetAgentInfo($ptr, "X")
            Local $aY = Agent_GetAgentInfo($ptr, "Y")
            If Sqrt(($aX - $myX)^2 + ($aY - $myY)^2) > $range Then ContinueLoop
        EndIf
        $count += 1
    Next
    Return $count
EndFunc
Global $g_waypointCount = 0
Global $g_bCombatIgnoreSpirits = True
Global $g_bCombatIgnoreMinions = True
Func _Char_IsReallyDead()
    If Not Agent_GetAgentInfo(-2, "IsDead") Then Return False
    Local $maxHp = Number(Agent_GetAgentInfo(-2, "MaxHP"))
    Local $cx = Agent_GetAgentInfo(-2, "X")
    Local $cy = Agent_GetAgentInfo(-2, "Y")
    If $maxHp <= 0 Or ($cx = 0 And $cy = 0) Then Return False   
    Return True
EndFunc
Func _CaptureWaypoint()
    Local $cX = Agent_GetAgentInfo(-2, "X")
    Local $cY = Agent_GetAgentInfo(-2, "Y")
    Local $map = Map_GetMapID()
    $g_waypointCount += 1
    Out("[Waypoint] #" & $g_waypointCount & " pos=(" & Round($cX, 0) & "," & Round($cY, 0) & ") map=" & $map)
    Local $ts = StringFormat("%04d-%02d-%02d %02d:%02d:%02d", _
            @YEAR, @MON, @MDAY, @HOUR, @MIN, @SEC)
    Local $line = $ts & " #" & $g_waypointCount & " map=" & $map & " pos=(" & Round($cX, 0) & "," & Round($cY, 0) & ")" & @CRLF
    FileWrite(@ScriptDir & "\waypoints.txt", $line)
EndFunc
Func _CaptureTarget()
    Local $tgt = Agent_GetAgentInfo(-1, "ID")
    If $tgt = 0 Then
        Out("[Target] Sin target seleccionado")
        Return
    EndIf
    Local $model = Agent_GetAgentInfo($tgt, "PlayerNumber")
    Local $tx = Agent_GetAgentInfo($tgt, "X")
    Local $ty = Agent_GetAgentInfo($tgt, "Y")
    Local $alleg = Agent_GetAgentInfo($tgt, "Allegiance")
    Local $type = Agent_GetAgentInfo($tgt, "Type")
    Local $hp = Agent_GetAgentInfo($tgt, "HP")
    Local $maxHp = Agent_GetAgentInfo($tgt, "MaxHP")
    Local $dist = Agent_GetDistance(-2, $tgt)
    Local $map = Map_GetMapID()
    Local $quest = World_GetWorldInfo("ActiveQuestID")
    Out("[Target] id=" & $tgt & " model=" & $model & " pos=(" & Round($tx, 0) & "," & Round($ty, 0) & ") dist=" & Round($dist, 0) & "u alleg=" & $alleg & " type=" & $type & " hp=" & Round($hp*100, 0) & "% map=" & $map & " quest=0x" & Hex($quest, 4))
    Local $ts = StringFormat("%04d-%02d-%02d %02d:%02d:%02d", _
            @YEAR, @MON, @MDAY, @HOUR, @MIN, @SEC)
    Local $line = $ts & " map=" & $map & " model=" & $model & " pos=(" & Round($tx, 0) & "," & Round($ty, 0) & ") quest=0x" & Hex($quest, 4) & " alleg=" & $alleg & " type=" & $type & @CRLF
    FileWrite(@ScriptDir & "\targets.txt", $line)
EndFunc
Func _LogEnemies($range = 0, $modelID = 0)
    Local $agents = Agent_GetAgentArray($GC_I_AGENT_TYPE_LIVING)
    If Not IsArray($agents) Or $agents[0] = 0 Then
        Out("[Enemies] Sin agents living en el mapa")
        Return 0
    EndIf
    Local $myX = Agent_GetAgentInfo(-2, "X")
    Local $myY = Agent_GetAgentInfo(-2, "Y")
    Local $count = 0
    Local $filterDesc = ""
    If $range > 0 Then $filterDesc &= " range<=" & $range & "u"
    If $modelID > 0 Then $filterDesc &= " model=" & $modelID
    Out("[Enemies] === Listado enemies vivos" & $filterDesc & " ===")
    For $i = 1 To $agents[0]
        Local $ptr = $agents[$i]
        If $ptr = 0 Then ContinueLoop
        If Agent_GetAgentInfo($ptr, "Allegiance") <> $GC_I_ALLEGIANCE_ENEMY Then ContinueLoop
        If Agent_GetAgentInfo($ptr, "HP") <= 0 Then ContinueLoop
        If Agent_GetAgentInfo($ptr, "IsDead") Then ContinueLoop
        If $modelID <> 0 And Agent_GetAgentInfo($ptr, "PlayerNumber") <> $modelID Then ContinueLoop
        Local $aId = Agent_GetAgentInfo($ptr, "ID")
        Local $aModel = Agent_GetAgentInfo($ptr, "PlayerNumber")
        Local $aX = Agent_GetAgentInfo($ptr, "X")
        Local $aY = Agent_GetAgentInfo($ptr, "Y")
        Local $aHP = Agent_GetAgentInfo($ptr, "HP")
        Local $dist = Sqrt(($aX - $myX)^2 + ($aY - $myY)^2)
        If $range > 0 And $dist > $range Then ContinueLoop
        Out("[Enemies] AgentID=" & $aId & " Model=" & $aModel & " pos=(" & Round($aX, 0) & "," & Round($aY, 0) & ") HP=" & Round($aHP*100, 0) & "% dist=" & Round($dist, 0) & "u")
        $count += 1
    Next
    Out("[Enemies] === Total: " & $count & " enemies ===")
    Return $count
EndFunc
Func WaitStartLoading($a_i_WaitTimer = 65000)
    Local $l_i_Timer = TimerInit()
    Do
        Sleep(16)
    Until Other_GetPing() = 0 Or Map_GetInstanceInfo("IsLoading") Or TimerDiff($l_i_Timer) >= $a_i_WaitTimer
    Sleep(250)
EndFunc
Func WaitLoading($a_i_WaitTimer = 65000)
    WaitStartLoading($a_i_WaitTimer)
    Other_WaitPingStabilized(1500)
EndFunc
Func EnemyFilter($aAgentPtr)
    If Agent_GetAgentInfo($aAgentPtr, "Allegiance") <> $GC_I_ALLEGIANCE_ENEMY Then Return False
    If Agent_GetAgentInfo($aAgentPtr, "HP") <= 0 Then Return False
    If Agent_GetAgentInfo($aAgentPtr, "IsDead") > 0 Then Return False
    Local $pn = Agent_GetAgentInfo($aAgentPtr, "PlayerNumber")
    If _Combat_IsIgnoredModel($pn) Then Return False
    If _Combat_IsRangerPet($pn) Then Return False
    If $g_bCombatIgnoreSpirits Or $g_bCombatIgnoreMinions Then
        Local $name = Agent_GetAgentInfo($aAgentPtr, "Name")
        If $g_bCombatIgnoreSpirits And StringInStr($name, "Spirit") Then Return False
        If $g_bCombatIgnoreMinions And StringInStr($name, "Minion") Then Return False
    EndIf
    Return True
EndFunc
Global $g_NE_CacheTimer = 0
Global $g_NE_CachePtr = 0     
Global $g_NE_CacheDist = 0    
Global $g_NE_CacheTtlMs = 10000
Func GetNearestEnemy($range = 5000)
    If $g_NE_CacheTimer <> 0 And TimerDiff($g_NE_CacheTimer) < $g_NE_CacheTtlMs Then
        If $g_NE_CachePtr <> 0 Then
            If $g_NE_CacheDist <= $range Then
                If Agent_GetAgentInfo($g_NE_CachePtr, "HP") > 0 And Not Agent_GetAgentInfo($g_NE_CachePtr, "IsDead") Then Return $g_NE_CachePtr
            EndIf
        EndIf
    EndIf
    Local $v = GetAgents(-2, 5000, $GC_I_AGENT_TYPE_LIVING, 1, "EnemyFilter")
    $g_NE_CachePtr = $v
    $g_NE_CacheDist = ($v <> 0 ? Agent_GetDistance(-2, $v) : 999999)
    $g_NE_CacheTimer = TimerInit()
    If $v <> 0 And $g_NE_CacheDist <= $range Then Return $v
    Return 0
EndFunc
Func NPCFilter($aAgentPtr)
    Local $alleg = Agent_GetAgentInfo($aAgentPtr, 'Allegiance')
    If $alleg <> $GC_I_ALLEGIANCE_NPC And $alleg <> $GC_I_ALLEGIANCE_ALLY Then Return False
    If Agent_GetAgentInfo($aAgentPtr, 'HP') <= 0 Then Return False
    If Agent_GetAgentInfo($aAgentPtr, 'IsDead') > 0 Then Return False
    Return True
EndFunc
Func NPCQuestGiverFilter($aAgentPtr)
    If Agent_GetAgentInfo($aAgentPtr, 'Allegiance') <> $GC_I_ALLEGIANCE_NPC Then Return False
    If Agent_GetAgentInfo($aAgentPtr, 'HP') <= 0 Then Return False
    If Agent_GetAgentInfo($aAgentPtr, 'IsDead') > 0 Then Return False
    Return True
EndFunc
Func GetNearestQuestGiver($range = 1500)
    Return GetAgents(-2, $range, $GC_I_AGENT_TYPE_LIVING, 1, "NPCQuestGiverFilter")
EndFunc
Func GetNearestNPCToAgent($aAgentID = -2, $aRange = 1250, $aType = $GC_I_AGENT_TYPE_LIVING, $aReturnMode = 1, $aCustomFilter = "NPCFilter")
    Return GetAgents($aAgentID, $aRange, $aType, $aReturnMode, $aCustomFilter)
EndFunc
Func GetNearestNPCToXY($aX, $aY, $aRange = 5000, $aType = $GC_I_AGENT_TYPE_LIVING, $aReturnMode = 1, $aCustomFilter = "NPCFilter")
    Return GetAgentsFromXY($aX, $aY, $aRange, $aType, $aReturnMode, $aCustomFilter)
EndFunc
Func Agent_GetAgentByPlayerNumber($a_i_PlayerNumber)
    Local $l_a_AgentArray = Agent_GetAgentArray($GC_I_AGENT_TYPE_LIVING)
    If Not IsArray($l_a_AgentArray) Or $l_a_AgentArray[0] = 0 Then Return 0
    Local $l_i_ClosestID = 0
    Local $l_f_ClosestDistance = 999999
    For $i = 1 To $l_a_AgentArray[0]
        Local $l_p_AgentPtr = $l_a_AgentArray[$i]
        If $l_p_AgentPtr = 0 Then ContinueLoop
        If Agent_GetAgentInfo($l_p_AgentPtr, "PlayerNumber") = $a_i_PlayerNumber Then
            Local $l_i_AgentID = Agent_GetAgentInfo($l_p_AgentPtr, "ID")
            Local $l_f_Distance = Agent_GetDistance($l_i_AgentID)
            If $l_f_Distance < $l_f_ClosestDistance Then
                $l_f_ClosestDistance = $l_f_Distance
                $l_i_ClosestID = $l_i_AgentID
            EndIf
        EndIf
    Next
    Return $l_i_ClosestID
EndFunc
Func NF_SwitchTeleportHandler($x, $y)
    Out("[Switch] CALLBACK invocado en (" & Round($x, 0) & ", " & Round($y, 0) & ")")
    Local $npc = GetNearestNPCToXY($x, $y, 5000, $GC_I_AGENT_TYPE_LIVING, 1, "NPCFilter")
    If $npc = 0 Then
        Out("[Switch] No NPC cerca de switch coord, intento cerca de agent")
        $npc = GetNearestNPCToAgent(-2, 5000, $GC_I_AGENT_TYPE_LIVING, 1, "NPCFilter")
    EndIf
    If $npc = 0 Then
        Out("[Switch] No NPC encontrado")
        Return
    EndIf
    Local $npcX = Agent_GetAgentInfo($npc, "X")
    Local $npcY = Agent_GetAgentInfo($npc, "Y")
    Local $npcModel = Agent_GetAgentInfo($npc, "PlayerNumber")
    Out("[Switch] NPC id=" & $npc & " model=" & $npcModel & " en (" & Round($npcX, 0) & ", " & Round($npcY, 0) & ")")
    MoveTo($npcX, $npcY, 1250, 50)
    Sleep(500)
    Agent_GoNPC($npc)
    Sleep(1200)
    Local $oldMap = Map_GetMapID()
    Local $dialogs[6] = [0x82, 0x84, 0x85, 0x81, 0x83, 0x80]
    For $i = 0 To 5
        Out("[Switch] Probando dialog 0x" & Hex($dialogs[$i], 2))
        Bot_Dialog($dialogs[$i])
        Sleep(1500)
        If Map_GetMapID() <> $oldMap Then
            Out("[Switch] Mapa cambió tras 0x" & Hex($dialogs[$i], 2) & " -- exit")
            Return
        EndIf
    Next
    Out("[Switch] Cascada completa, mapa no cambió")
EndFunc
Func Agent_HasQuest($questId)
    Local $l_i_Size = World_GetWorldInfo("QuestLogSize")
    If $l_i_Size = 0 Or $questId = 0 Then Return 0
    For $l_i_Idx = 0 To $l_i_Size
        Local $l_ai_OffsetQuestLog[5] = [0, 0x18, 0x2C, 0x52C, 0x34 * $l_i_Idx]
        Local $l_ap_QuestPtr = Memory_ReadPtr($g_p_BasePointer, $l_ai_OffsetQuestLog, "long")
        If $l_ap_QuestPtr[1] = $questId Then Return True
    Next
    Return False
EndFunc
Func _LogNPCs($range = 2500)
    Local $agents = Agent_GetAgentArray($GC_I_AGENT_TYPE_LIVING)
    If Not IsArray($agents) Or $agents[0] = 0 Then
        Out("[Scan] Sin agents living en el mapa")
        Return 0
    EndIf
    Local $myX = Agent_GetAgentInfo(-2, "X")
    Local $myY = Agent_GetAgentInfo(-2, "Y")
    Local $count = 0
    For $i = 1 To $agents[0]
        Local $ptr = $agents[$i]
        If $ptr = 0 Then ContinueLoop
        Local $alleg = Agent_GetAgentInfo($ptr, "Allegiance")
        If $alleg <> $GC_I_ALLEGIANCE_NPC And $alleg <> $GC_I_ALLEGIANCE_ALLY Then ContinueLoop
        If Agent_GetAgentInfo($ptr, "HP") <= 0 Then ContinueLoop
        If Agent_GetAgentInfo($ptr, "IsDead") Then ContinueLoop
        Local $aX = Agent_GetAgentInfo($ptr, "X")
        Local $aY = Agent_GetAgentInfo($ptr, "Y")
        Local $dist = Sqrt(($aX - $myX)^2 + ($aY - $myY)^2)
        If $dist > $range Then ContinueLoop
        Local $model = Agent_GetAgentInfo($ptr, "PlayerNumber")
        Local $lbl = ($alleg = $GC_I_ALLEGIANCE_NPC) ? "npc " : "ally"
        Out("[Scan] NPC  model=" & $model & " " & $lbl & " pos=(" & Round($aX, 0) & "," & Round($aY, 0) & ") dist=" & Round($dist, 0))
        $count += 1
    Next
    Return $count
EndFunc
Func _LogQuestLog()
    Local $size = World_GetWorldInfo("QuestLogSize")
    If $size = 0 Then
        Out("[Scan] Quest log vacio")
        Return 0
    EndIf
    Local $active = World_GetWorldInfo("ActiveQuestID")
    Local $count = 0
    For $idx = 0 To $size
        Local $off[5] = [0, 0x18, 0x2C, 0x52C, 0x34 * $idx]
        Local $qp = Memory_ReadPtr($g_p_BasePointer, $off, "long")
        Local $qid = $qp[1]
        If $qid <= 0 Then ContinueLoop
        Local $ls = Quest_GetQuestInfo($qid, "LogState")
        Local $cr = Quest_GetQuestInfo($qid, "CanReward")
        Local $mt = Quest_GetQuestInfo($qid, "MapTo")
        Local $star = ($qid = $active) ? " <ACTIVA" : ""
        Out("[Scan] QUEST " & $qid & " ls=" & $ls & " cr=" & $cr & " mt=" & $mt & $star)
        $count += 1
    Next
    Return $count
EndFunc
Func _ScanArea()
    If Not $Bot_Core_Initialized Then
        Out("[Scan] Core no inicializado")
        Return
    EndIf
    Local $map = Map_GetMapID()
    Local $mx = Round(Agent_GetAgentInfo(-2, "X"), 0)
    Local $my = Round(Agent_GetAgentInfo(-2, "Y"), 0)
    Out("[Scan] === ENTORNO map=" & $map & " pos=(" & $mx & "," & $my & ") ===")
    Local $nNpc = _LogNPCs(2500)
    Gadget_LogNearby(2500)
    Local $nQ = _LogQuestLog()
    Out("[Scan] === " & $nNpc & " npc, " & $nQ & " quests en log ===")
EndFunc