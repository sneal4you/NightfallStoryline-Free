#include-once
#include "Catalog.au3"
#include <GUIConstantsEx.au3>
#include <WindowsConstants.au3>
#include <GuiListView.au3>
#include <GuiEdit.au3>
#include <StaticConstants.au3>
#include <EditConstants.au3>
#include <ComboConstants.au3>
#include <ListViewConstants.au3>
#include <FontConstants.au3>
#include <ScrollBarsConstants.au3>
Global $g_clrBg          = 0x101C2B
Global $g_clrPanel       = 0x152438
Global $g_clrHeaderBg    = 0x101C2B
Global $g_clrAccent      = 0x62B4F5
Global $g_clrOk          = 0x7DE0A2
Global $g_clrWarn        = 0xE9C46A
Global $g_clrError       = 0xF06A7A
Global $g_clrText        = 0xDCEAF7
Global $g_clrMuted       = 0x9DB1C7
Global $g_clrDone        = 0x819AB3
Global $g_clrPending     = 0xB4C6D8
Global $g_clrConsoleBg   = 0x0B1725
Global $g_clrConsoleText = 0xDCEAF7
Global $g_clrBtnBg       = 0x203852
Global $g_clrBtnText     = 0xDCEAF7
Global $g_clrRunBg       = 0x2F8FCA
Global $g_clrRunText     = 0xF4FAFF
Global $g_clrStopBg      = 0xB94F67
Global $g_clrStopText    = 0xFFF5F7
Global $hGui
Global $cbx_char_select
Global $g_idCharEnterDummy = 0   
Global $lbl_status
Global $console
Global $lbl_connDot
Global $lbl_connText
Global $lbl_charName
Global $lbl_charProf
Global $lbl_mapId
Global $lbl_runtime
Global $hPhaseList = 0
Global $idPhaseList = 0
Global $g_iSelectedPhase = -1
Global $g_bRunSelPhaseBusy = False   
Global $g_bAutoStartPhaseDone = True   
Global $g_iRightClickedPhase = -1
Global $idCM_MarkDone = 0, $idCM_MarkPending = 0
Global $g_iLastPhaseClick = -1
Global $g_tLastPhaseClick = 0
Global $g_aPhaseMap[0]
Global $g_aLogBuf[2000][4]
Global $g_iLogCount = 0
Global $g_bAutoScroll = True
Global $g_sFilterActive = "(All)"
Global $BotRunning = False
Global $g_iLastStopTime = 0           
Global $g_iLastResetTime = 0          
Global $Bot_Core_Initialized = False
Global $g_bInitInProgress = False   
Global $g_bDbgUiTickTrace = False   
Global $g_iDbgUiTickCount = 0       
Global $g_UpdateUiLastMs  = 0       
Global $g_sPendingAction = ""
Global $g_bActionRunning = False
Global $g_bUserPaused = False
Global $g_bChainMode = False
Global $g_bForceRunOnce = False
Global $g_sQueuedPhase = ""
Global $g_bResumeApplied = False
Global $g_sResumeAppliedFor = ""
Global $g_iKossLastUnused = 0
Global $g_bRecording = False
Global $g_sConfigFile = @ScriptDir & "\config.ini"
Global $g_iCharListRefreshCounter = 0
Global $g_hRuntimeTimer = 0
Global $btnStart = 0
Global $btnStopNew = 0
Global $btnFases  = 0   
Global $lbl_phases_header = 0
Global $idAutoScroll = 0
Global $idBtnClose   = 0
Global $btnRefreshChars = 0
Global $btnInit         = 0
Global $btnSkipTutorial = 0
Global $btnRewardM01    = 0
Global $btnPause        = 0
Global $btnStop         = 0
Global $lbl_botRunning  = 0
Global $lbl_currentMission = 0
Global $lbl_currentState   = 0
Global $lbl_level          = 0
Global $lbl_sunspearRank   = 0
Global $lbl_questLogState  = 0
Global $lbl_coords    = 0
Global $lbl_hp             = 0
Global $lbl_energy         = 0
Global $lbl_party          = 0
Global $lbl_dist           = 0
Global $tab                = 0
Global $h_tab_items[6]     = [0,0,0,0,0,0]
Global $editToolbox        = 0
Global $btnRunPhase        = 0
Global $btnResetPhase      = 0
Global $btnHideUI          = 0   
Global $btnClearPhases     = 0   
Global $btnAutoStart       = 0   
Global $btnCopyLog         = 0
Global $btnClearLog        = 0
Global $chkAutoScroll      = 0
Global $cbxFilter          = 0
Global $chkSkipCinematics  = 0
Global $chkHardMode        = 0
Global $chkPathfinderDebug = 0
Global $btnRecord          = 0
Global $g_sCache_connText = "", $g_sCache_charName = "", $g_sCache_charProf = ""
Global $g_sCache_mapId = "", $g_sCache_hp = "", $g_sCache_energy = ""
Global $g_sCache_party = "", $g_sCache_dist = "", $g_sCache_questLog = ""
Global $g_sCache_currentMission = "", $g_sCache_currentState = ""
Global $g_sCache_coords = "", $g_sCache_level = "", $g_sCache_sunspearRank = ""
Global $g_sCache_botRunning = ""
Global $g_sCache_diag_questId = "", $g_sCache_diag_questName = "", $g_sCache_diag_questLogState = ""
Global $g_sCache_diag_bundle = "", $g_sCache_diag_lastError = ""
Global $g_scX = 1.0  
Global $g_scY = 1.0  
Global $g_iScanRetries = 0  
Global $g_idHdrBg = 0, $g_idHdrAccent = 0, $g_idBotName = 0
Global $g_idDivider = 0, $g_idCtrlBg = 0, $g_idCtrlBorder = 0
Global $g_idStatsBg = 0, $g_idStatsBorder = 0
Global $g_idStatsBorderL = 0, $g_idStatsBorderR = 0, $g_idStatsBorderB = 0
Global $g_idLogHdrBg = 0, $g_idLogHdrBorder = 0, $g_idLogLabel = 0
Global $g_idLogBorderL = 0, $g_idLogBorderR = 0, $g_idLogBorderB = 0
Func Gui_v2_Init()
    If FileExists(_BotStopFile()) Then
        $g_bUserPaused = True
        Out("[Init] Flag STOP previo detectado: arranco pausado. Pulsa START para seguir.")
    EndIf
    $g_scX = 1.0
    $g_scY = 1.0
    Local $guiStyle = BitOR($WS_CAPTION, $WS_SYSMENU, $WS_MINIMIZEBOX, $WS_MAXIMIZEBOX, $WS_THICKFRAME)
    $hGui = GUICreate("NightfallStoryline  v2.0  TRIAL (misiones 1-16)", 1290, 830, -1, -1, $guiStyle)
    GUISetBkColor($g_clrBg, $hGui)
    $g_idHdrBg = GUICtrlCreateLabel("", 0, 0, _X(1290), _Y(46))
    GUICtrlSetBkColor($g_idHdrBg, $g_clrHeaderBg)
    GUICtrlSetState($g_idHdrBg, $GUI_DISABLE)
    $g_idHdrAccent = GUICtrlCreateLabel("", 0, _Y(45), _X(1290), _Y(2))
    GUICtrlSetBkColor($g_idHdrAccent, $g_clrAccent)
    GUICtrlSetState($g_idHdrAccent, $GUI_DISABLE)
    $g_idBotName = GUICtrlCreateLabel("NIGHTFALL STORYLINE  TRIAL 1-16", _X(14), _Y(12), _X(340), _Y(22))
    GUICtrlSetFont($g_idBotName, _F(11), $FW_NORMAL, 0, "Segoe UI")
    GUICtrlSetColor($g_idBotName, $g_clrText)
    GUICtrlSetBkColor($g_idBotName, $g_clrHeaderBg)
    GUICtrlSetState($g_idBotName, $GUI_SHOW)
    $lbl_charName = GUICtrlCreateLabel("NOMBRE: -", _X(608), _Y(626), _X(650), _Y(22))
    GUICtrlSetFont($lbl_charName, _F(9), $FW_NORMAL, 0, "Segoe UI")
    GUICtrlSetColor($lbl_charName, $g_clrText)
    GUICtrlSetBkColor($lbl_charName, $g_clrHeaderBg)
    GUICtrlSetState($lbl_charName, $GUI_HIDE)
    $lbl_mapId = GUICtrlCreateLabel("-", _X(690), _Y(12), _X(130), _Y(22))
    GUICtrlSetFont($lbl_mapId, _F(11), $FW_NORMAL, 0, "Consolas")
    GUICtrlSetColor($lbl_mapId, $g_clrMuted)
    GUICtrlSetBkColor($lbl_mapId, $g_clrHeaderBg)
    GUICtrlSetState($lbl_mapId, $GUI_DISABLE)
    $lbl_runtime = GUICtrlCreateLabel("00:00:00", _X(730), _Y(12), _X(90), _Y(22))
    GUICtrlSetFont($lbl_runtime, _F(11), $FW_NORMAL, 0, "Consolas")
    GUICtrlSetColor($lbl_runtime, $g_clrMuted)
    GUICtrlSetBkColor($lbl_runtime, $g_clrHeaderBg)
    GUICtrlSetState($lbl_runtime, $GUI_DISABLE)
    $lbl_connDot = GUICtrlCreateLabel("  ", _X(1128), _Y(14), _X(14), _Y(14))
    GUICtrlSetBkColor($lbl_connDot, $g_clrError)
    $lbl_connText = GUICtrlCreateLabel("Disconnected", _X(1146), _Y(12), _X(132), _Y(22))
    GUICtrlSetFont($lbl_connText, _F(10), $FW_NORMAL, 0, "Segoe UI")
    GUICtrlSetColor($lbl_connText, $g_clrText)
    GUICtrlSetBkColor($lbl_connText, $g_clrHeaderBg)
    GUICtrlSetState($lbl_connText, $GUI_SHOW)
    $g_idDivider = GUICtrlCreateLabel("", _X(575), _Y(48), 1, _Y(776))
    GUICtrlSetBkColor($g_idDivider, 0x0F1E3A)
    GUICtrlSetState($g_idDivider, $GUI_DISABLE)
    $lbl_status = GUICtrlCreateLabel("", 0, _Y(802), _X(1290), _Y(28), $SS_CENTERIMAGE)
    GUICtrlSetFont($lbl_status, _F(9), $FW_NORMAL, 0, "Segoe UI")
    GUICtrlSetColor($lbl_status, $g_clrText)
    GUICtrlSetBkColor($lbl_status, $g_clrHeaderBg)
    GUICtrlSetState($lbl_status, $GUI_SHOW)
    $g_idCtrlBg = GUICtrlCreateLabel("", 0, _Y(48), _X(575), _Y(66))
    GUICtrlSetBkColor($g_idCtrlBg, $g_clrBg)
    GUICtrlSetState($g_idCtrlBg, $GUI_DISABLE)
    $g_idCtrlBorder = GUICtrlCreateLabel("", 0, _Y(113), _X(575), 1)
    GUICtrlSetBkColor($g_idCtrlBorder, 0x2D4660)
    GUICtrlSetState($g_idCtrlBorder, $GUI_DISABLE)
    $btnStart = GUICtrlCreateButton("START", _X(40), _Y(58), _X(118), _Y(44))
    GUICtrlSetFont($btnStart, _F(10), $FW_BOLD, 0, "Segoe UI")
    GUICtrlSetBkColor($btnStart, $g_clrRunBg)
    GUICtrlSetColor($btnStart, $g_clrRunText)
    GUICtrlSetOnEvent($btnStart, "EventHandler")
    $btnStopNew = GUICtrlCreateButton("STOP", _X(166), _Y(58), _X(118), _Y(44))
    GUICtrlSetFont($btnStopNew, _F(10), $FW_BOLD, 0, "Segoe UI")
    GUICtrlSetBkColor($btnStopNew, $g_clrStopBg)
    GUICtrlSetColor($btnStopNew, $g_clrStopText)
    GUICtrlSetOnEvent($btnStopNew, "EventHandler")
    $cbx_char_select = GUICtrlCreateCombo("", _X(920), _Y(10), _X(190), 320, BitOR($CBS_DROPDOWNLIST, $CBS_AUTOHSCROLL))
    GUICtrlSetFont($cbx_char_select, _F(10), $FW_NORMAL, 0, "Consolas")
    GUICtrlSetBkColor($cbx_char_select, $g_clrPanel)
    GUICtrlSetColor($cbx_char_select, $g_clrText)
    GUICtrlSetOnEvent($cbx_char_select, "EventHandler")
    $btnResetPhase = GUICtrlCreateButton("RESET", _X(442), _Y(58), _X(122), _Y(44))
    GUICtrlSetFont($btnResetPhase, _F(9), $FW_BOLD, 0, "Segoe UI")
    GUICtrlSetBkColor($btnResetPhase, $g_clrBtnBg)
    GUICtrlSetColor($btnResetPhase, $g_clrBtnText)
    GUICtrlSetOnEvent($btnResetPhase, "EventHandler")
    $btnHideUI = GUICtrlCreateButton("HUD ON", _X(418), _Y(58), _X(118), _Y(44))
    GUICtrlSetFont($btnHideUI, _F(9), $FW_BOLD, 0, "Segoe UI")
    GUICtrlSetBkColor($btnHideUI, $g_clrBtnBg)
    GUICtrlSetColor($btnHideUI, $g_clrBtnText)
    GUICtrlSetOnEvent($btnHideUI, "EventHandler")
    $btnClearPhases = GUICtrlCreateButton("CLEAR", _X(486), _Y(58), _X(78), _Y(44))
    GUICtrlSetFont($btnClearPhases, _F(9), $FW_BOLD, 0, "Segoe UI")
    GUICtrlSetBkColor($btnClearPhases, $g_clrBtnBg)
    GUICtrlSetColor($btnClearPhases, $g_clrBtnText)
    GUICtrlSetOnEvent($btnClearPhases, "EventHandler")
    Local $bAS = (IniRead($g_sConfigFile, "General", "AutoStart", "0") = "1")
    $btnAutoStart = GUICtrlCreateButton($bAS ? "AUTO ON" : "AUTO OFF", _X(292), _Y(58), _X(118), _Y(44))
    GUICtrlSetFont($btnAutoStart, _F(9), $FW_BOLD, 0, "Segoe UI")
    GUICtrlSetBkColor($btnAutoStart, $g_clrBtnBg)
    GUICtrlSetColor($btnAutoStart, $g_clrBtnText)
    GUICtrlSetOnEvent($btnAutoStart, "EventHandler")
    $g_idStatsBg = GUICtrlCreateLabel("", _X(592), _Y(112), _X(682), _Y(142))
    GUICtrlSetBkColor($g_idStatsBg, $g_clrConsoleBg)
    GUICtrlSetState($g_idStatsBg, $GUI_DISABLE)
    $g_idStatsBorder = GUICtrlCreateLabel("", _X(592), _Y(112), _X(682), 1)
    GUICtrlSetBkColor($g_idStatsBorder, 0x2D4660)
    GUICtrlSetState($g_idStatsBorder, $GUI_DISABLE)
    $g_idStatsBorderL = GUICtrlCreateLabel("", _X(592), _Y(112), 1, _Y(142))
    GUICtrlSetBkColor($g_idStatsBorderL, 0x2D4660)
    GUICtrlSetState($g_idStatsBorderL, $GUI_DISABLE)
    $g_idStatsBorderR = GUICtrlCreateLabel("", _X(1273), _Y(112), 1, _Y(142))
    GUICtrlSetBkColor($g_idStatsBorderR, 0x2D4660)
    GUICtrlSetState($g_idStatsBorderR, $GUI_DISABLE)
    $g_idStatsBorderB = GUICtrlCreateLabel("", _X(592), _Y(253), _X(682), 1)
    GUICtrlSetBkColor($g_idStatsBorderB, 0x2D4660)
    GUICtrlSetState($g_idStatsBorderB, $GUI_DISABLE)
    $g_idStatsTitle = GUICtrlCreateLabel("BOT STATUS: STOPPED", _X(608), _Y(128), _X(650), _Y(20))
    GUICtrlSetFont($g_idStatsTitle, _F(10), $FW_BOLD, 0, "Segoe UI")
    GUICtrlSetColor($g_idStatsTitle, $g_clrError)
    GUICtrlSetBkColor($g_idStatsTitle, $g_clrConsoleBg)
    GUICtrlSetState($g_idStatsTitle, $GUI_SHOW)
    GUICtrlSetState($lbl_charName, $GUI_HIDE)
    $lbl_botRunning = GUICtrlCreateLabel("ESTADO: STOPPED", _X(608), _Y(156), _X(178), _Y(22))
    GUICtrlSetFont($lbl_botRunning, _F(9), $FW_BOLD, 0, "Segoe UI")
    GUICtrlSetColor($lbl_botRunning, $g_clrMuted)
    GUICtrlSetBkColor($lbl_botRunning, $g_clrConsoleBg)
    GUICtrlSetState($lbl_botRunning, $GUI_HIDE)
    $lbl_coords = GUICtrlCreateLabel("COORDS: -", _X(1074), _Y(170), _X(184), _Y(22))
    GUICtrlSetFont($lbl_coords, _F(9), $FW_NORMAL, 0, "Segoe UI")
    GUICtrlSetColor($lbl_coords, $g_clrText)
    GUICtrlSetBkColor($lbl_coords, $g_clrConsoleBg)
    GUICtrlSetState($lbl_coords, $GUI_SHOW)
    $lbl_level = GUICtrlCreateLabel("NIVEL: -", _X(608), _Y(156), _X(178), _Y(22))
    GUICtrlSetFont($lbl_level, _F(9), $FW_NORMAL, 0, "Segoe UI")
    GUICtrlSetColor($lbl_level, $g_clrText)
    GUICtrlSetBkColor($lbl_level, $g_clrConsoleBg)
    $lbl_sunspearRank = GUICtrlCreateLabel("LANZA: -", _X(800), _Y(654), _X(260), _Y(22))
    GUICtrlSetFont($lbl_sunspearRank, _F(9), $FW_NORMAL, 0, "Segoe UI")
    GUICtrlSetColor($lbl_sunspearRank, $g_clrText)
    GUICtrlSetBkColor($lbl_sunspearRank, $g_clrConsoleBg)
    GUICtrlSetState($lbl_sunspearRank, $GUI_HIDE)
    $lbl_hp = GUICtrlCreateLabel("VIDA: -", _X(800), _Y(156), _X(260), _Y(22))
    GUICtrlSetFont($lbl_hp, _F(9), $FW_NORMAL, 0, "Segoe UI")
    GUICtrlSetColor($lbl_hp, $g_clrText)
    GUICtrlSetBkColor($lbl_hp, $g_clrConsoleBg)
    $lbl_energy = GUICtrlCreateLabel("ENERGIA: -", _X(1074), _Y(156), _X(184), _Y(22))
    GUICtrlSetFont($lbl_energy, _F(9), $FW_NORMAL, 0, "Segoe UI")
    GUICtrlSetColor($lbl_energy, $g_clrText)
    GUICtrlSetBkColor($lbl_energy, $g_clrConsoleBg)
    $lbl_party = GUICtrlCreateLabel("PARTY: -", _X(608), _Y(184), _X(178), _Y(22))
    GUICtrlSetFont($lbl_party, _F(9), $FW_NORMAL, 0, "Segoe UI")
    GUICtrlSetColor($lbl_party, $g_clrText)
    GUICtrlSetBkColor($lbl_party, $g_clrConsoleBg)
    $lbl_currentState = GUICtrlCreateLabel("MAPA: -", _X(1074), _Y(184), _X(184), _Y(22))
    GUICtrlSetFont($lbl_currentState, _F(9), $FW_NORMAL, 0, "Segoe UI")
    GUICtrlSetColor($lbl_currentState, $g_clrText)
    GUICtrlSetBkColor($lbl_currentState, $g_clrConsoleBg)
    $lbl_currentMission = GUICtrlCreateLabel("DIALOG: -", _X(800), _Y(212), _X(260), _Y(22))
    GUICtrlSetFont($lbl_currentMission, _F(9), $FW_NORMAL, 0, "Segoe UI")
    GUICtrlSetColor($lbl_currentMission, $g_clrText)
    GUICtrlSetBkColor($lbl_currentMission, $g_clrConsoleBg)
    $lbl_questLogState = GUICtrlCreateLabel("MISION: -", _X(800), _Y(184), _X(260), _Y(22))
    GUICtrlSetFont($lbl_questLogState, _F(9), $FW_NORMAL, 0, "Segoe UI")
    GUICtrlSetColor($lbl_questLogState, $g_clrText)
    GUICtrlSetBkColor($lbl_questLogState, $g_clrConsoleBg)
    $lbl_dist = GUICtrlCreateLabel("TARGET: -", _X(608), _Y(212), _X(178), _Y(22))
    GUICtrlSetFont($lbl_dist, _F(9), $FW_NORMAL, 0, "Segoe UI")
    GUICtrlSetColor($lbl_dist, $g_clrText)
    GUICtrlSetBkColor($lbl_dist, $g_clrConsoleBg)
    $lbl_phases_header = GUICtrlCreateLabel("PHASES (57)  -  0 done", _X(10), _Y(124), _X(555), _Y(22))
    GUICtrlSetFont($lbl_phases_header, _F(10), $FW_NORMAL, 0, "Segoe UI")
    GUICtrlSetColor($lbl_phases_header, $g_clrText)
    GUICtrlSetBkColor($lbl_phases_header, $g_clrBg)
    GUICtrlSetState($lbl_phases_header, $GUI_SHOW)
    $idPhaseList = GUICtrlCreateListView("", 0, _Y(156), _X(1380), _Y(632), _
        BitOR($LVS_REPORT, $LVS_NOCOLUMNHEADER, $LVS_SINGLESEL, 0x0008, 0x04000000), _
        $LVS_EX_FULLROWSELECT)
    $hPhaseList = GUICtrlGetHandle($idPhaseList)
    GUICtrlSetBkColor($idPhaseList, $g_clrBg)
    GUICtrlSetColor($idPhaseList, $g_clrText)
    GUICtrlSetFont($idPhaseList, _F(11), $FW_NORMAL, 0, "Consolas")
    _GUICtrlListView_InsertColumn($hPhaseList, 0, "", _X(555))
    Local $hIml = DllCall("comctl32.dll", "handle", "ImageList_Create", _
        "int", 1, "int", 28, "uint", 0, "int", 1, "int", 1)
    If Not @error And IsArray($hIml) Then
        DllCall("user32.dll", "lparam", "SendMessage", _
            "hwnd", $hPhaseList, "uint", 0x1003, "wparam", 0, "lparam", $hIml[0])
    EndIf
    _GUICtrlListView_SetExtendedListViewStyle($hPhaseList, _
        BitOR($LVS_EX_FULLROWSELECT, $LVS_EX_DOUBLEBUFFER))
    GUIRegisterMsg($WM_NOTIFY, "_WM_NOTIFY_PhaseList")
    $g_idLogHdrBg = GUICtrlCreateLabel("", _X(592), _Y(266), _X(682), _Y(506))
    GUICtrlSetBkColor($g_idLogHdrBg, $g_clrConsoleBg)
    GUICtrlSetState($g_idLogHdrBg, $GUI_DISABLE)
    $g_idLogHdrBorder = GUICtrlCreateLabel("", _X(592), _Y(266), _X(682), 1)
    GUICtrlSetBkColor($g_idLogHdrBorder, 0x2D4660)
    GUICtrlSetState($g_idLogHdrBorder, $GUI_DISABLE)
    $g_idLogBorderL = GUICtrlCreateLabel("", _X(592), _Y(266), 1, _Y(506))
    GUICtrlSetBkColor($g_idLogBorderL, 0x2D4660)
    GUICtrlSetState($g_idLogBorderL, $GUI_DISABLE)
    $g_idLogBorderR = GUICtrlCreateLabel("", _X(1273), _Y(266), 1, _Y(506))
    GUICtrlSetBkColor($g_idLogBorderR, 0x2D4660)
    GUICtrlSetState($g_idLogBorderR, $GUI_DISABLE)
    $g_idLogBorderB = GUICtrlCreateLabel("", _X(592), _Y(771), _X(682), 1)
    GUICtrlSetBkColor($g_idLogBorderB, 0x2D4660)
    GUICtrlSetState($g_idLogBorderB, $GUI_DISABLE)
    $g_idLogLabel = GUICtrlCreateLabel("RUN LOG", _X(608), _Y(282), _X(650), _Y(20))
    GUICtrlSetFont($g_idLogLabel, _F(10), $FW_BOLD, 0, "Segoe UI")
    GUICtrlSetColor($g_idLogLabel, $g_clrText)
    GUICtrlSetBkColor($g_idLogLabel, $g_clrConsoleBg)
    GUICtrlSetState($g_idLogLabel, $GUI_SHOW)
    $console = GUICtrlCreateEdit("", _X(608), _Y(310), _X(650), _Y(450), _
        BitOR($ES_MULTILINE, $ES_AUTOVSCROLL, $ES_READONLY, $WS_VSCROLL))
    GUICtrlSetFont($console, _F(11), $FW_NORMAL, 0, "Consolas")
    GUICtrlSetBkColor($console, $g_clrConsoleBg)
    GUICtrlSetColor($console, $g_clrConsoleText)
    _GUICtrlEdit_SetLimitText(GUICtrlGetHandle($console), 0)
    _KillTheme(GUICtrlGetHandle($btnStart))
    _KillTheme(GUICtrlGetHandle($btnStopNew))
    _KillTheme(GUICtrlGetHandle($btnResetPhase))
    _KillTheme(GUICtrlGetHandle($btnHideUI))
    _KillTheme(GUICtrlGetHandle($btnClearPhases))
    _KillTheme($hPhaseList)
    _KillTheme(GUICtrlGetHandle($cbx_char_select))
    _RemoveBorder($hPhaseList)
    _RemoveBorder(GUICtrlGetHandle($console))
    DllCall("user32.dll", "bool", "ShowScrollBar", "hwnd", GUICtrlGetHandle($console), "int", 3, "bool", False)
    GUICtrlSetState($lbl_mapId,         $GUI_HIDE)   
    GUICtrlSetState($lbl_runtime,       $GUI_HIDE)   
    GUICtrlSetState($lbl_status,        $GUI_SHOW)   
    GUICtrlSetState($lbl_phases_header, $GUI_SHOW)   
    GUICtrlSetState($btnResetPhase,     $GUI_HIDE)   
    GUICtrlSetState($btnClearPhases,    $GUI_HIDE)   
    GUICtrlSetState($btnHideUI,         $GUI_SHOW)   
    GUISetOnEvent($GUI_EVENT_CLOSE, "_OnGuiClose")
    GUIRegisterMsg($WM_SIZE, "_WM_SIZE_Handler")
    GUIRegisterMsg($WM_COMMAND, "_WM_COMMAND_GuiControls")
    GUIRegisterMsg(0x020A, "_WM_MouseWheel_v2")
    AdlibRegister("_PollStopButton", 50)
    $g_idCharEnterDummy = GUICtrlCreateDummy()
    GUICtrlSetOnEvent($g_idCharEnterDummy, "_CharNameEnterPressed")
    Local $aAccel[1][2] = [["{ENTER}", $g_idCharEnterDummy]]
    GUISetAccelerators($aAccel, $hGui)
    GUISetState(@SW_SHOW, $hGui)
    _PopulatePhaseList()
    _InstallPhaseScrollKiller()
    Local $sAccounts = _GetLauncherAccountNames()
    If $sAccounts <> "" Then
        GUICtrlSetData($cbx_char_select, "-|" & $sAccounts, "-")
        Ui_SetStatus("Selecciona una cuenta en el desplegable.")
    Else
        Ui_SetStatus("No se encontraron cuentas: pon GW_Launcher.exe + Accounts.json junto al bot o fija [GW] LauncherPath en config.ini.")
    EndIf
EndFunc
Func _GetLauncherAccountNames()
    Local $path = _FindGwLauncherAccountsPath()
    If Not FileExists($path) Then Return ""
    Local $txt = FileRead($path)
    If @error Or $txt = "" Then Return ""
    Local $c = StringRegExp($txt, '"character"\s*:\s*"([^"]*)"', 3)
    If Not IsArray($c) Then Local $c[0]
    Local $cnt = UBound($c)
    Local $out = "", $seen = "|", $nShow = 0, $nSkip = 0
    For $i = 0 To $cnt - 1
        Local $name = StringStripWS($c[$i], 3)
        If $name = "" Then
            $nSkip += 1
            ContinueLoop
        EndIf
        If StringInStr($seen, "|" & $name & "|") Then ContinueLoop
        $seen &= $name & "|"
        $out &= ($out = "" ? "" : "|") & $name
        $nShow += 1
    Next
    Out("[GUI] Cuentas: " & $nShow & " en desplegable (" & $nSkip & " sin ningun identificador) desde " & $path)
    Return $out
EndFunc
Func _ResolveLaunchKey($display)
    Local $path = _FindGwLauncherAccountsPath()
    If Not FileExists($path) Then Return $display
    Local $txt = FileRead($path)
    If @error Or $txt = "" Then Return $display
    Local $c = StringRegExp($txt, '"character"\s*:\s*"([^"]*)"', 3)
    Local $n = StringRegExp($txt, '"Name"\s*:\s*"([^"]*)"', 3)
    Local $t = StringRegExp($txt, '"title"\s*:\s*"([^"]*)"', 3)
    If Not IsArray($c) Then Local $c[0]
    If Not IsArray($n) Then Local $n[0]
    If Not IsArray($t) Then Local $t[0]
    Local $cnt = UBound($c)
    If UBound($n) > $cnt Then $cnt = UBound($n)
    If UBound($t) > $cnt Then $cnt = UBound($t)
    For $i = 0 To $cnt - 1
        Local $hit = False
        If $i < UBound($c) And StringCompare(StringStripWS($c[$i], 3), $display, 2) = 0 And $display <> "" Then $hit = True
        If Not $hit And $i < UBound($n) And StringCompare(StringStripWS($n[$i], 3), $display, 2) = 0 And $display <> "" Then $hit = True
        If Not $hit And $i < UBound($t) And StringCompare(StringStripWS($t[$i], 3), $display, 2) = 0 And $display <> "" Then $hit = True
        If Not $hit Then ContinueLoop
        Local $ch = ""
        If $i < UBound($c) Then $ch = StringStripWS($c[$i], 3)
        If $ch <> "" Then Return $ch
        If $i < UBound($n) And StringStripWS($n[$i], 3) <> "" Then $ch = StringStripWS($n[$i], 3)
        If $ch = "" And $i < UBound($t) Then $ch = StringStripWS($t[$i], 3)
        Out("[Launch] AVISO: la cuenta '" & $display & "' no tiene character en Accounts.json -> lanzo con '" & $ch & "'. Rellena character o fallara (Failed to find account).")
        Ui_SetStatus("Aviso: '" & $display & "' sin character en Accounts.json.")
        If $ch <> "" Then Return $ch
        ExitLoop
    Next
    Out("[Launch] AVISO: '" & $display & "' no aparece en Accounts.json -> lanzo igual (puede fallar).")
    Return $display
EndFunc
Func _FindGwLauncherAccountsPath()
    Local $dir = _FindGwLauncherDir()
    If $dir = "" Then Return ""
    Local $path = $dir & "\Accounts.json"
    If FileExists($path) Then Return $path
    Return ""
EndFunc
Func _FindGwLauncherDir()
    Static $sCached = ""
    If $sCached <> "" And FileExists($sCached & "\Accounts.json") Then Return $sCached
    ; FIX ZIP -master: Accounts.json siempre está junto al bot, sin importar el nombre de la carpeta
    If FileExists(@ScriptDir & "\Accounts.json") Then
        $sCached = @ScriptDir
        Return $sCached
    EndIf
    Local $cfg = @ScriptDir & "\config.ini"
    Local $launcher = IniRead($cfg, "GW", "LauncherPath", "")
    If $launcher <> "" Then
        Local $dirCfg = _DirName($launcher)
        If FileExists($dirCfg & "\Accounts.json") Then
            $sCached = $dirCfg
            Return $sCached
        EndIf
    EndIf
    Local $aRoots[9] = [ _
        @ScriptDir, _
        @ScriptDir & "\..", _
        @DesktopDir, _
        @UserProfileDir, _
        @UserProfileDir & "\Desktop", _
        @UserProfileDir & "\Documents", _
        @ProgramFilesDir, _
        @ProgramFilesDir & " (x86)", _
        @HomeDrive & "\" _
    ]
    For $i = 0 To UBound($aRoots) - 1
        Local $found = _FindGwLauncherDirUnder($aRoots[$i], 5)
        If $found <> "" Then
            $sCached = $found
            Return $sCached
        EndIf
    Next
    Local $aDrives = DriveGetDrive("FIXED")
    If IsArray($aDrives) Then
        For $d = 1 To $aDrives[0]
            Local $foundDrive = _FindGwLauncherDirUnder(StringUpper($aDrives[$d]) & "\", 4)
            If $foundDrive <> "" Then
                $sCached = $foundDrive
                Return $sCached
            EndIf
        Next
    EndIf
    Return ""
EndFunc
Func _FindGwLauncherDirUnder($root, $depth)
    If $root = "" Or $depth < 0 Or Not FileExists($root) Then Return ""
    Local $candidate = $root & "\GW_Launcher.exe"
    If FileExists($root & "\Accounts.json") Then Return $root
    Local $hSearch = FileFindFirstFile($root & "\*")
    If $hSearch = -1 Then Return ""
    While 1
        Local $name = FileFindNextFile($hSearch)
        If @error Then ExitLoop
        If $name = "." Or $name = ".." Then ContinueLoop
        Local $path = $root & "\" & $name
        If StringInStr(FileGetAttrib($path), "D") Then
            Local $lname = StringLower($name)
            If StringInStr($lname, "gw") Or StringInStr($lname, "guild") Or StringInStr($lname, "launcher") Or StringInStr($lname, "suite") Or StringInStr($lname, "scripts") Or StringInStr($lname, "gwau3") Or StringInStr($lname, "game") Or StringInStr($lname, "games") Or StringInStr($lname, "nightfall") Or StringInStr($lname, "storyline") Or StringInStr($lname, "story") Or StringInStr($lname, "bot") Or StringInStr($lname, "free") Or StringInStr($lname, "master") Or StringInStr($lname, "main") Or StringInStr($lname, "trial") Or StringInStr($lname, "night") Then
                Local $found = _FindGwLauncherDirUnder($path, $depth - 1)
                If $found <> "" Then
                    FileClose($hSearch)
                    Return $found
                EndIf
            EndIf
        EndIf
    WEnd
    FileClose($hSearch)
    Return ""
EndFunc
Func _DirName($path)
    Local $iSlash = StringInStr($path, "\", 0, -1)
    If $iSlash <= 1 Then Return ""
    Return StringLeft($path, $iSlash - 1)
EndFunc
Func _PopulatePhaseList()
    If UBound($g_aPhases) = 0 Then
        Out("[GUI] ERROR PopulatePhaseList con 0 fases: conservo la lista visible")
        Return
    EndIf
    _GUICtrlListView_DeleteAllItems($hPhaseList)
    ReDim $g_aPhaseMap[0]
    Local $sLastType = ""
    For $i = 0 To UBound($g_aPhases) - 1
        Local $sType = $g_aPhases[$i][4]  
        If $sType <> $sLastType Then
            _GUICtrlListView_AddItem($hPhaseList, _GroupTypeLabel($sType))
            Local $nMap = UBound($g_aPhaseMap)
            ReDim $g_aPhaseMap[$nMap + 1]
            $g_aPhaseMap[$nMap] = -1   
            $sLastType = $sType
        EndIf
        Local $icon = _PhaseStatusIcon($g_aPhases[$i][2])
        Local $name = StringFormat("%02d. ", $i + 1) & $g_aPhases[$i][1]
        _GUICtrlListView_AddItem($hPhaseList, $icon & "  " & $name)
        Local $nMap = UBound($g_aPhaseMap)
        ReDim $g_aPhaseMap[$nMap + 1]
        $g_aPhaseMap[$nMap] = $i       
    Next
    _GUICtrlListView_SetColumnWidth($hPhaseList, 0, _X(555))
    _UpdatePhasesHeader()
    Out("[GUI] PopulatePhaseList: " & UBound($g_aPhases) & " fases -> " & _GUICtrlListView_GetItemCount($hPhaseList) & " filas")
EndFunc
Func _HideCtrlScrollbars($hwnd)
    If $hwnd = 0 Then Return
    Local $a = DllCall("user32.dll", "long", "GetWindowLong", "hwnd", $hwnd, "int", -16)  
    If Not @error And IsArray($a) Then
        Local $st = BitAND($a[0], BitNOT(0x00200000), BitNOT(0x00100000))  
        DllCall("user32.dll", "long", "SetWindowLong", "hwnd", $hwnd, "int", -16, "long", $st)
    EndIf
    DllCall("user32.dll", "bool", "SetWindowPos", "hwnd", $hwnd, "ptr", 0, _
        "int", 0, "int", 0, "int", 0, "int", 0, "uint", 0x0037)
    DllCall("user32.dll", "bool", "ShowScrollBar", "hwnd", $hwnd, "int", 3, "bool", False)  
EndFunc
Global $g_hPhaseSubCb = 0   
Func _InstallPhaseScrollKiller()
    If $hPhaseList = 0 Or $g_hPhaseSubCb <> 0 Then Return
    $g_hPhaseSubCb = DllCallbackRegister("_PhaseListSubProc", "lresult", _
        "hwnd;uint;wparam;lparam;uint_ptr;dword_ptr")
    If $g_hPhaseSubCb = 0 Then Return
    DllCall("comctl32.dll", "bool", "SetWindowSubclass", "hwnd", $hPhaseList, _
        "ptr", DllCallbackGetPtr($g_hPhaseSubCb), "uint_ptr", 1, "dword_ptr", 0)
    DllCall("user32.dll", "bool", "SetWindowPos", "hwnd", $hPhaseList, "ptr", 0, _
        "int", 0, "int", 0, "int", 0, "int", 0, "uint", 0x0037)
EndFunc
Func _PhaseListSubProc($hWnd, $iMsg, $wParam, $lParam, $iID, $dwData)
    If $iMsg = 0x020A Then
        _WM_MouseWheel_v2($hWnd, $iMsg, $wParam, $lParam)
        Return 0
    EndIf
    Local $aR = DllCall("comctl32.dll", "lresult", "DefSubclassProc", _
        "hwnd", $hWnd, "uint", $iMsg, "wparam", $wParam, "lparam", $lParam)
    Local $ret = 0
    If IsArray($aR) Then $ret = $aR[0]
    If $iMsg = 0x0083 And $wParam Then
        Local $w = 20
        Local $cx = DllCall("user32.dll", "int", "GetSystemMetrics", "int", 2)  
        If IsArray($cx) And $cx[0] > 0 Then $w = $cx[0] + 4
        Local $t = DllStructCreate("int left;int top;int right;int bottom", $lParam)
        DllStructSetData($t, "right", DllStructGetData($t, "right") + $w)
    EndIf
    Return $ret
EndFunc
Func _GroupTypeLabel($sType)
    Return "  --------------------------------------------------------------"
EndFunc
Func _PhaseIndexToListViewRow($idx)
    For $r = 0 To UBound($g_aPhaseMap) - 1
        If $g_aPhaseMap[$r] = $idx Then Return $r
    Next
    Return $idx  
EndFunc
Func _PhaseStatusIcon($status)
    Switch $status
        Case "done"
            Return "[OK]"
        Case "running"
            Return "[>>]"
        Case "failed"
            Return "[X]"
        Case Else
            Return "[ ]"
    EndSwitch
EndFunc
Func _UpdatePhasesHeader()
    Local $nDone = 0
    For $i = 0 To UBound($g_aPhases) - 1
        If $g_aPhases[$i][2] = "done" Then $nDone += 1
    Next
    GUICtrlSetData($lbl_phases_header, "PHASES (" & UBound($g_aPhases) & ")  -  " & $nDone & " done")
EndFunc
Func _SelectAndShowPhase($iPhase)
    If $iPhase < 0 Or $iPhase >= UBound($g_aPhases) Then Return
    Local $row = _PhaseIndexToListViewRow($iPhase)
    If $row < 0 Or $row >= UBound($g_aPhaseMap) Then Return
    _GUICtrlListView_SetItemSelected($hPhaseList, $row, True, True)
    _GUICtrlListView_SetSelectionMark($hPhaseList, $row)
    _GUICtrlListView_EnsureVisible($hPhaseList, $row, False)
    DllCall("user32.dll", "bool", "InvalidateRect", "hwnd", $hPhaseList, "ptr", 0, "bool", True)
EndFunc
Func _OnPhaseListClick($rowFromNotify = -1)
    Local $row = $rowFromNotify
    If $row < 0 Then
        Local $iItem = _GUICtrlListView_GetSelectedIndices($hPhaseList, False)
        If $iItem = "" Or $iItem = -1 Then Return
        $row = Number($iItem)
    EndIf
    If $row < 0 Or $row >= UBound($g_aPhaseMap) Then Return
    Local $i = $g_aPhaseMap[$row]
    If $i < 0 Then Return   
    Local $now = TimerInit()
    If $g_iLastPhaseClick = $i And $g_tLastPhaseClick <> 0 And TimerDiff($g_tLastPhaseClick) < 650 Then
        $g_iLastPhaseClick = -1
        $g_tLastPhaseClick = 0
        _OnPhaseListDoubleClick($row)
        Return
    EndIf
    $g_iLastPhaseClick = $i
    $g_tLastPhaseClick = $now
    $g_iSelectedPhase = $i
    _UpdateStartButton()
    _GUICtrlListView_RedrawItems($hPhaseList, 0, UBound($g_aPhaseMap) - 1)
EndFunc
Func _OnPhaseListDoubleClick($row)
    If $row < 0 Or $row >= UBound($g_aPhaseMap) Then
        $row = _GUICtrlListView_GetSelectionMark($hPhaseList)
    EndIf
    If $row < 0 Or $row >= UBound($g_aPhaseMap) Then Return
    Local $i = $g_aPhaseMap[$row]
    If $i < 0 Or $i >= UBound($g_aPhases) Then Return
    $g_bUserPaused = False
    FileDelete(_BotStopFile())
    _PreparePhaseChainFromIndex($i)
    If $g_bActionRunning Or $g_sPendingAction <> "" Or $g_currentPhase <> "" Then
        $g_iRequestedPhase = $i
        $BotRunning = False
        $g_bChainMode = False
        $g_bForceRunOnce = True
        $g_sQueuedPhase = ""
        $g_sPendingAction = "StopCampaign"
        $g_currentPhase = ""
        $g_currentMission = ""
        $g_state = $NF_STATE_IDLE
        Bot_CancelCurrentAction()
        Ui_SetStatus("Fase " & ($i + 1) & " preparada. Parando fase actual para arrancarla...")
        Return
    EndIf
    _StartBotFromSelection()
EndFunc
Func _RequestBotStop($reason = "Bot pausado. Pulsa START para continuar.")
    $g_iLastStopTime = TimerInit()
    $g_bUserPaused = True
    Local $hStopFlag = FileOpen(_BotStopFile(), 2)
    If $hStopFlag <> -1 Then
        FileWrite($hStopFlag, "1")
        FileClose($hStopFlag)
    EndIf
    $g_iRequestedPhase = -1
    $BotRunning = False
    $g_bChainMode = False
    $g_bForceRunOnce = False
    $g_sPendingAction = "StopCampaign"
    $g_sQueuedPhase = ""
    $g_state = $NF_STATE_IDLE
    Bot_CancelCurrentAction()
    _MarkAllRunningAsPending()
    Ui_SetStatus($reason)
EndFunc
Func _WM_COMMAND_GuiControls($hWnd, $iMsg, $wParam, $lParam)
    Local $ctrlId = BitAND($wParam, 0xFFFF)
    If $ctrlId = $btnStopNew Then
        _RequestBotStop("STOP pulsado. Bot detenido.")
        Return 0
    EndIf
    Return $GUI_RUNDEFMSG
EndFunc
Func _PollStopButton()
    Static $s_bStopMouseDown = False
    If $btnStopNew = 0 Then Return
    Local $aDown = DllCall("user32.dll", "short", "GetAsyncKeyState", "int", 0x01)
    Local $bDown = (IsArray($aDown) And BitAND($aDown[0], 0x8000) <> 0)
    Local $bClicked = (IsArray($aDown) And BitAND($aDown[0], 0x0001) <> 0)
    If Not $bDown And Not $bClicked Then
        $s_bStopMouseDown = False
        Return
    EndIf
    If $bDown And $s_bStopMouseDown Then Return
    Local $hBtn = GUICtrlGetHandle($btnStopNew)
    If $hBtn = 0 Then Return
    Local $tRect = DllStructCreate("long left;long top;long right;long bottom")
    DllCall("user32.dll", "bool", "GetWindowRect", "hwnd", $hBtn, "struct*", $tRect)
    Local $m = MouseGetPos()
    If IsArray($m) _
            And $m[0] >= DllStructGetData($tRect, "left") And $m[0] <= DllStructGetData($tRect, "right") _
            And $m[1] >= DllStructGetData($tRect, "top") And $m[1] <= DllStructGetData($tRect, "bottom") Then
        $s_bStopMouseDown = $bDown
        _RequestBotStop("STOP pulsado. Bot detenido.")
    EndIf
EndFunc
Func _PreparePhaseChainFromIndex($iPhase)
    Local $char = _SelectedOrCachedChar()
    For $i = 0 To UBound($g_aPhases) - 1
        If $i < $iPhase Then
            $g_aPhases[$i][2] = "done"
            If $char <> "" Then IniWrite($g_sConfigFile, "Phases." & $char, $g_aPhases[$i][0], "done")
        Else
            $g_aPhases[$i][2] = "pending"
            If $char <> "" Then IniDelete($g_sConfigFile, "Phases." & $char, $g_aPhases[$i][0])
        EndIf
    Next
    $g_iSelectedPhase = $iPhase
    $g_sQueuedPhase = ""
    $g_bForceRunOnce = True
    $g_bResumeApplied = True
    $g_sResumeAppliedFor = $char
    _PopulatePhaseList()
    _SelectAndShowPhase($iPhase)
    _UpdateStartButton()
    Ui_SetStatus("Fase " & ($iPhase + 1) & " preparada: anteriores completadas, esta pendiente, siguientes por hacer.")
EndFunc
Func _SelectedOrCachedChar()
    Local $char = StringStripWS(GUICtrlRead($cbx_char_select), 3)
    If $char = "" Or $char = "-" Then $char = StringStripWS($g_sCache_charName, 3)
    If $char = "" Or $char = "-" Then $char = StringStripWS(_NF_MainCharName(), 3)
    Return $char
EndFunc
Func _CM_MarkDone()
    Local $i = $g_iRightClickedPhase
    If $i < 0 Or $i >= UBound($g_aPhases) Then
        Local $row = _GUICtrlListView_GetSelectionMark($hPhaseList)
        If $row >= 0 And $row < UBound($g_aPhaseMap) Then $i = $g_aPhaseMap[$row]
    EndIf
    If $i < 0 Or $i >= UBound($g_aPhases) Then Return
    $g_aPhases[$i][2] = "done"
    _GUICtrlListView_SetItemText($hPhaseList, _PhaseIndexToListViewRow($i), _PhaseStatusIcon("done") & "  " & StringFormat("%02d. ", $i + 1) & $g_aPhases[$i][1])
    _GUICtrlListView_RedrawItems($hPhaseList, 0, UBound($g_aPhaseMap) - 1)
    _UpdatePhasesHeader()
    If $g_sCache_charName <> "" Then IniWrite($g_sConfigFile, "Phases." & $g_sCache_charName, $g_aPhases[$i][0], "done")
    Ui_SetStatus("Fase " & ($i + 1) & " '" & $g_aPhases[$i][1] & "' → completada.")
    $g_iRightClickedPhase = -1
EndFunc
Func _CM_MarkPending()
    Local $i = $g_iRightClickedPhase
    If $i < 0 Or $i >= UBound($g_aPhases) Then
        Local $row = _GUICtrlListView_GetSelectionMark($hPhaseList)
        If $row >= 0 And $row < UBound($g_aPhaseMap) Then $i = $g_aPhaseMap[$row]
    EndIf
    If $i < 0 Or $i >= UBound($g_aPhases) Then Return
    $g_aPhases[$i][2] = "pending"
    _GUICtrlListView_SetItemText($hPhaseList, _PhaseIndexToListViewRow($i), _PhaseStatusIcon("pending") & "  " & StringFormat("%02d. ", $i + 1) & $g_aPhases[$i][1])
    _GUICtrlListView_RedrawItems($hPhaseList, 0, UBound($g_aPhaseMap) - 1)
    _UpdatePhasesHeader()
    If $g_sCache_charName <> "" Then IniDelete($g_sConfigFile, "Phases." & $g_sCache_charName, $g_aPhases[$i][0])
    Ui_SetStatus("Fase " & ($i + 1) & " '" & $g_aPhases[$i][1] & "' → pendiente.")
    $g_iRightClickedPhase = -1
EndFunc
Func _CM_MarkDoneThrough()
    Local $i = $g_iRightClickedPhase
    If $i < 0 Or $i >= UBound($g_aPhases) Then
        Local $row = _GUICtrlListView_GetSelectionMark($hPhaseList)
        If $row >= 0 And $row < UBound($g_aPhaseMap) Then $i = $g_aPhaseMap[$row]
    EndIf
    If $i < 0 Or $i >= UBound($g_aPhases) Then Return
    Local $n = 0
    For $k = 0 To $i
        If $g_aPhases[$k][2] <> "done" Then
            $g_aPhases[$k][2] = "done"
            _GUICtrlListView_SetItemText($hPhaseList, _PhaseIndexToListViewRow($k), _PhaseStatusIcon("done") & "  " & StringFormat("%02d. ", $k + 1) & $g_aPhases[$k][1])
            If $g_sCache_charName <> "" Then IniWrite($g_sConfigFile, "Phases." & $g_sCache_charName, $g_aPhases[$k][0], "done")
            $n += 1
        EndIf
    Next
    _GUICtrlListView_RedrawItems($hPhaseList, 0, UBound($g_aPhaseMap) - 1)
    _UpdatePhasesHeader()
    Ui_SetStatus("Fases 1-" & ($i + 1) & " marcadas completadas (" & $n & " nuevas).")
    $g_iRightClickedPhase = -1
EndFunc
Func _UpdateStartButton()
    If $g_iSelectedPhase >= 0 And $g_iSelectedPhase < UBound($g_aPhases) Then
        Local $num = StringFormat("%02d", $g_iSelectedPhase + 1)
        GUICtrlSetData($btnStart, "START desde " & $num)
    Else
        GUICtrlSetData($btnStart, "START")
    EndIf
EndFunc
Func _StartBotFromSelection()
    If $g_bActionRunning Then
        $g_iRequestedPhase = $g_iSelectedPhase
        $g_sPendingAction = "StopCampaign"
        $BotRunning = False
        $g_bChainMode = False
        Bot_CancelCurrentAction()
        Return
    EndIf
    $g_bUserPaused = False
    FileDelete(_BotStopFile())
    Local $char = _SelectedOrCachedChar()
    If $char <> "" And $g_sForcedChar = "" Then IniWrite($g_sConfigFile, "Debug", "MainCharName", $char)
    If Not $Bot_Core_Initialized Then
        If Not _ConnectOrLaunchSelectedAccount() Then Return
    EndIf
    $g_bAutoStartPhaseDone = True
    Gui_v2_StartRuntime()
    If Not $BotRunning Then $BotRunning = True
    If $g_iSelectedPhase < 0 Then
        Local $tResWait = TimerInit()
        While TimerDiff($tResWait) < 120000
            If Bot_UserStopped() Then Return
            If $g_sCache_charName <> "" And $g_sCache_charName <> "-" And $g_bResumeApplied And $g_sResumeAppliedFor = $g_sCache_charName Then ExitLoop
            Sleep(500)
        WEnd
        If Not ($g_bResumeApplied And $g_sResumeAppliedFor = $g_sCache_charName) Then
            Out("[Start] WARN resume no aplicado tras 120s -> arrancar igual (la lista puede desincronizar)")
        EndIf
    EndIf
    _RunSelectedPhase()
EndFunc
Func _ConnectOrLaunchSelectedAccount()
    Local $char = _SelectedOrCachedChar()
    If $char = "" Then
        Ui_SetStatus("Selecciona una cuenta primero.")
        Return False
    EndIf
    If $g_sForcedChar = "" Then IniWrite($g_sConfigFile, "Debug", "MainCharName", $char)
    If ProcessExists("gw.exe") Then
        Local $pid = _GetPidForCharName($char)
        If $pid Then
            Ui_SetStatus("GW abierto para '" & $char & "'. Absorbiendo PID " & $pid & "...")
            _InitializeBotCore()
            If $Bot_Core_Initialized Then
                Ui_SetStatus("Conectado a '" & $char & "'.")
                Return True
            EndIf
            Ui_SetStatus("No se pudo conectar al GW abierto de '" & $char & "'.")
            Return False
        EndIf
        Ui_SetStatus("Hay GW abierto, pero ninguno coincide con '" & $char & "'. Abriendo esa cuenta...")
    EndIf
    If _NF_LaunchAccount($char) Then
        Ui_SetStatus("Cuenta '" & $char & "' abierta y conectada.")
        Return True
    EndIf
    If ProcessExists("gw.exe") Then
        Local $pid2 = _GetPidForCharName($char)
        If $pid2 Then
            _InitializeBotCore()
            Return $Bot_Core_Initialized
        EndIf
    EndIf
    Return False
EndFunc
Func _WM_NOTIFY_PhaseList($hWnd, $iMsg, $iwParam, $ilParam)
    Local $tNMHDR = DllStructCreate("hwnd hWndFrom;uint_ptr idFrom;int code", $ilParam)
    If DllStructGetData($tNMHDR, "hWndFrom") <> $hPhaseList Then Return $GUI_RUNDEFMSG
    Local $iCode = DllStructGetData($tNMHDR, "code")
    If $iCode = -5 Then  
        Return 0
    EndIf
    If $iCode = -2 Then  
        Local $tNMCLICK = DllStructCreate("struct;hwnd hWndFrom;uint_ptr idFrom;int code;endstruct;int iItem;int iSubItem", $ilParam)
        Local $ckItem = DllStructGetData($tNMCLICK, "iItem")
        _OnPhaseListClick($ckItem)
        Return 0
    EndIf
    If $iCode = -3 Then  
        Local $tNMITEM = DllStructCreate("struct;hwnd hWndFrom;uint_ptr idFrom;int code;endstruct;int iItem;int iSubItem", $ilParam)
        Local $rkItem = DllStructGetData($tNMITEM, "iItem")
        _OnPhaseListDoubleClick($rkItem)
        Return 0
    EndIf
    If $iCode = -12 Then  
        Local $tNMCD = DllStructCreate($tagNMLVCUSTOMDRAW, $ilParam)
        Local $iStage = DllStructGetData($tNMCD, "dwDrawStage")
        If $iStage = 1 Then Return 0x00000020  
        If $iStage = 0x10001 Then  
            Local $iItem = DllStructGetData($tNMCD, "dwItemSpec")
            Local $phaseIdx = -1
            If $iItem >= 0 And $iItem < UBound($g_aPhaseMap) Then
                $phaseIdx = $g_aPhaseMap[$iItem]
            EndIf
            Local $clrTxt, $clrBkg
            If $phaseIdx < 0 Then
                $clrTxt = $g_clrDone
                $clrBkg = $g_clrBg
            Else
                Local $status = $g_aPhases[$phaseIdx][2]
                Switch $status
                    Case "done"
                        $clrTxt = $g_clrDone
                    Case "running"
                        $clrTxt = $g_clrText
                    Case "failed"
                        $clrTxt = $g_clrError
                    Case Else
                        If $phaseIdx = $g_iSelectedPhase Then
                            $clrTxt = $g_clrAccent
                        Else
                            $clrTxt = $g_clrPending
                        EndIf
                EndSwitch
                Switch $status
                    Case "running"
                        $clrBkg = 0x1B3047
                    Case "failed"
                        $clrBkg = 0x1B3047
                    Case Else
                        If $phaseIdx = $g_iSelectedPhase Then
                            $clrBkg = 0x264560
                        Else
                            $clrBkg = $g_clrBg
                        EndIf
                EndSwitch
            EndIf
            DllStructSetData($tNMCD, "clrText", _V2_ToBGR($clrTxt))
            DllStructSetData($tNMCD, "clrTextBk", _V2_ToBGR($clrBkg))
            Return 0x00000002  
        EndIf
        Return 0
    EndIf
    Return $GUI_RUNDEFMSG
EndFunc
Func _V2_ToBGR($rgb)
    Return BitOR(BitShift(BitAND($rgb, 0xFF), -16), BitAND($rgb, 0xFF00), BitShift(BitAND($rgb, 0xFF0000), 16))
EndFunc
Func _OutFileNoise($msg)
    If StringInStr($msg, "[DBG] main loop tick") Then Return True   
    If StringInStr($msg, "[DBG] UiTick") Then Return True            
    If StringInStr($msg, "[Recorder] tick") Then Return True         
    If StringInStr($msg, "[Recorder] snapshot") Then Return True     
    If StringInStr($msg, "[Target] Agent=") Then Return True         
    If StringRegExp($msg, "^\[Combat\] t=[\d\.]+s i=\d+") Then Return True 
    If StringInStr($msg, "[Recorder] danger hp=") Then Return True 
    If StringInStr($msg, "[Pathfinder DLL] ERROR code=2") Then
        Static $pf_last_file = 0
        If $pf_last_file = 0 Or TimerDiff($pf_last_file) > 30000 Then
            $pf_last_file = TimerInit()
            Return False 
        EndIf
        Return True 
    EndIf
    Return False
EndFunc
Func _OutShouldSuppress($msg)
    If StringInStr($msg, "[Pathfinder] Initialize -") Then Return True
    If StringInStr($msg, "[Pathfinder] Local maps version") Then Return True
    If StringInStr($msg, "[Pathfinder] Fetching:") Then Return True
    If StringInStr($msg, "[Pathfinder] Remote maps version") Then Return True
    If StringInStr($msg, "[Pathfinder] Download URL:") Then Return True
    If StringInStr($msg, "[Pathfinder] Maps are up to date") Then Return True
    If StringInStr($msg, "[Pathfinder] DLL loaded OK") Then Return True
    If StringInStr($msg, "[Pathfinder] DLL Initialize returned") Then Return True
    If StringInStr($msg, "[Pathfinder] GetPath:") Then Return True
    If StringInStr($msg, "[Pathfinder] SUCCESS:") Then Return True
    If StringInStr($msg, "[Pathfinder DLL] OK:") Then Return True
    If StringInStr($msg, "[Pathfinder DLL] ERROR code=2") Then Return True
    If StringInStr($msg, "[Pathfinder] ERROR: FindPathWithObstacles failed") Then Return True
    If StringInStr($msg, "[Pathfinder] ABORT: movement timeout") Then Return True
    If StringInStr($msg, "[Resume] SKIP re-aplicacion") Then Return True
    If StringInStr($msg, "[Recorder] snapshot") Then Return True
    If StringInStr($msg, "[Recorder] tick") Then Return True
    If StringInStr($msg, "[Recorder] map id=") Then Return True
    If StringInStr($msg, "[Recorder] active_quest") Then Return True
    If StringInStr($msg, "[Recorder] level lvl=") Then Return True
    If StringInStr($msg, "[Recorder] gadget id=") Then Return True
    If StringInStr($msg, "[Recorder] gold_init") Then Return True
    If StringInStr($msg, "[Recorder] skills_init") Then Return True
    If StringInStr($msg, "[Recorder] xp total=") Then Return True
    If StringInStr($msg, "[Recorder] target id=") Then Return True
    If StringInStr($msg, "[AutoLevel] Scythe stuck") Then Return True
    If StringInStr($msg, "[AutoLevel] Mysticism stuck") Then Return True
    If StringInStr($msg, "[AutoLevel] Earth Prayers stuck") Then Return True
    If StringInStr($msg, "[AutoLevel] Wind Prayers stuck") Then Return True
    If StringInStr($msg, "[AutoLevel] Todos los puntos") Then Return True
    If StringInStr($msg, "[AutoLevel] Char: ") And StringInStr($msg, "asignando 1/tick") Then Return True
    If StringInStr($msg, "[Quest Tick]") Then Return True
    If StringInStr($msg, "[State] map=") And StringInStr($msg, "chg=0") Then Return True
    If StringInStr($msg, "[State] idle map=") Then Return True   
    If StringInStr($msg, "[Quest] PRIMARY accepted:") Or StringInStr($msg, "[Quest] RANK accepted:") _
       Or StringInStr($msg, "[Quest] RANK active-switch:") Or StringInStr($msg, "[Quest] RANK state-change:") Then
        Local Static $s_lastQMsg = "", $s_lastQSec = -99
        Local $nowSec = @HOUR * 3600 + @MIN * 60 + @SEC
        If $msg = $s_lastQMsg And ($nowSec - $s_lastQSec) < 60 Then Return True
        $s_lastQMsg = $msg
        $s_lastQSec = $nowSec
        Return False
    EndIf
    If StringRegExp($msg, "tras 0s \(dist=") Then Return True
    If StringInStr($msg, "[Combat-Skills] Cast slot") Then Return True
    If StringRegExp($msg, "^\[Combat\] t=[\d\.]+s i=\d+") Then Return True
    If StringInStr($msg, "[Target] Agent=") Then Return True
    If StringInStr($msg, "[Recorder] danger hp=") Then Return True
    If StringInStr($msg, "[PartyRec] Party member dead") Then Return True
    Return False
EndFunc
Func _FormatLogLine($ts, $sev, $cat, $msg)
    Local $cleanMsg = $msg
    If StringLeft($msg, 1) = "[" Then
        Local $close = StringInStr($msg, "]")
        If $close > 0 Then
            $cleanMsg = StringStripWS(StringMid($msg, $close + 1), 1)
        EndIf
    EndIf
    Local $sevPad = $sev
    Local $sevLen = StringLen($sev)
    If $sevLen < 5 Then
        For $i = 1 To 5 - $sevLen
            $sevPad &= " "
        Next
    EndIf
    Local $catPad
    If StringLen($cat) > 12 Then
        $catPad = StringLeft($cat, 10) & ".."
    Else
        $catPad = $cat
        Local $catLen = StringLen($cat)
        For $i = 1 To 12 - $catLen
            $catPad &= " "
        Next
    EndIf
    Return $ts & "  " & $sevPad & "  " & $catPad & "  " & $cleanMsg
EndFunc
Func _LineMatchesFilter($cat, $sev = "INFO", $msg = "")
    Switch $g_sFilterActive
        Case "(All)"
            Return True
        Case "Compact"
            If $sev = "ERROR" Or $sev = "WARN" Or $sev = "OK" Then Return True
            If $cat = "Phase" Or $cat = "Chain" Then Return True
            Return False
        Case "Errors only"
            Return ($sev = "ERROR" Or $sev = "WARN")
        Case Else
            Return ($g_sFilterActive == $cat)
    EndSwitch
EndFunc
Global $g_sLogFileDir = @TempDir & "\gwbot"
If Not FileExists($g_sLogFileDir) Then DirCreate($g_sLogFileDir)
Global $g_sLogFile = $g_sLogFileDir & "\bot_live.log"
Global $g_sLogFilePrev = $g_sLogFileDir & "\bot_live.prev.log"
If FileExists($g_sLogFile) Then
    FileDelete($g_sLogFilePrev)
    FileMove($g_sLogFile, $g_sLogFilePrev, 1)
EndIf
Global $g_hLogFile = FileOpen($g_sLogFile, 2)   
Global $g_bDebugVerbose = (IniRead(@ScriptDir & "\config.ini", "Debug", "Verbose", "0") = "1")
Global $g_bUserConsole = False
Func Out($msg)
    If Not $g_bDebugVerbose And StringLeft($msg, 5) = "[DBG]" Then Return
    If $g_hLogFile <> -1 And Not _OutFileNoise($msg) Then
        FileWrite($g_hLogFile, StringFormat("%02d:%02d:%02d", @HOUR, @MIN, @SEC) & " " & $msg & @LF)
    EndIf
    If _OutShouldSuppress($msg) Then Return
    Local $cat = "INFO"
    Local $sev = "INFO"
    If StringLeft($msg, 1) = "[" Then
        Local $close = StringInStr($msg, "]")
        If $close > 2 Then
            $cat = StringMid($msg, 2, $close - 2)
        EndIf
    EndIf
    If StringInStr($msg, "ERROR", 1) Or StringInStr($msg, "FAIL", 1) Then
        $sev = "ERROR"
    ElseIf StringInStr($msg, "WARN", 1) Then
        $sev = "WARN"
    ElseIf StringInStr($msg, "OK", 1) Or StringInStr($msg, "DONE", 1) Or StringInStr($msg, "COMPLETADA", 1) Then
        $sev = "OK"
    EndIf
    Local $ts = StringFormat("%02d:%02d:%02d", @HOUR, @MIN, @SEC)
    If $g_iLogCount >= UBound($g_aLogBuf) Then
        ReDim $g_aLogBuf[UBound($g_aLogBuf) + 1024][4]
    EndIf
    $g_aLogBuf[$g_iLogCount][0] = $cat
    $g_aLogBuf[$g_iLogCount][1] = $sev
    $g_aLogBuf[$g_iLogCount][2] = $ts
    $g_aLogBuf[$g_iLogCount][3] = $msg
    $g_iLogCount += 1
    Local $line = ""
    Local $bar = ""
    Local $postBar = False
    If _LineMatchesFilter($cat, $sev, $msg) Then
        $line = _FormatLogLine($ts, $sev, $cat, $msg)
        If $cat = "Phase" Then
            If StringInStr($msg, "iniciada") Then
                $bar = "  ─────────────────────────────────────────────────────" & @CRLF
            ElseIf StringInStr($msg, "COMPLETADA") Or StringInStr($msg, "FAILED") Then
                $postBar = True   
            EndIf
        EndIf
    EndIf
    If $line <> "" Then
        _GUICtrlEdit_SetReadOnly($console, False)
        _GUICtrlEdit_AppendText($console, $bar & $line & @CRLF)
        If $postBar Then _GUICtrlEdit_AppendText($console, @CRLF)
        _GUICtrlEdit_SetReadOnly($console, True)
        If $g_bAutoScroll Then _GUICtrlEdit_Scroll($console, $SB_SCROLLCARET)
        DllCall("user32.dll", "bool", "ShowScrollBar", "hwnd", GUICtrlGetHandle($console), "int", 3, "bool", False)
        Static $s_consoleAppends = 0
        $s_consoleAppends += 1
        If $s_consoleAppends >= 40 Then
            $s_consoleAppends = 0
            _TrimConsole(450)
        EndIf
    EndIf
    If $cat == "Phase" And StringInStr($msg, "COMPLETADA") Then
        Local $rest = StringTrimLeft($msg, StringLen("[Phase] "))
        Local $sp = StringInStr($rest, " ")
        If $sp > 0 Then
            Local $key = StringLeft($rest, $sp - 1)
            _MarkPhaseDone($key)
        EndIf
    EndIf
EndFunc
Func Ui_SetStatus($msg)
    GUICtrlSetData($lbl_status, "  " & $msg)
EndFunc
Func _UserMsg($cat, $sev, $msg)
    Static $sActivity = ""   
    Static $sDeadT    = 0    
    Static $sResignT  = 0    
    If $cat = "Level" And StringInStr($msg, "Char ") Then
        Local $a = StringRegExp($msg, "->\s*(\d+)", 3)
        If IsArray($a) Then Return "  ¡Has subido a nivel " & $a[0] & "!"
        Return ""
    EndIf
    If StringInStr($msg, "reclut") Then Return "  Un nuevo héroe se une al equipo"
    If $cat = "Phase" Then
        If StringInStr($msg, "Sync:") Then Return ""
        If StringInStr($msg, "iniciada") Then Return "  >> EMPEZANDO    " & _UserPhaseLabel($msg)
        If StringInStr($msg, "COMPLETADA") Then Return "  OK COMPLETADA   " & _UserPhaseLabel($msg)
        If StringInStr($msg, "FAILED") Then Return "  Reintentando la fase..."
        Return ""
    EndIf
    If StringInStr($msg, "Mision completada") Or StringInStr($msg, "Misión completada") Then Return "  *** MISIÓN COMPLETADA ***"
    If StringInStr($msg, "resign intencional") Then
        If $sResignT = 0 Or TimerDiff($sResignT) > 8000 Then
            $sResignT = TimerInit()
            $sActivity = ""
            Return "  Resignando para volver a la base"
        EndIf
        Return ""
    EndIf
    If StringInStr($msg, "Party defeated") Or StringInStr($msg, "PARTY DEFEATED") Then
        $sActivity = ""
        Return "  Equipo derrotado, volviendo a la base"
    EndIf
    If StringInStr($msg, "Char dead") Or StringInStr($msg, "Char murio") Or StringInStr($msg, "Char murió") Then
        If $sDeadT = 0 Or TimerDiff($sDeadT) > 8000 Then
            $sDeadT = TimerInit()
            $sActivity = ""
            Return "  Has caído en combate"
        EndIf
        Return ""
    EndIf
    If StringInStr($msg, "Char revived") Or StringInStr($msg, "revivido") Then Return "  De vuelta en pie"
    Local $act = ""
    If $cat = "Combat" Then
        $act = "combat"
    ElseIf StringLeft($cat, 7) = "Mission" Or $cat = "Travel" Then
        $act = "move"
    EndIf
    If $act <> "" Then
        If $act = $sActivity Then Return ""
        $sActivity = $act
        If $act = "combat" Then Return "  En combate"
        Return "  Avanzando hacia el objetivo"
    EndIf
    Return ""   
EndFunc
Func _UserPhaseName($msg)
    Local $s = StringTrimLeft($msg, StringLen("[Phase] "))
    $s = StringRegExpReplace($s, "\s+(iniciada|COMPLETADA|FAILED|FALLAD).*$", "")
    Return StringStripWS($s, 3)
EndFunc
Func _UserPhaseLabel($msg)
    Local $key = _UserPhaseName($msg)
    For $i = 0 To UBound($g_aPhases) - 1
        If $g_aPhases[$i][0] == $key Then
            Return ($i + 1) & ". " & StringUpper($g_aPhases[$i][1])
        EndIf
    Next
    Return StringUpper($key)   
EndFunc
Func _TrimConsole($keepLines)
    Local $hCon = GUICtrlGetHandle($console)
    Local $total = _GUICtrlEdit_GetLineCount($hCon)
    If $total <= $keepLines Then Return
    Local $charIdx = _GUICtrlEdit_LineIndex($hCon, $total - $keepLines)  
    If $charIdx <= 0 Then Return
    Local $sTxt = _GUICtrlEdit_GetText($hCon)
    _GUICtrlEdit_SetReadOnly($hCon, False)
    _GUICtrlEdit_SetText($hCon, StringTrimLeft($sTxt, $charIdx))
    _GUICtrlEdit_SetReadOnly($hCon, True)
    If $g_bAutoScroll Then _GUICtrlEdit_Scroll($hCon, $SB_SCROLLCARET)
EndFunc
Func _OnClearLog()
    $g_iLogCount = 0
    ReDim $g_aLogBuf[2000][4]
    Local $hCon = GUICtrlGetHandle($console)
    _GUICtrlEdit_SetReadOnly($hCon, False)
    _GUICtrlEdit_SetText($hCon, "")
    _GUICtrlEdit_SetReadOnly($hCon, True)
    Ui_SetStatus("Log borrado.")
EndFunc
Func _OnCopyLog()
    ClipPut(_GUICtrlEdit_GetText(GUICtrlGetHandle($console)))
    Ui_SetStatus("Log copiado al clipboard.")
EndFunc
Func _OnGuiClose()
    GUIDelete($hGui)
    Exit
EndFunc
Func Gui_v2_StartRuntime()
    $g_hRuntimeTimer = TimerInit()
EndFunc
Func Gui_v2_Tick()
    Static $s_lastRunFlag = -1
    If $BotRunning <> $s_lastRunFlag Then
        $s_lastRunFlag = $BotRunning
        If $BotRunning Then
            If _NF_IsWine() Then
                Local $hRF = FileOpen("Z:\tmp\bot_phase_running", 2)
                If $hRF <> -1 Then
                    FileWrite($hRF, "1")
                    FileClose($hRF)
                EndIf
            EndIf
        Else
            If _NF_IsWine() Then FileDelete("Z:\tmp\bot_phase_running")
        EndIf
    EndIf
    If $g_hRuntimeTimer > 0 Then
        Local $elapsed = TimerDiff($g_hRuntimeTimer) / 1000
        Local $h = Int($elapsed / 3600)
        Local $m = Int(Mod($elapsed, 3600) / 60)
        Local $s = Int(Mod($elapsed, 60))
        Local $rtStr = StringFormat("%02d:%02d:%02d", $h, $m, $s)
        If $rtStr <> GUICtrlRead($lbl_runtime) Then GUICtrlSetData($lbl_runtime, $rtStr)
    EndIf
    If $Bot_Core_Initialized Then
        Local $name = Agent_GetAgentInfo(-2, "Name")
        If $name <> $g_sCache_charName And StringInStr($name, "[") = 0 Then
            $g_sCache_charName = $name
            Local $prof = Agent_GetAgentInfo(-2, "Prof1Name") & "/" & Agent_GetAgentInfo(-2, "Prof2Name")
            Local $lvl = Agent_GetAgentInfo(-2, "Level")
            GUICtrlSetData($lbl_charName, "")
        EndIf
        Local $mapId = Map_GetMapID()
        Local $mapName = Map_GetInstanceInfo("Name")
        If $mapName = "0" Or $mapName = "" Then
            $mapName = ""
        EndIf
        Local $mapStr = $mapName & " - " & $mapId
        If StringLeft($mapStr, 3) = " - " Then $mapStr = $mapId  
        If $mapStr <> $g_sCache_mapId Then
            $g_sCache_mapId = $mapStr
            GUICtrlSetData($lbl_mapId, $mapStr)
        EndIf
    EndIf
EndFunc
Func _RunSelectedPhase()
    If $g_bRunSelPhaseBusy Then
        Out("[Start] _RunSelectedPhase re-entrante ignorada (busy=True) - la 1a llamada sigue en curso")
        Return
    EndIf
    $g_bRunSelPhaseBusy = True
    _MarkAllRunningAsPending()
    Local $iNameWait = 0
    While ($g_sCache_charName = "" Or $g_sCache_charName = "-") And $iNameWait < 240
        Sleep(500)
        $iNameWait += 1
        If $Bot_Core_Initialized Then
            Local $sNameNow = Agent_GetAgentInfo(-2, "Name")
            If $sNameNow <> "" And $sNameNow <> "0" And StringInStr($sNameNow, "[") = 0 Then $g_sCache_charName = $sNameNow
        EndIf
    WEnd
    If $g_sCache_charName = "" Or $g_sCache_charName = "-" Then
        Out("[Start] ABORT: nombre del char no disponible tras 120s. No arranco fase (evita correr fases ya hechas sobre el char).")
        Ui_SetStatus("ABORT: char no detectado. Espera a entrar in-game y pulsa START.")
        $BotRunning = False
        $g_bRunSelPhaseBusy = False
        Return
    EndIf
    Local $bManualPhase = ($g_bForceRunOnce And $g_iSelectedPhase >= 0 And $g_iSelectedPhase < UBound($g_aPhases))
    If Not $bManualPhase Then
        $g_bResumeApplied = False
        _AutoResumePhases()
    Else
        Out("[Start] Seleccion manual por doble clic: no aplicar resume; se respeta la fase elegida.")
    EndIf
    Local $bMemAllPending = True, $bIniHasDone = False
    For $iG = 0 To UBound($g_aPhases) - 1
        If $g_aPhases[$iG][2] <> "pending" Then $bMemAllPending = False
        If IniRead($g_sConfigFile, "Phases." & $g_sCache_charName, $g_aPhases[$iG][0], "") = "done" Then $bIniHasDone = True
    Next
    If (Not $bManualPhase) And $bMemAllPending And $bIniHasDone Then
        Out("[Start] ABORT: resume no cargo INI (memoria todo pending pero INI tiene dones). No arranco fase 1 por seguridad.")
        Ui_SetStatus("ABORT: resume sin cargar. Re-conecta y pulsa START.")
        $BotRunning = False
        $g_bRunSelPhaseBusy = False
        Return
    EndIf
    Local $iTarget = $g_iSelectedPhase
    If $iTarget < 0 Or $iTarget >= UBound($g_aPhases) Then
        For $i = 0 To UBound($g_aPhases) - 1
            If $g_aPhases[$i][2] = "pending" Then
                $iTarget = $i
                ExitLoop
            EndIf
        Next
    EndIf
    If $iTarget < 0 Then
        Ui_SetStatus("Storyline completa. Todas las fases done.")
        $BotRunning = False
        $g_bRunSelPhaseBusy = False
        Return
    EndIf
    Local $bAutoChain = (IniRead($g_sConfigFile, "General", "AutoStart", "0") = "1")
    $g_bChainMode = $bAutoChain
    Out("[Start] Fase " & ($iTarget + 1) & " '" & $g_aPhases[$iTarget][1] & "' (AUTO " & ($bAutoChain ? "ON - chain" : "OFF - stop after phase") & ")")
    Out("[DBG] RSP1 - pre-RecorderStart")
    If Not $g_bRecording Then _RecorderStart()
    Out("[DBG] RSP2 - post-RecorderStart")
    $g_aPhases[$iTarget][2] = "running"
    $g_bForceRunOnce = True
    $g_iSelectedPhase = -1
    Out("[DBG] RSP3 - pre-UpdateStartButton")
    _UpdateStartButton()
    Out("[DBG] RSP4 - pre-PopulatePhaseList")
    _PopulatePhaseList()
    Out("[DBG] RSP5 - pre-EnsureVisible")
    _GUICtrlListView_EnsureVisible($hPhaseList, _PhaseIndexToListViewRow($iTarget), False)
    Out("[DBG] RSP6 - post-EnsureVisible")
    Ui_SetStatus("Phase: " & $g_aPhases[$iTarget][1] & ($bAutoChain ? " (chain AUTO ON)" : " (AUTO OFF: se para al terminar)"))
    Out("[DBG] RSP7 - pendingAction=" & $g_aPhases[$iTarget][0])
    $g_sPendingAction = $g_aPhases[$iTarget][0]
    $g_bRunSelPhaseBusy = False
EndFunc
Func _MarkPhaseDone($actionKey)
    If Bot_UserStopped() Then Return
    For $i = 0 To UBound($g_aPhases) - 1
        If $g_aPhases[$i][0] == $actionKey Then
            $g_aPhases[$i][2] = "done"
            _GUICtrlListView_SetItemText($hPhaseList, _PhaseIndexToListViewRow($i), _PhaseStatusIcon("done") & "  " & StringFormat("%02d. ", $i + 1) & $g_aPhases[$i][1])
            ExitLoop
        EndIf
    Next
    _SavePhaseDoneToIni($actionKey)
    _UpdatePhasesHeader()
    If $g_sCache_charName <> "" Then IniDelete($g_sConfigFile, "PhasesFailed." & $g_sCache_charName, $actionKey)
    $g_sChainLastFail = ""
    $g_iChainConsecFail = 0
    Local $next = _FindNextPendingPhase($actionKey)
    Local $bAutoChain = (IniRead($g_sConfigFile, "General", "AutoStart", "0") = "1")
    If $next <> "" And $bAutoChain Then
        $g_bChainMode = True
        $g_sQueuedPhase = $next
        Out("[Chain] AUTO ON -> encolada siguiente: " & $next)
    Else
        $g_sQueuedPhase = ""
        If $g_bChainMode Then
            $g_bChainMode = False
        EndIf
        If $next <> "" Then
            $BotRunning = False
            Ui_SetStatus("Fase completada. AUTO OFF: bot pausado; pulsa START para continuar.")
            Out("[Chain] AUTO OFF -> bot pausado tras fase; siguiente pendiente: " & $next)
        Else
            Out("[Chain] Fin de cadena (no hay mas fases pending)")
        EndIf
    EndIf
EndFunc
Global $g_sChainLastFail = ""
Global $g_iChainConsecFail = 0
Func _MarkPhaseFailed($actionKey)
    If Bot_UserStopped() Then Return
    If $g_sCache_charName <> "" Then IniWrite($g_sConfigFile, "PhasesFailed." & $g_sCache_charName, $actionKey, "1")
    If $actionKey = $g_sChainLastFail Then
        $g_iChainConsecFail += 1
    Else
        $g_sChainLastFail = $actionKey
        $g_iChainConsecFail = 1
    EndIf
    If $g_iChainConsecFail >= 3 Then
        Out("[Chain] PAUSA: fase " & $actionKey & " fallo 3 veces seguidas -> intervencion manual (lista intacta, nada marcado done)")
        Ui_SetStatus("PAUSADO: " & $actionKey & " falla siempre. Arreglalo o corre otra fase a mano.")
        $g_sQueuedPhase = ""
        $g_bChainMode = False
        $BotRunning = False
        $g_iChainConsecFail = 0
        Return
    EndIf
    For $i = 0 To UBound($g_aPhases) - 1
        If $g_aPhases[$i][0] == $actionKey Then
            $g_aPhases[$i][2] = "failed"
            _GUICtrlListView_SetItemText($hPhaseList, _PhaseIndexToListViewRow($i), _PhaseStatusIcon("failed") & "  " & StringFormat("%02d. ", $i + 1) & $g_aPhases[$i][1])
            ExitLoop
        EndIf
    Next
    _UpdatePhasesHeader()
    Local $next = _FindNextPendingPhase($actionKey)
    Local $bAutoChain = (IniRead($g_sConfigFile, "General", "AutoStart", "0") = "1")
    If $next <> "" And $bAutoChain Then
        $g_bChainMode = True
        $g_sQueuedPhase = $next
        Out("[Chain] AUTO ON -> fase FAILED, se sigue con la siguiente: " & $next)
    Else
        $g_sQueuedPhase = ""
        $g_bChainMode = False
        $BotRunning = False
        Ui_SetStatus("Fase FAILED. AUTO OFF: bot pausado.")
        Out("[Chain] AUTO OFF -> bot pausado tras FAILED; siguiente pendiente: " & $next)
    EndIf
EndFunc
Func _PhasesMemPristine()
    For $iP = 0 To UBound($g_aPhases) - 1
        If $g_aPhases[$iP][2] <> "pending" Then Return False
    Next
    Return True
EndFunc
Func _SetPhaseRunning($actionKey)
    For $i = 0 To UBound($g_aPhases) - 1
        If $g_aPhases[$i][0] == $actionKey Then
            $g_aPhases[$i][2] = "running"
            Local $row = _PhaseIndexToListViewRow($i)
            _GUICtrlListView_SetItemText($hPhaseList, $row, _PhaseStatusIcon("running") & "  " & StringFormat("%02d. ", $i + 1) & $g_aPhases[$i][1])
            _SelectAndShowPhase($i)
            If $Bot_Core_Initialized And Map_GetMapID() > 0 Then _Team_AuditSkillUnlocks()
            ExitLoop
        EndIf
    Next
EndFunc
Func _FindNextPendingPhase($currentActionKey)
    For $i = 0 To UBound($g_aPhases) - 1
        If $g_aPhases[$i][2] = "pending" Then Return $g_aPhases[$i][0]
    Next
    Return ""
EndFunc
Func _PhaseVerify_SkippedFakeDone($currentActionKey, $iNextPhase)
    Return ""
EndFunc
Func _PhaseVerify_PrevPrimaryQid($iPhase)
    For $k = $iPhase - 1 To 0 Step -1
        Local $qid = _PhaseVerify_QidFor($g_aPhases[$k][0])
        If $qid > 0 Then Return $qid
    Next
    Return 0
EndFunc
Func _PhaseVerify_NextPrimaryQid($iPhase)
    For $k = $iPhase + 1 To UBound($g_aPhases) - 1
        Local $qid = _PhaseVerify_QidFor($g_aPhases[$k][0])
        If $qid > 0 Then Return $qid
    Next
    Return 0
EndFunc
Func _GameQuestLogState($aLog, $qid)
    For $i = 0 To UBound($aLog) - 1
        If $aLog[$i][0] = $qid Then Return $aLog[$i][1]
    Next
    Return -1
EndFunc
Func _DetectRealPhaseFromGame()
    If Not $Bot_Core_Initialized Then Return ""
    Local $aLog[0][2]   
    Local $size = World_GetWorldInfo("QuestLogSize")
    If $size > 0 Then
        For $idx = 0 To $size - 1
            Local $qid = _GetQuestIDByIndex($idx)
            If $qid <= 0 Then ContinueLoop
            ReDim $aLog[UBound($aLog) + 1][2]
            $aLog[UBound($aLog) - 1][0] = $qid
            $aLog[UBound($aLog) - 1][1] = Quest_GetQuestInfo($qid, "LogState")
        Next
    EndIf
    If UBound($aLog) = 0 Then
        Out("[Game] quest log VACÍO (ninguna quest activa/pendiente)")
    Else
        Local $activeCount = 0, $aActiveIds = ""
        For $i = 0 To UBound($aLog) - 1
            If $aLog[$i][1] > 0 Then
                $activeCount += 1
                If $aActiveIds <> "" Then $aActiveIds &= ","
                $aActiveIds &= $aLog[$i][0]
            EndIf
        Next
        If $activeCount > 0 Then
            Out("[Game] " & $activeCount & " quest(s) activa(s) en el juego: " & $aActiveIds & " (de " & UBound($aLog) & " en log)")
        EndIf
    EndIf
    For $i = 0 To UBound($g_aPhases) - 1
        Local $qid = _PhaseVerify_QidFor($g_aPhases[$i][0])
        If $qid = 0 Then ContinueLoop
        Local $ls = _GameQuestLogState($aLog, $qid)
        If $ls > 0 Then
            Out("[Game] fase " & $g_aPhases[$i][0] & " (q" & $qid & ") PRESENTE en el juego (ls=" & $ls & ") -> fase real")
            Return $g_aPhases[$i][0]
        EndIf
    Next
    Out("[Game] sin quest primaria activa en el log -> última completada indeterminada por el juego, usar INI")
    Return ""
EndFunc
Func _MarkAllRunningAsPending()
    For $i = 0 To UBound($g_aPhases) - 1
        If $g_aPhases[$i][2] = "running" Then
            $g_aPhases[$i][2] = "pending"
            _GUICtrlListView_SetItemText($hPhaseList, _PhaseIndexToListViewRow($i), _PhaseStatusIcon("pending") & "  " & StringFormat("%02d. ", $i + 1) & $g_aPhases[$i][1])
        EndIf
    Next
EndFunc
Func _ResetSelectedPhase()
    If $g_iSelectedPhase < 0 Then
        Ui_SetStatus("Selecciona una fase para resetear.")
        Return
    EndIf
    Local $i = $g_iSelectedPhase
    $g_aPhases[$i][2] = "pending"
    _GUICtrlListView_SetItemText($hPhaseList, _PhaseIndexToListViewRow($i), _PhaseStatusIcon("pending") & "  " & StringFormat("%02d. ", $i + 1) & $g_aPhases[$i][1])
    _SavePhasePendingToIni($g_aPhases[$i][0])
    Ui_SetStatus("Phase '" & $g_aPhases[$i][1] & "' reset a pending.")
EndFunc
Func _CharNameEnterPressed()
    Local $sName = StringStripWS(GUICtrlRead($cbx_char_select), 3)
    If $sName = "" Or $sName = "-" Then Return
    If $g_sForcedChar = "" Then IniWrite($g_sConfigFile, "Debug", "MainCharName", $sName)
    _ConnectOrLaunchSelectedAccount()
EndFunc
Func EventHandler()
    Local $iCtrl = @GUI_CtrlId
    If $iCtrl = $btnStart Then
        _StartBotFromSelection()
        Return
    EndIf
    If $iCtrl = $btnStopNew Then
        _RequestBotStop()
        Return
    EndIf
    If $iCtrl = $cbx_char_select Then
        Local $sSel = StringStripWS(GUICtrlRead($cbx_char_select), 3)
        If $sSel <> "" And $sSel <> "-" Then
            If $g_sForcedChar = "" Then IniWrite($g_sConfigFile, "Debug", "MainCharName", $sSel)
            $g_iSelectedPhase = -1
            $g_bForceRunOnce = False
            _UpdateStartButton()
            _StartBotFromSelection()
        EndIf
        Return
    EndIf
    If $iCtrl = $btnResetPhase Then
        _OnResetCharPhases()
        Return
    EndIf
    If $iCtrl = $btnClearPhases Then
        _OnResetCharPhases()
        Return
    EndIf
    If $iCtrl = $btnAutoStart Then
        Local $bNew = Not (IniRead($g_sConfigFile, "General", "AutoStart", "0") = "1")
        IniWrite($g_sConfigFile, "General", "AutoStart", $bNew ? "1" : "0")
        $g_bAutoStartPhaseDone = Not $bNew   
        GUICtrlSetData($btnAutoStart, $bNew ? "AUTO ON" : "AUTO OFF")
        GUICtrlSetColor($btnAutoStart, $g_clrBtnText)
        $g_bChainMode = $bNew And $BotRunning
        Ui_SetStatus($bNew ? "AUTO ON: al terminar una fase continúa en chain." : "AUTO OFF: al terminar una fase se pausa.")
        Return
    EndIf
    If $iCtrl = $btnHideUI Then
        If Not $Bot_Core_Initialized Then
            Ui_SetStatus("HUD: conecta el bot primero (core no inicializado)")
            Return
        EndIf
        Ui_ToggleRendering()
        If Ui_GetRenderDisabled() Then
            GUICtrlSetData($btnHideUI, "HUD OFF")
            If _NF_IsWine() Then
                Local $hSig = FileOpen("/tmp/gw_cpulimit_on", 2)   
                If $hSig <> -1 Then
                    FileWrite($hSig, "1")
                    FileClose($hSig)
                EndIf
            EndIf
            Ui_SetStatus("HUD de GW OCULTO (render off, CPU limitado). Pulsa HUD para mostrarlo.")
        Else
            GUICtrlSetData($btnHideUI, "HUD ON")
            If _NF_IsWine() Then FileDelete("/tmp/gw_cpulimit_on")
            Ui_SetStatus("HUD de GW visible (render on, CPU libre).")
        EndIf
        Return
    EndIf
    If $iCtrl = $idPhaseList Then
        _OnPhaseListClick()
        Return
    EndIf
EndFunc
Func _OnResetCharPhases()
    Local $char = StringStripWS(GUICtrlRead($cbx_char_select), 3)
    If $char = "" Or $char = "-" Then $char = $g_sCache_charName
    If $char = "" Or $char = "-" Then
        Ui_SetStatus("RESET: selecciona primero un personaje.")
        Return
    EndIf
    If $BotRunning Then
        Ui_SetStatus("RESET: pulsa STOP antes de resetear.")
        Return
    EndIf
    If $g_iLastResetTime > 0 And TimerDiff($g_iLastResetTime) < 3000 Then
        $g_iLastResetTime = 0
        _ResetCharPhases($char)
        Return
    EndIf
    $g_iLastResetTime = TimerInit()
    Ui_SetStatus("RESET '" & $char & "': pulsa RESET otra vez en 3s para CONFIRMAR (borra progreso, todo a pending).")
EndFunc
Func _ResetCharPhases($char)
    IniDelete($g_sConfigFile, "Phases." & $char)
    For $i = 0 To UBound($g_aPhases) - 1
        $g_aPhases[$i][2] = "pending"
    Next
    $g_bResumeApplied = True
    $g_sResumeAppliedFor = $char
    _PopulatePhaseList()
    Local $row0 = _PhaseIndexToListViewRow(0)
    _GUICtrlListView_SetItemSelected($hPhaseList, $row0, True, True)
    Out("[Reset] '" & $char & "' reseteado: progreso borrado, todas las fases pending. Listo para START.")
    Ui_SetStatus("RESET OK: '" & $char & "' empieza en la fase 1. Pulsa START.")
EndFunc
Func _AutoConnectIfSingleChar()
    AdlibUnRegister("_AutoConnectIfSingleChar")
    If Not $Bot_Core_Initialized Then _InitializeBotCore()
EndFunc
Func _ScanForCharsRetry()
    If $Bot_Core_Initialized Then
        AdlibUnRegister("_ScanForCharsRetry")
        Return
    EndIf
    If StringStripWS(GUICtrlRead($cbx_char_select), 3) <> "" Then
        AdlibUnRegister("_ScanForCharsRetry")
        Return
    EndIf
    $g_iScanRetries += 1
    Local $sChars = Scanner_GetLoggedCharNames()
    Local $sClean = StringStripWS($sChars, 3)
    If $sClean <> "" Then
        AdlibUnRegister("_ScanForCharsRetry")
        GUICtrlSetData($cbx_char_select, $sChars)
        If StringInStr($sChars, "|") = 0 Then
            GUICtrlSetData($cbx_char_select, "", $sClean)
            Out("[Scan] Personaje detectado: " & $sClean)
            If Not $Bot_Core_Initialized Then AdlibRegister("_AutoConnectIfSingleChar", 1500)
        Else
            Out("[Scan] Personajes detectados: " & $sClean)
            Ui_SetStatus("Selecciona tu personaje y pulsa START.")
        EndIf
    ElseIf $g_iScanRetries >= 3 Then
        AdlibUnRegister("_ScanForCharsRetry")
        Out("[Scan] Scanner no detectó personaje tras " & $g_iScanRetries & " intentos — intentando por PID")
        If Not $Bot_Core_Initialized Then AdlibRegister("_AutoConnectIfSingleChar", 500)
    EndIf
EndFunc
Func _InitializeBotCore()
    If $Bot_Core_Initialized Then Return
    If $g_bInitInProgress Then Return
    $g_bInitInProgress = True
    AdlibUnRegister("_AutoConnectIfSingleChar")
    AdlibUnRegister("_ScanForCharsRetry")
    Local $name = GUICtrlRead($cbx_char_select)
    GUICtrlSetBkColor($lbl_connDot, 0xE0A000)   
    GUICtrlSetData($lbl_connText, "Connecting...")
    Ui_SetStatus("Conectando con Guild Wars...")
    Sleep(50)   
    $g_b_AutoUpdate = False
    Local $iPid = _GetPidForCharName($name)
    Out("[Init] PID de gw.exe para '" & $name & "': " & $iPid)
    Local $ok = 0
    If $iPid Then
        Out("[Init] Llamando Core_Initialize con PID=" & $iPid & " ...")
        $ok = Core_Initialize($iPid, False)
        Out("[Init] Core_Initialize devolvió: " & $ok)
    Else
        If ProcessExists("gw.exe") Then
            Out("[Init] ERROR: hay gw.exe abiertos pero ninguno con el char '" & $name & "' — no inyecto (evita tocar otras cuentas)")
            Ui_SetStatus("El GW abierto es de otra cuenta/personaje. Cierra ese GW o pulsa Enter para lanzar '" & $name & "'.")
        Else
            Out("[Init] ERROR: ProcessExists('gw.exe') = 0 — GW no encontrado")
        EndIf
    EndIf
    If $ok = 0 Then
        GUICtrlSetBkColor($lbl_connDot, 0xCC3333)
        GUICtrlSetData($lbl_connText, "Disconnected")
        Out("[Init] ERROR: Core_Initialize devolvió 0 — fallo de conexión")
        $g_bInitInProgress = False
        Ui_SetStatus("GW no encontrado. Abre GW con un personaje in-game (gwlauncher) y conectaré solo.")
        Return
    EndIf
    $Bot_Core_Initialized = True
    If StringStripWS(GUICtrlRead($cbx_char_select), 3) = "" Then
        Local $realName = Agent_GetAgentInfo(-2, "Name")
        If Not @error And $realName <> "" Then
            GUICtrlSetData($cbx_char_select, "")
            GUICtrlSetData($cbx_char_select, $realName, $realName)
            Out("[Init] Combo rellenado post-connect con nombre real: " & $realName)
        EndIf
    EndIf
    Pathfinder_SetSwitchTeleportCallback("NF_SwitchTeleportHandler")
    Out("[Init] Switch teleport callback registrado (NF_SwitchTeleportHandler)")
    GUICtrlSetBkColor($lbl_connDot, 0x2E9E4F)
    GUICtrlSetData($lbl_connText, "Connected")
    $g_sCache_connText = "Connected"
    GUICtrlSetState($btnRunPhase, $GUI_ENABLE)
    GUICtrlSetState($btnPause, $GUI_ENABLE)
    GUICtrlSetState($btnRecord, $GUI_ENABLE)
    AdlibRegister("_UiTick", 500)
    Local $sRealName = Agent_GetAgentInfo(-2, "Name")
    If $sRealName <> "" And $sRealName <> "0" And StringInStr($sRealName, "[") = 0 Then $g_sCache_charName = $sRealName
    GameEvents_Init()
    _AutoDetectDonePhases()
    _AutoResumePhases()
    Local $pfdOn = (GUICtrlRead($chkPathfinderDebug) = $GUI_CHECKED)
    Pathfinder_SetDebug($pfdOn)
    Ui_SetStatus("Conectado. Detectando fase y arrancando automaticamente...")
    If _GUICtrlListView_GetItemCount($hPhaseList) = 0 And UBound($g_aPhases) > 0 Then
        Out("[GUI] WARN lista vacia tras conectar: repoblando")
        _PopulatePhaseList()
    EndIf
    $g_bInitInProgress = False
EndFunc
Func _AutoDetectDonePhases()
    Local $nDetected = 0
    For $i = 0 To UBound($g_aPhases) - 1
        If $g_aPhases[$i][2] = "done" Then ContinueLoop
        Local $ak = $g_aPhases[$i][0]
        If _IsPhaseDoneByQuestState($ak) Then
            $g_aPhases[$i][2] = "done"
            _SavePhaseDoneToIni($ak)
            $nDetected += 1
        EndIf
    Next
    If $nDetected > 0 Then
        _PopulatePhaseList()
        Out("[AutoDetect] " & $nDetected & " bots marcados done por quest state")
    EndIf
EndFunc
Func _SavePhaseDoneToIni($actionKey)
    If $g_sCache_charName = "" Or $g_sCache_charName = "-" Then Return
    Local $section = "Phases." & $g_sCache_charName
    IniWrite($g_sConfigFile, $section, $actionKey, "done")
    If $actionKey = "M17_AbaddonsGate" Then
        IniDelete($g_sConfigFile, $section)
        For $i = 0 To UBound($g_aPhases) - 1
            $g_aPhases[$i][2] = "pending"
        Next
        _PopulatePhaseList()
        $g_bChainMode = False   
        $g_sQueuedPhase = ""    
        IniWrite($g_sConfigFile, "Campaign", "Finished_" & $g_sCache_charName, "1")
        Out("[Fin] 🏁 CAMPAÑA COMPLETA -> progreso BORRADO y bot QUIETO (candado Finished). Pulsa START para re-correrla.")
        Out("==========================================================")
        Out("[Fin] STORYLINE COMPLETADA - campaña terminada. Cerrando el bot...")
        Out("==========================================================")
        Ui_SetStatus("Storyline completada. Cerrando el bot...")
        Sleep(2000)
        Exit
    Else
        If IniRead($g_sConfigFile, "Campaign", "Finished_" & $g_sCache_charName, "0") = "1" Then
            IniDelete($g_sConfigFile, "Campaign", "Finished_" & $g_sCache_charName)
            Out("[Fin] candado Finished retirado (re-run en curso)")
        EndIf
    EndIf
EndFunc
Func _SavePhasePendingToIni($actionKey)
    If $g_sCache_charName = "" Or $g_sCache_charName = "-" Then Return
    Local $section = "Phases." & $g_sCache_charName
    IniWrite($g_sConfigFile, $section, $actionKey, "pending")
EndFunc
Func _ResumeLogActiveQuests()
    Local $quests[10] = [677, 676, 600, 596, 649, 715, 632, 633, 634, 716]
    Local $names[10] = ["Tutorial", "M01 Chahbek", "PrimaryTraining", "Sec.Prof", "Leaving a Legacy(start)", _
                        "Rising:Master", "Leaving a Legacy(reward)", "Jokanur Diggings (M02)", _
                        "Signs and Portents", "Rising:First Spear"]
    For $i = 0 To 9
        Local $qid = $quests[$i]
        Local $st = Quest_GetQuestInfo($qid, "LogState")
        Local $dn = Quest_GetQuestInfo($qid, "IsCompleted")
        If $st > 0 And $dn <> 1 Then
            Out("[Quest " & $qid & "] " & $names[$i] & " - ACTIVA, no completada (LogState=" & $st & ")")
        EndIf
    Next
EndFunc
Func _PhaseVerify_QidFor($actionKey)
    Switch $actionKey
        Case "SkipTutorial_P1", "SkipTutorial_P2", "SkipTutorial_P3"
            Return 677            
        Case "PrimaryTraining"
            Return 600            
        Case "HoningYourSkills"
            Return 649            
        Case "LeavingALegacy"
            Return 632            
        Case "TheHonorableGeneral"
            Return 633            
        Case "SignsAndPortents"
            Return 634            
        Case "IsleOfTheDead"
            Return 635            
        Case "BadTideRising"
            Return 636            
        Case "SpecialDelivery"
            Return 637            
        Case "BigNewsSmallPackage"
            Return 638            
        Case "FollowingTheTrail"
            Return 639            
        Case "TheIronTruth"
            Return 640            
        Case "TrialByFire"
            Return 641            
        Case "WarPrep_RecruitTraining"
            Return 642            
        Case "WarPrep_WindAndWater"
            Return 643            
        Case "WarPrep_GhostRecon"
            Return 644            
        Case "TheTimeIsNigh"
            Return 645            
        Case "Hunted"
            Return 548            
        Case "TheGreatEscape"
            Return 549            
        Case "AndAHeroShallLeadThem"
            Return 550            
        Case "TheCouncilIsCalled"
            Return 490            
        Case "ToVabbi"
            Return 551            
        Case "CentaurBlackmail"
            Return 552            
        Case "MysteriousMessage"
            Return 553            
        Case "SecretsInTheShadow"
            Return 554            
        Case "ToKillADemon"
            Return 555            
        Case "RallyThePrinces"
            Return 556            
        Case "AllsWellThatEndsWell"
            Return 503            
        Case "WarningKehanni"
            Return 504            
        Case "CallingTheOrder"
            Return 505            
        Case "PledgeOfMerchantPrinces"
            Return 507            
        Case "AttackAtTheKodash"
            Return 680            
        Case "HeartOrMindRonjokInDanger"
            Return 586            
        Case "CrossingTheDesolation"
            Return 684            
        Case "ADealsADeal"
            Return 583            
        Case "HordeOfDarkness"
            Return 584            
        Case "UnchartedTerritory"
            Return 701            
        Case "KormirsCrusade"
            Return 702            
        Case "AllAloneInTheDarkness"
            Return 703            
        Case Else
            Return 0
    EndSwitch
EndFunc
Func _PhaseVerify_CurrentPhase($actionKey)
    Local $qid = _PhaseVerify_QidFor($actionKey)
    If $qid = 0 Then Return ""        
    If Quest_GetQuestInfo($qid, "LogState") > 0 Then Return ""   
    Local $i, $j
    Local $found = -1
    For $i = 0 To UBound($g_aPhases) - 1
        If $g_aPhases[$i][0] = $actionKey Then
            $found = $i
            ExitLoop
        EndIf
    Next
    If $found <= 0 Then Return ""
    For $j = $found - 1 To 0 Step -1
        Local $prevKey = $g_aPhases[$j][0]
        Local $prevQid = _PhaseVerify_QidFor($prevKey)
        If $prevQid > 0 Then
            If Quest_GetQuestInfo($prevQid, "LogState") > 0 Then
                Out("[Verify] " & $actionKey & " no es la fase real: q" & $prevQid & " (" & $prevKey & ") sigue activa -> redirigir a " & $prevKey)
                Return $prevKey
            EndIf
        EndIf
    Next
    Return ""
EndFunc
Func _IsPhaseDoneByQuestState($actionKey)
    Switch $actionKey
        Case "SkipTutorial_P1"
            If Quest_GetQuestInfo(677, "LogState") = 33 Or Quest_GetQuestInfo(677, "LogState") = 35 Then Return True
            If Map_GetMapID() = 544 Then Return True
            For $i = 1 To 7
                If Party_GetMyPartyHeroInfo($i, "HeroID") = 6 Then Return True
            Next
            Return False
        Case "SkipTutorial_P2"
            If Map_GetMapID() = 544 Then Return True
            For $i = 1 To 7
                If Party_GetMyPartyHeroInfo($i, "HeroID") = 6 Then Return True
            Next
            Return False
        Case "SkipTutorial_P3"
            For $i = 1 To 7
                If Party_GetMyPartyHeroInfo($i, "HeroID") = 6 Then Return True
            Next
            Return False
        Case "RewardM01"
            Return False
        Case "PrimaryTraining"
            Return Quest_GetQuestInfo($GC_I_QUEST_ID_HONINGYOURSKILLS, "LogState") > 0
        Case "TravelToSunspearHall"
            Return Map_IsMapUnlocked(431) = 1
        Case "TravelToAstralarium"
            Return Map_IsMapUnlocked(502) = 1
        Case "TravelToChampionsDawn"
            Return Map_IsMapUnlocked(479) = 1
        Case "FarmSunspear"
            Return False   
        Case "CQ_KamadanStart"
            Return True   
        Case "CQ_Sanctuary"
            Return Quest_GetQuestInfo(632, "LogState") > 0
        Case "CQ_TravelCD"
            Return False   
        Case "CompleteQuests"
            Return Quest_GetQuestInfo(632, "LogState") > 0
        Case "TravelToCliffsOfDohjok"
            Return Map_IsMapUnlocked($GC_I_MAP_ID_JOKANUR_DIGGINGS_OUTPOST)
        Case "RewardLeavingLegacy"
            Return (Quest_GetQuestInfo(632, "IsCompleted") = 1) _
               And (Quest_GetQuestInfo(633, "LogState") > 0)
        Case "BuySkillsKamadan"
            Return False   
        Case "SetupSkillBar"
            Return False   
        Case "RecruitMorgahn"
            Return Quest_GetQuestInfo(634, "LogState") > 0
        Case "RM_Step1_ExitToZehlon", "RM_Step2_NavToMorgahn", "RM_Step3_BossFight", _
             "RM_Step4_CrossToAstra", "RM_Step5_RewardAccept", _
             "SP_Step1_AstraToZehlon", "SP_Step2_TalkNPC5424", "SP_Step3_NavToMelonni", _
             "SP_Step4_TalkMelonni", "SP_Step5_NavToNPC15", "SP_Step6_JokanurReward"
            Return False   
        Case "SignsAndPortents"
            Return False
        Case "M02_JokanurDiggings"
            Return False
        Case "IsleOfTheDead"
            Return False
        Case "CrossingTheDesolation"
            Return False
        Case Else
            Return False
    EndSwitch
EndFunc
Func _PhaseHasQuestCheck($actionKey)
    Switch $actionKey
        Case "SkipTutorial_P1"         
        Case "SkipTutorial_P2"         
        Case "SkipTutorial_P3"         
        Case "TravelToSunspearHall"    
        Case "TravelToAstralarium"     
        Case "TravelToChampionsDawn"   
        Case "CQ_KamadanStart"         
        Case "CQ_Sanctuary"            
        Case "CompleteQuests"          
        Case "TravelToCliffsOfDohjok"  
        Case "RewardLeavingLegacy"     
        Case "RecruitMorgahn"          
        Case "SignsAndPortents"        
        Case "IsleOfTheDead"           
            Return True
        Case Else
            Return False
    EndSwitch
EndFunc
Func _DetectCurrentPhaseFromGame()
    If Not $Bot_Core_Initialized Then
        Ui_SetStatus("[Fases] Sin conexión — conecta primero para detectar progreso desde el juego.")
        Return
    EndIf
    If $g_sCache_charName = "" Or $g_sCache_charName = "-" Then
        Ui_SetStatus("[Fases] Sin personaje detectado.")
        Return
    EndIf
    Local $section  = "Phases." & $g_sCache_charName
    Local $currentKey = ""
    Local $checkedByQuest = 0
    Local $checkedByIni   = 0
    For $i = 0 To UBound($g_aPhases) - 1
        Local $ak = $g_aPhases[$i][0]
        Local $isDone = False
        If _PhaseHasQuestCheck($ak) Then
            $isDone = _IsPhaseDoneByQuestState($ak)
            $checkedByQuest += 1
            If Not $isDone And $g_sCache_charName <> "" Then
                $isDone = (IniRead($g_sConfigFile, $section, $ak, "") = "done")
                If $isDone Then $checkedByIni += 1
            EndIf
        Else
            $isDone = (IniRead($g_sConfigFile, $section, $ak, "") = "done")
            $checkedByIni += 1
        EndIf
        If Not $isDone Then
            $currentKey = $ak
            ExitLoop
        EndIf
    Next
    If $currentKey = "" Then
        Ui_SetStatus("[Fases] Storyline completo — todas las fases done según juego + INI.")
        Out("[Fases] Detección: todas done (quest=" & $checkedByQuest & " INI=" & $checkedByIni & ")")
        Return
    EndIf
    _SyncPhasesAroundActive($currentKey)
    Ui_SetStatus("[Fases] Detectada: '" & $currentKey & "' (quest=" & $checkedByQuest & " INI=" & $checkedByIni & ")")
    Out("[Fases] Fase actual detectada desde juego: " & $currentKey)
EndFunc
Func _SyncPhasesAroundActive($actionKey)
    Local $idx = -1
    For $i = 0 To UBound($g_aPhases) - 1
        If $g_aPhases[$i][0] = $actionKey Then
            $idx = $i
            ExitLoop
        EndIf
    Next
    If $idx = -1 Then Return
    Local $section = "Phases." & $g_sCache_charName
    Local $failSection = "PhasesFailed." & $g_sCache_charName
    For $i = 0 To $idx - 1
        If $g_sCache_charName <> "" And IniRead($g_sConfigFile, $failSection, $g_aPhases[$i][0], "0") = "1" Then
            If $g_aPhases[$i][2] = "done" Then
                $g_aPhases[$i][2] = "pending"
                _GUICtrlListView_SetItemText($hPhaseList, _PhaseIndexToListViewRow($i), _PhaseStatusIcon("pending") & "  " & StringFormat("%02d. ", $i + 1) & $g_aPhases[$i][1])
                IniDelete($g_sConfigFile, $section, $g_aPhases[$i][0])
                Out("[Phase] Sync: '" & $g_aPhases[$i][0] & "' estaba done pero FALLO antes -> pending (no saltar)")
            EndIf
            ContinueLoop
        EndIf
        If $g_aPhases[$i][2] <> "done" Then
            $g_aPhases[$i][2] = "done"
            _GUICtrlListView_SetItemText($hPhaseList, _PhaseIndexToListViewRow($i), _PhaseStatusIcon("done") & "  " & StringFormat("%02d. ", $i + 1) & $g_aPhases[$i][1])
            If $g_sCache_charName <> "" Then IniWrite($g_sConfigFile, $section, $g_aPhases[$i][0], "done")
        EndIf
    Next
    For $i = $idx + 1 To UBound($g_aPhases) - 1
        If $g_aPhases[$i][2] = "done" Then
            Local $fQid = _PhaseVerify_QidFor($g_aPhases[$i][0])
            If $Bot_Core_Initialized And $fQid > 0 And Quest_GetQuestInfo($fQid, "LogState") > 0 Then
                $g_aPhases[$i][2] = "pending"
                _GUICtrlListView_SetItemText($hPhaseList, _PhaseIndexToListViewRow($i), _PhaseStatusIcon("pending") & "  " & StringFormat("%02d. ", $i + 1) & $g_aPhases[$i][1])
                If $g_sCache_charName <> "" Then IniDelete($g_sConfigFile, $section, $g_aPhases[$i][0])
                Out("[Phase] Sync: '" & $g_aPhases[$i][0] & "' done era FALSO (q" & $fQid & " activa) -> pending")
            EndIf
        EndIf
    Next
    Out("[Phase] Sync: " & $idx & " anteriores done, " & (UBound($g_aPhases) - 1 - $idx) & " siguientes pending (" & $actionKey & ")")
EndFunc
Func _AutoResumePhases()
    If $g_sCache_charName = "" Or $g_sCache_charName = "-" Then
        Static $s_resumeNonameLog = 0
        If $s_resumeNonameLog = 0 Or TimerDiff($s_resumeNonameLog) > 10000 Then
            Out("[Resume] sin nombre de char aun (juego cargando?) -> reintentar, INI no cargado")
            $s_resumeNonameLog = TimerInit()
        EndIf
        Return
    EndIf
    If $g_bResumeApplied And $g_sResumeAppliedFor = $g_sCache_charName Then
        Local $sSecCheck = "Phases." & $g_sCache_charName
        Local $bAnyIniDone = False, $bAnyMemDone = False
        For $iC = 0 To UBound($g_aPhases) - 1
            If IniRead($g_sConfigFile, $sSecCheck, $g_aPhases[$iC][0], "") = "done" Then
                $bAnyIniDone = True
                ExitLoop
            EndIf
        Next
        For $iC = 0 To UBound($g_aPhases) - 1
            If $g_aPhases[$iC][2] = "done" Then
                $bAnyMemDone = True
                ExitLoop
            EndIf
        Next
        If Not $bAnyIniDone And $bAnyMemDone Then
            Out("[Resume] INI vacío pero memoria tiene fases done -> char nuevo detectado, resetear a pending")
            For $iC = 0 To UBound($g_aPhases) - 1
                $g_aPhases[$iC][2] = "pending"
            Next
            _PopulatePhaseList()
            $g_bResumeApplied = False
        Else
            Return
        EndIf
    EndIf
    Local $bMemPristine = True
    For $iP = 0 To UBound($g_aPhases) - 1
        If $g_aPhases[$iP][2] <> "pending" Then
            $bMemPristine = False
            ExitLoop
        EndIf
    Next
    If $g_bResumeApplied And ($BotRunning Or $g_currentPhase <> "") And Not $bMemPristine Then
        Static $s_resumeSkipLog = 0
        If $s_resumeSkipLog = 0 Or TimerDiff($s_resumeSkipLog) > 5000 Then
            Out("[Resume] SKIP re-aplicacion (BotRunning=True o phase activa '" & $g_currentPhase & "'). Char actual=" & $g_sCache_charName)
            $s_resumeSkipLog = TimerInit()
        EndIf
        $g_sResumeAppliedFor = $g_sCache_charName
        $g_bResumeApplied = True
        Return
    EndIf
    If $g_sResumeAppliedFor <> "" And $g_sResumeAppliedFor <> $g_sCache_charName Then
        For $i = 0 To UBound($g_aPhases) - 1
            $g_aPhases[$i][2] = "pending"
        Next
        _PopulatePhaseList()   
        Out("[Resume] Char cambio (" & $g_sResumeAppliedFor & " -> " & $g_sCache_charName & ") - reset fases")
    EndIf
    If False And $Bot_Core_Initialized Then
        Local $logState677 = Quest_GetQuestInfo(677, "LogState")
        If $logState677 > 0 Then
            IniDelete($g_sConfigFile, "Phases." & $g_sCache_charName)
            Out("[Resume] Char nuevo detectado (tutorial activo, LogState677=" & $logState677 & ") - INI de fases borrado, todo pending")
            _GUICtrlListView_SetItemSelected($hPhaseList, 0, True, True)
            Ui_SetStatus("Char nuevo detectado. Siguiente: 1 TakeTheShortcut_P1")
            $g_bResumeApplied = True
            $g_sResumeAppliedFor = $g_sCache_charName
            Return
        EndIf
    EndIf
    Local $section = "Phases." & $g_sCache_charName
    Local $applied = 0
    Local $appliedByQuest = 0
    Local $staleCleared = 0
    Local $skipTutorialDone = _IsPhaseDoneByQuestState("SkipTutorial_P3")
    For $i = 0 To UBound($g_aPhases) - 1
        Local $actionKey = $g_aPhases[$i][0]
        Local $iniState = IniRead($g_sConfigFile, $section, $actionKey, "")
        Local $qid = _PhaseVerify_QidFor($actionKey)
        If $Bot_Core_Initialized And $qid > 0 And Quest_GetQuestInfo($qid, "LogState") > 0 Then
            If $iniState = "done" Or $g_aPhases[$i][2] = "done" Then
                Out("[Resume] q" & $qid & " ACTIVA (" & $actionKey & ") -> done en INI era FALSO, revertido a pending")
                IniDelete($g_sConfigFile, $section, $actionKey)
                $g_aPhases[$i][2] = "pending"
                $staleCleared += 1
            EndIf
            ContinueLoop
        EndIf
        Local $questDone = _IsPhaseDoneByQuestState($actionKey)
        If $questDone Then
            $g_aPhases[$i][2] = "done"
            $applied += 1
            If $iniState <> "done" Then
                $appliedByQuest += 1
                IniWrite($g_sConfigFile, $section, $actionKey, "done")
            EndIf
        ElseIf $iniState = "done" Then
            $g_aPhases[$i][2] = "done"
            $applied += 1
        EndIf
    Next
    If $applied > 0 Or $staleCleared > 0 Then
        _PopulatePhaseList()   
        Local $extra = ""
        If $appliedByQuest > 0 Then $extra &= " (" & $appliedByQuest & " por quest state)"
        If $staleCleared > 0 Then $extra &= " (" & $staleCleared & " INI obsoletos limpiados)"
        Out("[Resume] " & $applied & " fases done para '" & $g_sCache_charName & "'" & $extra)
    EndIf
    _ResumeLogActiveQuests()
    Local $iPick = -1
    Local $realPhaseKey = _DetectRealPhaseFromGame()
    If $realPhaseKey <> "" Then
        Local $iReal = -1
        For $i = 0 To UBound($g_aPhases) - 1
            If $g_aPhases[$i][0] = $realPhaseKey Then
                $iReal = $i
                ExitLoop
            EndIf
        Next
        If $iReal >= 0 Then
            $iPick = $iReal
            If $g_aPhases[$iReal][2] = "done" Then
                Out("[Resume] FASE REAL del juego '" & $realPhaseKey & "' estaba done en INI -> revertido a pending (no está completada)")
                IniDelete($g_sConfigFile, "Phases." & $g_sCache_charName, $realPhaseKey)
                $g_aPhases[$iReal][2] = "pending"
            EndIf
            _SyncPhasesAroundActive($realPhaseKey)
        EndIf
    EndIf
    If $iPick >= 0 Then
        For $iF = 0 To $iPick - 1
            If $g_aPhases[$iF][2] = "pending" Then
                Out("[Resume] fase " & ($iPick + 1) & " detectada por quest pero " & ($iF + 1) & " pendiente -> jugar primero lo pendiente")
                $iPick = $iF
                ExitLoop
            EndIf
        Next
    EndIf
    If $iPick = -1 Then
        If $Bot_Core_Initialized Then
            For $i = 0 To UBound($g_aPhases) - 1
                Local $pickQid = _PhaseVerify_QidFor($g_aPhases[$i][0])
                If $pickQid > 0 And Quest_GetQuestInfo($pickQid, "LogState") > 0 Then
                    $iPick = $i
                    ExitLoop
                EndIf
            Next
        EndIf
    EndIf
    If $iPick = -1 Then
        For $i = 0 To UBound($g_aPhases) - 1
            If $g_aPhases[$i][2] = "pending" Then
                $iPick = $i
                ExitLoop
            EndIf
        Next
    EndIf
    If $iPick >= 0 Then
        _SelectAndShowPhase($iPick)
        Local $sugerencia = "Siguiente fase: " & ($iPick + 1) & " " & $g_aPhases[$iPick][1] & " (pulsa Run)"
        If $g_aPhases[$iPick][2] = "done" Then $sugerencia &= " [quest activa -> re-run]"
        Out("[Resume] " & $sugerencia)
        Ui_SetStatus($sugerencia)
    EndIf
    $g_bResumeApplied = True
    $g_sResumeAppliedFor = $g_sCache_charName
    Local $sAutorunFlag = (_NF_IsWine() ? "Z:\tmp\nf_autorun.flag" : @ScriptDir & "\nf_autorun.flag")
    If FileExists($sAutorunFlag) Then
        FileDelete($sAutorunFlag)
        If IniRead($g_sConfigFile, "Campaign", "Finished_" & $g_sCache_charName, "0") = "1" Then
            Out("[Resume] campaña COMPLETADA para '" & $g_sCache_charName & "' -> bot quieto (autorun ignorado; pulsa START para re-correr)")
            Return
        EndIf
        Out("[Resume] Flag autorun detectado -> arrancando fase sin interacción")
        Sleep(2000)  
        If $Bot_Core_Initialized And Not $BotRunning Then
            $BotRunning = True
            Gui_v2_StartRuntime()
            _RunSelectedPhase()
            $g_bChainMode = True
            Out("[Resume] Chain mode ON -> encadenando hasta el final (fire-and-forget)")
        EndIf
    EndIf
EndFunc
Func _WM_SIZE_Handler($hWnd, $iMsg, $wParam, $lParam)
    If $wParam = 1 Then Return $GUI_RUNDEFMSG  
    Local $newW = BitAND($lParam, 0xFFFF)
    Local $newH = BitShift($lParam, 16)
    If $newW < 200 Or $newH < 200 Then
        If $wParam = 2 Then
            Local $aMon = _GetPrimaryMonitorWorkarea()
            $newW = $aMon[2]
            $newH = $aMon[3]
        Else
            Return $GUI_RUNDEFMSG
        EndIf
    EndIf
    $g_scX = $newW / 1290
    $g_scY = $newH / 830
    _RelayoutControls()
    Return $GUI_RUNDEFMSG
EndFunc
Func _GetPrimaryMonitorWorkarea()
    Local $tRect = DllStructCreate("long left;long top;long right;long bottom")
    DllCall("user32.dll", "bool", "SystemParametersInfoA", "int", 48, "int", 0, "struct*", $tRect, "int", 0)
    Local $aResult[4] = [DllStructGetData($tRect, "left"), DllStructGetData($tRect, "top"), _
                          DllStructGetData($tRect, "right") - DllStructGetData($tRect, "left"), _
                          DllStructGetData($tRect, "bottom") - DllStructGetData($tRect, "top")]
    Return $aResult
EndFunc
Func _RelayoutControls()
    DllCall("user32.dll", "bool", "LockWindowUpdate", "hwnd", $hGui)
    GUICtrlSetPos($g_idHdrBg,         0,         0,         _X(1290), _Y(46))
    GUICtrlSetPos($g_idHdrAccent,      0,         _Y(45),    _X(1290), _Y(2))
    GUICtrlSetPos($g_idBotName,        _X(14),    _Y(12),    _X(300),  _Y(22))
    GUICtrlSetFont($g_idBotName,       _F(11), $FW_NORMAL, 0, "Segoe UI")
    GUICtrlSetState($lbl_charName,     $GUI_HIDE)
    GUICtrlSetPos($lbl_mapId,          _X(690),   _Y(12),    _X(130),  _Y(22))
    GUICtrlSetFont($lbl_mapId,         _F(11), $FW_NORMAL, 0, "Consolas")
    GUICtrlSetPos($lbl_runtime,        _X(730),   _Y(12),    _X(90),   _Y(22))
    GUICtrlSetFont($lbl_runtime,       _F(11), $FW_NORMAL, 0, "Consolas")
    GUICtrlSetPos($cbx_char_select,    _X(920),   _Y(10),    _X(190),  200)   
    GUICtrlSetPos($lbl_connDot,        _X(1128),  _Y(14),    _X(14),   _Y(14))
    GUICtrlSetPos($lbl_connText,       _X(1146),  _Y(12),    _X(132),  _Y(22))
    GUICtrlSetFont($lbl_connText,      _F(10), $FW_NORMAL, 0, "Segoe UI")
    GUICtrlSetPos($g_idDivider,        _X(575),   _Y(48),    1,        _Y(776))
    GUICtrlSetPos($lbl_status,         0,          _Y(802),   _X(1290), _Y(28))
    GUICtrlSetFont($lbl_status,        _F(9), $FW_NORMAL, 0, "Segoe UI")
    GUICtrlSetPos($g_idCtrlBg,         0,          _Y(48),   _X(575),  _Y(66))
    GUICtrlSetPos($g_idCtrlBorder,     0,          _Y(113),  _X(575),  1)
    GUICtrlSetPos($btnStart,           _X(40),     _Y(58),   _X(118),  _Y(44))
    GUICtrlSetFont($btnStart,          _F(10), $FW_BOLD,   0, "Segoe UI")
    GUICtrlSetPos($btnStopNew,         _X(166),    _Y(58),   _X(118),  _Y(44))
    GUICtrlSetFont($btnStopNew,        _F(10), $FW_BOLD,   0, "Segoe UI")
    GUICtrlSetPos($btnAutoStart,       _X(292),    _Y(58),   _X(118),  _Y(44))
    GUICtrlSetPos($btnHideUI,          _X(418),    _Y(58),   _X(118),  _Y(44))
    GUICtrlSetState($btnHideUI,        $GUI_SHOW)
    GUICtrlSetPos($btnClearPhases,     _X(486),    _Y(58),   _X(78),   _Y(44))
    GUICtrlSetPos($btnResetPhase,      _X(442),    _Y(58),   _X(122),  _Y(44))
    GUICtrlSetPos($g_idStatsBg,        _X(592),    _Y(112),  _X(682),  _Y(142))
    GUICtrlSetPos($g_idStatsBorder,    _X(592),    _Y(112),  _X(682),  1)
    GUICtrlSetPos($g_idStatsBorderL,   _X(592),    _Y(112),  1,        _Y(142))
    GUICtrlSetPos($g_idStatsBorderR,   _X(1273),   _Y(112),  1,        _Y(142))
    GUICtrlSetPos($g_idStatsBorderB,   _X(592),    _Y(253),  _X(682),  1)
    GUICtrlSetPos($g_idStatsTitle,     _X(608),    _Y(128),  _X(650),  _Y(20))
    GUICtrlSetFont($g_idStatsTitle,    _F(10), $FW_BOLD, 0, "Segoe UI")
    GUICtrlSetState($lbl_charName,     $GUI_HIDE)
    GUICtrlSetPos($lbl_botRunning,     _X(608),    _Y(156),  _X(178),  _Y(22))
    GUICtrlSetFont($lbl_botRunning,    _F(9), $FW_BOLD, 0, "Segoe UI")
    GUICtrlSetState($lbl_botRunning,   $GUI_HIDE)
    GUICtrlSetPos($lbl_coords,    _X(800),    _Y(626),  _X(458),  _Y(22))
    GUICtrlSetFont($lbl_coords,   _F(9), $FW_NORMAL, 0, "Segoe UI")
    GUICtrlSetPos($lbl_coords,    _X(1074),   _Y(212),  _X(184),  _Y(22))
    GUICtrlSetState($lbl_coords,  $GUI_SHOW)
    GUICtrlSetPos($lbl_level,          _X(608),    _Y(156),  _X(178),  _Y(22))
    GUICtrlSetFont($lbl_level,         _F(9), $FW_NORMAL, 0, "Segoe UI")
    GUICtrlSetPos($lbl_sunspearRank,   _X(800),    _Y(654),  _X(260),  _Y(22))
    GUICtrlSetFont($lbl_sunspearRank,  _F(9), $FW_NORMAL, 0, "Segoe UI")
    GUICtrlSetState($lbl_sunspearRank, $GUI_HIDE)
    GUICtrlSetPos($lbl_hp,             _X(800),    _Y(156),  _X(260),  _Y(22))
    GUICtrlSetFont($lbl_hp,            _F(9), $FW_NORMAL, 0, "Segoe UI")
    GUICtrlSetPos($lbl_energy,         _X(1074),   _Y(156),  _X(184),  _Y(22))
    GUICtrlSetFont($lbl_energy,        _F(9), $FW_NORMAL, 0, "Segoe UI")
    GUICtrlSetPos($lbl_party,          _X(608),    _Y(184),  _X(178),  _Y(22))
    GUICtrlSetFont($lbl_party,         _F(9), $FW_NORMAL, 0, "Segoe UI")
    GUICtrlSetPos($lbl_currentState,   _X(1074),   _Y(184),  _X(184),  _Y(22))
    GUICtrlSetFont($lbl_currentState,  _F(9), $FW_NORMAL, 0, "Segoe UI")
    GUICtrlSetPos($lbl_currentMission, _X(800),    _Y(212),  _X(260),  _Y(22))
    GUICtrlSetFont($lbl_currentMission,_F(9), $FW_NORMAL, 0, "Segoe UI")
    GUICtrlSetState($lbl_currentMission, $GUI_SHOW)
    GUICtrlSetPos($lbl_questLogState,  _X(800),    _Y(184),  _X(260),  _Y(22))
    GUICtrlSetFont($lbl_questLogState, _F(9), $FW_NORMAL, 0, "Segoe UI")
    GUICtrlSetPos($lbl_dist,           _X(608),    _Y(212),  _X(178),  _Y(22))
    GUICtrlSetFont($lbl_dist,          _F(9), $FW_NORMAL, 0, "Segoe UI")
    GUICtrlSetPos($lbl_phases_header,  _X(10),     _Y(124),  _X(555),  _Y(22))
    GUICtrlSetFont($lbl_phases_header, _F(10), $FW_NORMAL, 0, "Segoe UI")
    GUICtrlSetPos($idPhaseList,        0,          _Y(156),  _X(1380),  _Y(632))
    GUICtrlSetFont($idPhaseList,       _F(11), $FW_NORMAL, 0, "Consolas")
    _GUICtrlListView_SetColumnWidth($hPhaseList, 0, _X(555))
    Local $hRgn = DllCall("gdi32.dll", "handle", "CreateRectRgn", "int", 0, "int", 0, "int", _X(575), "int", _Y(632))
    If Not @error And IsArray($hRgn) Then
        DllCall("user32.dll", "int", "SetWindowRgn", "hwnd", $hPhaseList, "handle", $hRgn[0], "bool", True)
    EndIf
    GUICtrlSetPos($g_idLogHdrBg,       _X(592),   _Y(266),   _X(682),  _Y(506))
    GUICtrlSetPos($g_idLogHdrBorder,   _X(592),   _Y(266),   _X(682),  1)
    GUICtrlSetPos($g_idLogBorderL,     _X(592),   _Y(266),   1,        _Y(506))
    GUICtrlSetPos($g_idLogBorderR,     _X(1273),  _Y(266),   1,        _Y(506))
    GUICtrlSetPos($g_idLogBorderB,     _X(592),   _Y(771),   _X(682),  1)
    GUICtrlSetPos($g_idLogLabel,       _X(608),   _Y(282),   _X(650),  _Y(20))
    GUICtrlSetFont($g_idLogLabel,      _F(10), $FW_BOLD, 0, "Segoe UI")
    GUICtrlSetPos($console,            _X(608),   _Y(310),   _X(650),  _Y(450))
    GUICtrlSetFont($console,           _F(11), $FW_NORMAL, 0, "Consolas")
    DllCall("user32.dll", "bool", "LockWindowUpdate", "hwnd", 0)
EndFunc
Func _X($v)
    Return Round($v * $g_scX)
EndFunc
Func _Y($v)
    Return Round($v * $g_scY)
EndFunc
Func _F($v)
    Return Round($v * $g_scX)
EndFunc
Func _RemoveBorder($hwnd)
    Local $aStyle = DllCall("user32.dll", "long", "GetWindowLong", "hwnd", $hwnd, "int", -16)
    If Not @error And IsArray($aStyle) Then
        DllCall("user32.dll", "long", "SetWindowLong", "hwnd", $hwnd, "int", -16, _
            "long", BitAND($aStyle[0], BitNOT(0x800000)))  
    EndIf
    Local $aExStyle = DllCall("user32.dll", "long", "GetWindowLong", "hwnd", $hwnd, "int", -20)
    If Not @error And IsArray($aExStyle) Then
        DllCall("user32.dll", "long", "SetWindowLong", "hwnd", $hwnd, "int", -20, _
            "long", BitAND($aExStyle[0], BitNOT(0x200)))  
    EndIf
    DllCall("user32.dll", "bool", "SetWindowPos", "hwnd", $hwnd, "hwnd", 0, _
        "int", 0, "int", 0, "int", 0, "int", 0, "uint", 0x0027)
EndFunc
Func _WM_MouseWheel_v2($hWnd, $iMsg, $wParam, $lParam)
    Local $iDelta = BitShift($wParam, 16)
    If $iDelta > 32767 Then $iDelta -= 65536  
    Local $hConsoleHwnd = GUICtrlGetHandle($console)
    Local $tPoint = DllStructCreate("long x;long y")
    DllCall("user32.dll", "bool", "GetCursorPos", "struct*", $tPoint)
    Local $iCurX = DllStructGetData($tPoint, "x")
    Local $iCurY = DllStructGetData($tPoint, "y")
    Local $tRect = DllStructCreate("long left;long top;long right;long bottom")
    DllCall("user32.dll", "bool", "GetWindowRect", "hwnd", $hConsoleHwnd, "struct*", $tRect)
    If $iCurX >= DllStructGetData($tRect, "left")   And $iCurX <= DllStructGetData($tRect, "right") _
       And $iCurY >= DllStructGetData($tRect, "top") And $iCurY <= DllStructGetData($tRect, "bottom") Then
        Local $iLines = 3
        If $iDelta > 0 Then
            For $i = 1 To $iLines  
                DllCall("user32.dll", "lresult", "SendMessage", "hwnd", $hConsoleHwnd, "uint", 0x0115, "wparam", 0, "lparam", 0)
            Next
        Else
            For $i = 1 To $iLines  
                DllCall("user32.dll", "lresult", "SendMessage", "hwnd", $hConsoleHwnd, "uint", 0x0115, "wparam", 1, "lparam", 0)
            Next
        EndIf
        Return 0
    EndIf
    Local $consoleLeft = DllStructGetData($tRect, "left")  
    DllCall("user32.dll", "bool", "GetWindowRect", "hwnd", $hPhaseList, "struct*", $tRect)
    If $iCurX >= DllStructGetData($tRect, "left")   And $iCurX < $consoleLeft _
       And $iCurY >= DllStructGetData($tRect, "top") And $iCurY <= DllStructGetData($tRect, "bottom") Then
        If $iDelta > 0 Then
            _GUICtrlListView_Scroll($hPhaseList, 0, -40)   
        Else
            _GUICtrlListView_Scroll($hPhaseList, 0, 40)    
        EndIf
        DllCall("user32.dll", "bool", "ShowScrollBar", "hwnd", $hPhaseList, "int", 3, "bool", False)
        DllCall("user32.dll", "bool", "RedrawWindow", "hwnd", $hConsoleHwnd, "ptr", 0, "ptr", 0, "uint", 0x0101)  
        Return 0
    EndIf
    Return $GUI_RUNDEFMSG
EndFunc
Func _KillTheme($idOrHwnd)
    Local $hwnd
    If IsHWnd($idOrHwnd) Then
        $hwnd = $idOrHwnd
    Else
        $hwnd = GUICtrlGetHandle($idOrHwnd)
    EndIf
    If $hwnd <> 0 Then
        DllCall("uxtheme.dll", "int", "SetWindowTheme", "hwnd", $hwnd, "wstr", "", "wstr", "")
    EndIf
EndFunc
Func _UiTick()
    _PollStopButton()
    If $g_bDbgUiTickTrace Then Out("[DBG] UiTick A - pre-UpdateUi cnt=" & $g_iDbgUiTickCount)
    If $g_UpdateUiLastMs = 0 Or TimerDiff($g_UpdateUiLastMs) >= 3000 Then
        UpdateUiCharInfo()
        $g_UpdateUiLastMs = TimerInit()
    EndIf
    If $g_bDbgUiTickTrace Then Out("[DBG] UiTick B - post-UpdateUi")
    If Not Bot_UserStopped() Then _AutoResumePhases()
    If $g_bDbgUiTickTrace Then Out("[DBG] UiTick C - post-AutoResume")
    If $g_bDbgUiTickTrace Then Out("[DBG] UiTick F - pre-Cinematic")
    If Not Bot_UserStopped() Then Cinematic_ProtectStep()
    If Not Bot_UserStopped() Then
        _NF_GwWatchdog()
        _NF_HangWatchdog()
    EndIf
    If $g_bDbgUiTickTrace Then Out("[DBG] UiTick G - pre-GameEvents")
    If Not Bot_UserStopped() Then GameEvents_Tick()
    If $g_bDbgUiTickTrace Then Out("[DBG] UiTick H - pre-PartyRecovery")
    If Not Bot_UserStopped() And $g_bActionRunning Then PartyRecovery_Tick()
    If $g_bDbgUiTickTrace Then Out("[DBG] UiTick I - pre-Loot")
    If Not Bot_UserStopped() Then AutoParty_Tick()
    If Not Bot_UserStopped() Then AutoLevel_TickCharOnly()
    If Not Bot_UserStopped() Then _Inv_UseIgneousSummonStone()
    If Not Bot_UserStopped() Then Loot_Tick()
    If $g_bDbgUiTickTrace Then
        $g_iDbgUiTickCount += 1
        Out("[DBG] UiTick Z - END #" & $g_iDbgUiTickCount & " actionRunning=" & $g_bActionRunning & " pending='" & $g_sPendingAction & "'")
        If $g_iDbgUiTickCount >= 2 Then $g_bDbgUiTickTrace = False   
    EndIf
EndFunc
Func _GetQuestIDByIndex($idx)
    Local $l_ai_Offset[5] = [0, 0x18, 0x2C, 0x52C, 0x34 * $idx]
    Local $l_ap_QuestPtr = Memory_ReadPtr($g_p_BasePointer, $l_ai_Offset, "long")
    If Not IsArray($l_ap_QuestPtr) Then Return 0
    Return $l_ap_QuestPtr[1]
EndFunc
Func _GetPidForCharName($targetName)
    If $targetName = "" Then Return 0
    Local $tgt = StringStripWS($targetName, 3)
    Local $procs = ProcessList("gw.exe")
    If $procs[0][0] = 0 Then Return 0
    Local $wmi = ObjGet("winmgmts:\\\\.\\root\\cimv2")
    If IsObj($wmi) Then
        For $i = 1 To $procs[0][0]
            Local $pid = $procs[$i][1]
            Local $cmd = ""
            Local $col = $wmi.ExecQuery("SELECT CommandLine FROM Win32_Process WHERE ProcessId=" & $pid)
            For $o In $col
                $cmd = $o.CommandLine
                ExitLoop
            Next
            Local $m = StringRegExp($cmd, '(?i)-character\s+"([^"]+)"', 1)
            If IsArray($m) Then
                If StringCompare($m[0], $tgt, 2) = 0 Then
                    Out("[Init] Match commandline '-character """ & $m[0] & """' -> PID=" & $pid)
                    _NF_TagGwWindowByPid($pid, $tgt)
                    Return $pid
                EndIf
            EndIf
        Next
    EndIf
    Local $aW = WinList("[CLASS:ArenaNet_Dx_Window_Class]")
    If IsArray($aW) And $aW[0][0] >= 1 Then
        For $wi = 1 To $aW[0][0]
            Local $wT = WinGetTitle($aW[$wi][1])
            If StringInStr($wT, $tgt, 2) > 0 Then
                Local $pidW = WinGetProcess($aW[$wi][1])
                Out("[Init] Match titulo '" & $wT & "' -> PID=" & $pidW)
                _NF_TagGwWindowByPid($pidW, $tgt)
                Return $pidW
            EndIf
        Next
    EndIf
    For $i = 1 To $procs[0][0]
        Local $pid = $procs[$i][1]
        Memory_Open($pid)
        If $g_h_GWProcess Then
            Local $charName = Scanner_ScanForCharname()
            Memory_Close()
            $g_h_GWProcess = 0
            If StringStripWS($charName, 3) = $tgt Then
                Out("[Init] Match char '" & $charName & "' -> PID=" & $pid)
                _NF_TagGwWindowByPid($pid, $tgt)
                Return $pid
            EndIf
        Else
            Memory_Close()
            $g_h_GWProcess = 0
        EndIf
    Next
    Out("[Init] WARN: ningun gw.exe matcheo '" & $targetName & "' -> PID=0 (NO inyectar en gw ajeno)")
    Return 0
EndFunc