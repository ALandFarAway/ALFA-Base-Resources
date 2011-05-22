//::///////////////////////////////////////////////
//:: Symbol of Weakness (On Enter)
//:: nx2_s0_symbol_of_weaknessa.nss
//:: Copyright (c) 2007 Obsidian Entertainment, Inc.
//:://////////////////////////////////////////////
/*

	Symbol of Weakness
	Necromancy
	Level: Cleric 7, Sorceror/wizard 7
	Components: V, S
	Casting Time: 
	Range:
	Duration: See text
	Saving Throw: Fortitude Negates
	Spell Resistance: Yes

*/
//:://////////////////////////////////////////////
//:: Created By: Michael Diekmann
//:: Created On: 08/31/2007
//:://////////////////////////////////////////////

#include "x0_i0_spells"

void main()
{

    //Get target
    object oTarget		= GetEnteringObject();
	object oCaster		= GetAreaOfEffectCreator();
    // Spell damage
	int nDamage 		= d6(3);
	// Effects
	effect eDamage;
	effect eActivated 	= EffectNWN2SpecialEffectFile("fx_feat_chastisespirits_aoe01.sef");
	effect eVisual		= EffectVisualEffect(VFX_DUR_SPELL_SYMBOL_OF_WEAKNESS);
	float fDelay;
	// to make sure the spell in not repeatedly added to a creature
	SetEffectSpellId(eDamage, SPELL_SYMBOL_OF_WEAKNESS);
	// target valid?
	if(GetIsObjectValid(oTarget))
	{
	    if (spellsIsTarget(oTarget, SPELL_TARGET_SELECTIVEHOSTILE, oCaster))
	    {
			// now that a valid target has triggered symbol get all valid targets in a 60ft radius and apply symbol effect
			ApplyEffectToObject(DURATION_TYPE_INSTANT, eActivated, OBJECT_SELF);
			location lTarget = GetLocation(oTarget);
			oTarget = GetFirstObjectInShape(SHAPE_SPHERE, RADIUS_SIZE_VAST, lTarget);
			
			while(GetIsObjectValid(oTarget))
			{		
				if (spellsIsTarget(oTarget, SPELL_TARGET_SELECTIVEHOSTILE, oCaster)&& !GetHasSpellEffect(SPELL_SYMBOL_OF_WEAKNESS, oTarget))
		    	{
					fDelay = GetDistanceBetweenLocations(lTarget, GetLocation(oTarget))/20;
					nDamage = d6(3);
					eDamage = EffectAbilityDecrease(ABILITY_STRENGTH, nDamage);
					// saving throw
					int nSaved	= FortitudeSave(oTarget, GetSpellSaveDC(), SAVING_THROW_TYPE_NEGATIVE, GetAreaOfEffectCreator());
			     	if(nSaved == 2)
					{
						// spell resisted
					}   
					else if(nSaved == 1)
					{
						// good saving throw
					}
					else if(nSaved == 0)
					{
						ApplyEffectToObject(DURATION_TYPE_PERMANENT, eDamage, oTarget);
						DelayCommand(fDelay, ApplyEffectToObject(DURATION_TYPE_INSTANT, eVisual, oTarget));
					}
					//Fire cast spell at event for the specified target
			        SignalEvent(oTarget, EventSpellCastAt(oCaster, SPELL_SYMBOL_OF_WEAKNESS, TRUE));
				}
				oTarget = GetNextObjectInShape(SHAPE_SPHERE, RADIUS_SIZE_VAST, lTarget);
			}
	    }
	}
}