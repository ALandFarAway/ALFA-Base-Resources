//::///////////////////////////////////////////////
//:: Nature's Avatar
//:: nw_s0_natavatar.nss
//:: Copyright (c) 2006 Obsidian Entertainment
//:://////////////////////////////////////////////
/*
	With a touch, you gift your animal ally with nature's strength, resilience
	and speed.  
	
	The affected animal gains a +10 bonus on attack and damage rolls, and 1d8
	temporary hit points per caster level, plus the effect of the haste spell.
*/
//:://////////////////////////////////////////////
//:: Created By: Patrick Mills
//:: Created On: Oct 17, 2006
//:://////////////////////////////////////////////


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
	effect 	eHaste 		= 	EffectHaste();
	effect 	eVis 		= 	EffectVisualEffect(VFX_SPELL_DUR_NATURE_AVATAR); 
	effect 	eAttack 	=	EffectAttackIncrease(10);
	effect	eDamage		=	EffectDamageIncrease(DAMAGE_BONUS_10, DAMAGE_TYPE_SLASHING);
	effect	eBonusHP;
	effect 	eLink;
	int		nHP			=	d8() * GetCasterLevel(oCaster);
	float	fDuration	=	RoundsToSeconds(GetCasterLevel(oCaster));

//None of the following meta-magic behaviors can be used in base NWN2, the checks only exist to support epic levels
//should they be added later.
//Determine duration
	ApplyMetamagicDurationMods(fDuration);
	

//Determine HP Bonus
			nHP			=	ApplyMetamagicVariableMods(nHP, 160);
			eBonusHP	=	EffectTemporaryHitpoints(nHP);
	
//Link up effects
			eLink	=	EffectLinkEffects(eHaste,eAttack);
			eLink	=	EffectLinkEffects(eLink,eVis);
			eLink	=	EffectLinkEffects(eLink,eDamage);
			//eLink	=	EffectLinkEffects(eLink,eBonusHP);

			effect eOnDispell = EffectOnDispel(0.0f, RemoveEffectsFromSpell(oTarget, SPELL_NATURE_AVATAR));
			eLink = EffectLinkEffects(eLink, eOnDispell);
			eBonusHP = EffectLinkEffects(eBonusHP, eOnDispell);

//Validate target and apply effects
	if (GetIsObjectValid(oTarget))
	{
		if (spellsIsTarget(oTarget, SPELL_TARGET_ALLALLIES, oCaster))
		{
			if ((GetRacialType(oTarget) == RACIAL_TYPE_ANIMAL
				|| GetRacialType(oTarget) == RACIAL_TYPE_BEAST
				|| GetRacialType(oTarget) == RACIAL_TYPE_VERMIN)
				//&& !GetHasEffect(EFFECT_TYPE_WILDSHAPE, oTarget))
				&& !GetHasEffect(EFFECT_TYPE_POLYMORPH, oTarget))
			{
				RemoveEffectsFromSpell(oTarget, GetSpellId());
				ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eBonusHP, oTarget, fDuration);
				ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eLink, oTarget, fDuration);
			}
			else
			{
				FloatingTextStrRefOnCreature(184683, oCaster, FALSE);
				return;
			}
		}
	}
}
				
		