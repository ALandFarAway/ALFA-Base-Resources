//::///////////////////////////////////////////////
//:: Sacred Flames
//:: nx_s2_sacredflames.nss
//:: Copyright (c) 2007 Obsidian Entertainment, Inc.
//:://////////////////////////////////////////////
/*
	At 4th level, a sacred fist may use a
	standard action to invoke sacred flames around his hands and
	feet. These flames add to the sacred fist’s unarmed damage.
	The additional damage is equal to the sacred fist’s class level
	plus his Wisdom modifier (if any). Half the damage is fire
	damage (round up), and the rest is sacred energy and thus
	not subject to effects that reduce fire damage. The sacred
	flames last 1 minute and can be invoked once per day. At 8th
	level, a sacred fist can invoke sacred flames twice per day.
*/
//:://////////////////////////////////////////////
//:: Created By: Andrew Woo (AFW-OEI)
//:: Created On: 05/01/2007
//:://////////////////////////////////////////////
//:: AFW-OEI 06/28/2007: Flamey fist VFX.

#include "x2_inc_spellhook"
#include "x2_inc_itemprop"
#include "x0_i0_spells"

void main()
{
    if (!X2PreSpellCastCode())
    {   // If code within the PreSpellCastHook (i.e. UMD) reports FALSE, do not run this spell
        return;
    }

    int nTotalDamage  = GetLevelByClass(CLASS_TYPE_SACREDFIST);
	int nWisdomBonus  = GetAbilityModifier(ABILITY_WISDOM);
	if (nWisdomBonus > 0)
	{
		nTotalDamage += nWisdomBonus;
	}
	
	int nDivineDamage = nTotalDamage/2;					// Half of bonus (rounded down) is divine damage.
	int nFireDamage   = nTotalDamage - nDivineDamage;	// The rest (half rounded up) is fire damage.
	
    effect eDivineDamage = EffectDamageIncrease(IPGetDamageBonusConstantFromNumber(nDivineDamage), DAMAGE_TYPE_DIVINE);
    effect eFireDamage   = EffectDamageIncrease(IPGetDamageBonusConstantFromNumber(nFireDamage), DAMAGE_TYPE_FIRE);
	effect eFists		 = EffectVisualEffect(VFX_DUR_SACRED_FLAMES);
	
    effect eLink = EffectLinkEffects(eDivineDamage, eFireDamage);
	eLink = EffectLinkEffects(eLink, eFists);

    //Fire cast spell at event for the specified target
    SignalEvent(OBJECT_SELF, EventSpellCastAt(OBJECT_SELF, GetSpellId(), FALSE));

    // Spell does not stack
    if (GetHasSpellEffect(GetSpellId(),OBJECT_SELF))
    {
         RemoveSpellEffects(GetSpellId(), OBJECT_SELF, OBJECT_SELF);
    }

    //Apply the VFX impact and effects
    ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eLink, OBJECT_SELF, RoundsToSeconds(10));	// Lasts 10 rounds = 1 minute.
}