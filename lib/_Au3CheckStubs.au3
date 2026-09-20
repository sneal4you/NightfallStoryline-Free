#include-once
Func Extend_Write($arg1 = 0, $arg2 = 0, $arg3 = 0, $arg4 = 0)
EndFunc
Func Extend_AssemblerWriteDetour($arg1 = 0, $arg2 = 0, $arg3 = 0, $arg4 = 0)
EndFunc
Func StartBot()
EndFunc
Func _Exit()
EndFunc
Global $Bot_Core_Initialized = False
Global $g_sPendingAction = ""
Global $g_currentMission = ""
Global $BotRunning = False
Global $btnRecord
Global $cbx_char_select
Global $lbl_botRunning
Global $lbl_coords
Global $lbl_currentMission
Global $lbl_currentState
Global $lbl_charName
Global $lbl_charProf
Global $lbl_level
Global $lbl_sunspearRank
Global $lbl_mapId
Global $lbl_hp
Global $lbl_energy
Global $lbl_party
Global $lbl_dist
Global $lbl_questLogState
Global $g_sCache_botRunning = ""
Global $g_sCache_coords = ""
Global $g_sCache_currentMission = ""
Global $g_sCache_currentState = ""
Global $g_sCache_charName = ""
Global $g_sCache_charProf = ""
Global $g_sCache_level = ""
Global $g_sCache_sunspearRank = ""
Global $g_sCache_mapId = ""
Global $g_sCache_hp = ""
Global $g_sCache_energy = ""
Global $g_sCache_party = ""
Global $g_sCache_dist = ""
Global $g_sCache_questLog = ""
Global Const $NF_STATE_IDLE             = 0
Global Const $NF_STATE_DETECT_PROGRESS  = 1
Global Const $NF_STATE_ACCEPT_QUEST     = 2
Global Const $NF_STATE_ENTER_MISSION    = 3
Global Const $NF_STATE_IN_MISSION       = 4
Global Const $NF_STATE_DONE             = 5
Global $g_aLogBuf[1024][4]
Global $g_iLogCount = 0
Global $g_bActionRunning = False                     
Global $g_currentPhase = ""                          
Global $g_bRegistroMode = False                      
Global $g_sConfigFile = @ScriptDir & "\config.ini"   
Global $g_GE_DeathCount = 0                           
Global $g_GE_RescueEnabled = True                     
Global $g_aiAutoPartyHeroes[3] = [$GC_I_HERO_ID_KOSS, $GC_I_HERO_ID_DUNKORO, $GC_I_HERO_ID_MELONNI] 
Global $g_iPathfinder_MovementTimeout = 8000
Global $g_PR_CastLock = False
Global $g_bUAIFightActive = False                 
Global $g_GE_NeedsWalkback = False                
Global $g_state = $NF_STATE_IDLE                  
Global $g_sRedirectPhase = ""                     
Global $g_iKossLastUnused = -1                    
Global $g_iDunkoroLastUnused = -1                 
Global $g_iMelonniLastUnused = -1                 
Global $g_iTahlkoraLastUnused = -1                
Global $g_iUT_AggroRange = 1500                   
Global $g_iUT_ClearRange = 1500                   