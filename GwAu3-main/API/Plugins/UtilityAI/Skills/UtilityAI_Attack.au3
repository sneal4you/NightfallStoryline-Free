#include-once
Func Anti_Attack()
	If UAI_PlayerHasEffect($GC_I_SKILL_ID_BLIND) Then Return True
	If Not UAI_GetPlayerInfo($GC_UAI_AGENT_IsHexed) Then Return False
	If UAI_PlayerHasEffect($GC_I_SKILL_ID_Spirit_Shackles) Then Return True
	If UAI_PlayerHasEffect($GC_I_SKILL_ID_INEPTITUDE) Then Return True
	If UAI_PlayerHasEffect($GC_I_SKILL_ID_CLUMSINESS) Then Return True
	If UAI_PlayerHasEffect($GC_I_SKILL_ID_WANDERING_EYE) Then Return True
	Local $l_i_IncomingDamage = 0
	If UAI_PlayerHasEffect($GC_I_SKILL_ID_EMPATHY) Then $l_i_IncomingDamage += UAI_GetPlayerEffectInfo($GC_I_SKILL_ID_EMPATHY, $GC_UAI_EFFECT_Scale)
	If UAI_PlayerHasEffect($GC_I_SKILL_ID_SPITEFUL_SPIRIT) Then $l_i_IncomingDamage += UAI_GetPlayerEffectInfo($GC_I_SKILL_ID_SPITEFUL_SPIRIT, $GC_UAI_EFFECT_Scale)
	If UAI_PlayerHasEffect($GC_I_SKILL_ID_SPOIL_VICTOR) Then $l_i_IncomingDamage += UAI_GetPlayerEffectInfo($GC_I_SKILL_ID_SPOIL_VICTOR, $GC_UAI_EFFECT_Scale)
	Return ($l_i_IncomingDamage > (UAI_GetPlayerInfo($GC_UAI_AGENT_CurrentHP) + UAI_GetPlayerInfo($GC_UAI_AGENT_MaxHP * 0.15)))
EndFunc
Func CanUse_Hamstring()
	If Anti_Attack() Then Return False
	Return True
EndFunc
Func BestTarget_Hamstring($a_f_AggroRange)
	Return UAI_GetNearestAgent(-2, $a_f_AggroRange, "UAI_Filter_IsLivingEnemy")
EndFunc
Func CanUse_WildBlow()
	If Anti_Attack() Then Return False
	Return True
EndFunc
Func BestTarget_WildBlow($a_f_AggroRange)
	Return UAI_GetNearestAgent(-2, $a_f_AggroRange, "UAI_Filter_IsLivingEnemy")
EndFunc
Func CanUse_PowerAttack()
	If Anti_Attack() Then Return False
	Return True
EndFunc
Func BestTarget_PowerAttack($a_f_AggroRange)
	Return UAI_GetNearestAgent(-2, $a_f_AggroRange, "UAI_Filter_IsLivingEnemy")
EndFunc
Func CanUse_DesperationBlow()
	If Anti_Attack() Then Return False
	Return True
EndFunc
Func BestTarget_DesperationBlow($a_f_AggroRange)
	Return UAI_GetNearestAgent(-2, $a_f_AggroRange, "UAI_Filter_IsLivingEnemy")
EndFunc
Func CanUse_ThrillOfVictory()
	If Anti_Attack() Then Return False
	Return True
EndFunc
Func BestTarget_ThrillOfVictory($a_f_AggroRange)
	Return UAI_GetNearestAgent(-2, $a_f_AggroRange, "UAI_Filter_IsLivingEnemy")
EndFunc
Func CanUse_DistractingBlow()
	If Anti_Attack() Then Return False
	Return True
EndFunc
Func BestTarget_DistractingBlow($a_f_AggroRange)
	Return UAI_GetNearestAgent(-2, $a_f_AggroRange, "UAI_Filter_IsLivingEnemy")
EndFunc
Func CanUse_ProtectorsStrike()
	If Anti_Attack() Then Return False
	Return True
EndFunc
Func BestTarget_ProtectorsStrike($a_f_AggroRange)
	Return UAI_GetNearestAgent(-2, $a_f_AggroRange, "UAI_Filter_IsLivingEnemy")
EndFunc
Func CanUse_GriffonsSweep()
	If Anti_Attack() Then Return False
	Return True
EndFunc
Func BestTarget_GriffonsSweep($a_f_AggroRange)
	Return UAI_GetNearestAgent(-2, $a_f_AggroRange, "UAI_Filter_IsLivingEnemy")
EndFunc
Func CanUse_PureStrike()
	If Anti_Attack() Then Return False
	Return True
EndFunc
Func BestTarget_PureStrike($a_f_AggroRange)
	Return UAI_GetNearestAgent(-2, $a_f_AggroRange, "UAI_Filter_IsLivingEnemy")
EndFunc
Func CanUse_SkullCrack()
	If Anti_Attack() Then Return False
	Return True
EndFunc
Func BestTarget_SkullCrack($a_f_AggroRange)
	Return UAI_GetNearestAgent(-2, $a_f_AggroRange, "UAI_Filter_IsLivingEnemy")
EndFunc
Func CanUse_CycloneAxe()
	If Anti_Attack() Then Return False
	If UAI_CountAgents($g_i_BestTarget, $GC_I_RANGE_ADJACENT, "UAI_Filter_IsLivingEnemy") < 2 Then Return False
	Return True
EndFunc
Func BestTarget_CycloneAxe($a_f_AggroRange)
	Return UAI_GetNearestAgent(-2, $a_f_AggroRange, "UAI_Filter_IsLivingEnemy")
EndFunc
Func CanUse_HammerBash()
	If Anti_Attack() Then Return False
	Return True
EndFunc
Func BestTarget_HammerBash($a_f_AggroRange)
	Return UAI_GetNearestAgent(-2, $a_f_AggroRange, "UAI_Filter_IsLivingEnemy")
EndFunc
Func CanUse_BullsStrike()
	If Anti_Attack() Then Return False
	Return True
EndFunc
Func BestTarget_BullsStrike($a_f_AggroRange)
	Return UAI_GetNearestAgent(-2, $a_f_AggroRange, "UAI_Filter_IsLivingEnemy")
EndFunc
Func CanUse_AxeRake()
	If Anti_Attack() Then Return False
	Return True
EndFunc
Func BestTarget_AxeRake($a_f_AggroRange)
	Local $l_i_Target = UAI_GetNearestAgent(-2, $a_f_AggroRange, "UAI_Filter_IsLivingEnemy|UAI_Filter_IsDeepWounded")
	If $l_i_Target <> 0 Then Return $l_i_Target
	Return UAI_GetNearestAgent(-2, $a_f_AggroRange, "UAI_Filter_IsLivingEnemy")
EndFunc
Func CanUse_Cleave()
	If Anti_Attack() Then Return False
	Return True
EndFunc
Func BestTarget_Cleave($a_f_AggroRange)
	Return UAI_GetNearestAgent(-2, $a_f_AggroRange, "UAI_Filter_IsLivingEnemy")
EndFunc
Func CanUse_ExecutionersStrike()
	If Anti_Attack() Then Return False
	Return True
EndFunc
Func BestTarget_ExecutionersStrike($a_f_AggroRange)
	Return UAI_GetNearestAgent(-2, $a_f_AggroRange, "UAI_Filter_IsLivingEnemy")
EndFunc
Func CanUse_Dismember()
	If Anti_Attack() Then Return False
	Return True
EndFunc
Func BestTarget_Dismember($a_f_AggroRange)
	Return UAI_GetNearestAgent(-2, $a_f_AggroRange, "UAI_Filter_IsLivingEnemy")
EndFunc
Func CanUse_Eviscerate()
	If Anti_Attack() Then Return False
	Return True
EndFunc
Func BestTarget_Eviscerate($a_f_AggroRange)
	Return UAI_GetNearestAgent(-2, $a_f_AggroRange, "UAI_Filter_IsLivingEnemy")
EndFunc
Func CanUse_PenetratingBlow()
	If Anti_Attack() Then Return False
	Return True
EndFunc
Func BestTarget_PenetratingBlow($a_f_AggroRange)
	Return UAI_GetNearestAgent(-2, $a_f_AggroRange, "UAI_Filter_IsLivingEnemy")
EndFunc
Func CanUse_DisruptingChop()
	If Anti_Attack() Then Return False
	Return True
EndFunc
Func BestTarget_DisruptingChop($a_f_AggroRange)
	Return UAI_GetNearestAgent(-2, $a_f_AggroRange, "UAI_Filter_IsLivingEnemy")
EndFunc
Func CanUse_SwiftChop()
	If Anti_Attack() Then Return False
	Return True
EndFunc
Func BestTarget_SwiftChop($a_f_AggroRange)
	Return UAI_GetNearestAgent(-2, $a_f_AggroRange, "UAI_Filter_IsLivingEnemy")
EndFunc
Func CanUse_AxeTwist()
	If Anti_Attack() Then Return False
	Return True
EndFunc
Func BestTarget_AxeTwist($a_f_AggroRange)
	Local $l_i_Target = UAI_GetNearestAgent(-2, $a_f_AggroRange, "UAI_Filter_IsLivingEnemy|UAI_Filter_IsDeepWounded")
	If $l_i_Target <> 0 Then Return $l_i_Target
	Return UAI_GetNearestAgent(-2, $a_f_AggroRange, "UAI_Filter_IsLivingEnemy")
EndFunc
Func CanUse_BellySmash()
	If Anti_Attack() Then Return False
	Return True
EndFunc
Func BestTarget_BellySmash($a_f_AggroRange)
	Local $l_i_Target = UAI_GetNearestAgent(-2, $a_f_AggroRange, "UAI_Filter_IsLivingEnemy|UAI_Filter_IsKnocked")
	If $l_i_Target <> 0 Then Return $l_i_Target
	Return UAI_GetNearestAgent(-2, $a_f_AggroRange, "UAI_Filter_IsLivingEnemy")
EndFunc
Func CanUse_MightyBlow()
	If Anti_Attack() Then Return False
	Return True
EndFunc
Func BestTarget_MightyBlow($a_f_AggroRange)
	Return UAI_GetNearestAgent(-2, $a_f_AggroRange, "UAI_Filter_IsLivingEnemy")
EndFunc
Func CanUse_CrushingBlow()
	If Anti_Attack() Then Return False
	Return True
EndFunc
Func BestTarget_CrushingBlow($a_f_AggroRange)
	Local $l_i_Target = UAI_GetNearestAgent(-2, $a_f_AggroRange, "UAI_Filter_IsLivingEnemy|UAI_Filter_IsKnocked")
	If $l_i_Target <> 0 Then Return $l_i_Target
	Return UAI_GetNearestAgent(-2, $a_f_AggroRange, "UAI_Filter_IsLivingEnemy")
EndFunc
Func CanUse_CrudeSwing()
	If Anti_Attack() Then Return False
	Return True
EndFunc
Func BestTarget_CrudeSwing($a_f_AggroRange)
	Return UAI_GetNearestAgent(-2, $a_f_AggroRange, "UAI_Filter_IsLivingEnemy")
EndFunc
Func CanUse_EarthShaker()
	If Anti_Attack() Then Return False
	Return True
EndFunc
Func BestTarget_EarthShaker($a_f_AggroRange)
	Return UAI_GetNearestAgent(-2, $a_f_AggroRange, "UAI_Filter_IsLivingEnemy")
EndFunc
Func CanUse_DevastatingHammer()
	If Anti_Attack() Then Return False
	Return True
EndFunc
Func BestTarget_DevastatingHammer($a_f_AggroRange)
	Return UAI_GetNearestAgent(-2, $a_f_AggroRange, "UAI_Filter_IsLivingEnemy")
EndFunc
Func CanUse_IrresistibleBlow()
	If Anti_Attack() Then Return False
	Return True
EndFunc
Func BestTarget_IrresistibleBlow($a_f_AggroRange)
	Return UAI_GetNearestAgent(-2, $a_f_AggroRange, "UAI_Filter_IsLivingEnemy")
EndFunc
Func CanUse_CounterBlow()
	If Anti_Attack() Then Return False
	Return True
EndFunc
Func BestTarget_CounterBlow($a_f_AggroRange)
	Local $l_i_Target = UAI_GetNearestAgent(-2, $a_f_AggroRange, "UAI_Filter_IsLivingEnemy|UAI_Filter_IsAttacking")
	If $l_i_Target <> 0 Then Return $l_i_Target
	Return UAI_GetNearestAgent(-2, $a_f_AggroRange, "UAI_Filter_IsLivingEnemy")
EndFunc
Func CanUse_Backbreaker()
	If Anti_Attack() Then Return False
	Return True
EndFunc
Func BestTarget_Backbreaker($a_f_AggroRange)
	Return UAI_GetNearestAgent(-2, $a_f_AggroRange, "UAI_Filter_IsLivingEnemy")
EndFunc
Func CanUse_HeavyBlow()
	If Anti_Attack() Then Return False
	Return True
EndFunc
Func BestTarget_HeavyBlow($a_f_AggroRange)
	Local $l_i_Target = UAI_GetNearestAgent(-2, $a_f_AggroRange, "UAI_Filter_IsLivingEnemy|UAI_Filter_IsWeakened")
	If $l_i_Target <> 0 Then Return $l_i_Target
	Return UAI_GetNearestAgent(-2, $a_f_AggroRange, "UAI_Filter_IsLivingEnemy")
EndFunc
Func CanUse_StaggeringBlow()
	If Anti_Attack() Then Return False
	Return True
EndFunc
Func BestTarget_StaggeringBlow($a_f_AggroRange)
	Return UAI_GetNearestAgent(-2, $a_f_AggroRange, "UAI_Filter_IsLivingEnemy")
EndFunc
Func CanUse_SeverArtery()
	If Anti_Attack() Then Return False
	Return True
EndFunc
Func BestTarget_SeverArtery($a_f_AggroRange)
	Return UAI_GetNearestAgent(-2, $a_f_AggroRange, "UAI_Filter_IsLivingEnemy")
EndFunc
Func CanUse_GalrathSlash()
	If Anti_Attack() Then Return False
	Return True
EndFunc
Func BestTarget_GalrathSlash($a_f_AggroRange)
	Return UAI_GetNearestAgent(-2, $a_f_AggroRange, "UAI_Filter_IsLivingEnemy")
EndFunc
Func CanUse_Gash()
	If Anti_Attack() Then Return False
	Return True
EndFunc
Func BestTarget_Gash($a_f_AggroRange)
	Return UAI_GetNearestAgent(-2, $a_f_AggroRange, "UAI_Filter_IsLivingEnemy|UAI_Filter_IsBleeding")
EndFunc
Func CanUse_FinalThrust()
	If Anti_Attack() Then Return False
	Return True
EndFunc
Func BestTarget_FinalThrust($a_f_AggroRange)
	Return UAI_GetAgentLowest(-2, $a_f_AggroRange, $GC_UAI_AGENT_HP, "UAI_Filter_IsLivingEnemy")
EndFunc
Func CanUse_SeekingBlade()
	If Anti_Attack() Then Return False
	Return True
EndFunc
Func BestTarget_SeekingBlade($a_f_AggroRange)
	Return UAI_GetNearestAgent(-2, $a_f_AggroRange, "UAI_Filter_IsLivingEnemy")
EndFunc
Func CanUse_SavageSlash()
	If Anti_Attack() Then Return False
	Return True
EndFunc
Func BestTarget_SavageSlash($a_f_AggroRange)
	Return UAI_GetNearestAgent(-2, $a_f_AggroRange, "UAI_Filter_IsLivingEnemy")
EndFunc
Func CanUse_HuntersShot()
	If Anti_Attack() Then Return False
	Return True
EndFunc
Func BestTarget_HuntersShot($a_f_AggroRange)
	Return UAI_GetNearestAgent(-2, $a_f_AggroRange, "UAI_Filter_IsLivingEnemy")
EndFunc
Func CanUse_PinDown()
	If Anti_Attack() Then Return False
	Return True
EndFunc
Func BestTarget_PinDown($a_f_AggroRange)
	Return UAI_GetNearestAgent(-2, $a_f_AggroRange, "UAI_Filter_IsLivingEnemy")
EndFunc
Func CanUse_CripplingShot()
	If Anti_Attack() Then Return False
	Return True
EndFunc
Func BestTarget_CripplingShot($a_f_AggroRange)
	Return UAI_GetNearestAgent(-2, $a_f_AggroRange, "UAI_Filter_IsLivingEnemy")
EndFunc
Func CanUse_PowerShot()
	If Anti_Attack() Then Return False
	Return True
EndFunc
Func BestTarget_PowerShot($a_f_AggroRange)
	Return UAI_GetAgentLowest(-2, $a_f_AggroRange, $GC_UAI_AGENT_HP, "UAI_Filter_IsLivingEnemy")
EndFunc
Func CanUse_Barrage()
	If Anti_Attack() Then Return False
	Return True
EndFunc
Func BestTarget_Barrage($a_f_AggroRange)
	Return UAI_GetNearestAgent(-2, $a_f_AggroRange, "UAI_Filter_IsLivingEnemy")
EndFunc
Func CanUse_DualShot()
	If Anti_Attack() Then Return False
	Return True
EndFunc
Func BestTarget_DualShot($a_f_AggroRange)
	Return UAI_GetAgentLowest(-2, $a_f_AggroRange, $GC_UAI_AGENT_HP, "UAI_Filter_IsLivingEnemy")
EndFunc
Func CanUse_QuickShot()
	If Anti_Attack() Then Return False
	Return True
EndFunc
Func BestTarget_QuickShot($a_f_AggroRange)
	Return UAI_GetNearestAgent(-2, $a_f_AggroRange, "UAI_Filter_IsLivingEnemy")
EndFunc
Func CanUse_PenetratingAttack()
	If Anti_Attack() Then Return False
	Return True
EndFunc
Func BestTarget_PenetratingAttack($a_f_AggroRange)
	Return UAI_GetNearestAgent(-2, $a_f_AggroRange, "UAI_Filter_IsLivingEnemy")
EndFunc
Func CanUse_DistractingShot()
	If Anti_Attack() Then Return False
	Return True
EndFunc
Func BestTarget_DistractingShot($a_f_AggroRange)
	Return UAI_GetNearestAgent(-2, $a_f_AggroRange, "UAI_Filter_IsLivingEnemy")
EndFunc
Func CanUse_PrecisionShot()
	If Anti_Attack() Then Return False
	Return True
EndFunc
Func BestTarget_PrecisionShot($a_f_AggroRange)
	Return UAI_GetNearestAgent(-2, $a_f_AggroRange, "UAI_Filter_IsLivingEnemy")
EndFunc
Func CanUse_DeterminedShot()
	If Anti_Attack() Then Return False
	Return True
EndFunc
Func BestTarget_DeterminedShot($a_f_AggroRange)
	Return UAI_GetNearestAgent(-2, $a_f_AggroRange, "UAI_Filter_IsLivingEnemy")
EndFunc
Func CanUse_CalledShot()
	If Anti_Attack() Then Return False
	Return True
EndFunc
Func BestTarget_CalledShot($a_f_AggroRange)
	Return UAI_GetNearestAgent(-2, $a_f_AggroRange, "UAI_Filter_IsLivingEnemy")
EndFunc
Func CanUse_PoisonArrow()
	If Anti_Attack() Then Return False
	Return True
EndFunc
Func BestTarget_PoisonArrow($a_f_AggroRange)
	Return UAI_GetNearestAgent(-2, $a_f_AggroRange, "UAI_Filter_IsLivingEnemy")
EndFunc
Func CanUse_OathShot()
	If Anti_Attack() Then Return False
	Return True
EndFunc
Func BestTarget_OathShot($a_f_AggroRange)
	Return UAI_GetNearestAgent(-2, $a_f_AggroRange, "UAI_Filter_IsLivingEnemy")
EndFunc
Func CanUse_DebilitatingShot()
	If Anti_Attack() Then Return False
	Return True
EndFunc
Func BestTarget_DebilitatingShot($a_f_AggroRange)
	Return UAI_GetNearestAgent(-2, $a_f_AggroRange, "UAI_Filter_IsLivingEnemy")
EndFunc
Func CanUse_PointBlankShot()
	If Anti_Attack() Then Return False
	If UAI_CountAgents($g_i_BestTarget, $GC_I_RANGE_NEARBY, "UAI_Filter_IsLivingEnemy") < 1 Then Return False
	Return True
EndFunc
Func BestTarget_PointBlankShot($a_f_AggroRange)
	Return UAI_GetAgentLowest(-2, $a_f_AggroRange, $GC_UAI_AGENT_HP, "UAI_Filter_IsLivingEnemy")
EndFunc
Func CanUse_ConcussionShot()
	If Anti_Attack() Then Return False
	Return True
EndFunc
Func BestTarget_ConcussionShot($a_f_AggroRange)
	Return UAI_GetNearestAgent(-2, $a_f_AggroRange, "UAI_Filter_IsLivingEnemy")
EndFunc
Func CanUse_PunishingShot()
	If Anti_Attack() Then Return False
	Return True
EndFunc
Func BestTarget_PunishingShot($a_f_AggroRange)
	Return UAI_GetNearestAgent(-2, $a_f_AggroRange, "UAI_Filter_IsLivingEnemy")
EndFunc
Func CanUse_SavageShot()
	If Anti_Attack() Then Return False
	Return True
EndFunc
Func BestTarget_SavageShot($a_f_AggroRange)
	Return UAI_GetNearestAgent(-2, $a_f_AggroRange, "UAI_Filter_IsLivingEnemy")
EndFunc
Func CanUse_IncendiaryArrows()
	If Anti_Attack() Then Return False
	Return True
EndFunc
Func BestTarget_IncendiaryArrows($a_f_AggroRange)
	Return UAI_GetNearestAgent(-2, $a_f_AggroRange, "UAI_Filter_IsLivingEnemy")
EndFunc
Func CanUse_SiegeAttack4()
	If Anti_Attack() Then Return False
	Return True
EndFunc
Func BestTarget_SiegeAttack4($a_f_AggroRange)
	Return UAI_GetPlayerInfo($GC_UAI_AGENT_ID)
EndFunc
Func CanUse_BrutalMauling()
	If Anti_Attack() Then Return False
	Return True
EndFunc
Func BestTarget_BrutalMauling($a_f_AggroRange)
	Return UAI_GetNearestAgent(-2, $a_f_AggroRange, "UAI_Filter_IsLivingEnemy")
EndFunc
Func CanUse_CripplingAttack()
	If Anti_Attack() Then Return False
	Return True
EndFunc
Func BestTarget_CripplingAttack($a_f_AggroRange)
	Return UAI_GetNearestAgent(-2, $a_f_AggroRange, "UAI_Filter_IsLivingEnemy")
EndFunc
Func CanUse_DozenShot()
	If Anti_Attack() Then Return False
	Return True
EndFunc
Func BestTarget_DozenShot($a_f_AggroRange)
	Return UAI_GetNearestAgent(-2, $a_f_AggroRange, "UAI_Filter_IsLivingEnemy")
EndFunc
Func CanUse_GiantStomp()
	If Anti_Attack() Then Return False
	Return True
EndFunc
Func BestTarget_GiantStomp($a_f_AggroRange)
	Return UAI_GetPlayerInfo($GC_UAI_AGENT_ID)
EndFunc
Func CanUse_AgnarsRage()
	If Anti_Attack() Then Return False
	Return True
EndFunc
Func BestTarget_AgnarsRage($a_f_AggroRange)
	Return UAI_GetPlayerInfo($GC_UAI_AGENT_ID)
EndFunc
Func CanUse_HungerOfTheLich()
	If Anti_Attack() Then Return False
	Return True
EndFunc
Func BestTarget_HungerOfTheLich($a_f_AggroRange)
	Return UAI_GetNearestAgent(-2, $a_f_AggroRange, "UAI_Filter_IsLivingEnemy")
EndFunc
Func CanUse_SiegeAttack1()
	If Anti_Attack() Then Return False
	Return True
EndFunc
Func BestTarget_SiegeAttack1($a_f_AggroRange)
	Return UAI_GetPlayerInfo($GC_UAI_AGENT_ID)
EndFunc
Func CanUse_SiegeAttack2()
	If Anti_Attack() Then Return False
	Return True
EndFunc
Func BestTarget_SiegeAttack2($a_f_AggroRange)
	Return UAI_GetPlayerInfo($GC_UAI_AGENT_ID)
EndFunc
Func CanUse_DeathBlossom()
	If Anti_Attack() Then Return False
	Return True
EndFunc
Func BestTarget_DeathBlossom($a_f_AggroRange)
	Return UAI_GetNearestAgent(-2, $a_f_AggroRange, "UAI_Filter_IsLivingEnemy|UAI_Filter_IsLastStrikeIsOffHand")
EndFunc
Func CanUse_TwistingFangs()
	If Anti_Attack() Then Return False
	Return True
EndFunc
Func BestTarget_TwistingFangs($a_f_AggroRange)
	Return UAI_GetNearestAgent(-2, $a_f_AggroRange, "UAI_Filter_IsLivingEnemy|UAI_Filter_IsLastStrikeIsOffHand")
EndFunc
Func CanUse_HornsOfTheOx()
	If Anti_Attack() Then Return False
	Return True
EndFunc
Func BestTarget_HornsOfTheOx($a_f_AggroRange)
	Return UAI_GetNearestAgent(-2, $a_f_AggroRange, "UAI_Filter_IsLivingEnemy|UAI_Filter_IsLastStrikeIsOffHand")
EndFunc
Func CanUse_FallingSpider()
	If Anti_Attack() Then Return False
	Return True
EndFunc
Func BestTarget_FallingSpider($a_f_AggroRange)
	Return UAI_GetNearestAgent(-2, $GC_I_RANGE_NEARBY, "UAI_Filter_IsLivingEnemy|UAI_Filter_IsKnocked")
EndFunc
Func CanUse_BlackLotusStrike()
	If Anti_Attack() Then Return False
	Local $l_i_CurrentTarget = Agent_GetCurrentTarget()
	If $l_i_CurrentTarget <> 0 Then Return Not UAI_Filter_IsLastStrikeLeadOrOffHand($l_i_CurrentTarget)
	Return True
EndFunc
Func BestTarget_BlackLotusStrike($a_f_AggroRange)
	Local $l_i_Target = UAI_GetNearestAgent(-2, $a_f_AggroRange, "UAI_Filter_IsLivingEnemy|UAI_Filter_IsHexed")
	If $l_i_Target <> 0 Then Return $l_i_Target
	Return UAI_GetNearestAgent(-2, $a_f_AggroRange, "UAI_Filter_IsLivingEnemy")
EndFunc
Func CanUse_FoxFangs()
	If Anti_Attack() Then Return False
	Return True
EndFunc
Func BestTarget_FoxFangs($a_f_AggroRange)
	Return UAI_GetNearestAgent(-2, $a_f_AggroRange, "UAI_Filter_IsLivingEnemy|UAI_Filter_IsLastStrikeIsLead")
EndFunc
Func CanUse_MoebiusStrike()
	If Anti_Attack() Then Return False
	Return True
EndFunc
Func BestTarget_MoebiusStrike($a_f_AggroRange)
	Local $l_i_Target = UAI_GetAgentLowest(-2, $a_f_AggroRange, $GC_UAI_AGENT_HP, "UAI_Filter_IsLivingEnemy|UAI_Filter_IsLastStrikeIsDual")
	If $l_i_Target <> 0 Then Return $l_i_Target
	Return UAI_GetNearestAgent(-2, $a_f_AggroRange, "UAI_Filter_IsLivingEnemy|UAI_Filter_IsLastStrikeIsDual")
EndFunc
Func CanUse_JaggedStrike()
	If Anti_Attack() Then Return False
	Local $l_i_CurrentTarget = Agent_GetCurrentTarget()
	If $l_i_CurrentTarget <> 0 Then Return Not UAI_Filter_IsLastStrikeLeadOrOffHand($l_i_CurrentTarget)
	Return True
EndFunc
Func BestTarget_JaggedStrike($a_f_AggroRange)
	Return UAI_GetNearestAgent(-2, $a_f_AggroRange, "UAI_Filter_IsLivingEnemy")
EndFunc
Func CanUse_UnsuspectingStrike()
	If Anti_Attack() Then Return False
	Local $l_i_CurrentTarget = Agent_GetCurrentTarget()
	If $l_i_CurrentTarget <> 0 Then Return Not UAI_Filter_IsLastStrikeLeadOrOffHand($l_i_CurrentTarget)
	Return True
EndFunc
Func BestTarget_UnsuspectingStrike($a_f_AggroRange)
	Return UAI_GetNearestAgent(-2, $a_f_AggroRange, "UAI_Filter_IsLivingEnemy")
EndFunc
Func CanUse_LaceratingChop()
	If Anti_Attack() Then Return False
	Return True
EndFunc
Func BestTarget_LaceratingChop($a_f_AggroRange)
	Local $l_i_Target = UAI_GetNearestAgent(-2, $a_f_AggroRange, "UAI_Filter_IsLivingEnemy|UAI_Filter_IsKnocked")
	If $l_i_Target <> 0 Then Return $l_i_Target
	Return UAI_GetNearestAgent(-2, $a_f_AggroRange, "UAI_Filter_IsLivingEnemy")
EndFunc
Func CanUse_FierceBlow()
	If Anti_Attack() Then Return False
	Return True
EndFunc
Func BestTarget_FierceBlow($a_f_AggroRange)
	Local $l_i_Target = UAI_GetNearestAgent(-2, $a_f_AggroRange, "UAI_Filter_IsLivingEnemy|UAI_Filter_IsWeakened")
	If $l_i_Target <> 0 Then Return $l_i_Target
	Return UAI_GetNearestAgent(-2, $a_f_AggroRange, "UAI_Filter_IsLivingEnemy")
EndFunc
Func CanUse_SunAndMoonSlash()
	If Anti_Attack() Then Return False
	Return True
EndFunc
Func BestTarget_SunAndMoonSlash($a_f_AggroRange)
	Return UAI_GetNearestAgent(-2, $a_f_AggroRange, "UAI_Filter_IsLivingEnemy")
EndFunc
Func CanUse_SplinterShot()
	If Anti_Attack() Then Return False
	Return True
EndFunc
Func BestTarget_SplinterShot($a_f_AggroRange)
	Return UAI_GetNearestAgent(-2, $a_f_AggroRange, "UAI_Filter_IsLivingEnemy")
EndFunc
Func CanUse_MelandrusShot()
	If Anti_Attack() Then Return False
	Return True
EndFunc
Func BestTarget_MelandrusShot($a_f_AggroRange)
	Return UAI_GetNearestAgent(-2, $a_f_AggroRange, "UAI_Filter_IsLivingEnemy")
EndFunc
Func CanUse_ShadowsongAttack()
	If Anti_Attack() Then Return False
	Return True
EndFunc
Func BestTarget_ShadowsongAttack($a_f_AggroRange)
	Return UAI_GetNearestAgent(-2, $a_f_AggroRange, "UAI_Filter_IsLivingEnemy")
EndFunc
Func CanUse_ConsumingFlames()
	If Anti_Attack() Then Return False
	Return True
EndFunc
Func BestTarget_ConsumingFlames($a_f_AggroRange)
	Return UAI_GetNearestAgent(-2, $a_f_AggroRange, "UAI_Filter_IsLivingEnemy")
EndFunc
Func CanUse_WhirlingAxe()
	If Anti_Attack() Then Return False
	Return True
EndFunc
Func BestTarget_WhirlingAxe($a_f_AggroRange)
	Return UAI_GetNearestAgent(-2, $a_f_AggroRange, "UAI_Filter_IsLivingEnemy")
EndFunc
Func CanUse_ForcefulBlow()
	If Anti_Attack() Then Return False
	Return True
EndFunc
Func BestTarget_ForcefulBlow($a_f_AggroRange)
	Return UAI_GetNearestAgent(-2, $a_f_AggroRange, "UAI_Filter_IsLivingEnemy")
EndFunc
Func CanUse_QuiveringBlade()
	If Anti_Attack() Then Return False
	Return True
EndFunc
Func BestTarget_QuiveringBlade($a_f_AggroRange)
	Return UAI_GetNearestAgent(-2, $a_f_AggroRange, "UAI_Filter_IsLivingEnemy")
EndFunc
Func CanUse_FuriousAxe()
	If Anti_Attack() Then Return False
	Return True
EndFunc
Func BestTarget_FuriousAxe($a_f_AggroRange)
	Return UAI_GetNearestAgent(-2, $a_f_AggroRange, "UAI_Filter_IsLivingEnemy")
EndFunc
Func CanUse_AuspiciousBlow()
	If Anti_Attack() Then Return False
	Return True
EndFunc
Func BestTarget_AuspiciousBlow($a_f_AggroRange)
	Return UAI_GetNearestAgent(-2, $a_f_AggroRange, "UAI_Filter_IsLivingEnemy")
EndFunc
Func CanUse_DragonSlash()
	If Anti_Attack() Then Return False
	Return True
EndFunc
Func BestTarget_DragonSlash($a_f_AggroRange)
	Return UAI_GetNearestAgent(-2, $a_f_AggroRange, "UAI_Filter_IsLivingEnemy")
EndFunc
Func CanUse_MaraudersShot()
	If Anti_Attack() Then Return False
	Return True
EndFunc
Func BestTarget_MaraudersShot($a_f_AggroRange)
	Return UAI_GetNearestAgent(-2, $a_f_AggroRange, "UAI_Filter_IsLivingEnemy")
EndFunc
Func CanUse_FocusedShot()
	If Anti_Attack() Then Return False
	Return True
EndFunc
Func BestTarget_FocusedShot($a_f_AggroRange)
	Return UAI_GetNearestAgent(-2, $a_f_AggroRange, "UAI_Filter_IsLivingEnemy")
EndFunc
Func CanUse_DissonanceAttack()
	If Anti_Attack() Then Return False
	Return True
EndFunc
Func BestTarget_DissonanceAttack($a_f_AggroRange)
	Return UAI_GetNearestAgent(-2, $a_f_AggroRange, "UAI_Filter_IsLivingEnemy")
EndFunc
Func CanUse_DisenchantmentAttack()
	If Anti_Attack() Then Return False
	Return True
EndFunc
Func BestTarget_DisenchantmentAttack($a_f_AggroRange)
	Return UAI_GetNearestAgent(-2, $a_f_AggroRange, "UAI_Filter_IsLivingEnemy")
EndFunc
Func CanUse_DesperateStrike()
	If Anti_Attack() Then Return False
	Local $l_i_CurrentTarget = Agent_GetCurrentTarget()
	If $l_i_CurrentTarget <> 0 Then Return Not UAI_Filter_IsLastStrikeLeadOrOffHand($l_i_CurrentTarget)
	Return True
EndFunc
Func BestTarget_DesperateStrike($a_f_AggroRange)
	Return UAI_GetNearestAgent(-2, $a_f_AggroRange, "UAI_Filter_IsLivingEnemy")
EndFunc
Func CanUse_ExhaustingAssault()
	If Anti_Attack() Then Return False
	Return True
EndFunc
Func BestTarget_ExhaustingAssault($a_f_AggroRange)
	Return UAI_GetNearestAgent(-2, $a_f_AggroRange, "UAI_Filter_IsLivingEnemy|UAI_Filter_IsLastStrikeIsLead")
EndFunc
Func CanUse_RepeatingStrike()
	If Anti_Attack() Then Return False
	Return True
EndFunc
Func BestTarget_RepeatingStrike($a_f_AggroRange)
	Return UAI_GetNearestAgent(-2, $a_f_AggroRange, "UAI_Filter_IsLivingEnemy|UAI_Filter_IsLastStrikeIsOffHand")
EndFunc
Func CanUse_NineTailStrike()
	If Anti_Attack() Then Return False
	Return True
EndFunc
Func BestTarget_NineTailStrike($a_f_AggroRange)
	Return UAI_GetNearestAgent(-2, $a_f_AggroRange, "UAI_Filter_IsLivingEnemy|UAI_Filter_IsLastStrikeIsOffHand")
EndFunc
Func CanUse_TempleStrike()
	If Anti_Attack() Then Return False
	Return True
EndFunc
Func BestTarget_TempleStrike($a_f_AggroRange)
	Return UAI_GetNearestAgent(-2, $a_f_AggroRange, "UAI_Filter_IsLivingEnemy|UAI_Filter_IsLastStrikeIsLead")
EndFunc
Func CanUse_GoldenPhoenixStrike()
	If Anti_Attack() Then Return False
	If Not UAI_GetPlayerInfo($GC_UAI_AGENT_IsEnchanted) Then Return False
	Return True
EndFunc
Func BestTarget_GoldenPhoenixStrike($a_f_AggroRange)
	Return UAI_GetNearestAgent(-2, $a_f_AggroRange, "UAI_Filter_IsLivingEnemy")
EndFunc
Func CanUse_TripleChop()
	If Anti_Attack() Then Return False
	Return True
EndFunc
Func BestTarget_TripleChop($a_f_AggroRange)
	Return UAI_GetNearestAgent(-2, $a_f_AggroRange, "UAI_Filter_IsLivingEnemy")
EndFunc
Func CanUse_EnragedSmash()
	If Anti_Attack() Then Return False
	Return True
EndFunc
Func BestTarget_EnragedSmash($a_f_AggroRange)
	Return UAI_GetNearestAgent(-2, $a_f_AggroRange, "UAI_Filter_IsLivingEnemy")
EndFunc
Func CanUse_RenewingSmash()
	If Anti_Attack() Then Return False
	Return True
EndFunc
Func BestTarget_RenewingSmash($a_f_AggroRange)
	Return UAI_GetNearestAgent(-2, $a_f_AggroRange, "UAI_Filter_IsLivingEnemy")
EndFunc
Func CanUse_StandingSlash()
	If Anti_Attack() Then Return False
	Return True
EndFunc
Func BestTarget_StandingSlash($a_f_AggroRange)
	Return UAI_GetNearestAgent(-2, $a_f_AggroRange, "UAI_Filter_IsLivingEnemy")
EndFunc
Func CanUse_CriticalStrike()
	If Anti_Attack() Then Return False
	Return True
EndFunc
Func BestTarget_CriticalStrike($a_f_AggroRange)
	Return UAI_GetNearestAgent(-2, $a_f_AggroRange, "UAI_Filter_IsLivingEnemy|UAI_Filter_IsLastStrikeIsOffHand")
EndFunc
Func CanUse_BladesOfSteel()
	If Anti_Attack() Then Return False
	Return True
EndFunc
Func BestTarget_BladesOfSteel($a_f_AggroRange)
	Return UAI_GetNearestAgent(-2, $a_f_AggroRange, "UAI_Filter_IsLivingEnemy|UAI_Filter_IsLastStrikeIsOffHand")
EndFunc
Func CanUse_JungleStrike()
	If Anti_Attack() Then Return False
	Return True
EndFunc
Func BestTarget_JungleStrike($a_f_AggroRange)
	Return UAI_GetNearestAgent(-2, $a_f_AggroRange, "UAI_Filter_IsLivingEnemy|UAI_Filter_IsLastStrikeIsLead")
EndFunc
Func CanUse_WildStrike()
	If Anti_Attack() Then Return False
	Return True
EndFunc
Func BestTarget_WildStrike($a_f_AggroRange)
	Return UAI_GetNearestAgent(-2, $a_f_AggroRange, "UAI_Filter_IsLivingEnemy|UAI_Filter_IsLastStrikeIsLead")
EndFunc
Func CanUse_LeapingMantisSting()
	If Anti_Attack() Then Return False
	Local $l_i_CurrentTarget = Agent_GetCurrentTarget()
	If $l_i_CurrentTarget <> 0 Then Return Not UAI_Filter_IsLastStrikeLeadOrOffHand($l_i_CurrentTarget)
	Return True
EndFunc
Func BestTarget_LeapingMantisSting($a_f_AggroRange)
	Return UAI_GetNearestAgent(-2, $a_f_AggroRange, "UAI_Filter_IsLivingEnemy")
EndFunc
Func CanUse_BlackMantisThrust()
	If Anti_Attack() Then Return False
	Local $l_i_CurrentTarget = Agent_GetCurrentTarget()
	If $l_i_CurrentTarget <> 0 Then Return Not UAI_Filter_IsLastStrikeLeadOrOffHand($l_i_CurrentTarget)
	Return True
EndFunc
Func BestTarget_BlackMantisThrust($a_f_AggroRange)
	Local $l_i_Target = UAI_GetNearestAgent(-2, $a_f_AggroRange, "UAI_Filter_IsLivingEnemy|UAI_Filter_IsHexed")
	If $l_i_Target <> 0 Then Return $l_i_Target
	Return UAI_GetNearestAgent(-2, $a_f_AggroRange, "UAI_Filter_IsLivingEnemy")
EndFunc
Func CanUse_DisruptingStab()
	If Anti_Attack() Then Return False
	Local $l_i_CurrentTarget = Agent_GetCurrentTarget()
	If $l_i_CurrentTarget <> 0 Then Return Not UAI_Filter_IsLastStrikeLeadOrOffHand($l_i_CurrentTarget)
	Return True
EndFunc
Func BestTarget_DisruptingStab($a_f_AggroRange)
	Return UAI_GetNearestAgent(-2, $a_f_AggroRange, "UAI_Filter_IsLivingEnemy")
EndFunc
Func CanUse_GoldenLotusStrike()
	If Anti_Attack() Then Return False
	Local $l_i_CurrentTarget = Agent_GetCurrentTarget()
	If $l_i_CurrentTarget <> 0 Then Return Not UAI_Filter_IsLastStrikeLeadOrOffHand($l_i_CurrentTarget)
	Return True
EndFunc
Func BestTarget_GoldenLotusStrike($a_f_AggroRange)
	Return UAI_GetNearestAgent(-2, $a_f_AggroRange, "UAI_Filter_IsLivingEnemy|UAI_Filter_IsLastStrikeIsLead")
EndFunc
Func CanUse_DrunkenBlow()
	If Anti_Attack() Then Return False
	Return True
EndFunc
Func BestTarget_DrunkenBlow($a_f_AggroRange)
	Return UAI_GetNearestAgent(-2, $a_f_AggroRange, "UAI_Filter_IsLivingEnemy")
EndFunc
Func CanUse_LeviathansSweep()
	If Anti_Attack() Then Return False
	Return True
EndFunc
Func BestTarget_LeviathansSweep($a_f_AggroRange)
	Return UAI_GetNearestAgent(-2, $a_f_AggroRange, "UAI_Filter_IsLivingEnemy")
EndFunc
Func CanUse_JaizhenjuStrike()
	If Anti_Attack() Then Return False
	Return True
EndFunc
Func BestTarget_JaizhenjuStrike($a_f_AggroRange)
	Return UAI_GetNearestAgent(-2, $a_f_AggroRange, "UAI_Filter_IsLivingEnemy")
EndFunc
Func CanUse_PenetratingChop()
	If Anti_Attack() Then Return False
	Return True
EndFunc
Func BestTarget_PenetratingChop($a_f_AggroRange)
	Return UAI_GetNearestAgent(-2, $a_f_AggroRange, "UAI_Filter_IsLivingEnemy")
EndFunc
Func CanUse_YetiSmash()
	If Anti_Attack() Then Return False
	Return True
EndFunc
Func BestTarget_YetiSmash($a_f_AggroRange)
	Return UAI_GetNearestAgent(-2, $a_f_AggroRange, "UAI_Filter_IsLivingEnemy")
EndFunc
Func CanUse_SilverwingSlash()
	If Anti_Attack() Then Return False
	Return True
EndFunc
Func BestTarget_SilverwingSlash($a_f_AggroRange)
	Return UAI_GetNearestAgent(-2, $a_f_AggroRange, "UAI_Filter_IsLivingEnemy")
EndFunc
Func CanUse_DarkChainLightning()
	If Anti_Attack() Then Return False
	Return True
EndFunc
Func BestTarget_DarkChainLightning($a_f_AggroRange)
	Return UAI_GetNearestAgent(-2, $a_f_AggroRange, "UAI_Filter_IsLivingEnemy")
EndFunc
Func CanUse_SunderingAttack()
	If Anti_Attack() Then Return False
	Return True
EndFunc
Func BestTarget_SunderingAttack($a_f_AggroRange)
	Return UAI_GetNearestAgent(-2, $a_f_AggroRange, "UAI_Filter_IsLivingEnemy")
EndFunc
Func CanUse_ZojunsShot()
	If Anti_Attack() Then Return False
	Return True
EndFunc
Func BestTarget_ZojunsShot($a_f_AggroRange)
	Return UAI_GetNearestAgent(-2, $a_f_AggroRange, "UAI_Filter_IsLivingEnemy")
EndFunc
Func CanUse_NeedlingShot()
	If Anti_Attack() Then Return False
	Return True
EndFunc
Func BestTarget_NeedlingShot($a_f_AggroRange)
	Return UAI_GetNearestAgent(-2, $a_f_AggroRange, "UAI_Filter_IsLivingEnemy")
EndFunc
Func CanUse_BroadHeadArrow()
	If Anti_Attack() Then Return False
	Return True
EndFunc
Func BestTarget_BroadHeadArrow($a_f_AggroRange)
	Return UAI_GetNearestAgent(-2, $a_f_AggroRange, "UAI_Filter_IsLivingEnemy")
EndFunc
Func CanUse_PainAttack()
	If Anti_Attack() Then Return False
	Return True
EndFunc
Func BestTarget_PainAttack($a_f_AggroRange)
	Return UAI_GetNearestAgent(-2, $a_f_AggroRange, "UAI_Filter_IsLivingEnemy")
EndFunc
Func CanUse_BloodsongAttack()
	If Anti_Attack() Then Return False
	Return True
EndFunc
Func BestTarget_BloodsongAttack($a_f_AggroRange)
	Return UAI_GetNearestAgent(-2, $a_f_AggroRange, "UAI_Filter_IsLivingEnemy")
EndFunc
Func CanUse_WanderlustAttack()
	If Anti_Attack() Then Return False
	Return True
EndFunc
Func BestTarget_WanderlustAttack($a_f_AggroRange)
	Return UAI_GetNearestAgent(-2, $a_f_AggroRange, "UAI_Filter_IsLivingEnemy")
EndFunc
Func CanUse_SuicideEnergy()
	If Anti_Attack() Then Return False
	Return True
EndFunc
Func BestTarget_SuicideEnergy($a_f_AggroRange)
	Return UAI_GetNearestAgent(-2, $a_f_AggroRange, "UAI_Filter_IsLivingEnemy")
EndFunc
Func CanUse_SuicideHealth()
	If Anti_Attack() Then Return False
	Return True
EndFunc
Func BestTarget_SuicideHealth($a_f_AggroRange)
	Return UAI_GetNearestAgent(-2, $a_f_AggroRange, "UAI_Filter_IsLivingEnemy")
EndFunc
Func CanUse_SiegeAttack3()
	If Anti_Attack() Then Return False
	Return True
EndFunc
Func BestTarget_SiegeAttack3($a_f_AggroRange)
	Return UAI_GetPlayerInfo($GC_UAI_AGENT_ID)
EndFunc
Func CanUse_CriticalChop()
	If Anti_Attack() Then Return False
	Return True
EndFunc
Func BestTarget_CriticalChop($a_f_AggroRange)
	Return UAI_GetNearestAgent(-2, $a_f_AggroRange, "UAI_Filter_IsLivingEnemy")
EndFunc
Func CanUse_AgonizingChop()
	If Anti_Attack() Then Return False
	Return True
EndFunc
Func BestTarget_AgonizingChop($a_f_AggroRange)
	Return UAI_GetNearestAgent(-2, $a_f_AggroRange, "UAI_Filter_IsLivingEnemy")
EndFunc
Func CanUse_MokeleSmash()
	If Anti_Attack() Then Return False
	Return True
EndFunc
Func BestTarget_MokeleSmash($a_f_AggroRange)
	Return UAI_GetNearestAgent(-2, $a_f_AggroRange, "UAI_Filter_IsLivingEnemy")
EndFunc
Func CanUse_OverbearingSmash()
	If Anti_Attack() Then Return False
	Return True
EndFunc
Func BestTarget_OverbearingSmash($a_f_AggroRange)
	Return UAI_GetNearestAgent(-2, $a_f_AggroRange, "UAI_Filter_IsLivingEnemy")
EndFunc
Func CanUse_CripplingSlash()
	If Anti_Attack() Then Return False
	Return True
EndFunc
Func BestTarget_CripplingSlash($a_f_AggroRange)
	Return UAI_GetNearestAgent(-2, $a_f_AggroRange, "UAI_Filter_IsLivingEnemy")
EndFunc
Func CanUse_BarbarousSlice()
	If Anti_Attack() Then Return False
	Return True
EndFunc
Func BestTarget_BarbarousSlice($a_f_AggroRange)
	Return UAI_GetNearestAgent(-2, $a_f_AggroRange, "UAI_Filter_IsLivingEnemy")
EndFunc
Func CanUse_FeedingFrenzySkill()
	If Anti_Attack() Then Return False
	Return True
EndFunc
Func BestTarget_FeedingFrenzySkill($a_f_AggroRange)
	Return UAI_GetNearestAgent(-2, $a_f_AggroRange, "UAI_Filter_IsLivingEnemy")
EndFunc
Func CanUse_QuakeOfAhdashim()
	If Anti_Attack() Then Return False
	Return True
EndFunc
Func BestTarget_QuakeOfAhdashim($a_f_AggroRange)
	Return UAI_GetPlayerInfo($GC_UAI_AGENT_ID)
EndFunc
Func CanUse_HungersBite()
	If Anti_Attack() Then Return False
	Return True
EndFunc
Func BestTarget_HungersBite($a_f_AggroRange)
	Return UAI_GetNearestAgent(-2, $a_f_AggroRange, "UAI_Filter_IsLivingEnemy")
EndFunc
Func CanUse_EarthVortex()
	If Anti_Attack() Then Return False
	Return True
EndFunc
Func BestTarget_EarthVortex($a_f_AggroRange)
	Return UAI_GetNearestAgent(-2, $a_f_AggroRange, "UAI_Filter_IsLivingEnemy")
EndFunc
Func CanUse_FrostVortex()
	If Anti_Attack() Then Return False
	Return True
EndFunc
Func BestTarget_FrostVortex($a_f_AggroRange)
	Return UAI_GetNearestAgent(-2, $a_f_AggroRange, "UAI_Filter_IsLivingEnemy")
EndFunc
Func CanUse_PreparedShot()
	If Anti_Attack() Then Return False
	Return True
EndFunc
Func BestTarget_PreparedShot($a_f_AggroRange)
	Return UAI_GetNearestAgent(-2, $a_f_AggroRange, "UAI_Filter_IsLivingEnemy")
EndFunc
Func CanUse_BurningArrow()
	If Anti_Attack() Then Return False
	Return True
EndFunc
Func BestTarget_BurningArrow($a_f_AggroRange)
	Return UAI_GetNearestAgent(-2, $a_f_AggroRange, "UAI_Filter_IsLivingEnemy")
EndFunc
Func CanUse_ArcingShot()
	If Anti_Attack() Then Return False
	Return True
EndFunc
Func BestTarget_ArcingShot($a_f_AggroRange)
	Return UAI_GetNearestAgent(-2, $a_f_AggroRange, "UAI_Filter_IsLivingEnemy")
EndFunc
Func CanUse_Crossfire()
	If Anti_Attack() Then Return False
	Return True
EndFunc
Func BestTarget_Crossfire($a_f_AggroRange)
	Return UAI_GetNearestAgent(-2, $a_f_AggroRange, "UAI_Filter_IsLivingEnemy")
EndFunc
Func CanUse_BanishingStrike()
	If Anti_Attack() Then Return False
	Return True
EndFunc
Func BestTarget_BanishingStrike($a_f_AggroRange)
	Return UAI_GetNearestAgent(-2, $a_f_AggroRange, "UAI_Filter_IsLivingEnemy")
EndFunc
Func CanUse_MysticSweep()
	If Anti_Attack() Then Return False
	If Not UAI_GetPlayerInfo($GC_UAI_AGENT_IsEnchanted) Then Return False
	Return True
EndFunc
Func BestTarget_MysticSweep($a_f_AggroRange)
	Return UAI_GetBestAOETarget(-2, $GC_I_RANGE_ADJACENT, "UAI_Filter_IsLivingEnemy")
EndFunc
Func CanUse_EremitesAttack()
	If Anti_Attack() Then Return False
	If Not UAI_GetFeederEnchOnTop() Then Return False
	If UAI_CountAgents(-2, $GC_I_RANGE_ADJACENT, "UAI_Filter_IsLivingEnemy") <= 1 Then Return False
	Return True
EndFunc
Func BestTarget_EremitesAttack($a_f_AggroRange)
	Return UAI_GetBestAOETarget(-2, $GC_I_RANGE_ADJACENT, "UAI_Filter_IsLivingEnemy")
EndFunc
Func CanUse_ReapImpurities()
	If Anti_Attack() Then Return False
	Return True
EndFunc
Func BestTarget_ReapImpurities($a_f_AggroRange)
	Return UAI_GetNearestAgent(-2, $a_f_AggroRange, "UAI_Filter_IsLivingEnemy")
EndFunc
Func CanUse_TwinMoonSweep()
	If Anti_Attack() Then Return False
	If Not UAI_GetFeederEnchOnTop() Then Return False
	Return True
EndFunc
Func BestTarget_TwinMoonSweep($a_f_AggroRange)
	Return UAI_GetNearestAgent(-2, $a_f_AggroRange, "UAI_Filter_IsLivingEnemy")
EndFunc
Func CanUse_VictoriousSweep()
	If Anti_Attack() Then Return False
	Return True
EndFunc
Func BestTarget_VictoriousSweep($a_f_AggroRange)
	Return UAI_GetNearestAgent(-2, $a_f_AggroRange, "UAI_Filter_IsLivingEnemy")
EndFunc
Func CanUse_IrresistibleSweep()
	If Anti_Attack() Then Return False
If Not UAI_GetFeederEnchOnTop() Then Return False
	Return True
EndFunc
Func BestTarget_IrresistibleSweep($a_f_AggroRange)
	Return UAI_GetNearestAgent(-2, $a_f_AggroRange, "UAI_Filter_IsLivingEnemy")
EndFunc
Func CanUse_PiousAssault()
	If Anti_Attack() Then Return False
If Not UAI_GetFeederEnchOnTop() Then Return False
	Return True
EndFunc
Func BestTarget_PiousAssault($a_f_AggroRange)
	Return UAI_GetNearestAgent(-2, $a_f_AggroRange, "UAI_Filter_IsLivingEnemy")
EndFunc
Func CanUse_CripplingSweep()
	If Anti_Attack() Then Return False
	Return True
EndFunc
Func BestTarget_CripplingSweep($a_f_AggroRange)
	Return UAI_GetNearestAgent(-2, $a_f_AggroRange, "UAI_Filter_IsLivingEnemy")
EndFunc
Func CanUse_WoundingStrike()
	If Anti_Attack() Then Return False
	Return True
EndFunc
Func BestTarget_WoundingStrike($a_f_AggroRange)
	Return UAI_GetNearestAgent(-2, $a_f_AggroRange, "UAI_Filter_IsLivingEnemy")
EndFunc
Func CanUse_WearyingStrike()
	If Anti_Attack() Then Return False
If Not UAI_GetFeederEnchOnTop() Then Return False
	Return True
EndFunc
Func BestTarget_WearyingStrike($a_f_AggroRange)
	Return UAI_GetNearestAgent(-2, $a_f_AggroRange, "UAI_Filter_IsLivingEnemy")
EndFunc
Func CanUse_LyssasAssault()
	If Anti_Attack() Then Return False
	Return True
EndFunc
Func BestTarget_LyssasAssault($a_f_AggroRange)
	Return UAI_GetNearestAgent(-2, $a_f_AggroRange, "UAI_Filter_IsLivingEnemy")
EndFunc
Func CanUse_ChillingVictory()
	If Anti_Attack() Then Return False
	Return True
EndFunc
Func BestTarget_ChillingVictory($a_f_AggroRange)
	Return UAI_GetNearestAgent(-2, $a_f_AggroRange, "UAI_Filter_IsLivingEnemy")
EndFunc
Func CanUse_BlazingSpear()
	If Anti_Attack() Then Return False
	Return True
EndFunc
Func BestTarget_BlazingSpear($a_f_AggroRange)
	Return UAI_GetAgentLowest(-2, $a_f_AggroRange, $GC_UAI_AGENT_HP, "UAI_Filter_IsLivingEnemy")
EndFunc
Func CanUse_MightyThrow()
	If Anti_Attack() Then Return False
	Return True
EndFunc
Func BestTarget_MightyThrow($a_f_AggroRange)
	Return UAI_GetNearestAgent(-2, $a_f_AggroRange, "UAI_Filter_IsLivingEnemy")
EndFunc
Func CanUse_CruelSpear()
	If Anti_Attack() Then Return False
	Return True
EndFunc
Func BestTarget_CruelSpear($a_f_AggroRange)
	Return UAI_GetAgentLowest(-2, $a_f_AggroRange, $GC_UAI_AGENT_HP, "UAI_Filter_IsLivingEnemy")
EndFunc
Func CanUse_HarriersToss()
	If Anti_Attack() Then Return False
	Return True
EndFunc
Func BestTarget_HarriersToss($a_f_AggroRange)
	Return UAI_GetNearestAgent(-2, $a_f_AggroRange, "UAI_Filter_IsLivingEnemy")
EndFunc
Func CanUse_UnblockableThrow()
	If Anti_Attack() Then Return False
	Return True
EndFunc
Func BestTarget_UnblockableThrow($a_f_AggroRange)
	Return UAI_GetNearestAgent(-2, $a_f_AggroRange, "UAI_Filter_IsLivingEnemy")
EndFunc
Func CanUse_SpearOfLightning()
	If Anti_Attack() Then Return False
	Return True
EndFunc
Func BestTarget_SpearOfLightning($a_f_AggroRange)
	Return UAI_GetAgentLowest(-2, $a_f_AggroRange, $GC_UAI_AGENT_HP, "UAI_Filter_IsLivingEnemy")
EndFunc
Func CanUse_WearyingSpear()
	If Anti_Attack() Then Return False
	Return True
EndFunc
Func BestTarget_WearyingSpear($a_f_AggroRange)
	Return UAI_GetNearestAgent(-2, $a_f_AggroRange, "UAI_Filter_IsLivingEnemy")
EndFunc
Func CanUse_BarbedSpear()
	If Anti_Attack() Then Return False
	Return True
EndFunc
Func BestTarget_BarbedSpear($a_f_AggroRange)
	Local $l_i_Target = UAI_GetAgentLowest(-2, $a_f_AggroRange, $GC_UAI_AGENT_HP, "UAI_Filter_IsLivingEnemy|-UAI_Filter_IsConditioned")
	If $l_i_Target <> 0 Then Return $l_i_Target
	Return UAI_GetAgentHighest(-2, $a_f_AggroRange, $GC_UAI_AGENT_HP, "UAI_Filter_IsLivingEnemy")
EndFunc
Func CanUse_ViciousAttack()
	If Anti_Attack() Then Return False
	Return True
EndFunc
Func BestTarget_ViciousAttack($a_f_AggroRange)
	Return UAI_GetNearestAgent(-2, $a_f_AggroRange, "UAI_Filter_IsLivingEnemy")
EndFunc
Func CanUse_StunningStrike()
	If Anti_Attack() Then Return False
	Return True
EndFunc
Func BestTarget_StunningStrike($a_f_AggroRange)
	Return UAI_GetNearestAgent(-2, $a_f_AggroRange, "UAI_Filter_IsLivingEnemy")
EndFunc
Func CanUse_MercilessSpear()
	If Anti_Attack() Then Return False
	Return True
EndFunc
Func BestTarget_MercilessSpear($a_f_AggroRange)
	Local $l_i_Target = UAI_GetAgentLowest(-2, $a_f_AggroRange, $GC_UAI_AGENT_HP, "UAI_Filter_IsLivingEnemy")
	If $l_i_Target <> 0 And UAI_GetAgentInfoByID($l_i_Target, $GC_UAI_AGENT_HP) < 0.5 Then Return $l_i_Target
	Return UAI_GetNearestAgent(-2, $a_f_AggroRange, "UAI_Filter_IsLivingEnemy")
EndFunc
Func CanUse_DisruptingThrow()
	If Anti_Attack() Then Return False
	Return True
EndFunc
Func BestTarget_DisruptingThrow($a_f_AggroRange)
	Return UAI_GetNearestAgent(-2, $a_f_AggroRange, "UAI_Filter_IsLivingEnemy")
EndFunc
Func CanUse_WildThrow()
	If Anti_Attack() Then Return False
	Return True
EndFunc
Func BestTarget_WildThrow($a_f_AggroRange)
	Return UAI_GetNearestAgent(-2, $a_f_AggroRange, "UAI_Filter_IsLivingEnemy")
EndFunc
Func CanUse_MaliciousStrike()
	If Anti_Attack() Then Return False
	Return True
EndFunc
Func BestTarget_MaliciousStrike($a_f_AggroRange)
	Return UAI_GetNearestAgent(-2, $a_f_AggroRange, "UAI_Filter_IsLivingEnemy")
EndFunc
Func CanUse_ShatteringAssault()
	If Anti_Attack() Then Return False
	Return True
EndFunc
Func BestTarget_ShatteringAssault($a_f_AggroRange)
	Return UAI_GetNearestAgent(-2, $a_f_AggroRange, "UAI_Filter_IsLivingEnemy|UAI_Filter_IsLastStrikeIsOffHand")
EndFunc
Func CanUse_GoldenSkullStrike()
	If Anti_Attack() Then Return False
	If Not UAI_GetPlayerInfo($GC_UAI_AGENT_IsEnchanted) Then Return False
	Return True
EndFunc
Func BestTarget_GoldenSkullStrike($a_f_AggroRange)
	Return UAI_GetNearestAgent(-2, $a_f_AggroRange, "UAI_Filter_IsLivingEnemy")
EndFunc
Func CanUse_BlackSpiderStrike()
	If Anti_Attack() Then Return False
	Return True
EndFunc
Func BestTarget_BlackSpiderStrike($a_f_AggroRange)
	Return UAI_GetNearestAgent(-2, $a_f_AggroRange, "UAI_Filter_IsLivingEnemy|UAI_Filter_IsHexed")
EndFunc
Func CanUse_GoldenFoxStrike()
	If Anti_Attack() Then Return False
	Local $l_i_CurrentTarget = Agent_GetCurrentTarget()
	If $l_i_CurrentTarget <> 0 Then Return Not UAI_Filter_IsLastStrikeLeadOrOffHand($l_i_CurrentTarget)
	Return True
EndFunc
Func BestTarget_GoldenFoxStrike($a_f_AggroRange)
	Return UAI_GetNearestAgent(-2, $a_f_AggroRange, "UAI_Filter_IsLivingEnemy")
EndFunc
Func CanUse_SiegeAttackBombardment()
	If Anti_Attack() Then Return False
	Return True
EndFunc
Func BestTarget_SiegeAttackBombardment($a_f_AggroRange)
	Return UAI_GetPlayerInfo($GC_UAI_AGENT_ID)
EndFunc
Func CanUse_Counterattack()
	If Anti_Attack() Then Return False
	Return True
EndFunc
Func BestTarget_Counterattack($a_f_AggroRange)
	Local $l_i_Target = UAI_GetNearestAgent(-2, $a_f_AggroRange, "UAI_Filter_IsLivingEnemy|UAI_Filter_IsAttacking")
	If $l_i_Target <> 0 Then Return $l_i_Target
	Return UAI_GetNearestAgent(-2, $a_f_AggroRange, "UAI_Filter_IsLivingEnemy")
EndFunc
Func CanUse_MagehunterStrike()
	If Anti_Attack() Then Return False
	Return True
EndFunc
Func BestTarget_MagehunterStrike($a_f_AggroRange)
	Local $l_i_Target = UAI_GetNearestAgent(-2, $a_f_AggroRange, "UAI_Filter_IsLivingEnemy|UAI_Filter_IsEnchanted")
	If $l_i_Target <> 0 Then Return $l_i_Target
	Return UAI_GetNearestAgent(-2, $a_f_AggroRange, "UAI_Filter_IsLivingEnemy")
EndFunc
Func CanUse_SoldiersStrike()
	If Anti_Attack() Then Return False
	Return True
EndFunc
Func BestTarget_SoldiersStrike($a_f_AggroRange)
	Return UAI_GetNearestAgent(-2, $a_f_AggroRange, "UAI_Filter_IsLivingEnemy")
EndFunc
Func CanUse_Decapitate()
	If Anti_Attack() Then Return False
	Return True
EndFunc
Func BestTarget_Decapitate($a_f_AggroRange)
	Return UAI_GetNearestAgent(-2, $a_f_AggroRange, "UAI_Filter_IsLivingEnemy")
EndFunc
Func CanUse_MagehuntersSmash()
	If Anti_Attack() Then Return False
	Return True
EndFunc
Func BestTarget_MagehuntersSmash($a_f_AggroRange)
	Return UAI_GetNearestAgent(-2, $a_f_AggroRange, "UAI_Filter_IsLivingEnemy")
EndFunc
Func CanUse_SteelfangSlash()
	If Anti_Attack() Then Return False
	Return True
EndFunc
Func BestTarget_SteelfangSlash($a_f_AggroRange)
	Local $l_i_Target = UAI_GetNearestAgent(-2, $a_f_AggroRange, "UAI_Filter_IsLivingEnemy|UAI_Filter_IsKnocked")
	If $l_i_Target <> 0 Then Return $l_i_Target
	Return UAI_GetNearestAgent(-2, $a_f_AggroRange, "UAI_Filter_IsLivingEnemy")
EndFunc
Func CanUse_EarthShatteringBlow()
	If Anti_Attack() Then Return False
	Return True
EndFunc
Func BestTarget_EarthShatteringBlow($a_f_AggroRange)
	Return UAI_GetNearestAgent(-2, $a_f_AggroRange, "UAI_Filter_IsLivingEnemy")
EndFunc
Func CanUse_ScreamingShot()
	If Anti_Attack() Then Return False
	Return True
EndFunc
Func BestTarget_ScreamingShot($a_f_AggroRange)
	Return UAI_GetNearestAgent(-2, $a_f_AggroRange, "UAI_Filter_IsLivingEnemy")
EndFunc
Func CanUse_KeenArrow()
	If Anti_Attack() Then Return False
	Return True
EndFunc
Func BestTarget_KeenArrow($a_f_AggroRange)
	Return UAI_GetNearestAgent(-2, $a_f_AggroRange, "UAI_Filter_IsLivingEnemy")
EndFunc
Func CanUse_ForkedArrow()
	If Anti_Attack() Then Return False
	Return True
EndFunc
Func BestTarget_ForkedArrow($a_f_AggroRange)
	Return UAI_GetNearestAgent(-2, $a_f_AggroRange, "UAI_Filter_IsLivingEnemy")
EndFunc
Func CanUse_MagebaneShot()
	If Anti_Attack() Then Return False
	Return True
EndFunc
Func BestTarget_MagebaneShot($a_f_AggroRange)
	Return UAI_GetNearestAgent(-2, $a_f_AggroRange, "UAI_Filter_IsLivingEnemy")
EndFunc
Func CanUse_GazeOfFuryAttack()
	If Anti_Attack() Then Return False
	Return True
EndFunc
Func BestTarget_GazeOfFuryAttack($a_f_AggroRange)
	Return UAI_GetNearestAgent(-2, $a_f_AggroRange, "UAI_Filter_IsLivingEnemy")
EndFunc
Func CanUse_AnguishAttack()
	If Anti_Attack() Then Return False
	Return True
EndFunc
Func BestTarget_AnguishAttack($a_f_AggroRange)
	Return UAI_GetNearestAgent(-2, $a_f_AggroRange, "UAI_Filter_IsLivingEnemy")
EndFunc
Func CanUse_RendingSweep()
	If Anti_Attack() Then Return False
If Not UAI_GetFeederEnchOnTop() Then Return False
	Return True
EndFunc
Func BestTarget_RendingSweep($a_f_AggroRange)
	Return UAI_GetNearestAgent(-2, $a_f_AggroRange, "UAI_Filter_IsLivingEnemy")
EndFunc
Func CanUse_ReapersSweep()
	If Anti_Attack() Then Return False
	Return True
EndFunc
Func BestTarget_ReapersSweep($a_f_AggroRange)
	Return UAI_GetNearestAgent(-2, $a_f_AggroRange, "UAI_Filter_IsLivingEnemy")
EndFunc
Func CanUse_SlayersSpear()
	If Anti_Attack() Then Return False
	Return True
EndFunc
Func BestTarget_SlayersSpear($a_f_AggroRange)
	Return UAI_GetNearestAgent(-2, $a_f_AggroRange, "UAI_Filter_IsLivingEnemy")
EndFunc
Func CanUse_SwiftJavelin()
	If Anti_Attack() Then Return False
	Return True
EndFunc
Func BestTarget_SwiftJavelin($a_f_AggroRange)
	Return UAI_GetNearestAgent(-2, $a_f_AggroRange, "UAI_Filter_IsLivingEnemy")
EndFunc
Func CanUse_WildSmash()
	If Anti_Attack() Then Return False
	Return True
EndFunc
Func BestTarget_WildSmash($a_f_AggroRange)
	Return UAI_GetNearestAgent(-2, $a_f_AggroRange, "UAI_Filter_IsLivingEnemy")
EndFunc
Func CanUse_JadothsStormOfJudgment()
	If Anti_Attack() Then Return False
	Return True
EndFunc
Func BestTarget_JadothsStormOfJudgment($a_f_AggroRange)
	Return UAI_GetNearestAgent(-2, $a_f_AggroRange, "UAI_Filter_IsLivingEnemy")
EndFunc
Func CanUse_TorturousEmbers()
	If Anti_Attack() Then Return False
	Return True
EndFunc
Func BestTarget_TorturousEmbers($a_f_AggroRange)
	Return UAI_GetNearestAgent(-2, $a_f_AggroRange, "UAI_Filter_IsLivingEnemy")
EndFunc
Func CanUse_TripleShotLuxon()
	If Anti_Attack() Then Return False
	Return True
EndFunc
Func BestTarget_TripleShotLuxon($a_f_AggroRange)
	Return UAI_GetNearestAgent(-2, $a_f_AggroRange, "UAI_Filter_IsLivingEnemy")
EndFunc
Func CanUse_SpearOfFuryLuxon()
	If Anti_Attack() Then Return False
	Return True
EndFunc
Func BestTarget_SpearOfFuryLuxon($a_f_AggroRange)
	Return UAI_GetNearestAgent(-2, $a_f_AggroRange, "UAI_Filter_IsLivingEnemy")
EndFunc
Func CanUse_VampiricAssault()
	If Anti_Attack() Then Return False
	Return True
EndFunc
Func BestTarget_VampiricAssault($a_f_AggroRange)
	Return UAI_GetNearestAgent(-2, $a_f_AggroRange, "UAI_Filter_IsLivingEnemy|UAI_Filter_IsLastStrikeIsOffHand")
EndFunc
Func CanUse_LotusStrike()
	If Anti_Attack() Then Return False
	Return True
EndFunc
Func BestTarget_LotusStrike($a_f_AggroRange)
	Return UAI_GetNearestAgent(-2, $a_f_AggroRange, "UAI_Filter_IsLivingEnemy")
EndFunc
Func CanUse_GoldenFangStrike()
	If Anti_Attack() Then Return False
	Return True
EndFunc
Func BestTarget_GoldenFangStrike($a_f_AggroRange)
	Return UAI_GetNearestAgent(-2, $a_f_AggroRange, "UAI_Filter_IsLivingEnemy|UAI_Filter_IsLastStrikeIsLead")
EndFunc
Func CanUse_FallingLotusStrike()
	If Anti_Attack() Then Return False
	Return True
EndFunc
Func BestTarget_FallingLotusStrike($a_f_AggroRange)
	Return UAI_GetNearestAgent(-2, $GC_I_RANGE_NEARBY, "UAI_Filter_IsLivingEnemy|UAI_Filter_IsKnocked")
EndFunc
Func CanUse_PulverizingSmash()
	If Anti_Attack() Then Return False
	Return True
EndFunc
Func BestTarget_PulverizingSmash($a_f_AggroRange)
	Return UAI_GetNearestAgent(-2, $a_f_AggroRange, "UAI_Filter_IsLivingEnemy")
EndFunc
Func CanUse_KeenChop()
	If Anti_Attack() Then Return False
	Return True
EndFunc
Func BestTarget_KeenChop($a_f_AggroRange)
	Return UAI_GetNearestAgent(-2, $a_f_AggroRange, "UAI_Filter_IsLivingEnemy")
EndFunc
Func CanUse_KneeCutter()
	If Anti_Attack() Then Return False
	Return True
EndFunc
Func BestTarget_KneeCutter($a_f_AggroRange)
	Return UAI_GetNearestAgent(-2, $a_f_AggroRange, "UAI_Filter_IsLivingEnemy")
EndFunc
Func CanUse_RadiantScythe()
	If Anti_Attack() Then Return False
	Return True
EndFunc
Func BestTarget_RadiantScythe($a_f_AggroRange)
	Return UAI_GetNearestAgent(-2, $a_f_AggroRange, "UAI_Filter_IsLivingEnemy")
EndFunc
Func CanUse_FarmersScythe()
	If Anti_Attack() Then Return False
	Return True
EndFunc
Func BestTarget_FarmersScythe($a_f_AggroRange)
	Return UAI_GetNearestAgent(-2, $a_f_AggroRange, "UAI_Filter_IsLivingEnemy")
EndFunc
Func CanUse_Disarm()
	If Anti_Attack() Then Return False
	Return True
EndFunc
Func BestTarget_Disarm($a_f_AggroRange)
	Return UAI_GetNearestAgent(-2, $a_f_AggroRange, "UAI_Filter_IsLivingEnemy")
EndFunc
Func CanUse_SlothHuntersShot()
	If Anti_Attack() Then Return False
	Return True
EndFunc
Func BestTarget_SlothHuntersShot($a_f_AggroRange)
	Return UAI_GetNearestAgent(-2, $a_f_AggroRange, "UAI_Filter_IsLivingEnemy")
EndFunc
Func CanUse_AuraSlicer()
	If Anti_Attack() Then Return False
	Return True
EndFunc
Func BestTarget_AuraSlicer($a_f_AggroRange)
	Return UAI_GetNearestAgent(-2, $a_f_AggroRange, "UAI_Filter_IsLivingEnemy")
EndFunc
Func CanUse_ZealousSweep()
	If Anti_Attack() Then Return False
	Return True
EndFunc
Func BestTarget_ZealousSweep($a_f_AggroRange)
	Return UAI_GetNearestAgent(-2, $a_f_AggroRange, "UAI_Filter_IsLivingEnemy")
EndFunc
Func CanUse_ChestThumper()
	If Anti_Attack() Then Return False
	Return True
EndFunc
Func BestTarget_ChestThumper($a_f_AggroRange)
	Return UAI_GetNearestAgent(-2, $a_f_AggroRange, "UAI_Filter_IsLivingEnemy")
EndFunc
Func CanUse_TripleShotKurzick()
	If Anti_Attack() Then Return False
	Return True
EndFunc
Func BestTarget_TripleShotKurzick($a_f_AggroRange)
	Return UAI_GetNearestAgent(-2, $a_f_AggroRange, "UAI_Filter_IsLivingEnemy")
EndFunc
Func CanUse_SpearOfFuryKurzick()
	If Anti_Attack() Then Return False
	Return True
EndFunc
Func BestTarget_SpearOfFuryKurzick($a_f_AggroRange)
	Return UAI_GetNearestAgent(-2, $a_f_AggroRange, "UAI_Filter_IsLivingEnemy")
EndFunc
Func CanUse_WhirlwindAttack()
	If Anti_Attack() Then Return False
	Return True
EndFunc
Func BestTarget_WhirlwindAttack($a_f_AggroRange)
	Return UAI_GetNearestAgent(-2, $a_f_AggroRange, "UAI_Filter_IsLivingEnemy")
EndFunc
Func CanUse_VampirismAttack()
	If Anti_Attack() Then Return False
	Return True
EndFunc
Func BestTarget_VampirismAttack($a_f_AggroRange)
	Return UAI_GetNearestAgent(-2, $a_f_AggroRange, "UAI_Filter_IsLivingEnemy")
EndFunc
Func CanUse_SneakAttack()
	If Anti_Attack() Then Return False
	Local $l_i_CurrentTarget = Agent_GetCurrentTarget()
	If $l_i_CurrentTarget <> 0 Then Return Not UAI_Filter_IsLastStrikeLeadOrOffHand($l_i_CurrentTarget)
	Return True
EndFunc
Func BestTarget_SneakAttack($a_f_AggroRange)
	Return UAI_GetNearestAgent(-2, $a_f_AggroRange, "UAI_Filter_IsLivingEnemy")
EndFunc
Func CanUse_ShatteredSpirit()
	If Anti_Attack() Then Return False
	Return True
EndFunc
Func BestTarget_ShatteredSpirit($a_f_AggroRange)
	Return UAI_GetPlayerInfo($GC_UAI_AGENT_ID)
EndFunc
Func CanUse_UnseenAggression()
	If Anti_Attack() Then Return False
	Return True
EndFunc
Func BestTarget_UnseenAggression($a_f_AggroRange)
	Return UAI_GetPlayerInfo($GC_UAI_AGENT_ID)
EndFunc
Func CanUse_TramplingOx()
	If Anti_Attack() Then Return False
	Return True
EndFunc
Func BestTarget_TramplingOx($a_f_AggroRange)
	Return UAI_GetNearestAgent(-2, $a_f_AggroRange, "UAI_Filter_IsLivingEnemy|UAI_Filter_IsCrippled")
EndFunc
Func CanUse_DisruptingShot()
	If Anti_Attack() Then Return False
	Return True
EndFunc
Func BestTarget_DisruptingShot($a_f_AggroRange)
	Return UAI_GetNearestAgent(-2, $a_f_AggroRange, "UAI_Filter_IsLivingEnemy")
EndFunc
Func CanUse_Volley()
	If Anti_Attack() Then Return False
	Return True
EndFunc
Func BestTarget_Volley($a_f_AggroRange)
	Return UAI_GetBestAOETarget(-2, $a_f_AggroRange, $GC_I_RANGE_ADJACENT, "UAI_Filter_IsLivingEnemy")
EndFunc
Func CanUse_CripplingVictory()
	If Anti_Attack() Then Return False
	Return True
EndFunc
Func BestTarget_CripplingVictory($a_f_AggroRange)
	Return UAI_GetNearestAgent(-2, $a_f_AggroRange, "UAI_Filter_IsLivingEnemy")
EndFunc
Func CanUse_MaimingSpear()
	If Anti_Attack() Then Return False
	Return True
EndFunc
Func BestTarget_MaimingSpear($a_f_AggroRange)
	Return UAI_GetNearestAgent(-2, $a_f_AggroRange, "UAI_Filter_IsLivingEnemy")
EndFunc
Func CanUse_GolemStrike()
	If Anti_Attack() Then Return False
	Return True
EndFunc
Func BestTarget_GolemStrike($a_f_AggroRange)
	Return UAI_GetNearestAgent(-2, $a_f_AggroRange, "UAI_Filter_IsLivingEnemy")
EndFunc
Func CanUse_BloodstoneSlash()
	If Anti_Attack() Then Return False
	Return True
EndFunc
Func BestTarget_BloodstoneSlash($a_f_AggroRange)
	Return UAI_GetNearestAgent(-2, $a_f_AggroRange, "UAI_Filter_IsLivingEnemy")
EndFunc
Func CanUse_RollingShift()
	If Anti_Attack() Then Return False
	Return True
EndFunc
Func BestTarget_RollingShift($a_f_AggroRange)
	Return UAI_GetNearestAgent(-2, $a_f_AggroRange, "UAI_Filter_IsLivingEnemy")
EndFunc
Func CanUse_DistractingStrike()
	If Anti_Attack() Then Return False
	Return True
EndFunc
Func BestTarget_DistractingStrike($a_f_AggroRange)
	Return UAI_GetNearestAgent(-2, $a_f_AggroRange, "UAI_Filter_IsLivingEnemy")
EndFunc
Func CanUse_SymbolicStrike()
	If Anti_Attack() Then Return False
	Return True
EndFunc
Func BestTarget_SymbolicStrike($a_f_AggroRange)
	Return UAI_GetNearestAgent(-2, $a_f_AggroRange, "UAI_Filter_IsLivingEnemy")
EndFunc
Func CanUse_BodyBlow()
	If Anti_Attack() Then Return False
	Return True
EndFunc
Func BestTarget_BodyBlow($a_f_AggroRange)
	Return UAI_GetNearestAgent(-2, $a_f_AggroRange, "UAI_Filter_IsLivingEnemy")
EndFunc
Func CanUse_BodyShot()
	If Anti_Attack() Then Return False
	Return True
EndFunc
Func BestTarget_BodyShot($a_f_AggroRange)
	Return UAI_GetNearestAgent(-2, $a_f_AggroRange, "UAI_Filter_IsLivingEnemy")
EndFunc
Func CanUse_HolySpear()
	If Anti_Attack() Then Return False
	Return True
EndFunc
Func BestTarget_HolySpear($a_f_AggroRange)
	Return UAI_GetNearestAgent(-2, $a_f_AggroRange, "UAI_Filter_IsLivingEnemy")
EndFunc
Func CanUse_SpearSwipe()
	If Anti_Attack() Then Return False
	Return True
EndFunc
Func BestTarget_SpearSwipe($a_f_AggroRange)
	Return UAI_GetNearestAgent(-2, $a_f_AggroRange, "UAI_Filter_IsLivingEnemy")
EndFunc
Func CanUse_DeftStrike()
	If Anti_Attack() Then Return False
	Return True
EndFunc
Func BestTarget_DeftStrike($a_f_AggroRange)
	Return UAI_GetNearestAgent(-2, $a_f_AggroRange, "UAI_Filter_IsLivingEnemy")
EndFunc
Func CanUse_SpearOfRedemption()
	If Anti_Attack() Then Return False
	Return True
EndFunc
Func BestTarget_SpearOfRedemption($a_f_AggroRange)
	Return UAI_GetNearestAgent(-2, $a_f_AggroRange, "UAI_Filter_IsLivingEnemy")
EndFunc
Func CanUse_BrawlingJab1()
	If Anti_Attack() Then Return False
	If UAI_PlayerHasEffect($GC_I_SKILL_ID_BRAWLING_BLOCK) Then Return False
	If UAI_GetDynamicSkillInfo(3, $GC_UAI_DYNAMIC_SKILL_IsRecharged) Then Return False
	If UAI_GetDynamicSkillInfo(4, $GC_UAI_DYNAMIC_SKILL_Adrenaline) >= UAI_GetStaticSkillInfo(4, $GC_UAI_STATIC_SKILL_Adrenaline) Then Return False
	If UAI_GetDynamicSkillInfo(5, $GC_UAI_DYNAMIC_SKILL_Adrenaline) >= UAI_GetStaticSkillInfo(5, $GC_UAI_STATIC_SKILL_Adrenaline) Then Return False
	If UAI_GetDynamicSkillInfo(6, $GC_UAI_DYNAMIC_SKILL_Adrenaline) >= UAI_GetStaticSkillInfo(6, $GC_UAI_STATIC_SKILL_Adrenaline) Then Return False
	Return True
EndFunc
Func BestTarget_BrawlingJab1($a_f_AggroRange)
	Local $l_i_TargetID = UAI_GetBestSingleTarget(-2, $GC_I_RANGE_ADJACENT, $GC_UAI_AGENT_HP, "UAI_Filter_IsLivingEnemy|-UAI_Filter_IsBoss")
	If $l_i_TargetID <> 0 Then Return $l_i_TargetID
	$l_i_TargetID = UAI_GetBestSingleTarget(-2, $GC_I_RANGE_ADJACENT, $GC_UAI_AGENT_HP, "UAI_Filter_IsLivingEnemy")
	If $l_i_TargetID <> 0 Then Return $l_i_TargetID
	$l_i_TargetID = UAI_GetNearestAgent(-2, $a_f_AggroRange, "UAI_Filter_IsLivingEnemy|-UAI_Filter_IsBoss")
	If $l_i_TargetID <> 0 Then Return $l_i_TargetID
	Return UAI_GetNearestAgent(-2, $a_f_AggroRange, "UAI_Filter_IsLivingEnemy")
EndFunc
Func CanUse_BrawlingJab2()
	If Anti_Attack() Then Return False
	If UAI_PlayerHasEffect($GC_I_SKILL_ID_BRAWLING_BLOCK) Then Return False
	If UAI_GetDynamicSkillInfo(3, $GC_UAI_DYNAMIC_SKILL_IsRecharged) Then Return False
	If UAI_GetDynamicSkillInfo(4, $GC_UAI_DYNAMIC_SKILL_Adrenaline) >= UAI_GetStaticSkillInfo(4, $GC_UAI_STATIC_SKILL_Adrenaline) Then Return False
	If UAI_GetDynamicSkillInfo(5, $GC_UAI_DYNAMIC_SKILL_Adrenaline) >= UAI_GetStaticSkillInfo(5, $GC_UAI_STATIC_SKILL_Adrenaline) Then Return False
	If UAI_GetDynamicSkillInfo(6, $GC_UAI_DYNAMIC_SKILL_Adrenaline) >= UAI_GetStaticSkillInfo(6, $GC_UAI_STATIC_SKILL_Adrenaline) Then Return False
	Return True
EndFunc
Func BestTarget_BrawlingJab2($a_f_AggroRange)
	Local $l_i_TargetID = UAI_GetBestSingleTarget(-2, $GC_I_RANGE_ADJACENT, $GC_UAI_AGENT_HP, "UAI_Filter_IsLivingEnemy|-UAI_Filter_IsBoss")
	If $l_i_TargetID <> 0 Then Return $l_i_TargetID
	$l_i_TargetID = UAI_GetBestSingleTarget(-2, $GC_I_RANGE_ADJACENT, $GC_UAI_AGENT_HP, "UAI_Filter_IsLivingEnemy")
	If $l_i_TargetID <> 0 Then Return $l_i_TargetID
	$l_i_TargetID = UAI_GetNearestAgent(-2, $a_f_AggroRange, "UAI_Filter_IsLivingEnemy|-UAI_Filter_IsBoss")
	If $l_i_TargetID <> 0 Then Return $l_i_TargetID
	Return UAI_GetNearestAgent(-2, $a_f_AggroRange, "UAI_Filter_IsLivingEnemy")
EndFunc
Func CanUse_BrawlingStraightRight()
	If Anti_Attack() Then Return False
	If UAI_PlayerHasEffect($GC_I_SKILL_ID_BRAWLING_BLOCK) Then Return False
	Return True
EndFunc
Func BestTarget_BrawlingStraightRight($a_f_AggroRange)
	Local $l_i_TargetID = UAI_GetBestSingleTarget(-2, $GC_I_RANGE_ADJACENT, $GC_UAI_AGENT_HP, "UAI_Filter_IsLivingEnemy|-UAI_Filter_IsBoss")
	If $l_i_TargetID <> 0 Then Return $l_i_TargetID
	$l_i_TargetID = UAI_GetBestSingleTarget(-2, $GC_I_RANGE_ADJACENT, $GC_UAI_AGENT_HP, "UAI_Filter_IsLivingEnemy")
	If $l_i_TargetID <> 0 Then Return $l_i_TargetID
	$l_i_TargetID = UAI_GetNearestAgent(-2, $a_f_AggroRange, "UAI_Filter_IsLivingEnemy|-UAI_Filter_IsBoss")
	If $l_i_TargetID <> 0 Then Return $l_i_TargetID
	Return UAI_GetNearestAgent(-2, $a_f_AggroRange, "UAI_Filter_IsLivingEnemy")
EndFunc
Func CanUse_BrawlingHook1()
	If Anti_Attack() Then Return False
	If UAI_PlayerHasEffect($GC_I_SKILL_ID_BRAWLING_BLOCK) Then Return False
	Return True
EndFunc
Func BestTarget_BrawlingHook1($a_f_AggroRange)
	Local $l_i_TargetID = UAI_GetBestSingleTarget(-2, $GC_I_RANGE_ADJACENT, $GC_UAI_AGENT_HP, "UAI_Filter_IsLivingEnemy|-UAI_Filter_IsBoss")
	If $l_i_TargetID <> 0 Then Return $l_i_TargetID
	$l_i_TargetID = UAI_GetBestSingleTarget(-2, $GC_I_RANGE_ADJACENT, $GC_UAI_AGENT_HP, "UAI_Filter_IsLivingEnemy")
	If $l_i_TargetID <> 0 Then Return $l_i_TargetID
	$l_i_TargetID = UAI_GetNearestAgent(-2, $a_f_AggroRange, "UAI_Filter_IsLivingEnemy|-UAI_Filter_IsBoss")
	If $l_i_TargetID <> 0 Then Return $l_i_TargetID
	Return UAI_GetNearestAgent(-2, $a_f_AggroRange, "UAI_Filter_IsLivingEnemy")
EndFunc
Func CanUse_BrawlingHook2()
	If Anti_Attack() Then Return False
	If UAI_PlayerHasEffect($GC_I_SKILL_ID_BRAWLING_BLOCK) Then Return False
	Return True
EndFunc
Func BestTarget_BrawlingHook2($a_f_AggroRange)
	Local $l_i_TargetID = UAI_GetBestSingleTarget(-2, $GC_I_RANGE_ADJACENT, $GC_UAI_AGENT_HP, "UAI_Filter_IsLivingEnemy|-UAI_Filter_IsBoss")
	If $l_i_TargetID <> 0 Then Return $l_i_TargetID
	$l_i_TargetID = UAI_GetBestSingleTarget(-2, $GC_I_RANGE_ADJACENT, $GC_UAI_AGENT_HP, "UAI_Filter_IsLivingEnemy")
	If $l_i_TargetID <> 0 Then Return $l_i_TargetID
	$l_i_TargetID = UAI_GetNearestAgent(-2, $a_f_AggroRange, "UAI_Filter_IsLivingEnemy|-UAI_Filter_IsBoss")
	If $l_i_TargetID <> 0 Then Return $l_i_TargetID
	Return UAI_GetNearestAgent(-2, $a_f_AggroRange, "UAI_Filter_IsLivingEnemy")
EndFunc
Func CanUse_BrawlingUppercut()
	If Anti_Attack() Then Return False
	If UAI_PlayerHasEffect($GC_I_SKILL_ID_BRAWLING_BLOCK) Then Return False
	Return True
EndFunc
Func BestTarget_BrawlingUppercut($a_f_AggroRange)
	Local $l_i_TargetID = UAI_GetBestSingleTarget(-2, $GC_I_RANGE_ADJACENT, $GC_UAI_AGENT_HP, "UAI_Filter_IsLivingEnemy|-UAI_Filter_IsBoss")
	If $l_i_TargetID <> 0 Then Return $l_i_TargetID
	$l_i_TargetID = UAI_GetBestSingleTarget(-2, $GC_I_RANGE_ADJACENT, $GC_UAI_AGENT_HP, "UAI_Filter_IsLivingEnemy")
	If $l_i_TargetID <> 0 Then Return $l_i_TargetID
	$l_i_TargetID = UAI_GetNearestAgent(-2, $a_f_AggroRange, "UAI_Filter_IsLivingEnemy|-UAI_Filter_IsBoss")
	If $l_i_TargetID <> 0 Then Return $l_i_TargetID
	Return UAI_GetNearestAgent(-2, $a_f_AggroRange, "UAI_Filter_IsLivingEnemy")
EndFunc
Func CanUse_BrawlingComboPunch()
	If Anti_Attack() Then Return False
	If UAI_PlayerHasEffect($GC_I_SKILL_ID_BRAWLING_BLOCK) Then Return False
	Return True
EndFunc
Func BestTarget_BrawlingComboPunch($a_f_AggroRange)
	Local $l_i_TargetID = UAI_GetBestSingleTarget(-2, $GC_I_RANGE_ADJACENT, $GC_UAI_AGENT_HP, "UAI_Filter_IsLivingEnemy|-UAI_Filter_IsBoss")
	If $l_i_TargetID <> 0 Then Return $l_i_TargetID
	$l_i_TargetID = UAI_GetBestSingleTarget(-2, $GC_I_RANGE_ADJACENT, $GC_UAI_AGENT_HP, "UAI_Filter_IsLivingEnemy")
	If $l_i_TargetID <> 0 Then Return $l_i_TargetID
	$l_i_TargetID = UAI_GetNearestAgent(-2, $a_f_AggroRange, "UAI_Filter_IsLivingEnemy|-UAI_Filter_IsBoss")
	If $l_i_TargetID <> 0 Then Return $l_i_TargetID
	Return UAI_GetNearestAgent(-2, $a_f_AggroRange, "UAI_Filter_IsLivingEnemy")
EndFunc
Func CanUse_BrawlingHeadbuttBrawlingSkill()
	If Anti_Attack() Then Return False
	If UAI_PlayerHasEffect($GC_I_SKILL_ID_BRAWLING_BLOCK) Then Return False
	Return True
EndFunc
Func BestTarget_BrawlingHeadbuttBrawlingSkill($a_f_AggroRange)
	Local $l_i_TargetID = UAI_GetBestSingleTarget(-2, $GC_I_RANGE_ADJACENT, $GC_UAI_AGENT_HP, "UAI_Filter_IsLivingEnemy|-UAI_Filter_IsBoss")
	If $l_i_TargetID <> 0 Then Return $l_i_TargetID
	$l_i_TargetID = UAI_GetBestSingleTarget(-2, $GC_I_RANGE_ADJACENT, $GC_UAI_AGENT_HP, "UAI_Filter_IsLivingEnemy")
	If $l_i_TargetID <> 0 Then Return $l_i_TargetID
	$l_i_TargetID = UAI_GetNearestAgent(-2, $a_f_AggroRange, "UAI_Filter_IsLivingEnemy|-UAI_Filter_IsBoss")
	If $l_i_TargetID <> 0 Then Return $l_i_TargetID
	Return UAI_GetNearestAgent(-2, $a_f_AggroRange, "UAI_Filter_IsLivingEnemy")
EndFunc
Func CanUse_ClubOfAThousandBears()
	If Anti_Attack() Then Return False
	Return True
EndFunc
Func BestTarget_ClubOfAThousandBears($a_f_AggroRange)
	Return UAI_GetNearestAgent(-2, $a_f_AggroRange, "UAI_Filter_IsLivingEnemy")
EndFunc
Func CanUse_ThunderfistStrike()
	If Anti_Attack() Then Return False
	Return True
EndFunc
Func BestTarget_ThunderfistStrike($a_f_AggroRange)
	Return UAI_GetNearestAgent(-2, $a_f_AggroRange, "UAI_Filter_IsLivingEnemy")
EndFunc
Func CanUse_ParasiticBite()
	If Anti_Attack() Then Return False
	Return True
EndFunc
Func BestTarget_ParasiticBite($a_f_AggroRange)
	Return UAI_GetNearestAgent(-2, $a_f_AggroRange, "UAI_Filter_IsLivingEnemy")
EndFunc
Func CanUse_TheSnipersSpear()
	If Anti_Attack() Then Return False
	Return True
EndFunc
Func BestTarget_TheSnipersSpear($a_f_AggroRange)
	Return UAI_GetNearestAgent(-2, $a_f_AggroRange, "UAI_Filter_IsLivingEnemy")
EndFunc
Func CanUse_WhirlwindAttackTuraiOssa()
	If Anti_Attack() Then Return False
	Return True
EndFunc
Func BestTarget_WhirlwindAttackTuraiOssa($a_f_AggroRange)
	Return UAI_GetNearestAgent(-2, $a_f_AggroRange, "UAI_Filter_IsLivingEnemy")
EndFunc
Func CanUse_DragonSlashTuraiOssa()
	If Anti_Attack() Then Return False
	Return True
EndFunc
Func BestTarget_DragonSlashTuraiOssa($a_f_AggroRange)
	Return UAI_GetNearestAgent(-2, $a_f_AggroRange, "UAI_Filter_IsLivingEnemy")
EndFunc
Func CanUse_FalkensFireFist()
	If Anti_Attack() Then Return False
	Return True
EndFunc
Func BestTarget_FalkensFireFist($a_f_AggroRange)
	Return UAI_GetNearestAgent(-2, $a_f_AggroRange, "UAI_Filter_IsLivingEnemy")
EndFunc
Func CanUse_EnragedSmashPvP()
	If Anti_Attack() Then Return False
	Return True
EndFunc
Func BestTarget_EnragedSmashPvP($a_f_AggroRange)
	Return UAI_GetNearestAgent(-2, $a_f_AggroRange, "UAI_Filter_IsLivingEnemy")
EndFunc
Func CanUse_PenetratingAttackPvP()
	If Anti_Attack() Then Return False
	Return True
EndFunc
Func BestTarget_PenetratingAttackPvP($a_f_AggroRange)
	Return UAI_GetNearestAgent(-2, $a_f_AggroRange, "UAI_Filter_IsLivingEnemy")
EndFunc
Func CanUse_SunderingAttackPvP()
	If Anti_Attack() Then Return False
	Return True
EndFunc
Func BestTarget_SunderingAttackPvP($a_f_AggroRange)
	Return UAI_GetNearestAgent(-2, $a_f_AggroRange, "UAI_Filter_IsLivingEnemy")
EndFunc
Func CanUse_MysticSweepPvP()
	If Anti_Attack() Then Return False
	Return True
EndFunc
Func BestTarget_MysticSweepPvP($a_f_AggroRange)
	Return UAI_GetNearestAgent(-2, $a_f_AggroRange, "UAI_Filter_IsLivingEnemy")
EndFunc
Func CanUse_EremitesAttackPvP()
	If Anti_Attack() Then Return False
	Return True
EndFunc
Func BestTarget_EremitesAttackPvP($a_f_AggroRange)
	Return UAI_GetNearestAgent(-2, $a_f_AggroRange, "UAI_Filter_IsLivingEnemy")
EndFunc
Func CanUse_HarriersTossPvP()
	If Anti_Attack() Then Return False
	Return True
EndFunc
Func BestTarget_HarriersTossPvP($a_f_AggroRange)
	Return UAI_GetNearestAgent(-2, $a_f_AggroRange, "UAI_Filter_IsLivingEnemy")
EndFunc
Func CanUse_ChillingVictoryPvP()
	If Anti_Attack() Then Return False
	Return True
EndFunc
Func BestTarget_ChillingVictoryPvP($a_f_AggroRange)
	Return UAI_GetNearestAgent(-2, $a_f_AggroRange, "UAI_Filter_IsLivingEnemy")
EndFunc
Func CanUse_SlothHuntersShotPvP()
	If Anti_Attack() Then Return False
	Return True
EndFunc
Func BestTarget_SlothHuntersShotPvP($a_f_AggroRange)
	Return UAI_GetNearestAgent(-2, $a_f_AggroRange, "UAI_Filter_IsLivingEnemy")
EndFunc
Func CanUse_PainAttackTogo1()
	If Anti_Attack() Then Return False
	Return True
EndFunc
Func BestTarget_PainAttackTogo1($a_f_AggroRange)
	Return UAI_GetNearestAgent(-2, $a_f_AggroRange, "UAI_Filter_IsLivingEnemy")
EndFunc
Func CanUse_PainAttackTogo2()
	If Anti_Attack() Then Return False
	Return True
EndFunc
Func BestTarget_PainAttackTogo2($a_f_AggroRange)
	Return UAI_GetNearestAgent(-2, $a_f_AggroRange, "UAI_Filter_IsLivingEnemy")
EndFunc
Func CanUse_PainAttackTogo3()
	If Anti_Attack() Then Return False
	Return True
EndFunc
Func BestTarget_PainAttackTogo3($a_f_AggroRange)
	Return UAI_GetNearestAgent(-2, $a_f_AggroRange, "UAI_Filter_IsLivingEnemy")
EndFunc
Func CanUse_DeathBlossomPvP()
	If Anti_Attack() Then Return False
	Return True
EndFunc
Func BestTarget_DeathBlossomPvP($a_f_AggroRange)
	Return UAI_GetNearestAgent(-2, $a_f_AggroRange, "UAI_Filter_IsLivingEnemy|UAI_Filter_IsLastStrikeIsOffHand")
EndFunc
Func CanUse_BoneSpike()
	If Anti_Attack() Then Return False
	Return True
EndFunc
Func BestTarget_BoneSpike($a_f_AggroRange)
	Return UAI_GetNearestAgent(-2, $a_f_AggroRange, "UAI_Filter_IsLivingEnemy")
EndFunc
Func CanUse_FlurryOfSplinters()
	If Anti_Attack() Then Return False
	Return True
EndFunc
Func BestTarget_FlurryOfSplinters($a_f_AggroRange)
	Return UAI_GetNearestAgent(-2, $a_f_AggroRange, "UAI_Filter_IsLivingEnemy")
EndFunc
Func CanUse_ReapingOfDhuum()
	If Anti_Attack() Then Return False
	Return True
EndFunc
Func BestTarget_ReapingOfDhuum($a_f_AggroRange)
	Return UAI_GetNearestAgent(-2, $a_f_AggroRange, "UAI_Filter_IsLivingEnemy")
EndFunc
Func CanUse_WeightOfDhuum()
	If Anti_Attack() Then Return False
	Return True
EndFunc
Func BestTarget_WeightOfDhuum($a_f_AggroRange)
	Return UAI_GetNearestAgent(-2, $a_f_AggroRange, "UAI_Filter_IsLivingEnemy")
EndFunc
Func CanUse_StaggeringBlowPvP()
	If Anti_Attack() Then Return False
	Return True
EndFunc
Func BestTarget_StaggeringBlowPvP($a_f_AggroRange)
	Return UAI_GetNearestAgent(-2, $a_f_AggroRange, "UAI_Filter_IsLivingEnemy")
EndFunc
Func CanUse_FierceBlowPvP()
	If Anti_Attack() Then Return False
	Return True
EndFunc
Func BestTarget_FierceBlowPvP($a_f_AggroRange)
	Return UAI_GetNearestAgent(-2, $a_f_AggroRange, "UAI_Filter_IsLivingEnemy")
EndFunc
Func CanUse_RenewingSmashPvP()
	If Anti_Attack() Then Return False
	Return True
EndFunc
Func BestTarget_RenewingSmashPvP($a_f_AggroRange)
	Return UAI_GetNearestAgent(-2, $a_f_AggroRange, "UAI_Filter_IsLivingEnemy")
EndFunc
Func CanUse_KeenArrowPvP()
	If Anti_Attack() Then Return False
	Return True
EndFunc
Func BestTarget_KeenArrowPvP($a_f_AggroRange)
	Return UAI_GetNearestAgent(-2, $a_f_AggroRange, "UAI_Filter_IsLivingEnemy")
EndFunc
Func CanUse_PainAttackSignetOfSpirits1()
	Return True
EndFunc
Func BestTarget_PainAttackSignetOfSpirits1($a_f_AggroRange)
	Return UAI_GetNearestAgent(-2, $a_f_AggroRange, "UAI_Filter_IsLivingEnemy")
EndFunc
Func CanUse_PainAttackSignetOfSpirits2()
	If Anti_Attack() Then Return False
	Return True
EndFunc
Func BestTarget_PainAttackSignetOfSpirits2($a_f_AggroRange)
	Return UAI_GetNearestAgent(-2, $a_f_AggroRange, "UAI_Filter_IsLivingEnemy")
EndFunc
Func CanUse_PainAttackSignetOfSpirits3()
	If Anti_Attack() Then Return False
	Return True
EndFunc
Func BestTarget_PainAttackSignetOfSpirits3($a_f_AggroRange)
	Return UAI_GetNearestAgent(-2, $a_f_AggroRange, "UAI_Filter_IsLivingEnemy")
EndFunc
Func CanUse_KeiransSniperShot()
	If Anti_Attack() Then Return False
	Return True
EndFunc
Func BestTarget_KeiransSniperShot($a_f_AggroRange)
	Return UAI_GetNearestAgent(-2, $a_f_AggroRange, "UAI_Filter_IsLivingEnemy")
EndFunc
Func CanUse_FalkenPunch()
	If Anti_Attack() Then Return False
	Return True
EndFunc
Func BestTarget_FalkenPunch($a_f_AggroRange)
	Return UAI_GetNearestAgent(-2, $a_f_AggroRange, "UAI_Filter_IsLivingEnemy")
EndFunc
Func CanUse_KeiransSniperShotHeartsOfTheNorth()
	If Anti_Attack() Then Return False
	Return True
EndFunc
Func BestTarget_KeiransSniperShotHeartsOfTheNorth($a_f_AggroRange)
	Return UAI_GetNearestAgent(-2, $a_f_AggroRange, "UAI_Filter_IsLivingEnemy")
EndFunc
Func CanUse_GravestoneMarker()
	If Anti_Attack() Then Return False
	Return True
EndFunc
Func BestTarget_GravestoneMarker($a_f_AggroRange)
	Local $l_i_Target = UAI_GetNearestAgent(-2, $a_f_AggroRange, "UAI_Filter_IsLivingEnemy|UAI_Filter_IsWeakened")
	If $l_i_Target <> 0 Then Return $l_i_Target
	Return UAI_GetNearestAgent(-2, $a_f_AggroRange, "UAI_Filter_IsLivingEnemy")
EndFunc
Func CanUse_TerminalVelocity()
	If Anti_Attack() Then Return False
	Return True
EndFunc
Func BestTarget_TerminalVelocity($a_f_AggroRange)
	Local $l_i_Target = UAI_GetNearestAgent(-2, $a_f_AggroRange, "UAI_Filter_IsLivingEnemy|UAI_Filter_IsBleeding")
	If $l_i_Target <> 0 Then Return $l_i_Target
	Return UAI_GetNearestAgent(-2, $a_f_AggroRange, "UAI_Filter_IsLivingEnemy")
EndFunc
Func CanUse_RelentlessAssault()
	If Anti_Attack() Then Return False
	Return True
EndFunc
Func BestTarget_RelentlessAssault($a_f_AggroRange)
	Return UAI_GetNearestAgent(-2, $a_f_AggroRange, "UAI_Filter_IsLivingEnemy")
EndFunc
Func CanUse_WitheringBlade()
	If Anti_Attack() Then Return False
	Return True
EndFunc
Func BestTarget_WitheringBlade($a_f_AggroRange)
	Return UAI_GetNearestAgent(-2, $a_f_AggroRange, "UAI_Filter_IsLivingEnemy")
EndFunc
Func CanUse_VenomFang()
	If Anti_Attack() Then Return False
	Return True
EndFunc
Func BestTarget_VenomFang($a_f_AggroRange)
	Local $l_i_Target = UAI_GetNearestAgent(-2, $a_f_AggroRange, "UAI_Filter_IsLivingEnemy|UAI_Filter_IsDeepWounded")
	If $l_i_Target <> 0 Then Return $l_i_Target
	Return UAI_GetNearestAgent(-2, $a_f_AggroRange, "UAI_Filter_IsLivingEnemy")
EndFunc
Func CanUse_RainOfArrows()
	If Anti_Attack() Then Return False
	Return True
EndFunc
Func BestTarget_RainOfArrows($a_f_AggroRange)
	Return UAI_GetNearestAgent(-2, $a_f_AggroRange, "UAI_Filter_IsLivingEnemy")
EndFunc
Func CanUse_FoxFangsPvP()
	If Anti_Attack() Then Return False
	Return True
EndFunc
Func BestTarget_FoxFangsPvP($a_f_AggroRange)
	Return UAI_GetNearestAgent(-2, $a_f_AggroRange, "UAI_Filter_IsLivingEnemy|UAI_Filter_IsLastStrikeIsLead")
EndFunc
Func CanUse_WildStrikePvP()
	If Anti_Attack() Then Return False
	Return True
EndFunc
Func BestTarget_WildStrikePvP($a_f_AggroRange)
	Return UAI_GetNearestAgent(-2, $a_f_AggroRange, "UAI_Filter_IsLivingEnemy|UAI_Filter_IsLastStrikeIsLead")
EndFunc
Func CanUse_BanishingStrikePvP()
	If Anti_Attack() Then Return False
	Return True
EndFunc
Func BestTarget_BanishingStrikePvP($a_f_AggroRange)
	Return UAI_GetNearestAgent(-2, $a_f_AggroRange, "UAI_Filter_IsLivingEnemy")
EndFunc
Func CanUse_TwinMoonSweepPvP()
	If Anti_Attack() Then Return False
	Return True
EndFunc
Func BestTarget_TwinMoonSweepPvP($a_f_AggroRange)
	Return UAI_GetNearestAgent(-2, $a_f_AggroRange, "UAI_Filter_IsLivingEnemy")
EndFunc
Func CanUse_IrresistibleSweepPvP()
	If Anti_Attack() Then Return False
	Return True
EndFunc
Func BestTarget_IrresistibleSweepPvP($a_f_AggroRange)
	Return UAI_GetNearestAgent(-2, $a_f_AggroRange, "UAI_Filter_IsLivingEnemy")
EndFunc
Func CanUse_PiousAssaultPvP()
	If Anti_Attack() Then Return False
	Return True
EndFunc
Func BestTarget_PiousAssaultPvP($a_f_AggroRange)
	Return UAI_GetNearestAgent(-2, $a_f_AggroRange, "UAI_Filter_IsLivingEnemy")
EndFunc
Func CanUse_ClubStrike()
	If Anti_Attack() Then Return False
	Return True
EndFunc
Func BestTarget_ClubStrike($a_f_AggroRange)
	Local $l_i_Target = UAI_GetNearestAgent(-2, $a_f_AggroRange, "UAI_Filter_IsLivingEnemy|UAI_Filter_HasCondition")
	If $l_i_Target <> 0 Then Return $l_i_Target
	Return UAI_GetNearestAgent(-2, $a_f_AggroRange, "UAI_Filter_IsLivingEnemy")
EndFunc
Func CanUse_Bludgeon()
	If Anti_Attack() Then Return False
	Return True
EndFunc
Func BestTarget_Bludgeon($a_f_AggroRange)
	Local $l_i_Target = UAI_GetNearestAgent(-2, $a_f_AggroRange, "UAI_Filter_IsLivingEnemy|UAI_Filter_IsKnocked")
	If $l_i_Target <> 0 Then Return $l_i_Target
	Return UAI_GetNearestAgent(-2, $a_f_AggroRange, "UAI_Filter_IsLivingEnemy")
EndFunc
Func CanUse_AnnihilatorBash()
	If Anti_Attack() Then Return False
	Return True
EndFunc
Func BestTarget_AnnihilatorBash($a_f_AggroRange)
	Return UAI_GetNearestAgent(-2, $a_f_AggroRange, "UAI_Filter_IsLivingEnemy")
EndFunc
Func CanUse_WoundingStrikePvP()
	If Anti_Attack() Then Return False
	Return True
EndFunc
Func BestTarget_WoundingStrikePvP($a_f_AggroRange)
	Return UAI_GetNearestAgent(-2, $a_f_AggroRange, "UAI_Filter_IsLivingEnemy")
EndFunc
Func CanUse_AnnihilatorStrike()
	If Anti_Attack() Then Return False
	Return True
EndFunc
Func BestTarget_AnnihilatorStrike($a_f_AggroRange)
	Return UAI_GetNearestAgent(-2, $a_f_AggroRange, "UAI_Filter_IsLivingEnemy")
EndFunc
Func CanUse_AnnihilatorKnuckle()
	If Anti_Attack() Then Return False
	Return True
EndFunc
Func BestTarget_AnnihilatorKnuckle($a_f_AggroRange)
	Return UAI_GetNearestAgent(-2, $a_f_AggroRange, "UAI_Filter_IsLivingEnemy")
EndFunc
Func CanUse_JudgmentStrike()
	If Anti_Attack() Then Return False
	Return True
EndFunc
Func BestTarget_JudgmentStrike($a_f_AggroRange)
	Return UAI_GetNearestAgent(-2, $a_f_AggroRange, "UAI_Filter_IsLivingEnemy")
EndFunc