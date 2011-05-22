//::///////////////////////////////////////////////
//:: Okku Influence feats
//:: nx_s2_influence_okku.nss
//:: Copyright (c) 2007 Obsidian Entertainment, Inc.
//:://////////////////////////////////////////////
/*
    At Loyal, Okku gains Immunity to Fear.
	
	At Devoted, Okku gains Immunity to Fear, and
	Immunity to Mind-Affecting Spells.
*/
//:://////////////////////////////////////////////
//:: Created By: Andrew Woo (AFW-OEI)
//:: Created On: 04/18/2007
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
    if (!GetHasSpellEffect(SPELLABILITY_INFLUENCE_OKKU_LOYAL, oTarget) &&
        !GetHasSpellEffect(SPELLABILITY_INFLUENCE_OKKU_DEVOTED, oTarget) )
    {   
		int nSpellId = GetSpellId();
        SignalEvent(oTarget, EventSpellCastAt(OBJECT_SELF, nSpellId, FALSE));	        //Fire cast spell at event for the specified target
    
		effect eInfluenceEffects;
		effect eImmuneFear = EffectImmunity(IMMUNITY_TYPE_FEAR);
		
		if (nSpellId == SPELLABILITY_INFLUENCE_OKKU_DEVOTED)
		{	// Devoted grants more stuff
			effect eImmuneMind = EffectImmunity(IMMUNITY_TYPE_MIND_SPELLS);			
			eInfluenceEffects = EffectLinkEffects(eImmuneFear, eImmuneMind);
			
			// AFW-OEI 09/13/2007: Regenerate 4 HP every round (6 seconds).
			effect eRegen = EffectRegenerate(4, 6.0);
			eInfluenceEffects = EffectLinkEffects(eRegen, eInfluenceEffects);
		}
	 	else
		{	// Otherwise, it's just Immunity to Fear by itself.
			eInfluenceEffects = eImmuneFear;
		}
    
        //Apply the effects
		eInfluenceEffects = ExtraordinaryEffect(eInfluenceEffects);		// Cannot dispell.
        ApplyEffectToObject(DURATION_TYPE_PERMANENT, eInfluenceEffects, oTarget);
    }
}