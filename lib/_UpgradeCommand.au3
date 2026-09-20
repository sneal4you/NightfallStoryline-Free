#include-once
Global $__BIA_ASLRSlide = -1
Func _BIA_ASLRSlide()
    If $__BIA_ASLRSlide >= 0 Then Return $__BIA_ASLRSlide
    $__BIA_ASLRSlide = 0
    Local $base = Scanner_GWModuleBase()
    If $base > 0 Then $__BIA_ASLRSlide = $base - 0x400000
    Out("[APPLYC] ASLR slide gw.exe = +0x" & Hex($__BIA_ASLRSlide) & " (base 0x" & Hex($base, 8) & ")")
    Return $__BIA_ASLRSlide
EndFunc
Global $g_b_UpgradeCommand = True
Func Assembler_UpgradeRegisterLabels()
    Local $i_Slide = _BIA_ASLRSlide()
    Memory_SetValue('UpgradeFlatToId', Ptr(0x845610 + $i_Slide))
    Memory_SetValue('UpgradeOpen', Ptr(0x847b60 + $i_Slide))
    Memory_SetValue('UpgradeSpecify', Ptr(0x847b00 + $i_Slide))
    Memory_SetValue('UpgradeCommit', Ptr(0x847c10 + $i_Slide))
    Log_Debug("UpgradeFlatToId=" & Memory_GetValue('UpgradeFlatToId') & _
        " Open=" & Memory_GetValue('UpgradeOpen') & _
        " Specify=" & Memory_GetValue('UpgradeSpecify') & _
        " Commit=" & Memory_GetValue('UpgradeCommit'), "UpgradeCmd", $g_h_EditText)
EndFunc
Func Extend_UpgradeCommandData()
    Assembler_UpgradeRegisterLabels()
    Assembler_CreateUpgradeCommand()
EndFunc
Func Assembler_CreateUpgradeCommand()
    _('CommandUpgradeOpen:')
    _('mov esi,dword[eax+4]')      
    _('push esi')
    _('call UpgradeFlatToId')
    _('add esp,4')
    _('push esi')
    _('push eax')
    _('call UpgradeOpen')
    _('add esp,8')
    _('ljmp CommandReturn')
    _('CommandUpgradeSpecify:')
    _('mov ebx,dword[eax+8]')      
    _('push ebx')
    _('call UpgradeFlatToId')
    _('add esp,4')
    _('push ebx')
    _('push eax')
    _('call UpgradeSpecify')
    _('add esp,8')
    _('ljmp CommandReturn')
    _('CommandUpgradeCommit:')
    _('call UpgradeCommit')
    _('ljmp CommandReturn')
EndFunc
Func Item_UpgradeEnqueue($a_s_Label, $a_i_ArmorFlat, $a_i_RuneFlat)
    Local $i_Cmd = Memory_GetValue($a_s_Label)
    If $i_Cmd <= 0 Then Return SetError(1, 0, False)
    Local $d_Cmd = DllStructCreate('ptr;dword;dword')
    DllStructSetData($d_Cmd, 1, $i_Cmd)
    DllStructSetData($d_Cmd, 2, $a_i_ArmorFlat)
    DllStructSetData($d_Cmd, 3, $a_i_RuneFlat)
    Core_Enqueue(DllStructGetPtr($d_Cmd), 12)
    Return True
EndFunc
Func Item_ApplyUpgradeInternal($a_i_ArmorFlat, $a_i_RuneFlat)
    Item_UseItem($a_i_RuneFlat)
    Sleep(900)
    If Not Item_UpgradeEnqueue('CommandUpgradeOpen', $a_i_ArmorFlat, $a_i_RuneFlat) Then Return SetError(1, 0, False)
    Return True
EndFunc