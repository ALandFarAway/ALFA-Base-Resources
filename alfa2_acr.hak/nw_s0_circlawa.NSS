//::///////////////////////////////////////////////
//:: Magic Cirle Against Law
//:: NW_S0_CircLawA
//:: Copyright (c) 2020 A Land Far Away
//:://////////////////////////////////////////////
/*
    Add basic protection from law effects to
    entering allies.
*/
#include "NW_I0_SPELLS"

#include "x2_inc_spellhook"

void main()
{
    object oTarget = GetEnteringObject();
    if (spellsIsTarget(oTarget, SPELL_TARGET_ALLALLIES, GetAreaOfEffectCreator()))
    {
        int nDuration = GetCasterLevel(OBJECT_SELF);
        effect eLink = ACR_CreateProtectionFromAlignmentLink(ALIGNMENT_LAW);

        // Fire cast spell at event for the specified target
        SignalEvent(oTarget, EventSpellCastAt(OBJECT_SELF, SPELL_MAGIC_CIRCLE_AGAINST_LAW, FALSE));

        // Apply the VFX impact and effects
        ApplyEffectToObject(DURATION_TYPE_PERMANENT, eLink, oTarget);
     }
}
