//::///////////////////////////////////////////////
//:: [Bear's Endurance]
//:: [NW_S0_BearEndur.nss]
//:: Copyright (c) 2000 Bioware Corp.
//:://////////////////////////////////////////////
//:: Gives the target 4 Constitution.
//:://////////////////////////////////////////////
//:: Created By: Preston Watamaniuk
//:: Created On: Jan 31, 2001
//:://////////////////////////////////////////////

// (Updated JLR - OEI 07/05/05 NWN2 3.5)

// JLR - OEI 08/24/05 -- Metamagic changes
#include "nwn2_inc_spells"


#include "x2_inc_spellhook"

void main()
{
    /*
      Spellcast Hook Code
      Added 2004-03-08 by Jon (should have been added much sooner, but we somehow missed this one...)
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
    effect eCon;
    effect eVis = EffectVisualEffect(VFX_DUR_SPELL_BEAR_ENDURANCE);

    //Does not stack with Mass Bear Endurance
    if (GetHasSpellEffect(SPELL_MASS_BEAR_ENDURANCE, oTarget))
    {
        return;
    }

    int nCasterLvl = GetCasterLevel(OBJECT_SELF);
    int nModify = 4;
    float fDuration = TurnsToSeconds(nCasterLvl);

    //Fire cast spell at event for the specified target
    SignalEvent(oTarget, EventSpellCastAt(OBJECT_SELF, SPELL_BEARS_ENDURANCE, FALSE));

    //Check for metamagic conditions
    fDuration = ApplyMetamagicDurationMods(fDuration);
    int nDurType = ApplyMetamagicDurationTypeMods(DURATION_TYPE_TEMPORARY);

    //Set the ability bonus effect
    eCon = EffectAbilityIncrease(ABILITY_CONSTITUTION,nModify);
    effect eLink = EffectLinkEffects(eCon, eVis);

    // remove any previous effects of this spell
    RemoveEffectsFromSpell(oTarget, GetSpellId());

    //Appyly the VFX impact and ability bonus effect
    ApplyEffectToObject(nDurType, eLink, oTarget, fDuration);
    //ApplyEffectToObject(DURATION_TYPE_INSTANT, eVis, oTarget);
}