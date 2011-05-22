//::///////////////////////////////////////////////
//:: Furious Assault
//:: NW_S2_FurAslt.nss
//:: Copyright (c) 2006 Obsidian Entertainment, Inc.
//:://////////////////////////////////////////////
/*
   * Attacks do max damage for the next 3 rounds.
   * User takes 10 points of damage at the end of
	 each round.
*/
//:://////////////////////////////////////////////
//:: Created By: Andrew Woo (AFW-OEI)
//:: Created On: 05/18/2006
//:://////////////////////////////////////////////
//:: RPGplayer1 01/07/2009:
//::   Since it's not possible to attack in first round, 
//::   duration is increased, and damage delayed for an extra round.

#include "x2_inc_spellhook"

void main()
{
    if (!X2PreSpellCastCode())
    {
		// If code within the PreSpellCastHook (i.e. UMD) reports FALSE, do not run this spell
        return;
    }

	object oTarget	  = OBJECT_SELF;

	effect eMaxDamage = EffectMaxDamage();
	effect eDur		  = EffectVisualEffect(VFX_DUR_CESSATE_POSITIVE);
	effect eDoT		  = EffectDamage(10);

	effect eLink = EffectLinkEffects(eMaxDamage, eDur);
	eLink = SupernaturalEffect(eLink);

	SignalEvent(oTarget, EventSpellCastAt(oTarget, SPELLABILITY_FURIOUS_ASSAULT, FALSE));
    ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eLink, oTarget, RoundsToSeconds(4));
	DelayCommand(RoundsToSeconds(2), ApplyEffectToObject(DURATION_TYPE_INSTANT, eDoT, oTarget));
	DelayCommand(RoundsToSeconds(3), ApplyEffectToObject(DURATION_TYPE_INSTANT, eDoT, oTarget));
	DelayCommand(RoundsToSeconds(4), ApplyEffectToObject(DURATION_TYPE_INSTANT, eDoT, oTarget));
}