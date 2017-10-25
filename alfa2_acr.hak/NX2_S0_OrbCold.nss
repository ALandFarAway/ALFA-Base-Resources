//::///////////////////////////////////////////////
//:: Orb of Cold.
//:: NX2_S0_OrbCold.nss
//:://////////////////////////////////////////////
/*
    An orb of acid about 3 inches across
	shoots from your palm at its target,
	dealing 1d6 points of acid damage
	per caster level (maximum 15d6). You
	must succeed on a ranged touch attack
	to hit your target.
	A creature struck by the orb takes
	damage and becomes sickened by the
	acid�s noxious fumes for 1 round. A
	successful Fortitude save negates the
	sickened effect but does not reduce the
	damage.
	
	Fort Save failure = "blind for one round
*/
//:://////////////////////////////////////////////
//:: Created By: Justin Reynard (JWR-OEI)
//:: Created On: Sept 3, 2008
//:://////////////////////////////////////////////
//:: RPGplayer1 12/22/2008: Added support for critical hits
//:: RPGplayer1 12/22/2008: Fixed Maximized damage

#include "NW_I0_SPELLS"
#include "x2_inc_spellhook"

void main()
{
	if (!X2PreSpellCastCode())
    {
    // If code within the PreSpellCastHook (i.e. UMD) reports FALSE, do not run this spell
        return;
    }

		
	object oTarget = GetSpellTargetObject();
    int nCasterLevel = GetCasterLevel(OBJECT_SELF);
	int nDice = nCasterLevel;
	int nDamage = 0;
	// Calculate max damage.
	if (nCasterLevel > 15)
		nDice = 15;
		
	int nTouch = TouchAttackRanged(oTarget);
	if (nTouch == TOUCH_ATTACK_RESULT_CRITICAL && !GetIsImmune(oTarget, IMMUNITY_TYPE_CRITICAL_HIT))
	{
		nDice = nDice*2;
	}

	// calculate base damage	
	nDamage = d6(nDice);	
	if (spellsIsTarget(oTarget, SPELL_TARGET_STANDARDHOSTILE, OBJECT_SELF))
	{
		 SignalEvent(oTarget, EventSpellCastAt(OBJECT_SELF, SPELL_ORB_OF_COLD));
		 //if (TouchAttackRanged(oTarget) != TOUCH_ATTACK_RESULT_MISS)
		 if (nTouch != TOUCH_ATTACK_RESULT_MISS)
		 {
		 // Orb spells are not resisted!!
		 	int nMetaMagic = GetMetaMagicFeat();
			if (nMetaMagic == METAMAGIC_MAXIMIZE)
     	    {
      		   	// do MAXIMIZE 6 * nDice
				nDamage = 6 * nDice;
       	 	}
         	if (nMetaMagic == METAMAGIC_EMPOWER)
         	{
            	// DO EMPOWER damage * 1.5
				nDamage = nDamage + (nDamage/2);
         	}
			
			// Savint throw for "sickened" effect
			if(!MySavingThrow(SAVING_THROW_FORT, oTarget, GetSpellSaveDC()))
			{
				// failed saving throw, uh oh! Blindness!
				effect eBlindness = EffectBlindness();
				ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eBlindness, oTarget, RoundsToSeconds(1));
			}
			
			
			effect eDam = EffectDamage(nDamage, DAMAGE_TYPE_COLD, DAMAGE_POWER_NORMAL);
			// visual!!!!
			//effect eVis = EffectVisualEffect(VFX_HIT_SPELL_FIRE);
		    //effect eLink = EffectLinkEffects(eFireDamage, eVis);
			ApplyEffectToObject(DURATION_TYPE_INSTANT, eDam, oTarget);
			
			
			
		 	
		 }
		 
	}
	
	}