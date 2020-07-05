//::///////////////////////////////////////////////
//:: [Shillelagh]
//:: [acr_s0_shillelagh.NSS]
//:: Copyright (c) 2020 A Land Far Away
//::///////////////////////////////////////////////
/*
   Enhances a wooden club or quarterstaff of the
   caster's choosing by temporarily giving it a +1
   enhancement and increasing its damage output as
   if its size category were 2 larger.
   This _only_ operates if caster is wielding the
   weapon in question.
*/

#include "acr_spells_i"
#include "acr_material_i"


// How often verify_owner is polled to confirm the current owner
const float VERIFY_OWNER_POLL_DURATION = 18.0f;


// Terminates effects early if owner no longer controls weapon
void verify_owner(object oCaster, object oWeapon, itemproperty ipBludgeon, itemproperty ipEnhancement)
{
    // If item owner is not in possession of the item, remove all effects and exit early
    if (GetItemPossessor(oWeapon) != oCaster) {
        RemoveItemProperty(oWeapon, ipBludgeon);
        RemoveItemProperty(oWeapon, ipEnhancement);
        return;
    }

    // Property no longer exists (expired or dispelled), exit early
    if (!IPGetItemHasProperty(oWeapon, ipBludgeon, DURATION_TYPE_TEMPORARY)) {
        return;
    }

    // Delay for subsequent check
    DelayCommand(VERIFY_OWNER_POLL_DURATION, verify_owner(oCaster, oWeapon, ipBludgeon, ipEnhancement));
}


int isClubOrQuarterstaff(int nBaseItemType)
{
    return (
        nBaseItemType == BASE_ITEM_CLUB ||
        nBaseItemType == BASE_ITEM_QUARTERSTAFF
    );
}


void main()
{
    object oCaster, oTarget;
    int nCasterLevel, nBaseItemType, nMaterialType = 0, nCurrentEnhancement = 0;
    float fDuration;
    itemproperty ipBludgeon, ipEnhancement;

    // If code within the PreSpellCastHook (i.e. UMD) reports FALSE, do not run this spell
    if (!ACR_PrecastEvent()) {
        return;
    }

    oCaster = OBJECT_SELF;
    oTarget = IPGetTargetedOrEquippedMeleeWeapon();

    nBaseItemType = GetBaseItemType(oTarget);

    // Only check for weapons
    if (isClubOrQuarterstaff(nBaseItemType)) {
        nCurrentEnhancement = IPGetWeaponEnhancementBonus(oTarget, ITEM_PROPERTY_ENHANCEMENT_BONUS);
        nMaterialType = GetItemBaseMaterialType(oTarget);
    }

    // Is target not a club/quarterstaff OR
    // is target not made of wood OR
    // is the target have an enhancement bonus > 0 OR
    // is not a valid object
    if (
        oTarget == OBJECT_INVALID ||
        !isClubOrQuarterstaff(nBaseItemType) ||
        !IsMaterialWooden(nMaterialType) ||
        nCurrentEnhancement > 0
    ) {
        SendMessageToPC(oCaster, "Spell target must be a club or quarterstaff that is wooden and non-magical.");
        return;
    }

    // Signal event successful
    SignalEvent(oTarget, EventSpellCastAt(oCaster, GetSpellId(), FALSE));

    nCasterLevel = ACR_GetCorrectCasterLevel(OBJECT_SELF);
    fDuration = ACR_GetSpellDuration(oCaster, ACR_DURATION_TYPE_PER_CL, ACR_DURATION_1M);

    // Create bonuses:
    //  +1 enhancement bonus
    //  +1d6 for weapon being 2 sizes larger
    ipBludgeon = ItemPropertyDamageBonus(IP_CONST_DAMAGETYPE_BLUDGEONING, IP_CONST_DAMAGEBONUS_1d6);
    ipEnhancement = ItemPropertyEnhancementBonus(1);

    // Add bonuses
    IPSafeAddItemProperty(oTarget, ipEnhancement, fDuration, X2_IP_ADDPROP_POLICY_REPLACE_EXISTING);
    IPSafeAddItemProperty(oTarget, ipBludgeon, fDuration, X2_IP_ADDPROP_POLICY_REPLACE_EXISTING);

    // Set up DelayCommand loop to remove bonus if owner no longer has the weapon
    DelayCommand(VERIFY_OWNER_POLL_DURATION, verify_owner(oCaster, oTarget, ipBludgeon, ipEnhancement));
}
