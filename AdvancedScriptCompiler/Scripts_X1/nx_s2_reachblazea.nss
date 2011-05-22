//::///////////////////////////////////////////////
//:: Reach to the Blaze
//:: nx_s2_reachblazea.nss
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
//:: RPGplayer1 03/19/2008: Damage removed to prevent exploit


#include "nw_i0_spells"
#include "x2_inc_spellhook" 
#include "nwn2_inc_metmag"

void main()
{
    if (!X2PreSpellCastCode())
    {   // If code within the PreSpellCastHook (i.e. UMD) reports FALSE, do not run this spell
        return;
    }

//Declare major variables
	object 	oTarget			=	GetEnteringObject();
	object	oCaster			=	GetAreaOfEffectCreator();
	int		nDamValue;
	int		nMax			=   4 * 2;	// Max of 2d4
	effect	eFireDamage;
	effect	eFireHit		=	EffectVisualEffect(VFX_COM_HIT_FIRE);
	
//Determine damage
			nDamValue		=	d4(2);	// Fixed to 2d4 damage.
			nDamValue		=	ApplyMetamagicVariableMods(nDamValue, nMax);
	
//Validate entering object, force it to save, and then burn it
	/*if (GetIsObjectValid(oTarget))
	{
		if ( spellsIsTarget(oTarget, SPELL_TARGET_STANDARDHOSTILE, oCaster) && (oTarget != oCaster ) )
		{
			SignalEvent(oTarget, EventSpellCastAt(oCaster, SPELLABILITY_REACH_TO_THE_BLAZE));
			
			if (!MyResistSpell(oCaster, oTarget))
			{
				// AFW-OEI 01/11/2007: GetSpellSaveDC() works strangely for spell-like abilities, so we're going
				//		to just use the innate spell level plus your WIS modifier.  Note that this method will
				//		not take penalties/bonuses like negative levels and Spell Focus into account.
				int nDC = 10 + GetSpellLevel(SPELLABILITY_REACH_TO_THE_BLAZE) + GetAbilityModifier(ABILITY_WISDOM, oCaster);
				if(MySavingThrow(SAVING_THROW_REFLEX, oTarget, nDC, SAVING_THROW_TYPE_FIRE))
				{
					nDamValue = nDamValue/2;
				}
				
				eFireDamage	=	EffectDamage(nDamValue, DAMAGE_TYPE_FIRE);
				ApplyEffectToObject(DURATION_TYPE_INSTANT, eFireDamage, oTarget);
				ApplyEffectToObject(DURATION_TYPE_INSTANT, eFireHit, oTarget);
			}
		}
	}*/
}
	
			

	
	
	