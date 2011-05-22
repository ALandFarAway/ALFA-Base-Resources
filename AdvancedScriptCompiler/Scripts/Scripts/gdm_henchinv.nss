// gdm_henchinv
/*
    open inventory of henchman.

    This script for use in normal conversation
*/
// ChazM 11/13/05

#include "gdm_inc"
/*
int GetIntParam()
{
    int iParam = StringToInt(GetLocalString(GetPCSpeaker(), "dm_param"));
    return (iParam);
}
*/

void main()
{
    int iHench = GetIntParam();
    object oPC = GetPCSpeaker();
    if (iHench < 1)
        iHench = 1;
    OpenInventory(GetHenchman(oPC, iHench), oPC);
}
