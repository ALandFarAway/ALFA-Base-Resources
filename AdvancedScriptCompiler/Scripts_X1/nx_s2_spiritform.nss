//::///////////////////////////////////////////////
//:: Spirit Form
//:: nx_s2_spiritform.nss
//:: Copyright (c) 2007 Obsidian Entertainment, Inc.
//:://////////////////////////////////////////////
/*
    A spirit shaman learns how to temporarily
    transform herself into a spirit.  As a standard
    action, she can grant herself a 50% concealment
    bonus for 5 rounds.  This ability is usable 1
    time per day at 9th level, 2 times per day at
    15th level, and 1 additional time per day every
    5 levels thereafter.
*/
//:://////////////////////////////////////////////
//:: Created By: Andrew Woo (AFW-OEI)
//:: Created On: 03/15/2007
//:://////////////////////////////////////////////

#include "nwn2_inc_spells"
#include "x2_inc_spellhook"

void main()
{
    if (!X2PreSpellCastCode())
    {   // If code within the PreSpellCastHook (i.e. UMD) reports FALSE, do not run this spell
        return;
    }
    
    //Declare major variables
    object oTarget = GetSpellTargetObject();

    // Does not stack with itself
    if (!GetHasSpellEffect(GetSpellId(), oTarget) )
    {
        effect eConceal = EffectConcealment(50);
        effect eVis     = EffectVisualEffect(VFX_DUR_SPELL_SPIRIT_FORM);
        effect eLink    = EffectLinkEffects(eConceal, eVis);
    
        //Fire cast spell at event for the specified target
        SignalEvent(oTarget, EventSpellCastAt(OBJECT_SELF, GetSpellId(), FALSE));
    
        //Apply the VFX impact and effects
        ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eLink, oTarget, RoundsToSeconds(5));
    }
}