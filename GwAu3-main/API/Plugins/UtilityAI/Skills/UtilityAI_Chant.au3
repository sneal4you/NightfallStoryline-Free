#include-once
Func Anti_Chant()
	If UAI_PlayerHasEffect($GC_I_SKILL_ID_VOCAL_MINORITY) Then Return True
	If UAI_PlayerHasEffect($GC_I_SKILL_ID_WELL_OF_SILENCE) Then Return True
	If UAI_PlayerHasEffect($GC_I_SKILL_ID_CACOPHONY) And _
		UAI_GetPlayerEffectInfo($GC_I_SKILL_ID_CACOPHONY, $GC_UAI_EFFECT_Scale) > (UAI_GetPlayerInfo($GC_UAI_AGENT_CurrentHP) + 50) Then
		Return True
	EndIf
	Return False
EndFunc
Func CanUse_AnthemOfFury()
	If Anti_Chant() Then Return False
	Return True
EndFunc
Func BestTarget_AnthemOfFury($a_f_AggroRange)
	Return UAI_GetPlayerInfo($GC_UAI_AGENT_ID)
EndFunc
Func CanUse_CripplingAnthem()
	If Anti_Chant() Then Return False
	Return True
EndFunc
Func BestTarget_CripplingAnthem($a_f_AggroRange)
	Return UAI_GetPlayerInfo($GC_UAI_AGENT_ID)
EndFunc
Func CanUse_DefensiveAnthem()
	If Anti_Chant() Then Return False
	Return True
EndFunc
Func BestTarget_DefensiveAnthem($a_f_AggroRange)
	Return UAI_GetPlayerInfo($GC_UAI_AGENT_ID)
EndFunc
Func CanUse_AnthemOfFlame()
	If Anti_Chant() Then Return False
	Return True
EndFunc
Func BestTarget_AnthemOfFlame($a_f_AggroRange)
	Return UAI_GetPlayerInfo($GC_UAI_AGENT_ID)
EndFunc
Func CanUse_AnthemOfEnvy()
	If Anti_Chant() Then Return False
	Return True
EndFunc
Func BestTarget_AnthemOfEnvy($a_f_AggroRange)
	Return UAI_GetPlayerInfo($GC_UAI_AGENT_ID)
EndFunc
Func CanUse_SongOfPower()
	If Anti_Chant() Then Return False
	Return True
EndFunc
Func BestTarget_SongOfPower($a_f_AggroRange)
	Return UAI_GetPlayerInfo($GC_UAI_AGENT_ID)
EndFunc
Func CanUse_ZealousAnthem()
	If Anti_Chant() Then Return False
	Return True
EndFunc
Func BestTarget_ZealousAnthem($a_f_AggroRange)
	Return UAI_GetPlayerInfo($GC_UAI_AGENT_ID)
EndFunc
Func CanUse_AriaOfZeal()
	If Anti_Chant() Then Return False
	Return True
EndFunc
Func BestTarget_AriaOfZeal($a_f_AggroRange)
	Return UAI_GetPlayerInfo($GC_UAI_AGENT_ID)
EndFunc
Func CanUse_LyricOfZeal()
	If Anti_Chant() Then Return False
	Return True
EndFunc
Func BestTarget_LyricOfZeal($a_f_AggroRange)
	Return UAI_GetPlayerInfo($GC_UAI_AGENT_ID)
EndFunc
Func CanUse_BalladOfRestoration()
	If Anti_Chant() Then Return False
	Return True
EndFunc
Func BestTarget_BalladOfRestoration($a_f_AggroRange)
	Return UAI_GetPlayerInfo($GC_UAI_AGENT_ID)
EndFunc
Func CanUse_ChorusOfRestoration()
	If Anti_Chant() Then Return False
	Return True
EndFunc
Func BestTarget_ChorusOfRestoration($a_f_AggroRange)
	Return UAI_GetPlayerInfo($GC_UAI_AGENT_ID)
EndFunc
Func CanUse_AriaOfRestoration()
	If Anti_Chant() Then Return False
	Return True
EndFunc
Func BestTarget_AriaOfRestoration($a_f_AggroRange)
	Return UAI_GetPlayerInfo($GC_UAI_AGENT_ID)
EndFunc
Func CanUse_SongOfConcentration()
	If Anti_Chant() Then Return False
	Return True
EndFunc
Func BestTarget_SongOfConcentration($a_f_AggroRange)
	Return UAI_GetPlayerInfo($GC_UAI_AGENT_ID)
EndFunc
Func CanUse_AnthemOfGuidance()
	If Anti_Chant() Then Return False
	Return True
EndFunc
Func BestTarget_AnthemOfGuidance($a_f_AggroRange)
	Return UAI_GetPlayerInfo($GC_UAI_AGENT_ID)
EndFunc
Func CanUse_EnergizingChorus()
	If Anti_Chant() Then Return False
	Return True
EndFunc
Func BestTarget_EnergizingChorus($a_f_AggroRange)
	Return UAI_GetPlayerInfo($GC_UAI_AGENT_ID)
EndFunc
Func CanUse_SongOfPurification()
	If Anti_Chant() Then Return False
	Return True
EndFunc
Func BestTarget_SongOfPurification($a_f_AggroRange)
	Return UAI_GetPlayerInfo($GC_UAI_AGENT_ID)
EndFunc
Func CanUse_HexbreakerAria()
	If Anti_Chant() Then Return False
	Return True
EndFunc
Func BestTarget_HexbreakerAria($a_f_AggroRange)
	Return UAI_GetPlayerInfo($GC_UAI_AGENT_ID)
EndFunc
Func CanUse_PresenceOfTheSkaleLord()
	If Anti_Chant() Then Return False
	Return True
EndFunc
Func BestTarget_PresenceOfTheSkaleLord($a_f_AggroRange)
	Return UAI_GetPlayerInfo($GC_UAI_AGENT_ID)
EndFunc
Func CanUse_SongOfRestoration()
	If Anti_Chant() Then Return False
	Return True
EndFunc
Func BestTarget_SongOfRestoration($a_f_AggroRange)
	Return UAI_GetPlayerInfo($GC_UAI_AGENT_ID)
EndFunc
Func CanUse_LyricOfPurification()
	If Anti_Chant() Then Return False
	Return True
EndFunc
Func BestTarget_LyricOfPurification($a_f_AggroRange)
	Return UAI_GetPlayerInfo($GC_UAI_AGENT_ID)
EndFunc
Func CanUse_AnthemOfAggression()
	If Anti_Chant() Then Return False
	Return True
EndFunc
Func BestTarget_AnthemOfAggression($a_f_AggroRange)
	Return UAI_GetPlayerInfo($GC_UAI_AGENT_ID)
EndFunc
Func CanUse_AnthemOfWeariness()
	If Anti_Chant() Then Return False
	Return True
EndFunc
Func BestTarget_AnthemOfWeariness($a_f_AggroRange)
	Return UAI_GetPlayerInfo($GC_UAI_AGENT_ID)
EndFunc
Func CanUse_AnthemOfDisruption()
	If Anti_Chant() Then Return False
	Return True
EndFunc
Func BestTarget_AnthemOfDisruption($a_f_AggroRange)
	Return UAI_GetPlayerInfo($GC_UAI_AGENT_ID)
EndFunc
Func CanUse_AnthemOfPurity()
	If Anti_Chant() Then Return False
	Return True
EndFunc
Func BestTarget_AnthemOfPurity($a_f_AggroRange)
	Return UAI_GetPlayerInfo($GC_UAI_AGENT_ID)
EndFunc
Func CanUse_DefensiveAnthemPvp()
	If Anti_Chant() Then Return False
	Return True
EndFunc
Func BestTarget_DefensiveAnthemPvp($a_f_AggroRange)
	Return UAI_GetPlayerInfo($GC_UAI_AGENT_ID)
EndFunc
Func CanUse_BalladOfRestorationPvp()
	If Anti_Chant() Then Return False
	Return True
EndFunc
Func BestTarget_BalladOfRestorationPvp($a_f_AggroRange)
	Return UAI_GetPlayerInfo($GC_UAI_AGENT_ID)
EndFunc
Func CanUse_SongOfRestorationPvp()
	If Anti_Chant() Then Return False
	Return True
EndFunc
Func BestTarget_SongOfRestorationPvp($a_f_AggroRange)
	Return UAI_GetPlayerInfo($GC_UAI_AGENT_ID)
EndFunc
Func CanUse_AnthemOfDisruptionPvp()
	If Anti_Chant() Then Return False
	Return True
EndFunc
Func BestTarget_AnthemOfDisruptionPvp($a_f_AggroRange)
	Return UAI_GetPlayerInfo($GC_UAI_AGENT_ID)
EndFunc
Func CanUse_AnthemOfEnvyPvp()
	If Anti_Chant() Then Return False
	Return True
EndFunc
Func BestTarget_AnthemOfEnvyPvp($a_f_AggroRange)
	Return UAI_GetPlayerInfo($GC_UAI_AGENT_ID)
EndFunc