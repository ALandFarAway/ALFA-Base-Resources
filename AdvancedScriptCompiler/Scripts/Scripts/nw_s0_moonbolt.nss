//::///////////////////////////////////////////////
//:: Moon Bolt
//:: nw_s0_moonbolt.nss
//:: Copyright (c) 2006 Obsidian Entertainment
//:://////////////////////////////////////////////
/*
	A moon bolt strikes unerringl against any living or undead creature in range.
	
	A living creature struck by a moon bolt takes 1d4 points of Strength damage per 
	three caster levels (max 5d4).  If the subject makes a sucessful Fort save
	the strength damage is halved.
	
	An undead creature struck by a moon bolt must make a will save or fall helpless
	for 1d4 rounds, after which time it is no longer helpless and can stand upright,
	but it takes a -2 penalty on sttack rolls and will saving throws for the next minute.
*/
//:://////////////////////////////////////////////
//:: Created By: Patrick Mills
//:: Created On: Oct 19, 2006
//:://////////////////////////////////////////////
//:: RPGplayer1 02/10/2009: Added missing SignalEvent (will force caster to drop invisibility)

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

//Declare major variables
	object	oTarget		=	GetSpellTargetObject();
	object	oCaster		=	OBJECT_SELF;
	int		nCasterLev	=	GetCasterLevel(oCaster);
	int		nDex		=	GetAbilityScore(oTarget, ABILITY_DEXTERITY);
	int		nDam;
	int		nKODur;
	effect	eBeam		=	EffectBeam(VFX_SPELL_BEAM_MOON_BOLT, oCaster, BODY_NODE_HAND);
	effect	eStrDam;
	effect	eKnockdown	=	EffectKnockdown();
	effect	eHelpless	=	EffectAbilityDecrease(ABILITY_DEXTERITY, nDex);
	effect	eVis		=	EffectVisualEffect(VFX_HIT_SPELL_HOLY);
	effect	eWillDec	=	EffectSavingThrowDecrease(SAVING_THROW_WILL, 2);
	effect	eAttackDec	=	EffectAttackDecrease(2);
	float	fDuration;

	
//Determine base damage and cap
	if (nCasterLev > 15)
	{
		nCasterLev = 15;
	}
			nDam		=	d4(nCasterLev/3);
	nDam = ApplyMetamagicVariableMods(nDam, 4*(nCasterLev/3));

		
//Determine duration of knockdown

			nKODur		=	d4();
	nKODur = ApplyMetamagicVariableMods(nKODur, 4);
			fDuration	=	RoundsToSeconds(nKODur);
	fDuration = ApplyMetamagicDurationMods(fDuration);

	float fDuration2 = 60.0;
	fDuration2 = ApplyMetamagicDurationMods(fDuration2);
	
//Link undead effects
	effect	eUndeadLink	=	EffectLinkEffects(eKnockdown, eVis);
			eUndeadLink	=	EffectLinkEffects(eUndeadLink, eHelpless);

			
//Link undead curse effects
	effect	eCurseLink	=	EffectLinkEffects(eWillDec, eAttackDec);

//Validate target, determine race (living, undead, unliving), then do effects

	if (GetIsObjectValid(oTarget))
	{
		if (spellsIsTarget(oTarget, SPELL_TARGET_STANDARDHOSTILE, oCaster))
		{
			SignalEvent(oTarget, EventSpellCastAt(OBJECT_SELF, GetSpellId()));
			ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eBeam, oTarget, 1.0);
			
			if (GetRacialType(oTarget) == RACIAL_TYPE_CONSTRUCT)
			{
				//string to indicate immunity
				return;
			}
			else if (GetRacialType(oTarget) == RACIAL_TYPE_UNDEAD)
			{
				if (!MySavingThrow(SAVING_THROW_WILL, oTarget, GetSpellSaveDC(), SAVING_THROW_TYPE_NONE, oCaster))
				{
					ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eUndeadLink, oTarget, fDuration);
					DelayCommand(fDuration, ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eCurseLink, oTarget, fDuration2));
				}
			}
			else
			{
				if(MySavingThrow(SAVING_THROW_FORT, oTarget, GetSpellSaveDC(), SAVING_THROW_TYPE_NONE, oCaster))
				{
					nDam	=	nDam/2;
				}
				eStrDam				=	EffectAbilityDecrease(ABILITY_STRENGTH, nDam);
				effect	eLivingLink	=	EffectLinkEffects(eStrDam, eVis);
				ApplyEffectToObject(DURATION_TYPE_PERMANENT, eLivingLink, oTarget);
			}
		}
	}
}