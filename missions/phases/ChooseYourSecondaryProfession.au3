#include-once
Func Quest_ChooseSecondaryProfession_Run()
    Out("[ChooseSecondaryProfession] secondary Warrior + Reward 596 + Accept 632 + ferryman")
    If Not World_IsSkillLearnt(2107) Or Not World_IsSkillLearnt(2110) Then
        Out("[ChooseSecondaryProfession] hero skills de la fase 05 pendientes -> comprarlas ahora")
        _ST_BuyHeroSkills()
    EndIf
    Return Quest_CQ_Phase06_Run()
EndFunc