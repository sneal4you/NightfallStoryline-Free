#include-once
Global $g_iLastCatapultTarget = 0
Global $g_bHasBundle = False
Func Gadget_Pickup($agentID)
    $g_bHasBundle = False
    If $agentID = 0 Then
        Out("[Gadget] Pickup FAIL: agentID=0")
        Return False
    EndIf
    Local $attempt = 0
    While Not Bot_ShouldStop() And $attempt < 3
        $attempt += 1
        Out("[Gadget] Recoger ID=" & $agentID & " (intento " & $attempt & "/3)")
        Agent_ChangeTarget($agentID)
        Sleep(250)
        Agent_GoSignpost($agentID)
        Sleep(2500)
        Agent_CancelAction()
        Sleep(500)
        If Item_GetInventoryInfo("BundleModelID") > 0 Then
            $g_bHasBundle = True
            Out("[Gadget] Pickup OK id=" & $agentID & " intento=" & $attempt)
            Return True
        EndIf
        Out("[Gadget] Pickup intento " & $attempt & "/3: sin bundle, retry")
        Sleep(500)
    WEnd
    Out("[Gadget] Pickup FAIL: 3 intentos sin bundle id=" & $agentID)
    Return False
EndFunc
Func Gadget_LoadCatapult($agentID)
    If Not $g_bHasBundle Then
        Out("[Gadget] LoadCata SKIP: no tengo barril (pickup previo fallo)")
        $g_iLastCatapultTarget = 0
        Return False
    EndIf
    If $agentID = 0 Then
        Out("[Gadget] LoadCata FAIL: agentID=0")
        $g_iLastCatapultTarget = 0
        Return False
    EndIf
    Local $cX = Agent_GetAgentInfo($agentID, "X")
    Local $cY = Agent_GetAgentInfo($agentID, "Y")
    Out("[Gadget] Dejar barril en cata ID=" & $agentID & " pos=(" & Round($cX, 0) & "," & Round($cY, 0) & ")")
    Agent_ChangeTarget($agentID)
    Sleep(250)
    Agent_GoSignpost($agentID)
    Sleep(2000)
    $g_iLastCatapultTarget = $agentID
    $g_bHasBundle = False
    Out("[Gadget] LoadCata OK")
    Return True
EndFunc
Func Gadget_FireCatapult()
    If $g_iLastCatapultTarget = 0 Then
        Out("[Gadget] FireCata FAIL: no hay catapulta cargada")
        Return False
    EndIf
    Out("[Gadget] Disparar catapulta id=" & $g_iLastCatapultTarget)
    Agent_GoSignpost($g_iLastCatapultTarget)
    Sleep(3000)   
    $g_iLastCatapultTarget = 0   
    Out("[Gadget] FireCata OK")
    Return True
EndFunc
Func Gadget_FindNearest($range = 800)
    Local $myX = Agent_GetAgentInfo(-2, "X")
    Local $myY = Agent_GetAgentInfo(-2, "Y")
    Return Gadget_FindNearestToXY($myX, $myY, $range)
EndFunc
Func Gadget_FindNearestToXY($x, $y, $range = 500)
    Local $agents = Agent_GetAgentArray($GC_I_AGENT_TYPE_GADGET)
    If Not IsArray($agents) Or $agents[0] = 0 Then Return 0
    Local $bestId = 0
    Local $bestDist = $range
    For $i = 1 To $agents[0]
        Local $ptr = $agents[$i]
        If $ptr = 0 Then ContinueLoop
        Local $aX = Agent_GetAgentInfo($ptr, "X")
        Local $aY = Agent_GetAgentInfo($ptr, "Y")
        Local $dist = Sqrt(($aX - $x)^2 + ($aY - $y)^2)
        If $dist < $bestDist Then
            $bestDist = $dist
            $bestId = Agent_GetAgentInfo($ptr, "ID")
        EndIf
    Next
    Return $bestId
EndFunc
Func Gadget_LogNearby($range = 2500)
    Local $myX = Agent_GetAgentInfo(-2, "X")
    Local $myY = Agent_GetAgentInfo(-2, "Y")
    Out("[Gadget] LogNearby char=(" & Round($myX, 0) & "," & Round($myY, 0) & ") rango=" & $range)
    Local $agents = Agent_GetAgentArray($GC_I_AGENT_TYPE_GADGET)
    If Not IsArray($agents) Or $agents[0] = 0 Then
        Out("[Gadget] Sin gadgets en el mapa")
        Return
    EndIf
    Local $found = 0
    For $i = 1 To $agents[0]
        Local $ptr = $agents[$i]
        If $ptr = 0 Then ContinueLoop
        Local $aX = Agent_GetAgentInfo($ptr, "X")
        Local $aY = Agent_GetAgentInfo($ptr, "Y")
        Local $dist = Sqrt(($aX - $myX)^2 + ($aY - $myY)^2)
        If $dist > $range Then ContinueLoop
        Local $id = Agent_GetAgentInfo($ptr, "ID")
        Local $model = Agent_GetAgentInfo($ptr, "PlayerNumber")
        Out("[Gadget] id=" & $id & " model=" & $model & " pos=(" & Round($aX, 0) & "," & Round($aY, 0) & ") dist=" & Round($dist, 0))
        $found += 1
    Next
    If $found = 0 Then Out("[Gadget] Ninguno en " & $range & "u")
EndFunc