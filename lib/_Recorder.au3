#include-once
Global $g_bRecording = False
Global $g_recFile = ""
Global $g_recTickTimer = 0
Global $g_recGadgetTimer = 0
Global $g_recLastMap = -1
Global $g_recLastType = -1
Global $g_recLastTarget = -1
Global $g_recLastTargetType = -1
Global $g_recLastX = 0
Global $g_recLastY = 0
Global $g_recLastQuest = -1
Global $g_recLastLevel = -1
Global $g_recLastXp = -1
Global $g_recLastHp = 1.0
Global $g_recLastCinematic = False
Global $g_recGadgetsSeen[0]   
Global Const $REC_TICK_MS = 1000        
Global Const $REC_MIN_MOVE = 200        
Global Const $REC_XP_DELTA = 500        
Global Const $REC_GADGET_MS = 5000      
Global Const $REC_SNAPSHOT_MS = 5000    
Global Const $REC_GOLD_DELTA = 50       
Global $g_recSnapshotTimer = 0
Global $g_recLastGold = -1
Global $g_recSkillLearned[3435]   
Func _RecorderStart()
    Local $dir = @ScriptDir & "\recordings"
    If Not FileExists($dir) Then DirCreate($dir)
    Local $ts = StringFormat("%04d%02d%02d_%02d%02d%02d", _
            @YEAR, @MON, @MDAY, @HOUR, @MIN, @SEC)
    $g_recFile = $dir & "\session_" & $ts & ".jsonl"
    $g_bRecording = True
    $g_recTickTimer = TimerInit()
    $g_recGadgetTimer = TimerInit()
    $g_recSnapshotTimer = TimerInit()
    $g_recLastGold = -1
    For $recInitI = 0 To UBound($g_recSkillLearned) - 1
        $g_recSkillLearned[$recInitI] = ""
    Next
    Local $emptyArr[0]
    $g_recGadgetsSeen = $emptyArr   
    $g_recLastMap = -1
    $g_recLastType = -1
    $g_recLastTarget = -1
    $g_recLastTargetType = -1
    $g_recLastX = 0
    $g_recLastY = 0
    $g_recLastQuest = -1
    $g_recLastLevel = -1
    $g_recLastXp = -1
    $g_recLastHp = 1.0
    $g_recLastCinematic = False
    _RecLog("start", "file=" & $g_recFile)
    GUICtrlSetData($btnRecord, "■ Stop Rec")
    GUICtrlSetColor($btnRecord, 0x2E9E4F)
    Ui_SetStatus("Grabando sesión en " & $g_recFile)
    Out("[Recorder] Started: " & $g_recFile)
EndFunc
Func _RecorderStop()
    If Not $g_bRecording Then Return
    _RecLog("stop", "")
    $g_bRecording = False
    GUICtrlSetData($btnRecord, "● Record")
    GUICtrlSetColor($btnRecord, 0xC62828)
    Ui_SetStatus("Grabación detenida: " & $g_recFile)
    Out("[Recorder] Stopped. File: " & $g_recFile)
EndFunc
Func _RecorderTick()
    If Not $g_bRecording Then Return
    Local $curMap = Map_GetMapID()
    Local $curType = Map_GetInstanceInfo("Type")
    If $curMap <> $g_recLastMap Or $curType <> $g_recLastType Then
        _RecLog("map", "id=" & $curMap & " type=" & $curType & " name=" & Map_GetAreaInfo($curMap, "Name"))
        $g_recLastMap = $curMap
        $g_recLastType = $curType
    EndIf
    Local $tgt = Agent_GetAgentInfo(-1, "ID")
    If $tgt <> $g_recLastTarget And $tgt <> 0 Then
        Local $tgtModel = Agent_GetAgentInfo($tgt, "PlayerNumber")
        Local $tgtX = Agent_GetAgentInfo($tgt, "X")
        Local $tgtY = Agent_GetAgentInfo($tgt, "Y")
        Local $tgtAlleg = Agent_GetAgentInfo($tgt, "Allegiance")
        Local $tgtType = Agent_GetAgentInfo($tgt, "Type")
        Local $tgtKind = _RecClassifyTarget($tgtAlleg, $tgtType)
        _RecLog("target", "id=" & $tgt & " kind=" & $tgtKind & " model=" & $tgtModel & " pos=(" & Round($tgtX, 0) & "," & Round($tgtY, 0) & ") alleg=" & $tgtAlleg & " type=" & $tgtType)
        $g_recLastTarget = $tgt
    EndIf
    Local $curQuest = World_GetWorldInfo("ActiveQuestID")
    If $curQuest <> $g_recLastQuest Then
        _RecLog("active_quest", "id=" & $curQuest & " hex=0x" & Hex($curQuest, 4))
        $g_recLastQuest = $curQuest
    EndIf
    Local $curLevel = Agent_GetAgentInfo(-2, "Level")
    If $curLevel <> $g_recLastLevel And $curLevel > 0 Then
        _RecLog("level", "lvl=" & $curLevel)
        $g_recLastLevel = $curLevel
    EndIf
    Local $inCine = Game_GetGameInfo("IsCinematic")
    If $inCine <> $g_recLastCinematic Then
        _RecLog("cinematic", $inCine ? "start" : "end")
        $g_recLastCinematic = $inCine
    EndIf
    Local $hp = Agent_GetAgentInfo(-2, "HP")
    Local $maxHp = Agent_GetAgentInfo(-2, "MaxHP")
    If $maxHp > 0 And Not Map_GetInstanceInfo("IsLoading") Then
        If $hp < 0.5 And $g_recLastHp >= 0.5 Then
            _RecLog("danger", "hp=" & Round($hp*100, 0) & "% (bajó <50%)")
        EndIf
        $g_recLastHp = $hp
    EndIf
    If TimerDiff($g_recTickTimer) >= $REC_TICK_MS Then
        $g_recTickTimer = TimerInit()
        Local $myX = Agent_GetAgentInfo(-2, "X")
        Local $myY = Agent_GetAgentInfo(-2, "Y")
        Local $dx = $myX - $g_recLastX
        Local $dy = $myY - $g_recLastY
        Local $dist = Sqrt($dx * $dx + $dy * $dy)
        If $dist > $REC_MIN_MOVE Or $g_recLastX = 0 Then
            _RecLog("tick", "pos=(" & Round($myX, 0) & "," & Round($myY, 0) & ") hp=" & Round($hp*100, 0))
            $g_recLastX = $myX
            $g_recLastY = $myY
        EndIf
        Local $curXp = World_GetWorldInfo("Experience")
        If $g_recLastXp = -1 Then
            $g_recLastXp = $curXp
        ElseIf $curXp - $g_recLastXp >= $REC_XP_DELTA Then
            _RecLog("xp", "total=" & $curXp & " delta=+" & ($curXp - $g_recLastXp))
            $g_recLastXp = $curXp
        EndIf
    EndIf
    If TimerDiff($g_recGadgetTimer) >= $REC_GADGET_MS Then
        $g_recGadgetTimer = TimerInit()
        _RecScanGadgets()
    EndIf
    If TimerDiff($g_recSnapshotTimer) >= $REC_SNAPSHOT_MS Then
        $g_recSnapshotTimer = TimerInit()
        _RecSnapshot()
    EndIf
    Local $gold = Item_GetInventoryInfo("GoldCharacter")
    If Not @error And $gold >= 0 Then
        If $g_recLastGold = -1 Then
            _RecLog("gold_init", "gold=" & $gold)
            $g_recLastGold = $gold
        ElseIf Abs($gold - $g_recLastGold) >= $REC_GOLD_DELTA Then
            Local $delta = $gold - $g_recLastGold
            _RecLog("gold", "gold=" & $gold & " delta=" & ($delta >= 0 ? "+" : "") & $delta)
            $g_recLastGold = $gold
        EndIf
    EndIf
    Local $recSkills[3] = [1763, 1816, 321]   
    For $rs = 0 To UBound($recSkills) - 1
        Local $recLearned = (World_IsSkillLearnt($recSkills[$rs]) ? 1 : 0)
        If $g_recSkillLearned[$recSkills[$rs]] <> $recLearned Then
            If $g_recSkillLearned[$recSkills[$rs]] <> "" Then
                _RecLog("skill_learn", "id=" & $recSkills[$rs] & " aprendida=" & ($recLearned ? "SI" : "NO"))
            EndIf
            $g_recSkillLearned[$recSkills[$rs]] = $recLearned
        EndIf
    Next
EndFunc
Func _RecSnapshot()
    Local $cname = Agent_GetAgentInfo(-2, "Name")
    Local $level = Agent_GetAgentInfo(-2, "Level")
    Local $hp = Round(Agent_GetAgentInfo(-2, "CurrentHP"))
    Local $maxhp = Agent_GetAgentInfo(-2, "MaxHP")
    Local $en = Round(Agent_GetAgentInfo(-2, "CurrentEnergy"))
    Local $maxen = Agent_GetAgentInfo(-2, "MaxEnergy")
    Local $xp = World_GetWorldInfo("Experience")
    Local $sunspear = Sunspear_GetPoints()
    Local $myX = Agent_GetAgentInfo(-2, "X")
    Local $myY = Agent_GetAgentInfo(-2, "Y")
    Local $map = Map_GetMapID()
    Local $partySize = 1 + Party_GetMyPartyInfo("ArrayHeroPartyMemberSize") + Party_GetMyPartyInfo("ArrayHenchmanPartyMemberSize")
    _RecLog("snapshot", _
        "name=" & $cname _
        & " lvl=" & $level _
        & " hp=" & $hp & "/" & $maxhp _
        & " en=" & $en & "/" & $maxen _
        & " xp=" & $xp _
        & " sunspear=" & $sunspear _
        & " pos=(" & Round($myX, 0) & "," & Round($myY, 0) & ")" _
        & " map=" & $map _
        & " party=" & $partySize)
EndFunc
Func _RecScanGadgets()
    Local $agents = Agent_GetAgentArray($GC_I_AGENT_TYPE_GADGET)
    If Not IsArray($agents) Or $agents[0] = 0 Then Return
    For $i = 1 To $agents[0]
        Local $ptr = $agents[$i]
        If $ptr = 0 Then ContinueLoop
        Local $id = Agent_GetAgentInfo($ptr, "ID")
        Local $seen = False
        For $s = 0 To UBound($g_recGadgetsSeen) - 1
            If $g_recGadgetsSeen[$s] = $id Then
                $seen = True
                ExitLoop
            EndIf
        Next
        If $seen Then ContinueLoop
        Local $model = Agent_GetAgentInfo($ptr, "PlayerNumber")
        Local $aX = Agent_GetAgentInfo($ptr, "X")
        Local $aY = Agent_GetAgentInfo($ptr, "Y")
        _RecLog("gadget", "id=" & $id & " model=" & $model & " pos=(" & Round($aX, 0) & "," & Round($aY, 0) & ")")
        ReDim $g_recGadgetsSeen[UBound($g_recGadgetsSeen) + 1]
        $g_recGadgetsSeen[UBound($g_recGadgetsSeen) - 1] = $id
    Next
EndFunc
Func _RecClassifyTarget($alleg, $type)
    If $type = $GC_I_AGENT_TYPE_GADGET Then Return "GADGET"   
    Switch $alleg
        Case $GC_I_ALLEGIANCE_ALLY      
            Return "ALLY"
        Case $GC_I_ALLEGIANCE_ANIMAL    
            Return "ANIMAL"
        Case $GC_I_ALLEGIANCE_ENEMY     
            Return "ENEMY"
        Case $GC_I_ALLEGIANCE_SPIRIT    
            Return "SPIRIT"
        Case $GC_I_ALLEGIANCE_MINION    
            Return "MINION"
        Case $GC_I_ALLEGIANCE_NPC       
            Return "NPC"
        Case Else
            Return "?"
    EndSwitch
EndFunc
Func _RecLog($type, $data)
    If $g_recFile = "" Then Return
    Local $ts = StringFormat("%02d:%02d:%02d.%03d", @HOUR, @MIN, @SEC, @MSEC)
    FileWriteLine($g_recFile, $ts & " " & $type & " " & $data)
    Out("[Recorder] " & $type & " " & $data)
EndFunc