//::///////////////////////////////////////////////
//:: Copyright (c) 2003 Bioware Corp.
//:://////////////////////////////////////////////
/*
  Check to see if the PC has SPELL_RESIST_ENERGY_ELECTRICITY
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
       SPELL_RESIST_ENERGY
      , GetPCSpeaker()) > 0)
        return TRUE;
    return FALSE;
}
