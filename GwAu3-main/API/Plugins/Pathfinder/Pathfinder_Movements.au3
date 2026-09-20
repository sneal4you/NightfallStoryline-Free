#include-once
#include "Pathfinder_Core.au3"
Global $g_aPathfinder_CurrentPath[0][4]  
Global $g_iPathfinder_CurrentPathIndex = 0
Global $g_hPathfinder_LastPathUpdateTime = 0
Global $g_iPathfinder_PathUpdateInterval = 1000      
Global $g_iPathfinder_WaypointReachedDistance = 250 
Global $g_iPathfinder_SimplifyRange = 1250           
Global $g_iPathfinder_ObstacleUpdateInterval = 1000  
Global $g_iPathfinder_StuckCheckInterval = 500      
Global $g_iPathfinder_StuckDistance = 100           
Global $g_iPathfinder_UnstuckDirectionIndex = 0     
Global $g_sPathfinder_SwitchTeleportFunc = ""        
Global $g_iPathfinder_MovementTimeout = 0           
Func Pathfinder_MoveTo($aDestX, $aDestY, $aDestLayer = -1, $aObstacles = 0, $aAggroRange = 1320, $aFightRangeOut = 3500, $aFinisherMode = 0, $aCallFunc = "")
    If Call("Bot_ShouldStop") Then Return False
    Local $lMyOldMap = Map_GetMapID()
    Local $lMapLoadingOld = Map_GetInstanceInfo("Type")
    Local $lMyX = Agent_GetAgentInfo(-2, "X")
    Local $lMyY = Agent_GetAgentInfo(-2, "Y")
	Local $lLayer = Agent_GetAgentInfo(-2, "Plane")
	Local $lNeedPathUpdate = False
	If $lMyX = 0 Or $lMyY = 0 Or $lMyOldMap = 0 Or $lMapLoadingOld = $GC_I_MAP_TYPE_LOADING Then
		Do
			If Call("Bot_ShouldStop") Then Return False
			Sleep(16)
		Until Map_GetMapID() <> 0 And (Agent_GetAgentInfo(-2, "X") <> 0 Or Agent_GetAgentInfo(-2, "Y") <> 0)
		Other_WaitPingStabilized(1500)
		$lMyOldMap = Map_GetMapID()
		$lMapLoadingOld = Map_GetInstanceInfo("Type")
		$lMyX = Agent_GetAgentInfo(-2, "X")
		$lMyY = Agent_GetAgentInfo(-2, "Y")
		$lLayer = Agent_GetAgentInfo(-2, "Plane")
	EndIf
    If $g_hPathfinderDLL = 0 Or $g_hPathfinderDLL = -1 Then
        Local $lInitResult = Pathfinder_Initialize()
        If $lInitResult = 0 Then
            Out("[Pathfinder] ERROR: Failed to initialize DLL")
            If Map_GetMapID() = $lMyOldMap Then
				Map_MoveLayer($aDestX, $aDestY, $lLayer)
			Else
				Agent_CancelAction()
			EndIf
            Return False
        ElseIf $lInitResult = 2 Then
            Out("[Pathfinder] WARNING: maps.rar and maps/ folder not found - pathfinding may not work")
        EndIf
    EndIf
    If Party_GetPartyContextInfo("IsDefeated") Then
        Pathfinder_Shutdown()
        Return False
    EndIf
    Local $lIsDynamicObstacles = IsString($aObstacles) And $aObstacles <> "" And $aObstacles <> "0"
    Local $lCurrentObstacles = 0
    If $lIsDynamicObstacles Then
        $lCurrentObstacles = Call($aObstacles)
    ElseIf IsArray($aObstacles) Then
        $lCurrentObstacles = $aObstacles
    EndIf
    Local $lPath = _Pathfinder_GetPath($lMyX, $lMyY, $lLayer, $aDestX, $aDestY, $aDestLayer, $lCurrentObstacles)
    If Not IsArray($lPath) Or UBound($lPath) = 0 Then
        Local $lEmptyPath[0][4]
        $lPath = $lEmptyPath
		If Map_GetMapID() = $lMyOldMap Then
			Map_MoveLayer($aDestX, $aDestY, $lLayer)
		Else
			Agent_CancelAction()
		EndIf
    EndIf
    $g_aPathfinder_CurrentPath = $lPath
    $g_iPathfinder_CurrentPathIndex = 0
    $g_hPathfinder_LastPathUpdateTime = TimerInit()
    Local $lLastObstacleUpdate = TimerInit()
    Local $lLastStuckCheckTime = TimerInit()
    Local $lLastStuckCheckX = $lMyX
    Local $lLastStuckCheckY = $lMyY
    Local $lStuckCount = 0
    Local $lMoveTimeoutTimer = TimerInit()
    Local $lFightStartTimer = TimerInit()
    Do
        If Call("Bot_ShouldStop") Then Return False
        If $g_iPathfinder_MovementTimeout > 0 And TimerDiff($lMoveTimeoutTimer) > $g_iPathfinder_MovementTimeout Then
            _Pathfinder_Log("Movement timeout (" & $g_iPathfinder_MovementTimeout & "ms) - destination unreachable, aborting")
            Pathfinder_Shutdown()
            Return False
        EndIf
        If (Map_GetMapID() <> $lMyOldMap And Not Game_GetGameInfo("IsCinematic")) Or Map_GetInstanceInfo("Type") <> $lMapLoadingOld Then
            Pathfinder_Shutdown()
            Return False
        EndIf
        If Party_GetPartyContextInfo("IsDefeated") Then
            Pathfinder_Shutdown()
            Return False
        EndIf
		If Agent_GetAgentInfo(-2, "IsDead") Then
			$lNeedPathUpdate = True
			ContinueLoop
		EndIf
        $lMyX = Agent_GetAgentInfo(-2, "X")
        $lMyY = Agent_GetAgentInfo(-2, "Y")
        If $lIsDynamicObstacles And TimerDiff($lLastObstacleUpdate) > $g_iPathfinder_ObstacleUpdateInterval Then
            $lCurrentObstacles = Call($aObstacles)
            $lLastObstacleUpdate = TimerInit()
            $lNeedPathUpdate = True
        EndIf
        If TimerDiff($lLastStuckCheckTime) > $g_iPathfinder_StuckCheckInterval Then
            Local $lMovedDistance = _Pathfinder_Distance($lMyX, $lMyY, $lLastStuckCheckX, $lLastStuckCheckY)
            If $lMovedDistance < $g_iPathfinder_StuckDistance Then
                $lStuckCount += 1
                If $lStuckCount >= 2 Then
                    Local $lUnstuckAngles[8] = [1.5707963, 4.7123890, 0.0, 3.1415927, 0.7853982, 3.9269908, 2.3561945, 5.4977871]
                    Local $lAngle = $lUnstuckAngles[$g_iPathfinder_UnstuckDirectionIndex]
                    If Map_GetMapID() = $lMyOldMap Then
						Map_MoveLayer($lMyX + Cos($lAngle) * 500, $lMyY + Sin($lAngle) * 500, $lLayer)
					Else
						Agent_CancelAction()
					EndIf
                    Sleep(750)
                    $g_iPathfinder_UnstuckDirectionIndex = Mod($g_iPathfinder_UnstuckDirectionIndex + 1, 8)
                    $lStuckCount = 0
					$lNeedPathUpdate = True
                EndIf
            Else
                $lStuckCount = 0
            EndIf
            $lLastStuckCheckX = $lMyX
            $lLastStuckCheckY = $lMyY
            $lLastStuckCheckTime = TimerInit()
        EndIf
        If TimerDiff($g_hPathfinder_LastPathUpdateTime) > $g_iPathfinder_PathUpdateInterval Or $lNeedPathUpdate Then
            $lPath = _Pathfinder_GetPath($lMyX, $lMyY, $lLayer, $aDestX, $aDestY, $aDestLayer, $lCurrentObstacles)
            If IsArray($lPath) And UBound($lPath) > 0 Then
                $g_aPathfinder_CurrentPath = $lPath
                $g_iPathfinder_CurrentPathIndex = 0
            Else
                Local $lEmptyPath[0][4]
                $g_aPathfinder_CurrentPath = $lEmptyPath
                $g_iPathfinder_CurrentPathIndex = 0
            EndIf
            $g_hPathfinder_LastPathUpdateTime = TimerInit()
			$lNeedPathUpdate = False
        EndIf
        If Map_GetInstanceInfo("Type") = $GC_I_MAP_TYPE_EXPLORABLE Then
            UAI_UpdateAgentCache($aAggroRange)
            Local $lDiagEnemyCount = UAI_CountEnemyInPartyAggroRange($aAggroRange)
            If $lDiagEnemyCount <> 0 Then
                _Pathfinder_FightEnemies($aAggroRange, $aFightRangeOut, $aFinisherMode, $lMyOldMap)
                UAI_UpdateAgentCache($aAggroRange)
            Else
                $lFightStartTimer = TimerInit()
            EndIf
        EndIf
        If $g_iPathfinder_CurrentPathIndex >= UBound($g_aPathfinder_CurrentPath) Then
            If Map_GetMapID() = $lMyOldMap Then
				Map_MoveLayer($aDestX, $aDestY, $lLayer)
			Else
				Agent_CancelAction()
			EndIf
        Else
            Local $lWaypointX = $g_aPathfinder_CurrentPath[$g_iPathfinder_CurrentPathIndex][0]
            Local $lWaypointY = $g_aPathfinder_CurrentPath[$g_iPathfinder_CurrentPathIndex][1]
            $lLayer = $g_aPathfinder_CurrentPath[$g_iPathfinder_CurrentPathIndex][2]
            If _Pathfinder_Distance($lMyX, $lMyY, $lWaypointX, $lWaypointY) < $g_iPathfinder_WaypointReachedDistance Then
                Local $lTpType = $g_aPathfinder_CurrentPath[$g_iPathfinder_CurrentPathIndex][3]
                If $lTpType = 3 And $g_sPathfinder_SwitchTeleportFunc <> "" Then
                    _Pathfinder_Log("Switch teleporter reached at (" & Round($lWaypointX, 1) & ", " & Round($lWaypointY, 1) & ") - calling activation callback")
                    Call($g_sPathfinder_SwitchTeleportFunc, $lWaypointX, $lWaypointY)
                EndIf
                $g_iPathfinder_CurrentPathIndex += 1
                If $g_iPathfinder_CurrentPathIndex < UBound($g_aPathfinder_CurrentPath) Then
                    $lWaypointX = $g_aPathfinder_CurrentPath[$g_iPathfinder_CurrentPathIndex][0]
                    $lWaypointY = $g_aPathfinder_CurrentPath[$g_iPathfinder_CurrentPathIndex][1]
                    $lLayer = $g_aPathfinder_CurrentPath[$g_iPathfinder_CurrentPathIndex][2]
                Else
                    $lWaypointX = $aDestX
                    $lWaypointY = $aDestY
                    $lLayer = 0
                EndIf
            EndIf
            If Map_GetMapID() = $lMyOldMap Then
				Map_MoveLayer($lWaypointX, $lWaypointY, $lLayer)
			Else
				Agent_CancelAction()
			EndIf
        EndIf
        If Map_GetInstanceInfo("Type") = $GC_I_MAP_TYPE_EXPLORABLE Then
			If _Pathfinder_ShouldWaitForParty(2000, 1320) Then
				Local $lWaitTimer = TimerInit()
				Do
					If Call("Bot_ShouldStop") Then Return False
					Agent_CancelAction()
					Sleep(250)
				Until _Pathfinder_PartyWithinRange(1320) Or TimerDiff($lWaitTimer) > 30000
			EndIf
            If _Pathfinder_ShouldWaitForResurrection() Then
                _Pathfinder_WaitForResurrection()
            EndIf
		EndIf
		Sleep(32)
		If $aCallFunc <> "" Then Call($aCallFunc)
		If Game_GetGameInfo("IsCinematic") Then Other_WaitPingStabilized(2000)
    Until Agent_GetDistanceToXY($aDestX, $aDestY) < 125
	Agent_CancelAction()
    Pathfinder_Shutdown()
    Return True
EndFunc
Func _Pathfinder_GetPath($aStartX, $aStartY, $aStartLayer, $aDestX, $aDestY, $aDestLayer, $aObstacles)
    Local $lMapID = Map_GetMapID()
    Local $lObstacleCount = 0
    If IsArray($aObstacles) Then $lObstacleCount = UBound($aObstacles)
    _Pathfinder_Log("GetPath: Map=" & $lMapID & " Start=(" & Round($aStartX, 1) & ", " & Round($aStartY, 1) & ") Layer=" & $aStartLayer & " Dest=(" & Round($aDestX, 1) & ", " & Round($aDestY, 1) & ") Obstacles=" & $lObstacleCount)
    Local $lPath = Pathfinder_FindPath($lMapID, $aStartX, $aStartY, $aStartLayer, $aDestX, $aDestY, $aDestLayer, $aObstacles, $g_iPathfinder_SimplifyRange)
    Local $lError = @error
    Local $lExtended = @extended
    If $lError Then
        _Pathfinder_Log("ERROR: FindPathWithObstacles failed - @error=" & $lError & " @extended=" & $lExtended)
        Return 0
    EndIf
    If Not IsArray($lPath) Then
        _Pathfinder_Log("ERROR: FindPathWithObstacles returned non-array")
        Return 0
    EndIf
    _Pathfinder_Log("SUCCESS: Path found with " & UBound($lPath) & " points")
    Return $lPath
EndFunc
Func _Pathfinder_Distance($aX1, $aY1, $aX2, $aY2)
    Return Sqrt(($aX2 - $aX1) ^ 2 + ($aY2 - $aY1) ^ 2)
EndFunc
Func Pathfinder_GetCurrentPath()
    Return $g_aPathfinder_CurrentPath
EndFunc
Func Pathfinder_GetCurrentWaypointIndex()
    Return $g_iPathfinder_CurrentPathIndex
EndFunc
Func Pathfinder_SetPathUpdateInterval($aInterval)
    $g_iPathfinder_PathUpdateInterval = $aInterval
EndFunc
Func Pathfinder_SetWaypointReachedDistance($aDistance)
    $g_iPathfinder_WaypointReachedDistance = $aDistance
EndFunc
Func Pathfinder_SetSimplifyRange($aRange)
    $g_iPathfinder_SimplifyRange = $aRange
EndFunc
Func Pathfinder_SetObstacleUpdateInterval($aInterval)
    $g_iPathfinder_ObstacleUpdateInterval = $aInterval
EndFunc
Func Pathfinder_SetSwitchTeleportCallback($sFuncName)
    $g_sPathfinder_SwitchTeleportFunc = $sFuncName
EndFunc
Func Pathfinder_SetDebug($bEnabled)
    $g_bPathfinder_Debug = $bEnabled
EndFunc
Func _Pathfinder_Log($sMessage)
    If $g_bPathfinder_Debug Then
        Out("[Pathfinder] " & $sMessage)
    EndIf
EndFunc
Func _Pathfinder_ShouldWaitForParty($fMaxDistance = 1800, $fResumeDistance = 1400)
    Local $iEnemyCount = GetAgents(-2, 1250, $GC_I_AGENT_TYPE_LIVING, 0, "_Pathfinder_FilterIsEnemy")
    If $iEnemyCount > 0 Then Return False
    Local $aFlagAll = World_GetWorldInfo("FlagAll")
	If IsArray($aFlagAll) Then
		Local $fX = $aFlagAll[0]
		Local $fY = $aFlagAll[1]
		If _IsFinite($fX) And _IsFinite($fY) Then Return False
	EndIf
    Local $iPartySize = Party_GetPartyContextInfo("TotalPartySize")
    Local $iNearbyCount = _Pathfinder_CountPartyMembersInRange($fResumeDistance)
    If $iNearbyCount >= $iPartySize - 1 Then Return False 
    Local $iTotalCount = _Pathfinder_CountPartyMembersInRange(5000)
    If $iTotalCount < $iPartySize - 1 Then Return False
    Local $iFarthestID = _Pathfinder_GetFarthestPartyMember()
    If $iFarthestID = 0 Then Return False
    Return True
EndFunc
Func _IsFinite($fValue)
    Return ($fValue > -1e30 And $fValue < 1e30)
EndFunc
Func _Pathfinder_PartyWithinRange($fResumeDistance = 1400)
    Local $iEnemyCount = GetAgents(-2, 1200, $GC_I_AGENT_TYPE_LIVING, 0, "_Pathfinder_FilterIsEnemy")
    If $iEnemyCount > 0 Then Return True
    Local $aFlagAll = World_GetWorldInfo("FlagAll")
	If IsArray($aFlagAll) Then
		Local $fX = $aFlagAll[0]
		Local $fY = $aFlagAll[1]
		If _IsFinite($fX) And _IsFinite($fY) Then Return True
	EndIf
    Local $iPartySize = Party_GetPartyContextInfo("TotalPartySize")
    Local $iNearbyCount = _Pathfinder_CountPartyMembersInRange($fResumeDistance)
    Return ($iNearbyCount >= $iPartySize - 1) 
EndFunc
Func _Pathfinder_CountPartyMembersInRange($fRange)
    Local $iCount = 0
    Local $iMyID = Agent_GetMyID()
    Local $iHeroCount = Party_GetPartyContextInfo("HeroCount")
    For $i = 1 To $iHeroCount
        Local $iHeroAgentID = Party_GetMyPartyHeroInfo($i, "AgentID")
        If $iHeroAgentID = 0 Then ContinueLoop
        If Agent_GetAgentInfo($iHeroAgentID, "IsDead") Then ContinueLoop
        Local $fDist = Agent_GetDistance($iHeroAgentID, $iMyID)
        If $fDist <= $fRange Then $iCount += 1
    Next
    Local $iHenchCount = Party_GetPartyContextInfo("HenchmanCount")
    For $i = 1 To $iHenchCount
        Local $iHenchAgentID = Party_GetMyPartyHenchmanInfo($i, "AgentID")
        If $iHenchAgentID = 0 Then ContinueLoop
        If Agent_GetAgentInfo($iHenchAgentID, "IsDead") Then ContinueLoop
        Local $fDist = Agent_GetDistance($iHenchAgentID, $iMyID)
        If $fDist <= $fRange Then $iCount += 1
    Next
    Return $iCount
EndFunc
Func _Pathfinder_GetFarthestPartyMember()
    Local $iFarthestID = 0
    Local $fFarthestDist = 0
    Local $iMyID = Agent_GetMyID()
    Local $iHeroCount = Party_GetPartyContextInfo("HeroCount")
    For $i = 1 To $iHeroCount
        Local $fFlagX = Party_GetHeroFlagInfo($i, "FlagX")
        Local $fFlagY = Party_GetHeroFlagInfo($i, "FlagY")
        If $fFlagX <> 0 Or $fFlagY <> 0 Then ContinueLoop
        Local $iHeroAgentID = Party_GetMyPartyHeroInfo($i, "AgentID")
        If $iHeroAgentID = 0 Then ContinueLoop
        If Agent_GetAgentInfo($iHeroAgentID, "IsDead") Then ContinueLoop
        Local $fDist = Agent_GetDistance($iHeroAgentID, $iMyID)
        If $fDist > $fFarthestDist Then
            $fFarthestDist = $fDist
            $iFarthestID = $iHeroAgentID
        EndIf
    Next
    Local $iHenchCount = Party_GetPartyContextInfo("HenchmanCount")
    For $i = 1 To $iHenchCount
        Local $iHenchAgentID = Party_GetMyPartyHenchmanInfo($i, "AgentID")
        If $iHenchAgentID = 0 Then ContinueLoop
        If Agent_GetAgentInfo($iHenchAgentID, "IsDead") Then ContinueLoop
        Local $fDist = Agent_GetDistance($iHenchAgentID, $iMyID)
        If $fDist > $fFarthestDist Then
            $fFarthestDist = $fDist
            $iFarthestID = $iHenchAgentID
        EndIf
    Next
    Return $iFarthestID
EndFunc
Func _Pathfinder_ShouldWaitForResurrection()
    Local $iEnemyCount = GetAgents(-2, 1200, $GC_I_AGENT_TYPE_LIVING, 0, "_Pathfinder_FilterIsEnemy")
    If $iEnemyCount > 0 Then Return False
    Local $iDeadCount = _Pathfinder_CountDeadPartyMembers()
    If $iDeadCount = 0 Then Return False
    Local $iRezCount = _Pathfinder_CountAvailableResurrections()
    If $iRezCount = 0 Then Return False
    Return True
EndFunc
Func _Pathfinder_CountDeadPartyMembers()
    Local $iCount = 0
    Local $iHeroCount = Party_GetPartyContextInfo("HeroCount")
    For $i = 1 To $iHeroCount
        Local $iHeroAgentID = Party_GetMyPartyHeroInfo($i, "AgentID")
        If $iHeroAgentID = 0 Then ContinueLoop
        If Agent_GetAgentInfo($iHeroAgentID, "IsDead") Then $iCount += 1
    Next
    Local $iHenchCount = Party_GetPartyContextInfo("HenchmanCount")
    For $i = 1 To $iHenchCount
        Local $iHenchAgentID = Party_GetMyPartyHenchmanInfo($i, "AgentID")
        If $iHenchAgentID = 0 Then ContinueLoop
        If Agent_GetAgentInfo($iHenchAgentID, "IsDead") Then $iCount += 1
    Next
    Return $iCount
EndFunc
Func _Pathfinder_CountAvailableResurrections()
    Local $iCount = 0
    Local $iMyID = Agent_GetMyID()
    If Not Agent_GetAgentInfo(-2, "IsDead") Then
        For $iSlot = 1 To 8
            Local $iSkillID = Skill_GetSkillbarInfo($iSlot, "SkillID", 0)
            If $iSkillID = 0 Then ContinueLoop
            If Skill_IsAnyResurrection($iSkillID) Or Skill_IsResurrectionSpecial($iSkillID) Then
                If Skill_GetSkillbarInfo($iSlot, "IsRecharged", 0) Then
                    $iCount += 1
                EndIf
            EndIf
        Next
    EndIf
    Local $iHeroCount = Party_GetPartyContextInfo("HeroCount")
    For $iHero = 1 To $iHeroCount
        Local $iHeroAgentID = Party_GetMyPartyHeroInfo($iHero, "AgentID")
        If $iHeroAgentID = 0 Then ContinueLoop
        If Agent_GetAgentInfo($iHeroAgentID, "IsDead") Then ContinueLoop
        If Agent_GetDistance($iHeroAgentID, $iMyID) > 5000 Then ContinueLoop
        For $iSlot = 1 To 8
            Local $iSkillID = Skill_GetSkillbarInfo($iSlot, "SkillID", $iHero)
            If $iSkillID = 0 Then ContinueLoop
            If Skill_IsAnyResurrection($iSkillID) Or Skill_IsResurrectionSpecial($iSkillID) Then
                If Skill_GetSkillbarInfo($iSlot, "IsRecharged", $iHero) Then
                    $iCount += 1
                EndIf
            EndIf
        Next
    Next
    Return $iCount
EndFunc
Func _Pathfinder_GetNearestDeadPartyMember()
    Local $iNearestID = 0
    Local $fNearestDist = 999999
    Local $iMyID = Agent_GetMyID()
    Local $iHeroCount = Party_GetPartyContextInfo("HeroCount")
    For $i = 1 To $iHeroCount
        Local $iHeroAgentID = Party_GetMyPartyHeroInfo($i, "AgentID")
        If $iHeroAgentID = 0 Then ContinueLoop
        If Not Agent_GetAgentInfo($iHeroAgentID, "IsDead") Then ContinueLoop
        Local $fDist = Agent_GetDistance($iHeroAgentID, $iMyID)
        If $fDist < $fNearestDist Then
            $fNearestDist = $fDist
            $iNearestID = $iHeroAgentID
        EndIf
    Next
    Local $iHenchCount = Party_GetPartyContextInfo("HenchmanCount")
    For $i = 1 To $iHenchCount
        Local $iHenchAgentID = Party_GetMyPartyHenchmanInfo($i, "AgentID")
        If $iHenchAgentID = 0 Then ContinueLoop
        If Not Agent_GetAgentInfo($iHenchAgentID, "IsDead") Then ContinueLoop
        Local $fDist = Agent_GetDistance($iHenchAgentID, $iMyID)
        If $fDist < $fNearestDist Then
            $fNearestDist = $fDist
            $iNearestID = $iHenchAgentID
        EndIf
    Next
    Return $iNearestID
EndFunc
Func _Pathfinder_WaitForResurrection()
    Local $iDeadAllyID = _Pathfinder_GetNearestDeadPartyMember()
    If $iDeadAllyID = 0 Then Return
    Local $fDeadX = Agent_GetAgentInfo($iDeadAllyID, "X")
    Local $fDeadY = Agent_GetAgentInfo($iDeadAllyID, "Y")
    Local $fDist = Agent_GetDistanceToXY($fDeadX, $fDeadY)
    Local $lRezTimer = TimerInit()
    Do
		If Agent_GetAgentEffectInfo(-2, 471, "HasEffect") Then 
			Local $iFrozenSoilSpirit = GetAgents(-2, 5000, $GC_I_AGENT_TYPE_LIVING, 1, "_Pathfinder_FilterIsFrozenSoilSpirit")
			If $iFrozenSoilSpirit <> 0 Then
				Agent_ChangeTarget($iFrozenSoilSpirit)
				Agent_Attack($iFrozenSoilSpirit)
			EndIf
		Else
			If $fDist > 1000 Then Map_Move($fDeadX, $fDeadY, 0)
			For $iSlot = 1 To 8
				Local $iSkillID = Skill_GetSkillbarInfo($iSlot, "SkillID", 0)
				If $iSkillID = 0 Then ContinueLoop
				If Not (Skill_IsAnyResurrection($iSkillID) Or Skill_IsResurrectionSpecial($iSkillID)) Then ContinueLoop
				If Not Skill_GetSkillbarInfo($iSlot, "IsRecharged", 0) Then ContinueLoop
				Skill_UseSkill($iSlot, $iDeadAllyID)
				ExitLoop
			Next
		EndIf
        Sleep(250)
        Local $iEnemyCount = GetAgents(-2, 1200, $GC_I_AGENT_TYPE_LIVING, 0, "_Pathfinder_FilterIsEnemy")
        If $iEnemyCount > 0 Then
            Return
        EndIf
        If Not Agent_GetAgentInfo($iDeadAllyID, "IsDead") Then
            $iDeadAllyID = _Pathfinder_GetNearestDeadPartyMember()
            If $iDeadAllyID = 0 Then
                Return
            EndIf
        EndIf
    Until _Pathfinder_CountAvailableResurrections() = 0 Or _Pathfinder_CountDeadPartyMembers() = 0 Or TimerDiff($lRezTimer) > 30000
EndFunc
Func _Pathfinder_FilterIsEnemy($aAgentPtr)
    If Agent_GetAgentInfo($aAgentPtr, "Allegiance") <> $GC_I_ALLEGIANCE_ENEMY Then Return False
    If Agent_GetAgentInfo($aAgentPtr, "HP") <= 0 Then Return False
    If Agent_GetAgentInfo($aAgentPtr, "IsDead") Then Return False
    Return True
EndFunc
Func _Pathfinder_FilterIsFrozenSoilSpirit($aAgentPtr)
    If Agent_GetAgentInfo($aAgentPtr, "PlayerNumber") <> 2882 Then Return False
    If Agent_GetAgentInfo($aAgentPtr, "IsDead") Then Return False
    If Agent_GetAgentInfo($aAgentPtr, "HP") <= 0 Then Return False
    Return True
EndFunc
Func _Pathfinder_DumpFightDiag($aAggroRange)
    Local $sDiag = "[FightGate] enemies=" & UAI_CountEnemyInPartyAggroRange($aAggroRange) & " cache=" & $g_i_AgentCacheCount & " Map=" & Map_GetMapID() & " playerRange=" & UAI_IsAgentInRange(-2, $aAggroRange, "UAI_Filter_IsLivingEnemy") & @CRLF
    For $slot = 1 To 8
        Local $lID = UAI_GetStaticSkillInfo($slot, $GC_UAI_STATIC_SKILL_SkillID)
        If $lID = 0 Then
            $sDiag &= "[FightGate] slot " & $slot & " ID=0 (static cache empty)" & @CRLF
            ContinueLoop
        EndIf
        Local $lBest = 0
        If IsString($g_as_BestTargetCache[$slot]) And $g_as_BestTargetCache[$slot] <> "" Then
            $lBest = Call($g_as_BestTargetCache[$slot], $aAggroRange)
        EndIf
        Local $lCU = -1
        If IsString($g_as_CanUseCache[$slot]) And $g_as_CanUseCache[$slot] <> "" Then
            $lCU = Call($g_as_CanUseCache[$slot])
        EndIf
        $sDiag &= "[FightGate] slot " & $slot & " ID=" & $lID & " CanUse=" & UAI_CanUse($slot) & " BT=" & $g_as_BestTargetCache[$slot] & "(" & $lBest & ") CU=" & $g_as_CanUseCache[$slot] & "(" & $lCU & ")" & @CRLF
    Next
    FileWrite("C:\Users\W11\AppData\Local\Temp\opencode\_bot_fight_diag.txt", $sDiag)
EndFunc
Func _Pathfinder_FightEnemies($aAggroRange, $aFightRangeOut, $aFinisherMode, $aOldMap)
    Local $lFightTimer = TimerInit()
    Cache_SkillBar()
    While Map_GetMapID() = $aOldMap And TimerDiff($lFightTimer) < 90000
        If Agent_GetAgentInfo(-2, "IsDead") Then Return False
        UAI_UpdateAgentCache($aAggroRange)
        If UAI_CountEnemyInPartyAggroRange($aAggroRange) = 0 Then Return True
        Local $lEnemy = UAI_GetNearestAgent(-2, $aAggroRange, "UAI_Filter_IsLivingEnemy|UAI_Filter_IsNotAvoided")
        If $lEnemy = 0 Then
            Sleep(100)
            ContinueLoop
        EndIf
        Agent_ChangeTarget($lEnemy)
        Agent_CallTarget($lEnemy)
        Agent_Attack($lEnemy, False)
        If Agent_GetDistance($lEnemy) <= 1320 Then
            For $slot = 1 To 8
                Local $lID = UAI_GetStaticSkillInfo($slot, $GC_UAI_STATIC_SKILL_SkillID)
                If $lID = 0 Then ContinueLoop
                If Not UAI_CanUse($slot) Then ContinueLoop
                Local $lTarget = Call($g_as_BestTargetCache[$slot], $aAggroRange)
                If $lTarget = 0 Then ContinueLoop
                If Agent_GetDistance($lTarget) > 1320 Then ContinueLoop
                Local $lCanUseSkill = Call($g_as_CanUseCache[$slot])
                If $lCanUseSkill Then
                    Skill_UseSkill($slot, $lTarget)
                    Sleep(400)
                    UAI_UpdateAgentCache($aAggroRange)
                EndIf
            Next
        EndIf
        Sleep(100)
    WEnd
    Return False
EndFunc