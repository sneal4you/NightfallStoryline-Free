#include-once
Func Anti_WeaponSpell()
	If Not UAI_GetPlayerInfo($GC_UAI_AGENT_IsHexed) Then Return False
	If UAI_PlayerHasEffect($GC_I_SKILL_ID_MARK_OF_SUBVERSION) Then Return True
	If UAI_PlayerHasEffect($GC_I_SKILL_ID_SHAME) Then Return True
	If UAI_PlayerHasEffect($GC_I_SKILL_ID_DIVERSION) Then Return True
	Local $l_i_IncomingDamage = 0
	If UAI_PlayerHasEffect($GC_I_SKILL_ID_BACKFIRE) Then $l_i_IncomingDamage += UAI_GetPlayerEffectInfo($GC_I_SKILL_ID_BACKFIRE, $GC_UAI_EFFECT_Scale)
	If UAI_PlayerHasEffect($GC_I_SKILL_ID_VISIONS_OF_REGRET) Then
		$l_i_IncomingDamage += UAI_GetPlayerEffectInfo($GC_I_SKILL_ID_VISIONS_OF_REGRET, $GC_UAI_EFFECT_Scale)
		If Not UAI_PlayerHasOtherMesmerHex($GC_I_SKILL_ID_VISIONS_OF_REGRET) Then $l_i_IncomingDamage += UAI_GetPlayerEffectInfo($GC_I_SKILL_ID_VISIONS_OF_REGRET, $GC_UAI_EFFECT_BonusScale)
	EndIf
	If UAI_PlayerHasEffect($GC_I_SKILL_ID_SOUL_LEECH) Then $l_i_IncomingDamage += UAI_GetPlayerEffectInfo($GC_I_SKILL_ID_SOUL_LEECH, $GC_UAI_EFFECT_Scale)
	If UAI_PlayerHasEffect($GC_I_SKILL_ID_SPITEFUL_SPIRIT) Then $l_i_IncomingDamage += UAI_GetPlayerEffectInfo($GC_I_SKILL_ID_SPITEFUL_SPIRIT, $GC_UAI_EFFECT_Scale)
	If UAI_PlayerHasEffect($GC_I_SKILL_ID_SPOIL_VICTOR) And UAI_GetAgentInfoByID($g_i_BestTarget, $GC_UAI_AGENT_HP) < UAI_GetPlayerInfo($GC_UAI_AGENT_HP) Then
		$l_i_IncomingDamage += UAI_GetPlayerEffectInfo($GC_I_SKILL_ID_SPOIL_VICTOR, $GC_UAI_EFFECT_Scale)
	EndIf
	Return ($l_i_IncomingDamage > (UAI_GetPlayerInfo($GC_UAI_AGENT_CurrentHP) + UAI_GetPlayerInfo($GC_UAI_AGENT_MaxHP * 0.15)))
EndFunc
Func CanUse_ResilientWeapon()
	If Anti_WeaponSpell() Then Return False
	Return True
EndFunc
Func BestTarget_ResilientWeapon($a_f_AggroRange)
	Local $l_i_BestAlly = 0
	Local $l_f_LowestHP = 1.0
	For $i = 1 To $g_i_AgentCacheCount
		Local $l_i_AgentID = UAI_GetAgentInfo($i, $GC_UAI_AGENT_ID)
		If Not UAI_Filter_IsLivingAlly($l_i_AgentID) Then ContinueLoop
		Local $l_f_Distance = UAI_GetAgentInfo($i, $GC_UAI_AGENT_Distance)
		If $l_f_Distance > $a_f_AggroRange Then ContinueLoop
		If UAI_GetAgentInfoByID($l_i_AgentID, $GC_UAI_AGENT_IsWeaponSpelled) Then ContinueLoop
		If Not UAI_GetAgentInfo($i, $GC_UAI_AGENT_IsHexed) And Not UAI_GetAgentInfo($i, $GC_UAI_AGENT_IsConditioned) Then ContinueLoop
		Local $l_f_HP = UAI_GetAgentInfo($i, $GC_UAI_AGENT_HP)
		If $l_f_HP < $l_f_LowestHP Then
			$l_f_LowestHP = $l_f_HP
			$l_i_BestAlly = $l_i_AgentID
		EndIf
	Next
	Return $l_i_BestAlly
EndFunc
Func CanUse_SplinterWeapon()
	If Anti_WeaponSpell() Then Return False
	Return True
EndFunc
Func BestTarget_SplinterWeapon($a_f_AggroRange)
	Local $l_i_BestAlly = 0
	Local $l_i_BestEnemyCount = 0
	For $i = 1 To $g_i_AgentCacheCount
		Local $l_i_AgentID = UAI_GetAgentInfo($i, $GC_UAI_AGENT_ID)
		If Not UAI_Filter_IsLivingAlly($l_i_AgentID) Then ContinueLoop
		Local $l_f_Distance = UAI_GetAgentInfo($i, $GC_UAI_AGENT_Distance)
		If $l_f_Distance > $a_f_AggroRange Then ContinueLoop
		If UAI_GetAgentInfoByID($l_i_AgentID, $GC_UAI_AGENT_IsWeaponSpelled) Then ContinueLoop
		If Not UAI_GetAgentInfo($i, $GC_UAI_AGENT_IsAttacking) Then ContinueLoop
		Local $l_i_EnemyCount = UAI_CountAgents($l_i_AgentID, $GC_I_RANGE_ADJACENT, "UAI_Filter_IsLivingEnemy")
		If $l_i_EnemyCount > $l_i_BestEnemyCount Then
			$l_i_BestEnemyCount = $l_i_EnemyCount
			$l_i_BestAlly = $l_i_AgentID
		EndIf
	Next
	If $l_i_BestEnemyCount >= 2 Then Return $l_i_BestAlly
	Return 0
EndFunc
Func CanUse_WeaponOfWarding()
	If Anti_WeaponSpell() Then Return False
	Return True
EndFunc
Func BestTarget_WeaponOfWarding($a_f_AggroRange)
	Local $l_i_BestAlly = 0
	Local $l_f_LowestHP = 1.0
	For $i = 1 To $g_i_AgentCacheCount
		Local $l_i_AgentID = UAI_GetAgentInfo($i, $GC_UAI_AGENT_ID)
		If Not UAI_Filter_IsLivingAlly($l_i_AgentID) Then ContinueLoop
		Local $l_f_Distance = UAI_GetAgentInfo($i, $GC_UAI_AGENT_Distance)
		If $l_f_Distance > $a_f_AggroRange Then ContinueLoop
		If UAI_GetAgentInfoByID($l_i_AgentID, $GC_UAI_AGENT_IsWeaponSpelled) Then ContinueLoop
		Local $l_i_EnemyCount = UAI_CountAgents($l_i_AgentID, $GC_I_RANGE_ADJACENT, "UAI_Filter_IsLivingEnemy")
		If $l_i_EnemyCount = 0 Then ContinueLoop
		Local $l_f_HP = UAI_GetAgentInfo($i, $GC_UAI_AGENT_HP)
		If $l_f_HP < $l_f_LowestHP Then
			$l_f_LowestHP = $l_f_HP
			$l_i_BestAlly = $l_i_AgentID
		EndIf
	Next
	Return $l_i_BestAlly
EndFunc
Func CanUse_WailingWeapon()
	If Anti_WeaponSpell() Then Return False
	Return True
EndFunc
Func BestTarget_WailingWeapon($a_f_AggroRange)
	Local $l_i_BestAlly = 0
	Local $l_i_BestEnemyCount = 0
	For $i = 1 To $g_i_AgentCacheCount
		Local $l_i_AgentID = UAI_GetAgentInfo($i, $GC_UAI_AGENT_ID)
		If Not UAI_Filter_IsLivingAlly($l_i_AgentID) Then ContinueLoop
		Local $l_f_Distance = UAI_GetAgentInfo($i, $GC_UAI_AGENT_Distance)
		If $l_f_Distance > $a_f_AggroRange Then ContinueLoop
		If UAI_GetAgentInfoByID($l_i_AgentID, $GC_UAI_AGENT_IsWeaponSpelled) Then ContinueLoop
		If Not UAI_GetAgentInfo($i, $GC_UAI_AGENT_IsAttacking) Then ContinueLoop
		Local $l_i_EnemyCount = UAI_CountAgents($l_i_AgentID, $GC_I_RANGE_ADJACENT, "UAI_Filter_IsLivingEnemy")
		If $l_i_EnemyCount > $l_i_BestEnemyCount Then
			$l_i_BestEnemyCount = $l_i_EnemyCount
			$l_i_BestAlly = $l_i_AgentID
		EndIf
	Next
	If $l_i_BestEnemyCount >= 1 Then Return $l_i_BestAlly
	Return 0
EndFunc
Func CanUse_NightmreWeapon()
	If Anti_WeaponSpell() Then Return False
	Return True
EndFunc
Func BestTarget_NightmareWeapon($a_f_AggroRange)
	Local $l_i_BestAlly = 0
	Local $l_f_LowestHP = 1.0
	For $i = 1 To $g_i_AgentCacheCount
		Local $l_i_AgentID = UAI_GetAgentInfo($i, $GC_UAI_AGENT_ID)
		If Not UAI_Filter_IsLivingAlly($l_i_AgentID) Then ContinueLoop
		Local $l_f_Distance = UAI_GetAgentInfo($i, $GC_UAI_AGENT_Distance)
		If $l_f_Distance > $a_f_AggroRange Then ContinueLoop
		If UAI_GetAgentInfoByID($l_i_AgentID, $GC_UAI_AGENT_IsWeaponSpelled) Then ContinueLoop
		If Not UAI_GetAgentInfo($i, $GC_UAI_AGENT_IsAttacking) Then ContinueLoop
		Local $l_f_HP = UAI_GetAgentInfo($i, $GC_UAI_AGENT_HP)
		If $l_f_HP < $l_f_LowestHP Then
			$l_f_LowestHP = $l_f_HP
			$l_i_BestAlly = $l_i_AgentID
		EndIf
	Next
	Return $l_i_BestAlly
EndFunc
Func CanUse_VengefulWeapon()
	If Anti_WeaponSpell() Then Return False
	Return True
EndFunc
Func BestTarget_VengefulWeapon($a_f_AggroRange)
	Local $l_i_BestAlly = 0
	Local $l_f_LowestHP = 1.0
	For $i = 1 To $g_i_AgentCacheCount
		Local $l_i_AgentID = UAI_GetAgentInfo($i, $GC_UAI_AGENT_ID)
		If Not UAI_Filter_IsLivingAlly($l_i_AgentID) Then ContinueLoop
		Local $l_f_Distance = UAI_GetAgentInfo($i, $GC_UAI_AGENT_Distance)
		If $l_f_Distance > $a_f_AggroRange Then ContinueLoop
		If UAI_GetAgentInfoByID($l_i_AgentID, $GC_UAI_AGENT_IsWeaponSpelled) Then ContinueLoop
		Local $l_i_EnemyCount = UAI_CountAgents($l_i_AgentID, $GC_I_RANGE_ADJACENT, "UAI_Filter_IsLivingEnemy")
		If $l_i_EnemyCount = 0 Then ContinueLoop
		Local $l_f_HP = UAI_GetAgentInfo($i, $GC_UAI_AGENT_HP)
		If $l_f_HP < $l_f_LowestHP Then
			$l_f_LowestHP = $l_f_HP
			$l_i_BestAlly = $l_i_AgentID
		EndIf
	Next
	Return $l_i_BestAlly
EndFunc
Func CanUse_WeaponOfShadow()
	If Anti_WeaponSpell() Then Return False
	Return True
EndFunc
Func BestTarget_WeaponOfShadow($a_f_AggroRange)
	Local $l_i_BestAlly = 0
	Local $l_i_BestEnemyCount = 0
	For $i = 1 To $g_i_AgentCacheCount
		Local $l_i_AgentID = UAI_GetAgentInfo($i, $GC_UAI_AGENT_ID)
		If Not UAI_Filter_IsLivingAlly($l_i_AgentID) Then ContinueLoop
		Local $l_f_Distance = UAI_GetAgentInfo($i, $GC_UAI_AGENT_Distance)
		If $l_f_Distance > $a_f_AggroRange Then ContinueLoop
		If UAI_GetAgentInfoByID($l_i_AgentID, $GC_UAI_AGENT_IsWeaponSpelled) Then ContinueLoop
		Local $l_i_EnemyCount = UAI_CountAgents($l_i_AgentID, $GC_I_RANGE_ADJACENT, "UAI_Filter_IsLivingEnemy")
		If $l_i_EnemyCount > $l_i_BestEnemyCount Then
			$l_i_BestEnemyCount = $l_i_EnemyCount
			$l_i_BestAlly = $l_i_AgentID
		EndIf
	Next
	If $l_i_BestEnemyCount >= 1 Then Return $l_i_BestAlly
	Return 0
EndFunc
Func CanUse_SpiritLightWeapon()
	If Anti_WeaponSpell() Then Return False
	Return True
EndFunc
Func BestTarget_SpiritLightWeapon($a_f_AggroRange)
	Local $l_i_BestAlly = 0
	Local $l_f_LowestHP = 1.0
	For $i = 1 To $g_i_AgentCacheCount
		Local $l_i_AgentID = UAI_GetAgentInfo($i, $GC_UAI_AGENT_ID)
		If Not UAI_Filter_IsLivingAlly($l_i_AgentID) Then ContinueLoop
		Local $l_f_Distance = UAI_GetAgentInfo($i, $GC_UAI_AGENT_Distance)
		If $l_f_Distance > $a_f_AggroRange Then ContinueLoop
		If UAI_GetAgentInfoByID($l_i_AgentID, $GC_UAI_AGENT_IsWeaponSpelled) Then ContinueLoop
		Local $l_f_HP = UAI_GetAgentInfo($i, $GC_UAI_AGENT_HP)
		If $l_f_HP < $l_f_LowestHP Then
			$l_f_LowestHP = $l_f_HP
			$l_i_BestAlly = $l_i_AgentID
		EndIf
	Next
	Return $l_i_BestAlly
EndFunc
Func CanUse_BrutalWeapon()
	If Anti_WeaponSpell() Then Return False
	Return True
EndFunc
Func BestTarget_BrutalWeapon($a_f_AggroRange)
	For $i = 1 To $g_i_AgentCacheCount
		Local $l_i_AgentID = UAI_GetAgentInfo($i, $GC_UAI_AGENT_ID)
		If Not UAI_Filter_IsLivingAlly($l_i_AgentID) Then ContinueLoop
		Local $l_f_Distance = UAI_GetAgentInfo($i, $GC_UAI_AGENT_Distance)
		If $l_f_Distance > $a_f_AggroRange Then ContinueLoop
		If UAI_GetAgentInfoByID($l_i_AgentID, $GC_UAI_AGENT_IsWeaponSpelled) Then ContinueLoop
		If Not UAI_GetAgentInfo($i, $GC_UAI_AGENT_IsAttacking) Then ContinueLoop
		If UAI_GetAgentInfo($i, $GC_UAI_AGENT_IsEnchanted) Then ContinueLoop
		Return $l_i_AgentID
	Next
	Return 0
EndFunc
Func CanUse_GuidedWeapon()
	If Anti_WeaponSpell() Then Return False
	Return True
EndFunc
Func BestTarget_GuidedWeapon($a_f_AggroRange)
	For $i = 1 To $g_i_AgentCacheCount
		Local $l_i_AgentID = UAI_GetAgentInfo($i, $GC_UAI_AGENT_ID)
		If Not UAI_Filter_IsLivingAlly($l_i_AgentID) Then ContinueLoop
		Local $l_f_Distance = UAI_GetAgentInfo($i, $GC_UAI_AGENT_Distance)
		If $l_f_Distance > $a_f_AggroRange Then ContinueLoop
		If UAI_GetAgentInfoByID($l_i_AgentID, $GC_UAI_AGENT_IsWeaponSpelled) Then ContinueLoop
		If Not UAI_GetAgentInfo($i, $GC_UAI_AGENT_IsAttacking) Then ContinueLoop
		Return $l_i_AgentID
	Next
	Return 0
EndFunc
Func CanUse_VitalWeapon()
	If Anti_WeaponSpell() Then Return False
	Return True
EndFunc
Func BestTarget_VitalWeapon($a_f_AggroRange)
	Local $l_i_BestAlly = 0
	Local $l_f_LowestHP = 1.0
	For $i = 1 To $g_i_AgentCacheCount
		Local $l_i_AgentID = UAI_GetAgentInfo($i, $GC_UAI_AGENT_ID)
		If Not UAI_Filter_IsLivingAlly($l_i_AgentID) Then ContinueLoop
		Local $l_f_Distance = UAI_GetAgentInfo($i, $GC_UAI_AGENT_Distance)
		If $l_f_Distance > $a_f_AggroRange Then ContinueLoop
		If UAI_GetAgentInfoByID($l_i_AgentID, $GC_UAI_AGENT_IsWeaponSpelled) Then ContinueLoop
		Local $l_f_HP = UAI_GetAgentInfo($i, $GC_UAI_AGENT_HP)
		If $l_f_HP < $l_f_LowestHP Then
			$l_f_LowestHP = $l_f_HP
			$l_i_BestAlly = $l_i_AgentID
		EndIf
	Next
	Return $l_i_BestAlly
EndFunc
Func CanUse_WeaponOfQuickening()
	If Anti_WeaponSpell() Then Return False
	Return True
EndFunc
Func BestTarget_WeaponOfQuickening($a_f_AggroRange)
	For $i = 1 To $g_i_AgentCacheCount
		Local $l_i_AgentID = UAI_GetAgentInfo($i, $GC_UAI_AGENT_ID)
		If Not UAI_Filter_IsLivingAlly($l_i_AgentID) Then ContinueLoop
		Local $l_f_Distance = UAI_GetAgentInfo($i, $GC_UAI_AGENT_Distance)
		If $l_f_Distance > $a_f_AggroRange Then ContinueLoop
		If UAI_GetAgentInfoByID($l_i_AgentID, $GC_UAI_AGENT_IsWeaponSpelled) Then ContinueLoop
		If Not UAI_GetAgentInfo($i, $GC_UAI_AGENT_IsCasting) Then ContinueLoop
		Return $l_i_AgentID
	Next
	Return 0
EndFunc
Func CanUse_WeaponOfFury()
	If Anti_WeaponSpell() Then Return False
	Return True
EndFunc
Func BestTarget_WeaponOfFury($a_f_AggroRange)
	For $i = 1 To $g_i_AgentCacheCount
		Local $l_i_AgentID = UAI_GetAgentInfo($i, $GC_UAI_AGENT_ID)
		If Not UAI_Filter_IsLivingAlly($l_i_AgentID) Then ContinueLoop
		Local $l_f_Distance = UAI_GetAgentInfo($i, $GC_UAI_AGENT_Distance)
		If $l_f_Distance > $a_f_AggroRange Then ContinueLoop
		If UAI_GetAgentInfoByID($l_i_AgentID, $GC_UAI_AGENT_IsWeaponSpelled) Then ContinueLoop
		If Not UAI_GetAgentInfo($i, $GC_UAI_AGENT_IsAttacking) Then ContinueLoop
		Return $l_i_AgentID
	Next
	Return 0
EndFunc
Func CanUse_XinraesWeapon()
	If Anti_WeaponSpell() Then Return False
	Return True
EndFunc
Func BestTarget_XinraesWeapon($a_f_AggroRange)
	Local $l_i_BestAlly = 0
	Local $l_f_LowestHP = 1.0
	For $i = 1 To $g_i_AgentCacheCount
		Local $l_i_AgentID = UAI_GetAgentInfo($i, $GC_UAI_AGENT_ID)
		If Not UAI_Filter_IsLivingAlly($l_i_AgentID) Then ContinueLoop
		Local $l_f_Distance = UAI_GetAgentInfo($i, $GC_UAI_AGENT_Distance)
		If $l_f_Distance > $a_f_AggroRange Then ContinueLoop
		If UAI_GetAgentInfoByID($l_i_AgentID, $GC_UAI_AGENT_IsWeaponSpelled) Then ContinueLoop
		Local $l_i_EnemyCount = UAI_CountAgents($l_i_AgentID, $GC_I_RANGE_ADJACENT, "UAI_Filter_IsLivingEnemy")
		If $l_i_EnemyCount = 0 Then ContinueLoop
		Local $l_f_HP = UAI_GetAgentInfo($i, $GC_UAI_AGENT_HP)
		If $l_f_HP < $l_f_LowestHP Then
			$l_f_LowestHP = $l_f_HP
			$l_i_BestAlly = $l_i_AgentID
		EndIf
	Next
	Return $l_i_BestAlly
EndFunc
Func CanUse_WarmongersWeapon()
	If Anti_WeaponSpell() Then Return False
	Return True
EndFunc
Func BestTarget_WarmongersWeapon($a_f_AggroRange)
	Local $l_i_BestAlly = 0
	Local $l_i_BestCasterCount = 0
	For $i = 1 To $g_i_AgentCacheCount
		Local $l_i_AgentID = UAI_GetAgentInfo($i, $GC_UAI_AGENT_ID)
		If Not UAI_Filter_IsLivingAlly($l_i_AgentID) Then ContinueLoop
		Local $l_f_Distance = UAI_GetAgentInfo($i, $GC_UAI_AGENT_Distance)
		If $l_f_Distance > $a_f_AggroRange Then ContinueLoop
		If UAI_GetAgentInfoByID($l_i_AgentID, $GC_UAI_AGENT_IsWeaponSpelled) Then ContinueLoop
		If Not UAI_GetAgentInfo($i, $GC_UAI_AGENT_IsAttacking) Then ContinueLoop
		Local $l_i_CasterCount = UAI_CountAgents($l_i_AgentID, $GC_I_RANGE_ADJACENT, "UAI_Filter_IsLivingEnemyCaster")
		If $l_i_CasterCount > $l_i_BestCasterCount Then
			$l_i_BestCasterCount = $l_i_CasterCount
			$l_i_BestAlly = $l_i_AgentID
		EndIf
	Next
	If $l_i_BestCasterCount >= 1 Then Return $l_i_BestAlly
	Return 0
EndFunc
Func CanUse_WeaponOfRemedy()
	If Anti_WeaponSpell() Then Return False
	Return True
EndFunc
Func BestTarget_WeaponOfRemedy($a_f_AggroRange)
	For $i = 1 To $g_i_AgentCacheCount
		Local $l_i_AgentID = UAI_GetAgentInfo($i, $GC_UAI_AGENT_ID)
		If Not UAI_Filter_IsLivingAlly($l_i_AgentID) Then ContinueLoop
		Local $l_f_Distance = UAI_GetAgentInfo($i, $GC_UAI_AGENT_Distance)
		If $l_f_Distance > $a_f_AggroRange Then ContinueLoop
		If UAI_GetAgentInfoByID($l_i_AgentID, $GC_UAI_AGENT_IsWeaponSpelled) Then ContinueLoop
		If Not UAI_GetAgentInfo($i, $GC_UAI_AGENT_IsConditioned) Then ContinueLoop
		Local $l_i_EnemyCount = UAI_CountAgents($l_i_AgentID, $GC_I_RANGE_ADJACENT, "UAI_Filter_IsLivingEnemy")
		If $l_i_EnemyCount = 0 Then ContinueLoop
		Return $l_i_AgentID
	Next
	Return 0
EndFunc
Func CanUse_WeaponOfMastery()
	If Anti_WeaponSpell() Then Return False
	Return True
EndFunc
Func BestTarget_WeaponOfMastery($a_f_AggroRange)
	For $i = 1 To $g_i_AgentCacheCount
		Local $l_i_AgentID = UAI_GetAgentInfo($i, $GC_UAI_AGENT_ID)
		If Not UAI_Filter_IsLivingAlly($l_i_AgentID) Then ContinueLoop
		Local $l_f_Distance = UAI_GetAgentInfo($i, $GC_UAI_AGENT_Distance)
		If $l_f_Distance > $a_f_AggroRange Then ContinueLoop
		If UAI_GetAgentInfoByID($l_i_AgentID, $GC_UAI_AGENT_IsWeaponSpelled) Then ContinueLoop
		If Not UAI_GetAgentInfo($i, $GC_UAI_AGENT_IsAttacking) Then ContinueLoop
		Return $l_i_AgentID
	Next
	Return 0
EndFunc
Func CanUse_WeaponOfAggression()
	If Anti_WeaponSpell() Then Return False
	If UAI_GetPlayerInfo($GC_UAI_AGENT_IsWeaponSpelled) Then Return False
	Return True
EndFunc
Func BestTarget_WeaponOfAggression($a_f_AggroRange)
	Return UAI_GetPlayerInfo($GC_UAI_AGENT_ID)
EndFunc
Func CanUse_SunderingWeapon()
	If Anti_WeaponSpell() Then Return False
	Return True
EndFunc
Func BestTarget_SunderingWeapon($a_f_AggroRange)
	For $i = 1 To $g_i_AgentCacheCount
		Local $l_i_AgentID = UAI_GetAgentInfo($i, $GC_UAI_AGENT_ID)
		If Not UAI_Filter_IsLivingAlly($l_i_AgentID) Then ContinueLoop
		Local $l_f_Distance = UAI_GetAgentInfo($i, $GC_UAI_AGENT_Distance)
		If $l_f_Distance > $a_f_AggroRange Then ContinueLoop
		If UAI_GetAgentInfoByID($l_i_AgentID, $GC_UAI_AGENT_IsWeaponSpelled) Then ContinueLoop
		If Not UAI_GetAgentInfo($i, $GC_UAI_AGENT_IsAttacking) Then ContinueLoop
		Return $l_i_AgentID
	Next
	Return 0
EndFunc
Func CanUse_WeaponOfRenewal()
	If Anti_WeaponSpell() Then Return False
	Return True
EndFunc
Func BestTarget_WeaponOfRenewal($a_f_AggroRange)
	Local $l_i_BestAlly = 0
	Local $l_f_LowestEnergy = 1.0
	For $i = 1 To $g_i_AgentCacheCount
		Local $l_i_AgentID = UAI_GetAgentInfo($i, $GC_UAI_AGENT_ID)
		If Not UAI_Filter_IsLivingAlly($l_i_AgentID) Then ContinueLoop
		Local $l_f_Distance = UAI_GetAgentInfo($i, $GC_UAI_AGENT_Distance)
		If $l_f_Distance > $a_f_AggroRange Then ContinueLoop
		If UAI_GetAgentInfoByID($l_i_AgentID, $GC_UAI_AGENT_IsWeaponSpelled) Then ContinueLoop
		If Not UAI_GetAgentInfo($i, $GC_UAI_AGENT_IsAttacking) Then ContinueLoop
		Local $l_f_Energy = UAI_GetAgentInfo($i, $GC_UAI_AGENT_CurrentEnergy)
		If $l_f_Energy < $l_f_LowestEnergy Then
			$l_f_LowestEnergy = $l_f_Energy
			$l_i_BestAlly = $l_i_AgentID
		EndIf
	Next
	Return $l_i_BestAlly
EndFunc
Func CanUse_GhostlyWeapon()
	If Anti_WeaponSpell() Then Return False
	Return True
EndFunc
Func BestTarget_GhostlyWeapon($a_f_AggroRange)
	Local $l_i_PlayerID = UAI_GetPlayerInfo($GC_UAI_AGENT_ID)
	For $i = 1 To $g_i_AgentCacheCount
		Local $l_i_AgentID = UAI_GetAgentInfo($i, $GC_UAI_AGENT_ID)
		If $l_i_AgentID = $l_i_PlayerID Then ContinueLoop
		If Not UAI_Filter_IsLivingAlly($l_i_AgentID) Then ContinueLoop
		Local $l_f_Distance = UAI_GetAgentInfo($i, $GC_UAI_AGENT_Distance)
		If $l_f_Distance > $a_f_AggroRange Then ContinueLoop
		If UAI_GetAgentInfoByID($l_i_AgentID, $GC_UAI_AGENT_IsWeaponSpelled) Then ContinueLoop
		If Not UAI_GetAgentInfo($i, $GC_UAI_AGENT_IsAttacking) Then ContinueLoop
		Return $l_i_AgentID
	Next
	Return 0
EndFunc
Func CanUse_GreatDwarfWeapon()
	If Anti_WeaponSpell() Then Return False
	Return True
EndFunc
Func BestTarget_GreatDwarfWeapon($a_f_AggroRange)
	Local $l_i_PlayerID = UAI_GetPlayerInfo($GC_UAI_AGENT_ID)
	For $i = 1 To $g_i_AgentCacheCount
		Local $l_i_AgentID = UAI_GetAgentInfo($i, $GC_UAI_AGENT_ID)
		If $l_i_AgentID = $l_i_PlayerID Then ContinueLoop
		If Not UAI_Filter_IsLivingAlly($l_i_AgentID) Then ContinueLoop
		Local $l_f_Distance = UAI_GetAgentInfo($i, $GC_UAI_AGENT_Distance)
		If $l_f_Distance > $a_f_AggroRange Then ContinueLoop
		If UAI_GetAgentInfoByID($l_i_AgentID, $GC_UAI_AGENT_IsWeaponSpelled) Then ContinueLoop
		If Not UAI_GetAgentInfo($i, $GC_UAI_AGENT_IsAttacking) Then ContinueLoop
		Return $l_i_AgentID
	Next
	Return 0
EndFunc
Func CanUse_SplinterWeaponPvP()
	If Anti_WeaponSpell() Then Return False
	Return True
EndFunc
Func BestTarget_SplinterWeaponPvP($a_f_AggroRange)
	Local $l_i_BestAlly = 0
	Local $l_i_BestEnemyCount = 0
	For $i = 1 To $g_i_AgentCacheCount
		Local $l_i_AgentID = UAI_GetAgentInfo($i, $GC_UAI_AGENT_ID)
		If Not UAI_Filter_IsLivingAlly($l_i_AgentID) Then ContinueLoop
		Local $l_f_Distance = UAI_GetAgentInfo($i, $GC_UAI_AGENT_Distance)
		If $l_f_Distance > $a_f_AggroRange Then ContinueLoop
		If UAI_GetAgentInfoByID($l_i_AgentID, $GC_UAI_AGENT_IsWeaponSpelled) Then ContinueLoop
		If Not UAI_GetAgentInfo($i, $GC_UAI_AGENT_IsAttacking) Then ContinueLoop
		Local $l_i_EnemyCount = UAI_CountAgents($l_i_AgentID, $GC_I_RANGE_ADJACENT, "UAI_Filter_IsLivingEnemy")
		If $l_i_EnemyCount > $l_i_BestEnemyCount Then
			$l_i_BestEnemyCount = $l_i_EnemyCount
			$l_i_BestAlly = $l_i_AgentID
		EndIf
	Next
	If $l_i_BestEnemyCount >= 2 Then Return $l_i_BestAlly
	Return 0
EndFunc
Func CanUse_WeaponOfWardingPvP()
	If Anti_WeaponSpell() Then Return False
	Return True
EndFunc
Func BestTarget_WeaponOfWardingPvP($a_f_AggroRange)
	Local $l_i_BestAlly = 0
	Local $l_f_LowestHP = 1.0
	For $i = 1 To $g_i_AgentCacheCount
		Local $l_i_AgentID = UAI_GetAgentInfo($i, $GC_UAI_AGENT_ID)
		If Not UAI_Filter_IsLivingAlly($l_i_AgentID) Then ContinueLoop
		Local $l_f_Distance = UAI_GetAgentInfo($i, $GC_UAI_AGENT_Distance)
		If $l_f_Distance > $a_f_AggroRange Then ContinueLoop
		If UAI_GetAgentInfoByID($l_i_AgentID, $GC_UAI_AGENT_IsWeaponSpelled) Then ContinueLoop
		Local $l_i_EnemyCount = UAI_CountAgents($l_i_AgentID, $GC_I_RANGE_ADJACENT, "UAI_Filter_IsLivingEnemy")
		If $l_i_EnemyCount = 0 Then ContinueLoop
		Local $l_f_HP = UAI_GetAgentInfo($i, $GC_UAI_AGENT_HP)
		If $l_f_HP < $l_f_LowestHP Then
			$l_f_LowestHP = $l_f_HP
			$l_i_BestAlly = $l_i_AgentID
		EndIf
	Next
	Return $l_i_BestAlly
EndFunc
Func CanUse_WeaponsOfThreeForges()
	If Anti_WeaponSpell() Then Return False
	Return True
EndFunc
Func BestTarget_WeaponsOfThreeForges($a_f_AggroRange)
	Return UAI_GetPlayerInfo($GC_UAI_AGENT_ID)
EndFunc