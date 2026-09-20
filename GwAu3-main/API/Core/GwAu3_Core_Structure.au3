#include-once
Func Memory_CreateStructure($a_a_Definition)
    Local $l_a_Lines = StringSplit($a_a_Definition, ";", 2)
    Local $l_a_Fields[UBound($l_a_Lines)][5] 
    Local $l_i_FieldCount = 0
    For $i = 0 To UBound($l_a_Lines) - 1
        Local $l_s_Line = StringStripWS($l_a_Lines[$i], 3)
        If $l_s_Line = "" Then ContinueLoop
        Local $l_a_Match = StringRegExp($l_s_Line, "^(\w+)\s+(\w+)\[0x([0-9A-Fa-f]+)\]", 3)
        If @error Or UBound($l_a_Match) < 3 Then ContinueLoop
        $l_a_Fields[$l_i_FieldCount][0] = $l_a_Match[0] 
        $l_a_Fields[$l_i_FieldCount][1] = $l_a_Match[1] 
        $l_a_Fields[$l_i_FieldCount][2] = Dec($l_a_Match[2]) 
        $l_a_Fields[$l_i_FieldCount][3] = Memory_GetTypeSize($l_a_Match[0]) 
        $l_a_Fields[$l_i_FieldCount][4] = 0 
        $l_i_FieldCount += 1
    Next
    ReDim $l_a_Fields[$l_i_FieldCount][5]
    For $i = 0 To $l_i_FieldCount - 2
        For $j = $i + 1 To $l_i_FieldCount - 1
            If $l_a_Fields[$i][2] > $l_a_Fields[$j][2] Then
                For $k = 0 To 4
                    Local $vTemp = $l_a_Fields[$i][$k]
                    $l_a_Fields[$i][$k] = $l_a_Fields[$j][$k]
                    $l_a_Fields[$j][$k] = $vTemp
                Next
            EndIf
        Next
    Next
    Local $l_s_StructDef = ""
    Local $l_i_CurrentOffset = 0
    Local $l_i_StructIndex = 1 
    If $l_a_Fields[0][2] > 0 Then
        $l_s_StructDef = "byte[" & $l_a_Fields[0][2] & "];"
        $l_i_CurrentOffset = $l_a_Fields[0][2]
        $l_i_StructIndex += 1
    EndIf
    For $i = 0 To $l_i_FieldCount - 1
        $l_s_StructDef &= $l_a_Fields[$i][0] & " " & $l_a_Fields[$i][1] & ";"
        $l_a_Fields[$i][4] = $l_i_StructIndex 
        $l_i_StructIndex += 1
        $l_i_CurrentOffset += $l_a_Fields[$i][3]
        If $i < $l_i_FieldCount - 1 Then
            Local $l_i_Gap = $l_a_Fields[$i + 1][2] - $l_i_CurrentOffset
            If $l_i_Gap > 0 Then
                $l_s_StructDef &= "byte[" & $l_i_Gap & "];"
                $l_i_CurrentOffset += $l_i_Gap
                $l_i_StructIndex += 1
            EndIf
        EndIf
    Next
    Local $l_t_Struct = DllStructCreate(StringTrimRight($l_s_StructDef, 1))
    Local $l_i_Size = DllStructGetSize($l_t_Struct)
    Local $l_a_FieldIndices[$l_i_FieldCount]
    For $i = 0 To $l_i_FieldCount - 1
        $l_a_FieldIndices[$i] = $l_a_Fields[$i][4]
    Next
    Local $l_a_Result[4]
    $l_a_Result[0] = $l_t_Struct       
    $l_a_Result[1] = $l_i_Size         
    $l_a_Result[2] = $l_a_FieldIndices 
    $l_a_Result[3] = $l_i_FieldCount   
    Return $l_a_Result
EndFunc
Func Memory_ReadStruct($a_p_Address, ByRef $a_a_StructInfo)
    Local $l_t_Struct = $a_a_StructInfo[0]
    Local $l_i_Size = $a_a_StructInfo[1]
    Local $l_a_Indices = $a_a_StructInfo[2]
    Local $l_i_FieldCount = $a_a_StructInfo[3]
    Local $l_a_Call = DllCall($g_h_Kernel32, "bool", "ReadProcessMemory", _
        "handle", $g_h_GWProcess, _
        "ptr", $a_p_Address, _
        "struct*", $l_t_Struct, _
        "ulong_ptr", $l_i_Size, _
        "ulong_ptr*", 0)
    If @error Or Not $l_a_Call[0] Then Return SetError(1, 0, 0)
    Local $l_a_Result[$l_i_FieldCount]
    For $i = 0 To $l_i_FieldCount - 1
        $l_a_Result[$i] = DllStructGetData($l_t_Struct, $l_a_Indices[$i])
    Next
    Return $l_a_Result
EndFunc
Func Memory_ReadStructFields($a_p_Address, ByRef $a_a_StructInfo, $a_s_Fields)
    Local $l_t_Struct = $a_a_StructInfo[0]
    Local $l_i_Size = $a_a_StructInfo[1]
    DllCall($g_h_Kernel32, "bool", "ReadProcessMemory", _
        "handle", $g_h_GWProcess, _
        "ptr", $a_p_Address, _
        "struct*", $l_t_Struct, _
        "ulong_ptr", $l_i_Size, _
        "ulong_ptr*", 0)
    Local $l_a_RequestedFields = StringSplit($a_s_Fields, "|", 2)
    Local $l_i_Count = UBound($l_a_RequestedFields)
    Local $l_a_Result[$l_i_Count]
    For $i = 0 To $l_i_Count - 1
        $l_a_Result[$i] = DllStructGetData($l_t_Struct, $l_a_RequestedFields[$i])
    Next
    Return $l_a_Result
EndFunc
Func Memory_GetTypeSize($a_s_Type)
    Local $l_i_Size
    Switch StringLower($a_s_Type)
        Case 'byte', 'boolean', 'char'
			$l_i_Size = 1
        Case 'wchar', 'short', 'ushort', 'word'
            $l_i_Size = 2
        Case 'int', 'long', 'bool', 'uint', 'ulong', 'dword', 'float'
            $l_i_Size = 4
        Case 'int64', 'uint64', 'double'
            $l_i_Size = 8
        Case 'ptr', 'hwnd', 'handle'
            $l_i_Size = @AutoItX64 ? 8 : 4
        Case Else
            $l_i_Size = 0
    EndSwitch
    Return $l_i_Size
EndFunc