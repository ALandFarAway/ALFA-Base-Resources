//::///////////////////////////////////////////////
//:: Magic Circle Against Good
//:: NW_S0_CircGood.nss
//:: Copyright (c) 2020 A Land Far Away
//:://////////////////////////////////////////////
//:://////////////////////////////////////////////

#include "acr_spells_i"

void main()
{
    // If code within the PreSpellCastHook (i.e. UMD) reports FALSE, do not run this spell
    if (!ACR_PrecastEvent()) {
        return;
    }
    effect eAOE = EffectAreaOfEffect(AOE_MOB_CIRCEVIL);

    object oCaster = OBJECT_SELF;
    object oTarget = GetSpellTargetObject();
    int nCasterLevel = ACR_GetCorrectCasterLevel(OBJECT_SELF);
    float fDuration = ACR_GetSpellDuration(oCaster, ACR_DURATION_TYPE_PER_CL, ACR_DURATION_1H);

    // Fire cast spell at event for the specified target
    SignalEvent(oTarget, EventSpellCastAt(OBJECT_SELF, SPELL_MAGIC_CIRCLE_AGAINST_GOOD, FALSE));
    // Create an instance of the AOE Object using the Apply Effect function
    ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eAOE, oTarget, fDuration);
}
