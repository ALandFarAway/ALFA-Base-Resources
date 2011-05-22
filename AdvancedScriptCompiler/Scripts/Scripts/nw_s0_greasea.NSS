//::///////////////////////////////////////////////
//:: Grease: On Enter
//:: NW_S0_GreaseA.nss
//:: Copyright (c) 2001 Bioware Corp.
//:://////////////////////////////////////////////
/*
    Creatures entering the zone of grease must make
    a reflex save or fall down.  Those that make
    their save have their movement reduced by 1/2.
*/
//:://////////////////////////////////////////////
//:: Created By: Preston Watamaniuk
//:: Created On: Aug 1, 2001
//:://////////////////////////////////////////////

#include "X0_I0_SPELLS"
#include "x2_inc_spellhook"

void main()
{



    //Declare major variables
    int nMetaMagic = GetMetaMagicFeat();
    effect eVis = EffectVisualEffect(VFX_IMP_SLOW);
    effect eSlow = EffectMovementSpeedDecrease(50);
    effect eLink = EffectLinkEffects(eVis, eSlow);
	effect eHit = EffectVisualEffect(VFX_HIT_SPELL_ENCHANTMENT);
    object oTarget = GetEnteringObject();
    float fDelay = GetRandomDelay(1.0, 2.2);
    if(spellsIsTarget(oTarget, SPELL_TARGET_STANDARDHOSTILE, GetAreaOfEffectCreator()))
    {
        // if(!GetHasFeat(FEAT_WOODLAND_STRIDE, oTarget) &&(GetCreatureFlag(OBJECT_SELF, CREATURE_VAR_IS_INCORPOREAL) != TRUE) )
        if( (GetCreatureFlag(OBJECT_SELF, CREATURE_VAR_IS_INCORPOREAL) != TRUE) )	// AFW-OEI 05/01/2006: Woodland Stride no longer protects from spells.
		{
            //Fire cast spell at event for the target
            SignalEvent(oTarget, EventSpellCastAt(GetAreaOfEffectCreator(), SPELL_GREASE));
               //Spell resistance check
            //if(!MyResistSpell(GetAreaOfEffectCreator(), oTarget))
            //{
				//if(!MySavingThrow(SAVING_THROW_REFLEX, oTarget, GetSpellSaveDC(), SAVING_THROW_TYPE_NONE, OBJECT_SELF))
				{
                	//Apply reduced movement effect and VFX_Impact
                	ApplyEffectToObject(DURATION_TYPE_PERMANENT, eLink, oTarget);
                	ApplyEffectToObject(DURATION_TYPE_INSTANT, eHit, oTarget);
				}
            //}
        }
    }
}