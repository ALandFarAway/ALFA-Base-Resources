//::///////////////////////////////////////////////
//:: Copyright (c) 2003 Bioware Corp.
//:://////////////////////////////////////////////
/*
  Check to see if the PC has SPELL_MASS_CURE_LIGHT_WOUNDS
  memorized...
*/
//:://////////////////////////////////////////////
//:: Created By: Brent
//:: Created On: June 2003
//:://////////////////////////////////////////////


// JLR - OEI 08/23/05 -- Spell "Circle of Doom" Renamed for 3.5

int StartingConditional()
{
    if (GetHasSpell(
//       SPELL_CIRCLE_OF_DOOM
       SPELL_MASS_CURE_LIGHT_WOUNDS
      , GetPCSpeaker()) > 0)
        return TRUE;
    return FALSE;
}
