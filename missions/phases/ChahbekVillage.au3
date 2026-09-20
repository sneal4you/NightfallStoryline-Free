#include-once
Global Const $M01_MAP_ID   = $GC_I_MAP_ID_CHAHBEK_VILLAGE_OUTPOST   
Global Const $M01_QUEST_ID = $GC_I_QUEST_ID_INTOCHAHBEKVILLAGE      
Global Const $M01_BOSS_MODEL = $GC_I_MODEL_ID_NF_BENNIS            
Global Const $M01_AGENT_BARREL = 9
Global Const $M01_AGENT_CATA1  = 5
Global Const $M01_AGENT_CATA2  = 6
Global $M01_STEPS[][5] = [ _
    ["nav_combat",    -660,  -4518, "spawn area (este, entrada)",     0], _
    ["gadget_pickup", -4752, -1826, "barrel 1 (NW)",                  $M01_AGENT_BARREL], _
    ["gadget_load",   -1729, -2532, "cata 1 load (centro-N)",         $M01_AGENT_CATA1],  _
    ["gadget_fire",   -1729, -2532, "cata 1 fire",                    0], _
    ["gadget_pickup", -4742, -1791, "barrel 2 (NW)",                  $M01_AGENT_BARREL], _
    ["gadget_load",   -1750, -4136, "cata 2 load (centro-S)",         $M01_AGENT_CATA2],  _
    ["gadget_fire",   -1750, -4136, "cata 2 fire",                    0], _
    ["nav_combat",    -4181, -6662, "bennis (SW)",                    0], _
    ["nav_kill_far",  -2130, -6718, "cleanup S",                      0], _
    ["nav_kill_far",    97,   -6141, "cleanup SE",                     0], _
    ["nav_kill_far",   -1974, -3338, "cleanup centro",                 0], _
    ["nav_kill_far",   -2224, -306,  "cleanup N",                      0], _
    ["nav_kill_far",   -1878,  1153, "cleanup N lejano",               0], _
    ["wait_cinematic", 0,     0,    "cinematic outro (si aparece)",   0], _
    ["stop",           0,     0,    "end",                            0]  _
]
Func Mission_Chahbek_Run()
    Out("[M01] Mission_Chahbek_Run start")
    If Not Bot_IsInMission($M01_MAP_ID) Then
        Return Bot_AbortClean("Mission_Chahbek_Run: no estoy en mission instance")
    EndIf
    Out("[M01] Esperando que el char este cargado en la instance...")
    Local $tLoad = TimerInit()
    While Not Bot_ShouldStop() And TimerDiff($tLoad) < 20000
        Local $mhp = Agent_GetAgentInfo(-2, "MaxHP")
        Local $mx = Agent_GetAgentInfo(-2, "X")
        Local $my = Agent_GetAgentInfo(-2, "Y")
        If $mhp > 0 And ($mx <> 0 Or $my <> 0) And Not Map_GetInstanceInfo("IsLoading") Then
            Out("[M01] Char cargado tras " & Round(TimerDiff($tLoad)/1000, 1) & "s pos=(" & Round($mx) & "," & Round($my) & ") MaxHP=" & $mhp)
            ExitLoop
        EndIf
        Sleep(500)
    WEnd
    If Agent_GetAgentInfo(-2, "MaxHP") = 0 Then
        Return Bot_AbortClean("Mission_Chahbek_Run: char no cargado tras 20s")
    EndIf
    Sleep(2000)   
    Pathfinder_SetPathUpdateInterval(2000)
    Cache_SkillBar()
    Local $ok = Mission_RunSteps($M01_STEPS, $M01_MAP_ID)
    Local $endMap = Map_GetMapID()
    If $endMap = $GC_I_MAP_ID_CHUURHIR_FIELDS Then
        Out("[M01] Char en Chuurhir Fields (456) tras steps - outro cinematic OK")
        Return True
    EndIf
    Local $isComplete = Quest_GetQuestInfo($M01_QUEST_ID, "IsCompleted")
    Local $logState   = Quest_GetQuestInfo($M01_QUEST_ID, "LogState")
    If $isComplete = True And $logState >= 0 Then
        Out("[M01] Quest " & $M01_QUEST_ID & " IsCompleted=True logState=" & $logState & " — MISSION OK")
        Return True
    EndIf
    Out("[M01] Mission terminada pero quest " & $M01_QUEST_ID & " no completada (IsCompleted=" & $isComplete & " logState=" & $logState & " map=" & $endMap & ") ok=" & $ok)
    Return $ok
EndFunc
Func Missions_Execute($missionName)
    Switch $missionName
        Case "M01_Chahbek"
            Return Mission_Chahbek_Run()
        Case Else
            Out("[Missions] Unknown mission: '" & $missionName & "'")
            Return False
    EndSwitch
EndFunc
Func Missions_Enter($missionName)
    Out("[Missions] Setup party para " & $missionName)
    Heroes_SetupForMission($missionName)
    Sleep(500)
    Party_FillWithHenchmen()
    Sleep(1000)
    Out("[Missions] Enter mission " & $missionName)
    Ui_EnterChallenge(False, True)
    Sleep(2000)
    Local $type = Map_GetInstanceInfo("Type")
    Return ($type = $GC_I_MAP_TYPE_EXPLORABLE)
EndFunc