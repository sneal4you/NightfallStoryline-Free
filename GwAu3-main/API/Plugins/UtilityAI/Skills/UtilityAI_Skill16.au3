#include-once
Func Anti_Skill16()
	Return False
EndFunc
Func CanUse_DefyPain()
	If UAI_GetPlayerInfo($GC_UAI_AGENT_HP) > 0.8 Then Return False
	Return True
EndFunc
Func BestTarget_DefyPain($a_f_AggroRange)
	Return UAI_GetPlayerInfo($GC_UAI_AGENT_ID)
EndFunc
Func CanUse_EndurePain()
	If UAI_GetPlayerInfo($GC_UAI_AGENT_HP) > 0.5 Then Return False
	Return True
EndFunc
Func BestTarget_EndurePain($a_f_AggroRange)
	Return UAI_GetPlayerInfo($GC_UAI_AGENT_ID)
EndFunc
Func CanUse_WarriorsCunning()
	If Not UAI_GetPlayerInfo($GC_UAI_AGENT_IsAttacking) Then Return False
	Return True
EndFunc
Func BestTarget_WarriorsCunning($a_f_AggroRange)
	Return UAI_GetPlayerInfo($GC_UAI_AGENT_ID)
EndFunc
Func CanUse_ShieldBash()
	Local $l_i_EnemyCount = UAI_CountAgents(UAI_GetPlayerInfo($GC_UAI_AGENT_ID), $GC_I_RANGE_ADJACENT, "UAI_Filter_IsLivingEnemy")
	If $l_i_EnemyCount < 1 Then Return False
	Return True
EndFunc
Func BestTarget_ShieldBash($a_f_AggroRange)
	Return UAI_GetPlayerInfo($GC_UAI_AGENT_ID)
EndFunc
Func CanUse_WarriorsEndurance()
	If Not UAI_GetPlayerInfo($GC_UAI_AGENT_IsAttacking) Then Return False
	If UAI_GetPlayerInfo($GC_UAI_AGENT_CurrentEnergy) > 10 Then Return False
	Return True
EndFunc
Func BestTarget_WarriorsEndurance($a_f_AggroRange)
	Return UAI_GetPlayerInfo($GC_UAI_AGENT_ID)
EndFunc
Func CanUse_HundredBlades()
	Local $l_i_EnemyCount = UAI_CountAgents(UAI_GetPlayerInfo($GC_UAI_AGENT_ID), $GC_I_RANGE_ADJACENT, "UAI_Filter_IsLivingEnemy")
	If $l_i_EnemyCount < 2 Then Return False
	Return True
EndFunc
Func BestTarget_HundredBlades($a_f_AggroRange)
	Return UAI_GetPlayerInfo($GC_UAI_AGENT_ID)
EndFunc
Func CanUse_Riposte()
	Local $l_i_EnemyCount = UAI_CountAgents(UAI_GetPlayerInfo($GC_UAI_AGENT_ID), $GC_I_RANGE_ADJACENT, "UAI_Filter_IsLivingEnemy")
	If $l_i_EnemyCount < 1 Then Return False
	Return True
EndFunc
Func BestTarget_Riposte($a_f_AggroRange)
	Return UAI_GetPlayerInfo($GC_UAI_AGENT_ID)
EndFunc
Func CanUse_DeadlyRiposte()
	Local $l_i_EnemyCount = UAI_CountAgents(UAI_GetPlayerInfo($GC_UAI_AGENT_ID), $GC_I_RANGE_ADJACENT, "UAI_Filter_IsLivingEnemy")
	If $l_i_EnemyCount < 1 Then Return False
	Return True
EndFunc
Func BestTarget_DeadlyRiposte($a_f_AggroRange)
	Return UAI_GetPlayerInfo($GC_UAI_AGENT_ID)
EndFunc
Func CanUse_CriticalEye()
	If Not UAI_GetPlayerInfo($GC_UAI_AGENT_IsAttacking) Then Return False
	Return True
EndFunc
Func BestTarget_CriticalEye($a_f_AggroRange)
	Return UAI_GetPlayerInfo($GC_UAI_AGENT_ID)
EndFunc
Func CanUse_AuraOfTheJuggernaut()
	Return True
EndFunc
Func BestTarget_AuraOfTheJuggernaut($a_f_AggroRange)
	Return UAI_GetPlayerInfo($GC_UAI_AGENT_ID)
EndFunc
Func CanUse_RitualLord()
	Return True
EndFunc
Func BestTarget_RitualLord($a_f_AggroRange)
	Return UAI_GetPlayerInfo($GC_UAI_AGENT_ID)
EndFunc
Func CanUse_SoulTwisting()
	Return True
EndFunc
Func BestTarget_SoulTwisting($a_f_AggroRange)
	Return UAI_GetPlayerInfo($GC_UAI_AGENT_ID)
EndFunc
Func CanUse_EtherPrism()
	If UAI_GetPlayerInfo($GC_UAI_AGENT_HP) > 0.5 Then Return False
	Return True
EndFunc
Func BestTarget_EtherPrism($a_f_AggroRange)
	Return UAI_GetPlayerInfo($GC_UAI_AGENT_ID)
EndFunc
Func CanUse_RageOfTheNtouka()
	Return True
EndFunc
Func BestTarget_RageOfTheNtouka($a_f_AggroRange)
	Return UAI_GetPlayerInfo($GC_UAI_AGENT_ID)
EndFunc
Func CanUse_ExtendEnchantments()
	If UAI_PlayerHasEffect($GC_I_SKILL_ID_EXTEND_ENCHANTMENTS) Then Return False
	Local $l_i_VoSSlot = Skill_GetSlotByID($GC_I_SKILL_ID_VOW_OF_STRENGTH)
	If $l_i_VoSSlot > 0 Then
		If UAI_PlayerHasEffect($GC_I_SKILL_ID_VOW_OF_STRENGTH) Then Return False
	EndIf
	Return True
EndFunc
Func BestTarget_ExtendEnchantments($a_f_AggroRange)
	Return UAI_GetPlayerInfo($GC_UAI_AGENT_ID)
EndFunc
Func CanUse_CurseOfTheStaffOfTheMists()
	Return True
EndFunc
Func BestTarget_CurseOfTheStaffOfTheMists($a_f_AggroRange)
	Return UAI_GetPlayerInfo($GC_UAI_AGENT_ID)
EndFunc
Func CanUse_AuraOfTheStaffOfTheMists()
	Return True
EndFunc
Func BestTarget_AuraOfTheStaffOfTheMists($a_f_AggroRange)
	Return UAI_GetPlayerInfo($GC_UAI_AGENT_ID)
EndFunc
Func CanUse_PowerOfTheStaffOfTheMists()
	Return True
EndFunc
Func BestTarget_PowerOfTheStaffOfTheMists($a_f_AggroRange)
	Return UAI_GetPlayerInfo($GC_UAI_AGENT_ID)
EndFunc
Func CanUse_RampageAsOne()
	Local $l_i_PetSize = World_GetWorldInfo("PetInfoArraySize")
    Local $lMyPet = 0
    For $i = 1 To $l_i_PetSize
        If Party_GetPetInfo($i, "OwnerAgentID") = UAI_GetPlayerInfo($GC_UAI_AGENT_ID) Then
            $lMyPet = Party_GetPetInfo($i, "AgentID")
            ExitLoop
        EndIf
    Next
    If $lMyPet = 0 Then Return False
    If Agent_GetAgentInfo($lMyPet, "HPPercent") = 0 Then Return False
	Return True
EndFunc
Func BestTarget_RampageAsOne($a_f_AggroRange)
	Return UAI_GetPlayerInfo($GC_UAI_AGENT_ID)
EndFunc
Func CanUse_FocusedAnger()
	Return True
EndFunc
Func BestTarget_FocusedAnger($a_f_AggroRange)
	Return UAI_GetPlayerInfo($GC_UAI_AGENT_ID)
EndFunc
Func CanUse_NaturalTemper()
	If UAI_GetPlayerInfo($GC_UAI_AGENT_IsEnchanted) Then Return False
	Return True
EndFunc
Func BestTarget_NaturalTemper($a_f_AggroRange)
	Return UAI_GetPlayerInfo($GC_UAI_AGENT_ID)
EndFunc
Func CanUse_Enraged()
	Return True
EndFunc
Func BestTarget_Enraged($a_f_AggroRange)
	Return UAI_GetPlayerInfo($GC_UAI_AGENT_ID)
EndFunc
Func CanUse_Ram()
	Return True
EndFunc
Func BestTarget_Ram($a_f_AggroRange)
	Return UAI_GetPlayerInfo($GC_UAI_AGENT_ID)
EndFunc
Func CanUse_HardenShell()
	Return True
EndFunc
Func BestTarget_HardenShell($a_f_AggroRange)
	Return UAI_GetPlayerInfo($GC_UAI_AGENT_ID)
EndFunc
Func CanUse_RollerbeetleDash()
	Return True
EndFunc
Func BestTarget_RollerbeetleDash($a_f_AggroRange)
	Return UAI_GetPlayerInfo($GC_UAI_AGENT_ID)
EndFunc
Func CanUse_SuperRollerbeetle()
	Return True
EndFunc
Func BestTarget_SuperRollerbeetle($a_f_AggroRange)
	Return UAI_GetPlayerInfo($GC_UAI_AGENT_ID)
EndFunc
Func CanUse_RollerbeetleEcho()
	Return True
EndFunc
Func BestTarget_RollerbeetleEcho($a_f_AggroRange)
	Return UAI_GetPlayerInfo($GC_UAI_AGENT_ID)
EndFunc
Func CanUse_DistractingLunge()
	Return True
EndFunc
Func BestTarget_DistractingLunge($a_f_AggroRange)
	Return 0
EndFunc
Func CanUse_RollerbeetleBlast()
	Return True
EndFunc
Func BestTarget_RollerbeetleBlast($a_f_AggroRange)
	Return 0
EndFunc
Func CanUse_SpitRocks()
	Return True
EndFunc
Func BestTarget_SpitRocks($a_f_AggroRange)
	Return 0
EndFunc
Func CanUse_Intensity()
	Return True
EndFunc
Func BestTarget_Intensity($a_f_AggroRange)
	Return UAI_GetPlayerInfo($GC_UAI_AGENT_ID)
EndFunc
Func CanUse_NeverRampageAlone()
	Local $l_i_PetSize = World_GetWorldInfo("PetInfoArraySize")
    Local $lMyPet = 0
    For $i = 1 To $l_i_PetSize
        If Party_GetPetInfo($i, "OwnerAgentID") = UAI_GetPlayerInfo($GC_UAI_AGENT_ID) Then
            $lMyPet = Party_GetPetInfo($i, "AgentID")
            ExitLoop
        EndIf
    Next
    If $lMyPet = 0 Then Return False
    If Agent_GetAgentInfo($lMyPet, "HPPercent") = 0 Then Return False
	Return True
EndFunc
Func BestTarget_NeverRampageAlone($a_f_AggroRange)
	Return UAI_GetPlayerInfo($GC_UAI_AGENT_ID)
EndFunc
Func CanUse_BurningShield()
	Local $l_i_EnemyCount = UAI_CountAgents(UAI_GetPlayerInfo($GC_UAI_AGENT_ID), $GC_I_RANGE_ADJACENT, "UAI_Filter_IsLivingEnemy")
	If $l_i_EnemyCount < 1 Then Return False
	Return True
EndFunc
Func BestTarget_BurningShield($a_f_AggroRange)
	Return UAI_GetPlayerInfo($GC_UAI_AGENT_ID)
EndFunc
Func CanUse_FeelNoPain()
	Return True
EndFunc
Func BestTarget_FeelNoPain($a_f_AggroRange)
	Return UAI_GetPlayerInfo($GC_UAI_AGENT_ID)
EndFunc
Func CanUse_UrsanForce()
	Return True
EndFunc
Func BestTarget_UrsanForce($a_f_AggroRange)
	Return UAI_GetPlayerInfo($GC_UAI_AGENT_ID)
EndFunc
Func CanUse_FalkenQuick()
	Return True
EndFunc
Func BestTarget_FalkenQuick($a_f_AggroRange)
	Return UAI_GetPlayerInfo($GC_UAI_AGENT_ID)
EndFunc
Func CanUse_RitualLordPvP()
	Return True
EndFunc
Func BestTarget_RitualLordPvP($a_f_AggroRange)
	Return UAI_GetPlayerInfo($GC_UAI_AGENT_ID)
EndFunc