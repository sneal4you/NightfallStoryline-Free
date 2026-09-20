#include-once
Func Anti_Form()
	Return False
EndFunc
Func CanUse_AvatarOfBalthazar()
	If Anti_Form() Then Return False
	If UAI_GetPlayerEffectInfo($GC_I_SKILL_ID_AVATAR_OF_BALTHAZAR, $GC_UAI_EFFECT_TimeRemaining) > 5000 Then Return False
	Return True
EndFunc
Func BestTarget_AvatarOfBalthazar($a_f_AggroRange)
	Return UAI_GetPlayerInfo($GC_UAI_AGENT_ID)
EndFunc
Func CanUse_AvatarOfDwayna()
	If Anti_Form() Then Return False
	If UAI_GetPlayerEffectInfo($GC_I_SKILL_ID_AVATAR_OF_DWAYNA, $GC_UAI_EFFECT_TimeRemaining) > 5000 Then Return False
	Return True
EndFunc
Func BestTarget_AvatarOfDwayna($a_f_AggroRange)
	Return UAI_GetPlayerInfo($GC_UAI_AGENT_ID)
EndFunc
Func CanUse_AvatarOfGrenth()
	If Anti_Form() Then Return False
	If UAI_GetPlayerEffectInfo($GC_I_SKILL_ID_AVATAR_OF_GRENTH, $GC_UAI_EFFECT_TimeRemaining) > 5000 Then Return False
	Return True
EndFunc
Func BestTarget_AvatarOfGrenth($a_f_AggroRange)
	Return UAI_GetPlayerInfo($GC_UAI_AGENT_ID)
EndFunc
Func CanUse_AvatarOfLyssa()
	If Anti_Form() Then Return False
	If UAI_GetPlayerEffectInfo($GC_I_SKILL_ID_AVATAR_OF_LYSSA, $GC_UAI_EFFECT_TimeRemaining) > 5000 Then Return False
	Return True
EndFunc
Func BestTarget_AvatarOfLyssa($a_f_AggroRange)
	Return UAI_GetPlayerInfo($GC_UAI_AGENT_ID)
EndFunc
Func CanUse_AvatarOfMelandru()
	If Anti_Form() Then Return False
	If UAI_GetPlayerEffectInfo($GC_I_SKILL_ID_AVATAR_OF_MELANDRU, $GC_UAI_EFFECT_TimeRemaining) > 5000 Then Return False
	Return True
EndFunc
Func BestTarget_AvatarOfMelandru($a_f_AggroRange)
	Return UAI_GetPlayerInfo($GC_UAI_AGENT_ID)
EndFunc
Func CanUse_AvatarOfGrenthSnowFightingSkill()
	If UAI_GetPlayerEffectInfo($GC_I_SKILL_ID_AVATAR_OF_GRENTH_SNOW_FIGHTING_SKILL, $GC_UAI_EFFECT_TimeRemaining) > 5000 Then Return False
	If Anti_Form() Then Return False
	Return True
EndFunc
Func BestTarget_AvatarOfGrenthSnowFightingSkill($a_f_AggroRange)
	Return UAI_GetPlayerInfo($GC_UAI_AGENT_ID)
EndFunc
Func CanUse_AvatarOfDwaynaSnowFightingSkill()
	If UAI_GetPlayerEffectInfo($GC_I_SKILL_ID_AVATAR_OF_DWAYNA_SNOW_FIGHTING_SKILL, $GC_UAI_EFFECT_TimeRemaining) > 5000 Then Return False
	If Anti_Form() Then Return False
	Return True
EndFunc
Func BestTarget_AvatarOfDwaynaSnowFightingSkill($a_f_AggroRange)
	Return UAI_GetPlayerInfo($GC_UAI_AGENT_ID)
EndFunc
Func CanUse_UrsanBlessing()
	If UAI_GetPlayerEffectInfo($GC_I_SKILL_ID_URSAN_BLESSING, $GC_UAI_EFFECT_TimeRemaining) > 5000 Then Return False
	If Anti_Form() Then Return False
	Return True
EndFunc
Func BestTarget_UrsanBlessing($a_f_AggroRange)
	Return UAI_GetPlayerInfo($GC_UAI_AGENT_ID)
EndFunc
Func CanUse_VolfenBlessing()
	If UAI_GetPlayerEffectInfo($GC_I_SKILL_ID_VOLFEN_BLESSING, $GC_UAI_EFFECT_TimeRemaining) > 5000 Then Return False
	If Anti_Form() Then Return False
	Return True
EndFunc
Func BestTarget_VolfenBlessing($a_f_AggroRange)
	Return UAI_GetPlayerInfo($GC_UAI_AGENT_ID)
EndFunc
Func CanUse_RavenBlessing()
	If UAI_GetPlayerEffectInfo($GC_I_SKILL_ID_RAVEN_BLESSING, $GC_UAI_EFFECT_TimeRemaining) > 5000 Then Return False
	If Anti_Form() Then Return False
	Return True
EndFunc
Func BestTarget_RavenBlessing($a_f_AggroRange)
	Return UAI_GetPlayerInfo($GC_UAI_AGENT_ID)
EndFunc
Func CanUse_BearForm()
	If UAI_GetPlayerEffectInfo($GC_I_SKILL_ID_BEAR_FORM, $GC_UAI_EFFECT_TimeRemaining) > 5000 Then Return False
	If Anti_Form() Then Return False
	Return True
EndFunc
Func BestTarget_BearForm($a_f_AggroRange)
	Return UAI_GetPlayerInfo($GC_UAI_AGENT_ID)
EndFunc
Func CanUse_SiegeDevourer()
	If UAI_GetPlayerEffectInfo($GC_I_SKILL_ID_SIEGE_DEVOURER, $GC_UAI_EFFECT_TimeRemaining) > 5000 Then Return False
	If Anti_Form() Then Return False
	Return True
EndFunc
Func BestTarget_SiegeDevourer($a_f_AggroRange)
	Return UAI_GetPlayerInfo($GC_UAI_AGENT_ID)
EndFunc
Func CanUse_Hide()
	If UAI_GetPlayerEffectInfo($GC_I_SKILL_ID_HIDE, $GC_UAI_EFFECT_TimeRemaining) > 5000 Then Return False
	If Anti_Form() Then Return False
	Return True
EndFunc
Func BestTarget_Hide($a_f_AggroRange)
	Return UAI_GetPlayerInfo($GC_UAI_AGENT_ID)
EndFunc
Func CanUse_FeignDeath()
	If UAI_GetPlayerEffectInfo($GC_I_SKILL_ID_FEIGN_DEATH, $GC_UAI_EFFECT_TimeRemaining) > 5000 Then Return False
	If Anti_Form() Then Return False
	Return True
EndFunc
Func BestTarget_FeignDeath($a_f_AggroRange)
	Return UAI_GetPlayerInfo($GC_UAI_AGENT_ID)
EndFunc
Func CanUse_AvatarOfGrenthPvP()
	If UAI_GetPlayerEffectInfo($GC_I_SKILL_ID_AVATAR_OF_GRENTH_PvP, $GC_UAI_EFFECT_TimeRemaining) > 5000 Then Return False
	If Anti_Form() Then Return False
	Return True
EndFunc
Func BestTarget_AvatarOfGrenthPvP($a_f_AggroRange)
	Return UAI_GetPlayerInfo($GC_UAI_AGENT_ID)
EndFunc
Func CanUse_AvatarOfDwaynaPvP()
	If UAI_GetPlayerEffectInfo($GC_I_SKILL_ID_AVATAR_OF_DWAYNA_PvP, $GC_UAI_EFFECT_TimeRemaining) > 5000 Then Return False
	If Anti_Form() Then Return False
	Return True
EndFunc
Func BestTarget_AvatarOfDwaynaPvP($a_f_AggroRange)
	Return UAI_GetPlayerInfo($GC_UAI_AGENT_ID)
EndFunc
Func CanUse_AvatarOfMelandruPvP()
	If UAI_GetPlayerEffectInfo($GC_I_SKILL_ID_AVATAR_OF_MELANDRU_PvP, $GC_UAI_EFFECT_TimeRemaining) > 5000 Then Return False
	If Anti_Form() Then Return False
	Return True
EndFunc
Func BestTarget_AvatarOfMelandruPvP($a_f_AggroRange)
	Return UAI_GetPlayerInfo($GC_UAI_AGENT_ID)
EndFunc