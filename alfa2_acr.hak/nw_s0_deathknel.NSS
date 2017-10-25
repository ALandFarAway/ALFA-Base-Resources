//::///////////////////////////////////////////////
//:: Death Knell
//:: NW_S0_DeathKnel.nss
//:://////////////////////////////////////////////
/*
    Decompose closest recently-killed living target,
    caster gains 1d8 Temporary HPs, +2 Strength,
    and effective Caster Level +1.
    Note that this spell is inherently Evil, and
    could adjust the Caster's alignment potentially...
*/
//:://////////////////////////////////////////////
//:: Created By: Jesse Reynolds (JLR - OEI)
//:: Created On: June 16, 2005
//:://////////////////////////////////////////////
//:: VFX Pass By: Preston W, On: June 20, 2001
//::PKM-OEI: 05.28.07: Touch attacks now do critical hit damage



// JLR - OEI 08/24/05 -- Metamagic changes
// RPGplayer1 02/05/08 - Made SpellCastAt event hostile, so that caster drops invisibility properly

#include "nwn2_inc_spells"

//#include "nw_s0_spells" 
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
    object oTarget = GetSpellTargetObject();
    int nCasterLvl = GetCasterLevel(OBJECT_SELF);
    float fDuration = HoursToSeconds(nCasterLvl);
    int nBonus = d8(1);
    int nTouch      = TouchAttackMelee(oTarget, TRUE);

    //Enter Metamagic conditions
    nBonus = ApplyMetamagicVariableMods(nBonus, 8);
    /*if( nCasterLvl > 10 ) //PKM - OEI 09.29.06 - Removed this check, don't know why it was here, but the amount of hitpoints received doesn't scale
    {
        nBonus = nBonus + 10;
    }
    else
    {
        nBonus = nBonus + nCasterLvl;
    }
	*/

    fDuration = ApplyMetamagicDurationMods(fDuration);
    int nDurType = ApplyMetamagicDurationTypeMods(DURATION_TYPE_TEMPORARY);

//    RemoveEffectsFromSpell(OBJECT_SELF, SPELL_DEATH_KNELL);

// WIP! JLR! Make sure we have a VALID corpse target!!!
// WIP! JLR! Make sure we DECOMPOSE the valid corpse target!

// 7/31/06 - BDF: modified logic so that on a touch attack, the target is damaged
//	for 2d4 negative energy.  If the target dies as a result of this damage, then
// 	apply the bonuses to the caster

	int nDamage = d4( 2 );
	nDamage = ApplyMetamagicVariableMods(nDamage, 8);
	
	//PKM-OEI: 05.28.07: Do critical hit damage
	if (nTouch == TOUCH_ATTACK_RESULT_CRITICAL && !GetIsImmune(oTarget, IMMUNITY_TYPE_CRITICAL_HIT))
	{
		nDamage = d4(4);
		nDamage = ApplyMetamagicVariableMods(nDamage, 16);
	}
	
	int nTargetHP = GetCurrentHitPoints( oTarget );
	effect eDamage = EffectDamage( nDamage, DAMAGE_TYPE_NEGATIVE );
	effect eDamageVis = EffectVisualEffect( VFX_HIT_SPELL_EVIL );
	effect eDamageLink = EffectLinkEffects( eDamage, eDamageVis );
	
	if ( spellsIsTarget(oTarget, SPELL_TARGET_STANDARDHOSTILE, OBJECT_SELF) )
	{
		if (nTouch != TOUCH_ATTACK_RESULT_MISS)
		{
		
			if ( !MyResistSpell(OBJECT_SELF, oTarget) )
			{
				if ( !MySavingThrow(SAVING_THROW_WILL, oTarget, GetSpellSaveDC(), SAVING_THROW_TYPE_NEGATIVE) )
				{
	    			//Fire cast spell at event for the specified target
				    SignalEvent(oTarget, EventSpellCastAt(OBJECT_SELF, SPELL_DEATH_KNELL, TRUE));
			
					if ( (nTargetHP - nDamage) <= 0 )
					{
		    			effect eHP = EffectTemporaryHitpoints(nBonus);
			    		effect eStr = EffectAbilityIncrease(ABILITY_STRENGTH, 2);
			    		effect eDur = EffectVisualEffect( VFX_DUR_SPELL_DEATH_KNELL );	// NWN2 VFX
				
			    		//effect eLink = EffectLinkEffects(eHP, eStr);
			    		effect eLink = EffectLinkEffects(eStr, eDur);
					
			    		effect eOnDispell = EffectOnDispel(0.0f, RemoveEffectsFromSpell(OBJECT_SELF, SPELL_DEATH_KNELL));
			    		eLink = EffectLinkEffects(eLink, eOnDispell);
			    		eHP = EffectLinkEffects(eHP, eOnDispell);

			    		RemoveEffectsFromSpell(OBJECT_SELF, SPELL_DEATH_KNELL);

			    		//Apply the VFX impact and effects
			    		ApplyEffectToObject(nDurType, eHP, OBJECT_SELF, fDuration);
			    		ApplyEffectToObject(nDurType, eLink, OBJECT_SELF, fDuration);
					}
					
					ApplyEffectToObject( DURATION_TYPE_INSTANT, eDamageLink, oTarget );
				}
			}
		}
	}
}