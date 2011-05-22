//::///////////////////////////////////////////////
//:: Body of the Sun
//:: nw_s0_bodysun.nss
//:: Copyright (c) 2006 Obsidian Entertainment
//:://////////////////////////////////////////////
/*
	By drawing on the power of the sun, you cause your body to emanate fire.
	Fire extends 5 feet in all directions from your body, illuminating the 
	area and dealing 1d4 points of fire damage per two caster levels (maximum 5d4)
	to adjacent enemies every round.
*/
//:://////////////////////////////////////////////
//:: Created By: Patrick Mills
//:: Created On: Oct 18, 2006
//:://////////////////////////////////////////////
//:: AFW-OEI 07/06/2007: Do random damage to each target.


#include "nw_i0_spells"
#include "x2_inc_spellhook" 
#include "nwn2_inc_metmag"

void main()
{
    /*
      Spellcast Hook Code
      Added 2003-07-07 by Georg Zoeller
      If you want to make changes to all spells,
      check x2_inc_spellhook.nss to find out more

    */

    if (!X2PreSpellCastCode())
    {
    // If code within the PreSpellCastHook (i.e. UMD) reports FALSE, do not run this spell
        return;
    }

// End of Spell Cast Hook

//Declare Major variables

	object	oTarget;
	object	oCreator		=	GetAreaOfEffectCreator();
	int		nCasterLevel	=	GetCasterLevel(oCreator);
	int		nDamValue;
	int		nMax;
	effect	eFireDamage;
	effect	eFireHit		=	EffectVisualEffect(VFX_COM_HIT_FIRE);

//Cap caster level at 10, then determine max damage for metamagics
	if (nCasterLevel > 10)
	{
		nCasterLevel = 10;
	}
	nMax = 4*(nCasterLevel/2);
		
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
			SignalEvent(oTarget, EventSpellCastAt(oCreator, SPELL_BODY_OF_THE_SUN));
			
			if (!MyResistSpell(oCreator, oTarget))
			{
				//Determine damage
				nDamValue		=	d4(nCasterLevel/2);
				nDamValue		=	ApplyMetamagicVariableMods(nDamValue, nMax);

				//Adjust damage via Reflex Save or Evasion or Improved Evasion
				nDamValue = GetReflexAdjustedDamage(nDamValue, oTarget, GetSpellSaveDC(), SAVING_THROW_TYPE_FIRE, oCreator);
				
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
	
	