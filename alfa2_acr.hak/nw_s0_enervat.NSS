//::///////////////////////////////////////////////
//:: Enervation
//:: NW_S0_Enervat.nss
//:: Copyright (c) 2001 Bioware Corp.
//:://////////////////////////////////////////////
/*
    Target Loses 1d4 levels for 1 hour per caster
    level
*/
//:://////////////////////////////////////////////
//:: Created By: Preston Watamaniuk
//:: Created On: Jan 7, 2002
//:://////////////////////////////////////////////
//:: AFW-OEI 06/06/2006:
//::	Require a ranged touch attack to hit.
//::	Remove saving throw.
//::PKM-OEI: 05.28.07: Touch attacks now do critical hit damage
//::RPGplayer1: 12.23.08: Negative levels set as Supernatural (to prevent dispelling)

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
    effect eVis = EffectVisualEffect(VFX_HIT_SPELL_NECROMANCY);
    effect eBeam = EffectBeam( VFX_BEAM_NECROMANCY, OBJECT_SELF, BODY_NODE_HAND );
    object oTarget = GetSpellTargetObject();
    int nMetaMagic = GetMetaMagicFeat();
	int nTouch      = TouchAttackRanged(oTarget);
    int nDrain = d4();
    int nDuration = GetCasterLevel(OBJECT_SELF);

	//PKM-OEI: 05.28.07: Do critical hit damage
	if (nTouch == TOUCH_ATTACK_RESULT_CRITICAL && !GetIsImmune(oTarget, IMMUNITY_TYPE_CRITICAL_HIT))
	{
		nDrain = d4(2);
	}

    //Enter Metamagic conditions
    if ((nMetaMagic == METAMAGIC_MAXIMIZE) && (nTouch == 2) && !GetIsImmune(oTarget, IMMUNITY_TYPE_CRITICAL_HIT))
    {
    	nDrain = 8;//Damage is at max
    }
	else if (nMetaMagic == METAMAGIC_MAXIMIZE)
	{
		nDrain = 4;
	}
    else if (nMetaMagic == METAMAGIC_EMPOWER)
    {
    	nDrain = nDrain + (nDrain/2); //Damage/Healing is +50%
    }
    else if (nMetaMagic == METAMAGIC_EXTEND)
    {
    	nDuration = nDuration *2; //Duration is +100%
    }

    effect eDrain = EffectNegativeLevel(nDrain);
	eDrain = SupernaturalEffect(eDrain);

	if (spellsIsTarget(oTarget, SPELL_TARGET_STANDARDHOSTILE, OBJECT_SELF))
	{
        //Fire cast spell at event for the specified target
        SignalEvent(oTarget, EventSpellCastAt(OBJECT_SELF, SPELL_ENERVATION));
		if (nTouch != TOUCH_ATTACK_RESULT_MISS)
		{
	        //Resist magic check
	        if(!MyResistSpell(OBJECT_SELF, oTarget))
	        {
	            //if(!MySavingThrow(SAVING_THROW_FORT, oTarget, GetSpellSaveDC(), SAVING_THROW_TYPE_NEGATIVE))
	            {
	                //Apply the VFX impact and effects
	                ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eDrain, oTarget, HoursToSeconds(nDuration));
	                ApplyEffectToObject(DURATION_TYPE_INSTANT, eVis, oTarget);
	            }
	        }
		}
		ApplyEffectToObject( DURATION_TYPE_TEMPORARY, eBeam, oTarget, 1.7 );
    }
}