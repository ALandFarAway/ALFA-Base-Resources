//::///////////////////////////////////////////////
//:: Blood to Water
//:: nx2_s0_blood_to_water.nss
//:: Copyright (c) 2007 Obsidian Entertainment, Inc.
//:://////////////////////////////////////////////
/*
	Blood to Water
	Necromancy [Water]
	Level: Cleric 7
	Components: V, S
	Range: Close
	Effect: Up to five living creatures withint a 30ft. radius.
	Duration: Instantaneous
	Saving Throw: Fortitude half
	Spell Resistance: Yes
	 
	You transmute the subjects' blood into pure water, dealing 2d6 points of Constitution damage. 
	A sucessful Fortitude save halves the Constitution damage.
	 
	NOTE: The spell specifies that water and fire subtypes are immune to this spell.  
	I am fine with ignoring this rule or special casing fire/water genasi and fire giants from the list.  
	Outsiders, elementals, undead, etc, are already covered under the "living targets" rule.
	
*/
//:://////////////////////////////////////////////
//:: Created By: Michael Diekmann
//:: Created On: 08/28/2007
//:://////////////////////////////////////////////

#include "nwn2_inc_spells"
#include "x2_inc_spellhook"
#include "x0_i0_match"

void main()
{
    if (!X2PreSpellCastCode())
    {
	    // If code within the PreSpellCastHook (i.e. UMD) reports FALSE, do not run this spell
        return;
    }
	// Get necessary objects
	location lTarget		= GetSpellTargetLocation();
	object oCaster			= OBJECT_SELF;
	// Effect placeholders
	int nDamage;
	effect eDamage;
	effect eHit	 			= EffectVisualEffect(VFX_HIT_SPELL_BLOOD_TO_WATER);
	effect eVisual			= EffectVisualEffect(VFX_AOE_SPELL_BLOOD_TO_WATER);
	float fDelay;
	//counter
	int nCount = 1;
	// Succesful save?
	int nSaved;
	
	ApplyEffectAtLocation(DURATION_TYPE_INSTANT, eVisual, lTarget);
	
	//Get first target
	object oTarget = GetFirstObjectInShape(SHAPE_SPHERE, RADIUS_SIZE_COLOSSAL, lTarget, TRUE, OBJECT_TYPE_CREATURE);
	// as long as target is valid and count is less than 5
	while(nCount <=5 && GetIsObjectValid(oTarget))
	{
		// Make sure spell target is living
		if (!MatchNonliving(GetRacialType(oTarget)))
		{	
			// check to see if hostile
			if (spellsIsTarget(oTarget, SPELL_TARGET_STANDARDHOSTILE, oCaster)) 
			{
				// remove previous usages of this spell
				RemoveEffectsFromSpell(oTarget, GetSpellId());
				fDelay = GetDistanceBetweenLocations(lTarget, GetLocation(oTarget))/20;
				nDamage = d6(2);
				nSaved = FortitudeSave(oTarget, GetSpellSaveDC(), SAVING_THROW_TYPE_NEGATIVE, oCaster);
				if(nSaved == 2)
				{
					// spell resisted
				}
				else if(nSaved == 1)
				{
					// successful save
					nDamage = nDamage/2;
					eDamage = EffectAbilityDecrease(ABILITY_CONSTITUTION, nDamage);
					DelayCommand(fDelay, ApplyEffectToObject(DURATION_TYPE_INSTANT, eHit, oTarget));
					ApplyEffectToObject(DURATION_TYPE_PERMANENT, eDamage, oTarget);
				}
				else if(nSaved == 0)
				{
					eDamage = EffectAbilityDecrease(ABILITY_CONSTITUTION, nDamage);
					DelayCommand(fDelay, ApplyEffectToObject(DURATION_TYPE_INSTANT, eHit, oTarget));
					ApplyEffectToObject(DURATION_TYPE_PERMANENT, eDamage, oTarget);
				}
				//Fire cast spell at event for the specified target
	    		SignalEvent(oTarget, EventSpellCastAt(OBJECT_SELF, GetSpellId(), TRUE));
				nCount++;
			}
		}
		oTarget = GetNextObjectInShape(SHAPE_SPHERE, RADIUS_SIZE_COLOSSAL, lTarget, TRUE, OBJECT_TYPE_CREATURE);
	}
}