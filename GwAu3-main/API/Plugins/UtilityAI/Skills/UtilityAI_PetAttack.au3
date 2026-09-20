#include-once
Func Anti_PetAttack()
	Local $l_i_PetAgentID = Party_GetPetInfo(1, "AgentID")
	If $l_i_PetAgentID = 0 Then Return True
	Local $l_i_OwnerID = Party_GetPetInfo(1, "OwnerAgentID")
	If $l_i_OwnerID <> Agent_GetAgentInfo(-2, "ID") Then Return True
	Local $l_f_PetHP = Agent_GetAgentInfo($l_i_PetAgentID, "HP")
	If $l_f_PetHP <= 0 Then Return True
	Return UAI_AgentHasVisibleEffect($l_i_PetAgentID, $GC_I_EFFECT_TYPE_STATUS, $GC_I_EFFECT_ID_BLINDED)
EndFunc
Func CanUse_BestialPounce()
	If Anti_PetAttack() Then Return False
	Return True
EndFunc
Func BestTarget_BestialPounce($a_f_AggroRange)
	Local $l_i_Target = UAI_GetBestSingleTarget(-2, $a_f_AggroRange, $GC_UAI_AGENT_HP, "UAI_Filter_IsLivingEnemy|UAI_Filter_IsCaster")
	If $l_i_Target <> 0 Then Return $l_i_Target
	Return UAI_GetBestSingleTarget(-2, $a_f_AggroRange, $GC_UAI_AGENT_HP, "UAI_Filter_IsLivingEnemy")
EndFunc
Func CanUse_MaimingStrike()
	If Anti_PetAttack() Then Return False
	Return True
EndFunc
Func BestTarget_MaimingStrike($a_f_AggroRange)
	Local $l_i_Target = UAI_GetBestSingleTarget(-2, $a_f_AggroRange, $GC_UAI_AGENT_HP, "UAI_Filter_IsLivingEnemy|UAI_Filter_IsMoving")
	If $l_i_Target <> 0 Then Return $l_i_Target
	Return UAI_GetBestSingleTarget(-2, $a_f_AggroRange, $GC_UAI_AGENT_HP, "UAI_Filter_IsLivingEnemy")
EndFunc
Func CanUse_FeralLunge()
	If Anti_PetAttack() Then Return False
	Return True
EndFunc
Func BestTarget_FeralLunge($a_f_AggroRange)
	Local $l_i_Target = UAI_GetBestSingleTarget(-2, $a_f_AggroRange, $GC_UAI_AGENT_HP, "UAI_Filter_IsLivingEnemy|UAI_Filter_IsAttacking")
	If $l_i_Target <> 0 Then Return $l_i_Target
	Return UAI_GetBestSingleTarget(-2, $a_f_AggroRange, $GC_UAI_AGENT_HP, "UAI_Filter_IsLivingEnemy")
EndFunc
Func CanUse_ScavengerStrike()
	If Anti_PetAttack() Then Return False
	Return True
EndFunc
Func BestTarget_ScavengerStrike($a_f_AggroRange)
	Local $l_i_Target = UAI_GetBestSingleTarget(-2, $a_f_AggroRange, $GC_UAI_AGENT_HP, "UAI_Filter_IsLivingEnemy|UAI_Filter_IsConditioned")
	If $l_i_Target <> 0 Then Return $l_i_Target
	Return UAI_GetBestSingleTarget(-2, $a_f_AggroRange, $GC_UAI_AGENT_HP, "UAI_Filter_IsLivingEnemy")
EndFunc
Func CanUse_MelandrusAssault()
	If Anti_PetAttack() Then Return False
	Return True
EndFunc
Func BestTarget_MelandrusAssault($a_f_AggroRange)
	Return UAI_GetBestAOETarget(-2, $a_f_AggroRange, $GC_I_RANGE_NEARBY, "UAI_Filter_IsLivingEnemy")
EndFunc
Func CanUse_FerociousStrike()
	If Anti_PetAttack() Then Return False
	Return True
EndFunc
Func BestTarget_FerociousStrike($a_f_AggroRange)
	Return UAI_GetBestSingleTarget(-2, $a_f_AggroRange, $GC_UAI_AGENT_HP, "UAI_Filter_IsLivingEnemy")
EndFunc
Func CanUse_PredatorsPounce()
	If Anti_PetAttack() Then Return False
	Return True
EndFunc
Func BestTarget_PredatorsPounce($a_f_AggroRange)
	Return UAI_GetBestSingleTarget(-2, $a_f_AggroRange, $GC_UAI_AGENT_HP, "UAI_Filter_IsLivingEnemy")
EndFunc
Func CanUse_BrutalStrike()
	If Anti_PetAttack() Then Return False
	Return True
EndFunc
Func BestTarget_BrutalStrike($a_f_AggroRange)
	Local $l_i_Target = UAI_GetBestSingleTarget(-2, $a_f_AggroRange, $GC_UAI_AGENT_HP, "UAI_Filter_IsLivingEnemy|UAI_Filter_IsBelow50HP")
	If $l_i_Target <> 0 Then Return $l_i_Target
	Return UAI_GetBestSingleTarget(-2, $a_f_AggroRange, $GC_UAI_AGENT_HP, "UAI_Filter_IsLivingEnemy")
EndFunc
Func CanUse_DisruptingLunge()
	If Anti_PetAttack() Then Return False
	Return True
EndFunc
Func BestTarget_DisruptingLunge($a_f_AggroRange)
	Local $l_i_Target = UAI_GetBestSingleTarget(-2, $a_f_AggroRange, $GC_UAI_AGENT_HP, "UAI_Filter_IsLivingEnemy|UAI_Filter_IsCaster")
	If $l_i_Target <> 0 Then Return $l_i_Target
	Return UAI_GetBestSingleTarget(-2, $a_f_AggroRange, $GC_UAI_AGENT_HP, "UAI_Filter_IsLivingEnemy")
EndFunc
Func CanUse_SavagePounce()
	If Anti_PetAttack() Then Return False
	Return True
EndFunc
Func BestTarget_SavagePounce($a_f_AggroRange)
	Local $l_i_Target = UAI_GetBestSingleTarget(-2, $a_f_AggroRange, $GC_UAI_AGENT_HP, "UAI_Filter_IsLivingEnemy|UAI_Filter_IsCasting")
	If $l_i_Target <> 0 Then Return $l_i_Target
	Return UAI_GetBestSingleTarget(-2, $a_f_AggroRange, $GC_UAI_AGENT_HP, "UAI_Filter_IsLivingEnemy")
EndFunc
Func CanUse_EnragedLunge()
	If Anti_PetAttack() Then Return False
	Return True
EndFunc
Func BestTarget_EnragedLunge($a_f_AggroRange)
	Local $l_i_Target = UAI_GetBestSingleTarget(-2, $a_f_AggroRange, $GC_UAI_AGENT_HP, "UAI_Filter_IsLivingEnemy|UAI_Filter_IsNotDeepWounded")
	If $l_i_Target <> 0 Then Return $l_i_Target
	Return UAI_GetBestSingleTarget(-2, $a_f_AggroRange, $GC_UAI_AGENT_HP, "UAI_Filter_IsLivingEnemy")
EndFunc
Func CanUse_BestialMauling()
	If Anti_PetAttack() Then Return False
	Return True
EndFunc
Func BestTarget_BestialMauling($a_f_AggroRange)
	Local $l_i_Target = UAI_GetBestSingleTarget(-2, $a_f_AggroRange, $GC_UAI_AGENT_HP, "UAI_Filter_IsLivingEnemy|UAI_Filter_IsKnocked")
	If $l_i_Target <> 0 Then Return $l_i_Target
	Return UAI_GetBestSingleTarget(-2, $a_f_AggroRange, $GC_UAI_AGENT_HP, "UAI_Filter_IsLivingEnemy")
EndFunc
Func CanUse_PoisonousBite()
	If Anti_PetAttack() Then Return False
	Return True
EndFunc
Func BestTarget_PoisonousBite($a_f_AggroRange)
	Local $l_i_Target = UAI_GetBestSingleTarget(-2, $a_f_AggroRange, $GC_UAI_AGENT_HP, "UAI_Filter_IsLivingEnemy|UAI_Filter_IsNotPoisoned")
	If $l_i_Target <> 0 Then Return $l_i_Target
	Return UAI_GetBestSingleTarget(-2, $a_f_AggroRange, $GC_UAI_AGENT_HP, "UAI_Filter_IsLivingEnemy")
EndFunc
Func CanUse_Pounce()
	If Anti_PetAttack() Then Return False
	Return True
EndFunc
Func BestTarget_Pounce($a_f_AggroRange)
	Local $l_i_Target = UAI_GetBestSingleTarget(-2, $a_f_AggroRange, $GC_UAI_AGENT_HP, "UAI_Filter_IsLivingEnemy|UAI_Filter_IsMoving")
	If $l_i_Target <> 0 Then Return $l_i_Target
	Return UAI_GetBestSingleTarget(-2, $a_f_AggroRange, $GC_UAI_AGENT_HP, "UAI_Filter_IsLivingEnemy")
EndFunc
Func CanUse_MelandrusAssaultPvP()
	If Anti_PetAttack() Then Return False
	Return True
EndFunc
Func BestTarget_MelandrusAssaultPvP($a_f_AggroRange)
	Local $l_i_Target = UAI_GetBestAOETarget(-2, $a_f_AggroRange, $GC_I_RANGE_ADJACENT, "UAI_Filter_IsLivingEnemy|UAI_Filter_IsEnchanted")
	If $l_i_Target <> 0 Then Return $l_i_Target
	$l_i_Target = UAI_GetBestSingleTarget(-2, $a_f_AggroRange, $GC_UAI_AGENT_HP, "UAI_Filter_IsLivingEnemy|UAI_Filter_IsEnchanted")
	If $l_i_Target <> 0 Then Return $l_i_Target
	Return UAI_GetBestSingleTarget(-2, $a_f_AggroRange, $GC_UAI_AGENT_HP, "UAI_Filter_IsLivingEnemy")
EndFunc
Func CanUse_EnragedLungePvP()
	If Anti_PetAttack() Then Return False
	Return True
EndFunc
Func BestTarget_EnragedLungePvP($a_f_AggroRange)
	Return UAI_GetBestSingleTarget(-2, $a_f_AggroRange, $GC_UAI_AGENT_HP, "UAI_Filter_IsLivingEnemy")
EndFunc