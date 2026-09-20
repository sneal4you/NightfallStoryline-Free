#include-once
Func Anti_Skill10()
	Return False
EndFunc
Func CanUse_Blackout()
	Return True
EndFunc
Func BestTarget_Blackout($a_f_AggroRange)
	Return UAI_GetNearestAgent(-2, $a_f_AggroRange, "UAI_Filter_IsLivingEnemy")
EndFunc
Func CanUse_PlagueTouch()
	Return True
EndFunc
Func BestTarget_PlagueTouch($a_f_AggroRange)
	Return UAI_GetNearestAgent(-2, $a_f_AggroRange, "UAI_Filter_IsLivingEnemy")
EndFunc
Func CanUse_VileTouch()
	Return True
EndFunc
Func BestTarget_VileTouch($a_f_AggroRange)
	Return UAI_GetNearestAgent(-2, $a_f_AggroRange, "UAI_Filter_IsLivingEnemy")
EndFunc
Func CanUse_VampiricTouch()
	If UAI_CountAgents(-2, $GC_I_RANGE_ADJACENT, "UAI_Filter_IsLivingEnemy") < 1 Then Return False
	Return True
EndFunc
Func BestTarget_VampiricTouch($a_f_AggroRange)
	Return UAI_GetAgentLowest(-2, $a_f_AggroRange, $GC_UAI_AGENT_HP, "UAI_Filter_IsLivingEnemy")
EndFunc
Func CanUse_TouchOfAgony()
	Return True
EndFunc
Func BestTarget_TouchOfAgony($a_f_AggroRange)
	Return UAI_GetNearestAgent(-2, $a_f_AggroRange, "UAI_Filter_IsLivingEnemy")
EndFunc
Func CanUse_Shock()
	Return True
EndFunc
Func BestTarget_Shock($a_f_AggroRange)
	Return UAI_GetNearestAgent(-2, $a_f_AggroRange, "UAI_Filter_IsLivingEnemy")
EndFunc
Func CanUse_LightningTouch()
	Return True
EndFunc
Func BestTarget_LightningTouch($a_f_AggroRange)
	Return UAI_GetBestAOETarget(-2, $a_f_AggroRange, $GC_I_RANGE_ADJACENT, "UAI_Filter_IsLivingEnemy")
EndFunc
Func CanUse_ContemplationOfPurity()
	Return True
EndFunc
Func BestTarget_ContemplationOfPurity($a_f_AggroRange)
	Return UAI_GetPlayerInfo($GC_UAI_AGENT_ID)
EndFunc
Func CanUse_HolyStrike()
	Return True
EndFunc
Func BestTarget_HolyStrike($a_f_AggroRange)
	Return UAI_GetNearestAgent(-2, $a_f_AggroRange, "UAI_Filter_IsLivingEnemy")
EndFunc
Func CanUse_Flourish()
	Return True
EndFunc
Func BestTarget_Flourish($a_f_AggroRange)
	Return UAI_GetPlayerInfo($GC_UAI_AGENT_ID)
EndFunc
Func CanUse_CharmAnimal()
	Return True
EndFunc
Func BestTarget_CharmAnimal($a_f_AggroRange)
	Return 0
EndFunc
Func CanUse_ReviveAnimal()
	Return True
EndFunc
Func BestTarget_ReviveAnimal($a_f_AggroRange)
	Return UAI_GetPlayerInfo($GC_UAI_AGENT_ID)
EndFunc
Func CanUse_ThrowDirt()
	Return True
EndFunc
Func BestTarget_ThrowDirt($a_f_AggroRange)
	Return UAI_GetBestAOETarget(-2, $a_f_AggroRange, $GC_I_RANGE_ADJACENT, "UAI_Filter_IsLivingEnemy")
EndFunc
Func CanUse_ComfortAnimal()
    Local $l_i_PetSize = World_GetWorldInfo("PetInfoArraySize")
    Local $lMyPet = 0
    For $i = 1 To $l_i_PetSize
        If Party_GetPetInfo($i, "OwnerAgentID") = UAI_GetPlayerInfo($GC_UAI_AGENT_ID) Then
            $lMyPet = Party_GetPetInfo($i, "AgentID")
            ExitLoop
        EndIf
    Next
    If $lMyPet = 0 Then Return False
    If Agent_GetAgentInfo($lMyPet, "HPPercent") < 0.5 Then Return True
    Return False
EndFunc
Func BestTarget_ComfortAnimal($a_f_AggroRange)
	Return UAI_GetPlayerInfo($GC_UAI_AGENT_ID)
EndFunc
Func CanUse_TrollUnguent()
	If UAI_GetPlayerInfo($GC_UAI_AGENT_HP) > 0.8 Then Return False
	Return True
EndFunc
Func BestTarget_TrollUnguent($a_f_AggroRange)
	Return UAI_GetPlayerInfo($GC_UAI_AGENT_ID)
EndFunc
Func CanUse_DeafeningRoar()
	Return True
EndFunc
Func BestTarget_DeafeningRoar($a_f_AggroRange)
	Return UAI_GetPlayerInfo($GC_UAI_AGENT_ID)
EndFunc
Func CanUse_ClaimResource1()
	Return True
EndFunc
Func BestTarget_ClaimResource1($a_f_AggroRange)
	Return UAI_GetPlayerInfo($GC_UAI_AGENT_ID)
EndFunc
Func CanUse_ClaimResource2()
	Return True
EndFunc
Func BestTarget_ClaimResource2($a_f_AggroRange)
	Return UAI_GetPlayerInfo($GC_UAI_AGENT_ID)
EndFunc
Func CanUse_ClaimResource3()
	Return True
EndFunc
Func BestTarget_ClaimResource3($a_f_AggroRange)
	Return UAI_GetPlayerInfo($GC_UAI_AGENT_ID)
EndFunc
Func CanUse_ClaimResource4()
	Return True
EndFunc
Func BestTarget_ClaimResource4($a_f_AggroRange)
	Return UAI_GetPlayerInfo($GC_UAI_AGENT_ID)
EndFunc
Func CanUse_ClaimResource5()
	Return True
EndFunc
Func BestTarget_ClaimResource5($a_f_AggroRange)
	Return UAI_GetPlayerInfo($GC_UAI_AGENT_ID)
EndFunc
Func CanUse_ClaimResource6()
	Return True
EndFunc
Func BestTarget_ClaimResource6($a_f_AggroRange)
	Return UAI_GetPlayerInfo($GC_UAI_AGENT_ID)
EndFunc
Func CanUse_ClaimResource7()
	Return True
EndFunc
Func BestTarget_ClaimResource7($a_f_AggroRange)
	Return UAI_GetPlayerInfo($GC_UAI_AGENT_ID)
EndFunc
Func CanUse_ClaimResource8()
	Return True
EndFunc
Func BestTarget_ClaimResource8($a_f_AggroRange)
	Return UAI_GetPlayerInfo($GC_UAI_AGENT_ID)
EndFunc
Func CanUse_ClaimResource9()
	Return True
EndFunc
Func BestTarget_ClaimResource9($a_f_AggroRange)
	Return UAI_GetPlayerInfo($GC_UAI_AGENT_ID)
EndFunc
Func CanUse_ClaimResource10()
	Return True
EndFunc
Func BestTarget_ClaimResource10($a_f_AggroRange)
	Return UAI_GetPlayerInfo($GC_UAI_AGENT_ID)
EndFunc
Func CanUse_CrystalHibernation()
	Return True
EndFunc
Func BestTarget_CrystalHibernation($a_f_AggroRange)
	Return UAI_GetPlayerInfo($GC_UAI_AGENT_ID)
EndFunc
Func CanUse_LifeVortex()
	Return True
EndFunc
Func BestTarget_LifeVortex($a_f_AggroRange)
	Return UAI_GetPlayerInfo($GC_UAI_AGENT_ID)
EndFunc
Func CanUse_SpectralAgony()
	Return True
EndFunc
Func BestTarget_SpectralAgony($a_f_AggroRange)
	Return UAI_GetNearestAgent(-2, $a_f_AggroRange, "UAI_Filter_IsLivingEnemy")
EndFunc
Func CanUse_ClaimResource()
	Return True
EndFunc
Func BestTarget_ClaimResource($a_f_AggroRange)
	Return UAI_GetPlayerInfo($GC_UAI_AGENT_ID)
EndFunc
Func CanUse_TeleportPlayers()
	Return True
EndFunc
Func BestTarget_TeleportPlayers($a_f_AggroRange)
	Return UAI_GetPlayerInfo($GC_UAI_AGENT_ID)
EndFunc
Func CanUse_Knock()
	Return True
EndFunc
Func BestTarget_Knock($a_f_AggroRange)
	Return UAI_GetPlayerInfo($GC_UAI_AGENT_ID)
EndFunc
Func CanUse_IronPalm()
	Return True
EndFunc
Func BestTarget_IronPalm($a_f_AggroRange)
	Local $l_i_Target = UAI_GetNearestAgent(-2, $a_f_AggroRange, "UAI_Filter_IsLivingEnemy|UAI_Filter_IsConditioned")
	If $l_i_Target <> 0 Then Return $l_i_Target
	$l_i_Target = UAI_GetNearestAgent(-2, $a_f_AggroRange, "UAI_Filter_IsLivingEnemy|UAI_Filter_IsHexed")
	If $l_i_Target <> 0 Then Return $l_i_Target
	Return UAI_GetNearestAgent(-2, $a_f_AggroRange, "UAI_Filter_IsLivingEnemy")
EndFunc
Func CanUse_ProtectorsDefense()
	Return True
EndFunc
Func BestTarget_ProtectorsDefense($a_f_AggroRange)
	Return UAI_GetPlayerInfo($GC_UAI_AGENT_ID)
EndFunc
Func CanUse_ExpungeEnchantments()
	Return True
EndFunc
Func BestTarget_ExpungeEnchantments($a_f_AggroRange)
	Return UAI_GetNearestAgent(-2, $a_f_AggroRange, "UAI_Filter_IsLivingEnemy|UAI_Filter_IsEnchanted")
EndFunc
Func CanUse_Impale()
	Return True
EndFunc
Func BestTarget_Impale($a_f_AggroRange)
	UAI_GetNearestAgent(-2, $a_f_AggroRange, "UAI_Filter_IsLivingEnemy|UAI_Filter_IsLastStrikeIsDual")
EndFunc
Func CanUse_StarStrike()
	Return True
EndFunc
Func BestTarget_StarStrike($a_f_AggroRange)
	Return UAI_GetPlayerInfo($GC_UAI_AGENT_ID)
EndFunc
Func CanUse_PalmStrike()
	Return True
EndFunc
Func BestTarget_PalmStrike($a_f_AggroRange)
	Return UAI_GetNearestAgent(-2, $a_f_AggroRange, "UAI_Filter_IsLivingEnemy")
EndFunc
Func CanUse_StarServant()
	Return True
EndFunc
Func BestTarget_StarServant($a_f_AggroRange)
	Return UAI_GetPlayerInfo($GC_UAI_AGENT_ID)
EndFunc
Func CanUse_VampiricBite()
	Return True
EndFunc
Func BestTarget_VampiricBite($a_f_AggroRange)
	Return UAI_GetNearestAgent(-2, $a_f_AggroRange, "UAI_Filter_IsLivingEnemy")
EndFunc
Func CanUse_WallowsBite()
	Return True
EndFunc
Func BestTarget_WallowsBite($a_f_AggroRange)
	Return UAI_GetNearestAgent(-2, $a_f_AggroRange, "UAI_Filter_IsLivingEnemy")
EndFunc
Func CanUse_EnfeeblingTouch()
	Return True
EndFunc
Func BestTarget_EnfeeblingTouch($a_f_AggroRange)
	Return UAI_GetNearestAgent(-2, $a_f_AggroRange, "UAI_Filter_IsLivingEnemy")
EndFunc
Func CanUse_CelestialStorm()
	Return True
EndFunc
Func BestTarget_CelestialStorm($a_f_AggroRange)
	Return UAI_GetBestAOETarget(-2, $a_f_AggroRange, $GC_I_RANGE_ADJACENT, "UAI_Filter_IsLivingEnemy")
EndFunc
Func CanUse_StarShine()
	Return True
EndFunc
Func BestTarget_StarShine($a_f_AggroRange)
	Return UAI_GetPlayerInfo($GC_UAI_AGENT_ID)
EndFunc
Func CanUse_StonesoulStrike()
	Return True
EndFunc
Func BestTarget_StonesoulStrike($a_f_AggroRange)
	Return UAI_GetNearestAgent(-2, $a_f_AggroRange, "UAI_Filter_IsLivingEnemy")
EndFunc
Func CanUse_StormOfSwords()
	Return True
EndFunc
Func BestTarget_StormOfSwords($a_f_AggroRange)
	Return UAI_GetPlayerInfo($GC_UAI_AGENT_ID)
EndFunc
Func CanUse_Shove()
	Return True
EndFunc
Func BestTarget_Shove($a_f_AggroRange)
	Return UAI_GetNearestAgent(-2, $a_f_AggroRange, "UAI_Filter_IsLivingEnemy")
EndFunc
Func CanUse_BaseDefense()
	Return True
EndFunc
Func BestTarget_BaseDefense($a_f_AggroRange)
	Return UAI_GetPlayerInfo($GC_UAI_AGENT_ID)
EndFunc
Func CanUse_CarrierDefense()
	Return True
EndFunc
Func BestTarget_CarrierDefense($a_f_AggroRange)
	Return UAI_GetPlayerInfo($GC_UAI_AGENT_ID)
EndFunc
Func CanUse_TheChaliceOfCorruption()
	Return True
EndFunc
Func BestTarget_TheChaliceOfCorruption($a_f_AggroRange)
	Return UAI_GetPlayerInfo($GC_UAI_AGENT_ID)
EndFunc
Func CanUse_JuggernautToss()
	Return True
EndFunc
Func BestTarget_JuggernautToss($a_f_AggroRange)
	Return UAI_GetNearestAgent(-2, $a_f_AggroRange, "UAI_Filter_IsLivingEnemy")
EndFunc
Func CanUse_LastStand()
	Return True
EndFunc
Func BestTarget_LastStand($a_f_AggroRange)
	Return UAI_GetPlayerInfo($GC_UAI_AGENT_ID)
EndFunc
Func CanUse_ConstructPossession()
	Return True
EndFunc
Func BestTarget_ConstructPossession($a_f_AggroRange)
	Return UAI_GetPlayerInfo($GC_UAI_AGENT_ID)
EndFunc
Func CanUse_SiegeTurtleAttackTheEternalGrove()
	Return True
EndFunc
Func BestTarget_SiegeTurtleAttackTheEternalGrove($a_f_AggroRange)
	Return UAI_GetNearestAgent(-2, $a_f_AggroRange, "UAI_Filter_IsLivingEnemy")
EndFunc
Func CanUse_SiegeTurtleAttackFortAspenwood()
	Return True
EndFunc
Func BestTarget_SiegeTurtleAttackFortAspenwood($a_f_AggroRange)
	Return UAI_GetNearestAgent(-2, $a_f_AggroRange, "UAI_Filter_IsLivingEnemy")
EndFunc
Func CanUse_SiegeTurtleAttackGyalaHatchery()
	Return True
EndFunc
Func BestTarget_SiegeTurtleAttackGyalaHatchery($a_f_AggroRange)
	Return UAI_GetPlayerInfo($GC_UAI_AGENT_ID)
EndFunc
Func CanUse_HealAsOne()
	Return True
EndFunc
Func BestTarget_HealAsOne($a_f_AggroRange)
	Return UAI_GetPlayerInfo($GC_UAI_AGENT_ID)
EndFunc
Func CanUse_CelestialStance()
	Return True
EndFunc
Func BestTarget_CelestialStance($a_f_AggroRange)
	Return UAI_GetPlayerInfo($GC_UAI_AGENT_ID)
EndFunc
Func CanUse_ArmorOfUnfeeling()
	Return True
EndFunc
Func BestTarget_ArmorOfUnfeeling($a_f_AggroRange)
	Return UAI_GetPlayerInfo($GC_UAI_AGENT_ID)
EndFunc
Func CanUse_CelestialSummoning()
	Return True
EndFunc
Func BestTarget_CelestialSummoning($a_f_AggroRange)
	Return UAI_GetPlayerInfo($GC_UAI_AGENT_ID)
EndFunc
Func CanUse_AncestorsRage()
	Return True
EndFunc
Func BestTarget_AncestorsRage($a_f_AggroRange)
	Local $l_i_BestAlly = 0
	Local $l_i_BestEnemyCount = 0
	For $i = 1 To $g_i_AgentCacheCount
		Local $l_i_AgentID = UAI_GetAgentInfo($i, $GC_UAI_AGENT_ID)
		If Not UAI_Filter_IsLivingAlly($l_i_AgentID) Then ContinueLoop
		If UAI_Filter_IsSpirit($l_i_AgentID) Then ContinueLoop
		Local $l_f_Distance = UAI_GetAgentInfo($i, $GC_UAI_AGENT_Distance)
		If $l_f_Distance > $a_f_AggroRange Then ContinueLoop
		Local $l_i_EnemyCount = UAI_CountAgents($l_i_AgentID, $GC_I_RANGE_ADJACENT, "UAI_Filter_IsLivingEnemy")
		If $l_i_EnemyCount > $l_i_BestEnemyCount Then
			$l_i_BestEnemyCount = $l_i_EnemyCount
			$l_i_BestAlly = $l_i_AgentID
		EndIf
	Next
	If $l_i_BestEnemyCount >= 1 Then Return $l_i_BestAlly
	Return 0
EndFunc
Func CanUse_ImpossibleOdds()
	Return True
EndFunc
Func BestTarget_ImpossibleOdds($a_f_AggroRange)
	Return UAI_GetPlayerInfo($GC_UAI_AGENT_ID)
EndFunc
Func CanUse_MeditationOfTheReaper1()
	Return True
EndFunc
Func BestTarget_MeditationOfTheReaper1($a_f_AggroRange)
	Return UAI_GetPlayerInfo($GC_UAI_AGENT_ID)
EndFunc
Func CanUse_ForestsBinding()
	Return True
EndFunc
Func BestTarget_ForestsBinding($a_f_AggroRange)
	Return UAI_GetNearestAgent(-2, $a_f_AggroRange, "UAI_Filter_IsLivingEnemy")
EndFunc
Func CanUse_ExplodingSpores()
	Return True
EndFunc
Func BestTarget_ExplodingSpores($a_f_AggroRange)
	Return UAI_GetPlayerInfo($GC_UAI_AGENT_ID)
EndFunc
Func CanUse_RageOfTheSea()
	Return True
EndFunc
Func BestTarget_RageOfTheSea($a_f_AggroRange)
	Return UAI_GetPlayerInfo($GC_UAI_AGENT_ID)
EndFunc
Func CanUse_MeditationOfTheReaper2()
	Return True
EndFunc
Func BestTarget_MeditationOfTheReaper2($a_f_AggroRange)
	Return UAI_GetPlayerInfo($GC_UAI_AGENT_ID)
EndFunc
Func CanUse_TormentSlash()
	Return True
EndFunc
Func BestTarget_TormentSlash($a_f_AggroRange)
	Return UAI_GetNearestAgent(-2, $a_f_AggroRange, "UAI_Filter_IsLivingEnemy")
EndFunc
Func CanUse_TradeWinds()
	Return True
EndFunc
Func BestTarget_TradeWinds($a_f_AggroRange)
	Local $l_i_Target = UAI_GetAgentLowest(-2, $a_f_AggroRange, $GC_UAI_AGENT_HP, "UAI_Filter_IsLivingAlly|UAI_Filter_ExcludeMe")
	If $l_i_Target <> 0 Then Return $l_i_Target
	Return 0
EndFunc
Func CanUse_DragonBlast()
	Return True
EndFunc
Func BestTarget_DragonBlast($a_f_AggroRange)
	Return UAI_GetNearestAgent(-2, $a_f_AggroRange, "UAI_Filter_IsLivingEnemy")
EndFunc
Func CanUse_ImperialMajesty()
	Return True
EndFunc
Func BestTarget_ImperialMajesty($a_f_AggroRange)
	Return UAI_GetNearestAgent(-2, $a_f_AggroRange, "UAI_Filter_IsLivingEnemy")
EndFunc
Func CanUse_SymbolsOfInspiration()
	Return True
EndFunc
Func BestTarget_SymbolsOfInspiration($a_f_AggroRange)
	Return UAI_GetNearestAgent(-2, $a_f_AggroRange, "UAI_Filter_IsLivingEnemy")
EndFunc
Func CanUse_SentryTrapSkill()
	Return True
EndFunc
Func BestTarget_SentryTrapSkill($a_f_AggroRange)
	Return UAI_GetPlayerInfo($GC_UAI_AGENT_ID)
EndFunc
Func CanUse_CaltropsMonster()
	Return True
EndFunc
Func BestTarget_CaltropsMonster($a_f_AggroRange)
	Return UAI_GetPlayerInfo($GC_UAI_AGENT_ID)
EndFunc
Func CanUse_SacredBranch()
	Return True
EndFunc
Func BestTarget_SacredBranch($a_f_AggroRange)
	Return UAI_GetPlayerInfo($GC_UAI_AGENT_ID)
EndFunc
Func CanUse_LightOfSeborhin()
	Return True
EndFunc
Func BestTarget_LightOfSeborhin($a_f_AggroRange)
	Return UAI_GetPlayerInfo($GC_UAI_AGENT_ID)
EndFunc
Func CanUse_Headbutt()
	Return True
EndFunc
Func BestTarget_Headbutt($a_f_AggroRange)
	Return UAI_GetNearestAgent(-2, $a_f_AggroRange, "UAI_Filter_IsLivingEnemy")
EndFunc
Func CanUse_LionsComfort()
	Return True
EndFunc
Func BestTarget_LionsComfort($a_f_AggroRange)
	Return UAI_GetPlayerInfo($GC_UAI_AGENT_ID)
EndFunc
Func CanUse_DisarmTrap()
	Return True
EndFunc
Func BestTarget_DisarmTrap($a_f_AggroRange)
	Return UAI_GetPlayerInfo($GC_UAI_AGENT_ID)
EndFunc
Func CanUse_CreateLightOfSeborhin()
	Return True
EndFunc
Func BestTarget_CreateLightOfSeborhin($a_f_AggroRange)
	Return UAI_GetPlayerInfo($GC_UAI_AGENT_ID)
EndFunc
Func CanUse_UnlockCell()
	Return True
EndFunc
Func BestTarget_UnlockCell($a_f_AggroRange)
	Return UAI_GetPlayerInfo($GC_UAI_AGENT_ID)
EndFunc
Func CanUse_JununduFeast()
	Return True
EndFunc
Func BestTarget_JununduFeast($a_f_AggroRange)
	Return UAI_GetNearestAgent(-2, $GC_I_RANGE_ADJACENT, "GC_UAI_AGENT_IsExploitableCorpse")
EndFunc
Func CanUse_JununduStrike()
	Return True
EndFunc
Func BestTarget_JununduStrike($a_f_AggroRange)
	Return UAI_GetNearestAgent(-2, $a_f_AggroRange, "UAI_Filter_IsLivingEnemy")
EndFunc
Func CanUse_JununduSmash()
	If Not UAI_IsAgentInRange(-2, $GC_I_RANGE_ADJACENT, "UAI_Filter_IsLivingEnemy") Then Return False
	Return True
EndFunc
Func BestTarget_JununduSmash($a_f_AggroRange)
	Return UAI_GetPlayerInfo($GC_UAI_AGENT_ID)
EndFunc
Func CanUse_JununduSiege1()
	Return True
EndFunc
Func BestTarget_JununduSiege1($a_f_AggroRange)
	Local $l_i_Target = UAI_GetFarthestAgent(-2, $a_f_AggroRange, "UAI_Filter_IsLivingEnemy")
	If UAI_GetAgentInfoByID($g_i_BestTarget, $GC_UAI_AGENT_Distance) > $GC_I_RANGE_NEARBY Then Return $l_i_Target
EndFunc
Func CanUse_LeaveJunundu()
	Return False
EndFunc
Func BestTarget_LeaveJunundu($a_f_AggroRange)
	Return UAI_GetPlayerInfo($GC_UAI_AGENT_ID)
EndFunc
Func CanUse_SignalFlare()
	Return True
EndFunc
Func BestTarget_SignalFlare($a_f_AggroRange)
	Return UAI_GetPlayerInfo($GC_UAI_AGENT_ID)
EndFunc
Func CanUse_TheElixirOfStrength()
	Return True
EndFunc
Func BestTarget_TheElixirOfStrength($a_f_AggroRange)
	Return UAI_GetPlayerInfo($GC_UAI_AGENT_ID)
EndFunc
Func CanUse_EhzahFromAbove()
	Return True
EndFunc
Func BestTarget_EhzahFromAbove($a_f_AggroRange)
	Return UAI_GetNearestAgent(-2, $a_f_AggroRange, "UAI_Filter_IsLivingEnemy")
EndFunc
Func CanUse_CallToTheTorment()
	Return True
EndFunc
Func BestTarget_CallToTheTorment($a_f_AggroRange)
	Return UAI_GetPlayerInfo($GC_UAI_AGENT_ID)
EndFunc
Func CanUse_CommandOfTorment()
	Return True
EndFunc
Func BestTarget_CommandOfTorment($a_f_AggroRange)
	Return UAI_GetPlayerInfo($GC_UAI_AGENT_ID)
EndFunc
Func CanUse_AbaddonsFavor()
	Return True
EndFunc
Func BestTarget_AbaddonsFavor($a_f_AggroRange)
	Return UAI_GetNearestAgent(-2, $a_f_AggroRange, "UAI_Filter_IsLivingEnemy")
EndFunc
Func CanUse_ScavengersFocus()
	Return True
EndFunc
Func BestTarget_ScavengersFocus($a_f_AggroRange)
	Return UAI_GetPlayerInfo($GC_UAI_AGENT_ID)
EndFunc
Func CanUse_Awe()
	Return True
EndFunc
Func BestTarget_Awe($a_f_AggroRange)
	Local $l_i_Target = UAI_GetNearestAgent(-2, $a_f_AggroRange, "UAI_Filter_IsLivingEnemy|UAI_Filter_IsKnocked")
	If $l_i_Target <> 0 Then Return $l_i_Target
	Return UAI_GetNearestAgent(-2, $a_f_AggroRange, "UAI_Filter_IsLivingEnemy")
EndFunc
Func CanUse_LeadersZeal()
	Return True
EndFunc
Func BestTarget_LeadersZeal($a_f_AggroRange)
	Return UAI_GetPlayerInfo($GC_UAI_AGENT_ID)
EndFunc
Func CanUse_LeadersComfort()
	Return True
EndFunc
Func BestTarget_LeadersComfort($a_f_AggroRange)
	Return UAI_GetPlayerInfo($GC_UAI_AGENT_ID)
EndFunc
Func CanUse_AngelicProtection()
	Return True
EndFunc
Func BestTarget_AngelicProtection($a_f_AggroRange)
	Local $l_i_Target = UAI_GetAgentLowest(-2, $a_f_AggroRange, $GC_UAI_AGENT_HP, "UAI_Filter_IsLivingAlly|UAI_Filter_ExcludeMe")
	If $l_i_Target <> 0 Then Return $l_i_Target
	Return 0
EndFunc
Func CanUse_AngelicBond()
	Return True
EndFunc
Func BestTarget_AngelicBond($a_f_AggroRange)
	Return UAI_GetPlayerInfo($GC_UAI_AGENT_ID)
EndFunc
Func CanUse_ScepterOfEther()
	Return True
EndFunc
Func BestTarget_ScepterOfEther($a_f_AggroRange)
	Return UAI_GetPlayerInfo($GC_UAI_AGENT_ID)
EndFunc
Func CanUse_QueenHeal()
	Return True
EndFunc
Func BestTarget_QueenHeal($a_f_AggroRange)
	Return UAI_GetPlayerInfo($GC_UAI_AGENT_ID)
EndFunc
Func CanUse_QueenBite()
	Return True
EndFunc
Func BestTarget_QueenBite($a_f_AggroRange)
	Return UAI_GetNearestAgent(-2, $a_f_AggroRange, "UAI_Filter_IsLivingEnemy")
EndFunc
Func CanUse_QueenThump()
	Return True
EndFunc
Func BestTarget_QueenThump($a_f_AggroRange)
	Return UAI_GetPlayerInfo($GC_UAI_AGENT_ID)
EndFunc
Func CanUse_QueenSiege()
	Return True
EndFunc
Func BestTarget_QueenSiege($a_f_AggroRange)
	Return UAI_GetFarthestAgent(-2, $a_f_AggroRange, "UAI_Filter_IsLivingEnemy")
EndFunc
Func CanUse_AssaultEnchantments()
	Return True
EndFunc
Func BestTarget_AssaultEnchantments($a_f_AggroRange)
	Return UAI_GetNearestAgent(-2, $a_f_AggroRange, "UAI_Filter_IsLivingEnemy|UAI_Filter_IsEnchanted|UAI_Filter_IsLastStrikeIsDual")
EndFunc
Func CanUse_WastrelsCollapse()
	Return True
EndFunc
Func BestTarget_WastrelsCollapse($a_f_AggroRange)
	Return UAI_GetNearestAgent(-2, $a_f_AggroRange, "UAI_Filter_IsLivingEnemy")
EndFunc
Func CanUse_LiftEnchantment()
	Return True
EndFunc
Func BestTarget_LiftEnchantment($a_f_AggroRange)
	Local $l_i_Target = UAI_GetNearestAgent(-2, $a_f_AggroRange, "UAI_Filter_IsLivingEnemy|UAI_Filter_IsKnocked")
	If $l_i_Target <> 0 Then Return $l_i_Target
	Return UAI_GetNearestAgent(-2, $a_f_AggroRange, "UAI_Filter_IsLivingEnemy")
EndFunc
Func CanUse_CorruptPower()
	Return True
EndFunc
Func BestTarget_CorruptPower($a_f_AggroRange)
	Return UAI_GetPlayerInfo($GC_UAI_AGENT_ID)
EndFunc
Func CanUse_GazeOfMoavukaal()
	Return True
EndFunc
Func BestTarget_GazeOfMoavukaal($a_f_AggroRange)
	Return UAI_GetNearestAgent(-2, $a_f_AggroRange, "UAI_Filter_IsLivingEnemy")
EndFunc
Func CanUse_TheApocryphaIsChangingToAnotherForm()
	Return True
EndFunc
Func BestTarget_TheApocryphaIsChangingToAnotherForm($a_f_AggroRange)
	Return UAI_GetPlayerInfo($GC_UAI_AGENT_ID)
EndFunc
Func CanUse_ReformCarvings()
	Return True
EndFunc
Func BestTarget_ReformCarvings($a_f_AggroRange)
	Return UAI_GetPlayerInfo($GC_UAI_AGENT_ID)
EndFunc
Func CanUse_SoulTorture()
	Return True
EndFunc
Func BestTarget_SoulTorture($a_f_AggroRange)
	Return UAI_GetPlayerInfo($GC_UAI_AGENT_ID)
EndFunc
Func CanUse_LightbringersGaze()
	Return True
EndFunc
Func BestTarget_LightbringersGaze($a_f_AggroRange)
	Return UAI_GetNearestAgent(-2, $a_f_AggroRange, "UAI_Filter_IsLivingEnemy")
EndFunc
Func CanUse_MaddenedStrike()
	Return True
EndFunc
Func BestTarget_MaddenedStrike($a_f_AggroRange)
	Return UAI_GetPlayerInfo($GC_UAI_AGENT_ID)
EndFunc
Func CanUse_KournanSiege()
	Return True
EndFunc
Func BestTarget_KournanSiege($a_f_AggroRange)
	Return UAI_GetPlayerInfo($GC_UAI_AGENT_ID)
EndFunc
Func CanUse_ChokingBreath()
	Return True
EndFunc
Func BestTarget_ChokingBreath($a_f_AggroRange)
	Local $l_i_CastingTarget = UAI_GetNearestAgent(-2, $a_f_AggroRange, "UAI_Filter_IsLivingEnemy|UAI_Filter_IsCasting")
	If $l_i_CastingTarget <> 0 Then Return $l_i_CastingTarget
	Local $l_i_AOETarget = UAI_GetBestAOETarget(-2, $a_f_AggroRange, $GC_I_RANGE_ADJACENT, "UAI_Filter_IsLivingEnemy")
	If $l_i_AOETarget <> 0 Then Return $l_i_AOETarget
	Return UAI_GetNearestAgent(-2, $a_f_AggroRange, "UAI_Filter_IsLivingEnemy")
EndFunc
Func CanUse_JununduBite()
	Return True
EndFunc
Func BestTarget_JununduBite($a_f_AggroRange)
	Local $l_i_KnockedTarget = UAI_GetNearestAgent(-2, $GC_I_RANGE_ADJACENT, "UAI_Filter_IsLivingEnemy|UAI_Filter_IsKnocked")
	If $l_i_KnockedTarget <> 0 Then Return $l_i_KnockedTarget
	Return UAI_GetNearestAgent(-2, $a_f_AggroRange, "UAI_Filter_IsLivingEnemy")
EndFunc
Func CanUse_BlindingBreath()
	If Not UAI_IsAgentInRange(-2, $GC_I_RANGE_ADJACENT, "UAI_Filter_IsLivingEnemy") Then Return False
	Return True
EndFunc
Func BestTarget_BlindingBreath($a_f_AggroRange)
	Return UAI_GetPlayerInfo($GC_UAI_AGENT_ID)
EndFunc
Func CanUse_BurningBreath()
	Return True
EndFunc
Func BestTarget_BurningBreath($a_f_AggroRange)
	Local $l_i_Target = UAI_GetFarthestAgent(-2, $a_f_AggroRange, "UAI_Filter_IsLivingEnemy")
	If UAI_GetAgentInfoByID($g_i_BestTarget, $GC_UAI_AGENT_Distance) > $GC_I_RANGE_NEARBY Then Return $l_i_Target
EndFunc
Func CanUse_JununduWail()
	If UAI_PlayerHasEffect($GC_I_SKILL_ID_CURSE_OF_DHUUM) Or UAI_PlayerHasEffect($GC_I_SKILL_ID_FROZEN_SOIL) Then Return False
	Return True
EndFunc
Func BestTarget_JununduWail($a_f_AggroRange)
	Local $l_i_Target = UAI_GetNearestAgent(-2, $GC_I_RANGE_EARSHOT, "UAI_Filter_IsDeadAlly")
	If $l_i_Target <> 0 Then Return $l_i_Target 
	If Not UAI_IsAgentInRange(-2, $GC_I_RANGE_EARSHOT, "UAI_Filter_IsLivingEnemy") And UAI_GetPlayerInfo($GC_UAI_AGENT_HP) <= 1.0 Then
		Return UAI_GetPlayerInfo($GC_UAI_AGENT_ID)
	EndIf
EndFunc
Func CanUse_WordsOfMadness()
	Return True
EndFunc
Func BestTarget_WordsOfMadness($a_f_AggroRange)
	Return UAI_GetNearestAgent(-2, $a_f_AggroRange, "UAI_Filter_IsLivingEnemy")
EndFunc
Func CanUse_UnknownJununduAbility()
	Return False
EndFunc
Func BestTarget_UnknownJununduAbility($a_f_AggroRange)
	Return UAI_GetPlayerInfo($GC_UAI_AGENT_ID)
EndFunc
Func CanUse_TormentSlashSmotheringTendrils()
	Return True
EndFunc
Func BestTarget_TormentSlashSmotheringTendrils($a_f_AggroRange)
	Return UAI_GetNearestAgent(-2, $a_f_AggroRange, "UAI_Filter_IsLivingEnemy")
EndFunc
Func CanUse_ConsumeTorment()
	Return True
EndFunc
Func BestTarget_ConsumeTorment($a_f_AggroRange)
	Return UAI_GetPlayerInfo($GC_UAI_AGENT_ID)
EndFunc
Func CanUse_SummoningShadows()
	Return True
EndFunc
Func BestTarget_SummoningShadows($a_f_AggroRange)
	Return UAI_GetPlayerInfo($GC_UAI_AGENT_ID)
EndFunc
Func CanUse_TouchOfAaaaarrrrrrggghhh()
	Return True
EndFunc
Func BestTarget_TouchOfAaaaarrrrrrggghhh($a_f_AggroRange)
	Return UAI_GetNearestAgent(-2, $a_f_AggroRange, "UAI_Filter_IsLivingEnemy")
EndFunc
Func CanUse_SideStep()
	Return True
EndFunc
Func BestTarget_SideStep($a_f_AggroRange)
	Return UAI_GetPlayerInfo($GC_UAI_AGENT_ID)
EndFunc
Func CanUse_CharmAnimalWhiteMantle()
	Return True
EndFunc
Func BestTarget_CharmAnimalWhiteMantle($a_f_AggroRange)
	Return UAI_GetPlayerInfo($GC_UAI_AGENT_ID)
EndFunc
Func CanUse_ClaimResourceHeroesAscent()
	Return True
EndFunc
Func BestTarget_ClaimResourceHeroesAscent($a_f_AggroRange)
	Return UAI_GetPlayerInfo($GC_UAI_AGENT_ID)
EndFunc
Func CanUse_LunarBlessing()
	Return True
EndFunc
Func BestTarget_LunarBlessing($a_f_AggroRange)
	Return UAI_GetPlayerInfo($GC_UAI_AGENT_ID)
EndFunc
Func CanUse_LuckyAura()
	Return True
EndFunc
Func BestTarget_LuckyAura($a_f_AggroRange)
	Return UAI_GetPlayerInfo($GC_UAI_AGENT_ID)
EndFunc
Func CanUse_SpiritualPossession()
	Return True
EndFunc
Func BestTarget_SpiritualPossession($a_f_AggroRange)
	Return UAI_GetPlayerInfo($GC_UAI_AGENT_ID)
EndFunc
Func CanUse_Water()
	Return True
EndFunc
Func BestTarget_Water($a_f_AggroRange)
	Return UAI_GetPlayerInfo($GC_UAI_AGENT_ID)
EndFunc
Func CanUse_ShroudOfAsh()
	Return True
EndFunc
Func BestTarget_ShroudOfAsh($a_f_AggroRange)
	Return UAI_GetPlayerInfo($GC_UAI_AGENT_ID)
EndFunc
Func CanUse_FlameCall()
	Return True
EndFunc
Func BestTarget_FlameCall($a_f_AggroRange)
	Return UAI_GetPlayerInfo($GC_UAI_AGENT_ID)
EndFunc
Func CanUse_TorturersInferno()
	Return True
EndFunc
Func BestTarget_TorturersInferno($a_f_AggroRange)
	Return UAI_GetPlayerInfo($GC_UAI_AGENT_ID)
EndFunc
Func CanUse_WhirlingFires()
	Return True
EndFunc
Func BestTarget_WhirlingFires($a_f_AggroRange)
	Return UAI_GetPlayerInfo($GC_UAI_AGENT_ID)
EndFunc
Func CanUse_CharrSiegeAttackWhatMustBeDone()
	Return True
EndFunc
Func BestTarget_CharrSiegeAttackWhatMustBeDone($a_f_AggroRange)
	Return UAI_GetNearestAgent(-2, $a_f_AggroRange, "UAI_Filter_IsLivingEnemy")
EndFunc
Func CanUse_CharrSiegeAttackAgainstTheCharr()
	Return True
EndFunc
Func BestTarget_CharrSiegeAttackAgainstTheCharr($a_f_AggroRange)
	Return UAI_GetPlayerInfo($GC_UAI_AGENT_ID)
EndFunc
Func CanUse_Grapple()
	Return True
EndFunc
Func BestTarget_Grapple($a_f_AggroRange)
	Return UAI_GetNearestAgent(-2, $a_f_AggroRange, "UAI_Filter_IsLivingEnemy")
EndFunc
Func CanUse_Berserk()
	Return True
EndFunc
Func BestTarget_Berserk($a_f_AggroRange)
	Return UAI_GetPlayerInfo($GC_UAI_AGENT_ID)
EndFunc
Func CanUse_Chomp()
	Return True
EndFunc
Func BestTarget_Chomp($a_f_AggroRange)
	Return UAI_GetNearestAgent(-2, $a_f_AggroRange, "UAI_Filter_IsLivingEnemy")
EndFunc
Func CanUse_TwistingJaws()
	Return True
EndFunc
Func BestTarget_TwistingJaws($a_f_AggroRange)
	Return UAI_GetNearestAgent(-2, $a_f_AggroRange, "UAI_Filter_IsLivingEnemy")
EndFunc
Func CanUse_Trample()
	Return True
EndFunc
Func BestTarget_Trample($a_f_AggroRange)
	Return UAI_GetBestAOETarget(-2, $a_f_AggroRange, $GC_I_RANGE_ADJACENT, "UAI_Filter_IsLivingEnemy")
EndFunc
Func CanUse_Necrosis()
	Return True
EndFunc
Func BestTarget_Necrosis($a_f_AggroRange)
	Local $l_i_Conditionned = UAI_GetBestSingleTarget(-2, $a_f_AggroRange, $GC_UAI_AGENT_HP, "UAI_Filter_IsLivingEnemy|UAI_Filter_IsConditioned")
	Local $l_i_Hexed = UAI_GetBestSingleTarget(-2, $a_f_AggroRange, $GC_UAI_AGENT_HP, "UAI_Filter_IsLivingEnemy|UAI_Filter_IsHexed")
	If $l_i_Conditionned <> 0 Then Return $l_i_Conditionned
	If $l_i_Hexed <> 0 Then Return $l_i_Hexed
	Return 0
EndFunc
Func CanUse_CallOfTheEye()
	Return True
EndFunc
Func BestTarget_CallOfTheEye($a_f_AggroRange)
	Return UAI_GetPlayerInfo($GC_UAI_AGENT_ID)
EndFunc
Func CanUse_UrsanRageBloodWashesBlood()
	Return True
EndFunc
Func BestTarget_UrsanRageBloodWashesBlood($a_f_AggroRange)
	Return UAI_GetPlayerInfo($GC_UAI_AGENT_ID)
EndFunc
Func CanUse_UrsanStrikeBloodWashesBlood()
	Return True
EndFunc
Func BestTarget_UrsanStrikeBloodWashesBlood($a_f_AggroRange)
	Return UAI_GetNearestAgent(-2, $a_f_AggroRange, "UAI_Filter_IsLivingEnemy")
EndFunc
Func CanUse_Firebomb()
	Return True
EndFunc
Func BestTarget_Firebomb($a_f_AggroRange)
	Return UAI_GetNearestAgent(-2, $a_f_AggroRange, "UAI_Filter_IsLivingEnemy")
EndFunc
Func CanUse_ShieldOfFire()
	Return True
EndFunc
Func BestTarget_ShieldOfFire($a_f_AggroRange)
	Return UAI_GetPlayerInfo($GC_UAI_AGENT_ID)
EndFunc
Func CanUse_VolfenClawCurseOfTheNornbear()
	Return True
EndFunc
Func BestTarget_VolfenClawCurseOfTheNornbear($a_f_AggroRange)
	Return UAI_GetNearestAgent(-2, $a_f_AggroRange, "UAI_Filter_IsLivingEnemy")
EndFunc
Func CanUse_VolfenBlessingCurseOfTheNornbear()
	Return True
EndFunc
Func BestTarget_VolfenBlessingCurseOfTheNornbear($a_f_AggroRange)
	Return UAI_GetPlayerInfo($GC_UAI_AGENT_ID)
EndFunc
Func CanUse_Companionship()
	Return True
EndFunc
Func BestTarget_Companionship($a_f_AggroRange)
	Return UAI_GetPlayerInfo($GC_UAI_AGENT_ID)
EndFunc
Func CanUse_FeralAggression()
	Return True
EndFunc
Func BestTarget_FeralAggression($a_f_AggroRange)
	Return UAI_GetPlayerInfo($GC_UAI_AGENT_ID)
EndFunc
Func CanUse_APoolOfWater()
	Return True
EndFunc
Func BestTarget_APoolOfWater($a_f_AggroRange)
	Return UAI_GetPlayerInfo($GC_UAI_AGENT_ID)
EndFunc
Func CanUse_PhaseShieldEffect()
	Return True
EndFunc
Func BestTarget_PhaseShieldEffect($a_f_AggroRange)
	Return UAI_GetPlayerInfo($GC_UAI_AGENT_ID)
EndFunc
Func BestTarget_PhaseShieldMonsterSkill($a_f_AggroRange)
	Return UAI_GetPlayerInfo($GC_UAI_AGENT_ID)
EndFunc
Func CanUse_VitalityTransfer()
	Return True
EndFunc
Func BestTarget_VitalityTransfer($a_f_AggroRange)
	Local $l_i_Target = UAI_GetAgentLowest(-2, $a_f_AggroRange, $GC_UAI_AGENT_HP, "UAI_Filter_IsLivingAlly")
	If $l_i_Target <> 0 Then Return $l_i_Target
	Return 0
EndFunc
Func CanUse_EnergyBlastGolem()
	Return True
EndFunc
Func BestTarget_EnergyBlastGolem($a_f_AggroRange)
	Return UAI_GetNearestAgent(-2, $a_f_AggroRange, "UAI_Filter_IsLivingEnemy")
EndFunc
Func CanUse_ChaoticEnergy()
	Return True
EndFunc
Func BestTarget_ChaoticEnergy($a_f_AggroRange)
	Return UAI_GetPlayerInfo($GC_UAI_AGENT_ID)
EndFunc
Func CanUse_RavenBlessingAGateTooFar()
	Return True
EndFunc
Func BestTarget_RavenBlessingAGateTooFar($a_f_AggroRange)
	Return UAI_GetPlayerInfo($GC_UAI_AGENT_ID)
EndFunc
Func CanUse_RavenTalonsAGateTooFar()
	Return True
EndFunc
Func BestTarget_RavenTalonsAGateTooFar($a_f_AggroRange)
	Return UAI_GetNearestAgent(-2, $a_f_AggroRange, "UAI_Filter_IsLivingEnemy")
EndFunc
Func CanUse_AspectOfOak()
	Return True
EndFunc
Func BestTarget_AspectOfOak($a_f_AggroRange)
	Return UAI_GetPlayerInfo($GC_UAI_AGENT_ID)
EndFunc
Func CanUse_SunderingSoulcrush()
	Return True
EndFunc
Func BestTarget_SunderingSoulcrush($a_f_AggroRange)
	Return UAI_GetNearestAgent(-2, $a_f_AggroRange, "UAI_Filter_IsLivingEnemy")
EndFunc
Func CanUse_PyroclasticShot()
	Return True
EndFunc
Func BestTarget_PyroclasticShot($a_f_AggroRange)
	Return UAI_GetBestAOETarget(-2, $a_f_AggroRange, $GC_I_RANGE_ADJACENT, "UAI_Filter_IsLivingEnemy")
EndFunc
Func CanUse_ExplosiveForce()
	Return True
EndFunc
Func BestTarget_ExplosiveForce($a_f_AggroRange)
	Return UAI_GetPlayerInfo($GC_UAI_AGENT_ID)
EndFunc
Func CanUse_PowderKegExplosion()
	Return True
EndFunc
Func BestTarget_PowderKegExplosion($a_f_AggroRange)
	Return UAI_GetPlayerInfo($GC_UAI_AGENT_ID)
EndFunc
Func CanUse_SpiritleechAura()
	Return True
EndFunc
Func BestTarget_SpiritleechAura($a_f_AggroRange)
	Return UAI_GetPlayerInfo($GC_UAI_AGENT_ID)
EndFunc
Func CanUse_InspirationalSpeech()
	Return True
EndFunc
Func BestTarget_InspirationalSpeech($a_f_AggroRange)
	Local $l_i_Target = UAI_GetAgentLowest(-2, $a_f_AggroRange, $GC_UAI_AGENT_HP, "UAI_Filter_IsLivingAlly|UAI_Filter_ExcludeMe")
	If $l_i_Target <> 0 Then Return $l_i_Target
	Return 0
EndFunc
Func CanUse_EarBite()
	Return True
EndFunc
Func BestTarget_EarBite($a_f_AggroRange)
	Return UAI_GetNearestAgent(-2, $a_f_AggroRange, "UAI_Filter_IsLivingEnemy")
EndFunc
Func CanUse_LowBlow()
	Return True
EndFunc
Func BestTarget_LowBlow($a_f_AggroRange)
	Local $l_i_Target = UAI_GetNearestAgent(-2, $a_f_AggroRange, "UAI_Filter_IsLivingEnemy|UAI_Filter_IsKnocked")
	If $l_i_Target <> 0 Then Return $l_i_Target
	Return UAI_GetNearestAgent(-2, $a_f_AggroRange, "UAI_Filter_IsLivingEnemy")
EndFunc
Func CanUse_BrawlingHeadbutt()
	Return True
EndFunc
Func BestTarget_BrawlingHeadbutt($a_f_AggroRange)
	Return UAI_GetNearestAgent(-2, $a_f_AggroRange, "UAI_Filter_IsLivingEnemy")
EndFunc
Func CanUse_GelatinousCorpseConsumption()
	Return True
EndFunc
Func BestTarget_GelatinousCorpseConsumption($a_f_AggroRange)
	Return UAI_GetPlayerInfo($GC_UAI_AGENT_ID)
EndFunc
Func CanUse_GelatinousMutation()
	Return True
EndFunc
Func BestTarget_GelatinousMutation($a_f_AggroRange)
	Return UAI_GetPlayerInfo($GC_UAI_AGENT_ID)
EndFunc
Func CanUse_GelatinousAbsorption()
	Return True
EndFunc
Func BestTarget_GelatinousAbsorption($a_f_AggroRange)
	Return UAI_GetPlayerInfo($GC_UAI_AGENT_ID)
EndFunc
Func CanUse_UnstableOozeExplosion()
	Return True
EndFunc
Func BestTarget_UnstableOozeExplosion($a_f_AggroRange)
	Return UAI_GetPlayerInfo($GC_UAI_AGENT_ID)
EndFunc
Func CanUse_UnstableAura()
	Return True
EndFunc
Func BestTarget_UnstableAura($a_f_AggroRange)
	Return UAI_GetPlayerInfo($GC_UAI_AGENT_ID)
EndFunc
Func CanUse_UnstablePulse()
	Return True
EndFunc
Func BestTarget_UnstablePulse($a_f_AggroRange)
	Return UAI_GetPlayerInfo($GC_UAI_AGENT_ID)
EndFunc
Func CanUse_SearingBreath()
	Return True
EndFunc
Func BestTarget_SearingBreath($a_f_AggroRange)
	Return UAI_GetPlayerInfo($GC_UAI_AGENT_ID)
EndFunc
Func CanUse_Brawling()
	Return True
EndFunc
Func BestTarget_Brawling($a_f_AggroRange)
	Return UAI_GetPlayerInfo($GC_UAI_AGENT_ID)
EndFunc
Func CanUse_CallOfDestruction()
	Return True
EndFunc
Func BestTarget_CallOfDestruction($a_f_AggroRange)
	Return UAI_GetPlayerInfo($GC_UAI_AGENT_ID)
EndFunc
Func CanUse_FlameJet()
	Return True
EndFunc
Func BestTarget_FlameJet($a_f_AggroRange)
	Return UAI_GetNearestAgent(-2, $a_f_AggroRange, "UAI_Filter_IsLivingEnemy")
EndFunc
Func CanUse_LavaGround()
	Return True
EndFunc
Func BestTarget_LavaGround($a_f_AggroRange)
	Return UAI_GetPlayerInfo($GC_UAI_AGENT_ID)
EndFunc
Func CanUse_LavaWave()
	Return True
EndFunc
Func BestTarget_LavaWave($a_f_AggroRange)
	Return UAI_GetPlayerInfo($GC_UAI_AGENT_ID)
EndFunc
Func CanUse_SpiritShield()
	Return True
EndFunc
Func BestTarget_SpiritShield($a_f_AggroRange)
	Return UAI_GetPlayerInfo($GC_UAI_AGENT_ID)
EndFunc
Func CanUse_SummoningLord()
	Return True
EndFunc
Func BestTarget_SummoningLord($a_f_AggroRange)
	Return UAI_GetPlayerInfo($GC_UAI_AGENT_ID)
EndFunc
Func CanUse_CharmAnimalAshlynSpiderfriend()
	Return True
EndFunc
Func BestTarget_CharmAnimalAshlynSpiderfriend($a_f_AggroRange)
	Return UAI_GetPlayerInfo($GC_UAI_AGENT_ID)
EndFunc
Func CanUse_CharrSiegeAttackAssaultOnTheStronghold()
	Return True
EndFunc
Func BestTarget_CharrSiegeAttackAssaultOnTheStronghold($a_f_AggroRange)
	Return UAI_GetPlayerInfo($GC_UAI_AGENT_ID)
EndFunc
Func CanUse_TalonStrike()
	Return True
EndFunc
Func BestTarget_TalonStrike($a_f_AggroRange)
	Return UAI_GetNearestAgent(-2, $a_f_AggroRange, "UAI_Filter_IsLivingEnemy")
EndFunc
Func CanUse_LavaBlast()
	Return True
EndFunc
Func BestTarget_LavaBlast($a_f_AggroRange)
	Return UAI_GetPlayerInfo($GC_UAI_AGENT_ID)
EndFunc
Func CanUse_AlkarsConcoction()
	Return True
EndFunc
Func BestTarget_AlkarsConcoction($a_f_AggroRange)
	Return UAI_GetPlayerInfo($GC_UAI_AGENT_ID)
EndFunc
Func CanUse_UrsanStrike()
	Return True
EndFunc
Func BestTarget_UrsanStrike($a_f_AggroRange)
	Return UAI_GetNearestAgent(-2, $a_f_AggroRange, "UAI_Filter_IsLivingEnemy")
EndFunc
Func CanUse_UrsanRage()
	Return True
EndFunc
Func BestTarget_UrsanRage($a_f_AggroRange)
	Return UAI_GetBestAOETarget(-2, $a_f_AggroRange, $GC_I_RANGE_ADJACENT, "UAI_Filter_IsLivingEnemy")
EndFunc
Func CanUse_VolfenClaw()
	Return True
EndFunc
Func BestTarget_VolfenClaw($a_f_AggroRange)
	Return UAI_GetNearestAgent(-2, $a_f_AggroRange, "UAI_Filter_IsLivingEnemy")
EndFunc
Func CanUse_RavenTalons()
	Return True
EndFunc
Func BestTarget_RavenTalons($a_f_AggroRange)
	Return UAI_GetNearestAgent(-2, $a_f_AggroRange, "UAI_Filter_IsLivingEnemy")
EndFunc
Func CanUse_TotemOfMan()
	Return True
EndFunc
Func BestTarget_TotemOfMan($a_f_AggroRange)
	Return UAI_GetPlayerInfo($GC_UAI_AGENT_ID)
EndFunc
Func CanUse_SpawnPods()
	Return True
EndFunc
Func BestTarget_SpawnPods($a_f_AggroRange)
	Return UAI_GetPlayerInfo($GC_UAI_AGENT_ID)
EndFunc
Func CanUse_EnragedBlast()
	Return True
EndFunc
Func BestTarget_EnragedBlast($a_f_AggroRange)
	Return UAI_GetPlayerInfo($GC_UAI_AGENT_ID)
EndFunc
Func CanUse_SpawnHatchling()
	Return True
EndFunc
Func BestTarget_SpawnHatchling($a_f_AggroRange)
	Return UAI_GetPlayerInfo($GC_UAI_AGENT_ID)
EndFunc
Func CanUse_UrsanAura()
	Return True
EndFunc
Func BestTarget_UrsanAura($a_f_AggroRange)
	Return UAI_GetPlayerInfo($GC_UAI_AGENT_ID)
EndFunc
Func CanUse_ExtractInscription()
	Return True
EndFunc
Func BestTarget_ExtractInscription($a_f_AggroRange)
	Return UAI_GetPlayerInfo($GC_UAI_AGENT_ID)
EndFunc
Func CanUse_AirOfSuperiority()
	If UAI_GetPlayerEffectInfo($GC_I_SKILL_ID_AIR_OF_SUPERIORITY, $GC_UAI_EFFECT_TimeRemaining) > 5000 Then Return False
	Return True
EndFunc
Func BestTarget_AirOfSuperiority($a_f_AggroRange)
	Return UAI_GetPlayerInfo($GC_UAI_AGENT_ID)
EndFunc
Func CanUse_DecipherInscriptions()
	Return True
EndFunc
Func BestTarget_DecipherInscriptions($a_f_AggroRange)
	Return UAI_GetPlayerInfo($GC_UAI_AGENT_ID)
EndFunc
Func CanUse_AsuranFlameStaff()
	Return True
EndFunc
Func BestTarget_AsuranFlameStaff($a_f_AggroRange)
	Return UAI_GetPlayerInfo($GC_UAI_AGENT_ID)
EndFunc
Func CanUse_HauntedGround()
	Return True
EndFunc
Func BestTarget_HauntedGround($a_f_AggroRange)
	Return UAI_GetPlayerInfo($GC_UAI_AGENT_ID)
EndFunc
Func CanUse_Gloat()
	Return True
EndFunc
Func BestTarget_Gloat($a_f_AggroRange)
	Return UAI_GetPlayerInfo($GC_UAI_AGENT_ID)
EndFunc
Func CanUse_Metamorphosis()
	Return True
EndFunc
Func BestTarget_Metamorphosis($a_f_AggroRange)
	Return UAI_GetPlayerInfo($GC_UAI_AGENT_ID)
EndFunc
Func CanUse_InnerFire()
	Return True
EndFunc
Func BestTarget_InnerFire($a_f_AggroRange)
	Return UAI_GetPlayerInfo($GC_UAI_AGENT_ID)
EndFunc
Func CanUse_FungalExplosion()
	Return True
EndFunc
Func BestTarget_FungalExplosion($a_f_AggroRange)
	Return UAI_GetPlayerInfo($GC_UAI_AGENT_ID)
EndFunc
Func CanUse_BloodRage()
	Return True
EndFunc
Func BestTarget_BloodRage($a_f_AggroRange)
	Return UAI_GetPlayerInfo($GC_UAI_AGENT_ID)
EndFunc
Func CanUse_OozeCombination()
	Return True
EndFunc
Func BestTarget_OozeCombination($a_f_AggroRange)
	Return UAI_GetNearestAgent(-2, $a_f_AggroRange, "UAI_Filter_IsLivingEnemy")
EndFunc
Func CanUse_OozeDivision()
	Return True
EndFunc
Func BestTarget_OozeDivision($a_f_AggroRange)
	Return UAI_GetPlayerInfo($GC_UAI_AGENT_ID)
EndFunc
Func CanUse_SporeExplosion()
	Return True
EndFunc
Func BestTarget_SporeExplosion($a_f_AggroRange)
	Return UAI_GetPlayerInfo($GC_UAI_AGENT_ID)
EndFunc
Func CanUse_DormantHusk()
	Return True
EndFunc
Func BestTarget_DormantHusk($a_f_AggroRange)
	Return UAI_GetPlayerInfo($GC_UAI_AGENT_ID)
EndFunc
Func CanUse_MonkeySeeMonkeyDo()
	Return True
EndFunc
Func BestTarget_MonkeySeeMonkeyDo($a_f_AggroRange)
	Return UAI_GetPlayerInfo($GC_UAI_AGENT_ID)
EndFunc
Func CanUse_FeedingFrenzy()
	Return True
EndFunc
Func BestTarget_FeedingFrenzy($a_f_AggroRange)
	Return UAI_GetPlayerInfo($GC_UAI_AGENT_ID)
EndFunc
Func CanUse_SoulrendingShriek()
	Return True
EndFunc
Func BestTarget_SoulrendingShriek($a_f_AggroRange)
	Local $l_i_Target = UAI_GetNearestAgent(-2, $a_f_AggroRange, "UAI_Filter_IsLivingEnemy|UAI_Filter_IsEnchanted")
	If $l_i_Target <> 0 Then Return $l_i_Target
	Return UAI_GetNearestAgent(-2, $a_f_AggroRange, "UAI_Filter_IsLivingEnemy")
EndFunc
Func CanUse_SiegeDevourerFeast()
	Return True
EndFunc
Func BestTarget_SiegeDevourerFeast($a_f_AggroRange)
	Return UAI_GetPlayerInfo($GC_UAI_AGENT_ID)
EndFunc
Func CanUse_DevourerBite()
	Return True
EndFunc
Func BestTarget_DevourerBite($a_f_AggroRange)
	Return UAI_GetNearestAgent(-2, $a_f_AggroRange, "UAI_Filter_IsLivingEnemy")
EndFunc
Func CanUse_SiegeDevourerSwipe()
	Return True
EndFunc
Func BestTarget_SiegeDevourerSwipe($a_f_AggroRange)
	Return UAI_GetPlayerInfo($GC_UAI_AGENT_ID)
EndFunc
Func CanUse_DevourerSiege()
	Return True
EndFunc
Func BestTarget_DevourerSiege($a_f_AggroRange)
	Return UAI_GetFarthestAgent(-2, $a_f_AggroRange, "UAI_Filter_IsLivingEnemy")
EndFunc
Func CanUse_DismountSiegeDevourer()
	Return True
EndFunc
Func BestTarget_DismountSiegeDevourer($a_f_AggroRange)
	Return UAI_GetPlayerInfo($GC_UAI_AGENT_ID)
EndFunc
Func CanUse_Mount()
	Return True
EndFunc
Func BestTarget_Mount($a_f_AggroRange)
	Return UAI_GetPlayerInfo($GC_UAI_AGENT_ID)
EndFunc
Func CanUse_TengusGaze()
	Return True
EndFunc
Func BestTarget_TengusGaze($a_f_AggroRange)
	Return UAI_GetPlayerInfo($GC_UAI_AGENT_ID)
EndFunc
Func CanUse_ForgewightsBlessing()
	Return True
EndFunc
Func BestTarget_ForgewightsBlessing($a_f_AggroRange)
	Return UAI_GetPlayerInfo($GC_UAI_AGENT_ID)
EndFunc
Func CanUse_SelvetarmsBlessing()
	Return True
EndFunc
Func BestTarget_SelvetarmsBlessing($a_f_AggroRange)
	Return UAI_GetPlayerInfo($GC_UAI_AGENT_ID)
EndFunc
Func CanUse_ThommissBlessing()
	Return True
EndFunc
Func BestTarget_ThommissBlessing($a_f_AggroRange)
	Return UAI_GetPlayerInfo($GC_UAI_AGENT_ID)
EndFunc
Func CanUse_RandsAttack()
	Return True
EndFunc
Func BestTarget_RandsAttack($a_f_AggroRange)
	Return UAI_GetPlayerInfo($GC_UAI_AGENT_ID)
EndFunc
Func CanUse_LitTorch()
	Return True
EndFunc
Func BestTarget_LitTorch($a_f_AggroRange)
	Return UAI_GetPlayerInfo($GC_UAI_AGENT_ID)
EndFunc
Func CanUse_CharmAnimalCharrDemolisher()
	Return True
EndFunc
Func BestTarget_CharmAnimalCharrDemolisher($a_f_AggroRange)
	Return UAI_GetPlayerInfo($GC_UAI_AGENT_ID)
EndFunc
Func CanUse_ThrowRock()
	Return True
EndFunc
Func BestTarget_ThrowRock($a_f_AggroRange)
	Return UAI_GetNearestAgent(-2, $a_f_AggroRange, "UAI_Filter_IsLivingEnemy")
EndFunc
Func CanUse_NightmarishAura()
	Return True
EndFunc
Func BestTarget_NightmarishAura($a_f_AggroRange)
	Return UAI_GetPlayerInfo($GC_UAI_AGENT_ID)
EndFunc
Func CanUse_SiegeStrike()
	Return True
EndFunc
Func BestTarget_SiegeStrike($a_f_AggroRange)
	Return UAI_GetNearestAgent(-2, $a_f_AggroRange, "UAI_Filter_IsLivingEnemy")
EndFunc
Func CanUse_BarbedBomb()
	Return True
EndFunc
Func BestTarget_BarbedBomb($a_f_AggroRange)
	Return UAI_GetPlayerInfo($GC_UAI_AGENT_ID)
EndFunc
Func CanUse_BalmBomb()
	Return True
EndFunc
Func BestTarget_BalmBomb($a_f_AggroRange)
	Return UAI_GetPlayerInfo($GC_UAI_AGENT_ID)
EndFunc
Func CanUse_Explosives()
	Return True
EndFunc
Func BestTarget_Explosives($a_f_AggroRange)
	Return UAI_GetPlayerInfo($GC_UAI_AGENT_ID)
EndFunc
Func CanUse_Rations()
	Return True
EndFunc
Func BestTarget_Rations($a_f_AggroRange)
	Return UAI_GetPlayerInfo($GC_UAI_AGENT_ID)
EndFunc
Func CanUse_StunBomb()
	Return True
EndFunc
Func BestTarget_StunBomb($a_f_AggroRange)
	Return UAI_GetPlayerInfo($GC_UAI_AGENT_ID)
EndFunc
Func CanUse_GiantStompTuraiOssa()
	Return True
EndFunc
Func BestTarget_GiantStompTuraiOssa($a_f_AggroRange)
	Return UAI_GetPlayerInfo($GC_UAI_AGENT_ID)
EndFunc
Func CanUse_JununduSiege2()
	Return True
EndFunc
Func BestTarget_JununduSiege2($a_f_AggroRange)
	Local $l_i_Target = UAI_GetFarthestAgent(-2, $a_f_AggroRange, "UAI_Filter_IsLivingEnemy")
	If UAI_GetAgentInfoByID($g_i_BestTarget, $GC_UAI_AGENT_Distance) > $GC_I_RANGE_NEARBY Then Return $l_i_Target
EndFunc
Func CanUse_FireDart2()
	Return True
EndFunc
Func BestTarget_FireDart2($a_f_AggroRange)
	Return UAI_GetPlayerInfo($GC_UAI_AGENT_ID)
EndFunc
Func CanUse_AncestorsRagePvP()
	Return True
EndFunc
Func BestTarget_AncestorsRagePvP($a_f_AggroRange)
	Return UAI_GetNearestAgent(-2, $a_f_AggroRange, "UAI_Filter_IsLivingEnemy")
EndFunc
Func BestTarget_BamphLite($a_f_AggroRange)
	Return UAI_GetNearestAgent(-2, $a_f_AggroRange, "UAI_Filter_IsLivingEnemy")
EndFunc
Func CanUse_ReactorBlastTimer()
	Return True
EndFunc
Func BestTarget_ReactorBlastTimer($a_f_AggroRange)
	Return UAI_GetPlayerInfo($GC_UAI_AGENT_ID)
EndFunc
Func CanUse_InternalPowerEngaged()
	Return True
EndFunc
Func BestTarget_InternalPowerEngaged($a_f_AggroRange)
	Return UAI_GetPlayerInfo($GC_UAI_AGENT_ID)
EndFunc
Func CanUse_Countdown()
	Return True
EndFunc
Func BestTarget_Countdown($a_f_AggroRange)
	Return UAI_GetPlayerInfo($GC_UAI_AGENT_ID)
EndFunc
Func CanUse_NoxLockOn()
	Return True
EndFunc
Func BestTarget_NoxLockOn($a_f_AggroRange)
	Return UAI_GetNearestAgent(-2, $a_f_AggroRange, "UAI_Filter_IsLivingEnemy")
EndFunc
Func BestTarget_BamphLifesteal($a_f_AggroRange)
	Return UAI_GetNearestAgent(-2, $a_f_AggroRange, "UAI_Filter_IsLivingEnemy")
EndFunc
Func CanUse_DelayedBlastBamph()
	Return True
EndFunc
Func BestTarget_DelayedBlastBamph($a_f_AggroRange)
	Return UAI_GetNearestAgent(-2, $a_f_AggroRange, "UAI_Filter_IsLivingEnemy")
EndFunc
Func CanUse_GunthersGaze()
	Return True
EndFunc
Func BestTarget_GunthersGaze($a_f_AggroRange)
	Return UAI_GetPlayerInfo($GC_UAI_AGENT_ID)
EndFunc
Func CanUse_ComfortAnimalPvP()
	Return True
EndFunc
Func BestTarget_ComfortAnimalPvP($a_f_AggroRange)
	Return UAI_GetPlayerInfo($GC_UAI_AGENT_ID)
EndFunc
Func CanUse_CharmAnimal2()
	Return True
EndFunc
Func BestTarget_CharmAnimal2($a_f_AggroRange)
	Return UAI_GetPlayerInfo($GC_UAI_AGENT_ID)
EndFunc
Func CanUse_CharmAnimal3()
	Return True
EndFunc
Func BestTarget_CharmAnimal3($a_f_AggroRange)
	Return UAI_GetPlayerInfo($GC_UAI_AGENT_ID)
EndFunc
Func CanUse_CharmAnimalCodex()
	Return True
EndFunc
Func BestTarget_CharmAnimalCodex($a_f_AggroRange)
	Return UAI_GetNearestAgent(-2, $a_f_AggroRange, "UAI_Filter_IsLivingEnemy")
EndFunc
Func CanUse_TouchOfDhuum()
	Return True
EndFunc
Func BestTarget_TouchOfDhuum($a_f_AggroRange)
	Return UAI_GetNearestAgent(-2, $a_f_AggroRange, "UAI_Filter_IsLivingEnemy")
EndFunc
Func CanUse_HealAsOnePvP()
	Return True
EndFunc
Func BestTarget_HealAsOnePvP($a_f_AggroRange)
	Return UAI_GetPlayerInfo($GC_UAI_AGENT_ID)
EndFunc
Func CanUse_CharmDrake()
	Return True
EndFunc
Func BestTarget_CharmDrake($a_f_AggroRange)
	Return UAI_GetPlayerInfo($GC_UAI_AGENT_ID)
EndFunc
Func CanUse_GuildMonumentProtected()
	Return True
EndFunc
Func BestTarget_GuildMonumentProtected($a_f_AggroRange)
	Return UAI_GetPlayerInfo($GC_UAI_AGENT_ID)
EndFunc
Func CanUse_SacrificePawn()
	Return True
EndFunc
Func BestTarget_SacrificePawn($a_f_AggroRange)
	Local $l_i_Target = UAI_GetAgentLowest(-2, $a_f_AggroRange, $GC_UAI_AGENT_HP, "UAI_Filter_IsLivingAlly|UAI_Filter_ExcludeMe")
	If $l_i_Target <> 0 Then Return $l_i_Target
	Return 0
EndFunc
Func CanUse_Entourage()
	Return True
EndFunc
Func BestTarget_Entourage($a_f_AggroRange)
	Return UAI_GetPlayerInfo($GC_UAI_AGENT_ID)
EndFunc
Func CanUse_EntourageBuffer()
	Return True
EndFunc
Func BestTarget_EntourageBuffer($a_f_AggroRange)
	Return UAI_GetPlayerInfo($GC_UAI_AGENT_ID)
EndFunc
Func CanUse_DamageAssessment()
	Return True
EndFunc
Func BestTarget_DamageAssessment($a_f_AggroRange)
	Return UAI_GetNearestAgent(-2, $a_f_AggroRange, "UAI_Filter_IsLivingEnemy")
EndFunc
Func CanUse_SmashOfTheTitans()
	Return True
EndFunc
Func BestTarget_SmashOfTheTitans($a_f_AggroRange)
	Return UAI_GetBestAOETarget(-2, $a_f_AggroRange, $GC_I_RANGE_ADJACENT, "UAI_Filter_IsLivingEnemy")
EndFunc
Func CanUse_AnnihilatorToss()
	Return True
EndFunc
Func BestTarget_AnnihilatorToss($a_f_AggroRange)
	Return UAI_GetNearestAgent(-2, $a_f_AggroRange, "UAI_Filter_IsLivingEnemy")
EndFunc
Func CanUse_TonicTipsiness()
	Return True
EndFunc
Func BestTarget_TonicTipsiness($a_f_AggroRange)
	Return UAI_GetPlayerInfo($GC_UAI_AGENT_ID)
EndFunc
Func CanUse_GiftOfBattle()
	Return True
EndFunc
Func BestTarget_GiftOfBattle($a_f_AggroRange)
	Return UAI_GetPlayerInfo($GC_UAI_AGENT_ID)
EndFunc
Func CanUse_ShadowTheft()
	Return True
EndFunc
Func BestTarget_ShadowTheft($a_f_AggroRange)
	Return UAI_GetNearestAgent(-2, $a_f_AggroRange, "UAI_Filter_IsLivingEnemy")
EndFunc