//::///////////////////////////////////////////////
//:: Enlarge Person
//:: NW_S0_EnlrgePer.nss
//:://////////////////////////////////////////////
/*
    Target creature increases in size 50%.  Gains
    +2 Strength, -2 Dexterity, -1 to Attack and
    -1 AC penalties.  Melee weapons gain +3 Dmg.
*/
//:://////////////////////////////////////////////
//:: Created By: Jesse Reynolds (JLR - OEI)
//:: Created On: July 12, 2005
//:://////////////////////////////////////////////
//:: VFX Pass By: Preston W, On: June 20, 2001


// JLR - OEI 08/23/05 -- Permanency & Metamagic changes
#include "nwn2_inc_spells"



#include "nw_i0_spells"
#include "x2_inc_spellhook" 
#include "nwn2_inc_spells" 

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
    float fDuration = TurnsToSeconds(nCasterLvl);

	// AFW-OEI 05/09/2006: Make sure the target is humanoid
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
	
    //Enter Metamagic conditions
    fDuration = ApplyMetamagicDurationMods(fDuration);
    int nDurType = ApplyMetamagicDurationTypeMods(DURATION_TYPE_TEMPORARY);

	// JBH - 08/11/05 - OEI
	// Currently, if there are any size enlarging spells on the character
	// casting another should fail
	if ( HasSizeIncreasingSpellEffect( oTarget ) == TRUE || GetHasSpellEffect( 803, oTarget ) )
	{
		// TODO: fizzle effect? 
		FloatingTextStrRefOnCreature( STR_REF_FEEDBACK_SPELL_FAILED, oTarget );  //"Failed"
		return;
	}

    RemoveEffectsFromSpell(oTarget, GetSpellId());
    RemovePermanencySpells(oTarget);

    effect eVis = EffectVisualEffect(VFX_HIT_SPELL_ENLARGE_PERSON);

    effect eStr = EffectAbilityIncrease(ABILITY_STRENGTH, 2);
    effect eDex = EffectAbilityDecrease(ABILITY_DEXTERITY, 2);
    effect eAtk = EffectAttackDecrease(1, ATTACK_BONUS_MISC);
    effect eAC = EffectACDecrease(1, AC_DODGE_BONUS);
    effect eDmg = EffectDamageIncrease(3, DAMAGE_TYPE_MAGICAL);	// Should be Melee-only!
    effect eScale = EffectSetScale(1.5);
    effect eDur = EffectVisualEffect(VFX_DUR_CESSATE_POSITIVE);
    effect eLink = EffectLinkEffects(eStr, eDex);
    eLink = EffectLinkEffects(eLink, eAtk);
    eLink = EffectLinkEffects(eLink, eAC);
    eLink = EffectLinkEffects(eLink, eDmg);
    eLink = EffectLinkEffects(eLink, eScale);
    eLink = EffectLinkEffects(eLink, eDur);
    eLink = EffectLinkEffects(eLink, eVis);

    //Fire cast spell at event for the specified target
    SignalEvent(oTarget, EventSpellCastAt(OBJECT_SELF, GetSpellId(), FALSE));

    //Apply the VFX impact and effects
    //ApplyEffectToObject(DURATION_TYPE_INSTANT, eVis, oTarget);	// VFX_HIT_SPELL_ENLARGE_PERSON contains a cessation effect, so it must be applied temporarily
	// Delay increasing size for 2 seconds to let enough particles spawn from the
	//	hit fx to obscure the pop in size.
    DelayCommand(1.5, ApplyEffectToObject(nDurType, eLink, oTarget, fDuration));
}