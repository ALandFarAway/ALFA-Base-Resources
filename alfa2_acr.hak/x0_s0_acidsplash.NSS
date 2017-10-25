//::///////////////////////////////////////////////
//:: Acid Splash
//:: [X0_S0_AcidSplash.nss]
//:: Copyright (c) 2002 Bioware Corp.
//:://////////////////////////////////////////////
/*
1d3 points of acid damage to one target.
*/
//:://////////////////////////////////////////////
//:: Created By: Brent
//:: Created On: July 17 2002
//:://////////////////////////////////////////////
//:: AFW-OEI 06/06/2006:
//::	Require ranged touch attack to hit.

#include "X0_I0_SPELLS"
#include "x2_inc_spellhook" 
#include "nwn2_inc_spells"

void main()
{

/* 
  Spellcast Hook Code 
  Added 2003-06-20 by Georg
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
    object oTarget = GetSpellTargetObject();
    int nCasterLevel = GetCasterLevel(OBJECT_SELF);
	int nTouch      = TouchAttackRanged(oTarget);

    effect eVis = EffectVisualEffect(VFX_HIT_SPELL_ACID);
    effect eRay = EffectBeam(VFX_BEAM_ACID, OBJECT_SELF, BODY_NODE_HAND);

	if (spellsIsTarget(oTarget, SPELL_TARGET_STANDARDHOSTILE, OBJECT_SELF))
	{
        //Fire cast spell at event for the specified target
        SignalEvent(oTarget, EventSpellCastAt(OBJECT_SELF, 424));
		if (nTouch != TOUCH_ATTACK_RESULT_MISS)
		{ 
	        //Make SR Check
	        if(!MyResistSpell(OBJECT_SELF, oTarget))
	        {
	            //Set damage effect
	            int nDamage =  d3(1);
				nDamage = ApplyMetamagicVariableMods(nDamage, 3);
				if (nTouch == TOUCH_ATTACK_RESULT_CRITICAL && !GetIsImmune(oTarget, IMMUNITY_TYPE_CRITICAL_HIT))
				{
					nDamage = d3(2);
					nDamage = ApplyMetamagicVariableMods(nDamage, 6);
				}
				
	            effect eBad = EffectDamage(nDamage, DAMAGE_TYPE_ACID);
	            //Apply the VFX impact and damage effect
	            ApplyEffectToObject(DURATION_TYPE_INSTANT, eVis, oTarget);
	            ApplyEffectToObject(DURATION_TYPE_INSTANT, eBad, oTarget);
	        }
		}
    }
    ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eRay, oTarget, 1.7);
}