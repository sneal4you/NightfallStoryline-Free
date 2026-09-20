#include-once
Func Anti_Well()
	If Not UAI_GetPlayerInfo($GC_UAI_AGENT_IsHexed) Then Return False
	If UAI_PlayerHasEffect($GC_I_SKILL_ID_DIVERSION) Then Return True
	Local $l_i_IncomingDamage = 0
	If UAI_PlayerHasEffect($GC_I_SKILL_ID_BACKFIRE) Then $l_i_IncomingDamage += UAI_GetPlayerEffectInfo($GC_I_SKILL_ID_BACKFIRE, $GC_UAI_EFFECT_Scale)
	If UAI_PlayerHasEffect($GC_I_SKILL_ID_VISIONS_OF_REGRET) Then
		$l_i_IncomingDamage += UAI_GetPlayerEffectInfo($GC_I_SKILL_ID_VISIONS_OF_REGRET, $GC_UAI_EFFECT_Scale)
		If Not UAI_PlayerHasOtherMesmerHex($GC_I_SKILL_ID_VISIONS_OF_REGRET) Then $l_i_IncomingDamage += UAI_GetPlayerEffectInfo($GC_I_SKILL_ID_VISIONS_OF_REGRET, $GC_UAI_EFFECT_BonusScale)
	EndIf
	If UAI_PlayerHasEffect($GC_I_SKILL_ID_SOUL_LEECH) Then $l_i_IncomingDamage += UAI_GetPlayerEffectInfo($GC_I_SKILL_ID_SOUL_LEECH, $GC_UAI_EFFECT_Scale)
	If UAI_PlayerHasEffect($GC_I_SKILL_ID_SPITEFUL_SPIRIT) Then $l_i_IncomingDamage += UAI_GetPlayerEffectInfo($GC_I_SKILL_ID_SPITEFUL_SPIRIT, $GC_UAI_EFFECT_Scale)
	Return ($l_i_IncomingDamage > (UAI_GetPlayerInfo($GC_UAI_AGENT_CurrentHP) + UAI_GetPlayerInfo($GC_UAI_AGENT_MaxHP * 0.15)))
EndFunc
Func CanUse_WellOfPower()
	If Anti_Well() Then Return False
	Return True
EndFunc
Func BestTarget_WellOfPower($a_f_AggroRange)
	Return UAI_GetBestCorpseForAllySupport($a_f_AggroRange)
EndFunc
Func CanUse_WellOfBlood()
	If Anti_Well() Then Return False
	Return True
EndFunc
Func BestTarget_WellOfBlood($a_f_AggroRange)
	Return UAI_GetBestCorpseForAllySupport($a_f_AggroRange)
EndFunc
Func CanUse_WellOfSuffering()
	If Anti_Well() Then Return False
	Return True
EndFunc
Func BestTarget_WellOfSuffering($a_f_AggroRange)
	Return UAI_GetBestCorpseForEnemyPressure($a_f_AggroRange)
EndFunc
Func CanUse_WellOfTheProfane()
	If Anti_Well() Then Return False
	Return True
EndFunc
Func BestTarget_WellOfTheProfane($a_f_AggroRange)
	Return UAI_GetBestCorpseForEnemyPressure($a_f_AggroRange)
EndFunc
Func CanUse_WellOfWeariness()
	If Anti_Well() Then Return False
	Return True
EndFunc
Func BestTarget_WellOfWeariness($a_f_AggroRange)
	Return UAI_GetBestCorpseForEnemyPressure($a_f_AggroRange)
EndFunc
Func CanUse_WellOfDarkness()
	If Anti_Well() Then Return False
	Return True
EndFunc
Func BestTarget_WellOfDarkness($a_f_AggroRange)
	Return UAI_GetBestCorpseForEnemyPressure($a_f_AggroRange)
EndFunc
Func CanUse_WellOfSilence()
	If Anti_Well() Then Return False
	Return True
EndFunc
Func BestTarget_WellOfSilence($a_f_AggroRange)
	Return UAI_GetBestCorpseForEnemyPressure($a_f_AggroRange)
EndFunc
Func CanUse_WellOfRuin()
	If Anti_Well() Then Return False
	Return True
EndFunc
Func BestTarget_WellOfRuin($a_f_AggroRange)
	Return UAI_GetBestCorpseForEnemyPressure($a_f_AggroRange)
EndFunc