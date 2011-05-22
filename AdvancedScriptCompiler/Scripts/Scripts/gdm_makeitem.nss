// gdm_makeitem
/*
    create item from specified blueprint.

    This script for use in normal conversation
*/
// ChazM 11/13/05

#include "gdm_inc"

void main()
{
    string sResRef = GetStringParam();
    object oPC = GetPCSpeaker();
    object oItem = CreateItemOnObject(sResRef, oPC);
    if (!GetIsObjectValid(oItem))
        SpeakString("Item blueprint not found.");


}
