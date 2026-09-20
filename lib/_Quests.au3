#include-once
Global $g_kormirTalked = False
Func Quests_DetectCurrentObjective()
    Local $currentMap = Map_GetMapID()
    Local $region = Map_GetRegion()
    Local $instType = Map_GetInstanceInfo("Type")   
    If $currentMap = 0 Then
        Out("[Quests] Map=0 (char no cargado en mundo). Esperar 3s y reintentar")
        Sleep(3000)
        Return False
    EndIf
    If Map_GetInstanceInfo("IsLoading") Then
        Out("[Quests] IsLoading=True. Esperar 3s y reintentar")
        Sleep(3000)
        Return False
    EndIf
    Local $missionName = _Quests_GetStorylineFromMapId($currentMap, True)
    If $missionName <> "" Then
        $g_currentMission = $missionName
        $g_state = $NF_STATE_IN_MISSION
        Out("[Quests] map=" & $currentMap & " IN_MISSION " & $missionName)
        Return True
    EndIf
    If $currentMap = $GC_I_MAP_ID_CHAHBEK_VILLAGE_OUTPOST _
            And $instType = $GC_I_MAP_TYPE_EXPLORABLE Then
        $g_currentMission = "M01_Chahbek"
        $g_state = $NF_STATE_IN_MISSION
        Out("[Quests] map=544 type=EXPLORABLE -> IN_MISSION M01_Chahbek")
        Return True
    EndIf
    Local $tutorialStep = _Quests_GetTutorialStepForMap($currentMap)
    If $tutorialStep <> "" Then
        $g_currentMission = $tutorialStep
        $g_state = $NF_STATE_ACCEPT_QUEST
        Out("[Quests] map=" & $currentMap & " tutorial step=" & $tutorialStep & " -> ACCEPT_QUEST")
        Return True
    EndIf
    $missionName = _Quests_GetStorylineFromMapId($currentMap, False)
    If $missionName <> "" Then
        $g_currentMission = $missionName
        If $currentMap = $GC_I_MAP_ID_CHAHBEK_VILLAGE_OUTPOST And Not Agent_HasQuest($GC_I_QUEST_ID_INTOCHAHBEKVILLAGE) Then
            $g_state = $NF_STATE_ACCEPT_QUEST
            Out("[Quests] map=" & $currentMap & " M01 outpost sin quest -> ACCEPT_QUEST")
        Else
            $g_state = $NF_STATE_ENTER_MISSION
            Out("[Quests] map=" & $currentMap & " outpost " & $missionName & " -> ENTER_MISSION")
        EndIf
        Return True
    EndIf
    Local $campaign = Map_GetAreaInfo($currentMap, "Campaign")
    Local $phase = ""
    If $campaign = $GC_I_MAP_CAMPAIGN_NIGHTFALL Then
        If _Quests_IsNightfallRegion($region) Then
            $phase = _Quests_RegionToPhase($region)
        Else
            $phase = _Quests_GetPhaseForOutpost($currentMap)
            If $phase = "" Then $phase = "Istan"   
        EndIf
    EndIf
    Out("[Quests] map=" & $currentMap & " region=" & $region & " instType=" & $instType & " campaign=" & $campaign & " phase=" & $phase)
    If $phase = "" Then
        Out("[Quests] Fuera de Nightfall (campaign=" & $campaign & ") -> Travel_ToOutpost Kamadan")
        Travel_ToOutpost($GC_I_MAP_ID_KAMADAN_JEWEL_OF_ISTAN)
        $g_state = $NF_STATE_DETECT_PROGRESS
        Return True
    EndIf
    Local $nextMissionOutpost = _Quests_GetNextMissionOutpostForPhase($phase)
    Local $hub = _Quests_GetHubForPhase($phase)
    If $instType = 1 Then
        Out("[Quests] explorable de " & $phase & " -> Travel_ToOutpost hub " & $hub)
        Travel_ToOutpost($hub)
        $g_state = $NF_STATE_DETECT_PROGRESS
        Return True
    EndIf
    Out("[Quests] outpost no-storyline en " & $phase & " -> Travel_ToOutpost siguiente misión " & $nextMissionOutpost)
    Travel_ToOutpost($nextMissionOutpost)
    $g_state = $NF_STATE_DETECT_PROGRESS
    Return True
EndFunc
Func _Quests_RegionToPhase($region)
    Switch $region
        Case $GC_I_MAP_REGION_Istan
            Return "Istan"
        Case $GC_I_MAP_REGION_Kourna
            Return "Kourna"
        Case $GC_I_MAP_REGION_Vaabi
            Return "Vabbi"
        Case $GC_I_MAP_REGION_Desolation
            Return "Desolation"
        Case $GC_I_MAP_REGION_DomainOfAnguish
            Return "RoT"
        Case Else
            Return ""
    EndSwitch
EndFunc
Func _Quests_GetPhaseForOutpost($mapId)
    Switch $mapId
        Case $GC_I_MAP_ID_KAMADAN_JEWEL_OF_ISTAN, _
             $GC_I_MAP_ID_SUNSPEAR_SANCTUARY, _
             $GC_I_MAP_ID_SUNSPEAR_GREAT_HALL, _
             $GC_I_MAP_ID_FAHRANUR_THE_FIRST_CITY, _
             $GC_I_MAP_ID_KODLONU_HAMLET, _
             $GC_I_MAP_ID_CAMP_HOJANU, _
             $GC_I_MAP_ID_SUN_DOCKS, _
             $GC_I_MAP_ID_ISLAND_OF_SHEHKAH, _
             $GC_I_MAP_ID_DAJKAH_INLET_OUTPOST, _
             $GC_I_MAP_ID_LIONS_ARCH_DURING_SUNSPEARS_IN_KRYTA, _
             $GC_I_MAP_ID_KAINENG_CENTER_DURING_SUNSPEARS_IN_CANTHA
            Return "Istan"
        Case $GC_I_MAP_ID_CONSULATE, _
             $GC_I_MAP_ID_COMMAND_POST, _
             $GC_I_MAP_ID_YOHLON_HAVEN, _
             $GC_I_MAP_ID_GANDARA_THE_MOON_FORTRESS, _
             $GC_I_MAP_ID_MIHANU_TOWNSHIP, _
             $GC_I_MAP_ID_MEHTANI_KEYS, _
             $GC_I_MAP_ID_REMAINS_OF_SAHLAHJA_OUTPOST
            Return "Kourna"
        Case $GC_I_MAP_ID_THE_KODASH_BAZAAR, _
             $GC_I_MAP_ID_SEBELKEH_BASILICA, _
             $GC_I_MAP_ID_HOLDINGSOFCHOKHIN, _
             $GC_I_MAP_ID_GARDEN_OF_SEBORHIN, _
             $GC_I_MAP_ID_BASALT_GROTTO, _
             $GC_I_MAP_ID_HONUR_HILL, _
             $GC_I_MAP_ID_YAHNUR_MARKET, _
             $GC_I_MAP_ID_THE_HIDDEN_CITY_OF_AHDASHIM
            Return "Vabbi"
        Case $GC_I_MAP_ID_CHANTRY_OF_SECRETS, _
             $GC_I_MAP_ID_BONE_PALACE, _
             $GC_I_MAP_ID_CRYSTAL_OVERLOOK
            Return "Desolation"
        Case $GC_I_MAP_ID_GATE_OF_TORMENT, _
             $GC_I_MAP_ID_HEART_OF_ABADDON, _
             $GC_I_MAP_ID_GATE_OF_FEAR, _
             $GC_I_MAP_ID_GATE_OF_SECRETS, _
             $GC_I_MAP_ID_GATE_OF_ANGUISH, _
             $GC_I_MAP_ID_GATE_OF_THE_NIGHTFALLEN_LANDS, _
             $GC_I_MAP_ID_A_LAND_OF_HEROES
            Return "RoT"
        Case Else
            Return ""
    EndSwitch
EndFunc
Func _Quests_GetHubForPhase($phase)
    Switch $phase
        Case "Istan"
            Return $GC_I_MAP_ID_KAMADAN_JEWEL_OF_ISTAN
        Case "Kourna"
            Return $GC_I_MAP_ID_CONSULATE
        Case "Vabbi"
            Return $GC_I_MAP_ID_THE_KODASH_BAZAAR
        Case "Desolation"
            Return $GC_I_MAP_ID_CHANTRY_OF_SECRETS
        Case "RoT"
            Return $GC_I_MAP_ID_GATE_OF_TORMENT
        Case Else
            Return $GC_I_MAP_ID_KAMADAN_JEWEL_OF_ISTAN
    EndSwitch
EndFunc
Func _Quests_GetNextMissionOutpostForPhase($phase)
    Switch $phase
        Case "Istan"
            Return $GC_I_MAP_ID_CHAHBEK_VILLAGE_OUTPOST          
        Case "Kourna"
            Return $GC_I_MAP_ID_VENTA_CEMETERY_OUTPOST           
        Case "Vabbi"
            Return $GC_I_MAP_ID_TIHARK_ORCHARD_OUTPOST           
        Case "Desolation"
            Return $GC_I_MAP_ID_RUINS_OF_MORAH_OUTPOST           
        Case "RoT"
            Return $GC_I_MAP_ID_GATE_OF_PAIN_OUTPOST             
        Case Else
            Return $GC_I_MAP_ID_CHAHBEK_VILLAGE_OUTPOST
    EndSwitch
EndFunc
Func _Quests_IsNightfallRegion($region)
    Return ($region = $GC_I_MAP_REGION_Istan _
         Or $region = $GC_I_MAP_REGION_Kourna _
         Or $region = $GC_I_MAP_REGION_Vaabi _
         Or $region = $GC_I_MAP_REGION_Desolation _
         Or $region = $GC_I_MAP_REGION_DomainOfAnguish)
EndFunc
Func _Quests_GetStorylineFromMapId($mapId, $isMissionInstance)
    If $isMissionInstance Then
        Switch $mapId
            Case $GC_I_MAP_ID_CHAHBEK_VILLAGE_MISSION
                Return "M01_Chahbek"
            Case $GC_I_MAP_ID_JOKANUR_DIGGINGS_MISSION
                Return "M02_Jokanur"
            Case $GC_I_MAP_ID_BLACKTIDE_DEN_MISSION
                Return "M03_Blacktide"
            Case $GC_I_MAP_ID_CONSULATE_DOCKS_MISSION
                Return "M04_ConsulateDocks"
            Case $GC_I_MAP_ID_KODONUR_CROSSROADS_MISSION
                Return "M06_Kodonur"
            Case $GC_I_MAP_ID_POGAHN_PASSAGE_MISSION
                Return "M07_PogahnPassage"
            Case $GC_I_MAP_ID_RILOHN_REFUGE_MISSION
                Return "M08_RilohnOrModdok"
            Case $GC_I_MAP_ID_TIHARK_ORCHARD_MISSION
                Return "M09_Tihark"
            Case $GC_I_MAP_ID_GRAND_COURT_OF_SEBELKEH_MISSION
                Return "M11_GrandCourt"
            Case $GC_I_MAP_ID_JENNURS_HORDE_MISSION, $GC_I_MAP_ID_DZAGONUR_BASTION_MISSION
                Return "M12_JennurOrDzagonur"
            Case $GC_I_MAP_ID_NUNDU_BAY_MISSION
                Return "M13_NunduBay"
            Case $GC_I_MAP_ID_GATES_OF_DESOLATION_MISSION
                Return "M14_GateOfDesolation"
            Case $GC_I_MAP_ID_RUINS_OF_MORAH_MISSION
                Return "M15_RuinsOfMorah"
            Case $GC_I_MAP_ID_DOMAIN_OF_PAIN_MISSION
                Return "M16_GateOfPain"
            Case $GC_I_MAP_ID_GATE_OF_MADNESS_MISSION
                Return "M17_GateOfMadness"
            Case $GC_I_MAP_ID_ABADDONS_GATE_MISSION
                Return "M18_AbaddonsGate"
            Case Else
                Return ""
        EndSwitch
    Else
        Switch $mapId
            Case $GC_I_MAP_ID_CHAHBEK_VILLAGE_OUTPOST
                Return "M01_Chahbek"
            Case $GC_I_MAP_ID_JOKANUR_DIGGINGS_OUTPOST
                Return "M02_Jokanur"
            Case $GC_I_MAP_ID_BLACKTIDE_DEN_OUTPOST
                Return "M03_Blacktide"
            Case $GC_I_MAP_ID_CONSULATE_DOCKS_OUTPOST
                Return "M04_ConsulateDocks"
            Case $GC_I_MAP_ID_VENTA_CEMETERY_OUTPOST
                Return "M05_VentaCemetery"
            Case $GC_I_MAP_ID_KODONUR_CROSSROADS_OUTPOST
                Return "M06_Kodonur"
            Case $GC_I_MAP_ID_POGAHN_PASSAGE_OUTPOST
                Return "M07_PogahnPassage"
            Case $GC_I_MAP_ID_RILOHN_REFUGE_OUTPOST, $GC_I_MAP_ID_MODDOK_CREVICE_OUTPOST
                Return "M08_RilohnOrModdok"
            Case $GC_I_MAP_ID_TIHARK_ORCHARD_OUTPOST
                Return "M09_Tihark"
            Case $GC_I_MAP_ID_DASHA_VESTIBULE_OUTPOST
                Return "M10_Dasha"
            Case $GC_I_MAP_ID_GRAND_COURT_OF_SEBELKEH_OUTPOST
                Return "M11_GrandCourt"
            Case $GC_I_MAP_ID_JENNURS_HORDE_OUTPOST, $GC_I_MAP_ID_DZAGONUR_BASTION_OUTPOST
                Return "M12_JennurOrDzagonur"
            Case $GC_I_MAP_ID_NUNDU_BAY_OUTPOST
                Return "M13_NunduBay"
            Case $GC_I_MAP_ID_GATE_OF_DESOLATION_OUTPOST
                Return "M14_GateOfDesolation"
            Case $GC_I_MAP_ID_RUINS_OF_MORAH_OUTPOST
                Return "M15_RuinsOfMorah"
            Case $GC_I_MAP_ID_GATE_OF_PAIN_OUTPOST
                Return "M16_GateOfPain"
            Case $GC_I_MAP_ID_GATE_OF_MADNESS_OUTPOST
                Return "M17_GateOfMadness"
            Case $GC_I_MAP_ID_ABADDONS_GATE_OUTPOST
                Return "M18_AbaddonsGate"
            Case Else
                Return ""
        EndSwitch
    EndIf
EndFunc
Func Quests_AcceptForCurrentMission()
    Switch $g_currentMission
        Case "M01_Chahbek"
            Return _Quests_AcceptM01()
        Case "Q_TutorialKormir"
            Return _Quests_TalkToKormir()
        Case "Q_TutorialWalkToChahbek"
            Return _Quests_WalkToChahbekShortcut()
        Case Else
            Out("[Quests] Sin handler específico para " & $g_currentMission & " -- fallback genérico")
            Return Quests_AcceptFromNearestNPC()
    EndSwitch
EndFunc
Func _Quests_WalkToChahbekShortcut()
    Equipment_AutoEquipFirstWeapon()
    Sleep(500)
    Cache_SkillBar()
    Local $sbar = "[Quests Tutorial Walk] Skill bar:"
    For $slot = 1 To 8
        Local $skillId = Skill_GetSkillbarInfo($slot, "SkillID", 0)
        $sbar &= " s" & $slot & "=" & $skillId
    Next
    Out($sbar)
    Local $questId = 677   
    Local $markerX = Quest_GetQuestInfo($questId, "MarkerX")
    Local $markerY = Quest_GetQuestInfo($questId, "MarkerY")
    If $markerX = 0 And $markerY = 0 Then
        Out("[Quests Tutorial Walk] FAIL Quest ID " & $questId & " no encontrada o sin marker (probar otro quest ID)")
        Return False
    EndIf
    Out("[Quests Tutorial Walk] Marker quest " & $questId & " coords=(" & Round($markerX, 0) & "," & Round($markerY, 0) & ")")
    Local $oldMap = Map_GetMapID()
    Local $tWalk = TimerInit()
    Local $npc = 0
    While Not Bot_ShouldStop() And TimerDiff($tWalk) < 150000 And $npc = 0
        Local $curMap = Map_GetMapID()
        If $curMap <> $oldMap And $curMap <> 0 Then
            Out("[Quests Tutorial Walk] Mapa cambiado " & $oldMap & " -> " & $curMap & " durante walk (ya cruzado)")
            Return True
        EndIf
        $markerX = Quest_GetQuestInfo($questId, "MarkerX")
        $markerY = Quest_GetQuestInfo($questId, "MarkerY")
        If $markerX <> 0 And $markerY <> 0 Then
            Travel_NavigateNoCombat($markerX, $markerY, 45000)
        EndIf
        $npc = Agent_GetAgentByPlayerNumber(4751)
        If $npc = 0 Then Sleep(1000)
    WEnd
    Out("[Quests Tutorial Walk] Llegada al marker. Ahora hablar con First Spear Jahdugar")
    If $npc = 0 Then
        Out("[Quests Tutorial Walk] FAIL First Spear Jahdugar (model 4751) no cargado en 150s")
        Return False
    EndIf
    Local $npcX = Agent_GetAgentInfo($npc, "X")
    Local $npcY = Agent_GetAgentInfo($npc, "Y")
    Out("[Quests Tutorial Walk] Jahdugar id=" & $npc & " pos=(" & Round($npcX, 0) & "," & Round($npcY, 0) & ")")
    MoveTo($npcX, $npcY, 0, 30)
    Sleep(500)
    Out("[Quests Tutorial Walk] Agent_GoNPC -> abrir dialog window")
    Agent_GoNPC($npc)
    Sleep(3000)
    Out("[Quests Tutorial Walk] Bot_Dialog(0x82A504) -> 'Take the Shortcut' (UpdateQuest 677)")
    Bot_Dialog(0x82A504)
    Sleep(2500)
    Out("[Quests Tutorial Walk] Bot_Dialog(0x84) -> 'Let me know when you are ready'")
    Bot_Dialog(0x84)
    Sleep(2500)
    Out("[Quests Tutorial Walk] Bot_Dialog(0x85) -> 'We are ready.' (cruza a Chahbek)")
    Bot_Dialog(0x85)
    Sleep(5000)   
    Local $newMap = Map_GetMapID()
    If $newMap <> $oldMap Then
        Out("[Quests Tutorial Walk] OK Skip completado: map " & $oldMap & " -> " & $newMap)
        Return True
    EndIf
    Out("[Quests Tutorial Walk] FAIL Tras Jahdugar el mapa no cambió. Sigue en " & $newMap)
    Return False
EndFunc
Func _Quests_GetTutorialStepForMap($mapId)
    Switch $mapId
        Case $GC_I_MAP_ID_ISLAND_OF_SHEHKAH   
            If $g_kormirTalked Then
                Out("[Quests Tutorial] Kormir ya hablada (flag sesión), pasar al siguiente paso")
                Return "Q_TutorialWalkToChahbek"
            EndIf
            Return "Q_TutorialKormir"
        Case Else
            Return ""
    EndSwitch
EndFunc
Func _Quests_TalkToKormir()
    Local $npc = Agent_GetAgentByPlayerNumber(4916)
    If $npc = 0 Then
        Out("[Quests Tutorial] Kormir (4916) no cargada, navegando a (10331, 6387)")
        Pathfinder_MoveTo(10331, 6387, -1, "FilterObstacle", 0, 15000, $g_i_FinisherMode, "")
        Sleep(500)
        $npc = Agent_GetAgentByPlayerNumber(4916)
        If $npc = 0 Then
            Out("[Quests Tutorial] FAIL Kormir aún no cargada tras navegar")
            Return False
        EndIf
    EndIf
    Local $npcX = Agent_GetAgentInfo($npc, "X")
    Local $npcY = Agent_GetAgentInfo($npc, "Y")
    Out("[Quests Tutorial] Kormir id=" & $npc & " pos=(" & Round($npcX, 0) & "," & Round($npcY, 0) & ")")
    If Not ProcessExists("gw.exe") Then
        Out("[Quests Tutorial] ABORT: gw.exe no existe antes de GoNPC")
        Return False
    EndIf
    MoveTo($npcX, $npcY, 0, 30)
    Local $oldMap = Map_GetMapID()
    Out("[Quests Tutorial] Agent_GoNPC -> abrir dialog window")
    Agent_GoNPC($npc)
    Sleep(3000)
    Out("[Quests Tutorial] Bot_Dialog(0x82A503) -> 'Take the Shortcut (Skip Tutorial)'")
    Bot_Dialog(0x82A503)
    Sleep(3500)   
    Out("[Quests Tutorial] Bot_Dialog(0x82A501) -> 'I am confident in my abilities' (confirmar skip)")
    Bot_Dialog(0x82A501)
    Sleep(8000)   
    $g_kormirTalked = True
    Out("[Quests Tutorial] OK Skip tutorial dado. Quest 'Make your way to Chahbek Village' activa. Flag g_kormirTalked=True")
    Return True
EndFunc
Func _Quests_AcceptM01()
    If Map_GetMapID() = $GC_I_MAP_ID_CHAHBEK_VILLAGE_OUTPOST _
            And Map_GetInstanceInfo("Type") = $GC_I_MAP_TYPE_EXPLORABLE Then
        Out("[Quests M01] Char ya en mission instance (map=544 type=EXPLORABLE), fase completa")
        Return True
    EndIf
    Local $npc = Agent_GetAgentByPlayerNumber(4751)
    If $npc = 0 Then
        Out("[Quests M01] NPC model 4751 no encontrado, fallback genérico")
        Return Quests_AcceptFromNearestNPC()
    EndIf
    Local $npcX = Agent_GetAgentInfo($npc, "X")
    Local $npcY = Agent_GetAgentInfo($npc, "Y")
    Out("[Quests M01] First Spear Jahdugar id=" & $npc & " pos=(" & Round($npcX, 0) & "," & Round($npcY, 0) & ")")
    MoveTo($npcX, $npcY, 0, 30)
    Sleep(500)
    Agent_ChangeTarget($npc)
    Sleep(200)
    Out("[Quests M01] Agent_GoNPC -> abrir dialog window")
    Agent_GoNPC($npc)
    Sleep(2500)
    Local $logState677 = Quest_GetQuestInfo(677, "LogState")
    Local $alreadyClaimed = ($logState677 = 0 Or $logState677 = -1)
    Out("[Quests M01] Quest 677 LogState=" & $logState677 & " alreadyClaimed=" & $alreadyClaimed)
    If Not $alreadyClaimed Then
        Out("[Quests M01] Ui_RewardQuest(677) -> cobrar reward")
        Ui_RewardQuest(677)
        Sleep(4000)
        Local $logStateNow = Quest_GetQuestInfo(677, "LogState")
        If Not ($logStateNow = 0 Or $logStateNow = -1) Then
            Out("[Quests M01] WARN Reward(677) no aplicado (LogState=" & $logStateNow & ") - retry con re-approach")
            MoveTo($npcX, $npcY, 0, 30)
            Sleep(500)
            Agent_ChangeTarget($npc)
            Sleep(200)
            Agent_GoNPC($npc)
            Sleep(2500)
            Ui_RewardQuest(677)
            Sleep(4000)
            $logStateNow = Quest_GetQuestInfo(677, "LogState")
            If Not ($logStateNow = 0 Or $logStateNow = -1) Then
                Out("[Quests M01] FAIL Reward(677) tras retry (LogState=" & $logStateNow & ")")
                Return False
            EndIf
        EndIf
        Out("[Quests M01] OK Reward(677) aplicado, Koss debe estar unlocked")
    Else
        Out("[Quests M01] Reward 677 ya cobrado previamente, skipear")
    EndIf
    Local $heroesNow = Party_GetMyPartyInfo("ArrayHeroPartyMemberSize")
    Local $henchNow = Party_GetMyPartyInfo("ArrayHenchmanPartyMemberSize")
    Local $partyTotal = 1 + $heroesNow + $henchNow
    Local $maxPartySize = Map_GetAreaInfo(Map_GetMapID(), "MaxPartySize")
    Out("[Quests M01] Party actual=" & $partyTotal & "/" & $maxPartySize & " (heroes=" & $heroesNow & " hench=" & $henchNow & ")")
    If $partyTotal < $maxPartySize Then
        Out("[Quests M01] Party incompleto -> Add Koss + henchmen")
        If $heroesNow = 0 Then
            Heroes_Add("Koss")
            Sleep(1500)
            Local $heroesAfter = Party_GetMyPartyInfo("ArrayHeroPartyMemberSize")
            If $heroesAfter = 0 Then
                Out("[Quests M01] WARN Heroes_Add(Koss) no añadio hero al party - quest 677 puede no estar realmente cobrada")
            Else
                Out("[Quests M01] OK Koss añadido al party (heroes=" & $heroesAfter & ") -> Guard")
                Party_SetHeroAggression(1, 1)   
            EndIf
        EndIf
        Party_FillWithHenchmen()
        Sleep(1500)
    Else
        Out("[Quests M01] Party ya completo, skipear setup")
    EndIf
    Out("[Quests M01] Bot_Dialog(0x81) -> 'We must hurry and save Chahbek'")
    Bot_Dialog(0x81)
    Sleep(3500)   
    Out("[Quests M01] Bot_Dialog(0x84) -> 'We are ready' (entrar a mission)")
    Bot_Dialog(0x84)
    Local $t = TimerInit()
    While Not Bot_ShouldStop() And Not (Map_GetMapID() = $GC_I_MAP_ID_CHAHBEK_VILLAGE_OUTPOST _
            And Map_GetInstanceInfo("Type") = $GC_I_MAP_TYPE_EXPLORABLE) _
            And TimerDiff($t) < 20000
        Sleep(500)
    WEnd
    Local $mapNow = Map_GetMapID()
    Local $typeNow = Map_GetInstanceInfo("Type")
    Out("[Quests M01] Tras esperar transición: Map=" & $mapNow & " Type=" & $typeNow & " (esperado map=544 type=1 EXPLORABLE) elapsed=" & Round(TimerDiff($t)/1000, 1) & "s")
    Return ($mapNow = $GC_I_MAP_ID_CHAHBEK_VILLAGE_OUTPOST And $typeNow = $GC_I_MAP_TYPE_EXPLORABLE)
EndFunc
Func Quests_AcceptFromNearestNPC()
    Local $npc = GetNearestNPCToAgent(-2, 1250, $GC_I_AGENT_TYPE_LIVING, 1, "NPCFilter")
    If $npc = 0 Then
        Out("[Quests] No NPC nearby to accept quest from")
        Return False
    EndIf
    Out("[Quests] Talking to nearest NPC " & $npc)
    Agent_GoNPC($npc)
    Sleep(800)
    Bot_Dialog(0x84)
    Sleep(300)
    Bot_Dialog(0x85)
    Sleep(300)
    Return True
EndFunc
Func Quests_Talk1Dialog($wpX, $wpY, $d1 = 0x81, $npcModelID = 0)
    If Not _Quests_NavAndOpenDialog($wpX, $wpY, $npcModelID) Then Return False
    _Quests_Dialog($d1)
    Return True
EndFunc
Func Quests_Talk2Dialogs($wpX, $wpY, $d1 = 0x81, $d2 = 0x84, $npcModelID = 0)
    If Not _Quests_NavAndOpenDialog($wpX, $wpY, $npcModelID) Then Return False
    _Quests_Dialog($d1)
    _Quests_Dialog($d2)
    Return True
EndFunc
Func Quests_Talk3Dialogs($wpX, $wpY, $d1 = 0x81, $d2 = 0x84, $d3 = 0x85, $npcModelID = 0)
    If Not _Quests_NavAndOpenDialog($wpX, $wpY, $npcModelID) Then Return False
    _Quests_Dialog($d1)
    _Quests_Dialog($d2)
    _Quests_Dialog($d3)
    Return True
EndFunc
Func Quests_TalkAcceptQuest($wpX, $wpY, $questID, $npcModelID = 0)
    If Not _Quests_NavAndOpenDialog($wpX, $wpY, $npcModelID) Then Return False
    Out("[Quests] Ui_AcceptQuest(" & $questID & " / 0x" & Hex($questID, 3) & ")")
    Ui_AcceptQuest($questID)
    Sleep(2500)
    If Not Agent_HasQuest($questID) Then
        Out("[Quests] FAIL: Ui_AcceptQuest(0x" & Hex($questID, 3) & ") enviado pero Agent_HasQuest=" & Agent_HasQuest($questID))
        Return False
    EndIf
    Out("[Quests] OK quest 0x" & Hex($questID, 3) & " activa tras AcceptQuest")
    Return True
EndFunc
Func Quests_TalkAcceptQuestWithAbout($wpX, $wpY, $questID, $npcModelID = 0, $sName = "")
    For $try = 1 To 3
        If Not _Quests_NavAndOpenDialog($wpX, $wpY, $npcModelID, $sName) Then
            Out("[Quests] AcceptWithAbout intento " & $try & "/3 fail nav/dialog")
            ContinueLoop
        EndIf
        _Quests_ForceReframeDialog($wpX, $wpY, $npcModelID, $sName)
        Out("[Quests] Ui_AboutQuest(" & $questID & " / 0x" & Hex($questID, 3) & ") -> abrir quest offer (try " & $try & ")")
        Ui_AboutQuest($questID)
        Sleep(1500)
        Out("[Quests] Ui_AcceptQuest(" & $questID & " / 0x" & Hex($questID, 3) & ")")
        Ui_AcceptQuest($questID)
        Sleep(3000)
        Local $logState = Quest_GetQuestInfo($questID, "LogState")
        If $logState > 0 Then
            Out("[Quests] OK quest 0x" & Hex($questID, 3) & " activa (LogState=" & $logState & ") en try " & $try)
            Return True
        EndIf
        Out("[Quests] FAIL intento " & $try & ": quest 0x" & Hex($questID, 3) & " NO en log (LogState=" & $logState & ") - retry")
        Sleep(2000)
    Next
    Out("[Quests] FAIL: quest 0x" & Hex($questID, 3) & " NO aceptada tras 3 intentos")
    Return False
EndFunc
Func _Quests_ForceReframeDialog($wpX, $wpY, $npcModelID = 0, $sName = "")
    If $npcModelID <= 0 And $sName = "" Then Return
    Local $npc = 0
    If $npcModelID > 0 Then $npc = _Quests_FindNearestNPCByModelToWp($npcModelID, $wpX, $wpY, $sName)
    If $npc = 0 And $sName <> "" Then $npc = _Quests_FindNPCByName($sName, $wpX, $wpY, 1500)
    If $npc = 0 Then
        Out("[Quests] ForceReframe: NPC model=" & $npcModelID & " no presente")
        Return
    EndIf
    Local $nX = Agent_GetAgentInfo($npc, "X")
    Local $nY = Agent_GetAgentInfo($npc, "Y")
    Local $dNow = Agent_GetDistance(-2, $npc)
    Out("[Quests] ForceReframe: NPC id=" & $npc & " a " & Round($dNow) & "u -> reencuadrar")
    MoveTo($nX, $nY, 0, 50)
    Sleep(600)
    Agent_ChangeTarget($npc)
    Sleep(300)
    Agent_GoNPC($npc)
    Sleep(1800)
    Local $tRef = TimerInit()
    While TimerDiff($tRef) < 12000
        If Agent_GetDistance(-2, $npc) < 120 Then ExitLoop
        Sleep(250)
        If TimerDiff($tRef) >= 6000 Then
            Agent_GoNPC($npc)
            $tRef = TimerInit()
        EndIf
    WEnd
    Sleep(1200)
EndFunc
Func Quests_TalkDialogsArray($wpX, $wpY, ByRef $dialogs, $npcModelID = 0)
    If Not _Quests_NavAndOpenDialog($wpX, $wpY, $npcModelID) Then Return False
    For $i = 0 To UBound($dialogs) - 1
        _Quests_Dialog($dialogs[$i])
    Next
    Return True
EndFunc
Func Quests_TalkUpdateQuest($wpX, $wpY, $questID, $npcModelID = 0, $sName = "")
    If Not _Quests_NavAndOpenDialog($wpX, $wpY, $npcModelID, $sName) Then Return False
    Out("[Quests] Ui_UpdateQuest(" & $questID & " / 0x" & Hex($questID, 3) & ")")
    Ui_UpdateQuest($questID)
    Sleep(2500)
    Return True
EndFunc
Func _Quests_FindNearestNPCByModelToWp($modelId, $wpX, $wpY, $sName = "")
    Local $agents = Agent_GetAgentArray($GC_I_AGENT_TYPE_LIVING)
    If Not IsArray($agents) Or $agents[0] = 0 Then Return 0
    Local $bestId = 0, $bestDist = 999999
    Local $bestNameId = 0, $bestNameDist = 999999
    For $i = 1 To $agents[0]
        Local $ptr = $agents[$i]
        If $ptr = 0 Then ContinueLoop
        If Agent_GetAgentInfo($ptr, "PlayerNumber") <> $modelId Then ContinueLoop
        Local $aX = Agent_GetAgentInfo($ptr, "X")
        Local $aY = Agent_GetAgentInfo($ptr, "Y")
        Local $dist = Sqrt(($aX - $wpX)^2 + ($aY - $wpY)^2)
        If $dist < $bestDist Then
            $bestDist = $dist
            $bestId = Agent_GetAgentInfo($ptr, "ID")
        EndIf
        If $sName <> "" And StringInStr(Agent_GetAgentInfo($ptr, "Name"), $sName, 2) Then
            If $dist < $bestNameDist Then
                $bestNameDist = $dist
                $bestNameId = Agent_GetAgentInfo($ptr, "ID")
            EndIf
        EndIf
    Next
    If $sName <> "" Then
        If $bestNameId <> 0 Then
            If $bestId <> 0 And $bestId <> $bestNameId Then
                Out("[Quests] homonimo model=" & $modelId & " a " & Round($bestDist) & "u descartado (se busca '" & $sName & "' a " & Round($bestNameDist) & "u)")
            EndIf
            Return $bestNameId
        EndIf
        Return 0
    EndIf
    Return $bestId
EndFunc
Func _Quests_FindNPCByName($sName, $wpX, $wpY, $maxDist = 800)
    Local $agents = Agent_GetAgentArray($GC_I_AGENT_TYPE_LIVING)
    If Not IsArray($agents) Or $agents[0] = 0 Then Return 0
    Local $bestId = 0, $bestDist = 999999
    For $i = 1 To $agents[0]
        Local $ptr = $agents[$i]
        If $ptr = 0 Then ContinueLoop
        If Not StringInStr(Agent_GetAgentInfo($ptr, "Name"), $sName, 2) Then ContinueLoop
        Local $dist = Sqrt((Agent_GetAgentInfo($ptr, "X") - $wpX)^2 + (Agent_GetAgentInfo($ptr, "Y") - $wpY)^2)
        If $dist < $bestDist And $dist <= $maxDist Then
            $bestDist = $dist
            $bestId = Agent_GetAgentInfo($ptr, "ID")
        EndIf
    Next
    Return $bestId
EndFunc
Func _Quests_NavAndOpenDialog($wpX, $wpY, $npcModelID = 0, $sName = "")
    Out("[Quests] NavAndOpenDialog navegar a (" & $wpX & "," & $wpY & ")" & ($npcModelID > 0 ? " npcModel=" & $npcModelID : "") & ($sName <> "" ? " nombre='" & $sName & "'" : ""))
    If $npcModelID > 0 Then
        Local $npcFast = _Quests_FindNearestNPCByModelToWp($npcModelID, $wpX, $wpY, $sName)
        If $npcFast <> 0 And $sName <> "" And Not StringInStr(Agent_GetAgentInfo($npcFast, "Name"), $sName, 2) Then
            Out("[Quests] FAST PATH SKIP: el NPC no se llama '" & $sName & "' -> ruta normal")
            $npcFast = 0
        EndIf
        If $npcFast <> 0 Then
            Local $fX = Agent_GetAgentInfo($npcFast, "X")
            Local $fY = Agent_GetAgentInfo($npcFast, "Y")
            Local $distFast = Agent_GetDistance(-2, $npcFast)
            Local $distToWp = Sqrt(($fX - $wpX)^2 + ($fY - $wpY)^2)
            If $distToWp > 1000 Then
                Out("[Quests] FAST PATH SKIP: NPC model=" & $npcModelID & " mas cercano al waypoint esta en (" & Round($fX) & "," & Round($fY) & ") a " & Round($distToWp) & "u - usar ruta normal")
            ElseIf $distFast > 0 And $distFast < 1500 Then
                If Not ProcessExists("gw.exe") Then
                    Out("[Quests] FAST PATH ABORT: gw.exe ya no existe")
                    Return False
                EndIf
                Out("[Quests] FAST PATH NPC model=" & $npcModelID & " ya a " & Round($distFast) & "u del char -> GoNPC")
                Local $tFastArr = TimerInit(), $tReFast = TimerInit()
                Agent_GoNPC($npcFast)
                While Not Bot_ShouldStop() And TimerDiff($tFastArr) < 45000
                    If Agent_GetDistance(-2, $npcFast) < 250 Then ExitLoop
                    Sleep(250)
                    If TimerDiff($tReFast) >= 4000 Then
                        Agent_GoNPC($npcFast)
                        $tReFast = TimerInit()
                    EndIf
                WEnd
                Sleep(1000)
                Out("[Quests] FAST PATH llegada: " & Round(Agent_GetDistance(-2, $npcFast)) & "u del NPC")
                Return True
            EndIf
        EndIf
    EndIf
    If Map_GetInstanceInfo("Type") = $GC_I_MAP_TYPE_OUTPOST Then
        Map_Move($wpX, $wpY, 0)
        Local $tWalk = TimerInit()
        Local $tReemit = TimerInit()
        While Not Bot_ShouldStop() And TimerDiff($tWalk) < 25000
            Local $wX = Agent_GetAgentInfo(-2, "X")
            Local $wY = Agent_GetAgentInfo(-2, "Y")
            If Sqrt(($wX - $wpX)^2 + ($wY - $wpY)^2) < 500 Then ExitLoop
            Sleep(200)
            If TimerDiff($tReemit) >= 3000 Then
                Map_Move($wpX, $wpY, 0)
                $tReemit = TimerInit()
            EndIf
        WEnd
    Else
        Local $rescuePrev = $g_GE_RescueEnabled
        $g_GE_RescueEnabled = False
        GameEvents_ResetStuck()
        Local $tNavExpl = TimerInit()
        Local $tReNavExpl = TimerInit()
        Local $wpDist = 999999
        While Not Bot_ShouldStop() And TimerDiff($tNavExpl) < 120000
            Local $wjx = Agent_GetAgentInfo(-2, "X")
            Local $wjy = Agent_GetAgentInfo(-2, "Y")
            $wpDist = Sqrt(($wjx - $wpX)^2 + ($wjy - $wpY)^2)
            If $wpDist < 600 Then ExitLoop
            If TimerDiff($tReNavExpl) >= 5000 Then
                MoveToFollowPath($wpX, $wpY, 0, "")
                $tReNavExpl = TimerInit()
            EndIf
            Sleep(500)
        WEnd
        Out("[Quests] MoveToFollowPath tras " & Round(TimerDiff($tNavExpl)/1000, 1) & "s: " & Round($wpDist) & "u del waypoint")
        $g_GE_RescueEnabled = $rescuePrev
        GameEvents_ResetStuck()
    EndIf
    Sleep(1500)
    Local $npc
    If $npcModelID > 0 Then
        Local $tFind = TimerInit()
        While TimerDiff($tFind) < 8000
            $npc = _Quests_FindNearestNPCByModelToWp($npcModelID, $wpX, $wpY, $sName)
            If $npc <> 0 Then
                Local $nfX = Agent_GetAgentInfo($npc, "X")
                Local $nfY = Agent_GetAgentInfo($npc, "Y")
                Local $nfDistWp = Sqrt(($nfX - $wpX)^2 + ($nfY - $wpY)^2)
                If $nfDistWp <= 800 Then ExitLoop
                Out("[Quests] NPC model=" & $npcModelID & " en (" & Round($nfX) & "," & Round($nfY) & ") a " & Round($nfDistWp) & "u del waypoint -> esperando al NPC correcto")
                $npc = 0
            EndIf
            Sleep(500)
        WEnd
        If $npc = 0 Then
            Out("[Quests] No NPC con model=" & $npcModelID & " tras retry -> fallback quest-giver cercano al waypoint")
            Local $tFB = TimerInit()
            While TimerDiff($tFB) < 5000 And $npc = 0
                $npc = GetNearestQuestGiver(6000)
                If $npc <> 0 Then
                    Local $fbX = Agent_GetAgentInfo($npc, "X")
                    Local $fbY = Agent_GetAgentInfo($npc, "Y")
                    Local $fbD = Sqrt(($fbX - $wpX)^2 + ($fbY - $wpY)^2)
                    If $fbD > 800 Then
                        Out("[Quests] Fallback quest-giver en (" & Round($fbX) & "," & Round($fbY) & ") a " & Round($fbD) & "u del waypoint -> descartar, seguir esperando")
                        $npc = 0
                    ElseIf $sName <> "" And Not StringInStr(Agent_GetAgentInfo($npc, "Name"), $sName, 2) Then
                        Out("[Quests] Fallback quest-giver '" & Agent_GetAgentInfo($npc, "Name") & "' no es '" & $sName & "' -> descartar (evita Yapono), seguir esperando")
                        $npc = 0
                    EndIf
                EndIf
                If $npc = 0 Then Sleep(500)
            WEnd
            If $npc = 0 And $sName <> "" Then
                $npc = _Quests_FindNPCByName($sName, $wpX, $wpY, 800)
                If $npc <> 0 Then Out("[Quests] Fallback por NOMBRE: '" & $sName & "' id=" & $npc)
            EndIf
            If $npc = 0 Then
                Out("[Quests] No NPC con model=" & $npcModelID & " en el mapa tras retry + fallback")
                Return False
            EndIf
            Out("[Quests] Fallback: quest-giver id=" & $npc & " cerca del waypoint")
        EndIf
        If TimerDiff($tFind) > 500 Then
            Out("[Quests] NPC model=" & $npcModelID & " aparecio tras " & Round(TimerDiff($tFind)/1000, 1) & "s de espera")
        EndIf
    Else
        $npc = GetNearestQuestGiver(1500)
        If $npc = 0 Then
            Out("[Quests] No quest-giver (allegiance NPC) en 1500u")
            Return False
        EndIf
    EndIf
    Local $nX = Agent_GetAgentInfo($npc, "X")
    Local $nY = Agent_GetAgentInfo($npc, "Y")
    Local $nModel = Agent_GetAgentInfo($npc, "PlayerNumber")
    Out("[Quests] NPC seleccionado id=" & $npc & " model=" & $nModel & " pos=(" & Round($nX, 0) & "," & Round($nY, 0) & ")")
    Local $goRescuePrev = $g_GE_RescueEnabled
    $g_GE_RescueEnabled = False
    GameEvents_ResetStuck()
    Local $tGo = TimerInit(), $tReGo = TimerInit()
    Agent_GoNPC($npc)
    While Not Bot_ShouldStop() And TimerDiff($tGo) < 45000
        Local $dGo = Agent_GetDistance(-2, $npc)
        If $dGo < 250 Then ExitLoop
        Sleep(250)
        If TimerDiff($tReGo) >= 4000 Then
            Agent_GoNPC($npc)
            $tReGo = TimerInit()
        EndIf
    WEnd
    $g_GE_RescueEnabled = $goRescuePrev
    GameEvents_ResetStuck()
    Local $dFin = Agent_GetDistance(-2, $npc)
    Out("[Quests] tras GoNPC char a " & Round($dFin) & "u del NPC")
    If $dFin > 600 Then
        Out("[Quests] GoNPC no logro acercar al char (>600u) - FAIL limpio para reintento del caller")
        Return False
    EndIf
    Sleep(1000)
    Return True
EndFunc
Func _Quests_Dialog($code)
    Out("[Quests] Bot_Dialog(0x" & Hex($code, 2) & ")")
    Bot_Dialog($code)
    Sleep(2500)
EndFunc
Func Quests_AcceptByDialog($npcLocation_x, $npcLocation_y, $dialogId)
    MoveToFollowPath($npcLocation_x, $npcLocation_y)
    Local $npc = GetNearestNPCToAgent(-2, 1250, $GC_I_AGENT_TYPE_LIVING, 1, "NPCFilter")
    If $npc = 0 Then Return False
    Agent_GoNPC($npc)
    Sleep(500)
    Bot_Dialog($dialogId)
    Sleep(300)
    Return True
EndFunc
Func Quests_AcceptReward($npcLocation_x, $npcLocation_y, $rewardDialogId)
    MoveTo($npcLocation_x, $npcLocation_y)
    Local $npc = GetNearestNPCToAgent(-2, 1250, $GC_I_AGENT_TYPE_LIVING, 1, "NPCFilter")
    If $npc = 0 Then Return False
    Agent_GoNPC($npc)
    Sleep(500)
    Bot_Dialog($rewardDialogId)
    Sleep(300)
    Return True
EndFunc
Func Quests_WaitForComplete($questId, $timeoutMs = 60000)
    If $questId = 0 Then Return False
    Local $t0 = TimerInit()
    While Not Bot_ShouldStop() And TimerDiff($t0) < $timeoutMs
        If Quest_GetQuestInfo($questId, 'IsCompleted') Then Return True
        Sleep(500)
    WEnd
    Return False
EndFunc
Func _Quests_StorylineList()
    Local $list[18][4] = [ _
        ["M01_Chahbek",          $GC_I_QUEST_ID_INTOCHAHBEKVILLAGE, $GC_I_MAP_ID_CHAHBEK_VILLAGE_OUTPOST,        $GC_I_MAP_ID_CHAHBEK_VILLAGE_MISSION],        _
        ["M02_Jokanur",          0,                                  $GC_I_MAP_ID_JOKANUR_DIGGINGS_OUTPOST,        $GC_I_MAP_ID_JOKANUR_DIGGINGS_MISSION],        _
        ["M03_Blacktide",        0,                                  $GC_I_MAP_ID_BLACKTIDE_DEN_OUTPOST,           $GC_I_MAP_ID_BLACKTIDE_DEN_MISSION],           _
        ["M04_ConsulateDocks",   0,                                  $GC_I_MAP_ID_CONSULATE_DOCKS_OUTPOST,         $GC_I_MAP_ID_CONSULATE_DOCKS_MISSION],         _
        ["M05_VentaCemetery",    0,                                  $GC_I_MAP_ID_VENTA_CEMETERY_OUTPOST,          $GC_I_MAP_ID_VENTA_CEMETERY_OUTPOST],          _
        ["M06_Kodonur",          0,                                  $GC_I_MAP_ID_KODONUR_CROSSROADS_OUTPOST,      $GC_I_MAP_ID_KODONUR_CROSSROADS_MISSION],      _
        ["M07_PogahnPassage",    0,                                  $GC_I_MAP_ID_POGAHN_PASSAGE_OUTPOST,          $GC_I_MAP_ID_POGAHN_PASSAGE_MISSION],          _
        ["M08_RilohnOrModdok",   0,                                  $GC_I_MAP_ID_RILOHN_REFUGE_OUTPOST,           $GC_I_MAP_ID_RILOHN_REFUGE_MISSION],           _
        ["M09_Tihark",           0,                                  $GC_I_MAP_ID_TIHARK_ORCHARD_OUTPOST,          $GC_I_MAP_ID_TIHARK_ORCHARD_MISSION],          _
        ["M10_Dasha",            0,                                  $GC_I_MAP_ID_DASHA_VESTIBULE_OUTPOST,         $GC_I_MAP_ID_DASHA_VESTIBULE_OUTPOST],         _
        ["M11_GrandCourt",       0,                                  $GC_I_MAP_ID_GRAND_COURT_OF_SEBELKEH_OUTPOST, $GC_I_MAP_ID_GRAND_COURT_OF_SEBELKEH_MISSION], _
        ["M12_JennurOrDzagonur", 0,                                  $GC_I_MAP_ID_JENNURS_HORDE_OUTPOST,           $GC_I_MAP_ID_JENNURS_HORDE_MISSION],           _
        ["M13_NunduBay",         0,                                  $GC_I_MAP_ID_NUNDU_BAY_OUTPOST,               $GC_I_MAP_ID_NUNDU_BAY_MISSION],               _
        ["M14_GateOfDesolation", 0,                                  $GC_I_MAP_ID_GATE_OF_DESOLATION_OUTPOST,      $GC_I_MAP_ID_GATE_OF_DESOLATION_OUTPOST],      _
        ["M15_RuinsOfMorah",     0,                                  $GC_I_MAP_ID_RUINS_OF_MORAH_OUTPOST,          $GC_I_MAP_ID_RUINS_OF_MORAH_MISSION],          _
        ["M16_GateOfPain",       0,                                  $GC_I_MAP_ID_GATE_OF_PAIN_OUTPOST,            $GC_I_MAP_ID_GATE_OF_PAIN_OUTPOST],            _
        ["M17_GateOfMadness",    0,                                  $GC_I_MAP_ID_GATE_OF_MADNESS_OUTPOST,         $GC_I_MAP_ID_GATE_OF_MADNESS_MISSION],         _
        ["M18_AbaddonsGate",     0,                                  $GC_I_MAP_ID_ABADDONS_GATE_OUTPOST,           $GC_I_MAP_ID_ABADDONS_GATE_MISSION]            _
    ]
    Return $list
EndFunc