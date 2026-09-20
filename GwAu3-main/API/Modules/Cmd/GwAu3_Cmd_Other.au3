#include-once
Func Other_RndSleep($a_i_Amount, $a_f_Random = 0.05)
    Local $l_f_Random = $a_i_Amount * $a_f_Random
    Sleep(Random($a_i_Amount - $l_f_Random, $a_i_Amount + $l_f_Random))
EndFunc   
Func Other_TolSleep($a_i_Amount = 150, $a_i_Tolerance = 50)
    Sleep(Random($a_i_Amount - $a_i_Tolerance, $a_i_Amount + $a_i_Tolerance))
EndFunc   
Func Other_PingSleep($a_i_MsExtra = 0)
    Sleep(Other_GetPing() + $a_i_MsExtra)
EndFunc   
Func Other_WaitPingStabilized($a_i_WaiTimer = 2000)
	Local $l_b_Stabilized = False
	Local $l_b_RestartLoop = False
	While Not $l_b_Stabilized
		Sleep(16)
		If Map_GetInstanceInfo("IsLoading") Then ContinueLoop
		If Game_GetGameInfo("IsCinematic") Then
			Local $l_i_CinematicTimer = TimerInit()
			Do
				Cinematic_SkipCinematic()
				Sleep(16)
			Until Not Game_GetGameInfo("IsCinematic") Or TimerDiff($l_i_CinematicTimer) >= 60000
			ContinueLoop
		EndIf
		If Other_GetPing() <> 0 Then
			$l_b_RestartLoop = False
			Local $l_i_Timer = TimerInit()
			Do
				Sleep(16)
				If Other_GetPing() = 0 Or Game_GetGameInfo("IsCinematic") Or Map_GetInstanceInfo("IsLoading") Then $l_b_RestartLoop = True
			Until TimerDiff($l_i_Timer) >= $a_i_WaiTimer Or $l_b_RestartLoop
			If $l_b_RestartLoop Then ContinueLoop
			$l_b_Stabilized = True
		EndIf
	Wend
EndFunc