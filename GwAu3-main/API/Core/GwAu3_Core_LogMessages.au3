#include-once
Global $g_s_Log_Callback = "" 
Func Log_SetCallback($a_s_Callback)
    If $a_s_Callback = "" Then
        $g_s_Log_Callback = ""
        Return True
    EndIf
    If Not IsFunc(Execute($a_s_Callback)) Then Return SetError(1, 0, False)
    $g_s_Log_Callback = $a_s_Callback
    Return True
EndFunc
Func Log_Message($a_s_Message, $a_i_MsgType = $GC_I_LOG_MSGTYPE_INFO, $a_s_Author = "AutoIt", $a_h_EditText = 0)
    If $a_i_MsgType = $GC_I_LOG_MSGTYPE_DEBUG And Not $g_b_DebugMode Then Return
    If $g_s_Log_Callback <> "" Then
        Call($g_s_Log_Callback, $a_s_Message, $a_i_MsgType, $a_s_Author)
        Return
    EndIf
    If $a_h_EditText = 0 Then Return 
    Local $l_s_TypeText
    Local $l_i_Color 
    Switch $a_i_MsgType
        Case $GC_I_LOG_MSGTYPE_DEBUG
            $l_s_TypeText = "DEBUG"
            $l_i_Color = 0xFFA500
        Case $GC_I_LOG_MSGTYPE_WARNING
            $l_s_TypeText = "WARNING"
            $l_i_Color = 0x00C8FF
        Case $GC_I_LOG_MSGTYPE_ERROR
            $l_s_TypeText = "ERROR"
            $l_i_Color = 0x0000CC
        Case $GC_I_LOG_MSGTYPE_CRITICAL
            $l_s_TypeText = "CRITICAL"
            $l_i_Color = 0x0000FF
        Case Else
            $l_s_TypeText = "INFO"
            $l_i_Color = 0x008000
    EndSwitch
    Local $l_s_LogText = "[" & Log_GetCurrentTime() & "] [" & $l_s_TypeText & "] [" & $a_s_Author & "] " & $a_s_Message & @CRLF
    If _GUICtrlRichEdit_GetTextLength($a_h_EditText) > 30000 Then _GUICtrlRichEdit_SetText($a_h_EditText, "")
    _GUICtrlRichEdit_SetSel($a_h_EditText, -1, -1)
    _GUICtrlRichEdit_SetCharColor($a_h_EditText, $l_i_Color)
    _GUICtrlRichEdit_AppendText($a_h_EditText, $l_s_LogText)
    _GUICtrlEdit_Scroll($a_h_EditText, $SB_SCROLLCARET)
EndFunc
Func Log_Debug($a_s_Message, $a_s_Author = "AutoIt", $a_h_EditText = 0)
    Log_Message($a_s_Message, $GC_I_LOG_MSGTYPE_DEBUG, $a_s_Author, $a_h_EditText)
EndFunc
Func Log_Info($a_s_Message, $a_s_Author = "AutoIt", $a_h_EditText = 0)
    Log_Message($a_s_Message, $GC_I_LOG_MSGTYPE_INFO, $a_s_Author, $a_h_EditText)
EndFunc
Func Log_Warning($a_s_Message, $a_s_Author = "AutoIt", $a_h_EditText = 0)
    Log_Message($a_s_Message, $GC_I_LOG_MSGTYPE_WARNING, $a_s_Author, $a_h_EditText)
EndFunc
Func Log_Error($a_s_Message, $a_s_Author = "AutoIt", $a_h_EditText = 0)
    Log_Message($a_s_Message, $GC_I_LOG_MSGTYPE_ERROR, $a_s_Author, $a_h_EditText)
EndFunc
Func Log_Critical($a_s_Message, $a_s_Author = "AutoIt", $a_h_EditText = 0)
    Log_Message($a_s_Message, $GC_I_LOG_MSGTYPE_CRITICAL, $a_s_Author, $a_h_EditText)
EndFunc
Func Log_SetDebugMode($a_b_Enable = True)
    $g_b_DebugMode = $a_b_Enable
    Log_Message("Debug Mode " & ($a_b_Enable ? "Enabled" : "Disabled"), $GC_I_LOG_MSGTYPE_INFO, "SetDebugMode")
EndFunc
Func Log_GetCurrentTime()
    Return StringFormat("%02d:%02d:%02d", @HOUR, @MIN, @SEC)
EndFunc