#include-once
Func Anti_Spell()
	If Not UAI_GetPlayerInfo($GC_UAI_AGENT_IsHexed) Then Return False
	Local $l_i_TargetAllegiance = UAI_GetAgentInfoByID($g_i_BestTarget, $GC_UAI_AGENT_Allegiance)
	If UAI_PlayerHasEffect($GC_I_SKILL_ID_MARK_OF_SUBVERSION) And $l_i_TargetAllegiance = $GC_I_ALLEGIANCE_ALLY Then Return True
	If UAI_PlayerHasEffect($GC_I_SKILL_ID_MISTRUST) And $l_i_TargetAllegiance = $GC_I_ALLEGIANCE_ALLY Then Return True
	If UAI_PlayerHasEffect($GC_I_SKILL_ID_SHAME) And $l_i_TargetAllegiance = $GC_I_ALLEGIANCE_ALLY Then Return True
	If UAI_PlayerHasEffect($GC_I_SKILL_ID_GUILT) And $l_i_TargetAllegiance = $GC_I_ALLEGIANCE_ENEMY Then Return True
	If UAI_PlayerHasEffect($GC_I_SKILL_ID_DIVERSION) Then Return True
	Local $l_i_IncomingDamage = 0
	If UAI_PlayerHasEffect($GC_I_SKILL_ID_BACKFIRE) Then $l_i_IncomingDamage += UAI_GetPlayerEffectInfo($GC_I_SKILL_ID_BACKFIRE, $GC_UAI_EFFECT_Scale)
	If UAI_PlayerHasEffect($GC_I_SKILL_ID_VISIONS_OF_REGRET) Then
		$l_i_IncomingDamage += UAI_GetPlayerEffectInfo($GC_I_SKILL_ID_VISIONS_OF_REGRET, $GC_UAI_EFFECT_Scale)
		If Not UAI_PlayerHasOtherMesmerHex($GC_I_SKILL_ID_VISIONS_OF_REGRET) Then $l_i_IncomingDamage += Effect_GetEffectArg($GC_I_SKILL_ID_VISIONS_OF_REGRET, $GC_UAI_EFFECT_BonusScale)
	EndIf
	If UAI_PlayerHasEffect($GC_I_SKILL_ID_SOUL_LEECH) Then $l_i_IncomingDamage += UAI_GetPlayerEffectInfo($GC_I_SKILL_ID_SOUL_LEECH, $GC_UAI_EFFECT_Scale)
	If UAI_PlayerHasEffect($GC_I_SKILL_ID_SPITEFUL_SPIRIT) Then $l_i_IncomingDamage += UAI_GetPlayerEffectInfo($GC_I_SKILL_ID_SPITEFUL_SPIRIT, $GC_UAI_EFFECT_Scale)
	If UAI_PlayerHasEffect($GC_I_SKILL_ID_SPOIL_VICTOR) And UAI_GetAgentInfoByID($g_i_BestTarget, $GC_UAI_AGENT_HP) < UAI_GetPlayerInfo($GC_UAI_AGENT_HP) Then
		$l_i_IncomingDamage += UAI_GetPlayerEffectInfo($GC_I_SKILL_ID_SPOIL_VICTOR, $GC_UAI_EFFECT_Scale)
	EndIf
	Return ($l_i_IncomingDamage > (UAI_GetPlayerInfo($GC_UAI_AGENT_CurrentHP) + UAI_GetPlayerInfo($GC_UAI_AGENT_MaxHP * 0.15)))
EndFunc
Func CanUse_PowerBlock()
	If Anti_Spell() Then Return False
	If UAI_PlayerHasEffect($GC_I_SKILL_ID_GUILT) Then Return False
	If UAI_PlayerHasEffect($GC_I_SKILL_ID_DIVERSION) Then Return False
	If Not UAI_GetAgentInfoByID($g_i_BestTarget, $GC_UAI_AGENT_IsCasting) Then Return False
	Return True
EndFunc
Func BestTarget_PowerBlock($a_f_AggroRange)
	Local $l_i_Target = UAI_GetNearestAgent(-2, $a_f_AggroRange, "UAI_Filter_IsLivingEnemy|UAI_Filter_IsCasting")
	If $l_i_Target <> 0 Then Return $l_i_Target
	Return UAI_GetNearestAgent(-2, $a_f_AggroRange, "UAI_Filter_IsLivingEnemy|UAI_Filter_IsCaster")
EndFunc
Func CanUse_InspiredEnchantment()
	If Anti_Spell() Then Return False
	Return True
EndFunc
Func BestTarget_InspiredEnchantment($a_f_AggroRange)
	Return UAI_GetAgentHighest(-2, $a_f_AggroRange, $GC_UAI_AGENT_HP, "UAI_Filter_IsLivingEnemy|UAI_Filter_IsEnchanted")
EndFunc
Func CanUse_InspiredHex()
	If Anti_Spell() Then Return False
	Return True
EndFunc
Func BestTarget_InspiredHex($a_f_AggroRange)
	Return UAI_GetNearestAgent(-2, $a_f_AggroRange, "UAI_Filter_IsAlly|UAI_Filter_IsHexed")
EndFunc
Func CanUse_PowerSpike()
	If Anti_Spell() Then Return False
	Return True
EndFunc
Func BestTarget_PowerSpike($a_f_AggroRange)
	Return UAI_GetNearestAgent(-2, $a_f_AggroRange, "UAI_Filter_IsLivingEnemy|UAI_Filter_IsCasting")
EndFunc
Func CanUse_PowerLeak()
	If Anti_Spell() Then Return False
	Return True
EndFunc
Func BestTarget_PowerLeak($a_f_AggroRange)
	Return UAI_GetNearestAgent(-2, $a_f_AggroRange, "UAI_Filter_IsLivingEnemy|UAI_Filter_IsCasting")
EndFunc
Func CanUse_PowerDrain()
	If Anti_Spell() Then Return False
	If UAI_GetPlayerInfo($GC_UAI_AGENT_CurrentEnergy) > 20 Then Return False
	Local $lSkillID = UAI_GetAgentInfoByID($g_i_BestTarget, $GC_UAI_AGENT_Skill)
	Local $lRuptable = [$GC_I_SKILL_TYPE_HEX, $GC_I_SKILL_TYPE_SPELL, $GC_I_SKILL_TYPE_ENCHANTMENT, $GC_I_SKILL_TYPE_WELL, $GC_I_SKILL_TYPE_WARD, $GC_I_SKILL_TYPE_ITEM_SPELL, $GC_I_SKILL_TYPE_WEAPON_SPELL, $GC_I_SKILL_TYPE_CHANT]
	For $i = 0 To UBound($lRuptable) - 1
		If Skill_GetSkillInfo($lSkillID, "SkillType") = $i Then Return True
	Next
	Return False
EndFunc
Func BestTarget_PowerDrain($a_f_AggroRange)
	Return UAI_GetAgentHighest(-2, $a_f_AggroRange, $GC_UAI_AGENT_HP, "UAI_Filter_IsLivingEnemy|UAI_Filter_IsCaster|UAI_Filter_IsCasting")
EndFunc
Func CanUse_ShatterDelusions()
	If Anti_Spell() Then Return False
	Return True
EndFunc
Func BestTarget_ShatterDelusions($a_f_AggroRange)
	Return UAI_GetBestAOETarget(-2, $a_f_AggroRange, $GC_I_RANGE_ADJACENT, "UAI_Filter_IsLivingEnemy|UAI_Filter_IsHexed")
EndFunc
Func CanUse_EnergySurge()
	If Anti_Spell() Then Return False
	Return True
EndFunc
Func BestTarget_EnergySurge($a_f_AggroRange)
	Local $l_i_BestAgent = 0
	Local $l_i_BestCount = 0
	Local $l_i_BestCasterCount = 0
	For $i = 1 To $g_i_AgentCacheCount
		Local $l_i_AgentID = UAI_GetAgentInfo($i, $GC_UAI_AGENT_ID)
		Local $l_f_Distance = UAI_GetAgentInfo($i, $GC_UAI_AGENT_Distance)
		If $l_f_Distance > $a_f_AggroRange Then ContinueLoop
		If Not UAI_Filter_IsLivingEnemy($l_i_AgentID) Then ContinueLoop
		Local $l_i_EnemyCount = UAI_CountAgents($l_i_AgentID, $GC_I_RANGE_NEARBY, "UAI_Filter_IsLivingEnemy")
		Local $l_i_CasterCount = UAI_CountAgents($l_i_AgentID, $GC_I_RANGE_NEARBY, "UAI_Filter_IsLivingEnemy|UAI_Filter_IsCaster")
		If $l_i_EnemyCount > $l_i_BestCount Then
			$l_i_BestCount = $l_i_EnemyCount
			$l_i_BestCasterCount = $l_i_CasterCount
			$l_i_BestAgent = $l_i_AgentID
		ElseIf $l_i_EnemyCount = $l_i_BestCount And $l_i_CasterCount > $l_i_BestCasterCount Then
			$l_i_BestCasterCount = $l_i_CasterCount
			$l_i_BestAgent = $l_i_AgentID
		EndIf
	Next
	Return $l_i_BestAgent
EndFunc
Func CanUse_EtherFeast()
	If Anti_Spell() Then Return False
	If UAI_GetPlayerInfo($GC_UAI_AGENT_HP) > 0.7 Then Return False
	Return True
EndFunc
Func BestTarget_EtherFeast($a_f_AggroRange)
	Local $l_i_Target = UAI_GetAgentHighest(-2, $a_f_AggroRange, $GC_UAI_AGENT_HP, "UAI_Filter_IsLivingEnemy|UAI_Filter_IsCaster")
	If $l_i_Target <> 0 Then Return $l_i_Target
	Return UAI_GetAgentHighest(-2, $a_f_AggroRange, $GC_UAI_AGENT_HP, "UAI_Filter_IsLivingEnemy")
EndFunc
Func CanUse_EnergyBurn()
	If Anti_Spell() Then Return False
	Return True
EndFunc
Func BestTarget_EnergyBurn($a_f_AggroRange)
	Local $l_i_Target = UAI_GetAgentHighest(-2, $a_f_AggroRange, $GC_UAI_AGENT_HP, "UAI_Filter_IsLivingEnemy|UAI_Filter_IsCaster")
	If $l_i_Target <> 0 Then Return $l_i_Target
	Return UAI_GetAgentHighest(-2, $a_f_AggroRange, $GC_UAI_AGENT_HP, "UAI_Filter_IsLivingEnemy")
EndFunc
Func CanUse_CryOfFrustration()
	If Anti_Spell() Then Return False
	Return True
EndFunc
Func BestTarget_CryOfFrustration($a_f_AggroRange)
	Return UAI_GetBestAOETarget(-2, $a_f_AggroRange, $GC_I_RANGE_NEARBY, "UAI_Filter_IsLivingEnemy")
EndFunc
Func CanUse_Mimic()
	If Anti_Spell() Then Return False
	Return True
EndFunc
Func BestTarget_Mimic($a_f_AggroRange)
	Return UAI_GetPlayerInfo($GC_UAI_AGENT_ID)
EndFunc
Func CanUse_ArcaneMimicry()
	If Anti_Spell() Then Return False
	Return True
EndFunc
Func BestTarget_ArcaneMimicry($a_f_AggroRange)
	Return UAI_GetNearestAgent(-2, $a_f_AggroRange, "UAI_Filter_IsLivingEnemy")
EndFunc
Func CanUse_ShatterHex()
	If Anti_Spell() Then Return False
	Return True
EndFunc
Func BestTarget_ShatterHex($a_f_AggroRange)
	Return UAI_GetNearestAgent(-2, $a_f_AggroRange, "UAI_Filter_IsAlly|UAI_Filter_IsHexed")
EndFunc
Func CanUse_DrainEnchantment()
	If Anti_Spell() Then Return False
	If UAI_GetPlayerInfo($GC_UAI_AGENT_CurrentEnergy) > 20 Then Return False
	Return True
EndFunc
Func BestTarget_DrainEnchantment($a_f_AggroRange)
	Return UAI_GetAgentHighest(-2, $a_f_AggroRange, $GC_UAI_AGENT_HP, "UAI_Filter_IsLivingEnemy|UAI_Filter_IsEnchanted")
EndFunc
Func CanUse_ShatterEnchantment()
	If Anti_Spell() Then Return False
	Return True
EndFunc
Func BestTarget_ShatterEnchantment($a_f_AggroRange)
	Return UAI_GetAgentHighest(-2, $a_f_AggroRange, $GC_UAI_AGENT_HP, "UAI_Filter_IsLivingEnemy|UAI_Filter_IsEnchanted")
EndFunc
Func CanUse_ChaosStorm()
	If Anti_Spell() Then Return False
	Return True
EndFunc
Func BestTarget_ChaosStorm($a_f_AggroRange)
	Return UAI_GetBestAOETarget(-2, $a_f_AggroRange, $GC_I_RANGE_ADJACENT, "UAI_Filter_IsLivingEnemy")
EndFunc
Func CanUse_Epidemic()
	If Anti_Spell() Then Return False
	Return True
EndFunc
Func BestTarget_Epidemic($a_f_AggroRange)
	Local $l_i_Target = UAI_GetBestAOETarget(-2, $a_f_AggroRange, $GC_I_RANGE_ADJACENT, "UAI_Filter_IsLivingEnemy|UAI_Filter_IsConditioned")
	If $l_i_Target <> 0 Then Return $l_i_Target
	Return UAI_GetBestAOETarget(-2, $a_f_AggroRange, $GC_I_RANGE_ADJACENT, "UAI_Filter_IsLivingEnemy")
EndFunc
Func CanUse_EnergyDrain()
	If Anti_Spell() Then Return False
	If UAI_GetPlayerInfo($GC_UAI_AGENT_CurrentEnergy) > 20 Then Return False
	Return True
EndFunc
Func BestTarget_EnergyDrain($a_f_AggroRange)
	Local $l_i_Target = UAI_GetBestSingleTarget(-2, $a_f_AggroRange, $GC_UAI_AGENT_HP, "UAI_Filter_IsLivingEnemy|UAI_Filter_IsMonk")
	If $l_i_Target <> 0 Then Return $l_i_Target
	$l_i_Target = UAI_GetBestSingleTarget(-2, $a_f_AggroRange, $GC_UAI_AGENT_HP, "UAI_Filter_IsLivingEnemy|UAI_Filter_IsCaster")
	If $l_i_Target <> 0 Then Return $l_i_Target
	Return UAI_GetBestSingleTarget(-2, $a_f_AggroRange, $GC_UAI_AGENT_HP, "UAI_Filter_IsLivingEnemy")
EndFunc
Func CanUse_EnergyTap()
	If Anti_Spell() Then Return False
	If UAI_GetPlayerInfo($GC_UAI_AGENT_CurrentEnergy) > 20 Then Return False
	Return True
EndFunc
Func BestTarget_EnergyTap($a_f_AggroRange)
	Local $l_i_Target = UAI_GetBestSingleTarget(-2, $a_f_AggroRange, $GC_UAI_AGENT_HP, "UAI_Filter_IsLivingEnemy|UAI_Filter_IsMonk")
	If $l_i_Target <> 0 Then Return $l_i_Target
	$l_i_Target = UAI_GetBestSingleTarget(-2, $a_f_AggroRange, $GC_UAI_AGENT_HP, "UAI_Filter_IsLivingEnemy|UAI_Filter_IsCaster")
	If $l_i_Target <> 0 Then Return $l_i_Target
	Return UAI_GetBestSingleTarget(-2, $a_f_AggroRange, $GC_UAI_AGENT_HP, "UAI_Filter_IsLivingEnemy")
EndFunc
Func CanUse_ArcaneThievery()
	If Anti_Spell() Then Return False
	Return True
EndFunc
Func BestTarget_ArcaneThievery($a_f_AggroRange)
	Local $l_i_Target = UAI_GetNearestAgent(-2, $a_f_AggroRange, "UAI_Filter_IsLivingEnemy|UAI_Filter_IsCaster")
	If $l_i_Target <> 0 Then Return $l_i_Target
	Return UAI_GetNearestAgent(-2, $a_f_AggroRange, "UAI_Filter_IsLivingEnemy")
EndFunc
Func CanUse_AnimateBoneHorror()
	If Anti_Spell() Then Return False
	Return True
EndFunc
Func BestTarget_AnimateBoneHorror($a_f_AggroRange)
	Return UAI_GetPlayerInfo($GC_UAI_AGENT_ID)
EndFunc
Func CanUse_AnimateBoneFiend()
	If Anti_Spell() Then Return False
	Return True
EndFunc
Func BestTarget_AnimateBoneFiend($a_f_AggroRange)
	Return UAI_GetPlayerInfo($GC_UAI_AGENT_ID)
EndFunc
Func CanUse_AnimateBoneMinions()
	If Anti_Spell() Then Return False
	Return True
EndFunc
Func BestTarget_AnimateBoneMinions($a_f_AggroRange)
	Return UAI_GetPlayerInfo($GC_UAI_AGENT_ID)
EndFunc
Func CanUse_GrenthsBalance()
	If Anti_Spell() Then Return False
	Return True
EndFunc
Func BestTarget_GrenthsBalance($a_f_AggroRange)
	Return UAI_GetPlayerInfo($GC_UAI_AGENT_ID)
EndFunc
Func CanUse_VeratasGaze()
	If Anti_Spell() Then Return False
	Return True
EndFunc
Func BestTarget_VeratasGaze($a_f_AggroRange)
	Return UAI_GetNearestAgent(-2, $a_f_AggroRange, "UAI_Filter_IsLivingEnemy")
EndFunc
Func CanUse_DeathlyChill()
	If Anti_Spell() Then Return False
	Return True
EndFunc
Func BestTarget_DeathlyChill($a_f_AggroRange)
	Return UAI_GetAgentHighest(-2, $a_f_AggroRange, $GC_UAI_AGENT_HP, "UAI_Filter_IsLivingEnemy")
EndFunc
Func CanUse_VeratasSacrifice()
	If Anti_Spell() Then Return False
	Return True
EndFunc
Func BestTarget_VeratasSacrifice($a_f_AggroRange)
	Return UAI_GetPlayerInfo($GC_UAI_AGENT_ID)
EndFunc
Func CanUse_PutridExplosion()
	If Anti_Spell() Then Return False
	Return True
EndFunc
Func BestTarget_PutridExplosion($a_f_AggroRange)
	Return UAI_GetBestCorpseForEnemyPressure($a_f_AggroRange)
EndFunc
Func CanUse_SoulFeast()
	If Anti_Spell() Then Return False
	Return True
EndFunc
Func BestTarget_SoulFeast($a_f_AggroRange)
	Return UAI_GetPlayerInfo($GC_UAI_AGENT_ID)
EndFunc
Func CanUse_NecroticTraversal()
	If Anti_Spell() Then Return False
	Return True
EndFunc
Func BestTarget_NecroticTraversal($a_f_AggroRange)
	Return UAI_GetPlayerInfo($GC_UAI_AGENT_ID)
EndFunc
Func CanUse_ConsumeCorpse()
	If Anti_Spell() Then Return False
	Return True
EndFunc
Func BestTarget_ConsumeCorpse($a_f_AggroRange)
	Return UAI_GetPlayerInfo($GC_UAI_AGENT_ID)
EndFunc
Func CanUse_ShadowStrike()
	If Anti_Spell() Then Return False
	Return True
EndFunc
Func BestTarget_ShadowStrike($a_f_AggroRange)
	Return UAI_GetAgentHighest(-2, $a_f_AggroRange, $GC_UAI_AGENT_HP, "UAI_Filter_IsLivingEnemy")
EndFunc
Func CanUse_DeathlySwarm()
	If Anti_Spell() Then Return False
	Return True
EndFunc
Func BestTarget_DeathlySwarm($a_f_AggroRange)
	Return UAI_GetBestAOETarget(-2, $a_f_AggroRange, $GC_I_RANGE_NEARBY, "UAI_Filter_IsLivingEnemy")
EndFunc
Func CanUse_RottingFlesh()
	If Anti_Spell() Then Return False
	Return True
EndFunc
Func BestTarget_RottingFlesh($a_f_AggroRange)
	Return UAI_GetNearestAgent(-2, $a_f_AggroRange, "UAI_Filter_IsLivingEnemy")
EndFunc
Func CanUse_Virulence()
	If Anti_Spell() Then Return False
	Return True
EndFunc
Func BestTarget_Virulence($a_f_AggroRange)
	Return UAI_GetNearestAgent(-2, $a_f_AggroRange, "UAI_Filter_IsLivingEnemy|UAI_Filter_IsConditioned")
EndFunc
Func CanUse_UnholyFeast()
	If Anti_Spell() Then Return False
	Return True
EndFunc
Func BestTarget_UnholyFeast($a_f_AggroRange)
	Return UAI_GetPlayerInfo($GC_UAI_AGENT_ID)
EndFunc
Func CanUse_DesecrateEnchantments()
	If Anti_Spell() Then Return False
	Return True
EndFunc
Func BestTarget_DesecrateEnchantments($a_f_AggroRange)
	Local $l_i_Target = UAI_GetBestAOETarget(-2, $a_f_AggroRange, $GC_I_RANGE_NEARBY, "UAI_Filter_IsLivingEnemy|UAI_Filter_IsEnchanted")
	If $l_i_Target <> 0 Then Return $l_i_Target
	Return UAI_GetBestAOETarget(-2, $a_f_AggroRange, $GC_I_RANGE_NEARBY, "UAI_Filter_IsLivingEnemy")
EndFunc
Func CanUse_Enfeeble1()
	If Anti_Spell() Then Return False
	Return True
EndFunc
Func BestTarget_Enfeeble1($a_f_AggroRange)
	Return UAI_GetNearestAgent(-2, $a_f_AggroRange, "UAI_Filter_IsLivingEnemy")
EndFunc
Func CanUse_EnfeeblingBlood()
	If Anti_Spell() Then Return False
	Return True
EndFunc
Func BestTarget_EnfeeblingBlood($a_f_AggroRange)
	Return UAI_GetBestAOETarget(-2, $a_f_AggroRange, $GC_I_RANGE_NEARBY, "UAI_Filter_IsLivingEnemy")
EndFunc
Func CanUse_BloodOfTheMaster()
	If Anti_Spell() Then Return False
	Return True
EndFunc
Func BestTarget_BloodOfTheMaster($a_f_AggroRange)
	Return UAI_GetPlayerInfo($GC_UAI_AGENT_ID)
EndFunc
Func CanUse_DarkPact()
	If Anti_Spell() Then Return False
	Return True
EndFunc
Func BestTarget_DarkPact($a_f_AggroRange)
	Return UAI_GetNearestAgent(-2, $a_f_AggroRange, "UAI_Filter_IsLivingEnemy")
EndFunc
Func CanUse_RendEnchantments()
	If Anti_Spell() Then Return False
	Return True
EndFunc
Func BestTarget_RendEnchantments($a_f_AggroRange)
	Return UAI_GetAgentHighest(-2, $a_f_AggroRange, $GC_UAI_AGENT_HP, "UAI_Filter_IsLivingEnemy|UAI_Filter_IsEnchanted")
EndFunc
Func CanUse_StripEnchantment()
	If Anti_Spell() Then Return False
	Return True
EndFunc
Func BestTarget_StripEnchantment($a_f_AggroRange)
	Return UAI_GetAgentHighest(-2, $a_f_AggroRange, $GC_UAI_AGENT_HP, "UAI_Filter_IsLivingEnemy|UAI_Filter_IsEnchanted")
EndFunc
Func CanUse_Chilblains()
	If Anti_Spell() Then Return False
	Return True
EndFunc
Func BestTarget_Chilblains($a_f_AggroRange)
	Local $l_i_Target = UAI_GetBestAOETarget(-2, $a_f_AggroRange, $GC_I_RANGE_NEARBY, "UAI_Filter_IsLivingEnemy|UAI_Filter_IsEnchanted")
	If $l_i_Target <> 0 Then Return $l_i_Target
	Return UAI_GetBestAOETarget(-2, $a_f_AggroRange, $GC_I_RANGE_NEARBY, "UAI_Filter_IsLivingEnemy")
EndFunc
Func CanUse_OfferingOfBlood()
	If Anti_Spell() Then Return False
	Return True
EndFunc
Func BestTarget_OfferingOfBlood($a_f_AggroRange)
	Return UAI_GetPlayerInfo($GC_UAI_AGENT_ID)
EndFunc
Func CanUse_PlagueSending()
	If Anti_Spell() Then Return False
	Return True
EndFunc
Func BestTarget_PlagueSending($a_f_AggroRange)
	Return UAI_GetBestAOETarget(-2, $a_f_AggroRange, $GC_I_RANGE_ADJACENT, "UAI_Filter_IsLivingEnemy")
EndFunc
Func CanUse_FeastOfCorruption()
	If Anti_Spell() Then Return False
	Return True
EndFunc
Func BestTarget_FeastOfCorruption($a_f_AggroRange)
	Local $l_i_Target = UAI_GetBestAOETarget(-2, $a_f_AggroRange, $GC_I_RANGE_ADJACENT, "UAI_Filter_IsLivingEnemy|UAI_Filter_IsHexed")
	If $l_i_Target <> 0 Then Return $l_i_Target
	Return UAI_GetBestAOETarget(-2, $a_f_AggroRange, $GC_I_RANGE_ADJACENT, "UAI_Filter_IsLivingEnemy")
EndFunc
Func CanUse_TasteOfDeath()
	If Anti_Spell() Then Return False
	Return True
EndFunc
Func BestTarget_TasteOfDeath($a_f_AggroRange)
	Return UAI_GetPlayerInfo($GC_UAI_AGENT_ID)
EndFunc
Func CanUse_VampiricGaze()
	If Anti_Spell() Then Return False
	Return True
EndFunc
Func BestTarget_VampiricGaze($a_f_AggroRange)
	Return UAI_GetAgentLowest(-2, $a_f_AggroRange, $GC_UAI_AGENT_HP, "UAI_Filter_IsLivingEnemy")
EndFunc
Func CanUse_WeakenArmor()
	If Anti_Spell() Then Return False
	Return True
EndFunc
Func BestTarget_WeakenArmor($a_f_AggroRange)
	Return UAI_GetBestAOETarget(-2, $a_f_AggroRange, $GC_I_RANGE_ADJACENT, "UAI_Filter_IsLivingEnemy")
EndFunc
Func CanUse_LightningStorm()
	If Anti_Spell() Then Return False
	Return True
EndFunc
Func BestTarget_LightningStorm($a_f_AggroRange)
	Return UAI_GetBestAOETarget(-2, $a_f_AggroRange, $GC_I_RANGE_NEARBY, "UAI_Filter_IsLivingEnemy")
EndFunc
Func CanUse_Gale()
	If Anti_Spell() Then Return False
	Return True
EndFunc
Func BestTarget_Gale($a_f_AggroRange)
	Return UAI_GetNearestAgent(-2, $a_f_AggroRange, "UAI_Filter_IsLivingEnemy")
EndFunc
Func CanUse_Whirlwind()
	If Anti_Spell() Then Return False
	Return True
EndFunc
Func BestTarget_Whirlwind($a_f_AggroRange)
	Return UAI_GetPlayerInfo($GC_UAI_AGENT_ID)
EndFunc
Func CanUse_Eruption()
	If Anti_Spell() Then Return False
	Return True
EndFunc
Func BestTarget_Eruption($a_f_AggroRange)
	Return UAI_GetBestAOETarget(-2, $a_f_AggroRange, $GC_I_RANGE_NEARBY, "UAI_Filter_IsLivingEnemy")
EndFunc
Func CanUse_Earthquake()
	If Anti_Spell() Then Return False
	Return True
EndFunc
Func BestTarget_Earthquake($a_f_AggroRange)
	Return UAI_GetBestAOETarget(-2, $a_f_AggroRange, $GC_I_RANGE_NEARBY, "UAI_Filter_IsLivingEnemy")
EndFunc
Func CanUse_Stoning()
	If Anti_Spell() Then Return False
	Return True
EndFunc
Func BestTarget_Stoning($a_f_AggroRange)
	Local $l_i_Target = UAI_GetNearestAgent(-2, $a_f_AggroRange, "UAI_Filter_IsLivingEnemy|UAI_Filter_IsConditioned")
	If $l_i_Target <> 0 Then Return $l_i_Target
	Return UAI_GetNearestAgent(-2, $a_f_AggroRange, "UAI_Filter_IsLivingEnemy")
EndFunc
Func CanUse_StoneDaggers()
	If Anti_Spell() Then Return False
	Return True
EndFunc
Func BestTarget_StoneDaggers($a_f_AggroRange)
	Return UAI_GetNearestAgent(-2, $a_f_AggroRange, "UAI_Filter_IsLivingEnemy")
EndFunc
Func CanUse_Aftershock()
	If Anti_Spell() Then Return False
	Return True
EndFunc
Func BestTarget_Aftershock($a_f_AggroRange)
	Return UAI_GetPlayerInfo($GC_UAI_AGENT_ID)
EndFunc
Func CanUse_Inferno()
	If Anti_Spell() Then Return False
	Return True
EndFunc
Func BestTarget_Inferno($a_f_AggroRange)
	Return UAI_GetPlayerInfo($GC_UAI_AGENT_ID)
EndFunc
Func CanUse_MindBurn()
	If Anti_Spell() Then Return False
	Return True
EndFunc
Func BestTarget_MindBurn($a_f_AggroRange)
	Return UAI_GetBestAOETarget(-2, $a_f_AggroRange, $GC_I_RANGE_ADJACENT, "UAI_Filter_IsLivingEnemy")
EndFunc
Func CanUse_Fireball()
	If Anti_Spell() Then Return False
	Return True
EndFunc
Func BestTarget_Fireball($a_f_AggroRange)
	Return UAI_GetAgentLowest(-2, $a_f_AggroRange, $GC_UAI_AGENT_HP, "UAI_Filter_IsLivingEnemy")
EndFunc
Func CanUse_Meteor()
	If Anti_Spell() Then Return False
	Return True
EndFunc
Func BestTarget_Meteor($a_f_AggroRange)
	Return UAI_GetBestAOETarget(-2, $a_f_AggroRange, $GC_I_RANGE_ADJACENT, "UAI_Filter_IsLivingEnemy")
EndFunc
Func CanUse_FlameBurst()
	If Anti_Spell() Then Return False
	Return True
EndFunc
Func BestTarget_FlameBurst($a_f_AggroRange)
	Return UAI_GetPlayerInfo($GC_UAI_AGENT_ID)
EndFunc
Func CanUse_RodgortsInvocation()
	If Anti_Spell() Then Return False
	Return True
EndFunc
Func BestTarget_RodgortsInvocation($a_f_AggroRange)
	Return UAI_GetBestAOETarget(-2, $a_f_AggroRange, $GC_I_RANGE_ADJACENT, "UAI_Filter_IsLivingEnemy")
EndFunc
Func CanUse_Immolate()
	If Anti_Spell() Then Return False
	Return True
EndFunc
Func BestTarget_Immolate($a_f_AggroRange)
	Return UAI_GetNearestAgent(-2, $a_f_AggroRange, "UAI_Filter_IsLivingEnemy")
EndFunc
Func CanUse_MeteorShower()
	If Anti_Spell() Then Return False
	Return True
EndFunc
Func BestTarget_MeteorShower($a_f_AggroRange)
	Return UAI_GetBestAOETarget(-2, $a_f_AggroRange, $GC_I_RANGE_SPELLCASTING, "UAI_Filter_IsLivingEnemy")
EndFunc
Func CanUse_Phoenix()
	If Anti_Spell() Then Return False
	Return True
EndFunc
Func BestTarget_Phoenix($a_f_AggroRange)
	Return UAI_GetBestAOETarget(-2, $a_f_AggroRange, $GC_I_RANGE_ADJACENT, "UAI_Filter_IsLivingEnemy")
EndFunc
Func CanUse_Flare()
	If Anti_Spell() Then Return False
	Return True
EndFunc
Func BestTarget_Flare($a_f_AggroRange)
	Return UAI_GetAgentLowest(-2, $a_f_AggroRange, $GC_UAI_AGENT_HP, "UAI_Filter_IsLivingEnemy")
EndFunc
Func CanUse_LavaFont()
	If Anti_Spell() Then Return False
	Return True
EndFunc
Func BestTarget_LavaFont($a_f_AggroRange)
	Return UAI_GetPlayerInfo($GC_UAI_AGENT_ID)
EndFunc
Func CanUse_SearingHeat()
	If Anti_Spell() Then Return False
	Return True
EndFunc
Func BestTarget_SearingHeat($a_f_AggroRange)
	Return UAI_GetBestAOETarget(-2, $a_f_AggroRange, $GC_I_RANGE_SPELLCASTING, "UAI_Filter_IsLivingEnemy")
EndFunc
Func CanUse_FireStorm()
	If Anti_Spell() Then Return False
	Return True
EndFunc
Func BestTarget_FireStorm($a_f_AggroRange)
	Return UAI_GetBestAOETarget(-2, $a_f_AggroRange, $GC_I_RANGE_SPELLCASTING, "UAI_Filter_IsLivingEnemy")
EndFunc
Func CanUse_Maelstrom()
	If Anti_Spell() Then Return False
	Return True
EndFunc
Func BestTarget_Maelstrom($a_f_AggroRange)
	Local $l_i_Target = UAI_GetBestAOETarget(-2, $a_f_AggroRange, $GC_I_RANGE_SPELLCASTING, "UAI_Filter_IsLivingEnemy")
	If $l_i_Target <> 0 Then Return $l_i_Target
	Return UAI_GetBestAOETarget(-2, $a_f_AggroRange, $GC_I_RANGE_SPELLCASTING, "UAI_Filter_IsLivingEnemy")
EndFunc
Func CanUse_CrystalWave()
	If Anti_Spell() Then Return False
	Return True
EndFunc
Func BestTarget_CrystalWave($a_f_AggroRange)
	Return UAI_GetPlayerInfo($GC_UAI_AGENT_ID)
EndFunc
Func CanUse_ObsidianFlame()
	If Anti_Spell() Then Return False
	Return True
EndFunc
Func BestTarget_ObsidianFlame($a_f_AggroRange)
	Return UAI_GetBestAOETarget(-2, $a_f_AggroRange, $GC_I_RANGE_ADJACENT, "UAI_Filter_IsLivingEnemy")
EndFunc
Func CanUse_BlindingFlash()
	If Anti_Spell() Then Return False
	Return True
EndFunc
Func BestTarget_BlindingFlash($a_f_AggroRange)
	Local $l_i_Target = UAI_GetAgentHighest(-2, $a_f_AggroRange, $GC_UAI_AGENT_HP, "UAI_Filter_IsLivingEnemy|UAI_Filter_IsAttacking")
	If $l_i_Target <> 0 Then Return $l_i_Target
	Return UAI_GetAgentHighest(-2, $a_f_AggroRange, $GC_UAI_AGENT_HP, "UAI_Filter_IsLivingEnemy")
EndFunc
Func CanUse_ChainLightning()
	If Anti_Spell() Then Return False
	Return True
EndFunc
Func BestTarget_ChainLightning($a_f_AggroRange)
	Return UAI_GetBestAOETarget(-2, $a_f_AggroRange, $GC_I_RANGE_NEARBY, "UAI_Filter_IsLivingEnemy")
EndFunc
Func CanUse_EnervatingCharge()
	If Anti_Spell() Then Return False
	Return True
EndFunc
Func BestTarget_EnervatingCharge($a_f_AggroRange)
	Return UAI_GetNearestAgent(-2, $a_f_AggroRange, "UAI_Filter_IsLivingEnemy")
EndFunc
Func CanUse_MindShock()
	If Anti_Spell() Then Return False
	Return True
EndFunc
Func BestTarget_MindShock($a_f_AggroRange)
	Return UAI_GetNearestAgent(-2, $a_f_AggroRange, "UAI_Filter_IsLivingEnemy")
EndFunc
Func CanUse_Thunderclap()
	If Anti_Spell() Then Return False
	Return True
EndFunc
Func BestTarget_Thunderclap($a_f_AggroRange)
	Return UAI_GetBestAOETarget(-2, $a_f_AggroRange, $GC_I_RANGE_ADJACENT, "UAI_Filter_IsLivingEnemy")
EndFunc
Func CanUse_LightningOrb1()
	If Anti_Spell() Then Return False
	Return True
EndFunc
Func BestTarget_LightningOrb1($a_f_AggroRange)
	Return UAI_GetNearestAgent(-2, $a_f_AggroRange, "UAI_Filter_IsLivingEnemy")
EndFunc
Func CanUse_LightningJavelin()
	If Anti_Spell() Then Return False
	Return True
EndFunc
Func BestTarget_LightningJavelin($a_f_AggroRange)
	Local $l_i_Target = UAI_GetAgentLowest(-2, $a_f_AggroRange, $GC_UAI_AGENT_HP, "UAI_Filter_IsLivingEnemy|UAI_Filter_IsAttacking")
	If $l_i_Target <> 0 Then Return $l_i_Target
	Return UAI_GetAgentLowest(-2, $a_f_AggroRange, $GC_UAI_AGENT_HP, "UAI_Filter_IsLivingEnemy")
EndFunc
Func CanUse_WaterTrident()
	If Anti_Spell() Then Return False
	Return True
EndFunc
Func BestTarget_WaterTrident($a_f_AggroRange)
	Return UAI_GetAgentLowest(-2, $a_f_AggroRange, $GC_UAI_AGENT_HP, "UAI_Filter_IsLivingEnemy")
EndFunc
Func CanUse_Smite()
	If Anti_Spell() Then Return False
	Return True
EndFunc
Func BestTarget_Smite($a_f_AggroRange)
	Return UAI_GetAgentLowest(-2, $a_f_AggroRange, $GC_UAI_AGENT_HP, "UAI_Filter_IsLivingEnemy|UAI_Filter_IsAttacking")
EndFunc
Func CanUse_SymbolOfWrath()
	If Anti_Spell() Then Return False
	Return True
EndFunc
Func BestTarget_SymbolOfWrath($a_f_AggroRange)
	Return UAI_GetBestAOETarget(-2, $a_f_AggroRange, $GC_I_RANGE_ADJACENT, "UAI_Filter_IsLivingEnemy")
EndFunc
Func CanUse_Banish()
	If Anti_Spell() Then Return False
	Return True
EndFunc
Func BestTarget_Banish($a_f_AggroRange)
	Local $l_i_Target = UAI_GetBestSingleTarget(-2, $a_f_AggroRange, $GC_UAI_AGENT_HP, "UAI_Filter_IsLivingEnemy|UAI_Filter_IsMinion")
	If $l_i_Target <> 0 Then Return $l_i_Target
	$l_i_Target = UAI_GetBestSingleTarget(-2, $a_f_AggroRange, $GC_UAI_AGENT_HP, "UAI_Filter_IsLivingEnemy|UAI_Filter_IsSpirit")
	If $l_i_Target <> 0 Then Return $l_i_Target
	Return UAI_GetBestSingleTarget(-2, $a_f_AggroRange, $GC_UAI_AGENT_HP, "UAI_Filter_IsLivingEnemy")
EndFunc
Func CanUse_MendCondition()
	If Anti_Spell() Then Return False
	Return True
EndFunc
Func BestTarget_MendCondition($a_f_AggroRange)
	Local $l_i_Target = UAI_GetAgentLowest(-2, $a_f_AggroRange, $GC_UAI_AGENT_HP, "UAI_Filter_IsLivingAlly|UAI_Filter_ExcludeMe|UAI_Filter_IsConditioned")
	If $l_i_Target <> 0 Then Return $l_i_Target
	Return UAI_GetAgentLowest(-2, $a_f_AggroRange, $GC_UAI_AGENT_HP, "UAI_Filter_IsLivingAlly|UAI_Filter_ExcludeMe")
EndFunc
Func CanUse_RestoreCondition()
	If Anti_Spell() Then Return False
	Return True
EndFunc
Func BestTarget_RestoreCondition($a_f_AggroRange)
	Local $l_i_Target = UAI_GetAgentLowest(-2, $a_f_AggroRange, $GC_UAI_AGENT_HP, "UAI_Filter_IsLivingAlly|UAI_Filter_ExcludeMe|UAI_Filter_IsConditioned")
	If $l_i_Target <> 0 Then Return $l_i_Target
	Return UAI_GetAgentLowest(-2, $a_f_AggroRange, $GC_UAI_AGENT_HP, "UAI_Filter_IsLivingAlly|UAI_Filter_ExcludeMe")
EndFunc
Func CanUse_MendAilment()
	If Anti_Spell() Then Return False
	Return True
EndFunc
Func BestTarget_MendAilment($a_f_AggroRange)
	Return UAI_GetAgentLowest(-2, $a_f_AggroRange, $GC_UAI_AGENT_HP, "UAI_Filter_IsLivingAlly|UAI_Filter_IsConditioned")
EndFunc
Func CanUse_PurgeConditions()
	If Anti_Spell() Then Return False
	Return True
EndFunc
Func BestTarget_PurgeConditions($a_f_AggroRange)
	Return UAI_GetAgentLowest(-2, $a_f_AggroRange, $GC_UAI_AGENT_HP, "UAI_Filter_IsLivingAlly|UAI_Filter_IsConditioned")
EndFunc
Func CanUse_DivineHealing()
	If Anti_Spell() Then Return False
	Return True
EndFunc
Func BestTarget_DivineHealing($a_f_AggroRange)
	Return UAI_GetPlayerInfo($GC_UAI_AGENT_ID)
EndFunc
Func CanUse_HealArea()
	If Anti_Spell() Then Return False
	Return True
EndFunc
Func BestTarget_HealArea($a_f_AggroRange)
	Return UAI_GetPlayerInfo($GC_UAI_AGENT_ID)
EndFunc
Func CanUse_OrisonOfHealing()
	If Anti_Spell() Then Return False
	If UAI_GetAgentInfoByID($g_i_BestTarget, $GC_UAI_AGENT_HP) > 0.8 Then Return False
	Return True
EndFunc
Func BestTarget_OrisonOfHealing($a_f_AggroRange)
	Return UAI_GetAgentLowest(-2, $a_f_AggroRange, $GC_UAI_AGENT_HP, "UAI_Filter_IsLivingAlly")
EndFunc
Func CanUse_WordOfHealing()
	If Anti_Spell() Then Return False
	Return True
EndFunc
Func BestTarget_WordOfHealing($a_f_AggroRange)
    Local $l_i_Target = UAI_GetAgentLowest(-2, $a_f_AggroRange, $GC_UAI_AGENT_HP, "UAI_Filter_IsLivingAlly")
    If $l_i_Target <> 0 Then Return $l_i_Target
    Return UAI_GetAgentLowest(-2, $a_f_AggroRange, $GC_UAI_AGENT_HP, "UAI_Filter_IsLivingAlly|UAI_Filter_ExcludeMe")
EndFunc
Func CanUse_DwaynasKiss()
	If Anti_Spell() Then Return False
	If UAI_GetAgentInfoByID($g_i_BestTarget, $GC_UAI_AGENT_HP) > 0.8 Then Return False
	Return True
EndFunc
Func BestTarget_DwaynasKiss($a_f_AggroRange)
	Local $l_i_Target = UAI_GetAgentLowest(-2, $a_f_AggroRange, $GC_UAI_AGENT_HP, "UAI_Filter_IsLivingAlly|UAI_Filter_ExcludeMe|UAI_Filter_IsEnchanted|UAI_Filter_IsHexed")
	If UAI_GetAgentInfoByID($l_i_Target, $GC_UAI_AGENT_HP) < 0.8 And $l_i_Target <> 0 Then Return $l_i_Target
	$l_i_Target = UAI_GetAgentLowest(-2, $a_f_AggroRange, $GC_UAI_AGENT_HP, "UAI_Filter_IsLivingAlly|UAI_Filter_ExcludeMe|UAI_Filter_IsHexed")
	If UAI_GetAgentInfoByID($l_i_Target, $GC_UAI_AGENT_HP) < 0.8 And $l_i_Target <> 0 Then Return $l_i_Target
	$l_i_Target = UAI_GetAgentLowest(-2, $a_f_AggroRange, $GC_UAI_AGENT_HP, "UAI_Filter_IsLivingAlly|UAI_Filter_ExcludeMe|UAI_Filter_IsEnchanted")
	If UAI_GetAgentInfoByID($l_i_Target, $GC_UAI_AGENT_HP) < 0.8 And $l_i_Target <> 0 Then Return $l_i_Target
	$l_i_Target = UAI_GetAgentLowest(-2, $a_f_AggroRange, $GC_UAI_AGENT_HP, "UAI_Filter_IsLivingAlly|UAI_Filter_ExcludeMe")
	If UAI_GetAgentInfoByID($l_i_Target, $GC_UAI_AGENT_HP) < 0.5 And $l_i_Target <> 0 Then Return $l_i_Target
	Return $l_i_Target
EndFunc
Func CanUse_HealOther()
	If Anti_Spell() Then Return False
	Return True
EndFunc
Func BestTarget_HealOther($a_f_AggroRange)
	Return UAI_GetAgentLowest(-2, $a_f_AggroRange, $GC_UAI_AGENT_HP, "UAI_Filter_IsLivingAlly|UAI_Filter_ExcludeMe")
EndFunc
Func CanUse_HealParty()
	If Anti_Spell() Then Return False
	Return True
EndFunc
Func BestTarget_HealParty($a_f_AggroRange)
	Return UAI_GetPlayerInfo($GC_UAI_AGENT_ID)
EndFunc
Func CanUse_InfuseHealth()
	If Anti_Spell() Then Return False
	Return True
EndFunc
Func BestTarget_InfuseHealth($a_f_AggroRange)
	Local $l_i_Target = UAI_GetAgentLowest(-2, $a_f_AggroRange, $GC_UAI_AGENT_HP, "UAI_Filter_IsLivingAlly|UAI_Filter_ExcludeMe")
    If $l_i_Target <> 0 And UAI_GetAgentInfoByID($l_i_Target, $GC_UAI_AGENT_HP) < 0.1 Then Return $l_i_Target
    Return UAI_GetAgentLowest(-2, $a_f_AggroRange, $GC_UAI_AGENT_HP, "UAI_Filter_IsLivingAlly|UAI_Filter_ExcludeMe")
EndFunc
Func CanUse_Martyr()
	If Anti_Spell() Then Return False
	Return True
EndFunc
Func BestTarget_Martyr($a_f_AggroRange)
	Return UAI_GetPlayerInfo($GC_UAI_AGENT_ID)
EndFunc
Func CanUse_RemoveHex()
	If Anti_Spell() Then Return False
	Return True
EndFunc
Func BestTarget_RemoveHex($a_f_AggroRange)
	Return UAI_GetAgentLowest(-2, $a_f_AggroRange, $GC_UAI_AGENT_HP, "UAI_Filter_IsLivingAlly|UAI_Filter_IsHexed")
EndFunc
Func CanUse_SmiteHex()
	If Anti_Spell() Then Return False
	If UAI_CountAgents($g_i_BestTarget, $GC_I_RANGE_AREA, "UAI_Filter_IsLivingEnemy") < 1 Then Return False
	Return True
EndFunc
Func BestTarget_SmiteHex($a_f_AggroRange)
	Return UAI_GetAgentLowest(-2, $a_f_AggroRange, $GC_UAI_AGENT_HP, "UAI_Filter_IsLivingAlly|UAI_Filter_IsHexed")
EndFunc
Func CanUse_ConvertHexes()
	If Anti_Spell() Then Return False
	Return True
EndFunc
Func BestTarget_ConvertHexes($a_f_AggroRange)
	Local $l_i_Target = UAI_GetAgentLowest(-2, $a_f_AggroRange, $GC_UAI_AGENT_HP, "UAI_Filter_IsLivingAlly|UAI_Filter_ExcludeMe|UAI_Filter_IsHexed")
	If $l_i_Target <> 0 Then Return $l_i_Target
	Return UAI_GetAgentLowest(-2, $a_f_AggroRange, $GC_UAI_AGENT_HP, "UAI_Filter_IsLivingAlly|UAI_Filter_ExcludeMe")
EndFunc
Func CanUse_LightOfDwayna()
	If Anti_Spell() Then Return False
	If UAI_PlayerHasEffect($GC_I_SKILL_ID_CURSE_OF_DHUUM) Or UAI_PlayerHasEffect($GC_I_SKILL_ID_FROZEN_SOIL) Then Return False
	Return True
EndFunc
Func BestTarget_LightOfDwayna($a_f_AggroRange)
	Return UAI_GetPlayerInfo($GC_UAI_AGENT_ID)
EndFunc
Func CanUse_Resurrect()
	If Anti_Spell() Then Return False
	If UAI_PlayerHasEffect($GC_I_SKILL_ID_CURSE_OF_DHUUM) Or UAI_PlayerHasEffect($GC_I_SKILL_ID_FROZEN_SOIL) Then Return False
	Return True
EndFunc
Func BestTarget_Resurrect($a_f_AggroRange)
	Return UAI_GetNearestAgent(-2, $a_f_AggroRange, "UAI_Filter_IsDeadAlly")
EndFunc
Func CanUse_Rebirth()
	If Anti_Spell() Then Return False
	If UAI_PlayerHasEffect($GC_I_SKILL_ID_CURSE_OF_DHUUM) Or UAI_PlayerHasEffect($GC_I_SKILL_ID_FROZEN_SOIL) Then Return False
	Return True
EndFunc
Func BestTarget_Rebirth($a_f_AggroRange)
	Return UAI_GetNearestAgent(-2, $a_f_AggroRange, "UAI_Filter_IsDeadAlly")
EndFunc
Func CanUse_DrawConditions()
	If Anti_Spell() Then Return False
	Return True
EndFunc
Func BestTarget_DrawConditions($a_f_AggroRange)
	Return UAI_GetAgentLowest(-2, $a_f_AggroRange, $GC_UAI_AGENT_HP, "UAI_Filter_IsLivingAlly|UAI_Filter_ExcludeMe|UAI_Filter_IsConditioned")
EndFunc
Func CanUse_HealingTouch()
	If Anti_Spell() Then Return False
	Return True
EndFunc
Func BestTarget_HealingTouch($a_f_AggroRange)
	Return UAI_GetAgentLowest(-2, $a_f_AggroRange, $GC_UAI_AGENT_HP, "UAI_Filter_IsLivingAlly")
EndFunc
Func CanUse_RestoreLife()
	If Anti_Spell() Then Return False
	If UAI_PlayerHasEffect($GC_I_SKILL_ID_CURSE_OF_DHUUM) Or UAI_PlayerHasEffect($GC_I_SKILL_ID_FROZEN_SOIL) Then Return False
	Return True
EndFunc
Func BestTarget_RestoreLife($a_f_AggroRange)
	Return UAI_GetNearestAgent(-2, $a_f_AggroRange, "UAI_Filter_IsDeadAlly")
EndFunc
Func CanUse_EruptionEnvironment()
	If Anti_Spell() Then Return False
	Return True
EndFunc
Func BestTarget_EruptionEnvironment($a_f_AggroRange)
	Return UAI_GetPlayerInfo($GC_UAI_AGENT_ID)
EndFunc
Func CanUse_FireStormEnvironment()
	If Anti_Spell() Then Return False
	Return True
EndFunc
Func BestTarget_FireStormEnvironment($a_f_AggroRange)
	Return UAI_GetPlayerInfo($GC_UAI_AGENT_ID)
EndFunc
Func CanUse_FountOfMaguuma()
	If Anti_Spell() Then Return False
	Return True
EndFunc
Func BestTarget_FountOfMaguuma($a_f_AggroRange)
	Return UAI_GetPlayerInfo($GC_UAI_AGENT_ID)
EndFunc
Func CanUse_HealingFountain()
	If Anti_Spell() Then Return False
	Return True
EndFunc
Func BestTarget_HealingFountain($a_f_AggroRange)
	Return UAI_GetPlayerInfo($GC_UAI_AGENT_ID)
EndFunc
Func CanUse_IcyGround()
	If Anti_Spell() Then Return False
	Return True
EndFunc
Func BestTarget_IcyGround($a_f_AggroRange)
	Return UAI_GetPlayerInfo($GC_UAI_AGENT_ID)
EndFunc
Func CanUse_MaelstromEnvironment()
	If Anti_Spell() Then Return False
	Return True
EndFunc
Func BestTarget_MaelstromEnvironment($a_f_AggroRange)
	Return UAI_GetPlayerInfo($GC_UAI_AGENT_ID)
EndFunc
Func CanUse_MursaatTowerSkill()
	If Anti_Spell() Then Return False
	Return True
EndFunc
Func BestTarget_MursaatTowerSkill($a_f_AggroRange)
	Return UAI_GetNearestAgent(-2, $a_f_AggroRange, "UAI_Filter_IsLivingEnemy")
EndFunc
Func CanUse_QuicksandEnvironmentEffect()
	If Anti_Spell() Then Return False
	Return True
EndFunc
Func BestTarget_QuicksandEnvironmentEffect($a_f_AggroRange)
	Return UAI_GetPlayerInfo($GC_UAI_AGENT_ID)
EndFunc
Func CanUse_CurseOfTheBloodstone()
	If Anti_Spell() Then Return False
	Return True
EndFunc
Func BestTarget_CurseOfTheBloodstone($a_f_AggroRange)
	Return UAI_GetPlayerInfo($GC_UAI_AGENT_ID)
EndFunc
Func CanUse_ChainLightningEnvironment()
	If Anti_Spell() Then Return False
	Return True
EndFunc
Func BestTarget_ChainLightningEnvironment($a_f_AggroRange)
	Return UAI_GetPlayerInfo($GC_UAI_AGENT_ID)
EndFunc
Func CanUse_ObeliskLightning()
	If Anti_Spell() Then Return False
	Return True
EndFunc
Func BestTarget_ObeliskLightning($a_f_AggroRange)
	Return UAI_GetPlayerInfo($GC_UAI_AGENT_ID)
EndFunc
Func CanUse_Tar()
	If Anti_Spell() Then Return False
	Return True
EndFunc
Func BestTarget_Tar($a_f_AggroRange)
	Return UAI_GetPlayerInfo($GC_UAI_AGENT_ID)
EndFunc
Func CanUse_Nibble()
	If Anti_Spell() Then Return False
	Return True
EndFunc
Func BestTarget_Nibble($a_f_AggroRange)
	Return UAI_GetPlayerInfo($GC_UAI_AGENT_ID)
EndFunc
Func CanUse_GuardianPacify()
	If Anti_Spell() Then Return False
	Return True
EndFunc
Func BestTarget_GuardianPacify($a_f_AggroRange)
	Return UAI_GetPlayerInfo($GC_UAI_AGENT_ID)
EndFunc
Func CanUse_SoulVortex()
	If Anti_Spell() Then Return False
	Return True
EndFunc
Func BestTarget_SoulVortex($a_f_AggroRange)
	Return UAI_GetPlayerInfo($GC_UAI_AGENT_ID)
EndFunc
Func CanUse_ResurrectGargoyle()
	If Anti_Spell() Then Return False
	Return True
EndFunc
Func BestTarget_ResurrectGargoyle($a_f_AggroRange)
	Return UAI_GetPlayerInfo($GC_UAI_AGENT_ID)
EndFunc
Func CanUse_LightningOrb2()
	If Anti_Spell() Then Return False
	Return True
EndFunc
Func BestTarget_LightningOrb2($a_f_AggroRange)
	Return UAI_GetNearestAgent(-2, $a_f_AggroRange, "UAI_Filter_IsLivingEnemy")
EndFunc
Func CanUse_WurmSiegeDunesOfDespair()
	If Anti_Spell() Then Return False
	Return True
EndFunc
Func BestTarget_WurmSiegeDunesOfDespair($a_f_AggroRange)
	Return UAI_GetBestAOETarget(-2, $a_f_AggroRange, $GC_I_RANGE_ADJACENT, "UAI_Filter_IsLivingEnemy")
EndFunc
Func CanUse_WurmSiege()
	If Anti_Spell() Then Return False
	Return True
EndFunc
Func BestTarget_WurmSiege($a_f_AggroRange)
	Return UAI_GetBestAOETarget(-2, $a_f_AggroRange, $GC_I_RANGE_ADJACENT, "UAI_Filter_IsLivingEnemy")
EndFunc
Func CanUse_ShiverTouch()
	If Anti_Spell() Then Return False
	Return True
EndFunc
Func BestTarget_ShiverTouch($a_f_AggroRange)
	Return UAI_GetNearestAgent(-2, $a_f_AggroRange, "UAI_Filter_IsLivingEnemy")
EndFunc
Func CanUse_Vanish()
	If Anti_Spell() Then Return False
	Return True
EndFunc
Func BestTarget_Vanish($a_f_AggroRange)
	Return UAI_GetPlayerInfo($GC_UAI_AGENT_ID)
EndFunc
Func CanUse_DisruptingDagger()
	If Anti_Spell() Then Return False
	Return True
EndFunc
Func BestTarget_DisruptingDagger($a_f_AggroRange)
	Local $l_i_Target = UAI_GetNearestAgent(-2, $a_f_AggroRange, "UAI_Filter_IsLivingEnemy|UAI_Filter_IsCasting")
	If $l_i_Target <> 0 Then Return $l_i_Target
	Return UAI_GetNearestAgent(-2, $a_f_AggroRange, "UAI_Filter_IsLivingEnemy")
EndFunc
Func CanUse_StatuesBlessing()
	If Anti_Spell() Then Return False
	Return True
EndFunc
Func BestTarget_StatuesBlessing($a_f_AggroRange)
	Return UAI_GetPlayerInfo($GC_UAI_AGENT_ID)
EndFunc
Func CanUse_DomainOfSkillDamage()
	If Anti_Spell() Then Return False
	Return True
EndFunc
Func BestTarget_DomainOfSkillDamage($a_f_AggroRange)
	Return UAI_GetPlayerInfo($GC_UAI_AGENT_ID)
EndFunc
Func CanUse_DomainOfEnergyDraining()
	If Anti_Spell() Then Return False
	Return True
EndFunc
Func BestTarget_DomainOfEnergyDraining($a_f_AggroRange)
	Return UAI_GetPlayerInfo($GC_UAI_AGENT_ID)
EndFunc
Func CanUse_DomainOfElements()
	If Anti_Spell() Then Return False
	Return True
EndFunc
Func BestTarget_DomainOfElements($a_f_AggroRange)
	Return UAI_GetPlayerInfo($GC_UAI_AGENT_ID)
EndFunc
Func CanUse_DomainOfHealthDraining()
	If Anti_Spell() Then Return False
	Return True
EndFunc
Func BestTarget_DomainOfHealthDraining($a_f_AggroRange)
	Return UAI_GetPlayerInfo($GC_UAI_AGENT_ID)
EndFunc
Func CanUse_DomainOfSlow()
	If Anti_Spell() Then Return False
	Return True
EndFunc
Func BestTarget_DomainOfSlow($a_f_AggroRange)
	Return UAI_GetPlayerInfo($GC_UAI_AGENT_ID)
EndFunc
Func CanUse_SwampWater()
	If Anti_Spell() Then Return False
	Return True
EndFunc
Func BestTarget_SwampWater($a_f_AggroRange)
	Return UAI_GetPlayerInfo($GC_UAI_AGENT_ID)
EndFunc
Func CanUse_JanthirsGaze()
	If Anti_Spell() Then Return False
	Return True
EndFunc
Func BestTarget_JanthirsGaze($a_f_AggroRange)
	Return UAI_GetPlayerInfo($GC_UAI_AGENT_ID)
EndFunc
Func CanUse_FakeSpell()
	If Anti_Spell() Then Return False
	Return True
EndFunc
Func BestTarget_FakeSpell($a_f_AggroRange)
	Return UAI_GetPlayerInfo($GC_UAI_AGENT_ID)
EndFunc
Func CanUse_StormcallerSkill()
	If Anti_Spell() Then Return False
	Return True
EndFunc
Func BestTarget_StormcallerSkill($a_f_AggroRange)
	Return UAI_GetPlayerInfo($GC_UAI_AGENT_ID)
EndFunc
Func CanUse_QuestSkill()
	If Anti_Spell() Then Return False
	Return True
EndFunc
Func BestTarget_QuestSkill($a_f_AggroRange)
	Return UAI_GetPlayerInfo($GC_UAI_AGENT_ID)
EndFunc
Func CanUse_RurikMustLive()
	If Anti_Spell() Then Return False
	Return True
EndFunc
Func BestTarget_RurikMustLive($a_f_AggroRange)
	Return UAI_GetPlayerInfo($GC_UAI_AGENT_ID)
EndFunc
Func CanUse_GazeOfContempt()
	If Anti_Spell() Then Return False
	Return True
EndFunc
Func BestTarget_GazeOfContempt($a_f_AggroRange)
	Return UAI_GetAgentHighest(-2, $a_f_AggroRange, $GC_UAI_AGENT_HP, "UAI_Filter_IsLivingEnemy")
EndFunc
Func CanUse_VipersDefense()
	If Anti_Spell() Then Return False
	Return True
EndFunc
Func BestTarget_VipersDefense($a_f_AggroRange)
	Return UAI_GetPlayerInfo($GC_UAI_AGENT_ID)
EndFunc
Func CanUse_Return()
	If Anti_Spell() Then Return False
	Return True
EndFunc
Func BestTarget_Return($a_f_AggroRange)
	Return UAI_GetNearestAgent(-2, $a_f_AggroRange, "UAI_Filter_IsAlly|UAI_Filter_ExcludeMe")
EndFunc
Func CanUse_EntanglingAsp()
	If Anti_Spell() Then Return False
	Return True
EndFunc
Func BestTarget_EntanglingAsp($a_f_AggroRange)
	Return UAI_GetNearestAgent(-2, $a_f_AggroRange, "UAI_Filter_IsLivingEnemy|UAI_Filter_IsLastStrikeIsLead")
EndFunc
Func CanUse_FleshOfMyFlesh()
	If Anti_Spell() Then Return False
	If UAI_PlayerHasEffect($GC_I_SKILL_ID_CURSE_OF_DHUUM) Or UAI_PlayerHasEffect($GC_I_SKILL_ID_FROZEN_SOIL) Then Return False
	Return True
EndFunc
Func BestTarget_FleshOfMyFlesh($a_f_AggroRange)
	Return UAI_GetNearestAgent(-2, $a_f_AggroRange, "UAI_Filter_IsDeadAlly")
EndFunc
Func CanUse_SorrowsFlame()
	If Anti_Spell() Then Return False
	Return True
EndFunc
Func BestTarget_SorrowsFlame($a_f_AggroRange)
	Return UAI_GetPlayerInfo($GC_UAI_AGENT_ID)
EndFunc
Func CanUse_SorrowsFist()
	If Anti_Spell() Then Return False
	Return True
EndFunc
Func BestTarget_SorrowsFist($a_f_AggroRange)
	Return UAI_GetPlayerInfo($GC_UAI_AGENT_ID)
EndFunc
Func CanUse_BlastFurnace()
	If Anti_Spell() Then Return False
	Return True
EndFunc
Func BestTarget_BlastFurnace($a_f_AggroRange)
	Return UAI_GetPlayerInfo($GC_UAI_AGENT_ID)
EndFunc
Func CanUse_BeguilingHaze()
	If Anti_Spell() Then Return False
	Return True
EndFunc
Func BestTarget_BeguilingHaze($a_f_AggroRange)
	Return UAI_GetNearestAgent(-2, $a_f_AggroRange, "UAI_Filter_IsLivingEnemy")
EndFunc
Func CanUse_AnimateVampiricHorror()
	If Anti_Spell() Then Return False
	Return True
EndFunc
Func BestTarget_AnimateVampiricHorror($a_f_AggroRange)
	Return UAI_GetPlayerInfo($GC_UAI_AGENT_ID)
EndFunc
Func CanUse_Discord()
	If Anti_Spell() Then Return False
	Return True
EndFunc
Func BestTarget_Discord($a_f_AggroRange)
	Local $l_i_Target
	$l_i_Target = UAI_GetBestSingleTarget(-2, $a_f_AggroRange, $GC_UAI_AGENT_HP, "UAI_Filter_IsLivingEnemy|UAI_Filter_IsHexedOrEnchanted|UAI_Filter_IsConditioned")
	If $l_i_Target <> 0 Then Return $l_i_Target
	Return UAI_GetNearestAgent(-2, $a_f_AggroRange, "UAI_Filter_IsLivingEnemy")
EndFunc
Func CanUse_LavaArrows()
	If Anti_Spell() Then Return False
	Return True
EndFunc
Func BestTarget_LavaArrows($a_f_AggroRange)
	Return UAI_GetBestAOETarget(-2, $a_f_AggroRange, $GC_I_RANGE_NEARBY, "UAI_Filter_IsLivingEnemy")
EndFunc
Func CanUse_BedOfCoals()
	If Anti_Spell() Then Return False
	Return True
EndFunc
Func BestTarget_BedOfCoals($a_f_AggroRange)
	Return UAI_GetBestAOETarget(-2, $a_f_AggroRange, $GC_I_RANGE_ADJACENT, "UAI_Filter_IsLivingEnemy")
EndFunc
Func CanUse_RayOfJudgment()
	If Anti_Spell() Then Return False
	Return True
EndFunc
Func BestTarget_RayOfJudgment($a_f_AggroRange)
	Return UAI_GetBestAOETarget(-2, $a_f_AggroRange, $GC_I_RANGE_SPELLCASTING, "UAI_Filter_IsLivingEnemy")
EndFunc
Func CanUse_AnimateFleshGolem()
	If Anti_Spell() Then Return False
	Return True
EndFunc
Func BestTarget_AnimateFleshGolem($a_f_AggroRange)
	Return UAI_GetPlayerInfo($GC_UAI_AGENT_ID)
EndFunc
Func CanUse_RideTheLightning()
	If Anti_Spell() Then Return False
	Return True
EndFunc
Func BestTarget_RideTheLightning($a_f_AggroRange)
	Return UAI_GetNearestAgent(-2, $a_f_AggroRange, "UAI_Filter_IsLivingEnemy")
EndFunc
Func CanUse_PoisonedHeart()
	If Anti_Spell() Then Return False
	Return True
EndFunc
Func BestTarget_PoisonedHeart($a_f_AggroRange)
	Return UAI_GetPlayerInfo($GC_UAI_AGENT_ID)
EndFunc
Func CanUse_FetidGround()
	If Anti_Spell() Then Return False
	Return True
EndFunc
Func BestTarget_FetidGround($a_f_AggroRange)
	Return UAI_GetNearestAgent(-2, $a_f_AggroRange, "UAI_Filter_IsLivingEnemy")
EndFunc
Func CanUse_ArcLightning()
	If Anti_Spell() Then Return False
	Return True
EndFunc
Func BestTarget_ArcLightning($a_f_AggroRange)
	Return UAI_GetBestAOETarget(-2, $a_f_AggroRange, $GC_I_RANGE_NEARBY, "UAI_Filter_IsLivingEnemy")
EndFunc
Func CanUse_ChurningEarth()
	If Anti_Spell() Then Return False
	Return True
EndFunc
Func BestTarget_ChurningEarth($a_f_AggroRange)
	Return UAI_GetBestAOETarget(-2, $a_f_AggroRange, $GC_I_RANGE_ADJACENT, "UAI_Filter_IsLivingEnemy")
EndFunc
Func CanUse_LiquidFlame()
	If Anti_Spell() Then Return False
	Return True
EndFunc
Func BestTarget_LiquidFlame($a_f_AggroRange)
	Return UAI_GetNearestAgent(-2, $a_f_AggroRange, "UAI_Filter_IsLivingEnemy")
EndFunc
Func CanUse_Steam1()
	If Anti_Spell() Then Return False
	Return True
EndFunc
Func BestTarget_Steam1($a_f_AggroRange)
	Return UAI_GetBestAOETarget(-2, $a_f_AggroRange, $GC_I_RANGE_ADJACENT, "UAI_Filter_IsLivingEnemy")
EndFunc
Func CanUse_Chomper()
	If Anti_Spell() Then Return False
	Return True
EndFunc
Func BestTarget_Chomper($a_f_AggroRange)
	Return UAI_GetPlayerInfo($GC_UAI_AGENT_ID)
EndFunc
Func CanUse_DancingDaggers()
	If Anti_Spell() Then Return False
	Return True
EndFunc
Func BestTarget_DancingDaggers($a_f_AggroRange)
	Return UAI_GetNearestAgent(-2, $a_f_AggroRange, "UAI_Filter_IsLivingEnemy")
EndFunc
Func CanUse_RavenousGaze()
	If Anti_Spell() Then Return False
	Return True
EndFunc
Func BestTarget_RavenousGaze($a_f_AggroRange)
	Return UAI_GetBestAOETarget(-2, $a_f_AggroRange, $GC_I_RANGE_NEARBY, "UAI_Filter_IsLivingEnemy")
EndFunc
Func CanUse_OppressiveGaze()
	If Anti_Spell() Then Return False
	Return True
EndFunc
Func BestTarget_OppressiveGaze($a_f_AggroRange)
	Return UAI_GetBestAOETarget(-2, $a_f_AggroRange, $GC_I_RANGE_ADJACENT, "UAI_Filter_IsLivingEnemy")
EndFunc
Func CanUse_LightningHammer()
	If Anti_Spell() Then Return False
	Return True
EndFunc
Func BestTarget_LightningHammer($a_f_AggroRange)
	Return UAI_GetNearestAgent(-2, $a_f_AggroRange, "UAI_Filter_IsLivingEnemy")
EndFunc
Func CanUse_VaporBlade()
	If Anti_Spell() Then Return False
	Return True
EndFunc
Func BestTarget_VaporBlade($a_f_AggroRange)
	Return UAI_GetNearestAgent(-2, $a_f_AggroRange, "UAI_Filter_IsLivingEnemy")
EndFunc
Func CanUse_HealingLight()
	If Anti_Spell() Then Return False
	Return True
EndFunc
Func BestTarget_HealingLight($a_f_AggroRange)
	Local $l_i_Target = UAI_GetAgentLowest(-2, $a_f_AggroRange, $GC_UAI_AGENT_HP, "UAI_Filter_IsLivingAlly|UAI_Filter_IsEnchanted")
	If $l_i_Target <> 0 And UAI_GetAgentInfoByID($l_i_Target, $GC_UAI_AGENT_HP) < 0.9 Then Return $l_i_Target
	$l_i_Target = UAI_GetAgentLowest(-2, $a_f_AggroRange, $GC_UAI_AGENT_HP, "UAI_Filter_IsLivingAlly")
	If $l_i_Target <> 0 And UAI_GetAgentInfoByID($l_i_Target, $GC_UAI_AGENT_HP) < 0.8 Then Return $l_i_Target
	Return $l_i_Target
EndFunc
Func CanUse_LyssasBalance()
	If Anti_Spell() Then Return False
	Return True
EndFunc
Func BestTarget_LyssasBalance($a_f_AggroRange)
	Return UAI_GetPlayerInfo($GC_UAI_AGENT_ID)
EndFunc
Func CanUse_SearingFlames1()
	If Anti_Spell() Then Return False
	Return True
EndFunc
Func BestTarget_SearingFlames1($a_f_AggroRange)
	Return UAI_GetBestAOETarget(-2, $a_f_AggroRange, $GC_I_RANGE_ADJACENT, "UAI_Filter_IsLivingEnemy")
EndFunc
Func CanUse_OathOfHealing()
	If Anti_Spell() Then Return False
	Return True
EndFunc
Func BestTarget_OathOfHealing($a_f_AggroRange)
	Return UAI_GetPlayerInfo($GC_UAI_AGENT_ID)
EndFunc
Func CanUse_BloodOfTheAggressor()
	If Anti_Spell() Then Return False
	Return True
EndFunc
Func BestTarget_BloodOfTheAggressor($a_f_AggroRange)
	Return UAI_GetNearestAgent(-2, $a_f_AggroRange, "UAI_Filter_IsLivingEnemy")
EndFunc
Func CanUse_IcyPrism()
	If Anti_Spell() Then Return False
	Return True
EndFunc
Func BestTarget_IcyPrism($a_f_AggroRange)
	Return UAI_GetNearestAgent(-2, $a_f_AggroRange, "UAI_Filter_IsLivingEnemy")
EndFunc
Func CanUse_SpiritRift()
	If Anti_Spell() Then Return False
	Return True
EndFunc
Func BestTarget_SpiritRift($a_f_AggroRange)
	Return UAI_GetNearestAgent(-2, $a_f_AggroRange, "UAI_Filter_IsLivingEnemy")
EndFunc
Func CanUse_ConsumeSoul()
	If Anti_Spell() Then Return False
	Return True
EndFunc
Func BestTarget_ConsumeSoul($a_f_AggroRange)
	Return UAI_GetNearestAgent(-2, $a_f_AggroRange, "UAI_Filter_IsLivingEnemy")
EndFunc
Func CanUse_SpiritLight()
	If Anti_Spell() Then Return False
	Local $l_i_SpiritCount = UAI_CountAgents(-2, $GC_I_RANGE_EARSHOT, "UAI_Filter_IsSpirit")
	Local $l_i_HP = UAI_GetPlayerInfo($GC_UAI_AGENT_HP)
	If $l_i_SpiritCount <= 0 And $l_i_HP < 0.85 Then Return False
	Return True
EndFunc
Func BestTarget_SpiritLight($a_f_AggroRange)
	Local $l_i_Target = UAI_GetAgentLowest(-2, $a_f_AggroRange, $GC_UAI_AGENT_HP, "UAI_Filter_IsLivingAlly")
	If $l_i_Target <> 0 And UAI_GetAgentInfoByID($l_i_Target, $GC_UAI_AGENT_HP) < 0.85 Then Return $l_i_Target
EndFunc
Func CanUse_RuptureSoul()
	If Anti_Spell() Then Return False
	Return True
EndFunc
Func BestTarget_RuptureSoul($a_f_AggroRange)
	Return UAI_GetNearestAgent(-2, $a_f_AggroRange, "UAI_Filter_IsSpirit")
EndFunc
Func CanUse_SpiritToFlesh()
	If Anti_Spell() Then Return False
	Return True
EndFunc
Func BestTarget_SpiritToFlesh($a_f_AggroRange)
	Return UAI_GetAgentLowest(-2, $a_f_AggroRange, $GC_UAI_AGENT_HP, "UAI_Filter_IsLivingAlly|UAI_Filter_ExcludeMe")
EndFunc
Func CanUse_SpiritBurn()
	If Anti_Spell() Then Return False
	Return True
EndFunc
Func BestTarget_SpiritBurn($a_f_AggroRange)
	Return UAI_GetBestSingleTarget(-2, $a_f_AggroRange, $GC_UAI_AGENT_HP, "UAI_Filter_IsLivingEnemy")
EndFunc
Func CanUse_PowerReturn()
	If Anti_Spell() Then Return False
	Return True
EndFunc
Func BestTarget_PowerReturn($a_f_AggroRange)
	Return UAI_GetNearestAgent(-2, $a_f_AggroRange, "UAI_Filter_IsLivingEnemy|UAI_Filter_IsCasting")
EndFunc
Func CanUse_Complicate()
	If Anti_Spell() Then Return False
	Return True
EndFunc
Func BestTarget_Complicate($a_f_AggroRange)
	Return UAI_GetBestAOETarget(-2, $a_f_AggroRange, $GC_I_RANGE_NEARBY, "UAI_Filter_IsLivingEnemy")
EndFunc
Func CanUse_ShatterStorm()
	If Anti_Spell() Then Return False
	Return True
EndFunc
Func BestTarget_ShatterStorm($a_f_AggroRange)
	Return UAI_GetAgentHighest(-2, $a_f_AggroRange, $GC_UAI_AGENT_HP, "UAI_Filter_IsLivingEnemy|UAI_Filter_IsEnchanted")
EndFunc
Func CanUse_EnvenomEnchantments()
	If Anti_Spell() Then Return False
	Return True
EndFunc
Func BestTarget_EnvenomEnchantments($a_f_AggroRange)
	Return UAI_GetAgentHighest(-2, $a_f_AggroRange, $GC_UAI_AGENT_HP, "UAI_Filter_IsLivingEnemy|UAI_Filter_IsEnchanted")
EndFunc
Func CanUse_Shockwave()
	If Anti_Spell() Then Return False
	Return True
EndFunc
Func BestTarget_Shockwave($a_f_AggroRange)
	Return UAI_GetPlayerInfo($GC_UAI_AGENT_ID)
EndFunc
Func CanUse_CryOfLament()
	If Anti_Spell() Then Return False
	Return True
EndFunc
Func BestTarget_CryOfLament($a_f_AggroRange)
	Return UAI_GetPlayerInfo($GC_UAI_AGENT_ID)
EndFunc
Func CanUse_BlessedLight()
	If Anti_Spell() Then Return False
	Return True
EndFunc
Func BestTarget_BlessedLight($a_f_AggroRange)
	Local $l_i_Target = UAI_GetAgentLowest(-2, $a_f_AggroRange, $GC_UAI_AGENT_HP, "UAI_Filter_IsLivingAlly|UAI_Filter_IsConditioned|UAI_Filter_IsHexed")
	If $l_i_Target <> 0 Then Return $l_i_Target
	$l_i_Target = UAI_GetAgentLowest(-2, $a_f_AggroRange, $GC_UAI_AGENT_HP, "UAI_Filter_IsLivingAlly|UAI_Filter_IsHexed")
	If $l_i_Target <> 0 And UAI_GetAgentInfoByID($l_i_Target, $GC_UAI_AGENT_HP) < 0.9 Then Return $l_i_Target
	$l_i_Target = UAI_GetAgentLowest(-2, $a_f_AggroRange, $GC_UAI_AGENT_HP, "UAI_Filter_IsLivingAlly|UAI_Filter_IsConditioned")
	If $l_i_Target <> 0 And UAI_GetAgentInfoByID($l_i_Target, $GC_UAI_AGENT_HP) < 0.9 Then Return $l_i_Target
	$l_i_Target = UAI_GetAgentLowest(-2, $a_f_AggroRange, $GC_UAI_AGENT_HP, "UAI_Filter_IsLivingAlly")
	If $l_i_Target <> 0 And UAI_GetAgentInfoByID($l_i_Target, $GC_UAI_AGENT_HP) < 0.7 Then Return $l_i_Target
	Return $l_i_Target
EndFunc
Func CanUse_WithdrawHexes()
	If Anti_Spell() Then Return False
	Return True
EndFunc
Func BestTarget_WithdrawHexes($a_f_AggroRange)
	Return UAI_GetNearestAgent(-2, $a_f_AggroRange, "UAI_Filter_IsAlly|UAI_Filter_IsHexed")
EndFunc
Func CanUse_Extinguish()
	If Anti_Spell() Then Return False
	Return True
EndFunc
Func BestTarget_Extinguish($a_f_AggroRange)
	Return UAI_GetPlayerInfo($GC_UAI_AGENT_ID)
EndFunc
Func CanUse_DeathsCharge()
	If Anti_Spell() Then Return False
	Return True
EndFunc
Func BestTarget_DeathsCharge($a_f_AggroRange)
	Return UAI_GetBestAOETarget(-2, $a_f_AggroRange, $GC_I_RANGE_ADJACENT, "UAI_Filter_AgentHasMoreHpThanMe")
EndFunc
Func CanUse_ExpelHexes()
	If Anti_Spell() Then Return False
	Return True
EndFunc
Func BestTarget_ExpelHexes($a_f_AggroRange)
	Return UAI_GetNearestAgent(-2, $a_f_AggroRange, "UAI_Filter_IsAlly|UAI_Filter_IsHexed")
EndFunc
Func CanUse_RipEnchantment()
	If Anti_Spell() Then Return False
	Return True
EndFunc
Func BestTarget_RipEnchantment($a_f_AggroRange)
	Return UAI_GetAgentHighest(-2, $a_f_AggroRange, $GC_UAI_AGENT_HP, "UAI_Filter_IsLivingEnemy|UAI_Filter_IsEnchanted")
EndFunc
Func CanUse_HealingWhisper()
	If Anti_Spell() Then Return False
	Return True
EndFunc
Func BestTarget_HealingWhisper($a_f_AggroRange)
	Return UAI_GetAgentLowest(-2, $a_f_AggroRange, $GC_UAI_AGENT_HP, "UAI_Filter_IsLivingAlly|UAI_Filter_ExcludeMe")
EndFunc
Func CanUse_EtherealLight()
	If Anti_Spell() Then Return False
	Return True
EndFunc
Func BestTarget_EtherealLight($a_f_AggroRange)
	Return UAI_GetAgentLowest(-2, $a_f_AggroRange, $GC_UAI_AGENT_HP, "UAI_Filter_IsLivingAlly")
EndFunc
Func CanUse_ReleaseEnchantments()
	If Anti_Spell() Then Return False
	Return True
EndFunc
Func BestTarget_ReleaseEnchantments($a_f_AggroRange)
	Return UAI_GetPlayerInfo($GC_UAI_AGENT_ID)
EndFunc
Func CanUse_SpiritTransfer()
	If Anti_Spell() Then Return False
	Local $l_i_SpiritCount = UAI_CountAgents(-2, $GC_I_RANGE_EARSHOT, "UAI_Filter_IsSpirit")
	If $l_i_SpiritCount <= 0 Then Return False
	Return True
EndFunc
Func BestTarget_SpiritTransfer($a_f_AggroRange)
	Local $l_i_Target
	$l_i_Target = UAI_GetAgentLowest(-2, $a_f_AggroRange, $GC_UAI_AGENT_HP, "UAI_Filter_IsLivingAlly")
	If $l_i_Target <> 0 And UAI_GetAgentInfoByID($l_i_Target, $GC_UAI_AGENT_HP) < 0.5 Then Return $l_i_Target
	Return $l_i_Target
EndFunc
Func CanUse_ArchemorusStrike()
	If Anti_Spell() Then Return False
	Return True
EndFunc
Func BestTarget_ArchemorusStrike($a_f_AggroRange)
	Return UAI_GetPlayerInfo($GC_UAI_AGENT_ID)
EndFunc
Func CanUse_SpearOfArchemorusLevel1()
	If Anti_Spell() Then Return False
	Return True
EndFunc
Func BestTarget_SpearOfArchemorusLevel1($a_f_AggroRange)
	Return UAI_GetPlayerInfo($GC_UAI_AGENT_ID)
EndFunc
Func CanUse_SpearOfArchemorusLevel2()
	If Anti_Spell() Then Return False
	Return True
EndFunc
Func BestTarget_SpearOfArchemorusLevel2($a_f_AggroRange)
	Return UAI_GetPlayerInfo($GC_UAI_AGENT_ID)
EndFunc
Func CanUse_SpearOfArchemorusLevel3()
	If Anti_Spell() Then Return False
	Return True
EndFunc
Func BestTarget_SpearOfArchemorusLevel3($a_f_AggroRange)
	Return UAI_GetPlayerInfo($GC_UAI_AGENT_ID)
EndFunc
Func CanUse_SpearOfArchemorusLevel4()
	If Anti_Spell() Then Return False
	Return True
EndFunc
Func BestTarget_SpearOfArchemorusLevel4($a_f_AggroRange)
	Return UAI_GetPlayerInfo($GC_UAI_AGENT_ID)
EndFunc
Func CanUse_SpearOfArchemorusLevel5()
	If Anti_Spell() Then Return False
	Return True
EndFunc
Func BestTarget_SpearOfArchemorusLevel5($a_f_AggroRange)
	Return UAI_GetPlayerInfo($GC_UAI_AGENT_ID)
EndFunc
Func CanUse_ArgosCry()
	If Anti_Spell() Then Return False
	Return True
EndFunc
Func BestTarget_ArgosCry($a_f_AggroRange)
	Return UAI_GetPlayerInfo($GC_UAI_AGENT_ID)
EndFunc
Func CanUse_JadeFury()
	If Anti_Spell() Then Return False
	Return True
EndFunc
Func BestTarget_JadeFury($a_f_AggroRange)
	Return UAI_GetPlayerInfo($GC_UAI_AGENT_ID)
EndFunc
Func CanUse_BlindingPowder()
	If Anti_Spell() Then Return False
	Return True
EndFunc
Func BestTarget_BlindingPowder($a_f_AggroRange)
	Return UAI_GetBestAOETarget(-2, $a_f_AggroRange, $GC_I_RANGE_ADJACENT, "UAI_Filter_IsLivingEnemy")
EndFunc
Func CanUse_MantisTouch()
	If Anti_Spell() Then Return False
	Return True
EndFunc
Func BestTarget_MantisTouch($a_f_AggroRange)
	Return UAI_GetNearestAgent(-2, $a_f_AggroRange, "UAI_Filter_IsLivingEnemy")
EndFunc
Func CanUse_FeastOfSouls()
	If Anti_Spell() Then Return False
	Return True
EndFunc
Func BestTarget_FeastOfSouls($a_f_AggroRange)
	Return UAI_GetPlayerInfo($GC_UAI_AGENT_ID)
EndFunc
Func CanUse_Caltrops()
	If Anti_Spell() Then Return False
	Return True
EndFunc
Func BestTarget_Caltrops($a_f_AggroRange)
	Return UAI_GetBestAOETarget(-2, $a_f_AggroRange, $GC_I_RANGE_ADJACENT, "UAI_Filter_IsLivingEnemy")
EndFunc
Func CanUse_DenyHexes()
	If Anti_Spell() Then Return False
	Return True
EndFunc
Func BestTarget_DenyHexes($a_f_AggroRange)
	Return UAI_GetNearestAgent(-2, $a_f_AggroRange, "UAI_Filter_IsAlly|UAI_Filter_IsHexed")
EndFunc
Func CanUse_BlindingSnow()
	If Anti_Spell() Then Return False
	Return True
EndFunc
Func BestTarget_BlindingSnow($a_f_AggroRange)
	Return UAI_GetNearestAgent(-2, $a_f_AggroRange, "UAI_Filter_IsLivingEnemy")
EndFunc
Func CanUse_AvalancheSkill()
	If Anti_Spell() Then Return False
	Return True
EndFunc
Func BestTarget_AvalancheSkill($a_f_AggroRange)
	Return UAI_GetBestAOETarget(-2, $a_f_AggroRange, $GC_I_RANGE_ADJACENT, "UAI_Filter_IsLivingEnemy")
EndFunc
Func CanUse_Snowball()
	If Anti_Spell() Then Return False
	Return True
EndFunc
Func BestTarget_Snowball($a_f_AggroRange)
	Return UAI_GetNearestAgent(-2, $a_f_AggroRange, "UAI_Filter_IsLivingEnemy")
EndFunc
Func CanUse_MegaSnowball()
	If Anti_Spell() Then Return False
	Return True
EndFunc
Func BestTarget_MegaSnowball($a_f_AggroRange)
	Return UAI_GetNearestAgent(-2, $a_f_AggroRange, "UAI_Filter_IsLivingEnemy")
EndFunc
Func CanUse_HolidayBlues()
	If Anti_Spell() Then Return False
	Return True
EndFunc
Func BestTarget_HolidayBlues($a_f_AggroRange)
	Return UAI_GetPlayerInfo($GC_UAI_AGENT_ID)
EndFunc
Func CanUse_FlurryOfIce()
	If Anti_Spell() Then Return False
	Return True
EndFunc
Func BestTarget_FlurryOfIce($a_f_AggroRange)
	Return UAI_GetBestAOETarget(-2, $a_f_AggroRange, $GC_I_RANGE_ADJACENT, "UAI_Filter_IsLivingEnemy")
EndFunc
Func CanUse_SnowballNpc()
	If Anti_Spell() Then Return False
	Return True
EndFunc
Func BestTarget_SnowballNpc($a_f_AggroRange)
	Return UAI_GetNearestAgent(-2, $a_f_AggroRange, "UAI_Filter_IsLivingEnemy")
EndFunc
Func CanUse_HeartOfShadow()
	If Anti_Spell() Then Return False
	If UAI_GetPlayerInfo($GC_UAI_AGENT_HP) > 0.9 Then Return False
	Return True
EndFunc
Func BestTarget_HeartOfShadow($a_f_AggroRange)
	Return UAI_GetPlayerInfo($GC_UAI_AGENT_ID)
EndFunc
Func CanUse_CripplingDagger()
	If Anti_Spell() Then Return False
	Return True
EndFunc
Func BestTarget_CripplingDagger($a_f_AggroRange)
	Return UAI_GetNearestAgent(-2, $a_f_AggroRange, "UAI_Filter_IsLivingEnemy")
EndFunc
Func CanUse_SpiritWalk()
	If Anti_Spell() Then Return False
	Return True
EndFunc
Func BestTarget_SpiritWalk($a_f_AggroRange)
	Return UAI_GetNearestAgent(-2, $a_f_AggroRange, "UAI_Filter_IsSpirit")
EndFunc
Func CanUse_RevealedEnchantment()
	If Anti_Spell() Then Return False
	Return True
EndFunc
Func BestTarget_RevealedEnchantment($a_f_AggroRange)
	Return UAI_GetAgentHighest(-2, $a_f_AggroRange, $GC_UAI_AGENT_HP, "UAI_Filter_IsLivingEnemy|UAI_Filter_IsEnchanted")
EndFunc
Func CanUse_RevealedHex()
	If Anti_Spell() Then Return False
	Return True
EndFunc
Func BestTarget_RevealedHex($a_f_AggroRange)
	Return UAI_GetNearestAgent(-2, $a_f_AggroRange, "UAI_Filter_IsAlly|UAI_Filter_IsHexed")
EndFunc
Func CanUse_AccumulatedPain()
	If Anti_Spell() Then Return False
	Return True
EndFunc
Func BestTarget_AccumulatedPain($a_f_AggroRange)
	Local $l_i_Target = UAI_GetNearestAgent(-2, $a_f_AggroRange, "UAI_Filter_IsLivingEnemy|UAI_Filter_IsHexed")
	If $l_i_Target <> 0 Then
		Local $l_i_HexCount = UAI_CountAgents($l_i_Target, $GC_I_RANGE_ADJACENT, "UAI_Filter_IsHex")
		If $l_i_HexCount >= 2 Then Return $l_i_Target
	EndIf
	Return UAI_GetNearestAgent(-2, $a_f_AggroRange, "UAI_Filter_IsLivingEnemy")
EndFunc
Func CanUse_PsychicDistraction()
	If Anti_Spell() Then Return False
	Return True
EndFunc
Func BestTarget_PsychicDistraction($a_f_AggroRange)
	Return UAI_GetNearestAgent(-2, $a_f_AggroRange, "UAI_Filter_IsLivingEnemy|UAI_Filter_IsCasting")
EndFunc
Func CanUse_PsychicInstability()
	If Anti_Spell() Then Return False
	Return True
EndFunc
Func BestTarget_PsychicInstability($a_f_AggroRange)
	Return UAI_GetNearestAgent(-2, $a_f_AggroRange, "UAI_Filter_IsLivingEnemy|UAI_Filter_IsCasting")
EndFunc
Func CanUse_CelestialHaste()
	If Anti_Spell() Then Return False
	Return True
EndFunc
Func BestTarget_CelestialHaste($a_f_AggroRange)
	Return UAI_GetPlayerInfo($GC_UAI_AGENT_ID)
EndFunc
Func CanUse_Feedback()
	If Anti_Spell() Then Return False
	Return True
EndFunc
Func BestTarget_Feedback($a_f_AggroRange)
	Return UAI_GetNearestAgent(-2, $a_f_AggroRange, "UAI_Filter_IsLivingEnemy|UAI_Filter_IsCasting")
EndFunc
Func CanUse_ArcaneLarceny()
	If Anti_Spell() Then Return False
	Return True
EndFunc
Func BestTarget_ArcaneLarceny($a_f_AggroRange)
	Local $l_i_Target = UAI_GetNearestAgent(-2, $a_f_AggroRange, "UAI_Filter_IsLivingEnemy|UAI_Filter_IsCaster")
	If $l_i_Target <> 0 Then Return $l_i_Target
	Return UAI_GetNearestAgent(-2, $a_f_AggroRange, "UAI_Filter_IsLivingEnemy")
EndFunc
Func CanUse_LifebaneStrike()
	If Anti_Spell() Then Return False
	Return True
EndFunc
Func BestTarget_LifebaneStrike($a_f_AggroRange)
	Return UAI_GetAgentHighest(-2, $a_f_AggroRange, $GC_UAI_AGENT_HP, "UAI_Filter_IsLivingEnemy")
EndFunc
Func CanUse_BitterChill()
	If Anti_Spell() Then Return False
	Return True
EndFunc
Func BestTarget_BitterChill($a_f_AggroRange)
	Return UAI_GetAgentHighest(-2, $a_f_AggroRange, $GC_UAI_AGENT_HP, "UAI_Filter_IsLivingEnemy")
EndFunc
Func CanUse_TasteOfPain()
	If Anti_Spell() Then Return False
	Return True
EndFunc
Func BestTarget_TasteOfPain($a_f_AggroRange)
	Return UAI_GetAgentLowest(-2, $a_f_AggroRange, $GC_UAI_AGENT_HP, "UAI_Filter_IsLivingEnemy")
EndFunc
Func CanUse_DefileEnchantments()
	If Anti_Spell() Then Return False
	Return True
EndFunc
Func BestTarget_DefileEnchantments($a_f_AggroRange)
	Local $l_i_Target = UAI_GetBestAOETarget(-2, $a_f_AggroRange, $GC_I_RANGE_NEARBY, "UAI_Filter_IsLivingEnemy|UAI_Filter_IsEnchanted")
	If $l_i_Target <> 0 Then Return $l_i_Target
	Return UAI_GetBestAOETarget(-2, $a_f_AggroRange, $GC_I_RANGE_NEARBY, "UAI_Filter_IsLivingEnemy")
EndFunc
Func CanUse_VampiricSwarm()
	If Anti_Spell() Then Return False
	Return True
EndFunc
Func BestTarget_VampiricSwarm($a_f_AggroRange)
	Return UAI_GetBestAOETarget(-2, $a_f_AggroRange, $GC_I_RANGE_NEARBY, "UAI_Filter_IsLivingEnemy")
EndFunc
Func CanUse_BloodDrinker()
	If Anti_Spell() Then Return False
	Return True
EndFunc
Func BestTarget_BloodDrinker($a_f_AggroRange)
	Return UAI_GetBestAOETarget(-2, $a_f_AggroRange, $GC_I_RANGE_NEARBY, "UAI_Filter_IsLivingEnemy")
EndFunc
Func CanUse_TeinaisWind()
	If Anti_Spell() Then Return False
	Return True
EndFunc
Func BestTarget_TeinaisWind($a_f_AggroRange)
	Return UAI_GetBestAOETarget(-2, $a_f_AggroRange, $GC_I_RANGE_ADJACENT, "UAI_Filter_IsLivingEnemy")
EndFunc
Func CanUse_ShockArrow()
	If Anti_Spell() Then Return False
	Return True
EndFunc
Func BestTarget_ShockArrow($a_f_AggroRange)
	Local $l_i_Target = UAI_GetNearestAgent(-2, $a_f_AggroRange, "UAI_Filter_IsLivingEnemy|UAI_Filter_IsConditioned")
	If $l_i_Target <> 0 Then Return $l_i_Target
	Return UAI_GetNearestAgent(-2, $a_f_AggroRange, "UAI_Filter_IsLivingEnemy")
EndFunc
Func CanUse_UnsteadyGround()
	If Anti_Spell() Then Return False
	Return True
EndFunc
Func BestTarget_UnsteadyGround($a_f_AggroRange)
	Return UAI_GetBestAOETarget(-2, $a_f_AggroRange, $GC_I_RANGE_ADJACENT, "UAI_Filter_IsLivingEnemy")
EndFunc
Func CanUse_DragonsStomp()
	If Anti_Spell() Then Return False
	Return True
EndFunc
Func BestTarget_DragonsStomp($a_f_AggroRange)
	Return UAI_GetBestAOETarget(-2, $a_f_AggroRange, $GC_I_RANGE_ADJACENT, "UAI_Filter_IsLivingEnemy")
EndFunc
Func CanUse_SecondWind()
	If Anti_Spell() Then Return False
	Return True
EndFunc
Func BestTarget_SecondWind($a_f_AggroRange)
	Return UAI_GetPlayerInfo($GC_UAI_AGENT_ID)
EndFunc
Func CanUse_BreathOfFire()
	If Anti_Spell() Then Return False
	Return True
EndFunc
Func BestTarget_BreathOfFire($a_f_AggroRange)
	Return UAI_GetBestAOETarget(-2, $a_f_AggroRange, $GC_I_RANGE_SPELLCASTING, "UAI_Filter_IsLivingEnemy")
EndFunc
Func CanUse_StarBurst()
	If Anti_Spell() Then Return False
	Return True
EndFunc
Func BestTarget_StarBurst($a_f_AggroRange)
	Return UAI_GetBestAOETarget(-2, $a_f_AggroRange, $GC_I_RANGE_ADJACENT, "UAI_Filter_IsLivingEnemy")
EndFunc
Func CanUse_TeinaisCrystals()
	If Anti_Spell() Then Return False
	Return True
EndFunc
Func BestTarget_TeinaisCrystals($a_f_AggroRange)
	Return UAI_GetBestAOETarget(-2, $a_f_AggroRange, $GC_I_RANGE_ADJACENT, "UAI_Filter_IsLivingEnemy")
EndFunc
Func CanUse_ShieldOfSaintViktor()
	If Anti_Spell() Then Return False
	Return True
EndFunc
Func BestTarget_ShieldOfSaintViktor($a_f_AggroRange)
	Return UAI_GetPlayerInfo($GC_UAI_AGENT_ID)
EndFunc
Func CanUse_UrnOfSaintViktorLevel1()
	If Anti_Spell() Then Return False
	Return True
EndFunc
Func BestTarget_UrnOfSaintViktorLevel1($a_f_AggroRange)
	Return UAI_GetPlayerInfo($GC_UAI_AGENT_ID)
EndFunc
Func CanUse_UrnOfSaintViktorLevel2()
	If Anti_Spell() Then Return False
	Return True
EndFunc
Func BestTarget_UrnOfSaintViktorLevel2($a_f_AggroRange)
	Return UAI_GetPlayerInfo($GC_UAI_AGENT_ID)
EndFunc
Func CanUse_UrnOfSaintViktorLevel3()
	If Anti_Spell() Then Return False
	Return True
EndFunc
Func BestTarget_UrnOfSaintViktorLevel3($a_f_AggroRange)
	Return UAI_GetPlayerInfo($GC_UAI_AGENT_ID)
EndFunc
Func CanUse_UrnOfSaintViktorLevel4()
	If Anti_Spell() Then Return False
	Return True
EndFunc
Func BestTarget_UrnOfSaintViktorLevel4($a_f_AggroRange)
	Return UAI_GetPlayerInfo($GC_UAI_AGENT_ID)
EndFunc
Func CanUse_UrnOfSaintViktorLevel5()
	If Anti_Spell() Then Return False
	Return True
EndFunc
Func BestTarget_UrnOfSaintViktorLevel5($a_f_AggroRange)
	Return UAI_GetPlayerInfo($GC_UAI_AGENT_ID)
EndFunc
Func CanUse_KirinsWrath()
	If Anti_Spell() Then Return False
	Return True
EndFunc
Func BestTarget_KirinsWrath($a_f_AggroRange)
	Return UAI_GetPlayerInfo($GC_UAI_AGENT_ID)
EndFunc
Func CanUse_HeavensDelight()
	If Anti_Spell() Then Return False
	Return True
EndFunc
Func BestTarget_HeavensDelight($a_f_AggroRange)
	Return UAI_GetPlayerInfo($GC_UAI_AGENT_ID)
EndFunc
Func CanUse_HealingBurst()
	If Anti_Spell() Then Return False
	Return True
EndFunc
Func BestTarget_HealingBurst($a_f_AggroRange)
	Return UAI_GetAgentLowest(-2, $a_f_AggroRange, $GC_UAI_AGENT_HP, "UAI_Filter_IsLivingAlly")
EndFunc
Func CanUse_KareisHealingCircle()
	If Anti_Spell() Then Return False
	Return True
EndFunc
Func BestTarget_KareisHealingCircle($a_f_AggroRange)
	Return UAI_GetPlayerInfo($GC_UAI_AGENT_ID)
EndFunc
Func CanUse_JameisGaze()
	If Anti_Spell() Then Return False
	Return True
EndFunc
Func BestTarget_JameisGaze($a_f_AggroRange)
	Return UAI_GetNearestAgent(-2, $a_f_AggroRange, "UAI_Filter_IsLivingEnemy")
EndFunc
Func CanUse_GiftOfHealth()
	If Anti_Spell() Then Return False
	Return True
EndFunc
Func BestTarget_GiftOfHealth($a_f_AggroRange)
	Return UAI_GetAgentLowest(-2, $a_f_AggroRange, $GC_UAI_AGENT_HP, "UAI_Filter_IsLivingAlly|UAI_Filter_ExcludeMe")
EndFunc
Func CanUse_EmpathicRemoval()
	If Anti_Spell() Then Return False
	Return True
EndFunc
Func BestTarget_EmpathicRemoval($a_f_AggroRange)
	Local $l_i_Target = UAI_GetNearestAgent(-2, $a_f_AggroRange, "UAI_Filter_IsAlly|UAI_Filter_IsConditioned|UAI_Filter_ExcludeMe")
	If $l_i_Target <> 0 Then Return $l_i_Target
	Return UAI_GetAgentLowest(-2, $a_f_AggroRange, $GC_UAI_AGENT_HP, "UAI_Filter_IsLivingAlly|UAI_Filter_ExcludeMe")
EndFunc
Func CanUse_ResurrectionChant()
	If Anti_Spell() Then Return False
	If UAI_PlayerHasEffect($GC_I_SKILL_ID_CURSE_OF_DHUUM) Or UAI_PlayerHasEffect($GC_I_SKILL_ID_FROZEN_SOIL) Then Return False
	Return True
EndFunc
Func BestTarget_ResurrectionChant($a_f_AggroRange)
	Return 0
EndFunc
Func CanUse_WordOfCensure()
	If Anti_Spell() Then Return False
	Return True
EndFunc
Func BestTarget_WordOfCensure($a_f_AggroRange)
	Return UAI_GetAgentLowest(-2, $a_f_AggroRange, $GC_UAI_AGENT_HP, "UAI_Filter_IsLivingEnemy")
EndFunc
Func CanUse_SpearOfLight()
	If Anti_Spell() Then Return False
	Return True
EndFunc
Func BestTarget_SpearOfLight($a_f_AggroRange)
	Local $l_i_Target = UAI_GetNearestAgent(-2, $a_f_AggroRange, "UAI_Filter_IsLivingEnemy|UAI_Filter_IsAttacking")
	If $l_i_Target <> 0 Then Return $l_i_Target
	Return UAI_GetNearestAgent(-2, $a_f_AggroRange, "UAI_Filter_IsLivingEnemy")
EndFunc
Func CanUse_CathedralCollapse2()
	If Anti_Spell() Then Return False
	Return True
EndFunc
Func BestTarget_CathedralCollapse2($a_f_AggroRange)
	Return UAI_GetPlayerInfo($GC_UAI_AGENT_ID)
EndFunc
Func CanUse_BloodOfZuHeltzer()
	If Anti_Spell() Then Return False
	Return True
EndFunc
Func BestTarget_BloodOfZuHeltzer($a_f_AggroRange)
	Return UAI_GetPlayerInfo($GC_UAI_AGENT_ID)
EndFunc
Func CanUse_CorruptedDragonSpores()
	If Anti_Spell() Then Return False
	Return True
EndFunc
Func BestTarget_CorruptedDragonSpores($a_f_AggroRange)
	Local $l_i_Target = UAI_GetBestAOETarget(-2, $a_f_AggroRange, $GC_I_RANGE_ADJACENT, "UAI_Filter_IsLivingEnemy|UAI_Filter_IsCaster")
	If $l_i_Target <> 0 Then Return $l_i_Target
	Return UAI_GetBestAOETarget(-2, $a_f_AggroRange, $GC_I_RANGE_ADJACENT, "UAI_Filter_IsLivingEnemy")
EndFunc
Func CanUse_CorruptedDragonScales()
	If Anti_Spell() Then Return False
	Return True
EndFunc
Func BestTarget_CorruptedDragonScales($a_f_AggroRange)
	Return UAI_GetBestAOETarget(-2, $a_f_AggroRange, $GC_I_RANGE_ADJACENT, "UAI_Filter_IsLivingEnemy")
EndFunc
Func CanUse_OfRoyalBlood()
	If Anti_Spell() Then Return False
	Return True
EndFunc
Func BestTarget_OfRoyalBlood($a_f_AggroRange)
	Return UAI_GetPlayerInfo($GC_UAI_AGENT_ID)
EndFunc
Func CanUse_PassageToTahnnakai()
	If Anti_Spell() Then Return False
	Return True
EndFunc
Func BestTarget_PassageToTahnnakai($a_f_AggroRange)
	Return UAI_GetPlayerInfo($GC_UAI_AGENT_ID)
EndFunc
Func CanUse_ClamorOfSouls()
	If Anti_Spell() Then Return False
	Return True
EndFunc
Func BestTarget_ClamorOfSouls($a_f_AggroRange)
	Return UAI_GetBestAOETarget(-2, $a_f_AggroRange, $GC_I_RANGE_NEARBY, "UAI_Filter_IsLivingEnemy")
EndFunc
Func CanUse_DrawSpirit()
	If Anti_Spell() Then Return False
	Return True
EndFunc
Func BestTarget_DrawSpirit($a_f_AggroRange)
	Return UAI_GetPlayerInfo($GC_UAI_AGENT_ID)
EndFunc
Func CanUse_ChanneledStrike()
	If Anti_Spell() Then Return False
	Return True
EndFunc
Func BestTarget_ChanneledStrike($a_f_AggroRange)
	Return UAI_GetNearestAgent(-2, $a_f_AggroRange, "UAI_Filter_IsLivingEnemy")
EndFunc
Func CanUse_SpiritBoonStrike()
	If Anti_Spell() Then Return False
	Return True
EndFunc
Func BestTarget_SpiritBoonStrike($a_f_AggroRange)
	Return UAI_GetNearestAgent(-2, $a_f_AggroRange, "UAI_Filter_IsLivingEnemy")
EndFunc
Func CanUse_EssenceStrike()
	If Anti_Spell() Then Return False
	If UAI_GetPlayerInfo($GC_UAI_AGENT_CurrentEnergy) > 20 Then Return False
	Return True
EndFunc
Func BestTarget_EssenceStrike($a_f_AggroRange)
	Return UAI_GetBestSingleTarget(-2, $a_f_AggroRange, $GC_UAI_AGENT_HP, "UAI_Filter_IsLivingEnemy")
EndFunc
Func CanUse_SpiritSiphon()
	If Anti_Spell() Then Return False
	Return True
EndFunc
Func BestTarget_SpiritSiphon($a_f_AggroRange)
	Return UAI_GetPlayerInfo($GC_UAI_AGENT_ID)
EndFunc
Func CanUse_SoothingMemories()
	If Anti_Spell() Then Return False
	Return True
EndFunc
Func BestTarget_SoothingMemories($a_f_AggroRange)
	Return UAI_GetAgentLowest(-2, $a_f_AggroRange, $GC_UAI_AGENT_HP, "UAI_Filter_IsLivingAlly")
EndFunc
Func CanUse_MendBodyAndSoul()
	If Anti_Spell() Then Return False
	Return True
EndFunc
Func BestTarget_MendBodyAndSoul($a_f_AggroRange)
	Local $l_i_SpiritCount = UAI_CountAgents(-2, $GC_I_RANGE_EARSHOT, "UAI_Filter_IsSpirit")
	Local $l_i_TargetConditioned = UAI_GetAgentLowest(-2, $a_f_AggroRange, $GC_UAI_AGENT_HP, "UAI_Filter_IsLivingAlly|UAI_Filter_IsConditioned")
	Local $l_i_TargetLowest = UAI_GetAgentLowest(-2, $a_f_AggroRange, $GC_UAI_AGENT_HP, "UAI_Filter_IsLivingAlly")
	If $l_i_TargetLowest <> 0 Then
		Local $l_f_LowestHP = UAI_GetAgentInfoByID($l_i_TargetLowest, $GC_UAI_AGENT_HP)
		If $l_f_LowestHP >= 0.85 Then
			If $l_i_SpiritCount >= 1 And $l_i_TargetConditioned <> 0 Then Return $l_i_TargetConditioned
			Return 0
		EndIf
		If $l_i_SpiritCount >= 1 And $l_i_TargetConditioned <> 0 And $l_i_TargetConditioned <> $l_i_TargetLowest Then
			Local $l_f_ConditionedHP = UAI_GetAgentInfoByID($l_i_TargetConditioned, $GC_UAI_AGENT_HP)
			Local $l_f_HPDelta = 0.10
			If $l_f_ConditionedHP <= $l_f_LowestHP + $l_f_HPDelta Then Return $l_i_TargetConditioned
		EndIf
		Return $l_i_TargetLowest
	EndIf
EndFunc
Func CanUse_ArchemorusStrikeCelestialSummoning()
	If Anti_Spell() Then Return False
	Return True
EndFunc
Func BestTarget_ArchemorusStrikeCelestialSummoning($a_f_AggroRange)
	Return UAI_GetPlayerInfo($GC_UAI_AGENT_ID)
EndFunc
Func CanUse_ShieldOfSaintViktorCelestialSummoning()
	If Anti_Spell() Then Return False
	Return True
EndFunc
Func BestTarget_ShieldOfSaintViktorCelestialSummoning($a_f_AggroRange)
	Return UAI_GetPlayerInfo($GC_UAI_AGENT_ID)
EndFunc
Func CanUse_GazeFromBeyond()
	If Anti_Spell() Then Return False
	Return True
EndFunc
Func BestTarget_GazeFromBeyond($a_f_AggroRange)
	Return UAI_GetNearestAgent(-2, $a_f_AggroRange, "UAI_Filter_IsLivingEnemy")
EndFunc
Func CanUse_HealingRing()
	If Anti_Spell() Then Return False
	Return True
EndFunc
Func BestTarget_HealingRing($a_f_AggroRange)
	Return UAI_GetPlayerInfo($GC_UAI_AGENT_ID)
EndFunc
Func CanUse_RenewLife()
	If Anti_Spell() Then Return False
	If UAI_PlayerHasEffect($GC_I_SKILL_ID_CURSE_OF_DHUUM) Or UAI_PlayerHasEffect($GC_I_SKILL_ID_FROZEN_SOIL) Then Return False
	Return True
EndFunc
Func BestTarget_RenewLife($a_f_AggroRange)
	Return 0
EndFunc
Func CanUse_Doom()
	If Anti_Spell() Then Return False
	Return True
EndFunc
Func BestTarget_Doom($a_f_AggroRange)
	Return UAI_GetNearestAgent(-2, $a_f_AggroRange, "UAI_Filter_IsLivingEnemy")
EndFunc
Func CanUse_WieldersBoon()
	If Anti_Spell() Then Return False
	Return True
EndFunc
Func BestTarget_WieldersBoon($a_f_AggroRange)
	Return UAI_GetPlayerInfo($GC_UAI_AGENT_ID)
EndFunc
Func CanUse_BattleCry2()
	If Anti_Spell() Then Return False
	Return True
EndFunc
Func BestTarget_BattleCry2($a_f_AggroRange)
	Return UAI_GetPlayerInfo($GC_UAI_AGENT_ID)
EndFunc
Func CanUse_ElementalDefenseZone()
	If Anti_Spell() Then Return False
	Return True
EndFunc
Func BestTarget_ElementalDefenseZone($a_f_AggroRange)
	Return UAI_GetPlayerInfo($GC_UAI_AGENT_ID)
EndFunc
Func CanUse_MeleeDefenseZone()
	If Anti_Spell() Then Return False
	Return True
EndFunc
Func BestTarget_MeleeDefenseZone($a_f_AggroRange)
	Return UAI_GetPlayerInfo($GC_UAI_AGENT_ID)
EndFunc
Func CanUse_TurretArrow()
	If Anti_Spell() Then Return False
	Return True
EndFunc
Func BestTarget_TurretArrow($a_f_AggroRange)
	Return UAI_GetPlayerInfo($GC_UAI_AGENT_ID)
EndFunc
Func CanUse_BloodFlowerSkill()
	If Anti_Spell() Then Return False
	Return True
EndFunc
Func BestTarget_BloodFlowerSkill($a_f_AggroRange)
	Return UAI_GetPlayerInfo($GC_UAI_AGENT_ID)
EndFunc
Func CanUse_FireFlowerSkill()
	If Anti_Spell() Then Return False
	Return True
EndFunc
Func BestTarget_FireFlowerSkill($a_f_AggroRange)
	Return UAI_GetPlayerInfo($GC_UAI_AGENT_ID)
EndFunc
Func CanUse_PoisonArrowFlower()
	If Anti_Spell() Then Return False
	Return True
EndFunc
Func BestTarget_PoisonArrowFlower($a_f_AggroRange)
	Return UAI_GetPlayerInfo($GC_UAI_AGENT_ID)
EndFunc
Func CanUse_ShieldingUrnSkill()
	If Anti_Spell() Then Return False
	Return True
EndFunc
Func BestTarget_ShieldingUrnSkill($a_f_AggroRange)
	Return UAI_GetPlayerInfo($GC_UAI_AGENT_ID)
EndFunc
Func CanUse_FireballObelisk()
	If Anti_Spell() Then Return False
	Return True
EndFunc
Func BestTarget_FireballObelisk($a_f_AggroRange)
	Return UAI_GetPlayerInfo($GC_UAI_AGENT_ID)
EndFunc
Func CanUse_ExtendConditions()
	If Anti_Spell() Then Return False
	Return True
EndFunc
Func BestTarget_ExtendConditions($a_f_AggroRange)
	Local $l_i_Target = UAI_GetBestAOETarget(-2, $a_f_AggroRange, $GC_I_RANGE_ADJACENT, "UAI_Filter_IsLivingEnemy|UAI_Filter_IsConditioned")
	If $l_i_Target <> 0 Then Return $l_i_Target
	Return UAI_GetBestAOETarget(-2, $a_f_AggroRange, $GC_I_RANGE_ADJACENT, "UAI_Filter_IsLivingEnemy")
EndFunc
Func CanUse_Hypochondria()
	If Anti_Spell() Then Return False
	Return True
EndFunc
Func BestTarget_Hypochondria($a_f_AggroRange)
	Return UAI_GetBestAOETarget(-2, $a_f_AggroRange, $GC_I_RANGE_ADJACENT, "UAI_Filter_IsLivingEnemy")
EndFunc
Func CanUse_SpiritualPain()
	If Anti_Spell() Then Return False
	Return True
EndFunc
Func BestTarget_SpiritualPain($a_f_AggroRange)
	Local $l_i_BestAgent = 0
	Local $l_i_BestSummonCount = 0
	For $i = 1 To $g_i_AgentCacheCount
		Local $l_i_AgentID = UAI_GetAgentInfo($i, $GC_UAI_AGENT_ID)
		Local $l_f_Distance = UAI_GetAgentInfo($i, $GC_UAI_AGENT_Distance)
		If $l_f_Distance > $a_f_AggroRange Then ContinueLoop
		If Not UAI_Filter_IsLivingEnemy($l_i_AgentID) Then ContinueLoop
		Local $l_i_SpiritCount = UAI_CountAgents($l_i_AgentID, $GC_I_RANGE_AREA, "UAI_Filter_IsLivingEnemy|UAI_Filter_IsSpirit")
		Local $l_i_MinionCount = UAI_CountAgents($l_i_AgentID, $GC_I_RANGE_AREA, "UAI_Filter_IsLivingEnemy|UAI_Filter_IsMinion")
		Local $l_i_SummonCount = $l_i_SpiritCount + $l_i_MinionCount
		If $l_i_SummonCount > $l_i_BestSummonCount Then
			$l_i_BestSummonCount = $l_i_SummonCount
			$l_i_BestAgent = $l_i_AgentID
		EndIf
	Next
	If $l_i_BestAgent <> 0 Then Return $l_i_BestAgent
	Return UAI_GetBestSingleTarget(-2, $a_f_AggroRange, $GC_UAI_AGENT_HP, "UAI_Filter_IsLivingEnemy")
EndFunc
Func CanUse_DrainDelusions()
	If Anti_Spell() Then Return False
	Return True
EndFunc
Func BestTarget_DrainDelusions($a_f_AggroRange)
	Local $l_i_Target = UAI_GetNearestAgent(-2, $a_f_AggroRange, "UAI_Filter_IsLivingEnemy|UAI_Filter_IsHexed")
	If $l_i_Target <> 0 Then Return $l_i_Target
	Return UAI_GetNearestAgent(-2, $a_f_AggroRange, "UAI_Filter_IsLivingEnemy")
EndFunc
Func CanUse_Tease()
	If Anti_Spell() Then Return False
	Return True
EndFunc
Func BestTarget_Tease($a_f_AggroRange)
	Return UAI_GetNearestAgent(-2, $a_f_AggroRange, "UAI_Filter_IsLivingEnemy|UAI_Filter_IsCasting")
EndFunc
Func CanUse_DischargeEnchantment()
	If Anti_Spell() Then Return False
	Return True
EndFunc
Func BestTarget_DischargeEnchantment($a_f_AggroRange)
	Local $l_i_Target = UAI_GetAgentHighest(-2, $a_f_AggroRange, $GC_UAI_AGENT_HP, "UAI_Filter_IsLivingEnemy|UAI_Filter_IsEnchanted")
	If $l_i_Target <> 0 Then Return $l_i_Target
	Return UAI_GetAgentHighest(-2, $a_f_AggroRange, $GC_UAI_AGENT_HP, "UAI_Filter_IsLivingEnemy")
EndFunc
Func CanUse_HexEaterVortex()
	If Anti_Spell() Then Return False
	Return True
EndFunc
Func BestTarget_HexEaterVortex($a_f_AggroRange)
	Return UAI_GetNearestAgent(-2, $a_f_AggroRange, "UAI_Filter_IsAlly|UAI_Filter_IsHexed")
EndFunc
Func CanUse_MirrorOfDisenchantment()
	If Anti_Spell() Then Return False
	Return True
EndFunc
Func BestTarget_MirrorOfDisenchantment($a_f_AggroRange)
	Local $l_i_Target = UAI_GetAgentHighest(-2, $a_f_AggroRange, $GC_UAI_AGENT_HP, "UAI_Filter_IsLivingEnemy|UAI_Filter_IsEnchanted")
	If $l_i_Target <> 0 Then Return $l_i_Target
	Return UAI_GetAgentHighest(-2, $a_f_AggroRange, $GC_UAI_AGENT_HP, "UAI_Filter_IsLivingEnemy")
EndFunc
Func CanUse_SimpleThievery()
	If Anti_Spell() Then Return False
	Return True
EndFunc
Func BestTarget_SimpleThievery($a_f_AggroRange)
	Return UAI_GetNearestAgent(-2, $a_f_AggroRange, "UAI_Filter_IsLivingEnemy|UAI_Filter_IsCasting")
EndFunc
Func CanUse_AnimateShamblingHorror()
	If Anti_Spell() Then Return False
	Return True
EndFunc
Func BestTarget_AnimateShamblingHorror($a_f_AggroRange)
	Return UAI_GetPlayerInfo($GC_UAI_AGENT_ID)
EndFunc
Func CanUse_OrderOfUndeath()
	If Anti_Spell() Then Return False
	Return True
EndFunc
Func BestTarget_OrderOfUndeath($a_f_AggroRange)
	Return UAI_GetPlayerInfo($GC_UAI_AGENT_ID)
EndFunc
Func CanUse_PutridFlesh()
	If Anti_Spell() Then Return False
	Return True
EndFunc
Func BestTarget_PutridFlesh($a_f_AggroRange)
	Return UAI_GetBestAOETarget(-2, $a_f_AggroRange, $GC_I_RANGE_ADJACENT, "UAI_Filter_IsLivingEnemy")
EndFunc
Func CanUse_FeastForTheDead()
	If Anti_Spell() Then Return False
	Return True
EndFunc
Func BestTarget_FeastForTheDead($a_f_AggroRange)
	Return UAI_GetPlayerInfo($GC_UAI_AGENT_ID)
EndFunc
Func CanUse_PainOfDisenchantment()
	If Anti_Spell() Then Return False
	Return True
EndFunc
Func BestTarget_PainOfDisenchantment($a_f_AggroRange)
	Local $l_i_Target = UAI_GetBestAOETarget(-2, $a_f_AggroRange, $GC_I_RANGE_ADJACENT, "UAI_Filter_IsLivingEnemy|UAI_Filter_IsEnchanted")
	If $l_i_Target <> 0 Then Return $l_i_Target
	Return UAI_GetBestAOETarget(-2, $a_f_AggroRange, $GC_I_RANGE_ADJACENT, "UAI_Filter_IsLivingEnemy")
EndFunc
Func CanUse_BlindingSurge()
	If Anti_Spell() Then Return False
	Return True
EndFunc
Func BestTarget_BlindingSurge($a_f_AggroRange)
	Return UAI_GetBestAOETarget(-2, $a_f_AggroRange, $GC_I_RANGE_ADJACENT, "UAI_Filter_IsLivingEnemy")
EndFunc
Func CanUse_LightningBolt()
	If Anti_Spell() Then Return False
	Return True
EndFunc
Func BestTarget_LightningBolt($a_f_AggroRange)
	Return UAI_GetNearestAgent(-2, $a_f_AggroRange, "UAI_Filter_IsLivingEnemy")
EndFunc
Func CanUse_Sandstorm()
	If Anti_Spell() Then Return False
	Return True
EndFunc
Func BestTarget_Sandstorm($a_f_AggroRange)
	Return UAI_GetBestAOETarget(-2, $a_f_AggroRange, $GC_I_RANGE_ADJACENT, "UAI_Filter_IsLivingEnemy")
EndFunc
Func CanUse_EbonHawk()
	If Anti_Spell() Then Return False
	Return True
EndFunc
Func BestTarget_EbonHawk($a_f_AggroRange)
	Return UAI_GetNearestAgent(-2, $a_f_AggroRange, "UAI_Filter_IsLivingEnemy")
EndFunc
Func CanUse_GlowingGaze1()
	If Anti_Spell() Then Return False
	Return True
EndFunc
Func BestTarget_GlowingGaze1($a_f_AggroRange)
	Return UAI_GetNearestAgent(-2, $a_f_AggroRange, "UAI_Filter_IsLivingEnemy")
EndFunc
Func CanUse_SavannahHeat()
	If Anti_Spell() Then Return False
	Return True
EndFunc
Func BestTarget_SavannahHeat($a_f_AggroRange)
	Return UAI_GetBestAOETarget(-2, $a_f_AggroRange, $GC_I_RANGE_SPELLCASTING, "UAI_Filter_IsLivingEnemy")
EndFunc
Func CanUse_WordsOfComfort()
	If Anti_Spell() Then Return False
	Return True
EndFunc
Func BestTarget_WordsOfComfort($a_f_AggroRange)
	Local $l_i_Target = UAI_GetAgentLowest(-2, $a_f_AggroRange, $GC_UAI_AGENT_HP, "UAI_Filter_IsLivingAlly|UAI_Filter_IsConditioned")
	If $l_i_Target <> 0 Then Return $l_i_Target
	Return UAI_GetAgentLowest(-2, $a_f_AggroRange, $GC_UAI_AGENT_HP, "UAI_Filter_IsLivingAlly")
EndFunc
Func CanUse_LightOfDeliverance()
	If Anti_Spell() Then Return False
	Return True
EndFunc
Func BestTarget_LightOfDeliverance($a_f_AggroRange)
	Return UAI_GetPlayerInfo($GC_UAI_AGENT_ID)
EndFunc
Func CanUse_MendingTouch()
	If Anti_Spell() Then Return False
	Return True
EndFunc
Func BestTarget_MendingTouch($a_f_AggroRange)
	Local $l_i_Target = UAI_GetNearestAgent(-2, $a_f_AggroRange, "UAI_Filter_IsAlly|UAI_Filter_IsConditioned")
	If $l_i_Target <> 0 Then Return $l_i_Target
	Return UAI_GetNearestAgent(-2, $a_f_AggroRange, "UAI_Filter_IsAlly")
EndFunc
Func CanUse_StopPump()
	If Anti_Spell() Then Return False
	Return True
EndFunc
Func BestTarget_StopPump($a_f_AggroRange)
	Return UAI_GetPlayerInfo($GC_UAI_AGENT_ID)
EndFunc
Func CanUse_WaveOfTorment()
	If Anti_Spell() Then Return False
	Return True
EndFunc
Func BestTarget_WaveOfTorment($a_f_AggroRange)
	Return UAI_GetPlayerInfo($GC_UAI_AGENT_ID)
EndFunc
Func CanUse_CorruptedHealing()
	If Anti_Spell() Then Return False
	Return True
EndFunc
Func BestTarget_CorruptedHealing($a_f_AggroRange)
	Return UAI_GetPlayerInfo($GC_UAI_AGENT_ID)
EndFunc
Func CanUse_SummonTorment()
	If Anti_Spell() Then Return False
	Return True
EndFunc
Func BestTarget_SummonTorment($a_f_AggroRange)
	Return UAI_GetPlayerInfo($GC_UAI_AGENT_ID)
EndFunc
Func CanUse_OfferingOfSpirit()
	If Anti_Spell() Then Return False
	Return True
EndFunc
Func BestTarget_OfferingOfSpirit($a_f_AggroRange)
	Return UAI_GetPlayerInfo($GC_UAI_AGENT_ID)
EndFunc
Func CanUse_ReclaimEssence()
	If Anti_Spell() Then Return False
	Return True
EndFunc
Func BestTarget_ReclaimEssence($a_f_AggroRange)
	Return UAI_GetPlayerInfo($GC_UAI_AGENT_ID)
EndFunc
Func CanUse_MysticTwister()
	If Anti_Spell() Then Return False
	Return True
EndFunc
Func BestTarget_MysticTwister($a_f_AggroRange)
	Return UAI_GetPlayerInfo($GC_UAI_AGENT_ID)
EndFunc
Func CanUse_NaturalHealing()
	If Anti_Spell() Then Return False
	Return True
EndFunc
Func BestTarget_NaturalHealing($a_f_AggroRange)
	Return UAI_GetPlayerInfo($GC_UAI_AGENT_ID)
EndFunc
Func CanUse_ImbueHealth()
	If Anti_Spell() Then Return False
	Local $l_i_HP = UAI_GetPlayerInfo($GC_UAI_AGENT_HP)
	If $l_i_HP < 0.6 Then Return False
	Return True
EndFunc
Func BestTarget_ImbueHealth($a_f_AggroRange)
	Local $l_i_Target = UAI_GetAgentLowest(-2, $a_f_AggroRange, $GC_UAI_AGENT_HP, "UAI_Filter_IsLivingAlly|UAI_Filter_ExcludeMe")
	If $l_i_Target <> 0 And UAI_GetAgentInfoByID($l_i_Target, $GC_UAI_AGENT_HP) < 0.7 Then Return $l_i_Target
EndFunc
Func CanUse_MysticHealing()
	If Anti_Spell() Then Return False
	Return True
EndFunc
Func BestTarget_MysticHealing($a_f_AggroRange)
	Return UAI_GetPlayerInfo($GC_UAI_AGENT_ID)
EndFunc
Func CanUse_DwaynasTouch()
	If Anti_Spell() Then Return False
	Return True
EndFunc
Func BestTarget_DwaynasTouch($a_f_AggroRange)
	Return UAI_GetAgentLowest(-2, $a_f_AggroRange, $GC_UAI_AGENT_HP, "UAI_Filter_IsLivingAlly|UAI_Filter_ExcludeMe")
EndFunc
Func CanUse_PiousRestoration()
	If Anti_Spell() Then Return False
	Return True
EndFunc
Func BestTarget_PiousRestoration($a_f_AggroRange)
	Return UAI_GetPlayerInfo($GC_UAI_AGENT_ID)
EndFunc
Func CanUse_MysticSandstorm()
	If Anti_Spell() Then Return False
	Return True
EndFunc
Func BestTarget_MysticSandstorm($a_f_AggroRange)
	Return UAI_GetPlayerInfo($GC_UAI_AGENT_ID)
EndFunc
Func CanUse_WindsOfDisenchantment()
	If Anti_Spell() Then Return False
	Return True
EndFunc
Func BestTarget_WindsOfDisenchantment($a_f_AggroRange)
	Return UAI_GetPlayerInfo($GC_UAI_AGENT_ID)
EndFunc
Func CanUse_RendingTouch()
	If Anti_Spell() Then Return False
	Return True
EndFunc
Func BestTarget_RendingTouch($a_f_AggroRange)
	Return UAI_GetNearestAgent(-2, $a_f_AggroRange, "UAI_Filter_IsLivingEnemy")
EndFunc
Func CanUse_TestOfFaith()
	If Anti_Spell() Then Return False
	Return True
EndFunc
Func BestTarget_TestOfFaith($a_f_AggroRange)
	Local $l_i_Target = UAI_GetNearestAgent(-2, $a_f_AggroRange, "UAI_Filter_IsLivingEnemy|UAI_Filter_IsEnchanted")
	If $l_i_Target <> 0 Then Return $l_i_Target
	Return UAI_GetNearestAgent(-2, $a_f_AggroRange, "UAI_Filter_IsLivingEnemy")
EndFunc
Func CanUse_SummoningOfTheScepter()
	If Anti_Spell() Then Return False
	Return True
EndFunc
Func BestTarget_SummoningOfTheScepter($a_f_AggroRange)
	Return UAI_GetPlayerInfo($GC_UAI_AGENT_ID)
EndFunc
Func CanUse_RiseFromYourGrave()
	If Anti_Spell() Then Return False
	Return True
EndFunc
Func BestTarget_RiseFromYourGrave($a_f_AggroRange)
	Return UAI_GetPlayerInfo($GC_UAI_AGENT_ID)
EndFunc
Func CanUse_DeathsRetreat()
	If Anti_Spell() Then Return False
	Return True
EndFunc
Func BestTarget_DeathsRetreat($a_f_AggroRange)
	Return UAI_GetPlayerInfo($GC_UAI_AGENT_ID)
EndFunc
Func CanUse_Swap()
	If Anti_Spell() Then Return False
	Return True
EndFunc
Func BestTarget_Swap($a_f_AggroRange)
	Return UAI_GetPlayerInfo($GC_UAI_AGENT_ID)
EndFunc
Func CanUse_ToxicChill()
	If Anti_Spell() Then Return False
	Return True
EndFunc
Func BestTarget_ToxicChill($a_f_AggroRange)
	Local $l_i_Target = UAI_GetNearestAgent(-2, $a_f_AggroRange, "UAI_Filter_IsLivingEnemy|UAI_Filter_IsHexed")
	If $l_i_Target <> 0 Then Return $l_i_Target
	$l_i_Target = UAI_GetNearestAgent(-2, $a_f_AggroRange, "UAI_Filter_IsLivingEnemy|UAI_Filter_IsEnchanted")
	If $l_i_Target <> 0 Then Return $l_i_Target
	Return UAI_GetNearestAgent(-2, $a_f_AggroRange, "UAI_Filter_IsLivingEnemy")
EndFunc
Func CanUse_Glowstone()
	If Anti_Spell() Then Return False
	Return True
EndFunc
Func BestTarget_Glowstone($a_f_AggroRange)
	Local $l_i_Target = UAI_GetNearestAgent(-2, $a_f_AggroRange, "UAI_Filter_IsLivingEnemy|UAI_Filter_IsConditioned")
	If $l_i_Target <> 0 Then Return $l_i_Target
	Return UAI_GetNearestAgent(-2, $a_f_AggroRange, "UAI_Filter_IsLivingEnemy")
EndFunc
Func CanUse_MindBlast()
	If Anti_Spell() Then Return False
	Return True
EndFunc
Func BestTarget_MindBlast($a_f_AggroRange)
	Return UAI_GetNearestAgent(-2, $a_f_AggroRange, "UAI_Filter_IsLivingEnemy")
EndFunc
Func CanUse_InvokeLightning()
	If Anti_Spell() Then Return False
	Return True
EndFunc
Func BestTarget_InvokeLightning($a_f_AggroRange)
	Return UAI_GetBestAOETarget(-2, $a_f_AggroRange, $GC_I_RANGE_ADJACENT, "UAI_Filter_IsLivingEnemy")
EndFunc
Func CanUse_BattleCry1()
	If Anti_Spell() Then Return False
	Return True
EndFunc
Func BestTarget_BattleCry1($a_f_AggroRange)
	Return UAI_GetPlayerInfo($GC_UAI_AGENT_ID)
EndFunc
Func CanUse_MendingShrineBonus()
	If Anti_Spell() Then Return False
	Return True
EndFunc
Func BestTarget_MendingShrineBonus($a_f_AggroRange)
	Return UAI_GetPlayerInfo($GC_UAI_AGENT_ID)
EndFunc
Func CanUse_EnergyShrineBonus()
	If Anti_Spell() Then Return False
	Return True
EndFunc
Func BestTarget_EnergyShrineBonus($a_f_AggroRange)
	Return UAI_GetPlayerInfo($GC_UAI_AGENT_ID)
EndFunc
Func CanUse_NorthernHealthShrineBonus()
	If Anti_Spell() Then Return False
	Return True
EndFunc
Func BestTarget_NorthernHealthShrineBonus($a_f_AggroRange)
	Return UAI_GetPlayerInfo($GC_UAI_AGENT_ID)
EndFunc
Func CanUse_SouthernHealthShrineBonus()
	If Anti_Spell() Then Return False
	Return True
EndFunc
Func BestTarget_SouthernHealthShrineBonus($a_f_AggroRange)
	Return UAI_GetPlayerInfo($GC_UAI_AGENT_ID)
EndFunc
Func CanUse_ToThePainHeroBattles()
	If Anti_Spell() Then Return False
	Return True
EndFunc
Func BestTarget_ToThePainHeroBattles($a_f_AggroRange)
	Return UAI_GetPlayerInfo($GC_UAI_AGENT_ID)
EndFunc
Func CanUse_GlimmerOfLight()
	If Anti_Spell() Then Return False
	Return True
EndFunc
Func BestTarget_GlimmerOfLight($a_f_AggroRange)
	Return UAI_GetAgentLowest(-2, $a_f_AggroRange, $GC_UAI_AGENT_HP, "UAI_Filter_IsLivingAlly")
EndFunc
Func CanUse_ZealousBenediction()
	If Anti_Spell() Then Return False
	Return True
EndFunc
Func BestTarget_ZealousBenediction($a_f_AggroRange)
	Return UAI_GetAgentLowest(-2, $a_f_AggroRange, $GC_UAI_AGENT_HP, "UAI_Filter_IsLivingAlly")
EndFunc
Func CanUse_DismissCondition()
	If Anti_Spell() Then Return False
	Return True
EndFunc
Func BestTarget_DismissCondition($a_f_AggroRange)
	Local $l_i_Target = UAI_GetNearestAgent(-2, $a_f_AggroRange, "UAI_Filter_IsAlly|UAI_Filter_IsConditioned")
	If $l_i_Target <> 0 Then Return $l_i_Target
	Return UAI_GetAgentLowest(-2, $a_f_AggroRange, $GC_UAI_AGENT_HP, "UAI_Filter_IsLivingAlly")
EndFunc
Func CanUse_DivertHexes()
	If Anti_Spell() Then Return False
	Return True
EndFunc
Func BestTarget_DivertHexes($a_f_AggroRange)
	Local $l_i_Target = UAI_GetNearestAgent(-2, $a_f_AggroRange, "UAI_Filter_IsAlly|UAI_Filter_IsHexed")
	If $l_i_Target <> 0 Then Return $l_i_Target
	Return UAI_GetNearestAgent(-2, $a_f_AggroRange, "UAI_Filter_IsAlly")
EndFunc
Func CanUse_SunspearSiege()
	If Anti_Spell() Then Return False
	Return True
EndFunc
Func BestTarget_SunspearSiege($a_f_AggroRange)
	Return UAI_GetPlayerInfo($GC_UAI_AGENT_ID)
EndFunc
Func CanUse_WieldersStrike()
	If Anti_Spell() Then Return False
	Return True
EndFunc
Func BestTarget_WieldersStrike($a_f_AggroRange)
	Return UAI_GetNearestAgent(-2, $a_f_AggroRange, "UAI_Filter_IsLivingEnemy")
EndFunc
Func CanUse_GhostmirrorLight()
	If Anti_Spell() Then Return False
	Local $l_i_SpiritCount = UAI_CountAgents(-2, $GC_I_RANGE_EARSHOT, "UAI_Filter_IsSpirit")
	If $l_i_SpiritCount <= 0 Then Return False
	Return True
EndFunc
Func BestTarget_GhostmirrorLight($a_f_AggroRange)
	Return UAI_GetAgentLowest(-2, $a_f_AggroRange, $GC_UAI_AGENT_HP, "UAI_Filter_IsLivingAlly|UAI_Filter_ExcludeMe")
EndFunc
Func CanUse_CaretakersCharge()
	If Anti_Spell() Then Return False
	Return True
EndFunc
Func BestTarget_CaretakersCharge($a_f_AggroRange)
	Return UAI_GetNearestAgent(-2, $a_f_AggroRange, "UAI_Filter_IsLivingEnemy")
EndFunc
Func CanUse_AltarBuff()
	If Anti_Spell() Then Return False
	Return True
EndFunc
Func BestTarget_AltarBuff($a_f_AggroRange)
	Return UAI_GetPlayerInfo($GC_UAI_AGENT_ID)
EndFunc
Func CanUse_CapturePoint()
	If Anti_Spell() Then Return False
	Return True
EndFunc
Func BestTarget_CapturePoint($a_f_AggroRange)
	Return UAI_GetPlayerInfo($GC_UAI_AGENT_ID)
EndFunc
Func CanUse_BanishEnchantment()
	If Anti_Spell() Then Return False
	Return True
EndFunc
Func BestTarget_BanishEnchantment($a_f_AggroRange)
	Local $l_i_Target = UAI_GetAgentHighest(-2, $a_f_AggroRange, $GC_UAI_AGENT_HP, "UAI_Filter_IsLivingEnemy|UAI_Filter_IsEnchanted")
	If $l_i_Target <> 0 Then Return $l_i_Target
	Return UAI_GetAgentHighest(-2, $a_f_AggroRange, $GC_UAI_AGENT_HP, "UAI_Filter_IsLivingEnemy")
EndFunc
Func CanUse_UnyieldingAnguish()
	If Anti_Spell() Then Return False
	Return True
EndFunc
Func BestTarget_UnyieldingAnguish($a_f_AggroRange)
	Return UAI_GetPlayerInfo($GC_UAI_AGENT_ID)
EndFunc
Func CanUse_PutridFlames()
	If Anti_Spell() Then Return False
	Return True
EndFunc
Func BestTarget_PutridFlames($a_f_AggroRange)
	Return UAI_GetPlayerInfo($GC_UAI_AGENT_ID)
EndFunc
Func CanUse_FireDart()
	If Anti_Spell() Then Return False
	Return True
EndFunc
Func BestTarget_FireDart($a_f_AggroRange)
	Return UAI_GetPlayerInfo($GC_UAI_AGENT_ID)
EndFunc
Func CanUse_IceDart()
	If Anti_Spell() Then Return False
	Return True
EndFunc
Func BestTarget_IceDart($a_f_AggroRange)
	Return UAI_GetPlayerInfo($GC_UAI_AGENT_ID)
EndFunc
Func CanUse_PoisonDart()
	If Anti_Spell() Then Return False
	Return True
EndFunc
Func BestTarget_PoisonDart($a_f_AggroRange)
	Return UAI_GetPlayerInfo($GC_UAI_AGENT_ID)
EndFunc
Func CanUse_PowerLock()
	If Anti_Spell() Then Return False
	Return True
EndFunc
Func BestTarget_PowerLock($a_f_AggroRange)
	Return UAI_GetNearestAgent(-2, $a_f_AggroRange, "UAI_Filter_IsLivingEnemy|UAI_Filter_IsCasting")
EndFunc
Func CanUse_WasteNotWantNot()
	If Anti_Spell() Then Return False
	Return True
EndFunc
Func BestTarget_WasteNotWantNot($a_f_AggroRange)
	Return UAI_GetNearestAgent(-2, $a_f_AggroRange, "UAI_Filter_IsLivingEnemy")
EndFunc
Func CanUse_CureHex()
	If Anti_Spell() Then Return False
	Return True
EndFunc
Func BestTarget_CureHex($a_f_AggroRange)
	Return UAI_GetAgentLowest(-2, $a_f_AggroRange, $GC_UAI_AGENT_HP, "UAI_Filter_IsLivingAlly|UAI_Filter_IsHexed")
EndFunc
Func CanUse_SmiteCondition()
	If Anti_Spell() Then Return False
	Return True
EndFunc
Func BestTarget_SmiteCondition($a_f_AggroRange)
	Return UAI_GetNearestAgent(-2, $a_f_AggroRange, "UAI_Filter_IsAlly|UAI_Filter_IsConditioned")
EndFunc
Func CanUse_BurningGround()
	If Anti_Spell() Then Return False
	Return True
EndFunc
Func BestTarget_BurningGround($a_f_AggroRange)
	Return UAI_GetPlayerInfo($GC_UAI_AGENT_ID)
EndFunc
Func CanUse_FreezingGround()
	If Anti_Spell() Then Return False
	Return True
EndFunc
Func BestTarget_FreezingGround($a_f_AggroRange)
	Return UAI_GetPlayerInfo($GC_UAI_AGENT_ID)
EndFunc
Func CanUse_PoisonGround()
	If Anti_Spell() Then Return False
	Return True
EndFunc
Func BestTarget_PoisonGround($a_f_AggroRange)
	Return UAI_GetPlayerInfo($GC_UAI_AGENT_ID)
EndFunc
Func CanUse_FireJet()
	If Anti_Spell() Then Return False
	Return True
EndFunc
Func BestTarget_FireJet($a_f_AggroRange)
	Return UAI_GetPlayerInfo($GC_UAI_AGENT_ID)
EndFunc
Func CanUse_PoisonJet()
	If Anti_Spell() Then Return False
	Return True
EndFunc
Func BestTarget_PoisonJet($a_f_AggroRange)
	Return UAI_GetPlayerInfo($GC_UAI_AGENT_ID)
EndFunc
Func CanUse_FireSpout()
	If Anti_Spell() Then Return False
	Return True
EndFunc
Func BestTarget_FireSpout($a_f_AggroRange)
	Return UAI_GetPlayerInfo($GC_UAI_AGENT_ID)
EndFunc
Func CanUse_PoisonSpout()
	If Anti_Spell() Then Return False
	Return True
EndFunc
Func BestTarget_PoisonSpout($a_f_AggroRange)
	Return UAI_GetPlayerInfo($GC_UAI_AGENT_ID)
EndFunc
Func CanUse_SarcophagusSpores()
	If Anti_Spell() Then Return False
	Return True
EndFunc
Func BestTarget_SarcophagusSpores($a_f_AggroRange)
	Return UAI_GetPlayerInfo($GC_UAI_AGENT_ID)
EndFunc
Func CanUse_ExplodingBarrel()
	If Anti_Spell() Then Return False
	Return True
EndFunc
Func BestTarget_ExplodingBarrel($a_f_AggroRange)
	Return UAI_GetPlayerInfo($GC_UAI_AGENT_ID)
EndFunc
Func CanUse_SummonSpiritsLuxon()
	If Anti_Spell() Then Return False
	Local $lSpiritsAt5000 = UAI_CountAgents(-2, 5000, "UAI_Filter_IsControlledSpirit")
	If $lSpiritsAt5000 = 0 Then Return False
	Local $lSpiritsAt1000 = UAI_CountAgents(-2, 1000, "UAI_Filter_IsControlledSpirit")
	Local $lLowestSpirit
	If $lSpiritsAt5000 > 0 And $lSpiritsAt1000 = $lSpiritsAt5000 Then
		$lLowestSpirit = UAI_GetAgentLowest(-2, 1320, $GC_UAI_AGENT_HP, "UAI_Filter_IsControlledSpirit")
		If UAI_GetAgentInfoByID($lLowestSpirit, $GC_UAI_AGENT_HP) < 0.85 Then Return True
		Return False
	EndIf
	Return True
EndFunc
Func BestTarget_SummonSpiritsLuxon($a_f_AggroRange)
	Return UAI_GetPlayerInfo($GC_UAI_AGENT_ID)
EndFunc
Func CanUse_Aneurysm()
	If Anti_Spell() Then Return False
	Return True
EndFunc
Func BestTarget_Aneurysm($a_f_AggroRange)
	Local $l_i_Target = UAI_GetAgentHighest(-2, $a_f_AggroRange, $GC_UAI_AGENT_HP, "UAI_Filter_IsLivingEnemy|UAI_Filter_IsCaster")
	If $l_i_Target <> 0 Then Return $l_i_Target
	Return UAI_GetAgentHighest(-2, $a_f_AggroRange, $GC_UAI_AGENT_HP, "UAI_Filter_IsLivingEnemy")
EndFunc
Func CanUse_FoulFeast()
	If Anti_Spell() Then Return False
	Return True
EndFunc
Func BestTarget_FoulFeast($a_f_AggroRange)
	Return UAI_GetNearestAgent(-2, $a_f_AggroRange, "UAI_Filter_IsAlly|UAI_Filter_IsConditioned")
EndFunc
Func CanUse_ShellShock()
	If Anti_Spell() Then Return False
	Return True
EndFunc
Func BestTarget_ShellShock($a_f_AggroRange)
	Return UAI_GetBestAOETarget(-2, $a_f_AggroRange, $GC_I_RANGE_ADJACENT, "UAI_Filter_IsLivingEnemy")
EndFunc
Func CanUse_HealingRibbon()
	If Anti_Spell() Then Return False
	Return True
EndFunc
Func BestTarget_HealingRibbon($a_f_AggroRange)
	Return UAI_GetAgentLowest(-2, $a_f_AggroRange, $GC_UAI_AGENT_HP, "UAI_Filter_IsLivingAlly")
EndFunc
Func CanUse_DrainMinion()
	If Anti_Spell() Then Return False
	Return True
EndFunc
Func BestTarget_DrainMinion($a_f_AggroRange)
	Return UAI_GetPlayerInfo($GC_UAI_AGENT_ID)
EndFunc
Func CanUse_FleshreaversEscape()
	If Anti_Spell() Then Return False
	Return True
EndFunc
Func BestTarget_FleshreaversEscape($a_f_AggroRange)
	Return UAI_GetPlayerInfo($GC_UAI_AGENT_ID)
EndFunc
Func CanUse_MandragorsCharge()
	If Anti_Spell() Then Return False
	Return True
EndFunc
Func BestTarget_MandragorsCharge($a_f_AggroRange)
	Return UAI_GetNearestAgent(-2, $a_f_AggroRange, "UAI_Filter_IsLivingEnemy")
EndFunc
Func CanUse_RockSlide()
	If Anti_Spell() Then Return False
	Return True
EndFunc
Func BestTarget_RockSlide($a_f_AggroRange)
	Return UAI_GetPlayerInfo($GC_UAI_AGENT_ID)
EndFunc
Func CanUse_AvalancheEffect()
	If Anti_Spell() Then Return False
	Return True
EndFunc
Func BestTarget_AvalancheEffect($a_f_AggroRange)
	Return UAI_GetPlayerInfo($GC_UAI_AGENT_ID)
EndFunc
Func CanUse_CeilingCollapse()
	If Anti_Spell() Then Return False
	Return True
EndFunc
Func BestTarget_CeilingCollapse($a_f_AggroRange)
	Return UAI_GetBestAOETarget(-2, $a_f_AggroRange, $GC_I_RANGE_NEARBY, "UAI_Filter_IsLivingEnemy")
EndFunc
Func CanUse_SummonSpiritsKurzick()
	If Anti_Spell() Then Return False
	Local $lSpiritsAt5000 = UAI_CountAgents(-2, 5000, "UAI_Filter_IsControlledSpirit")
	If $lSpiritsAt5000 = 0 Then Return False
	Local $lSpiritsAt1000 = UAI_CountAgents(-2, 1000, "UAI_Filter_IsControlledSpirit")
	Local $lLowestSpirit
	If $lSpiritsAt5000 > 0 And $lSpiritsAt1000 = $lSpiritsAt5000 Then
		$lLowestSpirit = UAI_GetAgentLowest(-2, 1320, $GC_UAI_AGENT_HP, "UAI_Filter_IsControlledSpirit")
		If UAI_GetAgentInfoByID($lLowestSpirit, $GC_UAI_AGENT_HP) < 0.85 Then Return True
		Return False
	EndIf
	Return True
EndFunc
Func BestTarget_SummonSpiritsKurzick($a_f_AggroRange)
	Return UAI_GetPlayerInfo($GC_UAI_AGENT_ID)
EndFunc
Func CanUse_CryOfPain()
	If Anti_Spell() Then Return False
	Return True
EndFunc
Func BestTarget_CryOfPain($a_f_AggroRange)
	Return UAI_GetNearestAgent(-2, $a_f_AggroRange, "UAI_Filter_IsLivingEnemy|UAI_Filter_IsCasting")
EndFunc
Func CanUse_GolemFireShield()
	If Anti_Spell() Then Return False
	Return True
EndFunc
Func BestTarget_GolemFireShield($a_f_AggroRange)
	Return UAI_GetPlayerInfo($GC_UAI_AGENT_ID)
EndFunc
Func CanUse_DiamondshardGrave()
	If Anti_Spell() Then Return False
	Return True
EndFunc
Func BestTarget_DiamondshardGrave($a_f_AggroRange)
	Return UAI_GetPlayerInfo($GC_UAI_AGENT_ID)
EndFunc
Func CanUse_DiamondshardMist()
	If Anti_Spell() Then Return False
	Return True
EndFunc
Func BestTarget_DiamondshardMist($a_f_AggroRange)
	Return UAI_GetPlayerInfo($GC_UAI_AGENT_ID)
EndFunc
Func CanUse_RavenSwoopAGateTooFar()
	If Anti_Spell() Then Return False
	Return True
EndFunc
Func BestTarget_RavenSwoopAGateTooFar($a_f_AggroRange)
	Return UAI_GetNearestAgent(-2, $a_f_AggroRange, "UAI_Filter_IsLivingEnemy")
EndFunc
Func CanUse_AngorodonsGaze()
	If Anti_Spell() Then Return False
	Return True
EndFunc
Func BestTarget_AngorodonsGaze($a_f_AggroRange)
	Return UAI_GetNearestAgent(-2, $a_f_AggroRange, "UAI_Filter_IsLivingEnemy")
EndFunc
Func CanUse_SlipperyGround()
	If Anti_Spell() Then Return False
	Return True
EndFunc
Func BestTarget_SlipperyGround($a_f_AggroRange)
	Return UAI_GetBestAOETarget(-2, $a_f_AggroRange, $GC_I_RANGE_ADJACENT, "UAI_Filter_IsLivingEnemy")
EndFunc
Func CanUse_GlowingIce()
	If Anti_Spell() Then Return False
	Return True
EndFunc
Func BestTarget_GlowingIce($a_f_AggroRange)
	Local $l_i_Target = UAI_GetNearestAgent(-2, $a_f_AggroRange, "UAI_Filter_IsLivingEnemy|UAI_Filter_IsHexed")
	If $l_i_Target <> 0 Then Return $l_i_Target
	Return UAI_GetNearestAgent(-2, $a_f_AggroRange, "UAI_Filter_IsLivingEnemy")
EndFunc
Func CanUse_EnergyBlast()
	If Anti_Spell() Then Return False
	Return True
EndFunc
Func BestTarget_EnergyBlast($a_f_AggroRange)
	Return UAI_GetNearestAgent(-2, $a_f_AggroRange, "UAI_Filter_IsLivingEnemy")
EndFunc
Func CanUse_MendingGrip()
	If Anti_Spell() Then Return False
	Return True
EndFunc
Func BestTarget_MendingGrip($a_f_AggroRange)
	Return UAI_GetAgentLowest(-2, $a_f_AggroRange, $GC_UAI_AGENT_HP, "UAI_Filter_IsLivingAlly")
EndFunc
Func CanUse_AlkarsAlchemicalAcid()
	If Anti_Spell() Then Return False
	Return True
EndFunc
Func BestTarget_AlkarsAlchemicalAcid($a_f_AggroRange)
	Return UAI_GetNearestAgent(-2, $a_f_AggroRange, "UAI_Filter_IsLivingEnemy")
EndFunc
Func CanUse_LightOfDeldrimor()
	If Anti_Spell() Then Return False
	Return True
EndFunc
Func BestTarget_LightOfDeldrimor($a_f_AggroRange)
	Return UAI_GetPlayerInfo($GC_UAI_AGENT_ID)
EndFunc
Func CanUse_BreathOfTheGreatDwarf()
	If Anti_Spell() Then Return False
	Return True
EndFunc
Func BestTarget_BreathOfTheGreatDwarf($a_f_AggroRange)
	Return UAI_GetPlayerInfo($GC_UAI_AGENT_ID)
EndFunc
Func CanUse_SnowStorm()
	If Anti_Spell() Then Return False
	Return True
EndFunc
Func BestTarget_SnowStorm($a_f_AggroRange)
	Return UAI_GetBestAOETarget(-2, $a_f_AggroRange, $GC_I_RANGE_SPELLCASTING, "UAI_Filter_IsLivingEnemy")
EndFunc
Func CanUse_SummonMursaat()
	If Anti_Spell() Then Return False
	Local $lSpirit = UAI_FindAgentByPlayerNumber(5847, -2, 2500, "UAI_Filter_IsLivingAlly")
	If $lSpirit <> 0 Then
		If UAI_GetAgentInfoByID($lSpirit, $GC_UAI_AGENT_HP) < 0.20 Then Return True
		Return False
	EndIf
	Return True
EndFunc
Func BestTarget_SummonMursaat($a_f_AggroRange)
	Return UAI_GetPlayerInfo($GC_UAI_AGENT_ID)
EndFunc
Func CanUse_SummonRubyDjinn()
	If Anti_Spell() Then Return False
	Local $lSpirit = UAI_FindAgentByPlayerNumber(5848, -2, 2500, "UAI_Filter_IsLivingAlly")
	If $lSpirit <> 0 Then
		If UAI_GetAgentInfoByID($lSpirit, $GC_UAI_AGENT_HP) < 0.20 Then Return True
		Return False
	EndIf
	Return True
EndFunc
Func BestTarget_SummonRubyDjinn($a_f_AggroRange)
	Return UAI_GetPlayerInfo($GC_UAI_AGENT_ID)
EndFunc
Func CanUse_SummonIceImp()
	If Anti_Spell() Then Return False
	Local $lSpirit = UAI_FindAgentByPlayerNumber(5849, -2, 2500, "UAI_Filter_IsLivingAlly")
	If $lSpirit <> 0 Then
		If UAI_GetAgentInfoByID($lSpirit, $GC_UAI_AGENT_HP) < 0.20 Then Return True
		Return False
	EndIf
	Return True
EndFunc
Func BestTarget_SummonIceImp($a_f_AggroRange)
	Return UAI_GetPlayerInfo($GC_UAI_AGENT_ID)
EndFunc
Func CanUse_SummonNagaShaman()
	If Anti_Spell() Then Return False
	Local $lSpirit = UAI_FindAgentByPlayerNumber(5850, -2, 2500, "UAI_Filter_IsLivingAlly")
	If $lSpirit <> 0 Then
		If UAI_GetAgentInfoByID($lSpirit, $GC_UAI_AGENT_HP) < 0.20 Then Return True
		Return False
	EndIf
	Return True
EndFunc
Func BestTarget_SummonNagaShaman($a_f_AggroRange)
	Return UAI_GetPlayerInfo($GC_UAI_AGENT_ID)
EndFunc
Func CanUse_EbonVanguardSniperSupport()
	If Anti_Spell() Then Return False
	Return True
EndFunc
Func BestTarget_EbonVanguardSniperSupport($a_f_AggroRange)
	Return UAI_GetNearestAgent(-2, $a_f_AggroRange, "UAI_Filter_IsLivingEnemy")
EndFunc
Func CanUse_EbonVanguardAssassinSupport()
	If Anti_Spell() Then Return False
	Return True
EndFunc
Func BestTarget_EbonVanguardAssassinSupport($a_f_AggroRange)
	Local $l_i_Target = UAI_GetBestSingleTarget(-2, $a_f_AggroRange, $GC_UAI_AGENT_HP, "UAI_Filter_IsLivingEnemy|UAI_Filter_IsMonk|UAI_Filter_IsHexedOrConditioned")
	If $l_i_Target <> 0 Then Return $l_i_Target
	Local $l_i_Target = UAI_GetBestSingleTarget(-2, $a_f_AggroRange, $GC_UAI_AGENT_HP, "UAI_Filter_IsLivingEnemy|UAI_Filter_IsCaster|UAI_Filter_IsHexedOrConditioned")
	If $l_i_Target <> 0 Then Return $l_i_Target
	Local $l_i_Target = UAI_GetBestSingleTarget(-2, $a_f_AggroRange, $GC_UAI_AGENT_HP, "UAI_Filter_IsLivingEnemy|UAI_Filter_IsMonk")
	If $l_i_Target <> 0 Then Return $l_i_Target
	$l_i_Target = UAI_GetBestSingleTarget(-2, $a_f_AggroRange, $GC_UAI_AGENT_HP, "UAI_Filter_IsLivingEnemy|UAI_Filter_IsCaster")
	If $l_i_Target <> 0 Then Return $l_i_Target
	Return UAI_GetBestSingleTarget(-2, $a_f_AggroRange, $GC_UAI_AGENT_HP, "UAI_Filter_IsLivingEnemy")
EndFunc
Func CanUse_PolymockPowerDrain()
	If Anti_Spell() Then Return False
	Return True
EndFunc
Func BestTarget_PolymockPowerDrain($a_f_AggroRange)
	Return UAI_GetNearestAgent(-2, $a_f_AggroRange, "UAI_Filter_IsLivingEnemy|UAI_Filter_IsCasting")
EndFunc
Func CanUse_PolymockOverload()
	If Anti_Spell() Then Return False
	Return True
EndFunc
Func BestTarget_PolymockOverload($a_f_AggroRange)
	Local $l_i_Target = UAI_GetNearestAgent(-2, $a_f_AggroRange, "UAI_Filter_IsLivingEnemy|UAI_Filter_IsCasting")
	If $l_i_Target <> 0 Then Return $l_i_Target
	Return UAI_GetNearestAgent(-2, $a_f_AggroRange, "UAI_Filter_IsLivingEnemy")
EndFunc
Func CanUse_OrderOfUnholyVigor()
	If Anti_Spell() Then Return False
	Return True
EndFunc
Func BestTarget_OrderOfUnholyVigor($a_f_AggroRange)
	Return UAI_GetPlayerInfo($GC_UAI_AGENT_ID)
EndFunc
Func CanUse_OrderOfTheLich()
	If Anti_Spell() Then Return False
	Return True
EndFunc
Func BestTarget_OrderOfTheLich($a_f_AggroRange)
	Return UAI_GetPlayerInfo($GC_UAI_AGENT_ID)
EndFunc
Func CanUse_MasterOfNecromancy()
	If Anti_Spell() Then Return False
	Return True
EndFunc
Func BestTarget_MasterOfNecromancy($a_f_AggroRange)
	Return UAI_GetPlayerInfo($GC_UAI_AGENT_ID)
EndFunc
Func CanUse_AnimateUndead()
	If Anti_Spell() Then Return False
	Return True
EndFunc
Func BestTarget_AnimateUndead($a_f_AggroRange)
	Return UAI_GetPlayerInfo($GC_UAI_AGENT_ID)
EndFunc
Func CanUse_PolymockDeathlyChill()
	If Anti_Spell() Then Return False
	Return True
EndFunc
Func BestTarget_PolymockDeathlyChill($a_f_AggroRange)
	Return UAI_GetAgentHighest(-2, $a_f_AggroRange, $GC_UAI_AGENT_HP, "UAI_Filter_IsLivingEnemy")
EndFunc
Func CanUse_PolymockRottingFlesh()
	If Anti_Spell() Then Return False
	Return True
EndFunc
Func BestTarget_PolymockRottingFlesh($a_f_AggroRange)
	Return UAI_GetNearestAgent(-2, $a_f_AggroRange, "UAI_Filter_IsLivingEnemy")
EndFunc
Func CanUse_PolymockLightningStrike()
	If Anti_Spell() Then Return False
	Return True
EndFunc
Func BestTarget_PolymockLightningStrike($a_f_AggroRange)
	Return UAI_GetAgentLowest(-2, $a_f_AggroRange, $GC_UAI_AGENT_HP, "UAI_Filter_IsLivingEnemy")
EndFunc
Func CanUse_PolymockLightningOrb()
	If Anti_Spell() Then Return False
	Return True
EndFunc
Func BestTarget_PolymockLightningOrb($a_f_AggroRange)
	Return UAI_GetAgentLowest(-2, $a_f_AggroRange, $GC_UAI_AGENT_HP, "UAI_Filter_IsLivingEnemy")
EndFunc
Func CanUse_PolymockFlare()
	If Anti_Spell() Then Return False
	Return True
EndFunc
Func BestTarget_PolymockFlare($a_f_AggroRange)
	Return UAI_GetNearestAgent(-2, $a_f_AggroRange, "UAI_Filter_IsLivingEnemy")
EndFunc
Func CanUse_PolymockImmolate()
	If Anti_Spell() Then Return False
	Return True
EndFunc
Func BestTarget_PolymockImmolate($a_f_AggroRange)
	Return UAI_GetNearestAgent(-2, $a_f_AggroRange, "UAI_Filter_IsLivingEnemy")
EndFunc
Func CanUse_PolymockMeteor()
	If Anti_Spell() Then Return False
	Return True
EndFunc
Func BestTarget_PolymockMeteor($a_f_AggroRange)
	Local $l_i_Target = UAI_GetNearestAgent(-2, $a_f_AggroRange, "UAI_Filter_IsLivingEnemy|UAI_Filter_IsCasting")
	If $l_i_Target <> 0 Then Return $l_i_Target
	Return UAI_GetAgentLowest(-2, $a_f_AggroRange, $GC_UAI_AGENT_HP, "UAI_Filter_IsLivingEnemy")
EndFunc
Func CanUse_PolymockIceSpear()
	If Anti_Spell() Then Return False
	Return True
EndFunc
Func BestTarget_PolymockIceSpear($a_f_AggroRange)
	Return UAI_GetNearestAgent(-2, $a_f_AggroRange, "UAI_Filter_IsLivingEnemy")
EndFunc
Func CanUse_PolymockIcyPrison()
	If Anti_Spell() Then Return False
	Return True
EndFunc
Func BestTarget_PolymockIcyPrison($a_f_AggroRange)
	Return UAI_GetNearestAgent(-2, $a_f_AggroRange, "UAI_Filter_IsLivingEnemy|UAI_Filter_IsCasting")
EndFunc
Func CanUse_PolymockMindFreeze()
	If Anti_Spell() Then Return False
	Return True
EndFunc
Func BestTarget_PolymockMindFreeze($a_f_AggroRange)
	Return UAI_GetNearestAgent(-2, $a_f_AggroRange, "UAI_Filter_IsLivingEnemy")
EndFunc
Func CanUse_PolymockIceShardStorm()
	If Anti_Spell() Then Return False
	Return True
EndFunc
Func BestTarget_PolymockIceShardStorm($a_f_AggroRange)
	Return UAI_GetNearestAgent(-2, $a_f_AggroRange, "UAI_Filter_IsLivingEnemy")
EndFunc
Func CanUse_PolymockFrozenTrident()
	If Anti_Spell() Then Return False
	Return True
EndFunc
Func BestTarget_PolymockFrozenTrident($a_f_AggroRange)
	Local $l_i_Target = UAI_GetNearestAgent(-2, $a_f_AggroRange, "UAI_Filter_IsLivingEnemy|UAI_Filter_IsCasting")
	If $l_i_Target <> 0 Then Return $l_i_Target
	Return UAI_GetNearestAgent(-2, $a_f_AggroRange, "UAI_Filter_IsLivingEnemy")
EndFunc
Func CanUse_PolymockSmite()
	If Anti_Spell() Then Return False
	Return True
EndFunc
Func BestTarget_PolymockSmite($a_f_AggroRange)
	Return UAI_GetNearestAgent(-2, $a_f_AggroRange, "UAI_Filter_IsLivingEnemy")
EndFunc
Func CanUse_PolymockSmiteHex()
	If Anti_Spell() Then Return False
	Return True
EndFunc
Func BestTarget_PolymockSmiteHex($a_f_AggroRange)
	Return UAI_GetNearestAgent(-2, $a_f_AggroRange, "UAI_Filter_IsLivingEnemy")
EndFunc
Func CanUse_PolymockStoneDaggers()
	If Anti_Spell() Then Return False
	Return True
EndFunc
Func BestTarget_PolymockStoneDaggers($a_f_AggroRange)
	Return UAI_GetNearestAgent(-2, $a_f_AggroRange, "UAI_Filter_IsLivingEnemy")
EndFunc
Func CanUse_PolymockObsidianFlame()
	If Anti_Spell() Then Return False
	Return True
EndFunc
Func BestTarget_PolymockObsidianFlame($a_f_AggroRange)
	Return UAI_GetNearestAgent(-2, $a_f_AggroRange, "UAI_Filter_IsLivingEnemy")
EndFunc
Func CanUse_PolymockEarthquake()
	If Anti_Spell() Then Return False
	Return True
EndFunc
Func BestTarget_PolymockEarthquake($a_f_AggroRange)
	Local $l_i_Target = UAI_GetNearestAgent(-2, $a_f_AggroRange, "UAI_Filter_IsLivingEnemy|UAI_Filter_IsCasting")
	If $l_i_Target <> 0 Then Return $l_i_Target
	Return UAI_GetNearestAgent(-2, $a_f_AggroRange, "UAI_Filter_IsLivingEnemy")
EndFunc
Func CanUse_PolymockFireball()
	If Anti_Spell() Then Return False
	Return True
EndFunc
Func BestTarget_PolymockFireball($a_f_AggroRange)
	Return UAI_GetNearestAgent(-2, $a_f_AggroRange, "UAI_Filter_IsLivingEnemy")
EndFunc
Func CanUse_PolymockRodgortsInvocation()
	If Anti_Spell() Then Return False
	Return True
EndFunc
Func BestTarget_PolymockRodgortsInvocation($a_f_AggroRange)
	Return UAI_GetBestAOETarget(-2, $a_f_AggroRange, $GC_I_RANGE_ADJACENT, "UAI_Filter_IsLivingEnemy")
EndFunc
Func CanUse_PolymockLamentation()
	If Anti_Spell() Then Return False
	Return True
EndFunc
Func BestTarget_PolymockLamentation($a_f_AggroRange)
	Return UAI_GetNearestAgent(-2, $a_f_AggroRange, "UAI_Filter_IsLivingEnemy")
EndFunc
Func CanUse_PolymockSpiritRift()
	If Anti_Spell() Then Return False
	Return True
EndFunc
Func BestTarget_PolymockSpiritRift($a_f_AggroRange)
	Return UAI_GetNearestAgent(-2, $a_f_AggroRange, "UAI_Filter_IsLivingEnemy")
EndFunc
Func CanUse_PolymockGlowingGaze()
	If Anti_Spell() Then Return False
	Return True
EndFunc
Func BestTarget_PolymockGlowingGaze($a_f_AggroRange)
	Local $l_i_Target = UAI_GetNearestAgent(-2, $a_f_AggroRange, "UAI_Filter_IsLivingEnemy|UAI_Filter_IsBurning")
	If $l_i_Target <> 0 Then Return $l_i_Target
	Return UAI_GetNearestAgent(-2, $a_f_AggroRange, "UAI_Filter_IsLivingEnemy")
EndFunc
Func CanUse_PolymockSearingFlames()
	If Anti_Spell() Then Return False
	Return True
EndFunc
Func BestTarget_PolymockSearingFlames($a_f_AggroRange)
	Local $l_i_Target = UAI_GetNearestAgent(-2, $a_f_AggroRange, "UAI_Filter_IsLivingEnemy|UAI_Filter_IsBurning")
	If $l_i_Target <> 0 Then Return $l_i_Target
	Return UAI_GetNearestAgent(-2, $a_f_AggroRange, "UAI_Filter_IsLivingEnemy")
EndFunc
Func CanUse_PolymockStoning()
	If Anti_Spell() Then Return False
	Return True
EndFunc
Func BestTarget_PolymockStoning($a_f_AggroRange)
	Return UAI_GetNearestAgent(-2, $a_f_AggroRange, "UAI_Filter_IsLivingEnemy")
EndFunc
Func CanUse_PolymockEruption()
	If Anti_Spell() Then Return False
	Return True
EndFunc
Func BestTarget_PolymockEruption($a_f_AggroRange)
	Return UAI_GetNearestAgent(-2, $a_f_AggroRange, "UAI_Filter_IsLivingEnemy")
EndFunc
Func CanUse_PolymockShockArrow()
	If Anti_Spell() Then Return False
	Return True
EndFunc
Func BestTarget_PolymockShockArrow($a_f_AggroRange)
	Return UAI_GetNearestAgent(-2, $a_f_AggroRange, "UAI_Filter_IsLivingEnemy")
EndFunc
Func CanUse_PolymockMindShock()
	If Anti_Spell() Then Return False
	Return True
EndFunc
Func BestTarget_PolymockMindShock($a_f_AggroRange)
	Return UAI_GetNearestAgent(-2, $a_f_AggroRange, "UAI_Filter_IsLivingEnemy")
EndFunc
Func CanUse_PolymockPiercingLightSpear()
	If Anti_Spell() Then Return False
	Return True
EndFunc
Func BestTarget_PolymockPiercingLightSpear($a_f_AggroRange)
	Return UAI_GetNearestAgent(-2, $a_f_AggroRange, "UAI_Filter_IsLivingEnemy")
EndFunc
Func CanUse_PolymockMindBlast()
	If Anti_Spell() Then Return False
	Return True
EndFunc
Func BestTarget_PolymockMindBlast($a_f_AggroRange)
	Return UAI_GetNearestAgent(-2, $a_f_AggroRange, "UAI_Filter_IsLivingEnemy")
EndFunc
Func CanUse_PolymockSavannahHeat()
	If Anti_Spell() Then Return False
	Return True
EndFunc
Func BestTarget_PolymockSavannahHeat($a_f_AggroRange)
	Return UAI_GetNearestAgent(-2, $a_f_AggroRange, "UAI_Filter_IsLivingEnemy")
EndFunc
Func CanUse_PolymockLightningBlast()
	If Anti_Spell() Then Return False
	Return True
EndFunc
Func BestTarget_PolymockLightningBlast($a_f_AggroRange)
	Return UAI_GetNearestAgent(-2, $a_f_AggroRange, "UAI_Filter_IsLivingEnemy")
EndFunc
Func CanUse_PolymockPoisonedGround()
	If Anti_Spell() Then Return False
	Return True
EndFunc
Func BestTarget_PolymockPoisonedGround($a_f_AggroRange)
	Return UAI_GetNearestAgent(-2, $a_f_AggroRange, "UAI_Filter_IsLivingEnemy")
EndFunc
Func CanUse_PolymockSandstorm()
	If Anti_Spell() Then Return False
	Return True
EndFunc
Func BestTarget_PolymockSandstorm($a_f_AggroRange)
	Local $l_i_Target = UAI_GetNearestAgent(-2, $a_f_AggroRange, "UAI_Filter_IsLivingEnemy|UAI_Filter_IsCasting")
	If $l_i_Target <> 0 Then Return $l_i_Target
	Return UAI_GetNearestAgent(-2, $a_f_AggroRange, "UAI_Filter_IsLivingEnemy")
EndFunc
Func CanUse_PolymockBanish()
	If Anti_Spell() Then Return False
	Return True
EndFunc
Func BestTarget_PolymockBanish($a_f_AggroRange)
	Return UAI_GetNearestAgent(-2, $a_f_AggroRange, "UAI_Filter_IsLivingEnemy")
EndFunc
Func CanUse_MurakaisConsumption()
	If Anti_Spell() Then Return False
	Return True
EndFunc
Func BestTarget_MurakaisConsumption($a_f_AggroRange)
	Return UAI_GetAgentLowest(-2, $a_f_AggroRange, $GC_UAI_AGENT_HP, "UAI_Filter_IsLivingAlly|UAI_Filter_ExcludeMe")
EndFunc
Func CanUse_MurakaisCensure()
	If Anti_Spell() Then Return False
	Return True
EndFunc
Func BestTarget_MurakaisCensure($a_f_AggroRange)
	Return UAI_GetPlayerInfo($GC_UAI_AGENT_ID)
EndFunc
Func CanUse_MurakaisCalamity()
	If Anti_Spell() Then Return False
	Return True
EndFunc
Func BestTarget_MurakaisCalamity($a_f_AggroRange)
	Return UAI_GetPlayerInfo($GC_UAI_AGENT_ID)
EndFunc
Func CanUse_MurakaisStormOfSouls()
	If Anti_Spell() Then Return False
	Return True
EndFunc
Func BestTarget_MurakaisStormOfSouls($a_f_AggroRange)
	Return UAI_GetPlayerInfo($GC_UAI_AGENT_ID)
EndFunc
Func CanUse_RavenSwoop()
	If Anti_Spell() Then Return False
	Return True
EndFunc
Func BestTarget_RavenSwoop($a_f_AggroRange)
	Return UAI_GetBestAOETarget(-2, $a_f_AggroRange, $GC_I_RANGE_ADJACENT, "UAI_Filter_IsLivingEnemy")
EndFunc
Func CanUse_FilthyExplosion()
	If Anti_Spell() Then Return False
	Return True
EndFunc
Func BestTarget_FilthyExplosion($a_f_AggroRange)
	Return UAI_GetPlayerInfo($GC_UAI_AGENT_ID)
EndFunc
Func CanUse_MurakaisCall()
	If Anti_Spell() Then Return False
	Return True
EndFunc
Func BestTarget_MurakaisCall($a_f_AggroRange)
	Return UAI_GetPlayerInfo($GC_UAI_AGENT_ID)
EndFunc
Func CanUse_ConsumeFlames()
	If Anti_Spell() Then Return False
	Return True
EndFunc
Func BestTarget_ConsumeFlames($a_f_AggroRange)
	Return UAI_GetPlayerInfo($GC_UAI_AGENT_ID)
EndFunc
Func CanUse_SmoothCriminal()
	If Anti_Spell() Then Return False
	Return True
EndFunc
Func BestTarget_SmoothCriminal($a_f_AggroRange)
	Return UAI_GetNearestAgent(-2, $a_f_AggroRange, "UAI_Filter_IsLivingEnemy")
EndFunc
Func CanUse_Technobabble()
	If Anti_Spell() Then Return False
	Return True
EndFunc
Func BestTarget_Technobabble($a_f_AggroRange)
	Return UAI_GetBestAOETarget(-2, $a_f_AggroRange, $GC_I_RANGE_ADJACENT, "UAI_Filter_IsLivingEnemy")
EndFunc
Func CanUse_EbonEscape()
	If Anti_Spell() Then Return False
	Return True
EndFunc
Func BestTarget_EbonEscape($a_f_AggroRange)
	Local $l_i_Target = UAI_GetAgentLowest(-2, $a_f_AggroRange, $GC_UAI_AGENT_HP, "UAI_Filter_IsLivingAlly|UAI_Filter_ExcludeMe")
	If $l_i_Target <> 0 Then Return $l_i_Target
	Return 0
EndFunc
Func CanUse_DrydersFeast()
	If Anti_Spell() Then Return False
	Return True
EndFunc
Func BestTarget_DrydersFeast($a_f_AggroRange)
	Return UAI_GetAgentLowest(-2, $a_f_AggroRange, $GC_UAI_AGENT_HP, "UAI_Filter_IsLivingAlly|UAI_Filter_ExcludeMe")
EndFunc
Func CanUse_ReversePolarityFireShield()
	If Anti_Spell() Then Return False
	Return True
EndFunc
Func BestTarget_ReversePolarityFireShield($a_f_AggroRange)
	Return UAI_GetPlayerInfo($GC_UAI_AGENT_ID)
EndFunc
Func CanUse_AnimateUndeadPalawaJoko()
	If Anti_Spell() Then Return False
	Return True
EndFunc
Func BestTarget_AnimateUndeadPalawaJoko($a_f_AggroRange)
	Return UAI_GetPlayerInfo($GC_UAI_AGENT_ID)
EndFunc
Func CanUse_OrderOfUnholyVigorPalawaJoko()
	If Anti_Spell() Then Return False
	Return True
EndFunc
Func BestTarget_OrderOfUnholyVigorPalawaJoko($a_f_AggroRange)
	Return UAI_GetPlayerInfo($GC_UAI_AGENT_ID)
EndFunc
Func CanUse_OrderOfTheLichPalawaJoko()
	If Anti_Spell() Then Return False
	Return True
EndFunc
Func BestTarget_OrderOfTheLichPalawaJoko($a_f_AggroRange)
	Return UAI_GetPlayerInfo($GC_UAI_AGENT_ID)
EndFunc
Func CanUse_WurmSiegeEyeOfTheNorth()
	If Anti_Spell() Then Return False
	Return True
EndFunc
Func BestTarget_WurmSiegeEyeOfTheNorth($a_f_AggroRange)
	Return UAI_GetBestAOETarget(-2, $a_f_AggroRange, $GC_I_RANGE_ADJACENT, "UAI_Filter_IsLivingEnemy")
EndFunc
Func CanUse_Enfeeble2()
	If Anti_Spell() Then Return False
	Return True
EndFunc
Func BestTarget_Enfeeble2($a_f_AggroRange)
	Return UAI_GetNearestAgent(-2, $a_f_AggroRange, "UAI_Filter_IsLivingEnemy")
EndFunc
Func CanUse_SearingFlames2()
	If Anti_Spell() Then Return False
	Return True
EndFunc
Func BestTarget_SearingFlames2($a_f_AggroRange)
	Return UAI_GetBestAOETarget(-2, $a_f_AggroRange, $GC_I_RANGE_ADJACENT, "UAI_Filter_IsLivingEnemy")
EndFunc
Func CanUse_GlowingGaze2()
	If Anti_Spell() Then Return False
	Return True
EndFunc
Func BestTarget_GlowingGaze2($a_f_AggroRange)
	Return UAI_GetNearestAgent(-2, $a_f_AggroRange, "UAI_Filter_IsLivingEnemy")
EndFunc
Func CanUse_Steam2()
	If Anti_Spell() Then Return False
	Return True
EndFunc
Func BestTarget_Steam2($a_f_AggroRange)
	Return UAI_GetBestAOETarget(-2, $a_f_AggroRange, $GC_I_RANGE_ADJACENT, "UAI_Filter_IsLivingEnemy")
EndFunc
Func CanUse_LiquidFlam2()
	If Anti_Spell() Then Return False
	Return True
EndFunc
Func BestTarget_LiquidFlam2($a_f_AggroRange)
	Return UAI_GetBestAOETarget(-2, $a_f_AggroRange, $GC_I_RANGE_ADJACENT, "UAI_Filter_IsLivingEnemy")
EndFunc
Func CanUse_SmiteCondition2()
	If Anti_Spell() Then Return False
	Return True
EndFunc
Func BestTarget_SmiteCondition2($a_f_AggroRange)
	Return UAI_GetNearestAgent(-2, $a_f_AggroRange, "UAI_Filter_IsLivingEnemy")
EndFunc
Func CanUse_SpikeTrapSpell()
	If Anti_Spell() Then Return False
	Return True
EndFunc
Func BestTarget_SpikeTrapSpell($a_f_AggroRange)
	Return UAI_GetPlayerInfo($GC_UAI_AGENT_ID)
EndFunc
Func CanUse_FireAndBrimstone()
	If Anti_Spell() Then Return False
	Return True
EndFunc
Func BestTarget_FireAndBrimstone($a_f_AggroRange)
	Return UAI_GetNearestAgent(-2, $a_f_AggroRange, "UAI_Filter_IsLivingEnemy")
EndFunc
Func CanUse_EssenceStrikeTogo()
	If Anti_Spell() Then Return False
	Return True
EndFunc
Func BestTarget_EssenceStrikeTogo($a_f_AggroRange)
	Return UAI_GetNearestAgent(-2, $a_f_AggroRange, "UAI_Filter_IsLivingEnemy")
EndFunc
Func CanUse_SpiritBurnTogo()
	If Anti_Spell() Then Return False
	Return True
EndFunc
Func BestTarget_SpiritBurnTogo($a_f_AggroRange)
	Return UAI_GetNearestAgent(-2, $a_f_AggroRange, "UAI_Filter_IsLivingEnemy")
EndFunc
Func CanUse_SpiritRiftTogo()
	If Anti_Spell() Then Return False
	Return True
EndFunc
Func BestTarget_SpiritRiftTogo($a_f_AggroRange)
	Return UAI_GetNearestAgent(-2, $a_f_AggroRange, "UAI_Filter_IsLivingEnemy")
EndFunc
Func CanUse_MendBodyAndSoulTogo()
	If Anti_Spell() Then Return False
	Return True
EndFunc
Func BestTarget_MendBodyAndSoulTogo($a_f_AggroRange)
	Return UAI_GetAgentLowest(-2, $a_f_AggroRange, $GC_UAI_AGENT_HP, "UAI_Filter_IsLivingAlly|UAI_Filter_ExcludeMe")
EndFunc
Func CanUse_OfferingOfSpiritTogo()
	If Anti_Spell() Then Return False
	Return True
EndFunc
Func BestTarget_OfferingOfSpiritTogo($a_f_AggroRange)
	Return UAI_GetPlayerInfo($GC_UAI_AGENT_ID)
EndFunc
Func CanUse_RedemptionOfPurity()
	If Anti_Spell() Then Return False
	Return True
EndFunc
Func BestTarget_RedemptionOfPurity($a_f_AggroRange)
	Return UAI_GetNearestAgent(-2, $a_f_AggroRange, "UAI_Filter_IsLivingEnemy")
EndFunc
Func CanUse_PurifyEnergy()
	If Anti_Spell() Then Return False
	Return True
EndFunc
Func BestTarget_PurifyEnergy($a_f_AggroRange)
	Return UAI_GetPlayerInfo($GC_UAI_AGENT_ID)
EndFunc
Func CanUse_PurifyingFlame()
	If Anti_Spell() Then Return False
	Return True
EndFunc
Func BestTarget_PurifyingFlame($a_f_AggroRange)
	Return UAI_GetPlayerInfo($GC_UAI_AGENT_ID)
EndFunc
Func CanUse_PurifyingPrayer()
	If Anti_Spell() Then Return False
	Return True
EndFunc
Func BestTarget_PurifyingPrayer($a_f_AggroRange)
	Local $l_i_Target = UAI_GetNearestAgent(-2, $a_f_AggroRange, "UAI_Filter_IsAlly|UAI_Filter_IsConditioned|UAI_Filter_IsHexed")
	If $l_i_Target <> 0 Then Return $l_i_Target
	Return UAI_GetNearestAgent(-2, $a_f_AggroRange, "UAI_Filter_IsAlly")
EndFunc
Func CanUse_PurifySoul()
	If Anti_Spell() Then Return False
	Return True
EndFunc
Func BestTarget_PurifySoul($a_f_AggroRange)
	Return UAI_GetPlayerInfo($GC_UAI_AGENT_ID)
EndFunc
Func CanUse_JadeBrotherhoodBomb()
	If Anti_Spell() Then Return False
	Return True
EndFunc
Func BestTarget_JadeBrotherhoodBomb($a_f_AggroRange)
	Return UAI_GetPlayerInfo($GC_UAI_AGENT_ID)
EndFunc
Func CanUse_RocketPropelledGobstopper()
	If Anti_Spell() Then Return False
	Return True
EndFunc
Func BestTarget_RocketPropelledGobstopper($a_f_AggroRange)
	Return UAI_GetNearestAgent(-2, $a_f_AggroRange, "UAI_Filter_IsLivingEnemy")
EndFunc
Func CanUse_RainOfTerrorSpell()
	If Anti_Spell() Then Return False
	Return True
EndFunc
Func BestTarget_RainOfTerrorSpell($a_f_AggroRange)
	Return UAI_GetBestAOETarget(-2, $a_f_AggroRange, $GC_I_RANGE_ADJACENT, "UAI_Filter_IsLivingEnemy")
EndFunc
Func CanUse_SugarInfusion()
	If Anti_Spell() Then Return False
	Return True
EndFunc
Func BestTarget_SugarInfusion($a_f_AggroRange)
	Return UAI_GetAgentLowest(-2, $a_f_AggroRange, $GC_UAI_AGENT_HP, "UAI_Filter_IsLivingAlly|UAI_Filter_ExcludeMe")
EndFunc
Func CanUse_FeastOfVengeance()
	If Anti_Spell() Then Return False
	Return True
EndFunc
Func BestTarget_FeastOfVengeance($a_f_AggroRange)
	Return UAI_GetNearestAgent(-2, $a_f_AggroRange, "UAI_Filter_IsLivingEnemy")
EndFunc
Func CanUse_AnimateCandyMinions()
	If Anti_Spell() Then Return False
	Return True
EndFunc
Func BestTarget_AnimateCandyMinions($a_f_AggroRange)
	Return UAI_GetPlayerInfo($GC_UAI_AGENT_ID)
EndFunc
Func CanUse_TasteOfUndeath()
	If Anti_Spell() Then Return False
	Return True
EndFunc
Func BestTarget_TasteOfUndeath($a_f_AggroRange)
	Return UAI_GetNearestAgent(-2, $a_f_AggroRange, "UAI_Filter_IsLivingEnemy")
EndFunc
Func CanUse_ScourgeOfCandy()
	If Anti_Spell() Then Return False
	Return True
EndFunc
Func BestTarget_ScourgeOfCandy($a_f_AggroRange)
	Return UAI_GetNearestAgent(-2, $a_f_AggroRange, "UAI_Filter_IsLivingEnemy")
EndFunc
Func CanUse_MadKingPonySupport()
	If Anti_Spell() Then Return False
	Return True
EndFunc
Func BestTarget_MadKingPonySupport($a_f_AggroRange)
	Return UAI_GetNearestAgent(-2, $a_f_AggroRange, "UAI_Filter_IsLivingEnemy")
EndFunc
Func CanUse_MindShockPvp()
	If Anti_Spell() Then Return False
	Return True
EndFunc
Func BestTarget_MindShockPvp($a_f_AggroRange)
	Return UAI_GetNearestAgent(-2, $a_f_AggroRange, "UAI_Filter_IsLivingEnemy")
EndFunc
Func CanUse_RideTheLightningPvp()
	If Anti_Spell() Then Return False
	Return True
EndFunc
Func BestTarget_RideTheLightningPvp($a_f_AggroRange)
	Return UAI_GetNearestAgent(-2, $a_f_AggroRange, "UAI_Filter_IsLivingEnemy")
EndFunc
Func CanUse_ObsidianFlamePvp()
	If Anti_Spell() Then Return False
	Return True
EndFunc
Func BestTarget_ObsidianFlamePvp($a_f_AggroRange)
	Return UAI_GetNearestAgent(-2, $a_f_AggroRange, "UAI_Filter_IsLivingEnemy")
EndFunc
Func CanUse_EnergyDrainPvp()
	If Anti_Spell() Then Return False
	Return True
EndFunc
Func BestTarget_EnergyDrainPvp($a_f_AggroRange)
	Local $l_i_Target = UAI_GetBestSingleTarget(-2, $a_f_AggroRange, $GC_UAI_AGENT_HP, "UAI_Filter_IsLivingEnemy|UAI_Filter_IsCaster")
	If $l_i_Target <> 0 Then Return $l_i_Target
	Return UAI_GetBestSingleTarget(-2, $a_f_AggroRange, $GC_UAI_AGENT_HP, "UAI_Filter_IsLivingEnemy")
EndFunc
Func CanUse_EnergyTapPvp()
	If Anti_Spell() Then Return False
	Return True
EndFunc
Func BestTarget_EnergyTapPvp($a_f_AggroRange)
	Local $l_i_Target = UAI_GetBestSingleTarget(-2, $a_f_AggroRange, $GC_UAI_AGENT_HP, "UAI_Filter_IsLivingEnemy|UAI_Filter_IsCaster")
	If $l_i_Target <> 0 Then Return $l_i_Target
	Return UAI_GetBestSingleTarget(-2, $a_f_AggroRange, $GC_UAI_AGENT_HP, "UAI_Filter_IsLivingEnemy")
EndFunc
Func CanUse_LightningOrbPvp()
	If Anti_Spell() Then Return False
	Return True
EndFunc
Func BestTarget_LightningOrbPvp($a_f_AggroRange)
	Return UAI_GetNearestAgent(-2, $a_f_AggroRange, "UAI_Filter_IsLivingEnemy")
EndFunc
Func CanUse_EnfeeblePvp()
	If Anti_Spell() Then Return False
	Return True
EndFunc
Func BestTarget_EnfeeblePvp($a_f_AggroRange)
	Return UAI_GetNearestAgent(-2, $a_f_AggroRange, "UAI_Filter_IsLivingEnemy")
EndFunc
Func CanUse_DiscordPvp()
	If Anti_Spell() Then Return False
	Return True
EndFunc
Func BestTarget_DiscordPvp($a_f_AggroRange)
	Return UAI_GetNearestAgent(-2, $a_f_AggroRange, "UAI_Filter_IsLivingEnemy")
EndFunc
Func CanUse_FleshOfMyFleshPvp()
	If Anti_Spell() Then Return False
	If UAI_PlayerHasEffect($GC_I_SKILL_ID_CURSE_OF_DHUUM) Or UAI_PlayerHasEffect($GC_I_SKILL_ID_FROZEN_SOIL) Then Return False
	Return True
EndFunc
Func BestTarget_FleshOfMyFleshPvp($a_f_AggroRange)
	Return UAI_GetAgentLowest(-2, $a_f_AggroRange, $GC_UAI_AGENT_HP, "UAI_Filter_IsLivingAlly|UAI_Filter_ExcludeMe")
EndFunc
Func CanUse_BlindingSurgePvp()
	If Anti_Spell() Then Return False
	Return True
EndFunc
Func BestTarget_BlindingSurgePvp($a_f_AggroRange)
	Return UAI_GetNearestAgent(-2, $a_f_AggroRange, "UAI_Filter_IsLivingEnemy")
EndFunc
Func CanUse_LightOfDeliverancePvp()
	If Anti_Spell() Then Return False
	Return True
EndFunc
Func BestTarget_LightOfDeliverancePvp($a_f_AggroRange)
	Return UAI_GetPlayerInfo($GC_UAI_AGENT_ID)
EndFunc
Func CanUse_EnfeeblingBloodPvp()
	If Anti_Spell() Then Return False
	Return True
EndFunc
Func BestTarget_EnfeeblingBloodPvp($a_f_AggroRange)
	Return UAI_GetBestAOETarget(-2, $a_f_AggroRange, $GC_I_RANGE_NEARBY, "UAI_Filter_IsLivingEnemy")
EndFunc
Func CanUse_ReactorBlast()
	If Anti_Spell() Then Return False
	Return True
EndFunc
Func BestTarget_ReactorBlast($a_f_AggroRange)
	Return UAI_GetPlayerInfo($GC_UAI_AGENT_ID)
EndFunc
Func CanUse_NoxBeam()
	If Anti_Spell() Then Return False
	Return True
EndFunc
Func BestTarget_NoxBeam($a_f_AggroRange)
	Return UAI_GetNearestAgent(-2, $a_f_AggroRange, "UAI_Filter_IsLivingEnemy")
EndFunc
Func CanUse_NoxionBuster()
	If Anti_Spell() Then Return False
	Return True
EndFunc
Func BestTarget_NoxionBuster($a_f_AggroRange)
	Return UAI_GetNearestAgent(-2, $a_f_AggroRange, "UAI_Filter_IsLivingEnemy")
EndFunc
Func CanUse_BitGolemBreaker()
	If Anti_Spell() Then Return False
	Return True
EndFunc
Func BestTarget_BitGolemBreaker($a_f_AggroRange)
	Return UAI_GetNearestAgent(-2, $a_f_AggroRange, "UAI_Filter_IsLivingEnemy")
EndFunc
Func CanUse_BitGolemCrash()
	If Anti_Spell() Then Return False
	Return True
EndFunc
Func BestTarget_BitGolemCrash($a_f_AggroRange)
	Return UAI_GetPlayerInfo($GC_UAI_AGENT_ID)
EndFunc
Func CanUse_BitGolemForce()
	If Anti_Spell() Then Return False
	Return True
EndFunc
Func BestTarget_BitGolemForce($a_f_AggroRange)
	Return UAI_GetPlayerInfo($GC_UAI_AGENT_ID)
EndFunc
Func CanUse_NoxThunder()
	If Anti_Spell() Then Return False
	Return True
EndFunc
Func BestTarget_NoxThunder($a_f_AggroRange)
	Return UAI_GetNearestAgent(-2, $a_f_AggroRange, "UAI_Filter_IsLivingEnemy")
EndFunc
Func CanUse_NoxFire()
	If Anti_Spell() Then Return False
	Return True
EndFunc
Func BestTarget_NoxFire($a_f_AggroRange)
	Return UAI_GetPlayerInfo($GC_UAI_AGENT_ID)
EndFunc
Func CanUse_NoxKnuckle()
	If Anti_Spell() Then Return False
	Return True
EndFunc
Func BestTarget_NoxKnuckle($a_f_AggroRange)
	Return UAI_GetNearestAgent(-2, $a_f_AggroRange, "UAI_Filter_IsLivingEnemy")
EndFunc
Func CanUse_NoxDividerDrive()
	If Anti_Spell() Then Return False
	Return True
EndFunc
Func BestTarget_NoxDividerDrive($a_f_AggroRange)
	Return UAI_GetNearestAgent(-2, $a_f_AggroRange, "UAI_Filter_IsLivingEnemy")
EndFunc
Func CanUse_ShrineBacklash()
	If Anti_Spell() Then Return False
	Return True
EndFunc
Func BestTarget_ShrineBacklash($a_f_AggroRange)
	Return UAI_GetPlayerInfo($GC_UAI_AGENT_ID)
EndFunc
Func CanUse_WesternHealthShrineBonus()
	If Anti_Spell() Then Return False
	Return True
EndFunc
Func BestTarget_WesternHealthShrineBonus($a_f_AggroRange)
	Return UAI_GetPlayerInfo($GC_UAI_AGENT_ID)
EndFunc
Func CanUse_EasternHealthShrineBonus()
	If Anti_Spell() Then Return False
	Return True
EndFunc
Func BestTarget_EasternHealthShrineBonus($a_f_AggroRange)
	Return UAI_GetPlayerInfo($GC_UAI_AGENT_ID)
EndFunc
Func CanUse_Snowball2()
	If Anti_Spell() Then Return False
	Return True
EndFunc
Func BestTarget_Snowball2($a_f_AggroRange)
	Return UAI_GetNearestAgent(-2, $a_f_AggroRange, "UAI_Filter_IsLivingEnemy")
EndFunc
Func CanUse_SavannahHeatPvp()
	If Anti_Spell() Then Return False
	Return True
EndFunc
Func BestTarget_SavannahHeatPvp($a_f_AggroRange)
	Return UAI_GetBestAOETarget(-2, $a_f_AggroRange, $GC_I_RANGE_ADJACENT, "UAI_Filter_IsLivingEnemy")
EndFunc
Func CanUse_SpiritSiphonMasterRiyo()
	If Anti_Spell() Then Return False
	Return True
EndFunc
Func BestTarget_SpiritSiphonMasterRiyo($a_f_AggroRange)
	Return UAI_GetNearestAgent(-2, $a_f_AggroRange, "UAI_Filter_IsLivingEnemy")
EndFunc
Func CanUse_UnholyFeastPvp()
	If Anti_Spell() Then Return False
	Return True
EndFunc
Func BestTarget_UnholyFeastPvp($a_f_AggroRange)
	Return UAI_GetPlayerInfo($GC_UAI_AGENT_ID)
EndFunc
Func CanUse_EverlastingMobstopperSkill()
	If Anti_Spell() Then Return False
	Return True
EndFunc
Func BestTarget_EverlastingMobstopperSkill($a_f_AggroRange)
	Return UAI_GetPlayerInfo($GC_UAI_AGENT_ID)
EndFunc
Func CanUse_CurseOfDhuum()
	If Anti_Spell() Then Return False
	Return True
EndFunc
Func BestTarget_CurseOfDhuum($a_f_AggroRange)
	Return UAI_GetPlayerInfo($GC_UAI_AGENT_ID)
EndFunc
Func CanUse_DhuumsRestReaperSkill()
	If Anti_Spell() Then Return False
	Return True
EndFunc
Func BestTarget_DhuumsRestReaperSkill($a_f_AggroRange)
	Return UAI_GetPlayerInfo($GC_UAI_AGENT_ID)
EndFunc
Func CanUse_SummonChampion()
	If Anti_Spell() Then Return False
	Return True
EndFunc
Func BestTarget_SummonChampion($a_f_AggroRange)
	Return UAI_GetPlayerInfo($GC_UAI_AGENT_ID)
EndFunc
Func CanUse_SummonMinions()
	If Anti_Spell() Then Return False
	Return True
EndFunc
Func BestTarget_SummonMinions($a_f_AggroRange)
	Return UAI_GetPlayerInfo($GC_UAI_AGENT_ID)
EndFunc
Func CanUse_JudgmentOfDhuum()
	If Anti_Spell() Then Return False
	Return True
EndFunc
Func BestTarget_JudgmentOfDhuum($a_f_AggroRange)
	Return UAI_GetPlayerInfo($GC_UAI_AGENT_ID)
EndFunc
Func CanUse_DhuumsRest()
	If Anti_Spell() Then Return False
	Return True
EndFunc
Func BestTarget_DhuumsRest($a_f_AggroRange)
	Return UAI_GetPlayerInfo($GC_UAI_AGENT_ID)
EndFunc
Func CanUse_SpiritualHealing()
	If Anti_Spell() Then Return False
	Return True
EndFunc
Func BestTarget_SpiritualHealing($a_f_AggroRange)
	Return UAI_GetAgentLowest(-2, $a_f_AggroRange, $GC_UAI_AGENT_HP, "UAI_Filter_IsLivingAlly|UAI_Filter_ExcludeMe")
EndFunc
Func CanUse_EncaseSkeletal()
	If Anti_Spell() Then Return False
	Return True
EndFunc
Func BestTarget_EncaseSkeletal($a_f_AggroRange)
	Return UAI_GetNearestAgent(-2, $a_f_AggroRange, "UAI_Filter_IsLivingEnemy")
EndFunc
Func CanUse_ReversalOfDeath()
	If Anti_Spell() Then Return False
	Return True
EndFunc
Func BestTarget_ReversalOfDeath($a_f_AggroRange)
	Return UAI_GetAgentLowest(-2, $a_f_AggroRange, $GC_UAI_AGENT_HP, "UAI_Filter_IsLivingAlly|UAI_Filter_ExcludeMe")
EndFunc
Func CanUse_GhostlyFury()
	If Anti_Spell() Then Return False
	Return True
EndFunc
Func BestTarget_GhostlyFury($a_f_AggroRange)
	Return UAI_GetNearestAgent(-2, $a_f_AggroRange, "UAI_Filter_IsLivingEnemy")
EndFunc
Func CanUse_SpiritualHealingReaperSkill()
	If Anti_Spell() Then Return False
	Return True
EndFunc
Func BestTarget_SpiritualHealingReaperSkill($a_f_AggroRange)
	Return UAI_GetAgentLowest(-2, $a_f_AggroRange, $GC_UAI_AGENT_HP, "UAI_Filter_IsLivingAlly|UAI_Filter_ExcludeMe")
EndFunc
Func CanUse_GhostlyFuryReaperSkill()
	If Anti_Spell() Then Return False
	Return True
EndFunc
Func BestTarget_GhostlyFuryReaperSkill($a_f_AggroRange)
	Return UAI_GetNearestAgent(-2, $a_f_AggroRange, "UAI_Filter_IsLivingEnemy")
EndFunc
Func CanUse_GolemPilebunker()
	If Anti_Spell() Then Return False
	Return True
EndFunc
Func BestTarget_GolemPilebunker($a_f_AggroRange)
	Return UAI_GetNearestAgent(-2, $a_f_AggroRange, "UAI_Filter_IsLivingEnemy")
EndFunc
Func CanUse_KorosGaze()
	If Anti_Spell() Then Return False
	Return True
EndFunc
Func BestTarget_KorosGaze($a_f_AggroRange)
	Return UAI_GetNearestAgent(-2, $a_f_AggroRange, "UAI_Filter_IsLivingEnemy")
EndFunc
Func CanUse_EbonVanguardAssassinSupportNpc()
	If Anti_Spell() Then Return False
	Return True
EndFunc
Func BestTarget_EbonVanguardAssassinSupportNpc($a_f_AggroRange)
	Return UAI_GetNearestAgent(-2, $a_f_AggroRange, "UAI_Filter_IsLivingEnemy")
EndFunc
Func CanUse_ShatterDelusionsPvp()
	If Anti_Spell() Then Return False
	Return True
EndFunc
Func BestTarget_ShatterDelusionsPvp($a_f_AggroRange)
	Local $l_i_Target = UAI_GetBestAOETarget(-2, $a_f_AggroRange, $GC_I_RANGE_ADJACENT, "UAI_Filter_IsLivingEnemy|UAI_Filter_IsHexed")
	If $l_i_Target <> 0 Then Return $l_i_Target
	Return UAI_GetBestAOETarget(-2, $a_f_AggroRange, $GC_I_RANGE_ADJACENT, "UAI_Filter_IsLivingEnemy")
EndFunc
Func CanUse_AccumulatedPainPvp()
	If Anti_Spell() Then Return False
	Return True
EndFunc
Func BestTarget_AccumulatedPainPvp($a_f_AggroRange)
	Return UAI_GetNearestAgent(-2, $a_f_AggroRange, "UAI_Filter_IsLivingEnemy")
EndFunc
Func CanUse_PsychicInstabilityPvp()
	If Anti_Spell() Then Return False
	Return True
EndFunc
Func BestTarget_PsychicInstabilityPvp($a_f_AggroRange)
	Return UAI_GetNearestAgent(-2, $a_f_AggroRange, "UAI_Filter_IsLivingEnemy")
EndFunc
Func CanUse_SpiritualPainPvp()
	If Anti_Spell() Then Return False
	Return True
EndFunc
Func BestTarget_SpiritualPainPvp($a_f_AggroRange)
	Return UAI_GetNearestAgent(-2, $a_f_AggroRange, "UAI_Filter_IsLivingEnemy")
EndFunc
Func CanUse_MirrorOfDisenchantmentPvp()
	If Anti_Spell() Then Return False
	Return True
EndFunc
Func BestTarget_MirrorOfDisenchantmentPvp($a_f_AggroRange)
	Return UAI_GetAgentHighest(-2, $a_f_AggroRange, $GC_UAI_AGENT_HP, "UAI_Filter_IsLivingEnemy|UAI_Filter_IsEnchanted")
EndFunc
Func CanUse_Adoration()
	If Anti_Spell() Then Return False
	Return True
EndFunc
Func BestTarget_Adoration($a_f_AggroRange)
	Return UAI_GetAgentLowest(-2, $a_f_AggroRange, $GC_UAI_AGENT_HP, "UAI_Filter_IsLivingAlly")
EndFunc
Func CanUse_HealPartyPvp()
	If Anti_Spell() Then Return False
	Return True
EndFunc
Func BestTarget_HealPartyPvp($a_f_AggroRange)
	Return UAI_GetPlayerInfo($GC_UAI_AGENT_ID)
EndFunc
Func CanUse_ComingOfSpring()
	If Anti_Spell() Then Return False
	Return True
EndFunc
Func BestTarget_ComingOfSpring($a_f_AggroRange)
	Return UAI_GetPlayerInfo($GC_UAI_AGENT_ID)
EndFunc
Func CanUse_DeathsEmbrace()
	If Anti_Spell() Then Return False
	Return True
EndFunc
Func BestTarget_DeathsEmbrace($a_f_AggroRange)
	Return UAI_GetPlayerInfo($GC_UAI_AGENT_ID)
EndFunc
Func CanUse_UltraSnowball()
	If Anti_Spell() Then Return False
	Return True
EndFunc
Func BestTarget_UltraSnowball($a_f_AggroRange)
	Return UAI_GetNearestAgent(-2, $a_f_AggroRange, "UAI_Filter_IsLivingEnemy")
EndFunc
Func CanUse_Blizzard()
	If Anti_Spell() Then Return False
	Return True
EndFunc
Func BestTarget_Blizzard($a_f_AggroRange)
	Return UAI_GetNearestAgent(-2, $a_f_AggroRange, "UAI_Filter_IsLivingEnemy")
EndFunc
Func CanUse_UltraSnowball2()
	If Anti_Spell() Then Return False
	Return True
EndFunc
Func BestTarget_UltraSnowball2($a_f_AggroRange)
	Return UAI_GetNearestAgent(-2, $a_f_AggroRange, "UAI_Filter_IsLivingEnemy")
EndFunc
Func CanUse_UltraSnowball3()
	If Anti_Spell() Then Return False
	Return True
EndFunc
Func BestTarget_UltraSnowball3($a_f_AggroRange)
	Return UAI_GetNearestAgent(-2, $a_f_AggroRange, "UAI_Filter_IsLivingEnemy")
EndFunc
Func CanUse_UltraSnowball4()
	If Anti_Spell() Then Return False
	Return True
EndFunc
Func BestTarget_UltraSnowball4($a_f_AggroRange)
	Return UAI_GetNearestAgent(-2, $a_f_AggroRange, "UAI_Filter_IsLivingEnemy")
EndFunc
Func CanUse_UltraSnowball5()
	If Anti_Spell() Then Return False
	Return True
EndFunc
Func BestTarget_UltraSnowball5($a_f_AggroRange)
	Return UAI_GetNearestAgent(-2, $a_f_AggroRange, "UAI_Filter_IsLivingEnemy")
EndFunc
Func CanUse_MysticHealingPvp()
	If Anti_Spell() Then Return False
	Return True
EndFunc
Func BestTarget_MysticHealingPvp($a_f_AggroRange)
	Return UAI_GetPlayerInfo($GC_UAI_AGENT_ID)
EndFunc
Func CanUse_StunGrenade()
	If Anti_Spell() Then Return False
	Return True
EndFunc
Func BestTarget_StunGrenade($a_f_AggroRange)
	Return UAI_GetBestAOETarget(-2, $a_f_AggroRange, $GC_I_RANGE_ADJACENT, "UAI_Filter_IsLivingEnemy")
EndFunc
Func CanUse_FragmentationGrenade()
	If Anti_Spell() Then Return False
	Return True
EndFunc
Func BestTarget_FragmentationGrenade($a_f_AggroRange)
	Return UAI_GetBestAOETarget(-2, $a_f_AggroRange, $GC_I_RANGE_ADJACENT, "UAI_Filter_IsLivingEnemy")
EndFunc
Func CanUse_TearGas()
	If Anti_Spell() Then Return False
	Return True
EndFunc
Func BestTarget_TearGas($a_f_AggroRange)
	Return UAI_GetBestAOETarget(-2, $a_f_AggroRange, $GC_I_RANGE_ADJACENT, "UAI_Filter_IsLivingEnemy")
EndFunc
Func CanUse_PhasedPlasmaBurst()
	If Anti_Spell() Then Return False
	Return True
EndFunc
Func BestTarget_PhasedPlasmaBurst($a_f_AggroRange)
	Return UAI_GetNearestAgent(-2, $a_f_AggroRange, "UAI_Filter_IsLivingEnemy")
EndFunc
Func CanUse_PlasmaShot()
	If Anti_Spell() Then Return False
	Return True
EndFunc
Func BestTarget_PlasmaShot($a_f_AggroRange)
	Return UAI_GetNearestAgent(-2, $a_f_AggroRange, "UAI_Filter_IsLivingEnemy")
EndFunc
Func CanUse_MirrorShatter()
	If Anti_Spell() Then Return False
	Return True
EndFunc
Func BestTarget_MirrorShatter($a_f_AggroRange)
	Return UAI_GetPlayerInfo($GC_UAI_AGENT_ID)
EndFunc
Func CanUse_PhaseShield()
	If Anti_Spell() Then Return False
	Return True
EndFunc
Func BestTarget_PhaseShield($a_f_AggroRange)
	Return UAI_GetPlayerInfo($GC_UAI_AGENT_ID)
EndFunc
Func CanUse_ReactorBurst()
	If Anti_Spell() Then Return False
	Return True
EndFunc
Func BestTarget_ReactorBurst($a_f_AggroRange)
	Return UAI_GetPlayerInfo($GC_UAI_AGENT_ID)
EndFunc
Func CanUse_AnnihilatorBeam()
	If Anti_Spell() Then Return False
	Return True
EndFunc
Func BestTarget_AnnihilatorBeam($a_f_AggroRange)
	Return UAI_GetNearestAgent(-2, $a_f_AggroRange, "UAI_Filter_IsLivingEnemy")
EndFunc
Func CanUse_LightningHammerPvp()
	If Anti_Spell() Then Return False
	Return True
EndFunc
Func BestTarget_LightningHammerPvp($a_f_AggroRange)
	Return UAI_GetNearestAgent(-2, $a_f_AggroRange, "UAI_Filter_IsLivingEnemy")
EndFunc
Func CanUse_SlipperyGroundPvp()
	If Anti_Spell() Then Return False
	Return True
EndFunc
Func BestTarget_SlipperyGroundPvp($a_f_AggroRange)
	Return UAI_GetBestAOETarget(-2, $a_f_AggroRange, $GC_I_RANGE_ADJACENT, "UAI_Filter_IsLivingEnemy")
EndFunc