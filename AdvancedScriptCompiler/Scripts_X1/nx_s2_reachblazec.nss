//::///////////////////////////////////////////////
//:: Reach to the Blaze
//:: nx_s2_reachblazec.nss
//:: Copyright (c) 2007 Obsidian Entertainment
//:://////////////////////////////////////////////
/*
	By drawing on the power of the sun, you cause your body to emanate fire.
	Fire extends 5 feet in all directions from your body, illuminating the 
	area and dealing 1d4 points of fire damage per two caster levels (maximum 5d4)
	to adjacent enemies every round.
*/
//:://////////////////////////////////////////////
//:: Created By: Andrew Woo (AFW-OEI)
//:: Created On: 01/11/2007
//:://////////////////////////////////////////////
//:: Repurposed from Body of the Sun
//:: RPGplayer1 03/19/2008:
//::  Damage reduced by Evasion or Improved Evasion
//::  Make damage roll for each target


#include "nw_i0_spells"
#include "x2_inc_spellhook" 
#include "nwn2_inc_metmag"

void main()
{
    if (!X2PreSpellCastCode())
    {   // If code within the PreSpellCastHook (i.e. UMD) reports FALSE, do not run this spell
        return;
    }
	
//Declare Major variables
	object	oTarget;
	object	oCreator		=	GetAreaOfEffectCreator();
	int		nCasterLevel	=	GetCasterLevel(oCreator);
	int		nDamValue;
	int		nMax			=  4 * 2;	// Max of 2d4
	effect	eFireDamage;
	effect	eFireHit		=	EffectVisualEffect(VFX_COM_HIT_FIRE);
		
//If the caster is dead, kill the AOE

	if (!GetIsObjectValid(oCreator))
	{
		DestroyObject(OBJECT_SELF);
	}
	
//Find our first target
	oTarget = GetFirstInPersistentObject(OBJECT_SELF, OBJECT_TYPE_CREATURE);
	
//This loop validates target, makes it save, burns it, then finds the next target and repeats

	while(GetIsObjectValid(oTarget))
	{
		if (spellsIsTarget(oTarget, SPELL_TARGET_STANDARDHOSTILE, oCreator) && (oTarget != oCreator) )
		{
			SignalEvent(oTarget, EventSpellCastAt(oCreator, SPELLABILITY_REACH_TO_THE_BLAZE));
			
			if (!MyResistSpell(oCreator, oTarget))
			{
				//Determine damage
				nDamValue		=	d4(2);	// Fixed to 2d4 damage.
				nDamValue		=	ApplyMetamagicVariableMods(nDamValue, nMax);

				// AFW-OEI 01/11/2007: GetSpellSaveDC() works strangely for spell-like abilities, so we're going
				//		to just use the innate spell level plus your WIS modifier.  Note that this method will
				//		not take penalties/bonuses like negative levels and Spell Focus into account.
				int nDC = 10 + GetSpellLevel(SPELLABILITY_REACH_TO_THE_BLAZE) + GetAbilityModifier(ABILITY_WISDOM, oCreator);

				//Adjust damage via Reflex Save or Evasion or Improved Evasion
				//if(MySavingThrow(SAVING_THROW_REFLEX, oTarget, nDC, SAVING_THROW_TYPE_FIRE))
				nDamValue = GetReflexAdjustedDamage(nDamValue, oTarget, nDC, SAVING_THROW_TYPE_FIRE);
				
				if (nDamValue > 0)
				{
				eFireDamage	=	EffectDamage(nDamValue, DAMAGE_TYPE_FIRE);
				ApplyEffectToObject(DURATION_TYPE_INSTANT, eFireDamage, oTarget);
				ApplyEffectToObject(DURATION_TYPE_INSTANT, eFireHit, oTarget);
				}
			}
		}
	
		oTarget = GetNextInPersistentObject(OBJECT_SELF, OBJECT_TYPE_CREATURE);
	}
}
	
	