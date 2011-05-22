//::///////////////////////////////////////////////
//:: Symbol of Pain (On Enter)
//:: nx2_s0_symbol_of_paina.nss
//:: Copyright (c) 2007 Obsidian Entertainment, Inc.
//:://////////////////////////////////////////////
/*

	Symbol of Pain
	Necromancy[Evil]
	Level: Cleric 5, Sorceror/wizard 5
	Components: V, S
	Casting Time: 
	Range:
	Duration: See text
	Saving Throw: Fortitude Negates
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
    object oTarget				= GetEnteringObject();
	object oCaster				= GetAreaOfEffectCreator();
	// duration
	float fDuration				= HoursToSeconds(1);
	// Effects
	effect eDecreaseAttack		= EffectAttackDecrease(4);
	effect eDecreaseSkill		= EffectSkillDecrease(SKILL_ALL_SKILLS, 4);
	effect eDecreaseAbility0	= EffectAbilityDecrease(ABILITY_CHARISMA, 4);
	effect eDecreaseAbility1	= EffectAbilityDecrease(ABILITY_CONSTITUTION, 4);
	effect eDecreaseAbility2	= EffectAbilityDecrease(ABILITY_DEXTERITY, 4);
	effect eDecreaseAbility3	= EffectAbilityDecrease(ABILITY_INTELLIGENCE, 4);
	effect eDecreaseAbility4	= EffectAbilityDecrease(ABILITY_STRENGTH, 4);
	effect eDecreaseAbility5	= EffectAbilityDecrease(ABILITY_WISDOM, 4);
	effect eLink;
	effect eActivated 			= EffectNWN2SpecialEffectFile("fx_feat_chastisespirits_aoe01.sef");
	effect eVisual				= EffectVisualEffect(VFX_DUR_SPELL_SYMBOL_OF_PAIN);
	float fDelay;
	eLink						= EffectLinkEffects(eDecreaseAttack, eDecreaseSkill);
	eLink						= EffectLinkEffects(eLink, eDecreaseAbility0);
	eLink						= EffectLinkEffects(eLink, eDecreaseAbility1);
	eLink						= EffectLinkEffects(eLink, eDecreaseAbility2);
	eLink						= EffectLinkEffects(eLink, eDecreaseAbility3);
	eLink						= EffectLinkEffects(eLink, eDecreaseAbility4);
	eLink						= EffectLinkEffects(eLink, eDecreaseAbility5);
	// to make sure the spell in not repeatedly added to a creature
	SetEffectSpellId(eLink, SPELL_SYMBOL_OF_PAIN);
	
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
				if (spellsIsTarget(oTarget, SPELL_TARGET_SELECTIVEHOSTILE, oCaster) && !GetHasSpellEffect(SPELL_SYMBOL_OF_PAIN, oTarget))
		    	{
					fDelay = GetDistanceBetweenLocations(lTarget, GetLocation(oTarget))/20;	
					//Fire cast spell at event for the specified target
			        SignalEvent(oTarget, EventSpellCastAt(oCaster, SPELL_SYMBOL_OF_PAIN, TRUE));
					// saving throw
					int nSaved	= FortitudeSave(oTarget, GetSpellSaveDC(), SAVING_THROW_TYPE_EVIL, GetAreaOfEffectCreator());
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
						ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eLink, oTarget, fDuration);
						DelayCommand(fDelay,ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eVisual, oTarget, fDuration));
					}	
				}
				oTarget = GetNextObjectInShape(SHAPE_SPHERE, RADIUS_SIZE_VAST, lTarget);
			}	
	    }
	}
}