//::///////////////////////////////////////////////
//:: Alchemists fire
//:: x0_s3_alchem
//:: Copyright (c) 2002 Bioware Corp.
//:://////////////////////////////////////////////
/*
    Grenade.
    Fires at a target. If hit, the target takes
    direct damage. If missed, all enemies within
    an area of effect take splash damage.

    HOWTO:
    - If target is valid attempt a hit
       - If miss then MISS
       - If hit then direct damage
    - If target is invalid or MISS
       - have area of effect near target
       - everyone in area takes splash damage
*/
//:://////////////////////////////////////////////
//:: Created By: Brent
//:: Created On: September 10, 2002
//:://////////////////////////////////////////////
//:: GZ: Can now be used to coat a weapon with fire.
//:: RPGplayer1 03/19/2008: Damage bonus to weapons will depend from strength of alchemist fire

#include "X2_I0_SPELLS"
#include "x2_inc_itemprop"
#include "x2_inc_spellhook"

void AddFlamingEffectToWeapon(object oTarget, float fDuration)
{
    //forget the fancy on-hit spell and just go with elemental damage item property.
    int nBonus = IP_CONST_DAMAGEBONUS_1d4;
    object oItem = GetSpellCastItem();
    string sTag = GetStringLowerCase(GetTag(oItem));

    if (sTag == "n2_it_alch_2")
    {
        nBonus = IP_CONST_DAMAGEBONUS_1d6;
    }
    else if (sTag == "n2_it_alch_3")
    {
        nBonus = IP_CONST_DAMAGEBONUS_1d8;
    }
    else if (sTag == "n2_it_alch_4")
    {
        nBonus = IP_CONST_DAMAGEBONUS_1d10;
    }
    itemproperty ipFlame = ItemPropertyDamageBonus(IP_CONST_DAMAGETYPE_FIRE, nBonus);

   // If the spell is cast again, any previous itemproperties matching are removed.
   //IPSafeAddItemProperty(oTarget, ItemPropertyOnHitCastSpell(124,1), fDuration, X2_IP_ADDPROP_POLICY_REPLACE_EXISTING);
   IPSafeAddItemProperty(oTarget, ipFlame, fDuration, X2_IP_ADDPROP_POLICY_REPLACE_EXISTING);
   IPSafeAddItemProperty(oTarget, ItemPropertyVisualEffect(ITEM_VISUAL_FIRE), fDuration,X2_IP_ADDPROP_POLICY_REPLACE_EXISTING,FALSE,TRUE);
   return;
}

void main()
{
    effect eVis = EffectVisualEffect(VFX_COM_HIT_FIRE);
    effect eDur = EffectVisualEffect(VFX_DUR_CESSATE_POSITIVE);
    object oTarget = GetSpellTargetObject();
    object oMyWeapon;
    int nTarget = GetObjectType(oTarget);
    int nDuration = 4;
    int nCasterLvl = 1;

    if(nTarget == OBJECT_TYPE_ITEM)
    {
        oMyWeapon = oTarget;
        int nItem = IPGetIsMeleeWeapon(oMyWeapon);
        if(nItem == TRUE)
        {
            if(GetIsObjectValid(oMyWeapon))
            {
                SignalEvent(OBJECT_SELF, EventSpellCastAt(OBJECT_SELF, GetSpellId(), FALSE));

                if (nDuration > 0)
                {
                    // haaaack: store caster level on item for the on hit spell to work properly
                    SetLocalInt(oMyWeapon,"X2_SPELL_CLEVEL_FLAMING_WEAPON",nCasterLvl);
                    ApplyEffectToObject(DURATION_TYPE_INSTANT, eVis, GetItemPossessor(oMyWeapon));
                    ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eDur, GetItemPossessor(oMyWeapon), RoundsToSeconds(nDuration));
                    AddFlamingEffectToWeapon(oMyWeapon, RoundsToSeconds(nDuration));
                }
                    return;
            }
        }
        else
        {
            FloatingTextStrRefOnCreature(100944,OBJECT_SELF);
        }
    }
    else if(nTarget == OBJECT_TYPE_CREATURE || OBJECT_TYPE_DOOR || OBJECT_TYPE_PLACEABLE)
    {
		object oItem = GetSpellCastItem();
		string sTag = GetStringLowerCase(GetTag(oItem));
		
		int nDmg = 0;
		int nSplashDmg = 0;
		
		if (sTag == "x1_wmgrenade002")
		{
			nDmg = d6(1);
			nSplashDmg = 1;
		}
		else if (sTag == "n2_it_alch_2")
		{
			nDmg = d8(1);
			nSplashDmg = 2;
		}
		else if (sTag == "n2_it_alch_3")
		{
			nDmg = d10(1);
			nSplashDmg = d4(1);
		}
		else if (sTag == "n2_it_alch_4")
		{
			nDmg = d6(2);
			nSplashDmg = d4(1) + 1;
		}
        DoGrenade(nDmg,nSplashDmg,VFX_HIT_SPELL_FIRE,VFX_HIT_AOE_FIRE,DAMAGE_TYPE_FIRE,RADIUS_SIZE_HUGE, OBJECT_TYPE_CREATURE | OBJECT_TYPE_DOOR | OBJECT_TYPE_PLACEABLE);
    }
}