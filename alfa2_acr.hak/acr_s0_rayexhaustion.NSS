//::///////////////////////////////////////////////
//:: Ray of Exhaustion

// Created by Riotnrrd for ALFA 2/2009

#include "NW_I0_SPELLS"
#include "x2_inc_spellhook"

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
	
	if (GetMetaMagicFeat() == METAMAGIC_EXTEND)
    {
        nDuration = nDuration * 2;
    }
	
	effect eDur = EffectVisualEffect(VFX_DUR_SPELL_RAY_ENFEEBLE);

    if (spellsIsTarget(oTarget, SPELL_TARGET_STANDARDHOSTILE, OBJECT_SELF))
    {
        //Fire cast spell at event for the specified target
        SignalEvent(oTarget, EventSpellCastAt(OBJECT_SELF, GetSpellId()));
 
		// Ray spells require a ranged touch attack
		if (TouchAttackRanged(oTarget) != TOUCH_ATTACK_RESULT_MISS) 
		{	//Make SR check
        	if (!MyResistSpell(OBJECT_SELF, oTarget))
        	{
				if(!MySavingThrow(SAVING_THROW_FORT, oTarget, GetSpellSaveDC(), SAVING_THROW_TYPE_NONE, OBJECT_SELF))
                {
					effect eExhausted = EffectAbilityDecrease(ABILITY_STRENGTH, 6);
					effect eLink = EffectLinkEffects(EffectAbilityDecrease(ABILITY_DEXTERITY, 6), eExhausted);
					eLink = EffectLinkEffects(EffectMovementSpeedDecrease(50), eLink);
					eLink = EffectLinkEffects(eDur, eLink);
					ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eLink, oTarget, TurnsToSeconds(nDuration));
				} else {
					effect eFatigued = EffectAbilityDecrease(ABILITY_STRENGTH, 2);
					effect eLink = EffectLinkEffects(EffectAbilityDecrease(ABILITY_DEXTERITY, 2), eFatigued);
					eLink = EffectLinkEffects(EffectMovementSpeedDecrease(50), eLink);
					eLink = EffectLinkEffects(eDur, eLink);
					ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eLink, oTarget, TurnsToSeconds(nDuration));
				}
			}
        }
	
 	    effect eRay = EffectBeam(VFX_BEAM_BLACK, OBJECT_SELF, BODY_NODE_HAND);
    	ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eRay, oTarget, 1.0);
    }
}