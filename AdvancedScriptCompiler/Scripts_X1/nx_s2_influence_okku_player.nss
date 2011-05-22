//::///////////////////////////////////////////////
//:: Okku Influence feats (player)
//:: nx_s2_influence_okku_player.nss
//:: Copyright (c) 2007 Obsidian Entertainment, Inc.
//:://////////////////////////////////////////////
/*
	At Devoted, Player gains Immunity to Fear.
*/
//:://////////////////////////////////////////////
//:: Created By: Andrew Woo (AFW-OEI)
//:: Created On: 04/19/2007
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
    if (!GetHasSpellEffect(SPELLABILITY_INFLUENCE_OKKU_DEVOTED_PLAYER, oTarget) )
    {   
		int nSpellId = GetSpellId();
        SignalEvent(oTarget, EventSpellCastAt(OBJECT_SELF, nSpellId, FALSE));	        //Fire cast spell at event for the specified target
    
		effect eImmuneFear = EffectImmunity(IMMUNITY_TYPE_FEAR);
		
        //Apply the effects
		eImmuneFear = ExtraordinaryEffect(eImmuneFear);		// Cannot dispell.
        ApplyEffectToObject(DURATION_TYPE_PERMANENT, eImmuneFear, oTarget);
    }
}