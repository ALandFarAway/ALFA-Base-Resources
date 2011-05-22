//::///////////////////////////////////////////////
//:: Touch of Fatigue
//:: NX_s0_tfatigue.nss
//:: Copyright (c) 2007 Obsidian Entertainment
//:://////////////////////////////////////////////
/* 	
 	Components: V, S
	Duration: 1 round/level
	Saving Throw: Fortitude negates
	Spell Resistance: Yes
	 
	Touch attack gives target Fatigued status 
	effect. If the target is already fatigued, 
	nothing happens.
*/
//:://////////////////////////////////////////////
//:: Created By: Patrick Mills
//:: Created On: 12.13.06
//:://////////////////////////////////////////////
// ChazM 1/8/07 Modified includes
// MDiekmann 5/21/07 Changed so that spell only lasts one round per caster level
// AFW-OEI 07/14/2007: NX1 VFX

//#include "nw_i0_spells" 
//#include "X0_I0_SPELLS"
#include "x2_inc_spellhook"
#include "ginc_nx1spells"




void main()
{

/* 
  Spellcast Hook Code 
  Added 2003-06-23 by GeorgZ
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
	object	oTarget			=	GetSpellTargetObject();
	object	oCaster			=	OBJECT_SELF;
	effect	eVis			=	EffectVisualEffect(VFX_HIT_SPELL_TOUCH_OF_FATIGUE);
	//effect	eFatigue	=	EffectFatigue();
	//effect	eLink		=	EffectLinkEffects(eVis, eFatigue);
	int 	nFatigueRds 	=   GetCasterLevel(oCaster);
	
	
	
//discriminate targets

    if (GetIsObjectValid(oTarget))
    {
        if (spellsIsTarget(oTarget, SPELL_TARGET_STANDARDHOSTILE, OBJECT_SELF))
        {
			if (TouchAttackMelee(oTarget))
			{
				SignalEvent(oTarget, EventSpellCastAt(OBJECT_SELF, GetSpellId(), TRUE));
				//spell resistance
				if	(!ResistSpell(oCaster, oTarget))
				{
					//saving throw
					if (!MySavingThrow(SAVING_THROW_FORT, oTarget, GetSpellSaveDC(), SAVING_THROW_TYPE_SPELL, oCaster))
					{
						ApplyEffectToObject(DURATION_TYPE_INSTANT, eVis, oTarget);
						ApplyFatigue(oTarget, nFatigueRds);
					}
				}
			}
		}
	}
}
						