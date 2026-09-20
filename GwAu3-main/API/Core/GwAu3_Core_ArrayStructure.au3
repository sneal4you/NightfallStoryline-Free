#include-once
Func Memory_CreateArrayStructure($a_a_Definition, $a_i_ElementSize)
    Local $l_a_StructInfo = Memory_CreateStructure($a_a_Definition)
    If @error Then Return SetError(1, 0, 0)
    Local $l_a_ArrayStructInfo[5]
    $l_a_ArrayStructInfo[0] = $l_a_StructInfo[0]  
    $l_a_ArrayStructInfo[1] = $l_a_StructInfo[1]  
    $l_a_ArrayStructInfo[2] = $l_a_StructInfo[2]  
    $l_a_ArrayStructInfo[3] = $l_a_StructInfo[3]  
    $l_a_ArrayStructInfo[4] = $a_i_ElementSize    
    Return $l_a_ArrayStructInfo
EndFunc
Func Memory_ReadPointerArrayStruct($a_p_PointerArrayBase, $a_i_ArraySize, ByRef $a_a_StructInfo)
    If Not IsArray($a_a_StructInfo) Then Return SetError(1, 0, 0)
    If $a_i_ArraySize <= 0 Then Return SetError(2, 0, 0)
    Local $l_i_FieldCount = $a_a_StructInfo[3]
    Local $l_a_FieldIndices = $a_a_StructInfo[2]
    Local $l_d_PointerBuffer = DllStructCreate("ptr[" & $a_i_ArraySize & "]")
    Local $l_a_Call = DllCall($g_h_Kernel32, "bool", "ReadProcessMemory", _
        "handle", $g_h_GWProcess, _
        "ptr", $a_p_PointerArrayBase, _
        "struct*", $l_d_PointerBuffer, _
        "ulong_ptr", 4 * $a_i_ArraySize, _ 
        "ulong_ptr*", 0)
    If @error Or Not $l_a_Call[0] Then Return SetError(3, 0, 0)
    Local $l_i_ValidCount = 0
    For $i = 1 To $a_i_ArraySize
        If DllStructGetData($l_d_PointerBuffer, 1, $i) <> 0 Then
            $l_i_ValidCount += 1
        EndIf
    Next
    If $l_i_ValidCount = 0 Then Return SetError(4, 0, 0)
    Local $l_a_Results[$l_i_ValidCount][$l_i_FieldCount + 1] 
    Local $l_t_Struct = $a_a_StructInfo[0]
    Local $l_i_ResultIndex = 0
    For $i = 1 To $a_i_ArraySize
        Local $l_p_StructPtr = DllStructGetData($l_d_PointerBuffer, 1, $i)
        If $l_p_StructPtr = 0 Then ContinueLoop
        Local $l_a_Call = DllCall($g_h_Kernel32, "bool", "ReadProcessMemory", _
            "handle", $g_h_GWProcess, _
            "ptr", $l_p_StructPtr, _
            "struct*", $l_t_Struct, _
            "ulong_ptr", $a_a_StructInfo[1], _
            "ulong_ptr*", 0)
        If @error Or Not $l_a_Call[0] Then ContinueLoop
        $l_a_Results[$l_i_ResultIndex][0] = $l_p_StructPtr
        For $j = 0 To $l_i_FieldCount - 1
            $l_a_Results[$l_i_ResultIndex][$j + 1] = DllStructGetData($l_t_Struct, $l_a_FieldIndices[$j])
        Next
        $l_i_ResultIndex += 1
    Next
    Return $l_a_Results
EndFunc
Func Memory_ReadArrayStruct($a_p_ArrayBase, $a_i_ArraySize, ByRef $l_a_ArrayStructInfo)
    If Not IsArray($l_a_ArrayStructInfo) Then Return SetError(1, 0, 0)
    If $a_i_ArraySize <= 0 Then Return SetError(2, 0, 0)
    Local $l_i_FieldCount = $l_a_ArrayStructInfo[3]
    Local $l_i_ElementSize = $l_a_ArrayStructInfo[4]
    Local $l_a_FieldIndices = $l_a_ArrayStructInfo[2]
    Local $l_a_Results[$a_i_ArraySize][$l_i_FieldCount]
    Local $l_t_Struct = $l_a_ArrayStructInfo[0]
    For $i = 0 To $a_i_ArraySize - 1
        Local $l_p_CurrentElement = $a_p_ArrayBase + ($i * $l_i_ElementSize)
        Local $aCall = DllCall($g_h_Kernel32, "bool", "ReadProcessMemory", _
            "handle", $g_h_GWProcess, _
            "ptr", $l_p_CurrentElement, _
            "struct*", $l_t_Struct, _
            "ulong_ptr", $l_a_ArrayStructInfo[1], _
            "ulong_ptr*", 0)
        If @error Or Not $aCall[0] Then ContinueLoop
        For $j = 0 To $l_i_FieldCount - 1
            $l_a_Results[$i][$j] = DllStructGetData($l_t_Struct, $l_a_FieldIndices[$j])
        Next
    Next
    Return $l_a_Results
EndFunc
Func Memory_ReadArrayStructFields($a_p_ArrayBase, $a_i_ArraySize, ByRef $l_a_ArrayStructInfo, $a_s_Fields)
    If Not IsArray($l_a_ArrayStructInfo) Then Return SetError(1, 0, 0)
    If $a_i_ArraySize <= 0 Then Return SetError(2, 0, 0)
    Local $l_i_ElementSize = $l_a_ArrayStructInfo[4]
    Local $l_a_RequestedFields = StringSplit($a_s_Fields, "|", 2)
    Local $l_i_RequestedCount = UBound($l_a_RequestedFields)
    Local $l_a_Results[$a_i_ArraySize][$l_i_RequestedCount]
    Local $l_t_Struct = $l_a_ArrayStructInfo[0]
    For $i = 0 To $a_i_ArraySize - 1
        Local $l_p_CurrentElement = $a_p_ArrayBase + ($i * $l_i_ElementSize)
        DllCall($g_h_Kernel32, "bool", "ReadProcessMemory", _
            "handle", $g_h_GWProcess, _
            "ptr", $l_p_CurrentElement, _
            "struct*", $l_t_Struct, _
            "ulong_ptr", $l_a_ArrayStructInfo[1], _
            "ulong_ptr*", 0)
        For $j = 0 To $l_i_RequestedCount - 1
            $l_a_Results[$i][$j] = DllStructGetData($l_t_Struct, $l_a_RequestedFields[$j])
        Next
    Next
    Return $l_a_Results
EndFunc
Func Memory_ReadArrayStructFiltered($a_p_ArrayBase, $a_i_ArraySize, ByRef $l_a_ArrayStructInfo, $a_s_FilterField, $a_v_FilterValue, $a_i_FilterOperator = 0)
    If Not IsArray($l_a_ArrayStructInfo) Then Return SetError(1, 0, 0)
    If $a_i_ArraySize <= 0 Then Return SetError(2, 0, 0)
    Local $l_i_FieldCount = $l_a_ArrayStructInfo[3]
    Local $l_i_ElementSize = $l_a_ArrayStructInfo[4]
    Local $l_a_FieldIndices = $l_a_ArrayStructInfo[2]
    Local $l_i_MatchCount = 0
    Local $l_t_Struct = $l_a_ArrayStructInfo[0]
    Local $l_a_Matches[$a_i_ArraySize]
    For $i = 0 To $a_i_ArraySize - 1
        Local $l_p_CurrentElement = $a_p_ArrayBase + ($i * $l_i_ElementSize)
        DllCall($g_h_Kernel32, "bool", "ReadProcessMemory", _
            "handle", $g_h_GWProcess, _
            "ptr", $l_p_CurrentElement, _
            "struct*", $l_t_Struct, _
            "ulong_ptr", $l_a_ArrayStructInfo[1], _
            "ulong_ptr*", 0)
        Local $l_v_FieldValue = DllStructGetData($l_t_Struct, $a_s_FilterField)
        Local $l_b_Match = False
        Switch $a_i_FilterOperator
            Case 0 
                $l_b_Match = ($l_v_FieldValue = $a_v_FilterValue)
            Case 1 
                $l_b_Match = ($l_v_FieldValue <> $a_v_FilterValue)
            Case 2 
                $l_b_Match = ($l_v_FieldValue > $a_v_FilterValue)
            Case 3 
                $l_b_Match = ($l_v_FieldValue < $a_v_FilterValue)
        EndSwitch
        If $l_b_Match Then
            $l_a_Matches[$l_i_MatchCount] = $i
            $l_i_MatchCount += 1
        EndIf
    Next
    If $l_i_MatchCount = 0 Then Return SetError(3, 0, 0)
    Local $l_a_Results[$l_i_MatchCount][$l_i_FieldCount]
    For $i = 0 To $l_i_MatchCount - 1
        Local $l_i_Index = $l_a_Matches[$i]
        Local $l_p_CurrentElement = $a_p_ArrayBase + ($l_i_Index * $l_i_ElementSize)
        DllCall($g_h_Kernel32, "bool", "ReadProcessMemory", _
            "handle", $g_h_GWProcess, _
            "ptr", $l_p_CurrentElement, _
            "struct*", $l_t_Struct, _
            "ulong_ptr", $l_a_ArrayStructInfo[1], _
            "ulong_ptr*", 0)
        For $j = 0 To $l_i_FieldCount - 1
            $l_a_Results[$i][$j] = DllStructGetData($l_t_Struct, $l_a_FieldIndices[$j])
        Next
    Next
    Return $l_a_Results
EndFunc
Func Memory_FindInArrayStruct($a_p_ArrayBase, $a_i_ArraySize, ByRef $l_a_ArrayStructInfo, $sSearchField, $a_v_SearchValue)
    If Not IsArray($l_a_ArrayStructInfo) Then Return SetError(1, 0, 0)
    If $a_i_ArraySize <= 0 Then Return SetError(2, 0, 0)
    Local $l_i_FieldCount = $l_a_ArrayStructInfo[3]
    Local $l_i_ElementSize = $l_a_ArrayStructInfo[4]
    Local $l_a_FieldIndices = $l_a_ArrayStructInfo[2]
    Local $l_t_Struct = $l_a_ArrayStructInfo[0]
    For $i = 0 To $a_i_ArraySize - 1
        Local $l_p_CurrentElement = $a_p_ArrayBase + ($i * $l_i_ElementSize)
        DllCall($g_h_Kernel32, "bool", "ReadProcessMemory", _
            "handle", $g_h_GWProcess, _
            "ptr", $l_p_CurrentElement, _
            "struct*", $l_t_Struct, _
            "ulong_ptr", $l_a_ArrayStructInfo[1], _
            "ulong_ptr*", 0)
        Local $l_v_FieldValue = DllStructGetData($l_t_Struct, $sSearchField)
        If $l_v_FieldValue = $a_v_SearchValue Then
            Local $l_a_Result[$l_i_FieldCount]
            For $j = 0 To $l_i_FieldCount - 1
                $l_a_Result[$j] = DllStructGetData($l_t_Struct, $l_a_FieldIndices[$j])
            Next
            Return $l_a_Result
        EndIf
    Next
    Return SetError(3, 0, 0) 
EndFunc