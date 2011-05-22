//::///////////////////////////////////////////////
//:: Symbol of Persuasion (On Enter)
//:: nx2_s0_symbol_of_persuasiona.nss
//:: Copyright (c) 2007 Obsidian Entertainment, Inc.
//:://////////////////////////////////////////////
/*

	Symbol of Persuasion
	Enchantment[Mind-Affecting]
	Level: Cleric 6, Sorceror/wizard 6
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
#include "ginc_debug"

void main()
{

    //Get target
    object oTarget			= GetEnteringObject();
	object oCaster			= GetAreaOfEffectCreator();
	// duration
	int nCasterLevel		= GetCasterLevel(oCaster);
	float fDuration			= HoursToSeconds(nCasterLevel);
	// Effects
	effect eCharm			= EffectCharmed();
	effect eActivated 		= EffectNWN2SpecialEffectFile("fx_feat_chastisespirits_aoe01.sef");
	effect eVisual			= EffectVisualEffect(VFX_DUR_SPELL_SYMBOL_OF_PERSUASION);
	float fDelay;
	// to make sure the spell in not repeatedly added to a creature
	SetEffectSpellId(eCharm, SPELL_SYMBOL_OF_PERSUASION);
	
	// target valid?
	if(GetIsObjectValid(oTarget) && !GetHasSpellEffect(GetSpellId(), oTarget))
	{
	    if (spellsIsTarget(oTarget, SPELL_TARGET_SELECTIVEHOSTILE, oCaster))
	    {	
			// now that a valid target has triggered symbol get all valid targets in a 60ft radius and apply symbol effect
			ApplyEffectToObject(DURATION_TYPE_INSTANT, eActivated, OBJECT_SELF);
			location lTarget = GetLocation(oTarget);
			oTarget = GetFirstObjectInShape(SHAPE_SPHERE, RADIUS_SIZE_VAST, lTarget);
			
			while(GetIsObjectValid(oTarget))
			{		
				if (spellsIsTarget(oTarget, SPELL_TARGET_SELECTIVEHOSTILE, oCaster) && !GetHasSpellEffect(SPELL_SYMBOL_OF_PERSUASION, oTarget))
		    	{
					fDelay = GetDistanceBetweenLocations(lTarget, GetLocation(oTarget))/20;			
					//Fire cast spell at event for the specified target
			        SignalEvent(oTarget, EventSpellCastAt(oCaster, SPELL_SYMBOL_OF_PERSUASION, TRUE));
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
						AssignCommand(oCaster, ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eCharm, oTarget, fDuration));
						DelayCommand(fDelay,ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eVisual, oTarget, fDuration));
					}
				}
				oTarget = GetNextObjectInShape(SHAPE_SPHERE, RADIUS_SIZE_VAST, lTarget);
			}		
	    }
	}
}