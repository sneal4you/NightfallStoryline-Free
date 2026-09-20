#include-once
Func Utils_FloatToInt($a_f_Float)
    Local $l_d_Float = DllStructCreate("float")
    Local $l_d_Int = DllStructCreate("int", DllStructGetPtr($l_d_Float))
    DllStructSetData($l_d_Float, 1, $a_f_Float)
    Return DllStructGetData($l_d_Int, 1)
EndFunc
Func Utils_IntToFloat($a_i_Int)
    Local $l_d_Int = DllStructCreate("int")
    Local $l_d_Float = DllStructCreate("float", DllStructGetPtr($l_d_Int))
    DllStructSetData($l_d_Int, 1, $a_i_Int)
    Return DllStructGetData($l_d_Float, 1)
EndFunc
Func Utils_Bin64ToDec($a_s_Binary)
    Local $l_i_Return = 0
    Local $l_i_Power = 1
    For $i = 1 To StringLen($a_s_Binary)
        If StringMid($a_s_Binary, $i, 1) = "1" Then
            $l_i_Return += $l_i_Power
        EndIf
        $l_i_Power *= 2
    Next
    Return $l_i_Return
EndFunc
Func Utils_Base64ToBin64($a_s_Character)
    Local $l_i_Index = StringInStr("ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789+/", $a_s_Character, 1) - 1
    If $l_i_Index < 0 Then Return SetError(1, 0, "")
    Return $GC_AS_BASE64_BINARY_GW[$l_i_Index]
EndFunc
Func Utils_ArrayAdd2D(ByRef $a_amx2_Array, $a_v_Val1, $a_v_Val2)
    Local $l_i_Idx = UBound($a_amx2_Array)
    ReDim $a_amx2_Array[$l_i_Idx + 1][2]
    $a_amx2_Array[$l_i_Idx][0] = $a_v_Val1
    $a_amx2_Array[$l_i_Idx][1] = $a_v_Val2
EndFunc
Func Utils_UnsignedCompare($a_i_A, $a_i_B)
    $a_i_A = BitAND($a_i_A, 0xFFFFFFFF)
    $a_i_B = BitAND($a_i_B, 0xFFFFFFFF)
    If $a_i_A = $a_i_B Then Return 0
    Return ($a_i_A > $a_i_B And $a_i_A - $a_i_B < 0x80000000) Or ($a_i_B > $a_i_A And $a_i_B - $a_i_A > 0x80000000) ? 1 : -1
EndFunc
Func Utils_MakeInt32($a_i_Value)
    Local $l_i_Val = BitAND($a_i_Value, 0xFFFFFFFF)
    If BitAND($l_i_Val, 0x80000000) Then
        Return BitOR($l_i_Val, 0xFFFFFFFF00000000)
    Else
        Return $l_i_Val
    EndIf
EndFunc
Func Utils_StringToByteArray($a_s_HexString)
    Local $l_i_Length = StringLen($a_s_HexString) / 2
    Local $l_ax_Bytes[$l_i_Length]
    For $l_i_Index = 0 To $l_i_Length - 1
        Local $l_s_HexByte = StringMid($a_s_HexString, ($l_i_Index * 2) + 1, 2)
        $l_ax_Bytes[$l_i_Index] = Dec($l_s_HexByte)
    Next
    Return $l_ax_Bytes
EndFunc
Func Utils_StringToBytes($a_s_Str)
    Local $l_i_Len = StringLen($a_s_Str) + 1
    Local $l_d_Struct = DllStructCreate("byte[" & $l_i_Len & "]")
    For $l_i_Index = 1 To StringLen($a_s_Str)
        DllStructSetData($l_d_Struct, 1, Asc(StringMid($a_s_Str, $l_i_Index, 1)), $l_i_Index)
    Next
    DllStructSetData($l_d_Struct, 1, 0, $l_i_Len)
    Local $l_ax_Result = DllStructGetData($l_d_Struct, 1)
    Return $l_ax_Result
EndFunc
Func Utils_SwapEndian($a_s_Hex)
    Return StringMid($a_s_Hex, 7, 2) & StringMid($a_s_Hex, 5, 2) & StringMid($a_s_Hex, 3, 2) & StringMid($a_s_Hex, 1, 2)
EndFunc
Func Utils_TList_CreateIterator($a_p_TListPtr)
    Local $l_a_Iterator[3]
    Local $l_p_Sentinel = $a_p_TListPtr + 0x4
    $l_a_Iterator[0] = $l_p_Sentinel
    $l_a_Iterator[1] = $l_p_Sentinel
    $l_a_Iterator[2] = 0
    Return $l_a_Iterator
EndFunc
Func Utils_TList_Iterator_Current(ByRef $a_a_Iterator)
    Local $l_p_CurrentTLink = $a_a_Iterator[0]
    Local $l_p_NextNode = Memory_Read($l_p_CurrentTLink + 0x4, "ptr")
    If BitAND($l_p_NextNode, 1) Then Return 0
    Return $l_p_NextNode
EndFunc
Func Utils_TList_Iterator_Next(ByRef $a_a_Iterator)
    Local $l_p_CurrentTLink = $a_a_Iterator[0]
    Local $l_p_FirstTLink = $a_a_Iterator[1]
    Local $l_p_NextLink = Utils_TLink_GetNextLink($l_p_CurrentTLink)
    If $l_p_NextLink = $l_p_FirstTLink Then
        $a_a_Iterator[2] += 1
    EndIf
    $a_a_Iterator[0] = $l_p_NextLink
    Local $l_p_NextNode = Memory_Read($l_p_NextLink + 0x4, "ptr")
    If BitAND($l_p_NextNode, 1) Or $l_p_NextNode = 0 Then
        Return False
    EndIf
    Return True
EndFunc
Func Utils_TLink_IsLinked($a_p_TLink)
    Local $l_p_PrevLink = Memory_Read($a_p_TLink, "ptr")
    Return $l_p_PrevLink <> $a_p_TLink
EndFunc
Func Utils_TLink_GetNextLink($a_p_TLink)
    Local $l_p_PrevLink = Memory_Read($a_p_TLink, "ptr")
    Local $l_p_NextNode = Memory_Read($a_p_TLink + 0x4, "ptr")
    Local $l_p_PrevNextNode = Memory_Read($l_p_PrevLink + 0x4, "ptr")
    Local $l_p_PrevNextClean = BitAND($l_p_PrevNextNode, 0xFFFFFFFE)
    Local $l_i_Offset = $a_p_TLink - $l_p_PrevNextClean
    Local $l_p_NextClean = BitAND($l_p_NextNode, 0xFFFFFFFE)
    Return $l_p_NextClean + $l_i_Offset
EndFunc
Func Utils_TLink_GetNext($a_p_TLink)
    Local $l_p_NextNode = Memory_Read($a_p_TLink + 0x4, "ptr")
    If BitAND($l_p_NextNode, 1) Then Return 0
    Return $l_p_NextNode
EndFunc
Func Utils_TLink_GetPrev($a_p_TLink)
    Local $l_p_PrevLink = Memory_Read($a_p_TLink, "ptr")
    Local $l_p_PrevPrevLink = Memory_Read($l_p_PrevLink, "ptr")
    Local $l_p_PrevNode = Memory_Read($l_p_PrevPrevLink + 0x4, "ptr")
    If BitAND($l_p_PrevNode, 1) Then Return 0
    Return $l_p_PrevNode
EndFunc
Func Utils_Array_Create($a_p_ArrayPtr)
    Return $a_p_ArrayPtr
EndFunc
Func Utils_Array_GetBuffer($a_p_Array)
    Return Memory_Read($a_p_Array, "ptr")
EndFunc
Func Utils_Array_GetCapacity($a_p_Array)
    Return Memory_Read($a_p_Array + 0x4, "dword")
EndFunc
Func Utils_Array_GetSize($a_p_Array)
    Return Memory_Read($a_p_Array + 0x8, "dword")
EndFunc
Func Utils_Array_GetParam($a_p_Array)
    Return Memory_Read($a_p_Array + 0xC, "dword")
EndFunc
Func Utils_Array_IsValid($a_p_Array)
    Local $l_p_Buffer = Utils_Array_GetBuffer($a_p_Array)
    Return $l_p_Buffer <> 0
EndFunc
Func Utils_Array_At($a_p_Array, $a_i_Index, $a_s_Type = "ptr", $a_i_ElementSize = 4)
    Local $l_i_Size = Utils_Array_GetSize($a_p_Array)
    If $a_i_Index < 0 Or $a_i_Index >= $l_i_Size Then
        Return 0  
    EndIf
    Local $l_p_Buffer = Utils_Array_GetBuffer($a_p_Array)
    If $l_p_Buffer = 0 Then Return 0  
    Local $l_p_Element = $l_p_Buffer + ($a_i_Index * $a_i_ElementSize)
    Return Memory_Read($l_p_Element, $a_s_Type)
EndFunc
Func Utils_Array_Set($a_p_Array, $a_i_Index, $a_Value, $a_s_Type = "ptr", $a_i_ElementSize = 4)
    Local $l_i_Size = Utils_Array_GetSize($a_p_Array)
    If $a_i_Index < 0 Or $a_i_Index >= $l_i_Size Then
        Return False  
    EndIf
    Local $l_p_Buffer = Utils_Array_GetBuffer($a_p_Array)
    If $l_p_Buffer = 0 Then Return False  
    Local $l_p_Element = $l_p_Buffer + ($a_i_Index * $a_i_ElementSize)
    Memory_Write($l_p_Element, $a_Value, $a_s_Type)
    Return True
EndFunc
Func Utils_Array_CreateIterator($a_p_Array, $a_i_ElementSize = 4)
    Local $l_a_Iterator[3]
    $l_a_Iterator[0] = 0                
    $l_a_Iterator[1] = $a_p_Array       
    $l_a_Iterator[2] = $a_i_ElementSize 
    Return $l_a_Iterator
EndFunc
Func Utils_Array_Iterator_HasNext(ByRef $a_a_Iterator)
    Local $l_i_CurrentIndex = $a_a_Iterator[0]
    Local $l_p_Array = $a_a_Iterator[1]
    Local $l_i_Size = Utils_Array_GetSize($l_p_Array)
    Return $l_i_CurrentIndex < $l_i_Size
EndFunc
Func Utils_Array_Iterator_Next(ByRef $a_a_Iterator, $a_s_Type = "ptr")
    If Not Utils_Array_Iterator_HasNext($a_a_Iterator) Then Return 0
    Local $l_i_CurrentIndex = $a_a_Iterator[0]
    Local $l_p_Array = $a_a_Iterator[1]
    Local $l_i_ElementSize = $a_a_Iterator[2]
    Local $l_Value = Utils_Array_At($l_p_Array, $l_i_CurrentIndex, $a_s_Type, $l_i_ElementSize)
    $a_a_Iterator[0] += 1
    Return $l_Value
EndFunc
Func Utils_Array_Iterator_Current(ByRef $a_a_Iterator, $a_s_Type = "ptr")
    If Not Utils_Array_Iterator_HasNext($a_a_Iterator) Then Return 0
    Local $l_i_CurrentIndex = $a_a_Iterator[0]
    Local $l_p_Array = $a_a_Iterator[1]
    Local $l_i_ElementSize = $a_a_Iterator[2]
    Return Utils_Array_At($l_p_Array, $l_i_CurrentIndex, $a_s_Type, $l_i_ElementSize)
EndFunc
Func Utils_Array_Iterator_Reset(ByRef $a_a_Iterator)
    $a_a_Iterator[0] = 0
EndFunc
Func Utils_Array_ToAutoItArray($a_p_Array, $a_s_Type = "ptr", $a_i_ElementSize = 4)
    Local $l_i_Size = Utils_Array_GetSize($a_p_Array)
    If $l_i_Size = 0 Then Return 0
    Local $l_a_Result[$l_i_Size]
    For $i = 0 To $l_i_Size - 1
        $l_a_Result[$i] = Utils_Array_At($a_p_Array, $i, $a_s_Type, $a_i_ElementSize)
    Next
    Return $l_a_Result
EndFunc
Func Utils_Array_BoolAt($a_p_Array, $a_i_ArraySize, $a_i_Index)
    If $a_p_Array = 0 Then Return False
    Local $l_i_RealIndex = Floor($a_i_Index / 32)
    If $l_i_RealIndex >= $a_i_ArraySize Then Return False
    Local $l_i_Shift = Mod($a_i_Index, 32)
    Local $l_i_Flag = BitShift(1, -$l_i_Shift)  
    Local $l_i_Value = Memory_Read($a_p_Array + ($l_i_RealIndex * 4), "dword")
    Return BitAND($l_i_Value, $l_i_Flag) <> 0
EndFunc
#Region EncString Decoding
Func Utils_UInt32ToEncStr($a_i_Value)
    If $a_i_Value = 0 Then Return ""
    Local $l_i_CaseRequired = Ceiling($a_i_Value / $ENCSTR_WORD_VALUE_RANGE)
    If $l_i_CaseRequired = 0 Then $l_i_CaseRequired = 1
    Local $l_a_Chars[$l_i_CaseRequired]
    Local $l_i_Remaining = $a_i_Value
    For $i = $l_i_CaseRequired - 1 To 0 Step -1
        $l_a_Chars[$i] = $ENCSTR_WORD_VALUE_BASE + Mod($l_i_Remaining, $ENCSTR_WORD_VALUE_RANGE)
        $l_i_Remaining = Floor($l_i_Remaining / $ENCSTR_WORD_VALUE_RANGE)
        If $i <> $l_i_CaseRequired - 1 Then
            $l_a_Chars[$i] = BitOR($l_a_Chars[$i], $ENCSTR_WORD_BIT_MORE)
        EndIf
    Next
    Local $l_s_Result = ""
    For $i = 0 To $l_i_CaseRequired - 1
        $l_s_Result &= ChrW($l_a_Chars[$i])
    Next
    Return $l_s_Result
EndFunc
Func Utils_DecodeStringID($a_i_StringID, $a_i_Timeout = 1000)
    If $a_i_StringID = 0 Then Return ""
    Local $l_s_EncStr = Utils_UInt32ToEncStr($a_i_StringID)
    If $l_s_EncStr = "" Then Return ""
    DllStructSetData($g_d_DecodeEncString, 2, $l_s_EncStr)
    Memory_Write($g_p_DecodeReady, 0, "dword")
    Core_Enqueue($g_p_DecodeEncString, DllStructGetSize($g_d_DecodeEncString))
    Local $l_i_StartTime = TimerInit()
    While TimerDiff($l_i_StartTime) < $a_i_Timeout
        If Memory_Read($g_p_DecodeReady, "dword") = 1 Then
            Local $l_s_Decoded = Memory_Read($g_p_DecodeOutputPtr, "wchar[1024]")
            Return $l_s_Decoded
        EndIf
        Sleep(16)
    WEnd
    Return ""
EndFunc
Func Utils_SkillDecodeStringID($a_i_StringID, $a_i_Timeout = 1000)
    If $a_i_StringID = 0 Then Return ""
    Local $l_s_EncStr = Utils_UInt32ToEncStr($a_i_StringID)
    If $l_s_EncStr = "" Then Return ""
    $l_s_EncStr &= ChrW(0x10A)  
    $l_s_EncStr &= ChrW(0x104)  
    $l_s_EncStr &= ChrW(0x101)  
    $l_s_EncStr &= ChrW(0x100 + 991)  
    $l_s_EncStr &= ChrW(0x01)  
    $l_s_EncStr &= ChrW(0x10B)  
    $l_s_EncStr &= ChrW(0x104)
    $l_s_EncStr &= ChrW(0x101)
    $l_s_EncStr &= ChrW(0x100 + 992)  
    $l_s_EncStr &= ChrW(0x01)
    $l_s_EncStr &= ChrW(0x10C)  
    $l_s_EncStr &= ChrW(0x104)
    $l_s_EncStr &= ChrW(0x101)
    $l_s_EncStr &= ChrW(0x100 + 993)  
    $l_s_EncStr &= ChrW(0x01)
    DllStructSetData($g_d_DecodeEncString, 2, $l_s_EncStr)
    Memory_Write($g_p_DecodeReady, 0, "dword")
    Core_Enqueue($g_p_DecodeEncString, DllStructGetSize($g_d_DecodeEncString))
    Local $l_i_StartTime = TimerInit()
    While TimerDiff($l_i_StartTime) < $a_i_Timeout
        If Memory_Read($g_p_DecodeReady, "dword") = 1 Then
            Local $l_s_Decoded = Memory_Read($g_p_DecodeOutputPtr, "wchar[1024]")
            Return $l_s_Decoded
        EndIf
        Sleep(16)
    WEnd
    Return ""
EndFunc
Func Utils_DecodeEncString($a_p_Ptr)
    If $a_p_Ptr = 0 Then Return 0
    Local $l_i_Val = 0
    Local $l_i_Offset = 0
    Local $l_i_MaxIter = 10  
    For $i = 1 To $l_i_MaxIter
        Local $l_i_Char = Memory_Read($a_p_Ptr + $l_i_Offset, "word")
        If $l_i_Char < $ENCSTR_WORD_VALUE_BASE Then ExitLoop
        $l_i_Val *= $ENCSTR_WORD_VALUE_RANGE
        $l_i_Val += BitAND($l_i_Char, BitNOT($ENCSTR_WORD_BIT_MORE)) - $ENCSTR_WORD_VALUE_BASE
        $l_i_Offset += 2
        If BitAND($l_i_Char, $ENCSTR_WORD_BIT_MORE) = 0 Then ExitLoop
    Next
    Return $l_i_Val
EndFunc
Func Utils_DecodeEncStringAsync($a_p_Ptr, $a_i_Timeout = 1000)
    If $a_p_Ptr = 0 Then Return ""
    Local $l_s_EncStr = Memory_Read($a_p_Ptr, "wchar[128]")
    If $l_s_EncStr = "" Then Return ""
    DllStructSetData($g_d_DecodeEncString, 2, $l_s_EncStr)
    Memory_Write($g_p_DecodeReady, 0, "dword")
    Core_Enqueue($g_p_DecodeEncString, DllStructGetSize($g_d_DecodeEncString))
    Local $l_i_StartTime = TimerInit()
    While TimerDiff($l_i_StartTime) < $a_i_Timeout
        If Memory_Read($g_p_DecodeReady, "dword") = 1 Then
            Local $l_s_Decoded = Memory_Read($g_p_DecodeOutputPtr, "wchar[1024]")
            Return $l_s_Decoded
        EndIf
        Sleep(16)
    WEnd
    Return ""
EndFunc
Func Utils_DecodeEncStringDirect($a_s_EncStr, $a_i_Timeout = 1000)
    If $a_s_EncStr = "" Then Return ""
    DllStructSetData($g_d_DecodeEncString, 2, $a_s_EncStr)
    Memory_Write($g_p_DecodeReady, 0, "dword")
    Core_Enqueue($g_p_DecodeEncString, DllStructGetSize($g_d_DecodeEncString))
    Local $l_i_StartTime = TimerInit()
    While TimerDiff($l_i_StartTime) < $a_i_Timeout
        If Memory_Read($g_p_DecodeReady, "dword") = 1 Then
            Local $l_s_Decoded = Memory_Read($g_p_DecodeOutputPtr, "wchar[1024]")
            Return $l_s_Decoded
        EndIf
        DllCall("kernel32.dll", "none", "Sleep", "dword", 10)
    WEnd
    Return ""
EndFunc
#EndRegion EncString Decoding