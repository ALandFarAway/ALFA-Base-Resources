//::///////////////////////////////////////////////
//:: Inner Armor
//:: nx_s2_innerarmor.nss
//:: Copyright (c) 2007 Obsidian Entertainment, Inc.
//:://////////////////////////////////////////////
/*
	At 10th level, a sacred fist’s inner tranquility
	protects him from external threats. He may invoke
	a +4 sacred bonus to AC, a +4 sacred bonus on all saves,
	and spell resistance 25 for a number of rounds equal to his
	Wisdom modifier. He may use inner armor once per day.
	*/
//:://////////////////////////////////////////////
//:: Created By: Andrew Woo (AFW-OEI)
//:: Created On: 05/01/2007
//:://////////////////////////////////////////////
//:: AFW-OEI 07/12/2007: NX1 VFX

#include "x2_inc_spellhook"
#include "x2_inc_itemprop"
#include "x0_i0_spells"

void main()
{
    if (!X2PreSpellCastCode())
    {   // If code within the PreSpellCastHook (i.e. UMD) reports FALSE, do not run this spell
        return;
    }

	int nWisdomBonus  = GetAbilityModifier(ABILITY_WISDOM);
	if (nWisdomBonus <= 0)
	{
		nWisdomBonus = 1;	// Lasts a minimum of one round.
	}
	
	effect eAC = EffectACIncrease(4, AC_DODGE_BONUS);
	effect eSave = EffectSavingThrowIncrease(SAVING_THROW_ALL, 4);
	effect eSR = EffectSpellResistanceIncrease(25);
	effect eDur = EffectVisualEffect(VFX_DUR_INNER_ARMOR);
		
    effect eLink = EffectLinkEffects(eAC, eSave);
	eLink = EffectLinkEffects(eLink, eSR);
	eLink = EffectLinkEffects(eLink, eDur);

    //Fire cast spell at event for the specified target
    SignalEvent(OBJECT_SELF, EventSpellCastAt(OBJECT_SELF, GetSpellId(), FALSE));

    // Spell does not stack
    if (GetHasSpellEffect(GetSpellId(),OBJECT_SELF))
    {
         RemoveSpellEffects(GetSpellId(), OBJECT_SELF, OBJECT_SELF);
    }

    //Apply the VFX impact and effects
    ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eLink, OBJECT_SELF, RoundsToSeconds(nWisdomBonus));
}