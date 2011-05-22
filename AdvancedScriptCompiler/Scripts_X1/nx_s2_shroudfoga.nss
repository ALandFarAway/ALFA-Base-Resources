//::///////////////////////////////////////////////
//:: Shroud of Fog: On Enter
//:: nx_s2_shroudfog.nss
//:: Copyright (c) 2007 Obsidian Entertainment, Inc.
//:://////////////////////////////////////////////
/*
	Repurposed from Darkness (nw_s2_darkness).

    Creates a globe of fog around those in the area
    of effect.
*/
//:://////////////////////////////////////////////
//:: Created By: Andrew Woo (AFW-OEI)
//:: Created On: 01/11/2007
//:://////////////////////////////////////////////
//:: AFW-OEI 07/09/2007: Change to 20% concealment
//::	and use new VFX
//:: RPGplayer1 03/19/2008:
//::  Will affect those with spell immunities
//::  EventSpellCastAt not Harmful anymore

#include "x0_i0_spells"
#include "x2_inc_spellhook"

void main()
{
    object oTarget = GetEnteringObject();	
	object oCreator = GetAreaOfEffectCreator();
	
	effect eConceal = EffectConcealment(20);
    effect eDur   = EffectVisualEffect(VFX_DUR_SPELL_SHROUDING_FOG);
	
    effect eLink = EffectLinkEffects(eConceal, eDur);

    if(GetIsObjectValid(oTarget))
    {
        SignalEvent(oTarget, EventSpellCastAt(oCreator, SPELLABILITY_SHROUDING_FOG, FALSE));
		
        // Creatures immune to the darkness spell are not affected.
        //if ( ResistSpell(oCreator ,oTarget) != 2 )
        {
            //Fire cast spell at event for the specified target
            ApplyEffectToObject(DURATION_TYPE_PERMANENT, eLink, oTarget);
        }
    }

}