#include-once
Func Cinematic_WaitAndSkip($startTimeoutMs = 5000, $skipTimeoutMs = 30000)
    Out("[Cinematic] WaitAndSkip start_to=" & $startTimeoutMs & "ms skip_to=" & $skipTimeoutMs & "ms")
    Local $tWait = TimerInit()
    While Not Bot_ShouldStop() And Not Game_GetGameInfo("IsCinematic")
        If TimerDiff($tWait) > $startTimeoutMs Then
            Out("[Cinematic] No aparecio en " & $startTimeoutMs & "ms (puede que no haya cinematica aqui)")
            Return False
        EndIf
        Sleep(500)
    WEnd
    Out("[Cinematic] Detectada tras " & Round(TimerDiff($tWait), 0) & "ms, skipear...")
    Local $tSkip = TimerInit()
    While Not Bot_ShouldStop() And Game_GetGameInfo("IsCinematic")
        If TimerDiff($tSkip) > $skipTimeoutMs Then
            Out("[Cinematic] TIMEOUT skip " & $skipTimeoutMs & "ms, sigue activa")
            Return False
        EndIf
        Cinematic_SkipCinematic()
        Sleep(500)
    WEnd
    Out("[Cinematic] Skip OK en " & Round(TimerDiff($tSkip), 0) & "ms")
    Other_WaitPingStabilized(1500)
    Return True
EndFunc
Func Cinematic_ProtectStep()
    If Not Game_GetGameInfo("IsCinematic") Then Return False
    Out("[Cinematic] Detectada mid-step, skipear...")
    Local $t = TimerInit()
    While Not Bot_ShouldStop() And Game_GetGameInfo("IsCinematic")
        If TimerDiff($t) > 10000 Then
            Out("[Cinematic] ProtectStep TIMEOUT 10s")
            Return False
        EndIf
        Cinematic_SkipCinematic()
        Sleep(500)
    WEnd
    Out("[Cinematic] ProtectStep skip OK en " & Round(TimerDiff($t), 0) & "ms")
    Other_WaitPingStabilized(1000)
    Return True
EndFunc