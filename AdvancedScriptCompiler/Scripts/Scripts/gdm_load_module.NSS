// gdm_load_module
/*
    load specified module.

    This script for use in normal conversation
*/
// ChazM 2/24/06

#include "gdm_inc"

void main()
{
    string sModule = GetStringParam();
    object oPC = GetPCSpeaker();
	LoadNewModule(sModule);
}
