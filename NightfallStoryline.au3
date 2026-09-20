#RequireAdmin
Local $hBotMutex = DllCall("kernel32.dll", "handle", "CreateMutexW", "ptr", 0, "bool", False, "wstr", "Global\NightfallStorylineBot")
If @error Or $hBotMutex[0] = 0 Then Exit 1
Local $tMutex = TimerInit()
While DllCall("kernel32.dll", "dword", "GetLastError")[0] = 183 And TimerDiff($tMutex) < 30000
    Sleep(500)
    DllCall("kernel32.dll", "handle", "CreateMutexW", "ptr", 0, "bool", False, "wstr", "Global\NightfallStorylineBot")
WEnd
If DllCall("kernel32.dll", "dword", "GetLastError")[0] = 183 Then
    MsgBox(48, "NightfallStoryline", "Ya hay otro bot corriendo. Cierralo antes de abrir uno nuevo.", 10)
    Exit 1
EndIf
#include "GwAu3-main\API\_GwAu3.au3"
#include "lib\_Au3CheckStubs.au3"
#include "lib\_TrialCompat.au3" ; FREE 1-16: huerfanas de fases 17+ (restores M08/RP, utils PMP/TV)
#include "lib\_UpgradeCommand.au3" 
#include "lib\_GwNFAgentIDs.au3" 
Global $g_bGwDown = False
; FREE 1-16: la fase M11 no existe en este bot -> su flag de hold siempre False.
Global $g_bM11HoldPosition = False                 
Global $g_bUserPaused = False             
Global $g_bTeamSetupRunning = False       
Global $g_bPostTravelQuietUntil = 0       
Global $g_sForcedChar = ""
For $ci = 1 To $CmdLine[0]
    If $CmdLine[$ci] = "--char" And $ci < $CmdLine[0] Then $g_sForcedChar = StringStripWS($CmdLine[$ci + 1], 3)
Next
#include "lib\_Helpers.au3"      
#include "lib\_Recovery.au3"     
#include "lib\_Bot.au3"          
#include "lib\_Cinematic.au3"    
#include "lib\_CombatSkills.au3" 
#include "lib\_Combat.au3"       
#include "lib\_Loot.au3"         
#include "lib\_Inventory.au3"    
#include "lib\_Gadgets.au3"      
#include "lib\_Mission.au3"      
#include "lib\_Equipment.au3"    
#include "lib\_Sunspear.au3"     
#include "lib\_Quests.au3"       
#include "lib\_Travel.au3"       
#include "lib\_Heroes.au3"       
#include "lib\_Recorder.au3"     
#include "lib\_AutoLevel.au3"    
#include "lib\_AutoParty.au3"    
#include "lib\_GameEvents.au3"   
#include "lib\_PartyRecovery.au3" 
#include "missions\phases\_phases_index.au3"
Global Const $doLoadLoggedChars = True
Global Const $botName = "Nightfall Storyline"
Global Const $botVersion = "0.1.0-reset"
Opt("GUIOnEventMode", True)
Opt("GUICloseOnESC", False)
Opt("ExpandVarStrings", 1)
HotKeySet("{F8}", "_CaptureWaypoint")
HotKeySet("{F10}", "_CaptureTarget")
HotKeySet("{F7}", "_ScanArea")
#Region GLOBALS
Global $BotRunning = False
Global $Bot_Core_Initialized = False
Global $g_BIA_TestApplyDone = False   
Global $g_sPendingAction = ""
Global $g_bActionRunning = False
Global $g_iPendingTravelMapId = 0   
Global $g_iRequestedPhase = -1      
Global $g_bChainMode = False
Global $g_sQueuedPhase = ""
Global $g_sLastFailedPhase = ""     
Global $g_iRequeueCount = 0         
Global $g_iMaxRequeue = 5           
Global $g_sRedirectPhase = ""
Global $g_bForceRunOnce = False
Global $g_sDbgLastPending = ""   
Global $DLL_PATH = @ScriptDir & "\GwAu3-main\API\Plugins\Pathfinder\GWPathfinder.dll"
#EndRegion GLOBALS
#Region STATES
Global $g_state = $NF_STATE_IDLE
Global $g_currentMission = ""   
Global $g_currentPhase = ""     
#EndRegion STATES
Global $g_idStatsTitle = 0
#include "gui\MainWindow.au3"
#include "gui\UiStatus.au3"
Combat_LoadConfig()
Func _NF_MainCharName()
    If $g_sForcedChar <> "" Then Return $g_sForcedChar
    Return IniRead(@ScriptDir & "\config.ini", "Debug", "MainCharName", "")
EndFunc
Func _NF_TagGwHandle($h, $charName)
    If $h = 0 Or $charName = "" Then Return False
    If StringInStr(WinGetTitle($h), $charName, 2) > 0 Then Return True 
    WinSetTitle($h, "", $charName)
    Out("[GwTag] ventana GW (hWnd=" & $h & ") titulada '" & $charName & "'")
    Return True
EndFunc
Func _NF_TagGwWindowByPid($pid, $charName)
    If $pid = 0 Or $charName = "" Then Return False
    Local $tW = TimerInit()
    While TimerDiff($tW) < 30000
        Local $aW = WinList("[CLASS:ArenaNet_Dx_Window_Class]")
        If IsArray($aW) And $aW[0][0] >= 1 Then
            For $wi = 1 To $aW[0][0]
                If WinGetProcess($aW[$wi][1]) = $pid Then
                    Return _NF_TagGwHandle($aW[$wi][1], $charName)
                EndIf
            Next
        EndIf
        Sleep(1000)
    WEnd
    Out("[GwTag] WARN: sin ventana para PID=" & $pid & " en 30s (no etiquetada)")
    Return False
EndFunc
Func _NF_FindGwWindow()
    If $g_i_GWProcessId <> 0 Then
        Local $aP = WinList("[CLASS:ArenaNet_Dx_Window_Class]")
        If IsArray($aP) And $aP[0][0] >= 1 Then
            For $i = 1 To $aP[0][0]
                If WinGetProcess($aP[$i][1]) = $g_i_GWProcessId Then
                    _NF_TagGwHandle($aP[$i][1], _NF_MainCharName())
                    Return $aP[$i][1]
                EndIf
            Next
        EndIf
    EndIf
    Local $hChar = _NF_FindGwByCharName()
    If $hChar <> 0 Then Return $hChar
    Return 0 
EndFunc
Func _NF_FindGwByCharName()
    Local $sTarget = _NF_MainCharName()
    If $sTarget = "" Then Return 0
    Local $aP = ProcessList("gw.exe")
    If Not IsArray($aP) Or $aP[0][0] < 1 Then Return 0
    For $i = 1 To $aP[0][0]
        Local $sCmd = _NF_GetGwCmdLine($aP[$i][1])
        Local $m = StringRegExp($sCmd, '(?i)-character\s+"([^"]+)"', 1)
        If IsArray($m) And StringCompare(StringStripWS($m[0], 3), $sTarget, 2) = 0 Then
            $g_i_GWProcessId = $aP[$i][1] 
            Out("[GwPid] anclado PID=" & $aP[$i][1] & " (char='" & $sTarget & "')")
            Local $hRet = _NF_FindGwWindow() 
            If $hRet <> 0 Then Return $hRet
        EndIf
    Next
    Local $aW = WinList("[CLASS:ArenaNet_Dx_Window_Class]")
    If IsArray($aW) And $aW[0][0] >= 1 Then
        For $wi = 1 To $aW[0][0]
            If StringInStr(WinGetTitle($aW[$wi][1]), $sTarget, 2) > 0 Then
                Local $pidT = WinGetProcess($aW[$wi][1])
                $g_i_GWProcessId = $pidT 
                Out("[GwPid] anclado por TITULO PID=" & $pidT & " (char='" & $sTarget & "')")
                Return $aW[$wi][1]
            EndIf
        Next
    EndIf
    For $si = 1 To $aP[0][0]
        Local $pidS = $aP[$si][1]
        Memory_Open($pidS)
        If $g_h_GWProcess Then
            Local $sScan = Scanner_ScanForCharname()
            Memory_Close()
            $g_h_GWProcess = 0
            If StringCompare(StringStripWS($sScan, 3), $sTarget, 2) = 0 Then
                $g_i_GWProcessId = $pidS 
                Out("[GwPid] anclado por SCANNER PID=" & $pidS & " (char='" & $sTarget & "')")
                Local $hRet2 = _NF_FindGwWindow() 
                If $hRet2 <> 0 Then Return $hRet2
            EndIf
        Else
            Memory_Close()
            $g_h_GWProcess = 0
        EndIf
    Next
    Return 0
EndFunc
Func SendGWKey($h, $key)
    WinActivate($h)
    WinWaitActive($h, "", 2)
    For $i = 1 To 2
        ControlSend($h, "", "", $key)
        Sleep(120)
    Next
EndFunc
Func _NF_ReconnectNoThenEnter($h)
    SendGWKey($h, "n")
    Sleep(300)
    SendGWKey($h, "{ENTER}")
EndFunc
Func _NF_SelectCharAndEnter($charName)
    Local $tChSel = TimerInit()
    Local $sChars = ""
    While TimerDiff($tChSel) < 120000
        If Map_GetMapID() > 0 Then
            Out("[CharSelect] ya in-game (map=" & Map_GetMapID() & "), no hace falta seleccionar")
            Return
        EndIf
        $sChars = StringStripWS(Scanner_GetLoggedCharNames(), 3)
        If $sChars <> "" Then ExitLoop 
        Sleep(1000)
    WEnd
    If $sChars = "" Then
        Out("[CharSelect] warning: GW no llego a char-select en 120s (scanner sin personajes)")
        Return
    EndIf
    Out("[CharSelect] char-select detectado (scanner) -> chars='" & $sChars & "' objetivo='" & $charName & "'")
    Local $h = _NF_FindGwWindow()
    If $h = 0 Then
        Out("[CharSelect] no se encontro la ventana de GW (ni por clase ni por título)")
        Return
    EndIf
    Local $aParts = StringSplit($sChars, "|")
    Local $nChars = IsArray($aParts) ? ($aParts[0] > 0 ? $aParts[0] : 1) : 1
    If $nChars > 1 And $charName <> "" Then
        Local $desiredIdx = -1
        For $i = 1 To $nChars
            If StringCompare($aParts[$i], $charName, 2) = 0 Then
                $desiredIdx = $i - 1
                ExitLoop
            EndIf
        Next
        If $desiredIdx > 0 Then
            Out("[CharSelect] ciclar " & $desiredIdx & "x a la derecha para '" & $charName & "'")
            For $i = 1 To $desiredIdx
                SendGWKey($h, "{RIGHT}")
                Sleep(250)
            Next
        EndIf
    EndIf
    Out("[CharSelect] ENTER con objetivo '" & $charName & "' (nChars=" & $nChars & ")")
    _NF_ReconnectNoThenEnter($h)
    Local $tWait = TimerInit()
    Local $lastScan = TimerInit()
    Local $lastEnter = TimerInit()
    Local $enterTries = 0
    While TimerDiff($tWait) < 120000
        If Map_GetMapID() > 0 Then ExitLoop 
        Local $enterGap = 10000
        If $enterTries >= 6 Then
            $enterGap = 35000
        ElseIf $enterTries >= 3 Then
            $enterGap = 20000
        EndIf
        If TimerDiff($lastEnter) > $enterGap Then
            $lastEnter = TimerInit()
            If StringStripWS(Scanner_GetLoggedCharNames(), 3) <> "" Then
                $enterTries += 1
                Out("[CharSelect] reintento " & $enterTries & " ENTER (seguimos en char-select, map=0)")
                _NF_ReconnectNoThenEnter($h)
            EndIf
        EndIf
        If TimerDiff($lastScan) > 8000 And $g_i_GWProcessId <> 0 Then
            $lastScan = TimerInit()
            Out("[CharSelect] re-scan patrones -> PID=" & $g_i_GWProcessId & " (map=" & Map_GetMapID() & ")")
            $g_b_SectionsInitialized = False
            $g_p_GwAu3Scan = 0
            $g_p_GwAu3Header = 0
            Core_Initialize($g_i_GWProcessId, False)
            Out("[CharSelect] re-scan -> map=" & Map_GetMapID() & " HP=" & Agent_GetAgentInfo(-2, "HP") & " Name='" & Agent_GetAgentInfo(-2, "Name") & "'")
        EndIf
        Sleep(500)
    WEnd
    Out("[CharSelect] resultado: in-game (map=" & Map_GetMapID() & ")")
    Sleep(2000)
    Local $cur = StringStripWS(Player_GetCharName(), 3)
    If $cur <> "" And StringCompare($cur, $charName, 0) <> 0 Then
    If $g_sForcedChar = "" Then IniWrite(@ScriptDir & "\config.ini", "Debug", "MainCharName", StringStripWS($cur, 3))
        Out("[CharSelect] cuenta ABIERTA detectada: char real='" & $cur & "' -> MainCharName actualizado")
    EndIf
EndFunc
Gui_v2_Init()
Out("[Init] Bot listo. Selecciona una cuenta en el desplegable.")
Ui_SetStatus("Selecciona una cuenta en el desplegable.")
Global $g_wdTimer        = TimerInit()        
Global $g_wdDeadChecks   = 0                   
Global $g_wdMap0Since    = 0                    
Global $g_wdLoadingSince = 0                    
Global $g_wdLastRelaunch = 0                    
Global Const $NF_WD_PERIOD_MS    = 20000        
Global Const $NF_WD_DEAD_NEEDED  = 3            
Global Const $NF_WD_DESYNC_MS    = 90000        
Global Const $NF_WD_COOLDOWN_MS  = 120000       
Global $g_wdReconnectNeeded = False    
Global $g_wdOldPids = ""               
Global $g_wdReconnectChar = ""         
Global $g_wdReconnectTick = 0          
Global $g_wdReconnectPhase = 0         
Global $g_wdReconnectBusy = False      
Global $g_wdRelLaunchTick = 0          
Global $g_wdRelaunchFails = 0          
Global $g_wdGiveUpUntil = 0            
Global Const $NF_WD_MAX_RELAUNCHES = 3 
Global Const $NF_WD_GIVEUP_MS    = 900000 
Global $NF_WD_RESTART_CNT_FILE = @TempDir & "\gwbot\wd_restart_count"
Global Const $NF_WD_MAX_BOT_RESTARTS = 3  
Global $g_wdBotRestartFirst = 0           
Global $g_wdRestartPending = False
Global $g_bLaunching = False
Global Const $NF_LAUNCH_CORE_TRIES = 6        
Global Const $NF_LAUNCH_CORE_TIMEOUT_MS = 60000 
Global $g_asTimer    = TimerInit()             
Global $g_asLastX    = 0                         
Global $g_asLastY    = 0                         
Global $g_asStillMs  = 0                          
Global $g_asNudges   = 0                           
Global Const $NF_AS_PERIOD_MS = 5000             
Global Const $NF_AS_MOVE_U    = 120               
Global Const $NF_AS_STILL_MS  = 10000             
Global Const $NF_AS_NUDGE_U   = 250               
Global $g_hwTimer   = TimerInit()    
Global $g_hwLastX   = 0              
Global $g_hwLastY   = 0              
Global $g_hwSince   = 0              
Global $g_hwNudges  = 0              
Global $g_hwNX = 0, $g_hwNY = 0      
Global $g_hwLastZ = ""               
Global Const $NF_HW_PERIOD_MS = 5000   
Global Const $NF_HW_MOVE_U     = 120   
Global Const $NF_HW_STILL_MS   = 10000 
Global Const $NF_HW_NUDGE_U    = 250   
Global Const $NF_HW_MAX_NUDGES = 3     
Global Const $NF_HW_ZONE_GRACE_MS = 90000 
Global $g_hwLastMap = -2              
Global $g_hwMapSince = TimerInit()    
Func _NF_IsWine()
    Local $a = DllCall("ntdll.dll", "str", "wine_get_version")
    Return (Not @error)
EndFunc
Func _NF_LaunchGw($charName, $bToCharSelect = False)
    Local $cfg = @ScriptDir & "\config.ini"
    Local $char = $charName
    If $char = "" Then $char = IniRead($cfg, "GW", "Character", "")
    If _NF_IsWine() Then
        Out("[Launch] launch_gw.sh (segundo plano)")
        ShellExecute("bash", 'tools/launch_gw.sh "' & $charName & '"', @ScriptDir, "", @SW_HIDE)
        Return
    EndIf
    Local $launcherDir = _FindGwLauncherDir()
    If $launcherDir = "" Then Return False
    Local $launcherExe = $launcherDir & "\GW_Launcher.exe"
    If FileExists($launcherExe) Then
        If ProcessExists("GW_Launcher.exe") Then
            Out("[Launch] GW_Launcher.exe stale detectado -> matar antes de relanzar")
            RunWait('taskkill /F /IM GW_Launcher.exe', @ScriptDir, @SW_HIDE)
            Sleep(2000)
        EndIf
        If $bToCharSelect Then
            Out("[Launch] GW_Launcher -launch a char-select (char='" & $char & "')")
        Else
            Out("[Launch] GW_Launcher -launch (char='" & $char & "')")
        EndIf
        Run('"' & $launcherExe & '" -launch "' & $char & '"', $launcherDir)
        Return
    EndIf
    Local $gwPath = IniRead($cfg, "GW", "GwPath", "")
    Local $email  = IniRead($cfg, "GW", "Email", "")
    Local $pass   = IniRead($cfg, "GW", "Password", "")
    Local $extra  = IniRead($cfg, "GW", "ExtraArgs", "")
    If $gwPath = "" Then
        Out("[Launch] Falta [GW] LauncherPath, GwPath y GW_Launcher.exe -> no puedo lanzar GW")
        Return
    EndIf
    Local $cmd = '"' & $gwPath & '"'
    If $email <> "" Then $cmd &= ' -email "' & $email & '" -maillen ' & StringLen($email)
    If $pass  <> "" Then $cmd &= ' -password "' & $pass & '" -passwordlen ' & StringLen($pass)
    If $char <> "" And Not $bToCharSelect Then $cmd &= ' -character "' & $char & '"'
    If $extra <> "" Then $cmd &= ' ' & $extra
    Local $iSlash = StringInStr($gwPath, "\", 0, -1)
    Local $gwDir = @ScriptDir
    If $iSlash > 1 Then $gwDir = StringLeft($gwPath, $iSlash - 1)
    If $bToCharSelect Then
        Out("[Launch] GW nativo Windows a char-select (char='" & $char & "')")
    Else
        Out("[Launch] GW nativo Windows (char='" & $char & "')")
    EndIf
    Run($cmd, $gwDir)
EndFunc
Func _NF_RestartBot()
    If _NF_IsWine() Then
        ShellExecute("bash", "tools/reload_bot.sh --force", @ScriptDir, "", @SW_HIDE)
    Else
        Local $sAS = ""
        If IniRead(@ScriptDir & "\config.ini", "General", "AutoStart", "0") = "1" Then $sAS = " --autostart"
        If $g_sForcedChar <> "" Then $sAS &= ' --char "' & $g_sForcedChar & '"'
        Run(@AutoItExe & ' "' & @ScriptFullPath & '"' & $sAS, @ScriptDir)
        Sleep(300)
        Exit
    EndIf
EndFunc
Func _NF_LaunchAccount($accountName)
    Out("[Launch] _NF_LaunchAccount ENTER acct='" & $accountName & "' g_bLaunching=" & $g_bLaunching)
    If $g_bLaunching Then
        Out("[Launch] _NF_LaunchAccount ya en curso -> ignoro doble llamada")
        Return False
    EndIf
    Local $procsCheck = ProcessList("gw.exe")
    If IsArray($procsCheck) And $procsCheck[0][0] > 0 Then
        For $ck = 1 To $procsCheck[0][0]
            Local $cmdCk = _NF_GetGwCmdLine($procsCheck[$ck][1])
            If StringInStr($cmdCk, $accountName) > 0 Then
                Out("[Launch] gw.exe YA abierto para '" & $accountName & "' PID=" & $procsCheck[$ck][1] & " -> NO lanzar duplicado")
                $g_bLaunching = False
                Return False   
            EndIf
        Next
    EndIf
    $g_bLaunching = True
    Out("[Launch] guard OK, g_bLaunching=True")
    Local $launcherDir = _FindGwLauncherDir()
    If $launcherDir = "" Then
        Ui_SetStatus("Falta GW_Launcher\GW_Launcher.exe junto al bot.")
        $g_bLaunching = False
        Return False
    EndIf
    Local $launcherExe = $launcherDir & "\GW_Launcher.exe"
    If Not FileExists($launcherExe) Then
        Out("[Launch] GW_Launcher.exe no encontrado en " & $launcherExe)
        Ui_SetStatus("Error: GW_Launcher.exe no encontrado")
        $g_bLaunching = False
        Return False
    EndIf
    Local $aOldPids[1] = [0]
    Local $procs = ProcessList("gw.exe")
    If IsArray($procs) And $procs[0][0] > 0 Then
        ReDim $aOldPids[$procs[0][0] + 1]
        $aOldPids[0] = $procs[0][0]
        For $i = 1 To $procs[0][0]
            $aOldPids[$i] = $procs[$i][1]
        Next
    EndIf
    Out("[Launch] snapshot done, oldPids count=" & $aOldPids[0])
    Out("[Launch] GW_Launcher.exe -launch """ & $accountName & """")
    Ui_SetStatus("Abriendo GW con '" & $accountName & "'...")
    Run('"' & $launcherExe & '" -launch "' & $accountName & '"', $launcherDir)
    Local $tWait = TimerInit()
    Local $pid = 0
    Local $rejected = ""
    While TimerDiff($tWait) < 40000
        Sleep(1000)
        Local $procs = ProcessList("gw.exe")
        If IsArray($procs) Then
            For $i = 1 To $procs[0][0]
                Local $bOld = False
                For $j = 1 To $aOldPids[0]
                    If $procs[$i][1] = $aOldPids[$j] Then
                        $bOld = True
                        ExitLoop
                    EndIf
                Next
                If Not $bOld Then
                    Local $cmdNew = _NF_GetGwCmdLine($procs[$i][1])
                    Local $mChar = StringRegExp($cmdNew, '(?i)-character\s+"([^"]+)"', 1)
                    If IsArray($mChar) Then
                        If StringCompare($mChar[0], $accountName, 2) <> 0 Then
                            If Not StringInStr("," & $rejected & ",", "," & $procs[$i][1] & ",") Then
                                $rejected &= "," & $procs[$i][1]
                                Out("[Launch] gw.exe nuevo (PID=" & $procs[$i][1] & ") es de '" & $mChar[0] & "' != objetivo '" & $accountName & "' -> rechazar (NO tocar cuenta ajena)")
                            EndIf
                            ContinueLoop
                        EndIf
                    EndIf
                    $pid = $procs[$i][1]
                    ExitLoop
                EndIf
            Next
        EndIf
        If $pid <> 0 Then ExitLoop
    WEnd
    If $pid = 0 Then
        Out("[Launch] Timeout: gw.exe nuevo no apareció en 40s")
        Ui_SetStatus("Error: GW no se abrió. Inténtalo de nuevo.")
        $g_bLaunching = False
        Return False
    EndIf
    Out("[Launch] gw.exe nuevo detectado (PID=" & $pid & ")")
    Ui_SetStatus("GW abierto (PID=" & $pid & "). Conectando...")
    _NF_TagGwWindowByPid($pid, $accountName)
    $g_b_AutoUpdate = False
    Local $ok = 0
    Local $tCore = TimerInit()
    For $t = 1 To $NF_LAUNCH_CORE_TRIES
        If Not ProcessExists($pid) Then ExitLoop
        If TimerDiff($tCore) > $NF_LAUNCH_CORE_TIMEOUT_MS Then ExitLoop
        Sleep(3000)
        $ok = Core_Initialize($pid, False)
        Out("[Init] Core_Initialize (intento " & $t & "/" & $NF_LAUNCH_CORE_TRIES & ") devolvió: " & $ok)
        If $ok <> 0 Then ExitLoop
    Next
    If $ok = 0 Then
        Out("[Init] ERROR: Core_Initialize fallo para PID=" & $pid & " tras " & $NF_LAUNCH_CORE_TRIES & " intentos")
        Ui_SetStatus("Error: no se pudo conectar a GW. Reintenta.")
        $Bot_Core_Initialized = False
        $g_bLaunching = False
        Return False
    EndIf
    $Bot_Core_Initialized = True
    Out("[Init] Conectado a GW (PID=" & $pid & ")")
    _NF_SelectCharAndEnter($accountName)
    Local $tLoad = TimerInit()
    While TimerDiff($tLoad) < 30000
        Local $hp = Agent_GetAgentInfo(-2, "HP")
        Local $lv = Agent_GetAgentInfo(-2, "Level")
        Local $px = Agent_GetAgentInfo(-2, "X")
        If $hp > 0 And $lv > 0 And ($px <> 0 Or Agent_GetAgentInfo(-2, "Y") <> 0) Then ExitLoop
        Out("[Init] esperando carga del personaje (hp=" & $hp & " lv=" & $lv & " pos=(" & $px & "," & Agent_GetAgentInfo(-2, "Y") & "))")
        Sleep(2000)
    WEnd
    If TimerDiff($tLoad) >= 30000 Then
        Out("[Init] WARNING: personaje no cargó en 30s, continuando de todas formas")
    Else
        Out("[Init] personaje cargado en " & Round(TimerDiff($tLoad)/1000) & "s")
        $g_wdBotRestartFirst = 0
        If FileExists($NF_WD_RESTART_CNT_FILE) Then FileDelete($NF_WD_RESTART_CNT_FILE)
    EndIf
    GUICtrlSetBkColor($lbl_connDot, 0x2E9E4F)
    GUICtrlSetData($lbl_connText, "Connected")
    $g_sCache_connText = "Connected"
    GUICtrlSetState($btnRunPhase, $GUI_ENABLE)
    GUICtrlSetState($btnPause, $GUI_ENABLE)
    GUICtrlSetState($btnRecord, $GUI_ENABLE)
    AdlibRegister("_UiTick", 500)
    GameEvents_Init()
    Local $sRealName = Agent_GetAgentInfo(-2, "Name")
    If $sRealName <> "" And $sRealName <> "0" And StringInStr($sRealName, "[") = 0 Then $g_sCache_charName = $sRealName
    _AutoDetectDonePhases()
    Pathfinder_SetSwitchTeleportCallback("NF_SwitchTeleportHandler")
    Ui_SetStatus("Conectado a '" & $accountName & "'. Fase auto-arrancando...")
    $g_bLaunching = False
    Return True
EndFunc
Func _NF_GetGwCmdLine($pid)
    Local $cmd = ""
    Local $wmi = ObjGet("winmgmts:\\\\.\\root\\cimv2")
    If IsObj($wmi) Then
        Local $cols = $wmi.ExecQuery("SELECT CommandLine FROM Win32_Process WHERE ProcessId=" & $pid)
        For $o In $cols
            $cmd = $o.CommandLine
            ExitLoop
        Next
    EndIf
    Return $cmd
EndFunc
Func _NF_KillBotGw()
    Local $charName = _NF_MainCharName()
    If $charName = "" Then Return False
    Local $bKilled = False
    Local $killPids = ""
    Local $aAllGw = ProcessList("gw.exe")
    If Not IsArray($aAllGw) Or $aAllGw[0][0] = 0 Then
        Out("[Watchdog] _NF_KillBotGw: no hay gw.exe -> nada que matar")
        Return False
    EndIf
    For $si = 1 To $aAllGw[0][0]
        Local $pidGw = $aAllGw[$si][1]
        Local $cmdGw = _NF_GetGwCmdLine($pidGw)
        Local $bMine = (StringInStr($cmdGw, $charName) > 0) Or ($g_i_GWProcessId <> 0 And $pidGw = $g_i_GWProcessId)
        If Not $bMine Then
            Local $aKW = WinList("[CLASS:ArenaNet_Dx_Window_Class]")
            If IsArray($aKW) And $aKW[0][0] >= 1 Then
                For $ki = 1 To $aKW[0][0]
                    If WinGetProcess($aKW[$ki][1]) = $pidGw And StringInStr(WinGetTitle($aKW[$ki][1]), $charName, 2) > 0 Then
                        $bMine = True
                        ExitLoop
                    EndIf
                Next
            EndIf
        EndIf
        If $bMine Then
            Out("[Watchdog] mata gw del bot (PID=" & $pidGw & ", char='" & $charName & "')")
            ProcessClose($pidGw)
            $killPids &= "," & $pidGw
            $bKilled = True
        Else
            Out("[Watchdog] gw ajeno (otra cuenta) PID=" & $pidGw & " -> NO tocar")
        EndIf
    Next
    If $killPids <> "" Then
        Local $tKillGw = TimerInit()
        While TimerDiff($tKillGw) < 15000
            Local $still = 0
            Local $chkGw = ProcessList("gw.exe")
            If IsArray($chkGw) And $chkGw[0][0] > 0 Then
                For $si2 = 1 To $chkGw[0][0]
                    If StringInStr("," & $killPids & ",", "," & $chkGw[$si2][1] & ",") > 0 Then $still = 1
                Next
            EndIf
            If Not $still Then ExitLoop
            Sleep(500)
        WEnd
        Out("[Watchdog] gw del bot (PIDs " & $killPids & ") liberado")
    EndIf
    Return $bKilled
EndFunc
Func _NF_WdGiveUpWithRestart($reason)
    If $g_wdRestartPending Then Return
    If $g_wdGiveUpUntil <> 0 And TimerDiff($g_wdGiveUpUntil) < $NF_WD_GIVEUP_MS Then
        $g_bGwDown = True
        $g_wdDeadChecks = 0
        Out("[Watchdog] ventana de rendicion activa (" & Round(($NF_WD_GIVEUP_MS - TimerDiff($g_wdGiveUpUntil)) / 1000) & "s) -> sin reinicio (abre GW a mano)")
        Return
    EndIf
    $g_wdGiveUpUntil = 0
    $g_wdRestartPending = True
    $g_bGwDown = True
    If FileExists($NF_WD_RESTART_CNT_FILE) Then
        $g_wdBotRestartFirst = TimerInit() - 0
    EndIf
    If $g_wdBotRestartFirst = 0 Then $g_wdBotRestartFirst = TimerInit()
    Local $n = 0
    If FileExists($NF_WD_RESTART_CNT_FILE) Then
        $n = Int(FileRead($NF_WD_RESTART_CNT_FILE))
        If Not @error And FileExists($NF_WD_RESTART_CNT_FILE) Then FileDelete($NF_WD_RESTART_CNT_FILE)
    EndIf
    $n += 1
    If $n > $NF_WD_MAX_BOT_RESTARTS Then
        Out("[Watchdog] " & $reason & " -> " & $n & " reinicios de bot seguidos sin in-game -> RENDIRSE " & Round($NF_WD_GIVEUP_MS / 1000) & "s (abre GW a mano)")
        Ui_SetStatus("GW no responde. Abre GW a mano o reinicia.")
        $g_wdGiveUpUntil = TimerInit()
        $g_wdRelaunchFails = 0
        $g_wdRestartPending = False
        $g_wdDeadChecks = 0
        Return
    EndIf
    Out("[Watchdog] " & $reason & " -> REINICIANDO EL BOT (intento " & $n & "/" & $NF_WD_MAX_BOT_RESTARTS & "): cierro gw del bot + bot limpio")
    Ui_SetStatus("GW caído: cierro GW y reinicio bot limpio...")
    DirCreate(@TempDir & "\gwbot")
    Local $f = FileOpen($NF_WD_RESTART_CNT_FILE, 2)
    If $f <> -1 Then
        FileWrite($f, $n)
        FileClose($f)
    EndIf
    Out("[Watchdog] cierre de GW en 10s (" & $reason & ") - pulsa STOP para abortar")
    Ui_SetStatus("Reinicio limpio en 10s: " & $reason)
    Local $tCd = TimerInit()
    While TimerDiff($tCd) < 10000
        Call("_PollStopButton")
        If Bot_UserStopped() Then
            Out("[Watchdog] reinicio abortado por STOP (GW queda vivo)")
            Ui_SetStatus("Reinicio abortado por STOP.")
            $g_wdRestartPending = False
            $g_bGwDown = False
            Return
        EndIf
        Sleep(500)
    WEnd
    Local $bKilled = _NF_KillBotGw()
    If $bKilled Then
        Out("[Watchdog] esperando 20s para que el servidor libere la sesion...")
        Sleep(20000)
    Else
        Sleep(2000)
    EndIf
    Local $wdWait = 0
    If $n >= 3 Then
        $wdWait = 180000
    ElseIf $n = 2 Then
        $wdWait = 60000
    EndIf
    If $wdWait > 0 Then
        Out("[Watchdog] backoff anti-ciclado: espero " & Round($wdWait / 1000) & "s antes de relanzar (intento " & $n & ")")
        If Not Bot_Sleep($wdWait) Then
            Out("[Watchdog] backoff interrumpido por STOP: no relanzo")
            $g_wdRestartPending = False
            $g_wdDeadChecks = 0
            Return
        EndIf
    EndIf
    _NF_RestartBot()
EndFunc
Func _NF_RelaunchGw()
    If $g_wdGiveUpUntil <> 0 And TimerDiff($g_wdGiveUpUntil) < $NF_WD_GIVEUP_MS Then
        Out("[Watchdog] GW crashea al arrancar -> relanzamiento automatico BLOQUEADO " & Round(($NF_WD_GIVEUP_MS - TimerDiff($g_wdGiveUpUntil)) / 1000) & "s (abre GW a mano)")
        $g_wdDeadChecks = 0
        Return
    EndIf
    $g_wdGiveUpUntil = 0
    If IniRead(@ScriptDir & "\config.ini", "GW", "AutoLaunch", "0") <> "1" Then
        Out("[Watchdog] GW caído, pero AutoLaunch=0 -> no relanzo. Reabre GW a mano.")
        Ui_SetStatus("GW caído. Reábrelo con tu personaje (AutoLaunch=0).")
        $g_wdDeadChecks = 0
        Return
    EndIf
    If $g_wdLastRelaunch <> 0 And TimerDiff($g_wdLastRelaunch) < $NF_WD_COOLDOWN_MS Then
        Out("[Watchdog] relanzamiento en cooldown (" & Round((($NF_WD_COOLDOWN_MS - TimerDiff($g_wdLastRelaunch)) / 1000)) & "s restantes) - skip")
        Return
    EndIf
    $g_wdLastRelaunch = TimerInit()
    $g_wdRelaunchFails += 1
    If $g_wdRelaunchFails > $NF_WD_MAX_RELAUNCHES Then
        _NF_WdGiveUpWithRestart($g_wdRelaunchFails & " relanzamientos consecutivos sin llegar a in-game")
        Return
    EndIf
    Local $charName = _NF_MainCharName()
    Out("[Watchdog] RELANZANDO GW (char='" & $charName & "')...")
    Ui_SetStatus("Watchdog: relanzando GW (gwlauncher)...")
    If ProcessExists("gw.exe") Then
        Out("[Watchdog] gw.exe sigue vivo (cuelgue/desync) -> matarlo ANTES de relanzar (evita 2a copia)")
        $g_wdOldPids = ""
        Local $aAllGw = ProcessList("gw.exe")
        If IsArray($aAllGw) And $aAllGw[0][0] > 0 Then
            For $si = 1 To $aAllGw[0][0]
                Local $pidGw = $aAllGw[$si][1]
                Local $cmdGw = ""
                Local $wmi = ObjGet("winmgmts:\\\\.\\root\\cimv2")
                If IsObj($wmi) Then
                    Local $cols = $wmi.ExecQuery("SELECT ProcessId,CommandLine FROM Win32_Process WHERE ProcessId=" & $pidGw)
                    For $o In $cols
                        $cmdGw = $o.CommandLine
                    Next
                EndIf
                If StringInStr($cmdGw, $charName) > 0 Then
                    Out("[Watchdog] matando gw del bot (PID=" & $pidGw & ", char='" & $charName & "')")
                    ProcessClose($pidGw)
                    $g_wdOldPids &= "," & $pidGw
                Else
                    Out("[Watchdog] gw ajeno (otra cuenta) PID=" & $pidGw & " -> NO tocar")
                EndIf
            Next
        EndIf
        Local $tKillGw = TimerInit()
        If $g_wdOldPids <> "" Then
            While ProcessExists("gw.exe") And TimerDiff($tKillGw) < 15000
                Local $still = 0
                Local $chkGw = ProcessList("gw.exe")
                If IsArray($chkGw) And $chkGw[0][0] > 0 Then
                    For $si2 = 1 To $chkGw[0][0]
                        If StringInStr("," & $g_wdOldPids & ",", "," & $chkGw[$si2][1] & ",") > 0 Then $still = 1
                    Next
                EndIf
                If Not $still Then ExitLoop
                Sleep(500)
            WEnd
            Out("[Watchdog] gw del bot (PIDs " & $g_wdOldPids & ") liberado")
        EndIf
    EndIf
    If $g_wdOldPids <> "" Then
        Out("[Watchdog] esperando 60s para que el servidor libere la sesion...")
        Sleep(60000)
        Out("[Watchdog] espera completada, lanzando copia limpia")
    EndIf
    _NF_LaunchGw($charName, True)
    $g_wdReconnectNeeded = True
    $g_wdReconnectChar = $charName
    $g_wdReconnectTick = TimerInit()
    $g_wdReconnectPhase = 0
    $Bot_Core_Initialized = False
    $g_wdDeadChecks = 0
    $g_wdMap0Since  = 0
    $g_asLastX      = 0
    $g_asLastY      = 0
    $g_asStillMs    = TimerInit()
EndFunc
Func _NF_WdReconnectStep()
    If $g_wdReconnectBusy Then Return
    $g_wdReconnectBusy = True
    _NF_WdReconnectStepImpl()
    $g_wdReconnectBusy = False
EndFunc
Func _NF_WdReconnectStepImpl()
    If TimerDiff($g_wdReconnectTick) > 240000 Then
        Out("[Watchdog] reconexion TIMEOUT (4 min) -> abandonar, volviendo a flujo normal")
        $g_wdReconnectNeeded = False
        $g_wdReconnectPhase = 0
        $g_wdReconnectTick = 0
        $g_bGwDown = False
        Return
    EndIf
    If $g_wdReconnectPhase = 0 Then
        If $g_wdGiveUpUntil <> 0 And TimerDiff($g_wdGiveUpUntil) < $NF_WD_GIVEUP_MS Then
            Sleep(1000)
            Return
        EndIf
        $g_wdGiveUpUntil = 0
        If Not ProcessExists("gw.exe") Then
            If $g_wdRelLaunchTick = 0 Then
                $g_wdRelLaunchTick = TimerInit()
            ElseIf TimerDiff($g_wdRelLaunchTick) > 15000 Then
                $g_wdRelaunchFails += 1
                If $g_wdRelaunchFails > $NF_WD_MAX_RELAUNCHES Then
                    _NF_WdGiveUpWithRestart($g_wdRelaunchFails & " relaunches sin conectar")
                    Return
                EndIf
                Out("[Watchdog] reconexion: GW no volvio en 15s (crash en arranque?) -> relanzar de nuevo")
                RunWait('taskkill /F /IM gw.exe /T', @ScriptDir, @SW_HIDE)
                RunWait('taskkill /F /IM GW_Launcher.exe', @ScriptDir, @SW_HIDE)
                Out("[Watchdog] reconexion: esperando 60s para liberar sesion del servidor...")
                Sleep(60000)
                Out("[Watchdog] reconexion: espera completada, lanzando GW")
                $g_wdOldPids = ""
                _NF_LaunchGw($g_wdReconnectChar, True)
                $g_wdRelLaunchTick = TimerInit()
            EndIf
            Sleep(1000)
            Return
        EndIf
        Local $aP = ProcessList("gw.exe")
        Local $newPid = 0
        If IsArray($aP) Then
            For $i = 1 To $aP[0][0]
                If Not StringInStr("," & $g_wdOldPids & ",", "," & $aP[$i][1] & ",") Then
                    If StringInStr(_NF_GetGwCmdLine($aP[$i][1]), $g_wdReconnectChar) > 0 Then
                        $newPid = $aP[$i][1]
                        ExitLoop
                    Else
                        Out("[Watchdog] reconexion: gw.exe (PID=" & $aP[$i][1] & ") no es de '" & $g_wdReconnectChar & "' -> ignorar (NO tocar cuenta ajena)")
                    EndIf
                EndIf
            Next
        EndIf
        If $newPid = 0 Then
            Out("[Watchdog] reconexion: esperando gw.exe nuevo... (fase 0)")
            Sleep(1000)
            Return
        EndIf
        $g_wdRelLaunchTick = TimerInit()
        Out("[Watchdog] reconexion: gw.exe nuevo detectado (PID=" & $newPid & ") -> esperando carga (15s)...")
        Sleep(15000)
        Out("[Watchdog] reconexion: Core_Initialize tras espera")
        $g_b_AutoUpdate = False
        $Bot_Core_Initialized = False
        Local $ok = Core_Initialize($newPid, False)
        Out("[Watchdog] reconexion: Core_Initialize devolvio " & $ok)
        If $ok = 0 Then
            $g_wdRelaunchFails += 1
            If $g_wdRelaunchFails > $NF_WD_MAX_RELAUNCHES Then
                _NF_WdGiveUpWithRestart($g_wdRelaunchFails & " fallos de Core_Initialize")
                Return
            EndIf
            Out("[Watchdog] reconexion: Core_Initialize fallo (" & $g_wdRelaunchFails & "/" & $NF_WD_MAX_RELAUNCHES & "), reintentando...")
            $g_wdReconnectPhase = 0
            Sleep(2000)
            Return
        EndIf
        $Bot_Core_Initialized = True
        Local $tLoad = TimerInit()
        While TimerDiff($tLoad) < 30000
            Local $hp = Agent_GetAgentInfo(-2, "HP")
            Local $lv = Agent_GetAgentInfo(-2, "Level")
            If $hp > 0 And $lv > 0 Then ExitLoop
            Sleep(2000)
        WEnd
        $g_wdReconnectPhase = 1
        Return
    EndIf
    If $g_wdReconnectPhase = 1 Then
        If Not ProcessExists("gw.exe") Then
            $g_wdRelaunchFails += 1
            If $g_wdRelaunchFails > $NF_WD_MAX_RELAUNCHES Then
                _NF_WdGiveUpWithRestart($g_wdRelaunchFails & " crashes en fase 1")
                Return
            EndIf
            Out("[Watchdog] reconexion: gw.exe muerto durante fase 1 (" & $g_wdRelaunchFails & "/" & $NF_WD_MAX_RELAUNCHES & ") -> volver a fase 0 (relanzar)")
            $g_wdReconnectPhase = 0
            $g_wdRelLaunchTick = TimerInit()
            Sleep(1000)
            Return
        EndIf
        If Map_GetMapID() > 0 Then
            Out("[Watchdog] reconexion: ya in-game (map=" & Map_GetMapID() & ")")
            $g_wdReconnectNeeded = False
            $g_wdReconnectPhase = 0
            $g_wdReconnectTick = 0
            $g_wdDeadChecks = 0
            $g_wdMap0Since = 0
            $g_wdRelaunchFails = 0
            $g_wdGiveUpUntil = 0
            $g_wdBotRestartFirst = 0
            $g_bGwDown = False
            If FileExists($NF_WD_RESTART_CNT_FILE) Then FileDelete($NF_WD_RESTART_CNT_FILE)
            Return
        EndIf
        If PreGame_Ptr() <> 0 Then
            Out("[Watchdog] reconexion: en char-select, seleccionando personaje...")
            _NF_SelectCharAndEnter($g_wdReconnectChar)
            $g_wdReconnectPhase = 2
            $g_wdReconnectTick = TimerInit()
            Return
        EndIf
        Out("[Watchdog] reconexion: esperando char-select (PreGame 0, map 0)...")
        Sleep(1000)
        Return
    EndIf
    If $g_wdReconnectPhase = 2 Then
        If Map_GetMapID() > 0 Then
            Out("[Watchdog] reconexion: mundo cargado (map=" & Map_GetMapID() & ")")
            $g_wdReconnectNeeded = False
            $g_wdReconnectPhase = 0
            $g_wdReconnectTick = 0
            $g_wdDeadChecks = 0
            $g_wdMap0Since = 0
            $g_wdRelaunchFails = 0
            $g_wdGiveUpUntil = 0
            $g_wdBotRestartFirst = 0
            $g_bGwDown = False
            If FileExists($NF_WD_RESTART_CNT_FILE) Then FileDelete($NF_WD_RESTART_CNT_FILE)
            Return
        EndIf
        If TimerDiff($g_wdReconnectTick) > 90000 Then
            Out("[Watchdog] reconexion: mundo no cargo en 90s tras ENTER -> reintentar seleccion")
            $g_wdReconnectPhase = 1
            $g_wdReconnectTick = TimerInit()
            Return
        EndIf
        Out("[Watchdog] reconexion: cargando mundo tras seleccion...")
        Sleep(1000)
        Return
    EndIf
EndFunc
Func _NF_GwWatchdog()
    If Not $BotRunning Then Return  
    If $g_wdReconnectNeeded Then
        _NF_WdReconnectStep()
        Return
    EndIf
    If Not ProcessExists("gw.exe") Then
        $g_wdDeadChecks += 1
        $g_wdMap0Since = 0   
        $g_bGwDown = True
        Out("[Watchdog] gw.exe AUSENTE (" & $g_wdDeadChecks & "/" & $NF_WD_DEAD_NEEDED & ")")
        If $g_wdDeadChecks >= $NF_WD_DEAD_NEEDED Then
            Out("[Watchdog] GW muerto confirmado -> reinicio limpio (cerrar gw + relanzar bot)")
            _NF_WdGiveUpWithRestart("gw.exe muerto")
        EndIf
        Return
    EndIf
    $g_wdDeadChecks = 0
    If TimerDiff($g_wdTimer) < $NF_WD_PERIOD_MS Then Return
    $g_wdTimer = TimerInit()
    If Map_GetMapID() <= 0 Then
        $g_wdLoadingSince = 0   
        If $g_wdMap0Since = 0 Then
            $g_wdMap0Since = TimerInit()
        ElseIf TimerDiff($g_wdMap0Since) > $NF_WD_DESYNC_MS Then
            Out("[Watchdog] DESYNC: map=0 con GW vivo >" & Round($NF_WD_DESYNC_MS / 1000) & "s -> reinicio limpio")
            $g_bGwDown = True
            _NF_WdGiveUpWithRestart("desync map=0")
        EndIf
    Else
        $g_wdMap0Since = 0   
        If Agent_GetAgentInfo(-2, "MaxHP") <= 0 Then
            If $g_wdLoadingSince = 0 Then
                $g_wdLoadingSince = TimerInit()
            ElseIf TimerDiff($g_wdLoadingSince) > $NF_WD_DESYNC_MS Then
                Out("[Watchdog] CUELGUE DE CARGA: map=" & Map_GetMapID() & " con player sin cargar >" & Round($NF_WD_DESYNC_MS / 1000) & "s -> reinicio limpio")
                $g_bGwDown = True
                _NF_WdGiveUpWithRestart("cuelgue de carga")
            EndIf
        Else
            $g_wdLoadingSince = 0   
        EndIf
    EndIf
    If $g_bGwDown Then
        $g_bGwDown = False
        Out("[Watchdog] GW sano (map=" & Map_GetMapID() & ") -> gate $g_bGwDown=False")
    EndIf
EndFunc
Func _NF_AntiStuck()
    If TimerDiff($g_asTimer) < $NF_AS_PERIOD_MS Then Return
    $g_asTimer = TimerInit()
    If Not $BotRunning Or $g_currentPhase = "" Then
        $g_asStillMs = 0
        Return
    EndIf
    If Map_GetMapID() <= 0 Then
        $g_asStillMs = 0
        Return
    EndIf
    If Map_GetInstanceInfo("Type") = $GC_I_MAP_TYPE_OUTPOST Then
        $g_asStillMs = 0
        Return
    EndIf
    If Agent_GetAgentInfo(-2, "IsDead") Then
        $g_asStillMs = 0
        Return
    EndIf
    Local $cx = Agent_GetAgentInfo(-2, "X")
    Local $cy = Agent_GetAgentInfo(-2, "Y")
    If $cx = 0 And $cy = 0 Then Return   
    If $g_asLastX = 0 And $g_asLastY = 0 Then
        $g_asLastX = $cx
        $g_asLastY = $cy
        $g_asStillMs = TimerInit()
        Return
    EndIf
    If Sqrt(($cx - $g_asLastX) ^ 2 + ($cy - $g_asLastY) ^ 2) >= $NF_AS_MOVE_U Then
        $g_asLastX = $cx
        $g_asLastY = $cy
        $g_asStillMs = TimerInit()
        $g_asNudges = 0
        Return
    EndIf
    If $g_asStillMs = 0 Then
        $g_asStillMs = TimerInit()
        Return
    EndIf
    If TimerDiff($g_asStillMs) < $NF_AS_STILL_MS Then Return
    $g_asNudges += 1
    Local $ang = Mod($g_asNudges, 4) * 1.5707963   
    Local $nx = $cx + Cos($ang) * $NF_AS_NUDGE_U
    Local $ny = $cy + Sin($ang) * $NF_AS_NUDGE_U
    Out("[AntiStuck] player quieto >" & Round($NF_AS_STILL_MS / 1000) & "s (fase " & $g_currentPhase & ") -> nudge#" & $g_asNudges & " a (" & Round($nx) & "," & Round($ny) & ")")
    Map_Move($nx, $ny, 0)
    $g_asStillMs = TimerInit()
EndFunc
Func _NF_HangWatchdog()
    If TimerDiff($g_hwTimer) < $NF_HW_PERIOD_MS Then Return
    $g_hwTimer = TimerInit()
    If Not $BotRunning Or $g_currentPhase = "" Then
        $g_hwSince = 0
        $g_hwNudges = 0
        Return
    EndIf
    If $g_bGwDown Or $g_wdRestartPending Then
        $g_hwSince = 0
        $g_hwNudges = 0
        Return
    EndIf
    Local $hwMapNow = Map_GetMapID()
    If $hwMapNow <> $g_hwLastMap Then
        $g_hwLastMap = $hwMapNow
        $g_hwMapSince = TimerInit()
        $g_hwSince = 0
        $g_hwNudges = 0
    EndIf
    If $hwMapNow > 0 And TimerDiff($g_hwMapSince) < $NF_HW_ZONE_GRACE_MS Then Return
    If Map_GetMapID() <= 0 Then
        $g_hwSince = 0
        $g_hwNudges = 0
        Return
    EndIf
    If Map_GetInstanceInfo("Type") = $GC_I_MAP_TYPE_OUTPOST Then
        $g_hwSince = 0
        $g_hwNudges = 0
        Return
    EndIf
    If Map_GetInstanceInfo("IsLoading") Then
        $g_hwSince = 0
        $g_hwNudges = 0
        Return
    EndIf
    If Agent_GetAgentInfo(-2, "IsDead") Then
        $g_hwSince = 0
        $g_hwNudges = 0
        Return
    EndIf
    If Agent_GetAgentInfo(-2, "MaxHP") <= 0 Then
        $g_hwSince = 0
        $g_hwNudges = 0
        Return
    EndIf
    If Agent_GetCurrentTarget() > 0 Then
        $g_hwSince = 0
        $g_hwNudges = 0
        Return
    EndIf
    If GetNearestEnemy(2500) <> 0 Then
        $g_hwSince = 0
        $g_hwNudges = 0
        Return
    EndIf
    If Game_GetGameInfo("IsCinematic") Then
        $g_hwSince = 0
        $g_hwNudges = 0
        Return
    EndIf
    If $g_GE_LastDialogTimer > 0 And TimerDiff($g_GE_LastDialogTimer) < 5000 Then
        $g_hwSince = 0
        $g_hwNudges = 0
        Return
    EndIf
    If $g_bM11HoldPosition Then
        $g_hwSince = 0
        $g_hwNudges = 0
        Return
    EndIf
    Local $hwx = Agent_GetAgentInfo(-2, "X")
    Local $hwy = Agent_GetAgentInfo(-2, "Y")
    If $hwx = 0 And $hwy = 0 Then Return   
    If $g_hwSince = 0 Then
        $g_hwLastX = $hwx
        $g_hwLastY = $hwy
        $g_hwLastZ = Agent_GetAgentInfo(-2, "Z")
        $g_hwSince = TimerInit()
        Return
    EndIf
    Local $hwmoved = Sqrt(($hwx - $g_hwLastX) ^ 2 + ($hwy - $g_hwLastY) ^ 2)
    If $hwmoved >= $NF_HW_MOVE_U Then
        $g_hwLastX = $hwx
        $g_hwLastY = $hwy
        $g_hwLastZ = Agent_GetAgentInfo(-2, "Z")
        $g_hwSince = TimerInit()
        $g_hwNudges = 0
        Return
    EndIf
    If TimerDiff($g_hwSince) < $NF_HW_STILL_MS Then Return
    Local $hwz = Agent_GetAgentInfo(-2, "Z")
    If ($g_hwLastZ <> "") And ($g_hwLastZ - $hwz > 400) Then
        Out("[HangWatchdog] caida bajo el mapa (Z " & Round($g_hwLastZ) & " -> " & Round($hwz) & ") -> Map_ReturnToOutpost")
        Map_ReturnToOutpost()
        Local $tFallBack = TimerInit()
        While TimerDiff($tFallBack) < 20000
            If Bot_ShouldStop() Then ExitLoop
            Sleep(1000)
        WEnd
        $g_hwSince = 0
        $g_hwNudges = 0
        $g_hwLastZ = 0
        Return
    EndIf
    $g_hwLastZ = $hwz
    If $g_hwNudges >= $NF_HW_MAX_NUDGES Then
        Out("[HangWatchdog] char still " & Round($NF_HW_STILL_MS / 1000) & "s + " & $g_hwNudges & " nudges sin progreso (map=" & Map_GetMapID() & " fase=" & $g_currentPhase & ") -> reinicio limpio")
        $g_hwSince = 0
        $g_hwNudges = 0
        $g_hwLastZ = ""
        Return
    EndIf
    $g_hwNudges += 1
    If $g_hwNudges = 1 Then
        $g_hwNX = $hwx
        $g_hwNY = $hwy
    EndIf
    If $g_hwNudges >= 3 And Sqrt(($hwx - $g_hwNX)^2 + ($hwy - $g_hwNY)^2) < $NF_HW_MOVE_U Then
        Local $movedBase = Sqrt(($hwx - $g_hwNX)^2 + ($hwy - $g_hwNY)^2)
        If $movedBase >= 5 Then
            Local $bang = Mod($g_hwNudges, 4) * 1.5707963 + 0.7853982
            Local $bx = $hwx + Cos($bang) * 1200, $by = $hwy + Sin($bang) * 1200
            Out("[HangWatchdog] micro-movimiento (" & Round($movedBase) & "u): cuna, no muerte -> sidestep 1200u a (" & Round($bx) & "," & Round($by) & ")")
            Map_Move($bx, $by, 0)
            $g_hwSince = 0
            $g_hwNudges = 0
            Return
        EndIf
        Out("[HangWatchdog] pos cero absoluto tras 3 nudges -> probar ReturnToOutpost antes de reiniciar")
        Map_ReturnToOutpost()
        Local $tRTO = TimerInit()
        While Not Bot_ShouldStop() And TimerDiff($tRTO) < 60000
            Sleep(2000)
        WEnd
        Local $rx = Agent_GetAgentInfo(-2, "X"), $ry = Agent_GetAgentInfo(-2, "Y")
        If Map_GetMapID() <> $hwMapNow Or Sqrt(($rx - $hwx)^2 + ($ry - $hwy)^2) >= $NF_HW_MOVE_U Then
            Out("[HangWatchdog] ReturnToOutpost recupero (map/pos cambiaron) -> seguir, sin reinicio")
            $g_hwSince = 0
            $g_hwNudges = 0
            Return
        EndIf
        Out("[HangWatchdog] 3 nudges sin moverse nada (pos congelada) -> sesion muerta: reinicio limpio")
        Local $fTgt = Agent_GetCurrentTarget()
        Local $fTgtMdl = 0
        If $fTgt <> 0 Then $fTgtMdl = Agent_GetAgentInfo($fTgt, "PlayerNumber")
        Local $fDlgAge = -1
        If $g_GE_LastDialogTimer > 0 Then $fDlgAge = TimerDiff($g_GE_LastDialogTimer)
        Out("[HangWatchdog] forense: target=" & $fTgt & " model=" & $fTgtMdl & " ultimoDialogHaceMs=" & $fDlgAge & " map=" & Map_GetMapID() & " hp=" & Agent_GetAgentInfo(-2, "HP"))
        $g_hwSince = 0
        $g_hwNudges = 0
        _NF_WdGiveUpWithRestart("sesion muerta (mundo congelado)")
        Return
    EndIf
    Local $ang = Mod($g_hwNudges - 1, 4) * 1.5707963   
    Local $nx = $hwx + Cos($ang) * $NF_HW_NUDGE_U
    Local $ny = $hwy + Sin($ang) * $NF_HW_NUDGE_U
    Out("[HangWatchdog] char still >" & Round($NF_HW_STILL_MS / 1000) & "s (map=" & Map_GetMapID() & " fase=" & $g_currentPhase & " z=" & Round(Agent_GetAgentInfo(-2, "Z")) & ") -> nudge#" & $g_hwNudges & " a (" & Round($nx) & "," & Round($ny) & ")")
    Map_Move($nx, $ny, 0)
    $g_hwSince = TimerInit()
EndFunc
If StringInStr($CmdLineRaw, "--autostart") > 0 Then
    Out("[Init] AutoStart activo -> conectando y reanudando solo")
    Ui_SetStatus("AutoStart: conectando a GW y reanudando fase...")
    Local $sAutoSel = StringStripWS(GUICtrlRead($cbx_char_select), 3)
    If $sAutoSel = "" Or $sAutoSel = "-" Then
        $sAutoSel = StringStripWS(_NF_MainCharName(), 3)
        If $sAutoSel <> "" Then GUICtrlSetData($cbx_char_select, $sAutoSel, $sAutoSel)
    EndIf
    If $sAutoSel <> "" Then _StartBotFromSelection()
EndIf
Global $g_uiTimer = TimerInit()
Global Const $UI_REFRESH_MS = 1000
While True
    Sleep(50)
    ; FREE 1-16: hooks dev de BIA apply-runas (fase 22) eliminados (codigo borrado).
    If $g_iRequestedPhase >= 0 And Not $g_bActionRunning Then
        Local $iRequested = $g_iRequestedPhase
        $g_iRequestedPhase = -1
        $g_sPendingAction = ""
        $g_sQueuedPhase = ""
        $g_currentPhase = ""
        $g_state = $NF_STATE_IDLE
        _PreparePhaseChainFromIndex($iRequested)
        _StartBotFromSelection()
    EndIf
    If Bot_UserStopped() And Not $g_bActionRunning And $g_iRequestedPhase < 0 Then
        $g_sPendingAction = ""
        $g_sQueuedPhase = ""
        $g_currentPhase = ""
        $g_currentMission = ""
        $g_state = $NF_STATE_IDLE
        $BotRunning = False
        $g_bChainMode = False
        Sleep(50)
        ContinueLoop
    EndIf
    If Not Bot_UserStopped() Then
        _NF_GwWatchdog()
        _NF_AntiStuck()
    EndIf
    If Not Bot_UserStopped() And Not $g_bActionRunning And $g_sPendingAction = "" And $g_sQueuedPhase <> "" And ($g_bResumeApplied Or Not _PhasesMemPristine()) Then
        Out("[Chain] Auto-disparando siguiente fase: " & $g_sQueuedPhase)
        _SetPhaseRunning($g_sQueuedPhase)
        $g_sPendingAction = $g_sQueuedPhase
        $g_sQueuedPhase = ""
    EndIf
    If $g_sPendingAction <> $g_sDbgLastPending Then
        $g_sDbgLastPending = $g_sPendingAction
        Out("[DBG] pending='" & $g_sPendingAction & "' actionRunning=" & $g_bActionRunning & " forceRun=" & $g_bForceRunOnce & " BotRunning=" & $BotRunning)
    EndIf
    If Not $g_bActionRunning And $g_sPendingAction <> "" Then
        If $g_sPendingAction = "StopCampaign" Or $g_sPendingAction = "PauseCampaign" Then
            $BotRunning = False
            $g_bChainMode = False
            $g_bForceRunOnce = False
            $g_sQueuedPhase = ""
            $g_currentPhase = ""
            $g_currentMission = ""
            $g_state = $NF_STATE_IDLE
            If $g_sPendingAction = "StopCampaign" Then
                Out("[Phase] Detenida manualmente")
            Else
                Out("[Phase] Pausada")
            EndIf
            $g_sPendingAction = ""
            $g_bActionRunning = False
            ContinueLoop
        EndIf
        Local $bManualPhase = $g_bForceRunOnce
        If $g_bForceRunOnce Then
            Out("[Phase] " & $g_sPendingAction & " - force run (skip-if-done bypaseado)")
            $g_bForceRunOnce = False
        ElseIf _IsPhaseDoneByQuestState($g_sPendingAction) Then
            Out("[Phase] " & $g_sPendingAction & " ya completada (quest state) - skip")
            _MarkPhaseDone($g_sPendingAction)
            $g_sPendingAction = ""
            ContinueLoop
        EndIf
        $g_bActionRunning = True
        If Not Travel_EnsureAtBotOutpost($g_sPendingAction) Then
            Out("[Phase] WARN: Travel falló para " & $g_sPendingAction & " - reintentando en 15s")
            Ui_SetStatus("WARN: Travel falló - reintentando en 15s")
            $g_bActionRunning = False
            Bot_Sleep(15000)
            ContinueLoop
        EndIf
        _SyncPhasesAroundActive($g_sPendingAction)
        Local $sVerifyReal = ""
        If Not $bManualPhase Then $sVerifyReal = _PhaseVerify_CurrentPhase($g_sPendingAction)
        If $sVerifyReal <> "" Then
            Out("[Phase] " & $g_sPendingAction & " NO es la fase real -> encolar " & $sVerifyReal & " (verificación quest)")
            $g_sQueuedPhase = $sVerifyReal
            $g_sPendingAction = ""
            $g_bActionRunning = False
            ContinueLoop
        EndIf
        Switch $g_sPendingAction
            Case "SkipTutorial"
                Cache_SkillBar()
                _ResetStuckBaseline()
                $g_currentPhase = "SkipTutorial"
                $BotRunning = True
                Out("[Phase] SkipTutorial iniciada (lineal: Kormir + Jahdugar)")
                Out("[Phase] Wait 5s estabilización post-Initialize...")
                Sleep(5000)
                If Quest_Tutorial_Run() Then
                    Out("[Phase] SkipTutorial COMPLETADA")
                    _MarkPhaseDone($g_sPendingAction)
                Else
                    Out("[Phase] SkipTutorial FAILED")
                    _MarkPhaseFailed($g_sPendingAction)
                EndIf
                $g_currentPhase = ""
                $BotRunning = False
                $g_state = $NF_STATE_IDLE
            Case "RewardM01"
                Cache_SkillBar()
                _ResetStuckBaseline()
                Out("[Phase] RewardM01: esperando outpost cargado...")
                Map_WaitMapLoading(-1, $GC_I_MAP_TYPE_OUTPOST, 30000)
                Local $tRM01 = TimerInit()
                While TimerDiff($tRM01) < 15000
                    Local $rmX = Agent_GetAgentInfo(-2, "X"), $rmY = Agent_GetAgentInfo(-2, "Y")
                    If $rmX <> 0 Or $rmY <> 0 Then ExitLoop
                    Sleep(500)
                WEnd
                Sleep(1500)
                Out("[Phase] RewardM01: equipar guadaña + subir atributos en outpost antes de entrar a M01")
                Equipment_AutoEquipFirstWeapon()
                Sleep(500)
                Attribute_IncreaseAttribute($GC_I_ATTRIBUTE_SCYTHE_MASTERY, 2)
                Sleep(300)
                Attribute_IncreaseAttribute($GC_I_ATTRIBUTE_MYSTICISM, 1)
                Sleep(500)
                $g_currentPhase = "RewardM01"
                $g_currentMission = "M01_Chahbek"
                $BotRunning = True
                $g_state = $NF_STATE_ACCEPT_QUEST
                Out("[Phase] RewardM01 iniciada (cobrar reward 677 + aceptar 676 + entrar + correr M01)")
            Case "PrimaryTraining"
                Cache_SkillBar()
                _ResetStuckBaseline()
                $g_currentPhase = "PrimaryTraining"
                $BotRunning = True
                Out("[Phase] PrimaryTraining iniciada (NPC + 3 dialogs)")
                If Quest_PrimaryTraining_Run() Then
                    Out("[Phase] PrimaryTraining COMPLETADA")
                    _MarkPhaseDone($g_sPendingAction)
                Else
                    Out("[Phase] PrimaryTraining FAILED")
                    _MarkPhaseFailed($g_sPendingAction)
                EndIf
                $g_currentPhase = ""
                $BotRunning = False
                $g_state = $NF_STATE_IDLE
            Case "TravelToMap"
                If $g_iPendingTravelMapId > 0 Then
                    Out("[Phase] TravelToMap iniciada -> map " & $g_iPendingTravelMapId)
                    $g_currentPhase = "TravelToMap"
                    $BotRunning = True
                    Travel_ToOutpost($g_iPendingTravelMapId)
                    Out("[Phase] TravelToMap COMPLETADA (map=" & Map_GetMapID() & ")")
                    $g_currentPhase = ""
                    $BotRunning = False
                    $g_state = $NF_STATE_IDLE
                    $g_iPendingTravelMapId = 0
                EndIf
            Case "HoningYourSkills"
                Cache_SkillBar()
                _ResetStuckBaseline()
                $g_currentPhase = "HoningYourSkills"
                $BotRunning = True
                Out("[Phase] HoningYourSkills: TravelSH + Astra + CD + FarmSunspear + BuySkills + SetupSkillBar")
                If Quest_HoningYourSkills_Run() Then
                    Out("[Phase] HoningYourSkills COMPLETADA")
                    _MarkPhaseDone($g_sPendingAction)
                Else
                    Out("[Phase] HoningYourSkills FAILED")
                    _MarkPhaseFailed($g_sPendingAction)
                EndIf
                $g_currentPhase = ""
                $BotRunning = False
                $g_state = $NF_STATE_IDLE
            Case "TravelToCliffsOfDohjok"
                Cache_SkillBar()
                _ResetStuckBaseline()
                $g_currentPhase = "TravelToCliffsOfDohjok"
                $BotRunning = True
                Out("[Phase] TravelToCliffsOfDohjok iniciada (Bohanna + cruce a Cliffs of Dohjok)")
                If Quest_TravelToCliffsOfDohjok_Run() Then
                    Out("[Phase] TravelToCliffsOfDohjok COMPLETADA")
                Else
                    Out("[Phase] TravelToCliffsOfDohjok FAILED")
                    _MarkPhaseFailed($g_sPendingAction)
                EndIf
                $g_currentPhase = ""
                $BotRunning = False
                $g_state = $NF_STATE_IDLE
            Case "RewardLeavingLegacy"
                Cache_SkillBar()
                _ResetStuckBaseline()
                $g_currentPhase = "RewardLeavingLegacy"
                $BotRunning = True
                Out("[Phase] RewardLeavingLegacy iniciada (cobrar quest 632 con NPC 4763 -> Dunkoro hero)")
                If Quest_RewardLeavingLegacy_Run() Then
                    Out("[Phase] RewardLeavingLegacy COMPLETADA")
                Else
                    Out("[Phase] RewardLeavingLegacy FAILED")
                    _MarkPhaseFailed($g_sPendingAction)
                EndIf
                $g_currentPhase = ""
                $BotRunning = False
                $g_state = $NF_STATE_IDLE
            Case "CQ_KamadanStart"
                _MarkPhaseDone($g_sPendingAction)
                $g_state = $NF_STATE_IDLE
            Case "CQ_Sanctuary"
                Cache_SkillBar()
                _ResetStuckBaseline()
                $g_currentPhase = "CQ_Sanctuary"
                $BotRunning = True
                Out("[Phase] CQ_Sanctuary iniciada (Ferryman + Skill Trainer + Warrior + Reward 596/601 + Accept 632)")
                If Quest_CQ_Sanctuary_Run() Then
                    Out("[Phase] CQ_Sanctuary COMPLETADA")
                    _MarkPhaseDone($g_sPendingAction)
                Else
                    Out("[Phase] CQ_Sanctuary FAILED")
                    _MarkPhaseFailed($g_sPendingAction)
                EndIf
                $g_currentPhase = ""
                $BotRunning = False
                $g_state = $NF_STATE_IDLE
            Case "CQ_TravelCD"
                _MarkPhaseDone($g_sPendingAction)
                $BotRunning = False
                $g_state = $NF_STATE_IDLE
            Case "TravelToSunspearHall"
                Cache_SkillBar()
                _ResetStuckBaseline()
                $g_currentPhase = "TravelToSunspearHall"
                $BotRunning = True
                Out("[Phase] TravelToSunspearHall iniciada (Kamadan -> Sunspear Hall)")
                If Quest_TravelToSunspearHall_Run() Then
                    Out("[Phase] TravelToSunspearHall COMPLETADA")
                    _MarkPhaseDone($g_sPendingAction)
                Else
                    Out("[Phase] TravelToSunspearHall FAILED")
                    _MarkPhaseFailed($g_sPendingAction)
                EndIf
                $g_currentPhase = ""
                $BotRunning = False
                $g_state = $NF_STATE_IDLE
            Case "TravelToAstralarium"
                Cache_SkillBar()
                _ResetStuckBaseline()
                $g_currentPhase = "TravelToAstralarium"
                $BotRunning = True
                Out("[Phase] TravelToAstralarium iniciada (Sunspear Hall -> The Astralarium)")
                If Quest_TravelToAstralarium_Run() Then
                    Out("[Phase] TravelToAstralarium COMPLETADA")
                    _MarkPhaseDone($g_sPendingAction)
                Else
                    Out("[Phase] TravelToAstralarium FAILED")
                    _MarkPhaseFailed($g_sPendingAction)
                EndIf
                $g_currentPhase = ""
                $BotRunning = False
                $g_state = $NF_STATE_IDLE
            Case "TravelToChampionsDawn"
                Cache_SkillBar()
                _ResetStuckBaseline()
                $g_currentPhase = "TravelToChampionsDawn"
                $BotRunning = True
                Out("[Phase] TravelToChampionsDawn iniciada (Astralarium -> Champion's Dawn)")
                If Quest_TravelToChampionsDawn_Run() Then
                    Out("[Phase] TravelToChampionsDawn COMPLETADA")
                    _MarkPhaseDone($g_sPendingAction)
                Else
                    Out("[Phase] TravelToChampionsDawn FAILED")
                    _MarkPhaseFailed($g_sPendingAction)
                EndIf
                $g_currentPhase = ""
                $BotRunning = False
                $g_state = $NF_STATE_IDLE
            Case "FarmSunspear"
                Cache_SkillBar()
                _ResetStuckBaseline()
                $g_currentPhase = "FarmSunspear"
                $BotRunning = True
                Out("[Phase] FarmSunspear iniciada (Champion's Dawn -> Plains of Jarin, 500 pts = Sunspear Captain)")
                If Quest_FarmSunspear_Run(500) Then
                    Out("[Phase] FarmSunspear COMPLETADA")
                    _MarkPhaseDone($g_sPendingAction)
                Else
                    Out("[Phase] FarmSunspear FAILED")
                    _MarkPhaseFailed($g_sPendingAction)
                EndIf
                $g_currentPhase = ""
                $BotRunning = False
                $g_state = $NF_STATE_IDLE
            Case "BuySkillsKamadan"
                Cache_SkillBar()
                _ResetStuckBaseline()
                $g_currentPhase = "BuySkillsKamadan"
                $BotRunning = True
                Out("[Phase] BuySkillsKamadan iniciada (Kamadan + Sunspear Hall skills + quest 716)")
                If Quest_BuySkillsKamadan_Run() Then
                    Out("[Phase] BuySkillsKamadan COMPLETADA")
                Else
                    Out("[Phase] BuySkillsKamadan FAILED")
                    _MarkPhaseFailed($g_sPendingAction)
                EndIf
                $g_currentPhase = ""
                $BotRunning = False
                $g_state = $NF_STATE_IDLE
            Case "SetupSkillBar"
                _ResetStuckBaseline()
                $g_currentPhase = "SetupSkillBar"
                $BotRunning = True
                Out("[Phase] SetupSkillBar iniciada (templates char/Koss/Dunkoro + Odurra)")
                If Quest_SetupSkillBar_Run() Then
                    Out("[Phase] SetupSkillBar COMPLETADA")
                Else
                    Out("[Phase] SetupSkillBar FAILED")
                    _MarkPhaseFailed($g_sPendingAction)
                EndIf
                $g_currentPhase = ""
                $BotRunning = False
                $g_state = $NF_STATE_IDLE
            Case "RecruitMorgahn"
                Cache_SkillBar()
                _ResetStuckBaseline()
                $g_currentPhase = "RecruitMorgahn"
                $BotRunning = True
                Out("[Phase] RecruitMorgahn iniciada (Dajmir Astralarium -> S&P Zehlon -> M02 Jokanur)")
                If Quest_RecruitMorgahn_Run() Then
                    Out("[Phase] RecruitMorgahn COMPLETADA")
                Else
                    Out("[Phase] RecruitMorgahn FAILED - reintentar")
                EndIf
                $g_currentPhase = ""
                $BotRunning = False
                $g_state = $NF_STATE_IDLE
            Case "RM_Step1_ExitToZehlon"
                _ResetStuckBaseline()
                $g_currentPhase = "RM_Step1"
                $BotRunning = True
                Out("[Phase] RM Step 1: Exit Jokanur -> Zehlon Reach")
                If Quest_RM_Step1_ExitToZehlon() Then
                    Out("[Phase] RM Step 1 COMPLETADA")
                Else
                    Out("[Phase] RM Step 1 FAILED")
                EndIf
                $g_currentPhase = ""
                $BotRunning = False
                $g_state = $NF_STATE_IDLE
            Case "M02_JokanurDiggings"
                _ResetStuckBaseline()
                $g_currentPhase = "M02_JokanurDiggings"
                $BotRunning = True
                Out("[Phase] M02 Jokanur Diggings iniciada (orquestador del bloque M01->M02)")
                If Quest_M02_JokanurDiggings_Run() Then
                    Out("[Phase] M02_JokanurDiggings COMPLETADA")
                    _MarkPhaseDone($g_sPendingAction)
                Else
                    Out("[Phase] M02_JokanurDiggings falló tras " & $M2J_MAX_ATTEMPTS & " intentos internos -> RE-ENCOLAR sin límite (el char sube de nivel y acaba pasando)")
                    Bot_Sleep(8000)
                    $g_sQueuedPhase = "M02_JokanurDiggings"
                EndIf
                $g_currentPhase = ""
                $BotRunning = False
                $g_state = $NF_STATE_IDLE
            Case "M03_BlacktideDen", "M04_ConsulateDocks", "M05_VentaCemetery", _
                 "M06_KodonurCrossroads", "M07_RilohnRefuge", "M08_ModdokCrevice", _
                 "M09_TiharkOrchard", "M10_DzagonurBastion", "M11_GrandCourtSebelkeh", _
                 "M12_NunduBay", "M13_GateOfDesolation", "M14_RuinsOfMorah", _
                 "M15_GateOfPain", "M16_GateOfMadness", "M17_AbaddonsGate", _
                 "SecondaryTraining", "ChooseSecondaryProfession", _
                 "LeavingALegacy", "TheHonorableGeneral", _
                 "IsleOfTheDead", "BadTideRising", "SpecialDelivery", _
                 "SignsAndPortents", _
                 "BigNewsSmallPackage", "FollowingTheTrail", _
                 "TheIronTruth", "TrialByFire", _
                 "WarPrep_GhostRecon", "WarPrep_RecruitTraining", "WarPrep_WindAndWater", _
                 "TheTimeIsNigh", "Hunted", "TheGreatEscape", "AndAHeroShallLeadThem", _
                 "TheCouncilIsCalled", "ToVabbi", "CentaurBlackmail", _
                 "MysteriousMessage", "SecretsInTheShadow", "ToKillADemon", _
                 "RallyThePrinces", "AllsWellThatEndsWell", "WarningKehanni", _
                 "CallingTheOrder", "PledgeOfMerchantPrinces", _
                 "AttackAtTheKodash", "HeartOrMindRonjokInDanger", _
                 "CrossingTheDesolation", "ADealsADeal", "HordeOfDarkness", _
                 "UnchartedTerritory", "KormirsCrusade", "AllAloneInTheDarkness"
                _ResetStuckBaseline()
                $g_currentPhase = $g_sPendingAction
                $BotRunning = True
                Out("[Phase] " & $g_sPendingAction & " iniciada")
                Local $missionFunc = "Quest_" & $g_sPendingAction & "_Run"
                Local $ok = False
                _M08_RestoreDervishWarrior()
                _RP_RestoreDervishWarrior()
                Local $phaseRetries = 3
                For $phaseTry = 1 To $phaseRetries
                    If Bot_UserStopped() Then ExitLoop
                    If $phaseTry > 1 Then Out("[Phase] " & $g_sPendingAction & " REINTENTO " & $phaseTry & "/" & $phaseRetries & " (autonomo)")
                    $ok = Call($missionFunc)
                    If @error Then
                        Out("[Phase] " & $g_sPendingAction & " ERROR llamando " & $missionFunc)
                        $ok = False
                        ExitLoop
                    EndIf
                    If Bot_UserStopped() Then
                        $ok = False
                        ExitLoop
                    EndIf
                    If $ok Then ExitLoop
                    If $phaseTry < $phaseRetries Then Bot_Sleep(3000)
                Next
                If $ok Then
                    Out("[Phase] " & $g_sPendingAction & " COMPLETADA")
                    _MarkPhaseDone($g_sPendingAction)
                    ; FREE 1-16: excursion Korr (endgame) eliminada.
                Else
                    If Bot_UserStopped() Then
                        Out("[Phase] " & $g_sPendingAction & " abortada por Stop/cambio manual -> no re-encolar")
                        $g_sQueuedPhase = ""
                        $g_bChainMode = False
                    ElseIf $g_bGwDown Then
                        Out("[Phase] " & $g_sPendingAction & " abortada por GW caído/relanzando -> esperando reconexión...")
                        $g_wdGiveUpUntil = 0
                        Local $sAbortedPhase = $g_sPendingAction
                        While $g_bGwDown And Not Bot_UserStopped()
                            Sleep(1000)
                        WEnd
                        If Bot_UserStopped() Then
                            Out("[Phase] usuario pidió Stop durante la reconexión -> no re-encolar")
                            $g_sQueuedPhase = ""
                        Else
                            Out("[Phase] GW recuperado -> re-encolando " & $sAbortedPhase & " (sin contar como fallo)")
                            $g_sQueuedPhase = $sAbortedPhase
                        EndIf
                        $g_currentPhase = ""
                        $BotRunning = False
                        $g_state = $NF_STATE_IDLE
                        $g_sPendingAction = ""
                        $g_bActionRunning = False
                        ContinueLoop
                    EndIf
                    If Not Bot_UserStopped() Then
                        If $g_sLastFailedPhase <> $g_sPendingAction Then
                            $g_sLastFailedPhase = $g_sPendingAction
                            $g_iRequeueCount = 0
                        EndIf
                        $g_iRequeueCount += 1
                        Local $sFailedPhase = $g_sPendingAction
                        If $g_sRedirectPhase <> "" Then
                            Out("[Phase] " & $sFailedPhase & " no era la fase real -> redirigiendo a " & $g_sRedirectPhase)
                            $g_sQueuedPhase = $g_sRedirectPhase
                            $g_sRedirectPhase = ""
                            $g_iRequeueCount = 0
                        ElseIf $g_iRequeueCount > $g_iMaxRequeue Then
                            Out("[Phase] 🔴 " & $sFailedPhase & " falló " & $g_iRequeueCount & " veces seguidas (limite " & $g_iMaxRequeue & ")")
                            _MarkPhaseFailed($sFailedPhase)
                        Else
                            Out("[Phase] " & $sFailedPhase & " falló tras " & $phaseRetries & " intentos -> RE-ENCOLAR " & $g_iRequeueCount & "/" & $g_iMaxRequeue)
                            Bot_Sleep(8000)
                            $g_sQueuedPhase = $sFailedPhase
                        EndIf
                    EndIf
                EndIf
                $g_currentPhase = ""
                $BotRunning = False
                $g_state = $NF_STATE_IDLE
            Case "PauseCampaign"
                $BotRunning = False
                Out("[Phase] Pausada")
            Case "StopCampaign"
                $BotRunning = False
                $g_currentPhase = ""
                $g_currentMission = ""
                $g_state = $NF_STATE_IDLE
                Out("[Phase] Detenida manualmente")
        EndSwitch
        $g_sPendingAction = ""
        $g_bActionRunning = False
    EndIf
    If $BotRunning And $g_currentPhase <> "" And _IsPhaseComplete() Then
        Out("[Phase] " & $g_currentPhase & " COMPLETADA")
        _MarkPhaseDone($g_currentPhase)
        $g_currentPhase = ""
        $BotRunning = False
        $g_bActionRunning = False
        $g_state = $NF_STATE_IDLE
    EndIf
    If TimerDiff($g_uiTimer) > $UI_REFRESH_MS Then
        UpdateUiCharInfo()
        Gui_v2_Tick()
        $g_uiTimer = TimerInit()
    EndIf
    If $BotRunning Then _StateTick()
    _RecorderTick()
WEnd
Func _StateTick()
    Local $skipStuckCheck = ($g_state = $NF_STATE_IDLE _
                          Or $g_state = $NF_STATE_IN_MISSION _
                          Or $g_state = $NF_STATE_ACCEPT_QUEST)
    If Recovery_IsDisconnected() Then
        Out("[State] Disconnected, IDLE")
        $g_state = $NF_STATE_IDLE
        $BotRunning = False
        Return
    EndIf
    If Recovery_IsDefeated() Then
        Out("[State] Party derrotada - esperando revival del juego (sin resign automatico)")
        Return
    EndIf
    If Not $skipStuckCheck And Recovery_CheckStuck() Then
        Recovery_Unstuck()
        Return
    EndIf
    Switch $g_state
        Case $NF_STATE_IDLE
            Sleep(500)
        Case $NF_STATE_DETECT_PROGRESS
            Quests_DetectCurrentObjective()
        Case $NF_STATE_ACCEPT_QUEST
            Local $accepted = Quests_AcceptForCurrentMission()
            If Map_GetMapID() = $GC_I_MAP_ID_CHAHBEK_VILLAGE_OUTPOST _
                    And Map_GetInstanceInfo("Type") = $GC_I_MAP_TYPE_EXPLORABLE Then
                Out("[State] ACCEPT_QUEST -> IN_MISSION (char dentro de mission instance)")
                $g_state = $NF_STATE_IN_MISSION
            Else
                Out("[State] ACCEPT_QUEST: accept=" & $accepted & " map=" & Map_GetMapID() & " type=" & Map_GetInstanceInfo("Type") & " - retry tras 3s")
                Sleep(3000)
            EndIf
        Case $NF_STATE_ENTER_MISSION
            If Missions_Enter($g_currentMission) Then
                $g_state = $NF_STATE_IN_MISSION
            Else
                Out("[State] Enter mission FAIL, vuelta a IDLE")
                $g_state = $NF_STATE_IDLE
                $BotRunning = False
            EndIf
        Case $NF_STATE_IN_MISSION
            Local $ok = Missions_Execute($g_currentMission)
            Out("[State] Missions_Execute returned " & $ok)
            If $ok Then
                $g_state = $NF_STATE_DONE
            Else
                Out("[State] Mission FAILED/ABORTED - chain detenida")
                $g_state = $NF_STATE_IDLE
                $BotRunning = False
            EndIf
        Case $NF_STATE_DONE
            Out("[State] Mission DONE")
            Sleep(500)
    EndSwitch
EndFunc
Func _IsPhaseComplete()
    Switch $g_currentPhase
        Case "SkipTutorial"
            Return (Map_GetMapID() = $GC_I_MAP_ID_CHAHBEK_VILLAGE_OUTPOST)
        Case "RewardM01"
            Return ($g_state = $NF_STATE_DONE _
                Or Map_GetMapID() = $GC_I_MAP_ID_CHUURHIR_FIELDS)
        Case Else
            Return False
    EndSwitch
EndFunc