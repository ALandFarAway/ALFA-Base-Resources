//::///////////////////////////////////////////////
//:: Reduce Person, Greater
//:: NX2_S0_GreatReducePer.nss
//:: Copyright (c) 2008 Obsidian Entertainment, Inc.
//:://////////////////////////////////////////////
/*
	Based on Enlarge Person script (opposite, obviously)
	by Jesse Reynolds (JLR - OEI).
*/
//:://////////////////////////////////////////////
//:: Created By: Justin Reynard (JWR-OEI)
//:: Created On: 09/05/2008
//:://////////////////////////////////////////////
//:: RPGplayer1 11/22/08 - Won't stack with other Reduce spells anymore
//:: RPGplayer1 02/23/09 - RemoveEffectsFromSpell() synched with ApplyEffectToObject()

#include "nw_i0_spells"
#include "x2_inc_spellhook" 
#include "nwn2_inc_spells" 

void main()
{
	if (!X2PreSpellCastCode())
    {
        // If code within the PreSpellCastHook (i.e. UMD) reports FALSE, do not run this spell
        return;
    }

	//Declare major variables
    object oTarget = GetSpellTargetObject();
    int nCasterLvl = GetCasterLevel(OBJECT_SELF);
    float fDuration = TurnsToSeconds(nCasterLvl)*10; // longer duration than the usual
	
	//	Make sure the target is humanoid
    if ( !(GetIsPlayableRacialType(oTarget) ||
           GetRacialType(oTarget) == RACIAL_TYPE_HUMANOID_GOBLINOID ||
           GetRacialType(oTarget) == RACIAL_TYPE_HUMANOID_MONSTROUS ||
           GetRacialType(oTarget) == RACIAL_TYPE_HUMANOID_ORC ||
           GetRacialType(oTarget) == RACIAL_TYPE_HUMANOID_REPTILIAN ||
           GetSubRace(oTarget) == RACIAL_SUBTYPE_GITHYANKI ||
           GetSubRace(oTarget) == RACIAL_SUBTYPE_GITHZERAI) )
		{
			FloatingTextStrRefOnCreature( STR_REF_FEEDBACK_SPELL_INVALID_TARGET, oTarget );  //"*Failure-Invalid Target*"
			return;
		}
		
	// Metamagic?
    fDuration = ApplyMetamagicDurationMods(fDuration);
    int nDurType = ApplyMetamagicDurationTypeMods(DURATION_TYPE_TEMPORARY);
	
	// check and make sure you aren't already shrank!
	
	// if you're enlarged, this will cancel that buff.
	
	// DO I need this??
	DelayCommand(1.49, RemoveEffectsFromSpell(oTarget, GetSpellId()));
	DelayCommand(1.49, RemoveEffectsFromSpell(oTarget, SPELL_REDUCE_PERSON));
	DelayCommand(1.49, RemoveEffectsFromSpell(oTarget, SPELL_REDUCE_ANIMAL));
	DelayCommand(1.49, RemoveEffectsFromSpell(oTarget, SPELL_REDUCE_PERSON_MASS));
    // RemovePermanencySpells(oTarget);
	
	effect eVis = EffectVisualEffect(VFX_HIT_SPELL_REDUCE_PERSON);  // visual effect
	
	effect eStr = EffectAbilityDecrease(ABILITY_STRENGTH, 2);
    effect eDex = EffectAbilityIncrease(ABILITY_DEXTERITY, 2);
    effect eAtk = EffectAttackIncrease(1, ATTACK_BONUS_MISC);
    effect eAC = EffectACIncrease(1, AC_DODGE_BONUS);
   	// effect eDmg = EffectDamageDecrease(3, DAMAGE_TYPE_MAGICAL);
    effect eScale = EffectSetScale(0.5);
    effect eDur = EffectVisualEffect(VFX_DUR_CESSATE_POSITIVE);
    effect eLink = EffectLinkEffects(eStr, eDex);
    eLink = EffectLinkEffects(eLink, eAtk);
    eLink = EffectLinkEffects(eLink, eAC);
	//    eLink = EffectLinkEffects(eLink, eDmg);
    eLink = EffectLinkEffects(eLink, eScale);
    eLink = EffectLinkEffects(eLink, eDur);
    eLink = EffectLinkEffects(eLink, eVis);
	
	SignalEvent(oTarget, EventSpellCastAt(OBJECT_SELF, GetSpellId(), FALSE));
	
	DelayCommand(1.5, ApplyEffectToObject(nDurType, eLink, oTarget, fDuration));
	

}