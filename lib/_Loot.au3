#include-once
Global $g_Loot_LastRunTimer = 0
Global Const $LOOT_COOLDOWN_MS = 3000
Global Const $LOOT_RANGE       = 1300
Global $g_Loot_SkipIDs = "|"
Global $g_LootNavLock = False
Func Loot_Tick()
    If Not $Bot_Core_Initialized Then Return
    If $g_bPostTravelQuietUntil <> 0 And TimerDiff($g_bPostTravelQuietUntil) < 4000 Then Return
    If $g_LootNavLock Then Return              
    If Agent_GetAgentInfo(-2, "IsDead") Then Return   
    If Map_GetInstanceInfo("IsLoading") Then Return
    Local $mapType = Map_GetInstanceInfo("Type")
    If $mapType <> 1 And $mapType <> 2 Then Return  
    If $g_Loot_LastRunTimer <> 0 And TimerDiff($g_Loot_LastRunTimer) < $LOOT_COOLDOWN_MS Then Return
    $g_Loot_LastRunTimer = TimerInit()
    If GetNearestEnemy(2800) <> 0 Then Return
    Loot_PickupNearby($LOOT_RANGE)
EndFunc
Func Loot_PickupNearby($range = 1300)
    If BitAND(Agent_GetAgentInfo(-2, "TransmogNpcId"), 0x20000000) <> 0 Then Return 0
    If _Inv_CountFreeSlots() <= 0 Then
        Static $s_lastFullWarn = 0
        If $s_lastFullWarn = 0 Or TimerDiff($s_lastFullWarn) > 60000 Then
            Out("[Loot] inventario LLENO -> ignorando objetos del suelo")
            $s_lastFullWarn = TimerInit()
        EndIf
        Return 0
    EndIf
    Local $cx = Agent_GetAgentInfo(-2, "X")
    Local $cy = Agent_GetAgentInfo(-2, "Y")
    If $cx = 0 And $cy = 0 Then Return 0
    Local $picked = 0
    Local $tLoot = TimerInit()
    Local $tried = "|"   
    While TimerDiff($tLoot) < 8000   
        $cx = Agent_GetAgentInfo(-2, "X")
        $cy = Agent_GetAgentInfo(-2, "Y")
        If $cx = 0 And $cy = 0 Then ExitLoop
        Local $bestAgent = 0
        Local $bestScore = 0
        Local $bestDist  = $range + 1
        Local $items = Agent_GetAgentArray($GC_I_AGENT_TYPE_ITEM)
        If Not IsArray($items) Or $items[0] = 0 Then ExitLoop
        For $i = 1 To $items[0]
            Local $ptr = $items[$i]
            If $ptr = 0 Then ContinueLoop
            Local $ax = Agent_GetAgentInfo($ptr, "X")
            Local $ay = Agent_GetAgentInfo($ptr, "Y")
            Local $dist = Sqrt(($ax - $cx)^2 + ($ay - $cy)^2)
            If $dist > $range Then ContinueLoop
            Local $agentId = Agent_GetAgentInfo($ptr, "ID")
            If $agentId = 0 Then ContinueLoop
            If StringInStr($tried, "|" & $agentId & "|") Then ContinueLoop          
            If StringInStr($g_Loot_SkipIDs, "|" & $agentId & "|") Then ContinueLoop  
            Local $score = _Loot_GetScore($agentId)
            If $score <= 0 Then ContinueLoop
            If $score > $bestScore Or ($score = $bestScore And $dist < $bestDist) Then
                $bestScore = $score
                $bestDist  = $dist
                $bestAgent = $agentId
            EndIf
        Next
        If $bestAgent = 0 Then ExitLoop   
        Local $name = Item_GetItemInfoByAgentID($bestAgent, "CompleteName")
        If $name = 0 Or $name = "" Then $name = Item_GetItemInfoByAgentID($bestAgent, "Name")
        If $name = 0 Or $name = "" Then $name = "item"
        Out("[Loot] Recogiendo: " & $name & " (score=" & $bestScore & " dist=" & Round($bestDist, 0) & "u)")
        $tried &= $bestAgent & "|"   
        Local $pcx = $cx, $pcy = $cy   
        Item_PickUpItem($bestAgent)
        Sleep(2500)   
        Local $ncx = Agent_GetAgentInfo(-2, "X"), $ncy = Agent_GetAgentInfo(-2, "Y")
        If $bestDist > 250 And Sqrt(($ncx-$pcx)^2+($ncy-$pcy)^2) < 150 Then
            $g_Loot_SkipIDs &= $bestAgent & "|"
            Out("[Loot] item id=" & $bestAgent & " INALCANZABLE (char no se movió) -> skip permanente")
        EndIf
        $picked += 1
    WEnd
    If $picked > 0 Then Out("[Loot] Total recogidos en esta pasada: " & $picked)
    Return $picked
EndFunc
Func _Loot_GetScore($agentId)
    Local $itemType = Item_GetItemInfoByAgentID($agentId, "ItemType")
    If $itemType = $GC_I_TYPE_GOLD_COINS Then Return 30
    If $itemType = $GC_I_TYPE_QUEST_ITEM Then Return 95
    Local $rarity = Item_GetItemInfoByAgentID($agentId, "Rarity")
    If $rarity = $GC_I_RARITY_GREEN Or $rarity = 2627 Or $rarity = 5 Then Return 90
    If $rarity = $GC_I_RARITY_GOLD Or $rarity = 2624 Or $rarity = 4 Then Return 70
    If $rarity = $GC_I_RARITY_PURPLE Or $rarity = 2625 Or $rarity = 3 Then Return 50
    Return 0   
EndFunc