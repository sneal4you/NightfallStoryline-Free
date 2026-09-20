#include-once
Global $g_aiKossAttrs[3] = [$GC_I_ATTRIBUTE_SWORDSMANSHIP, $GC_I_ATTRIBUTE_STRENGTH, $GC_I_ATTRIBUTE_TACTICS]
Global $g_aiDunkoroAttrs[3] = [$GC_I_ATTRIBUTE_HEALING_PRAYERS, $GC_I_ATTRIBUTE_DIVINE_FAVOR, $GC_I_ATTRIBUTE_PROTECTION_PRAYERS]
Global $g_aiMelonniAttrs[3] = [$GC_I_ATTRIBUTE_SCYTHE_MASTERY, $GC_I_ATTRIBUTE_MYSTICISM, $GC_I_ATTRIBUTE_TACTICS]
Global $g_aiTahlkoraAttrs[3] = [$GC_I_ATTRIBUTE_PROTECTION_PRAYERS, $GC_I_ATTRIBUTE_HEALING_PRAYERS, $GC_I_ATTRIBUTE_DIVINE_FAVOR]
Global $g_aiZhedAttrs[2] = [$GC_I_ATTRIBUTE_FIRE_MAGIC, $GC_I_ATTRIBUTE_ENERGY_STORAGE]
Global $g_aiMoWAttrs[0] = []
Global $g_heroesNightfall[14][3] = [ _
    ["Koss",             "Warrior",  $GC_I_HERO_ID_KOSS], _
    ["Dunkoro",          "Monk",     $GC_I_HERO_ID_DUNKORO], _
    ["Melonni",          "Dervish",  $GC_I_HERO_ID_MELONNI], _
    ["AcolyteJin",       "Ranger",   $GC_I_HERO_ID_ACOLYTE_JIN], _
    ["Tahlkora",         "Monk",     $GC_I_HERO_ID_TAHLKORA], _
    ["MasterOfWhispers", "Necro",    $GC_I_HERO_ID_MASTER_OF_WHISPERS], _
    ["AcolyteSousuke",   "Ele",      $GC_I_HERO_ID_ACOLYTE_SOUSUKE], _
    ["MargridTheSly",    "Ranger",   $GC_I_HERO_ID_MARGRID_THE_SLY], _
    ["GeneralMorgahn",   "Paragon",  $GC_I_HERO_ID_GENERAL_MORGAHN], _
    ["ZhedShadowhoof",   "Ele",      $GC_I_HERO_ID_ZHED_SHADOWHOOF], _
    ["Olias",            "Necro",    $GC_I_HERO_ID_OLIAS], _
    ["Razah",            "Rit",      $GC_I_HERO_ID_RAZAH], _
    ["Norgu",            "Mesmer",   $GC_I_HERO_ID_NORGU], _
    ["Kahmu",            "Dervish",  $GC_I_HERO_ID_KAHMU] _
]
Func Heroes_SetupForMission($missionName)
    Local $teamKey = _Heroes_GetTeamKeyForMission($missionName)
    Local $teamList = IniRead(@ScriptDir & "\config.ini", "Heroes", $teamKey, "")
    Out("[Heroes] Setup for " & $missionName & " (key=" & $teamKey & ", list='" & $teamList & "')")
    If $teamList = "" Then Return True   
    Local $heroes = StringSplit($teamList, ",", 2)
    For $i = 0 To UBound($heroes) - 1
        Local $name = StringStripWS($heroes[$i], 3)
        If $name <> "" Then
            Heroes_Add($name)
            Heroes_LoadBuild($name)
        EndIf
    Next
    Return True
EndFunc
Func Heroes_Add($heroName)
    Local $heroId = _Heroes_GetIdByName($heroName)
    If $heroId = 0 Then
        Out("[Heroes] Unknown hero name: " & $heroName)
        Return False
    EndIf
    Out("[Heroes] Adding hero " & $heroName & " (id=" & $heroId & ")")
    Party_AddHero($heroId)
    Sleep(500)
    Return True
EndFunc
Func _Heroes_GetIdByName($heroName)
    For $i = 0 To UBound($g_heroesNightfall) - 1
        If $g_heroesNightfall[$i][0] = $heroName Then Return $g_heroesNightfall[$i][2]
    Next
    Return 0
EndFunc
Func Heroes_LoadBuild($heroName)
    Return False
EndFunc
Func Heroes_RefreshUnlocked()
    Return True
EndFunc
Func Party_FillWithHenchmen()
    Local $maxSize = Map_GetAreaInfo(Map_GetMapID(), "MaxPartySize")
    If $maxSize <= 1 Then
        Out("[Party] MaxPartySize=" & $maxSize & " -> outpost no acepta party, skip henchmen")
        Return True
    EndIf
    Local $henchInParty = Party_GetMyPartyInfo("ArrayHenchmanPartyMemberSize")
    Local $heroesInParty = Party_GetMyPartyInfo("ArrayHeroPartyMemberSize")
    Local $currentSize = 1 + $henchInParty + $heroesInParty   
    Local $toAdd = $maxSize - $currentSize
    If $toAdd <= 0 Then Return True
    Local $henchModels = _Party_GetHenchmenModelsForMap(Map_GetMapID())
    Local $agents = Agent_GetAgentArray($GC_I_AGENT_TYPE_LIVING)
    If Not IsArray($agents) Or $agents[0] = 0 Then
        Out("[Party] Agent array LIVING vacío")
        Return False
    EndIf
    Local $added = 0
    For $m = 0 To UBound($henchModels) - 1
        If $added >= $toAdd Then ExitLoop
        For $i = 1 To $agents[0]
            If $agents[$i] = 0 Then ContinueLoop
            If Agent_GetAgentInfo($agents[$i], "PlayerNumber") <> $henchModels[$m] Then ContinueLoop
            If _AutoParty_IsHenchModelInParty($henchModels[$m]) Then ExitLoop
            Local $aidP = Agent_GetAgentInfo($agents[$i], "ID")
            Out("[Party] Añadiendo henchman (prioridad) agent_id=" & $aidP & " model=" & $henchModels[$m])
            Ui_AddNPC($aidP)
            Sleep(700)
            $added += 1
            ExitLoop
        Next
    Next
    For $i = 1 To $agents[0]
        If $added >= $toAdd Then ExitLoop
        Local $agentPtr = $agents[$i]
        If $agentPtr = 0 Then ContinueLoop
        Local $isHench = Agent_GetAgentInfo($agentPtr, "IsHenchman")
        Local $model = Agent_GetAgentInfo($agentPtr, "PlayerNumber")
        If Not $isHench Then ContinueLoop
        If _AutoParty_IsHenchModelInParty($model) Then ContinueLoop
        Local $agentId = Agent_GetAgentInfo($agentPtr, "ID")
        Local $level = Agent_GetAgentInfo($agentPtr, "Level")
        Out("[Party] Añadiendo henchman agent_id=" & $agentId & " model=" & $model & " level=" & $level)
        Ui_AddNPC($agentId)
        Sleep(700)
        $added += 1
    Next
    If $added > 0 Then
        Out("[Party] Añadidos " & $added & " henchmen (party " & ($currentSize + $added) & "/" & $maxSize & ")")
    EndIf
    Return ($added > 0)
EndFunc
Func _Party_GetHenchmenModelsForMap($mapId)
    Local $empty[0]
    Switch $mapId
        Case $GC_I_MAP_ID_CHAMPIONS_DAWN   
            Local $list479[3] = [4586, 4588, 4593]
            Return $list479
        Case $GC_I_MAP_ID_CHAHBEK_VILLAGE_OUTPOST   
            Local $list544[2] = [4585, 4582]   
            Return $list544
        Case $GC_I_MAP_ID_THE_ASTRALARIUM            
            Local $list502[7] = [4586, 4591, 4592, 4587, 4588, 4589, 4590]
            Return $list502
        Case 491   
            Local $list491[1] = [4593]   
            Return $list491
        Case 493   
            Local $list493[4] = [4619, 4614, 4617, 4623]
            Return $list493
        Case $GC_I_MAP_ID_SUNSPEAR_SANCTUARY   
            Local $list387[10] = [4628, 4626, 4624, 4633, 4632, 4629, 4631, 4630, 4627, 4625]
            Return $list387
        Case 424   
            Local $list424[2] = [4628, 4626]   
            Return $list424
        Case 554   
            Local $list554[6] = [4628, 4626, 4627, 4625, 4633, 4631]
            Return $list554
        Case $GC_I_MAP_ID_YOHLON_HAVEN   
            Local $list381[10] = [4628, 4626, 4624, 4633, 4632, 4629, 4631, 4630, 4627, 4625]
            Return $list381
        Case $GC_I_MAP_ID_BEKNUR_HARBOR_2   
            Local $list487[4] = [4600, 4601, 4602, 4606]
            Return $list487
        Case $GC_I_MAP_ID_KODLONU_HAMLET   
            Local $list489[4] = [4609, 4607, 4613, 4608]
            Return $list489
        Case $GC_I_MAP_ID_RUINS_OF_MORAH_OUTPOST   
            Local $list480[3] = [4626, 4624, 4633]
            Return $list480
        Case 495   
            Local $list495[10] = [4626, 4629, 4627, 4609, 4606, 4588, 4625, 4632, 4631, 4630]
            Return $list495
        Case 450, 469, 473, 494, 496   
            Local $list450[12] = [4628, 4626, 4629, 4633, 4625, 4632, 4624, 4631, 4630, 4627, 4593, 4602] 
            Return $list450
        Case 414   
            Local $list414[2] = [4626, 4624]
            Return $list414
        Case $GC_I_MAP_ID_MODDOK_CREVICE_OUTPOST   
            Local $list427[3] = [4626, 4624, 4629]
            Return $list427
        Case $GC_I_MAP_ID_WEHHAN_TERRACES   
            Local $list378[3] = [4626, 4624, 4629]
            Return $list378
    EndSwitch
    Return $empty
EndFunc
Func _Heroes_GetTeamKeyForMission($missionName)
    Switch $missionName
        Case "M01_Chahbek"
            Return "Team_M01"
        Case "M02_Jokanur", "M03_Blacktide"
            Return "Team_Istan"
        Case "M04_ConsulateDocks", "M05_VentaCemetery", _
             "M06_Kodonur", "M07_PogahnPassage", _
             "M08_RilohnOrModdok"
            Return "Team_Kourna"
        Case "M09_Tihark", "M10_Dasha", "M11_GrandCourt", _
             "M12_JennurOrDzagonur", "M13_NunduBay"
            Return "Team_Vabbi"
        Case "AllsWellThatEndsWell", "WarningKehanni", "CallingTheOrder", "PledgeOfMerchantPrinces"
            Return "Team_Vabbi_NoMelee"
        Case "CrossingTheDesolation"
            Return "Team_CTD"
        Case Else
            Return "Team_Endgame"
    EndSwitch
EndFunc
Global Const $TEAM_KOSS_TEMPLATE     = "OQATEHqVl4q+FwBWocNACAA"    
Global Const $TEAM_MELONNI_TEMPLATE  = "OgGikeszcV+vS3BMXZ8OuFAA"  
Global Const $TEAM_TAHLKORA_TEMPLATE = "OwUUMwG/Q4N11MCd9uKQqH9AiAA"
Global Const $TEAM_DUNKORO_TEMPLATE  = "OwUUMwG/Q4N11MCddlMTqH9AiAA"
Global Const $TEAM_ZHED_TEMPLATE     = "OgBCoMzDdbs202FFDaBuQAA"  
Global Const $TEAM_MASTER_OF_WHISPERS_TEMPLATE = "OAZDQopKP3hixuYs20EG4CBA"  
Global Const $TEAM_PLAYER_OFFICIAL_BUILD = "OgGjUhpMrOXl/r0dAzVGvjbBAA"
Global Const $KODONUR_KOSS_TEMPLATE     = "OQATETKXt4q+FwBWocNACAA"
Global Const $KODONUR_DUNKORO_TEMPLATE  = "OwAT04nBz5umRAJtE6aFpeETAA"
Global Const $KODONUR_MELONNI_TEMPLATE  = "OgGjUZpMbOXl/r0dAzVGvjbBAA"
Global Const $KODONUR_TAHLKORA_TEMPLATE = "OwAT0yHDtpikRmJtE66dteETAA"
Global Const $KODONUR_ZHED_TEMPLATE     = "OgBCoMzTxQYMWba7ibBuQAA"   
Global Const $RP_CHAR_TEMPLATE    = "OgGjUhpMrOXl/r0dAzVGvjbBAA"
Global Const $RP_KOSS_TEMPLATE    = "OQATEVKXx4q+FwBWocNACAA"
Global Const $RP_DUNKORO_TEMPLATE = "OwUUMwG/Q4N11MCddlIQqH9gMAA"
Global Const $RP_MELONNI_TEMPLATE = "OgGjUhpMrOXl/r0dAzVGvjbBAA"
Global Const $RP_TAHLKORA_TEMPLATE = "OwUUMwG/Q4N11MCd9uKQqH9gMAA"
Global Const $RP_ZHED_TEMPLATE     = "OgBCoMzTxQYMWba7ibBuQAA"
Global Const $RP_MOW_TEMPLATE      = "OAVDIJxWCt9YmcxhGEJA"
Func _Team_LoadRPBuilds()
    If Agent_GetAgentInfo(-2, "MaxHP") > 0 Then
        Out("[RPbuilds] Char (player): Attribute_LoadSkillTemplate")
        Attribute_LoadSkillTemplate($RP_CHAR_TEMPLATE)
        Sleep(1500)
    EndIf
    If _AutoParty_IsHeroInParty($GC_I_HERO_ID_KOSS) Then _Team_LoadHeroBuild($GC_I_HERO_ID_KOSS, $RP_KOSS_TEMPLATE, "Koss", $g_aiKossAttrs)
    If _AutoParty_IsHeroInParty($GC_I_HERO_ID_DUNKORO) Then _Team_LoadHeroBuild($GC_I_HERO_ID_DUNKORO, $RP_DUNKORO_TEMPLATE, "Dunkoro", $g_aiDunkoroAttrs)
    If _AutoParty_IsHeroInParty($GC_I_HERO_ID_MELONNI) Then _Team_LoadHeroBuild($GC_I_HERO_ID_MELONNI, $RP_MELONNI_TEMPLATE, "Melonni", $g_aiMelonniAttrs)
    If _AutoParty_IsHeroInParty($GC_I_HERO_ID_TAHLKORA) Then _Team_LoadHeroBuild($GC_I_HERO_ID_TAHLKORA, $RP_TAHLKORA_TEMPLATE, "Tahlkora", $g_aiTahlkoraAttrs)
    If _AutoParty_IsHeroInParty($GC_I_HERO_ID_ZHED_SHADOWHOOF) Then _Team_LoadHeroBuild($GC_I_HERO_ID_ZHED_SHADOWHOOF, $RP_ZHED_TEMPLATE, "Zhed", $g_aiZhedAttrs)
    If _AutoParty_IsHeroInParty($GC_I_HERO_ID_MASTER_OF_WHISPERS) Then _Team_LoadHeroBuild($GC_I_HERO_ID_MASTER_OF_WHISPERS, $TEAM_MASTER_OF_WHISPERS_TEMPLATE, "MoW", $g_aiMoWAttrs)
    Out("[RPbuilds] builds de la fase 37 cargadas")
EndFunc
Func _Team_SetAttr($attrId, $target)
    Local $cur = Attribute_GetPartyAttributeInfo($attrId, 0, "BaseLevel")
    If $cur < $target Then
        Attribute_IncreaseAttribute($attrId, $target - $cur)
    ElseIf $cur > $target Then
        Attribute_DecreaseAttribute($attrId, $cur - $target)
    EndIf
    Sleep(400)
EndFunc
Func _Team_LoadHeroBuild($heroId, $template, $name, $aAttrIds = "")
    Local $slot = _AutoLevel_FindHeroSlot($heroId)
    If $slot > 0 Then
        Out("[Team] build " & $name & " (slot " & $slot & ")")
        Attribute_LoadSkillTemplate($template, $slot)
        Sleep(1500)   
        If IsArray($aAttrIds) And UBound($aAttrIds) > 0 Then
            _Team_ForceHeroAttrs($heroId, $slot, $name, $aAttrIds)
        EndIf
        Local $nEmpty = 0
        For $vs = 1 To 8
            If Skill_GetSkillbarInfo($vs, "SkillID", $slot) = 0 Then
                Out("[Team] " & $name & " slot" & $vs & " VACIO tras cargar build (skill no aprendida/desbloqueada)")
                $nEmpty += 1
            EndIf
        Next
        If $nEmpty > 0 Then Out("[Team] " & $name & ": " & $nEmpty & "/8 slots vacios -> faltan skills por comprar/desbloquear")
        _Team_FillForHero($heroId, $name)
    Else
        Out("[Team] " & $name & " no en party → build no cargada")
    EndIf
EndFunc
Func _Team_ForceHeroAttrs($heroId, $slot, $name, $aAttrIds)
    If $slot <= 0 Then
        Out("[Team] " & $name & ": slot no válido (" & $slot & ") → skip attrs")
        Return
    EndIf
    Local $count = UBound($aAttrIds)
    If $count = 0 Then Return
    Local $agentId = Party_GetMyPartyHeroInfo($slot, "AgentID")
    If $agentId = 0 Then
        Out("[Team] " & $name & ": agent ID no encontrado (slot " & $slot & ") → skip attrs")
        Return
    EndIf
    Local $primary   = Party_GetPartyProfessionInfo($agentId, "Primary")
    Local $secondary = Party_GetPartyProfessionInfo($agentId, "Secondary")
    If $primary = 0 Then
        Out("[Team] " & $name & ": no se pudo leer profesión (agent=" & $agentId & ") → skip attrs")
        Return
    EndIf
    Local $costTable[12] = [1, 2, 3, 4, 5, 6, 7, 9, 11, 13, 16, 20]
    Local $unusedPts = Attribute_GetPartyAttributePointInfo($slot, "UnusedPoints")
    Local $sBefore = "BEFORE [Free=" & $unusedPts & "]"
    For $i = 0 To $count - 1
        $sBefore &= " " & $GC_AS_ATTRIBUTE_NAMES[$aAttrIds[$i]] & "=" & Attribute_GetPartyAttributeInfo($aAttrIds[$i], $slot, "BaseLevel")
    Next
    Out("[Team] " & $name & ": " & $sBefore)
    For $i = 0 To UBound($GC_AI2_ALL_ATTRIBUTES_BY_PROFESSION) - 1
        If $GC_AI2_ALL_ATTRIBUTES_BY_PROFESSION[$i][0] = $primary Then
            For $j = 1 To UBound($GC_AI2_ALL_ATTRIBUTES_BY_PROFESSION, $UBOUND_COLUMNS) - 1
                Local $attrId = $GC_AI2_ALL_ATTRIBUTES_BY_PROFESSION[$i][$j]
                If $attrId = "" Then ExitLoop
                Local $isTarget = False
                For $k = 0 To $count - 1
                    If $aAttrIds[$k] = $attrId Then $isTarget = True
                Next
                If Not $isTarget Then
                    Local $curLvl = Attribute_GetPartyAttributeInfo($attrId, $slot, "BaseLevel")
                    If $curLvl > 0 Then
                        Attribute_DecreaseAttribute($attrId, $curLvl, $slot)
                        Sleep(128)
                    EndIf
                EndIf
            Next
            ExitLoop
        EndIf
    Next
    If $secondary <> $GC_I_PROFESSION_NONE Then
        For $i = 0 To UBound($GC_AI2_ALL_ATTRIBUTES_BY_PROFESSION) - 1
            If $GC_AI2_ALL_ATTRIBUTES_BY_PROFESSION[$i][0] = $secondary Then
                For $j = 1 To UBound($GC_AI2_ALL_ATTRIBUTES_BY_PROFESSION, $UBOUND_COLUMNS) - 1
                    Local $attrIdS = $GC_AI2_ALL_ATTRIBUTES_BY_PROFESSION[$i][$j]
                    If $attrIdS = "" Then ExitLoop
                    Local $isTargetS = False
                    For $k = 0 To $count - 1
                        If $aAttrIds[$k] = $attrIdS Then $isTargetS = True
                    Next
                    If Not $isTargetS Then
                        Local $curLvlS = Attribute_GetPartyAttributeInfo($attrIdS, $slot, "BaseLevel")
                        If $curLvlS > 0 Then
                            Attribute_DecreaseAttribute($attrIdS, $curLvlS, $slot)
                            Sleep(128)
                        EndIf
                    EndIf
                Next
                ExitLoop
            EndIf
        Next
    EndIf
    Sleep(200)
    $unusedPts = Attribute_GetPartyAttributePointInfo($slot, "UnusedPoints")
    Local $raised = 0
    For $i = 0 To $count - 1
        Local $target = $aAttrIds[$i]
        Local $cur = Attribute_GetPartyAttributeInfo($target, $slot, "BaseLevel")
        While $cur < 12 And $unusedPts > 0
            Local $cost = $costTable[$cur]  
            If $unusedPts < $cost Then ExitLoop
            Attribute_IncreaseAttribute($target, 1, $slot)
            Sleep(128)
            $unusedPts -= $cost
            $cur += 1
            $raised += 1
        WEnd
    Next
    Local $sAfter = "AFTER  [Free=" & $unusedPts & "] raised=" & $raised
    For $i = 0 To $count - 1
        $sAfter &= " " & $GC_AS_ATTRIBUTE_NAMES[$aAttrIds[$i]] & "=" & Attribute_GetPartyAttributeInfo($aAttrIds[$i], $slot, "BaseLevel")
    Next
    For $i = 0 To UBound($GC_AI2_ALL_ATTRIBUTES_BY_PROFESSION) - 1
        If $GC_AI2_ALL_ATTRIBUTES_BY_PROFESSION[$i][0] = $primary Then
            For $j = 1 To UBound($GC_AI2_ALL_ATTRIBUTES_BY_PROFESSION, $UBOUND_COLUMNS) - 1
                Local $attrNt = $GC_AI2_ALL_ATTRIBUTES_BY_PROFESSION[$i][$j]
                If $attrNt = "" Then ExitLoop
                Local $isTargetNt = False
                For $k = 0 To $count - 1
                    If $aAttrIds[$k] = $attrNt Then $isTargetNt = True
                Next
                If Not $isTargetNt Then
                    $sAfter &= " " & $GC_AS_ATTRIBUTE_NAMES[$attrNt] & "=" & Attribute_GetPartyAttributeInfo($attrNt, $slot, "BaseLevel")
                EndIf
            Next
            ExitLoop
        EndIf
    Next
    Out("[Team] " & $name & ": " & $sAfter)
    Local $unusedFinal = Attribute_GetPartyAttributePointInfo($slot, "UnusedPoints")
    If $heroId = $GC_I_HERO_ID_KOSS Then
        $g_iKossLastUnused = $unusedFinal
    ElseIf $heroId = $GC_I_HERO_ID_DUNKORO Then
        $g_iDunkoroLastUnused = $unusedFinal
    ElseIf $heroId = $GC_I_HERO_ID_MELONNI Then
        $g_iMelonniLastUnused = $unusedFinal
    ElseIf $heroId = $GC_I_HERO_ID_TAHLKORA Then
        $g_iTahlkoraLastUnused = $unusedFinal
    EndIf
    Out("[Team] " & $name & ": AutoLevel cooldown set to " & $unusedFinal & " (skip hasta level-up)")
EndFunc
Global $g_bTeamSetupDone = False
Global $g_bOfficialBuildApplied = False
Global $g_bSkipBuildsOnSetup = False  
Func _Team_KickKihmIfPresent()
    Local $kihmOut = 0
    Local $agsKh2 = Agent_GetAgentArray($GC_I_AGENT_TYPE_LIVING)
    If IsArray($agsKh2) Then
        For $kk = 0 To UBound($agsKh2) - 1
            If $agsKh2[$kk] = 0 Then ContinueLoop
            If StringInStr(Agent_GetAgentInfo($agsKh2[$kk], "Name"), "Kihm") _
               Or Agent_GetAgentInfo($agsKh2[$kk], "PlayerNumber") = 4629 Then
                $kihmOut = Agent_GetAgentInfo($agsKh2[$kk], "ID")
                ExitLoop
            EndIf
        Next
    EndIf
    If $kihmOut <> 0 Then
        Out("[Team] Kihm en party -> kick (equipo oficial usa Mhenlo)")
        Party_KickNpc($kihmOut)
        Sleep(600)
    EndIf
EndFunc
Func _Team_KickHenchByModel($model, $name)
    Local $nHench = Party_GetMyPartyInfo("ArrayHenchmanPartyMemberSize")
    If @error Or $nHench <= 0 Then Return False
    For $hk = 1 To $nHench
        Local $haid = Party_GetMyPartyHenchmanInfo($hk, "AgentID")
        If $haid = 0 Then ContinueLoop
        If Agent_GetAgentInfo($haid, "PlayerNumber") = $model Then
            Out("[Team] Kick henchman " & $name & " (model " & $model & ") agent=" & $haid)
            Party_KickNpc($haid)
            Sleep(600)
            Return True
        EndIf
    Next
    Return False
EndFunc
Func _Team_AddHenchByModel($model, $name)
    Local $bestNPC = 0, $bestD = 9e9
    For $a1 = 1 To 5
        Local $agsT = Agent_GetAgentArray($GC_I_AGENT_TYPE_LIVING)
        If IsArray($agsT) Then
            For $i = 0 To UBound($agsT) - 1
                If $agsT[$i] = 0 Then ContinueLoop
                If Agent_GetAgentInfo($agsT[$i], "PlayerNumber") <> $model Then ContinueLoop
                Out("[Team] +Henchman " & $name & " (model " & $model & ") via Ui_AddNPC")
                Ui_AddNPC(Agent_GetAgentInfo($agsT[$i], "ID"))
                Sleep(800)
                Return True
            Next
        EndIf
        $bestNPC = 0
        $bestD = 9e9
        Local $cxT = Agent_GetAgentInfo(-2, "X"), $cyT = Agent_GetAgentInfo(-2, "Y")
        Local $agsN = Agent_GetAgentArray($GC_I_AGENT_TYPE_LIVING)
        If IsArray($agsN) Then
            For $j = 0 To UBound($agsN) - 1
                If $agsN[$j] = 0 Then ContinueLoop
                If Agent_GetAgentInfo($agsN[$j], "IsPlayer") Then ContinueLoop
                Local $alT = Agent_GetAgentInfo($agsN[$j], "Allegiance")
                If $alT <> $GC_I_ALLEGIANCE_ALLY And $alT <> $GC_I_ALLEGIANCE_NPC Then ContinueLoop
                Local $dx = Agent_GetAgentInfo($agsN[$j], "X") - $cxT
                Local $dy = Agent_GetAgentInfo($agsN[$j], "Y") - $cyT
                Local $d = Sqrt($dx^2 + $dy^2)
                If $d < $bestD Then
                    $bestD = $d
                    $bestNPC = Agent_GetAgentInfo($agsN[$j], "ID")
                EndIf
            Next
        EndIf
        If $bestNPC <> 0 And $bestD > 150 Then
            Out("[Team] " & $name & " (model " & $model & ") no cargado -> acercándose a NPC d=" & Round($bestD) & "u")
            Map_Move(Agent_GetAgentInfo($bestNPC, "X"), Agent_GetAgentInfo($bestNPC, "Y"), 0)
            Sleep(1500)
        Else
            Sleep(500)
        EndIf
    Next
    Out("[Team] " & $name & " (model " & $model & ") NO reclutado tras 5 intentos")
    Return False
EndFunc
Func _Team_KickNonOfficialHenchmen()
    If Map_GetMapID() = 493 Then Return
    Local $aOfficial[3] = [4626, 4624, 4628]
    If Map_GetMapID() = 477 Then
        $aOfficial[0] = 4626
        $aOfficial[1] = 4628
        $aOfficial[2] = 0
    EndIf
    Local $aFallbackHeroModels[2] = [4616, 4617]
    Local $nH = Party_GetMyPartyInfo("ArrayHenchmanPartyMemberSize")
    If @error Or $nH <= 0 Then Return
    For $i = 1 To $nH
        Local $aid = Party_GetMyPartyHenchmanInfo($i, "AgentID")
        If $aid = 0 Then ContinueLoop
        Local $m = Agent_GetAgentInfo($aid, "PlayerNumber")
        If $m = 0 Then ContinueLoop
        Local $isHero = False
        For $h = 0 To UBound($aFallbackHeroModels) - 1
            If $m = $aFallbackHeroModels[$h] Then
                $isHero = True
                ExitLoop
            EndIf
        Next
        If $isHero Then ContinueLoop
        Local $ok = False
        For $k = 0 To 2
            If $m = $aOfficial[$k] Then
                $ok = True
                ExitLoop
            EndIf
        Next
        If Not $ok Then
            Out("[Team] Kick henchman no oficial model=" & $m & " agent=" & $aid)
            Party_KickNpc($aid)
            Sleep(500)
        EndIf
    Next
EndFunc
Func _Team_EnsureZhedMoWKihm()
    If Map_GetMapID() = 554 Then
        Out("[Team] EnsureZhedMoWKihm: skip en Dajkah 554 (compo fija de la fase 26)")
        Return
    EndIf
    Local $bM12_Ensure = (Map_GetMapID() = 477)
    If Not _AutoParty_IsHeroInParty($GC_I_HERO_ID_ZHED_SHADOWHOOF) Then
        Local $pNow = 1 + Party_GetMyPartyInfo("ArrayHeroPartyMemberSize") _
                        + Party_GetMyPartyInfo("ArrayHenchmanPartyMemberSize")
        If $pNow >= 8 Then
            _AutoParty_KickAnyHenchman()
            Sleep(1000)
        EndIf
        Out("[Team] Ensure: Party_AddHero Zhed")
        Party_AddHero($GC_I_HERO_ID_ZHED_SHADOWHOOF)
        Sleep(1000)
        _Team_LoadHeroBuild($GC_I_HERO_ID_ZHED_SHADOWHOOF, $TEAM_ZHED_TEMPLATE, "Zhed", $g_aiZhedAttrs)
        If Not _AutoParty_IsHeroInParty($GC_I_HERO_ID_ZHED_SHADOWHOOF) And _
           Not _AutoParty_IsHeroInParty($GC_I_HERO_ID_KOSS) Then
            Local $pK2 = 1 + Party_GetMyPartyInfo("ArrayHeroPartyMemberSize") _
                        + Party_GetMyPartyInfo("ArrayHenchmanPartyMemberSize")
            If $pK2 >= 8 Then _AutoParty_KickAnyHenchman()
            Sleep(400)
            Out("[Team] Ensure fallback: añadir Koss (Zhed no disponible)")
            Party_AddHero($GC_I_HERO_ID_KOSS)
            Sleep(800)
            If _AutoParty_IsHeroInParty($GC_I_HERO_ID_KOSS) Then
                ReDim $g_aiAutoPartyHeroes[UBound($g_aiAutoPartyHeroes) + 1]
                $g_aiAutoPartyHeroes[UBound($g_aiAutoPartyHeroes) - 1] = $GC_I_HERO_ID_KOSS
                Out("[Team] Ensure fallback: Koss añadido")
            EndIf
        EndIf
    Else
        Local $zSlot = _AutoLevel_FindHeroSlot($GC_I_HERO_ID_ZHED_SHADOWHOOF)
        If $zSlot > 0 Then _Team_ForceHeroAttrs($GC_I_HERO_ID_ZHED_SHADOWHOOF, $zSlot, "Zhed", $g_aiZhedAttrs)
    EndIf
    If Not _AutoParty_IsHeroInParty($GC_I_HERO_ID_MASTER_OF_WHISPERS) Then
        Local $pNowM = 1 + Party_GetMyPartyInfo("ArrayHeroPartyMemberSize") _
                        + Party_GetMyPartyInfo("ArrayHenchmanPartyMemberSize")
        If $pNowM >= 8 Then
            _AutoParty_KickAnyHenchman()
            Sleep(1000)
        EndIf
        Out("[Team] Ensure: Party_AddHero MoW")
        Party_AddHero($GC_I_HERO_ID_MASTER_OF_WHISPERS)
        Sleep(1000)
        _Team_LoadHeroBuild($GC_I_HERO_ID_MASTER_OF_WHISPERS, $TEAM_MASTER_OF_WHISPERS_TEMPLATE, "MasterOfWhispers", $g_aiMoWAttrs)
        If Not _AutoParty_IsHeroInParty($GC_I_HERO_ID_MASTER_OF_WHISPERS) And _
           Not $bM12_Ensure And Not _AutoParty_IsHeroInParty($GC_I_HERO_ID_MELONNI) Then
            Local $pM2 = 1 + Party_GetMyPartyInfo("ArrayHeroPartyMemberSize") _
                        + Party_GetMyPartyInfo("ArrayHenchmanPartyMemberSize")
            If $pM2 >= 8 Then _AutoParty_KickAnyHenchman()
            Sleep(400)
            Out("[Team] Ensure fallback: añadir Melonni (MoW no disponible)")
            Party_AddHero($GC_I_HERO_ID_MELONNI)
            Sleep(800)
            If _AutoParty_IsHeroInParty($GC_I_HERO_ID_MELONNI) Then
                ReDim $g_aiAutoPartyHeroes[UBound($g_aiAutoPartyHeroes) + 1]
                $g_aiAutoPartyHeroes[UBound($g_aiAutoPartyHeroes) - 1] = $GC_I_HERO_ID_MELONNI
                Out("[Team] Ensure fallback: Melonni añadida")
            EndIf
        EndIf
    Else
    EndIf
    _Team_KickKihmIfPresent()
    Local $aOffHenchNames[3] = ["Mhenlo", "Odurra", "Cynn"]
    Local $aOffHenchModels[3] = [4628, 4624, 4626]
    For $oh = 0 To 2
        Local $ohName = $aOffHenchNames[$oh]
        Local $pNowOh = 1 + Party_GetMyPartyInfo("ArrayHeroPartyMemberSize") _
                        + Party_GetMyPartyInfo("ArrayHenchmanPartyMemberSize")
        If $pNowOh >= 8 Then
            Out("[Team] Ensure: party ya 8/8 -> skip " & $ohName)
            ExitLoop
        EndIf
        If _AutoParty_IsHenchModelInParty($aOffHenchModels[$oh]) Then ContinueLoop
        Local $ohAgent = 0
        Local $agsOh = Agent_GetAgentArray($GC_I_AGENT_TYPE_LIVING)
        If IsArray($agsOh) Then
            For $ohi = 0 To UBound($agsOh) - 1
                If $agsOh[$ohi] = 0 Then ContinueLoop
                If Agent_GetAgentInfo($agsOh[$ohi], "IsPlayer") Then ContinueLoop
                If StringInStr(Agent_GetAgentInfo($agsOh[$ohi], "Name"), $ohName) Then
                    $ohAgent = Agent_GetAgentInfo($agsOh[$ohi], "ID")
                    ExitLoop
                EndIf
            Next
        EndIf
        If $ohAgent <> 0 Then
            Out("[Team] Ensure: Party_AddNpc " & $ohName & " agent=" & $ohAgent)
            Party_AddNpc($ohAgent)
            Sleep(1000)
        EndIf
    Next
EndFunc
Func Team_SetupFull()
    _Team_AuditSkillUnlocks()
    Local $tReady = TimerInit()
    While TimerDiff($tReady) < 20000 And Not Bot_ShouldStop()
        If Map_GetInstanceInfo("IsLoading") Then
            Sleep(500)
            ContinueLoop
        EndIf
        If Agent_GetAgentInfo(-2, "MaxHP") <= 0 Then
            Sleep(500)
            ContinueLoop
        EndIf
        If Agent_GetAgentInfo(-2, "X") = 0 And Agent_GetAgentInfo(-2, "Y") = 0 Then
            Sleep(500)
            ContinueLoop
        EndIf
        ExitLoop
    WEnd
    If Agent_GetAgentInfo(-2, "MaxHP") <= 0 Or (Agent_GetAgentInfo(-2, "X") = 0 And Agent_GetAgentInfo(-2, "Y") = 0) Then
        Out("[Team] SetupFull SKIP: char aun sin cargar tras 20s (MaxHP=" & Agent_GetAgentInfo(-2, "MaxHP") & ") -> no montar party (evita crash GW)")
        Return
    EndIf
    If Map_GetMapID() = 414 Then
        Out("[Team] SetupFull: skip en Kodash 414 (fase 39 gestiona su equipo)")
        Return
    EndIf
    If Map_GetMapID() = $GC_I_MAP_ID_WEHHAN_TERRACES Then
        Out("[Team] SetupFull: skip en Wehhan 378 (fase 37 gestiona su equipo)")
        Return
    EndIf
    $g_bTeamSetupRunning = True 
    Local $bM12 = (Map_GetMapID() = 477)
    Local $aHeroes[2] = [$GC_I_HERO_ID_DUNKORO, $GC_I_HERO_ID_TAHLKORA]
    If $bM12 Then
        ReDim $g_aiAutoPartyHeroes[3]
        $g_aiAutoPartyHeroes[0] = $GC_I_HERO_ID_DUNKORO
        $g_aiAutoPartyHeroes[1] = $GC_I_HERO_ID_TAHLKORA
        $g_aiAutoPartyHeroes[2] = $GC_I_HERO_ID_MELONNI
    Else
        ReDim $g_aiAutoPartyHeroes[2]
        $g_aiAutoPartyHeroes[0] = $GC_I_HERO_ID_DUNKORO
        $g_aiAutoPartyHeroes[1] = $GC_I_HERO_ID_TAHLKORA
    EndIf
    If $bM12 Then
        _Team_KickHenchByModel(4624, "Odurra")
        Sleep(500)
        If Not _AutoParty_IsHeroInParty($GC_I_HERO_ID_MELONNI) Then
            Local $pM12 = 1 + Party_GetMyPartyInfo("ArrayHeroPartyMemberSize") _
                           + Party_GetMyPartyInfo("ArrayHenchmanPartyMemberSize")
            If $pM12 >= 8 Then _AutoParty_KickAnyHenchman()
            Sleep(500)
            Out("[Team] M12: Party_AddHero Melonni (obligatoria en esta coop)")
            Party_AddHero($GC_I_HERO_ID_MELONNI)
            Sleep(800)
        EndIf
        _Team_LoadHeroBuild($GC_I_HERO_ID_MELONNI, $TEAM_PLAYER_OFFICIAL_BUILD, "Melonni")
        Sleep(600)
    EndIf
    _Team_KickKihmIfPresent()
    If _AutoParty_IsHeroInParty($GC_I_HERO_ID_DUNKORO) And _AutoParty_IsHeroInParty($GC_I_HERO_ID_TAHLKORA) _
       And $g_bOfficialBuildApplied Then
        Out("[Team] SetupFull: heroes base ya en party → skip builds (evita 007)")
        Local $skipHeroes[2] = [$GC_I_HERO_ID_DUNKORO, $GC_I_HERO_ID_TAHLKORA]
        Local $skipNames[2]  = ["Dunkoro", "Tahlkora"]
        Local $skipAttrs[2]  = [$g_aiDunkoroAttrs, $g_aiTahlkoraAttrs]
        For $si = 0 To 1
            Local $sslot = _AutoLevel_FindHeroSlot($skipHeroes[$si])
            If $sslot > 0 Then _Team_ForceHeroAttrs($skipHeroes[$si], $sslot, $skipNames[$si], $skipAttrs[$si])
        Next
        _Team_EnsureZhedMoWKihm()
        $g_bTeamSetupDone = True
        $g_bTeamSetupRunning = False 
        Return
    EndIf
    Out("[Team] === SetupFull: equipo oficial (Dunkoro/Tahlkora/Zhed/MoW + build player) ===")
    If Not $g_bSkipBuildsOnSetup Then
        Out("[Team] Player build oficial")
        Attribute_LoadSkillTemplate($TEAM_PLAYER_OFFICIAL_BUILD)
        Sleep(1000)
    EndIf
    For $i = 0 To 1
        If _AutoParty_IsHeroInParty($aHeroes[$i]) Then ContinueLoop
        Out("[Team] Party_AddHero " & $aHeroes[$i])
        Party_AddHero($aHeroes[$i])
        Sleep(800)
    Next
    If Not $g_bSkipBuildsOnSetup Then
        _Team_LoadHeroBuild($GC_I_HERO_ID_DUNKORO,  $TEAM_DUNKORO_TEMPLATE,  "Dunkoro",  $g_aiDunkoroAttrs)
        _Team_LoadHeroBuild($GC_I_HERO_ID_TAHLKORA, $TEAM_TAHLKORA_TEMPLATE, "Tahlkora", $g_aiTahlkoraAttrs)
    EndIf
    If Not _AutoParty_IsHeroInParty($GC_I_HERO_ID_ZHED_SHADOWHOOF) Then
        For $zr = 1 To 3
            Local $pNow = 1 + Party_GetMyPartyInfo("ArrayHeroPartyMemberSize") _
                            + Party_GetMyPartyInfo("ArrayHenchmanPartyMemberSize")
            If $pNow >= 8 Then
                Out("[Team] party llena (" & $pNow & "/8) -> kick henchman para hueco a Zhed")
                _AutoParty_KickAnyHenchman()
                Sleep(500)
            EndIf
            Out("[Team] Party_AddHero Zhed Shadowhoof (" & $GC_I_HERO_ID_ZHED_SHADOWHOOF & ") intento " & $zr)
            Party_AddHero($GC_I_HERO_ID_ZHED_SHADOWHOOF)
            Sleep(800)
            If _AutoParty_IsHeroInParty($GC_I_HERO_ID_ZHED_SHADOWHOOF) Then ExitLoop
        Next
    EndIf
    If _AutoParty_IsHeroInParty($GC_I_HERO_ID_ZHED_SHADOWHOOF) Then
        ReDim $g_aiAutoPartyHeroes[5]
        $g_aiAutoPartyHeroes[4] = $GC_I_HERO_ID_ZHED_SHADOWHOOF
        Out("[Team] Zhed Shadowhoof en party -> gestionado (5 heroes; 1 henchman menos)")
        If Not $g_bSkipBuildsOnSetup Then _Team_LoadHeroBuild($GC_I_HERO_ID_ZHED_SHADOWHOOF, $TEAM_ZHED_TEMPLATE, "Zhed", $g_aiZhedAttrs)
        If _AutoParty_IsHeroInParty($GC_I_HERO_ID_KOSS) Then
            Out("[Team] Kick Koss (Zhed confirmado, equipo oficial sin Koss)")
            Party_KickHero($GC_I_HERO_ID_KOSS)
            Sleep(500)
        EndIf
    Else
        Out("[Team] Zhed Shadowhoof NO entró al party (¿desbloqueado? revisar tras reward CB)")
        If Not _AutoParty_IsHeroInParty($GC_I_HERO_ID_KOSS) Then
            Local $pK = 1 + Party_GetMyPartyInfo("ArrayHeroPartyMemberSize") _
                       + Party_GetMyPartyInfo("ArrayHenchmanPartyMemberSize")
            If $pK >= 8 Then _AutoParty_KickAnyHenchman()
            Sleep(400)
            Out("[Team] Fallback: añadir Koss (Zhed no disponible)")
            Party_AddHero($GC_I_HERO_ID_KOSS)
            Sleep(800)
            If _AutoParty_IsHeroInParty($GC_I_HERO_ID_KOSS) Then
                ReDim $g_aiAutoPartyHeroes[UBound($g_aiAutoPartyHeroes) + 1]
                $g_aiAutoPartyHeroes[UBound($g_aiAutoPartyHeroes) - 1] = $GC_I_HERO_ID_KOSS
                Out("[Team] Koss añadido como fallback para Zhed")
            EndIf
        EndIf
    EndIf
    If Not _AutoParty_IsHeroInParty($GC_I_HERO_ID_MASTER_OF_WHISPERS) Then
        For $mr = 1 To 3
            Local $pNowM = 1 + Party_GetMyPartyInfo("ArrayHeroPartyMemberSize") _
                            + Party_GetMyPartyInfo("ArrayHenchmanPartyMemberSize")
            If $pNowM >= 8 Then
                Out("[Team] party llena (" & $pNowM & "/8) -> kick henchman para hueco a MoW")
                _AutoParty_KickAnyHenchman()
                Sleep(500)
            EndIf
            Out("[Team] Party_AddHero Master of Whispers (" & $GC_I_HERO_ID_MASTER_OF_WHISPERS & ") intento " & $mr)
            Party_AddHero($GC_I_HERO_ID_MASTER_OF_WHISPERS)
            Sleep(800)
            If _AutoParty_IsHeroInParty($GC_I_HERO_ID_MASTER_OF_WHISPERS) Then ExitLoop
        Next
    EndIf
    If _AutoParty_IsHeroInParty($GC_I_HERO_ID_MASTER_OF_WHISPERS) Then
        Local $newIdx = UBound($g_aiAutoPartyHeroes)
        ReDim $g_aiAutoPartyHeroes[$newIdx + 1]
        $g_aiAutoPartyHeroes[$newIdx] = $GC_I_HERO_ID_MASTER_OF_WHISPERS
        Out("[Team] Master of Whispers en party -> gestionado (" & ($newIdx + 1) & " heroes)")
        If Not $g_bSkipBuildsOnSetup Then _Team_LoadHeroBuild($GC_I_HERO_ID_MASTER_OF_WHISPERS, $TEAM_MASTER_OF_WHISPERS_TEMPLATE, "MasterOfWhispers", $g_aiMoWAttrs)
        If Not $bM12 And _AutoParty_IsHeroInParty($GC_I_HERO_ID_MELONNI) Then
            Out("[Team] Kick Melonni (MoW confirmado, equipo oficial sin Melonni)")
            Party_KickHero($GC_I_HERO_ID_MELONNI)
            Sleep(500)
        EndIf
    Else
        Out("[Team] Master of Whispers NO entró al party (¿desbloqueado tras q553?)")
        If Not $bM12 And Not _AutoParty_IsHeroInParty($GC_I_HERO_ID_MELONNI) Then
            Local $pM = 1 + Party_GetMyPartyInfo("ArrayHeroPartyMemberSize") _
                       + Party_GetMyPartyInfo("ArrayHenchmanPartyMemberSize")
            If $pM >= 8 Then _AutoParty_KickAnyHenchman()
            Sleep(400)
            Out("[Team] Fallback: añadir Melonni (MoW no disponible)")
            Party_AddHero($GC_I_HERO_ID_MELONNI)
            Sleep(800)
            If _AutoParty_IsHeroInParty($GC_I_HERO_ID_MELONNI) Then
                ReDim $g_aiAutoPartyHeroes[UBound($g_aiAutoPartyHeroes) + 1]
                $g_aiAutoPartyHeroes[UBound($g_aiAutoPartyHeroes) - 1] = $GC_I_HERO_ID_MELONNI
                Out("[Team] Melonni añadida como fallback para MoW")
            EndIf
        EndIf
    EndIf
    Local $aFullHenchNames[3] = ["Mhenlo", "Odurra", "Cynn"]
    Local $aFullHenchModels[3] = [4628, 4624, 4626]
    If $bM12 Then
        ReDim $aFullHenchNames[2]
        ReDim $aFullHenchModels[2]
        $aFullHenchNames[0] = "Cynn"
        $aFullHenchNames[1] = "Mhenlo"
        $aFullHenchModels[0] = 4626
        $aFullHenchModels[1] = 4628
        Local $cxM12 = Agent_GetAgentInfo(-2, "X"), $cyM12 = Agent_GetAgentInfo(-2, "Y")
        If Sqrt(($cxM12 - (-15717)) ^ 2 + ($cyM12 - (-7689)) ^ 2) > 700 Then
            Out("[Team] M12: acercándose a Dreamer Raja (-15717,-7689) para cargar henchmen (Cynn/Mhenlo)")
            Map_Move(-15717, -7689, 0)
            Sleep(3000)
        EndIf
    EndIf
    If Map_GetMapID() = 478 Then
        Local $cx478 = Agent_GetAgentInfo(-2, "X"), $cy478 = Agent_GetAgentInfo(-2, "Y")
        If Sqrt(($cx478 - 791) ^ 2 + ($cy478 - 1785) ^ 2) > 700 Then
            Out("[Team] 478: acercándose al spawn del outpost (791,1785) para cargar henchmen")
            Map_Move(791, 1785, 0)
            Sleep(3000)
        EndIf
    EndIf
    For $fh = 0 To UBound($aFullHenchNames) - 1
        Local $fhName = $aFullHenchNames[$fh]
        Local $pNowFh = 1 + Party_GetMyPartyInfo("ArrayHeroPartyMemberSize") _
                        + Party_GetMyPartyInfo("ArrayHenchmanPartyMemberSize")
        If $pNowFh >= 8 Then
            Out("[Team] party ya 8/8 -> skip " & $fhName)
            ExitLoop
        EndIf
        If _AutoParty_IsHenchModelInParty($aFullHenchModels[$fh]) Then ContinueLoop
        _Team_AddHenchByModel($aFullHenchModels[$fh], $fhName)
    Next
    Party_FillWithHenchmen()
    _Team_KickNonOfficialHenchmen()
    $g_bOfficialBuildApplied = True
    $g_bTeamSetupRunning = False 
    Local $pSz = 1 + Party_GetMyPartyInfo("ArrayHeroPartyMemberSize") _
                   + Party_GetMyPartyInfo("ArrayHenchmanPartyMemberSize")
    Out("[Team] SetupFull FINAL party=" & $pSz & "/8 (Scythe=" _
        & Attribute_GetPartyAttributeInfo($GC_I_ATTRIBUTE_SCYTHE_MASTERY, 0, "BaseLevel") & " Myst=" _
        & Attribute_GetPartyAttributeInfo($GC_I_ATTRIBUTE_MYSTICISM, 0, "BaseLevel") & ")")
    _Team_FillForHero($GC_I_HERO_ID_DUNKORO, "Dunkoro")
    _Team_FillForHero($GC_I_HERO_ID_TAHLKORA, "Tahlkora")
    _Team_FillForHero($GC_I_HERO_ID_ZHED_SHADOWHOOF, "Zhed")
    _Team_FillForHero($GC_I_HERO_ID_MASTER_OF_WHISPERS, "MasterOfWhispers")
EndFunc
Global $g_bTahlkoraSkillEnsured = False
Func _Team_EnsureTahlkoraSkill()
    Local Const $SKILL = 299
    Local Const $KAMADAN = $GC_I_MAP_ID_KAMADAN_JEWEL_OF_ISTAN
    Local Const $TX = -11385, $TY = 16140   
    Local $T = "[Tahlkora-skill] "
    If $g_bTahlkoraSkillEnsured Then Return True
    $g_bTahlkoraSkillEnsured = True
    If World_IsSkillLearnt($SKILL) Then
        Out($T & "skill " & $SKILL & " (Shielding Hands) ya aprendida -> ok")
        Return True
    EndIf
    Out($T & "skill " & $SKILL & " NO aprendida -> comprar en Kamadan (Pikin)")
    Local $originMap = Map_GetMapID()
    If $originMap <> $KAMADAN Then
        If Map_GetInstanceInfo("Type") <> $GC_I_MAP_TYPE_OUTPOST Then
            Out($T & "en explorable/mid-quest (map=" & $originMap & ") -> skip compra (se reintenta en outpost)")
            Return False
        EndIf
        If Not Travel_ToOutpost($KAMADAN) Then
            Out($T & "FAIL travel a Kamadan (" & $KAMADAN & ")")
            Return False
        EndIf
        Sleep(1500)
    EndIf
    Local $trainer = 0
    Local $tWalk = TimerInit(), $tEmit = TimerInit()
    Map_Move($TX, $TY, 0)
    While Not Bot_ShouldStop() And TimerDiff($tWalk) < 120000
        Local $best = 999999.0
        Local $ags = Agent_GetAgentArray($GC_I_AGENT_TYPE_LIVING)
        If IsArray($ags) Then
            For $j = 0 To UBound($ags) - 1
                If $ags[$j] = 0 Then ContinueLoop
                If Agent_GetAgentInfo($ags[$j], "PlayerNumber") <> 4751 Then ContinueLoop
                Local $ttx = Agent_GetAgentInfo($ags[$j], "X"), $tty = Agent_GetAgentInfo($ags[$j], "Y")
                Local $ttd = Sqrt(($ttx - $TX)^2 + ($tty - $TY)^2)
                If $ttd < $best Then
                    $best = $ttd
                    $trainer = $ags[$j]
                EndIf
            Next
        EndIf
        If $trainer <> 0 And $best < 300 Then ExitLoop
        If TimerDiff($tEmit) >= 2500 Then
            Map_Move($TX, $TY, 0)
            $tEmit = TimerInit()
        EndIf
        Sleep(500)
    WEnd
    If $trainer = 0 Then
        Out($T & "Pikin (4751) no encontrado cerca de (" & $TX & "," & $TY & ") -> skip compra")
        Return False
    EndIf
    Out($T & "Pikin agent=" & $trainer & " -> GoNPC")
    Agent_GoNPC($trainer)
    Sleep(2500)
    Local $bought = False
    For $a = 1 To 2
        Out($T & "intento " & $a & ": menu Monk (0x800300) + Skill_BuySkillByID(" & $SKILL & ")")
        Agent_ChangeTarget($trainer)
        Sleep(300)
        Bot_Dialog(0x800300)   
        Sleep(2500)
        Skill_BuySkillByID($SKILL)
        Sleep(2500)
        If World_IsSkillLearnt($SKILL) Then
            $bought = True
            ExitLoop
        EndIf
    Next
    If Not $bought Then
        Out($T & "Compra FALLO: skill " & $SKILL & " tras 2 intentos -> la barra usara fallback")
        If $originMap <> $KAMADAN And $originMap > 0 Then
            Out($T & "round-trip: volver al outpost origen " & $originMap)
            Travel_ToOutpost($originMap)
        EndIf
        Return False
    EndIf
    Out($T & "Compra OK: Shielding Hands (299) aprendida")
    If $originMap <> $KAMADAN And $originMap > 0 Then
        Out($T & "round-trip: volver al outpost origen " & $originMap)
        Travel_ToOutpost($originMap)
    EndIf
    Return True
EndFunc
Func _Team_FillForHero($heroId, $name)
    Local $slot = _AutoLevel_FindHeroSlot($heroId)
    If $slot <= 0 Then Return 0
    If $name = "Dunkoro" Then
        Local $aExpD[9] = [0, 1397, 281, 1396, 299, 307, 245, 61, 68]
        Local $aPoolD[12] = [299, 313, 288, 277, 68, 281, 307, 258, 301, 305, 61, 200]
        Return _Team_FillEmptySlots($heroId, $name, $slot, $aExpD, $aPoolD)
    ElseIf $name = "Tahlkora" Then
        Local $aExpT[9] = [0, 1397, 281, 1396, 1399, 258, 245, 61, 68]
        Local $aPoolT[12] = [299, 313, 288, 277, 68, 281, 258, 307, 301, 305, 61, 200]
        Return _Team_FillEmptySlots($heroId, $name, $slot, $aExpT, $aPoolT)
    ElseIf $name = "Zhed" Then
        Local $aExpZ[9] = [0, 884, 1379, 845, 187, 197, 180, 184, 2]
        Local $aPoolZ[8] = [183, 197, 187, 194, 200, 184, 180, 2]
        Return _Team_FillEmptySlots($heroId, $name, $slot, $aExpZ, $aPoolZ)
    ElseIf $name = "MasterOfWhispers" Or $name = "MoW" Then
        Local $aExpM[9] = [0, 119, 197, 187, 1379, 845, 194, 184, 2]
        Local $aPoolM[10] = [25, 26, 28, 40, 92, 109, 143, 153, 183, 197]
        Return _Team_FillEmptySlots($heroId, $name, $slot, $aExpM, $aPoolM)
    EndIf
    Return 0
EndFunc
Func _Team_FillEmptySlots($heroId, $name, $slot, $aExpected, $aPool)
    Local $cur[9] = [0, 0, 0, 0, 0, 0, 0, 0, 0]
    Local $nEmpty = 0
    For $s = 1 To 8
        $cur[$s] = Skill_GetSkillbarInfo($s, "SkillID", $slot)
        If $cur[$s] = 0 Then $nEmpty += 1
    Next
    If $nEmpty = 0 Then Return 0
    Local $filled = 0
    For $s = 1 To 8
        If $cur[$s] <> 0 Then ContinueLoop
        For $p = 0 To UBound($aPool) - 1
            Local $cand = $aPool[$p]
            If Not World_IsSkillLearnt($cand) Then ContinueLoop
            Local $dup = False
            For $q = 1 To 8
                If $cur[$q] = $cand Then
                    $dup = True
                    ExitLoop
                EndIf
            Next
            If $dup Then ContinueLoop
            Local $snap[9] = [0, 0, 0, 0, 0, 0, 0, 0, 0]
            For $w = 1 To 8
                $snap[$w] = Skill_GetSkillbarInfo($w, "SkillID", $slot)
            Next
            Local $tryBar[9] = [0, 0, 0, 0, 0, 0, 0, 0, 0]
            For $w = 1 To 8
                $tryBar[$w] = $snap[$w]
            Next
            $tryBar[$s] = $cand
            Skill_LoadSkillBar($tryBar[1], $tryBar[2], $tryBar[3], $tryBar[4], $tryBar[5], $tryBar[6], $tryBar[7], $tryBar[8], $slot)
            Sleep(2500)
            Cache_SkillBar()
            Sleep(800)
            If Skill_GetSkillbarInfo($s, "SkillID", $slot) = $cand Then
                Out("[Team] " & $name & " slot" & $s & " vacio (falta " & $aExpected[$s] & ") -> sustituto " & $cand & " OK")
                $cur[$s] = $cand
                $filled += 1
                ExitLoop
            EndIf
            Out("[Team] " & $name & " slot" & $s & " candidato " & $cand & " rechazado -> siguiente")
            Skill_LoadSkillBar($snap[1], $snap[2], $snap[3], $snap[4], $snap[5], $snap[6], $snap[7], $snap[8], $slot)
            Sleep(1500)
        Next
    Next
    Out("[Team] " & $name & ": sustitutos instalados " & $filled & "/" & $nEmpty)
    Return $filled
EndFunc
Func _Team_AuditSkillUnlocks()
    Static $done = False
    If $done Then Return
    $done = True
    Local $aAll[80] = [1, 2, 23, 25, 26, 28, 40, 42, 61, 68, 69, 92, 109, 119, 143, 153, 176, 177, 180, 183, 184, 186, 187, 194, 197, 200, 245, 258, 277, 281, 287, 288, 299, 301, 305, 307, 313, 321, 322, 343, 348, 382, 384, 385, 824, 845, 851, 860, 884, 1379, 1381, 1396, 1397, 1399, 1484, 1487, 1490, 1493, 1503, 1506, 1507, 1517, 1526, 1535, 1539, 1544, 1546, 1551, 1557, 1558, 1572, 1584, 1595, 1600, 1605, 1691, 1763, 1774, 1816, 2107]
    Local $sMissing = "", $nLearnt = 0
    For $i = 0 To 79
        If World_IsSkillLearnt($aAll[$i]) Then
            $nLearnt += 1
        Else
            $sMissing &= $aAll[$i] & ","
        EndIf
    Next
    Out("[Team] SKILLS-AUDIT cuenta: " & $nLearnt & "/80 aprendidas. FALTAN: " & $sMissing)
EndFunc
Func _Team_ApplyTahlkoraBar()
    Local $slot = _AutoLevel_FindHeroSlot($GC_I_HERO_ID_TAHLKORA)
    If $slot <= 0 Then
        Out("[Tahlkora-bar] Tahlkora no en party (slot=" & $slot & ") -> no se aplica barra")
        Return False
    EndIf
    Local $aBar[9] = [0, 299, 281, 307, 301, 1396, 1399, 245, 305]   
    If Not World_IsSkillLearnt($aBar[1]) Then
        Local $aCand[4] = [277, 288, 313, 299]
        For $i = 0 To UBound($aCand) - 1
            If World_IsSkillLearnt($aCand[$i]) Then
                Out("[Tahlkora-bar] slot1: skill 299 no aprendida -> sustituto " & $aCand[$i])
                $aBar[1] = $aCand[$i]
                ExitLoop
            EndIf
        Next
    EndIf
    Out("[Tahlkora-bar] Tahlkora slot " & $slot & " -> [" & $aBar[1] & "," & $aBar[2] & "," & $aBar[3] & "," & $aBar[4] & "," & $aBar[5] & "," & $aBar[6] & "," & $aBar[7] & "," & $aBar[8] & "]")
    Skill_LoadSkillBar($aBar[1], $aBar[2], $aBar[3], $aBar[4], $aBar[5], $aBar[6], $aBar[7], $aBar[8], $slot)
    Sleep(2500)
    Cache_SkillBar()
    Sleep(800)
    For $s = 1 To 8
        Local $vid = Skill_GetSkillbarInfo($s, "SkillID", $slot)
        If $vid = 0 Then
            Out("[Tahlkora-bar] WARN slot " & $s & " vacio (skill " & $aBar[$s] & " no disponible)")
        EndIf
    Next
    Local $v1 = Skill_GetSkillbarInfo(1, "SkillID", $slot)
    Out("[Tahlkora-bar] verificado slot1=" & $v1)
    Return ($v1 <> 0)
EndFunc