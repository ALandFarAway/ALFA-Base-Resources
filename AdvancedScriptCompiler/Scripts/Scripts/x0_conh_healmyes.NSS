//::///////////////////////////////////////////////
//:: x0_conh_healmyes.nss.nss
//:: Copyright (c) 2001 Bioware Corp.
//:://////////////////////////////////////////////
/*
    Will henchman use healing in melee?
*/
//:://////////////////////////////////////////////
//:: Created By:
//:: Created On:
//:://////////////////////////////////////////////
#include "x0_inc_henai"
int StartingConditional()
{
    int iResult;

    iResult = bkGetBehavior(BK_HEALINMELEE);
    return iResult;
}
