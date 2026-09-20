#include-once
Global $g_PR_LastTryTimer  = 0
Global $g_PR_LastResTarget = 0    
Global $g_PR_CastLock      = False 
Global $g_PR_SkipList      = "|"  
Global $g_PR_BackoffTimer  = 0    
Global Const $PR_BACKOFF_MS = 300000 
Global $g_PR_RetryTarget   = 0    
Global $g_PR_RetryCount    = 0    
Global $g_PR_InTick        = False 
Global $g_PR_ResSlot = 8
Global $g_PR_Disabled = False
Func PartyRecovery_SetDisabled($b)
    $g_PR_Disabled = $b
EndFunc
Global Const $PR_COOLDOWN_MS = 5000
Func PartyRecovery_SetResSlot($slot)
    $g_PR_ResSlot = $slot
EndFunc
Func PartyRecovery_Reset()
    $g_PR_LastTryTimer  = 0
    $g_PR_LastResTarget = 0
    $g_PR_SkipList      = "|"
    $g_PR_BackoffTimer  = 0
    $g_PR_RetryTarget   = 0
    $g_PR_RetryCount    = 0
EndFunc
Func PartyRecovery_Tick()
    If $g_PR_InTick Then Return
    $g_PR_InTick = True
    If $g_PR_Disabled Then
        $g_PR_InTick = False
        Return
    EndIf
    If $g_PR_LastTryTimer <> 0 And TimerDiff($g_PR_LastTryTimer) < $PR_COOLDOWN_MS Then
        $g_PR_InTick = False
        Return
    EndIf
    If $g_PR_LastResTarget > 0 Then
        If Agent_GetAgentInfo($g_PR_LastResTarget, "IsDead") = True Then
            If $g_PR_RetryTarget <> $g_PR_LastResTarget Then
                $g_PR_RetryTarget = $g_PR_LastResTarget
                $g_PR_RetryCount  = 0
            EndIf
            $g_PR_RetryCount += 1
            If $g_PR_RetryCount >= 2 Then
                Out("[PartyRec] " & $g_PR_RetryCount & " intentos fallidos (agent=" & $g_PR_LastResTarget & "), skip + backoff " & ($PR_BACKOFF_MS/1000) & "s")
                If Not StringInStr($g_PR_SkipList, "|" & $g_PR_LastResTarget & "|") Then
                    $g_PR_SkipList &= $g_PR_LastResTarget & "|"
                EndIf
                $g_PR_RetryTarget = 0
                $g_PR_RetryCount  = 0
                $g_PR_LastResTarget = 0
                $g_PR_BackoffTimer = TimerInit()
            Else
                Out("[PartyRec] intento " & $g_PR_RetryCount & "/2 fallido (agent=" & $g_PR_LastResTarget & "), reintentando")
                $g_PR_LastResTarget = 0
            EndIf
        Else
            If $g_PR_RetryTarget = $g_PR_LastResTarget Then
                $g_PR_RetryCount  = 0
                $g_PR_RetryTarget = 0
            EndIf
            $g_PR_LastResTarget = 0
        EndIf
    EndIf
    Local $mapType = Map_GetInstanceInfo("Type")
    If $mapType = $GC_I_MAP_TYPE_OUTPOST Then
        $g_PR_InTick = False
        Return
    EndIf
    If Map_GetMapID() = 0 Then
        $g_PR_InTick = False
        Return
    EndIf
    If Map_GetInstanceInfo("IsLoading") Then
        $g_PR_InTick = False
        Return
    EndIf
    If Agent_GetAgentInfo(-2, "IsDead") = True Then
        $g_PR_InTick = False
        Return
    EndIf
    If Agent_GetAgentInfo(-2, "MaxHP") = 0 Then
        $g_PR_InTick = False
        Return
    EndIf
    Local $bSierpe = BitAND(Agent_GetAgentInfo(-2, "TransmogNpcId"), 0x20000000) <> 0
    Local $rezSlot = $bSierpe ? 7 : $g_PR_ResSlot
    If Skill_GetSkillbarInfo($rezSlot, "Disabled") Then
        $g_PR_LastResTarget = 0   
        $g_PR_InTick = False
        Return
    EndIf
    If $g_PR_BackoffTimer <> 0 And TimerDiff($g_PR_BackoffTimer) < $PR_BACKOFF_MS Then
        $g_PR_InTick = False
        Return
    EndIf
    Local $deadAgent = _PR_FindDeadAlly()
    If $deadAgent = 0 Then
        $g_PR_InTick = False
        Return
    EndIf
    If $bSierpe Then
        Local $deadTmog = Agent_GetAgentInfo($deadAgent, "TransmogNpcId")
        If BitAND($deadTmog, 0x20000000) = 0 Then
            Out("[PartyRec] sierpe: aliado agent=" & $deadAgent & " NO en sierpe (transmog=0x" & Hex($deadTmog) & ") -> skip (skill 7 no revive no-sierpe)")
            $g_PR_LastTryTimer = TimerInit()
            $g_PR_LastResTarget = $deadAgent
            $g_PR_InTick = False
            Return
        EndIf
    EndIf
    Local $recharge = Skill_GetSkillbarInfo($rezSlot, "Recharge")
    If $recharge <> 0 Then
        $g_PR_InTick = False
        Return
    EndIf
    Local $deadRezX = Agent_GetAgentInfo($deadAgent, "X")
    Local $deadRezY = Agent_GetAgentInfo($deadAgent, "Y")
    Local $dRez = Sqrt(($deadRezX - Agent_GetAgentInfo(-2, "X"))^2 + ($deadRezY - Agent_GetAgentInfo(-2, "Y"))^2)
    Out("[PartyRec] Dead ally (agent=" & $deadAgent & ") dist=" & Round($dRez) & " slot=" & $rezSlot & ($bSierpe ? " sierpe-area" : " normal-target"))
    If $bSierpe Then
        If $dRez > 800 Then
            $g_PR_CastLock = True
            Local $tMovR7 = TimerInit()
            While TimerDiff($tMovR7) < 12000
                Map_Move($deadRezX, $deadRezY, 0)
                Sleep(600)
                Local $cwx = Agent_GetAgentInfo(-2, "X"), $cwy = Agent_GetAgentInfo(-2, "Y")
                If Sqrt(($deadRezX - $cwx)^2 + ($deadRezY - $cwy)^2) < 700 Then ExitLoop
                If GetNearestEnemy(1200) <> 0 Then ExitLoop
            WEnd
            $g_PR_CastLock = False
            $dRez = Sqrt(($deadRezX - Agent_GetAgentInfo(-2, "X"))^2 + ($deadRezY - Agent_GetAgentInfo(-2, "Y"))^2)
            If $dRez > 800 Then
                Out("[PartyRec] sierpe: aliado muerto a " & Round($dRez) & "u > 800 -> skip (fuera de radio skill 7)")
                $g_PR_LastTryTimer = TimerInit()
                $g_PR_LastResTarget = $deadAgent
                $g_PR_InTick = False
                Return
            EndIf
        EndIf
    Else
        If $dRez > 4500 Then
            Out("[PartyRec] aliado muerto a " & Round($dRez) & "u > 4500 -> skip (no desviar al char del objetivo)")
            $g_PR_LastTryTimer = TimerInit()
            $g_PR_LastResTarget = $deadAgent
            $g_PR_InTick = False
            Return
        EndIf
        If $dRez > 500 Then
            Out("[PartyRec] lejos -> mover encima (bucle hasta <500u)")
            $g_PR_CastLock = True
            Local $tMovRez = TimerInit()
            While TimerDiff($tMovRez) < 10000
                If Map_GetMapID() = 0 Or Map_GetInstanceInfo("IsLoading") _
                   Or Map_GetInstanceInfo("Type") = $GC_I_MAP_TYPE_OUTPOST Then ExitLoop
                If GetNearestEnemy(1200) <> 0 Then
                    Out("[PartyRec] enemigos cerca durante caminata -> abortar (no caminar hacia el peligro)")
                    ExitLoop
                EndIf
                Map_Move($deadRezX, $deadRezY, 0)
                Sleep(400)
                Local $cdx = Agent_GetAgentInfo(-2, "X"), $cdy = Agent_GetAgentInfo(-2, "Y")
                If Sqrt(($deadRezX - $cdx)^2 + ($deadRezY - $cdy)^2) < 500 Then ExitLoop
            WEnd
            $dRez = Sqrt(($deadRezX - Agent_GetAgentInfo(-2, "X"))^2 + ($deadRezY - Agent_GetAgentInfo(-2, "Y"))^2)
            Out("[PartyRec] post-mov dist=" & Round($dRez))
        EndIf
    EndIf
    Agent_CancelAction()
    Sleep(200)
    $g_PR_CastLock = True
    If $bSierpe Then
        Local $srRecharge = Skill_GetSkillbarInfo($rezSlot, "Recharge")
        Local $srDisabled = Skill_GetSkillbarInfo($rezSlot, "Disabled")
        Out("[PartyRec] sierpe rez: slot=" & $rezSlot & " recharge=" & $srRecharge & " disabled=" & $srDisabled & " distAlly=" & Round($dRez))
        Skill_UseSkill($rezSlot)
    Else
        If Map_GetMapID() = 0 Or Map_GetInstanceInfo("IsLoading") _
           Or Map_GetInstanceInfo("Type") = $GC_I_MAP_TYPE_OUTPOST Then
            $g_PR_CastLock = False
            $g_PR_InTick = False
            Return
        EndIf
        Agent_ChangeTarget($deadAgent)
        Sleep(300)
        Skill_UseSkill($rezSlot, $deadAgent, False)
    EndIf
    Local $tRezCast = TimerInit()
    Local $rezOK = False
    While TimerDiff($tRezCast) < 5500
        Sleep(300)
        If Map_GetMapID() = 0 Or Map_GetInstanceInfo("IsLoading") Then ExitLoop
        If Agent_GetAgentInfo($deadAgent, "IsDead") <> True Then
            $rezOK = True
            ExitLoop
        EndIf
    WEnd
    Out("[PartyRec] rez " & ($rezOK ? "OK (aliado agent=" & $deadAgent & " revivido)" : "NO cuajó (agent=" & $deadAgent & ", sigue muerto tras 5.5s)"))
    $g_PR_CastLock = False
    $g_PR_LastTryTimer = TimerInit()
    $g_PR_LastResTarget = $deadAgent
    $g_PR_InTick = False
EndFunc
Func _PR_FindDeadAlly()
    For $i = 1 To 8
        Local $aid = Party_GetMyPartyHeroInfo($i, "AgentID")
        If $aid = 0 Then ContinueLoop
        If StringInStr($g_PR_SkipList, "|" & $aid & "|") Then ContinueLoop
        If Agent_GetAgentInfo($aid, "IsDead") = True Then Return $aid
    Next
    For $i = 1 To 4
        Local $aid = Party_GetMyPartyHenchmanInfo($i, "AgentID")
        If $aid = 0 Then ContinueLoop
        If StringInStr($g_PR_SkipList, "|" & $aid & "|") Then ContinueLoop
        If Agent_GetAgentInfo($aid, "IsDead") = True Then Return $aid
    Next
    Return 0
EndFunc