//::///////////////////////////////////////////////
//:: nw_i0_ochrejelly (alfa_i0_oozesplit)
//:: Copyright (c) 2004 Bioware Corp.
//:://////////////////////////////////////////////
/*
    An include file for handling the "Split"
    functionality of the Ochre Jellies.
*/
//:://////////////////////////////////////////////
//:: Created By: Keith K2 Hayward
//:: Created On: July, 2004
//:: Modified On: January, 2006
//:: Copied to NWN2 July, 2020
//:://////////////////////////////////////////////

void SplitCreature(object oCreature);

void SplitCreature(object oCreature)
{
    int iCloneHP;
    int iCurrentHP = GetCurrentHitPoints(oCreature);
    int iHitDice = GetHitDice(oCreature);
    int iDamage;

    effect ePoof1 = EffectVisualEffect(VFX_IMP_ACID_L);
    effect ePoof2 = EffectVisualEffect(VFX_HIT_SPELL_POISON);
    effect eLevelDown, eDamage;

    object oClone1;
    object oClone2;

    location lSpawn = GetLocation(oCreature);
    string sResRef = GetResRef(oCreature);

    // Split hit dice by half
    if (iHitDice > 2)
    {
        oClone1 = CreateObject(OBJECT_TYPE_CREATURE, sResRef, lSpawn, TRUE);
        oClone2 = CreateObject(OBJECT_TYPE_CREATURE, sResRef, lSpawn, TRUE);
        iHitDice /= 2;
    }

    if ((GetIsObjectValid(oClone1)) && (GetIsObjectValid(oClone2)))
    {
        iCloneHP = GetCurrentHitPoints(oClone1);
        iDamage = iCloneHP - (iCurrentHP/2);
        eDamage = EffectDamage(iDamage);

        ApplyEffectAtLocation(DURATION_TYPE_INSTANT, ePoof1, lSpawn);
        ApplyEffectToObject(DURATION_TYPE_INSTANT, ePoof2, oClone1);
        ApplyEffectToObject(DURATION_TYPE_INSTANT, ePoof2, oClone2);

        // Make 50% smaller
        SetScale(oClone1, 0.5, 0.5, 0.5);
        SetScale(oClone2, 0.5, 0.5, 0.5);

        // Reduce the hitpoints of the Jellies and take away levels
        ApplyEffectToObject(DURATION_TYPE_INSTANT, eDamage, oClone1);
        ApplyEffectToObject(DURATION_TYPE_INSTANT, eDamage, oClone2);

        // If the Level of the monster is greater then 1 reduce it by levels
        eLevelDown = EffectNegativeLevel(iHitDice, TRUE);
        if (iHitDice > 0)
        {
            ApplyEffectToObject(DURATION_TYPE_INSTANT, eLevelDown, oClone1);
            ApplyEffectToObject(DURATION_TYPE_INSTANT, eLevelDown, oClone2);
        }

        AssignCommand(oCreature, ClearAllActions(TRUE));
        DestroyObject(oCreature);
    }
}
