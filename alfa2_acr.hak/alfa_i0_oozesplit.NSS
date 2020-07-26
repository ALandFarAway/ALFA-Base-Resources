//::///////////////////////////////////////////////
//:: alfa_i0_oozesplit
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
//:: Rewritten for NWN2 July, 2020
//:://////////////////////////////////////////////

void SplitCreature(object oCreature, object oPC);

void SplitCreature(object oCreature, object oPC)
{
    int iCloneHP;
    int iConLoss;
    int iNewCon;
    int iTotalCon;
    int iFortBonus;
    int iCurrentHP = GetCurrentHitPoints(oCreature);
    int iMaxHP;
    int iDamage;
    int iSplit;

    float fScale;

    string sResRef = GetResRef(oCreature);

    effect ePoof = EffectVisualEffect(VFX_IMP_ACID_L);
    effect eDamage, eConLoss, eFortBonus;

    object oClone1;
    object oClone2;

    location lSpawn = GetLocation(oCreature);

    // Only split if HP > 10
    if (iCurrentHP > 10) {
        iSplit = GetLocalInt(oCreature, "split") + 1;

        oClone1 = CreateObject(OBJECT_TYPE_CREATURE, sResRef, lSpawn);
        oClone2 = CreateObject(OBJECT_TYPE_CREATURE, sResRef, lSpawn);
    }

    if ((GetIsObjectValid(oClone1)) && (GetIsObjectValid(oClone2))) {
        // Count split number
        SetLocalInt(oClone1, "split", iSplit);
        SetLocalInt(oClone2, "split", iSplit);

        // VFX
        ApplyEffectAtLocation(DURATION_TYPE_INSTANT, ePoof, lSpawn);

        // Make 50% smaller
        fScale = pow(0.5, IntToFloat(iSplit));
        SetScale(oClone1, fScale, fScale, fScale);
        SetScale(oClone2, fScale, fScale, fScale);

        // Reduce max hp by 2^split
        iMaxHP = GetMaxHitPoints(oClone1);
        iTotalCon = GetAbilityScore(oClone1, ABILITY_CONSTITUTION);
        iNewCon = (
            iTotalCon / FloatToInt(pow(2.0, IntToFloat(iSplit)))
        );
        iConLoss = iTotalCon - iNewCon;
        eConLoss = EffectAbilityDecrease(ABILITY_CONSTITUTION, iConLoss);
        ApplyEffectToObject(DURATION_TYPE_PERMANENT, eConLoss, oClone1);
        ApplyEffectToObject(DURATION_TYPE_PERMANENT, eConLoss, oClone2);

        // Bump up Fort for con loss
        iFortBonus = iConLoss / 2;
        eFortBonus = EffectSavingThrowIncrease(SAVING_THROW_FORT, iFortBonus);
        ApplyEffectToObject(DURATION_TYPE_PERMANENT, eFortBonus, oClone1);
        ApplyEffectToObject(DURATION_TYPE_PERMANENT, eFortBonus, oClone2);

        // Reduce the hitpoints of the ooze
        iCloneHP = GetCurrentHitPoints(oClone1);
        iDamage = iCloneHP - (iCurrentHP/2);
        if (iDamage > 0) {
            eDamage = EffectDamage(iDamage);
            ApplyEffectToObject(DURATION_TYPE_INSTANT, eDamage, oClone1);
            ApplyEffectToObject(DURATION_TYPE_INSTANT, eDamage, oClone2);
        }

        AssignCommand(oCreature, ClearAllActions(TRUE));
        DestroyObject(oCreature);
    }
}
