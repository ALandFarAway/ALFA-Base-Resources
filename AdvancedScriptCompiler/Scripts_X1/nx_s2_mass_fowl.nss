//::///////////////////////////////////////////////
//:: Mass Fowl
//:: nx_s2_mass_fowl.nss
//:: Copyright (c) 2007 Obsidian Entertainment, Inc.
//:://////////////////////////////////////////////
/*
	Classes: Bard, Druid, Spirit Shaman, Wizard, Sorcerer
	Spellcraft Required: 24
	Caster Level: Epic
	Innate Level: Epic
	School: Transmutation
	Descriptor(s): 
	Components: Verbal, Somatic
	Range: Long
	Area of Effect / Target: 20-ft radius hemisphere
	Duration: Permanent
	Save: Fortitude negates
	Spell Resistance: Yes
	 
	This spell transforms all hostile creatures of Medium-size or
	smaller in the area into chickens. Targets are allowed a
	Fortitude save (DC +5) to negate the effects of the spell.
	The transformation is permanent.
*/
//:://////////////////////////////////////////////
//:: Created By: Andrew Woo
//:: Created On: 04/11/2007
//:://////////////////////////////////////////////
//:: AFW-OEI 06/25/2007: Reduce DC from +15 to +5.
//::	Remove hard HD caps, reduce radius to 20'.
//:: AFW-OEI 07/11/2007: NX1 VFX.
//:: AFW-OEI 07/16/2007: Reduce INT, WIS, & CHA to 9 to block spellcasting.

#include "x2_i0_spells"
#include "x2_inc_spellhook"

void main()
{
    if (!X2PreSpellCastCode())
    {   // If code within the PreSpellCastHook (i.e. UMD) reports FALSE, do not run this spell
        return;
    }

	//int nHD, nCreatureSize;
	int nCreatureSize;
	float fDelay;
    int nSpell = GetSpellId();
	int nSaveDC = GetSpellSaveDC() + 5;
    location lTarget = GetSpellTargetLocation();
		
    effect eVis = EffectVisualEffect( VFX_HIT_SPELL_MASS_FOWL );
	
    effect ePoly = EffectPolymorph(POLYMORPH_TYPE_CHICKEN, TRUE);
	ePoly = ExtraordinaryEffect(ePoly);	// AFW-OEI 07/11/2007: No dispelling extraordinary effects.
	
    //Declare the spell shape, size and the location.  Capture the first target object in the shape.
    object oTarget = GetFirstObjectInShape(SHAPE_SPHERE, RADIUS_SIZE_HUGE, lTarget, TRUE, OBJECT_TYPE_CREATURE);
    while (GetIsObjectValid(oTarget))
    {
		if ( spellsIsTarget(oTarget, SPELL_TARGET_SELECTIVEHOSTILE, OBJECT_SELF) )	// Only ever effects enemies.
		{
		    //Fire cast spell at event for the specified target
		    SignalEvent(oTarget, EventSpellCastAt(OBJECT_SELF, nSpell, FALSE));
		
            //Get the distance between the explosion and the target to calculate delay
			//nHD = GetHitDice(oTarget);
			nCreatureSize = GetCreatureSize(oTarget);	
            fDelay = GetDistanceBetweenLocations(lTarget, GetLocation(oTarget))/20;
			
			//if ( nHD <= 15 && nCreatureSize <= CREATURE_SIZE_MEDIUM &&	// Only affects Medium or smaller creatures with 15 or less HD
			if ( nCreatureSize <= CREATURE_SIZE_MEDIUM &&					// Only affects Medium or smaller creatures
				 !MyResistSpell(OBJECT_SELF, oTarget, fDelay) &&
				 !MySavingThrow(SAVING_THROW_FORT, oTarget, nSaveDC, SAVING_THROW_TYPE_SPELL, OBJECT_SELF, fDelay) )
			{
				//Apply the VFX impact and effects
				ApplyEffectToObject(DURATION_TYPE_INSTANT, eVis, oTarget);
				AssignCommand(oTarget, ClearAllActions()); // prevents an exploit	
				DelayCommand(fDelay, ApplyEffectToObject(DURATION_TYPE_PERMANENT, ePoly, oTarget));
				
				// Reduce mental stats to 9.
				int nINT = GetAbilityScore(oTarget, ABILITY_INTELLIGENCE);
				int nWIS = GetAbilityScore(oTarget, ABILITY_WISDOM);
				int nCHA = GetAbilityScore(oTarget, ABILITY_CHARISMA);
				
				if (nINT > 9)
				{
					effect eINT = EffectAbilityDecrease(ABILITY_INTELLIGENCE, nINT - 9);
					DelayCommand(fDelay, ApplyEffectToObject(DURATION_TYPE_PERMANENT, eINT, oTarget));
				}
				if (nWIS > 9)
				{
					effect eWIS = EffectAbilityDecrease(ABILITY_WISDOM, nWIS - 9);
					DelayCommand(fDelay, ApplyEffectToObject(DURATION_TYPE_PERMANENT, eWIS, oTarget));
				}
				if (nCHA > 9)
				{
					effect eCHA = EffectAbilityDecrease(ABILITY_CHARISMA, nCHA - 9);
					DelayCommand(fDelay, ApplyEffectToObject(DURATION_TYPE_PERMANENT, eCHA, oTarget));
				}
			}
		}
						
	    //Select the next target within the spell shape.
        oTarget = GetNextObjectInShape(SHAPE_SPHERE, RADIUS_SIZE_HUGE, lTarget, TRUE, OBJECT_TYPE_CREATURE);
	}
}