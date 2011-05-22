//::///////////////////////////////////////////////
//:: Death Armor
//:: X2_S0_DthArm
//:: Copyright (c) 2001 Bioware Corp.
//:://////////////////////////////////////////////
/*
    You are surrounded with a magical aura that injures
    creatures that contact it. Any creature striking
    you with its body or handheld weapon takes 1d4 points
    of damage +1 point per 2 caster levels (maximum +5).
*/
//:://////////////////////////////////////////////
//:: Created By: Andrew Nobbs
//:: Created On: Jan 6, 2003
//:://////////////////////////////////////////////
//:: Last Updated By: Andrew Nobbs, 02/06/2003
//:: 2003-07-07: Stacking Spell Pass, Georg Zoeller

// JLR - OEI 08/24/05 -- Metamagic changes
#include "nwn2_inc_spells"


#include "x2_inc_spellhook"
#include "x0_i0_spells"
//#include "ginc_debug"

void main()
{

    /*
      Spellcast Hook Code
      Added 2003-07-07 by Georg Zoeller
      If you want to make changes to all spells,
      check x2_inc_spellhook.nss to find out more

    */

    if (!X2PreSpellCastCode())
    {
    // If code within the PreSpellCastHook (i.e. UMD) reports FALSE, do not run this spell
        return;
    }

    // End of Spell Cast Hook
    object oTarget = GetSpellTargetObject();

    float fDuration = RoundsToSeconds(GetCasterLevel(oTarget));
    int nCasterLvl = GetCasterLevel(oTarget)/2;
    if(nCasterLvl > 5)
    {
        nCasterLvl = 5;
    }

    effect eShield = EffectDamageShield(nCasterLvl, DAMAGE_BONUS_1d4, DAMAGE_TYPE_MAGICAL);
    effect eDur = EffectVisualEffect( VFX_DUR_DEATH_ARMOR );

    //Link effects
    effect eLink = EffectLinkEffects( eDur, eShield );

    //Fire cast spell at event for the specified target
    SignalEvent(oTarget, EventSpellCastAt(OBJECT_SELF, GetSpellId(), FALSE));

    //Enter Metamagic conditions
    fDuration = ApplyMetamagicDurationMods(fDuration);
    //int nDurType = ApplyMetamagicDurationTypeMods(DURATION_TYPE_TEMPORARY);

    //Stacking Spellpass, 2003-07-07, Georg
    RemoveEffectsFromSpell(oTarget, GetSpellId());

    ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eLink, oTarget, fDuration);
}