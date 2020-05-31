//::///////////////////////////////////////////////
//:: Protection from Alignment
//:: NW_S0_PrVAlign_i.nss
//:: Copyright (c) 2020 A Land Far Away
//:://////////////////////////////////////////////
/*
    When confronted by an alignment the protected
    character gains +2 AC, +2 to Saves and
    immunity to all mind-affecting spells cast
    by aligned creatures
*/
//:://////////////////////////////////////////////

#include "acr_spells_i"


void handle_protection_vs_align(int alignment_to_protect_against, int feat_to_give_bonus)
{
    if (!X2PreSpellCastCode())
    {
        return;
    }

    int caster_level, duration_type;
    float duration;
    object target;
    effect spell_effect;

    target = GetSpellTargetObject();
    spell_effect = CreateProtectionFromAlignmentLink(alignment_to_protect_against, 1, SPELL_PROTECTION_FROM_ALIGNMENT);

    // Determine duration
    caster_level = GetCasterLevel(OBJECT_SELF);
    if (GetHasFeat(feat_to_give_bonus)) {
        caster_level += 1;
    }
    duration = ApplyMetamagicDurationMods(HoursToSeconds(caster_level));
    duration_type = ApplyMetamagicDurationTypeMods(DURATION_TYPE_TEMPORARY);
    RemovePermanencySpells(target);

    // Fire cast spell at event for the specified target
    SignalEvent(target, EventSpellCastAt(OBJECT_SELF, GetSpellId(), FALSE));

    // Apply the VFX impact and effects
    ApplyEffectToObject(duration_type, spell_effect, target, duration);
}
