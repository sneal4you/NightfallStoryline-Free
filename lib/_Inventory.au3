#include-once
Global $g_Inv_LastRun = 0      
Global $g_Inv_JustEquipped = 0 
Global $g_InvIni = @ScriptDir & "\config.ini"
Global Const $INV_KAMADAN_MAP = 449
Func _Inv_IsWeaponType($t)
    Switch $t
        Case $GC_I_TYPE_LEADHAND, $GC_I_TYPE_AXE, $GC_I_TYPE_BOW, $GC_I_TYPE_OFFHAND, _
             $GC_I_TYPE_HAMMER, $GC_I_TYPE_WAND, $GC_I_TYPE_SHIELD, $GC_I_TYPE_STAFF, _
             $GC_I_TYPE_SWORD, $GC_I_TYPE_DAGGERS, $GC_I_TYPE_SCYTHE, $GC_I_TYPE_SPEAR
            Return True
    EndSwitch
    Return False
EndFunc
Func _Inv_IsArmorType($t)
    Switch $t
        Case $GC_I_TYPE_BOOTS, $GC_I_TYPE_CHESTPIECE, $GC_I_TYPE_GLOVES, _
             $GC_I_TYPE_HEADPIECE, $GC_I_TYPE_LEGGINS
            Return True
    EndSwitch
    Return False
EndFunc
Func _Inv_IsEquipmentType($t)
    Return _Inv_IsWeaponType($t) Or _Inv_IsArmorType($t)
EndFunc
Func _Inv_IsProtectedModel($model)
    If $model = 0 Then Return False
    Local $csv = IniRead($g_InvIni, "Inventory", "ProtectedModels", "24859,24860,24861")
    Local $a = StringSplit($csv, ",")
    For $i = 1 To $a[0]
        If Int(StringStripWS($a[$i], 3)) = $model Then Return True
    Next
    Return False
EndFunc
Func Inventory_ManageAtOutpost()
    If Int(IniRead($g_InvIni, "Inventory", "AutoManageInventory", "1")) <> 1 Then Return
    If Map_GetInstanceInfo("Type") <> 0 Then Return
    Local $cooldownS = Int(IniRead($g_InvIni, "Inventory", "ManageCooldownS", "60"))
    If $g_Inv_LastRun <> 0 And TimerDiff($g_Inv_LastRun) < ($cooldownS * 1000) Then Return
    Local $minFree = Int(IniRead($g_InvIni, "Inventory", "MinFreeSlots", "5"))
    Local $free = _Inv_CountFreeSlots()
    $g_Inv_JustEquipped = 0
    Out("[Inv] Gestion de inventario (huecos libres: " & $free & ")")
    If Int(IniRead($g_InvIni, "Inventory", "AutoIdentifyEquip", "1")) = 1 Then _Inv_IdentifyAll()
    If Int(IniRead($g_InvIni, "Inventory", "AutoEquipPlayer", "1")) = 1 Then _Inv_AutoEquipPlayer()
    If Int(IniRead($g_InvIni, "Inventory", "AutoDestroyTrash", "1"))  = 1 Then _Inv_DestroyTrash()
    If $free <= $minFree Then
        Out("[Inv] Inventario casi lleno (" & $free & " huecos <= " & $minFree & "). Vender sobrante...")
        If Int(IniRead($g_InvIni, "Inventory", "AutoSell", "1"))        = 1 Then _Inv_SellAtKamadan()
    EndIf
    Out("[Inv] Gestion completa. Huecos libres ahora: " & _Inv_CountFreeSlots())
    $g_Inv_LastRun = TimerInit()
EndFunc
Func _Inv_CountFreeSlots()
    Local $total = 0
    For $bag = 1 To 4
        Local $empty = Item_GetBagInfo($bag, "EmptySlots")
        If $empty > 0 Then $total += $empty
    Next
    Return $total
EndFunc
Func _Inv_IdentifyAll()
    Local $count = 0
    For $bag = 1 To 4
        For $slot = 1 To 20
            Local $p = Item_GetItemBySlot($bag, $slot)
            If $p = 0 Then ContinueLoop
            If Not _Inv_IsEquipmentType(Item_GetItemInfoByPtr($p, "ItemType")) Then ContinueLoop
            If Item_GetItemInfoByPtr($p, "IsIdentified") Then ContinueLoop
            Local $id = Item_GetItemInfoByPtr($p, "ItemID")
            If Item_IdentifyItem($id) Then
                $count += 1
                Sleep(350)
            Else
                Out("[Inv] Sin kit de ID (o ya identificado) item id=" & $id)
            EndIf
            If Bot_ShouldStop() Then Return
        Next
    Next
    If $count > 0 Then Out("[Inv] Identificados " & $count & " objetos de equipo")
EndFunc
Func _Inv_ExpectedWeapon($prof, ByRef $type, ByRef $attrId)
    Switch $prof
        Case $GC_I_PROFESSION_DERVISH
            $type = $GC_I_TYPE_SCYTHE
            $attrId = $GC_I_ATTRIBUTE_SCYTHE_MASTERY
            Return True
    EndSwitch
    Return False
EndFunc
Func _Inv_AutoEquipPlayer()
    Local $prof = Agent_GetAgentInfo(-2, "Primary")
    Local $wantType, $attrId
    If Not _Inv_ExpectedWeapon($prof, $wantType, $attrId) Then
        Out("[Inv] Auto-equip: profesion " & $prof & " no soportada en v1 - skip")
        Return
    EndIf
    Local $attrLvl = Attribute_GetPartyAttributeInfo($attrId, 0, "BaseLevel")
    Local $curPtr = Item_GetInventoryInfo("WeaponSet0WeaponPtr")
    Local $curDmg = 0
    Local $hasWeapon = False
    If $curPtr <> 0 Then
        $curDmg = Item_GetItemMaxDmg($curPtr)
        If Item_GetItemInfoByPtr($curPtr, "ItemType") = $wantType Then $hasWeapon = True
    EndIf
    If $hasWeapon Then
        Out("[Inv] Auto-equip: char YA con arma de profesion -> NO tocar")
        Return
    EndIf
    Local $bestPtr = 0, $bestDmg = $curDmg, $bestRar = 0
    Local $fallbackPtr = 0
    For $bag = 1 To 4
        For $slot = 1 To 20
            Local $p = Item_GetItemBySlot($bag, $slot)
            If $p = 0 Then ContinueLoop
            If Item_GetItemInfoByPtr($p, "ItemType") <> $wantType Then ContinueLoop
            If Item_GetItemInfoByPtr($p, "Equipped") <> 0 Then ContinueLoop
            If $fallbackPtr = 0 Then $fallbackPtr = $p
            If Not Item_GetItemInfoByPtr($p, "IsIdentified") Then ContinueLoop
            Local $itemAttr = Item_GetItemAttribute($p)
            Local $itemReq  = Item_GetItemReq($p)
            If $itemAttr <> $attrId Then ContinueLoop
            If $itemReq > $attrLvl Then ContinueLoop
            Local $dmg = Item_GetItemMaxDmg($p)
            Local $rar = Item_GetItemInfoByPtr($p, "Rarity")
            If $dmg > $bestDmg Or ($dmg = $bestDmg And $rar > $bestRar) Then
                $bestPtr = $p
                $bestDmg = $dmg
                $bestRar = $rar
            EndIf
        Next
    Next
    Local $toEquip = $bestPtr
    If $toEquip = 0 And Not $hasWeapon And $fallbackPtr <> 0 Then
        $toEquip = $fallbackPtr
        Out("[Inv] Auto-equip: char SIN arma -> equipar arma de profesion (fallback, sin id ok)")
    EndIf
    If $toEquip = 0 Then
        Out("[Inv] Auto-equip: ninguna arma mejor (actual dmg=" & $curDmg & ", attrLvl=" & $attrLvl & ")")
        Return
    EndIf
    Out("[Inv] Auto-equip arma: dmg " & $curDmg & " -> " & Item_GetItemMaxDmg($toEquip) & " (req<=" & $attrLvl & ")")
    $g_Inv_JustEquipped = Item_GetItemInfoByPtr($toEquip, "ItemID")
    Item_EquipItem($toEquip)
    Sleep(800)
    Core_ControlAction($GC_I_CONTROL_INVENTORY_ACTIVATE_WEAPON_SET_1)
    Sleep(500)
EndFunc
Func _Inv_DestroyTrash()
    Local $count = 0
    Local $protType = -1
    Local $protWantType, $protAttr
    If _Inv_ExpectedWeapon(Agent_GetAgentInfo(-2, "Primary"), $protWantType, $protAttr) Then
        Local $pw = Item_GetInventoryInfo("WeaponSet0WeaponPtr")
        Local $hasProf = ($pw <> 0 And Item_GetItemInfoByPtr($pw, "ItemType") = $protWantType)
        If Not $hasProf Then $protType = $protWantType  
    EndIf
    For $bag = 1 To 4
        For $slot = 1 To 20
            Local $p = Item_GetItemBySlot($bag, $slot)
            If $p = 0 Then ContinueLoop
            Local $t = Item_GetItemInfoByPtr($p, "ItemType")
            If $t = $protType Then
                Out("[Inv] Proteger arma de profesion (char sin arma) type=" & $t & " - NO destruir")
                ContinueLoop
            EndIf
            If _Inv_IsProtectedModel(Item_GetItemInfoByPtr($p, "ModelID")) Then
                Out("[Inv] Conset/protegido model=" & Item_GetItemInfoByPtr($p, "ModelID") & " - NO destruir")
                ContinueLoop
            EndIf
            Local $dVal  = Item_GetItemInfoByPtr($p, "Value")
            Local $dIdf  = Item_GetItemInfoByPtr($p, "IsIdentified")
            Local $dEqp  = Item_GetItemInfoByPtr($p, "Equipped")
            Local $dMdl  = Item_GetItemInfoByPtr($p, "ModelID")
            Local $isWeap = _Inv_IsWeaponType($t)
            Local $dCust = Item_GetItemInfoByPtr($p, "Customized")  
            Local $skip = ""
            If Not _Inv_IsEquipmentType($t) Then $skip = "no-equipo"
            If $skip = "" And $dCust <> 0 Then $skip = "customizado"   
            If $skip = "" And Not $isWeap And Not $dIdf Then $skip = "armadura-sin-id"
            If $skip = "" And $dEqp <> 0 Then $skip = "equipado"
            If $skip = "" And $dVal <> 0 Then $skip = "value>0"
            Out("[Inv-dump] bag=" & $bag & " slot=" & $slot & " type=" & $t & _
                " model=" & $dMdl & " value=" & $dVal & " idf=" & $dIdf & _
                " eqp=" & $dEqp & " weap=" & $isWeap & " cust=" & $dCust & (($skip = "") ? " -> DESTRUIR" : " -> skip(" & $skip & ")"))
            If Not _Inv_IsEquipmentType($t) Then ContinueLoop          
            If $dCust <> 0 Then ContinueLoop                            
            If Not $isWeap And Not Item_GetItemInfoByPtr($p, "IsIdentified") Then ContinueLoop 
            If Item_GetItemInfoByPtr($p, "Equipped") <> 0 Then ContinueLoop
            If Item_GetItemInfoByPtr($p, "Value") <> 0 Then ContinueLoop 
            Local $id = Item_GetItemInfoByPtr($p, "ItemID")
            If $id = $g_Inv_JustEquipped Then ContinueLoop
            Out("[Inv] Destruir basura no vendible id=" & $id & " type=" & $t)
            Item_DestroyItem($id)
            $count += 1
            Sleep(250)
            If Bot_ShouldStop() Then Return
        Next
    Next
    If $count > 0 Then Out("[Inv] Destruidos " & $count & " objetos basura")
EndFunc
Func _Inv_SellAtKamadan()
    Local $merchModel = Int(IniRead($g_InvIni, "Inventory", "KamadanMerchantModel", "0"))
    If $merchModel <= 0 Then
        Out("[Inv] Venta: KamadanMerchantModel sin configurar (0) - capturar model del mercader in-game. Skip.")
        Return
    EndIf
    Local $map = Map_GetMapID()
    If $map <> $INV_KAMADAN_MAP Then
        Local $agsLocal = Agent_GetAgentArray($GC_I_AGENT_TYPE_LIVING)
        If IsArray($agsLocal) Then
            For $iL = 1 To $agsLocal[0]
                If $agsLocal[$iL] = 0 Then ContinueLoop
                Local $mMatch = (Agent_GetAgentInfo($agsLocal[$iL], "PlayerNumber") = $merchModel)
                If Not $mMatch And StringInStr(Agent_GetAgentInfo($agsLocal[$iL], "Name"), "Merchant") Then
                    $merchModel = Agent_GetAgentInfo($agsLocal[$iL], "PlayerNumber")
                    Out("[Inv] Venta: mercader local por NOMBRE model=" & $merchModel)
                    $mMatch = True
                EndIf
                If $mMatch Then
                    Out("[Inv] Venta: mercader model=" & $merchModel & " encontrado en outpost actual (map=" & $map & ")")
                    $map = $INV_KAMADAN_MAP  
                    ExitLoop
                EndIf
            Next
        EndIf
    EndIf
    If $map <> $INV_KAMADAN_MAP Then
        If Int(IniRead($g_InvIni, "Inventory", "SellTravelToKamadan", "0")) = 1 Then
            Out("[Inv] Venta: viajando a Kamadan (449)...")
            Travel_ToOutpost($INV_KAMADAN_MAP)
            Sleep(1500)
            $map = Map_GetMapID()
        EndIf
        If $map <> $INV_KAMADAN_MAP Then
            Out("[Inv] Venta: no estoy en Kamadan (map=" & $map & ") - pospuesta")
            Return
        EndIf
    EndIf
    Local $npc = GetNearestNPCToAgent(-2, 6000, $GC_I_AGENT_TYPE_LIVING, 1, "NPCFilter")
    Local $merch = 0
    If $npc <> 0 And Agent_GetAgentInfo($npc, "PlayerNumber") = $merchModel Then $merch = $npc
    If $merch = 0 Then
        Local $aArr = Agent_GetAgentArray($GC_I_AGENT_TYPE_LIVING)
        If IsArray($aArr) Then
            For $i = 1 To $aArr[0]
                If Agent_GetAgentInfo($aArr[$i], "PlayerNumber") = $merchModel Then
                    $merch = $aArr[$i]
                    ExitLoop
                EndIf
            Next
        EndIf
    EndIf
    If $merch = 0 Then
        Out("[Inv] Venta: mercader model " & $merchModel & " no encontrado en Kamadan - skip")
        Return
    EndIf
    MoveTo(Agent_GetAgentInfo($merch, "X"), Agent_GetAgentInfo($merch, "Y"), 1250, 50)
    Sleep(500)
    Agent_GoNPC($merch)
    Sleep(1500)
    If Merchant_GetMerchantItemsBase() = 0 Then
        Out("[Inv] Venta: panel de mercader no se abrio - reintento")
        Agent_GoNPC($merch)
        Sleep(1500)
        If Merchant_GetMerchantItemsBase() = 0 Then
            Out("[Inv] Venta: mercader sigue cerrado - skip")
            Return
        EndIf
    EndIf
    If Not _Inv_HasIdKit() Then
        Out("[Inv] Sin kit de ID -> comprando al mercader")
        Merchant_BuyItem($GC_I_MODELID_IDENTIFICATION_KIT)
        Sleep(1200)
    EndIf
    _Inv_IdentifyAll()
    Sleep(500)
    Local $inv = Item_GetInventoryArray()
    Local $count = 0
    For $i = 0 To UBound($inv) - 1
        Local $rar = $inv[$i][$GC_I_INVENTORY_RARITY]
        Local $val = $inv[$i][$GC_I_INVENTORY_VALUE]
        Local $mid = $inv[$i][$GC_I_INVENTORY_MODELID]
        Local $ptr = $inv[$i][$GC_I_INVENTORY_PTR]
        If $rar = $GC_I_RARITY_GOLD Or $rar = $GC_I_RARITY_GREEN Then ContinueLoop
        If _Inv_IsKitModel($mid) Then ContinueLoop
        If _Inv_IsProtectedModel($mid) Then ContinueLoop   
        If $val <= 0 Then ContinueLoop
        If Item_GetItemInfoByPtr($ptr, "Equipped") <> 0 Then ContinueLoop
        If Item_GetItemInfoByPtr($ptr, "ItemID") = $g_Inv_JustEquipped Then ContinueLoop
        Merchant_SellItem($ptr)
        $count += 1
        Sleep(450)
        If Bot_ShouldStop() Then ExitLoop
    Next
    Out("[Inv] Vendidos " & $count & " objetos al mercader")
EndFunc
Func _Inv_HasIdKit()
    Local $inv = Item_GetInventoryArray()
    For $i = 0 To UBound($inv) - 1
        Local $mid = $inv[$i][$GC_I_INVENTORY_MODELID]
        If $mid = $GC_I_MODELID_IDENTIFICATION_KIT Or $mid = $GC_I_MODELID_SUPERIOR_IDENTIFICATION_KIT Then Return True
    Next
    Return False
EndFunc
Func _Inv_IsKitModel($a_i_ModelID)
    Switch $a_i_ModelID
        Case $GC_I_MODELID_SALVAGE_KIT, $GC_I_MODELID_EXPERT_SALVAGE_KIT, _
             $GC_I_MODELID_SUPERIOR_SALVAGE_KIT, $GC_I_MODELID_PERFECT_SALVAGE_KIT, _
             $GC_I_MODELID_CHARR_SALVAGE_KIT, $GC_I_MODELID_IDENTIFICATION_KIT, _
             $GC_I_MODELID_SUPERIOR_IDENTIFICATION_KIT
            Return True
    EndSwitch
    Return False
EndFunc
Global $g_Inv_SummonStoneArmed = False
Global Const $INV_SUMMON_STONE_MODEL = 30847   
Func _Inv_UseIgneousSummonStone()
    Local $mtype = Map_GetInstanceInfo("Type")
    If $mtype = $GC_I_MAP_TYPE_OUTPOST Then
        $g_Inv_SummonStoneArmed = True
        Return
    EndIf
    If Not $g_Inv_SummonStoneArmed Then Return
    If $mtype <> $GC_I_MAP_TYPE_EXPLORABLE Then Return  
    Local $itemID = 0
    Local $inv = Item_GetInventoryArray()
    If IsArray($inv) Then
        For $i = 0 To UBound($inv) - 1
            If $inv[$i][$GC_I_INVENTORY_MODELID] = $INV_SUMMON_STONE_MODEL Then
                $itemID = $inv[$i][$GC_I_INVENTORY_ITEMID]
                ExitLoop
            EndIf
        Next
    EndIf
    If $itemID = 0 Then Return  
    Item_UseItem($itemID)
    $g_Inv_SummonStoneArmed = False
    Out("[Inv] Piedra de Invocación Ígnea usada (1x al salir del outpost)")
EndFunc