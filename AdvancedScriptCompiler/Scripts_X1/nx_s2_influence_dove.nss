//::///////////////////////////////////////////////
//:: Dove Influence feats (Dove & Player)
//:: nx_s2_influence_dove.nss
//:: Copyright (c) 2007 Obsidian Entertainment, Inc.
//:://////////////////////////////////////////////
/*
	At Devoted, both Dove & Player get "Freedom of
	Movement"; that translates to Immunity to
	Paralysis, Entangle, Slow, and Movement Speed
	Decrease.
*/
//:://////////////////////////////////////////////
//:: Created By: Andrew Woo (AFW-OEI)
//:: Created On: 04/20/2007
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
    if ( !GetHasSpellEffect(SPELLABILITY_INFLUENCE_DOVE_DEVOTED, oTarget) &&
		 !GetHasSpellEffect(SPELLABILITY_INFLUENCE_DOVE_DEVOTED_PLAYER, oTarget) )
    {   
		int nSpellId = GetSpellId();
        SignalEvent(oTarget, EventSpellCastAt(OBJECT_SELF, nSpellId, FALSE));	        //Fire cast spell at event for the specified target
    
		effect eImmuneParalysis = EffectImmunity(IMMUNITY_TYPE_PARALYSIS);
		effect eImmuneEntangle = EffectImmunity(IMMUNITY_TYPE_ENTANGLE) ;
		effect eImmuneSlow = EffectImmunity(IMMUNITY_TYPE_SLOW);
		effect eImmuneMovementSpeedDecrease = EffectImmunity(IMMUNITY_TYPE_MOVEMENT_SPEED_DECREASE);
		
		effect eInfluenceEffects = EffectLinkEffects(eImmuneParalysis, eImmuneEntangle);
		eInfluenceEffects = EffectLinkEffects(eInfluenceEffects, eImmuneSlow);
		eInfluenceEffects = EffectLinkEffects(eInfluenceEffects, eImmuneMovementSpeedDecrease);
		
        //Apply the effects
		eInfluenceEffects = ExtraordinaryEffect(eInfluenceEffects);		// Cannot dispell.
        ApplyEffectToObject(DURATION_TYPE_PERMANENT, eInfluenceEffects, oTarget);
    }
}