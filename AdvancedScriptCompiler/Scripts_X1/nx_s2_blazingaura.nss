//::///////////////////////////////////////////////
//:: Blazing Aura
//:: nx_s2_blazingaura.nss
//:: Copyright (c) 2007 Obsidian Entertainment, Inc.
//:://////////////////////////////////////////////
/*
    Caster gains additional 1d10 fire damage and
    inflicts 1d6 fire damage on melee attackers
    for 5 + WIS rounds.
*/
//:://////////////////////////////////////////////
//:: Created By: Andrew Woo (AFW-OEI)
//:: Created On: 02/29/2007
//:://////////////////////////////////////////////
//:: AFW-OEI 07/17/2007: NX1 VFX.

#include "x2_inc_spellhook"
#include "x0_i0_spells"

void main()
{
    if (!X2PreSpellCastCode())
    {   // If code within the PreSpellCastHook (i.e. UMD) reports FALSE, do not run this spell
        return;
    }

    //Declare major variables
    effect eDur = EffectVisualEffect(VFX_DUR_BLAZING_AURA);
    effect eShield = EffectDamageShield(0, DAMAGE_BONUS_1d6, DAMAGE_TYPE_FIRE);
    effect eDamage = EffectDamageIncrease(DAMAGE_BONUS_1d10, DAMAGE_TYPE_FIRE);
    int nDuration = 5 + GetAbilityModifier(ABILITY_WISDOM);
	
    //Link effects
    effect eLink = EffectLinkEffects(eShield, eDamage);
    eLink = EffectLinkEffects(eLink, eDur);

    //Fire cast spell at event for the specified target
    SignalEvent(OBJECT_SELF, EventSpellCastAt(OBJECT_SELF, SPELL_ELEMENTAL_SHIELD, FALSE));

    // Spell does not stack
    if (GetHasSpellEffect(GetSpellId(),OBJECT_SELF))
    {
         RemoveSpellEffects(GetSpellId(), OBJECT_SELF, OBJECT_SELF);
    }

    //Apply the VFX impact and effects
    ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eLink, OBJECT_SELF, RoundsToSeconds(nDuration));
}