//:://////////////////////////////////////////////////
//:: X0_D2_NOPERS1
//:: Copyright (c) 2002 Floodgate Entertainment
//:://////////////////////////////////////////////////
/*
Determine whether the PC has NOT yet tried to persuade this NPC
 */
//:://////////////////////////////////////////////////
//:: Created By: Naomi Novik
//:: Created On: 09/26/2002
//:://////////////////////////////////////////////////

#include "x0_i0_common"

int StartingConditional()
{
    return GetPersuadeAttempt(GetPCSpeaker(), 1) == 0;
}
