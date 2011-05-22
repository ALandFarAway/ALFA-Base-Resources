//::///////////////////////////////////////////////
//:: Stormlord Elemental Weapons
//:: nx_s2_stormlordelementalweapons
//:: Copyright (c) 2007 Obsidian Entertainment, Inc.
//:://////////////////////////////////////////////
/*
	At 2nd level, a stormlord may enchant any equipped
	thrown weapon or spear to deal an additional 1d8
	points of electricity damage.  This effect lasts
	20 rounds.
	
	At 5th level, a stormlord may enchant any equipped
	thrown weapon or spear to deal an additional 1d8
	points of electricity damage and an extra 2d8 points
	of weapon damage on a critical hit (4d8 if the
	critical multiplier is x3, 6d8 if the critical
	multiplier is x4).  This effect lasts 20 rounds.	

	At 8th level, a stormlord may enchant any equipped
	thrown weapon or spear to deal an additional 1d8
	points of electricity damage, an extra 1d8 points
	of sonic damage, and an extra 2d8 points of weapon
	damage on a critical hit (4d8 if the critical
	multiplier is x3, 6d8 if the critical multiplier
	is x4).  This effect lasts 20 rounds.
*/
//:://////////////////////////////////////////////
//:: Created By: Andrew Woo (AFW-OEI)
//:: Created On: 03/22/2007
//:://////////////////////////////////////////////



#include "nw_i0_spells"
#include "x2_i0_spells"
#include "x2_inc_spellhook"

void main()
{
    if (!X2PreSpellCastCode())
    {   // If code within the PreSpellCastHook (i.e. UMD) reports FALSE, do not run this spell
        return;
    }

    //Declare major variables
    float fDuration = RoundsToSeconds(20);	// Always lasts 20 rounds.

	// Make sure that a thrown weapon or spear is equipped.
	object oTarget = GetSpellTargetObject();
	object oWeapon = GetItemInSlot(INVENTORY_SLOT_RIGHTHAND, oTarget);
	if (GetIsObjectValid(oWeapon))
	{
		int nItemType = GetBaseItemType(oWeapon);
		if (! ((nItemType == BASE_ITEM_DART) ||
			   (nItemType == BASE_ITEM_SHURIKEN) ||
			   (nItemType == BASE_ITEM_THROWINGAXE) ||
			   (nItemType == BASE_ITEM_SPEAR)) )
		{
			oWeapon = OBJECT_INVALID;
		}
	} 

    if(GetIsObjectValid(oWeapon) )
    {
        SignalEvent(GetItemPossessor(oWeapon), EventSpellCastAt(OBJECT_SELF, GetSpellId(), FALSE));
		
		// AFW-OEI 06/27/2007: Add a "cast" effect.
		effect eCast = EffectVisualEffect(VFX_SPELL_HIT_CALL_LIGHTNING);
		ApplyEffectToObject( DURATION_TYPE_INSTANT, eCast, OBJECT_SELF);
		
		if (GetHasFeat(FEAT_STORMLORD_SHOCK_WEAPON, OBJECT_SELF, TRUE))
		{
			//SpeakString("nx_s2_stormlordelementalweapons: Has FEAT_STORMLORD_SHOCK_WEAPON");
   			IPSafeAddItemProperty(oWeapon, ItemPropertyDamageBonus(IP_CONST_DAMAGETYPE_ELECTRICAL, IP_CONST_DAMAGEBONUS_1d8),
						  		  fDuration, X2_IP_ADDPROP_POLICY_REPLACE_EXISTING, FALSE, FALSE);
		}
		
		if (GetHasFeat(FEAT_STORMLORD_SHOCKING_BURST_WEAPON, OBJECT_SELF, TRUE))
		{
			//SpeakString("nx_s2_stormlordelementalweapons: Has FEAT_STORMLORD_SHOCKING_BURST_WEAPON");
   			IPSafeAddItemProperty(oWeapon, ItemPropertyMassiveCritical(IP_CONST_DAMAGEBONUS_2d8),
								  fDuration, X2_IP_ADDPROP_POLICY_REPLACE_EXISTING, FALSE, TRUE);
		}
		
		if (GetHasFeat(FEAT_STORMLORD_SONIC_WEAPON, OBJECT_SELF, TRUE))
		{
			//SpeakString("nx_s2_stormlordelementalweapons: Has FEAT_STORMLORD_SONIC_WEAPON");
   			IPSafeAddItemProperty(oWeapon, ItemPropertyDamageBonus(IP_CONST_DAMAGETYPE_SONIC, IP_CONST_DAMAGEBONUS_1d8),
						  		  fDuration, X2_IP_ADDPROP_POLICY_REPLACE_EXISTING, FALSE, FALSE);
		}
		
        return;
    }
    else
    {
	    FloatingTextStrRefOnCreature(186129, OBJECT_SELF);	// *Spell Failed - Must have a thrown weapon or spear equipped.*
	    return;
    }
}