#include-once
Func Anti_ItemSpell()
	If Not UAI_GetPlayerInfo($GC_UAI_AGENT_IsHexed) Then Return False
	If UAI_PlayerHasEffect($GC_I_SKILL_ID_DIVERSION) Then Return True
	Local $l_i_IncomingDamage = 0
	If UAI_PlayerHasEffect($GC_I_SKILL_ID_BACKFIRE) Then $l_i_IncomingDamage += UAI_GetPlayerEffectInfo($GC_I_SKILL_ID_BACKFIRE, $GC_UAI_EFFECT_Scale)
	If UAI_PlayerHasEffect($GC_I_SKILL_ID_VISIONS_OF_REGRET) Then
		$l_i_IncomingDamage += UAI_GetPlayerEffectInfo($GC_I_SKILL_ID_VISIONS_OF_REGRET, $GC_UAI_EFFECT_Scale)
		If Not UAI_PlayerHasOtherMesmerHex($GC_I_SKILL_ID_VISIONS_OF_REGRET) Then $l_i_IncomingDamage += Effect_GetEffectArg($GC_I_SKILL_ID_VISIONS_OF_REGRET, $GC_UAI_EFFECT_BonusScale)
	EndIf
	If UAI_PlayerHasEffect($GC_I_SKILL_ID_SOUL_LEECH) Then $l_i_IncomingDamage += UAI_GetPlayerEffectInfo($GC_I_SKILL_ID_SOUL_LEECH, $GC_UAI_EFFECT_Scale)
	If UAI_PlayerHasEffect($GC_I_SKILL_ID_SPITEFUL_SPIRIT) Then $l_i_IncomingDamage += UAI_GetPlayerEffectInfo($GC_I_SKILL_ID_SPITEFUL_SPIRIT, $GC_UAI_EFFECT_Scale)
	Return ($l_i_IncomingDamage > (UAI_GetPlayerInfo($GC_UAI_AGENT_CurrentHP) + UAI_GetPlayerInfo($GC_UAI_AGENT_MaxHP * 0.15)))
EndFunc
Func CanUse_GenerousWasTsungrai()
	If Anti_ItemSpell() Then Return False
	Return True
EndFunc
Func BestTarget_GenerousWasTsungrai($a_f_AggroRange)
	Return UAI_GetPlayerInfo($GC_UAI_AGENT_ID)
EndFunc
Func CanUse_MightyWasVorizun()
	If Anti_ItemSpell() Then Return False
	Return True
EndFunc
Func BestTarget_MightyWasVorizun($a_f_AggroRange)
	Return UAI_GetPlayerInfo($GC_UAI_AGENT_ID)
EndFunc
Func CanUse_BlindWasMingson()
	If Anti_ItemSpell() Then Return False
	Return True
EndFunc
Func BestTarget_BlindWasMingson($a_f_AggroRange)
	Return UAI_GetPlayerInfo($GC_UAI_AGENT_ID)
EndFunc
Func CanUse_GraspingWasKuurong()
	If Anti_ItemSpell() Then Return False
	Return True
EndFunc
Func BestTarget_GraspingWasKuurong($a_f_AggroRange)
	Return UAI_GetPlayerInfo($GC_UAI_AGENT_ID)
EndFunc
Func CanUse_VengefulWasKhanhei()
	If Anti_ItemSpell() Then Return False
	Return True
EndFunc
Func BestTarget_VengefulWasKhanhei($a_f_AggroRange)
	Return UAI_GetPlayerInfo($GC_UAI_AGENT_ID)
EndFunc
Func CanUse_DefiantWasXinrae()
	If Anti_ItemSpell() Then Return False
	Return True
EndFunc
Func BestTarget_DefiantWasXinrae($a_f_AggroRange)
	Return UAI_GetPlayerInfo($GC_UAI_AGENT_ID)
EndFunc
Func CanUse_TranquilWasTanasen()
	If Anti_ItemSpell() Then Return False
	Return True
EndFunc
Func BestTarget_TranquilWasTanasen($a_f_AggroRange)
	Return UAI_GetPlayerInfo($GC_UAI_AGENT_ID)
EndFunc
Func CanUse_CruelWasDaoshen()
	If Anti_ItemSpell() Then Return False
	Return True
EndFunc
Func BestTarget_CruelWasDaoshen($a_f_AggroRange)
	Return UAI_GetPlayerInfo($GC_UAI_AGENT_ID)
EndFunc
Func CanUse_ProtectiveWasKaolai()
	If Anti_ItemSpell() Then Return False
	Return True
EndFunc
Func BestTarget_ProtectiveWasKaolai($a_f_AggroRange)
	Return UAI_GetPlayerInfo($GC_UAI_AGENT_ID)
EndFunc
Func CanUse_AttunedWasSongkai()
	If Anti_ItemSpell() Then Return False
	Return True
EndFunc
Func BestTarget_AttunedWasSongkai($a_f_AggroRange)
	Return UAI_GetPlayerInfo($GC_UAI_AGENT_ID)
EndFunc
Func CanUse_ResilientWasXiko()
	If Anti_ItemSpell() Then Return False
	Return True
EndFunc
Func BestTarget_ResilientWasXiko($a_f_AggroRange)
	Return UAI_GetPlayerInfo($GC_UAI_AGENT_ID)
EndFunc
Func CanUse_LivelyWasNaomei()
	If Anti_ItemSpell() Then Return False
	Return True
EndFunc
Func BestTarget_LivelyWasNaomei($a_f_AggroRange)
	Return UAI_GetPlayerInfo($GC_UAI_AGENT_ID)
EndFunc
Func CanUse_AnguishedWasLingwah()
	If Anti_ItemSpell() Then Return False
	Return True
EndFunc
Func BestTarget_AnguishedWasLingwah($a_f_AggroRange)
	Return UAI_GetPlayerInfo($GC_UAI_AGENT_ID)
EndFunc
Func CanUse_VocalWasSogolon()
	If Anti_ItemSpell() Then Return False
	Return True
EndFunc
Func BestTarget_VocalWasSogolon($a_f_AggroRange)
	Return UAI_GetPlayerInfo($GC_UAI_AGENT_ID)
EndFunc
Func CanUse_DestructiveWasGlaive()
	If Anti_ItemSpell() Then Return False
	Return True
EndFunc
Func BestTarget_DestructiveWasGlaive($a_f_AggroRange)
	Return UAI_GetPlayerInfo($GC_UAI_AGENT_ID)
EndFunc
Func CanUse_EnergeticWasLeeSa()
	If Anti_ItemSpell() Then Return False
	Return True
EndFunc
Func BestTarget_EnergeticWasLeeSa($a_f_AggroRange)
	Return UAI_GetPlayerInfo($GC_UAI_AGENT_ID)
EndFunc
Func CanUse_PureWasLiMing()
	If Anti_ItemSpell() Then Return False
	Return True
EndFunc
Func BestTarget_PureWasLiMing($a_f_AggroRange)
	Return UAI_GetPlayerInfo($GC_UAI_AGENT_ID)
EndFunc
Func CanUse_CourageousWasSaidra()
	If Anti_ItemSpell() Then Return False
	Return True
EndFunc
Func BestTarget_CourageousWasSaidra($a_f_AggroRange)
	Return UAI_GetPlayerInfo($GC_UAI_AGENT_ID)
EndFunc
Func CanUse_DestructiveWasGlaivePvP()
	If Anti_ItemSpell() Then Return False
	Return True
EndFunc
Func BestTarget_DestructiveWasGlaivePvP($a_f_AggroRange)
	Return UAI_GetPlayerInfo($GC_UAI_AGENT_ID)
EndFunc