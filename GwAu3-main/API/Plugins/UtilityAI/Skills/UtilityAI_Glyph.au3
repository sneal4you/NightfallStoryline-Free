#include-once
Func Anti_Glyph()
	Return False
EndFunc
Func CanUse_GlyphOfElementalPower()
	If Anti_Glyph() Then Return False
	Return True
EndFunc
Func BestTarget_GlyphOfElementalPower($a_f_AggroRange)
	Return UAI_GetPlayerInfo($GC_UAI_AGENT_ID)
EndFunc
Func CanUse_GlyphOfEnergy()
	If Anti_Glyph() Then Return False
	Return True
EndFunc
Func BestTarget_GlyphOfEnergy($a_f_AggroRange)
	Return UAI_GetPlayerInfo($GC_UAI_AGENT_ID)
EndFunc
Func CanUse_GlyphOfLesserEnergy()
	If Anti_Glyph() Then Return False
	Return True
EndFunc
Func BestTarget_GlyphOfLesserEnergy($a_f_AggroRange)
	Return UAI_GetPlayerInfo($GC_UAI_AGENT_ID)
EndFunc
Func CanUse_GlyphOfConcentration()
	If Anti_Glyph() Then Return False
	Return True
EndFunc
Func BestTarget_GlyphOfConcentration($a_f_AggroRange)
	Return UAI_GetPlayerInfo($GC_UAI_AGENT_ID)
EndFunc
Func CanUse_GlyphOfSacrifice()
	If Anti_Glyph() Then Return False
	Return True
EndFunc
Func BestTarget_GlyphOfSacrifice($a_f_AggroRange)
	Return UAI_GetPlayerInfo($GC_UAI_AGENT_ID)
EndFunc
Func CanUse_GlyphOfRenewal()
	If Anti_Glyph() Then Return False
	Return True
EndFunc
Func BestTarget_GlyphOfRenewal($a_f_AggroRange)
	Return UAI_GetPlayerInfo($GC_UAI_AGENT_ID)
EndFunc
Func CanUse_HiddenRock()
	If Anti_Glyph() Then Return False
	Return True
EndFunc
Func BestTarget_HiddenRock($a_f_AggroRange)
	Return UAI_GetPlayerInfo($GC_UAI_AGENT_ID)
EndFunc
Func CanUse_GlyphOfEssence()
	If Anti_Glyph() Then Return False
	Return True
EndFunc
Func BestTarget_GlyphOfEssence($a_f_AggroRange)
	Return UAI_GetPlayerInfo($GC_UAI_AGENT_ID)
EndFunc
Func CanUse_GlyphOfRestoration()
	If Anti_Glyph() Then Return False
	Return True
EndFunc
Func BestTarget_GlyphOfRestoration($a_f_AggroRange)
	Return UAI_GetPlayerInfo($GC_UAI_AGENT_ID)
EndFunc
Func CanUse_GlyphOfSwiftness()
	If Anti_Glyph() Then Return False
	Return True
EndFunc
Func BestTarget_GlyphOfSwiftness($a_f_AggroRange)
	Return UAI_GetPlayerInfo($GC_UAI_AGENT_ID)
EndFunc
Func CanUse_GlyphOfImmolation()
	If Anti_Glyph() Then Return False
	Return True
EndFunc
Func BestTarget_GlyphOfImmolation($a_f_AggroRange)
	Return UAI_GetPlayerInfo($GC_UAI_AGENT_ID)
EndFunc
Func CanUse_PolymockGlyphOfConcentration()
	If Anti_Glyph() Then Return False
	Return True
EndFunc
Func BestTarget_PolymockGlyphOfConcentration($a_f_AggroRange)
	Return UAI_GetPlayerInfo($GC_UAI_AGENT_ID)
EndFunc
Func CanUse_PolymockGlyphOfPower()
	If Anti_Glyph() Then Return False
	Return True
EndFunc
Func BestTarget_PolymockGlyphOfPower($a_f_AggroRange)
	Return UAI_GetPlayerInfo($GC_UAI_AGENT_ID)
EndFunc