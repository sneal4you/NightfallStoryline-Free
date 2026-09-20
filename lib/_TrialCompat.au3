#include-once
Global $g_bM08ProfMonkSet = False
Global $g_bM08SignetEquipped = False
Global $g_bM08Captured = False
Global $g_bRPProfNecroSet = False
Global $g_bRPSignetEquipped = False
Func _M08_RestoreDervishWarrior()
    Local $T = "[M08-capture] "
    Local Const $SKILL = $GC_I_SKILL_ID_LIGHT_OF_DELIVERANCE   
    If Not $g_bM08Captured And Not World_IsSkillLearnt($SKILL) Then
        Out($T & "elite no capturada -> mantener D/M (reintento)")
        Return False
    EndIf
    If Map_GetInstanceInfo("Type") <> $GC_I_MAP_TYPE_OUTPOST Then
        Out($T & "no outpost -> skip restore build")
        Return False
    EndIf
    Local $tPop = TimerInit()
    While Agent_GetAgentInfo(-2, "MaxHP") <= 0 And TimerDiff($tPop) < 10000
        Sleep(500)
    WEnd
    Local $secNow = Agent_GetAgentInfo(-2, "Secondary")
    If $secNow = $GC_I_PROFESSION_WARRIOR Then
        Out($T & "2a profesion ya Warrior -> ok")
    ElseIf $secNow <> $GC_I_PROFESSION_MONK Then
        Out($T & "2a profesion " & $secNow & " no es Monk (deliberado) -> skip restore")
        Return True
    Else
        Out($T & "restaurando 2a profesion a Warrior (D/W)")
        Attribute_ChangeSecondProfession($GC_I_PROFESSION_WARRIOR)
        Sleep(1000)
        If Agent_GetAgentInfo(-2, "Secondary") <> $GC_I_PROFESSION_WARRIOR Then
            Out($T & "FALLO restore a Warrior (sec=" & Agent_GetAgentInfo(-2, "Secondary") & ")")
            Return False
        EndIf
    EndIf
    If Agent_GetAgentInfo(-2, "MaxHP") > 0 Then
        Local Const $M08_DW_BUILD = "OgGjUhpMrOXl/r0dAzVGvjbBAA"
        Attribute_LoadSkillTemplate($M08_DW_BUILD)
        Sleep(1000)
    EndIf
    $g_bM08ProfMonkSet = False
    $g_bM08SignetEquipped = False
    Out($T & "OK: build D/W restaurada")
    Return True
EndFunc
Func _RP_RestoreDervishWarrior()
    Local $T = "[RP-capture] "
    If Not World_IsSkillLearnt($GC_I_SKILL_ID_BLOOD_IS_POWER) Then
        Out($T & "Blood is Power no capturada -> mantener profesion actual (preparar captura)")
        Return False
    EndIf
    If Map_GetInstanceInfo("Type") <> $GC_I_MAP_TYPE_OUTPOST Then
        Out($T & "no outpost -> skip restore build")
        Return False
    EndIf
    Local $secNow = Agent_GetAgentInfo(-2, "Secondary")
    If $secNow = $GC_I_PROFESSION_NECROMANCER Then
        Out($T & "restaurando 2a profesion a Warrior (D/W)")
        Attribute_ChangeSecondProfession($GC_I_PROFESSION_WARRIOR)
        Sleep(1000)
        If Agent_GetAgentInfo(-2, "Secondary") <> $GC_I_PROFESSION_WARRIOR Then
            Out($T & "FALLO restore a Warrior (sec=" & Agent_GetAgentInfo(-2, "Secondary") & ")")
            Return False
        EndIf
    ElseIf $secNow <> $GC_I_PROFESSION_WARRIOR Then
        Out($T & "2a profesion " & $secNow & " no es Necromancer ni Warrior (no es un swap de captura) -> skip restore")
        Return True
    Else
        Out($T & "2a profesion ya Warrior -> ok")
    EndIf
    Local Const $M08_DW_BUILD = "OgGjUhpMrOXl/r0dAzVGvjbBAA"
    If Agent_GetAgentInfo(-2, "MaxHP") > 0 Then
        Attribute_LoadSkillTemplate($M08_DW_BUILD)
        Sleep(1000)
        Out($T & "template D/W base cargado")
    EndIf
    $g_bRPProfNecroSet = False
    $g_bRPSignetEquipped = False
    Out($T & "OK: char restaurado a D/W con build base")
    Return True
EndFunc
Func _PMP_FindAllyByModel($model)
    Local $ags = Agent_GetAgentArray($GC_I_AGENT_TYPE_LIVING)
    If Not IsArray($ags) Then Return 0
    For $i = 0 To UBound($ags) - 1
        If $ags[$i] = 0 Then ContinueLoop
        If Agent_GetAgentInfo($ags[$i], "ModelID") <> $model Then ContinueLoop
        If Agent_GetAgentInfo($ags[$i], "IsDead") Then ContinueLoop
        Return $ags[$i]
    Next
    Return 0
EndFunc
Func _TV_DumpHenchmen()
    Local $agents = Agent_GetAgentArray($GC_I_AGENT_TYPE_LIVING)
    If Not IsArray($agents) Or $agents[0] = 0 Then
        Out("[TV] HenchDump: array vacio")
        Return
    EndIf
    Local $self = Agent_GetAgentInfo(-2, "ID")
    Local $n = 0, $s = ""
    For $i = 1 To $agents[0]
        Local $ptr = $agents[$i]
        If $ptr = 0 Then ContinueLoop
        If Agent_GetAgentInfo($ptr, "ID") = $self Then ContinueLoop
        Local $model = Agent_GetAgentInfo($ptr, "PlayerNumber")
        If $model = 0 Then ContinueLoop
        $n += 1
        $s &= " [m=" & $model & " h=" & Agent_GetAgentInfo($ptr, "IsHenchman") & " '" & Agent_GetAgentInfo($ptr, "Name") & "']"
    Next
    Out("[TV] HenchDump map=" & Map_GetMapID() & " n=" & $n & ":" & $s)
EndFunc