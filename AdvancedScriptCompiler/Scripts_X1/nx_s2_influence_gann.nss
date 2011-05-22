//::///////////////////////////////////////////////
//:: Gann Influence feats (Gann & Player)
//:: nx_s2_influence_gann.nss
//:: Copyright (c) 2007 Obsidian Entertainment, Inc.
//:://////////////////////////////////////////////
/*
	At Romance, both Gann & Player get Immunity to
	Mind-affecting Spells.
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
    if ( !GetHasSpellEffect(SPELLABILITY_INFLUENCE_GANN_ROMANCE, oTarget) &&
		 !GetHasSpellEffect(SPELLABILITY_INFLUENCE_GANN_ROMANCE_PLAYER, oTarget) )
    {   
		int nSpellId = GetSpellId();
        SignalEvent(oTarget, EventSpellCastAt(OBJECT_SELF, nSpellId, FALSE));	        //Fire cast spell at event for the specified target
    
		effect eImmuneMind = EffectImmunity(IMMUNITY_TYPE_MIND_SPELLS);		
		
        //Apply the effects
		eImmuneMind = ExtraordinaryEffect(eImmuneMind);		// Cannot dispell.
        ApplyEffectToObject(DURATION_TYPE_PERMANENT, eImmuneMind, oTarget);
    }
}