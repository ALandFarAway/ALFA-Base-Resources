//::///////////////////////////////////////////////
//:: [Goodberry]
//:: [acr_s0_goodberry.NSS]
//:: Copyright (c) 2020 A Land Far Away
//::///////////////////////////////////////////////
/*
   Creates 2d4 berries that each temporarily have
   the ability to nourish as a full meal and heal 1
   point of damage.
*/

#include "acr_spells_i"


const string GOODBERRY_RES_REF = "abr_it_fr_goodberry";


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

    oTarget = GetSpellTargetObject();
    oCaster = OBJECT_SELF;

    // Signal event successful
    SignalEvent(oTarget, EventSpellCastAt(oCaster, GetSpellId(), FALSE));

    nCasterLevel = ACR_GetCorrectCasterLevel(OBJECT_SELF);
    fDuration = ACR_GetSpellDuration(oCaster, ACR_DURATION_TYPE_PER_CL, ACR_DURATION_24H);

    // Number of goodberries to create
    nNumberToCreate = d4(2);

    // Create goodberries
    oBerry = CreateItemOnObject(GOODBERRY_RES_REF, oCaster, nNumberToCreate, "", 1);

    // Create temporary spell of cure minor wounds
    ipCureMinorWounds = ItemPropertyCastSpell(IP_CONST_CASTSPELL_CURE_MINOR_WOUNDS_1, 1);

    // Add bonuses
    IPSafeAddItemProperty(oBerry, ipCureMinorWounds, fDuration, X2_IP_ADDPROP_POLICY_REPLACE_EXISTING);
}
