//::///////////////////////////////////////////////
//:: x0_conh_healmno.nss
//:: Copyright (c) 2001 Bioware Corp.
//:://////////////////////////////////////////////
/*
    Will henchman NOT use healing in melee?
*/
//:://////////////////////////////////////////////
//:: Created By:
//:: Created On:
//:://////////////////////////////////////////////
#include "x0_inc_henai"
int StartingConditional()
{
    if (bkGetBehavior(BK_HEALINMELEE) == FALSE)
        return TRUE;
    return FALSE;
}
