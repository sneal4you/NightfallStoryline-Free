#include-once
Func Anti_Enchantment()
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
Func CanUse_IllusionOfWeakness()
	If Anti_Enchantment() Then Return False
	Return True
EndFunc
Func BestTarget_IllusionOfWeakness($a_f_AggroRange)
	Return UAI_GetPlayerInfo($GC_UAI_AGENT_ID)
EndFunc
Func CanUse_IllusionaryWeaponry()
	If Anti_Enchantment() Then Return False
	Return True
EndFunc
Func BestTarget_IllusionaryWeaponry($a_f_AggroRange)
	Return UAI_GetPlayerInfo($GC_UAI_AGENT_ID)
EndFunc
Func CanUse_SympatheticVisage()
	If Anti_Enchantment() Then Return False
	Return True
EndFunc
Func BestTarget_SympatheticVisage($a_f_AggroRange)
	Local $l_i_Target = UAI_GetNearestAgent(-2, $a_f_AggroRange, "UAI_Filter_IsLivingAlly|UAI_Filter_ExcludeMe")
	If $l_i_Target <> 0 Then Return $l_i_Target
	Return UAI_GetPlayerInfo($GC_UAI_AGENT_ID)
EndFunc
Func CanUse_IllusionOfHaste()
	If Anti_Enchantment() Then Return False
	Return True
EndFunc
Func BestTarget_IllusionOfHaste($a_f_AggroRange)
	Return UAI_GetPlayerInfo($GC_UAI_AGENT_ID)
EndFunc
Func CanUse_Channeling()
	If Anti_Enchantment() Then Return False
	Return True
EndFunc
Func BestTarget_Channeling($a_f_AggroRange)
	Return UAI_GetPlayerInfo($GC_UAI_AGENT_ID)
EndFunc
Func CanUse_Echo()
	If Anti_Enchantment() Then Return False
	Return True
EndFunc
Func BestTarget_Echo($a_f_AggroRange)
	Return UAI_GetPlayerInfo($GC_UAI_AGENT_ID)
EndFunc
Func CanUse_ArcaneEcho()
	If Anti_Enchantment() Then Return False
	Return True
EndFunc
Func BestTarget_ArcaneEcho($a_f_AggroRange)
	Return UAI_GetPlayerInfo($GC_UAI_AGENT_ID)
EndFunc
Func CanUse_MantraOfRecall()
	If Anti_Enchantment() Then Return False
	Return True
EndFunc
Func BestTarget_MantraOfRecall($a_f_AggroRange)
	Return UAI_GetPlayerInfo($GC_UAI_AGENT_ID)
EndFunc
Func CanUse_VeratasAura()
	If Anti_Enchantment() Then Return False
	Return True
EndFunc
Func BestTarget_VeratasAura($a_f_AggroRange)
	Return UAI_GetPlayerInfo($GC_UAI_AGENT_ID)
EndFunc
Func CanUse_DeathNova()
	If Anti_Enchantment() Then Return False
	Return True
EndFunc
Func BestTarget_DeathNova($a_f_AggroRange)
	Local $l_i_Target = UAI_GetNearestAgent(-2, $a_f_AggroRange, "UAI_Filter_IsLivingAlly|UAI_Filter_ExcludeMe")
	If $l_i_Target <> 0 Then Return $l_i_Target
	Return UAI_GetPlayerInfo($GC_UAI_AGENT_ID)
EndFunc
Func CanUse_AwakenTheBlood()
	If Anti_Enchantment() Then Return False
	Return True
EndFunc
Func BestTarget_AwakenTheBlood($a_f_AggroRange)
	Return UAI_GetPlayerInfo($GC_UAI_AGENT_ID)
EndFunc
Func CanUse_TaintedFlesh()
	If Anti_Enchantment() Then Return False
	Return True
EndFunc
Func BestTarget_TaintedFlesh($a_f_AggroRange)
	Local $l_i_Target = UAI_GetNearestAgent(-2, $a_f_AggroRange, "UAI_Filter_IsLivingAlly|UAI_Filter_ExcludeMe")
	If $l_i_Target <> 0 Then Return $l_i_Target
	Return UAI_GetPlayerInfo($GC_UAI_AGENT_ID)
EndFunc
Func CanUse_AuraOfTheLich()
	If Anti_Enchantment() Then Return False
	Return True
EndFunc
Func BestTarget_AuraOfTheLich($a_f_AggroRange)
	Return UAI_GetPlayerInfo($GC_UAI_AGENT_ID)
EndFunc
Func CanUse_BloodRenewal()
	If Anti_Enchantment() Then Return False
	Return True
EndFunc
Func BestTarget_BloodRenewal($a_f_AggroRange)
	Return UAI_GetPlayerInfo($GC_UAI_AGENT_ID)
EndFunc
Func CanUse_DarkAura()
	If Anti_Enchantment() Then Return False
	If UAI_GetPlayerEffectInfo($GC_I_SKILL_ID_DARK_AURA, $GC_UAI_EFFECT_TimeRemaining) > 5000 Then Return False
	Return True
EndFunc
Func BestTarget_DarkAura($a_f_AggroRange)
	Return UAI_GetPlayerInfo($GC_UAI_AGENT_ID)
EndFunc
Func CanUse_BloodIsPower()
	If Anti_Enchantment() Then Return False
	Return True
EndFunc
Func BestTarget_BloodIsPower($a_f_AggroRange)
	Local $l_i_Target = UAI_GetNearestAgent(-2, $a_f_AggroRange, "UAI_Filter_IsLivingAlly|UAI_Filter_ExcludeMe")
	If $l_i_Target <> 0 Then Return $l_i_Target
	Return UAI_GetPlayerInfo($GC_UAI_AGENT_ID)
EndFunc
Func CanUse_DemonicFlesh()
	If Anti_Enchantment() Then Return False
	Return True
EndFunc
Func BestTarget_DemonicFlesh($a_f_AggroRange)
	Return UAI_GetPlayerInfo($GC_UAI_AGENT_ID)
EndFunc
Func CanUse_OrderOfPain()
	If Anti_Enchantment() Then Return False
	Return True
EndFunc
Func BestTarget_OrderOfPain($a_f_AggroRange)
	Return UAI_GetPlayerInfo($GC_UAI_AGENT_ID)
EndFunc
Func CanUse_DarkBond()
	If Anti_Enchantment() Then Return False
	Return True
EndFunc
Func BestTarget_DarkBond($a_f_AggroRange)
	Return UAI_GetPlayerInfo($GC_UAI_AGENT_ID)
EndFunc
Func CanUse_InfuseCondition()
	If Anti_Enchantment() Then Return False
	Return True
EndFunc
Func BestTarget_InfuseCondition($a_f_AggroRange)
	Return UAI_GetPlayerInfo($GC_UAI_AGENT_ID)
EndFunc
Func CanUse_DarkFury()
	If Anti_Enchantment() Then Return False
	Return True
EndFunc
Func BestTarget_DarkFury($a_f_AggroRange)
	Return UAI_GetPlayerInfo($GC_UAI_AGENT_ID)
EndFunc
Func CanUse_OrderOfTheVampire()
	If Anti_Enchantment() Then Return False
	Return True
EndFunc
Func BestTarget_OrderOfTheVampire($a_f_AggroRange)
	Return UAI_GetPlayerInfo($GC_UAI_AGENT_ID)
EndFunc
Func CanUse_BloodRitual()
	If Anti_Enchantment() Then Return False
	Return True
EndFunc
Func BestTarget_BloodRitual($a_f_AggroRange)
	Local $l_i_Target = UAI_GetNearestAgent(-2, $a_f_AggroRange, "UAI_Filter_IsLivingAlly|UAI_Filter_ExcludeMe")
	If $l_i_Target <> 0 Then Return $l_i_Target
	Return UAI_GetPlayerInfo($GC_UAI_AGENT_ID)
EndFunc
Func CanUse_WindborneSpeed()
	If Anti_Enchantment() Then Return False
	Return True
EndFunc
Func BestTarget_WindborneSpeed($a_f_AggroRange)
	Local $l_i_Target = UAI_GetNearestAgent(-2, $a_f_AggroRange, "UAI_Filter_IsLivingAlly|UAI_Filter_ExcludeMe")
	If $l_i_Target <> 0 Then Return $l_i_Target
	Return UAI_GetPlayerInfo($GC_UAI_AGENT_ID)
EndFunc
Func CanUse_ElementalAttunement()
	If Anti_Enchantment() Then Return False
	Return True
EndFunc
Func BestTarget_ElementalAttunement($a_f_AggroRange)
	Return UAI_GetPlayerInfo($GC_UAI_AGENT_ID)
EndFunc
Func CanUse_ArmorOfEarth()
	If Anti_Enchantment() Then Return False
	Return True
EndFunc
Func BestTarget_ArmorOfEarth($a_f_AggroRange)
	Return UAI_GetPlayerInfo($GC_UAI_AGENT_ID)
EndFunc
Func CanUse_KineticArmor()
	If Anti_Enchantment() Then Return False
	Return True
EndFunc
Func BestTarget_KineticArmor($a_f_AggroRange)
	Return UAI_GetPlayerInfo($GC_UAI_AGENT_ID)
EndFunc
Func CanUse_MagneticAura()
	If Anti_Enchantment() Then Return False
	Return True
EndFunc
Func BestTarget_MagneticAura($a_f_AggroRange)
	Return UAI_GetPlayerInfo($GC_UAI_AGENT_ID)
EndFunc
Func CanUse_EarthAttunement()
	If Anti_Enchantment() Then Return False
	Return True
EndFunc
Func BestTarget_EarthAttunement($a_f_AggroRange)
	Return UAI_GetPlayerInfo($GC_UAI_AGENT_ID)
EndFunc
Func CanUse_EtherProdigy()
	If Anti_Enchantment() Then Return False
	Return True
EndFunc
Func BestTarget_EtherProdigy($a_f_AggroRange)
	Return UAI_GetPlayerInfo($GC_UAI_AGENT_ID)
EndFunc
Func CanUse_AuraOfRestoration()
	If Anti_Enchantment() Then Return False
	Return True
EndFunc
Func BestTarget_AuraOfRestoration($a_f_AggroRange)
	Return UAI_GetPlayerInfo($GC_UAI_AGENT_ID)
EndFunc
Func CanUse_EtherRenewal()
	If Anti_Enchantment() Then Return False
	Return True
EndFunc
Func BestTarget_EtherRenewal($a_f_AggroRange)
	Return UAI_GetPlayerInfo($GC_UAI_AGENT_ID)
EndFunc
Func CanUse_ConjureFlame()
	If Anti_Enchantment() Then Return False
	Return True
EndFunc
Func BestTarget_ConjureFlame($a_f_AggroRange)
	Return UAI_GetPlayerInfo($GC_UAI_AGENT_ID)
EndFunc
Func CanUse_FireAttunement()
	If Anti_Enchantment() Then Return False
	Return True
EndFunc
Func BestTarget_FireAttunement($a_f_AggroRange)
	Return UAI_GetPlayerInfo($GC_UAI_AGENT_ID)
EndFunc
Func CanUse_ArmorOfFrost()
	If Anti_Enchantment() Then Return False
	Return True
EndFunc
Func BestTarget_ArmorOfFrost($a_f_AggroRange)
	Return UAI_GetPlayerInfo($GC_UAI_AGENT_ID)
EndFunc
Func CanUse_ConjureFrost()
	If Anti_Enchantment() Then Return False
	Return True
EndFunc
Func BestTarget_ConjureFrost($a_f_AggroRange)
	Return UAI_GetPlayerInfo($GC_UAI_AGENT_ID)
EndFunc
Func CanUse_WaterAttunement()
	If Anti_Enchantment() Then Return False
	Return True
EndFunc
Func BestTarget_WaterAttunement($a_f_AggroRange)
	Return UAI_GetPlayerInfo($GC_UAI_AGENT_ID)
EndFunc
Func CanUse_IceSpear()
	If Anti_Enchantment() Then Return False
	Return True
EndFunc
Func BestTarget_IceSpear($a_f_AggroRange)
	Return UAI_GetNearestAgent(-2, $a_f_AggroRange, "UAI_Filter_IsLivingEnemy")
EndFunc
Func CanUse_IronMist()
	If Anti_Enchantment() Then Return False
	Return True
EndFunc
Func BestTarget_IronMist($a_f_AggroRange)
	Return UAI_GetPlayerInfo($GC_UAI_AGENT_ID)
EndFunc
Func CanUse_ObsidianFlesh()
	If Anti_Enchantment() Then Return False
	Return True
EndFunc
Func BestTarget_ObsidianFlesh($a_f_AggroRange)
	Return UAI_GetPlayerInfo($GC_UAI_AGENT_ID)
EndFunc
Func CanUse_ConjureLightning()
	If Anti_Enchantment() Then Return False
	Return True
EndFunc
Func BestTarget_ConjureLightning($a_f_AggroRange)
	Return UAI_GetPlayerInfo($GC_UAI_AGENT_ID)
EndFunc
Func CanUse_AirAttunement()
	If Anti_Enchantment() Then Return False
	Return True
EndFunc
Func BestTarget_AirAttunement($a_f_AggroRange)
	Return UAI_GetPlayerInfo($GC_UAI_AGENT_ID)
EndFunc
Func CanUse_SwirlingAura()
	If Anti_Enchantment() Then Return False
	Return True
EndFunc
Func BestTarget_SwirlingAura($a_f_AggroRange)
	Return UAI_GetPlayerInfo($GC_UAI_AGENT_ID)
EndFunc
Func CanUse_MistForm()
	If Anti_Enchantment() Then Return False
	Return True
EndFunc
Func BestTarget_MistForm($a_f_AggroRange)
	Return UAI_GetPlayerInfo($GC_UAI_AGENT_ID)
EndFunc
Func CanUse_ArmorOfMist()
	If Anti_Enchantment() Then Return False
	Return True
EndFunc
Func BestTarget_ArmorOfMist($a_f_AggroRange)
	Return UAI_GetPlayerInfo($GC_UAI_AGENT_ID)
EndFunc
Func CanUse_LifeBond()
	If Anti_Enchantment() Then Return False
	Return True
EndFunc
Func BestTarget_LifeBond($a_f_AggroRange)
	Local $l_i_Target = UAI_GetNearestAgent(-2, $a_f_AggroRange, "UAI_Filter_IsLivingAlly|UAI_Filter_ExcludeMe")
	If $l_i_Target <> 0 Then Return $l_i_Target
	Return UAI_GetPlayerInfo($GC_UAI_AGENT_ID)
EndFunc
Func CanUse_BalthazarsSpirit()
	If Anti_Enchantment() Then Return False
	Return True
EndFunc
Func BestTarget_BalthazarsSpirit($a_f_AggroRange)
	Local $l_i_Target = UAI_GetNearestAgent(-2, $a_f_AggroRange, "UAI_Filter_IsLivingAlly|UAI_Filter_ExcludeMe")
	If $l_i_Target <> 0 Then Return $l_i_Target
	Return UAI_GetPlayerInfo($GC_UAI_AGENT_ID)
EndFunc
Func CanUse_StrengthOfHonor()
	If Anti_Enchantment() Then Return False
	Return True
EndFunc
Func BestTarget_StrengthOfHonor($a_f_AggroRange)
	Local $l_i_Target = UAI_GetNearestAgent(-2, $a_f_AggroRange, "UAI_Filter_IsLivingAlly|UAI_Filter_ExcludeMe")
	If $l_i_Target <> 0 Then Return $l_i_Target
	Return UAI_GetPlayerInfo($GC_UAI_AGENT_ID)
EndFunc
Func CanUse_LifeAttunement()
	If Anti_Enchantment() Then Return False
	Return True
EndFunc
Func BestTarget_LifeAttunement($a_f_AggroRange)
	Local $l_i_Target = UAI_GetNearestAgent(-2, $a_f_AggroRange, "UAI_Filter_IsLivingAlly|UAI_Filter_ExcludeMe")
	If $l_i_Target <> 0 Then Return $l_i_Target
	Return UAI_GetPlayerInfo($GC_UAI_AGENT_ID)
EndFunc
Func CanUse_ProtectiveSpirit()
	If Anti_Enchantment() Then Return False
	Return True
EndFunc
Func BestTarget_ProtectiveSpirit($a_f_AggroRange)
	Local $l_i_Target = UAI_GetAgentLowest(-2, $a_f_AggroRange, $GC_UAI_AGENT_HP, "UAI_Filter_IsLivingAlly|UAI_Filter_ExcludeMe")
	If $l_i_Target <> 0 Then Return $l_i_Target
	Return UAI_GetPlayerInfo($GC_UAI_AGENT_ID)
EndFunc
Func CanUse_DivineIntervention()
	If Anti_Enchantment() Then Return False
	Return True
EndFunc
Func BestTarget_DivineIntervention($a_f_AggroRange)
	Local $l_i_Target = UAI_GetAgentLowest(-2, $a_f_AggroRange, $GC_UAI_AGENT_HP, "UAI_Filter_IsLivingAlly|UAI_Filter_ExcludeMe")
	If $l_i_Target <> 0 Then Return $l_i_Target
	Return UAI_GetPlayerInfo($GC_UAI_AGENT_ID)
EndFunc
Func CanUse_Retribution()
	If Anti_Enchantment() Then Return False
	Return True
EndFunc
Func BestTarget_Retribution($a_f_AggroRange)
	Local $l_i_Target = UAI_GetAgentLowest(-2, $a_f_AggroRange, $GC_UAI_AGENT_HP, "UAI_Filter_IsLivingAlly|UAI_Filter_ExcludeMe")
	If $l_i_Target <> 0 Then Return $l_i_Target
	Return UAI_GetPlayerInfo($GC_UAI_AGENT_ID)
EndFunc
Func CanUse_HolyWrath()
	If Anti_Enchantment() Then Return False
	Return True
EndFunc
Func BestTarget_HolyWrath($a_f_AggroRange)
	Local $l_i_Target = UAI_GetAgentLowest(-2, $a_f_AggroRange, $GC_UAI_AGENT_HP, "UAI_Filter_IsLivingAlly|UAI_Filter_ExcludeMe")
	If $l_i_Target <> 0 Then Return $l_i_Target
	Return UAI_GetPlayerInfo($GC_UAI_AGENT_ID)
EndFunc
Func CanUse_EssenceBond()
	If Anti_Enchantment() Then Return False
	Return True
EndFunc
Func BestTarget_EssenceBond($a_f_AggroRange)
	Local $l_i_Target = UAI_GetAgentLowest(-2, $a_f_AggroRange, $GC_UAI_AGENT_HP, "UAI_Filter_IsLivingAlly|UAI_Filter_ExcludeMe")
	If $l_i_Target <> 0 Then Return $l_i_Target
	Return UAI_GetPlayerInfo($GC_UAI_AGENT_ID)
EndFunc
Func CanUse_VigorousSpirit()
	If Anti_Enchantment() Then Return False
	Return True
EndFunc
Func BestTarget_VigorousSpirit($a_f_AggroRange)
	Local $l_i_Target = UAI_GetAgentLowest(-2, $a_f_AggroRange, $GC_UAI_AGENT_HP, "UAI_Filter_IsLivingAlly|UAI_Filter_ExcludeMe")
	If $l_i_Target <> 0 Then Return $l_i_Target
	Return UAI_GetPlayerInfo($GC_UAI_AGENT_ID)
EndFunc
Func CanUse_WatchfulSpirit()
	If Anti_Enchantment() Then Return False
	Return True
EndFunc
Func BestTarget_WatchfulSpirit($a_f_AggroRange)
	Local $l_i_Target = UAI_GetAgentLowest(-2, $a_f_AggroRange, $GC_UAI_AGENT_HP, "UAI_Filter_IsLivingAlly|UAI_Filter_ExcludeMe")
	If $l_i_Target <> 0 Then Return $l_i_Target
	Return UAI_GetPlayerInfo($GC_UAI_AGENT_ID)
EndFunc
Func CanUse_BlessedAura()
	If Anti_Enchantment() Then Return False
	Return True
EndFunc
Func BestTarget_BlessedAura($a_f_AggroRange)
	Return UAI_GetPlayerInfo($GC_UAI_AGENT_ID)
EndFunc
Func CanUse_Aegis()
	If Anti_Enchantment() Then Return False
	Return True
EndFunc
Func BestTarget_Aegis($a_f_AggroRange)
	Return UAI_GetPlayerInfo($GC_UAI_AGENT_ID)
EndFunc
Func CanUse_Guardian()
	If Anti_Enchantment() Then Return False
	Return True
EndFunc
Func BestTarget_Guardian($a_f_AggroRange)
	Local $l_i_Target = UAI_GetAgentLowest(-2, $a_f_AggroRange, $GC_UAI_AGENT_HP, "UAI_Filter_IsLivingAlly|UAI_Filter_ExcludeMe")
	If $l_i_Target <> 0 Then Return $l_i_Target
	Return UAI_GetPlayerInfo($GC_UAI_AGENT_ID)
EndFunc
Func CanUse_ShieldOfDeflection()
	If Anti_Enchantment() Then Return False
	Return True
EndFunc
Func BestTarget_ShieldOfDeflection($a_f_AggroRange)
	Local $l_i_Target = UAI_GetAgentLowest(-2, $a_f_AggroRange, $GC_UAI_AGENT_HP, "UAI_Filter_IsLivingAlly|UAI_Filter_ExcludeMe")
	If $l_i_Target <> 0 Then Return $l_i_Target
	Return UAI_GetPlayerInfo($GC_UAI_AGENT_ID)
EndFunc
Func CanUse_AuraOfFaith()
	If Anti_Enchantment() Then Return False
	Return True
EndFunc
Func BestTarget_AuraOfFaith($a_f_AggroRange)
	Local $l_i_Target = UAI_GetAgentLowest(-2, $a_f_AggroRange, $GC_UAI_AGENT_HP, "UAI_Filter_IsLivingAlly|UAI_Filter_ExcludeMe")
	If $l_i_Target <> 0 Then Return $l_i_Target
	Return UAI_GetPlayerInfo($GC_UAI_AGENT_ID)
EndFunc
Func CanUse_ShieldOfRegeneration()
	If Anti_Enchantment() Then Return False
	Return True
EndFunc
Func BestTarget_ShieldOfRegeneration($a_f_AggroRange)
	Local $l_i_Target = UAI_GetAgentLowest(-2, $a_f_AggroRange, $GC_UAI_AGENT_HP, "UAI_Filter_IsLivingAlly|UAI_Filter_ExcludeMe")
	If $l_i_Target <> 0 Then Return $l_i_Target
	Return UAI_GetPlayerInfo($GC_UAI_AGENT_ID)
EndFunc
Func CanUse_ShieldOfJudgment()
	If Anti_Enchantment() Then Return False
	Return True
EndFunc
Func BestTarget_ShieldOfJudgment($a_f_AggroRange)
	Local $l_i_Target = UAI_GetAgentLowest(-2, $a_f_AggroRange, $GC_UAI_AGENT_HP, "UAI_Filter_IsLivingAlly|UAI_Filter_ExcludeMe")
	If $l_i_Target <> 0 Then Return $l_i_Target
	Return UAI_GetPlayerInfo($GC_UAI_AGENT_ID)
EndFunc
Func CanUse_ProtectiveBond()
	If Anti_Enchantment() Then Return False
	Return True
EndFunc
Func BestTarget_ProtectiveBond($a_f_AggroRange)
	Local $l_i_Target = UAI_GetAgentLowest(-2, $a_f_AggroRange, $GC_UAI_AGENT_HP, "UAI_Filter_IsLivingAlly|UAI_Filter_ExcludeMe")
	If $l_i_Target <> 0 Then Return $l_i_Target
	Return UAI_GetPlayerInfo($GC_UAI_AGENT_ID)
EndFunc
Func CanUse_PeaceAndHarmony()
	If Anti_Enchantment() Then Return False
	Return True
EndFunc
Func BestTarget_PeaceAndHarmony($a_f_AggroRange)
	Local $l_i_Target = UAI_GetAgentLowest(-2, $a_f_AggroRange, $GC_UAI_AGENT_HP, "UAI_Filter_IsLivingAlly|UAI_Filter_IsConditioned|UAI_Filter_IsHexed")
	If $l_i_Target <> 0 Then Return $l_i_Target
	$l_i_Target = UAI_GetAgentLowest(-2, $a_f_AggroRange, $GC_UAI_AGENT_HP, "UAI_Filter_IsLivingAlly|UAI_Filter_IsHexed")
	If $l_i_Target <> 0 Then Return $l_i_Target
	$l_i_Target = UAI_GetAgentLowest(-2, $a_f_AggroRange, $GC_UAI_AGENT_HP, "UAI_Filter_IsLivingAlly|UAI_Filter_IsConditioned")
	If $l_i_Target <> 0 And UAI_GetAgentInfoByID($l_i_Target, $GC_UAI_AGENT_HP) < 0.5 Then Return $l_i_Target
	$l_i_Target = UAI_GetAgentLowest(-2, $a_f_AggroRange, $GC_UAI_AGENT_HP, "UAI_Filter_IsLivingAlly|UAI_Filter_ExcludeMe")
	If $l_i_Target <> 0 Then Return $l_i_Target
	Return UAI_GetPlayerInfo($GC_UAI_AGENT_ID)
EndFunc
Func CanUse_JudgesInsight()
	If Anti_Enchantment() Then Return False
	Return True
EndFunc
Func BestTarget_JudgesInsight($a_f_AggroRange)
	Return UAI_GetPlayerInfo($GC_UAI_AGENT_ID)
EndFunc
Func CanUse_UnyieldingAura()
	If Anti_Enchantment() Then Return False
	Return True
EndFunc
Func BestTarget_UnyieldingAura($a_f_AggroRange)
	Return UAI_GetPlayerInfo($GC_UAI_AGENT_ID)
EndFunc
Func CanUse_MarkOfProtection()
	If Anti_Enchantment() Then Return False
	Return True
EndFunc
Func BestTarget_MarkOfProtection($a_f_AggroRange)
	Local $l_i_Target = UAI_GetAgentLowest(-2, $a_f_AggroRange, $GC_UAI_AGENT_HP, "UAI_Filter_IsLivingAlly|UAI_Filter_ExcludeMe")
	If $l_i_Target <> 0 Then Return $l_i_Target
	Return UAI_GetPlayerInfo($GC_UAI_AGENT_ID)
EndFunc
Func CanUse_LifeBarrier()
	If Anti_Enchantment() Then Return False
	Return True
EndFunc
Func BestTarget_LifeBarrier($a_f_AggroRange)
	Local $l_i_Target = UAI_GetNearestAgent(-2, $a_f_AggroRange, "UAI_Filter_IsLivingAlly|UAI_Filter_ExcludeMe")
	If $l_i_Target <> 0 Then Return $l_i_Target
	Return UAI_GetPlayerInfo($GC_UAI_AGENT_ID)
EndFunc
Func CanUse_ZealotsFire()
	If Anti_Enchantment() Then Return False
	Return True
EndFunc
Func BestTarget_ZealotsFire($a_f_AggroRange)
	Return UAI_GetPlayerInfo($GC_UAI_AGENT_ID)
EndFunc
Func CanUse_BalthazarsAura()
	If Anti_Enchantment() Then Return False
	Return True
EndFunc
Func BestTarget_BalthazarsAura($a_f_AggroRange)
	Return UAI_GetPlayerInfo($GC_UAI_AGENT_ID)
EndFunc
Func CanUse_SpellBreaker()
	If Anti_Enchantment() Then Return False
	Return True
EndFunc
Func BestTarget_SpellBreaker($a_f_AggroRange)
	Local $l_i_Target = UAI_GetNearestAgent(-2, $a_f_AggroRange, "UAI_Filter_IsLivingAlly|UAI_Filter_ExcludeMe")
	If $l_i_Target <> 0 Then Return $l_i_Target
	Return UAI_GetPlayerInfo($GC_UAI_AGENT_ID)
EndFunc
Func CanUse_HealingSeed()
	If Anti_Enchantment() Then Return False
	Return True
EndFunc
Func BestTarget_HealingSeed($a_f_AggroRange)
	Local $l_i_Target = UAI_GetNearestAgent(-2, $a_f_AggroRange, "UAI_Filter_IsLivingAlly|UAI_Filter_ExcludeMe")
	If $l_i_Target <> 0 Then Return $l_i_Target
	Return UAI_GetPlayerInfo($GC_UAI_AGENT_ID)
EndFunc
Func CanUse_DivineBoon()
	If Anti_Enchantment() Then Return False
	Return True
EndFunc
Func BestTarget_DivineBoon($a_f_AggroRange)
	Return UAI_GetPlayerInfo($GC_UAI_AGENT_ID)
EndFunc
Func CanUse_HealingHands()
	If Anti_Enchantment() Then Return False
	Return True
EndFunc
Func BestTarget_HealingHands($a_f_AggroRange)
	Local $l_i_Target = UAI_GetAgentLowest(-2, $a_f_AggroRange, $GC_UAI_AGENT_HP, "UAI_Filter_IsLivingAlly|UAI_Filter_ExcludeMe")
	If $l_i_Target <> 0 Then Return $l_i_Target
	Return UAI_GetPlayerInfo($GC_UAI_AGENT_ID)
EndFunc
Func CanUse_HealingBreeze()
	If Anti_Enchantment() Then Return False
	If UAI_GetAgentInfoByID($g_i_BestTarget, $GC_UAI_AGENT_HP) > 0.8 Then Return False
	Return True
EndFunc
Func BestTarget_HealingBreeze($a_f_AggroRange)
	Return UAI_GetAgentLowest(-2, $a_f_AggroRange, $GC_UAI_AGENT_HP, "UAI_Filter_IsLivingAlly")
EndFunc
Func CanUse_VitalBlessing()
	If Anti_Enchantment() Then Return False
	Return True
EndFunc
Func BestTarget_VitalBlessing($a_f_AggroRange)
	Local $l_i_Target = UAI_GetAgentLowest(-2, $a_f_AggroRange, $GC_UAI_AGENT_HP, "UAI_Filter_IsLivingAlly|UAI_Filter_ExcludeMe")
	If $l_i_Target <> 0 Then Return $l_i_Target
	Return UAI_GetPlayerInfo($GC_UAI_AGENT_ID)
EndFunc
Func CanUse_Mending()
	If Anti_Enchantment() Then Return False
	Return True
EndFunc
Func BestTarget_Mending($a_f_AggroRange)
	Local $l_i_Target = UAI_GetAgentLowest(-2, $a_f_AggroRange, $GC_UAI_AGENT_HP, "UAI_Filter_IsLivingAlly|UAI_Filter_ExcludeMe")
	If $l_i_Target <> 0 Then Return $l_i_Target
	Return UAI_GetPlayerInfo($GC_UAI_AGENT_ID)
EndFunc
Func CanUse_LiveVicariously()
	If Anti_Enchantment() Then Return False
	Return True
EndFunc
Func BestTarget_LiveVicariously($a_f_AggroRange)
	Local $l_i_Target = UAI_GetNearestAgent(-2, $a_f_AggroRange, "UAI_Filter_IsLivingAlly|UAI_Filter_ExcludeMe")
	If $l_i_Target <> 0 Then Return $l_i_Target
	Return UAI_GetPlayerInfo($GC_UAI_AGENT_ID)
EndFunc
Func CanUse_ShieldingHands()
	If Anti_Enchantment() Then Return False
	Return True
EndFunc
Func BestTarget_ShieldingHands($a_f_AggroRange)
	Local $l_i_Target = UAI_GetAgentLowest(-2, $a_f_AggroRange, $GC_UAI_AGENT_HP, "UAI_Filter_IsLivingAlly|UAI_Filter_ExcludeMe")
	If $l_i_Target <> 0 Then Return $l_i_Target
	Return UAI_GetPlayerInfo($GC_UAI_AGENT_ID)
EndFunc
Func CanUse_ReversalOfFortune()
	If Anti_Enchantment() Then Return False
	Return True
EndFunc
Func BestTarget_ReversalOfFortune($a_f_AggroRange)
	Local $l_i_Target = UAI_GetAgentLowest(-2, $a_f_AggroRange, $GC_UAI_AGENT_HP, "UAI_Filter_IsLivingAlly|UAI_Filter_ExcludeMe")
	If $l_i_Target <> 0 Then Return $l_i_Target
	Return UAI_GetPlayerInfo($GC_UAI_AGENT_ID)
EndFunc
Func CanUse_Succor()
	If Anti_Enchantment() Then Return False
	Return True
EndFunc
Func BestTarget_Succor($a_f_AggroRange)
	Local $l_i_Target = UAI_GetNearestAgent(-2, $a_f_AggroRange, "UAI_Filter_IsLivingAlly|UAI_Filter_ExcludeMe")
	If $l_i_Target <> 0 Then Return $l_i_Target
	Return UAI_GetPlayerInfo($GC_UAI_AGENT_ID)
EndFunc
Func CanUse_HolyVeil()
	If Anti_Enchantment() Then Return False
	Return True
EndFunc
Func BestTarget_HolyVeil($a_f_AggroRange)
	Local $l_i_Target = UAI_GetNearestAgent(-2, $a_f_AggroRange, "UAI_Filter_IsLivingAlly|UAI_Filter_IsHexed")
	If $l_i_Target <> 0 Then Return $l_i_Target
	$l_i_Target = UAI_GetNearestAgent(-2, $a_f_AggroRange, "UAI_Filter_IsLivingAlly|UAI_Filter_ExcludeMe")
	If $l_i_Target <> 0 Then Return $l_i_Target
	Return UAI_GetPlayerInfo($GC_UAI_AGENT_ID)
EndFunc
Func CanUse_DivineSpirit()
	If Anti_Enchantment() Then Return False
	Return True
EndFunc
Func BestTarget_DivineSpirit($a_f_AggroRange)
	Return UAI_GetPlayerInfo($GC_UAI_AGENT_ID)
EndFunc
Func CanUse_Vengeance()
	If Anti_Enchantment() Then Return False
	If UAI_PlayerHasEffect($GC_I_SKILL_ID_CURSE_OF_DHUUM) Or UAI_PlayerHasEffect($GC_I_SKILL_ID_FROZEN_SOIL) Then Return False
	Return True
EndFunc
Func BestTarget_Vengeance($a_f_AggroRange)
	Return UAI_GetPlayerInfo($GC_UAI_AGENT_ID)
EndFunc
Func CanUse_CharrBuff()
	If Anti_Enchantment() Then Return False
	Return True
EndFunc
Func BestTarget_CharrBuff($a_f_AggroRange)
	Return UAI_GetPlayerInfo($GC_UAI_AGENT_ID)
EndFunc
Func CanUse_HealingBreezeAgnarsRage()
	If Anti_Enchantment() Then Return False
	Return True
EndFunc
Func BestTarget_HealingBreezeAgnarsRage($a_f_AggroRange)
	Return UAI_GetAgentLowest(-2, $a_f_AggroRange, $GC_UAI_AGENT_HP, "UAI_Filter_IsLivingAlly")
EndFunc
Func CanUse_DivineFire()
	If Anti_Enchantment() Then Return False
	Return True
EndFunc
Func BestTarget_DivineFire($a_f_AggroRange)
	Return UAI_GetPlayerInfo($GC_UAI_AGENT_ID)
EndFunc
Func CanUse_ChimeraOfIntensity()
	If Anti_Enchantment() Then Return False
	Return True
EndFunc
Func BestTarget_ChimeraOfIntensity($a_f_AggroRange)
	Return UAI_GetPlayerInfo($GC_UAI_AGENT_ID)
EndFunc
Func CanUse_JaundicedGaze()
	If Anti_Enchantment() Then Return False
	Return True
EndFunc
Func BestTarget_JaundicedGaze($a_f_AggroRange)
	Return UAI_GetNearestAgent(-2, $a_f_AggroRange, "UAI_Filter_IsLivingEnemy")
EndFunc
Func CanUse_AuraOfDisplacement()
	If Anti_Enchantment() Then Return False
	Return True
EndFunc
Func BestTarget_AuraOfDisplacement($a_f_AggroRange)
	Return UAI_GetNearestAgent(-2, $a_f_AggroRange, "UAI_Filter_IsLivingEnemy")
EndFunc
Func CanUse_CultistsFervor()
	If Anti_Enchantment() Then Return False
	Return True
EndFunc
Func BestTarget_CultistsFervor($a_f_AggroRange)
	Return UAI_GetPlayerInfo($GC_UAI_AGENT_ID)
EndFunc
Func CanUse_LyssasAura()
	If Anti_Enchantment() Then Return False
	Return True
EndFunc
Func BestTarget_LyssasAura($a_f_AggroRange)
	Return UAI_GetPlayerInfo($GC_UAI_AGENT_ID)
EndFunc
Func CanUse_ShadowRefuge()
	If Anti_Enchantment() Then Return False
	Return True
EndFunc
Func BestTarget_ShadowRefuge($a_f_AggroRange)
	Return UAI_GetPlayerInfo($GC_UAI_AGENT_ID)
EndFunc
Func CanUse_VampiricSpirit()
	If Anti_Enchantment() Then Return False
	Return True
EndFunc
Func BestTarget_VampiricSpirit($a_f_AggroRange)
	Return UAI_GetNearestAgent(-2, $a_f_AggroRange, "UAI_Filter_IsLivingEnemy")
EndFunc
Func CanUse_BurningSpeed()
	If Anti_Enchantment() Then Return False
	Return True
EndFunc
Func BestTarget_BurningSpeed($a_f_AggroRange)
	Return UAI_GetPlayerInfo($GC_UAI_AGENT_ID)
EndFunc
Func CanUse_ShadowForm()
	If Anti_Enchantment() Then Return False
	Return True
EndFunc
Func BestTarget_ShadowForm($a_f_AggroRange)
	Return UAI_GetPlayerInfo($GC_UAI_AGENT_ID)
EndFunc
Func CanUse_VeratasPromise()
	If Anti_Enchantment() Then Return False
	Return True
EndFunc
Func BestTarget_VeratasPromise($a_f_AggroRange)
	Return UAI_GetPlayerInfo($GC_UAI_AGENT_ID)
EndFunc
Func CanUse_BorrowedEnergy()
	If Anti_Enchantment() Then Return False
	Return True
EndFunc
Func BestTarget_BorrowedEnergy($a_f_AggroRange)
	Local $l_i_Target = UAI_GetNearestAgent(-2, $a_f_AggroRange, "UAI_Filter_IsLivingAlly|UAI_Filter_ExcludeMe")
	If $l_i_Target <> 0 Then Return $l_i_Target
	Return UAI_GetPlayerInfo($GC_UAI_AGENT_ID)
EndFunc
Func CanUse_EnergyBoon()
	If Anti_Enchantment() Then Return False
	Return True
EndFunc
Func BestTarget_EnergyBoon($a_f_AggroRange)
	Local $l_i_Target = UAI_GetNearestAgent(-2, $a_f_AggroRange, "UAI_Filter_IsLivingAlly|UAI_Filter_ExcludeMe")
	If $l_i_Target <> 0 Then Return $l_i_Target
	Return UAI_GetPlayerInfo($GC_UAI_AGENT_ID)
EndFunc
Func CanUse_DwaynasSorrow()
	If Anti_Enchantment() Then Return False
	Return True
EndFunc
Func BestTarget_DwaynasSorrow($a_f_AggroRange)
	Return UAI_GetPlayerInfo($GC_UAI_AGENT_ID)
EndFunc
Func CanUse_Gust()
	If Anti_Enchantment() Then Return False
	Return True
EndFunc
Func BestTarget_Gust($a_f_AggroRange)
	Local $l_i_Target = UAI_GetNearestAgent(-2, $a_f_AggroRange, "UAI_Filter_IsLivingAlly|UAI_Filter_ExcludeMe")
	If $l_i_Target <> 0 Then Return $l_i_Target
	Return UAI_GetPlayerInfo($GC_UAI_AGENT_ID)
EndFunc
Func CanUse_ReverseHex()
	If Anti_Enchantment() Then Return False
	Return True
EndFunc
Func BestTarget_ReverseHex($a_f_AggroRange)
	Local $l_i_Target = UAI_GetNearestAgent(-2, $a_f_AggroRange, "UAI_Filter_IsLivingAlly|UAI_Filter_IsHexed")
	If $l_i_Target <> 0 Then Return $l_i_Target
	$l_i_Target = UAI_GetNearestAgent(-2, $a_f_AggroRange, "UAI_Filter_IsLivingAlly|UAI_Filter_ExcludeMe")
	If $l_i_Target <> 0 Then Return $l_i_Target
	Return UAI_GetPlayerInfo($GC_UAI_AGENT_ID)
EndFunc
Func CanUse_OrderOfApostasy()
	If Anti_Enchantment() Then Return False
	Return True
EndFunc
Func BestTarget_OrderOfApostasy($a_f_AggroRange)
	Return UAI_GetPlayerInfo($GC_UAI_AGENT_ID)
EndFunc
Func CanUse_ShieldGuardian()
	If Anti_Enchantment() Then Return False
	Return True
EndFunc
Func BestTarget_ShieldGuardian($a_f_AggroRange)
	Return UAI_GetPlayerInfo($GC_UAI_AGENT_ID)
EndFunc
Func CanUse_RestfulBreeze()
	If Anti_Enchantment() Then Return False
	Return True
EndFunc
Func BestTarget_RestfulBreeze($a_f_AggroRange)
	Local $l_i_Target = UAI_GetNearestAgent(-2, $a_f_AggroRange, "UAI_Filter_IsLivingAlly|UAI_Filter_ExcludeMe")
	If $l_i_Target <> 0 Then Return $l_i_Target
	Return UAI_GetPlayerInfo($GC_UAI_AGENT_ID)
EndFunc
Func CanUse_Recall()
	If Anti_Enchantment() Then Return False
	Return True
EndFunc
Func BestTarget_Recall($a_f_AggroRange)
	Local $l_i_Target = UAI_GetNearestAgent(-2, $a_f_AggroRange, "UAI_Filter_IsLivingAlly|UAI_Filter_ExcludeMe")
	If $l_i_Target <> 0 Then Return $l_i_Target
	Return UAI_GetPlayerInfo($GC_UAI_AGENT_ID)
EndFunc
Func CanUse_SharpenDaggers()
	If Anti_Enchantment() Then Return False
	Return True
EndFunc
Func BestTarget_SharpenDaggers($a_f_AggroRange)
	Return UAI_GetPlayerInfo($GC_UAI_AGENT_ID)
EndFunc
Func CanUse_AuspiciousIncantation()
	If Anti_Enchantment() Then Return False
	Return True
EndFunc
Func BestTarget_AuspiciousIncantation($a_f_AggroRange)
	Return UAI_GetPlayerInfo($GC_UAI_AGENT_ID)
EndFunc
Func CanUse_WayOfTheFox()
	If Anti_Enchantment() Then Return False
	Return True
EndFunc
Func BestTarget_WayOfTheFox($a_f_AggroRange)
	Return UAI_GetPlayerInfo($GC_UAI_AGENT_ID)
EndFunc
Func CanUse_EnergyFont()
	If Anti_Enchantment() Then Return False
	Return True
EndFunc
Func BestTarget_EnergyFont($a_f_AggroRange)
	Return UAI_GetPlayerInfo($GC_UAI_AGENT_ID)
EndFunc
Func CanUse_SpellShield()
	If Anti_Enchantment() Then Return False
	Return True
EndFunc
Func BestTarget_SpellShield($a_f_AggroRange)
	Return UAI_GetPlayerInfo($GC_UAI_AGENT_ID)
EndFunc
Func CanUse_WayOfTheLotus()
	If Anti_Enchantment() Then Return False
	Return True
EndFunc
Func BestTarget_WayOfTheLotus($a_f_AggroRange)
	Return UAI_GetPlayerInfo($GC_UAI_AGENT_ID)
EndFunc
Func CanUse_TorchEnchantment()
	If Anti_Enchantment() Then Return False
	Return True
EndFunc
Func BestTarget_TorchEnchantment($a_f_AggroRange)
	Return UAI_GetPlayerInfo($GC_UAI_AGENT_ID)
EndFunc
Func CanUse_WayOfTheEmptyPalm()
	If Anti_Enchantment() Then Return False
	Return True
EndFunc
Func BestTarget_WayOfTheEmptyPalm($a_f_AggroRange)
	Return UAI_GetPlayerInfo($GC_UAI_AGENT_ID)
EndFunc
Func CanUse_IceFort()
	If Anti_Enchantment() Then Return False
	Return True
EndFunc
Func BestTarget_IceFort($a_f_AggroRange)
	Return UAI_GetPlayerInfo($GC_UAI_AGENT_ID)
EndFunc
Func CanUse_IceBreaker()
	If Anti_Enchantment() Then Return False
	Return True
EndFunc
Func BestTarget_IceBreaker($a_f_AggroRange)
	Return UAI_GetPlayerInfo($GC_UAI_AGENT_ID)
EndFunc
Func CanUse_CriticalDefenses()
	If Anti_Enchantment() Then Return False
	Return True
EndFunc
Func BestTarget_CriticalDefenses($a_f_AggroRange)
	Return UAI_GetPlayerInfo($GC_UAI_AGENT_ID)
EndFunc
Func CanUse_WayOfPerfection()
	If Anti_Enchantment() Then Return False
	Return True
EndFunc
Func BestTarget_WayOfPerfection($a_f_AggroRange)
	Return UAI_GetPlayerInfo($GC_UAI_AGENT_ID)
EndFunc
Func CanUse_DarkApostasy()
	If Anti_Enchantment() Then Return False
	Return True
EndFunc
Func BestTarget_DarkApostasy($a_f_AggroRange)
	Return UAI_GetPlayerInfo($GC_UAI_AGENT_ID)
EndFunc
Func CanUse_LocustsFury()
	If Anti_Enchantment() Then Return False
	Return True
EndFunc
Func BestTarget_LocustsFury($a_f_AggroRange)
	Return UAI_GetPlayerInfo($GC_UAI_AGENT_ID)
EndFunc
Func CanUse_ShroudOfDistress()
	If Anti_Enchantment() Then Return False
	Return True
EndFunc
Func BestTarget_ShroudOfDistress($a_f_AggroRange)
	Return UAI_GetPlayerInfo($GC_UAI_AGENT_ID)
EndFunc
Func CanUse_AncestorsVisage()
	If Anti_Enchantment() Then Return False
	Return True
EndFunc
Func BestTarget_AncestorsVisage($a_f_AggroRange)
	Return UAI_GetPlayerInfo($GC_UAI_AGENT_ID)
EndFunc
Func CanUse_SliverArmor()
	If Anti_Enchantment() Then Return False
	Return True
EndFunc
Func BestTarget_SliverArmor($a_f_AggroRange)
	Return UAI_GetPlayerInfo($GC_UAI_AGENT_ID)
EndFunc
Func CanUse_DoubleDragon()
	If Anti_Enchantment() Then Return False
	Return True
EndFunc
Func BestTarget_DoubleDragon($a_f_AggroRange)
	Local $l_i_Target = UAI_GetNearestAgent(-2, $a_f_AggroRange, "UAI_Filter_IsLivingAlly|UAI_Filter_ExcludeMe")
	If $l_i_Target <> 0 Then Return $l_i_Target
	Return UAI_GetPlayerInfo($GC_UAI_AGENT_ID)
EndFunc
Func CanUse_SpiritBond()
	If Anti_Enchantment() Then Return False
	Return True
EndFunc
Func BestTarget_SpiritBond($a_f_AggroRange)
	Local $l_i_Target = UAI_GetNearestAgent(-2, $a_f_AggroRange, "UAI_Filter_IsLivingAlly|UAI_Filter_ExcludeMe")
	If $l_i_Target <> 0 Then Return $l_i_Target
	Return UAI_GetPlayerInfo($GC_UAI_AGENT_ID)
EndFunc
Func CanUse_AirOfEnchantment()
	If Anti_Enchantment() Then Return False
	Return True
EndFunc
Func BestTarget_AirOfEnchantment($a_f_AggroRange)
	Local $l_i_Target = UAI_GetNearestAgent(-2, $a_f_AggroRange, "UAI_Filter_IsLivingAlly|UAI_Filter_ExcludeMe")
	If $l_i_Target <> 0 Then Return $l_i_Target
	Return UAI_GetPlayerInfo($GC_UAI_AGENT_ID)
EndFunc
Func CanUse_LifeSheath()
	If Anti_Enchantment() Then Return False
	Return True
EndFunc
Func BestTarget_LifeSheath($a_f_AggroRange)
	Local $l_i_Target = UAI_GetNearestAgent(-2, $a_f_AggroRange, "UAI_Filter_IsLivingAlly|UAI_Filter_IsConditioned")
	If $l_i_Target <> 0 Then Return $l_i_Target
	$l_i_Target = UAI_GetNearestAgent(-2, $a_f_AggroRange, "UAI_Filter_IsLivingAlly|UAI_Filter_ExcludeMe")
	If $l_i_Target <> 0 Then Return $l_i_Target
	Return UAI_GetPlayerInfo($GC_UAI_AGENT_ID)
EndFunc
Func CanUse_DemonicAgility()
	If Anti_Enchantment() Then Return False
	Return True
EndFunc
Func BestTarget_DemonicAgility($a_f_AggroRange)
	Return UAI_GetPlayerInfo($GC_UAI_AGENT_ID)
EndFunc
Func CanUse_BlessingOfTheKirin()
	If Anti_Enchantment() Then Return False
	Return True
EndFunc
Func BestTarget_BlessingOfTheKirin($a_f_AggroRange)
	Return UAI_GetPlayerInfo($GC_UAI_AGENT_ID)
EndFunc
Func CanUse_ExplosiveGrowth()
	If Anti_Enchantment() Then Return False
	Return True
EndFunc
Func BestTarget_ExplosiveGrowth($a_f_AggroRange)
	Return UAI_GetPlayerInfo($GC_UAI_AGENT_ID)
EndFunc
Func CanUse_BoonOfCreation()
	If Anti_Enchantment() Then Return False
	Return True
EndFunc
Func BestTarget_BoonOfCreation($a_f_AggroRange)
	Return UAI_GetPlayerInfo($GC_UAI_AGENT_ID)
EndFunc
Func CanUse_SpiritChanneling()
	If Anti_Enchantment() Then Return False
	Return True
EndFunc
Func BestTarget_SpiritChanneling($a_f_AggroRange)
	Return UAI_GetPlayerInfo($GC_UAI_AGENT_ID)
EndFunc
Func CanUse_GhostlyHaste()
	If Anti_Enchantment() Then Return False
	Return True
EndFunc
Func BestTarget_GhostlyHaste($a_f_AggroRange)
	Return UAI_GetPlayerInfo($GC_UAI_AGENT_ID)
EndFunc
Func CanUse_FrigidArmor()
	If Anti_Enchantment() Then Return False
	Return True
EndFunc
Func BestTarget_FrigidArmor($a_f_AggroRange)
	Return UAI_GetPlayerInfo($GC_UAI_AGENT_ID)
EndFunc
Func CanUse_NightmareRefuge()
	If Anti_Enchantment() Then Return False
	Return True
EndFunc
Func BestTarget_NightmareRefuge($a_f_AggroRange)
	Return UAI_GetPlayerInfo($GC_UAI_AGENT_ID)
EndFunc
Func CanUse_SugarRushMedium()
	If Anti_Enchantment() Then Return False
	Return True
EndFunc
Func BestTarget_SugarRushMedium($a_f_AggroRange)
	Return UAI_GetPlayerInfo($GC_UAI_AGENT_ID)
EndFunc
Func CanUse_PersistenceOfMemory()
	If Anti_Enchantment() Then Return False
	Return True
EndFunc
Func BestTarget_PersistenceOfMemory($a_f_AggroRange)
	Return UAI_GetPlayerInfo($GC_UAI_AGENT_ID)
EndFunc
Func CanUse_SymbolicCelerity()
	If Anti_Enchantment() Then Return False
	Return True
EndFunc
Func BestTarget_SymbolicCelerity($a_f_AggroRange)
	Return UAI_GetPlayerInfo($GC_UAI_AGENT_ID)
EndFunc
Func CanUse_JaggedBones()
	If Anti_Enchantment() Then Return False
	Return True
EndFunc
Func BestTarget_JaggedBones($a_f_AggroRange)
	Return UAI_GetPlayerInfo($GC_UAI_AGENT_ID)
EndFunc
Func CanUse_Contagion()
	If Anti_Enchantment() Then Return False
	Return True
EndFunc
Func BestTarget_Contagion($a_f_AggroRange)
	Return UAI_GetPlayerInfo($GC_UAI_AGENT_ID)
EndFunc
Func CanUse_Bloodletting()
	If Anti_Enchantment() Then Return False
	Return True
EndFunc
Func BestTarget_Bloodletting($a_f_AggroRange)
	Return UAI_GetPlayerInfo($GC_UAI_AGENT_ID)
EndFunc
Func CanUse_StormDjinnsHaste()
	If Anti_Enchantment() Then Return False
	Return True
EndFunc
Func BestTarget_StormDjinnsHaste($a_f_AggroRange)
	Return UAI_GetPlayerInfo($GC_UAI_AGENT_ID)
EndFunc
Func CanUse_StoneStriker()
	If Anti_Enchantment() Then Return False
	Return True
EndFunc
Func BestTarget_StoneStriker($a_f_AggroRange)
	Return UAI_GetPlayerInfo($GC_UAI_AGENT_ID)
EndFunc
Func CanUse_StoneSheath()
	If Anti_Enchantment() Then Return False
	Return True
EndFunc
Func BestTarget_StoneSheath($a_f_AggroRange)
	Local $l_i_Target = UAI_GetNearestAgent(-2, $a_f_AggroRange, "UAI_Filter_IsLivingAlly|UAI_Filter_ExcludeMe")
	If $l_i_Target <> 0 Then Return $l_i_Target
	Return UAI_GetPlayerInfo($GC_UAI_AGENT_ID)
EndFunc
Func CanUse_StonefleshAura()
	If Anti_Enchantment() Then Return False
	Return True
EndFunc
Func BestTarget_StonefleshAura($a_f_AggroRange)
	Return UAI_GetPlayerInfo($GC_UAI_AGENT_ID)
EndFunc
Func CanUse_MasterOfMagic()
	If Anti_Enchantment() Then Return False
	Return True
EndFunc
Func BestTarget_MasterOfMagic($a_f_AggroRange)
	Return UAI_GetPlayerInfo($GC_UAI_AGENT_ID)
EndFunc
Func CanUse_FlameDjinnsHaste1()
	If Anti_Enchantment() Then Return False
	Return True
EndFunc
Func BestTarget_FlameDjinnsHaste1($a_f_AggroRange)
	Return UAI_GetPlayerInfo($GC_UAI_AGENT_ID)
EndFunc
Func CanUse_JudgesIntervention()
	If Anti_Enchantment() Then Return False
	Return True
EndFunc
Func BestTarget_JudgesIntervention($a_f_AggroRange)
	Local $l_i_Target = UAI_GetAgentLowest(-2, $a_f_AggroRange, $GC_UAI_AGENT_HP, "UAI_Filter_IsLivingAlly|UAI_Filter_ExcludeMe")
	If $l_i_Target <> 0 Then Return $l_i_Target
	Return UAI_GetPlayerInfo($GC_UAI_AGENT_ID)
EndFunc
Func CanUse_SupportiveSpirit()
	If Anti_Enchantment() Then Return False
	Return True
EndFunc
Func BestTarget_SupportiveSpirit($a_f_AggroRange)
	Local $l_i_Target = UAI_GetNearestAgent(-2, $a_f_AggroRange, "UAI_Filter_IsLivingAlly|UAI_Filter_ExcludeMe")
	If $l_i_Target <> 0 Then Return $l_i_Target
	Return UAI_GetPlayerInfo($GC_UAI_AGENT_ID)
EndFunc
Func CanUse_WatchfulHealing()
	If Anti_Enchantment() Then Return False
	Return True
EndFunc
Func BestTarget_WatchfulHealing($a_f_AggroRange)
	Local $l_i_Target = UAI_GetNearestAgent(-2, $a_f_AggroRange, "UAI_Filter_IsLivingAlly|UAI_Filter_ExcludeMe")
	If $l_i_Target <> 0 Then Return $l_i_Target
	Return UAI_GetPlayerInfo($GC_UAI_AGENT_ID)
EndFunc
Func CanUse_HealersBoon()
	If Anti_Enchantment() Then Return False
	Return True
EndFunc
Func BestTarget_HealersBoon($a_f_AggroRange)
	Return UAI_GetPlayerInfo($GC_UAI_AGENT_ID)
EndFunc
Func CanUse_HealersCovenant()
	If Anti_Enchantment() Then Return False
	Return True
EndFunc
Func BestTarget_HealersCovenant($a_f_AggroRange)
	Return UAI_GetPlayerInfo($GC_UAI_AGENT_ID)
EndFunc
Func CanUse_BalthazarsPendulum()
	If Anti_Enchantment() Then Return False
	Return True
EndFunc
Func BestTarget_BalthazarsPendulum($a_f_AggroRange)
	Return UAI_GetPlayerInfo($GC_UAI_AGENT_ID)
EndFunc
Func CanUse_ShieldOfAbsorption()
	If Anti_Enchantment() Then Return False
	Return True
EndFunc
Func BestTarget_ShieldOfAbsorption($a_f_AggroRange)
	Local $l_i_Target = UAI_GetNearestAgent(-2, $a_f_AggroRange, "UAI_Filter_IsLivingAlly|UAI_Filter_ExcludeMe")
	If $l_i_Target <> 0 Then Return $l_i_Target
	Return UAI_GetPlayerInfo($GC_UAI_AGENT_ID)
EndFunc
Func CanUse_ReversalOfDamage()
	If Anti_Enchantment() Then Return False
	Return True
EndFunc
Func BestTarget_ReversalOfDamage($a_f_AggroRange)
	Local $l_i_Target = UAI_GetAgentLowest(-2, $a_f_AggroRange, $GC_UAI_AGENT_HP, "UAI_Filter_IsLivingAlly|UAI_Filter_ExcludeMe")
	If $l_i_Target <> 0 Then Return $l_i_Target
	Return UAI_GetPlayerInfo($GC_UAI_AGENT_ID)
EndFunc
Func CanUse_AbaddonsConspiracy()
	If Anti_Enchantment() Then Return False
	Return True
EndFunc
Func BestTarget_AbaddonsConspiracy($a_f_AggroRange)
	Return UAI_GetPlayerInfo($GC_UAI_AGENT_ID)
EndFunc
Func CanUse_AbaddonsChosen()
	If Anti_Enchantment() Then Return False
	Return True
EndFunc
Func BestTarget_AbaddonsChosen($a_f_AggroRange)
	Return UAI_GetPlayerInfo($GC_UAI_AGENT_ID)
EndFunc
Func CanUse_SpiritsGift()
	If Anti_Enchantment() Then Return False
	Return True
EndFunc
Func BestTarget_SpiritsGift($a_f_AggroRange)
	Return UAI_GetPlayerInfo($GC_UAI_AGENT_ID)
EndFunc
Func CanUse_RemoveWindPrayersSkill()
	If Anti_Enchantment() Then Return False
	Return True
EndFunc
Func BestTarget_RemoveWindPrayersSkill($a_f_AggroRange)
	Return UAI_GetPlayerInfo($GC_UAI_AGENT_ID)
EndFunc
Func CanUse_GrenthsFingers()
	If Anti_Enchantment() Then Return False
	Return True
EndFunc
Func BestTarget_GrenthsFingers($a_f_AggroRange)
	Return UAI_GetPlayerInfo($GC_UAI_AGENT_ID)
EndFunc
Func CanUse_RemoveBoonOfTheGods()
	If Anti_Enchantment() Then Return False
	Return True
EndFunc
Func BestTarget_RemoveBoonOfTheGods($a_f_AggroRange)
	Return UAI_GetPlayerInfo($GC_UAI_AGENT_ID)
EndFunc
Func CanUse_AuraOfThorns()
	If Anti_Enchantment() Then Return False
	Return True
EndFunc
Func BestTarget_AuraOfThorns($a_f_AggroRange)
	Return UAI_GetPlayerInfo($GC_UAI_AGENT_ID)
EndFunc
Func CanUse_BalthazarsRage()
	If Anti_Enchantment() Then Return False
	Return True
EndFunc
Func BestTarget_BalthazarsRage($a_f_AggroRange)
	Return UAI_GetPlayerInfo($GC_UAI_AGENT_ID)
EndFunc
Func CanUse_DustCloak()
	If Anti_Enchantment() Then Return False
	Return True
EndFunc
Func BestTarget_DustCloak($a_f_AggroRange)
	Return UAI_GetPlayerInfo($GC_UAI_AGENT_ID)
EndFunc
Func CanUse_StaggeringForce()
	If Anti_Enchantment() Then Return False
	If UAI_CountAgents(-2, $GC_I_RANGE_ADJACENT, "UAI_Filter_IsLivingEnemy") <= 1 Then Return False
	Return True
EndFunc
Func BestTarget_StaggeringForce($a_f_AggroRange)
	Return UAI_GetPlayerInfo($GC_UAI_AGENT_ID)
EndFunc
Func CanUse_PiousRenewal()
	If Anti_Enchantment() Then Return False
	Return True
EndFunc
Func BestTarget_PiousRenewal($a_f_AggroRange)
	Return UAI_GetPlayerInfo($GC_UAI_AGENT_ID)
EndFunc
Func CanUse_MirageCloak()
	If Anti_Enchantment() Then Return False
	Return True
EndFunc
Func BestTarget_MirageCloak($a_f_AggroRange)
	Return UAI_GetPlayerInfo($GC_UAI_AGENT_ID)
EndFunc
Func CanUse_RemoveBalthazarsRage()
	If Anti_Enchantment() Then Return False
	Return True
EndFunc
Func BestTarget_RemoveBalthazarsRage($a_f_AggroRange)
	Return UAI_GetPlayerInfo($GC_UAI_AGENT_ID)
EndFunc
Func CanUse_ArcaneZeal()
	If Anti_Enchantment() Then Return False
	Return True
EndFunc
Func BestTarget_ArcaneZeal($a_f_AggroRange)
	Return UAI_GetPlayerInfo($GC_UAI_AGENT_ID)
EndFunc
Func CanUse_MysticVigor()
	If Anti_Enchantment() Then Return False
	Return True
EndFunc
Func BestTarget_MysticVigor($a_f_AggroRange)
	Return UAI_GetPlayerInfo($GC_UAI_AGENT_ID)
EndFunc
Func CanUse_WatchfulIntervention()
	If Anti_Enchantment() Then Return False
	Return True
EndFunc
Func BestTarget_WatchfulIntervention($a_f_AggroRange)
	Local $l_i_Target = UAI_GetAgentLowest(-2, $a_f_AggroRange, $GC_UAI_AGENT_HP, "UAI_Filter_IsLivingAlly|UAI_Filter_ExcludeMe")
	If $l_i_Target <> 0 Then Return $l_i_Target
	Return UAI_GetPlayerInfo($GC_UAI_AGENT_ID)
EndFunc
Func CanUse_VowOfPiety()
	If Anti_Enchantment() Then Return False
	Return True
EndFunc
Func BestTarget_VowOfPiety($a_f_AggroRange)
	Return UAI_GetPlayerInfo($GC_UAI_AGENT_ID)
EndFunc
Func CanUse_VitalBoon()
	If Anti_Enchantment() Then Return False
	Return True
EndFunc
Func BestTarget_VitalBoon($a_f_AggroRange)
	Return UAI_GetPlayerInfo($GC_UAI_AGENT_ID)
EndFunc
Func CanUse_HeartOfHolyFlame()
	If Anti_Enchantment() Then Return False
	Return True
EndFunc
Func BestTarget_HeartOfHolyFlame($a_f_AggroRange)
	Return UAI_GetPlayerInfo($GC_UAI_AGENT_ID)
EndFunc
Func CanUse_FaithfulIntervention()
	If Anti_Enchantment() Then Return False
	Return True
EndFunc
Func BestTarget_FaithfulIntervention($a_f_AggroRange)
	Return UAI_GetPlayerInfo($GC_UAI_AGENT_ID)
EndFunc
Func CanUse_SandShards()
	If Anti_Enchantment() Then Return False
	If UAI_CountAgents(-2, $GC_I_RANGE_ADJACENT, "UAI_Filter_IsLivingEnemy") <= 1 Then Return False
	Return True
EndFunc
Func BestTarget_SandShards($a_f_AggroRange)
	Return UAI_GetPlayerInfo($GC_UAI_AGENT_ID)
EndFunc
Func CanUse_IntimidatingAuraBetaVersion()
	If Anti_Enchantment() Then Return False
	Return True
EndFunc
Func BestTarget_IntimidatingAuraBetaVersion($a_f_AggroRange)
	Return UAI_GetPlayerInfo($GC_UAI_AGENT_ID)
EndFunc
Func CanUse_LyssasHaste()
	If Anti_Enchantment() Then Return False
	Local $l_i_NearestEnemy = UAI_GetNearestAgent(-2, 1320, "UAI_Filter_IsLivingEnemy")
	If UAI_GetAgentInfoByID($l_i_NearestEnemy, $GC_UAI_AGENT_Distance) > $GC_I_RANGE_ADJACENT Then Return False
	Return True
EndFunc
Func BestTarget_LyssasHaste($a_f_AggroRange)
	Return UAI_GetPlayerInfo($GC_UAI_AGENT_ID)
EndFunc
Func CanUse_GuidingHands()
	If Anti_Enchantment() Then Return False
	Return True
EndFunc
Func BestTarget_GuidingHands($a_f_AggroRange)
	Return UAI_GetPlayerInfo($GC_UAI_AGENT_ID)
EndFunc
Func CanUse_FleetingStability()
	If Anti_Enchantment() Then Return False
	Return True
EndFunc
Func BestTarget_FleetingStability($a_f_AggroRange)
	Return UAI_GetPlayerInfo($GC_UAI_AGENT_ID)
EndFunc
Func CanUse_ArmorOfSanctity()
	If Anti_Enchantment() Then Return False
	Return True
EndFunc
Func BestTarget_ArmorOfSanctity($a_f_AggroRange)
	Return UAI_GetPlayerInfo($GC_UAI_AGENT_ID)
EndFunc
Func CanUse_MysticRegeneration()
	If Anti_Enchantment() Then Return False
	If UAI_GetPlayerInfo($GC_UAI_AGENT_HP) >= 0.95 Then Return False
	Return True
EndFunc
Func BestTarget_MysticRegeneration($a_f_AggroRange)
	Return UAI_GetPlayerInfo($GC_UAI_AGENT_ID)
EndFunc
Func CanUse_VowOfSilence()
	If Anti_Enchantment() Then Return False
	Return True
EndFunc
Func BestTarget_VowOfSilence($a_f_AggroRange)
	Return UAI_GetPlayerInfo($GC_UAI_AGENT_ID)
EndFunc
Func CanUse_Meditation()
	If Anti_Enchantment() Then Return False
	Return True
EndFunc
Func BestTarget_Meditation($a_f_AggroRange)
	Return UAI_GetPlayerInfo($GC_UAI_AGENT_ID)
EndFunc
Func CanUse_EremitesZeal()
	If Anti_Enchantment() Then Return False
	If UAI_CountAgents(-2, $GC_I_RANGE_EARSHOT, "UAI_Filter_IsLivingEnemy") <= 0 Then Return False
	Return True
EndFunc
Func BestTarget_EremitesZeal($a_f_AggroRange)
	Return UAI_GetPlayerInfo($GC_UAI_AGENT_ID)
EndFunc
Func CanUse_IntimidatingAura()
	If Anti_Enchantment() Then Return False
	Return True
EndFunc
Func BestTarget_IntimidatingAura($a_f_AggroRange)
	Return UAI_GetPlayerInfo($GC_UAI_AGENT_ID)
EndFunc
Func CanUse_Conviction()
	If Anti_Enchantment() Then Return False
	Return True
EndFunc
Func BestTarget_Conviction($a_f_AggroRange)
	Return UAI_GetPlayerInfo($GC_UAI_AGENT_ID)
EndFunc
Func CanUse_EnchantedHaste()
	If Anti_Enchantment() Then Return False
	Return True
EndFunc
Func BestTarget_EnchantedHaste($a_f_AggroRange)
	Return UAI_GetPlayerInfo($GC_UAI_AGENT_ID)
EndFunc
Func CanUse_WhirlingCharge()
	If Anti_Enchantment() Then Return False
	Return True
EndFunc
Func BestTarget_WhirlingCharge($a_f_AggroRange)
	Return UAI_GetPlayerInfo($GC_UAI_AGENT_ID)
EndFunc
Func CanUse_SugarRushLong()
	If Anti_Enchantment() Then Return False
	Return True
EndFunc
Func BestTarget_SugarRushLong($a_f_AggroRange)
	Return UAI_GetPlayerInfo($GC_UAI_AGENT_ID)
EndFunc
Func CanUse_DeadlyHaste()
	If Anti_Enchantment() Then Return False
	Return True
EndFunc
Func BestTarget_DeadlyHaste($a_f_AggroRange)
	Return UAI_GetPlayerInfo($GC_UAI_AGENT_ID)
EndFunc
Func CanUse_AssassinsRemedy()
	If Anti_Enchantment() Then Return False
	Return True
EndFunc
Func BestTarget_AssassinsRemedy($a_f_AggroRange)
	Return UAI_GetPlayerInfo($GC_UAI_AGENT_ID)
EndFunc
Func CanUse_FoxsPromise()
	If Anti_Enchantment() Then Return False
	Return True
EndFunc
Func BestTarget_FoxsPromise($a_f_AggroRange)
	Return UAI_GetPlayerInfo($GC_UAI_AGENT_ID)
EndFunc
Func CanUse_FeignedNeutrality()
	If Anti_Enchantment() Then Return False
	Return True
EndFunc
Func BestTarget_FeignedNeutrality($a_f_AggroRange)
	Return UAI_GetPlayerInfo($GC_UAI_AGENT_ID)
EndFunc
Func CanUse_ShadowMeld()
	If Anti_Enchantment() Then Return False
	Return True
EndFunc
Func BestTarget_ShadowMeld($a_f_AggroRange)
	Local $l_i_Target = UAI_GetNearestAgent(-2, $a_f_AggroRange, "UAI_Filter_IsLivingAlly|UAI_Filter_ExcludeMe")
	If $l_i_Target <> 0 Then Return $l_i_Target
	Return UAI_GetPlayerInfo($GC_UAI_AGENT_ID)
EndFunc
Func CanUse_ElementalFlame()
	If Anti_Enchantment() Then Return False
	Return True
EndFunc
Func BestTarget_ElementalFlame($a_f_AggroRange)
	Return UAI_GetPlayerInfo($GC_UAI_AGENT_ID)
EndFunc
Func CanUse_PensiveGuardian()
	If Anti_Enchantment() Then Return False
	Return True
EndFunc
Func BestTarget_PensiveGuardian($a_f_AggroRange)
	Local $l_i_Target = UAI_GetNearestAgent(-2, $a_f_AggroRange, "UAI_Filter_IsLivingAlly|UAI_Filter_ExcludeMe")
	If $l_i_Target <> 0 Then Return $l_i_Target
	Return UAI_GetPlayerInfo($GC_UAI_AGENT_ID)
EndFunc
Func CanUse_ScribesInsight()
	If Anti_Enchantment() Then Return False
	Return True
EndFunc
Func BestTarget_ScribesInsight($a_f_AggroRange)
	Return UAI_GetPlayerInfo($GC_UAI_AGENT_ID)
EndFunc
Func CanUse_HolyHaste()
	If Anti_Enchantment() Then Return False
	Return True
EndFunc
Func BestTarget_HolyHaste($a_f_AggroRange)
	Return UAI_GetPlayerInfo($GC_UAI_AGENT_ID)
EndFunc
Func CanUse_SpiritsStrength()
	If Anti_Enchantment() Then Return False
	Return True
EndFunc
Func BestTarget_SpiritsStrength($a_f_AggroRange)
	Return UAI_GetPlayerInfo($GC_UAI_AGENT_ID)
EndFunc
Func CanUse_WieldersZeal()
	If Anti_Enchantment() Then Return False
	Return True
EndFunc
Func BestTarget_WieldersZeal($a_f_AggroRange)
	Return UAI_GetPlayerInfo($GC_UAI_AGENT_ID)
EndFunc
Func CanUse_SightBeyondSight()
	If Anti_Enchantment() Then Return False
	Return True
EndFunc
Func BestTarget_SightBeyondSight($a_f_AggroRange)
	Return UAI_GetPlayerInfo($GC_UAI_AGENT_ID)
EndFunc
Func CanUse_RenewingMemories()
	If Anti_Enchantment() Then Return False
	Return True
EndFunc
Func BestTarget_RenewingMemories($a_f_AggroRange)
	Return UAI_GetPlayerInfo($GC_UAI_AGENT_ID)
EndFunc
Func CanUse_WieldersRemedy()
	If Anti_Enchantment() Then Return False
	Return True
EndFunc
Func BestTarget_WieldersRemedy($a_f_AggroRange)
	Return UAI_GetPlayerInfo($GC_UAI_AGENT_ID)
EndFunc
Func CanUse_Onslaught()
	If Anti_Enchantment() Then Return False
	Return True
EndFunc
Func BestTarget_Onslaught($a_f_AggroRange)
	Return UAI_GetPlayerInfo($GC_UAI_AGENT_ID)
EndFunc
Func CanUse_MysticCorruption()
	If Anti_Enchantment() Then Return False
	Return True
EndFunc
Func BestTarget_MysticCorruption($a_f_AggroRange)
	Return UAI_GetPlayerInfo($GC_UAI_AGENT_ID)
EndFunc
Func CanUse_GrenthsGrasp()
	If Anti_Enchantment() Then Return False
	Return True
EndFunc
Func BestTarget_GrenthsGrasp($a_f_AggroRange)
	Return UAI_GetPlayerInfo($GC_UAI_AGENT_ID)
EndFunc
Func CanUse_VeilOfThorns()
	If Anti_Enchantment() Then Return False
	Return True
EndFunc
Func BestTarget_VeilOfThorns($a_f_AggroRange)
	Return UAI_GetPlayerInfo($GC_UAI_AGENT_ID)
EndFunc
Func CanUse_HarriersGrasp()
	If Anti_Enchantment() Then Return False
	Return True
EndFunc
Func BestTarget_HarriersGrasp($a_f_AggroRange)
	Return UAI_GetPlayerInfo($GC_UAI_AGENT_ID)
EndFunc
Func CanUse_VowOfStrength()
	If Anti_Enchantment() Then Return False
	Local $l_b_SkillSlot = Skill_GetSlotByID($GC_I_SKILL_ID_EXTEND_ENCHANTMENTS)
	Local $l_b_HasEffect = UAI_GetPlayerEffectInfo($GC_I_SKILL_ID_EXTEND_ENCHANTMENTS, $GC_UAI_EFFECT_TimeRemaining) > 500
	If $l_b_SkillSlot > 0 Then
		If Not $l_b_HasEffect Then
			Skill_UseSkill($l_b_SkillSlot)
		EndIf
	EndIf
	Return True
EndFunc
Func BestTarget_VowOfStrength($a_f_AggroRange)
	Return UAI_GetPlayerInfo($GC_UAI_AGENT_ID)
EndFunc
Func CanUse_EbonDustAura()
	If Anti_Enchantment() Then Return False
	Return True
EndFunc
Func BestTarget_EbonDustAura($a_f_AggroRange)
	Return UAI_GetPlayerInfo($GC_UAI_AGENT_ID)
EndFunc
Func CanUse_ZealousVow()
	If Anti_Enchantment() Then Return False
	Return True
EndFunc
Func BestTarget_ZealousVow($a_f_AggroRange)
	Return UAI_GetPlayerInfo($GC_UAI_AGENT_ID)
EndFunc
Func CanUse_ZealousRenewal()
	If Anti_Enchantment() Then Return False
	Return True
EndFunc
Func BestTarget_ZealousRenewal($a_f_AggroRange)
	Return UAI_GetPlayerInfo($GC_UAI_AGENT_ID)
EndFunc
Func CanUse_AttackersInsight()
	If Anti_Enchantment() Then Return False
	Return True
EndFunc
Func BestTarget_AttackersInsight($a_f_AggroRange)
	Return UAI_GetPlayerInfo($GC_UAI_AGENT_ID)
EndFunc
Func CanUse_RendingAura()
	If Anti_Enchantment() Then Return False
	Return True
EndFunc
Func BestTarget_RendingAura($a_f_AggroRange)
	Return UAI_GetPlayerInfo($GC_UAI_AGENT_ID)
EndFunc
Func CanUse_FeatherfootGrace()
	If Anti_Enchantment() Then Return False
	Return True
EndFunc
Func BestTarget_FeatherfootGrace($a_f_AggroRange)
	Return UAI_GetPlayerInfo($GC_UAI_AGENT_ID)
EndFunc
Func CanUse_HarriersHaste()
	If Anti_Enchantment() Then Return False
	Return True
EndFunc
Func BestTarget_HarriersHaste($a_f_AggroRange)
	Return UAI_GetPlayerInfo($GC_UAI_AGENT_ID)
EndFunc
Func CanUse_AcceleratedGrowth()
	If Anti_Enchantment() Then Return False
	Return True
EndFunc
Func BestTarget_AcceleratedGrowth($a_f_AggroRange)
	Return UAI_GetPlayerInfo($GC_UAI_AGENT_ID)
EndFunc
Func CanUse_SpiritFormRemainsOfSahlahja()
	If Anti_Enchantment() Then Return False
	Return True
EndFunc
Func BestTarget_SpiritFormRemainsOfSahlahja($a_f_AggroRange)
	Return UAI_GetPlayerInfo($GC_UAI_AGENT_ID)
EndFunc
Func CanUse_GodsBlessing()
	If Anti_Enchantment() Then Return False
	Return True
EndFunc
Func BestTarget_GodsBlessing($a_f_AggroRange)
	Return UAI_GetPlayerInfo($GC_UAI_AGENT_ID)
EndFunc
Func CanUse_SugarRushShort()
	If Anti_Enchantment() Then Return False
	Return True
EndFunc
Func BestTarget_SugarRushShort($a_f_AggroRange)
	Return UAI_GetPlayerInfo($GC_UAI_AGENT_ID)
EndFunc
Func CanUse_SugarJoltShort()
	If Anti_Enchantment() Then Return False
	Return True
EndFunc
Func BestTarget_SugarJoltShort($a_f_AggroRange)
	Return UAI_GetPlayerInfo($GC_UAI_AGENT_ID)
EndFunc
Func CanUse_SugarJoltLong()
	If Anti_Enchantment() Then Return False
	Return True
EndFunc
Func BestTarget_SugarJoltLong($a_f_AggroRange)
	Return UAI_GetPlayerInfo($GC_UAI_AGENT_ID)
EndFunc
Func CanUse_ShadowSanctuaryLuxon2()
	If Anti_Enchantment() Then Return False
	Return True
EndFunc
Func BestTarget_ShadowSanctuaryLuxon2($a_f_AggroRange)
	Return UAI_GetPlayerInfo($GC_UAI_AGENT_ID)
EndFunc
Func CanUse_ElementalLordLuxon()
	If Anti_Enchantment() Then Return False
	Return True
EndFunc
Func BestTarget_ElementalLordLuxon($a_f_AggroRange)
	Return UAI_GetPlayerInfo($GC_UAI_AGENT_ID)
EndFunc
Func CanUse_SelflessSpiritLuxon()
	If Anti_Enchantment() Then Return False
	Return True
EndFunc
Func BestTarget_SelflessSpiritLuxon($a_f_AggroRange)
	Return UAI_GetPlayerInfo($GC_UAI_AGENT_ID)
EndFunc
Func CanUse_AuraOfHolyMightLuxon()
	If Anti_Enchantment() Then Return False
	If UAI_AgentHasEffect(UAI_GetPlayerInfo($GC_UAI_AGENT_ID), $GC_I_SKILL_ID_PIOUS_RENEWAL) Then Return False
	Return True
EndFunc
Func BestTarget_AuraOfHolyMightLuxon($a_f_AggroRange)
	Return UAI_GetPlayerInfo($GC_UAI_AGENT_ID)
EndFunc
Func CanUse_WayOfTheMantis()
	If Anti_Enchantment() Then Return False
	Return True
EndFunc
Func BestTarget_WayOfTheMantis($a_f_AggroRange)
	Return UAI_GetPlayerInfo($GC_UAI_AGENT_ID)
EndFunc
Func CanUse_WitheringAura()
	If Anti_Enchantment() Then Return False
	Return True
EndFunc
Func BestTarget_WitheringAura($a_f_AggroRange)
	Local $l_i_Target = UAI_GetNearestAgent(-2, $a_f_AggroRange, "UAI_Filter_IsLivingAlly|UAI_Filter_ExcludeMe")
	If $l_i_Target <> 0 Then Return $l_i_Target
	Return UAI_GetPlayerInfo($GC_UAI_AGENT_ID)
EndFunc
Func CanUse_SmitersBoon()
	If Anti_Enchantment() Then Return False
	Return True
EndFunc
Func BestTarget_SmitersBoon($a_f_AggroRange)
	Return UAI_GetPlayerInfo($GC_UAI_AGENT_ID)
EndFunc
Func CanUse_PurifyingVeil()
	If Anti_Enchantment() Then Return False
	Return True
EndFunc
Func BestTarget_PurifyingVeil($a_f_AggroRange)
	Local $l_i_Target = UAI_GetNearestAgent(-2, $a_f_AggroRange, "UAI_Filter_IsLivingAlly|UAI_Filter_IsConditioned")
	If $l_i_Target <> 0 Then Return $l_i_Target
	$l_i_Target = UAI_GetNearestAgent(-2, $a_f_AggroRange, "UAI_Filter_IsLivingAlly|UAI_Filter_ExcludeMe")
	If $l_i_Target <> 0 Then Return $l_i_Target
	Return UAI_GetPlayerInfo($GC_UAI_AGENT_ID)
EndFunc
Func CanUse_GrenthsAura()
	If Anti_Enchantment() Then Return False
	Local $l_i_NearestEnemy = UAI_GetNearestAgent(-2, 1320, "UAI_Filter_IsLivingEnemy")
	If UAI_GetAgentInfoByID($l_i_NearestEnemy, $GC_UAI_AGENT_Distance) > $GC_I_RANGE_ADJACENT Then Return False
	Return True
EndFunc
Func BestTarget_GrenthsAura($a_f_AggroRange)
	Return UAI_GetPlayerInfo($GC_UAI_AGENT_ID)
EndFunc
Func CanUse_PatientSpirit()
	If Anti_Enchantment() Then Return False
	Return True
EndFunc
Func BestTarget_PatientSpirit($a_f_AggroRange)
	Local $l_i_Target = UAI_GetAgentLowest(-2, $a_f_AggroRange, $GC_UAI_AGENT_HP, "UAI_Filter_IsLivingAlly|UAI_Filter_ExcludeMe")
	If $l_i_Target <> 0 Then Return $l_i_Target
	Return UAI_GetPlayerInfo($GC_UAI_AGENT_ID)
EndFunc
Func CanUse_AuraOfStability()
	If Anti_Enchantment() Then Return False
	Return True
EndFunc
Func BestTarget_AuraOfStability($a_f_AggroRange)
	Local $l_i_Target = UAI_GetNearestAgent(-2, $a_f_AggroRange, "UAI_Filter_IsLivingAlly|UAI_Filter_ExcludeMe")
	If $l_i_Target <> 0 Then Return $l_i_Target
	Return UAI_GetPlayerInfo($GC_UAI_AGENT_ID)
EndFunc
Func CanUse_SpotlessMind()
	If Anti_Enchantment() Then Return False
	Return True
EndFunc
Func BestTarget_SpotlessMind($a_f_AggroRange)
	Local $l_i_Target = UAI_GetNearestAgent(-2, $a_f_AggroRange, "UAI_Filter_IsLivingAlly|UAI_Filter_IsHexed")
	If $l_i_Target <> 0 Then Return $l_i_Target
	$l_i_Target = UAI_GetNearestAgent(-2, $a_f_AggroRange, "UAI_Filter_IsLivingAlly|UAI_Filter_ExcludeMe")
	If $l_i_Target <> 0 Then Return $l_i_Target
	Return UAI_GetPlayerInfo($GC_UAI_AGENT_ID)
EndFunc
Func CanUse_SpotlessSoul()
	If Anti_Enchantment() Then Return False
	Return True
EndFunc
Func BestTarget_SpotlessSoul($a_f_AggroRange)
	Local $l_i_Target = UAI_GetNearestAgent(-2, $a_f_AggroRange, "UAI_Filter_IsLivingAlly|UAI_Filter_IsConditioned")
	If $l_i_Target <> 0 Then Return $l_i_Target
	$l_i_Target = UAI_GetNearestAgent(-2, $a_f_AggroRange, "UAI_Filter_IsLivingAlly|UAI_Filter_ExcludeMe")
	If $l_i_Target <> 0 Then Return $l_i_Target
	Return UAI_GetPlayerInfo($GC_UAI_AGENT_ID)
EndFunc
Func CanUse_ShadowSanctuaryKurzick()
	If Anti_Enchantment() Then Return False
	Return True
EndFunc
Func BestTarget_ShadowSanctuaryKurzick($a_f_AggroRange)
	Return UAI_GetPlayerInfo($GC_UAI_AGENT_ID)
EndFunc
Func CanUse_ElementalLordKurzick()
	If Anti_Enchantment() Then Return False
	Return True
EndFunc
Func BestTarget_ElementalLordKurzick($a_f_AggroRange)
	Return UAI_GetPlayerInfo($GC_UAI_AGENT_ID)
EndFunc
Func CanUse_SelflessSpiritKurzick()
	If Anti_Enchantment() Then Return False
	Return True
EndFunc
Func BestTarget_SelflessSpiritKurzick($a_f_AggroRange)
	Return UAI_GetPlayerInfo($GC_UAI_AGENT_ID)
EndFunc
Func CanUse_AuraOfHolyMightKurzick()
	If Anti_Enchantment() Then Return False
	If UAI_AgentHasEffect(UAI_GetPlayerInfo($GC_UAI_AGENT_ID), $GC_I_SKILL_ID_PIOUS_RENEWAL) Then Return False
	Return True
EndFunc
Func BestTarget_AuraOfHolyMightKurzick($a_f_AggroRange)
	Return UAI_GetPlayerInfo($GC_UAI_AGENT_ID)
EndFunc
Func CanUse_CriticalAgility()
	If Anti_Enchantment() Then Return False
	Return True
EndFunc
Func BestTarget_CriticalAgility($a_f_AggroRange)
	Return UAI_GetPlayerInfo($GC_UAI_AGENT_ID)
EndFunc
Func CanUse_SeedOfLife()
	If Anti_Enchantment() Then Return False
	Return True
EndFunc
Func BestTarget_SeedOfLife($a_f_AggroRange)
	Local $l_i_Target = UAI_GetNearestAgent(-2, $a_f_AggroRange, "UAI_Filter_IsLivingAlly|UAI_Filter_ExcludeMe")
	If $l_i_Target <> 0 Then Return $l_i_Target
	Return UAI_GetPlayerInfo($GC_UAI_AGENT_ID)
EndFunc
Func CanUse_EternalAura()
	If Anti_Enchantment() Then Return False
	If UAI_PlayerHasEffect($GC_I_SKILL_ID_CURSE_OF_DHUUM) Or UAI_PlayerHasEffect($GC_I_SKILL_ID_FROZEN_SOIL) Then Return False
	Return True
EndFunc
Func BestTarget_EternalAura($a_f_AggroRange)
	Return UAI_GetPlayerInfo($GC_UAI_AGENT_ID)
EndFunc
Func CanUse_VolfenPounceCurseOfTheNornbear()
	If Anti_Enchantment() Then Return False
	Return True
EndFunc
Func BestTarget_VolfenPounceCurseOfTheNornbear($a_f_AggroRange)
	Return UAI_GetPlayerInfo($GC_UAI_AGENT_ID)
EndFunc
Func CanUse_HexersVigor()
	If Anti_Enchantment() Then Return False
	Return True
EndFunc
Func BestTarget_HexersVigor($a_f_AggroRange)
	Return UAI_GetPlayerInfo($GC_UAI_AGENT_ID)
EndFunc
Func CanUse_Masochism()
	If Anti_Enchantment() Then Return False
	If UAI_GetPlayerEffectInfo($GC_I_SKILL_ID_MASOCHISM, $GC_UAI_EFFECT_TimeRemaining) > 5000 Then Return False
	Return True
EndFunc
Func BestTarget_Masochism($a_f_AggroRange)
	Return UAI_GetPlayerInfo($GC_UAI_AGENT_ID)
EndFunc
Func CanUse_WayOfTheMaster()
	If Anti_Enchantment() Then Return False
	Return True
EndFunc
Func BestTarget_WayOfTheMaster($a_f_AggroRange)
	Return UAI_GetPlayerInfo($GC_UAI_AGENT_ID)
EndFunc
Func CanUse_MagneticSurge()
	If Anti_Enchantment() Then Return False
	Return True
EndFunc
Func BestTarget_MagneticSurge($a_f_AggroRange)
	Return UAI_GetNearestAgent(-2, $a_f_AggroRange, "UAI_Filter_IsLivingEnemy")
EndFunc
Func CanUse_ShieldOfForce()
	If Anti_Enchantment() Then Return False
	Return True
EndFunc
Func BestTarget_ShieldOfForce($a_f_AggroRange)
	Return UAI_GetPlayerInfo($GC_UAI_AGENT_ID)
EndFunc
Func CanUse_GreatDwarfArmor()
	If Anti_Enchantment() Then Return False
	Return True
EndFunc
Func BestTarget_GreatDwarfArmor($a_f_AggroRange)
	Local $l_i_Target = UAI_GetAgentLowest(-2, $a_f_AggroRange, $GC_UAI_AGENT_HP, "UAI_Filter_IsLivingAlly|UAI_Filter_ExcludeMe")
	If $l_i_Target <> 0 Then Return $l_i_Target
	Return UAI_GetPlayerInfo($GC_UAI_AGENT_ID)
EndFunc
Func CanUse_PolymockBlock()
	If Anti_Enchantment() Then Return False
	Return True
EndFunc
Func BestTarget_PolymockBlock($a_f_AggroRange)
	Return UAI_GetPlayerInfo($GC_UAI_AGENT_ID)
EndFunc
Func CanUse_PolymockLightningDjinnsHaste()
	If Anti_Enchantment() Then Return False
	Return True
EndFunc
Func BestTarget_PolymockLightningDjinnsHaste($a_f_AggroRange)
	Return UAI_GetPlayerInfo($GC_UAI_AGENT_ID)
EndFunc
Func CanUse_PolymockFrozenArmor()
	If Anti_Enchantment() Then Return False
	Return True
EndFunc
Func BestTarget_PolymockFrozenArmor($a_f_AggroRange)
	Return UAI_GetPlayerInfo($GC_UAI_AGENT_ID)
EndFunc
Func CanUse_CrystalShield()
	If Anti_Enchantment() Then Return False
	Return True
EndFunc
Func BestTarget_CrystalShield($a_f_AggroRange)
	Return UAI_GetPlayerInfo($GC_UAI_AGENT_ID)
EndFunc
Func CanUse_VolfenAgility()
	If Anti_Enchantment() Then Return False
	Return True
EndFunc
Func BestTarget_VolfenAgility($a_f_AggroRange)
	Return UAI_GetPlayerInfo($GC_UAI_AGENT_ID)
EndFunc
Func CanUse_Mindbender()
	If Anti_Enchantment() Then Return False
	Return True
EndFunc
Func BestTarget_Mindbender($a_f_AggroRange)
	Return UAI_GetPlayerInfo($GC_UAI_AGENT_ID)
EndFunc
Func CanUse_MentalBlock()
	If Anti_Enchantment() Then Return False
	Return True
EndFunc
Func BestTarget_MentalBlock($a_f_AggroRange)
	Return UAI_GetPlayerInfo($GC_UAI_AGENT_ID)
EndFunc
Func CanUse_DwarvenStability()
	If Anti_Enchantment() Then Return False
	Return True
EndFunc
Func BestTarget_DwarvenStability($a_f_AggroRange)
	Return UAI_GetPlayerInfo($GC_UAI_AGENT_ID)
EndFunc
Func CanUse_FlameDjinnsHaste2()
	If Anti_Enchantment() Then Return False
	Return True
EndFunc
Func BestTarget_FlameDjinnsHaste2($a_f_AggroRange)
	Return UAI_GetPlayerInfo($GC_UAI_AGENT_ID)
EndFunc
Func CanUse_DragonEmpireRage()
	If Anti_Enchantment() Then Return False
	Return True
EndFunc
Func BestTarget_DragonEmpireRage($a_f_AggroRange)
	Return UAI_GetPlayerInfo($GC_UAI_AGENT_ID)
EndFunc
Func CanUse_AuraOfPurity()
	If Anti_Enchantment() Then Return False
	Return True
EndFunc
Func BestTarget_AuraOfPurity($a_f_AggroRange)
	Return UAI_GetPlayerInfo($GC_UAI_AGENT_ID)
EndFunc
Func CanUse_MistFormPvP()
	If Anti_Enchantment() Then Return False
	Return True
EndFunc
Func BestTarget_MistFormPvP($a_f_AggroRange)
	Return UAI_GetPlayerInfo($GC_UAI_AGENT_ID)
EndFunc
Func CanUse_AegisPvP()
	If Anti_Enchantment() Then Return False
	Return True
EndFunc
Func BestTarget_AegisPvP($a_f_AggroRange)
	Return UAI_GetPlayerInfo($GC_UAI_AGENT_ID)
EndFunc
Func CanUse_EtherRenewalPvP()
	If Anti_Enchantment() Then Return False
	Return True
EndFunc
Func BestTarget_EtherRenewalPvP($a_f_AggroRange)
	Return UAI_GetPlayerInfo($GC_UAI_AGENT_ID)
EndFunc
Func CanUse_ShadowFormPvP()
	If Anti_Enchantment() Then Return False
	Return True
EndFunc
Func BestTarget_ShadowFormPvP($a_f_AggroRange)
	Return UAI_GetPlayerInfo($GC_UAI_AGENT_ID)
EndFunc
Func CanUse_AssassinsRemedyPvP()
	If Anti_Enchantment() Then Return False
	Return True
EndFunc
Func BestTarget_AssassinsRemedyPvP($a_f_AggroRange)
	Return UAI_GetPlayerInfo($GC_UAI_AGENT_ID)
EndFunc
Func CanUse_MysticRegenerationPvP()
	If Anti_Enchantment() Then Return False
	Return True
EndFunc
Func BestTarget_MysticRegenerationPvP($a_f_AggroRange)
	Return UAI_GetPlayerInfo($GC_UAI_AGENT_ID)
EndFunc
Func CanUse_UnyieldingAuraPvP()
	If Anti_Enchantment() Then Return False
	Return True
EndFunc
Func BestTarget_UnyieldingAuraPvP($a_f_AggroRange)
	Return UAI_GetPlayerInfo($GC_UAI_AGENT_ID)
EndFunc
Func CanUse_SpiritBondPvP()
	If Anti_Enchantment() Then Return False
	Return True
EndFunc
Func BestTarget_SpiritBondPvP($a_f_AggroRange)
	Local $l_i_Target = UAI_GetAgentLowest(-2, $a_f_AggroRange, $GC_UAI_AGENT_HP, "UAI_Filter_IsLivingAlly|UAI_Filter_ExcludeMe")
	If $l_i_Target <> 0 Then Return $l_i_Target
	Return UAI_GetPlayerInfo($GC_UAI_AGENT_ID)
EndFunc
Func CanUse_SmitersBoonPvP()
	If Anti_Enchantment() Then Return False
	Return True
EndFunc
Func BestTarget_SmitersBoonPvP($a_f_AggroRange)
	Return UAI_GetPlayerInfo($GC_UAI_AGENT_ID)
EndFunc
Func CanUse_BitGolemRectifier()
	If Anti_Enchantment() Then Return False
	Return True
EndFunc
Func BestTarget_BitGolemRectifier($a_f_AggroRange)
	Return UAI_GetPlayerInfo($GC_UAI_AGENT_ID)
EndFunc
Func CanUse_StrengthOfHonorPvP()
	If Anti_Enchantment() Then Return False
	Return True
EndFunc
Func BestTarget_StrengthOfHonorPvP($a_f_AggroRange)
	Return UAI_GetPlayerInfo($GC_UAI_AGENT_ID)
EndFunc
Func CanUse_ArmorOfUnfeelingPvP()
	If Anti_Enchantment() Then Return False
	Return True
EndFunc
Func BestTarget_ArmorOfUnfeelingPvP($a_f_AggroRange)
	Return UAI_GetPlayerInfo($GC_UAI_AGENT_ID)
EndFunc
Func CanUse_ShroudOfDistressPvP()
	If Anti_Enchantment() Then Return False
	Return True
EndFunc
Func BestTarget_ShroudOfDistressPvP($a_f_AggroRange)
	Return UAI_GetPlayerInfo($GC_UAI_AGENT_ID)
EndFunc
Func CanUse_MasochismPvP()
	If Anti_Enchantment() Then Return False
	Return True
EndFunc
Func BestTarget_MasochismPvP($a_f_AggroRange)
	Return UAI_GetPlayerInfo($GC_UAI_AGENT_ID)
EndFunc
Func CanUse_IllusionaryWeaponryPvP()
	If Anti_Enchantment() Then Return False
	Return True
EndFunc
Func BestTarget_IllusionaryWeaponryPvP($a_f_AggroRange)
	Return UAI_GetPlayerInfo($GC_UAI_AGENT_ID)
EndFunc
Func CanUse_EbonDustAuraPvP()
	If Anti_Enchantment() Then Return False
	Return True
EndFunc
Func BestTarget_EbonDustAuraPvP($a_f_AggroRange)
	Return UAI_GetPlayerInfo($GC_UAI_AGENT_ID)
EndFunc
Func CanUse_HeartOfHolyFlamePvP()
	If Anti_Enchantment() Then Return False
	Return True
EndFunc
Func BestTarget_HeartOfHolyFlamePvP($a_f_AggroRange)
	Return UAI_GetPlayerInfo($GC_UAI_AGENT_ID)
EndFunc
Func CanUse_GuidingHandsPvP()
	If Anti_Enchantment() Then Return False
	Return True
EndFunc
Func BestTarget_GuidingHandsPvP($a_f_AggroRange)
	Return UAI_GetPlayerInfo($GC_UAI_AGENT_ID)
EndFunc
Func CanUse_AuraOfThornsPvP()
	If Anti_Enchantment() Then Return False
	Return True
EndFunc
Func BestTarget_AuraOfThornsPvP($a_f_AggroRange)
	Return UAI_GetPlayerInfo($GC_UAI_AGENT_ID)
EndFunc
Func CanUse_DustCloakPvP()
	If Anti_Enchantment() Then Return False
	Return True
EndFunc
Func BestTarget_DustCloakPvP($a_f_AggroRange)
	Return UAI_GetPlayerInfo($GC_UAI_AGENT_ID)
EndFunc
Func CanUse_LyssasHastePvP()
	If Anti_Enchantment() Then Return False
	Return True
EndFunc
Func BestTarget_LyssasHastePvP($a_f_AggroRange)
	Return UAI_GetPlayerInfo($GC_UAI_AGENT_ID)
EndFunc
Func CanUse_OnslaughtPvP()
	If Anti_Enchantment() Then Return False
	Return True
EndFunc
Func BestTarget_OnslaughtPvP($a_f_AggroRange)
	Return UAI_GetPlayerInfo($GC_UAI_AGENT_ID)
EndFunc
Func CanUse_IllusionOfHastePvP()
	If Anti_Enchantment() Then Return False
	Return True
EndFunc
Func BestTarget_IllusionOfHastePvP($a_f_AggroRange)
	Return UAI_GetPlayerInfo($GC_UAI_AGENT_ID)
EndFunc
Func CanUse_AuraOfRestorationPvP()
	If Anti_Enchantment() Then Return False
	Return True
EndFunc
Func BestTarget_AuraOfRestorationPvP($a_f_AggroRange)
	Return UAI_GetPlayerInfo($GC_UAI_AGENT_ID)
EndFunc
Func CanUse_ElementalFlamePvP()
	If Anti_Enchantment() Then Return False
	Return True
EndFunc
Func BestTarget_ElementalFlamePvP($a_f_AggroRange)
	Return UAI_GetPlayerInfo($GC_UAI_AGENT_ID)
EndFunc
Func CanUse_SoulTaker()
	If Anti_Enchantment() Then Return False
	If UAI_GetPlayerEffectInfo($GC_I_SKILL_ID_SOUL_TAKER, $GC_UAI_EFFECT_TimeRemaining) > 5000 Then Return False
	Return True
EndFunc
Func BestTarget_SoulTaker($a_f_AggroRange)
	Return UAI_GetPlayerInfo($GC_UAI_AGENT_ID)
EndFunc
Func CanUse_OverTheLimit()
	If Anti_Enchantment() Then Return False
	Return True
EndFunc
Func BestTarget_OverTheLimit($a_f_AggroRange)
	Return UAI_GetPlayerInfo($GC_UAI_AGENT_ID)
EndFunc
Func CanUse_VowOfRevolution()
	If Anti_Enchantment() Then Return False
	Return True
EndFunc
Func BestTarget_VowOfRevolution($a_f_AggroRange)
	Return UAI_GetPlayerInfo($GC_UAI_AGENT_ID)
EndFunc