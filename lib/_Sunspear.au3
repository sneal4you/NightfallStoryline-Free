#include-once
Func Sunspear_GetPoints()
    Local $pts = Title_GetTitleInfo($GC_E_TITLEID_SUNSPEAR, "CurrentPoints")
    If @error Then Return 0
    Return $pts
EndFunc
Func Sunspear_GetRankName()
    Local $pts = Sunspear_GetPoints()
    Select
        Case $pts < 50
            Return "Recruit"
        Case $pts < 250
            Return "Sunspear"
        Case $pts < 750
            Return "Cadet"
        Case $pts < 1750
            Return "Initiate"
        Case $pts < 3500
            Return "Soldier"
        Case $pts < 5000
            Return "Officer"
        Case $pts < 7500
            Return "Master"
        Case $pts < 10000
            Return "General"
        Case $pts < 15000
            Return "Castellan"
        Case Else
            Return "Lieutenant+"
    EndSelect
EndFunc
Func Sunspear_HasRankForMission($missionName)
    Return True
EndFunc
Func Sunspear_FarmUntilPoints($targetPoints)
    Return False
EndFunc
Func Sunspear_AcceptPromotion()
    Return False
EndFunc