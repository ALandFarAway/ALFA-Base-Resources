//::///////////////////////////////////////////////
//:: Check if Search Disabled
//:: Copyright (c) 2001 Bioware Corp.
//:://////////////////////////////////////////////
/*
    Does the henchman currently not search when
    moving.
*/
//:://////////////////////////////////////////////
//:: Created By: Preston Watamaniuk
//:: Created On:
//:://////////////////////////////////////////////
#include "NW_I0_GENERIC"

int StartingConditional()
{
    return FALSE;
    /*
    if(!GetAssociateState(NW_ASC_AGGRESSIVE_SEARCH) && GetLevelByClass(CLASS_TYPE_ROGUE) > 0)
    {
        return TRUE;
    }
    return FALSE;  */
}
