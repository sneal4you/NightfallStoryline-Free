#include-once
#Region WinHttp_Constants
Global $hWINHTTPDLL__WINHTTP = ""
Global Const $INTERNET_DEFAULT_PORT = 0
Global Const $INTERNET_DEFAULT_HTTP_PORT = 80
Global Const $INTERNET_DEFAULT_HTTPS_PORT = 443
Global Const $WINHTTP_FLAG_ASYNC = 0x10000000
Global Const $WINHTTP_FLAG_ESCAPE_PERCENT = 0x00000004
Global Const $WINHTTP_FLAG_NULL_CODEPAGE = 0x00000008
Global Const $WINHTTP_FLAG_ESCAPE_DISABLE = 0x00000040
Global Const $WINHTTP_FLAG_ESCAPE_DISABLE_QUERY = 0x00000080
Global Const $WINHTTP_FLAG_BYPASS_PROXY_CACHE = 0x00000100
Global Const $WINHTTP_FLAG_REFRESH = $WINHTTP_FLAG_BYPASS_PROXY_CACHE
Global Const $WINHTTP_FLAG_SECURE = 0x00800000
Global Const $WINHTTP_ACCESS_TYPE_DEFAULT_PROXY = 0
Global Const $WINHTTP_ACCESS_TYPE_NO_PROXY = 1
Global Const $WINHTTP_ACCESS_TYPE_NAMED_PROXY = 3
Global Const $WINHTTP_NO_PROXY_NAME = ""
Global Const $WINHTTP_NO_PROXY_BYPASS = ""
Global Const $WINHTTP_NO_REFERER = ""
Global Const $WINHTTP_DEFAULT_ACCEPT_TYPES  = 0
Global Const $WINHTTP_OPTION_CALLBACK = 1
Global Const $WINHTTP_FIRST_OPTION = $WINHTTP_OPTION_CALLBACK
Global Const $WINHTTP_OPTION_RESOLVE_TIMEOUT = 2
Global Const $WINHTTP_OPTION_CONNECT_TIMEOUT = 3
Global Const $WINHTTP_OPTION_CONNECT_RETRIES = 4
Global Const $WINHTTP_OPTION_SEND_TIMEOUT = 5
Global Const $WINHTTP_OPTION_RECEIVE_TIMEOUT = 6
Global Const $WINHTTP_OPTION_RECEIVE_RESPONSE_TIMEOUT = 7
Global Const $WINHTTP_OPTION_HANDLE_TYPE = 9
Global Const $WINHTTP_OPTION_READ_BUFFER_SIZE = 12
Global Const $WINHTTP_OPTION_WRITE_BUFFER_SIZE = 13
Global Const $WINHTTP_OPTION_PARENT_HANDLE = 21
Global Const $WINHTTP_OPTION_EXTENDED_ERROR = 24
Global Const $WINHTTP_OPTION_SECURITY_FLAGS = 31
Global Const $WINHTTP_OPTION_SECURITY_CERTIFICATE_STRUCT = 32
Global Const $WINHTTP_OPTION_URL = 34
Global Const $WINHTTP_OPTION_SECURITY_KEY_BITNESS = 36
Global Const $WINHTTP_OPTION_PROXY = 38
Global Const $WINHTTP_OPTION_USER_AGENT = 41
Global Const $WINHTTP_OPTION_CONTEXT_VALUE = 45
Global Const $WINHTTP_OPTION_CLIENT_CERT_CONTEXT = 47
Global Const $WINHTTP_OPTION_REQUEST_PRIORITY = 58
Global Const $WINHTTP_OPTION_HTTP_VERSION = 59
Global Const $WINHTTP_OPTION_DISABLE_FEATURE = 63
Global Const $WINHTTP_OPTION_CODEPAGE = 68
Global Const $WINHTTP_OPTION_MAX_CONNS_PER_SERVER = 73
Global Const $WINHTTP_OPTION_MAX_CONNS_PER_1_0_SERVER = 74
Global Const $WINHTTP_OPTION_AUTOLOGON_POLICY = 77
Global Const $WINHTTP_OPTION_SERVER_CERT_CONTEXT = 78
Global Const $WINHTTP_OPTION_ENABLE_FEATURE = 79
Global Const $WINHTTP_OPTION_WORKER_THREAD_COUNT = 80
Global Const $WINHTTP_OPTION_PASSPORT_COBRANDING_TEXT = 81
Global Const $WINHTTP_OPTION_PASSPORT_COBRANDING_URL = 82
Global Const $WINHTTP_OPTION_CONFIGURE_PASSPORT_AUTH = 83
Global Const $WINHTTP_OPTION_SECURE_PROTOCOLS = 84
Global Const $WINHTTP_OPTION_ENABLETRACING = 85
Global Const $WINHTTP_OPTION_PASSPORT_SIGN_OUT = 86
Global Const $WINHTTP_OPTION_PASSPORT_RETURN_URL = 87
Global Const $WINHTTP_OPTION_REDIRECT_POLICY = 88
Global Const $WINHTTP_OPTION_MAX_HTTP_AUTOMATIC_REDIRECTS = 89
Global Const $WINHTTP_OPTION_MAX_HTTP_STATUS_CONTINUE = 90
Global Const $WINHTTP_OPTION_MAX_RESPONSE_HEADER_SIZE = 91
Global Const $WINHTTP_OPTION_MAX_RESPONSE_DRAIN_SIZE = 92
Global Const $WINHTTP_OPTION_CONNECTION_INFO = 93
Global Const $WINHTTP_OPTION_CLIENT_CERT_ISSUER_LIST = 94
Global Const $WINHTTP_OPTION_SPN = 96
Global Const $WINHTTP_OPTION_GLOBAL_PROXY_CREDS = 97
Global Const $WINHTTP_OPTION_GLOBAL_SERVER_CREDS = 98
Global Const $WINHTTP_OPTION_UNLOAD_NOTIFY_EVENT = 99
Global Const $WINHTTP_OPTION_REJECT_USERPWD_IN_URL = 100
Global Const $WINHTTP_OPTION_USE_GLOBAL_SERVER_CREDENTIALS = 101
Global Const $WINHTTP_OPTION_RECEIVE_PROXY_CONNECT_RESPONSE = 103
Global Const $WINHTTP_OPTION_IS_PROXY_CONNECT_RESPONSE = 104
Global Const $WINHTTP_OPTION_SERVER_SPN_USED = 106
Global Const $WINHTTP_OPTION_PROXY_SPN_USED = 107
Global Const $WINHTTP_OPTION_SERVER_CBT = 108
Global Const $WINHTTP_OPTION_UNSAFE_HEADER_PARSING = 110
Global Const $WINHTTP_OPTION_DECOMPRESSION = 118
Global Const $WINHTTP_LAST_OPTION = $WINHTTP_OPTION_DECOMPRESSION
Global Const $WINHTTP_OPTION_USERNAME = 0x1000
Global Const $WINHTTP_OPTION_PASSWORD = 0x1001
Global Const $WINHTTP_OPTION_PROXY_USERNAME = 0x1002
Global Const $WINHTTP_OPTION_PROXY_PASSWORD = 0x1003
Global Const $WINHTTP_CONNS_PER_SERVER_UNLIMITED = 0xFFFFFFFF
Global Const $WINHTTP_NO_ADDITIONAL_HEADERS = ""
Global Const $WINHTTP_NO_REQUEST_DATA = ""
Global Const $ICU_ESCAPE = 0x80000000
Global Const $ICU_DECODE = 0x10000000
Global Const $WINHTTP_QUERY_RAW_HEADERS_CRLF = 22
Global Const $WINHTTP_HEADER_NAME_BY_INDEX = ""
Global Const $WINHTTP_NO_HEADER_INDEX = 0
Global Const $WINHTTP_AUTOLOGON_SECURITY_LEVEL_MEDIUM = 0
Global Const $WINHTTP_AUTOLOGON_SECURITY_LEVEL_LOW = 1
Global Const $WINHTTP_AUTOLOGON_SECURITY_LEVEL_HIGH = 2
Global Const $WINHTTP_AUTOLOGON_SECURITY_LEVEL_DEFAULT = $WINHTTP_AUTOLOGON_SECURITY_LEVEL_MEDIUM
Global Const $WINHTTP_QUERY_CONTENT_TYPE = 1
#EndRegion WinHttp_Constants
#Region Updater_ScriptVars
Global $g_s_GwAu3Dir = Updater_FindGwAu3Root()
Global $g_s_UpdaterConfigIni = $g_s_GwAu3Dir & "API\Core\config.ini"
Global $g_s_Section_Update = "Update"
Global $g_s_Section_Hashes = "Hashes"
Global $g_b_AutoUpdate = IniRead($g_s_UpdaterConfigIni, $g_s_Section_Update, "Enabled", "1") = "1"
Global $g_b_Verbose = IniRead($g_s_UpdaterConfigIni, $g_s_Section_Update, "Verbose", "1") = "1"
Global $g_s_Owner = IniRead($g_s_UpdaterConfigIni, $g_s_Section_Update, "Owner", "myUser")
Global $g_s_Repo = IniRead($g_s_UpdaterConfigIni, $g_s_Section_Update, "Repo", "myRepo")
Global $g_s_Branch = IniRead($g_s_UpdaterConfigIni, $g_s_Section_Update, "Branch", "main")
Global $g_as_IgnoredFiles[2] = [1, "API/Core/config.ini"]
#EndRegion Updater_ScriptVars
#Region Updater_Functions
Func Updater_FindGwAu3Root()
    Local $l_s_Dir = @ScriptDir
    While True
        If FileExists($l_s_Dir & "\API\Core\config.ini") Then Return ($l_s_Dir & "\")
        Local $l_s_Parent = StringRegExpReplace($l_s_Dir, "\\[^\\]+\\?$", "")
        If $l_s_Parent = $l_s_Dir Then ExitLoop
        $l_s_Dir = $l_s_Parent
    WEnd
    Return ""
EndFunc
Func Updater_CheckForGwAu3Updates()
    If $g_s_GwAu3Dir == "" Then Return 0
    If Not $g_b_AutoUpdate Then Return 3
    Updater_LoadWinHttp()
    Local $l_o_CachedHashes = Updater_LoadHashCache($g_s_UpdaterConfigIni, $g_s_Section_Hashes)
	Local $l_h_Session = _WinHttpOpen("GwAu3-Updater/1.0", $WINHTTP_ACCESS_TYPE_DEFAULT_PROXY)
	If @error Or Not $l_h_Session Then Return 0
	Local $l_h_Connect = _WinHttpConnect($l_h_Session, "api.github.com", 443)
	If @error Or Not $l_h_Connect Then Return 0
	Local $l_s_RequestObject = "/repos/" & $g_s_Owner & "/" & $g_s_Repo & "/git/trees/" & $g_s_Branch & "?recursive=1"
	Local $l_h_Request = _WinHttpOpenRequest($l_h_Connect, "GET", $l_s_RequestObject, Default, Default, Default, $WINHTTP_FLAG_SECURE)
	If @error Or Not $l_h_Request Then Return 0
	Local $l_b_Send = _WinHttpSendRequest($l_h_Request, "User-Agent: GwAu3-Updater/1.0")
	If @error Or Not $l_b_Send Then Return 0
	Local $l_b_Recv = _WinHttpReceiveResponse($l_h_Request)
	If @error Or Not $l_b_Recv Then Return 0
	Local $l_s_Json = _WinHttpSimpleReadData($l_h_Request)
	_WinHttpCloseHandle($l_h_Request)
	_WinHttpCloseHandle($l_h_Connect)
	_WinHttpCloseHandle($l_h_Session)
    Updater_UnloadWinHttp()
    Local $l_as_Tree = StringRegExp($l_s_Json, '(?s)\{[^}]*"path":"([^"]+)"[^}]*"type":"blob"[^}]*"sha":"([0-9a-f]+)"[^}]*\}', 3)
    If @error Or $l_as_Tree = 0 Then Return 0
    Local $l_o_RemoteHashes = ObjCreate("Scripting.Dictionary")
    For $i = 0 To UBound($l_as_Tree) - 1 Step 2
        $l_o_RemoteHashes.Add($l_as_Tree[$i], StringUpper($l_as_Tree[$i + 1]))
    Next
    Local $l_as_Deletion[1] = [0]
    Local $l_as_Keys = $l_o_CachedHashes.Keys
    For $i = 0 To UBound($l_as_Keys) - 1
        If Not $l_o_RemoteHashes.Exists($l_as_Keys[$i]) Then
            _ArrayAdd($l_as_Deletion, $l_as_Keys[$i])
            $l_as_Deletion[0] += 1
        EndIf
    Next
    Local $l_i_Count_Deletion = $l_as_Deletion[0]
    If $l_i_Count_Deletion > 0 Then
        Local $l_b_DeleteFiles = Not $g_b_Verbose
        If $g_b_Verbose Then
            Local Const $LC_I_MAX_ROWS = 20
            Local $l_s_DeleteMsg = ""
            If $l_i_Count_Deletion > $LC_I_MAX_ROWS Then
                For $i = 1 To $LC_I_MAX_ROWS
                    $l_s_DeleteMsg &= $l_as_Deletion[$i] & @CRLF
                Next
                Local $l_i_Leftovers = $l_i_Count_Deletion - $LC_I_MAX_ROWS
                $l_s_DeleteMsg &= @CRLF & "... and " & $l_i_Leftovers & " more items."
            Else
                For $i = 1 To $l_i_Count_Deletion
                    $l_s_DeleteMsg &= $l_as_Deletion[$i] & @CRLF
                Next
            EndIf
            If MsgBox(4 + 48, "GwAu3-Updater - File Removal", _
                "Tracked file(s) removed upstream. Remove file(s) locally?" & @CRLF & @CRLF & $l_s_DeleteMsg) = 6 Then
                $l_b_DeleteFiles = True
            EndIf
        EndIf
        If $l_b_DeleteFiles Then
            For $i = 1 To $l_as_Deletion[0]
                Local $l_s_File = $g_s_GwAu3Dir & $l_as_Deletion[$i]
                If FileExists($l_s_File) Then FileDelete($l_s_File)
                IniDelete($g_s_UpdaterConfigIni, $g_s_Section_Hashes, StringReplace($l_as_Deletion[$i], "/", "~"))
                $l_o_CachedHashes.Remove($l_as_Deletion[$i])
            Next
        EndIf
    EndIf
    Local $l_as_UpdateFiles[1] = [0]
	Local $l_as_UpdateSHAs[1] = [0]
    Local $l_s_RelPath, $l_s_CachedSHA, $l_s_RemoteSHA
    For $i = 0 To UBound($l_as_Tree) - 1 Step 2
        $l_s_RelPath = $l_as_Tree[$i]
        If Updater_IsIgnoredFile($l_s_RelPath) Then ContinueLoop
		$l_s_RemoteSHA = StringUpper($l_as_Tree[$i + 1])
		If $l_o_CachedHashes.Exists($l_s_RelPath) Then
        	$l_s_CachedSHA = $l_o_CachedHashes.Item($l_s_RelPath)
		Else
			$l_s_CachedSHA = ""
		EndIf
        If $l_s_CachedSHA <> $l_s_RemoteSHA Then
			_ArrayAdd($l_as_UpdateFiles, $l_s_RelPath)
			_ArrayAdd($l_as_UpdateSHAs, $l_s_RemoteSHA)
			$l_as_UpdateFiles[0] += 1
			$l_as_UpdateSHAs[0] += 1
		EndIf
    Next
    If $l_as_UpdateFiles[0]=0 Then Return 1
    If $g_b_Verbose Then
        If MsgBox(4 + 32, "GwAu3-Updater - Update Available", $l_as_UpdateFiles[0] & " update(s) available. Update now?") <> 6 Then Return 2
    EndIf
    Log_Info("Starting download, please wait...", "GwAu3", $g_h_EditText)
    Updater_DownloadFilesParallel_PB($l_as_UpdateFiles, $l_as_UpdateSHAs)
    Return 4
EndFunc
Func Updater_LoadHashCache($a_s_IniFile, $a_s_IniSection)
    Local $l_o_HashDict = ObjCreate("Scripting.Dictionary")
    Local $l_as_ShaHashes = _IniReadSection($a_s_IniFile, $a_s_IniSection)
    If @error Or UBound($l_as_ShaHashes) = 0 Then Return $l_o_HashDict
    For $i = 1 To UBound($l_as_ShaHashes) - 1
        Local $l_s_DictKey = $l_as_ShaHashes[$i][0]
        Local $l_s_DictVal = $l_as_ShaHashes[$i][1]
        $l_s_DictKey = StringReplace($l_s_DictKey, "~", "/")
        $l_o_HashDict.Add($l_s_DictKey, $l_s_DictVal)
    Next
    Return $l_o_HashDict
EndFunc
Func _IniReadSection($a_s_IniFile, $a_s_IniSection)
    If Not FileExists($a_s_IniFile) Then
        SetError(1)
        Return 0
    EndIf
    Local $l_as2_Keys[1][2]
    Local $l_h_File = FileOpen($a_s_IniFile, 0)
    If $l_h_File = -1 Then
        SetError(1)
        Return 0
    EndIf
    Local $l_b_InSection = False, $l_s_Line, $l_i_Count = 0
    While 1
        $l_s_Line = FileReadLine($l_h_File)
        If @error Then ExitLoop
        $l_s_Line = StringStripWS($l_s_Line, 3)
        If $l_s_Line = "" Or StringLeft($l_s_Line, 1) = ";" Or StringLeft($l_s_Line, 1) = "#" Then ContinueLoop
        If StringRegExp($l_s_Line, "^\s*\[.*\]\s*$") Then
            Local $l_s_CurrentSection = StringRegExpReplace($l_s_Line, "^\s*\[(.*)\]\s*$", "\1")
            If $l_s_CurrentSection = $a_s_IniSection Then
                $l_b_InSection = True
            ElseIf $l_b_InSection Then
                ExitLoop
            Else
                $l_b_InSection = False
            EndIf
            ContinueLoop
        EndIf
        If $l_b_InSection Then
            Local $l_i_EqPosition = StringInStr($l_s_Line, "=")
            If $l_i_EqPosition > 1 Then
                Local $sKey = StringStripWS(StringLeft($l_s_Line, $l_i_EqPosition - 1), 3)
                Local $sVal = StringMid($l_s_Line, $l_i_EqPosition + 1)
                ReDim $l_as2_Keys[UBound($l_as2_Keys) + 1][2]
                $l_as2_Keys[UBound($l_as2_Keys) - 1][0] = $sKey
                $l_as2_Keys[UBound($l_as2_Keys) - 1][1] = $sVal
                $l_i_Count += 1
            EndIf
        EndIf
    WEnd
    FileClose($l_h_File)
    If $l_i_Count = 0 Then
        SetError(1)
        Return 0
    EndIf
    $l_as2_Keys[0][0] = $l_i_Count
    Return $l_as2_Keys
EndFunc
Func Updater_SaveHashCache($a_s_IniFile, $a_s_IniSection, $a_as2_KeyHashes)
    Local $l_i_KeyCount = UBound($a_as2_KeyHashes)
    Local $l_s_Key, $l_s_SHA
    For $i = 0 To $l_i_KeyCount - 1
        $l_s_Key = StringRegExpReplace($a_as2_KeyHashes[$i][0], "[/\\]", "~")
        $l_s_SHA = $a_as2_KeyHashes[$i][1]
        IniWrite($a_s_IniFile, $a_s_IniSection, $l_s_Key, $l_s_SHA)
    Next
EndFunc
Func Updater_InitializeHashCache()
    Local $l_as_OldEntries = _IniReadSection($g_s_UpdaterConfigIni, $g_s_Section_Hashes)
    If Not @error Then IniDelete($g_s_UpdaterConfigIni, $g_s_Section_Hashes)
    Local $l_as_Files = Updater_GetRelativeFiles($g_s_GwAu3Dir), $l_i_FileCount = UBound($l_as_Files)
    Local $l_as2_KeyHashes[$l_i_FileCount][2]
    For $i = 1 To $l_as_Files[0]
        Local $l_s_RelPath = $l_as_Files[$i]
        Local $l_s_FullPath = $g_s_GwAu3Dir & $l_s_RelPath
        Local $l_s_SHA = Updater_ComputeGitBlobSHA($l_s_FullPath)  
        $l_as2_KeyHashes[$i - 1][0] = $l_s_RelPath
        $l_as2_KeyHashes[$i - 1][1] = $l_s_SHA
    Next
    Updater_SaveHashCache($g_s_UpdaterConfigIni, $g_s_Section_Hashes, $l_as2_KeyHashes)
    MsgBox(64, "Initialized", "Wrote " & $l_as_Files[0] & " entries into [" & $g_s_Section_Hashes & "]")
EndFunc
Func Updater_IsIgnoredFile($a_s_Path)
    For $i = 1 To $g_as_IgnoredFiles[0]
        If $a_s_Path = $g_as_IgnoredFiles[$i] Then Return True
    Next
    Return False
EndFunc
Func Updater_GetRelativeFiles($a_s_Base)
    Local $l_as_Files[1] = [0]
    Updater_Scan($a_s_Base, $a_s_Base, $l_as_Files)
    Return $l_as_Files
EndFunc
Func Updater_Scan($a_s_Root, $a_s_Current, ByRef $l_as_Files)
    Local $l_h_FirstFileHnd = FileFindFirstFile($a_s_Current & "\*")
    If $l_h_FirstFileHnd = -1 Then Return
    While 1
        Local $l_h_NextFileHnd = FileFindNextFile($l_h_FirstFileHnd)
        If @error Then ExitLoop
        If $l_h_NextFileHnd = "." Or $l_h_NextFileHnd = ".." Then ContinueLoop
        Local $l_s_FullPath = $a_s_Current & "\" & $l_h_NextFileHnd
        If StringInStr(FileGetAttrib($l_s_FullPath), "D") Then
            Updater_Scan($a_s_Root, $l_s_FullPath, $l_as_Files)
        Else
            Local $l_s_RelPath = StringTrimLeft($l_s_FullPath, StringLen($a_s_Root) + 1)
            _ArrayAdd($l_as_Files, $l_s_RelPath)
			$l_as_Files[0] += 1
        EndIf
    WEnd
    FileClose($l_h_FirstFileHnd)
EndFunc
Func Updater_ComputeGitBlobSHA($a_s_File)
    If Not FileExists($a_s_File) Then Return ""
    Local $l_h_Input = FileOpen($a_s_File, 0 + 8)
    If $l_h_Input = -1 Then Return ""
    Local $l_s_Content = FileRead($l_h_Input)
    FileClose($l_h_Input)
    Local $l_i_Size = BinaryLen($l_s_Content)
    Local $l_s_Header = "blob " & $l_i_Size & Chr(0)
    Local $l_s_Temp = @TempDir & "\gitblob.bin"
    Local $l_h_Output = FileOpen($l_s_Temp, 2 + 8)
    If $l_h_Output = -1 Then Return ""
    FileWrite($l_h_Output, StringToBinary($l_s_Header))
    FileWrite($l_h_Output, $l_s_Content)
    FileClose($l_h_Output)
    Local $l_s_SHA = Updater_GetSHA1($l_s_Temp)
    FileDelete($l_s_Temp)
    Return $l_s_SHA
EndFunc
Func Updater_GetSHA1($a_s_File)
    If Not FileExists($a_s_File) Then Return ""
    Local $l_s_Cmd = 'certutil -hashfile "' & $a_s_File & '" SHA1'
    Local $l_h_PID = Run(@ComSpec & " /c " & $l_s_Cmd, "", @SW_HIDE, BitOR($STDOUT_CHILD, $STDERR_CHILD))
    Local $l_s_Out = "", $l_s_Line
    While 1
        $l_s_Line = StdoutRead($l_h_PID)
        If @error Then ExitLoop
        $l_s_Out &= $l_s_Line
    WEnd
    Local $l_as_Output = StringSplit($l_s_Out, @CRLF, 1)
    For $i = 1 To $l_as_Output[0]
        Local $l_s_SHA = StringStripWS($l_as_Output[$i], 3)
        If StringRegExp($l_s_SHA, "^[A-Fa-f0-9]{40}$") Then
            Return StringUpper($l_s_SHA)
        EndIf
    Next
    Return ""
EndFunc
Func Updater_DownloadFilesParallel_PB($a_as_UpdateFiles, $a_as_UpdateSHAs)
    Local Const $LC_I_MAX_STREAMS = 4
    Local $l_i_FileCount = $a_as_UpdateFiles[0]
    Local $l_h_GUI = GUICreate("GwAu3-Updater - Downloading Updates", 400, 120)
    Local $l_h_Lbl = GUICtrlCreateLabel("", 20, 20, 360, 20, BitOR($SS_LEFT, $DT_END_ELLIPSIS))
    Local $l_h_ProgressBar = GUICtrlCreateProgress(20, 50, 360, 20)
    GUISetState(@SW_SHOW)
    Local $l_a_Files[$l_i_FileCount + 1][6]
    For $i = 1 To $l_i_FileCount
        Local $l_s_RelPath = StringReplace($a_as_UpdateFiles[$i], "/", "\")
        $l_a_Files[$i][0] = "https://raw.githubusercontent.com/" & $g_s_Owner & "/" & $g_s_Repo & "/" & $g_s_Branch & "/" & $a_as_UpdateFiles[$i] 
        $l_a_Files[$i][1] = $g_s_GwAu3Dir & $l_s_RelPath 
        $l_a_Files[$i][2] = $l_s_RelPath 
        $l_a_Files[$i][3] = $a_as_UpdateSHAs[$i] 
        $l_a_Files[$i][4] = False 
        $l_a_Files[$i][5] = 0 
        Local $l_s_TargetDir = StringRegExpReplace($l_a_Files[$i][1], "\\[^\\]+$", "")
        DirCreate($l_s_TargetDir)
    Next
    Local $l_as2_KeyHashes[$l_i_FileCount][2]
    Local $l_i_Started = 1, $l_i_Completed = 0, $l_i_Success = 0
    For $i = 1 To _Min($LC_I_MAX_STREAMS, $l_i_FileCount)
        $l_a_Files[$i][5] = InetGet($l_a_Files[$i][0], $l_a_Files[$i][1], $INET_BINARYTRANSFER, $INET_DOWNLOADBACKGROUND)
        $l_i_Started += 1
    Next
    While $l_i_Completed < $l_i_FileCount
        For $i = 1 To $l_i_FileCount
            If $l_a_Files[$i][4] = True Then ContinueLoop
            Local $l_h_Download = $l_a_Files[$i][5]
            If $l_h_Download = 0 Then ContinueLoop 
            If InetGetInfo($l_h_Download, $INET_DOWNLOADCOMPLETE) Then
                $l_a_Files[$i][4] = True
                $l_i_Completed += 1
                GUICtrlSetData($l_h_Lbl, "Downloaded Files: [" & $l_i_Completed & "/" & $l_i_FileCount & "]: " & $l_a_Files[$i][2])
                GUICtrlSetData($l_h_ProgressBar, $l_i_Completed / $l_i_FileCount * 100)
                If InetGetInfo($l_h_Download, $INET_DOWNLOADSUCCESS) Then
                    $l_as2_KeyHashes[$l_i_Success][0] = $l_a_Files[$i][2]
                    $l_as2_KeyHashes[$l_i_Success][1] = $l_a_Files[$i][3]
                    $l_i_Success += 1
                EndIf
                InetClose($l_h_Download)
                If $l_i_Started <= $l_i_FileCount Then
                    $l_a_Files[$l_i_Started][5] = InetGet($l_a_Files[$l_i_Started][0], $l_a_Files[$l_i_Started][1], $INET_BINARYTRANSFER, $INET_DOWNLOADBACKGROUND)
                    $l_i_Started += 1
                EndIf
            EndIf
        Next
        Sleep(100)
    WEnd
    ReDim $l_as2_KeyHashes[$l_i_Success][2]
    Updater_SaveHashCache($g_s_UpdaterConfigIni, $g_s_Section_Hashes, $l_as2_KeyHashes)
    GUIDelete($l_h_GUI)
EndFunc
Func Updater_DownloadFilesParallel_NoPB($a_as_UpdateFiles, $a_as_UpdateSHAs)
    Local Const $LC_I_MAX_STREAMS = 4
    Local $l_i_FileCount = $a_as_UpdateFiles[0]
    Local $l_a_Files[$l_i_FileCount + 1][6]
    For $i = 1 To $l_i_FileCount
        Local $l_s_RelPath = StringReplace($a_as_UpdateFiles[$i], "/", "\")
        $l_a_Files[$i][0] = "https://raw.githubusercontent.com/" & $g_s_Owner & "/" & $g_s_Repo & "/" & $g_s_Branch & "/" & $a_as_UpdateFiles[$i] 
        $l_a_Files[$i][1] = $g_s_GwAu3Dir & $l_s_RelPath 
        $l_a_Files[$i][2] = $l_s_RelPath 
        $l_a_Files[$i][3] = $a_as_UpdateSHAs[$i] 
        $l_a_Files[$i][4] = False 
        $l_a_Files[$i][5] = 0 
        Local $l_s_TargetDir = StringRegExpReplace($l_a_Files[$i][1], "\\[^\\]+$", "")
        DirCreate($l_s_TargetDir)
    Next
    Local $l_as2_KeyHashes[$l_i_FileCount][2]
    Local $l_i_Started = 1, $l_i_Completed = 0, $l_i_Success = 0
    For $i = 1 To _Min($LC_I_MAX_STREAMS, $l_i_FileCount)
        $l_a_Files[$i][5] = InetGet($l_a_Files[$i][0], $l_a_Files[$i][1], $INET_BINARYTRANSFER, $INET_DOWNLOADBACKGROUND)
        $l_i_Started += 1
    Next
    While $l_i_Completed < $l_i_FileCount
        For $i = 1 To $l_i_FileCount
            If $l_a_Files[$i][4] = True Then ContinueLoop
            Local $l_h_Download = $l_a_Files[$i][5]
            If $l_h_Download = 0 Then ContinueLoop 
            If InetGetInfo($l_h_Download, $INET_DOWNLOADCOMPLETE) Then
                $l_a_Files[$i][4] = True
                $l_i_Completed += 1
                If InetGetInfo($l_h_Download, $INET_DOWNLOADSUCCESS) Then
                    $l_as2_KeyHashes[$l_i_Success][0] = $l_a_Files[$i][2]
                    $l_as2_KeyHashes[$l_i_Success][1] = $l_a_Files[$i][3]
                    $l_i_Success += 1
                EndIf
                InetClose($l_h_Download)
                If $l_i_Started <= $l_i_FileCount Then
                    $l_a_Files[$l_i_Started][5] = InetGet($l_a_Files[$l_i_Started][0], $l_a_Files[$l_i_Started][1], $INET_BINARYTRANSFER, $INET_DOWNLOADBACKGROUND)
                    $l_i_Started += 1
                EndIf
            EndIf
        Next
        Sleep(100)
    WEnd
    ReDim $l_as2_KeyHashes[$l_i_Success][2]
    Updater_SaveHashCache($g_s_UpdaterConfigIni, $g_s_Section_Hashes, $l_as2_KeyHashes)
EndFunc
#EndRegion Updater_Functions
#Region WinHttp
Func Updater_LoadWinHttp()
    $hWINHTTPDLL__WINHTTP = DllOpen("winhttp.dll")
EndFunc
Func Updater_UnloadWinHttp()
    DllClose($hWINHTTPDLL__WINHTTP)
EndFunc
Func _WinHttpOpen($sUserAgent = Default, $iAccessType = Default, $sProxyName = Default, $sProxyBypass = Default, $iFlag = Default)
    __WinHttpDefault($sUserAgent, __WinHttpUA())
    __WinHttpDefault($iAccessType, $WINHTTP_ACCESS_TYPE_NO_PROXY)
    __WinHttpDefault($sProxyName, $WINHTTP_NO_PROXY_NAME)
    __WinHttpDefault($sProxyBypass, $WINHTTP_NO_PROXY_BYPASS)
    __WinHttpDefault($iFlag, 0)
    Local $aCall = DllCall($hWINHTTPDLL__WINHTTP, "handle", "WinHttpOpen", _
            "wstr", $sUserAgent, _
            "dword", $iAccessType, _
            "wstr", $sProxyName, _
            "wstr", $sProxyBypass, _
            "dword", $iFlag)
    If @error Or Not $aCall[0] Then Return SetError(1, 0, 0)
    If $iFlag = $WINHTTP_FLAG_ASYNC Then _WinHttpSetOption($aCall[0], $WINHTTP_OPTION_CONTEXT_VALUE, $WINHTTP_FLAG_ASYNC)
    Return $aCall[0]
EndFunc
Func __WinHttpDefault(ByRef $vInput, $vOutput)
    If $vInput = Default Or Number($vInput) = -1 Then $vInput = $vOutput
EndFunc
Func __WinHttpUA()
    Local Static $sUA = "Mozilla/5.0 " & __WinHttpSysInfo() & " WinHttp/" & __WinHttpVer() & " (WinHTTP/5.1) like Gecko"
    Return $sUA
EndFunc
Func __WinHttpSysInfo()
	Local $sDta = FileGetVersion("kernel32.dll")
	$sDta = "(Windows NT " & StringLeft($sDta, StringInStr($sDta, ".", 1, 2) - 1)
	If StringInStr(@OSArch, "64") And Not @AutoItX64 Then $sDta &= "; WOW64"
	$sDta &= ")"
	Return $sDta
EndFunc
Func __WinHttpVer()
	Return "1.6.4.2"
EndFunc
Func _WinHttpSetOption($hInternet, $iOption, $vSetting, $iSize = Default)
    If $iSize = Default Then $iSize = -1
    If IsBinary($vSetting) Then
        $iSize = DllStructCreate("byte[" & BinaryLen($vSetting) & "]")
        DllStructSetData($iSize, 1, $vSetting)
        $vSetting = $iSize
        $iSize = DllStructGetSize($vSetting)
    EndIf
    Local $sType
    Switch $iOption
        Case $WINHTTP_OPTION_AUTOLOGON_POLICY, $WINHTTP_OPTION_CODEPAGE, $WINHTTP_OPTION_CONFIGURE_PASSPORT_AUTH, $WINHTTP_OPTION_CONNECT_RETRIES, _
                $WINHTTP_OPTION_CONNECT_TIMEOUT, $WINHTTP_OPTION_DISABLE_FEATURE, $WINHTTP_OPTION_ENABLE_FEATURE, $WINHTTP_OPTION_ENABLETRACING, _
                $WINHTTP_OPTION_MAX_CONNS_PER_1_0_SERVER, $WINHTTP_OPTION_MAX_CONNS_PER_SERVER, $WINHTTP_OPTION_MAX_HTTP_AUTOMATIC_REDIRECTS, _
                $WINHTTP_OPTION_MAX_HTTP_STATUS_CONTINUE, $WINHTTP_OPTION_MAX_RESPONSE_DRAIN_SIZE, $WINHTTP_OPTION_MAX_RESPONSE_HEADER_SIZE, _
                $WINHTTP_OPTION_READ_BUFFER_SIZE, $WINHTTP_OPTION_RECEIVE_TIMEOUT, _
                $WINHTTP_OPTION_RECEIVE_RESPONSE_TIMEOUT, $WINHTTP_OPTION_REDIRECT_POLICY, $WINHTTP_OPTION_REJECT_USERPWD_IN_URL, _
                $WINHTTP_OPTION_REQUEST_PRIORITY, $WINHTTP_OPTION_RESOLVE_TIMEOUT, $WINHTTP_OPTION_SECURE_PROTOCOLS, $WINHTTP_OPTION_SECURITY_FLAGS, _
                $WINHTTP_OPTION_SECURITY_KEY_BITNESS, $WINHTTP_OPTION_SEND_TIMEOUT, $WINHTTP_OPTION_SPN, $WINHTTP_OPTION_USE_GLOBAL_SERVER_CREDENTIALS, _
                $WINHTTP_OPTION_WORKER_THREAD_COUNT, $WINHTTP_OPTION_WRITE_BUFFER_SIZE, $WINHTTP_OPTION_DECOMPRESSION, $WINHTTP_OPTION_UNSAFE_HEADER_PARSING
            $sType = "dword*"
            $iSize = 4
        Case $WINHTTP_OPTION_CALLBACK, $WINHTTP_OPTION_PASSPORT_SIGN_OUT
            $sType = "ptr*"
            $iSize = 4
            If @AutoItX64 Then $iSize = 8
            If Not IsPtr($vSetting) Then Return SetError(3, 0, 0)
        Case $WINHTTP_OPTION_CONTEXT_VALUE
            $sType = "dword_ptr*"
            $iSize = 4
            If @AutoItX64 Then $iSize = 8
        Case $WINHTTP_OPTION_PASSWORD, $WINHTTP_OPTION_PROXY_PASSWORD, $WINHTTP_OPTION_PROXY_USERNAME, $WINHTTP_OPTION_USER_AGENT, $WINHTTP_OPTION_USERNAME
            $sType = "wstr"
            If (IsDllStruct($vSetting) Or IsPtr($vSetting)) Then Return SetError(3, 0, 0)
            If $iSize < 1 Then $iSize = StringLen($vSetting)
        Case $WINHTTP_OPTION_CLIENT_CERT_CONTEXT, $WINHTTP_OPTION_GLOBAL_PROXY_CREDS, $WINHTTP_OPTION_GLOBAL_SERVER_CREDS, $WINHTTP_OPTION_HTTP_VERSION, _
                $WINHTTP_OPTION_PROXY
            $sType = "ptr"
            If Not (IsDllStruct($vSetting) Or IsPtr($vSetting)) Then Return SetError(3, 0, 0)
        Case Else
            Return SetError(1, 0, 0)
    EndSwitch
    If $iSize < 1 Then
        If IsDllStruct($vSetting) Then
            $iSize = DllStructGetSize($vSetting)
        Else
            Return SetError(2, 0, 0)
        EndIf
    EndIf
    Local $aCall
    If IsDllStruct($vSetting) Then
        $aCall = DllCall($hWINHTTPDLL__WINHTTP, "bool", "WinHttpSetOption", "handle", $hInternet, "dword", $iOption, $sType, DllStructGetPtr($vSetting), "dword", $iSize)
    Else
        $aCall = DllCall($hWINHTTPDLL__WINHTTP, "bool", "WinHttpSetOption", "handle", $hInternet, "dword", $iOption, $sType, $vSetting, "dword", $iSize)
    EndIf
    If @error Or Not $aCall[0] Then Return SetError(4, 0, 0)
    Return 1
EndFunc
Func _WinHttpConnect($hSession, $sServerName, $iServerPort = Default)
    Local $aURL = _WinHttpCrackUrl($sServerName), $iScheme = 0
    If @error Then
        __WinHttpDefault($iServerPort, $INTERNET_DEFAULT_PORT)
    Else
        $sServerName = $aURL[2]
        $iServerPort = $aURL[3]
        $iScheme = $aURL[1]
    EndIf
    Local $aCall = DllCall($hWINHTTPDLL__WINHTTP, "handle", "WinHttpConnect", _
            "handle", $hSession, _
            "wstr", $sServerName, _
            "dword", $iServerPort, _
            "dword", 0)
    If @error Or Not $aCall[0] Then Return SetError(1, 0, 0)
    _WinHttpSetOption($aCall[0], $WINHTTP_OPTION_CONTEXT_VALUE, $iScheme)
    Return $aCall[0]
EndFunc
Func _WinHttpCrackUrl($sURL, $iFlag = Default)
    __WinHttpDefault($iFlag, $ICU_ESCAPE)
    Local $tURL_COMPONENTS = DllStructCreate("dword StructSize;" & _
            "ptr SchemeName;" & _
            "dword SchemeNameLength;" & _
            "int Scheme;" & _
            "ptr HostName;" & _
            "dword HostNameLength;" & _
            "word Port;" & _
            "ptr UserName;" & _
            "dword UserNameLength;" & _
            "ptr Password;" & _
            "dword PasswordLength;" & _
            "ptr UrlPath;" & _
            "dword UrlPathLength;" & _
            "ptr ExtraInfo;" & _
            "dword ExtraInfoLength")
    DllStructSetData($tURL_COMPONENTS, 1, DllStructGetSize($tURL_COMPONENTS))
    Local $tBuffers[6]
    Local $iURLLen = StringLen($sURL)
    For $i = 0 To 5
        $tBuffers[$i] = DllStructCreate("wchar[" & $iURLLen + 1 & "]")
    Next
    DllStructSetData($tURL_COMPONENTS, "SchemeNameLength", $iURLLen)
    DllStructSetData($tURL_COMPONENTS, "SchemeName", DllStructGetPtr($tBuffers[0]))
    DllStructSetData($tURL_COMPONENTS, "HostNameLength", $iURLLen)
    DllStructSetData($tURL_COMPONENTS, "HostName", DllStructGetPtr($tBuffers[1]))
    DllStructSetData($tURL_COMPONENTS, "UserNameLength", $iURLLen)
    DllStructSetData($tURL_COMPONENTS, "UserName", DllStructGetPtr($tBuffers[2]))
    DllStructSetData($tURL_COMPONENTS, "PasswordLength", $iURLLen)
    DllStructSetData($tURL_COMPONENTS, "Password", DllStructGetPtr($tBuffers[3]))
    DllStructSetData($tURL_COMPONENTS, "UrlPathLength", $iURLLen)
    DllStructSetData($tURL_COMPONENTS, "UrlPath", DllStructGetPtr($tBuffers[4]))
    DllStructSetData($tURL_COMPONENTS, "ExtraInfoLength", $iURLLen)
    DllStructSetData($tURL_COMPONENTS, "ExtraInfo", DllStructGetPtr($tBuffers[5]))
    Local $aCall = DllCall($hWINHTTPDLL__WINHTTP, "bool", "WinHttpCrackUrl", _
            "wstr", $sURL, _
            "dword", $iURLLen, _
            "dword", $iFlag, _
            "struct*", $tURL_COMPONENTS)
    If @error Or Not $aCall[0] Then Return SetError(1, 0, 0)
    Local $aRet[8] = [DllStructGetData($tBuffers[0], 1), _
            DllStructGetData($tURL_COMPONENTS, "Scheme"), _
            DllStructGetData($tBuffers[1], 1), _
            DllStructGetData($tURL_COMPONENTS, "Port"), _
            DllStructGetData($tBuffers[2], 1), _
            DllStructGetData($tBuffers[3], 1), _
            DllStructGetData($tBuffers[4], 1), _
            DllStructGetData($tBuffers[5], 1)]
    Return $aRet
EndFunc
Func _WinHttpOpenRequest($hConnect, $sVerb = Default, $sObjectName = Default, $sVersion = Default, $sReferer = Default, $sAcceptTypes = Default, $iFlags = Default)
    __WinHttpDefault($sVerb, "GET")
    __WinHttpDefault($sObjectName, "")
    __WinHttpDefault($sVersion, "HTTP/1.1")
    __WinHttpDefault($sReferer, $WINHTTP_NO_REFERER)
    __WinHttpDefault($iFlags, $WINHTTP_FLAG_ESCAPE_DISABLE)
    Local $pAcceptTypes
    If $sAcceptTypes = Default Or Number($sAcceptTypes) = -1 Then
        $pAcceptTypes = $WINHTTP_DEFAULT_ACCEPT_TYPES
    Else
        Local $aTypes = StringSplit($sAcceptTypes, ",", 2)
        Local $tAcceptTypes = DllStructCreate("ptr[" & UBound($aTypes) + 1 & "]")
        Local $tType[UBound($aTypes)]
        For $i = 0 To UBound($aTypes) - 1
            $tType[$i] = DllStructCreate("wchar[" & StringLen($aTypes[$i]) + 1 & "]")
            DllStructSetData($tType[$i], 1, $aTypes[$i])
            DllStructSetData($tAcceptTypes, 1, DllStructGetPtr($tType[$i]), $i + 1)
        Next
        $pAcceptTypes = DllStructGetPtr($tAcceptTypes)
    EndIf
    Local $aCall = DllCall($hWINHTTPDLL__WINHTTP, "handle", "WinHttpOpenRequest", _
            "handle", $hConnect, _
            "wstr", StringUpper($sVerb), _
            "wstr", $sObjectName, _
            "wstr", StringUpper($sVersion), _
            "wstr", $sReferer, _
            "ptr", $pAcceptTypes, _
            "dword", $iFlags)
    If @error Or Not $aCall[0] Then Return SetError(1, 0, 0)
    Return $aCall[0]
EndFunc
Func _WinHttpSendRequest($hRequest, $sHeaders = Default, $vOptional = Default, $iTotalLength = Default, $iContext = Default)
	__WinHttpDefault($sHeaders, $WINHTTP_NO_ADDITIONAL_HEADERS)
	__WinHttpDefault($vOptional, $WINHTTP_NO_REQUEST_DATA)
	__WinHttpDefault($iTotalLength, 0)
	__WinHttpDefault($iContext, 0)
	Local $pOptional = 0, $iOptionalLength = 0
	If @NumParams > 2 Then
		Local $tOptional
		$iOptionalLength = BinaryLen($vOptional)
		$tOptional = DllStructCreate("byte[" & $iOptionalLength & "]")
		If $iOptionalLength Then $pOptional = DllStructGetPtr($tOptional)
		DllStructSetData($tOptional, 1, $vOptional)
	EndIf
	If Not $iTotalLength Or $iTotalLength < $iOptionalLength Then $iTotalLength += $iOptionalLength
	Local $aCall = DllCall($hWINHTTPDLL__WINHTTP, "bool", "WinHttpSendRequest", _
			"handle", $hRequest, _
			"wstr", $sHeaders, _
			"dword", 0, _
			"ptr", $pOptional, _
			"dword", $iOptionalLength, _
			"dword", $iTotalLength, _
			"dword_ptr", $iContext)
	If @error Or Not $aCall[0] Then Return SetError(1, 0, 0)
	Return 1
EndFunc
Func _WinHttpReceiveResponse($hRequest)
	Local $aCall = DllCall($hWINHTTPDLL__WINHTTP, "bool", "WinHttpReceiveResponse", "handle", $hRequest, "ptr", 0)
	If @error Or Not $aCall[0] Then Return SetError(1, 0, 0)
	Return 1
EndFunc
Func _WinHttpSimpleReadData($hRequest, $iMode = Default)
	If $iMode = Default Then
		$iMode = 0
		If __WinHttpCharSet(_WinHttpQueryHeaders($hRequest, $WINHTTP_QUERY_CONTENT_TYPE)) = 65001 Then $iMode = 1 
	Else
		__WinHttpDefault($iMode, 0)
	EndIf
	If $iMode > 2 Or $iMode < 0 Then Return SetError(1, 0, '')
	Local $vData = Binary('')
	If _WinHttpQueryDataAvailable($hRequest) Then
		Do
			$vData &= _WinHttpReadData($hRequest, 2)
		Until @error
		Switch $iMode
			Case 0
				Return BinaryToString($vData)
			Case 1
				Return BinaryToString($vData, 4)
			Case Else
				Return $vData
		EndSwitch
	EndIf
	Return SetError(2, 0, $vData)
EndFunc
Func __WinHttpCharSet($sContentType)
	Local $aContentType = StringRegExp($sContentType, "(?i).*?\Qcharset=\E(?U)([^ ]+)(;| |\Z)", 2)
	If Not @error Then $sContentType = $aContentType[1]
	If StringLeft($sContentType, 2) = "cp" Then Return Int(StringTrimLeft($sContentType, 2))
	If $sContentType = "utf-8" Then Return 65001
EndFunc
Func _WinHttpQueryHeaders($hRequest, $iInfoLevel = Default, $sName = Default, $iIndex = Default)
	__WinHttpDefault($iInfoLevel, $WINHTTP_QUERY_RAW_HEADERS_CRLF)
	__WinHttpDefault($sName, $WINHTTP_HEADER_NAME_BY_INDEX)
	__WinHttpDefault($iIndex, $WINHTTP_NO_HEADER_INDEX)
	Local $aCall = DllCall($hWINHTTPDLL__WINHTTP, "bool", "WinHttpQueryHeaders", _
			"handle", $hRequest, _
			"dword", $iInfoLevel, _
			"wstr", $sName, _
			"wstr", "", _
			"dword*", 65536, _
			"dword*", $iIndex)
	If @error Or Not $aCall[0] Then Return SetError(1, 0, "")
	Return SetExtended($aCall[6], $aCall[4])
EndFunc
Func _WinHttpQueryDataAvailable($hRequest)
	Local $sReadType = "dword*"
	If BitAND(_WinHttpQueryOption(_WinHttpQueryOption(_WinHttpQueryOption($hRequest, $WINHTTP_OPTION_PARENT_HANDLE), $WINHTTP_OPTION_PARENT_HANDLE), $WINHTTP_OPTION_CONTEXT_VALUE), $WINHTTP_FLAG_ASYNC) Then $sReadType = "ptr"
	Local $aCall = DllCall($hWINHTTPDLL__WINHTTP, "bool", "WinHttpQueryDataAvailable", "handle", $hRequest, $sReadType, 0)
	If @error Then Return SetError(1, 0, 0)
	Return SetExtended($aCall[2], $aCall[0])
EndFunc
Func _WinHttpQueryOption($hInternet, $iOption)
	Local $aCall = DllCall($hWINHTTPDLL__WINHTTP, "bool", "WinHttpQueryOption", _
			"handle", $hInternet, _
			"dword", $iOption, _
			"ptr", 0, _
			"dword*", 0)
	If @error Or $aCall[0] Then Return SetError(1, 0, "")
	Local $iSize = $aCall[4]
	Local $tBuffer
	Switch $iOption
		Case $WINHTTP_OPTION_CONNECTION_INFO, $WINHTTP_OPTION_PASSWORD, $WINHTTP_OPTION_PROXY_PASSWORD, $WINHTTP_OPTION_PROXY_USERNAME, $WINHTTP_OPTION_URL, $WINHTTP_OPTION_USERNAME, $WINHTTP_OPTION_USER_AGENT, _
				$WINHTTP_OPTION_PASSPORT_COBRANDING_TEXT, $WINHTTP_OPTION_PASSPORT_COBRANDING_URL
			$tBuffer = DllStructCreate("wchar[" & $iSize + 1 & "]")
		Case $WINHTTP_OPTION_PARENT_HANDLE, $WINHTTP_OPTION_CALLBACK, $WINHTTP_OPTION_SERVER_CERT_CONTEXT
			$tBuffer = DllStructCreate("ptr")
		Case $WINHTTP_OPTION_CONNECT_TIMEOUT, $WINHTTP_AUTOLOGON_SECURITY_LEVEL_HIGH, $WINHTTP_AUTOLOGON_SECURITY_LEVEL_LOW, $WINHTTP_AUTOLOGON_SECURITY_LEVEL_MEDIUM, _
				$WINHTTP_OPTION_CONFIGURE_PASSPORT_AUTH, $WINHTTP_OPTION_CONNECT_RETRIES, $WINHTTP_OPTION_EXTENDED_ERROR, $WINHTTP_OPTION_HANDLE_TYPE, $WINHTTP_OPTION_MAX_CONNS_PER_1_0_SERVER, _
				$WINHTTP_OPTION_MAX_CONNS_PER_SERVER, $WINHTTP_OPTION_MAX_HTTP_AUTOMATIC_REDIRECTS, $WINHTTP_OPTION_RECEIVE_RESPONSE_TIMEOUT, $WINHTTP_OPTION_RECEIVE_TIMEOUT, _
				$WINHTTP_OPTION_RESOLVE_TIMEOUT, $WINHTTP_OPTION_SECURITY_FLAGS, $WINHTTP_OPTION_SECURITY_KEY_BITNESS, $WINHTTP_OPTION_SEND_TIMEOUT
			$tBuffer = DllStructCreate("int")
		Case $WINHTTP_OPTION_CONTEXT_VALUE
			$tBuffer = DllStructCreate("dword_ptr")
		Case Else
			$tBuffer = DllStructCreate("byte[" & $iSize & "]")
	EndSwitch
	$aCall = DllCall($hWINHTTPDLL__WINHTTP, "bool", "WinHttpQueryOption", _
			"handle", $hInternet, _
			"dword", $iOption, _
			"struct*", $tBuffer, _
			"dword*", $iSize)
	If @error Or Not $aCall[0] Then Return SetError(2, 0, "")
	Return DllStructGetData($tBuffer, 1)
EndFunc
Func _WinHttpReadData($hRequest, $iMode = Default, $iNumberOfBytesToRead = Default, $pBuffer = Default)
	__WinHttpDefault($iMode, 0)
	__WinHttpDefault($iNumberOfBytesToRead, 8192)
	Local $tBuffer, $vOutOnError = ""
	If $iMode = 2 Then $vOutOnError = Binary($vOutOnError)
	Switch $iMode
		Case 1, 2
			If $pBuffer And $pBuffer <> Default Then
				$tBuffer = DllStructCreate("byte[" & $iNumberOfBytesToRead & "]", $pBuffer)
			Else
				$tBuffer = DllStructCreate("byte[" & $iNumberOfBytesToRead & "]")
			EndIf
		Case Else
			$iMode = 0
			If $pBuffer And $pBuffer <> Default Then
				$tBuffer = DllStructCreate("char[" & $iNumberOfBytesToRead & "]", $pBuffer)
			Else
				$tBuffer = DllStructCreate("char[" & $iNumberOfBytesToRead & "]")
			EndIf
	EndSwitch
	Local $sReadType = "dword*"
	If BitAND(_WinHttpQueryOption(_WinHttpQueryOption(_WinHttpQueryOption($hRequest, $WINHTTP_OPTION_PARENT_HANDLE), $WINHTTP_OPTION_PARENT_HANDLE), $WINHTTP_OPTION_CONTEXT_VALUE), $WINHTTP_FLAG_ASYNC) Then $sReadType = "ptr"
	Local $aCall = DllCall($hWINHTTPDLL__WINHTTP, "bool", "WinHttpReadData", _
			"handle", $hRequest, _
			"struct*", $tBuffer, _
			"dword", $iNumberOfBytesToRead, _
			$sReadType, 0)
	If @error Or Not $aCall[0] Then Return SetError(1, 0, "")
	If Not $aCall[4] Then Return SetError(-1, 0, $vOutOnError)
	If $aCall[4] < $iNumberOfBytesToRead Then
		Switch $iMode
			Case 0
				Return SetExtended($aCall[4], StringLeft(DllStructGetData($tBuffer, 1), $aCall[4]))
			Case 1
				Return SetExtended($aCall[4], BinaryToString(BinaryMid(DllStructGetData($tBuffer, 1), 1, $aCall[4]), 4))
			Case 2
				Return SetExtended($aCall[4], BinaryMid(DllStructGetData($tBuffer, 1), 1, $aCall[4]))
		EndSwitch
	Else
		Switch $iMode
			Case 0, 2
				Return SetExtended($aCall[4], DllStructGetData($tBuffer, 1))
			Case 1
				Return SetExtended($aCall[4], BinaryToString(DllStructGetData($tBuffer, 1), 4))
		EndSwitch
	EndIf
EndFunc
Func _WinHttpCloseHandle($hInternet)
	Local $aCall = DllCall($hWINHTTPDLL__WINHTTP, "bool", "WinHttpCloseHandle", "handle", $hInternet)
	If @error Or Not $aCall[0] Then Return SetError(1, 0, 0)
	Return 1
EndFunc
#EndRegion WinHttp