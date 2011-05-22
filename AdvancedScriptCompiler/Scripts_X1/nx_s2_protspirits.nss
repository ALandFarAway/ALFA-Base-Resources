//::///////////////////////////////////////////////
//:: Protection from Spirits
//:: nx_s2_protspirits.nss
//:: Copyright (c) 2007 Obsidian Entertainment, Inc.
//:://////////////////////////////////////////////
/*
    The spirit shaman gains a permanent +2
    deflection bonus to AC and a +2 resistance
    bonus on saves against attacks and effects
    made by spirits. This is essentially a
    permanent Protection From Evil, except it
    protects against spirits and lasts until it
    is dismissed or dispelled.  If this ability
    is dispelled, the spirit shaman can recreate
    it simply by taking a standard action to do so.
*/
//:://////////////////////////////////////////////
//:: Created By: Andrew Woo (AFW-OEI)
//:: Created On: 03/13/2007
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

    // Does not stack with itself or with Warding of the Spirits
    if (!GetHasSpellEffect(SPELLABILITY_BLESSING_OF_THE_SPIRITS, oTarget) &&
        !GetHasSpellEffect(SPELLABILITY_WARDING_OF_THE_SPIRITS, oTarget) )
    {
        effect eAC = EffectACIncrease(2, AC_DEFLECTION_BONUS, AC_VS_DAMAGE_TYPE_ALL, TRUE);
        effect eSave = EffectSavingThrowIncrease(SAVING_THROW_ALL, 2, SAVING_THROW_TYPE_ALL, TRUE);
    
        effect eLink = EffectLinkEffects(eAC, eSave);
    
        //Fire cast spell at event for the specified target
        SignalEvent(oTarget, EventSpellCastAt(OBJECT_SELF, GetSpellId(), FALSE));
    
        //Apply the VFX impact and effects
        ApplyEffectToObject(DURATION_TYPE_PERMANENT, eLink, oTarget);
    }
}