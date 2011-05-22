//::///////////////////////////////////////////////
//:: Divine Power
//:: NW_S0_DivPower.nss
//:: Copyright (c) 2001 Bioware Corp.
//:://////////////////////////////////////////////
/*
    Improves the Clerics attack to be the
    equivalent of a Fighter's BAB of the same level,
    +1 HP per level and raises their strength to
    18 if is not already there.
*/
//:://////////////////////////////////////////////
//:: Created By: Preston Watamaniuk
//:: Created On: Oct 21, 2001
//:://////////////////////////////////////////////

/*
bugfix by Kovi 2002.07.22
- temporary hp was stacked
- loosing temporary hp resulted in loosing the other bonuses
- number of attacks was not increased (should have been a BAB increase)
still problem:
~ attacks are better still approximation (the additional attack is at full BAB)
~ attack/ability bonuses count against the limits
*/

// (Update JLR - OEI 07/19/05) -- Changed STR Bonus to +6 instead of <Min 18>


#include "nw_i0_spells"
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

    RemoveEffectsFromSpell(oTarget, GetSpellId());
    RemoveTempHitPoints();

    int nCasterLevel = GetCasterLevel(OBJECT_SELF);
    int nTotalCharacterLevel = GetHitDice(OBJECT_SELF);
    int nBAB = GetBaseAttackBonus(OBJECT_SELF);
    int nEpicPortionOfBAB = ( nTotalCharacterLevel - 19 ) / 2;

    if ( nEpicPortionOfBAB < 0 )
    {
        nEpicPortionOfBAB = 0;
    }

    int nExtraAttacks = 0;
    int nAttackIncrease = 0;

    if ( nTotalCharacterLevel > 20 )
    {
        nAttackIncrease = 20 + nEpicPortionOfBAB;
        if( nBAB - nEpicPortionOfBAB < 11 )
        {
            nExtraAttacks = 2;
        }
        else if( nBAB - nEpicPortionOfBAB > 10 && nBAB - nEpicPortionOfBAB < 16)
        {
            nExtraAttacks = 1;
        }
    }
    else
    {
        nAttackIncrease = nTotalCharacterLevel;
        nExtraAttacks = ( ( nTotalCharacterLevel - 1 ) / 5 ) - ( ( nBAB - 1 ) / 5 );
    }
    nAttackIncrease -= nBAB;

    if ( nAttackIncrease < 0 )
    {
        nAttackIncrease = 0;
    }

/*
    int nStr = GetAbilityScore(oTarget, ABILITY_STRENGTH);
    int nStrengthIncrease = (nStr - 18) * -1;
    if( nStrengthIncrease < 0 )
    {
        nStrengthIncrease = 0;
    }
*/
    int nStrengthIncrease = 6;  // JLR - OEI 07/19/05

    //effect eVis = EffectVisualEffect(VFX_IMP_SUPER_HEROISM);	// no longer using NWN1 VFX
    effect eVis = EffectVisualEffect( VFX_DUR_SPELL_DIVINE_POWER );	// uses NWN2 VFX
    effect eStrength = EffectAbilityIncrease(ABILITY_STRENGTH, nStrengthIncrease);
    effect eHP = EffectTemporaryHitpoints(nCasterLevel);
    effect eAttack = EffectAttackIncrease(nAttackIncrease);
    effect eAttackMod = EffectModifyAttacks(nExtraAttacks);
//    effect eDur = EffectVisualEffect(VFX_DUR_CESSATE_POSITIVE);	// no longer using NWN1 VFX
//    effect eLink = EffectLinkEffects(eAttack, eAttackMod);
    //eLink = EffectLinkEffects(eLink, eDur);	// no longer using NWN1 VFX
//	eLink = EffectLinkEffects(eLink, eVis);

    effect eBAB = EffectBABMinimum(nTotalCharacterLevel);
    effect eLink = EffectLinkEffects(eBAB, eVis);

    //Make sure that the strength modifier is a bonus
    if( nStrengthIncrease > 0 )
    {
        eLink = EffectLinkEffects(eLink, eStrength);
    }

    //Meta-Magic
    int nMetaMagic = GetMetaMagicFeat();
    if( nMetaMagic == METAMAGIC_EXTEND )
    {
        nCasterLevel *= 2;
    }

    effect eOnDispell = EffectOnDispel(0.0f, RemoveEffectsFromSpell(OBJECT_SELF, SPELL_DIVINE_POWER));
    eLink = EffectLinkEffects(eLink, eOnDispell);
    eHP = EffectLinkEffects(eHP, eOnDispell);

    //Fire cast spell at event for the specified target
    SignalEvent(oTarget, EventSpellCastAt(OBJECT_SELF, SPELL_DIVINE_POWER, FALSE));

    //Apply Link and VFX effects to the target
    ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eLink, oTarget, RoundsToSeconds(nCasterLevel));
    ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eHP, oTarget, RoundsToSeconds(nCasterLevel));
    //ApplyEffectToObject(DURATION_TYPE_INSTANT, eVis, oTarget);	// now linked to eLink
}