//::///////////////////////////////////////////////
//:: Can combo 3 be made?
//:: Copyright (c) 2001 Bioware Corp.
//:://////////////////////////////////////////////
/*
   Searchs backpack of PC speaker and sees if they
   can build the #3 combo
*/
//:://////////////////////////////////////////////
//:: Created By:
//:: Created On:
//:://////////////////////////////////////////////
#include "NW_O0_ITEMMAKER"


int StartingConditional()
{
    int iResult;

    iResult = GetBackpackMatch(3, GetPCSpeaker());
    return iResult;
}

