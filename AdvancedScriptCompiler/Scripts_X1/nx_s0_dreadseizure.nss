//::///////////////////////////////////////////////
//:: Dread Seizure
//:: nx_s0_dreadseizure.nss
//:: Copyright (c) 2007 Obsidian Entertainment
//:://////////////////////////////////////////////
/*
 	Dread Seizure
	Lesser, 4th
	
	You speak a word that sends wracking pain through
	the limbs of a single target creature within
	60ft.  Though these seizures are not powerful
	enough to immobilize the creature, they do
	reduce its movement speed by 30%.  The target
	also takes a -3 penalty to all attacks it makes.
	These effects last for 3 rounds; a successful 
	Fortitude save negates the effects.
*/
//:://////////////////////////////////////////////
//:: Created By: Ryan Young
//:: Created On: 1.22.2007
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

//Declare major variables
	object		oCaster			=	OBJECT_SELF;
	object		oTarget			=	GetSpellTargetObject();
	effect		eAttackPenalty 	=	EffectAttackDecrease(3);
	effect		eMovePenalty	=	EffectMovementSpeedDecrease(30);
	effect		eLink			=	EffectLinkEffects(eAttackPenalty, eMovePenalty);
	float		fDuration		=	RoundsToSeconds(3);
	
//metamagic
	fDuration	=	ApplyMetamagicDurationMods(fDuration);
	
//Target discrimination, then apply effects

	if (GetIsObjectValid(oTarget))
	{
		if (spellsIsTarget(oTarget, SPELL_TARGET_STANDARDHOSTILE, oCaster))
		{	
			if (!MySavingThrow(SAVING_THROW_FORT, oTarget, GetSpellSaveDC()))
			{
				SignalEvent(oTarget, EventSpellCastAt(OBJECT_SELF, GetSpellId()));
				ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eLink, oTarget, fDuration);
			}
		}
	}
}
	
	
	
	