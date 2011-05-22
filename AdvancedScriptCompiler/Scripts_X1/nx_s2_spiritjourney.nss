//::///////////////////////////////////////////////
//:: Spirit Journey
//:: nx_s2_spiritjourney.nss
//:: Copyright (c) 2007 Obsidian Entertainment, Inc.
//:://////////////////////////////////////////////
/*
   A spirit shaman knows how to vanish bodily into
   the spirit world. This ability functions like the
   spell Ethereal Jaunt; the spirit shaman cannot
   attack or be attacked. A spirit shaman can use
   this ability once per day.
*/
//:://////////////////////////////////////////////
//:: Created By: Andrew Woo (AFW-OEI)
//:: Created On: 03/15/2007
//:://////////////////////////////////////////////

#include "x2_inc_spellhook"

void main()
{
    if (!X2PreSpellCastCode())
    {   // If code within the PreSpellCastHook (i.e. UMD) reports FALSE, do not run this spell
        return;
    }
    
    //Declare major variables
    object oTarget = GetSpellTargetObject();
    int nDuration = GetLevelByClass(CLASS_TYPE_SPIRIT_SHAMAN);  // Lasts 1 round/shaman level.

    effect eVis  = EffectVisualEffect( VFX_DUR_SPELL_SPIRIT_JOURNEY );
    effect eSanc = EffectEthereal();
    effect eLink = EffectLinkEffects(eVis, eSanc);

    //Fire cast spell at event for the specified target
    SignalEvent(oTarget, EventSpellCastAt(OBJECT_SELF, GetSpellId(), FALSE));

    // Does not stack with itself.
    if(!GetHasSpellEffect(GetSpellId(), OBJECT_SELF))
    {
        ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eLink, oTarget, RoundsToSeconds(nDuration));
    }

}