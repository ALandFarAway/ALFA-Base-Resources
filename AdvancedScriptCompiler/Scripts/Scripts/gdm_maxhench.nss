// gdm_maxhench
/*
    Set Max Num Henchmen.

    This script for use in normal conversation
*/
// ChazM 11/13/05

#include "gdm_inc"

void main()
{
    int iHench = GetIntParam();
    //object oPC = GetPCSpeaker();
    if (iHench < 0)
        iHench = 0;
    SetMaxHenchmen(iHench);
}
