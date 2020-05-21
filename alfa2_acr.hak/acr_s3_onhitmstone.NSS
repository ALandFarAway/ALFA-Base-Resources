//::///////////////////////////////////////////////
//:: [OnHit Magic Stone]
//:: [acr_s0_onhitmstone.NSS]
//:: Copyright (c) 2020 A Land Far Away
//::///////////////////////////////////////////////
/*
   Effect of Magic Stone spell hitting:
   1d6+1 or 2d6+2 against undead

   This must be a OnHit effect as as there is no
   thrown item that allows for 1d6 base bludegeon
   damage.
*/

#include "acr_spells_i"


void main()
{
    int nDamage;
    effect eDamage, eVisualEffect;
    object oTarget;

    oTarget = GetSpellTargetObject();

    if (GetIsObjectValid(oTarget)) {
        nDamage = d6(1) + 1;

        // Do extra damage if undead
        if (GetRacialType(oTarget) == RACIAL_TYPE_UNDEAD) {
            nDamage += d6(1) + 1;
        }

        // Create a visual and damage effect
        eDamage = EffectDamage(nDamage, DAMAGE_TYPE_BLUDGEONING);
        eVisualEffect = EffectVisualEffect(VFX_IMP_SONIC);
        eDamage = EffectLinkEffects(eVisualEffect, eDamage);

        // Apply effect
        ApplyEffectToObject(DURATION_TYPE_INSTANT, eDamage, oTarget);
    }
}
