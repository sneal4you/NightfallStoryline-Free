#include-once
Global $g_CS_LastCastTimer  = 0
Global Const $CS_CAST_COOLDOWN_MS = 1500   
Global $g_CS_LastSlot = 0
Global $g_CS_HealSlot       = 0            
Global $g_CS_HealThreshold  = 50           
Func Combat_SetHealSlot($slot, $hpThreshold = 50)
    $g_CS_HealSlot = $slot
    $g_CS_HealThreshold = $hpThreshold
EndFunc
Global $g_CS_ExcludedSlots[2] = [0, 8]
Global $g_CS_ExcludedSkillIDs = ""
Global $g_CS_Slot5MaxHP = 100
Func Combat_SetExcludedSlots($aSlots)
    $g_CS_ExcludedSlots = $aSlots
EndFunc
Func Combat_SetExcludedSkillIDs($csvIDs)
    $g_CS_ExcludedSkillIDs = $csvIDs
EndFunc
Func Combat_CastNextReady($target = 0)
    Local $dbgCd = "last=0"
    If $g_CS_LastCastTimer <> 0 Then $dbgCd = "last=" & Round(TimerDiff($g_CS_LastCastTimer)) & "ms cd=" & $CS_CAST_COOLDOWN_MS & "ms"
    Local $dbgTgt = "?"
    If $target > 0 Then
        Local $tfoe = _CountEnemies(1500)
        $dbgTgt = "foe=" & $tfoe & " hp=" & Round(Agent_GetAgentInfo($target, "HP") * 100) & "%"
    EndIf
    Out("[Combat-Skills] ENTRADA target=" & $target & " " & $dbgTgt & " " & $dbgCd)
    If $g_CS_LastCastTimer <> 0 And TimerDiff($g_CS_LastCastTimer) < $CS_CAST_COOLDOWN_MS Then
        Return 0  
    EndIf
    If $g_CS_HealSlot > 0 Then
        Local $hp = Agent_GetAgentInfo(-2, "HP") * 100
        If $hp < $g_CS_HealThreshold And Skill_GetSkillbarInfo($g_CS_HealSlot, "Recharge") = 0 Then
            Out("[Combat-Skills] Cast HEAL slot " & $g_CS_HealSlot & " (HP=" & Round($hp) & "%)")
            Skill_UseSkill($g_CS_HealSlot, -2, False)
            $g_CS_LastCastTimer = TimerInit()
            Return $g_CS_HealSlot
        EndIf
    EndIf
    If $target = 0 Then $target = Agent_GetCurrentTarget()
    If $target = 0 Then
        Out("[Combat-Skills] skip: target=0 y sin current")
        Return 0
    EndIf
    Local $enemyState = ""
    Local $tPN = Agent_GetAgentInfo($target, "PlayerNumber")
    Local $tHPCk = Agent_GetAgentInfo($target, "HP")
    If $tPN <= 0 Or $tHPCk <= 0 Then
        $enemyState = "invalid(pn=" & $tPN & " hp=" & Round($tHPCk, 2) & ")"
        $target = GetNearestEnemy(1300)
        If $target = 0 Then
            Out("[Combat-Skills] skip: ghost target y sin re-find")
            Return 0
        EndIf
    EndIf
    If Agent_GetAgentInfo($target, "HP") <= 0 Then
        $enemyState &= " dead" 
        $target = GetNearestEnemy(1300)
        If $target = 0 Then
            Out("[Combat-Skills] skip: target muerto y sin re-find")
            Return 0
        EndIf
    EndIf
    If Agent_GetCurrentTarget() <> $target Then Agent_ChangeTarget($target)
    Local Const $CS_CRITICAL_ENERGY_PCT = 10
    Local $curEnAbs = Agent_GetAgentInfo(-2, "CurrentEnergy")
    Local $curEnMax = Agent_GetAgentInfo(-2, "MaxEnergy")
    Local $curEn = ($curEnMax > 0) ? ($curEnAbs / $curEnMax) * 100 : 100.0
    Local $energyCrit = ($curEn < $CS_CRITICAL_ENERGY_PCT)
    Local $dbgGate = ""
    If $energyCrit Then $dbgGate = "ENERGIA=" & Round($curEn, 1) & "%>crit " 
    Local $isSierpe = (BitAND(Agent_GetAgentInfo(-2, "TransmogNpcId"), 0x20000000) <> 0)
    Local $startSlot = Mod($g_CS_LastSlot, 8) + 1
    Local $dbgStates = ""
    For $i = 0 To 7
        Local $slot = Mod($startSlot - 1 + $i, 8) + 1
        If $slot = $g_CS_HealSlot Then ContinueLoop
        If $isSierpe And $slot > 4 Then ContinueLoop
        If _CS_IsSlotExcluded($slot) Then ContinueLoop
        If $slot = 5 And $g_CS_Slot5MaxHP < 100 And Agent_GetAgentInfo(-2, "HP") * 100 > $g_CS_Slot5MaxHP Then ContinueLoop
        $dbgStates &= $slot & "=rch" & (Skill_GetSkillbarInfo($slot, "IsRecharged") ? "Y" : "N") & " "
        If Not Skill_GetSkillbarInfo($slot, "IsRecharged") Then ContinueLoop
        Local $sid = Skill_GetSkillbarInfo($slot, "SkillID")
        If $sid <= 0 Then ContinueLoop
        If $g_CS_ExcludedSkillIDs <> "" And StringInStr("," & $g_CS_ExcludedSkillIDs & ",", "," & $sid & ",") Then ContinueLoop
        If $energyCrit And $sid <> $GC_I_SKILL_ID_ZEALOUS_RENEWAL Then
            If $sid > 0 Then
                $dbgGate &= $slot & "(id" & $sid & ")_skip "
                ContinueLoop
            EndIf
        EndIf
        Out("[Combat-Skills] Cast slot " & $slot & " (ID=" & $sid & ") on target=" & $target)
        Skill_UseSkill($slot, $target, False)
        $g_CS_LastCastTimer = TimerInit()
        $g_CS_LastSlot = $slot
        Return $slot
    Next
    Out("[Combat-Skills] slots: [" & $dbgStates & "] excl=[" & _CS_ExcludedStr() & "] " & $dbgGate)
    Return 0
EndFunc
Func Combat_CastPrioritized($target = 0, $opts = Null)
    If $g_CS_LastCastTimer <> 0 And TimerDiff($g_CS_LastCastTimer) < $CS_CAST_COOLDOWN_MS Then
        Return 0
    EndIf
    Local $healSlot = 0, $hpThresh = 50
    Local $attackSlots = "all"
    If IsObj($opts) Then
        If $opts.Exists("heal_slot") Then $healSlot = $opts.Item("heal_slot")
        If $opts.Exists("heal_hp_threshold") Then $hpThresh = $opts.Item("heal_hp_threshold")
        If $opts.Exists("attack_slots") Then $attackSlots = $opts.Item("attack_slots")
    EndIf
    If $healSlot > 0 Then
        Local $hp = Agent_GetAgentInfo(-2, "HP") * 100
        If $hp < $hpThresh And Skill_GetSkillbarInfo($healSlot, "Recharge") = 0 Then
            Out("[Combat-Skills] Cast HEAL slot " & $healSlot & " (HP=" & Round($hp) & "%)")
            Skill_UseSkill($healSlot, -2, False)
            $g_CS_LastCastTimer = TimerInit()
            Return $healSlot
        EndIf
    EndIf
    If $target = 0 Then $target = Agent_GetCurrentTarget()
    If $target = 0 Then Return 0
    Local $curEnAbsP = Agent_GetAgentInfo(-2, "CurrentEnergy")
    Local $curEnMaxP = Agent_GetAgentInfo(-2, "MaxEnergy")
    Local $curEnP = ($curEnMaxP > 0) ? ($curEnAbsP / $curEnMaxP) * 100 : 100.0
    Local $enCritP = ($curEnP < 10)
    Local $isSierpeP = (BitAND(Agent_GetAgentInfo(-2, "TransmogNpcId"), 0x20000000) <> 0)
    If IsArray($attackSlots) Then
        For $i = 0 To UBound($attackSlots) - 1
            Local $slot = $attackSlots[$i]
            If $isSierpeP And $slot > 4 Then ContinueLoop
            If _CS_IsSlotExcluded($slot) Then ContinueLoop
            If Not Skill_GetSkillbarInfo($slot, "IsRecharged") Then ContinueLoop
            Local $sid2 = Skill_GetSkillbarInfo($slot, "SkillID")
            If $g_CS_ExcludedSkillIDs <> "" And StringInStr("," & $g_CS_ExcludedSkillIDs & ",", "," & $sid2 & ",") Then ContinueLoop
            If $enCritP And $sid2 <> $GC_I_SKILL_ID_ZEALOUS_RENEWAL Then ContinueLoop
            Out("[Combat-Skills] Cast ATTACK slot " & $slot & " (ID=" & $sid2 & ") on target=" & $target)
            Skill_UseSkill($slot, $target, False)
            $g_CS_LastCastTimer = TimerInit()
            Return $slot
        Next
    Else
        For $slot = 1 To 8
            If $slot = $healSlot Then ContinueLoop
            If $isSierpeP And $slot > 4 Then ContinueLoop
            If _CS_IsSlotExcluded($slot) Then ContinueLoop
            If Not Skill_GetSkillbarInfo($slot, "IsRecharged") Then ContinueLoop
            Local $sid3 = Skill_GetSkillbarInfo($slot, "SkillID")
            If $g_CS_ExcludedSkillIDs <> "" And StringInStr("," & $g_CS_ExcludedSkillIDs & ",", "," & $sid3 & ",") Then ContinueLoop
            If $enCritP And $sid3 <> $GC_I_SKILL_ID_ZEALOUS_RENEWAL Then ContinueLoop
            Out("[Combat-Skills] Cast ATTACK slot " & $slot & " (ID=" & $sid3 & ") on target=" & $target)
            Skill_UseSkill($slot, $target, False)
            $g_CS_LastCastTimer = TimerInit()
            Return $slot
        Next
    EndIf
    Return 0
EndFunc
Func _CS_IsSlotExcluded($slot)
    If Not IsArray($g_CS_ExcludedSlots) Then Return False
    For $i = 0 To UBound($g_CS_ExcludedSlots) - 1
        If $g_CS_ExcludedSlots[$i] = $slot Then Return True
    Next
    Return False
EndFunc
Func _CS_ExcludedStr()
    Local $s = ""
    For $i = 0 To UBound($g_CS_ExcludedSlots) - 1
        If $i > 0 Then $s &= ","
        $s &= $g_CS_ExcludedSlots[$i]
    Next
    Return $s
EndFunc