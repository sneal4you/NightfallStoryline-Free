#include-once
Func _D($msg)
	If $g_b_UAI_Debug Then _D(" " & $msg)
EndFunc
#Region === Skill Functions ===
Func Skill_GetSlotByID($a_i_SkillID, $a_i_HeroNumber = 0)
	For $i = 1 To 8
		Local $l_i_SlotSkillID = Skill_GetSkillbarInfo($i, "SkillID", $a_i_HeroNumber)
		If $l_i_SlotSkillID = $a_i_SkillID Then Return $i
	Next
	Return 0
EndFunc
Func Skill_CheckSlotByID($a_i_SkillID, $a_i_HeroNumber = 0)
	For $i = 1 To 8
		Local $l_i_SlotSkillID = Skill_GetSkillbarInfo($i, "SkillID", $a_i_HeroNumber)
		If $l_i_SlotSkillID = $a_i_SkillID Then Return True
	Next
	Return False
EndFunc
#EndRegion === Skill Functions ===
#Region === Party Functions ===
Func UAI_CountEnemyInPartyAggroRange($a_f_AggroRange = 1320)
    Local $l_i_Enemy = UAI_GetNearestAgent(-2, $a_f_AggroRange, "UAI_Filter_IsLivingEnemy")
    If $l_i_Enemy <> 0 Then Return $l_i_Enemy
    Local $l_i_HeroCount = Party_GetMyPartyInfo("ArrayHeroPartyMemberSize")
    For $i = 1 To $l_i_HeroCount
        Local $l_f_FlagX = Party_GetHeroFlagInfo($i, "FlagX")
        Local $l_f_FlagY = Party_GetHeroFlagInfo($i, "FlagY")
        If $l_f_FlagX <> 0 Or $l_f_FlagY <> 0 Then ContinueLoop
        Local $l_i_HeroAgentID = Party_GetMyPartyHeroInfo($i, "AgentID")
        If $l_i_HeroAgentID = 0 Then ContinueLoop
        $l_i_Enemy = UAI_CountAgents($l_i_HeroAgentID, $a_f_AggroRange, "UAI_Filter_IsLivingEnemy")
        If $l_i_Enemy <> 0 Then Return $l_i_Enemy
    Next
    Return 0
EndFunc
Func UAI_IsEnemyInPartyAggroRange($a_f_AggroRange = 1320)
    Local $l_b_InRange = UAI_IsAgentInRange(-2, $a_f_AggroRange, "UAI_Filter_IsLivingEnemy")
    If $l_b_InRange Then Return True
    Local $l_i_HeroCount = Party_GetMyPartyInfo("ArrayHeroPartyMemberSize")
    For $i = 1 To $l_i_HeroCount
        Local $l_f_FlagX = Party_GetHeroFlagInfo($i, "FlagX")
        Local $l_f_FlagY = Party_GetHeroFlagInfo($i, "FlagY")
        If $l_f_FlagX <> 0 Or $l_f_FlagY <> 0 Then ContinueLoop
        Local $l_i_HeroAgentID = Party_GetMyPartyHeroInfo($i, "AgentID")
        If $l_i_HeroAgentID = 0 Then ContinueLoop
        $l_b_InRange = UAI_IsAgentInRange($l_i_HeroAgentID, $a_f_AggroRange, "UAI_Filter_IsLivingEnemy")
        If $l_b_InRange Then Return True
    Next
    Return False
EndFunc
Func UAI_GetNearestEnemyInPartyRange($a_f_AggroRange = 1320)
    Local $l_i_Enemy = UAI_GetNearestAgent(-2, $a_f_AggroRange, "UAI_Filter_IsLivingEnemy")
    If $l_i_Enemy <> 0 Then Return $l_i_Enemy
    Local $l_i_HeroCount = Party_GetMyPartyInfo("ArrayHeroPartyMemberSize")
    Local $l_i_BestEnemy = 0
    Local $l_f_BestDistance = 999999
    For $i = 1 To $l_i_HeroCount
        Local $l_f_FlagX = Party_GetHeroFlagInfo($i, "FlagX")
        Local $l_f_FlagY = Party_GetHeroFlagInfo($i, "FlagY")
        If $l_f_FlagX <> 0 Or $l_f_FlagY <> 0 Then ContinueLoop
        Local $l_i_HeroAgentID = Party_GetMyPartyHeroInfo($i, "AgentID")
        If $l_i_HeroAgentID = 0 Then ContinueLoop
        Local $l_f_HeroX = UAI_GetAgentInfoByID($l_i_HeroAgentID, $GC_UAI_AGENT_X)
        Local $l_f_HeroY = UAI_GetAgentInfoByID($l_i_HeroAgentID, $GC_UAI_AGENT_Y)
        Local $l_f_RangeSquared = $a_f_AggroRange * $a_f_AggroRange
        For $j = 1 To $g_i_AgentCacheCount
            Local $l_i_AgentID = UAI_GetAgentInfo($j, $GC_UAI_AGENT_ID)
            If Not UAI_Filter_IsLivingEnemy($l_i_AgentID) Then ContinueLoop
            Local $l_f_EnemyX = UAI_GetAgentInfo($j, $GC_UAI_AGENT_X)
            Local $l_f_EnemyY = UAI_GetAgentInfo($j, $GC_UAI_AGENT_Y)
            Local $l_f_DX = $l_f_EnemyX - $l_f_HeroX
            Local $l_f_DY = $l_f_EnemyY - $l_f_HeroY
            Local $l_f_DistToHeroSquared = $l_f_DX * $l_f_DX + $l_f_DY * $l_f_DY
            If $l_f_DistToHeroSquared > $l_f_RangeSquared Then ContinueLoop
            Local $l_f_DistToPlayer = UAI_GetAgentInfo($j, $GC_UAI_AGENT_Distance)
            If $l_f_DistToPlayer < $l_f_BestDistance Then
                $l_f_BestDistance = $l_f_DistToPlayer
                $l_i_BestEnemy = $l_i_AgentID
            EndIf
        Next
    Next
    Return $l_i_BestEnemy
EndFunc
Func UAI_GetPartyCalledTarget()
	Local $l_i_PlayerCount = Party_GetMyPartyInfo("ArrayPlayerPartyMemberSize")
	Local $l_i_MyLoginNumber = Agent_GetAgentInfo(-2, "LoginNumber")
	For $i = 1 To $l_i_PlayerCount
		If Party_GetMyPartyPlayerMemberInfo($i, "LoginNumber") = $l_i_MyLoginNumber Then ContinueLoop
		Local $l_i_CalledTarget = Party_GetMyPartyPlayerMemberInfo($i, "CalledTargetID")
		If $l_i_CalledTarget <> 0 Then Return $l_i_CalledTarget
	Next
	Return 0
EndFunc
Func Party_GetSize()
	Return Party_GetPartyContextInfo("TotalPartySize")
EndFunc
Func Party_GetHeroCount()
	Return Party_GetPartyContextInfo("HeroCount")
EndFunc
Func Party_GetHeroAgentID($a_i_HeroNumber)
	If $a_i_HeroNumber = 0 Then Return UAI_GetPlayerInfo($GC_UAI_AGENT_ID)
	Return Party_GetMyPartyHeroInfo($a_i_HeroNumber, "AgentID")
EndFunc
Func Party_GetHeroID($a_i_HeroNumber)
	If $a_i_HeroNumber = 0 Then Return UAI_GetPlayerInfo($GC_UAI_AGENT_ID)
	Return Party_GetMyPartyHeroInfo($a_i_HeroNumber, "HeroID")
EndFunc
Func Party_GetMembersArray()
	Local $l_i_HeroCount = Party_GetHeroCount()
	Local $l_i_HenchCount = Party_GetPartyContextInfo("HenchmenCount")
	Local $l_ai_ReturnArray[2 + $l_i_HeroCount + $l_i_HenchCount]
	Local $l_i_Count = 0
	Local $l_i_PlayerID = Agent_GetMyID()
	If $l_i_PlayerID <= 0 Then $l_i_PlayerID = UAI_GetPlayerInfo($GC_UAI_AGENT_ID)
	If $l_i_PlayerID > 0 Then
		$l_i_Count += 1
		$l_ai_ReturnArray[$l_i_Count] = $l_i_PlayerID
	EndIf
	For $i = 1 To $l_i_HeroCount
		Local $l_i_HeroAgentID = Party_GetMyPartyHeroInfo($i, "AgentID")
		If $l_i_HeroAgentID <= 0 Then ContinueLoop
		$l_i_Count += 1
		$l_ai_ReturnArray[$l_i_Count] = $l_i_HeroAgentID
	Next
	For $i = 1 To $l_i_HenchCount
		Local $l_i_HenchAgentID = Party_GetMyPartyHenchmanInfo($i, "AgentID")
		If $l_i_HenchAgentID <= 0 Then ContinueLoop
		$l_i_Count += 1
		$l_ai_ReturnArray[$l_i_Count] = $l_i_HenchAgentID
	Next
	$l_ai_ReturnArray[0] = $l_i_Count
	Return $l_ai_ReturnArray
EndFunc
Func Party_GetAverageHealth()
	Local $l_f_TotalHP = 0
	Local $l_i_AliveCount = 0
	Local $l_ai_PartyArray = Party_GetMembersArray()
	For $i = 1 To $l_ai_PartyArray[0]
		Local $l_i_AgentID = $l_ai_PartyArray[$i]
		If $l_i_AgentID <= 0 Then ContinueLoop
		If UAI_GetIndexByID($l_i_AgentID) = 0 Then ContinueLoop
		If UAI_GetAgentInfoByID($l_i_AgentID, $GC_UAI_AGENT_IsDead) Then ContinueLoop
		Local $l_f_HP = UAI_GetAgentInfoByID($l_i_AgentID, $GC_UAI_AGENT_HP)
		If $l_f_HP < 0 Then $l_f_HP = 0
		If $l_f_HP > 1 Then $l_f_HP = 1
		$l_f_TotalHP += $l_f_HP
		$l_i_AliveCount += 1
	Next
	If $l_i_AliveCount = 0 Then Return SetError(1, 0, 0)
	Return Round($l_f_TotalHP / $l_i_AliveCount, 3)
EndFunc
Func Party_IsWiped()
	If Not Agent_GetAgentInfo(-2, "IsDead") Then Return False
	Local $l_i_DeadHeroes = 0
	For $i = 1 To Party_GetHeroCount()
		Local $l_i_HeroAgentID = Party_GetMyPartyHeroInfo($i, "AgentID")
		If $l_i_HeroAgentID <= 0 Then ContinueLoop
		If Agent_GetAgentInfo($l_i_HeroAgentID, "IsDead") Then
			$l_i_DeadHeroes += 1
		EndIf
	Next
	Local $l_i_AvailableRezz = Party_GetAvailableRezz()
	Local $l_ai_PartyArray = Party_GetMembersArray()
	Local $l_i_DeadThreshold = $l_ai_PartyArray[0] - 1 
	If $l_i_DeadThreshold < 0 Then $l_i_DeadThreshold = 0
	Local $l_f_AvgHP = Party_GetAverageHealth()
	Local $l_b_HasAvgHP = (@error = 0)
	Local $l_b_LowAvgHP = ($l_b_HasAvgHP And $l_f_AvgHP < 0.15)
	If $l_i_AvailableRezz = 0 Or $l_i_DeadHeroes >= $l_i_DeadThreshold Or $l_b_LowAvgHP Then
		Return True
	EndIf
	Return False
EndFunc
Func Party_GetAvailableRezz()
	Local $l_i_HeroRezzSkills = 0
	Local $l_i_HeroCount = Party_GetHeroCount()
	For $aHeroNumber = 1 To $l_i_HeroCount
		Local $l_i_HeroAgentID = Party_GetMyPartyHeroInfo($aHeroNumber, "AgentID")
		If $l_i_HeroAgentID <= 0 Then ContinueLoop
		If Agent_GetAgentInfo($l_i_HeroAgentID, "IsDead") Then ContinueLoop
		For $aSkillSlot = 1 To 8
			Local $l_i_SkillID = Skill_GetSkillbarInfo($aSkillSlot, "SkillID", $aHeroNumber)
			If $l_i_SkillID = 0 Then ContinueLoop
			If Skill_HasSpecialFlag($l_i_SkillID, $GC_I_SKILL_SPECIAL_FLAG_RESURRECTION) Then
				$l_i_HeroRezzSkills += 1
			EndIf
		Next
	Next
	Return $l_i_HeroRezzSkills
EndFunc   
#EndRegion === Party Functions ===
#Region === Agent Estimation Functions ===
Func UAI_GetAgentProfession($a_i_AgentID)
	Local $l_i_LoginNumber = UAI_GetAgentInfoByID($a_i_AgentID, $GC_UAI_AGENT_LoginNumber)
	If $l_i_LoginNumber <> 0 Then
		Return UAI_GetAgentInfoByID($a_i_AgentID, $GC_UAI_AGENT_Primary)
	EndIf
	Local $l_i_NpcIndex = UAI_GetAgentInfoByID($a_i_AgentID, $GC_UAI_AGENT_PlayerNumber)
	Local $l_i_TransmogID = UAI_GetAgentInfoByID($a_i_AgentID, $GC_UAI_AGENT_TransmogNpcId)
	If BitAND($l_i_TransmogID, 0x20000000) <> 0 Then
		$l_i_NpcIndex = BitXOR($l_i_TransmogID, 0x20000000)
	EndIf
	If $l_i_NpcIndex = 0 Then Return 0
	Local $l_p_NpcArray = World_GetWorldInfo("NpcArray")
	Local $l_i_NpcArraySize = World_GetWorldInfo("NpcArraySize")
	If $l_i_NpcIndex >= $l_i_NpcArraySize Then Return 0
	Local $l_p_NpcPtr = $l_p_NpcArray + ($l_i_NpcIndex * 0x30)
	Local $l_i_NpcPrimary = Memory_Read($l_p_NpcPtr + 0x14, "dword")
	Return $l_i_NpcPrimary
EndFunc
Func UAI_GetArmorBonus($a_i_Profession)
	Switch $a_i_Profession
		Case 1, 9  
			Return 20
		Case 2, 7, 10  
			Return 10
		Case Else  
			Return 0
	EndSwitch
EndFunc
Func UAI_GetEstimatedMaxHP($a_i_AgentID)
	Local $l_i_Level = UAI_GetAgentInfoByID($a_i_AgentID, $GC_UAI_AGENT_Level)
	If $l_i_Level = 0 Then $l_i_Level = 20  
	Local $l_i_BaseHP = $l_i_Level * 20 + 80
	If Party_GetPartyContextInfo("IsHardMode") And $l_i_Level > 20 Then
		$l_i_BaseHP += ($l_i_Level - 20) * 20
	EndIf
	Return $l_i_BaseHP
EndFunc
Func UAI_GetEstimatedCurrentHP($a_i_AgentID)
	Local $l_f_HPPercent = UAI_GetAgentInfoByID($a_i_AgentID, $GC_UAI_AGENT_HP)
	Return Round($l_f_HPPercent * UAI_GetEstimatedMaxHP($a_i_AgentID))
EndFunc
Func UAI_GetBaseArmor($a_i_AgentID)
	Local $l_i_Level = UAI_GetAgentInfoByID($a_i_AgentID, $GC_UAI_AGENT_Level)
	Local $l_i_Primary = UAI_GetAgentProfession($a_i_AgentID)
	If $l_i_Level = 0 Then $l_i_Level = 20  
	Return $l_i_Level * 3 + UAI_GetArmorBonus($l_i_Primary)
EndFunc
Func UAI_GetPhysicalArmor($a_i_AgentID)
	Local $l_i_BaseArmor = UAI_GetBaseArmor($a_i_AgentID)
	Local $l_i_Primary = UAI_GetAgentProfession($a_i_AgentID)
	If $l_i_Primary = 1 Then  
		Return $l_i_BaseArmor + 20
	EndIf
	Return $l_i_BaseArmor
EndFunc
Func UAI_GetElementalArmor($a_i_AgentID)
	Local $l_i_BaseArmor = UAI_GetBaseArmor($a_i_AgentID)
	Local $l_i_Primary = UAI_GetAgentProfession($a_i_AgentID)
	If $l_i_Primary = 2 Then  
		Return $l_i_BaseArmor + 30
	EndIf
	Return $l_i_BaseArmor
EndFunc
Func UAI_GetDamageMultiplier($a_i_Armor)
	If $a_i_Armor < 0 Then $a_i_Armor = 0
	Return 2 ^ ((60 - $a_i_Armor) / 40)
EndFunc
Func UAI_GetEffectiveArmor($a_i_BaseArmor, $a_f_Penetration = 0)
	If $a_f_Penetration <= 0 Then Return $a_i_BaseArmor
	If $a_f_Penetration > 1 Then $a_f_Penetration = 1  
	Return Round($a_i_BaseArmor * (1 - $a_f_Penetration))
EndFunc
Func UAI_EstimateDamage($a_i_BaseDamage, $a_i_AgentID, $a_s_DamageType = "physical", $a_f_Penetration = 0)
	If $a_s_DamageType = "armor-ignoring" Then Return $a_i_BaseDamage
	Local $l_i_Armor
	Switch $a_s_DamageType
		Case "physical"
			$l_i_Armor = UAI_GetPhysicalArmor($a_i_AgentID)
		Case "elemental", "fire", "cold", "lightning", "earth"
			$l_i_Armor = UAI_GetElementalArmor($a_i_AgentID)
		Case Else
			$l_i_Armor = UAI_GetBaseArmor($a_i_AgentID)
	EndSwitch
	Local $l_i_EffectiveArmor = UAI_GetEffectiveArmor($l_i_Armor, $a_f_Penetration)
	Local $l_f_Multiplier = UAI_GetDamageMultiplier($l_i_EffectiveArmor)
	Return Round($a_i_BaseDamage * $l_f_Multiplier)
EndFunc
Func UAI_IsCaster($a_i_AgentID)
	Local $l_i_Primary = UAI_GetAgentProfession($a_i_AgentID)
	Switch $l_i_Primary
		Case 3, 4, 5, 6, 8  
			Return True
		Case Else
			Return False
	EndSwitch
EndFunc
Func UAI_IsMelee($a_i_AgentID)
	Local $l_i_Primary = UAI_GetAgentProfession($a_i_AgentID)
	Switch $l_i_Primary
		Case 1, 7, 10  
			Return True
		Case Else
			Return False
	EndSwitch
EndFunc
Func UAI_IsRanged($a_i_AgentID)
	Local $l_i_Primary = UAI_GetAgentProfession($a_i_AgentID)
	Switch $l_i_Primary
		Case 2, 9  
			Return True
		Case Else
			Return False
	EndSwitch
EndFunc
#EndRegion === Agent Estimation Functions ===