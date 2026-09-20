#include-once
Func Anti_Hex()
	If UAI_Filter_IsSpirit($g_i_BestTarget) Then Return True 
	If Not UAI_GetPlayerInfo($GC_UAI_AGENT_IsHexed) Then Return False
	If UAI_PlayerHasEffect($GC_I_SKILL_ID_GUILT) Then Return True
	If UAI_PlayerHasEffect($GC_I_SKILL_ID_MISTRUST) Then Return True
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
Func CanUse_Fragility()
	If Anti_Hex() Then Return False
	Return True
EndFunc
Func BestTarget_Fragility($a_f_AggroRange)
	Return UAI_GetBestAOETarget(-2, 1320, $GC_I_RANGE_ADJACENT, "UAI_Filter_IsLivingEnemy")
EndFunc
Func CanUse_Confusion()
	If Anti_Hex() Then Return False
	Return True
EndFunc
Func BestTarget_Confusion($a_f_AggroRange)
	Return UAI_GetAgentLowest(-2, $a_f_AggroRange, $GC_UAI_AGENT_HP, "UAI_Filter_IsLivingEnemy")
EndFunc
Func CanUse_Empathy()
	If Anti_Hex() Then Return False
	Return True
EndFunc
Func BestTarget_Empathy($a_f_AggroRange)
	Local $l_i_Target = UAI_GetAgentLowest(-2, $a_f_AggroRange, $GC_UAI_AGENT_HP, "UAI_Filter_IsLivingEnemy|UAI_Filter_IsAttacking")
	If $l_i_Target <> 0 Then Return $l_i_Target
	Return UAI_GetAgentLowest(-2, $a_f_AggroRange, $GC_UAI_AGENT_HP, "UAI_Filter_IsLivingEnemy")
EndFunc
Func CanUse_Backfire()
	If Anti_Hex() Then Return False
	Return True
EndFunc
Func BestTarget_Backfire($a_f_AggroRange)
	Return UAI_GetAgentLowest(-2, $a_f_AggroRange, $GC_UAI_AGENT_HP, "UAI_Filter_IsLivingEnemy|UAI_Filter_IsCaster")
EndFunc
Func CanUse_Diversion()
	If Anti_Hex() Then Return False
	Return True
EndFunc
Func BestTarget_Diversion($a_f_AggroRange)
	Return UAI_GetAgentLowest(-2, $a_f_AggroRange, $GC_UAI_AGENT_HP, "UAI_Filter_IsLivingEnemy|UAI_Filter_IsCaster")
EndFunc
Func CanUse_ConjurePhantasm()
	If Anti_Hex() Then Return False
	Return True
EndFunc
Func BestTarget_ConjurePhantasm($a_f_AggroRange)
	Return UAI_GetAgentLowest(-2, $a_f_AggroRange, $GC_UAI_AGENT_HP, "UAI_Filter_IsLivingEnemy")
EndFunc
Func CanUse_Ignorance()
	If Anti_Hex() Then Return False
	Return True
EndFunc
Func BestTarget_Ignorance($a_f_AggroRange)
	Return UAI_GetAgentLowest(-2, $a_f_AggroRange, $GC_UAI_AGENT_HP, "UAI_Filter_IsLivingEnemy")
EndFunc
Func CanUse_ArcaneConundrum()
	If Anti_Hex() Then Return False
	Return True
EndFunc
Func BestTarget_ArcaneConundrum($a_f_AggroRange)
	Return UAI_GetAgentLowest(-2, $a_f_AggroRange, $GC_UAI_AGENT_HP, "UAI_Filter_IsLivingEnemy")
EndFunc
Func CanUse_EtherLord()
	If Anti_Hex() Then Return False
	Return True
EndFunc
Func BestTarget_EtherLord($a_f_AggroRange)
	Return UAI_GetAgentLowest(-2, $a_f_AggroRange, $GC_UAI_AGENT_HP, "UAI_Filter_IsLivingEnemy|UAI_Filter_IsCaster")
EndFunc
Func CanUse_Clumsiness()
	If Anti_Hex() Then Return False
	Return True
EndFunc
Func BestTarget_Clumsiness($a_f_AggroRange)
	Return UAI_GetBestAOETarget(-2, 1320, $GC_I_RANGE_ADJACENT, "UAI_Filter_IsLivingEnemy")
EndFunc
Func CanUse_PhantomPain()
	If Anti_Hex() Then Return False
	Return True
EndFunc
Func BestTarget_PhantomPain($a_f_AggroRange)
	Return UAI_GetAgentLowest(-2, $a_f_AggroRange, $GC_UAI_AGENT_HP, "UAI_Filter_IsLivingEnemy")
EndFunc
Func CanUse_EtherealBurden()
	If Anti_Hex() Then Return False
	Return True
EndFunc
Func BestTarget_EtherealBurden($a_f_AggroRange)
	Local $l_i_Target = UAI_GetAgentLowest(-2, $a_f_AggroRange, $GC_UAI_AGENT_HP, "UAI_Filter_IsLivingEnemy|UAI_Filter_IsMoving")
	If $l_i_Target <> 0 Then Return $l_i_Target
	Return UAI_GetAgentLowest(-2, $a_f_AggroRange, $GC_UAI_AGENT_HP, "UAI_Filter_IsLivingEnemy")
EndFunc
Func CanUse_Guilt()
	If Anti_Hex() Then Return False
	Return True
EndFunc
Func BestTarget_Guilt($a_f_AggroRange)
	Return UAI_GetAgentLowest(-2, $a_f_AggroRange, $GC_UAI_AGENT_HP, "UAI_Filter_IsLivingEnemy|UAI_Filter_IsCaster")
EndFunc
Func CanUse_Ineptitude()
	If Anti_Hex() Then Return False
	Return True
EndFunc
Func BestTarget_Ineptitude($a_f_AggroRange)
	Return UAI_GetBestAOETarget(-2, 1320, $GC_I_RANGE_ADJACENT, "UAI_Filter_IsLivingEnemy")
EndFunc
Func CanUse_SpiritOfFailure()
	If Anti_Hex() Then Return False
	Return True
EndFunc
Func BestTarget_SpiritOfFailure($a_f_AggroRange)
	Return UAI_GetAgentLowest(-2, $a_f_AggroRange, $GC_UAI_AGENT_HP, "UAI_Filter_IsLivingEnemy|UAI_Filter_IsAttacking")
EndFunc
Func CanUse_MindWrack()
	If Anti_Hex() Then Return False
	Return True
EndFunc
Func BestTarget_MindWrack($a_f_AggroRange)
	Return UAI_GetAgentLowest(-2, $a_f_AggroRange, $GC_UAI_AGENT_HP, "UAI_Filter_IsLivingEnemy|UAI_Filter_IsCaster")
EndFunc
Func CanUse_WastrelsWorry()
	If Anti_Hex() Then Return False
	Return True
EndFunc
Func BestTarget_WastrelsWorry($a_f_AggroRange)
	Return UAI_GetBestAOETarget(-2, 1320, $GC_I_RANGE_ADJACENT, "UAI_Filter_IsLivingEnemy")
EndFunc
Func CanUse_Shame()
	If Anti_Hex() Then Return False
	Return True
EndFunc
Func BestTarget_Shame($a_f_AggroRange)
	Return UAI_GetAgentLowest(-2, $a_f_AggroRange, $GC_UAI_AGENT_HP, "UAI_Filter_IsLivingEnemy|UAI_Filter_IsCaster")
EndFunc
Func CanUse_Panic()
	If Anti_Hex() Then Return False
	Return True
EndFunc
Func BestTarget_Panic($a_f_AggroRange)
	Return UAI_GetBestAOETarget(-2, 1320, $GC_I_RANGE_NEARBY, "UAI_Filter_IsLivingEnemy")
EndFunc
Func CanUse_Migraine()
	If Anti_Hex() Then Return False
	Return True
EndFunc
Func BestTarget_Migraine($a_f_AggroRange)
	Return UAI_GetAgentLowest(-2, $a_f_AggroRange, $GC_UAI_AGENT_HP, "UAI_Filter_IsLivingEnemy|UAI_Filter_IsCaster")
EndFunc
Func CanUse_CripplingAnguish()
	If Anti_Hex() Then Return False
	Return True
EndFunc
Func BestTarget_CripplingAnguish($a_f_AggroRange)
	Local $l_i_Target = UAI_GetAgentLowest(-2, $a_f_AggroRange, $GC_UAI_AGENT_HP, "UAI_Filter_IsLivingEnemy|UAI_Filter_IsAttacking")
	If $l_i_Target <> 0 Then Return $l_i_Target
	Return UAI_GetAgentLowest(-2, $a_f_AggroRange, $GC_UAI_AGENT_HP, "UAI_Filter_IsLivingEnemy")
EndFunc
Func CanUse_FeveredDreams()
	If Anti_Hex() Then Return False
	Return True
EndFunc
Func BestTarget_FeveredDreams($a_f_AggroRange)
	Return UAI_GetBestAOETarget(-2, 1320, $GC_I_RANGE_NEARBY, "UAI_Filter_IsLivingEnemy")
EndFunc
Func CanUse_SoothingImages()
	If Anti_Hex() Then Return False
	Return True
EndFunc
Func BestTarget_SoothingImages($a_f_AggroRange)
	Return UAI_GetBestAOETarget(-2, 1320, $GC_I_RANGE_ADJACENT, "UAI_Filter_IsLivingEnemy")
EndFunc
Func CanUse_SpiritShackles()
	If Anti_Hex() Then Return False
	Return True
EndFunc
Func BestTarget_SpiritShackles($a_f_AggroRange)
	Return UAI_GetAgentLowest(-2, $a_f_AggroRange, $GC_UAI_AGENT_HP, "UAI_Filter_IsLivingEnemy|UAI_Filter_IsAttacking")
EndFunc
Func CanUse_ImaginedBurden()
	If Anti_Hex() Then Return False
	Return True
EndFunc
Func BestTarget_ImaginedBurden($a_f_AggroRange)
	Local $l_i_Target = UAI_GetAgentLowest(-2, $a_f_AggroRange, $GC_UAI_AGENT_HP, "UAI_Filter_IsLivingEnemy|UAI_Filter_IsMoving")
	If $l_i_Target <> 0 Then Return $l_i_Target
	Return UAI_GetAgentLowest(-2, $a_f_AggroRange, $GC_UAI_AGENT_HP, "UAI_Filter_IsLivingEnemy")
EndFunc
Func CanUse_ParasiticBond()
	If Anti_Hex() Then Return False
	Return True
EndFunc
Func BestTarget_ParasiticBond($a_f_AggroRange)
	Return UAI_GetBestSingleTarget(-2, $a_f_AggroRange, $GC_UAI_AGENT_HP, "UAI_Filter_IsLivingEnemy|-UAI_Filter_IsHexed")
EndFunc
Func CanUse_SoulBarbs()
	If Anti_Hex() Then Return False
	Return True
EndFunc
Func BestTarget_SoulBarbs($a_f_AggroRange)
	Return UAI_GetNearestAgent(-2, $a_f_AggroRange, "UAI_Filter_IsLivingEnemy")
EndFunc
Func CanUse_Barbs()
	If Anti_Hex() Then Return False
	Return True
EndFunc
Func BestTarget_Barbs($a_f_AggroRange)
	Local $l_i_Target = UAI_GetAgentLowest(-2, $a_f_AggroRange, $GC_UAI_AGENT_HP, "UAI_Filter_IsLivingEnemy|UAI_Filter_IsAttacking")
	If $l_i_Target <> 0 Then Return $l_i_Target
	Return UAI_GetAgentLowest(-2, $a_f_AggroRange, $GC_UAI_AGENT_HP, "UAI_Filter_IsLivingEnemy")
EndFunc
Func CanUse_PriceOfFailure()
	If Anti_Hex() Then Return False
	Return True
EndFunc
Func BestTarget_PriceOfFailure($a_f_AggroRange)
	Return UAI_GetBestAOETarget(-2, 1320, $GC_I_RANGE_NEARBY, "UAI_Filter_IsLivingEnemy")
EndFunc
Func CanUse_Suffering()
	If Anti_Hex() Then Return False
	Return True
EndFunc
Func BestTarget_Suffering($a_f_AggroRange)
	Return UAI_GetBestAOETarget(-2, 1320, $GC_I_RANGE_NEARBY, "UAI_Filter_IsLivingEnemy")
EndFunc
Func CanUse_LifeSiphon()
	If Anti_Hex() Then Return False
	Return True
EndFunc
Func BestTarget_LifeSiphon($a_f_AggroRange)
	Return UAI_GetAgentLowest(-2, $a_f_AggroRange, $GC_UAI_AGENT_HP, "UAI_Filter_IsLivingEnemy")
EndFunc
Func CanUse_SpitefulSpirit()
	If Anti_Hex() Then Return False
	Return True
EndFunc
Func BestTarget_SpitefulSpirit($a_f_AggroRange)
	Return UAI_GetBestAOETarget(-2, 1320, $GC_I_RANGE_ADJACENT, "UAI_Filter_IsLivingEnemy")
EndFunc
Func CanUse_MalignIntervention()
	If Anti_Hex() Then Return False
	Return True
EndFunc
Func BestTarget_MalignIntervention($a_f_AggroRange)
	Return UAI_GetAgentLowest(-2, $a_f_AggroRange, $GC_UAI_AGENT_HP, "UAI_Filter_IsLivingEnemy")
EndFunc
Func CanUse_InsidiousParasite()
	If Anti_Hex() Then Return False
	Return True
EndFunc
Func BestTarget_InsidiousParasite($a_f_AggroRange)
	Return UAI_GetAgentLowest(-2, $a_f_AggroRange, $GC_UAI_AGENT_HP, "UAI_Filter_IsLivingEnemy|UAI_Filter_IsAttacking")
EndFunc
Func CanUse_SpinalShivers()
	If Anti_Hex() Then Return False
	Return True
EndFunc
Func BestTarget_SpinalShivers($a_f_AggroRange)
	Return UAI_GetAgentLowest(-2, $a_f_AggroRange, $GC_UAI_AGENT_HP, "UAI_Filter_IsLivingEnemy")
EndFunc
Func CanUse_Wither()
	If Anti_Hex() Then Return False
	Return True
EndFunc
Func BestTarget_Wither($a_f_AggroRange)
	Return UAI_GetAgentLowest(-2, $a_f_AggroRange, $GC_UAI_AGENT_HP, "UAI_Filter_IsLivingEnemy|UAI_Filter_IsCaster")
EndFunc
Func CanUse_LifeTransfer()
	If Anti_Hex() Then Return False
	Return True
EndFunc
Func BestTarget_LifeTransfer($a_f_AggroRange)
	Return UAI_GetBestAOETarget(-2, 1320, $GC_I_RANGE_ADJACENT, "UAI_Filter_IsLivingEnemy")
EndFunc
Func CanUse_MarkOfSubversion()
	If Anti_Hex() Then Return False
	Return True
EndFunc
Func BestTarget_MarkOfSubversion($a_f_AggroRange)
	Return UAI_GetAgentLowest(-2, $a_f_AggroRange, $GC_UAI_AGENT_HP, "UAI_Filter_IsLivingEnemy|UAI_Filter_IsCaster")
EndFunc
Func CanUse_SoulLeech()
	If Anti_Hex() Then Return False
	Return True
EndFunc
Func BestTarget_SoulLeech($a_f_AggroRange)
	Return UAI_GetAgentLowest(-2, $a_f_AggroRange, $GC_UAI_AGENT_HP, "UAI_Filter_IsLivingEnemy|UAI_Filter_IsCaster")
EndFunc
Func CanUse_DefileFlesh()
	If Anti_Hex() Then Return False
	Return True
EndFunc
Func BestTarget_DefileFlesh($a_f_AggroRange)
	Return UAI_GetAgentLowest(-2, $a_f_AggroRange, $GC_UAI_AGENT_HP, "UAI_Filter_IsLivingEnemy")
EndFunc
Func CanUse_Faintheartedness()
	If Anti_Hex() Then Return False
	Return True
EndFunc
Func BestTarget_Faintheartedness($a_f_AggroRange)
	Local $l_i_Target = UAI_GetAgentLowest(-2, $a_f_AggroRange, $GC_UAI_AGENT_HP, "UAI_Filter_IsLivingEnemy|UAI_Filter_IsAttacking")
	If $l_i_Target <> 0 Then Return $l_i_Target
	Return UAI_GetAgentLowest(-2, $a_f_AggroRange, $GC_UAI_AGENT_HP, "UAI_Filter_IsLivingEnemy")
EndFunc
Func CanUse_ShadowOfFear()
	If Anti_Hex() Then Return False
	Return True
EndFunc
Func BestTarget_ShadowOfFear($a_f_AggroRange)
	Return UAI_GetBestAOETarget(-2, 1320, $GC_I_RANGE_ADJACENT, "UAI_Filter_IsLivingEnemy")
EndFunc
Func CanUse_RigorMortis()
	If Anti_Hex() Then Return False
	Return True
EndFunc
Func BestTarget_RigorMortis($a_f_AggroRange)
	Return UAI_GetAgentLowest(-2, $a_f_AggroRange, $GC_UAI_AGENT_HP, "UAI_Filter_IsLivingEnemy|UAI_Filter_IsAttacking")
EndFunc
Func CanUse_Malaise()
	If Anti_Hex() Then Return False
	Return True
EndFunc
Func BestTarget_Malaise($a_f_AggroRange)
	Return UAI_GetAgentLowest(-2, $a_f_AggroRange, $GC_UAI_AGENT_HP, "UAI_Filter_IsLivingEnemy|UAI_Filter_IsCaster")
EndFunc
Func CanUse_LingeringCurse()
	If Anti_Hex() Then Return False
	Return True
EndFunc
Func BestTarget_LingeringCurse($a_f_AggroRange)
	Return UAI_GetBestAOETarget(-2, 1320, $GC_I_RANGE_NEARBY, "UAI_Filter_IsLivingEnemy")
EndFunc
Func CanUse_MarkOfPain()
	If Anti_Hex() Then Return False
	Return True
EndFunc
Func BestTarget_MarkOfPain($a_f_AggroRange)
	Return UAI_GetBestAOETarget(-2, 1320, $GC_I_RANGE_ADJACENT, "UAI_Filter_IsLivingEnemy")
EndFunc
Func CanUse_GraspingEarth()
	If Anti_Hex() Then Return False
	Return True
EndFunc
Func BestTarget_GraspingEarth($a_f_AggroRange)
	Return UAI_GetPlayerInfo($GC_UAI_AGENT_ID)
EndFunc
Func CanUse_IncendiaryBonds()
	If Anti_Hex() Then Return False
	Return True
EndFunc
Func BestTarget_IncendiaryBonds($a_f_AggroRange)
	Return UAI_GetBestAOETarget(-2, 1320, $GC_I_RANGE_NEARBY, "UAI_Filter_IsLivingEnemy")
EndFunc
Func CanUse_MarkOfRodgort()
	If Anti_Hex() Then Return False
	Return True
EndFunc
Func BestTarget_MarkOfRodgort($a_f_AggroRange)
	Return UAI_GetBestAOETarget(-2, 1320, $GC_I_RANGE_NEARBY, "UAI_Filter_IsLivingEnemy")
EndFunc
Func CanUse_Rust()
	If Anti_Hex() Then Return False
	Return True
EndFunc
Func BestTarget_Rust($a_f_AggroRange)
	Return UAI_GetBestAOETarget(-2, 1320, $GC_I_RANGE_ADJACENT, "UAI_Filter_IsLivingEnemy")
EndFunc
Func CanUse_LightningSurge()
	If Anti_Hex() Then Return False
	Return True
EndFunc
Func BestTarget_LightningSurge($a_f_AggroRange)
	Return UAI_GetBestAOETarget(-2, 1320, $GC_I_RANGE_ADJACENT, "UAI_Filter_IsLivingEnemy")
EndFunc
Func CanUse_MindFreeze()
	If Anti_Hex() Then Return False
	Return True
EndFunc
Func BestTarget_MindFreeze($a_f_AggroRange)
	Return UAI_GetAgentLowest(-2, $a_f_AggroRange, $GC_UAI_AGENT_HP, "UAI_Filter_IsLivingEnemy|UAI_Filter_IsCaster")
EndFunc
Func CanUse_IcePrison()
	If Anti_Hex() Then Return False
	Return True
EndFunc
Func BestTarget_IcePrison($a_f_AggroRange)
	Local $l_i_Target = UAI_GetAgentLowest(-2, $a_f_AggroRange, $GC_UAI_AGENT_HP, "UAI_Filter_IsLivingEnemy|UAI_Filter_IsMoving")
	If $l_i_Target <> 0 Then Return $l_i_Target
	Return UAI_GetAgentLowest(-2, $a_f_AggroRange, $GC_UAI_AGENT_HP, "UAI_Filter_IsLivingEnemy")
EndFunc
Func CanUse_IceSpikes()
	If Anti_Hex() Then Return False
	Return True
EndFunc
Func BestTarget_IceSpikes($a_f_AggroRange)
	Return UAI_GetBestAOETarget(-2, 1320, $GC_I_RANGE_ADJACENT, "UAI_Filter_IsLivingEnemy")
EndFunc
Func CanUse_FrozenBurst()
	If Anti_Hex() Then Return False
	Return True
EndFunc
Func BestTarget_FrozenBurst($a_f_AggroRange)
	Return UAI_GetPlayerInfo($GC_UAI_AGENT_ID)
EndFunc
Func CanUse_ShardStorm()
	If Anti_Hex() Then Return False
	Return True
EndFunc
Func BestTarget_ShardStorm($a_f_AggroRange)
	Local $l_i_Target = UAI_GetAgentLowest(-2, $a_f_AggroRange, $GC_UAI_AGENT_HP, "UAI_Filter_IsLivingEnemy|UAI_Filter_IsMoving")
	If $l_i_Target <> 0 Then Return $l_i_Target
	Return UAI_GetAgentLowest(-2, $a_f_AggroRange, $GC_UAI_AGENT_HP, "UAI_Filter_IsLivingEnemy")
EndFunc
Func CanUse_LightningStrike()
	If Anti_Hex() Then Return False
	Return True
EndFunc
Func BestTarget_LightningStrike($a_f_AggroRange)
	Return UAI_GetAgentLowest(-2, $a_f_AggroRange, $GC_UAI_AGENT_HP, "UAI_Filter_IsLivingEnemy")
EndFunc
Func CanUse_GlimmeringMark()
	If Anti_Hex() Then Return False
	Return True
EndFunc
Func BestTarget_GlimmeringMark($a_f_AggroRange)
	Return UAI_GetAgentLowest(-2, $a_f_AggroRange, $GC_UAI_AGENT_HP, "UAI_Filter_IsLivingEnemy")
EndFunc
Func CanUse_DeepFreeze()
	If Anti_Hex() Then Return False
	Return True
EndFunc
Func BestTarget_DeepFreeze($a_f_AggroRange)
	Return UAI_GetBestAOETarget(-2, $a_f_AggroRange, $GC_I_RANGE_AREA, "UAI_Filter_IsLivingEnemy")
EndFunc
Func CanUse_BlurredVision()
	If Anti_Hex() Then Return False
	Return True
EndFunc
Func BestTarget_BlurredVision($a_f_AggroRange)
	Return UAI_GetBestAOETarget(-2, 1320, $GC_I_RANGE_ADJACENT, "UAI_Filter_IsLivingEnemy")
EndFunc
Func CanUse_ScourgeHealing()
	If Anti_Hex() Then Return False
	Return True
EndFunc
Func BestTarget_ScourgeHealing($a_f_AggroRange)
	Return UAI_GetAgentLowest(-2, $a_f_AggroRange, $GC_UAI_AGENT_HP, "UAI_Filter_IsLivingEnemy")
EndFunc
Func CanUse_ScourgeSacrifice()
	If Anti_Hex() Then Return False
	Return True
EndFunc
Func BestTarget_ScourgeSacrifice($a_f_AggroRange)
	Return UAI_GetBestAOETarget(-2, 1320, $GC_I_RANGE_ADJACENT, "UAI_Filter_IsLivingEnemy")
EndFunc
Func CanUse_Pacifism()
	If Anti_Hex() Then Return False
	Return True
EndFunc
Func BestTarget_Pacifism($a_f_AggroRange)
	Return UAI_GetAgentLowest(-2, $a_f_AggroRange, $GC_UAI_AGENT_HP, "UAI_Filter_IsLivingEnemy|UAI_Filter_IsAttacking")
EndFunc
Func CanUse_Amity()
	If Anti_Hex() Then Return False
	Return True
EndFunc
Func BestTarget_Amity($a_f_AggroRange)
	Return UAI_GetPlayerInfo($GC_UAI_AGENT_ID)
EndFunc
Func CanUse_BurdenTotem()
	If Anti_Hex() Then Return False
	Return True
EndFunc
Func BestTarget_BurdenTotem($a_f_AggroRange)
	Return UAI_GetPlayerInfo($GC_UAI_AGENT_ID)
EndFunc
Func CanUse_CrystalHaze()
	If Anti_Hex() Then Return False
	Return True
EndFunc
Func BestTarget_CrystalHaze($a_f_AggroRange)
	Return UAI_GetBestAOETarget(-2, $a_f_AggroRange, $GC_I_RANGE_NEARBY, "UAI_Filter_IsLivingEnemy")
EndFunc
Func CanUse_CrystalBonds()
	If Anti_Hex() Then Return False
	Return True
EndFunc
Func BestTarget_CrystalBonds($a_f_AggroRange)
	Return UAI_GetAgentLowest(-2, $a_f_AggroRange, $GC_UAI_AGENT_HP, "UAI_Filter_IsLivingEnemy|UAI_Filter_IsEnchanted")
EndFunc
Func CanUse_OracleLink()
	If Anti_Hex() Then Return False
	Return True
EndFunc
Func BestTarget_OracleLink($a_f_AggroRange)
	Return UAI_GetPlayerInfo($GC_UAI_AGENT_ID)
EndFunc
Func CanUse_SpontaneousCombustion()
	If Anti_Hex() Then Return False
	Return True
EndFunc
Func BestTarget_SpontaneousCombustion($a_f_AggroRange)
	Return UAI_GetPlayerInfo($GC_UAI_AGENT_ID)
EndFunc
Func CanUse_MarkOfInsecurity()
	If Anti_Hex() Then Return False
	Return True
EndFunc
Func BestTarget_MarkOfInsecurity($a_f_AggroRange)
	Return UAI_GetAgentLowest(-2, $a_f_AggroRange, $GC_UAI_AGENT_HP, "UAI_Filter_IsLivingEnemy")
EndFunc
Func CanUse_WailOfDoom()
	If Anti_Hex() Then Return False
	Return True
EndFunc
Func BestTarget_WailOfDoom($a_f_AggroRange)
	Return UAI_GetAgentLowest(-2, $a_f_AggroRange, $GC_UAI_AGENT_HP, "UAI_Filter_IsLivingEnemy|UAI_Filter_IsCaster")
EndFunc
Func CanUse_MarkOfDeath()
	If Anti_Hex() Then Return False
	Return True
EndFunc
Func BestTarget_MarkOfDeath($a_f_AggroRange)
	Return UAI_GetAgentLowest(-2, $a_f_AggroRange, $GC_UAI_AGENT_HP, "UAI_Filter_IsLivingEnemy")
EndFunc
Func CanUse_EnduringToxin()
	If Anti_Hex() Then Return False
	Return True
EndFunc
Func BestTarget_EnduringToxin($a_f_AggroRange)
	Local $l_i_Target = UAI_GetAgentLowest(-2, $a_f_AggroRange, $GC_UAI_AGENT_HP, "UAI_Filter_IsLivingEnemy|UAI_Filter_IsMoving")
	If $l_i_Target <> 0 Then Return $l_i_Target
	Return UAI_GetAgentLowest(-2, $a_f_AggroRange, $GC_UAI_AGENT_HP, "UAI_Filter_IsLivingEnemy")
EndFunc
Func CanUse_ShroudOfSilence()
	If Anti_Hex() Then Return False
	Return True
EndFunc
Func BestTarget_ShroudOfSilence($a_f_AggroRange)
	Return UAI_GetAgentLowest(-2, $a_f_AggroRange, $GC_UAI_AGENT_HP, "UAI_Filter_IsLivingEnemy|UAI_Filter_IsCaster")
EndFunc
Func CanUse_ExposeDefenses()
	If Anti_Hex() Then Return False
	Return True
EndFunc
Func BestTarget_ExposeDefenses($a_f_AggroRange)
	Return UAI_GetAgentLowest(-2, $a_f_AggroRange, $GC_UAI_AGENT_HP, "UAI_Filter_IsLivingEnemy|UAI_Filter_IsAttacking")
EndFunc
Func CanUse_PowerLeech()
	If Anti_Hex() Then Return False
	Return True
EndFunc
Func BestTarget_PowerLeech($a_f_AggroRange)
	Return UAI_GetAgentLowest(-2, $a_f_AggroRange, $GC_UAI_AGENT_HP, "UAI_Filter_IsLivingEnemy|UAI_Filter_IsCaster")
EndFunc
Func CanUse_ArcaneLanguor()
	If Anti_Hex() Then Return False
	Return True
EndFunc
Func BestTarget_ArcaneLanguor($a_f_AggroRange)
	Return UAI_GetAgentLowest(-2, $a_f_AggroRange, $GC_UAI_AGENT_HP, "UAI_Filter_IsLivingEnemy|UAI_Filter_IsCaster")
EndFunc
Func CanUse_ReapersMark1()
	If Anti_Hex() Then Return False
	Return True
EndFunc
Func BestTarget_ReapersMark1($a_f_AggroRange)
	Return UAI_GetAgentLowest(-2, $a_f_AggroRange, $GC_UAI_AGENT_HP, "UAI_Filter_IsLivingEnemy")
EndFunc
Func CanUse_Shatterstone()
	If Anti_Hex() Then Return False
	Return True
EndFunc
Func BestTarget_Shatterstone($a_f_AggroRange)
	Return UAI_GetBestAOETarget(-2, $a_f_AggroRange, $GC_I_RANGE_NEARBY, "UAI_Filter_IsLivingEnemy")
EndFunc
Func CanUse_ScorpionWire()
	If Anti_Hex() Then Return False
	Return True
EndFunc
Func BestTarget_ScorpionWire($a_f_AggroRange)
	Return UAI_GetAgentLowest(-2, $a_f_AggroRange, $GC_UAI_AGENT_HP, "UAI_Filter_IsLivingEnemy")
EndFunc
Func CanUse_MirroredStance()
	If Anti_Hex() Then Return False
	Return True
EndFunc
Func BestTarget_MirroredStance($a_f_AggroRange)
	Return UAI_GetAgentLowest(-2, $a_f_AggroRange, $GC_UAI_AGENT_HP, "UAI_Filter_IsLivingEnemy")
EndFunc
Func CanUse_Depravity()
	If Anti_Hex() Then Return False
	Return True
EndFunc
Func BestTarget_Depravity($a_f_AggroRange)
	Return UAI_GetBestAOETarget(-2, $a_f_AggroRange, $GC_I_RANGE_NEARBY, "UAI_Filter_IsLivingEnemy")
EndFunc
Func CanUse_IcyVeins()
	If Anti_Hex() Then Return False
	Return True
EndFunc
Func BestTarget_IcyVeins($a_f_AggroRange)
	Return UAI_GetBestAOETarget(-2, $a_f_AggroRange, $GC_I_RANGE_NEARBY, "UAI_Filter_IsLivingEnemy")
EndFunc
Func CanUse_WeakenKnees()
	If Anti_Hex() Then Return False
	Return True
EndFunc
Func BestTarget_WeakenKnees($a_f_AggroRange)
	Local $l_i_Target = UAI_GetAgentLowest(-2, $a_f_AggroRange, $GC_UAI_AGENT_HP, "UAI_Filter_IsLivingEnemy|UAI_Filter_IsMoving")
	If $l_i_Target <> 0 Then Return $l_i_Target
	Return UAI_GetAgentLowest(-2, $a_f_AggroRange, $GC_UAI_AGENT_HP, "UAI_Filter_IsLivingEnemy")
EndFunc
Func CanUse_SiphonStrength()
	If Anti_Hex() Then Return False
	Return True
EndFunc
Func BestTarget_SiphonStrength($a_f_AggroRange)
	Return UAI_GetAgentLowest(-2, $a_f_AggroRange, $GC_UAI_AGENT_HP, "UAI_Filter_IsLivingEnemy|UAI_Filter_IsAttacking")
EndFunc
Func CanUse_VileMiasma()
	If Anti_Hex() Then Return False
	Return True
EndFunc
Func BestTarget_VileMiasma($a_f_AggroRange)
	Return UAI_GetAgentLowest(-2, $a_f_AggroRange, $GC_UAI_AGENT_HP, "UAI_Filter_IsLivingEnemy")
EndFunc
Func CanUse_RecklessHaste()
	If Anti_Hex() Then Return False
	Return True
EndFunc
Func BestTarget_RecklessHaste($a_f_AggroRange)
	Return UAI_GetBestAOETarget(-2, 1320, $GC_I_RANGE_ADJACENT, "UAI_Filter_IsLivingEnemy")
EndFunc
Func CanUse_BloodBond()
	If Anti_Hex() Then Return False
	Return True
EndFunc
Func BestTarget_BloodBond($a_f_AggroRange)
	Return UAI_GetBestAOETarget(-2, 1320, $GC_I_RANGE_ADJACENT, "UAI_Filter_IsLivingEnemy")
EndFunc
Func CanUse_ConjureNightmare()
	If Anti_Hex() Then Return False
	Return True
EndFunc
Func BestTarget_ConjureNightmare($a_f_AggroRange)
	Return UAI_GetAgentLowest(-2, $a_f_AggroRange, $GC_UAI_AGENT_HP, "UAI_Filter_IsLivingEnemy")
EndFunc
Func CanUse_Dissipation()
	If Anti_Hex() Then Return False
	Return True
EndFunc
Func BestTarget_Dissipation($a_f_AggroRange)
	Return UAI_GetAgentLowest(-2, $a_f_AggroRange, $GC_UAI_AGENT_HP, "UAI_Filter_IsLivingEnemy")
EndFunc
Func CanUse_VisionsOfRegret()
	If Anti_Hex() Then Return False
	Return True
EndFunc
Func BestTarget_VisionsOfRegret($a_f_AggroRange)
	Return UAI_GetBestAOETarget(-2, 1320, $GC_I_RANGE_ADJACENT, "UAI_Filter_IsLivingEnemy")
EndFunc
Func CanUse_IllusionOfPain()
	If Anti_Hex() Then Return False
	Return True
EndFunc
Func BestTarget_IllusionOfPain($a_f_AggroRange)
	Return UAI_GetAgentLowest(-2, $a_f_AggroRange, $GC_UAI_AGENT_HP, "UAI_Filter_IsLivingEnemy")
EndFunc
Func CanUse_StolenSpeed()
	If Anti_Hex() Then Return False
	Return True
EndFunc
Func BestTarget_StolenSpeed($a_f_AggroRange)
	Return UAI_GetBestAOETarget(-2, 1320, $GC_I_RANGE_ADJACENT, "UAI_Filter_IsLivingEnemy")
EndFunc
Func CanUse_VocalMinority()
	If Anti_Hex() Then Return False
	Return True
EndFunc
Func BestTarget_VocalMinority($a_f_AggroRange)
	Return UAI_GetBestAOETarget(-2, $a_f_AggroRange, $GC_I_RANGE_NEARBY, "UAI_Filter_IsLivingEnemy")
EndFunc
Func CanUse_Overload()
	If Anti_Hex() Then Return False
	Return True
EndFunc
Func BestTarget_Overload($a_f_AggroRange)
	Return UAI_GetBestAOETarget(-2, $a_f_AggroRange, $GC_I_RANGE_ADJACENT, "UAI_Filter_IsLivingEnemy")
EndFunc
Func CanUse_ImagesOfRemorse()
	If Anti_Hex() Then Return False
	Return True
EndFunc
Func BestTarget_ImagesOfRemorse($a_f_AggroRange)
	Return UAI_GetAgentLowest(-2, $a_f_AggroRange, $GC_UAI_AGENT_HP, "UAI_Filter_IsLivingEnemy|UAI_Filter_IsAttacking")
EndFunc
Func CanUse_SharedBurden()
	If Anti_Hex() Then Return False
	Return True
EndFunc
Func BestTarget_SharedBurden($a_f_AggroRange)
	Return UAI_GetBestAOETarget(-2, $a_f_AggroRange, $GC_I_RANGE_NEARBY, "UAI_Filter_IsLivingEnemy")
EndFunc
Func CanUse_SoulBind()
	If Anti_Hex() Then Return False
	Return True
EndFunc
Func BestTarget_SoulBind($a_f_AggroRange)
	Return UAI_GetAgentLowest(-2, $a_f_AggroRange, $GC_UAI_AGENT_HP, "UAI_Filter_IsLivingEnemy")
EndFunc
Func CanUse_Lamentation()
	If Anti_Hex() Then Return False
	Return True
EndFunc
Func BestTarget_Lamentation($a_f_AggroRange)
	Return UAI_GetBestAOETarget(-2, $a_f_AggroRange, $GC_I_RANGE_NEARBY, "UAI_Filter_IsLivingEnemy")
EndFunc
Func CanUse_ShamefulFear()
	If Anti_Hex() Then Return False
	Return True
EndFunc
Func BestTarget_ShamefulFear($a_f_AggroRange)
	Local $l_i_Target = UAI_GetAgentLowest(-2, $a_f_AggroRange, $GC_UAI_AGENT_HP, "UAI_Filter_IsLivingEnemy|UAI_Filter_IsMoving")
	If $l_i_Target <> 0 Then Return $l_i_Target
	Return UAI_GetAgentLowest(-2, $a_f_AggroRange, $GC_UAI_AGENT_HP, "UAI_Filter_IsLivingEnemy")
EndFunc
Func CanUse_ShadowShroud()
	If Anti_Hex() Then Return False
	Return True
EndFunc
Func BestTarget_ShadowShroud($a_f_AggroRange)
	Return UAI_GetAgentLowest(-2, $a_f_AggroRange, $GC_UAI_AGENT_HP, "UAI_Filter_IsLivingEnemy")
EndFunc
Func CanUse_RisingBile()
	If Anti_Hex() Then Return False
	Return True
EndFunc
Func BestTarget_RisingBile($a_f_AggroRange)
	Return UAI_GetBestAOETarget(-2, $a_f_AggroRange, $GC_I_RANGE_AREA, "UAI_Filter_IsLivingEnemy")
EndFunc
Func CanUse_IcyShackles()
	If Anti_Hex() Then Return False
	Return True
EndFunc
Func BestTarget_IcyShackles($a_f_AggroRange)
	Local $l_i_Target = UAI_GetAgentLowest(-2, $a_f_AggroRange, $GC_UAI_AGENT_HP, "UAI_Filter_IsLivingEnemy|UAI_Filter_IsEnchanted")
	If $l_i_Target <> 0 Then Return $l_i_Target
	Local $l_i_Target = UAI_GetAgentLowest(-2, $a_f_AggroRange, $GC_UAI_AGENT_HP, "UAI_Filter_IsLivingEnemy|UAI_Filter_IsMoving")
	If $l_i_Target <> 0 Then Return $l_i_Target
	Return UAI_GetAgentLowest(-2, $a_f_AggroRange, $GC_UAI_AGENT_HP, "UAI_Filter_IsLivingEnemy")
EndFunc
Func CanUse_ShadowyBurden()
	If Anti_Hex() Then Return False
	Return True
EndFunc
Func BestTarget_ShadowyBurden($a_f_AggroRange)
	Local $l_i_Target = UAI_GetAgentLowest(-2, $a_f_AggroRange, $GC_UAI_AGENT_HP, "UAI_Filter_IsLivingEnemy|UAI_Filter_IsMoving")
	If $l_i_Target <> 0 Then Return $l_i_Target
	Return UAI_GetAgentLowest(-2, $a_f_AggroRange, $GC_UAI_AGENT_HP, "UAI_Filter_IsLivingEnemy")
EndFunc
Func CanUse_SiphonSpeed()
	If Anti_Hex() Then Return False
	Return True
EndFunc
Func BestTarget_SiphonSpeed($a_f_AggroRange)
	Local $l_i_Target = UAI_GetAgentLowest(-2, $a_f_AggroRange, $GC_UAI_AGENT_HP, "UAI_Filter_IsLivingEnemy|UAI_Filter_IsMoving")
	If $l_i_Target <> 0 Then Return $l_i_Target
	Return UAI_GetAgentLowest(-2, $a_f_AggroRange, $GC_UAI_AGENT_HP, "UAI_Filter_IsLivingEnemy")
EndFunc
Func CanUse_PowerFlux()
	If Anti_Hex() Then Return False
	Return True
EndFunc
Func BestTarget_PowerFlux($a_f_AggroRange)
	Return UAI_GetAgentLowest(-2, $a_f_AggroRange, $GC_UAI_AGENT_HP, "UAI_Filter_IsLivingEnemy|UAI_Filter_IsCaster")
EndFunc
Func CanUse_MarkOfInstability()
	If Anti_Hex() Then Return False
	Return True
EndFunc
Func BestTarget_MarkOfInstability($a_f_AggroRange)
	Return UAI_GetAgentLowest(-2, $a_f_AggroRange, $GC_UAI_AGENT_HP, "UAI_Filter_IsLivingEnemy|UAI_Filter_IsAttacking")
EndFunc
Func CanUse_Mistrust()
	If Anti_Hex() Then Return False
	Return True
EndFunc
Func BestTarget_Mistrust($a_f_AggroRange)
	Return UAI_GetBestAOETarget(-2, $a_f_AggroRange, $GC_I_RANGE_NEARBY, "UAI_Filter_IsLivingEnemy")
EndFunc
Func CanUse_TorchHex()
	If Anti_Hex() Then Return False
	Return True
EndFunc
Func BestTarget_TorchHex($a_f_AggroRange)
	Return UAI_GetPlayerInfo($GC_UAI_AGENT_ID)
EndFunc
Func CanUse_TorchDegenerationHex()
	If Anti_Hex() Then Return False
	Return True
EndFunc
Func BestTarget_TorchDegenerationHex($a_f_AggroRange)
	Return UAI_GetPlayerInfo($GC_UAI_AGENT_ID)
EndFunc
Func CanUse_SnowDownTheShirt()
	If Anti_Hex() Then Return False
	Return True
EndFunc
Func BestTarget_SnowDownTheShirt($a_f_AggroRange)
	Return UAI_GetAgentLowest(-2, $a_f_AggroRange, $GC_UAI_AGENT_HP, "UAI_Filter_IsLivingEnemy")
EndFunc
Func CanUse_Icicles()
	If Anti_Hex() Then Return False
	Return True
EndFunc
Func BestTarget_Icicles($a_f_AggroRange)
	Return UAI_GetBestAOETarget(-2, 1320, $GC_I_RANGE_ADJACENT, "UAI_Filter_IsLivingEnemy")
EndFunc
Func CanUse_SeepingWound()
	If Anti_Hex() Then Return False
	Return True
EndFunc
Func BestTarget_SeepingWound($a_f_AggroRange)
	Local $l_i_Target = UAI_GetAgentLowest(-2, $a_f_AggroRange, $GC_UAI_AGENT_HP, "UAI_Filter_IsLivingEnemy|UAI_Filter_IsMoving")
	If $l_i_Target <> 0 Then Return $l_i_Target
	Return UAI_GetAgentLowest(-2, $a_f_AggroRange, $GC_UAI_AGENT_HP, "UAI_Filter_IsLivingEnemy")
EndFunc
Func CanUse_AssassinsPromise()
	If Anti_Hex() Then Return False
	Return True
EndFunc
Func BestTarget_AssassinsPromise($a_f_AggroRange)
	Return UAI_GetAgentLowest(-2, $a_f_AggroRange, $GC_UAI_AGENT_HP, "UAI_Filter_IsLivingEnemy")
EndFunc
Func CanUse_DarkPrison()
	If Anti_Hex() Then Return False
	Return True
EndFunc
Func BestTarget_DarkPrison($a_f_AggroRange)
	Local $l_i_Target = UAI_GetAgentLowest(-2, $a_f_AggroRange, $GC_UAI_AGENT_HP, "UAI_Filter_IsLivingEnemy|UAI_Filter_IsMoving")
	If $l_i_Target <> 0 Then Return $l_i_Target
	Return UAI_GetAgentLowest(-2, $a_f_AggroRange, $GC_UAI_AGENT_HP, "UAI_Filter_IsLivingEnemy")
EndFunc
Func CanUse_EmpathyKoro()
	If Anti_Hex() Then Return False
	Return True
EndFunc
Func BestTarget_EmpathyKoro($a_f_AggroRange)
	Return UAI_GetAgentLowest(-2, $a_f_AggroRange, $GC_UAI_AGENT_HP, "UAI_Filter_IsLivingEnemy|UAI_Filter_IsAttacking")
EndFunc
Func CanUse_RecurringInsecurity()
	If Anti_Hex() Then Return False
	Return True
EndFunc
Func BestTarget_RecurringInsecurity($a_f_AggroRange)
	Return UAI_GetAgentLowest(-2, $a_f_AggroRange, $GC_UAI_AGENT_HP, "UAI_Filter_IsLivingEnemy")
EndFunc
Func CanUse_KitahsBurden()
	If Anti_Hex() Then Return False
	Return True
EndFunc
Func BestTarget_KitahsBurden($a_f_AggroRange)
	Local $l_i_Target = UAI_GetAgentLowest(-2, $a_f_AggroRange, $GC_UAI_AGENT_HP, "UAI_Filter_IsLivingEnemy|UAI_Filter_IsMoving")
	If $l_i_Target <> 0 Then Return $l_i_Target
	Return UAI_GetAgentLowest(-2, $a_f_AggroRange, $GC_UAI_AGENT_HP, "UAI_Filter_IsLivingEnemy")
EndFunc
Func CanUse_SpoilVictor()
	If Anti_Hex() Then Return False
	Return True
EndFunc
Func BestTarget_SpoilVictor($a_f_AggroRange)
	Return UAI_GetAgentLowest(-2, $a_f_AggroRange, $GC_UAI_AGENT_HP, "UAI_Filter_IsLivingEnemy|UAI_Filter_IsAttacking")
EndFunc
Func CanUse_ShiversOfDread()
	If Anti_Hex() Then Return False
	Return True
EndFunc
Func BestTarget_ShiversOfDread($a_f_AggroRange)
	Return UAI_GetAgentLowest(-2, $a_f_AggroRange, $GC_UAI_AGENT_HP, "UAI_Filter_IsLivingEnemy")
EndFunc
Func CanUse_AshBlast()
	If Anti_Hex() Then Return False
	Return True
EndFunc
Func BestTarget_AshBlast($a_f_AggroRange)
	Return UAI_GetBestAOETarget(-2, 1320, $GC_I_RANGE_ADJACENT, "UAI_Filter_IsLivingEnemy")
EndFunc
Func CanUse_SmolderingEmbers()
	If Anti_Hex() Then Return False
	Return True
EndFunc
Func BestTarget_SmolderingEmbers($a_f_AggroRange)
	Return UAI_GetAgentLowest(-2, $a_f_AggroRange, $GC_UAI_AGENT_HP, "UAI_Filter_IsLivingEnemy")
EndFunc
Func CanUse_TeinaisPrison()
	If Anti_Hex() Then Return False
	Return True
EndFunc
Func BestTarget_TeinaisPrison($a_f_AggroRange)
	Local $l_i_Target = UAI_GetAgentLowest(-2, $a_f_AggroRange, $GC_UAI_AGENT_HP, "UAI_Filter_IsLivingEnemy|UAI_Filter_IsMoving")
	If $l_i_Target <> 0 Then Return $l_i_Target
	Return UAI_GetAgentLowest(-2, $a_f_AggroRange, $GC_UAI_AGENT_HP, "UAI_Filter_IsLivingEnemy")
EndFunc
Func CanUse_MirrorOfIce()
	If Anti_Hex() Then Return False
	Return True
EndFunc
Func BestTarget_MirrorOfIce($a_f_AggroRange)
	Return UAI_GetBestAOETarget(-2, $a_f_AggroRange, $GC_I_RANGE_NEARBY, "UAI_Filter_IsLivingEnemy")
EndFunc
Func CanUse_StarShards()
	If Anti_Hex() Then Return False
	Return True
EndFunc
Func BestTarget_StarShards($a_f_AggroRange)
	Return UAI_GetPlayerInfo($GC_UAI_AGENT_ID)
EndFunc
Func CanUse_DulledWeapon()
	If Anti_Hex() Then Return False
	Return True
EndFunc
Func BestTarget_DulledWeapon($a_f_AggroRange)
	Return UAI_GetBestAOETarget(-2, 1320, $GC_I_RANGE_ADJACENT, "UAI_Filter_IsLivingEnemy")
EndFunc
Func CanUse_BindingChains()
	If Anti_Hex() Then Return False
	Return True
EndFunc
Func BestTarget_BindingChains($a_f_AggroRange)
	Return UAI_GetBestAOETarget(-2, $a_f_AggroRange, $GC_I_RANGE_NEARBY, "UAI_Filter_IsLivingEnemy")
EndFunc
Func CanUse_PainfulBond()
	If Anti_Hex() Then Return False
	Return True
EndFunc
Func BestTarget_PainfulBond($a_f_AggroRange)
	Return UAI_GetBestAOETarget(-2, 1320, $GC_I_RANGE_NEARBY, "UAI_Filter_IsLivingEnemy")
EndFunc
Func CanUse_Meekness()
	If Anti_Hex() Then Return False
	Return True
EndFunc
Func BestTarget_Meekness($a_f_AggroRange)
	Return UAI_GetBestAOETarget(-2, $a_f_AggroRange, $GC_I_RANGE_AREA, "UAI_Filter_IsLivingEnemy")
EndFunc
Func CanUse_SuicidalImpulse()
	If Anti_Hex() Then Return False
	Return True
EndFunc
Func BestTarget_SuicidalImpulse($a_f_AggroRange)
	Return UAI_GetPlayerInfo($GC_UAI_AGENT_ID)
EndFunc
Func CanUse_WastrelsDemise()
	If Anti_Hex() Then Return False
	Return True
EndFunc
Func BestTarget_WastrelsDemise($a_f_AggroRange)
	Return UAI_GetBestAOETarget(-2, $a_f_AggroRange, $GC_I_RANGE_ADJACENT, "UAI_Filter_IsLivingEnemy")
EndFunc
Func CanUse_Frustration()
	If Anti_Hex() Then Return False
	Return True
EndFunc
Func BestTarget_Frustration($a_f_AggroRange)
	Return UAI_GetAgentLowest(-2, $a_f_AggroRange, $GC_UAI_AGENT_HP, "UAI_Filter_IsLivingEnemy|UAI_Filter_IsCaster")
EndFunc
Func CanUse_EtherPhantom()
	If Anti_Hex() Then Return False
	Return True
EndFunc
Func BestTarget_EtherPhantom($a_f_AggroRange)
	Return UAI_GetAgentLowest(-2, $a_f_AggroRange, $GC_UAI_AGENT_HP, "UAI_Filter_IsLivingEnemy|UAI_Filter_IsCaster")
EndFunc
Func CanUse_WebOfDisruption()
	If Anti_Hex() Then Return False
	Return True
EndFunc
Func BestTarget_WebOfDisruption($a_f_AggroRange)
	Return UAI_GetAgentLowest(-2, $a_f_AggroRange, $GC_UAI_AGENT_HP, "UAI_Filter_IsLivingEnemy|UAI_Filter_IsCaster")
EndFunc
Func CanUse_EnchantersConundrum()
	If Anti_Hex() Then Return False
	Return True
EndFunc
Func BestTarget_EnchantersConundrum($a_f_AggroRange)
	Return UAI_GetBestAOETarget(-2, 1320, $GC_I_RANGE_ADJACENT, "UAI_Filter_IsLivingEnemy")
EndFunc
Func CanUse_UlcerousLungs()
	If Anti_Hex() Then Return False
	Return True
EndFunc
Func BestTarget_UlcerousLungs($a_f_AggroRange)
	Return UAI_GetBestAOETarget(-2, $a_f_AggroRange, $GC_I_RANGE_NEARBY, "UAI_Filter_IsLivingEnemy")
EndFunc
Func CanUse_MarkOfFury()
	If Anti_Hex() Then Return False
	Return True
EndFunc
Func BestTarget_MarkOfFury($a_f_AggroRange)
	Return UAI_GetAgentLowest(-2, $a_f_AggroRange, $GC_UAI_AGENT_HP, "UAI_Filter_IsLivingEnemy|UAI_Filter_IsAttacking")
EndFunc
Func CanUse_RecurringScourge()
	If Anti_Hex() Then Return False
	Return True
EndFunc
Func BestTarget_RecurringScourge($a_f_AggroRange)
	Return UAI_GetAgentLowest(-2, $a_f_AggroRange, $GC_UAI_AGENT_HP, "UAI_Filter_IsLivingEnemy")
EndFunc
Func CanUse_CorruptEnchantment()
	If Anti_Hex() Then Return False
	Return True
EndFunc
Func BestTarget_CorruptEnchantment($a_f_AggroRange)
	Return UAI_GetAgentLowest(-2, $a_f_AggroRange, $GC_UAI_AGENT_HP, "UAI_Filter_IsLivingEnemy|UAI_Filter_IsEnchanted")
EndFunc
Func CanUse_ChillingWinds()
	If Anti_Hex() Then Return False
	Return True
EndFunc
Func BestTarget_ChillingWinds($a_f_AggroRange)
	Return UAI_GetBestAOETarget(-2, 1320, $GC_I_RANGE_ADJACENT, "UAI_Filter_IsLivingEnemy")
EndFunc
Func CanUse_FreezingGust()
	If Anti_Hex() Then Return False
	Return True
EndFunc
Func BestTarget_FreezingGust($a_f_AggroRange)
	Local $l_i_Target = UAI_GetAgentLowest(-2, $a_f_AggroRange, $GC_UAI_AGENT_HP, "UAI_Filter_IsLivingEnemy|UAI_Filter_IsMoving")
	If $l_i_Target <> 0 Then Return $l_i_Target
	Return UAI_GetAgentLowest(-2, $a_f_AggroRange, $GC_UAI_AGENT_HP, "UAI_Filter_IsLivingEnemy")
EndFunc
Func CanUse_ScourgeEnchantment()
	If Anti_Hex() Then Return False
	Return True
EndFunc
Func BestTarget_ScourgeEnchantment($a_f_AggroRange)
	Return UAI_GetAgentLowest(-2, $a_f_AggroRange, $GC_UAI_AGENT_HP, "UAI_Filter_IsLivingEnemy")
EndFunc
Func CanUse_VialOfPurifiedWater()
	If Anti_Hex() Then Return False
	Return True
EndFunc
Func BestTarget_VialOfPurifiedWater($a_f_AggroRange)
	Return UAI_GetAgentLowest(-2, $a_f_AggroRange, $GC_UAI_AGENT_HP, "UAI_Filter_IsLivingEnemy|UAI_Filter_IsHarbingers")
EndFunc
Func CanUse_CorsairsNet()
	If Anti_Hex() Then Return False
	Return True
EndFunc
Func BestTarget_CorsairsNet($a_f_AggroRange)
	Return UAI_GetBestAOETarget(-2, $a_f_AggroRange, $GC_I_RANGE_AREA, "UAI_Filter_IsLivingEnemy")
EndFunc
Func CanUse_LastRitesOfTorment()
	If Anti_Hex() Then Return False
	Return True
EndFunc
Func BestTarget_LastRitesOfTorment($a_f_AggroRange)
	Return UAI_GetPlayerInfo($GC_UAI_AGENT_ID)
EndFunc
Func CanUse_EnchantmentCollapse()
	If Anti_Hex() Then Return False
	Return True
EndFunc
Func BestTarget_EnchantmentCollapse($a_f_AggroRange)
	Return UAI_GetAgentLowest(-2, $a_f_AggroRange, $GC_UAI_AGENT_HP, "UAI_Filter_IsLivingEnemy|UAI_Filter_IsEnchanted")
EndFunc
Func CanUse_CallOfSacrifice()
	If Anti_Hex() Then Return False
	Return True
EndFunc
Func BestTarget_CallOfSacrifice($a_f_AggroRange)
	Return UAI_GetAgentLowest(-2, $a_f_AggroRange, $GC_UAI_AGENT_HP, "UAI_Filter_IsLivingEnemy")
EndFunc
Func CanUse_RenewingSurge()
	If Anti_Hex() Then Return False
	If UAI_GetPlayerInfo($GC_UAI_AGENT_CurrentEnergy) > 20 Then Return False
	Return True
EndFunc
Func BestTarget_RenewingSurge($a_f_AggroRange)
	Return UAI_GetAgentHighest(-2, 1320, $GC_UAI_AGENT_HP, "UAI_Filter_IsLivingEnemy")
EndFunc
Func CanUse_HiddenCaltrops()
	If Anti_Hex() Then Return False
	Return True
EndFunc
Func BestTarget_HiddenCaltrops($a_f_AggroRange)
	Local $l_i_Target = UAI_GetAgentLowest(-2, $a_f_AggroRange, $GC_UAI_AGENT_HP, "UAI_Filter_IsLivingEnemy|UAI_Filter_IsMoving")
	If $l_i_Target <> 0 Then Return $l_i_Target
	Return UAI_GetAgentLowest(-2, $a_f_AggroRange, $GC_UAI_AGENT_HP, "UAI_Filter_IsLivingEnemy")
EndFunc
Func CanUse_AuguryOfDeath()
	If Anti_Hex() Then Return False
	Return True
EndFunc
Func BestTarget_AuguryOfDeath($a_f_AggroRange)
	Return UAI_GetAgentLowest(-2, $a_f_AggroRange, $GC_UAI_AGENT_HP, "UAI_Filter_IsLivingEnemy")
EndFunc
Func CanUse_ShadowPrison()
	If Anti_Hex() Then Return False
	Return True
EndFunc
Func BestTarget_ShadowPrison($a_f_AggroRange)
	Local $l_i_Target = UAI_GetAgentLowest(-2, $a_f_AggroRange, $GC_UAI_AGENT_HP, "UAI_Filter_IsLivingEnemy|UAI_Filter_IsMoving")
	If $l_i_Target <> 0 Then Return $l_i_Target
	Return UAI_GetAgentLowest(-2, $a_f_AggroRange, $GC_UAI_AGENT_HP, "UAI_Filter_IsLivingEnemy")
EndFunc
Func CanUse_PriceOfPride()
	If Anti_Hex() Then Return False
	Return True
EndFunc
Func BestTarget_PriceOfPride($a_f_AggroRange)
	Return UAI_GetAgentLowest(-2, $a_f_AggroRange, $GC_UAI_AGENT_HP, "UAI_Filter_IsLivingEnemy|UAI_Filter_IsCaster")
EndFunc
Func CanUse_AirOfDisenchantment()
	If Anti_Hex() Then Return False
	Return True
EndFunc
Func BestTarget_AirOfDisenchantment($a_f_AggroRange)
	Return UAI_GetBestAOETarget(-2, $a_f_AggroRange, $GC_I_RANGE_NEARBY, "UAI_Filter_IsLivingEnemy")
EndFunc
Func CanUse_DefendersZeal()
	If Anti_Hex() Then Return False
	Return True
EndFunc
Func BestTarget_DefendersZeal($a_f_AggroRange)
	Return UAI_GetAgentLowest(-2, $a_f_AggroRange, $GC_UAI_AGENT_HP, "UAI_Filter_IsLivingEnemy|UAI_Filter_IsAttacking")
EndFunc
Func CanUse_WordsOfMadnessQwytzylkak()
	If Anti_Hex() Then Return False
	Return True
EndFunc
Func BestTarget_WordsOfMadnessQwytzylkak($a_f_AggroRange)
	Return UAI_GetPlayerInfo($GC_UAI_AGENT_ID)
EndFunc
Func CanUse_MadnessDart()
	If Anti_Hex() Then Return False
	Return True
EndFunc
Func BestTarget_MadnessDart($a_f_AggroRange)
	Return UAI_GetAgentLowest(-2, $a_f_AggroRange, $GC_UAI_AGENT_HP, "UAI_Filter_IsLivingEnemy")
EndFunc
Func CanUse_BondsOfTorment()
	If Anti_Hex() Then Return False
	Return True
EndFunc
Func BestTarget_BondsOfTorment($a_f_AggroRange)
	Return UAI_GetBestAOETarget(-2, $a_f_AggroRange, $GC_I_RANGE_NEARBY, "UAI_Filter_IsLivingEnemy")
EndFunc
Func CanUse_EtherNightmareLuxon()
	If Anti_Hex() Then Return False
	Return True
EndFunc
Func BestTarget_EtherNightmareLuxon($a_f_AggroRange)
	Return UAI_GetAgentLowest(-2, $a_f_AggroRange, $GC_UAI_AGENT_HP, "UAI_Filter_IsLivingEnemy")
EndFunc
Func CanUse_SumOfAllFears()
	If Anti_Hex() Then Return False
	Return True
EndFunc
Func BestTarget_SumOfAllFears($a_f_AggroRange)
	Local $l_i_Target = UAI_GetAgentLowest(-2, $a_f_AggroRange, $GC_UAI_AGENT_HP, "UAI_Filter_IsLivingEnemy|UAI_Filter_IsMoving")
	If $l_i_Target <> 0 Then Return $l_i_Target
	Return UAI_GetAgentLowest(-2, $a_f_AggroRange, $GC_UAI_AGENT_HP, "UAI_Filter_IsLivingEnemy")
EndFunc
Func CanUse_Cacophony()
	If Anti_Hex() Then Return False
	Return True
EndFunc
Func BestTarget_Cacophony($a_f_AggroRange)
	Return UAI_GetAgentLowest(-2, $a_f_AggroRange, $GC_UAI_AGENT_HP, "UAI_Filter_IsLivingEnemy")
EndFunc
Func CanUse_WintersEmbrace()
	If Anti_Hex() Then Return False
	Return True
EndFunc
Func BestTarget_WintersEmbrace($a_f_AggroRange)
	Local $l_i_Target = UAI_GetAgentLowest(-2, $a_f_AggroRange, $GC_UAI_AGENT_HP, "UAI_Filter_IsLivingEnemy|UAI_Filter_IsMoving")
	If $l_i_Target <> 0 Then Return $l_i_Target
	Return UAI_GetAgentLowest(-2, $a_f_AggroRange, $GC_UAI_AGENT_HP, "UAI_Filter_IsLivingEnemy")
EndFunc
Func CanUse_EarthenShackles()
	If Anti_Hex() Then Return False
	Return True
EndFunc
Func BestTarget_EarthenShackles($a_f_AggroRange)
	Return UAI_GetBestAOETarget(-2, $a_f_AggroRange, $GC_I_RANGE_NEARBY, "UAI_Filter_IsLivingEnemy")
EndFunc
Func CanUse_ShadowFang()
	If Anti_Hex() Then Return False
	Return True
EndFunc
Func BestTarget_ShadowFang($a_f_AggroRange)
	Return UAI_GetAgentLowest(-2, $a_f_AggroRange, $GC_UAI_AGENT_HP, "UAI_Filter_IsLivingEnemy")
EndFunc
Func CanUse_CalculatedRisk()
	If Anti_Hex() Then Return False
	Return True
EndFunc
Func BestTarget_CalculatedRisk($a_f_AggroRange)
	Return UAI_GetAgentLowest(-2, $a_f_AggroRange, $GC_UAI_AGENT_HP, "UAI_Filter_IsLivingEnemy|UAI_Filter_IsAttacking")
EndFunc
Func CanUse_ShrinkingArmor()
	If Anti_Hex() Then Return False
	Return True
EndFunc
Func BestTarget_ShrinkingArmor($a_f_AggroRange)
	Return UAI_GetAgentLowest(-2, $a_f_AggroRange, $GC_UAI_AGENT_HP, "UAI_Filter_IsLivingEnemy")
EndFunc
Func CanUse_WanderingEye()
	If Anti_Hex() Then Return False
	Return True
EndFunc
Func BestTarget_WanderingEye($a_f_AggroRange)
	Return UAI_GetBestAOETarget(-2, 1320, $GC_I_RANGE_NEARBY, "UAI_Filter_IsLivingEnemy")
EndFunc
Func CanUse_PutridBile()
	If Anti_Hex() Then Return False
	Return True
EndFunc
Func BestTarget_PutridBile($a_f_AggroRange)
	Return UAI_GetBestAOETarget(-2, $a_f_AggroRange, $GC_I_RANGE_NEARBY, "UAI_Filter_IsLivingEnemy")
EndFunc
Func CanUse_SnaringWeb()
	If Anti_Hex() Then Return False
	Return True
EndFunc
Func BestTarget_SnaringWeb($a_f_AggroRange)
	Return UAI_GetBestAOETarget(-2, $a_f_AggroRange, $GC_I_RANGE_NEARBY, "UAI_Filter_IsLivingEnemy")
EndFunc
Func CanUse_WurmBile()
	If Anti_Hex() Then Return False
	Return True
EndFunc
Func BestTarget_WurmBile($a_f_AggroRange)
	Return UAI_GetBestAOETarget(-2, $a_f_AggroRange, $GC_I_RANGE_NEARBY, "UAI_Filter_IsLivingEnemy")
EndFunc
Func CanUse_EtherNightmareKurzick()
	If Anti_Hex() Then Return False
	Return True
EndFunc
Func BestTarget_EtherNightmareKurzick($a_f_AggroRange)
	Return UAI_GetAgentLowest(-2, $a_f_AggroRange, $GC_UAI_AGENT_HP, "UAI_Filter_IsLivingEnemy")
EndFunc
Func CanUse_SpiritWorldRetreat()
	If Anti_Hex() Then Return False
	Return True
EndFunc
Func BestTarget_SpiritWorldRetreat($a_f_AggroRange)
	Return UAI_GetPlayerInfo($GC_UAI_AGENT_ID)
EndFunc
Func CanUse_ConfusingImages()
	If Anti_Hex() Then Return False
	Return True
EndFunc
Func BestTarget_ConfusingImages($a_f_AggroRange)
	Return UAI_GetAgentLowest(-2, $a_f_AggroRange, $GC_UAI_AGENT_HP, "UAI_Filter_IsLivingEnemy|UAI_Filter_IsCaster")
EndFunc
Func CanUse_DefileDefenses()
	If Anti_Hex() Then Return False
	Return True
EndFunc
Func BestTarget_DefileDefenses($a_f_AggroRange)
	Return UAI_GetAgentLowest(-2, $a_f_AggroRange, $GC_UAI_AGENT_HP, "UAI_Filter_IsLivingEnemy|UAI_Filter_IsAttacking")
EndFunc
Func CanUse_Atrophy()
	If Anti_Hex() Then Return False
	Return True
EndFunc
Func BestTarget_Atrophy($a_f_AggroRange)
	Return UAI_GetAgentLowest(-2, $a_f_AggroRange, $GC_UAI_AGENT_HP, "UAI_Filter_IsLivingEnemy")
EndFunc
Func CanUse_PolymockGlyphDestabilization()
	If Anti_Hex() Then Return False
	Return True
EndFunc
Func BestTarget_PolymockGlyphDestabilization($a_f_AggroRange)
	Return UAI_GetAgentLowest(-2, $a_f_AggroRange, $GC_UAI_AGENT_HP, "UAI_Filter_IsLivingEnemy")
EndFunc
Func CanUse_PolymockMindWreck()
	If Anti_Hex() Then Return False
	Return True
EndFunc
Func BestTarget_PolymockMindWreck($a_f_AggroRange)
	Return UAI_GetAgentLowest(-2, $a_f_AggroRange, $GC_UAI_AGENT_HP, "UAI_Filter_IsLivingEnemy|UAI_Filter_IsCaster")
EndFunc
Func CanUse_PolymockRisingBile()
	If Anti_Hex() Then Return False
	Return True
EndFunc
Func BestTarget_PolymockRisingBile($a_f_AggroRange)
	Return UAI_GetBestAOETarget(-2, $a_f_AggroRange, $GC_I_RANGE_AREA, "UAI_Filter_IsLivingEnemy")
EndFunc
Func CanUse_PolymockGlyphFreeze()
	If Anti_Hex() Then Return False
	Return True
EndFunc
Func BestTarget_PolymockGlyphFreeze($a_f_AggroRange)
	Return UAI_GetBestAOETarget(-2, $a_f_AggroRange, $GC_I_RANGE_AREA, "UAI_Filter_IsLivingEnemy")
EndFunc
Func CanUse_PolymockCalculatedRisk()
	If Anti_Hex() Then Return False
	Return True
EndFunc
Func BestTarget_PolymockCalculatedRisk($a_f_AggroRange)
	Return UAI_GetAgentLowest(-2, $a_f_AggroRange, $GC_UAI_AGENT_HP, "UAI_Filter_IsLivingEnemy|UAI_Filter_IsAttacking")
EndFunc
Func CanUse_PolymockRecurringInsecurity()
	If Anti_Hex() Then Return False
	Return True
EndFunc
Func BestTarget_PolymockRecurringInsecurity($a_f_AggroRange)
	Return UAI_GetAgentLowest(-2, $a_f_AggroRange, $GC_UAI_AGENT_HP, "UAI_Filter_IsLivingEnemy")
EndFunc
Func CanUse_PolymockBackfire()
	If Anti_Hex() Then Return False
	Return True
EndFunc
Func BestTarget_PolymockBackfire($a_f_AggroRange)
	Return UAI_GetAgentLowest(-2, $a_f_AggroRange, $GC_UAI_AGENT_HP, "UAI_Filter_IsLivingEnemy|UAI_Filter_IsCaster")
EndFunc
Func CanUse_PolymockGuilt()
	If Anti_Hex() Then Return False
	Return True
EndFunc
Func BestTarget_PolymockGuilt($a_f_AggroRange)
	Return UAI_GetAgentLowest(-2, $a_f_AggroRange, $GC_UAI_AGENT_HP, "UAI_Filter_IsLivingEnemy|UAI_Filter_IsCaster")
EndFunc
Func CanUse_PolymockPainfulBond()
	If Anti_Hex() Then Return False
	Return True
EndFunc
Func BestTarget_PolymockPainfulBond($a_f_AggroRange)
	Return UAI_GetBestAOETarget(-2, $a_f_AggroRange, $GC_I_RANGE_NEARBY, "UAI_Filter_IsLivingEnemy")
EndFunc
Func CanUse_PolymockMigraine()
	If Anti_Hex() Then Return False
	Return True
EndFunc
Func BestTarget_PolymockMigraine($a_f_AggroRange)
	Return UAI_GetAgentLowest(-2, $a_f_AggroRange, $GC_UAI_AGENT_HP, "UAI_Filter_IsLivingEnemy|UAI_Filter_IsCaster")
EndFunc
Func CanUse_PolymockDiversion()
	If Anti_Hex() Then Return False
	Return True
EndFunc
Func BestTarget_PolymockDiversion($a_f_AggroRange)
	Return UAI_GetAgentLowest(-2, $a_f_AggroRange, $GC_UAI_AGENT_HP, "UAI_Filter_IsLivingEnemy|UAI_Filter_IsCaster")
EndFunc
Func CanUse_PolymockIcyBonds()
	If Anti_Hex() Then Return False
	Return True
EndFunc
Func BestTarget_PolymockIcyBonds($a_f_AggroRange)
	Return UAI_GetBestAOETarget(-2, $a_f_AggroRange, $GC_I_RANGE_NEARBY, "UAI_Filter_IsLivingEnemy")
EndFunc
Func CanUse_CrystalSnare()
	If Anti_Hex() Then Return False
	Return True
EndFunc
Func BestTarget_CrystalSnare($a_f_AggroRange)
	Return UAI_GetPlayerInfo($GC_UAI_AGENT_ID)
EndFunc
Func CanUse_ParanoidIndignation()
	If Anti_Hex() Then Return False
	Return True
EndFunc
Func BestTarget_ParanoidIndignation($a_f_AggroRange)
	Return UAI_GetPlayerInfo($GC_UAI_AGENT_ID)
EndFunc
Func CanUse_ATouchOfGuile()
	If Anti_Hex() Then Return False
	Return True
EndFunc
Func BestTarget_ATouchOfGuile($a_f_AggroRange)
	Return UAI_GetAgentLowest(-2, $a_f_AggroRange, $GC_UAI_AGENT_HP, "UAI_Filter_IsLivingEnemy|UAI_Filter_IsAttacking")
EndFunc
Func CanUse_AsuranScan()
	If Anti_Hex() Then Return False
	Return True
EndFunc
Func BestTarget_AsuranScan($a_f_AggroRange)
	Return UAI_GetAgentLowest(-2, $a_f_AggroRange, $GC_UAI_AGENT_HP, "UAI_Filter_IsLivingEnemy")
EndFunc
Func CanUse_PainInverter()
	If Anti_Hex() Then Return False
	Return True
EndFunc
Func BestTarget_PainInverter($a_f_AggroRange)
	Return UAI_GetBestSingleTarget(-2, $a_f_AggroRange, $GC_UAI_AGENT_HP, "UAI_Filter_IsLivingEnemy")
EndFunc
Func CanUse_TongueLash()
	If Anti_Hex() Then Return False
	Return True
EndFunc
Func BestTarget_TongueLash($a_f_AggroRange)
	Return UAI_GetAgentLowest(-2, $a_f_AggroRange, $GC_UAI_AGENT_HP, "UAI_Filter_IsLivingEnemy")
EndFunc
Func CanUse_Unreliable()
	If Anti_Hex() Then Return False
	Return True
EndFunc
Func BestTarget_Unreliable($a_f_AggroRange)
	Return UAI_GetPlayerInfo($GC_UAI_AGENT_ID)
EndFunc
Func CanUse_TheMastersMark()
	If Anti_Hex() Then Return False
	Return True
EndFunc
Func BestTarget_TheMastersMark($a_f_AggroRange)
	Return UAI_GetAgentLowest(-2, $a_f_AggroRange, $GC_UAI_AGENT_HP, "UAI_Filter_IsLivingEnemy")
EndFunc
Func CanUse_TongueWhip()
	If Anti_Hex() Then Return False
	Return True
EndFunc
Func BestTarget_TongueWhip($a_f_AggroRange)
	Return UAI_GetAgentLowest(-2, $a_f_AggroRange, $GC_UAI_AGENT_HP, "UAI_Filter_IsLivingEnemy")
EndFunc
Func CanUse_Dishonorable()
	If Anti_Hex() Then Return False
	Return True
EndFunc
Func BestTarget_Dishonorable($a_f_AggroRange)
	Return UAI_GetPlayerInfo($GC_UAI_AGENT_ID)
EndFunc
Func CanUse_ReapersMark2()
	If Anti_Hex() Then Return False
	Return True
EndFunc
Func BestTarget_ReapersMark2($a_f_AggroRange)
	Return UAI_GetAgentLowest(-2, $a_f_AggroRange, $GC_UAI_AGENT_HP, "UAI_Filter_IsLivingEnemy")
EndFunc
Func CanUse_SpectralAgonySaulDalessio()
	If Anti_Hex() Then Return False
	Return True
EndFunc
Func BestTarget_SpectralAgonySaulDalessio($a_f_AggroRange)
	Return UAI_GetAgentLowest(-2, $a_f_AggroRange, $GC_UAI_AGENT_HP, "UAI_Filter_IsLivingEnemy")
EndFunc
Func CanUse_SharedBurdenGwen()
	If Anti_Hex() Then Return False
	Return True
EndFunc
Func BestTarget_SharedBurdenGwen($a_f_AggroRange)
	Return UAI_GetBestAOETarget(-2, $a_f_AggroRange, $GC_I_RANGE_NEARBY, "UAI_Filter_IsLivingEnemy")
EndFunc
Func CanUse_SumOfAllFearsGwen()
	If Anti_Hex() Then Return False
	Return True
EndFunc
Func BestTarget_SumOfAllFearsGwen($a_f_AggroRange)
	Local $l_i_Target = UAI_GetAgentLowest(-2, $a_f_AggroRange, $GC_UAI_AGENT_HP, "UAI_Filter_IsLivingEnemy|UAI_Filter_IsMoving")
	If $l_i_Target <> 0 Then Return $l_i_Target
	Return UAI_GetAgentLowest(-2, $a_f_AggroRange, $GC_UAI_AGENT_HP, "UAI_Filter_IsLivingEnemy")
EndFunc
Func CanUse_MindWrackPvp()
	If Anti_Hex() Then Return False
	Return True
EndFunc
Func BestTarget_MindWrackPvp($a_f_AggroRange)
	Return UAI_GetAgentLowest(-2, $a_f_AggroRange, $GC_UAI_AGENT_HP, "UAI_Filter_IsLivingEnemy|UAI_Filter_IsCaster")
EndFunc
Func CanUse_MadKingsFan()
	If Anti_Hex() Then Return False
	Return True
EndFunc
Func BestTarget_MadKingsFan($a_f_AggroRange)
	Return UAI_GetPlayerInfo($GC_UAI_AGENT_ID)
EndFunc
Func CanUse_MindFreezePvp()
	If Anti_Hex() Then Return False
	Return True
EndFunc
Func BestTarget_MindFreezePvp($a_f_AggroRange)
	Return UAI_GetAgentLowest(-2, $a_f_AggroRange, $GC_UAI_AGENT_HP, "UAI_Filter_IsLivingEnemy|UAI_Filter_IsCaster")
EndFunc
Func CanUse_TargetAcquisition()
	If Anti_Hex() Then Return False
	Return True
EndFunc
Func BestTarget_TargetAcquisition($a_f_AggroRange)
	Return UAI_GetAgentLowest(-2, $a_f_AggroRange, $GC_UAI_AGENT_HP, "UAI_Filter_IsLivingEnemy")
EndFunc
Func CanUse_NoxPhantom()
	If Anti_Hex() Then Return False
	Return True
EndFunc
Func BestTarget_NoxPhantom($a_f_AggroRange)
	Return UAI_GetAgentLowest(-2, $a_f_AggroRange, $GC_UAI_AGENT_HP, "UAI_Filter_IsLivingEnemy")
EndFunc
Func CanUse_FragilityPvp()
	If Anti_Hex() Then Return False
	Return True
EndFunc
Func BestTarget_FragilityPvp($a_f_AggroRange)
	Return UAI_GetBestAOETarget(-2, 1320, $GC_I_RANGE_ADJACENT, "UAI_Filter_IsLivingEnemy")
EndFunc
Func CanUse_WeightOfDhuumHex()
	If Anti_Hex() Then Return False
	Return True
EndFunc
Func BestTarget_WeightOfDhuumHex($a_f_AggroRange)
	Return UAI_GetAgentLowest(-2, $a_f_AggroRange, $GC_UAI_AGENT_HP, "UAI_Filter_IsLivingEnemy")
EndFunc
Func CanUse_EmpathyPvp()
	If Anti_Hex() Then Return False
	Return True
EndFunc
Func BestTarget_EmpathyPvp($a_f_AggroRange)
	Local $l_i_Target = UAI_GetAgentLowest(-2, $a_f_AggroRange, $GC_UAI_AGENT_HP, "UAI_Filter_IsLivingEnemy|UAI_Filter_IsAttacking")
	If $l_i_Target <> 0 Then Return $l_i_Target
	Return UAI_GetAgentLowest(-2, $a_f_AggroRange, $GC_UAI_AGENT_HP, "UAI_Filter_IsLivingEnemy")
EndFunc
Func CanUse_CripplingAnguishPvp()
	If Anti_Hex() Then Return False
	Return True
EndFunc
Func BestTarget_CripplingAnguishPvp($a_f_AggroRange)
	Local $l_i_Target = UAI_GetAgentLowest(-2, $a_f_AggroRange, $GC_UAI_AGENT_HP, "UAI_Filter_IsLivingEnemy|UAI_Filter_IsAttacking")
	If $l_i_Target <> 0 Then Return $l_i_Target
	Return UAI_GetAgentLowest(-2, $a_f_AggroRange, $GC_UAI_AGENT_HP, "UAI_Filter_IsLivingEnemy")
EndFunc
Func CanUse_PanicPvp()
	If Anti_Hex() Then Return False
	Return True
EndFunc
Func BestTarget_PanicPvp($a_f_AggroRange)
	Return UAI_GetBestAOETarget(-2, 1320, $GC_I_RANGE_NEARBY, "UAI_Filter_IsLivingEnemy")
EndFunc
Func CanUse_MigrainePvp()
	If Anti_Hex() Then Return False
	Return True
EndFunc
Func BestTarget_MigrainePvp($a_f_AggroRange)
	Return UAI_GetAgentLowest(-2, $a_f_AggroRange, $GC_UAI_AGENT_HP, "UAI_Filter_IsLivingEnemy|UAI_Filter_IsCaster")
EndFunc
Func CanUse_SharedBurdenPvp()
	If Anti_Hex() Then Return False
	Return True
EndFunc
Func BestTarget_SharedBurdenPvp($a_f_AggroRange)
	Return UAI_GetBestAOETarget(-2, $a_f_AggroRange, $GC_I_RANGE_NEARBY, "UAI_Filter_IsLivingEnemy")
EndFunc
Func CanUse_StolenSpeedPvp()
	If Anti_Hex() Then Return False
	Return True
EndFunc
Func BestTarget_StolenSpeedPvp($a_f_AggroRange)
	Return 0
EndFunc
Func CanUse_FrustrationPvp()
	If Anti_Hex() Then Return False
	Return True
EndFunc
Func BestTarget_FrustrationPvp($a_f_AggroRange)
	Return 0
EndFunc
Func CanUse_MistrustPvp()
	If Anti_Hex() Then Return False
	Return True
EndFunc
Func BestTarget_MistrustPvp($a_f_AggroRange)
	Return 0
EndFunc
Func CanUse_EnchantersConundrumPvp()
	If Anti_Hex() Then Return False
	Return True
EndFunc
Func BestTarget_EnchantersConundrumPvp($a_f_AggroRange)
	Return 0
EndFunc
Func CanUse_WanderingEyePvp()
	If Anti_Hex() Then Return False
	Return True
EndFunc
Func BestTarget_WanderingEyePvp($a_f_AggroRange)
	Return 0
EndFunc
Func CanUse_CalculatedRiskPvp()
	If Anti_Hex() Then Return False
	Return True
EndFunc
Func BestTarget_CalculatedRiskPvp($a_f_AggroRange)
	Return 0
EndFunc
Func CanUse_IsaiahsBalance()
	If Anti_Hex() Then Return False
	Return True
EndFunc
Func BestTarget_IsaiahsBalance($a_f_AggroRange)
	Return 0
EndFunc
Func CanUse_WastrelsDemisePvp()
	If Anti_Hex() Then Return False
	Return True
EndFunc
Func BestTarget_WastrelsDemisePvp($a_f_AggroRange)
	Return 0
EndFunc
Func CanUse_SpoilVictorPvp()
	If Anti_Hex() Then Return False
	Return True
EndFunc
Func BestTarget_SpoilVictorPvp($a_f_AggroRange)
	Return 0
EndFunc
Func CanUse_VisionsOfRegretPvp()
	If Anti_Hex() Then Return False
	Return True
EndFunc
Func BestTarget_VisionsOfRegretPvp($a_f_AggroRange)
	Return 0
EndFunc
Func CanUse_PromiseOfDeath()
	If Anti_Hex() Then Return False
	Return True
EndFunc
Func BestTarget_PromiseOfDeath($a_f_AggroRange)
	Return 0
EndFunc
Func CanUse_FeveredDreamsPvp()
	If Anti_Hex() Then Return False
	Return True
EndFunc
Func BestTarget_FeveredDreamsPvp($a_f_AggroRange)
	Return 0
EndFunc
Func CanUse_SkyNet()
	If Anti_Hex() Then Return False
	Return True
EndFunc
Func BestTarget_SkyNet($a_f_AggroRange)
	Return 0
EndFunc
Func CanUse_IllusionOfPainPvp()
	If Anti_Hex() Then Return False
	Return True
EndFunc
Func BestTarget_IllusionOfPainPvp($a_f_AggroRange)
	Return 0
EndFunc
Func CanUse_WebOfDisruptionPvp()
	If Anti_Hex() Then Return False
	Return True
EndFunc
Func BestTarget_WebOfDisruptionPvp($a_f_AggroRange)
	Return 0
EndFunc