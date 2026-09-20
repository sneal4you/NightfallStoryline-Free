#include-once
Func Anti_Ward()
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
Func CanUse_WardAgainstElements()
	If Anti_Ward() Then Return False
	Return True
EndFunc
Func BestTarget_WardAgainstElements($a_f_AggroRange)
	If UAI_MoveToWardPosition($GC_I_RANGE_AREA, $GC_I_UAI_WARDTYPE_DEFENSIVE) Then Return UAI_GetPlayerInfo($GC_UAI_AGENT_ID)
	Return 0
EndFunc
Func CanUse_WardAgainstMelee()
	If Anti_Ward() Then Return False
	Return True
EndFunc
Func BestTarget_WardAgainstMelee($a_f_AggroRange)
	If UAI_MoveToWardPosition($GC_I_RANGE_AREA, $GC_I_UAI_WARDTYPE_DEFENSIVE) Then Return UAI_GetPlayerInfo($GC_UAI_AGENT_ID)
	Return 0
EndFunc
Func CanUse_WardAgainstFoes()
	If Anti_Ward() Then Return False
	Return True
EndFunc
Func BestTarget_WardAgainstFoes($a_f_AggroRange)
	If UAI_MoveToWardPosition($GC_I_RANGE_AREA, $GC_I_UAI_WARDTYPE_OFFENSIVE) Then Return UAI_GetPlayerInfo($GC_UAI_AGENT_ID)
	Return 0
EndFunc
Func CanUse_WardAgainstHarm()
	If Anti_Ward() Then Return False
	Return True
EndFunc
Func BestTarget_WardAgainstHarm($a_f_AggroRange)
	If UAI_MoveToWardPosition($GC_I_RANGE_AREA, $GC_I_UAI_WARDTYPE_DEFENSIVE) Then Return UAI_GetPlayerInfo($GC_UAI_AGENT_ID)
	Return 0
EndFunc
Func CanUse_WardOfStability()
	If Anti_Ward() Then Return False
	Return True
EndFunc
Func BestTarget_WardOfStability($a_f_AggroRange)
	If UAI_MoveToWardPosition($GC_I_RANGE_AREA, $GC_I_UAI_WARDTYPE_DEFENSIVE) Then Return UAI_GetPlayerInfo($GC_UAI_AGENT_ID)
	Return 0
EndFunc
Func CanUse_TeinaisHeat()
	If Anti_Ward() Then Return False
	Return True
EndFunc
Func BestTarget_TeinaisHeat($a_f_AggroRange)
	If UAI_MoveToWardPosition($GC_I_RANGE_AREA, $GC_I_UAI_WARDTYPE_OFFENSIVE) Then Return UAI_GetPlayerInfo($GC_UAI_AGENT_ID)
	Return 0
EndFunc
Func CanUse_WardOfWeakness()
	If Anti_Ward() Then Return False
	Return True
EndFunc
Func BestTarget_WardOfWeakness($a_f_AggroRange)
	If UAI_MoveToWardPosition($GC_I_RANGE_AREA, $GC_I_UAI_WARDTYPE_OFFENSIVE) Then Return UAI_GetPlayerInfo($GC_UAI_AGENT_ID)
	Return 0
EndFunc
Func CanUse_EbonBattleStandardOfCourage()
	If Anti_Ward() Then Return False
	Return True
EndFunc
Func BestTarget_EbonBattleStandardOfCourage($a_f_AggroRange)
	If UAI_MoveToWardPosition($GC_I_RANGE_AREA, $GC_I_UAI_WARDTYPE_DEFENSIVE) Then Return UAI_GetPlayerInfo($GC_UAI_AGENT_ID)
	Return 0
EndFunc
Func CanUse_EbonBattleStandardOfWisdom()
	If Anti_Ward() Then Return False
	Return True
EndFunc
Func BestTarget_EbonBattleStandardOfWisdom($a_f_AggroRange)
	If UAI_MoveToWardPosition($GC_I_RANGE_AREA, $GC_I_UAI_WARDTYPE_DEFENSIVE) Then Return UAI_GetPlayerInfo($GC_UAI_AGENT_ID)
	Return 0
EndFunc
Func CanUse_EbonBattleStandardOfHonor()
	If Anti_Ward() Then Return False
	Return True
EndFunc
Func BestTarget_EbonBattleStandardOfHonor($a_f_AggroRange)
	If UAI_MoveToWardPosition($GC_I_RANGE_AREA, $GC_I_UAI_WARDTYPE_DEFENSIVE) Then Return UAI_GetPlayerInfo($GC_UAI_AGENT_ID)
	Return 0
EndFunc
Func CanUse_RadiationField()
	If Anti_Ward() Then Return False
	Return True
EndFunc
Func BestTarget_RadiationField($a_f_AggroRange)
	If UAI_MoveToWardPosition($GC_I_RANGE_AREA, $GC_I_UAI_WARDTYPE_OFFENSIVE) Then Return UAI_GetPlayerInfo($GC_UAI_AGENT_ID)
	Return 0
EndFunc
Func CanUse_BannerOfTheUnseen()
	If Anti_Ward() Then Return False
	Return True
EndFunc
Func BestTarget_BannerOfTheUnseen($a_f_AggroRange)
	If UAI_MoveToWardPosition($GC_I_RANGE_AREA, $GC_I_UAI_WARDTYPE_DEFENSIVE) Then Return UAI_GetPlayerInfo($GC_UAI_AGENT_ID)
	Return 0
EndFunc
Func CanUse_WardAgainstHarmPvP()
	If Anti_Ward() Then Return False
	Return True
EndFunc
Func BestTarget_WardAgainstHarmPvP($a_f_AggroRange)
	If UAI_MoveToWardPosition($GC_I_RANGE_AREA, $GC_I_UAI_WARDTYPE_DEFENSIVE) Then Return UAI_GetPlayerInfo($GC_UAI_AGENT_ID)
	Return 0
EndFunc
Func CanUse_WardAgainstMeleePvP()
	If Anti_Ward() Then Return False
	Return True
EndFunc
Func BestTarget_WardAgainstMeleePvP($a_f_AggroRange)
	If UAI_MoveToWardPosition($GC_I_RANGE_AREA, $GC_I_UAI_WARDTYPE_DEFENSIVE) Then Return UAI_GetPlayerInfo($GC_UAI_AGENT_ID)
	Return 0
EndFunc
Func CanUse_EbonVanguardBattleStandardOfPower()
	If Anti_Ward() Then Return False
	Return True
EndFunc
Func BestTarget_EbonVanguardBattleStandardOfPower($a_f_AggroRange)
	If UAI_MoveToWardPosition($GC_I_RANGE_AREA, $GC_I_UAI_WARDTYPE_DEFENSIVE) Then Return UAI_GetPlayerInfo($GC_UAI_AGENT_ID)
	Return 0
EndFunc
Func CanUse_TimeWard()
	If Anti_Ward() Then Return False
	Return True
EndFunc
Func BestTarget_TimeWard($a_f_AggroRange)
	If UAI_MoveToWardPosition($GC_I_RANGE_AREA, $GC_I_UAI_WARDTYPE_DEFENSIVE) Then Return UAI_GetPlayerInfo($GC_UAI_AGENT_ID)
	Return 0
EndFunc