//::///////////////////////////////////////////////
//:: [Magic Stone]
//:: [acr_s0_magicstone.NSS]
//:: Copyright (c) 2020 A Land Far Away
//::///////////////////////////////////////////////
/*
   Creates 3 pebbles that each temporarily have
   the ability to do 1d6+1 damage or 2d6+2 against
   undead.
*/

#include "acr_spells_i"


const int IP_CONST_ONHIT_CASTSPELL_ONHIT_MSTONE = 178;
const string MAGICSTONE_RES_REF = "abr_it_wp_magicstone";


void main()
{
    object oCaster, oTarget, oStone;
    int nNumberToCreate;
    float fDuration;
    itemproperty ipOnHitMagicStone;

    // If code within the PreSpellCastHook (i.e. UMD) reports FALSE, do not run this spell
    if (!ACR_PrecastEvent()) {
        return;
    }

    oCaster = OBJECT_SELF;
    oTarget = oCaster;  // Target of spell is always caster, despite what someone might target

    // Signal event successful
    SignalEvent(oTarget, EventSpellCastAt(oCaster, GetSpellId(), FALSE));

    // 30m, modified by metamagic
    fDuration = ACR_GetSpellDuration(oCaster, ACR_DURATION_TYPE_STATIC, ACR_DURATION_10M * 3.0f);

    // Number of pebbles to create
    nNumberToCreate = 3;

    // Create pebbles
    oStone = CreateItemOnObject(MAGICSTONE_RES_REF, oCaster, nNumberToCreate, "", 1);

    // Create bonus:
    ipOnHitMagicStone = ItemPropertyOnHitCastSpell(IP_CONST_ONHIT_CASTSPELL_ONHIT_MSTONE, 1);
    IPSafeAddItemProperty(oStone, ipOnHitMagicStone, fDuration, X2_IP_ADDPROP_POLICY_REPLACE_EXISTING);
}
