#include-once
Func Equipment_AutoEquipFirstWeapon()
    Local $curW = Item_GetInventoryInfo("WeaponSet0WeaponPtr")
    If $curW <> 0 Then
        Out("[Equipment] Arma ya equipada -> NO tocar")
        Return True
    EndIf
    Local $weaponTypes[10] = [ _
        $GC_I_TYPE_LEADHAND, $GC_I_TYPE_AXE, $GC_I_TYPE_BOW, $GC_I_TYPE_HAMMER, _
        $GC_I_TYPE_WAND,     $GC_I_TYPE_STAFF, $GC_I_TYPE_SWORD, $GC_I_TYPE_DAGGERS, _
        $GC_I_TYPE_SCYTHE,   $GC_I_TYPE_SPEAR _
    ]
    For $bag = 1 To 4
        For $slot = 1 To 20
            Local $pItem = Item_GetItemBySlot($bag, $slot)
            If $pItem = 0 Then ContinueLoop
            Local $itemType = Item_GetItemInfoByPtr($pItem, "ItemType")
            For $i = 0 To UBound($weaponTypes) - 1
                If $itemType = $weaponTypes[$i] Then
                    Out("[Equipment] Auto-equip weapon bag=" & $bag & " slot=" & $slot & " type=" & $itemType)
                    Item_EquipItem($pItem)
                    Sleep(800)
                    Core_ControlAction($GC_I_CONTROL_INVENTORY_ACTIVATE_WEAPON_SET_1)
                    Sleep(500)
                    Out("[Equipment] Weapon set 1 activado")
                    Return True
                EndIf
            Next
        Next
    Next
    Out("[Equipment] No weapon encontrada en inventario para auto-equip")
    Return False
EndFunc