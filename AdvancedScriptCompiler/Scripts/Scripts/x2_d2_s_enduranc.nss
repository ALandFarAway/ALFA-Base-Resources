//::///////////////////////////////////////////////
//:: Copyright (c) 2003 Bioware Corp.
//:://////////////////////////////////////////////
/*
  Check to see if the PC has SPELL_BEARS_ENDURANCE
  memorized...
*/
//:://////////////////////////////////////////////
//:: Created By: Brent
//:: Created On: June 2003
//:://////////////////////////////////////////////

// JLR - OEI 07/11/05 -- Name Changed

int StartingConditional()
{
    if (GetHasSpell(
       SPELL_BEARS_ENDURANCE
      , GetPCSpeaker()) > 0)
        return TRUE;
    return FALSE;
}
