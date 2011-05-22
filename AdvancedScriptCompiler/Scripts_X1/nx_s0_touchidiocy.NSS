//::///////////////////////////////////////////////
//:: [Touch of Idiocy]
//:: [NX_S0_touchidiocy.nss]
//:://////////////////////////////////////////////
//:: 
//:: Components: V, S
//:: Duration: 10 minutes/level
//:: Saving Throw: None
//:: Spell Resistance: Yes
//:: 
//:: Touch attack applies 1d6 penalty to INT, WIS,
//:: and CHA, which can affect target's spellcasting.
//:: This penalty cannot reduce any score to below 1.
//:: 
//:://////////////////////////////////////////////
//:: Created By: Ryan Young (REY - OEI)
//:: Created On: January 12, 2007
//:: 
//:: Borrowed heavily from [NW_S0_ShkngGrsp.nss]
//:: Jesse Reynolds (JLR - OEI)
//:://////////////////////////////////////////////
//:: AFW-OEI 07/10/2007: NX1 VFX

#include "nwn2_inc_spells"
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

    if (!X2PreSpellCastCode())
    {
	// If code within the PreSpellCastHook (i.e. UMD) reports FALSE, do not run this spell
        return;
    }

// End of Spell Cast Hook


    //Declare major variables
    object oTarget = GetSpellTargetObject();
	
    float fDuration = TurnsToSeconds(10 * GetCasterLevel(OBJECT_SELF));
	
    fDuration = ApplyMetamagicDurationMods(fDuration);
    int nDurType = ApplyMetamagicDurationTypeMods(DURATION_TYPE_TEMPORARY);
	
	
    if (TouchAttackMelee(oTarget) != FALSE)  //GZ: Fixed boolean check to work in NWScript. 1 or 2 are valid return numbers from TouchAttackMelee
    {
    	  if (spellsIsTarget(oTarget, SPELL_TARGET_STANDARDHOSTILE, OBJECT_SELF))
    	  {
            //Fire cast spell at event for the specified target
            SignalEvent(oTarget, EventSpellCastAt(OBJECT_SELF, GetSpellId()));

            if (!MyResistSpell(OBJECT_SELF, oTarget))
            {				
                //Check for metamagic
				int nWisDmg = d6();
				int nIntDmg = d6();
				int nChaDmg = d6();
                nWisDmg = ApplyMetamagicVariableMods(nWisDmg, 6);
                nIntDmg = ApplyMetamagicVariableMods(nIntDmg, 6);
                nChaDmg = ApplyMetamagicVariableMods(nChaDmg, 6);

                //Set ability damage effect
				effect eWis, eInt, eCha;				
				
				int nCurWis = GetAbilityScore(oTarget, ABILITY_WISDOM);
				if ( (nCurWis - nWisDmg) <= 1) {
					eWis = EffectAbilityDecrease(ABILITY_WISDOM, (nCurWis -1));
				}
				else {					
					eWis = EffectAbilityDecrease(ABILITY_WISDOM, nWisDmg);
				}
				
				int nCurInt = GetAbilityScore(oTarget, ABILITY_INTELLIGENCE);
				if ( (nCurInt - nIntDmg) <= 1) {
					eInt = EffectAbilityDecrease(ABILITY_INTELLIGENCE, (nCurInt - 1));
				}
				else {
					eInt = EffectAbilityDecrease(ABILITY_INTELLIGENCE, nIntDmg);
				}
				
				int nCurCha = GetAbilityScore(oTarget, ABILITY_CHARISMA);
				if ( (nCurCha - nChaDmg) <= 1) {
					eCha = EffectAbilityDecrease(ABILITY_CHARISMA, (nCurCha - 1));
				}
				else {
					eCha = EffectAbilityDecrease(ABILITY_CHARISMA, nChaDmg);
				}
				
  			    effect eDur = EffectVisualEffect( VFX_DUR_SPELL_TOUCH_OF_IDIOCY );
				effect eLink = EffectLinkEffects(eWis, eInt);
				eLink = EffectLinkEffects(eLink, eCha);
				eLink = EffectLinkEffects(eLink, eDur);
				
                //Apply the VFX impact and effects
    			RemoveEffectsFromSpell(oTarget, GetSpellId());
				ApplyEffectToObject(nDurType, eLink, oTarget, fDuration);
           }
        }
    }
	effect eRay = EffectBeam(VFX_BEAM_ENCHANTMENT, OBJECT_SELF, BODY_NODE_HAND);
	ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eRay, oTarget, 1.0);
}