#include-once
Func Ui_GetRenderDisabled()
    Return Memory_Read($g_b_DisableRendering) = 1
EndFunc 
Func Ui_GetRenderEnabled()
    Return Memory_Read($g_b_DisableRendering) = 0
EndFunc 