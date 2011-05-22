//::///////////////////////////////////////////////
//:: Can combo 20 be made?
//:: Copyright (c) 2001 Bioware Corp.
//:://////////////////////////////////////////////
/*
   Searchs backpack of PC speaker and sees if they
   can build the #20 combo
*/
//:://////////////////////////////////////////////
//:: Created By:
//:: Created On:
//:://////////////////////////////////////////////
#include "NW_O0_ITEMMAKER"


int StartingConditional()
{
    int iResult;

    iResult = GetBackpackMatch(20, GetPCSpeaker());
    return iResult;
}

