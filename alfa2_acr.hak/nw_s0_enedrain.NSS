//::///////////////////////////////////////////////
//:: Energy Drain
//:: NW_S0_EneDrain.nss
//:: Copyright (c) 2001 Bioware Corp.
//:://////////////////////////////////////////////
/*
    Target loses 2d4 levels.
*/
//:://////////////////////////////////////////////
//:: Created By: Preston Watamaniuk
//:: Created On: Jan 7, 2002
//:://////////////////////////////////////////////
//:: PKM-OEI 08.03.06 - VFX revision
//:: AFW-OEI 04/05/2007: No longer get Fort save.
#include "x0_I0_SPELLS"

#include "x2_inc_spellhook" 

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
	effect eVis = EffectVisualEffect( VFX_DUR_SPELL_ENERGY_DRAIN );
	effect eBeam = EffectBeam( VFX_BEAM_NECROMANCY, OBJECT_SELF, BODY_NODE_HAND );
    object oTarget = GetSpellTargetObject();
    int nMetaMagic = GetMetaMagicFeat();
	int nTouch      = TouchAttackRanged(oTarget);
    int nDrain = d4(2);

	//Do critical hit damage
	if (nTouch == TOUCH_ATTACK_RESULT_CRITICAL && !GetIsImmune(oTarget, IMMUNITY_TYPE_CRITICAL_HIT))
	{
		nDrain = d4(4);
	}

    //Enter Metamagic conditions
    if ((nMetaMagic == METAMAGIC_MAXIMIZE) && (nTouch == 2) && !GetIsImmune(oTarget, IMMUNITY_TYPE_CRITICAL_HIT))
    {
    	nDrain = 16;//Damage is at max
    }
	else if (nMetaMagic == METAMAGIC_MAXIMIZE)
	{
		nDrain = 8;
	}
    else if (nMetaMagic == METAMAGIC_EMPOWER)
    {
    	nDrain = nDrain + (nDrain/2); //Damage/Healing is +50%
    }
    effect eDrain = EffectNegativeLevel(nDrain);
	eDrain = SupernaturalEffect(eDrain);
	//eDrain = EffectLinkEffects( eDrain, eVis );
	//eDrain = EffectLinkEffects( eDrain, eBeam );
    
	if (spellsIsTarget(oTarget, SPELL_TARGET_STANDARDHOSTILE, OBJECT_SELF))
	{
        //Fire cast spell at event for the specified target
        SignalEvent(oTarget, EventSpellCastAt(OBJECT_SELF, SPELL_ENERGY_DRAIN));
        if (nTouch != TOUCH_ATTACK_RESULT_MISS)
        {
        if(!MyResistSpell(OBJECT_SELF, oTarget))
        {
            //if(!MySavingThrow(SAVING_THROW_FORT, oTarget, GetSpellSaveDC(), SAVING_THROW_TYPE_NEGATIVE))
            {
                ApplyEffectToObject( DURATION_TYPE_PERMANENT, eDrain, oTarget );
                ApplyEffectToObject( DURATION_TYPE_INSTANT, eVis, oTarget );
				//ApplyEffectToObject( DURATION_TYPE_TEMPORARY, eBeam, oTarget, 1.7 );
            }
        }
        }
        ApplyEffectToObject( DURATION_TYPE_TEMPORARY, eBeam, oTarget, 1.7 );
    }
}