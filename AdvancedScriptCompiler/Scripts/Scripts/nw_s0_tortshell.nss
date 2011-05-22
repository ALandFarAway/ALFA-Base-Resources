//::///////////////////////////////////////////////
//:: Tortoise Shell
//:: nw_s0_tortshell.nss
//:: Copyright (c) 2006 Obsidian Entertainment
//:://////////////////////////////////////////////
/*
	Tortoise Shell grants a +6 enhancement bonus to the subject's
	existing natural armor bonus.  This enhancement bonus increases
	by 1 for every three caster levels beyond 11th, to a maximum
	of +9 at 20th level.  Tortoise Shell slows a creature's 
	movement to half its normal rate for the duration.
*/
//:://////////////////////////////////////////////
//:: Created By: Patrick Mills
//:: Created On: Oct 12, 2006
//:://////////////////////////////////////////////
// MDiekmann 7/27/07 - Added signal event.
#include "nw_i0_spells"
#include "x2_inc_spellhook" 
#include "x2_i0_spells"


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

	object	oTarget		=	GetSpellTargetObject();
	object	oCaster		=	OBJECT_SELF;
	effect	eAC;
	effect	eDur		=	EffectVisualEffect(VFX_SPELL_DUR_TORT_SHELL); 
	effect 	eSpeed		=	EffectMovementSpeedDecrease(50);
	int 	nMeta		=	GetMetaMagicFeat();
	int		nCLevel		=	GetCasterLevel(oCaster);
	
	//	Caster level is capped at 20.
	if (nCLevel > 20)
	{
		nCLevel = 20;
	}
	
	int		nAC			=	6 + ((nCLevel - 11)/3);
		
	float	fDuration	=	TurnsToSeconds(10*(GetCasterLevel(oCaster)));
	
//Prevent this spell from stacking, the AC won't stack anyway, but the slowing will
	if (GetHasSpellEffect(1005, oTarget))
	{
		RemoveSpellEffects( 1005, oCaster, oTarget);
	}
	
//Determine AC bonus
//			nAC			=	ApplyMetamagicVariableMods(nAC, 9);
	
//Declare AC bonus
			eAC			=	EffectACIncrease(nAC, AC_NATURAL_BONUS);
			
//Determine duration
	fDuration = ApplyMetamagicDurationMods(fDuration);

//Link effects
	effect	eLink	=	EffectLinkEffects(eAC, eDur);
	eLink			=	EffectLinkEffects(eLink, eSpeed);
	
//Apply effects
	if (GetIsObjectValid(oTarget))
	{
		if (spellsIsTarget(oTarget, SPELL_TARGET_ALLALLIES, oCaster))
		{
			//Fire cast spell at event for the specified target
            SignalEvent(oTarget, EventSpellCastAt(OBJECT_SELF, GetSpellId(), FALSE));
			
			ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eLink, oTarget, fDuration);
		}
	}
}