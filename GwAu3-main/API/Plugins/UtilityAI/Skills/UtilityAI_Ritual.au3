#include-once
Func Anti_Ritual()
	Return False
EndFunc
Func CanUse_Winter()
	Return True
EndFunc
Func BestTarget_Winter($a_f_AggroRange)
	Return UAI_GetPlayerInfo($GC_UAI_AGENT_ID)
EndFunc
Func CanUse_Winnowing()
	Return True
EndFunc
Func BestTarget_Winnowing($a_f_AggroRange)
	Return UAI_GetPlayerInfo($GC_UAI_AGENT_ID)
EndFunc
Func CanUse_EdgeOfExtinction()
	Return True
EndFunc
Func BestTarget_EdgeOfExtinction($a_f_AggroRange)
	Return UAI_GetPlayerInfo($GC_UAI_AGENT_ID)
EndFunc
Func CanUse_GreaterConflagration()
	Return True
EndFunc
Func BestTarget_GreaterConflagration($a_f_AggroRange)
	Return UAI_GetPlayerInfo($GC_UAI_AGENT_ID)
EndFunc
Func CanUse_Conflagration()
	Return True
EndFunc
Func BestTarget_Conflagration($a_f_AggroRange)
	Return UAI_GetPlayerInfo($GC_UAI_AGENT_ID)
EndFunc
Func CanUse_FertileSeason()
	Return True
EndFunc
Func BestTarget_FertileSeason($a_f_AggroRange)
	Return UAI_GetPlayerInfo($GC_UAI_AGENT_ID)
EndFunc
Func CanUse_Symbiosis()
	Return True
EndFunc
Func BestTarget_Symbiosis($a_f_AggroRange)
	Return UAI_GetPlayerInfo($GC_UAI_AGENT_ID)
EndFunc
Func CanUse_PrimalEchoes()
	Return True
EndFunc
Func BestTarget_PrimalEchoes($a_f_AggroRange)
	Return UAI_GetPlayerInfo($GC_UAI_AGENT_ID)
EndFunc
Func CanUse_PredatorySeason()
	Return True
EndFunc
Func BestTarget_PredatorySeason($a_f_AggroRange)
	Return UAI_GetPlayerInfo($GC_UAI_AGENT_ID)
EndFunc
Func CanUse_FrozenSoil()
	Return True
EndFunc
Func BestTarget_FrozenSoil($a_f_AggroRange)
	Return UAI_GetPlayerInfo($GC_UAI_AGENT_ID)
EndFunc
Func CanUse_FavorableWinds()
	Return True
EndFunc
Func BestTarget_FavorableWinds($a_f_AggroRange)
	Return UAI_GetPlayerInfo($GC_UAI_AGENT_ID)
EndFunc
Func CanUse_HighWinds()
	Return True
EndFunc
Func BestTarget_HighWinds($a_f_AggroRange)
	Return UAI_GetPlayerInfo($GC_UAI_AGENT_ID)
EndFunc
Func CanUse_EnergizingWind()
	Return True
EndFunc
Func BestTarget_EnergizingWind($a_f_AggroRange)
	Return UAI_GetPlayerInfo($GC_UAI_AGENT_ID)
EndFunc
Func CanUse_QuickeningZephyr()
	Return True
EndFunc
Func BestTarget_QuickeningZephyr($a_f_AggroRange)
	Return UAI_GetPlayerInfo($GC_UAI_AGENT_ID)
EndFunc
Func CanUse_NaturesRenewal()
	Return True
EndFunc
Func BestTarget_NaturesRenewal($a_f_AggroRange)
	Return UAI_GetPlayerInfo($GC_UAI_AGENT_ID)
EndFunc
Func CanUse_MuddyTerrain()
	Return True
EndFunc
Func BestTarget_MuddyTerrain($a_f_AggroRange)
	Return UAI_GetPlayerInfo($GC_UAI_AGENT_ID)
EndFunc
Func CanUse_Pestilence()
	Return True
EndFunc
Func BestTarget_Pestilence($a_f_AggroRange)
	Return UAI_GetPlayerInfo($GC_UAI_AGENT_ID)
EndFunc
Func CanUse_Shadowsong()
	Local $l_i_Spirit = UAI_FindAgentByPlayerNumber(4213, -2, 2500, "UAI_Filter_IsControlledSpirit")
	If $l_i_Spirit <> 0 Then
		If UAI_GetAgentInfoByID($l_i_Spirit, $GC_UAI_AGENT_HP) < 0.20 Then Return True
		Return False
	EndIf
	Return True
EndFunc
Func BestTarget_Shadowsong($a_f_AggroRange)
	Return UAI_GetPlayerInfo($GC_UAI_AGENT_ID)
EndFunc
Func CanUse_Union()
	Local $l_i_Spirit = UAI_FindAgentByPlayerNumber(4224, -2, 2500, "UAI_Filter_IsControlledSpirit")
	If $l_i_Spirit <> 0 Then
		If UAI_GetAgentInfoByID($l_i_Spirit, $GC_UAI_AGENT_HP) < 0.20 Then Return True
		Return False
	EndIf
	Return True
EndFunc
Func BestTarget_Union($a_f_AggroRange)
	Return UAI_GetPlayerInfo($GC_UAI_AGENT_ID)
EndFunc
Func CanUse_Destruction()
	Local $l_i_Spirit = UAI_FindAgentByPlayerNumber(4215, -2, 2500, "UAI_Filter_IsControlledSpirit")
	If $l_i_Spirit <> 0 Then Return False
	Return True
EndFunc
Func BestTarget_Destruction($a_f_AggroRange)
	Return UAI_GetPlayerInfo($GC_UAI_AGENT_ID)
EndFunc
Func CanUse_Dissonance()
	Local $l_i_Spirit = UAI_FindAgentByPlayerNumber(4221, -2, 2500, "UAI_Filter_IsControlledSpirit")
	If $l_i_Spirit <> 0 Then
		If UAI_GetAgentInfoByID($l_i_Spirit, $GC_UAI_AGENT_HP) < 0.20 Then Return True
		Return False
	EndIf
	Return True
EndFunc
Func BestTarget_Dissonance($a_f_AggroRange)
	Return UAI_GetPlayerInfo($GC_UAI_AGENT_ID)
EndFunc
Func CanUse_Disenchantment()
	Local $l_i_Spirit = UAI_FindAgentByPlayerNumber(4225, -2, 2500, "UAI_Filter_IsControlledSpirit")
	If $l_i_Spirit <> 0 Then
		If UAI_GetAgentInfoByID($l_i_Spirit, $GC_UAI_AGENT_HP) < 0.20 Then Return True
		Return False
	EndIf
	Return True
EndFunc
Func BestTarget_Disenchantment($a_f_AggroRange)
	Return UAI_GetPlayerInfo($GC_UAI_AGENT_ID)
EndFunc
Func CanUse_Brambles()
	Return True
EndFunc
Func BestTarget_Brambles($a_f_AggroRange)
	Return UAI_GetPlayerInfo($GC_UAI_AGENT_ID)
EndFunc
Func CanUse_Lacerate()
	Return True
EndFunc
Func BestTarget_Lacerate($a_f_AggroRange)
	Return UAI_GetPlayerInfo($GC_UAI_AGENT_ID)
EndFunc
Func CanUse_Restoration()
	If UAI_PlayerHasEffect($GC_I_SKILL_ID_CURSE_OF_DHUUM) Or UAI_PlayerHasEffect($GC_I_SKILL_ID_FROZEN_SOIL) Then Return False
	Local $l_i_Spirit = UAI_FindAgentByPlayerNumber(4223, -2, 2500, "UAI_Filter_IsControlledSpirit")
	If $l_i_Spirit <> 0 Then Return False
	Return True
EndFunc
Func BestTarget_Restoration($a_f_AggroRange)
	Return UAI_GetPlayerInfo($GC_UAI_AGENT_ID)
EndFunc
Func CanUse_Recuperation()
	Local $l_i_Spirit = UAI_FindAgentByPlayerNumber(4220, -2, 2500, "UAI_Filter_IsControlledSpirit")
	If $l_i_Spirit <> 0 Then
		If UAI_GetAgentInfoByID($l_i_Spirit, $GC_UAI_AGENT_HP) < 0.20 Then Return True
		Return False
	EndIf
	Return True
EndFunc
Func BestTarget_Recuperation($a_f_AggroRange)
	Return UAI_GetPlayerInfo($GC_UAI_AGENT_ID)
EndFunc
Func CanUse_Shelter()
	Local $l_i_Spirit = UAI_FindAgentByPlayerNumber(4223, -2, 2500, "UAI_Filter_IsControlledSpirit")
	If $l_i_Spirit <> 0 Then
		If UAI_GetAgentInfoByID($l_i_Spirit, $GC_UAI_AGENT_HP) < 0.20 Then Return True
		Return False
	EndIf
	Return True
EndFunc
Func BestTarget_Shelter($a_f_AggroRange)
	Return UAI_GetPlayerInfo($GC_UAI_AGENT_ID)
EndFunc
Func CanUse_Famine()
	Return True
EndFunc
Func BestTarget_Famine($a_f_AggroRange)
	Return UAI_GetPlayerInfo($GC_UAI_AGENT_ID)
EndFunc
Func CanUse_Equinox()
	Return True
EndFunc
Func BestTarget_Equinox($a_f_AggroRange)
	Return UAI_GetPlayerInfo($GC_UAI_AGENT_ID)
EndFunc
Func CanUse_Tranquility()
	Return True
EndFunc
Func BestTarget_Tranquility($a_f_AggroRange)
	Return UAI_GetPlayerInfo($GC_UAI_AGENT_ID)
EndFunc
Func CanUse_Pain()
	Return True
EndFunc
Func BestTarget_Pain($a_f_AggroRange)
	Return UAI_GetPlayerInfo($GC_UAI_AGENT_ID)
EndFunc
Func CanUse_Displacement()
	Local $l_i_Spirit = UAI_FindAgentByPlayerNumber(4217, -2, 2500, "UAI_Filter_IsControlledSpirit")
	If $l_i_Spirit <> 0 Then
		If UAI_GetAgentInfoByID($l_i_Spirit, $GC_UAI_AGENT_HP) < 0.20 Then Return True
		Return False
	EndIf
	Return True
EndFunc
Func BestTarget_Displacement($a_f_AggroRange)
	Return UAI_GetPlayerInfo($GC_UAI_AGENT_ID)
EndFunc
Func CanUse_Preservation()
	Local $l_i_Spirit = UAI_FindAgentByPlayerNumber(4219, -2, 2500, "UAI_Filter_IsControlledSpirit")
	If $l_i_Spirit <> 0 Then
		If UAI_GetAgentInfoByID($l_i_Spirit, $GC_UAI_AGENT_HP) < 0.20 Then Return True
		Return False
	EndIf
	Return True
EndFunc
Func BestTarget_Preservation($a_f_AggroRange)
	Return UAI_GetPlayerInfo($GC_UAI_AGENT_ID)
EndFunc
Func CanUse_Life()
	Return True
EndFunc
Func BestTarget_Life($a_f_AggroRange)
	Return UAI_GetPlayerInfo($GC_UAI_AGENT_ID)
EndFunc
Func CanUse_Earthbind()
	Local $l_i_Spirit = UAI_FindAgentByPlayerNumber(4222, -2, 2500, "UAI_Filter_IsControlledSpirit")
	If $l_i_Spirit <> 0 Then
		If UAI_GetAgentInfoByID($l_i_Spirit, $GC_UAI_AGENT_HP) < 0.20 Then Return True
		Return False
	EndIf
	Return True
EndFunc
Func BestTarget_Earthbind($a_f_AggroRange)
	Return UAI_GetPlayerInfo($GC_UAI_AGENT_ID)
EndFunc
Func CanUse_Bloodsong()
	Local $l_i_Spirit = UAI_FindAgentByPlayerNumber(4227, -2, 2500, "UAI_Filter_IsControlledSpirit")
	If $l_i_Spirit <> 0 Then
		If UAI_GetAgentInfoByID($l_i_Spirit, $GC_UAI_AGENT_HP) < 0.20 Then Return True
		Return False
	EndIf
	Return True
EndFunc
Func BestTarget_Bloodsong($a_f_AggroRange)
	Return UAI_GetPlayerInfo($GC_UAI_AGENT_ID)
EndFunc
Func CanUse_Wanderlust()
	Local $l_i_Spirit = UAI_FindAgentByPlayerNumber(4228, -2, 2500, "UAI_Filter_IsControlledSpirit")
	If $l_i_Spirit <> 0 Then
		If UAI_GetAgentInfoByID($l_i_Spirit, $GC_UAI_AGENT_HP) < 0.20 Then Return True
		Return False
	EndIf
	Return True
EndFunc
Func BestTarget_Wanderlust($a_f_AggroRange)
	Return UAI_GetPlayerInfo($GC_UAI_AGENT_ID)
EndFunc
Func CanUse_Soothing()
	Local $l_i_Spirit = UAI_FindAgentByPlayerNumber(4216, -2, 2500, "UAI_Filter_IsControlledSpirit")
	If $l_i_Spirit <> 0 Then
		If UAI_GetAgentInfoByID($l_i_Spirit, $GC_UAI_AGENT_HP) < 0.20 Then Return True
		Return False
	EndIf
	Return True
EndFunc
Func BestTarget_Soothing($a_f_AggroRange)
	Return UAI_GetPlayerInfo($GC_UAI_AGENT_ID)
EndFunc
Func CanUse_Toxicity()
	Return True
EndFunc
Func BestTarget_Toxicity($a_f_AggroRange)
	Return UAI_GetPlayerInfo($GC_UAI_AGENT_ID)
EndFunc
Func CanUse_Quicksand()
	Return True
EndFunc
Func BestTarget_Quicksand($a_f_AggroRange)
	Return UAI_GetPlayerInfo($GC_UAI_AGENT_ID)
EndFunc
Func CanUse_RoaringWinds()
	Return True
EndFunc
Func BestTarget_RoaringWinds($a_f_AggroRange)
	Return UAI_GetPlayerInfo($GC_UAI_AGENT_ID)
EndFunc
Func CanUse_InfuriatingHeat()
	Return True
EndFunc
Func BestTarget_InfuriatingHeat($a_f_AggroRange)
	Return UAI_GetPlayerInfo($GC_UAI_AGENT_ID)
EndFunc
Func CanUse_GazeOfFury()
	Local $l_i_Spirit = UAI_FindAgentByPlayerNumber(5722, -2, 2500, "UAI_Filter_IsControlledSpirit")
	If $l_i_Spirit <> 0 Then Return False
	If UAI_CountAgents(-2, 1250, "UAI_Filter_IsControlledSpirit") = 0 Then Return False
	Return True
EndFunc
Func BestTarget_GazeOfFury($a_f_AggroRange)
	Return
EndFunc
Func CanUse_Anguish()
	Local $l_i_Spirit = UAI_FindAgentByPlayerNumber(5720, -2, 2500, "UAI_Filter_IsControlledSpirit")
	If $l_i_Spirit <> 0 Then
		If UAI_GetAgentInfoByID($l_i_Spirit, $GC_UAI_AGENT_HP) < 0.20 Then Return True
		Return False
	EndIf
	Return True
EndFunc
Func BestTarget_Anguish($a_f_AggroRange)
	Return UAI_GetPlayerInfo($GC_UAI_AGENT_ID)
EndFunc
Func CanUse_Empowerment()
	Local $l_i_Spirit = UAI_FindAgentByPlayerNumber(5721, -2, 2500, "UAI_Filter_IsControlledSpirit")
	If $l_i_Spirit <> 0 Then
		If UAI_GetAgentInfoByID($l_i_Spirit, $GC_UAI_AGENT_HP) < 0.20 Then Return True
		Return False
	EndIf
	Return True
EndFunc
Func BestTarget_Empowerment($a_f_AggroRange)
	Return UAI_GetPlayerInfo($GC_UAI_AGENT_ID)
EndFunc
Func CanUse_Recovery()
	Local $l_i_Spirit = UAI_FindAgentByPlayerNumber(5719, -2, 2500, "UAI_Filter_IsControlledSpirit")
	If $l_i_Spirit <> 0 Then
		If UAI_GetAgentInfoByID($l_i_Spirit, $GC_UAI_AGENT_HP) < 0.20 Then Return True
		Return False
	EndIf
	Return True
EndFunc
Func BestTarget_Recovery($a_f_AggroRange)
	Return UAI_GetPlayerInfo($GC_UAI_AGENT_ID)
EndFunc
Func CanUse_JackFrost()
	Return True
EndFunc
Func BestTarget_JackFrost($a_f_AggroRange)
	Return UAI_GetPlayerInfo($GC_UAI_AGENT_ID)
EndFunc
Func CanUse_Vampirism()
	Local $l_i_Spirit = UAI_FindAgentByPlayerNumber(5723, -2, 2500, "UAI_Filter_IsControlledSpirit")
	If $l_i_Spirit <> 0 Then
		If UAI_GetAgentInfoByID($l_i_Spirit, $GC_UAI_AGENT_HP) < 0.20 Then Return True
		Return False
	EndIf
	Return True
EndFunc
Func BestTarget_Vampirism($a_f_AggroRange)
	Return UAI_GetPlayerInfo($GC_UAI_AGENT_ID)
EndFunc
Func CanUse_Rejuvenation()
	Local $l_i_Spirit = UAI_FindAgentByPlayerNumber(5853, -2, 2500, "UAI_Filter_IsControlledSpirit")
	If $l_i_Spirit <> 0 Then
		If UAI_GetAgentInfoByID($l_i_Spirit, $GC_UAI_AGENT_HP) < 0.20 Then Return True
		Return False
	EndIf
	Return True
EndFunc
Func BestTarget_Rejuvenation($a_f_AggroRange)
	Return UAI_GetPlayerInfo($GC_UAI_AGENT_ID)
EndFunc
Func CanUse_Agony()
	Local $l_i_Spirit = UAI_FindAgentByPlayerNumber(5854, -2, 2500, "UAI_Filter_IsControlledSpirit")
	If $l_i_Spirit <> 0 Then
		If UAI_GetAgentInfoByID($l_i_Spirit, $GC_UAI_AGENT_HP) < 0.20 Then Return True
		Return False
	EndIf
	Return True
EndFunc
Func BestTarget_Agony($a_f_AggroRange)
	Return UAI_GetPlayerInfo($GC_UAI_AGENT_ID)
EndFunc
Func CanUse_Winds()
	Return True
EndFunc
Func BestTarget_Winds($a_f_AggroRange)
	Return UAI_GetPlayerInfo($GC_UAI_AGENT_ID)
EndFunc
Func CanUse_CallToTheSpiritRealm()
	Return True
EndFunc
Func BestTarget_CallToTheSpiritRealm($a_f_AggroRange)
	Return UAI_GetPlayerInfo($GC_UAI_AGENT_ID)
EndFunc
Func CanUse_DisenchantmentTogo()
	Return True
EndFunc
Func BestTarget_DisenchantmentTogo($a_f_AggroRange)
	Return UAI_GetPlayerInfo($GC_UAI_AGENT_ID)
EndFunc
Func CanUse_UnionPvp()
	Return True
EndFunc
Func BestTarget_UnionPvp($a_f_AggroRange)
	Return UAI_GetPlayerInfo($GC_UAI_AGENT_ID)
EndFunc
Func CanUse_ShadowsongPvp()
	Return True
EndFunc
Func BestTarget_ShadowsongPvp($a_f_AggroRange)
	Return UAI_GetPlayerInfo($GC_UAI_AGENT_ID)
EndFunc
Func CanUse_PainPvp()
	Return True
EndFunc
Func BestTarget_PainPvp($a_f_AggroRange)
	Return UAI_GetPlayerInfo($GC_UAI_AGENT_ID)
EndFunc
Func CanUse_DestructionPvp()
	Return True
EndFunc
Func BestTarget_DestructionPvp($a_f_AggroRange)
	Return UAI_GetPlayerInfo($GC_UAI_AGENT_ID)
EndFunc
Func CanUse_SoothingPvp()
	Return True
EndFunc
Func BestTarget_SoothingPvp($a_f_AggroRange)
	Return UAI_GetPlayerInfo($GC_UAI_AGENT_ID)
EndFunc
Func CanUse_DisplacementPvp()
	Return True
EndFunc
Func BestTarget_DisplacementPvp($a_f_AggroRange)
	Return UAI_GetPlayerInfo($GC_UAI_AGENT_ID)
EndFunc
Func CanUse_PreservationPvp()
	Return True
EndFunc
Func BestTarget_PreservationPvp($a_f_AggroRange)
	Return UAI_GetPlayerInfo($GC_UAI_AGENT_ID)
EndFunc
Func CanUse_LifePvp()
	Return True
EndFunc
Func BestTarget_LifePvp($a_f_AggroRange)
	Return UAI_GetPlayerInfo($GC_UAI_AGENT_ID)
EndFunc
Func CanUse_RecuperationPvp()
	Return True
EndFunc
Func BestTarget_RecuperationPvp($a_f_AggroRange)
	Return UAI_GetPlayerInfo($GC_UAI_AGENT_ID)
EndFunc
Func CanUse_DissonancePvp()
	Return True
EndFunc
Func BestTarget_DissonancePvp($a_f_AggroRange)
	Return UAI_GetPlayerInfo($GC_UAI_AGENT_ID)
EndFunc
Func CanUse_EarthbindPvp()
	Return True
EndFunc
Func BestTarget_EarthbindPvp($a_f_AggroRange)
	Return UAI_GetPlayerInfo($GC_UAI_AGENT_ID)
EndFunc
Func CanUse_ShelterPvp()
	Return True
EndFunc
Func BestTarget_ShelterPvp($a_f_AggroRange)
	Return UAI_GetPlayerInfo($GC_UAI_AGENT_ID)
EndFunc
Func CanUse_DisenchantmentPvp()
	Return True
EndFunc
Func BestTarget_DisenchantmentPvp($a_f_AggroRange)
	Return UAI_GetPlayerInfo($GC_UAI_AGENT_ID)
EndFunc
Func CanUse_RestorationPvp()
	If UAI_PlayerHasEffect($GC_I_SKILL_ID_CURSE_OF_DHUUM) Or UAI_PlayerHasEffect($GC_I_SKILL_ID_FROZEN_SOIL) Then Return False
	Return True
EndFunc
Func BestTarget_RestorationPvp($a_f_AggroRange)
	Return UAI_GetPlayerInfo($GC_UAI_AGENT_ID)
EndFunc
Func CanUse_BloodsongPvp()
	Return True
EndFunc
Func BestTarget_BloodsongPvp($a_f_AggroRange)
	Return UAI_GetPlayerInfo($GC_UAI_AGENT_ID)
EndFunc
Func CanUse_WanderlustPvp()
	Return True
EndFunc
Func BestTarget_WanderlustPvp($a_f_AggroRange)
	Return UAI_GetPlayerInfo($GC_UAI_AGENT_ID)
EndFunc
Func CanUse_GazeOfFuryPvp()
	Return True
EndFunc
Func BestTarget_GazeOfFuryPvp($a_f_AggroRange)
	Return
EndFunc
Func CanUse_AnguishPvp()
	Return True
EndFunc
Func BestTarget_AnguishPvp($a_f_AggroRange)
	Return UAI_GetPlayerInfo($GC_UAI_AGENT_ID)
EndFunc
Func CanUse_EmpowermentPvp()
	Return True
EndFunc
Func BestTarget_EmpowermentPvp($a_f_AggroRange)
	Return UAI_GetPlayerInfo($GC_UAI_AGENT_ID)
EndFunc
Func CanUse_RecoveryPvp()
	Return True
EndFunc
Func BestTarget_RecoveryPvp($a_f_AggroRange)
	Return UAI_GetPlayerInfo($GC_UAI_AGENT_ID)
EndFunc
Func CanUse_AgonyPvp()
	Return True
EndFunc
Func BestTarget_AgonyPvp($a_f_AggroRange)
	Return UAI_GetPlayerInfo($GC_UAI_AGENT_ID)
EndFunc
Func CanUse_RejuvenationPvp()
	Return True
EndFunc
Func BestTarget_RejuvenationPvp($a_f_AggroRange)
	Return UAI_GetPlayerInfo($GC_UAI_AGENT_ID)
EndFunc
Func CanUse_ShadowsongMasterRiyo()
	Return True
EndFunc
Func BestTarget_ShadowsongMasterRiyo($a_f_AggroRange)
	Return UAI_GetPlayerInfo($GC_UAI_AGENT_ID)
EndFunc