//::///////////////////////////////////////////////
//:: x2_act_ws_wtoken
//:: Copyright (c) 2003 Bioware Corp.
//:://////////////////////////////////////////////
/*
    Set the name of the weapon the user is wielding
    into the custom token
*/
//:://////////////////////////////////////////////
//:: Created By: Brent
//:: Created On: September 17, 2003
//:://////////////////////////////////////////////
#include "x2_inc_ws_smith"

void main()
{
    SetWeaponToken(GetPCSpeaker());
}
