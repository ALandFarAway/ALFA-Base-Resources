//::///////////////////////////////////////////////
//:: NW_D2_NOTMYSELF
//:: Copyright (c) 2001 Bioware Corp.
//:://////////////////////////////////////////////
/*
   Returns true if the person I am talking to
   is not myself.
*/
//:://////////////////////////////////////////////
//:: Created By: Brent
//:: Created On:
//:://////////////////////////////////////////////

int StartingConditional()
{
    int iResult;

    iResult = GetIsObjectValid(GetPCSpeaker());
    return iResult;
}
