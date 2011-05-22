//::///////////////////////////////////////////////
//:: Copyright (c) 2003 Bioware Corp.
//:://////////////////////////////////////////////
/*
  Check to see if the PC has SPELL_EAGLE_SPLEDOR
  memorized...
*/
//:://////////////////////////////////////////////
//:: Created By: Brent
//:: Created On: June 2003
//:://////////////////////////////////////////////
// ChazM-OEI 7/21/07 Spell constant changed

int StartingConditional()
{
    if (GetHasSpell(
       SPELL_EAGLES_SPLENDOR
      , GetPCSpeaker()) > 0)
        return TRUE;
    return FALSE;
}