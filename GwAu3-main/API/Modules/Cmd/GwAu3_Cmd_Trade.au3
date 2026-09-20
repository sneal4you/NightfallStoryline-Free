#include-once
Func Trade_InitiateTrade_($a_v_Agent)
    Return Core_SendPacket(0x08, $GC_I_HEADER_TRADE_INITIATE, Agent_ConvertID($a_v_Agent))
EndFunc   
Func Trade_AcceptTrade_()
    Return Core_SendPacket(0x4, $GC_I_HEADER_TRADE_ACCEPT)
EndFunc   
Func Trade_SubmitOffer_($a_i_Gold = 0)
    Return Core_SendPacket(0x8, $GC_I_HEADER_TRADE_SUBMIT_OFFER, $a_i_Gold)
EndFunc   
Func Trade_CancelTrade_()
    Return Core_SendPacket(0x4, $GC_I_HEADER_TRADE_CANCEL)
EndFunc   
Func Trade_ChangeOffer_()
    Return Core_SendPacket(0x4, $GC_I_HEADER_TRADE_CHANGE_OFFER)
EndFunc   
Func Trade_OfferItem_($a_i_ItemID, $a_i_Quantity = 1)
    Return Core_SendPacket(0xC, $GC_I_HEADER_TRADE_ADD_ITEM, $a_i_ItemID, $a_i_Quantity)
EndFunc   
Func Trade_InitTradePartner()
    Memory_Write($g_p_TradePartner, 0)
EndFunc
Func Trade_GetTradePartner()
    Local $l_i_TradePartner = Memory_Read($g_p_TradePartner)
    If $l_i_TradePartner <> 0 Then 
        Memory_Write($g_p_TradePartner, 0)
        Return $l_i_TradePartner
    EndIf
    Return 0
EndFunc
Func Trade_InitiateTrade($a_v_Agent)
    DllStructSetData($g_d_TradeInitiate, 2, $GC_I_UIMSG_INITIATE_TRADE)
    DllStructSetData($g_d_TradeInitiate, 3, Agent_ConvertID($a_v_Agent))
    Core_Enqueue($g_p_TradeInitiate, 12)
EndFunc   
Func Trade_CancelTrade()
    If Not Trade_WaitIdle() Then Return SetError(3, 0, False)
    Local $l_b_Result = Trade_CallSession('TradeSessAbort')
    Return SetError(@error, 0, $l_b_Result)
EndFunc
Func Trade_AcceptTrade()
    If Not Trade_WaitIdle() Then Return SetError(3, 0, False)
    Local $l_b_Result = Trade_CallSession('TradeSessConfirm')
    Return SetError(@error, 0, $l_b_Result)
EndFunc
Func Trade_SubmitOffer($a_i_Gold = 0)
    If Not Trade_WaitIdle() Then Return SetError(3, 0, False)
    Local $l_b_Result = Trade_CallSession('TradeSessSubmit', $a_i_Gold)
    Return SetError(@error, 0, $l_b_Result)
EndFunc
Func Trade_OfferItem($a_v_Item, $a_i_Qty = 1)
    If Not Trade_WaitIdle() Then Return SetError(3, 0, False)
    Local $l_b_Result = Trade_CallSession('TradeSessOfferItem', Item_ItemID($a_v_Item), $a_i_Qty)
    Return SetError(@error, 0, $l_b_Result)
EndFunc
#Region Trade Session Natives
Func Trade_CallSession($a_s_Native, $a_i_Arg1 = 0, $a_i_Arg2 = 0, $a_i_Timeout = 250)
    Local $l_p_Native = Memory_GetValue($a_s_Native)
    If $l_p_Native = 0 Then Return SetError(1, 0, False)
    If Trade_GetTradePtr() = 0 Then Return SetError(2, 0, False)
    If BitAND(Trade_GetTradeInfo("Flags"), $GC_I_TRADE_FLAG_ACTIVE) = 0 Then Return SetError(4, 0, False)
    DllStructSetData($g_d_TradeSession, 2, $l_p_Native)
    DllStructSetData($g_d_TradeSession, 3, $a_i_Arg1)
    DllStructSetData($g_d_TradeSession, 4, $a_i_Arg2)
    Memory_Write($g_p_TradeSessReady, $GC_I_TRADESESS_STATE_PENDING, "dword")
    Core_Enqueue($g_p_TradeSession, 16)
    Local $l_i_Timer = TimerInit()
    While TimerDiff($l_i_Timer) < $a_i_Timeout
        Local $l_i_State = Memory_Read($g_p_TradeSessReady, "dword")
        If $l_i_State = $GC_I_TRADESESS_STATE_SKIPPED Then Return SetError(2, 0, False)
        If $l_i_State = $GC_I_TRADESESS_STATE_DONE Then Return (Memory_Read($g_p_TradeSessResult, "dword") <> 0)
        Sleep(10)
    WEnd
    Return SetError(3, 0, False)
EndFunc
Func Trade_WaitIdle($a_i_Timeout = 3000)
    Local $l_i_Timer = TimerInit()
    While TimerDiff($l_i_Timer) < $a_i_Timeout
        If Not Trade_GetTradeInfo("IsBusy") Then Return True
        Sleep(20)
    WEnd
    Return False
EndFunc
Func Trade_RevokeItem($a_v_Item)
    If Not Trade_WaitIdle() Then Return SetError(3, 0, False)
    Local $l_b_Result = Trade_CallSession('TradeSessRevokeItem', Item_ItemID($a_v_Item))
    Return SetError(@error, 0, $l_b_Result)
EndFunc
Func Trade_RevokeOffer()
    If Not Trade_WaitIdle() Then Return SetError(3, 0, False)
    Local $l_b_Result = Trade_CallSession('TradeSessRevokeSubmit')
    Return SetError(@error, 0, $l_b_Result)
EndFunc
Func Trade_RevokeAccept()
    If Not Trade_WaitIdle() Then Return SetError(3, 0, False)
    Local $l_b_Result = Trade_CallSession('TradeSessRevokeConfirm')
    Return SetError(@error, 0, $l_b_Result)
EndFunc
#EndRegion Trade Session Natives