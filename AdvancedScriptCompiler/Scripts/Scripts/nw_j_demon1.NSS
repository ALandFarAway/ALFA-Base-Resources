//::///////////////////////////////////////////////
//:: NW_J_DEMON1.nss
//:: Copyright (c) 2001 Bioware Corp.
//:://////////////////////////////////////////////
/*
   Demon is hostile
*/
//:://////////////////////////////////////////////
//:: Created By: Brent
//:: Created On: December 17, 2001
//:://////////////////////////////////////////////

int StartingConditional()
{
    int iResult;

    iResult = GetLocalInt(OBJECT_SELF, "NW_L_TALKSTATE") == 0;
    return iResult;
}

