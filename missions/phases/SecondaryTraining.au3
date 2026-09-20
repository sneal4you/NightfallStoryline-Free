#include-once
Func Quest_SecondaryTraining_Run()
    Out("[SecondaryTraining] Accept 601 + 23 Expert NPCs + Reward 601")
    If Not Quest_CQ_Phase05_Run() Then Return False
    Return _ST_BuyHeroSkills()
EndFunc
Func _ST_BuyHeroSkills()
    If World_IsSkillLearnt(2107) And World_IsSkillLearnt(2110) Then
        Out("[ST] hero skills ya aprendidas (2107+2110) -> skip")
        Return True
    EndIf
    Out("[ST] Hero skills: travel a Sunspear Great Hall (" & $BSK_SUNSPEAR_MAP_ID & ")")
    If Not Travel_ToOutpost($BSK_SUNSPEAR_MAP_ID) Then
        Out("[ST] FAIL travel a Sunspear Great Hall")
        Return False
    EndIf
    Sleep(1500)
    Out("[ST] Nav a Sunspear Trainer 4751 (" & $BSK_TRAINER_X & "," & $BSK_TRAINER_Y & ")")
    If Not _Quests_NavAndOpenDialog($BSK_TRAINER_X, $BSK_TRAINER_Y, $BSK_TRAINER_MODEL) Then
        Out("[ST] FAIL nav/dialog Sunspear Trainer")
        Return False
    EndIf
    Out("[ST] Ui_Dialog menú Sunspear + Whirlwind Attack (2107) + Vampirism (2110)")
    Bot_Dialog($BSK_DIALOG_SUNSPEAR_MENU)
    Sleep(1500)
    Bot_Dialog($BSK_DIALOG_WHIRLWIND)
    Sleep(1500)
    _BSK_CloseSkillPopup()
    Bot_Dialog($BSK_DIALOG_VAMPIRISM)
    Sleep(1500)
    _BSK_CloseSkillPopup()
    Out("[ST] OK hero skills compradas")
    Return True
EndFunc