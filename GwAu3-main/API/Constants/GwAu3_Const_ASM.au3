#include-once
#Region Assembler Variables
Global $g_b_DevMode = False 
Global Const $GC_S_GWAU3_HEADER_BIN = "4757415533415049"
Global Const $GC_S_GWAU3_HEADER_STR = "GWAU3API"
Global Const $GC_I_GWAU3_HEADER_SIZE = 16
Global Const $GC_I_GWAU3_OFFSET_SCANPTR = 8
Global Const $GC_I_GWAU3_OFFSET_CMDPTR = 12
Global $g_p_GwAu3Header = 0 
Global $g_p_GwAu3Scan = 0 
Global $g_p_GwAu3Cmd = 0 
Global $g_s_ASMCode 
Global $g_i_ASMSize 
Global $g_i_ASMCodeOffset 
Global $g_amx2_Labels[1][2] 
#EndRegion Assembler Variables