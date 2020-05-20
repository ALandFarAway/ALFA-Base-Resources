//::///////////////////////////////////////////////
//:: [Magic Stone]
//:: [acr_s0_magicstone.NSS]
//:: Copyright (c) 2020 A Land Far Away
//::///////////////////////////////////////////////
/*
   Creates 3 pebbles that each temporarily have
   the ability to be +1 weapons that do 1d6 damage
   and 2d6+2 against undead.
*/

#include "acr_spells_i"


const string MAGICSTONE_RES_REF = "abr_it_wp_magicstone";


void main()
{
    object oCaster, oTarget, oBerry;
    int nCasterLevel, nNumberToCreate, i;
    float fDuration;
    itemproperty ipCureMinorWounds;

    // If code within the PreSpellCastHook (i.e. UMD) reports FALSE, do not run this spell
    if (!ACR_PrecastEvent()) {
        return;
    }

    oCaster = OBJECT_SELF;
    oTarget = oCaster;  // Target of spell is always caster, despite what someone might target

    // Signal event successful
    SignalEvent(oTarget, EventSpellCastAt(oCaster, GetSpellId(), FALSE));

    nCasterLevel = ACR_GetCorrectCasterLevel(OBJECT_SELF);
    fDuration = ACR_DURATION_10M * 3.0f;  // Always 30m -- no matter what

    // Number of pebbles to create
    nNumberToCreate = 3;

    // Create pebbles 
    oBerry = CreateItemOnObject(MAGICSTONE_RES_REF, oCaster, nNumberToCreate, "", 1);

    // Create bonuses:
    //  +1 enhancement bonus
    //  +2 vs undead
    //  +1d6 vs undead
    ipPlusOne = ItemPropertyEnhancementBonus(1);
    ipPlusTwoVsUndead = ItemPropertyEnhancementBonusVsRace(IP_CONST_RACIALTYPE_UNDEAD, 2);
    ip1d6VsUndead = ItemPropertyDamageBonusVsRace(IP_CONST_RACIALTYPE_UNDEAD, IP_CONST_DAMAGETYPE_BLUDGEONING, IP_CONST_DAMAGEBONUS_1d6);

    // Add bonuses
    IPSafeAddItemProperty(oBerry, ipPlusOne, fDuration, X2_IP_ADDPROP_POLICY_REPLACE_EXISTING);
    IPSafeAddItemProperty(oBerry, ipPlusTwoVsUndead, fDuration, X2_IP_ADDPROP_POLICY_REPLACE_EXISTING);
    IPSafeAddItemProperty(oBerry, ip1d6VsUndead, fDuration, X2_IP_ADDPROP_POLICY_REPLACE_EXISTING);
}
