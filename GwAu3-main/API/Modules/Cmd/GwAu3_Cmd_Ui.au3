#include-once
Func Ui_Dialog($a_i_DialogID)
    DllStructSetData($g_d_Dialog, 2, $a_i_DialogID)
    Core_Enqueue($g_p_Dialog, 8)
EndFunc   
Func Ui_AcceptQuest($a_i_QuestID)
    DllStructSetData($g_d_Dialog, 2, '0x008' & Hex($a_i_QuestID, 3) & '01')
    Core_Enqueue($g_p_Dialog, 8)
EndFunc   
Func Ui_UpdateQuest($a_i_QuestID)
    DllStructSetData($g_d_Dialog, 2, '0x008' & Hex($a_i_QuestID, 3) & '04')
    Core_Enqueue($g_p_Dialog, 8)
EndFunc   
Func Ui_AboutQuest($a_i_QuestID)
    DllStructSetData($g_d_Dialog, 2, '0x008' & Hex($a_i_QuestID, 3) & '03')
    Core_Enqueue($g_p_Dialog, 8)
EndFunc   
Func Ui_RewardQuest($a_i_QuestID)
    DllStructSetData($g_d_Dialog, 2, '0x008' & Hex($a_i_QuestID, 3) & '07')
    Core_Enqueue($g_p_Dialog, 8)
EndFunc   
Func Ui_Interact($a_i_InteractionID)
    DllStructSetData($g_d_Interact, 2, $a_i_InteractionID)
    Core_Enqueue($g_p_Interact, 8)
EndFunc   
Func Ui_OpenChest($a_b_WithLockpick = True)
	If $a_b_WithLockpick Then
        DllStructSetData($g_d_Interact, 2, 2)
	Else
        DllStructSetData($g_d_Interact, 2, 1)
	EndIf
    Core_Enqueue($g_p_Interact, 8)
EndFunc 
Func Ui_ActivateReforgedMode()
    Ui_Interact(1)
EndFunc 
Func Ui_DeactivateReforgedMode()
    Ui_Interact(2)
EndFunc 
Func Ui_ActivateDhuumsCovenant()
    Ui_Interact(4)
EndFunc 
Func Ui_DeactivateDhuumsCovenant()
    Ui_Interact(5)
EndFunc 
Func Ui_Xunlai()
    DllStructSetData($g_d_Xunlai, 2, $GC_I_UIMSG_OPEN_XUNLAI)
    Core_Enqueue($g_p_Xunlai, 8)
EndFunc   
Func Ui_CloseDialog($a_i_DialogID)
    Local $l_i_Message
    Switch $a_i_DialogID
        Case $GC_I_UIDIALOG_INVUPGRADE
            $l_i_Message = $GC_I_UIMSG_CLOSE_DIALOG_INVUPGRADE
        Case $GC_I_UIDIALOG_SALVAGE
            $l_i_Message = $GC_I_UIMSG_CLOSE_DIALOG_SALVAGE
        Case Else
            Return SetError(1, 0, False)
    EndSwitch
    DllStructSetData($g_d_CloseDialog, 2, $l_i_Message)
    Core_Enqueue($g_p_CloseDialog, 8)
    Return True
EndFunc   
Func Ui_CommandHero($a_i_HeroNumber, $a_f_X, $a_f_Y)
    DllStructSetData($g_d_FlagHero, 2, Party_GetMyPartyHeroInfo($a_i_HeroNumber, "AgentID"))
    DllStructSetData($g_d_FlagHero, 3, Utils_FloatToInt($a_f_X))
    DllStructSetData($g_d_FlagHero, 4, Utils_FloatToInt($a_f_Y))
    DllStructSetData($g_d_FlagHero, 5, 0) 
    Core_Enqueue($g_p_FlagHero, 20)
EndFunc   
Func Ui_CancelHero($a_i_HeroNumber)
    DllStructSetData($g_d_FlagHero, 2, Party_GetMyPartyHeroInfo($a_i_HeroNumber, "AgentID"))
    DllStructSetData($g_d_FlagHero, 3, $GC_I_UIMSG_HERO_FLAG)
    DllStructSetData($g_d_FlagHero, 4, $GC_I_UIMSG_HERO_FLAG)
    DllStructSetData($g_d_FlagHero, 5, 0) 
    Core_Enqueue($g_p_FlagHero, 20)
EndFunc   
Func Ui_CommandAll($a_f_X, $a_f_Y)
    DllStructSetData($g_d_FlagAll, 2, Utils_FloatToInt($a_f_X))
    DllStructSetData($g_d_FlagAll, 3, Utils_FloatToInt($a_f_Y))
    DllStructSetData($g_d_FlagAll, 4, 0) 
    Core_Enqueue($g_p_FlagAll, 16)
EndFunc   
Func Ui_CancelAll()
    DllStructSetData($g_d_FlagAll, 2, $GC_I_UIMSG_HERO_FLAG)
    DllStructSetData($g_d_FlagAll, 3, $GC_I_UIMSG_HERO_FLAG)
    DllStructSetData($g_d_FlagAll, 4, 0) 
    Core_Enqueue($g_p_FlagAll, 16)
EndFunc   
Func Ui_SetHeroBehavior($a_i_HeroNumber, $a_i_Behavior = 1)
    DllStructSetData($g_d_SetHeroBehavior, 2, Party_GetMyPartyHeroInfo($a_i_HeroNumber, "AgentID"))
    DllStructSetData($g_d_SetHeroBehavior, 3, $a_i_Behavior)
    Core_Enqueue($g_p_SetHeroBehavior, 12)
EndFunc   
Func Ui_DropHeroBundle($a_i_HeroNumber)
    DllStructSetData($g_d_DropHeroBundle, 2, Party_GetMyPartyHeroInfo($a_i_HeroNumber, "AgentID"))
    Core_Enqueue($g_p_DropHeroBundle, 8)
EndFunc   
Func Ui_LockHeroTarget($a_i_HeroNumber, $a_i_TargetAgentID = 0)
    DllStructSetData($g_d_LockHeroTarget, 2, Party_GetMyPartyHeroInfo($a_i_HeroNumber, "AgentID"))
    DllStructSetData($g_d_LockHeroTarget, 3, Agent_ConvertID($a_i_TargetAgentID))
    Core_Enqueue($g_p_LockHeroTarget, 12)
EndFunc   
Func Ui_ToggleHeroSkillState($a_i_HeroNumber, $a_i_Skillslot)
    DllStructSetData($g_d_ToggleHeroSkillState, 2, Party_GetMyPartyHeroInfo($a_i_HeroNumber, "AgentID"))
    DllStructSetData($g_d_ToggleHeroSkillState, 3, $a_i_Skillslot - 1)
    Core_Enqueue($g_p_ToggleHeroSkillState, 12)
EndFunc   
Func Ui_EnableHeroSkill($a_i_HeroNumber, $a_i_SkillSlot)
	If Party_GetIsHeroSkillDisabled($a_i_HeroNumber, $a_i_SkillSlot) Then Ui_ToggleHeroSkillState($a_i_HeroNumber, $a_i_SkillSlot)
EndFunc   
Func Ui_DisableHeroSkill($a_i_HeroNumber, $a_i_SkillSlot)
	If Not Party_GetIsHeroSkillDisabled($a_i_HeroNumber, $a_i_SkillSlot) Then Ui_ToggleHeroSkillState($a_i_HeroNumber, $a_i_SkillSlot)
	Return True
EndFunc   
Func Ui_AddNPC($a_i_AgentID)
    DllStructSetData($g_d_AddNPC, 2, $a_i_AgentID)
    Core_Enqueue($g_p_AddNPC, 8)
EndFunc   
Func Ui_AddHero($a_i_HeroID)
    DllStructSetData($g_d_AddHero, 2, $a_i_HeroID)
    Core_Enqueue($g_p_AddHero, 8)
EndFunc   
Func Ui_KickNPC($a_i_AgentID)
    DllStructSetData($g_d_KickNPC, 2, $a_i_AgentID)
    Core_Enqueue($g_p_KickNPC, 8)
EndFunc   
Func Ui_KickHero($a_i_HeroID)
    DllStructSetData($g_d_KickHero, 2, $a_i_HeroID)
    Core_Enqueue($g_p_KickHero, 8)
EndFunc   
Func Ui_KickAllHeroes()
    DllStructSetData($g_d_KickHero, 2, 0x28)
    Core_Enqueue($g_p_KickHero, 8)
EndFunc   
Func Ui_LeaveGroup($a_b_KickAllHeroes = True)
    DllStructSetData($g_d_LeaveGroup, 2, 0x28)
    Core_Enqueue($g_p_LeaveGroup, 8)
    If $a_b_KickAllHeroes Then Ui_KickAllHeroes()
EndFunc   
Func Ui_SetDifficulty($a_b_HardMode = False)
    DllStructSetData($g_d_SetDifficulty, 2, $a_b_HardMode)
    Core_Enqueue($g_p_SetDifficulty, 8)
EndFunc   
Func Ui_EnterChallenge($a_b_Foreign = False, $a_b_WaitMapIsLoaded = True)
    DllStructSetData($g_d_EnterMission, 2, Not $a_b_Foreign)
	Map_InitMapIsLoaded()
    Core_Enqueue($g_p_EnterMission, 8)
    If $a_b_WaitMapIsLoaded Then Map_WaitMapIsLoaded()
EndFunc   
Func Ui_MoveMap($a_i_MapID, $a_i_Region, $a_i_Language, $a_i_District)
    DllStructSetData($g_d_MoveMap, 2, $GC_I_UIMSG_TRAVEL)
    DllStructSetData($g_d_MoveMap, 3, $a_i_MapID)
    DllStructSetData($g_d_MoveMap, 4, $a_i_Region)
    DllStructSetData($g_d_MoveMap, 5, $a_i_Language)
    DllStructSetData($g_d_MoveMap, 6, $a_i_District)
    Core_Enqueue($g_p_MoveMap, 24)
EndFunc   
Func Ui_EquipItem($a_v_Item, $a_v_Agent = Agent_GetAgentPtr())
    DllStructSetData($g_d_EquipItem, 2, $GC_I_UIMSG_EQUIP_ITEM)
    DllStructSetData($g_d_EquipItem, 3, Item_ItemID($a_v_Item))
    DllStructSetData($g_d_EquipItem, 4, Agent_ConvertID($a_v_Agent))
    Core_Enqueue($g_p_EquipItem, 16)
EndFunc   
Func Ui_EnableRendering()
    If Ui_GetRenderEnabled() Then Return 1
    Memory_Write($g_b_DisableRendering, 0)
EndFunc 
Func Ui_DisableRendering()
    If Ui_GetRenderDisabled() Then Return 1
    Memory_Write($g_b_DisableRendering, 1)
EndFunc 
Func Ui_ToggleRendering()
    If Ui_GetRenderDisabled() Then
        Ui_EnableRendering()
        WinSetState(Scanner_GetWindowHandle(), "", @SW_SHOW)
    Else
        Ui_DisableRendering()
        WinSetState(Scanner_GetWindowHandle(), "", @SW_HIDE)
        Memory_Clear()
    EndIf
EndFunc 
Func Ui_PurgeHook($a_i_Time = 10000)
    If Ui_GetRenderEnabled() Then Return 1
    Ui_ToggleRendering()
    Sleep($a_i_Time)
    Ui_ToggleRendering()
EndFunc 
Func Ui_ToggleRendering_()
    If Ui_GetRenderDisabled() Then
        Ui_EnableRendering()
    Else
        Ui_DisableRendering()
        Memory_Clear()
    EndIf
EndFunc 
Func Ui_PurgeHook_($a_i_Time = 10000)
    If Ui_GetRenderEnabled() Then Return 1
    Ui_ToggleRendering_()
    Sleep($a_i_Time)
    Ui_ToggleRendering_()
EndFunc 
Func Ui_ActiveQuest($a_i_QuestID)
    DllStructSetData($g_d_ActiveQuest, 2, $a_i_QuestID)
    Core_Enqueue($g_p_ActiveQuest, 8)
EndFunc