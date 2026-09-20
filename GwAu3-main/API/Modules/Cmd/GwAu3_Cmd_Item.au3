#include-once
Func Item_SalvageItem($a_v_Item, $a_s_KitType = "Standard", $a_s_SalvageType = "Materials")
    Local $l_i_ItemID = Item_ItemID($a_v_Item)
    If $a_s_KitType = "Standard" And $a_s_SalvageType <> "Materials" Then
        Return False 
    EndIf
    Local $l_ptr_SalvageKit = 0
    Local $l_a_Kits[5][3] 
    $l_a_Kits[0][0] = 0 
    $l_a_Kits[1][0] = 0 
    $l_a_Kits[2][0] = 0 
    $l_a_Kits[3][0] = 0 
    $l_a_Kits[4][0] = 0 
    For $i = 1 To 4
        For $j = 1 To Item_GetBagInfo(Item_GetBagPtr($i), 'Slots')
            Local $l_ptr_Item = Item_GetItemBySlot($i, $j)
            Local $l_i_ModelID = Item_GetItemInfoByPtr($l_ptr_Item, 'ModelID')
            Local $l_i_Value = Item_GetItemInfoByPtr($l_ptr_Item, 'Value')
            Switch $l_i_ModelID
                Case $GC_I_MODELID_CHARR_SALVAGE_KIT 
                    Local $l_i_Uses = $l_i_Value / 1
                    If $l_a_Kits[0][0] = 0 Or $l_i_Uses < $l_a_Kits[0][2] Then
                        $l_a_Kits[0][0] = $GC_I_MODELID_CHARR_SALVAGE_KIT
                        $l_a_Kits[0][1] = $l_ptr_Item
                        $l_a_Kits[0][2] = $l_i_Uses
                    EndIf
                Case $GC_I_MODELID_SALVAGE_KIT 
                    Local $l_i_Uses = $l_i_Value / 2
                    If $l_a_Kits[1][0] = 0 Or $l_i_Uses < $l_a_Kits[1][2] Then
                        $l_a_Kits[1][0] = $GC_I_MODELID_SALVAGE_KIT
                        $l_a_Kits[1][1] = $l_ptr_Item
                        $l_a_Kits[1][2] = $l_i_Uses
                    EndIf
                Case $GC_I_MODELID_EXPERT_SALVAGE_KIT 
                    Local $l_i_Uses = $l_i_Value / 8
                    If $l_a_Kits[2][0] = 0 Or $l_i_Uses < $l_a_Kits[2][2] Then
                        $l_a_Kits[2][0] = $GC_I_MODELID_EXPERT_SALVAGE_KIT
                        $l_a_Kits[2][1] = $l_ptr_Item
                        $l_a_Kits[2][2] = $l_i_Uses
                    EndIf
                Case $GC_I_MODELID_SUPERIOR_SALVAGE_KIT 
                    Local $l_i_Uses = $l_i_Value / 10
                    If $l_a_Kits[3][0] = 0 Or $l_i_Uses < $l_a_Kits[3][2] Then
                        $l_a_Kits[3][0] = 5900
                        $l_a_Kits[3][1] = $l_ptr_Item
                        $l_a_Kits[3][2] = $l_i_Uses
                    EndIf
                Case $GC_I_MODELID_PERFECT_SALVAGE_KIT 
                    Local $l_i_Uses = $l_i_Value / 10
                    If $l_a_Kits[4][0] = 0 Or $l_i_Uses < $l_a_Kits[4][2] Then
                        $l_a_Kits[4][0] = $GC_I_MODELID_PERFECT_SALVAGE_KIT
                        $l_a_Kits[4][1] = $l_ptr_Item
                        $l_a_Kits[4][2] = $l_i_Uses
                    EndIf
            EndSwitch
        Next
    Next
    Switch $a_s_KitType
        Case "Perfect"
            If $l_a_Kits[4][0] <> 0 Then
                $l_ptr_SalvageKit = $l_a_Kits[4][1]
            ElseIf $l_a_Kits[3][0] <> 0 Then
                $l_ptr_SalvageKit = $l_a_Kits[3][1]
            ElseIf $l_a_Kits[2][0] <> 0 Then
                $l_ptr_SalvageKit = $l_a_Kits[2][1]
            ElseIf $l_a_Kits[1][0] <> 0 And $a_s_SalvageType = "Materials" Then
                $l_ptr_SalvageKit = $l_a_Kits[1][1]
            ElseIf $l_a_Kits[0][0] <> 0 Then
                $l_ptr_SalvageKit = $l_a_Kits[0][1]
            EndIf
        Case "Superior"
            If $l_a_Kits[3][0] <> 0 Then
                $l_ptr_SalvageKit = $l_a_Kits[3][1]
            ElseIf $l_a_Kits[4][0] <> 0 Then
                $l_ptr_SalvageKit = $l_a_Kits[4][1]
            ElseIf $l_a_Kits[2][0] <> 0 Then
                $l_ptr_SalvageKit = $l_a_Kits[2][1]
            ElseIf $l_a_Kits[1][0] <> 0 And $a_s_SalvageType = "Materials" Then
                $l_ptr_SalvageKit = $l_a_Kits[1][1]
            ElseIf $l_a_Kits[0][0] <> 0 Then
                $l_ptr_SalvageKit = $l_a_Kits[0][1]
            EndIf
        Case "Expert"
            If $l_a_Kits[2][0] <> 0 Then
                $l_ptr_SalvageKit = $l_a_Kits[2][1]
            ElseIf $l_a_Kits[3][0] <> 0 Then
                $l_ptr_SalvageKit = $l_a_Kits[3][1]
            ElseIf $l_a_Kits[4][0] <> 0 Then
                $l_ptr_SalvageKit = $l_a_Kits[4][1]
            ElseIf $l_a_Kits[1][0] <> 0 And $a_s_SalvageType = "Materials" Then
                $l_ptr_SalvageKit = $l_a_Kits[1][1]
            ElseIf $l_a_Kits[0][0] <> 0 Then
                $l_ptr_SalvageKit = $l_a_Kits[0][1]
            EndIf
        Case "Standard"
            If $l_a_Kits[1][0] <> 0 And $a_s_SalvageType = "Materials" Then
                $l_ptr_SalvageKit = $l_a_Kits[1][1]
            ElseIf $l_a_Kits[0][0] <> 0 Then
                $l_ptr_SalvageKit = $l_a_Kits[0][1]
            ElseIf $l_a_Kits[2][0] <> 0 Then
                $l_ptr_SalvageKit = $l_a_Kits[2][1]
            ElseIf $l_a_Kits[3][0] <> 0 Then
                $l_ptr_SalvageKit = $l_a_Kits[3][1]
            ElseIf $l_a_Kits[4][0] <> 0 Then
                $l_ptr_SalvageKit = $l_a_Kits[4][1]
            EndIf
        Case "Charr"
            If $l_a_Kits[0][0] <> 0 Then
                $l_ptr_SalvageKit = $l_a_Kits[0][1]
            ElseIf $l_a_Kits[1][0] <> 0 And $a_s_SalvageType = "Materials" Then
                $l_ptr_SalvageKit = $l_a_Kits[1][1]
            ElseIf $l_a_Kits[2][0] <> 0 Then
                $l_ptr_SalvageKit = $l_a_Kits[2][1]
            ElseIf $l_a_Kits[3][0] <> 0 Then
                $l_ptr_SalvageKit = $l_a_Kits[3][1]
            ElseIf $l_a_Kits[4][0] <> 0 Then
                $l_ptr_SalvageKit = $l_a_Kits[4][1]
            EndIf
    EndSwitch
    If $l_ptr_SalvageKit = 0 Then Return False
    Local $l_a_Offset[4] = [0, 0x18, 0x2C, 0x690]
    Local $l_i_SalvageSessionID = Memory_ReadPtr($g_p_BasePointer, $l_a_Offset)
    Other_PingSleep(32)
    DllStructSetData($g_d_Salvage, 2, $l_i_ItemID)
    DllStructSetData($g_d_Salvage, 3, Item_ItemID($l_ptr_SalvageKit))
    DllStructSetData($g_d_Salvage, 4, $l_i_SalvageSessionID[1])
    Core_Enqueue($g_p_Salvage, 16)
    Other_PingSleep(248)
    Switch $a_s_SalvageType
        Case "Materials"
            Core_SendPacket(0x4, $GC_I_HEADER_ITEM_SALVAGE_MATERIALS)
			Other_PingSleep(32)
        Case "Prefix"
            Core_SendPacket(0x8, $GC_I_HEADER_ITEM_SALVAGE_UPGRADE, 0)
			Other_PingSleep(32)
        Case "Suffix"
            Core_SendPacket(0x8, $GC_I_HEADER_ITEM_SALVAGE_UPGRADE, 1)
			Other_PingSleep(32)
        Case "Inscription"
            Core_SendPacket(0x8, $GC_I_HEADER_ITEM_SALVAGE_UPGRADE, 2)
			Other_PingSleep(32)
        Case Else
            Return False
    EndSwitch
    Return True
EndFunc 
Func Item_ApplyUpgrade($a_v_TargetItem, $a_v_UpgradeItem, $a_i_UpgradeSlot, $a_b_Confirm = True, $a_i_ExtraWait = 248)
    Local $l_i_TargetItemID = Item_ItemID($a_v_TargetItem)
    Local $l_i_UpgradeItemID = Item_ItemID($a_v_UpgradeItem)
    If $l_i_TargetItemID = 0 Or Item_GetItemPtr($l_i_TargetItemID) = 0 Then Return SetError(1, 0, False)
    If $l_i_UpgradeItemID = 0 Or Item_GetItemPtr($l_i_UpgradeItemID) = 0 Then Return SetError(2, 0, False)
    If $a_i_UpgradeSlot < $GC_I_UPGRADE_SLOT_PREFIX Or _
            $a_i_UpgradeSlot > $GC_I_UPGRADE_SLOT_INSCRIPTION Then Return SetError(3, 0, False)
    DllStructSetData($g_d_ApplyUpgrade, 2, $GC_I_UIMSG_ITEM_APPLY_UPGRADE)
    DllStructSetData($g_d_ApplyUpgrade, 3, 0)
    DllStructSetData($g_d_ApplyUpgrade, 4, $a_i_UpgradeSlot)
    DllStructSetData($g_d_ApplyUpgrade, 5, $l_i_TargetItemID)
    DllStructSetData($g_d_ApplyUpgrade, 6, $l_i_UpgradeItemID)
    Core_Enqueue($g_p_ApplyUpgrade, 24)
    If Not $a_b_Confirm Then Return True
    Other_PingSleep($a_i_ExtraWait)
    Other_PingSleep($a_i_ExtraWait)
    Core_SendPacket(0x4, $GC_I_HEADER_UPGRADE_SESSION_END)
    Return True
EndFunc 
Func Item_IdentifyItem($a_v_Item, $a_s_KitType = "Superior")
    Local $l_i_ItemID = Item_ItemID($a_v_Item)
    If Item_GetItemInfoByItemID($l_i_ItemID, "IsIdentified") Then Return True
    Local $l_i_IDKit = 0
    Local $l_i_BestUses = 101
    Local $l_a_Kits[2][3] 
    $l_a_Kits[0][0] = 0 
    $l_a_Kits[1][0] = 0 
    For $i = 1 To 4
        For $j = 1 To Item_GetBagInfo(Item_GetBagPtr($i), 'Slots')
            Local $l_ptr_Item = Item_GetItemBySlot($i, $j)
            Local $l_i_ModelID = Item_GetItemInfoByPtr($l_ptr_Item, 'ModelID')
            Local $l_i_Value = Item_GetItemInfoByPtr($l_ptr_Item, 'Value')
            Switch $l_i_ModelID
                Case 2989 
                    Local $l_i_Uses = $l_i_Value / 2
                    If $l_a_Kits[0][0] = 0 Or $l_i_Uses < $l_a_Kits[0][2] Then
                        $l_a_Kits[0][0] = 2989
                        $l_a_Kits[0][1] = Item_GetItemInfoByPtr($l_ptr_Item, 'ItemID')
                        $l_a_Kits[0][2] = $l_i_Uses
                    EndIf
                Case 5899 
                    Local $l_i_Uses = $l_i_Value / 2.5
                    If $l_a_Kits[1][0] = 0 Or $l_i_Uses < $l_a_Kits[1][2] Then
                        $l_a_Kits[1][0] = 5899
                        $l_a_Kits[1][1] = Item_GetItemInfoByPtr($l_ptr_Item, 'ItemID')
                        $l_a_Kits[1][2] = $l_i_Uses
                    EndIf
            EndSwitch
        Next
    Next
    Switch $a_s_KitType
        Case "Superior"
            If $l_a_Kits[1][0] <> 0 Then
                $l_i_IDKit = $l_a_Kits[1][1]
            ElseIf $l_a_Kits[0][0] <> 0 Then
                $l_i_IDKit = $l_a_Kits[0][1]
            EndIf
        Case "Normal"
            If $l_a_Kits[0][0] <> 0 Then
                $l_i_IDKit = $l_a_Kits[0][1]
            ElseIf $l_a_Kits[1][0] <> 0 Then
                $l_i_IDKit = $l_a_Kits[1][1]
            EndIf
    EndSwitch
    If $l_i_IDKit = 0 Then Return False
    Core_SendPacket(0xC, $GC_I_HEADER_ITEM_IDENTIFY, $l_i_IDKit, $l_i_ItemID)
    Local $l_i_Deadlock = TimerInit()
    Do
        Sleep(16)
    Until Item_GetItemInfoByItemID($l_i_ItemID, "IsIdentified") Or TimerDiff($l_i_Deadlock) > 2500
    If TimerDiff($l_i_Deadlock) > 2500 Then Return False
    Return True
EndFunc 
Func Item_CanIdentifyAll($a_i_Timeout = 1000)
    If $g_i_InvCanIdentifyAllResult <= 0 Then Return SetError(1, 0, False)
    If DllStructGetData($g_d_InvCanIdentifyAll, 1) <= 0 Then Return SetError(1, 0, False)
    Local Const $LC_I_IDENTIFYALL_PENDING = 0xFFFFFFFF
    Memory_Write($g_i_InvCanIdentifyAllResult, $LC_I_IDENTIFYALL_PENDING)
    Core_Enqueue($g_p_InvCanIdentifyAll, 4)
    Local $l_i_Deadlock = TimerInit()
    While Memory_Read($g_i_InvCanIdentifyAllResult) = $LC_I_IDENTIFYALL_PENDING
        If TimerDiff($l_i_Deadlock) > $a_i_Timeout Then Return SetError(2, 0, False)
        Sleep(8)
    WEnd
    Return Memory_Read($g_i_InvCanIdentifyAllResult) <> 0
EndFunc 
Func Item_IdentifyAll($a_i_Timeout = 1000)
    If Not Item_CanIdentifyAll($a_i_Timeout) Then Return SetError(@error, 0, False)
    If DllStructGetData($g_d_InvIdentifyAll, 1) <= 0 Then Return SetError(1, 0, False)
    Local Const $LC_I_IDENTIFYALL_PENDING = 0xFFFFFFFF
    Memory_Write($g_i_InvIdentifyAllResult, $LC_I_IDENTIFYALL_PENDING)
    Core_Enqueue($g_p_InvIdentifyAll, 4)
    Local $l_i_Deadlock = TimerInit()
    While Memory_Read($g_i_InvIdentifyAllResult) = $LC_I_IDENTIFYALL_PENDING
        If TimerDiff($l_i_Deadlock) > $a_i_Timeout Then Return SetError(2, 0, False)
        Sleep(8)
    WEnd
    Return True
EndFunc 
Func Item_CanDepositAllMaterials($a_i_Timeout = 1000)
    If $g_i_InvCanDepositAllMaterialsResult <= 0 Then Return SetError(1, 0, False)
    If DllStructGetData($g_d_InvCanDepositAllMaterials, 1) <= 0 Then Return SetError(1, 0, False)
    Local Const $LC_I_DEPOSITALL_PENDING = 0xFFFFFFFF
    Memory_Write($g_i_InvCanDepositAllMaterialsResult, $LC_I_DEPOSITALL_PENDING)
    Core_Enqueue($g_p_InvCanDepositAllMaterials, 4)
    Local $l_i_Deadlock = TimerInit()
    While Memory_Read($g_i_InvCanDepositAllMaterialsResult) = $LC_I_DEPOSITALL_PENDING
        If TimerDiff($l_i_Deadlock) > $a_i_Timeout Then Return SetError(2, 0, False)
        Sleep(8)
    WEnd
    Return Memory_Read($g_i_InvCanDepositAllMaterialsResult) <> 0
EndFunc 
Func Item_DepositAllMaterials($a_i_Timeout = 1000)
    If Not Item_CanDepositAllMaterials($a_i_Timeout) Then Return SetError(@error, 0, False)
    If DllStructGetData($g_d_InvDepositAllMaterials, 1) <= 0 Then Return SetError(1, 0, False)
    Local Const $LC_I_DEPOSITALL_PENDING = 0xFFFFFFFF
    Memory_Write($g_i_InvDepositAllMaterialsResult, $LC_I_DEPOSITALL_PENDING)
    Core_Enqueue($g_p_InvDepositAllMaterials, 4)
    Local $l_i_Deadlock = TimerInit()
    While Memory_Read($g_i_InvDepositAllMaterialsResult) = $LC_I_DEPOSITALL_PENDING
        If TimerDiff($l_i_Deadlock) > $a_i_Timeout Then Return SetError(2, 0, False)
        Sleep(8)
    WEnd
    Return True
EndFunc 
Func Item_EquipItem($a_v_Item)
    Return Core_SendPacket(0x8, $GC_I_HEADER_ITEM_EQUIP, Item_ItemID($a_v_Item))
EndFunc 
Func Item_EquipHero($a_i_HeroNumber, $a_v_Item)
    Local $l_i_HeroAgentID = Party_GetMyPartyHeroInfo($a_i_HeroNumber, "AgentID")
    Local $l_i_ItemID = Item_ItemID($a_v_Item)
    If $l_i_HeroAgentID = 0 Or $l_i_ItemID = 0 Then Return SetError(1, 0, False)
    Core_SendPacket(0xC, $GC_I_HEADER_ITEM_EQUIP_HERO, $l_i_HeroAgentID, $l_i_ItemID)
    Return True
EndFunc 
Func Item_UnequipHero($a_i_HeroNumber, $a_i_EquipmentSlot, $a_i_BagNumber, $a_i_Slot)
    Local $l_i_HeroAgentID = Party_GetMyPartyHeroInfo($a_i_HeroNumber, "AgentID")
    Local $l_i_BagID = Item_GetBagInfo($a_i_BagNumber, "ID")
    Local $l_i_BagSlots = Item_GetBagInfo($a_i_BagNumber, "Slots")
    If $l_i_HeroAgentID = 0 Or $l_i_BagID = 0 Then Return SetError(1, 0, False)
    If $a_i_EquipmentSlot < $GC_I_EQUIPMENT_SLOT_RIGHT_HAND Or $a_i_EquipmentSlot >= $GC_I_EQUIPMENT_SLOT_NONE Then Return SetError(2, 0, False)
    If $a_i_Slot < 1 Or $a_i_Slot > $l_i_BagSlots Then Return SetError(3, 0, False)
    Core_SendPacket(0x14, $GC_I_HEADER_ITEM_UNEQUIP_HERO, $l_i_HeroAgentID, _
            $a_i_EquipmentSlot, $l_i_BagID, $a_i_Slot - 1)
    Return True
EndFunc 
Func Item_UseItem($a_v_Item)
    Return Core_SendPacket(0x8, $GC_I_HEADER_ITEM_USE, Item_ItemID($a_v_Item))
EndFunc 
Func Item_PickUpItem($a_v_AgentID)
	Return Core_SendPacket(0xC, $GC_I_HEADER_ITEM_INTERACT, Agent_ConvertID($a_v_AgentID), 0)
EndFunc 
Func Item_DropItem($a_v_Item, $a_i_Amount = 0)
    Local $l_i_ItemID = Item_ItemID($a_v_Item)
    Local $l_i_Quantity = Item_GetItemInfoByItemID($a_v_Item, "Quantity")
    If $a_i_Amount = 0 Or $a_i_Amount > $l_i_Quantity Then $a_i_Amount = $l_i_Quantity
    Return Core_SendPacket(0xC, $GC_I_HEADER_DROP_ITEM, $l_i_ItemID, $a_i_Amount)
EndFunc 
Func Item_DropBundle()
    If DllStructGetData($g_d_DropBundle, 1) <= 0 Then Return SetError(1, 0, False)
    Core_Enqueue($g_p_DropBundle, 4)
    Return True
EndFunc 
Func Item_DestroyItem($a_v_ItemID)
	Return Core_SendPacket(0x8, $GC_I_HEADER_ITEM_DESTROY, Item_ItemID($a_v_ItemID))
EndFunc   
Func Item_MoveItem($a_v_Item, $a_i_BagNumber, $a_i_Slot)
    Return Core_SendPacket(0x10, $GC_I_HEADER_ITEM_MOVE, Item_ItemID($a_v_Item), Item_GetBagInfo($a_i_BagNumber, "ID"), $a_i_Slot - 1)
EndFunc 
Func Item_MoveItem_($a_v_Item, $a_i_BagNumber, $a_i_Slot, $a_i_Amount = 0)
    Local $l_p_Item = Item_GetItemPtr($a_v_Item)
    If $l_p_Item = 0 Then Return SetError(1, 0, 0)
    Local $l_i_Quantity = Item_GetItemInfoByPtr($l_p_Item, "Quantity")
    If $a_i_Amount = 0 Or $a_i_Amount > $l_i_Quantity Then $a_i_Amount = $l_i_Quantity
    If $a_i_Amount >= $l_i_Quantity Then
        Return Core_SendPacket(0x10, $GC_I_HEADER_ITEM_MOVE, Item_ItemID($a_v_Item), Item_GetBagInfo($a_i_BagNumber, "ID"), $a_i_Slot - 1)
    Else
        Return Core_SendPacket(0x14, $GC_I_HEADER_ITEM_SPLIT_STACK, Item_ItemID($a_v_Item), $a_i_Amount, Item_GetBagInfo($a_i_BagNumber, "ID"), $a_i_Slot - 1)
    EndIf
EndFunc 
Func Item_AcceptAllItems()
    Return Core_SendPacket(0x8, $GC_I_HEADER_ITEMS_ACCEPT_UNCLAIMED, Item_GetBagInfo(7, "ID"))
EndFunc 
Func Item_DropGold($a_i_Amount = 0)
    Local $l_i_Amount = Item_GetInventoryInfo("GoldCharacter")
    If $a_i_Amount = 0 Or $a_i_Amount > $l_i_Amount Then $a_i_Amount = $l_i_Amount
    Return Core_SendPacket(0x8, $GC_I_HEADER_DROP_GOLD, $a_i_Amount)
EndFunc 
Func Item_ChangeGold($a_i_Character, $a_i_Storage)
    Return Core_SendPacket(0xC, $GC_I_HEADER_ITEM_CHANGE_GOLD, $a_i_Character, $a_i_Storage) 
EndFunc 
Func Item_DepositGold($a_i_Amount = 0)
    Local $l_i_Amount
    Local $l_i_Storage = Item_GetInventoryInfo("GoldStorage")
    Local $l_i_Character = Item_GetInventoryInfo("GoldCharacter")
    If $a_i_Amount > 0 And $l_i_Character >= $a_i_Amount Then
        $l_i_Amount = $a_i_Amount
    Else
        $l_i_Amount = $l_i_Character
    EndIf
    If $l_i_Storage + $l_i_Amount > 1000000 Then $l_i_Amount = 1000000 - $l_i_Storage
    Item_ChangeGold($l_i_Character - $l_i_Amount, $l_i_Storage + $l_i_Amount)
EndFunc 
Func Item_WithdrawGold($a_i_Amount = 0)
    Local $l_i_Amount
    Local $l_i_Storage = Item_GetInventoryInfo("GoldStorage")
    Local $l_i_Character = Item_GetInventoryInfo("GoldCharacter")
    If $a_i_Amount > 0 And $l_i_Storage >= $a_i_Amount Then
        $l_i_Amount = $a_i_Amount
    Else
        $l_i_Amount = $l_i_Storage
    EndIf
    If $l_i_Character + $l_i_Amount > 100000 Then $l_i_Amount = 100000 - $l_i_Character
    Item_ChangeGold($l_i_Character + $l_i_Amount, $l_i_Storage - $l_i_Amount)
EndFunc 
Func Item_OpenChest($a_b_WithLockpick = True)
	If $a_b_WithLockpick Then
		Return Core_SendPacket(0x8, $GC_I_HEADER_CHEST_OPEN, 2)
	Else
		Return Core_SendPacket(0x8, $GC_I_HEADER_CHEST_OPEN, 1)
	EndIf
EndFunc 
Func Item_SwitchWeaponSet($a_i_WeaponSet)
    Return Core_SendPacket(0x8, $GC_I_HEADER_SWITCH_SET, $a_i_WeaponSet)
EndFunc 