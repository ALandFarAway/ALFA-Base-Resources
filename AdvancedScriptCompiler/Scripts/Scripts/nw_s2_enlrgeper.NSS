//::///////////////////////////////////////////////
//:: Enlarge Person (Duergar Racial Ability)
//:: NW_S2_EnlrgePer.nss
//:://////////////////////////////////////////////
/*
    Target creature increases in size 50%.  Gains
    +2 Strength, -2 Dexterity, -1 to Attack and
    -1 AC penalties.  Melee weapons gain +3 Dmg.
*/

// JLR-OEI 03/16/06: For GDD Update



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
    int nCasterLvl = GetTotalLevels(OBJECT_SELF, 1) * 2; //GetCasterLevel(OBJECT_SELF);
	if(nCasterLvl < 3)
	{
		nCasterLvl = 3;
	}
    float fDuration = TurnsToSeconds(nCasterLvl);

    //Enter Metamagic conditions
    fDuration = ApplyMetamagicDurationMods(fDuration);
    int nDurType = ApplyMetamagicDurationTypeMods(DURATION_TYPE_TEMPORARY);

	// JBH - 08/11/05 - OEI
	// Currently, if there are any size enlarging spells on the character
	// casting another should fail
	if ( HasSizeIncreasingSpellEffect( oTarget ) == TRUE )
	{
		// TODO: fizzle effect? 
		FloatingTextStrRefOnCreature( 3734, oTarget );  //"Failed"
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

    //Fire cast spell at event for the specified target
    SignalEvent(oTarget, EventSpellCastAt(OBJECT_SELF, GetSpellId(), FALSE));

    //Apply the VFX impact and effects
    ApplyEffectToObject(DURATION_TYPE_INSTANT, eVis, oTarget);
	// Delay increasing size for 2 seconds to let enough particles spawn from the
	//	hit fx to obscure the pop in size.
    DelayCommand(1.5, ApplyEffectToObject(nDurType, eLink, oTarget, fDuration));
}