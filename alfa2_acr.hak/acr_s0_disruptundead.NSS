//::///////////////////////////////////////////////
//:: Disrupt Undead
//:://////////////////////////////////////////////
/*
    If the caster succeeds at a ranged touch attack
    the target unded takes 1d6 damage
*/
//:://////////////////////////////////////////////
//:: Created By: Riotnrrd
//:: Created On: 2008/12/26

#include "X0_I0_SPELLS"    
#include "x2_inc_spellhook"
#include "acr_spells_i" 
#include "nwn2_inc_spells"

void main()
{


    if (!ACR_PrecastEvent())
    {
        return;
    }

    //Declare major variables
    object oTarget = GetSpellTargetObject();
	int nTouch      = TouchAttackRanged(oTarget);

    if (spellsIsTarget(oTarget, SPELL_TARGET_STANDARDHOSTILE, OBJECT_SELF))
    {
 
		// NOTE NEED TO ADD NEW SPELL ID FOR DISRUPT UNDEAD
        SignalEvent(oTarget, EventSpellCastAt(OBJECT_SELF, GetSpellId()));

		if (nTouch != TOUCH_ATTACK_RESULT_MISS)
		{	//Make SR Check
	        if(!MyResistSpell(OBJECT_SELF, oTarget))
	        {
				if (GetRacialType(oTarget)==RACIAL_TYPE_UNDEAD)
				{
		 			int nDam = d6();
					ApplyMetamagicVariableMods(nDam, 6);	    		
					if (nTouch == TOUCH_ATTACK_RESULT_CRITICAL && !GetIsImmune(oTarget, IMMUNITY_TYPE_CRITICAL_HIT))
					{
						nDam = d6(2);
						ApplyMetamagicVariableMods(nDam, 12);
					}
				
	    	        //Set damage effect
					effect eDam = EffectDamage(nDam, DAMAGE_TYPE_POSITIVE);
	   		 		effect eVis = EffectVisualEffect(VFX_HIT_SPELL_SEARING_LIGHT);
	
	    	        //Apply the VFX impact and damage effect
	     	       ApplyEffectToObject(DURATION_TYPE_INSTANT, eVis, oTarget);
				   ApplyEffectToObject(DURATION_TYPE_INSTANT, eDam, oTarget);
	    	    }
			}
		}
    }
	
    effect eRay = EffectBeam(VFX_BEAM_HOLY, OBJECT_SELF, BODY_NODE_HAND);
    ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eRay, oTarget, 1.7);
}