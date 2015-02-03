//::///////////////////////////////////////////////
//:: Ray of EnFeeblement
//:: [NW_S0_rayEnfeeb.nss]
//:: Copyright (c) 2000 Bioware Corp.
//:://////////////////////////////////////////////
//:: Target must make a Fort save or take ability
//:: damage to Strength equaling 1d6 +1 per 2 levels,
//:: to a maximum of +5.  Duration of 1 round per
//:: caster level.
//:://////////////////////////////////////////////
//:: Created By: Preston Watamaniuk
//:: Created On: Feb 2, 2001
//:://////////////////////////////////////////////

// (Updated JLR - OEI 07/05/05 NWN2 3.5)
//:: AFW-OEI 06/06/2006:
//::	Ray spells require a ranged touch attack.

// Modified by Riotnrrd for ALFA 1/7/2009
// Changed duration to 1 min / level per 3.5 canon

#include "NW_I0_SPELLS"
#include "x2_inc_spellhook"
#include "acr_spells_i"

void main()
{

/*
  Spellcast Hook Code
  Added 2003-06-23 by GeorgZ
  If you want to make changes to all spells,
  check x2_inc_spellhook.nss to find out more

*/

    if (!ACR_PrecastEvent())
    {
    // If code within the PreSpellCastHook (i.e. UMD) reports FALSE, do not run this spell
        return;
    }

// End of Spell Cast Hook


    //Declare major variables
    object oTarget = GetSpellTargetObject();
    int nDuration = GetCasterLevel(OBJECT_SELF);
    int nBonus = nDuration / 2;
	
    //Limit bonus ability damage
    if (nBonus > 5)
    {
        nBonus = 5;
    }
    int nRoll = d6();
    int nLoss = nRoll + nBonus;

    if (spellsIsTarget(oTarget, SPELL_TARGET_STANDARDHOSTILE, OBJECT_SELF))
    {
        //Fire cast spell at event for the specified target
        SignalEvent(oTarget, EventSpellCastAt(OBJECT_SELF, SPELL_RAY_OF_ENFEEBLEMENT));
 
		// Ray spells require a ranged touch attack
		if (TouchAttackRanged(oTarget) != TOUCH_ATTACK_RESULT_MISS) 
		{	//Make SR check
        	if (!MyResistSpell(OBJECT_SELF, oTarget))
        	{	//Enter Metamagic conditions
			
				//If target already has the Ray Of Enfeeblement effect on him, remove it
				//before casting again.  This prevents the spells from stacking. (Ryan Young - Jan. 12, 2007)
		    	RemoveEffectsFromSpell(oTarget, SPELL_RAY_OF_ENFEEBLEMENT);
		
    			int nMetaMagic = GetMetaMagicFeat();
                if (nMetaMagic == METAMAGIC_MAXIMIZE)
                {
                    nLoss = 6 + nBonus;
                }
                if (nMetaMagic == METAMAGIC_EMPOWER)
                {
                     nLoss = nRoll + (nRoll/2) + nBonus;
                }
                if (nMetaMagic == METAMAGIC_EXTEND)
                {
                    nDuration = nDuration * 2;
                }
                //Set ability damage effect
                effect eFeeb = EffectAbilityDecrease(ABILITY_STRENGTH, nLoss);
  			    effect eDur = EffectVisualEffect( VFX_DUR_SPELL_RAY_ENFEEBLE );
                effect eLink = EffectLinkEffects(eFeeb, eDur);
    			//effect eVis = EffectVisualEffect(VFX_HIT_SPELL_NECROMANCY);

                //Apply the ability damage effect and VFX impact
                ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eLink, oTarget, TurnsToSeconds(nDuration));
                //ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eVis, oTarget);
			}
        }
	
 	    effect eRay = EffectBeam(VFX_BEAM_NECROMANCY, OBJECT_SELF, BODY_NODE_HAND);
    	ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eRay, oTarget, 1.0);
    }
}