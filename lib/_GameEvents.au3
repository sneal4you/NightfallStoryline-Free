#include-once
#Region GLOBALS SNAPSHOT
Global $g_bAntiIdleTargetLock = False 
Global $g_GE_Initialized      = False
Global $g_GE_LastCharLevel    = 0
Global $g_GE_LastHeroLevel[9]            
Global $g_GE_LastHeroID[9]               
Global $g_GE_LastMapID        = -1
Global $g_GE_LastMapType      = -1
Global $g_GE_LastActiveQuest  = 0
Global $g_GE_LastTargetAgent  = 0
Global $g_GE_LastTargetModel  = 0
Global $g_GE_TargetCooldown   = 0        
Global $g_GE_QuestStates[1][2]
Global $g_GE_QuestCount       = 0
Global $g_GE_LastDialogCode   = 0
Global $g_GE_LastDialogTimer  = 0
Global $g_GE_LastDialogQuestId    = 0
Global $g_GE_LastDialogQuestState = -1
Global $g_GE_QuestDumpTimer   = 0
Global $g_GE_StateHbTimer     = 0
Global Const $GE_STATE_HB_MS  = 10000
Global $g_GE_LastStateSig     = ""    
Global $g_GE_LastCharIsDead   = False
Global $g_GE_DeathCount       = 0
Global $g_GE_DeathPosX        = 0     
Global $g_GE_DeathPosY        = 0
Global $g_GE_DeathMapID       = 0
Global $g_GE_NeedsWalkback          = False
Global $g_GE_RevivedAt              = 0     
Global $g_GE_WalkbackStarted        = False 
Global $g_GE_WalkbackReemitTimer    = 0     
Global $g_GE_WalkbackTimeoutTimer   = 0     
Global $g_GE_Quest715Removed = False
Global $g_GE_Quest644Removed = False
Global $g_GE_LastStuckX       = 0
Global $g_GE_LastStuckY       = 0
Global $g_GE_StuckTimer       = 0
Global $g_GE_StuckRescueCount = 0     
Global $g_GE_StuckCyclesUnrec = 0     
Global $g_GE_RescueEnabled    = True  
Global Const $GE_STUCK_THRESHOLD_EXPLORE_MS = 15000   
Global Const $GE_STUCK_THRESHOLD_OUTPOST_MS = 60000   
Global Const $GE_STUCK_MIN_MOVE     = 150     
Global Const $GE_STUCK_RESCUE_DIST  = 500     
Global Const $GE_STUCK_MAX_RESCUE   = 3       
Global Const $GE_STUCK_MAX_CYCLES   = 2       
Global $g_GE_TotalRescueCount = 0             
Global Const $GE_STUCK_MAX_TOTAL_RESCUES = 9  
Global $g_GE_LastPartyDefeated = False
Global $g_bUAIFightActive = False
Global $g_bResignMode = False
#EndRegion
Func _GE_GetQuestType($questId)
    Switch $questId
        Case 676, 677                        
            Return "COOP"
        Case 596, 600, 601, 649              
            Return "PRIMARY"
        Case 715, 716                        
            Return "RANK"
        Case 632, 633, 634                   
            Return "SECONDARY"
    EndSwitch
    Return "PRIMARY"
EndFunc
Func _GE_LogStateLabel($ls)
    Select
        Case $ls = -1 Or $ls = 0
            Return "none"
        Case $ls = 1
            Return "active"
        Case $ls = 32
            Return "primary"
        Case $ls = 33 Or $ls = 34 Or $ls = 35 Or $ls = 2 Or $ls = 3 Or $ls = 19 Or $ls = 79
            Return "can-reward(" & $ls & ")"
        Case Else
            Return "state=" & $ls
    EndSelect
EndFunc
Func _GE_DumpStorylineQuests($tag = "Dump")
    Local $knownIds[13]   = [596, 600, 601, 649, 676, 677, 715, 716, 632, 633, 634, 635, 0]
    Local $knownNames[13] = ["Prim.Train.prereq","PrimaryTraining","CompleteQuests","Sunspear pts", _
                              "M01 Chahbek","Tutorial","Rank:Master","Rank:FirstSpear", _
                              "Dunkoro","TravelCliffs","SignsPortents","IotD",""]
    Local $line = "[Quest " & $tag & "]"
    Local $allNone = True
    For $i = 0 To 11
        Local $qid = $knownIds[$i]
        Local $ls = Quest_GetQuestInfo($qid, "LogState")
        Local $lbl = _GE_LogStateLabel($ls)
        If $lbl <> "none" Then $allNone = False
        $line &= "  " & $qid & ":" & $lbl
    Next
    If $allNone Then $line = "[Quest " & $tag & "] all none"
    Static $s_lastTickLine = ""
    If $tag = "Tick" Then
        If $line = $s_lastTickLine Then Return
        $s_lastTickLine = $line
    EndIf
    Out($line)
EndFunc
Func _GE_MapTypeLabel($mt)
    Switch $mt
        Case 0
            Return "outpost"
        Case 1
            Return "explorable"
        Case 2
            Return "mission"
        Case Else
            Return "type=" & $mt
    EndSwitch
EndFunc
Func _GE_AllegianceLabel($all)
    Switch $all
        Case 1
            Return "TEAM"
        Case 3
            Return "FOE"
        Case 6
            Return "NPC"
        Case Else
            Return "?(" & $all & ")"
    EndSwitch
EndFunc
Func _GE_IsCompletedLogState($s)
    Switch $s
        Case 2, 3, 19, 32, 33, 34, 35, 79
            Return True
    EndSwitch
    Return False
EndFunc
Func GameEvents_Init()
    If $g_GE_Initialized Then Return
    If Map_GetMapID() <= 0 Then Return    
    $g_GE_LastCharLevel  = World_GetWorldInfo("Level")
    For $i = 1 To 8
        $g_GE_LastHeroLevel[$i] = Party_GetMyPartyHeroInfo($i, "Level")
        $g_GE_LastHeroID[$i]    = Party_GetMyPartyHeroInfo($i, "HeroID")
    Next
    $g_GE_LastMapID       = Map_GetMapID()
    $g_GE_LastMapType     = Map_GetCharacterInfo("CurrentMapType")
    $g_GE_LastActiveQuest = World_GetWorldInfo("ActiveQuestID")
    $g_GE_LastTargetAgent = Agent_GetCurrentTarget()
    $g_GE_LastTargetModel = ($g_GE_LastTargetAgent > 0) ? Agent_GetAgentInfo($g_GE_LastTargetAgent, "PlayerNumber") : 0
    _GE_RefreshQuestSnapshot()
    $g_GE_Initialized = True
    Out("[Event] init: charLv=" & $g_GE_LastCharLevel & " map=" & $g_GE_LastMapID & " (" & _GE_MapTypeLabel($g_GE_LastMapType) & ") quests=" & $g_GE_QuestCount)
    _GE_DumpStorylineQuests("Init")
    $g_GE_QuestDumpTimer = TimerInit()
    $g_GE_StateHbTimer = TimerInit()
    Local $unused = Attribute_GetPartyAttributePointInfo(0, "UnusedPoints")
    If Not @error And $unused > 0 Then
        Out("[Event] init: " & $unused & " puntos atributo libres -> notificar AutoLevel")
        AutoLevel_OnLevelUp($g_GE_LastCharLevel)
    EndIf
EndFunc
Func GameEvents_Tick()
    If Not $g_GE_Initialized Then
        GameEvents_Init()
        Return
    EndIf
    If Map_GetMapID() <= 0 Then
        If $g_GE_StateHbTimer > 0 And TimerDiff($g_GE_StateHbTimer) >= $GE_STATE_HB_MS Then
            _GE_StateHeartbeat()
            $g_GE_StateHbTimer = TimerInit()
        EndIf
        Return
    EndIf
    _GE_CheckCharLevel()
    _GE_CheckHeroLevels()
    _GE_CheckMap()
    _GE_CheckQuests()
    _GE_CheckActiveQuest()
    _GE_CheckTarget()
    _GE_CheckDialogSync()
    _GE_CheckCharDeath()
    _GE_ProcessDeathWalkback()
    _GE_CheckStuck()
    _GE_CheckPartyDefeated()
    If $g_GE_QuestDumpTimer > 0 And TimerDiff($g_GE_QuestDumpTimer) >= 30000 Then
        _GE_DumpStorylineQuests("Tick")
        $g_GE_QuestDumpTimer = TimerInit()
    EndIf
    If $g_GE_StateHbTimer > 0 And TimerDiff($g_GE_StateHbTimer) >= $GE_STATE_HB_MS Then
        _GE_StateHeartbeat()
        $g_GE_StateHbTimer = TimerInit()
    EndIf
EndFunc
Func _GE_StateHeartbeat()
    If Not $Bot_Core_Initialized Then Return
    Local $map = Map_GetMapID()
    Local $loading = Map_GetInstanceInfo("IsLoading")
    If $map <= 0 Or $loading Then
        Local $lbl = "loading"
        If $map <= 0 And Not $loading Then $lbl = "disconnected/crash?"
        Out("[State] " & $lbl & " map=" & $map)
        Return
    EndIf
    Local $mtype = Map_GetInstanceInfo("Type")
    Local $mtLbl = ""
    Switch $mtype
        Case 0
            $mtLbl = "outpost"
        Case 1
            $mtLbl = "expl"
        Case 2
            $mtLbl = "mission"
        Case Else
            $mtLbl = "t" & $mtype
    EndSwitch
    Local $x = Round(Agent_GetAgentInfo(-2, "X"), 0)
    Local $y = Round(Agent_GetAgentInfo(-2, "Y"), 0)
    Local $hpPct = Round(Agent_GetAgentInfo(-2, "HP") * 100, 0)
    Local $enAbs_ = Agent_GetAgentInfo(-2, "CurrentEnergy")
    Local $enMax_ = Agent_GetAgentInfo(-2, "MaxEnergy")
    Local $enPct = Round(($enMax_ > 0 ? ($enAbs_ / $enMax_) * 100 : 0), 0)
    Local $heroes = Party_GetMyPartyInfo("ArrayHeroPartyMemberSize")
    Local $hench  = Party_GetMyPartyInfo("ArrayHenchmanPartyMemberSize")
    Local $partyCur = 1 + $heroes + $hench
    Local $partyMax = Map_GetInstanceInfo("MaxPartySize")
    If $partyMax <= 0 Then $partyMax = $partyCur
    Local $q = World_GetWorldInfo("ActiveQuestID")
    Local $qStr = "-"
    If $q > 0 Then
        Local $ls = Quest_GetQuestInfo($q, "LogState")
        Local $cr = Quest_GetQuestInfo($q, "CanReward")
        Local $mt = Quest_GetQuestInfo($q, "MapTo")
        Local $mkx = Round(Quest_GetQuestInfo($q, "MarkerX"), 0)
        Local $mky = Round(Quest_GetQuestInfo($q, "MarkerY"), 0)
        $qStr = $q & " ls=" & $ls & " cr=" & $cr & " mt=" & $mt & " mark=(" & $mkx & "," & $mky & ")"
    EndIf
    Local $foes = _CountEnemies(1500)
    Static $s_aiX = -99999, $s_aiY = -99999, $s_aiTimer = 0
    If $mtype <> 0 And Not Agent_GetAgentInfo(-2, "IsDead") And Not $g_bAntiIdleTargetLock And Map_GetMapID() <> 490 Then
        If Abs($x - $s_aiX) > 60 Or Abs($y - $s_aiY) > 60 Then
            $s_aiX = $x
            $s_aiY = $y
            $s_aiTimer = TimerInit()
        ElseIf $s_aiTimer <> 0 And TimerDiff($s_aiTimer) > 25000 Then
            Local $aiE = GetNearestEnemy(2500)
            If $aiE <> 0 Then
                Local $bSierpeAI = BitAND(Agent_GetAgentInfo(-2, "TransmogNpcId"), 0x20000000) <> 0
                Local $aiX = Agent_GetAgentInfo($aiE, "X"), $aiY = Agent_GetAgentInfo($aiE, "Y")
                Local $cx = Agent_GetAgentInfo(-2, "X"), $cy = Agent_GetAgentInfo(-2, "Y")
                Local $aiDist = Agent_GetDistance(-2, $aiE)
                If $bSierpeAI And $aiDist > 1300 Then
                    $s_aiTimer = TimerInit()
                Else
                    If $aiX <> 0 And $cx <> 0 And Not $bSierpeAI Then
                        Local $dx = $aiX - $cx, $dy = $aiY - $cy
                        Local $dist = Sqrt($dx * $dx + $dy * $dy)
                        If $dist > 1 Then
                            Local $step = ($dist < 200) ? $dist : 200
                            Map_Move($cx + ($dx / $dist) * $step, $cy + ($dy / $dist) * $step, 0)
                            Sleep(300)
                        EndIf
                    EndIf
                    Out("[AntiIdle] pivot + ATACAR al mas cercano (dist=" & Round($aiDist) & "u" & ($bSierpeAI ? " sierpe-skill3" : "") & ")")
                    Agent_ChangeTarget($aiE)
                    Sleep(100)
                    Agent_CallTarget($aiE)
                    If $bSierpeAI Then
                        Skill_UseSkill(3)
                    Else
                        Agent_Attack($aiE, False)
                    EndIf
                    $s_aiTimer = TimerInit() 
                EndIf
            ElseIf TimerDiff($s_aiTimer) > 40000 Then
                Out("[AntiIdle] AVISO: quieto >40s sin enemigos (espera legitima o atasco de nav)")
                $s_aiTimer = TimerInit()
            EndIf
        EndIf
    Else
        $s_aiTimer = 0
        $s_aiX = -99999
    EndIf
    Local $npcStr = "-"
    Local $npc = GetNearestNPCToAgent(-2, 2500, $GC_I_AGENT_TYPE_LIVING, 1, "NPCFilter")
    If $npc > 0 Then
        Local $npcModel = Agent_GetAgentInfo($npc, "PlayerNumber")
        Local $npcX = Round(Agent_GetAgentInfo($npc, "X"), 0)
        Local $npcY = Round(Agent_GetAgentInfo($npc, "Y"), 0)
        $npcStr = $npcModel & "@(" & $npcX & "," & $npcY & ")d" & Round(Agent_GetDistance(-2, $npc), 0)
    EndIf
    Local $gadStr = "-"
    Local $gad = Gadget_FindNearest(2500)
    If $gad > 0 Then
        Local $gadX = Round(Agent_GetAgentInfo($gad, "X"), 0)
        Local $gadY = Round(Agent_GetAgentInfo($gad, "Y"), 0)
        $gadStr = Agent_GetAgentInfo($gad, "ID") & "@(" & $gadX & "," & $gadY & ")d" & Round(Agent_GetDistance(-2, $gad), 0)
    EndIf
    Local $tgtStr = "-"
    Local $tgt = Agent_GetAgentInfo(-1, "ID")
    If $tgt > 0 Then
        $tgtStr = Agent_GetAgentInfo($tgt, "PlayerNumber") & " " & _GE_AllegianceLabel(Agent_GetAgentInfo($tgt, "Allegiance")) & " d" & Round(Agent_GetDistance(-2, $tgt), 0)
    EndIf
    Local $tgtModel = ($tgt > 0) ? Agent_GetAgentInfo($tgt, "PlayerNumber") : 0
    Local $npcModel = ($npc > 0) ? Agent_GetAgentInfo($npc, "PlayerNumber") : 0
    Local $sig = $map & "|" & $mtype & "|" & $partyCur & "/" & $partyMax & "|" _
        & $q & "|" & ($q > 0 ? Quest_GetQuestInfo($q, "LogState") : 0) & "|" _
        & ($foes > 0) & "|" & $npcModel & "|" & $gad & "|" & $tgtModel
    Local $chg = ($sig <> $g_GE_LastStateSig) ? 1 : 0
    $g_GE_LastStateSig = $sig
    Static $s_lastQuietEmit = 0
    Static $s_lastHbX = -99999, $s_lastHbY = -99999
    Local $moved = (Abs($x - $s_lastHbX) > 50 Or Abs($y - $s_lastHbY) > 50)
    If $chg = 0 And Not $moved And $hpPct >= 100 And $foes = 0 Then
        If $s_lastQuietEmit <> 0 And TimerDiff($s_lastQuietEmit) < 60000 Then Return
        $s_lastQuietEmit = TimerInit()
        Out("[State] idle map=" & $map & "(" & $mtLbl & ") pos=(" & $x & "," & $y & ") party=" & $partyCur & "/" & $partyMax & " chg=0")
        Return
    EndIf
    If $chg = 0 Then
        If $s_lastQuietEmit <> 0 And TimerDiff($s_lastQuietEmit) < 60000 Then Return
    EndIf
    $s_lastQuietEmit = TimerInit()
    $s_lastHbX = $x
    $s_lastHbY = $y
    Out("[State] map=" & $map & "(" & $mtLbl & ")" _
        & " pos=(" & $x & "," & $y & ")" _
        & " hp=" & $hpPct & "% en=" & $enPct & "%" _
        & " party=" & $partyCur & "/" & $partyMax _
        & " quest=" & $qStr _
        & " foes=" & $foes _
        & " nearNPC=" & $npcStr _
        & " nearGadget=" & $gadStr _
        & " target=" & $tgtStr _
        & " chg=" & $chg)
EndFunc
Func _GE_CheckStuck()
    If $g_GE_LastCharIsDead Then Return
    If Int(IniRead(@ScriptDir & "\config.ini", "Debug", "DisableRescue", "0")) <> 0 Then Return
    If Not $g_GE_RescueEnabled Then Return   
    If Not $BotRunning Then Return           
    Local $x = Agent_GetAgentInfo(-2, "X")
    Local $y = Agent_GetAgentInfo(-2, "Y")
    If $x = 0 And $y = 0 Then Return    
    If $g_bUAIFightActive Then
        $g_GE_LastStuckX = $x
        $g_GE_LastStuckY = $y
        $g_GE_StuckTimer = TimerInit()   
        Return
    EndIf
    If Agent_GetCurrentTarget() > 0 Then
        $g_GE_LastStuckX = $x
        $g_GE_LastStuckY = $y
        $g_GE_StuckTimer = TimerInit()
        Return
    EndIf
    If Game_GetGameInfo("IsCinematic") Then
        $g_GE_LastStuckX = $x
        $g_GE_LastStuckY = $y
        $g_GE_StuckTimer = TimerInit()
        Return
    EndIf
    Local $threshold = $GE_STUCK_THRESHOLD_EXPLORE_MS
    If Map_GetInstanceInfo("Type") = 0 Then $threshold = $GE_STUCK_THRESHOLD_OUTPOST_MS
    If $g_GE_StuckTimer = 0 Then
        $g_GE_LastStuckX = $x
        $g_GE_LastStuckY = $y
        $g_GE_StuckTimer = TimerInit()
        $g_GE_StuckRescueCount = 0
        Return
    EndIf
    Local $dx = $x - $g_GE_LastStuckX
    Local $dy = $y - $g_GE_LastStuckY
    Local $moved = Sqrt($dx*$dx + $dy*$dy)
    If $moved >= $GE_STUCK_MIN_MOVE Then
        $g_GE_LastStuckX = $x
        $g_GE_LastStuckY = $y
        $g_GE_StuckTimer = TimerInit()
        $g_GE_StuckRescueCount = 0
        Return
    EndIf
    If TimerDiff($g_GE_StuckTimer) <= $threshold Then Return
    $g_GE_StuckRescueCount += 1
    If $g_GE_StuckRescueCount <= $GE_STUCK_MAX_RESCUE Then
        Local $rescueDirs[4][2] = [[0, $GE_STUCK_RESCUE_DIST], [$GE_STUCK_RESCUE_DIST, 0], _
                                    [0, -$GE_STUCK_RESCUE_DIST], [-$GE_STUCK_RESCUE_DIST, 0]]
        Local $idx = Mod($g_GE_StuckRescueCount - 1, 4)
        Local $rx = $x + $rescueDirs[$idx][0]
        Local $ry = $y + $rescueDirs[$idx][1]
        $g_GE_TotalRescueCount += 1
        Out("[Stuck] WARN char atascado " & Round(TimerDiff($g_GE_StuckTimer)/1000) & "s en (" & Round($x) & "," & Round($y) & ") -> rescue " & $g_GE_StuckRescueCount & "/" & $GE_STUCK_MAX_RESCUE & " total=" & $g_GE_TotalRescueCount & "/" & $GE_STUCK_MAX_TOTAL_RESCUES & " Map_Move(" & Round($rx) & "," & Round($ry) & ")")
        Map_Move($rx, $ry, 0)
        $g_GE_StuckTimer = TimerInit()    
        If $g_GE_TotalRescueCount >= $GE_STUCK_MAX_TOTAL_RESCUES Then
            Out("[Stuck] ABORT: " & $g_GE_TotalRescueCount & " rescues acumulados sin desencallar -> rescue OFF hasta reset de step")
            $g_GE_RescueEnabled = False
        EndIf
    Else
        $g_GE_StuckCyclesUnrec += 1
        Out("[Stuck] ERROR char atascado tras " & $GE_STUCK_MAX_RESCUE & " rescues fallidos en (" & Round($x) & "," & Round($y) & ") - DUMP (ciclo " & $g_GE_StuckCyclesUnrec & "/" & $GE_STUCK_MAX_CYCLES & ")")
        $g_GE_StuckTimer = TimerInit()
        $g_GE_StuckRescueCount = 0    
        If $g_GE_StuckCyclesUnrec >= $GE_STUCK_MAX_CYCLES Then
            Out("[Stuck] STOP rescue - " & $GE_STUCK_MAX_CYCLES & " ciclos sin desencallar. Reactivable con GameEvents_ResetStuck().")
            $g_GE_RescueEnabled = False
        EndIf
    EndIf
EndFunc
Func GameEvents_ResetStuck()
    $g_GE_LastStuckX        = 0
    $g_GE_LastStuckY        = 0
    $g_GE_StuckTimer        = 0
    $g_GE_StuckRescueCount  = 0
    $g_GE_StuckCyclesUnrec  = 0
    $g_GE_TotalRescueCount  = 0
EndFunc
Func GameEvents_EnableRescue()
    $g_GE_RescueEnabled = True
EndFunc
Global $g_GE_DefeatTime = 0       
Global $g_GE_DefeatMapId = 0      
Func _GE_CheckPartyDefeated()
    Local $def = Party_GetPartyContextInfo("IsDefeated")
    If $def And Not $g_GE_LastPartyDefeated Then
        If $g_bResignMode Then
            Out("[Party] Party defeated (resign intencional, no es error)")
        Else
            Out("[Party] ERROR Party DEFEATED en map=" & Map_GetMapID())
        EndIf
        $g_GE_LastPartyDefeated = True
        If Map_GetInstanceInfo("Type") = $GC_I_MAP_TYPE_EXPLORABLE Then
            $g_GE_DefeatTime = TimerInit()
            $g_GE_DefeatMapId = Map_GetMapID()
            If $g_GE_DefeatMapId = 435 Then
                Out("[Party] Defeat en M11 (map 435) -> ReturnToOutpost diferido (10s)")
            EndIf
        EndIf
    ElseIf Not $def And $g_GE_LastPartyDefeated Then
        Out("[Party] OK Party recovered tras defeated")
        $g_GE_LastPartyDefeated = False
    EndIf
    If $g_GE_DefeatTime <> 0 Then
        If Map_GetMapID() = 0 Or Map_GetInstanceInfo("Type") = $GC_I_MAP_TYPE_OUTPOST Then
            $g_GE_DefeatTime = 0
        ElseIf TimerDiff($g_GE_DefeatTime) >= 10000 Then
            If Party_GetPartyContextInfo("IsDefeated") Then
                Out("[Party] Defeat diferido: Map_ReturnToOutpost (map=" & Map_GetMapID() & ")")
                Map_ReturnToOutpost(False)
                Sleep(3000)
                If Party_GetPartyContextInfo("IsDefeated") And Map_GetMapID() <> 0 Then
                    Out("[Party] ReturnToOutpost no respondió -> retry #1")
                    Map_ReturnToOutpost(True)
                    Sleep(5000)
                    If Party_GetPartyContextInfo("IsDefeated") And Map_GetMapID() <> 0 Then
                        Out("[Party] ReturnToOutpost retry falló -> Map_TravelTo a outpost actual de nuevo")
                        Map_ReturnToOutpost(False)
                        Sleep(5000)
                    EndIf
                EndIf
                $g_GE_DefeatTime = 0
            EndIf
        EndIf
    EndIf
EndFunc
Func _GE_CheckCharDeath()
    Local $isDead = _Char_IsReallyDead()   
    If $isDead = True And $g_GE_LastCharIsDead = False Then
        $g_GE_DeathCount += 1
        $g_GE_DeathPosX = Agent_GetAgentInfo(-2, "X")
        $g_GE_DeathPosY = Agent_GetAgentInfo(-2, "Y")
        $g_GE_DeathMapID = Map_GetMapID()
        If $g_bResignMode Then
            Out("[Combat] Char dead (resign intencional #" & $g_GE_DeathCount & ", no es error)")
        Else
            Out("[Combat] ERROR Char DEATH #" & $g_GE_DeathCount & " en map=" & $g_GE_DeathMapID & " pos=(" & Round($g_GE_DeathPosX) & "," & Round($g_GE_DeathPosY) & ")")
        EndIf
        $g_GE_LastCharIsDead = True
    ElseIf $isDead = False And $g_GE_LastCharIsDead = True Then
        Out("[Combat] OK Char revived tras death #" & $g_GE_DeathCount)
        $g_GE_LastCharIsDead = False
        $g_GE_StuckTimer = 0    
        $g_GE_NeedsWalkback = False
    EndIf
EndFunc
Func _GE_ProcessDeathWalkback()
    If Not $g_GE_NeedsWalkback Then Return
    If Not $g_GE_RescueEnabled Then
        $g_GE_NeedsWalkback = False
        Return
    EndIf
    If TimerDiff($g_GE_RevivedAt) < 3000 Then Return
    If Agent_GetAgentInfo(-2, "IsDead") = True Then Return
    If BitAND(Agent_GetAgentInfo(-2, "TransmogNpcId"), 0x20000000) <> 0 Then
        Out("[Combat] Walkback cancelado: char en SIERPE (la fase navega al marcador; sin holds)")
        $g_GE_NeedsWalkback = False
        Return
    EndIf
    If Map_GetMapID() <> $g_GE_DeathMapID Then
        Out("[Combat] Walkback cancelado: char en map distinto (" & Map_GetMapID() & " vs " & $g_GE_DeathMapID & ")")
        $g_GE_NeedsWalkback = False
        Return
    EndIf
    If Map_GetInstanceInfo("Type") = $GC_I_MAP_TYPE_OUTPOST Then
        Out("[Combat] Walkback cancelado: char en OUTPOST (no se camina a la pos de muerte en ciudad)")
        $g_GE_NeedsWalkback = False
        Return
    EndIf
    Local $activeQuest = World_GetWorldInfo("ActiveQuestID")
    Local $targetX = 0
    Local $targetY = 0
    Local $targetSrc = "death_pos"
    If $activeQuest > 0 Then
        $targetX = Quest_GetQuestInfo($activeQuest, "MarkerX")
        $targetY = Quest_GetQuestInfo($activeQuest, "MarkerY")
        If $targetX <> 0 Or $targetY <> 0 Then
            $targetSrc = "quest_" & $activeQuest & "_marker"
        EndIf
    EndIf
    If $targetX = 0 And $targetY = 0 Then
        $targetX = $g_GE_DeathPosX
        $targetY = $g_GE_DeathPosY
    EndIf
    Local $cx = Agent_GetAgentInfo(-2, "X")
    Local $cy = Agent_GetAgentInfo(-2, "Y")
    Local $dist = Sqrt(($cx - $targetX)^2 + ($cy - $targetY)^2)
    Local $nearEnemy = Combat_AnyEnemyNear(1500)
    If $nearEnemy <> 0 Then
        If Not $g_GE_WalkbackStarted Then
            Out("[Combat] Walkback HOLD: enemies <1500u post-revive - limpiando zona antes de moverse")
            $g_GE_WalkbackStarted = True
        EndIf
        Agent_ChangeTarget($nearEnemy)
        Agent_CallTarget($nearEnemy)
        Agent_Attack($nearEnemy, False)
        $g_bUAIFightActive = True
        Combat_CastNextReady($nearEnemy)
        $g_bUAIFightActive = False
        Return
    EndIf
    If $dist < 700 Then
        Out("[Combat] Walkback skip: char ya cerca del objetivo (" & Round($dist) & "u, src=" & $targetSrc & ")")
        $g_GE_NeedsWalkback = False
        Return
    EndIf
    Local $walkbackMaxDist = 8000
    If Map_GetInstanceInfo("Type") <> 0 Then $walkbackMaxDist = 50000   
    If $dist > $walkbackMaxDist Then
        Out("[Combat] Walkback cancelado: dist=" & Round($dist) & "u > " & $walkbackMaxDist & "u. Reinicia la fase.")
        $g_GE_NeedsWalkback = False
        Return
    EndIf
    Local $myHp = Agent_GetAgentInfo(-2, "HP")
    If $myHp > 0 And $myHp < 0.60 Then
        Static $s_lastHoldHp = -1
        Local $hpPctNow = Round($myHp * 100)
        Local $emit = ($g_GE_WalkbackReemitTimer = 0) _
            Or (TimerDiff($g_GE_WalkbackReemitTimer) > 15000) _
            Or (Abs($hpPctNow - $s_lastHoldHp) >= 5)
        If $emit Then
            Out("[Combat] Walkback HOLD HP=" & $hpPctNow & "% < 60% - recuperando")
            $g_GE_WalkbackReemitTimer = TimerInit()
            $s_lastHoldHp = $hpPctNow
        EndIf
        Return
    EndIf
    If Not $g_GE_WalkbackStarted Or TimerDiff($g_GE_WalkbackReemitTimer) > 2000 Then
        If Not $g_GE_WalkbackStarted Then
            Out("[Combat] Walkback START: dist=" & Round($dist) & "u -> (" & Round($targetX) & "," & Round($targetY) & ") src=" & $targetSrc)
            _ResetStuckBaseline()
            $g_GE_WalkbackStarted    = True
            $g_GE_WalkbackTimeoutTimer = TimerInit()   
        EndIf
        If TimerDiff($g_GE_WalkbackTimeoutTimer) > 120000 Then
            Out("[Combat] Walkback TIMEOUT (120s) dist=" & Round($dist) & "u -> cancelado. El bot retomara nav desde pos actual.")
            $g_GE_NeedsWalkback = False
            Return
        EndIf
        Map_Move($targetX, $targetY, 0)
        $g_GE_WalkbackReemitTimer = TimerInit()
    EndIf
EndFunc
Func GameEvents_OnDialogSent($dialogCode)
    Local $target = Agent_GetCurrentTarget()
    Local $model  = ($target > 0) ? Agent_GetAgentInfo($target, "PlayerNumber") : 0
    Out("[Dialog] Sent 0x" & Hex($dialogCode, 6) & " -> Agent=" & $target & " Model=" & $model)
    $g_GE_LastDialogCode   = $dialogCode
    $g_GE_LastDialogTimer  = TimerInit()
    $g_GE_LastDialogQuestId    = World_GetWorldInfo("ActiveQuestID")
    $g_GE_LastDialogQuestState = ($g_GE_LastDialogQuestId > 0) ? Quest_GetQuestInfo($g_GE_LastDialogQuestId, "LogState") : -1
EndFunc
Func _GE_CheckCharLevel()
    Local $lv = World_GetWorldInfo("Level")
    If $lv > 0 And $lv <> $g_GE_LastCharLevel Then
        Out("[Level] Char " & $g_GE_LastCharLevel & " -> " & $lv)
        If $lv > $g_GE_LastCharLevel Then
            AutoLevel_OnLevelUp($lv)
            If Map_GetInstanceInfo("Type") = $GC_I_MAP_TYPE_OUTPOST Then
                Sleep(500)
                _AutoLevel_ProcessChar()
            EndIf
        EndIf
        $g_GE_LastCharLevel = $lv
    EndIf
EndFunc
Func _GE_CheckHeroLevels()
    For $i = 1 To 8
        Local $hid = Party_GetMyPartyHeroInfo($i, "HeroID")
        Local $lv  = Party_GetMyPartyHeroInfo($i, "Level")
        If $hid <> $g_GE_LastHeroID[$i] Then
            $g_GE_LastHeroID[$i]    = $hid
            $g_GE_LastHeroLevel[$i] = $lv
            ContinueLoop
        EndIf
        If $lv > 0 And $lv <> $g_GE_LastHeroLevel[$i] Then
            Out("[Level] Hero slot=" & $i & " HeroID=" & $hid & " " & $g_GE_LastHeroLevel[$i] & " -> " & $lv)
            $g_GE_LastHeroLevel[$i] = $lv
        EndIf
    Next
EndFunc
Func _GE_CheckMap()
    Local $mid   = Map_GetMapID()
    Local $mtype = Map_GetCharacterInfo("CurrentMapType")
    If $mid > 0 And $mid <> $g_GE_LastMapID Then
        Out("[Map] Enter " & $mid & " (" & _GE_MapTypeLabel($mtype) & ")")
        $g_GE_LastMapID   = $mid
        $g_GE_LastMapType = $mtype
        $g_bPostTravelQuietUntil = TimerInit()
        _GE_RefreshQuestSnapshotSilent()
        $g_NE_CachePtr = 0
        $g_NE_CacheTimer = 0
        PartyRecovery_Reset()
        If Map_GetInstanceInfo("Type") = $GC_I_MAP_TYPE_OUTPOST And $g_bAutoLevelCharPending Then
            Sleep(1500)
            _AutoLevel_ProcessChar()
        EndIf
    EndIf
EndFunc
Func _GE_CheckActiveQuest()
    Local $aq = World_GetWorldInfo("ActiveQuestID")
    If $aq = $g_GE_LastActiveQuest Then Return
    If $aq > 0 Then
        Local $name = Quest_GetQuestInfo($aq, "Name")
        Out("[Quest] " & _GE_GetQuestType($aq) & " active-switch: " & $aq & " '" & $name & "'")
    EndIf
    $g_GE_LastActiveQuest = $aq
EndFunc
Func _GE_CheckTarget()
    Local $t = Agent_GetCurrentTarget()
    If $t = $g_GE_LastTargetAgent Then Return
    If $g_GE_TargetCooldown > 0 And TimerDiff($g_GE_TargetCooldown) < 1000 Then
        Return
    EndIf
    If $t = 0 Then
        $g_GE_LastTargetAgent = 0
        $g_GE_LastTargetModel = 0
        Return
    EndIf
    Local $all = Agent_GetAgentInfo($t, "Allegiance")
    If $all <> 1 And $all <> 6 Then
        $g_GE_LastTargetAgent = $t
        Return
    EndIf
    Local $model = Agent_GetAgentInfo($t, "PlayerNumber")
    Local $x     = Agent_GetAgentInfo($t, "X")
    Local $y     = Agent_GetAgentInfo($t, "Y")
    Out("[Target] Agent=" & $t & " Model=" & $model & " " & _GE_AllegianceLabel($all) & " Pos=(" & Round($x) & "," & Round($y) & ")")
    $g_GE_LastTargetAgent = $t
    $g_GE_LastTargetModel = $model
    $g_GE_TargetCooldown  = TimerInit()
EndFunc
Func _GE_CheckQuests()
    Local $size = World_GetWorldInfo("QuestLogSize")
    If $size <= 0 Then Return
    Local $newStates[$size + 1][2]
    Local $newCount = 0
    For $i = 0 To $size - 1
        Local $qid = _GetQuestIDByIndex($i)
        If $qid = 0 Then ContinueLoop
        $newStates[$newCount][0] = $qid
        $newStates[$newCount][1] = Quest_GetQuestInfo($qid, "LogState")
        $newCount += 1
    Next
    For $k = 0 To $newCount - 1
        Local $qid       = $newStates[$k][0]
        Local $logState  = $newStates[$k][1]
        Local $oldState  = -1
        For $j = 0 To $g_GE_QuestCount - 1
            If $g_GE_QuestStates[$j][0] = $qid Then
                $oldState = $g_GE_QuestStates[$j][1]
                ExitLoop
            EndIf
        Next
        If $oldState = -1 Then
            If $logState > 0 Then
                Local $name = Quest_GetQuestInfo($qid, "Name")
                Out("[Quest] " & _GE_GetQuestType($qid) & " accepted: " & $qid & " '" & $name & "' LogState=" & $logState)
            EndIf
        ElseIf $oldState <> $logState Then
            Local $name      = Quest_GetQuestInfo($qid, "Name")
            Local $wasDone   = _GE_IsCompletedLogState($oldState)
            Local $isDone    = _GE_IsCompletedLogState($logState)
            If Not $wasDone And $isDone Then
                Out("[Quest] " & _GE_GetQuestType($qid) & " can-reward: " & $qid & " '" & $name & "' (LogState " & $oldState & "->" & $logState & ")")
            Else
                Out("[Quest] " & _GE_GetQuestType($qid) & " state-change: " & $qid & " '" & $name & "' " & $oldState & " -> " & $logState)
            EndIf
        EndIf
    Next
    For $j = 0 To $g_GE_QuestCount - 1
        Local $oldId = $g_GE_QuestStates[$j][0]
        Local $stillPresent = False
        For $k = 0 To $newCount - 1
            If $newStates[$k][0] = $oldId Then
                $stillPresent = True
                ExitLoop
            EndIf
        Next
        If Not $stillPresent Then
            Out("[Quest] " & _GE_GetQuestType($oldId) & " removed (rewarded/abandoned): " & $oldId)
            If $oldId = 715 Then $g_GE_Quest715Removed = True
            If $oldId = 644 Then $g_GE_Quest644Removed = True
        EndIf
    Next
    ReDim $g_GE_QuestStates[$newCount + 1][2]
    For $i = 0 To $newCount - 1
        $g_GE_QuestStates[$i][0] = $newStates[$i][0]
        $g_GE_QuestStates[$i][1] = $newStates[$i][1]
    Next
    $g_GE_QuestCount = $newCount
EndFunc
Func _GE_RefreshQuestSnapshotSilent()
    _GE_RefreshQuestSnapshot()
EndFunc
Func _GE_RefreshQuestSnapshot()
    Local $size = World_GetWorldInfo("QuestLogSize")
    If $size <= 0 Then
        $g_GE_QuestCount = 0
        Return
    EndIf
    ReDim $g_GE_QuestStates[$size + 1][2]
    Local $cnt = 0
    For $i = 0 To $size - 1
        Local $qid = _GetQuestIDByIndex($i)
        If $qid = 0 Then ContinueLoop
        $g_GE_QuestStates[$cnt][0] = $qid
        $g_GE_QuestStates[$cnt][1] = Quest_GetQuestInfo($qid, "LogState")
        $cnt += 1
    Next
    $g_GE_QuestCount = $cnt
EndFunc
Func _GE_CheckDialogSync()
    If $g_GE_LastDialogTimer = 0 Then Return
    If TimerDiff($g_GE_LastDialogTimer) < 3000 Then Return
    If $g_GE_LastDialogQuestId > 0 And $g_GE_LastDialogQuestState >= 0 Then
        Local $now = Quest_GetQuestInfo($g_GE_LastDialogQuestId, "LogState")
        If $now = $g_GE_LastDialogQuestState Then
            Out("[Sync] WARN dialog 0x" & Hex($g_GE_LastDialogCode, 6) & " enviado pero quest " & $g_GE_LastDialogQuestId & " LogState sin cambio (" & $now & ")")
        EndIf
    EndIf
    $g_GE_LastDialogTimer = 0
EndFunc