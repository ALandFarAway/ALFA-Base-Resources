//::///////////////////////////////////////////////
//:: Avasculate
//:: nw_s0_avasculate.nss
//:: Copyright (c) 2007 Obsidian Entertainment
//:://////////////////////////////////////////////
/*
	Avasculate
	Necromancy [Death, Evil]
	Level: sorceror/wizard 7
	Components: V,S
	Range: Close
	Duration: Instantaneous
	Saving Throw: Fortitude partial
	Spell Resistance: Yes
	 
	You must succeed on a ranged touch attack with 
	the ray to strike a target.  If the attack succeeds, 
	the subject is reduced to half of its current hit 
	points and stunned for 1 round.  On a successful 
	Fortitude saving throw, the subject is not stunned.
*/
//:://////////////////////////////////////////////
//:: Created By: Patrick Mills
//:: Created On: 12.06.2006
//:://////////////////////////////////////////////
//:: AFW-OEI 07/10/2007: NX1 VFX
//:: RPGplayer1 02/04/2009: Made SpellCastAt event hostile, so that caster drops invisibility properly
//:: RPGplayer1 02/05/2009: Signal SpellCastAt event regardless of TouchAttack success

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

//Major variables
	object 	oTarget 	= 	GetSpellTargetObject();
	object 	oCaster 	= 	OBJECT_SELF;
	int		nDam;
	effect	eStun		=	EffectStunned();
	effect	eDam;
	effect 	eVis		=	EffectVisualEffect(VFX_HIT_SPELL_AVASCULATE);
	effect	eVisStun	=	EffectVisualEffect(VFX_DUR_STUN);
	effect	eLink;
	effect	eLinkStun;	
	float	fDur		=	RoundsToSeconds(1);

//Determine damage
			nDam		=	GetCurrentHitPoints(oTarget)/2;
			eDam		=	EffectDamage(nDam, DAMAGE_TYPE_MAGICAL, DAMAGE_POWER_NORMAL, TRUE);	// AFW-OEI 07/10/2007: Ignore all resistances.
			
	
//Link up effects
			eLink		=	EffectLinkEffects(eDam, eVis);
			eLinkStun	=	EffectLinkEffects(eStun, eVisStun);
			
//Determine duration of the stun effect
			fDur		=	ApplyMetamagicDurationMods(fDur);

//Validate target and apply effects
//Target Discrimination

	if (GetIsObjectValid(oTarget))
	{
		if (spellsIsTarget(oTarget, SPELL_TARGET_STANDARDHOSTILE, oCaster))
		{	
			//Target is valid, cast spell and then run spell resistance and saving throw before applying effect
			SignalEvent(oTarget, EventSpellCastAt(OBJECT_SELF, 1032, TRUE));
			
			//Performed ranged touch attack
			if (TouchAttackRanged(oTarget, TRUE))
			{
				
				if (!MyResistSpell(oCaster, oTarget))
				{
					//This is a death spell, determine immunity and drop the target if they are immune
					if (GetIsImmune(oTarget,IMMUNITY_TYPE_DEATH, oCaster))
					{
						//print an immunity string
						return;
					}
					if (MySavingThrow(SAVING_THROW_FORT, oTarget, GetSpellSaveDC(), SAVING_THROW_TYPE_DEATH, oCaster))
					{
						ApplyEffectToObject(DURATION_TYPE_INSTANT, eDam, oTarget);
					}
					else
					{
						ApplyEffectToObject(DURATION_TYPE_INSTANT, eDam, oTarget);
						ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eLinkStun, oTarget, fDur);
					}
				}
			}
			ApplyEffectToObject(DURATION_TYPE_INSTANT, eVis, oTarget);
		}
	}
}
					