//::///////////////////////////////////////////////
//:: Magic Weapon
//:: X2_S0_MagcWeap
//:: Copyright (c) 2001 Bioware Corp.
//:://////////////////////////////////////////////
/*
  Grants a +1 enhancement bonus.
*/
//:://////////////////////////////////////////////
//:: Created By: Andrew Nobbs
//:: Created On: Nov 28, 2002
//:://////////////////////////////////////////////
//:: Updated by Andrew Nobbs May 08, 2003
//:: 2003-07-07: Stacking Spell Pass, Georg Zoeller
//:: 2003-07-17: Complete Rewrite to make use of Item Property System

#include "nw_i0_spells"
#include "x2_i0_spells"

#include "x2_inc_spellhook"


void AddEnhancementEffectToWeapon(object oMyWeapon, float fDuration)
{
    if(GetWeaponRanged(oMyWeapon) || GetBaseItemType(oMyWeapon) == BASE_ITEM_GLOVES)
    {
        IPSafeAddItemProperty(oMyWeapon,ItemPropertyAttackBonus(1), fDuration, X2_IP_ADDPROP_POLICY_KEEP_EXISTING ,TRUE,TRUE);
    }
    else if(IPGetIsMeleeWeapon(oMyWeapon))
    {
        IPSafeAddItemProperty(oMyWeapon,ItemPropertyEnhancementBonus(1), fDuration, X2_IP_ADDPROP_POLICY_KEEP_EXISTING ,TRUE,TRUE);
    }
    else
    {
        FloatingTextStrRefOnCreature(83615, OBJECT_SELF);
        return;
    }
    return;
}

void main()
{
    if (!X2PreSpellCastCode())
        return;

    effect eDur = EffectVisualEffect( VFX_DUR_SPELL_MAGIC_WEAPON );
    int nDuration = GetCasterLevel(OBJECT_SELF);
    int nMetaMagic = GetMetaMagicFeat();

    object oTarget = GetSpellTargetObject();
    object oMyWeapon = OBJECT_INVALID;
    if(GetObjectType(oTarget) == OBJECT_TYPE_CREATURE)
    {
        oMyWeapon = GetItemInSlot(INVENTORY_SLOT_RIGHTHAND, oTarget);
        if(!GetIsObjectValid(oMyWeapon))
            oMyWeapon = GetItemInSlot(INVENTORY_SLOT_ARMS, oTarget);
    }
    else
        oMyWeapon = oTarget;

    if (nMetaMagic == METAMAGIC_EXTEND)
        nDuration = nDuration * 2; //Duration is +100%

    if(GetIsObjectValid(oMyWeapon) )
    {
        SignalEvent(GetItemPossessor(oMyWeapon), EventSpellCastAt(OBJECT_SELF, GetSpellId(), FALSE));

        if (nDuration>0)
        {
            ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eDur, GetItemPossessor(oMyWeapon), HoursToSeconds(nDuration));
            AddEnhancementEffectToWeapon(oMyWeapon, HoursToSeconds(nDuration));
        }
        return;
    }
    else
    {
        FloatingTextStrRefOnCreature(83615, OBJECT_SELF);
        return;
    }
}