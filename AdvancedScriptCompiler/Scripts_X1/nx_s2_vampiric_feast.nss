//::///////////////////////////////////////////////
//:: Vampiric Feast
//:: X2_S2_HELLBALL
//:: Copyright (c) 2003 Bioware Corp.
//:://////////////////////////////////////////////
/*

	Classes: Cleric, Druid, Spirit Shaman, Wizard, Sorcerer, Warlock
	Spellcraft Required: 24
	Caster Level: Epic
	Innate Level: Epic
	School: Necromancy
	Descriptor(s): Evil
	Components: Verbal, Somatic
	Range: Personal
	Area of Effect / Target: All hostile creatures within 20 ft. of caster.
	Duration: Instant
	Save: Fortitude ½ (DC +5)
	Spell Resistance: Yes
	 
	When this spell is cast, you drink in the life force of all enemies in
	the area of effect. Creatures who succeed at a Fortitude save (DC +5)
	lose only half their remaining hit points. Those who fail their saving
	throw are instantly slain. Moreover, the life-force of slain creatures
	coalesces as a Greater Shadow, which will attack any surviving enemies.
	 
	You are only able to absorb sufficient hit points to return you to full
	health. Any remaining life force dissipates into the fabric of the Weave.
 
*/
//:://////////////////////////////////////////////
//:: Created By: Andrew Woo
//:: Created On: 04/13/2007
//:://////////////////////////////////////////////
//:: AFW-OEI 06/25/2007: Reduce DC from +15 to +5.
//::	Remove hard HD caps, reduce radius to 20'.
//:: AFW-OEI 07/12/2007: NX1 VFX.


#include "X0_I0_SPELLS"
#include "x2_i0_spells"
#include "x2_inc_spellhook"


void main()
{
	if (!X2PreSpellCastCode())
	{	// If code within the PreSpellCastHook (i.e. UMD) reports FALSE, do not run this spell
	    return;
	}
	
	int nSaveDC = GetSpellSaveDC() + 5;
	int nTotalDamage = 0;
	int bSummonShadow = FALSE;
	//int nHD, nCurrentHP, nDamage;
	int nCurrentHP, nDamage;
	float fDelay;

	location lCaster = GetSpellTargetLocation();
	effect eVis = EffectVisualEffect(VFX_HIT_SPELL_VAMPIRIC_FEAST);
	effect eShadow = EffectSummonCreature("c_greater_shadow", VFX_FNF_SUMMON_UNDEAD);
	effect eDamage;
	
   	//Cycle through the targets within the spell shape until an invalid object is captured.
	object oTarget = GetFirstObjectInShape(SHAPE_SPHERE, RADIUS_SIZE_HUGE, lCaster, TRUE, OBJECT_TYPE_CREATURE);
    while (GetIsObjectValid(oTarget))
    {
		if (spellsIsTarget(oTarget, SPELL_TARGET_SELECTIVEHOSTILE, OBJECT_SELF))	// Only ever effects enemies
		{
			SignalEvent(oTarget, EventSpellCastAt(OBJECT_SELF, GetSpellId(), FALSE));
			
			//nHD = GetHitDice(oTarget);
			nCurrentHP = GetCurrentHitPoints(oTarget);
			fDelay = GetDistanceBetweenLocations(lCaster, GetLocation(oTarget))/20;	// Create a delay so that all creatures seem to be hit at the same time.
			
			//if (nHD <= 22 && !MyResistSpell(OBJECT_SELF, oTarget, fDelay))	// Creatures under over 22 HD are immune.
			if (!MyResistSpell(OBJECT_SELF, oTarget, fDelay))
			{
				if (!MySavingThrow(SAVING_THROW_FORT, oTarget, nSaveDC, SAVING_THROW_TYPE_SPELL, OBJECT_SELF, fDelay))
				{	// Fail save, lose all your remaining HP
					nDamage = nCurrentHP;
					bSummonShadow = TRUE;	// We killed at least one person.
				}
				else
				{	// Make save, lose half of remaining HP.
					nDamage = nCurrentHP/2;
				}
				
				eDamage = EffectDamage(nDamage, DAMAGE_TYPE_NEGATIVE, DAMAGE_POWER_NORMAL, TRUE);	// Last flag is to ignore all resistances & immunities.
				DelayCommand(fDelay, ApplyEffectToObject(DURATION_TYPE_INSTANT, eVis, oTarget));
				DelayCommand(fDelay, ApplyEffectToObject(DURATION_TYPE_INSTANT, eDamage, oTarget));
				
				nTotalDamage += nDamage;	// Accumulate total damage done for healing later.
			}		
		}
	
		oTarget = GetNextObjectInShape(SHAPE_SPHERE, RADIUS_SIZE_HUGE, lCaster, TRUE, OBJECT_TYPE_CREATURE);
	}
	
	if (nTotalDamage > 0)	// We drained some life.
	{
		effect eHeal = EffectHeal(nTotalDamage);
		DelayCommand(1.0f, ApplyEffectToObject(DURATION_TYPE_INSTANT, eHeal, OBJECT_SELF));
	}
	
	if (bSummonShadow)	// Somone got killed, so summon a Greater Shadow.
	{
		float fDuration = RoundsToSeconds(GetTotalLevels(OBJECT_SELF, TRUE));
		DelayCommand(1.0f, ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eShadow, OBJECT_SELF, fDuration));
	}
}