//::///////////////////////////////////////////////
//:: Greater Magic Weapon
//:: X2_S0_GrMagWeap
//:: Copyright (c) 2001 Bioware Corp.
//:://////////////////////////////////////////////
/*
  Grants a +1 enhancement bonus per 3 caster levels
  (maximum of +5).
  lasts 1 hour per level
*/
//:://////////////////////////////////////////////
//:: Created By: Andrew Nobbs
//:: Created On: Nov 28, 2002
//:://////////////////////////////////////////////
//:: Updated by Andrew Nobbs May 08, 2003
//:: 2003-07-07: Stacking Spell Pass, Georg Zoeller
//:: 2003-07-17: Complete Rewrite to make use of Item Property System

// JLR - OEI 07/11/05 NWN2 3.5


#include "nw_i0_spells"
#include "x2_i0_spells"

#include "x2_inc_spellhook"

void AddEnhancementEffectToWeapon(object oMyWeapon, float fDuration, int nBonus)
{
    if(GetWeaponRanged(oMyWeapon) || GetBaseItemType(oMyWeapon) == BASE_ITEM_GLOVES)
    {
        IPSafeAddItemProperty(oMyWeapon,ItemPropertyAttackBonus(nBonus), fDuration, X2_IP_ADDPROP_POLICY_KEEP_EXISTING,FALSE,TRUE);
    }
    else if(IPGetIsMeleeWeapon(oMyWeapon))
    {
        IPSafeAddItemProperty(oMyWeapon,ItemPropertyEnhancementBonus(nBonus), fDuration, X2_IP_ADDPROP_POLICY_KEEP_EXISTING,FALSE,TRUE);
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
    int nBonus = GetCasterLevel(OBJECT_SELF) / 4;
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

    if(GetIsObjectValid(oMyWeapon))
    {
        SignalEvent(GetItemPossessor(oMyWeapon), EventSpellCastAt(OBJECT_SELF, GetSpellId(), FALSE));

        if (nDuration>0)
        {
            ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eDur, GetItemPossessor(oMyWeapon), HoursToSeconds(nDuration));
            AddEnhancementEffectToWeapon(oMyWeapon, HoursToSeconds(nDuration), nBonus);
        }
        return;
    }
    else
    {
        FloatingTextStrRefOnCreature(83615, OBJECT_SELF);
        return;
    }
}