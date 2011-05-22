//::///////////////////////////////////////////////
//:: Recitation
//:: NX_s0_recitation.nss
//:: Copyright (c) 2007 Obsidian Entertainment
//:://////////////////////////////////////////////
/*
	Recitation
	Creation (Conjuration)
	Level: Cleric 4
	Components: V, S
	Targets: All allies within a 60-ft.-radius of caster
	Duration: 1 round/level
	Saving Throw: None
	Spell Resistance: Yes
	
	This spell affects all allies within the spell's area at
	the moment you cast it.  Your allies gain a +2 bonus to
	AC, attack rolls, and saving throws, or a + 3 bonus if
	they worship the same diety as you.

	
	Note: SC says that this spell also targets foes in the
	area, but doesn't say exactly what it does to them.
	Presumably it also gives them the bonus but the
	description is unclear.
	
*/
//:://////////////////////////////////////////////
//:: Created By: Ryan Young
//:: Created On: 1.16.2007
//:://////////////////////////////////////////////
//:: AFW-OEI 06/26/2007: Removed SR checks.

#include "nwn2_inc_spells"


#include "x2_inc_spellhook" 

void main()
{
    if (!X2PreSpellCastCode())
    {	// If code within the PreSpellCastHook (i.e. UMD) reports FALSE, do not run this spell
        return;
    }

    // Declare major variables
	object oCaster = OBJECT_SELF;
    int nCasterLvl = GetCasterLevel(oCaster);
    float fDuration = RoundsToSeconds(nCasterLvl);
    fDuration = ApplyMetamagicDurationMods(fDuration);
    int nDurType = ApplyMetamagicDurationTypeMods(DURATION_TYPE_TEMPORARY);
	location lTarget = GetLocation(oCaster);

	// effects
	effect eAC;
	effect eAttack;
	effect eSave;
	effect eVis = EffectVisualEffect(VFX_DUR_SPELL_RECITATION);
	effect eLink;
	
	// find the first target
    object oTarget = GetFirstObjectInShape(SHAPE_SPHERE, RADIUS_SIZE_VAST, lTarget, TRUE, OBJECT_TYPE_CREATURE);
	
	while (GetIsObjectValid(oTarget)) {
		if (spellsIsTarget(oTarget, SPELL_TARGET_ALLALLIES, oCaster)) {
		
			//Fire cast spell at event for the specified target
    		SignalEvent(oTarget, EventSpellCastAt(oCaster, GetSpellId(), FALSE));
			
			int nBonus = 2;
			if (GetStringLowerCase(GetDeity(oTarget)) == GetStringLowerCase(GetDeity(oCaster))) {
				nBonus = 3;
			}
			eAC = EffectACIncrease(nBonus, AC_DODGE_BONUS, AC_VS_DAMAGE_TYPE_ALL);
			eAttack = EffectAttackIncrease(nBonus);
			eSave = EffectSavingThrowIncrease(SAVING_THROW_ALL, nBonus, SAVING_THROW_TYPE_ALL);
			eLink = EffectLinkEffects(eAC, eAttack);
			eLink = EffectLinkEffects(eLink, eSave);
			eLink = EffectLinkEffects(eLink, eVis);
		
			RemoveEffectsFromSpell(oTarget, GetSpellId());
		
   			//Apply the VFX impact and effects
   			ApplyEffectToObject(nDurType, eLink, oTarget, fDuration);
		}
		oTarget = GetNextObjectInShape(SHAPE_SPHERE, RADIUS_SIZE_VAST, lTarget, TRUE, OBJECT_TYPE_CREATURE);
	}		
}