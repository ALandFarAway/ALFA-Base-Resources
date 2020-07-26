//::///////////////////////////////////////////////
//:: alfa_opa_ooze_split
//:: Copyright (c) 2004 Bioware Corp.
//:://////////////////////////////////////////////
/*
    The NPC On Physically Attacked script is for the
    Ochre Jellies in PotSC. If the Target is physically
    attacked, divide into smaller jellies.
*/
//:://////////////////////////////////////////////
//:: Created By: Keith K2 Hayward
//:: Created On: August 2004
//:: Modified On: January, 2006
//:: Rewritten for NWN2 July, 2020
//:://////////////////////////////////////////////
#include "alfa_i0_oozesplit"

void main()
{
    object oPC = GetLastAttacker();
    object oSelf = OBJECT_SELF;
    object oWeapon = GetLastWeaponUsed(oPC);

    if (
        GetIsObjectValid(oWeapon) && (
            GetWeaponType(oWeapon) == WEAPON_TYPE_PIERCING ||
            GetWeaponType(oWeapon) == WEAPON_TYPE_SLASHING ||
            GetWeaponType(oWeapon) == WEAPON_TYPE_PIERCING_AND_SLASHING
    )) {
        SplitCreature(oSelf, oPC);
    }
}
