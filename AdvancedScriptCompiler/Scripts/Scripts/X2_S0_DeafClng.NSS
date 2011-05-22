//::///////////////////////////////////////////////
//:: Deafening Clang
//:: X2_S0_DeafClng
//:: Copyright (c) 2001 Bioware Corp.
//:://////////////////////////////////////////////
/*
  Grants a +1 to attack and +3 bonus sonic damage to
  a weapon. Also the weapon will deafen on hit.
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


void  AddDeafeningClangEffectToWeapon(object oMyWeapon, float fDuration)
{
   IPSafeAddItemProperty(oMyWeapon,ItemPropertyAttackBonus(1), fDuration, X2_IP_ADDPROP_POLICY_KEEP_EXISTING ,TRUE,TRUE);
   IPSafeAddItemProperty(oMyWeapon,ItemPropertyDamageBonus(IP_CONST_DAMAGETYPE_SONIC, IP_CONST_DAMAGEBONUS_3), fDuration, X2_IP_ADDPROP_POLICY_REPLACE_EXISTING ,FALSE,TRUE);
   IPSafeAddItemProperty(oMyWeapon, ItemPropertyOnHitCastSpell(137, 5),fDuration,  X2_IP_ADDPROP_POLICY_KEEP_EXISTING, TRUE,FALSE);
   IPSafeAddItemProperty(oMyWeapon, ItemPropertyVisualEffect(ITEM_VISUAL_SONIC), fDuration,X2_IP_ADDPROP_POLICY_REPLACE_EXISTING,FALSE,TRUE );
   return;
}

void main()
{

    /*
      Spellcast Hook Code
      Added 2003-07-07 by Georg Zoeller
      If you want to make changes to all spells,
      check x2_inc_spellhook.nss to find out more

    */

    if (!X2PreSpellCastCode())
    {
    // If code within the PreSpellCastHook (i.e. UMD) reports FALSE, do not run this spell
        return;
    }

// End of Spell Cast Hook



    //Declare major variables
    effect eVis = EffectVisualEffect(VFX_IMP_SUPER_HEROISM);
    effect eDur = EffectVisualEffect(VFX_DUR_CESSATE_POSITIVE);
    int nDuration = GetCasterLevel(OBJECT_SELF);
    int nMetaMagic = GetMetaMagicFeat();

     object oMyWeapon   =  IPGetTargetedOrEquippedMeleeWeapon();

    if (nMetaMagic == METAMAGIC_EXTEND)
    {
        nDuration = nDuration * 2; //Duration is +100%
    }
    if (nDuration == 0)
    {
      nDuration =1;
    }

    if(GetIsObjectValid(oMyWeapon) )
    {
        SignalEvent(GetItemPossessor(oMyWeapon), EventSpellCastAt(OBJECT_SELF, GetSpellId(), FALSE));

        if (nDuration>0)
        {

            ApplyEffectToObject(DURATION_TYPE_INSTANT, eVis, GetItemPossessor(oMyWeapon));
            ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eDur, GetItemPossessor(oMyWeapon), RoundsToSeconds(nDuration));
            AddDeafeningClangEffectToWeapon(oMyWeapon, RoundsToSeconds(nDuration));
    }
        return;
    }
        else
    {
           FloatingTextStrRefOnCreature(83615, OBJECT_SELF);
           return;
    }

}
