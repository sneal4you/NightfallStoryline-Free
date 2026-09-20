#include-once
Global $g_iAutoLevelLastUnused = 0
Global $g_iAutoLevelStuckTicks = 0       
Global $g_iAutoLevelSkipMask = 0         
Global $g_bCustomHeroAttrs = True         
Global $g_bAutoLevelCharPending = False
Global $g_iAutoLevelCharLastUnused = -1
Global Const $KOSS_TEMPLATE = "OQATEHqVl4q+FwBWocNACAA"
Global $g_iKossLastUnused = -1
Global Const $DUNKORO_TEMPLATE = "OwAT0uXAjJnkRAJtE6aFZmETAA"
Global $g_iDunkoroLastUnused = -1
Global Const $TAHLKORA_TEMPLATE = "OwAT0uHDrZlkRmJtE66dteETAA"
Global $g_iTahlkoraLastUnused = -1
Global Const $MELONNI_TEMPLATE = "OgGikeszcV+vS3BMXZ8OuFAA"
Global $DAJKAH_KOSS_TEMPLATE     = "OQATEL6Wn4q+FwBWocNACAA"      
Global $DAJKAH_DUNKORO_TEMPLATE  = "OwUUMmG/GYNEhMCIplQXrIzkYCA"   
Global $DAJKAH_TAHLKORA_TEMPLATE = "OwUUMoW+UoNEhMyMplQXvr1jYCA"   
Global $DAJKAH_MELONNI_TEMPLATE  = "OgGjUNpLbNXl/r0dAzVGvjbBAA"   
Global $g_iMelonniLastUnused = -1
Func AutoLevel_Tick()
    If Not $Bot_Core_Initialized Then Return
    Local $mapId = Map_GetMapID()
    Local $inOutpost = ($mapId <> 0 And Not Map_GetInstanceInfo("IsLoading") _
            And Map_GetInstanceInfo("Type") = $GC_I_MAP_TYPE_OUTPOST)
    If $g_bAutoLevelCharPending And $inOutpost Then
        _AutoLevel_ProcessChar()
    EndIf
    If $g_bActionRunning Then Return
    If Not $inOutpost Then Return
    _AutoLevel_ProcessKoss()
    _AutoLevel_ProcessDunkoro()
    _AutoLevel_ProcessTahlkora()
    _AutoLevel_ProcessMelonni()
EndFunc
Func AutoLevel_OnLevelUp($newLevel)
    Out("[AutoLevel] Senal de level-up recibida (level=" & $newLevel & ") -> pending")
    $g_bAutoLevelCharPending = True
EndFunc
Func AutoLevel_TickCharOnly()
    If Not $Bot_Core_Initialized Then Return
    Local $mapId = Map_GetMapID()
    Local $inOutpost = ($mapId <> 0 And Not Map_GetInstanceInfo("IsLoading") _
            And Map_GetInstanceInfo("Type") = $GC_I_MAP_TYPE_OUTPOST)
    If Not $inOutpost Then
        $g_iAutoLevelCharLastUnused = -1   
        Return
    EndIf
    Local $unused = Attribute_GetPartyAttributePointInfo(0, "UnusedPoints")
    If @error Then Return
    If $unused <= 0 Then
        $g_bAutoLevelCharPending = False
        $g_iAutoLevelCharLastUnused = 0
        Return
    EndIf
    If $unused <= $g_iAutoLevelCharLastUnused Then Return
    _AutoLevel_ProcessChar()
    Local $post = Attribute_GetPartyAttributePointInfo(0, "UnusedPoints")
    If @error Then
        $g_iAutoLevelCharLastUnused = $unused
        Return
    EndIf
    If $post < 0 Then $post = 0
    $g_iAutoLevelCharLastUnused = $post
EndFunc
Func _AutoLevel_ProcessKoss($sTemplate = "")
    If $sTemplate = "" Then $sTemplate = $KOSS_TEMPLATE
    Local $heroSlot = _AutoLevel_FindHeroSlot($GC_I_HERO_ID_KOSS)
    If $heroSlot = 0 Then Return
    Local $unused = Attribute_GetPartyAttributePointInfo($heroSlot, "UnusedPoints")
    If @error Then Return
    If $unused <= 0 Then
        $g_iKossLastUnused = 0
        Return
    EndIf
    If $unused <= $g_iKossLastUnused Then Return
    If $g_bCustomHeroAttrs Then
        Out("[AutoLevel] Koss " & $unused & " unused points -> ForceHeroAttrs")
        _Team_ForceHeroAttrs($GC_I_HERO_ID_KOSS, $heroSlot, "Koss", $g_aiKossAttrs)
    Else
        Out("[AutoLevel] Koss " & $unused & " unused points -> LoadSkillTemplate")
        Attribute_LoadSkillTemplate($sTemplate, $heroSlot)
        Sleep(500)
    EndIf
    Local $unusedPost = Attribute_GetPartyAttributePointInfo($heroSlot, "UnusedPoints")
    If @error Or $unusedPost < 0 Then $unusedPost = $unused
    $g_iKossLastUnused = $unusedPost
EndFunc
Func _AutoLevel_ProcessDunkoro($sTemplate = "")
    If $sTemplate = "" Then $sTemplate = $DUNKORO_TEMPLATE
    Local $heroSlot = _AutoLevel_FindHeroSlot($GC_I_HERO_ID_DUNKORO)
    If $heroSlot = 0 Then Return
    Local $unused = Attribute_GetPartyAttributePointInfo($heroSlot, "UnusedPoints")
    If @error Then Return
    If $unused <= 0 Then
        $g_iDunkoroLastUnused = 0
        Return
    EndIf
    If $unused <= $g_iDunkoroLastUnused Then Return
    If $g_bCustomHeroAttrs Then
        Out("[AutoLevel] Dunkoro " & $unused & " unused points -> ForceHeroAttrs")
        _Team_ForceHeroAttrs($GC_I_HERO_ID_DUNKORO, $heroSlot, "Dunkoro", $g_aiDunkoroAttrs)
    Else
        Out("[AutoLevel] Dunkoro " & $unused & " unused points -> LoadSkillTemplate")
        Attribute_LoadSkillTemplate($sTemplate, $heroSlot)
        Sleep(500)
    EndIf
    Local $unusedPost = Attribute_GetPartyAttributePointInfo($heroSlot, "UnusedPoints")
    If @error Or $unusedPost < 0 Then $unusedPost = $unused
    $g_iDunkoroLastUnused = $unusedPost
EndFunc
Func _AutoLevel_ProcessMelonni($sTemplate = "")
    If $sTemplate = "" Then $sTemplate = $MELONNI_TEMPLATE
    Local $heroSlot = _AutoLevel_FindHeroSlot($GC_I_HERO_ID_MELONNI)
    If $heroSlot = 0 Then Return
    Local $unused = Attribute_GetPartyAttributePointInfo($heroSlot, "UnusedPoints")
    If @error Then Return
    If $unused <= 0 Then
        $g_iMelonniLastUnused = 0
        Return
    EndIf
    If $unused <= $g_iMelonniLastUnused Then Return
    If $g_bCustomHeroAttrs Then
        Out("[AutoLevel] Melonni " & $unused & " unused points -> ForceHeroAttrs")
        _Team_ForceHeroAttrs($GC_I_HERO_ID_MELONNI, $heroSlot, "Melonni", $g_aiMelonniAttrs)
    Else
        Out("[AutoLevel] Melonni " & $unused & " unused points -> LoadSkillTemplate")
        Attribute_LoadSkillTemplate($sTemplate, $heroSlot)
        Sleep(500)
    EndIf
    Local $unusedPost = Attribute_GetPartyAttributePointInfo($heroSlot, "UnusedPoints")
    If @error Or $unusedPost < 0 Then $unusedPost = $unused
    $g_iMelonniLastUnused = $unusedPost
EndFunc
Func _AutoLevel_ProcessTahlkora($sTemplate = "")
    If $sTemplate = "" Then $sTemplate = $TAHLKORA_TEMPLATE
    Local $heroSlot = _AutoLevel_FindHeroSlot($GC_I_HERO_ID_TAHLKORA)
    If $heroSlot = 0 Then Return
    Local $unused = Attribute_GetPartyAttributePointInfo($heroSlot, "UnusedPoints")
    If @error Then Return
    If $unused <= 0 Then
        $g_iTahlkoraLastUnused = 0
        Return
    EndIf
    If $unused <= $g_iTahlkoraLastUnused Then Return
    If $g_bCustomHeroAttrs Then
        Out("[AutoLevel] Tahlkora " & $unused & " unused points -> ForceHeroAttrs")
        _Team_ForceHeroAttrs($GC_I_HERO_ID_TAHLKORA, $heroSlot, "Tahlkora", $g_aiTahlkoraAttrs)
    Else
        Out("[AutoLevel] Tahlkora " & $unused & " unused points -> LoadSkillTemplate")
        Attribute_LoadSkillTemplate($sTemplate, $heroSlot)
        Sleep(500)
    EndIf
    Local $unusedPost = Attribute_GetPartyAttributePointInfo($heroSlot, "UnusedPoints")
    If @error Or $unusedPost < 0 Then $unusedPost = $unused
    $g_iTahlkoraLastUnused = $unusedPost
EndFunc
Func _AutoLevel_FindHeroSlot($heroId)
    Local $nSlots = Party_GetMyPartyInfo("ArrayHeroPartyMemberSize")
    If @error Then Return 0
    For $i = 1 To $nSlots
        If Party_GetMyPartyHeroInfo($i, "HeroID") = $heroId Then Return $i
    Next
    Return 0
EndFunc
Func _AutoLevel_ProcessChar()
    Local $cx = Agent_GetAgentInfo(-2, "X")
    Local $cy = Agent_GetAgentInfo(-2, "Y")
    Local $isDead = Agent_GetAgentInfo(-2, "IsDead")
    Local $maxhp = Agent_GetAgentInfo(-2, "MaxHP")   
    If $isDead Or $maxhp = 0 Or ($cx = 0 And $cy = 0) Then
        Out("[AutoLevel] Char inestable (dead=" & $isDead & " maxhp=" & $maxhp & " pos=(" & $cx & "," & $cy & ")) -> diferir asignacion")
        Return
    EndIf
    Out("[AutoLevel] Char vivo y estable -> asignar atributos (margen 1s)")
    Sleep(1000)
    $cx = Agent_GetAgentInfo(-2, "X")
    $cy = Agent_GetAgentInfo(-2, "Y")
    $isDead = Agent_GetAgentInfo(-2, "IsDead")
    $maxhp = Agent_GetAgentInfo(-2, "MaxHP")
    If $isDead Or $maxhp = 0 Or ($cx = 0 And $cy = 0) Then
        Out("[AutoLevel] Char inestable tras 5s -> diferir")
        Return
    EndIf
    Local $unused = Attribute_GetPartyAttributePointInfo(0, "UnusedPoints")
    If @error Then Return
    If $unused <= 0 Then
        $g_bAutoLevelCharPending = False
        $g_iAutoLevelSkipMask = 0
        _AutoLevel_TryCloseAttributePanel()
        Return
    EndIf
    Out("[AutoLevel] Hay " & $unused & " puntos libres -> asignando atributos")
    $g_iAutoLevelSkipMask = 0
    Local $iter = 0
    While $unused > 0 And $iter < 30
        $iter += 1
        Local $nextAttr = _AutoLevel_PickNextAttribute()
        If $nextAttr = 0 Then
            Out("[AutoLevel] Sin atributos asignables (cap), " & $unused & " puntos libres quedan")
            ExitLoop
        EndIf
        Local $unusedBefore = $unused
        Attribute_IncreaseAttribute($nextAttr, 1)
        Sleep(500)   
        $unused = Attribute_GetPartyAttributePointInfo(0, "UnusedPoints")
        If @error Then ExitLoop
        If $unused >= $unusedBefore Then
            If $nextAttr = $GC_I_ATTRIBUTE_SCYTHE_MASTERY Then
                Out("[AutoLevel] Scythe cap alcanzado, saltar a Mysticism")
                $g_iAutoLevelSkipMask = BitOR($g_iAutoLevelSkipMask, 1)
            ElseIf $nextAttr = $GC_I_ATTRIBUTE_MYSTICISM Then
                Out("[AutoLevel] Mysticism cap alcanzado, " & $unused & " puntos quedan libres")
                $g_iAutoLevelSkipMask = BitOR($g_iAutoLevelSkipMask, 2)
            EndIf
        Else
            Out("[AutoLevel] +1 " & _AutoLevel_AttrName($nextAttr) & " (unused " & $unusedBefore & "->" & $unused & ")")
        EndIf
    WEnd
    $g_bAutoLevelCharPending = False
    _AutoLevel_TryCloseAttributePanel()
EndFunc
Func _AutoLevel_AttrName($attrId)
    Switch $attrId
        Case $GC_I_ATTRIBUTE_SCYTHE_MASTERY
            Return "Scythe Mastery"
        Case $GC_I_ATTRIBUTE_MYSTICISM
            Return "Mysticism"
        Case $GC_I_ATTRIBUTE_EARTH_PRAYERS
            Return "Earth Prayers"
        Case $GC_I_ATTRIBUTE_WIND_PRAYERS
            Return "Wind Prayers"
        Case Else
            Return "attr " & $attrId
    EndSwitch
EndFunc
Func _AutoLevel_PickNextAttribute()
    If BitAND($g_iAutoLevelSkipMask, 1) = 0 _
            And Attribute_GetPartyAttributeInfo($GC_I_ATTRIBUTE_SCYTHE_MASTERY, 0, "IsRaisable") Then
        Return $GC_I_ATTRIBUTE_SCYTHE_MASTERY
    EndIf
    If BitAND($g_iAutoLevelSkipMask, 2) = 0 _
            And Attribute_GetPartyAttributeInfo($GC_I_ATTRIBUTE_MYSTICISM, 0, "IsRaisable") Then
        Return $GC_I_ATTRIBUTE_MYSTICISM
    EndIf
    Return 0
EndFunc
Func _AutoLevel_TryCloseAttributePanel()
    Bot_Dialog(0x80)
    Sleep(300)
    Local $hWin = WinGetHandle("[CLASS:ArenaNet_Dx_Window_Class]")
    If $hWin = "" Or @error Then Return
    ControlSend($hWin, "", "", "{ESC}")
    Sleep(200)
EndFunc