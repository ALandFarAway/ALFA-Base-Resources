//::///////////////////////////////////////////////
//:: x0_conh_fightyes.nss.nss
//:: Copyright (c) 2001 Bioware Corp.
//:://////////////////////////////////////////////
/*
    Will henchman fight?
*/
//:://////////////////////////////////////////////
//:: Created By:
//:: Created On:
//:://////////////////////////////////////////////
#include "x0_inc_henai"
int StartingConditional()
{
    if (bkGetBehavior(BK_NEVERFIGHT) == FALSE)
    {
        return TRUE;
    }
    return FALSE;

}

