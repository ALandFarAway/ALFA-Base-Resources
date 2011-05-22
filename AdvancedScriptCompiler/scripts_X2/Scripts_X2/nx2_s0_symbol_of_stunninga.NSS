//::///////////////////////////////////////////////
//:: Symbol of Stunning (On Enter)
//:: nx2_s0_symbol_of_stunninga.nss
//:: Copyright (c) 2007 Obsidian Entertainment, Inc.
//:://////////////////////////////////////////////
/*

	Symbol of Stunning
	Enchantment[Mind-Affecting]
	Level: Cleric 7, Sorceror/wizard 7
	Components: V, S
	Casting Time: 
	Range:
	Duration: See text
	Saving Throw: Will Negates
	Spell Resistance: Yes

*/
//:://////////////////////////////////////////////
//:: Created By: Michael Diekmann
//:: Created On: 09/05/2007
//:://////////////////////////////////////////////

#include "x0_i0_spells"

void main()
{

    //Get target
    object oTarget	= GetEnteringObject();
	object oCaster	= GetAreaOfEffectCreator();
    // Spell duration
	int nDuration 	= d6(1);
	float fDuration	= RoundsToSeconds(nDuration);
	// Effects
	effect eStun	= EffectStunned();
	effect eActivated 		= EffectNWN2SpecialEffectFile("fx_feat_chastisespirits_aoe01.sef");
	effect eVisual			= EffectVisualEffect(VFX_DUR_SPELL_SYMBOL_OF_STUNNING);
	float fDelay;
	// to make sure the spell in not repeatedly added to a creature
	SetEffectSpellId(eStun, SPELL_SYMBOL_OF_STUNNING);
	
	// target valid with 10 or less HD
	if(GetIsObjectValid(oTarget) && !GetHasSpellEffect(SPELL_SYMBOL_OF_STUNNING, oTarget))
	{
	    if (spellsIsTarget(oTarget, SPELL_TARGET_SELECTIVEHOSTILE, oCaster))
	    {
			// now that a valid target has triggered symbol get all valid targets in a 60ft radius and apply symbol effect
			ApplyEffectToObject(DURATION_TYPE_INSTANT, eActivated, OBJECT_SELF);
			location lTarget = GetLocation(oTarget);
			oTarget = GetFirstObjectInShape(SHAPE_SPHERE, RADIUS_SIZE_VAST, lTarget);
			
			while(GetIsObjectValid(oTarget))
			{		
				if (spellsIsTarget(oTarget, SPELL_TARGET_SELECTIVEHOSTILE, oCaster) && !GetHasSpellEffect(1180, oTarget))
		    	{
					fDelay = GetDistanceBetweenLocations(lTarget, GetLocation(oTarget))/20;
					nDuration 	= d6(1);
					fDuration	= RoundsToSeconds(nDuration);
					// saving throw
					int nSaved	= WillSave(oTarget, GetSpellSaveDC(), SAVING_THROW_TYPE_MIND_SPELLS, GetAreaOfEffectCreator());
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
						ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eStun, oTarget, fDuration);
						DelayCommand(fDelay,ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eVisual, oTarget, fDuration));
					}
					//Fire cast spell at event for the specified target
			        SignalEvent(oTarget, EventSpellCastAt(oCaster, SPELL_SYMBOL_OF_STUNNING, TRUE));
				}
				oTarget = GetNextObjectInShape(SHAPE_SPHERE, RADIUS_SIZE_VAST, lTarget);
			}
	    }
	}
}