#include-once
#Region Set and Mods
Func UAI_DetermineWeaponSets()
	_D(" ========== STARTING WEAPON SET ANALYSIS ==========")
	_D(" Reading weapon sets directly from memory (no switching required)")
	$g_ai_High_Hp_Set[0] = 0
	$g_ai_High_Hp_Set[1] = 0
	$g_ai_High_Energy_Set[0] = 0
	$g_ai_High_Energy_Set[1] = 0
	$g_ai_Best_Offensive_Set[0] = 0
	$g_ai_Best_Offensive_Set[1] = 0
	$g_ai_Best_Defensive_Set[0] = 0
	$g_ai_Best_Defensive_Set[1] = 0
	$g_ai_Best_Casting_Set[0] = 0
	$g_ai_Best_Casting_Set[1] = 0
	$g_ai_Best_Enchant_Set[0] = 0
	$g_ai_Best_Enchant_Set[1] = 0
	$g_ai_Best_Ranged_Set[0] = 0
	$g_ai_Best_Ranged_Set[1] = 0
	$g_ai_Best_Vampiric_Set[0] = 0
	$g_ai_Best_Vampiric_Set[1] = 0
	$g_ai_Best_Zealous_Set[0] = 0
	$g_ai_Best_Zealous_Set[1] = 0
	For $l_i_Set = 0 To 3
		Local $l_i_SetNum = $l_i_Set + 1
		_D(" --- Analyzing Weapon Set " & $l_i_SetNum & " ---")
		UAI_SaveWeaponSetFromMemory($l_i_SetNum)
	Next
	_D(" ========== ANALYSIS COMPLETE ==========")
	_D(" Best Sets Summary:")
	_D("   HP: Set #" & $g_ai_High_Hp_Set[1] & " (+" & $g_ai_High_Hp_Set[0] & " HP)")
	_D("   Energy: Set #" & $g_ai_High_Energy_Set[1] & " (+" & $g_ai_High_Energy_Set[0] & " Energy)")
	_D("   Offensive: Set #" & $g_ai_Best_Offensive_Set[1] & " (Score: " & $g_ai_Best_Offensive_Set[0] & ")")
	_D("   Defensive: Set #" & $g_ai_Best_Defensive_Set[1] & " (Score: " & $g_ai_Best_Defensive_Set[0] & ")")
	_D("   Casting: Set #" & $g_ai_Best_Casting_Set[1] & " (Score: " & $g_ai_Best_Casting_Set[0] & ")")
	If $g_b_UAI_Debug Then
		If $g_ai_Best_Enchant_Set[1] > 0 Then _D("  Enchanting: Set #" & $g_ai_Best_Enchant_Set[1])
		If $g_ai_Best_Ranged_Set[1] > 0 Then _D("  Ranged: Set #" & $g_ai_Best_Ranged_Set[1])
		If $g_ai_Best_Vampiric_Set[1] > 0 Then _D("  Vampiric: Set #" & $g_ai_Best_Vampiric_Set[1])
		If $g_ai_Best_Zealous_Set[1] > 0 Then _D("  Zealous: Set #" & $g_ai_Best_Zealous_Set[1])
	EndIf
	_D(" ========================================")
EndFunc
Func UAI_SaveWeaponSetFromMemory($a_i_Set)
	If $a_i_Set < 1 Or $a_i_Set > 4 Then Return
	Local $l_i_Index = $a_i_Set - 1
	Local $l_i_SetIndex = $a_i_Set - 1 
	Local $l_p_WeaponPtr = Item_GetInventoryInfo("WeaponSet" & $l_i_SetIndex & "WeaponPtr")
	Local $l_p_OffhandPtr = Item_GetInventoryInfo("WeaponSet" & $l_i_SetIndex & "OffhandPtr")
	Local $l_i_WeaponId = 0
	Local $l_i_OffhandId = 0
	Local $l_i_WeaponType = 0
	Local $l_i_OffhandType = 0
	If $l_p_WeaponPtr <> 0 Then
		$l_i_WeaponId = Item_GetItemInfoByPtr($l_p_WeaponPtr, "ItemID")
		$l_i_WeaponType = Item_GetItemInfoByPtr($l_p_WeaponPtr, "ItemType")
	EndIf
	If $l_p_OffhandPtr <> 0 Then
		$l_i_OffhandId = Item_GetItemInfoByPtr($l_p_OffhandPtr, "ItemID")
		$l_i_OffhandType = Item_GetItemInfoByPtr($l_p_OffhandPtr, "ItemType")
	EndIf
	$g_a2D_WeaponSets[$l_i_Index][$GC_UAI_WEAPONSET_WeaponType] = $l_i_WeaponType
	$g_a2D_WeaponSets[$l_i_Index][$GC_UAI_WEAPONSET_WeaponId] = $l_i_WeaponId
	$g_a2D_WeaponSets[$l_i_Index][$GC_UAI_WEAPONSET_OffhandType] = $l_i_OffhandType
	$g_a2D_WeaponSets[$l_i_Index][$GC_UAI_WEAPONSET_OffhandId] = $l_i_OffhandId
	$g_a2D_WeaponSets[$l_i_Index][$GC_UAI_WEAPONSET_MaxHP] = 0
	$g_a2D_WeaponSets[$l_i_Index][$GC_UAI_WEAPONSET_MaxEnergy] = 0
	$g_a2D_WeaponSets[$l_i_Index][$GC_UAI_WEAPONSET_OffensiveScore] = 0
	$g_a2D_WeaponSets[$l_i_Index][$GC_UAI_WEAPONSET_DefensiveScore] = 0
	$g_a2D_WeaponSets[$l_i_Index][$GC_UAI_WEAPONSET_CastingScore] = 0
	$g_a2D_WeaponSets[$l_i_Index][$GC_UAI_WEAPONSET_EnchantScore] = 0
	$g_a2D_WeaponSets[$l_i_Index][$GC_UAI_WEAPONSET_IsRanged] = UAI_IsRangedWeapon($l_i_WeaponType) ? 1 : 0
	$g_a2D_WeaponSets[$l_i_Index][$GC_UAI_WEAPONSET_HasShield] = ($l_i_OffhandType = $GC_I_TYPE_SHIELD) ? 1 : 0
	$g_a2D_WeaponSets[$l_i_Index][$GC_UAI_WEAPONSET_HasVampiric] = 0
	$g_a2D_WeaponSets[$l_i_Index][$GC_UAI_WEAPONSET_HasZealous] = 0
	_D(" Saving Set " & $a_i_Set & " (from memory):")
	_D("   WeaponPtr: " & $l_p_WeaponPtr & " | OffhandPtr: " & $l_p_OffhandPtr)
	_D("   WeaponType: " & $l_i_WeaponType & " (" & UAI_GetWeaponTypeName($l_i_WeaponType) & ")")
	_D("   WeaponId: " & $l_i_WeaponId)
	_D("   OffhandType: " & $l_i_OffhandType & " (" & UAI_GetOffhandTypeName($l_i_OffhandType) & ")")
	_D("   OffhandId: " & $l_i_OffhandId)
	Local $l_b_TwoHanded = UAI_IsTwoHandedWeapon($l_i_WeaponType)
	If $l_i_WeaponId > 0 Then
		_D(" Analyzing Main Weapon mods..." & ($l_b_TwoHanded ? " (Two-Handed)" : ""))
		UAI_FindAndSaveModFromMemory($l_i_WeaponId, $l_i_WeaponType, $a_i_Set, 1)
	Else
		_D("   => No main weapon equipped")
	EndIf
	If $l_b_TwoHanded Then
		_D("   => Skipping offhand (two-handed weapon equipped)")
	ElseIf $l_i_OffhandId > 0 Then
		_D(" Analyzing Offhand mods...")
		UAI_FindAndSaveModFromMemory($l_i_OffhandId, $l_i_OffhandType, $a_i_Set, 2)
	Else
		_D("   => No offhand equipped")
	EndIf
	Local $l_i_SetHP = $g_a2D_WeaponSets[$l_i_Index][$GC_UAI_WEAPONSET_MaxHP]
	Local $l_i_SetEnergy = $g_a2D_WeaponSets[$l_i_Index][$GC_UAI_WEAPONSET_MaxEnergy]
	Local $l_i_OffScore = $g_a2D_WeaponSets[$l_i_Index][$GC_UAI_WEAPONSET_OffensiveScore]
	Local $l_i_DefScore = $g_a2D_WeaponSets[$l_i_Index][$GC_UAI_WEAPONSET_DefensiveScore]
	Local $l_i_CastScore = $g_a2D_WeaponSets[$l_i_Index][$GC_UAI_WEAPONSET_CastingScore]
	Local $l_i_EnchScore = $g_a2D_WeaponSets[$l_i_Index][$GC_UAI_WEAPONSET_EnchantScore]
	_D("   => Set Scores: HP+" & $l_i_SetHP & " | Energy+" & $l_i_SetEnergy & " | Off:" & $l_i_OffScore & " | Def:" & $l_i_DefScore & " | Cast:" & $l_i_CastScore & " | Ench:" & $l_i_EnchScore)
	If $l_i_SetHP > $g_ai_High_Hp_Set[0] Then
		$g_ai_High_Hp_Set[0] = $l_i_SetHP
		$g_ai_High_Hp_Set[1] = $a_i_Set
	EndIf
	If $l_i_SetEnergy > $g_ai_High_Energy_Set[0] Then
		$g_ai_High_Energy_Set[0] = $l_i_SetEnergy
		$g_ai_High_Energy_Set[1] = $a_i_Set
	EndIf
	If $l_i_OffScore > $g_ai_Best_Offensive_Set[0] Then
		$g_ai_Best_Offensive_Set[0] = $l_i_OffScore
		$g_ai_Best_Offensive_Set[1] = $a_i_Set
	EndIf
	Local $l_i_TotalDef = $l_i_SetHP + $l_i_DefScore + ($g_a2D_WeaponSets[$l_i_Index][$GC_UAI_WEAPONSET_HasShield] * 20)
	If $l_i_TotalDef > $g_ai_Best_Defensive_Set[0] Then
		$g_ai_Best_Defensive_Set[0] = $l_i_TotalDef
		$g_ai_Best_Defensive_Set[1] = $a_i_Set
	EndIf
	If $l_i_CastScore > $g_ai_Best_Casting_Set[0] Then
		$g_ai_Best_Casting_Set[0] = $l_i_CastScore
		$g_ai_Best_Casting_Set[1] = $a_i_Set
	EndIf
	If $l_i_EnchScore > $g_ai_Best_Enchant_Set[0] Then
		$g_ai_Best_Enchant_Set[0] = $l_i_EnchScore
		$g_ai_Best_Enchant_Set[1] = $a_i_Set
	EndIf
	If $g_a2D_WeaponSets[$l_i_Index][$GC_UAI_WEAPONSET_IsRanged] = 1 And $g_ai_Best_Ranged_Set[0] = 0 Then
		$g_ai_Best_Ranged_Set[0] = 1
		$g_ai_Best_Ranged_Set[1] = $a_i_Set
	EndIf
	If $g_a2D_WeaponSets[$l_i_Index][$GC_UAI_WEAPONSET_HasVampiric] = 1 And $g_ai_Best_Vampiric_Set[0] = 0 Then
		$g_ai_Best_Vampiric_Set[0] = 1
		$g_ai_Best_Vampiric_Set[1] = $a_i_Set
	EndIf
	If $g_a2D_WeaponSets[$l_i_Index][$GC_UAI_WEAPONSET_HasZealous] = 1 And $g_ai_Best_Zealous_Set[0] = 0 Then
		$g_ai_Best_Zealous_Set[0] = 1
		$g_ai_Best_Zealous_Set[1] = $a_i_Set
	EndIf
EndFunc
Func UAI_FindAndSaveModFromMemory($a_i_ItemId, $a_i_ItemType, $a_i_Set, $a_i_Weapon)
	Local $l_i_Finding = 0
	Local $l_s_ModStruct = Item_GetModStruct($a_i_ItemId)
	Local $l_s_NewModStruct = ""
	Local $l_s_WeaponSlot = ($a_i_Weapon = 1) ? "Main Hand" : "Offhand"
	_D("   Item ID: " & $a_i_ItemId & " (" & $l_s_WeaponSlot & ")")
	_D("   Raw ModStruct: " & $l_s_ModStruct)
	If $a_i_Weapon = 1 Then
		_D("   Weapon Type: " & $a_i_ItemType & " (" & UAI_GetWeaponTypeName($a_i_ItemType) & ")")
		Switch $a_i_ItemType
			Case $GC_I_TYPE_BOW 
				UAI_SearchModsInArray($g_as2_BowUpgrade, $l_s_ModStruct, $l_s_NewModStruct, $l_i_Finding, $a_i_Set, $a_i_Weapon)
				UAI_SearchModsInArray($g_as2_MartialWeaponsInscription, $l_s_ModStruct, $l_s_NewModStruct, $l_i_Finding, $a_i_Set, $a_i_Weapon)
			Case $GC_I_TYPE_AXE 
				UAI_SearchModsInArray($g_as2_AxeUpgrade, $l_s_ModStruct, $l_s_NewModStruct, $l_i_Finding, $a_i_Set, $a_i_Weapon)
				UAI_SearchModsInArray($g_as2_MartialWeaponsInscription, $l_s_ModStruct, $l_s_NewModStruct, $l_i_Finding, $a_i_Set, $a_i_Weapon)
			Case $GC_I_TYPE_HAMMER 
				UAI_SearchModsInArray($g_as2_HammerUpgrade, $l_s_ModStruct, $l_s_NewModStruct, $l_i_Finding, $a_i_Set, $a_i_Weapon)
				UAI_SearchModsInArray($g_as2_MartialWeaponsInscription, $l_s_ModStruct, $l_s_NewModStruct, $l_i_Finding, $a_i_Set, $a_i_Weapon)
			Case $GC_I_TYPE_DAGGERS 
				UAI_SearchModsInArray($g_as2_DaggerUpgrade, $l_s_ModStruct, $l_s_NewModStruct, $l_i_Finding, $a_i_Set, $a_i_Weapon)
				UAI_SearchModsInArray($g_as2_MartialWeaponsInscription, $l_s_ModStruct, $l_s_NewModStruct, $l_i_Finding, $a_i_Set, $a_i_Weapon)
			Case $GC_I_TYPE_SCYTHE 
				UAI_SearchModsInArray($g_as2_ScytheUpgrade, $l_s_ModStruct, $l_s_NewModStruct, $l_i_Finding, $a_i_Set, $a_i_Weapon)
				UAI_SearchModsInArray($g_as2_MartialWeaponsInscription, $l_s_ModStruct, $l_s_NewModStruct, $l_i_Finding, $a_i_Set, $a_i_Weapon)
			Case $GC_I_TYPE_SPEAR 
				UAI_SearchModsInArray($g_as2_SpearUpgrade, $l_s_ModStruct, $l_s_NewModStruct, $l_i_Finding, $a_i_Set, $a_i_Weapon)
				UAI_SearchModsInArray($g_as2_MartialWeaponsInscription, $l_s_ModStruct, $l_s_NewModStruct, $l_i_Finding, $a_i_Set, $a_i_Weapon)
			Case $GC_I_TYPE_SWORD 
				UAI_SearchModsInArray($g_as2_SwordUpgrade, $l_s_ModStruct, $l_s_NewModStruct, $l_i_Finding, $a_i_Set, $a_i_Weapon)
				UAI_SearchModsInArray($g_as2_MartialWeaponsInscription, $l_s_ModStruct, $l_s_NewModStruct, $l_i_Finding, $a_i_Set, $a_i_Weapon)
			Case $GC_I_TYPE_WAND, $GC_I_TYPE_STAFF 
				UAI_SearchModsInArray($g_as2_StaffWandUpgrade, $l_s_ModStruct, $l_s_NewModStruct, $l_i_Finding, $a_i_Set, $a_i_Weapon)
				UAI_SearchModsInArray($g_as2_SpellCastingWeaponsInscription, $l_s_ModStruct, $l_s_NewModStruct, $l_i_Finding, $a_i_Set, $a_i_Weapon)
		EndSwitch
	ElseIf $a_i_Weapon = 2 Then
		_D("   Offhand Type: " & $a_i_ItemType & " (" & UAI_GetOffhandTypeName($a_i_ItemType) & ")")
		Switch $a_i_ItemType
			Case $GC_I_TYPE_OFFHAND 
				UAI_SearchModsInArray($g_as2_FocusUpgrade, $l_s_ModStruct, $l_s_NewModStruct, $l_i_Finding, $a_i_Set, $a_i_Weapon)
				UAI_SearchModsInArray($g_as2_FocusShieldWeaponsInscription, $l_s_ModStruct, $l_s_NewModStruct, $l_i_Finding, $a_i_Set, $a_i_Weapon)
			Case $GC_I_TYPE_SHIELD 
				UAI_SearchModsInArray($g_as2_ShieldUpgrade, $l_s_ModStruct, $l_s_NewModStruct, $l_i_Finding, $a_i_Set, $a_i_Weapon)
				UAI_SearchModsInArray($g_as2_FocusShieldWeaponsInscription, $l_s_ModStruct, $l_s_NewModStruct, $l_i_Finding, $a_i_Set, $a_i_Weapon)
			Case 0 
				_D("   => Empty offhand slot")
		EndSwitch
	EndIf
	If $l_i_Finding = 0 Then
		_D("   => No mods found")
	Else
		_D("   => Total mods found: " & $l_i_Finding)
	EndIf
EndFunc
Func UAI_FindWeaponSetByType($a_i_Type)
	_D(" Searching for weapon type " & $a_i_Type & "...")
	Local $l_i_CurrentType = UAI_GetPlayerInfo($GC_UAI_AGENT_WeaponItemType)
	_D(" Current weapon type: " & $l_i_CurrentType)
	If $l_i_CurrentType = $a_i_Type Then
		_D(" => Already equipped type " & $a_i_Type & "! (returning 5)")
		Return 5 
	Else
		For $l_i_Set = 0 To 3
			Local $l_i_SetType = $g_a2D_WeaponSets[$l_i_Set][$GC_UAI_WEAPONSET_WeaponType]
			_D(" Set " & ($l_i_Set + 1) & " has weapon type: " & $l_i_SetType)
			If $l_i_SetType = $a_i_Type Then
				_D(" => Found type " & $a_i_Type & " in Set " & ($l_i_Set + 1) & "!")
				Return $l_i_Set + 1
			EndIf
		Next
	EndIf
	_D(" => Weapon type " & $a_i_Type & " not found (returning 0)")
	Return 0 
EndFunc
Func UAI_GetBestWeaponSetBySkillSlot($a_i_SkillSlot)
	Local $l_f_HP = UAI_GetPlayerInfo($GC_UAI_AGENT_HP)
	Local $l_i_CurrentEnergy = UAI_GetPlayerInfo($GC_UAI_AGENT_CurrentEnergy)
	Local $l_i_SkillEnergyCost = UAI_GetStaticSkillInfo($a_i_SkillSlot, $GC_UAI_STATIC_SKILL_EnergyCost)
	Local $l_i_SkillType = UAI_GetStaticSkillInfo($a_i_SkillSlot, $GC_UAI_STATIC_SKILL_SkillType)
	Local $l_i_BestSet = 0
	If $l_f_HP < 0.25 And $g_ai_Best_Defensive_Set[1] > 0 And $l_i_SkillType <> $GC_I_SKILL_TYPE_ATTACK And $l_i_SkillType <> $GC_I_SKILL_TYPE_ENCHANTMENT Then
		UAI_ChangeWeaponSet($g_ai_Best_Defensive_Set[1])
		Return
	EndIf
	If $l_i_CurrentEnergy < $l_i_SkillEnergyCost And $g_ai_High_Energy_Set[1] > 0 And $l_i_SkillType <> $GC_I_SKILL_TYPE_ATTACK And $l_i_SkillType <> $GC_I_SKILL_TYPE_ENCHANTMENT Then
		UAI_ChangeWeaponSet($g_ai_High_Energy_Set[1])
		Return
	EndIf
	Switch $l_i_SkillType
		Case $GC_I_SKILL_TYPE_HEX, $GC_I_SKILL_TYPE_SPELL, $GC_I_SKILL_TYPE_SIGNET, $GC_I_SKILL_TYPE_CONDITION, $GC_I_SKILL_TYPE_WELL, $GC_I_SKILL_TYPE_WARD, $GC_I_SKILL_TYPE_ITEM_SPELL, $GC_I_SKILL_TYPE_WEAPON_SPELL
			If $g_ai_Best_Casting_Set[1] > 0 Then
				$l_i_BestSet = $g_ai_Best_Casting_Set[1]
			EndIf
		Case $GC_I_SKILL_TYPE_ENCHANTMENT
			If $g_ai_Best_Enchant_Set[1] > 0 Then
				$l_i_BestSet = $g_ai_Best_Enchant_Set[1]
			ElseIf $g_ai_Best_Casting_Set[1] > 0 Then
				$l_i_BestSet = $g_ai_Best_Casting_Set[1]
			EndIf
		Case $GC_I_SKILL_TYPE_ATTACK
			Local $l_i_WeaponReq = UAI_GetStaticSkillInfo($a_i_SkillSlot, $GC_UAI_STATIC_SKILL_WeaponReq)
			Local $l_i_CurrentWeaponType = UAI_GetPlayerInfo($GC_UAI_AGENT_WeaponItemType)
			Local $l_i_RequiredItemType = UAI_WeaponReqToItemType($l_i_WeaponReq)
			If $l_i_RequiredItemType > 0 And $l_i_CurrentWeaponType <> $l_i_RequiredItemType Then
				$l_i_BestSet = UAI_FindWeaponSetByType($l_i_RequiredItemType)
				If $l_i_BestSet = 5 Then Return 
			EndIf
		Case $GC_I_SKILL_TYPE_STANCE
			If $g_ai_Best_Offensive_Set[1] > 0 Then
				$l_i_BestSet = $g_ai_Best_Offensive_Set[1]
			EndIf
		Case $GC_I_SKILL_TYPE_SHOUT, $GC_I_SKILL_TYPE_CHANT, $GC_I_SKILL_TYPE_ECHO_REFRAIN
			Return
		Case $GC_I_SKILL_TYPE_PREPARATION
			If $g_ai_Best_Ranged_Set[1] > 0 Then
				$l_i_BestSet = $g_ai_Best_Ranged_Set[1]
			EndIf
		Case $GC_I_SKILL_TYPE_TRAP
			Return
		Case $GC_I_SKILL_TYPE_RITUAL
			If $g_ai_Best_Casting_Set[1] > 0 Then
				$l_i_BestSet = $g_ai_Best_Casting_Set[1]
			EndIf
		Case $GC_I_SKILL_TYPE_GLYPH
			If $g_ai_Best_Casting_Set[1] > 0 Then
				$l_i_BestSet = $g_ai_Best_Casting_Set[1]
			EndIf
		Case $GC_I_SKILL_TYPE_FORM
			Return
		Case $GC_I_SKILL_TYPE_PETATTACK
			If $g_ai_Best_Offensive_Set[1] > 0 Then
				$l_i_BestSet = $g_ai_Best_Offensive_Set[1]
			EndIf
		Case Else
			Return
	EndSwitch
	If $l_i_BestSet > 0 And $l_i_BestSet <= 4 Then
		UAI_ChangeWeaponSet($l_i_BestSet)
	EndIf
EndFunc
Func UAI_WeaponReqToItemType($a_i_WeaponReq)
	Switch $a_i_WeaponReq
		Case 1   
			Return $GC_I_TYPE_AXE
		Case 2   
			Return $GC_I_TYPE_BOW
		Case 8   
			Return $GC_I_TYPE_DAGGERS
		Case 16  
			Return $GC_I_TYPE_HAMMER
		Case 32  
			Return $GC_I_TYPE_SCYTHE
		Case 64  
			Return $GC_I_TYPE_SPEAR
		Case 128 
			Return $GC_I_TYPE_SWORD
		Case Else
			Return 0 
	EndSwitch
EndFunc
Func UAI_GetBestWeaponSetForCombat()
	Local $l_f_HP = UAI_GetPlayerInfo($GC_UAI_AGENT_HP)
	Local $l_i_CurrentEnergy = UAI_GetPlayerInfo($GC_UAI_AGENT_CurrentEnergy)
	If $l_f_HP <= 0.30 Then
		$g_b_InDefensiveMode = True
	ElseIf $l_f_HP >= 0.50 Then
		$g_b_InDefensiveMode = False
	EndIf
	If $g_b_InDefensiveMode Then
		If $g_ai_Best_Defensive_Set[1] > 0 Then Return $g_ai_Best_Defensive_Set[1]
		If $g_ai_High_Hp_Set[1] > 0 Then Return $g_ai_High_Hp_Set[1]
	EndIf
	If $l_i_CurrentEnergy <= 5 Then
		$g_b_InLowEnergyMode = True
	ElseIf $l_i_CurrentEnergy >= 25 Then
		$g_b_InLowEnergyMode = False
	EndIf
	If $g_b_InLowEnergyMode Then
		If $g_ai_High_Energy_Set[1] > 0 Then Return $g_ai_High_Energy_Set[1]
		If $g_ai_Best_Zealous_Set[1] > 0 Then Return $g_ai_Best_Zealous_Set[1]
	EndIf
	If $g_ai_Best_Offensive_Set[1] > 0 Then Return $g_ai_Best_Offensive_Set[1]
	If $g_ai_Best_Casting_Set[1] > 0 Then Return $g_ai_Best_Casting_Set[1]
	If $g_ai_High_Hp_Set[1] > 0 Then Return $g_ai_High_Hp_Set[1]
	Return 1 
EndFunc
Func UAI_ShouldSwitchWeaponSet()
	Local $l_i_BestSet = UAI_GetBestWeaponSetForCombat()
	If UAI_IsOnWeaponSet($l_i_BestSet) Then Return False
	UAI_ChangeWeaponSet($l_i_BestSet)
	Return True
EndFunc
Func UAI_GetWeaponSetForSituation($a_s_Situation)
	Switch $a_s_Situation
		Case "defensive"
			Return $g_ai_Best_Defensive_Set[1]
		Case "offensive"
			Return $g_ai_Best_Offensive_Set[1]
		Case "casting"
			Return $g_ai_Best_Casting_Set[1]
		Case "enchanting"
			Return $g_ai_Best_Enchant_Set[1]
		Case "ranged"
			Return $g_ai_Best_Ranged_Set[1]
		Case "energy"
			Return $g_ai_High_Energy_Set[1]
		Case "hp"
			Return $g_ai_High_Hp_Set[1]
		Case "vampiric"
			Return $g_ai_Best_Vampiric_Set[1]
		Case "zealous"
			Return $g_ai_Best_Zealous_Set[1]
		Case Else
			Return 0
	EndSwitch
EndFunc
Func UAI_ChangeWeaponSet($a_i_Set)
	If UAI_IsOnWeaponSet($a_i_Set) Then Return
	Local $l_i_SetToUse = 0
	Switch $a_i_Set
		Case 1
			$l_i_SetToUse = $GC_I_CONTROL_INVENTORY_ACTIVATE_WEAPON_SET_1
		Case 2
			$l_i_SetToUse = $GC_I_CONTROL_INVENTORY_ACTIVATE_WEAPON_SET_2
		Case 3
			$l_i_SetToUse = $GC_I_CONTROL_INVENTORY_ACTIVATE_WEAPON_SET_3
		Case 4
			$l_i_SetToUse = $GC_I_CONTROL_INVENTORY_ACTIVATE_WEAPON_SET_4
	EndSwitch
	Local $l_i_Deadlock = TimerInit()
	Core_PerformAction($GC_I_CONTROL_ACTION_CANCEL_ACTION, $GC_I_CONTROL_TYPE_ACTIVATE)
	Sleep(32)
	Core_PerformAction($GC_I_CONTROL_ACTION_CANCEL_ACTION, $GC_I_CONTROL_TYPE_ACTIVATE)
	Sleep(32)
	Do
		Core_PerformAction($l_i_SetToUse, $GC_I_CONTROL_TYPE_ACTIVATE)
		Sleep(32)
	Until UAI_IsOnWeaponSet($a_i_Set) Or TimerDiff($l_i_Deadlock) > 400
EndFunc
Func UAI_SearchModsInArray(ByRef $a_as2_UpgradeArray, ByRef $a_s_ModStruct, ByRef $a_s_NewModStruct, ByRef $a_i_Finding, $a_i_Set, $a_i_Weapon)
	Local $l_i_Index = $a_i_Set - 1
	For $i = 0 To UBound($a_as2_UpgradeArray) - 1
		Local $l_s_SearchIn = ($a_i_Finding = 0) ? $a_s_ModStruct : $a_s_NewModStruct
		If StringInStr($l_s_SearchIn, $a_as2_UpgradeArray[$i][2]) > 0 Then
			$g_as3_Weapon_Mods[$a_i_Set - 1][$a_i_Weapon - 1][$a_i_Finding] = $a_as2_UpgradeArray[$i][0]
			If $a_i_Finding = 0 Then
				$a_s_NewModStruct = StringReplace($a_s_ModStruct, $a_as2_UpgradeArray[$i][2], "")
			Else
				$a_s_NewModStruct = StringReplace($a_s_NewModStruct, $a_as2_UpgradeArray[$i][2], "")
			EndIf
			Local $l_s_ModName = $a_as2_UpgradeArray[$i][0]
			Local $l_s_Effect = $a_as2_UpgradeArray[$i][1]
			_D("     [MOD #" & $a_i_Finding & "] " & $l_s_ModName & " => " & $l_s_Effect)
			Local $l_i_HPBonus = UAI_ExtractHPBonus($l_s_Effect)
			Local $l_i_EnergyBonus = UAI_ExtractEnergyBonus($l_s_Effect)
			If $l_i_HPBonus > 0 Then
				$g_a2D_WeaponSets[$l_i_Index][$GC_UAI_WEAPONSET_MaxHP] += $l_i_HPBonus
				$g_a2D_WeaponSets[$l_i_Index][$GC_UAI_WEAPONSET_DefensiveScore] += $l_i_HPBonus
			EndIf
			If $l_i_EnergyBonus > 0 Then
				$g_a2D_WeaponSets[$l_i_Index][$GC_UAI_WEAPONSET_MaxEnergy] += $l_i_EnergyBonus
			EndIf
			If StringInStr($l_s_ModName, "Sundering") Then
				$g_a2D_WeaponSets[$l_i_Index][$GC_UAI_WEAPONSET_OffensiveScore] += 20
			EndIf
			If StringInStr($l_s_ModName, "Vampiric") Then
				$g_a2D_WeaponSets[$l_i_Index][$GC_UAI_WEAPONSET_OffensiveScore] += 15
				$g_a2D_WeaponSets[$l_i_Index][$GC_UAI_WEAPONSET_HasVampiric] = 1
			EndIf
			If StringInStr($l_s_ModName, "Zealous") Then
				$g_a2D_WeaponSets[$l_i_Index][$GC_UAI_WEAPONSET_OffensiveScore] += 10
				$g_a2D_WeaponSets[$l_i_Index][$GC_UAI_WEAPONSET_HasZealous] = 1
			EndIf
			If StringInStr($l_s_ModName, "Furious") Then
				$g_a2D_WeaponSets[$l_i_Index][$GC_UAI_WEAPONSET_OffensiveScore] += 10
			EndIf
			If StringInStr($l_s_Effect, "+33%") Then
				$g_a2D_WeaponSets[$l_i_Index][$GC_UAI_WEAPONSET_OffensiveScore] += 5
			EndIf
			If StringInStr($l_s_Effect, "Damage +15%") Or StringInStr($l_s_Effect, "Damage 20%") Then
				$g_a2D_WeaponSets[$l_i_Index][$GC_UAI_WEAPONSET_OffensiveScore] += 15
			EndIf
			If StringInStr($l_s_Effect, "Armor +") Then
				$g_a2D_WeaponSets[$l_i_Index][$GC_UAI_WEAPONSET_DefensiveScore] += 10
			EndIf
			If StringInStr($l_s_Effect, "armor vs") Then
				$g_a2D_WeaponSets[$l_i_Index][$GC_UAI_WEAPONSET_DefensiveScore] += 7
			EndIf
			If StringInStr($l_s_Effect, "Damage -") Then
				$g_a2D_WeaponSets[$l_i_Index][$GC_UAI_WEAPONSET_DefensiveScore] += 5
			EndIf
			If StringInStr($l_s_Effect, "-20%") Then 
				$g_a2D_WeaponSets[$l_i_Index][$GC_UAI_WEAPONSET_DefensiveScore] += 3
			EndIf
			If StringInStr($l_s_Effect, "HCT20") Then
				$g_a2D_WeaponSets[$l_i_Index][$GC_UAI_WEAPONSET_CastingScore] += 20
			ElseIf StringInStr($l_s_Effect, "HCT10") Then
				$g_a2D_WeaponSets[$l_i_Index][$GC_UAI_WEAPONSET_CastingScore] += 10
			EndIf
			If StringInStr($l_s_Effect, "HSR20") Then
				$g_a2D_WeaponSets[$l_i_Index][$GC_UAI_WEAPONSET_CastingScore] += 20
			ElseIf StringInStr($l_s_Effect, "HSR10") Then
				$g_a2D_WeaponSets[$l_i_Index][$GC_UAI_WEAPONSET_CastingScore] += 10
			EndIf
			If StringInStr($l_s_Effect, "Enchantment Duration") Or StringInStr($l_s_ModName, "Enchanting") Then
				$g_a2D_WeaponSets[$l_i_Index][$GC_UAI_WEAPONSET_EnchantScore] += 20
			EndIf
			$a_i_Finding += 1
		EndIf
	Next
EndFunc
Func UAI_ExtractHPBonus($a_s_Effect)
	Local $l_a_Result = StringRegExp($a_s_Effect, "Health \+(\d+)", 1)
	If IsArray($l_a_Result) Then Return Int($l_a_Result[0])
	$l_a_Result = StringRegExp($a_s_Effect, "\+(\d+) HP", 1)
	If IsArray($l_a_Result) Then Return Int($l_a_Result[0])
	Return 0
EndFunc
Func UAI_ExtractEnergyBonus($a_s_Effect)
	Local $l_a_Result = StringRegExp($a_s_Effect, "Energy \+(\d+)", 1)
	If IsArray($l_a_Result) Then Return Int($l_a_Result[0])
	Return 0
EndFunc
Func UAI_IsOnWeaponSet($a_i_Set)
	If $a_i_Set < 1 Or $a_i_Set > 4 Then Return False
	Local $l_i_Index = $a_i_Set - 1
	Local $l_i_CurrentWeaponId = UAI_GetPlayerInfo($GC_UAI_AGENT_WeaponItemId)
	Local $l_i_CurrentOffhandId = UAI_GetPlayerInfo($GC_UAI_AGENT_OffhandItemId)
	Local $l_i_SetWeaponId = $g_a2D_WeaponSets[$l_i_Index][$GC_UAI_WEAPONSET_WeaponId]
	Local $l_i_SetOffhandId = $g_a2D_WeaponSets[$l_i_Index][$GC_UAI_WEAPONSET_OffhandId]
	Return ($l_i_CurrentWeaponId = $l_i_SetWeaponId And $l_i_CurrentOffhandId = $l_i_SetOffhandId)
EndFunc
Func UAI_IsTwoHandedWeapon($a_i_WeaponType)
	Switch $a_i_WeaponType
		Case $GC_I_TYPE_DAGGERS, $GC_I_TYPE_HAMMER, $GC_I_TYPE_SCYTHE, $GC_I_TYPE_BOW, $GC_I_TYPE_STAFF
			Return True
		Case Else
			Return False
	EndSwitch
EndFunc
Func UAI_IsRangedWeapon($a_i_WeaponType)
	Switch $a_i_WeaponType
		Case $GC_I_TYPE_BOW, $GC_I_TYPE_SPEAR, $GC_I_TYPE_WAND, $GC_I_TYPE_STAFF
			Return True
		Case Else
			Return False
	EndSwitch
EndFunc
Func UAI_GetWeaponTypeName($a_i_Type)
	Switch $a_i_Type
		Case $GC_I_TYPE_AXE 
			Return "Axe"
		Case $GC_I_TYPE_BOW 
			Return "Bow"
		Case $GC_I_TYPE_HAMMER 
			Return "Hammer"
		Case $GC_I_TYPE_WAND 
			Return "Wand"
		Case $GC_I_TYPE_STAFF 
			Return "Staff"
		Case $GC_I_TYPE_SWORD 
			Return "Sword"
		Case $GC_I_TYPE_DAGGERS 
			Return "Daggers"
		Case $GC_I_TYPE_SCYTHE 
			Return "Scythe"
		Case $GC_I_TYPE_SPEAR 
			Return "Spear"
		Case Else
			Return "Unknown (" & $a_i_Type & ")"
	EndSwitch
EndFunc
Func UAI_GetOffhandTypeName($a_i_Type)
	Switch $a_i_Type
		Case $GC_I_TYPE_OFFHAND 
			Return "Focus"
		Case $GC_I_TYPE_SHIELD 
			Return "Shield"
		Case 0
			Return "Empty"
		Case Else
			Return "Unknown (" & $a_i_Type & ")"
	EndSwitch
EndFunc
#EndRegion Set and Mods