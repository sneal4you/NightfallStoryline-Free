#include-once
Func Quest_AcceptQuest($a_i_QuestID)
    Return Core_SendPacket(0x8, $GC_I_HEADER_DIALOG_SEND, '0x008' & Hex($a_i_QuestID, 3) & '01')
EndFunc   
Func Quest_QuestReward($a_i_QuestID)
    Return Core_SendPacket(0x8, $GC_I_HEADER_DIALOG_SEND, '0x008' & Hex($a_i_QuestID, 3) & '07')
EndFunc   
Func Quest_AbandonQuest($a_i_QuestID)
    Return Core_SendPacket(0x8, $GC_I_HEADER_QUEST_ABANDON, $a_i_QuestID)
EndFunc   
Func Quest_ActiveQuest($a_i_QuestID)
	If Not Quest_GetQuestInfo($a_i_QuestID, "IsCurrentQuest") Then Return Core_SendPacket(0xC, $GC_I_HEADER_QUEST_SET_ACTIVE, Quest_GetQuestInfo($a_i_QuestID, "IsAreaPrimary"))
EndFunc
Func Quest_RequestInfos($a_i_QuestID)
	Return Core_SendPacket(0x8, $GC_I_HEADER_QUEST_REQUEST_INFOS, $a_i_QuestID)
EndFunc