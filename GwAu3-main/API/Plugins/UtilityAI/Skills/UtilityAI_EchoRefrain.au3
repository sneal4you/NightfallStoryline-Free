#include-once
Func Anti_EchoRefrain()
	Return False
EndFunc
Func CanUse_EnduringHarmony()
	If Anti_EchoRefrain() Then Return False
	Return True
EndFunc
Func BestTarget_EnduringHarmony($a_f_AggroRange)
	Return 0
EndFunc
Func CanUse_BlazingFinale()
	If Anti_EchoRefrain() Then Return False
	Return True
EndFunc
Func BestTarget_BlazingFinale($a_f_AggroRange)
	Local $l_i_BestAlly = 0
	Local $l_i_BestEnemyCount = 0
	For $i = 1 To $g_i_AgentCacheCount
		Local $l_i_AgentID = UAI_GetAgentInfo($i, $GC_UAI_AGENT_ID)
		If Not UAI_Filter_IsLivingAlly($l_i_AgentID) Then ContinueLoop
		If UAI_Filter_IsSpirit($l_i_AgentID) Then ContinueLoop
		Local $l_f_Distance = UAI_GetAgentInfo($i, $GC_UAI_AGENT_Distance)
		If $l_f_Distance > $a_f_AggroRange Then ContinueLoop
		If UAI_AgentHasEffect($l_i_AgentID, $GC_I_SKILL_ID_BLAZING_FINALE) Then ContinueLoop
		Local $l_i_EnemyCount = UAI_CountAgents($l_i_AgentID, $GC_I_RANGE_ADJACENT, "UAI_Filter_IsLivingEnemy")
		If $l_i_EnemyCount > $l_i_BestEnemyCount Then
			$l_i_BestEnemyCount = $l_i_EnemyCount
			$l_i_BestAlly = $l_i_AgentID
		EndIf
	Next
	If $l_i_BestEnemyCount >= 1 Then Return $l_i_BestAlly
	Return 0
EndFunc
Func CanUse_BurningRefrain()
	If Anti_EchoRefrain() Then Return False
	Return True
EndFunc
Func BestTarget_BurningRefrain($a_f_AggroRange)
	Local $l_i_BestAlly = 0
	Local $l_f_LowestHP = 999999
	For $i = 1 To $g_i_AgentCacheCount
		Local $l_i_AgentID = UAI_GetAgentInfo($i, $GC_UAI_AGENT_ID)
		If Not UAI_Filter_IsLivingAlly($l_i_AgentID) Then ContinueLoop
		If UAI_Filter_IsSpirit($l_i_AgentID) Then ContinueLoop
		Local $l_f_Distance = UAI_GetAgentInfo($i, $GC_UAI_AGENT_Distance)
		If $l_f_Distance > $a_f_AggroRange Then ContinueLoop
		If UAI_AgentHasEffect($l_i_AgentID, $GC_I_SKILL_ID_BURNING_REFRAIN) Then ContinueLoop
		Local $l_f_CurrentHP = UAI_GetAgentInfo($i, $GC_UAI_AGENT_CurrentHP)
		If $l_f_CurrentHP < $l_f_LowestHP Then
			$l_f_LowestHP = $l_f_CurrentHP
			$l_i_BestAlly = $l_i_AgentID
		EndIf
	Next
	Return $l_i_BestAlly
EndFunc
Func CanUse_FinaleOfRestoration()
	If Anti_EchoRefrain() Then Return False
	Return True
EndFunc
Func BestTarget_FinaleOfRestoration($a_f_AggroRange)
	Local $l_i_BestAlly = 0
	Local $l_f_LowestHP = 1.0
	For $i = 1 To $g_i_AgentCacheCount
		Local $l_i_AgentID = UAI_GetAgentInfo($i, $GC_UAI_AGENT_ID)
		If Not UAI_Filter_IsLivingAlly($l_i_AgentID) Then ContinueLoop
		If UAI_Filter_IsSpirit($l_i_AgentID) Then ContinueLoop
		Local $l_f_Distance = UAI_GetAgentInfo($i, $GC_UAI_AGENT_Distance)
		If $l_f_Distance > $a_f_AggroRange Then ContinueLoop
		If UAI_AgentHasEffect($l_i_AgentID, $GC_I_SKILL_ID_FINALE_OF_RESTORATION) Then ContinueLoop
		Local $l_f_HP = UAI_GetAgentInfo($i, $GC_UAI_AGENT_HP)
		If $l_f_HP < $l_f_LowestHP Then
			$l_f_LowestHP = $l_f_HP
			$l_i_BestAlly = $l_i_AgentID
		EndIf
	Next
	Return $l_i_BestAlly
EndFunc
Func CanUse_MendingRefrain()
	If Anti_EchoRefrain() Then Return False
	Return True
EndFunc
Func BestTarget_MendingRefrain($a_f_AggroRange)
	Local $l_i_BestAlly = 0
	Local $l_f_LowestHP = 1.0
	For $i = 1 To $g_i_AgentCacheCount
		Local $l_i_AgentID = UAI_GetAgentInfo($i, $GC_UAI_AGENT_ID)
		If Not UAI_Filter_IsLivingAlly($l_i_AgentID) Then ContinueLoop
		If UAI_Filter_IsSpirit($l_i_AgentID) Then ContinueLoop
		Local $l_f_Distance = UAI_GetAgentInfo($i, $GC_UAI_AGENT_Distance)
		If $l_f_Distance > $a_f_AggroRange Then ContinueLoop
		If UAI_AgentHasEffect($l_i_AgentID, $GC_I_SKILL_ID_MENDING_REFRAIN) Then ContinueLoop
		Local $l_f_HP = UAI_GetAgentInfo($i, $GC_UAI_AGENT_HP)
		If $l_f_HP < $l_f_LowestHP Then
			$l_f_LowestHP = $l_f_HP
			$l_i_BestAlly = $l_i_AgentID
		EndIf
	Next
	Return $l_i_BestAlly
EndFunc
Func CanUse_PurifyingFinale()
	If Anti_EchoRefrain() Then Return False
	Return True
EndFunc
Func BestTarget_PurifyingFinale($a_f_AggroRange)
	For $i = 1 To $g_i_AgentCacheCount
		Local $l_i_AgentID = UAI_GetAgentInfo($i, $GC_UAI_AGENT_ID)
		If Not UAI_Filter_IsLivingAlly($l_i_AgentID) Then ContinueLoop
		If UAI_Filter_IsSpirit($l_i_AgentID) Then ContinueLoop
		Local $l_f_Distance = UAI_GetAgentInfo($i, $GC_UAI_AGENT_Distance)
		If $l_f_Distance > $a_f_AggroRange Then ContinueLoop
		If UAI_AgentHasEffect($l_i_AgentID, $GC_I_SKILL_ID_PURIFYING_FINALE) Then ContinueLoop
		If Not UAI_GetAgentInfo($i, $GC_UAI_AGENT_IsConditioned) Then ContinueLoop
		Return $l_i_AgentID
	Next
	Return 0
EndFunc
Func CanUse_BladeturnRefrain()
	If Anti_EchoRefrain() Then Return False
	Return True
EndFunc
Func BestTarget_BladeturnRefrain($a_f_AggroRange)
	Local $l_i_BestAlly = 0
	Local $l_i_BestEnemyCount = 0
	For $i = 1 To $g_i_AgentCacheCount
		Local $l_i_AgentID = UAI_GetAgentInfo($i, $GC_UAI_AGENT_ID)
		If Not UAI_Filter_IsLivingAlly($l_i_AgentID) Then ContinueLoop
		If UAI_Filter_IsSpirit($l_i_AgentID) Then ContinueLoop
		Local $l_f_Distance = UAI_GetAgentInfo($i, $GC_UAI_AGENT_Distance)
		If $l_f_Distance > $a_f_AggroRange Then ContinueLoop
		If UAI_AgentHasEffect($l_i_AgentID, $GC_I_SKILL_ID_BLADETURN_REFRAIN) Then ContinueLoop
		Local $l_i_EnemyCount = UAI_CountAgents($l_i_AgentID, $GC_I_RANGE_ADJACENT, "UAI_Filter_IsLivingEnemy")
		If $l_i_EnemyCount > $l_i_BestEnemyCount Then
			$l_i_BestEnemyCount = $l_i_EnemyCount
			$l_i_BestAlly = $l_i_AgentID
		EndIf
	Next
	If $l_i_BestEnemyCount >= 1 Then Return $l_i_BestAlly
	Return 0
EndFunc
Func CanUse_SoldiersFury()
	If Anti_EchoRefrain() Then Return False
	If UAI_GetPlayerEffectInfo($GC_I_SKILL_ID_SOLDIERS_FURY, $GC_UAI_EFFECT_TimeRemaining) > 5000 Then Return False
	Return True
EndFunc
Func BestTarget_SoldiersFury($a_f_AggroRange)
	Return UAI_GetPlayerInfo($GC_UAI_AGENT_ID)
EndFunc
Func CanUse_AggressiveRefrain()
	If Anti_EchoRefrain() Then Return False
	If UAI_GetPlayerEffectInfo($GC_I_SKILL_ID_AGGRESSIVE_REFRAIN, $GC_UAI_EFFECT_TimeRemaining) > 5000 Then Return False
	Return True
EndFunc
Func BestTarget_AggressiveRefrain($a_f_AggroRange)
	Return UAI_GetPlayerInfo($GC_UAI_AGENT_ID)
EndFunc
Func CanUse_EnergizingFinale()
	If Anti_EchoRefrain() Then Return False
	Return True
EndFunc
Func BestTarget_EnergizingFinale($a_f_AggroRange)
	Local $l_i_BestAlly = 0
	Local $l_f_LowestEnergy = 1.0
	For $i = 1 To $g_i_AgentCacheCount
		Local $l_i_AgentID = UAI_GetAgentInfo($i, $GC_UAI_AGENT_ID)
		If Not UAI_Filter_IsLivingAlly($l_i_AgentID) Then ContinueLoop
		If UAI_Filter_IsSpirit($l_i_AgentID) Then ContinueLoop
		Local $l_f_Distance = UAI_GetAgentInfo($i, $GC_UAI_AGENT_Distance)
		If $l_f_Distance > $a_f_AggroRange Then ContinueLoop
		If UAI_AgentHasEffect($l_i_AgentID, $GC_I_SKILL_ID_ENERGIZING_FINALE) Then ContinueLoop
		Local $l_f_Energy = UAI_GetAgentInfo($i, $GC_UAI_AGENT_EnergyPercent)
		If $l_f_Energy < $l_f_LowestEnergy Then
			$l_f_LowestEnergy = $l_f_Energy
			$l_i_BestAlly = $l_i_AgentID
		EndIf
	Next
	Return $l_i_BestAlly
EndFunc
Func CanUse_HastyRefrain()
	If Anti_EchoRefrain() Then Return False
	Return True
EndFunc
Func BestTarget_HastyRefrain($a_f_AggroRange)
	Local $l_i_BestAlly = 0
	Local $l_f_FarthestDist = 0
	Local $l_i_FallbackAlly = 0
	For $i = 1 To $g_i_AgentCacheCount
		Local $l_i_AgentID = UAI_GetAgentInfo($i, $GC_UAI_AGENT_ID)
		If Not UAI_Filter_IsLivingAlly($l_i_AgentID) Then ContinueLoop
		If UAI_Filter_IsSpirit($l_i_AgentID) Then ContinueLoop
		Local $l_f_Distance = UAI_GetAgentInfo($i, $GC_UAI_AGENT_Distance)
		If $l_f_Distance > $a_f_AggroRange Then ContinueLoop
		If UAI_AgentHasEffect($l_i_AgentID, $GC_I_SKILL_ID_HASTY_REFRAIN) Then ContinueLoop
		If $l_i_FallbackAlly = 0 Then $l_i_FallbackAlly = $l_i_AgentID
		If $l_f_Distance > $l_f_FarthestDist Then
			$l_f_FarthestDist = $l_f_Distance
			$l_i_BestAlly = $l_i_AgentID
		EndIf
	Next
	If $l_i_BestAlly <> 0 Then Return $l_i_BestAlly
	Return $l_i_FallbackAlly
EndFunc
Func CanUse_BlazingFinalePvP()
	If Anti_EchoRefrain() Then Return False
	Return True
EndFunc
Func BestTarget_BlazingFinalePvP($a_f_AggroRange)
	Return 0
EndFunc
Func CanUse_BladeturnRefrainPvP()
	If Anti_EchoRefrain() Then Return False
	Return True
EndFunc
Func BestTarget_BladeturnRefrainPvP($a_f_AggroRange)
	Return 0
EndFunc
Func CanUse_FinaleOfRestorationPvP()
	If Anti_EchoRefrain() Then Return False
	Return True
EndFunc
Func BestTarget_FinaleOfRestorationPvP($a_f_AggroRange)
	Return 0
EndFunc
Func CanUse_MendingRefrainPvP()
	If Anti_EchoRefrain() Then Return False
	Return True
EndFunc
Func BestTarget_MendingRefrainPvP($a_f_AggroRange)
	Return UAI_GetPlayerInfo($GC_UAI_AGENT_ID)
EndFunc
Func CanUse_HeroicRefrain()
	If Anti_EchoRefrain() Then Return False
	Return True
EndFunc
Func BestTarget_HeroicRefrain($a_f_AggroRange)
	If Attribute_GetPartyAttributeInfo($GC_I_ATTRIBUTE_LEADERSHIP, 0, "CurrentLevel") < 20 Then Return UAI_GetPlayerInfo($GC_UAI_AGENT_ID)
	Local $l_ai_PartyArray = Party_GetMembersArray()
	For $i = 1 To $l_ai_PartyArray[0]
		If UAI_AgentHasEffect($l_ai_PartyArray[$i], $GC_I_SKILL_ID_HEROIC_REFRAIN) Then ContinueLoop
		Return $l_ai_PartyArray[$i]
	Next
	Return 0
EndFunc