//::///////////////////////////////////////////////
//:: Protection from Law
//:: NW_S0_PrLaw.nss
//:: Copyright (c) 2020 A Land Far Away
//:://////////////////////////////////////////////
/*
    When confronted by law the protected character
    gains +2 AC, +2 to Saves and immunity to all
    mind-affecting spells cast by law creatures
*/
//:://////////////////////////////////////////////

#include "nwn2_inc_spells"
#include "x2_inc_spellhook"

void main()
{

    if (!X2PreSpellCastCode())
    {
    // If code within the PreSpellCastHook (i.e. UMD) reports FALSE, do not run this spell
        return;
    }

// End of Spell Cast Hook


    //Declare major variables
    int nAlign = ALIGNMENT_LAW;
    object oTarget = GetSpellTargetObject();
    float fDuration = HoursToSeconds(GetCasterLevel(OBJECT_SELF));

    effect eDur = EffectVisualEffect(VFX_DUR_SPELL_PROT_ALIGN);
    effect eAC = EffectACIncrease(2, AC_DEFLECTION_BONUS);

    eAC = VersusAlignmentEffect(eAC,ALIGNMENT_ALL, nAlign);
    effect eSave = EffectSavingThrowIncrease(SAVING_THROW_ALL, 2);
    eSave = VersusAlignmentEffect(eSave,ALIGNMENT_ALL, nAlign);
    effect eImmune = EffectImmunity(IMMUNITY_TYPE_MIND_SPELLS);
    eImmune = VersusAlignmentEffect(eImmune,ALIGNMENT_ALL, nAlign);

    effect eLink = EffectLinkEffects(eImmune, eSave);
    eLink = EffectLinkEffects(eLink, eAC);
	eLink = EffectLinkEffects(eLink, eDur);

    //Enter Metamagic conditions
    fDuration = ApplyMetamagicDurationMods(fDuration);
    int nDurType = ApplyMetamagicDurationTypeMods(DURATION_TYPE_TEMPORARY);

    RemovePermanencySpells(oTarget);

    //Fire cast spell at event for the specified target
    SignalEvent(oTarget, EventSpellCastAt(OBJECT_SELF, SPELL_PROTECTION_FROM_LAW, FALSE));

    //Apply the VFX impact and effects
    ApplyEffectToObject(nDurType, eLink, oTarget, fDuration);
}
