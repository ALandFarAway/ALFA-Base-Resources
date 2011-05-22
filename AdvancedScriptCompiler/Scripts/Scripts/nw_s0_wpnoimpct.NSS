//::///////////////////////////////////////////////
//:: Weapon of Impact
//:: X2_S0_WpnOImpct
//:://////////////////////////////////////////////
/*
  Adds the keen property to one Blunt melee weapon,
  increasing its critical threat range.
*/
//:://////////////////////////////////////////////
//:: Created By: Jesse Reynolds (JLR - OEI)
//:: Created On: June 12, 2005
//:://////////////////////////////////////////////
//:: Updated by Andrew Nobbs May 08, 2003
//:: 2003-07-07: Stacking Spell Pass, Georg Zoeller
//:: 2003-07-17: Complete Rewrite to make use of Item Property System


// JLR - OEI 08/24/05 -- Metamagic changes
// PMills - OEI 07.07.06 -- VFX pass
#include "nwn2_inc_spells"


#include "nw_i0_spells"
#include "x2_i0_spells"

#include "x2_inc_spellhook"


void  AddKeenEffectToWeapon(object oMyWeapon, float fDuration)
{
   IPSafeAddItemProperty(oMyWeapon,ItemPropertyKeen(), fDuration, X2_IP_ADDPROP_POLICY_KEEP_EXISTING ,TRUE,TRUE);
   IPSafeAddItemProperty(oMyWeapon, ItemPropertyVisualEffect(ITEM_VISUAL_HOLY), fDuration,X2_IP_ADDPROP_POLICY_REPLACE_EXISTING,FALSE,TRUE );
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
    //effect eVis = EffectVisualEffect(VFX_IMP_SUPER_HEROISM);//NWN1 VFX
    //effect eDur = EffectVisualEffect(VFX_DUR_CESSATE_POSITIVE);// NWN1 VFX
    effect eDur = EffectVisualEffect(VFX_DUR_SPELL_WEAPON_OF_IMPACT);// NWN2 VFX
    float fDuration = TurnsToSeconds(10 * GetCasterLevel(OBJECT_SELF));

    object oMyWeapon   =  IPGetTargetedOrEquippedMeleeWeapon();

    fDuration = ApplyMetamagicDurationMods(fDuration);
    int nDurType = ApplyMetamagicDurationTypeMods(DURATION_TYPE_TEMPORARY);

    if(GetIsObjectValid(oMyWeapon) )
    {
        SignalEvent(oMyWeapon, EventSpellCastAt(OBJECT_SELF, GetSpellId(), FALSE));

        if (GetBluntWeapon(oMyWeapon))
        {
            if (fDuration>0.0)
            {
                //ApplyEffectToObject(DURATION_TYPE_INSTANT, eVis, GetItemPossessor(oMyWeapon)); //NWN1 VFX
                ApplyEffectToObject(nDurType, eDur, GetItemPossessor(oMyWeapon), fDuration);
                AddKeenEffectToWeapon(oMyWeapon, fDuration);
            }
            return;
        }
        else
        {
          FloatingTextStrRefOnCreature(112038, OBJECT_SELF); // not a blunt weapon
          return;
        }
     }
     else

     {
          FloatingTextStrRefOnCreature(83615, OBJECT_SELF);
          return;
    }



}