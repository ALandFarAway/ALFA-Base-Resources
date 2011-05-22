//::///////////////////////////////////////////////
//:: One of Many Influence feats (Player)
//:: nx_s2_influence_oneofmany.nss
//:: Copyright (c) 2007 Obsidian Entertainment, Inc.
//:://////////////////////////////////////////////
/*
    At Loyal, Player gains Regen 3/round.
	
	At Devoted, Player gains Regen 6/round.
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
    if (!GetHasSpellEffect(SPELLABILITY_INFLUENCE_ONEOFMANY_LOYAL_PLAYER, oTarget) &&
        !GetHasSpellEffect(SPELLABILITY_INFLUENCE_ONEOFMANY_DEVOTED_PLAYER, oTarget) )
    {   
		int nSpellId = GetSpellId();
        SignalEvent(oTarget, EventSpellCastAt(OBJECT_SELF, nSpellId, FALSE));	        //Fire cast spell at event for the specified target
    
		int nRegen = 3;	// Default to 3
		if (nSpellId == SPELLABILITY_INFLUENCE_ONEOFMANY_DEVOTED_PLAYER)
		{
			nRegen = 6;
		}
		
		effect eRegen = EffectRegenerate(nRegen, RoundsToSeconds(1));
		
        //Apply the effects
		eRegen = ExtraordinaryEffect(eRegen);		// Cannot dispell.
        ApplyEffectToObject(DURATION_TYPE_PERMANENT, eRegen, oTarget);
    }
}