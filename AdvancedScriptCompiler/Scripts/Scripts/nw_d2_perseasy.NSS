//::///////////////////////////////////////////////
//:: Diplomacy Check Easy
//:: NW_D2_PEREASY
//:: Copyright (c) 2001 Bioware Corp.
//:://////////////////////////////////////////////
/*
    Check to see if the character made an easy
    persuade check.
*/
//:://////////////////////////////////////////////
//:: Created By: Preston Watamaniuk
//:: Created On: Sept 18, 2001
//:://////////////////////////////////////////////

#include "nw_i0_plot"

int StartingConditional()
{
	return AutoDC(DC_EASY, SKILL_DIPLOMACY, GetPCSpeaker());
}
