//::///////////////////////////////////////////////
//:: Copyright (c) 2003 Bioware Corp.
//:://////////////////////////////////////////////
/*
  Check to see if the PC has SPELLABILITY_TOUCH_PETRIFY
  memorized...
*/
//:://////////////////////////////////////////////
//:: Created By: Brent
//:: Created On: June 2003
//:://////////////////////////////////////////////

int StartingConditional()
{
    if (GetHasSpell(
       SPELLABILITY_TOUCH_PETRIFY
      , GetPCSpeaker()) > 0)
        return TRUE;
    return FALSE;
}
