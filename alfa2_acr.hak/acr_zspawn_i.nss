#ifndef ACR_ZSPAWN_I
#define ACR_ZSPAWN_I

#include "acr_vanity_i"

// This function returns the polymorph effect number
// to produce a dummy effect that will shift a target
// creature to nRacialType
// No error handling. Look to racialtypes.2da and polymorph.2da to
// debug.
int RacialTypeToPolymorph(int nRacialType);

// This function returns a new creature of class
// nClass made from the template.
// Returns -1 on error.
object CreateCreatureOfClass(int nClass, int nGender, location lTarget);

// This function translates nClass into the ALFA NPC levelup scheme
// which will build a creature with a focus on group compatibility
// instead of individual power. For use with CreateCreatureOfClass
// ideally.
// Returns -1 on error.
int GetPackageForClass(int nClass);

// This function seeks to equip oCreature based on
// the associated equipment item, or, in the case
// of items not accounted for in the equipment
// item, with generic gear based on character class.
void EquipCreature(object oCreature, int nGear, object oContainer);

void SetAlignment(object oCreature, int nAlignment);

void ArmorToLevel(object oArmor, int nLevel);
void WeaponToLevel(object oWeapon, int nLevel);
void HelmetToLevel(object oHelmet, int nLevel);
void CloakToLevel(object oCloak, int nLevel);
void AmuletToLevel(object oAmulet, int nLevel);
void RingOneToLevel(object oRing, int nLevel);
void RingTwoToLevel(object oRing, int nLevel);
void GlovesToLevel(object oGloves, int nLevel);
void BootsToLevel(object oBoots, int nLevel);
void BeltToLevel(object oBelt, int nLevel);

int GEAR_KIT_NONE     = 0;
int GEAR_KITM_MUNDANE = 1;
int GEAR_KITM_LOW     = 2;
int GEAR_KITM_NORMAL  = 3;
int GEAR_KITS_MUNDANE = 4;
int GEAR_KITS_LOW     = 5;
int GEAR_KITS_NORMAL  = 6;

int RacialTypeToPolymorph(int nRacialType)
{
/* 
	Yes, it's vulnerable, but this will be valid for all
	RACIAL_TYPE_ constants.
*/	
	return (nRacialType + 162);
}

object CreateCreatureOfClass(int nClass, int nGender, location lTarget)
{
	string sSpawn = "acr_zspawn_";
	switch(nClass)
	{
		case CLASS_TYPE_BARBARIAN:     sSpawn += "brb_"; break;
		case CLASS_TYPE_BARD:          sSpawn += "brd_"; break;
		case CLASS_TYPE_CLERIC:        sSpawn += "clr_"; break;
		case CLASS_TYPE_COMMONER:      sSpawn += "com_"; break;
		case CLASS_TYPE_DRUID:         sSpawn += "drd_"; break;
		case CLASS_TYPE_FIGHTER:       sSpawn += "ftr_"; break;
		case CLASS_TYPE_FAVORED_SOUL:  sSpawn += "fvs_"; break;
		case CLASS_TYPE_MONK:          sSpawn += "mnk_"; break;
		case CLASS_TYPE_PALADIN:       sSpawn += "pal_"; break;
		case CLASS_TYPE_RANGER:        sSpawn += "rgr_"; break;
		case CLASS_TYPE_ROGUE:         sSpawn += "rog_"; break;
		case CLASS_TYPE_SPIRIT_SHAMAN: sSpawn += "sha_"; break;
		case CLASS_TYPE_SORCERER:      sSpawn += "sor_"; break;
		case CLASS_TYPE_SWASHBUCKLER:  sSpawn += "sws_"; break;
		case CLASS_TYPE_UNDEAD:        sSpawn += "und_"; break;
		case CLASS_TYPE_WARLOCK:       sSpawn += "war_"; break;
		case CLASS_TYPE_WIZARD:        sSpawn += "wiz_"; break;
		case CLASS_TYPE_HUMANOID:      sSpawn += "wrr_"; break;
		default: SendMessageToAllDMs("acr_zspawns_i error: cannot find class."); return OBJECT_INVALID; break;
	}	
	if(nGender == GENDER_FEMALE) sSpawn += "f";
	else                        sSpawn += "m";
	object oCreature = CreateObject(OBJECT_TYPE_CREATURE, sSpawn, lTarget);
	if(oCreature == OBJECT_INVALID)
		SendMessageToAllDMs("acr_spawns_i error: failed to create creature");
	return oCreature;
}

int GetPackageForClass(int nClass)
{
	switch(nClass)
	{
		case CLASS_TYPE_BARBARIAN:     return 207; break;
		case CLASS_TYPE_BARD:          return 208; break;
		case CLASS_TYPE_CLERIC:        return 209; break;
		case CLASS_TYPE_COMMONER:      return 223; break;
		case CLASS_TYPE_DRUID:         return 210; break;
		case CLASS_TYPE_FIGHTER:       return 212; break;
		case CLASS_TYPE_FAVORED_SOUL:  return 211; break;
		case CLASS_TYPE_MONK:          return 213; break;
		case CLASS_TYPE_PALADIN:       return 214; break;
		case CLASS_TYPE_RANGER:        return 215; break;
		case CLASS_TYPE_ROGUE:         return 216; break;
		case CLASS_TYPE_SPIRIT_SHAMAN: return 218; break;
		case CLASS_TYPE_SORCERER:      return 217; break;
		case CLASS_TYPE_SWASHBUCKLER:  return 219; break;
		case CLASS_TYPE_UNDEAD:        return 224; break;
		case CLASS_TYPE_WARLOCK:       return 220; break;
		case CLASS_TYPE_WIZARD:        return 221; break;
		case CLASS_TYPE_HUMANOID:      return 222; break;
		default: SendMessageToAllDMs("acr_zspawns_i error: no package exists for that class."); return -1; break;	
	}
	return -1;
}

void EquipCreature(object oCreature, int nGear, object oContainer)
{
	int bCustomGear = FALSE;
	int bRingEquipped = FALSE;
	object oCopyItem = GetFirstItemInInventory(oContainer);
	while(GetIsObjectValid(oCopyItem))
	{
		bCustomGear = TRUE;
		oCopyItem = CopyItem(oCopyItem, oCreature);

		if (oCopyItem == OBJECT_INVALID)
		{
			oCopyItem = GetNextItemInInventory(oContainer);
			continue;
		}

		int nItemType = GetBaseItemType(oCopyItem);
		if(nItemType == BASE_ITEM_AMULET)
			AssignCommand(oCreature, ActionEquipItem(oCopyItem, INVENTORY_SLOT_NECK));
		else if(nItemType == BASE_ITEM_ARMOR)
			AssignCommand(oCreature, ActionEquipItem(oCopyItem, INVENTORY_SLOT_CHEST));
		else if(nItemType == BASE_ITEM_ARROW)
			AssignCommand(oCreature, ActionEquipItem(oCopyItem, INVENTORY_SLOT_ARROWS));
		else if(nItemType == BASE_ITEM_BASTARDSWORD ||
                        nItemType == BASE_ITEM_BATTLEAXE ||
                        nItemType == BASE_ITEM_CLUB ||
			nItemType == BASE_ITEM_DAGGER ||
			nItemType == BASE_ITEM_DART ||
			nItemType == BASE_ITEM_DIREMACE ||
			nItemType == BASE_ITEM_DOUBLEAXE ||
			nItemType == BASE_ITEM_DRUM ||
			nItemType == BASE_ITEM_DWARVENWARAXE ||
			nItemType == BASE_ITEM_FALCHION ||
			nItemType == BASE_ITEM_FLAIL ||
			nItemType == BASE_ITEM_FLUTE ||
			nItemType == BASE_ITEM_GREATAXE ||
			nItemType == BASE_ITEM_GREATCLUB ||
			nItemType == BASE_ITEM_HALBERD ||
			nItemType == BASE_ITEM_HANDAXE ||
			nItemType == BASE_ITEM_HEAVYCROSSBOW ||
			nItemType == BASE_ITEM_HEAVYFLAIL ||
			nItemType == BASE_ITEM_KAMA ||
			nItemType == BASE_ITEM_KATANA ||
			nItemType == BASE_ITEM_KUKRI ||
			nItemType == BASE_ITEM_LIGHTCROSSBOW ||
			nItemType == BASE_ITEM_LIGHTFLAIL ||
			nItemType == BASE_ITEM_LIGHTHAMMER ||
			nItemType == BASE_ITEM_LIGHTMACE ||
			nItemType == BASE_ITEM_LONGBOW ||
			nItemType == BASE_ITEM_LONGSWORD ||
			nItemType == BASE_ITEM_MACE ||
			nItemType == BASE_ITEM_MAGICSTAFF || 
			nItemType == BASE_ITEM_MANDOLIN ||
			nItemType == BASE_ITEM_MORNINGSTAR ||
			nItemType == BASE_ITEM_QUARTERSTAFF ||
			nItemType == BASE_ITEM_RAPIER ||
			nItemType == BASE_ITEM_SCIMITAR ||
			nItemType == BASE_ITEM_SHORTBOW ||
			nItemType == BASE_ITEM_SHORTSPEAR ||
			nItemType == BASE_ITEM_SHORTSWORD ||
			nItemType == BASE_ITEM_SHURIKEN ||
			nItemType == BASE_ITEM_SICKLE ||
			nItemType == BASE_ITEM_SLING ||
			nItemType == BASE_ITEM_SPEAR ||
			nItemType == BASE_ITEM_THROWINGAXE ||
			nItemType == BASE_ITEM_TRAINING_CLUB ||
			nItemType == BASE_ITEM_TWOBLADEDSWORD ||
			nItemType == BASE_ITEM_WARHAMMER ||
			nItemType == BASE_ITEM_WARMACE ||
			nItemType == BASE_ITEM_WHIP)
			AssignCommand(oCreature, ActionEquipItem(oCopyItem, INVENTORY_SLOT_RIGHTHAND));
		else if(nItemType == BASE_ITEM_BELT)
			AssignCommand(oCreature, ActionEquipItem(oCopyItem, INVENTORY_SLOT_BELT));
		else if(nItemType == BASE_ITEM_BOLT)
			AssignCommand(oCreature, ActionEquipItem(oCopyItem, INVENTORY_SLOT_BOLTS));
		else if(nItemType == BASE_ITEM_BOOTS)
			AssignCommand(oCreature, ActionEquipItem(oCopyItem, INVENTORY_SLOT_BOOTS));
		else if(nItemType == BASE_ITEM_BRACER ||
			nItemType == BASE_ITEM_GLOVES)
			AssignCommand(oCreature, ActionEquipItem(oCopyItem, INVENTORY_SLOT_ARMS));
		else if(nItemType == BASE_ITEM_BULLET)
			AssignCommand(oCreature, ActionEquipItem(oCopyItem, INVENTORY_SLOT_BULLETS));
		else if(nItemType == BASE_ITEM_CLOAK)
			AssignCommand(oCreature, ActionEquipItem(oCopyItem, INVENTORY_SLOT_CLOAK));
		else if(nItemType == BASE_ITEM_HELMET)
			AssignCommand(oCreature, ActionEquipItem(oCopyItem, INVENTORY_SLOT_HEAD));
		else if(nItemType == BASE_ITEM_LARGESHIELD ||
			nItemType == BASE_ITEM_TOWERSHIELD ||
			nItemType == BASE_ITEM_SMALLSHIELD)
			AssignCommand(oCreature, ActionEquipItem(oCopyItem, INVENTORY_SLOT_LEFTHAND));
		else if(nItemType == BASE_ITEM_RING)
		{
			if(bRingEquipped)
				AssignCommand(oCreature, ActionEquipItem(oCopyItem, INVENTORY_SLOT_LEFTRING));
			else
			{
				AssignCommand(oCreature, ActionEquipItem(oCopyItem, INVENTORY_SLOT_RIGHTRING));
				bRingEquipped = TRUE;
			}
		}
		else
		{
			// This might be a consumable or other item that was desired to be
			// transferred to the target creature's inventory.
		}

		oCopyItem = GetNextItemInInventory(oContainer);
	}
//=== If the creature doesn't use equipment, return early. No business ===//
//=== being here.                                                      ===//	
	if(nGear == GEAR_KIT_NONE || bCustomGear == TRUE)
		return;

	int nArmor = 8; // start with full plate and peel down
	if(GetLevelByClass(CLASS_TYPE_BARBARIAN, oCreature) && nArmor > 5)
		nArmor = 5;
	if(GetLevelByClass(CLASS_TYPE_BARD, oCreature) && nArmor > 4)
		nArmor = 4;
	if(GetLevelByClass(CLASS_TYPE_COMMONER, oCreature) && nArmor > 0)
		nArmor = 0;
	if(GetLevelByClass(CLASS_TYPE_DRUID, oCreature) && nArmor > 3)
		nArmor = 3;
	if(GetLevelByClass(CLASS_TYPE_FAVORED_SOUL, oCreature) && nArmor > 5)
		nArmor = 5;
	if(GetLevelByClass(CLASS_TYPE_MONK, oCreature) && nArmor > 0)
		nArmor = 0;
	if(GetLevelByClass(CLASS_TYPE_RANGER, oCreature) && nArmor > 4)
		nArmor = 4;
	if(GetLevelByClass(CLASS_TYPE_ROGUE, oCreature) && nArmor > 2)
		nArmor = 2;
	if(GetLevelByClass(CLASS_TYPE_SPIRIT_SHAMAN, oCreature) && nArmor > 3)
		nArmor = 2;
	if(GetLevelByClass(CLASS_TYPE_SORCERER, oCreature) && nArmor > 0)
		nArmor = 0;
	if(GetLevelByClass(CLASS_TYPE_SWASHBUCKLER, oCreature) && nArmor > 4)
		nArmor = 4;
	if(GetLevelByClass(CLASS_TYPE_WARLOCK, oCreature) && nArmor > 4)
		nArmor = 4;
	if(GetLevelByClass(CLASS_TYPE_WIZARD, oCreature) && nArmor > 0)
		nArmor = 0;
	if(nArmor > 5 && GetHitDice(oCreature) < 3)
		nArmor = 5;
	if(nArmor > 4 && GetHitDice(oCreature) < 2)
		nArmor = 3;
	if(nGear == GEAR_KITM_LOW ||
	   nGear == GEAR_KITS_LOW)
        {
            if(nArmor > 4)
		nArmor = 3;
            else if(nArmor > 0)
                nArmor = 2;
        }
	int nLevel = GetHitDice(oCreature);
	if(nGear == GEAR_KITS_LOW ||
	   nGear == GEAR_KITM_LOW)
		nLevel = nLevel / 2;
	if(nGear == GEAR_KITS_MUNDANE ||
	   nGear == GEAR_KITM_MUNDANE)
	    nLevel = 1;
		
	int nShield = 0;
	if(GetLevelByClass(CLASS_TYPE_FIGHTER, oCreature))
	{
		if(nArmor == 8 && (nGear == GEAR_KITM_NORMAL || nGear == GEAR_KITM_LOW))
			nShield = 4;
		else
			nShield = 2;
	}
	else if(GetLevelByClass(CLASS_TYPE_CLERIC, oCreature) ||
		    GetLevelByClass(CLASS_TYPE_DRUID,  oCreature) ||
			GetLevelByClass(CLASS_TYPE_PALADIN, oCreature) ||
			GetLevelByClass(CLASS_TYPE_HUMANOID, oCreature))
		nShield = 2;
		
	object oMainHand;
	object oOffHand;
	if(GetLevelByClass(CLASS_TYPE_SWASHBUCKLER, oCreature) ||
	   GetLevelByClass(CLASS_TYPE_BARD, oCreature))
	{
		if(nGear == GEAR_KITM_NORMAL ||
		   nGear == GEAR_KITM_MUNDANE ||
		   nGear == GEAR_KITM_LOW)		   
			oMainHand = CreateItemOnObject("zitem_rapier", oCreature);
		else
			oMainHand = CreateItemOnObject("zitem_shsword", oCreature);
		if(GetLevelByClass(CLASS_TYPE_ROGUE, oCreature))
		{
			if(nGear == GEAR_KITM_NORMAL ||
			   nGear == GEAR_KITM_MUNDANE ||
			   nGear == GEAR_KITM_LOW)		
				oOffHand = CreateItemOnObject("zitem_shsword", oCreature);
			else
				oOffHand = CreateItemOnObject("zitem_dagger", oCreature);
			WeaponToLevel(oOffHand, nLevel);
		}
	}
	else if(GetLevelByClass(CLASS_TYPE_ROGUE, oCreature))
	{
		oMainHand = CreateItemOnObject("zitem_shsword", oCreature);
		if(!nShield)
		{
			if(nGear == GEAR_KITM_NORMAL ||
			   nGear == GEAR_KITM_MUNDANE ||
			   nGear == GEAR_KITM_LOW)		
				oOffHand = CreateItemOnObject("zitem_shsword", oCreature);
			else
				oOffHand = CreateItemOnObject("zitem_dagger", oCreature);
			WeaponToLevel(oOffHand, nLevel);
		}
	}
	else if(GetLevelByClass(CLASS_TYPE_FIGHTER, oCreature))
	{
		if(nGear == GEAR_KITM_NORMAL ||
		   nGear == GEAR_KITM_MUNDANE ||
		   nGear == GEAR_KITM_LOW)
			oMainHand = CreateItemOnObject("zitem_waraxe", oCreature);
		else
			oMainHand = CreateItemOnObject("zitem_haxe", oCreature);
	}
	else if(GetLevelByClass(CLASS_TYPE_PALADIN, oCreature) ||
			GetLevelByClass(CLASS_TYPE_HUMANOID, oCreature))
	{
		if(nGear == GEAR_KITM_NORMAL ||
		   nGear == GEAR_KITM_MUNDANE ||
		   nGear == GEAR_KITM_LOW)
			oMainHand = CreateItemOnObject("zitem_longsword", oCreature);
		else
			oMainHand = CreateItemOnObject("zitem_shsword", oCreature);
	}
	else if(GetLevelByClass(CLASS_TYPE_CLERIC, oCreature))
	{
		if(nGear == GEAR_KITM_NORMAL ||
		   nGear == GEAR_KITM_MUNDANE ||
		   nGear == GEAR_KITM_LOW)
			oMainHand = CreateItemOnObject("zitem_mstar", oCreature);
		else
			oMainHand = CreateItemOnObject("zitem_lmace", oCreature);
	}
	else if(GetLevelByClass(CLASS_TYPE_DRUID, oCreature))
		oMainHand = CreateItemOnObject("zitem_sickle", oCreature);
	else if(GetLevelByClass(CLASS_TYPE_BARBARIAN, oCreature) ||
			GetLevelByClass(CLASS_TYPE_UNDEAD, oCreature))
	{
		if(nGear == GEAR_KITM_NORMAL ||
		   nGear == GEAR_KITM_MUNDANE ||
		   nGear == GEAR_KITM_LOW)
			oMainHand = CreateItemOnObject("zitem_gsword", oCreature);
		else
			oMainHand = CreateItemOnObject("zitem_longsword", oCreature);
		nShield = -1;
	}
	else if(GetLevelByClass(CLASS_TYPE_MONK, oCreature))
		nShield = -1;
	else if(GetLevelByClass(CLASS_TYPE_SPIRIT_SHAMAN, oCreature) ||
			GetLevelByClass(CLASS_TYPE_FAVORED_SOUL, oCreature))
	{
		if(nGear == GEAR_KITM_NORMAL ||
		   nGear == GEAR_KITM_MUNDANE ||
		   nGear == GEAR_KITM_LOW)
			oMainHand = CreateItemOnObject("zitem_spear", oCreature);
		else
			oMainHand = CreateItemOnObject("zitem_club", oCreature);
		nShield = -1;
	}
	else if(GetLevelByClass(CLASS_TYPE_COMMONER, oCreature) ||
			GetLevelByClass(CLASS_TYPE_SORCERER, oCreature) ||
			GetLevelByClass(CLASS_TYPE_WARLOCK, oCreature) ||
			GetLevelByClass(CLASS_TYPE_WIZARD, oCreature))
	{
		if(nGear == GEAR_KITM_NORMAL ||
		   nGear == GEAR_KITM_MUNDANE ||
		   nGear == GEAR_KITM_LOW)		
			oMainHand = CreateItemOnObject("zitem_staff", oCreature);
		else
			oMainHand = CreateItemOnObject("zitem_club", oCreature);
		nShield = -1;
	}
	else if(GetLevelByClass(CLASS_TYPE_RANGER, oCreature))
	{
		if(nGear == GEAR_KITM_NORMAL ||
		   nGear == GEAR_KITM_MUNDANE ||
		   nGear == GEAR_KITM_LOW)	
			oMainHand = CreateItemOnObject("zitem_lbow", oCreature);
		else
			oMainHand = CreateItemOnObject("zitem_sbow", oCreature);
		object oArrows = CreateItemOnObject("nw_wamar001", oCreature, 99);
		AssignCommand(oCreature, ActionEquipItem(oArrows, INVENTORY_SLOT_ARROWS));
		nShield = -1;
	}
	
	WeaponToLevel(oMainHand, nLevel);
	SetIdentified(oMainHand, TRUE);
	SetDroppableFlag(oMainHand, FALSE);
	AssignCommand(oCreature, ActionEquipItem(oMainHand, INVENTORY_SLOT_RIGHTHAND));
	
	if(nShield == 2)
	{
		oOffHand = CreateItemOnObject("zitem_shield", oCreature);
		ArmorToLevel(oOffHand, nLevel);
	}
	else if(nShield == 4)
	{
		oOffHand = CreateItemOnObject("zitem_tshield", oCreature);
		ArmorToLevel(oOffHand, nLevel);
	}
	if(GetIsObjectValid(oOffHand))
	{
		SetIdentified(oOffHand, TRUE);
		SetDroppableFlag(oOffHand, FALSE);
		AssignCommand(oCreature, ActionEquipItem(oOffHand, INVENTORY_SLOT_LEFTHAND));
	}
	
	object oArmor;
	if(nArmor == 8)      oArmor = CreateItemOnObject("zitem_fullplate", oCreature);
	else if(nArmor == 5) oArmor = CreateItemOnObject("zitem_brplate", oCreature);
	else if(nArmor == 4) oArmor = CreateItemOnObject("zitem_chshirt", oCreature);
	else if(nArmor == 3) oArmor = CreateItemOnObject("zitem_hide", oCreature);
	else if(nArmor == 2) oArmor = CreateItemOnObject("zitem_leather", oCreature);
	else                 oArmor = CreateItemOnObject("zitem_robes", oCreature);
	ArmorToLevel(oArmor, nLevel);
	SetIdentified(oArmor, TRUE);
	SetDroppableFlag(oArmor, FALSE);
	AssignCommand(oCreature, ActionEquipItem(oArmor, INVENTORY_SLOT_CHEST));
	
	object oHelm;
	if(nArmor == 8) oHelm = CreateItemOnObject("zitem_helm8", oCreature);
	else            oHelm = CreateItemOnObject("zitem_helm2", oCreature);
	HelmetToLevel(oHelm, nLevel);
	SetIdentified(oHelm, TRUE);
	SetDroppableFlag(oHelm, FALSE);
	AssignCommand(oCreature, ActionEquipItem(oHelm, INVENTORY_SLOT_HEAD));
	
	object oGloves;
	if(nArmor >= 5) oGloves = CreateItemOnObject("zitem_glove8", oCreature);
	else            oGloves = CreateItemOnObject("zitem_glove2", oCreature);
	GlovesToLevel(oGloves, nLevel);
	SetIdentified(oGloves, TRUE);
	SetDroppableFlag(oGloves, FALSE);
	AssignCommand(oCreature, ActionEquipItem(oGloves, INVENTORY_SLOT_ARMS));
	
	object oBoots;
	if(nArmor >= 5) oBoots = CreateItemOnObject("zitem_boot8", oCreature);
	else            oBoots = CreateItemOnObject("zitem_boot2", oCreature);
	BootsToLevel(oBoots, nLevel);
	SetIdentified(oBoots, TRUE);
	SetDroppableFlag(oBoots, FALSE);
	AssignCommand(oCreature, ActionEquipItem(oBoots, INVENTORY_SLOT_BOOTS));
	
	object oBelt = CreateItemOnObject("zitem_belt", oCreature);
	BeltToLevel(oBelt, nLevel);
	SetIdentified(oBelt, TRUE);
	SetDroppableFlag(oBelt, FALSE);
	AssignCommand(oCreature, ActionEquipItem(oBelt, INVENTORY_SLOT_BELT));
	
	object oCloak = CreateItemOnObject("zitem_cloak", oCreature);
	CloakToLevel(oCloak, nLevel);
	SetIdentified(oCloak, TRUE);
	SetDroppableFlag(oCloak, FALSE);
	AssignCommand(oCreature, ActionEquipItem(oCloak, INVENTORY_SLOT_CLOAK));
	
	object oRing = CreateItemOnObject("nw_it_mring021", oCreature);
	object oRing2 = CreateItemOnObject("nw_it_mring021", oCreature);
	RingOneToLevel(oRing, nLevel);
	RingTwoToLevel(oRing2, nLevel);
	SetIdentified(oRing, TRUE);
	SetIdentified(oRing2, TRUE);
	SetDroppableFlag(oRing, FALSE);
	SetDroppableFlag(oRing2, FALSE);
	AssignCommand(oCreature, ActionEquipItem(oRing, INVENTORY_SLOT_LEFTRING));
	AssignCommand(oCreature, ActionEquipItem(oRing2, INVENTORY_SLOT_RIGHTRING));
	
	object oAmulet = CreateItemOnObject("nw_it_mneck020", oCreature);
	AmuletToLevel(oAmulet, nLevel);
	SetIdentified(oAmulet, TRUE);
	SetDroppableFlag(oAmulet, FALSE);
	AssignCommand(oCreature, ActionEquipItem(oAmulet, INVENTORY_SLOT_NECK));
}

void ArmorToLevel(object oArmor, int nLevel)
{
	if(nLevel >= 18)
		AddItemProperty(DURATION_TYPE_PERMANENT, ItemPropertyACBonus(5), oArmor);
	else if(nLevel >= 16)
		AddItemProperty(DURATION_TYPE_PERMANENT, ItemPropertyACBonus(4), oArmor);
	else if(nLevel >= 13)
		AddItemProperty(DURATION_TYPE_PERMANENT, ItemPropertyACBonus(3), oArmor);
	else if(nLevel >= 9)
		AddItemProperty(DURATION_TYPE_PERMANENT, ItemPropertyACBonus(2), oArmor);
	else if(nLevel >= 6)
		AddItemProperty(DURATION_TYPE_PERMANENT, ItemPropertyACBonus(1), oArmor);
}

void WeaponToLevel(object oWeapon, int nLevel)
{
	if(nLevel >= 17)
		AddItemProperty(DURATION_TYPE_PERMANENT, ItemPropertyEnhancementBonus(5), oWeapon);
	else if(nLevel >= 15)
		AddItemProperty(DURATION_TYPE_PERMANENT, ItemPropertyEnhancementBonus(4), oWeapon);
	else if(nLevel >= 13)
		AddItemProperty(DURATION_TYPE_PERMANENT, ItemPropertyEnhancementBonus(3), oWeapon);
	else if(nLevel >= 9)
		AddItemProperty(DURATION_TYPE_PERMANENT, ItemPropertyEnhancementBonus(2), oWeapon);
	else if(nLevel >= 5)
		AddItemProperty(DURATION_TYPE_PERMANENT, ItemPropertyEnhancementBonus(1), oWeapon);
}

void HelmetToLevel(object oHelmet, int nLevel)
{
	if(nLevel >= 19)
		AddItemProperty(DURATION_TYPE_PERMANENT, ItemPropertyAbilityBonus(IP_CONST_ABILITY_WIS, 6), oHelmet);
	else if(nLevel >= 16)
		AddItemProperty(DURATION_TYPE_PERMANENT, ItemPropertyAbilityBonus(IP_CONST_ABILITY_WIS, 4), oHelmet);
	else if(nLevel >= 11)
		AddItemProperty(DURATION_TYPE_PERMANENT, ItemPropertyAbilityBonus(IP_CONST_ABILITY_WIS, 2), oHelmet);
}

void CloakToLevel(object oCloak, int nLevel)
{
	if(nLevel >= 19)
		AddItemProperty(DURATION_TYPE_PERMANENT, ItemPropertyAbilityBonus(IP_CONST_ABILITY_CHA, 6), oCloak);
	else if(nLevel >= 16)
		AddItemProperty(DURATION_TYPE_PERMANENT, ItemPropertyAbilityBonus(IP_CONST_ABILITY_CHA, 4), oCloak);
	else if(nLevel >= 12)
		AddItemProperty(DURATION_TYPE_PERMANENT, ItemPropertyAbilityBonus(IP_CONST_ABILITY_CHA, 2), oCloak);
}

void AmuletToLevel(object oAmulet, int nLevel)
{
	if(nLevel >= 20)
		AddItemProperty(DURATION_TYPE_PERMANENT, ItemPropertyACBonus(5), oAmulet);
	else if(nLevel >= 17)
		AddItemProperty(DURATION_TYPE_PERMANENT, ItemPropertyACBonus(4), oAmulet);
	else if(nLevel >= 15)
		AddItemProperty(DURATION_TYPE_PERMANENT, ItemPropertyACBonus(3), oAmulet);
	else if(nLevel >= 11)
		AddItemProperty(DURATION_TYPE_PERMANENT, ItemPropertyACBonus(2), oAmulet);
	else if(nLevel >= 6)
		AddItemProperty(DURATION_TYPE_PERMANENT, ItemPropertyACBonus(1), oAmulet);
}

void RingOneToLevel(object oRing, int nLevel)
{
	if(nLevel >= 20)
		AddItemProperty(DURATION_TYPE_PERMANENT, ItemPropertyBonusSavingThrowVsX(IP_CONST_SAVEVS_UNIVERSAL, 5), oRing);
	else if(nLevel >= 17)
		AddItemProperty(DURATION_TYPE_PERMANENT, ItemPropertyBonusSavingThrowVsX(IP_CONST_SAVEVS_UNIVERSAL, 4), oRing);
	else if(nLevel >= 13)
		AddItemProperty(DURATION_TYPE_PERMANENT, ItemPropertyBonusSavingThrowVsX(IP_CONST_SAVEVS_UNIVERSAL, 3), oRing);
	else if(nLevel >= 10)
		AddItemProperty(DURATION_TYPE_PERMANENT, ItemPropertyBonusSavingThrowVsX(IP_CONST_SAVEVS_UNIVERSAL, 2), oRing);
	else if(nLevel >= 6)
		AddItemProperty(DURATION_TYPE_PERMANENT, ItemPropertyBonusSavingThrowVsX(IP_CONST_SAVEVS_UNIVERSAL, 1), oRing);
}

void RingTwoToLevel(object oRing, int nLevel)
{
	if(nLevel >= 20)
		AddItemProperty(DURATION_TYPE_PERMANENT, ItemPropertyACBonus(5), oRing);
	else if(nLevel >= 17)
		AddItemProperty(DURATION_TYPE_PERMANENT, ItemPropertyACBonus(4), oRing);
	else if(nLevel >= 15)
		AddItemProperty(DURATION_TYPE_PERMANENT, ItemPropertyACBonus(3), oRing);
	else if(nLevel >= 12)
		AddItemProperty(DURATION_TYPE_PERMANENT, ItemPropertyACBonus(2), oRing);
	else if(nLevel >= 4)
		AddItemProperty(DURATION_TYPE_PERMANENT, ItemPropertyACBonus(1), oRing);
}

void GlovesToLevel(object oGloves, int nLevel)
{
	if(nLevel >= 18)
		AddItemProperty(DURATION_TYPE_PERMANENT, ItemPropertyAbilityBonus(IP_CONST_ABILITY_STR, 6), oGloves);
	else if(nLevel >= 15)
		AddItemProperty(DURATION_TYPE_PERMANENT, ItemPropertyAbilityBonus(IP_CONST_ABILITY_STR, 4), oGloves);
	else if(nLevel >= 10)
		AddItemProperty(DURATION_TYPE_PERMANENT, ItemPropertyAbilityBonus(IP_CONST_ABILITY_STR, 2), oGloves);
}

void BootsToLevel(object oBoots, int nLevel)
{
	if(nLevel >= 18)
		AddItemProperty(DURATION_TYPE_PERMANENT, ItemPropertyAbilityBonus(IP_CONST_ABILITY_DEX, 6), oBoots);
	else if(nLevel >= 15)
		AddItemProperty(DURATION_TYPE_PERMANENT, ItemPropertyAbilityBonus(IP_CONST_ABILITY_DEX, 4), oBoots);
	else if(nLevel >= 10)
		AddItemProperty(DURATION_TYPE_PERMANENT, ItemPropertyAbilityBonus(IP_CONST_ABILITY_DEX, 2), oBoots);
}

void BeltToLevel(object oBelt, int nLevel)
{
	if(nLevel >= 18)
		AddItemProperty(DURATION_TYPE_PERMANENT, ItemPropertyAbilityBonus(IP_CONST_ABILITY_CON, 6), oBelt);
	else if(nLevel >= 14)
		AddItemProperty(DURATION_TYPE_PERMANENT, ItemPropertyAbilityBonus(IP_CONST_ABILITY_CON, 4), oBelt);
	else if(nLevel >= 7)
		AddItemProperty(DURATION_TYPE_PERMANENT, ItemPropertyAbilityBonus(IP_CONST_ABILITY_CON, 2), oBelt);
}

void UndeadEffects(object oCreature)
{
	ApplyEffectToObject(DURATION_TYPE_PERMANENT, SupernaturalEffect(EffectImmunity(IMMUNITY_TYPE_MIND_SPELLS)), oCreature);
	ApplyEffectToObject(DURATION_TYPE_PERMANENT, SupernaturalEffect(EffectImmunity(IMMUNITY_TYPE_POISON)), oCreature);
	ApplyEffectToObject(DURATION_TYPE_PERMANENT, SupernaturalEffect(EffectImmunity(IMMUNITY_TYPE_PARALYSIS)), oCreature);
	ApplyEffectToObject(DURATION_TYPE_PERMANENT, SupernaturalEffect(EffectImmunity(IMMUNITY_TYPE_STUN)), oCreature);
	ApplyEffectToObject(DURATION_TYPE_PERMANENT, SupernaturalEffect(EffectImmunity(IMMUNITY_TYPE_DISEASE)), oCreature);
	ApplyEffectToObject(DURATION_TYPE_PERMANENT, SupernaturalEffect(EffectImmunity(IMMUNITY_TYPE_DEATH)), oCreature);
	ApplyEffectToObject(DURATION_TYPE_PERMANENT, SupernaturalEffect(EffectImmunity(IMMUNITY_TYPE_CRITICAL_HIT)), oCreature);
	ApplyEffectToObject(DURATION_TYPE_PERMANENT, SupernaturalEffect(EffectImmunity(IMMUNITY_TYPE_DAMAGE_DECREASE)), oCreature);
	ApplyEffectToObject(DURATION_TYPE_PERMANENT, SupernaturalEffect(EffectImmunity(IMMUNITY_TYPE_NEGATIVE_LEVEL)), oCreature);
}

void IncorporealEffects(object oCreature)
{
	ApplyEffectToObject(DURATION_TYPE_PERMANENT, SupernaturalEffect(EffectDamageReduction(50, DAMAGE_POWER_PLUS_ONE, 0, DR_TYPE_MAGICBONUS)), oCreature);
	ApplyEffectToObject(DURATION_TYPE_PERMANENT, SupernaturalEffect(EffectConcealment(50)), oCreature);
	int nDeflection = GetAbilityModifier(ABILITY_CHARISMA, oCreature);
	if(nDeflection < 1) nDeflection = 1;
	ApplyEffectToObject(DURATION_TYPE_PERMANENT, SupernaturalEffect(EffectACIncrease(nDeflection, AC_DEFLECTION_BONUS)), oCreature);
	ApplyEffectToObject(DURATION_TYPE_PERMANENT, SupernaturalEffect(EffectSkillIncrease(SKILL_MOVE_SILENTLY, 50)), oCreature);
	ApplyEffectToObject(DURATION_TYPE_PERMANENT, SupernaturalEffect(EffectImmunity(IMMUNITY_TYPE_ENTANGLE)), oCreature);
	ApplyEffectToObject(DURATION_TYPE_PERMANENT, SupernaturalEffect(EffectImmunity(IMMUNITY_TYPE_KNOCKDOWN)), oCreature);
	FeatAdd(oCreature, FEAT_WEAPON_FINESSE, FALSE, FALSE, FALSE);
}
int SetRace(object oCreature, int nRace)
{
	if(nRace == 1) // dwarf
	{
		FeatRemove(oCreature, 258);
		FeatRemove(oCreature, 1773);
		
		FeatAdd(oCreature, 227, FALSE);
		FeatAdd(oCreature, 228, FALSE); //darkvision
		FeatAdd(oCreature, 229, FALSE);
		FeatAdd(oCreature, 230, FALSE);
		FeatAdd(oCreature, 231, FALSE);
		FeatAdd(oCreature, 232, FALSE);
		FeatAdd(oCreature, 233, FALSE);
		FeatAdd(oCreature, 234, FALSE);
		FeatAdd(oCreature, 1770, FALSE);
			
		SetCreatureAppearanceType(oCreature, 0);
		XPObjectAttributesSetRace(oCreature, RACIAL_TYPE_DWARF);
		XPObjectAttributesSetSubRace(oCreature, RACIAL_SUBTYPE_SHIELD_DWARF);
		ApplyEffectToObject(DURATION_TYPE_TEMPORARY, EffectPolymorph(162), oCreature, 1.0f);
		return GEAR_KITM_NORMAL;
	}
	else if(nRace == 2) // elf
	{
		FeatRemove(oCreature, 258);
		FeatRemove(oCreature, 1773);
		
		FeatAdd(oCreature, 235, FALSE);
		FeatAdd(oCreature, 236, FALSE);
		FeatAdd(oCreature, 237, FALSE);
		FeatAdd(oCreature, 238, FALSE);
		FeatAdd(oCreature, 239, FALSE);
		FeatAdd(oCreature, 240, FALSE);
		FeatAdd(oCreature, 256, FALSE);
		FeatAdd(oCreature, 354, FALSE); // low-light
				
		SetCreatureAppearanceType(oCreature, 1);
		XPObjectAttributesSetRace(oCreature, RACIAL_TYPE_ELF);
		XPObjectAttributesSetSubRace(oCreature, RACIAL_SUBTYPE_MOON_ELF);
		ApplyEffectToObject(DURATION_TYPE_TEMPORARY, EffectPolymorph(162), oCreature, 1.0f);	
		return GEAR_KITM_NORMAL;
	}
	else if(nRace == 3) // gnome
	{
		FeatRemove(oCreature, 258);
		FeatRemove(oCreature, 1773);
		
		FeatAdd(oCreature, 232, FALSE);
		FeatAdd(oCreature, 233, FALSE);
		FeatAdd(oCreature, 237, FALSE);
		FeatAdd(oCreature, 241, FALSE);
		FeatAdd(oCreature, 242, FALSE);
		FeatAdd(oCreature, 243, FALSE);
		FeatAdd(oCreature, 354, FALSE);
		FeatAdd(oCreature, 375, FALSE);
		FeatAdd(oCreature, 1795, FALSE);
		
		SetCreatureAppearanceType(oCreature, 2);
		XPObjectAttributesSetRace(oCreature, RACIAL_TYPE_GNOME);
		XPObjectAttributesSetSubRace(oCreature, RACIAL_SUBTYPE_ROCK_GNOME);
		ApplyEffectToObject(DURATION_TYPE_TEMPORARY, EffectPolymorph(162), oCreature, 1.0f);	
		return GEAR_KITS_NORMAL;
	}
	else if(nRace == 4) // half elf
	{
		FeatRemove(oCreature, 258);
		FeatRemove(oCreature, 1773);
		
		FeatAdd(oCreature, 235, FALSE);
		FeatAdd(oCreature, 236, FALSE);
		FeatAdd(oCreature, 244, FALSE);
		FeatAdd(oCreature, 245, FALSE);
		FeatAdd(oCreature, 246, FALSE);
		FeatAdd(oCreature, 354, FALSE);
		FeatAdd(oCreature, 1096, FALSE);
		FeatAdd(oCreature, 1097, FALSE);
		
		SetCreatureAppearanceType(oCreature, 4);
		XPObjectAttributesSetRace(oCreature, RACIAL_TYPE_HALFELF);
		XPObjectAttributesSetSubRace(oCreature, RACIAL_SUBTYPE_HALFELF);
		ApplyEffectToObject(DURATION_TYPE_TEMPORARY, EffectPolymorph(162), oCreature, 1.0f);	
		return GEAR_KITM_NORMAL;
	}
	else if(nRace == 5) // halfling
	{
		FeatRemove(oCreature, 258);
		FeatRemove(oCreature, 1773);
		
		FeatAdd(oCreature, 237, FALSE);
		FeatAdd(oCreature, 247, FALSE);
		FeatAdd(oCreature, 248, FALSE);
		FeatAdd(oCreature, 249, FALSE);
		FeatAdd(oCreature, 250, FALSE);
		FeatAdd(oCreature, 375, FALSE);
			
		SetCreatureAppearanceType(oCreature, 3);
		XPObjectAttributesSetRace(oCreature, RACIAL_TYPE_HALFLING);
		XPObjectAttributesSetSubRace(oCreature, RACIAL_SUBTYPE_LIGHTFOOT_HALF);
		ApplyEffectToObject(DURATION_TYPE_TEMPORARY, EffectPolymorph(162), oCreature, 1.0f);	
		return GEAR_KITS_NORMAL;
	}
	else if(nRace == 6) // half-orc
	{
		FeatRemove(oCreature, 258);
		FeatRemove(oCreature, 1773);
		
		FeatAdd(oCreature, 228, FALSE); // darkvision
						
		SetCreatureAppearanceType(oCreature, 5);
		XPObjectAttributesSetRace(oCreature, RACIAL_TYPE_HALFORC);
		XPObjectAttributesSetSubRace(oCreature, RACIAL_SUBTYPE_HALFORC);
		ApplyEffectToObject(DURATION_TYPE_TEMPORARY, EffectPolymorph(162), oCreature, 1.0f);	
		return GEAR_KITM_NORMAL;
	}
	else if(nRace == 7) // human
	{
		return GEAR_KITM_NORMAL;
//== We don't actually need to do anything. Human is default ==//
	}
	else if(nRace == 9) // goblin
	{
		FeatRemove(oCreature, 258);
		FeatRemove(oCreature, 1773);
		
		FeatAdd(oCreature, 228, FALSE); // darkvision
		FeatAdd(oCreature, 375, FALSE); // small
		
		SetBaseAbilityScore(oCreature, ABILITY_DEXTERITY,
			GetAbilityScore(oCreature, ABILITY_DEXTERITY, TRUE) + 2);
		SetBaseAbilityScore(oCreature, ABILITY_STRENGTH,
			GetAbilityScore(oCreature, ABILITY_STRENGTH, TRUE) - 2);
		SetBaseAbilityScore(oCreature, ABILITY_CHARISMA,
			GetAbilityScore(oCreature, ABILITY_CHARISMA, TRUE) - 2);
		
		ApplyEffectToObject(DURATION_TYPE_PERMANENT, SupernaturalEffect(EffectSkillIncrease(SKILL_RIDE, 4)), oCreature);
		ApplyEffectToObject(DURATION_TYPE_PERMANENT, SupernaturalEffect(EffectSkillIncrease(SKILL_MOVE_SILENTLY, 4)), oCreature);
			
		SetCreatureAppearanceType(oCreature, 534);
		XPObjectAttributesSetRace(oCreature, RACIAL_TYPE_HUMANOID_GOBLINOID);
		XPObjectAttributesSetSubRace(oCreature, RACIAL_SUBTYPE_HUMANOID_GOBLINOID);
		ApplyEffectToObject(DURATION_TYPE_TEMPORARY, EffectPolymorph(162), oCreature, 1.0f);	
		return GEAR_KITS_LOW;
	}
	else if(nRace == 10) // kobold
	{
		FeatRemove(oCreature, 258);
		FeatRemove(oCreature, 1773);
		
		FeatAdd(oCreature, 228, FALSE); // darkvision
		FeatAdd(oCreature, 375, FALSE); // small
		
		SetBaseAbilityScore(oCreature, ABILITY_DEXTERITY,
			GetAbilityScore(oCreature, ABILITY_DEXTERITY, TRUE) + 2);
		SetBaseAbilityScore(oCreature, ABILITY_STRENGTH,
			GetAbilityScore(oCreature, ABILITY_STRENGTH, TRUE) - 4);
		SetBaseAbilityScore(oCreature, ABILITY_CONSTITUTION,
			GetAbilityScore(oCreature, ABILITY_CONSTITUTION, TRUE) - 2);
			
		ApplyEffectToObject(DURATION_TYPE_PERMANENT, SupernaturalEffect(EffectSkillIncrease(SKILL_SEARCH, 2)), oCreature);
		ApplyEffectToObject(DURATION_TYPE_PERMANENT, SupernaturalEffect(EffectACIncrease(1, AC_NATURAL_BONUS)), oCreature);
		
		SetCreatureAppearanceType(oCreature, 535);
		XPObjectAttributesSetRace(oCreature, RACIAL_TYPE_HUMANOID_REPTILIAN);
		XPObjectAttributesSetSubRace(oCreature, RACIAL_SUBTYPE_HUMANOID_REPTILIAN);
		ApplyEffectToObject(DURATION_TYPE_TEMPORARY, EffectPolymorph(162), oCreature, 1.0f);	
		return GEAR_KITS_LOW;
	}
	else if(nRace == 11) // bugbear
	{
		FeatRemove(oCreature, 258);
		FeatRemove(oCreature, 1773);
		
		FeatAdd(oCreature, 228, FALSE); // darkvision

		SetBaseAbilityScore(oCreature, ABILITY_STRENGTH,
			GetAbilityScore(oCreature, ABILITY_STRENGTH, TRUE) + 4);
		SetBaseAbilityScore(oCreature, ABILITY_DEXTERITY,
			GetAbilityScore(oCreature, ABILITY_DEXTERITY, TRUE) + 2);
		SetBaseAbilityScore(oCreature, ABILITY_CONSTITUTION,
			GetAbilityScore(oCreature, ABILITY_CONSTITUTION, TRUE) + 2);
		SetBaseAbilityScore(oCreature, ABILITY_CHARISMA,
			GetAbilityScore(oCreature, ABILITY_CHARISMA, TRUE) - 2);
			
		ApplyEffectToObject(DURATION_TYPE_PERMANENT, SupernaturalEffect(EffectSkillIncrease(SKILL_MOVE_SILENTLY, 4)), oCreature);
		ApplyEffectToObject(DURATION_TYPE_PERMANENT, SupernaturalEffect(EffectACIncrease(3, AC_NATURAL_BONUS)), oCreature);
						
		SetCreatureAppearanceType(oCreature, 543);
		XPObjectAttributesSetRace(oCreature, RACIAL_TYPE_HUMANOID_GOBLINOID);
		XPObjectAttributesSetSubRace(oCreature, RACIAL_SUBTYPE_HUMANOID_GOBLINOID);
		ApplyEffectToObject(DURATION_TYPE_TEMPORARY, EffectPolymorph(162), oCreature, 1.0f);
		return GEAR_KITM_LOW;
	}
	else if(nRace == 12) // orc
	{
		FeatRemove(oCreature, 258);
		FeatRemove(oCreature, 1773);
		
		FeatAdd(oCreature, 228, FALSE); // darkvision

		SetBaseAbilityScore(oCreature, ABILITY_STRENGTH,
			GetAbilityScore(oCreature, ABILITY_STRENGTH, TRUE) + 4);
		SetBaseAbilityScore(oCreature, ABILITY_INTELLIGENCE,
			GetAbilityScore(oCreature, ABILITY_INTELLIGENCE, TRUE) - 2);
		SetBaseAbilityScore(oCreature, ABILITY_WISDOM,
			GetAbilityScore(oCreature, ABILITY_WISDOM, TRUE) - 2);
		SetBaseAbilityScore(oCreature, ABILITY_CHARISMA,
			GetAbilityScore(oCreature, ABILITY_CHARISMA, TRUE) - 2);
					
		SetCreatureAppearanceType(oCreature, 140);
		XPObjectAttributesSetRace(oCreature, RACIAL_TYPE_HUMANOID_ORC);
		XPObjectAttributesSetSubRace(oCreature, RACIAL_SUBTYPE_HUMANOID_ORC);
		ApplyEffectToObject(DURATION_TYPE_TEMPORARY, EffectPolymorph(162), oCreature, 1.0f);	
		return GEAR_KITM_LOW;
	}
	else if(nRace == 13) // gnoll
	{
		FeatRemove(oCreature, 258);
		FeatRemove(oCreature, 1773);
		
		FeatAdd(oCreature, 228, FALSE); // darkvision
		
		SetBaseAbilityScore(oCreature, ABILITY_STRENGTH,
			GetAbilityScore(oCreature, ABILITY_STRENGTH, TRUE) + 4);
		SetBaseAbilityScore(oCreature, ABILITY_CONSTITUTION,
			GetAbilityScore(oCreature, ABILITY_CONSTITUTION, TRUE) + 2);
		SetBaseAbilityScore(oCreature, ABILITY_INTELLIGENCE,
			GetAbilityScore(oCreature, ABILITY_INTELLIGENCE, TRUE) - 2);
		SetBaseAbilityScore(oCreature, ABILITY_CHARISMA,
			GetAbilityScore(oCreature, ABILITY_CHARISMA, TRUE) - 2);
		
		ApplyEffectToObject(DURATION_TYPE_PERMANENT, SupernaturalEffect(EffectACIncrease(1, AC_NATURAL_BONUS)), oCreature);
			
		SetCreatureAppearanceType(oCreature, 533);
		XPObjectAttributesSetRace(oCreature, RACIAL_TYPE_HUMANOID_MONSTROUS);
		XPObjectAttributesSetSubRace(oCreature, RACIAL_SUBTYPE_HUMANOID_MONSTROUS);
		ApplyEffectToObject(DURATION_TYPE_TEMPORARY, EffectPolymorph(162), oCreature, 1.0f);	
		return GEAR_KITM_LOW;
	}
	else if(nRace == 14) // lizardman
	{
		FeatRemove(oCreature, 258);
		FeatRemove(oCreature, 1773);
		
		SetBaseAbilityScore(oCreature, ABILITY_STRENGTH,
			GetAbilityScore(oCreature, ABILITY_STRENGTH, TRUE) + 2);
		SetBaseAbilityScore(oCreature, ABILITY_CONSTITUTION,
			GetAbilityScore(oCreature, ABILITY_CONSTITUTION, TRUE) + 2);
		SetBaseAbilityScore(oCreature, ABILITY_INTELLIGENCE,
			GetAbilityScore(oCreature, ABILITY_INTELLIGENCE, TRUE) - 2);
		
		ApplyEffectToObject(DURATION_TYPE_PERMANENT, SupernaturalEffect(EffectACIncrease(5, AC_NATURAL_BONUS)), oCreature);
		
		SetCreatureAppearanceType(oCreature, 536);
		XPObjectAttributesSetRace(oCreature, RACIAL_TYPE_HUMANOID_REPTILIAN);
		XPObjectAttributesSetSubRace(oCreature, RACIAL_SUBTYPE_HUMANOID_REPTILIAN);
		ApplyEffectToObject(DURATION_TYPE_TEMPORARY, EffectPolymorph(162), oCreature, 1.0f);	
		return GEAR_KITM_LOW;
	}
	else if(nRace == 15) // skeleton
	{
		FeatRemove(oCreature, 258);
		FeatRemove(oCreature, 1773);
		
		FeatAdd(oCreature, 228, FALSE); // darkvision
		FeatAdd(oCreature, 377, FALSE); // Imp init
		
		SetBaseAbilityScore(oCreature, ABILITY_DEXTERITY,
			GetAbilityScore(oCreature, ABILITY_DEXTERITY, TRUE) + 2);
		SetBaseAbilityScore(oCreature, ABILITY_CONSTITUTION, 10);
		SetBaseAbilityScore(oCreature, ABILITY_INTELLIGENCE, 1);
		SetBaseAbilityScore(oCreature, ABILITY_WISDOM, 10);
		SetBaseAbilityScore(oCreature, ABILITY_CHARISMA, 1);
		
		ApplyEffectToObject(DURATION_TYPE_PERMANENT, SupernaturalEffect(EffectDamageImmunityIncrease(DAMAGE_TYPE_COLD, 100)), oCreature);
		
		// Known bug in EffectDamageReduction -- it treats DAMAGE_TYPE_ALL as DAMAGE_TYPE_BLUDGEONING and vice versa, but we
		// can't change the constants because those damage constants are correct when dealing damage.
		ApplyEffectToObject(DURATION_TYPE_PERMANENT, SupernaturalEffect(EffectDamageReduction(5, DAMAGE_TYPE_ALL, 0, DR_TYPE_DMGTYPE)), oCreature);
		ApplyEffectToObject(DURATION_TYPE_PERMANENT, SupernaturalEffect(EffectACIncrease(2, AC_NATURAL_BONUS)), oCreature);
		UndeadEffects(oCreature);
		
		SetCreatureAppearanceType(oCreature, 537);
		XPObjectAttributesSetRace(oCreature, RACIAL_TYPE_UNDEAD);
		XPObjectAttributesSetSubRace(oCreature, RACIAL_SUBTYPE_UNDEAD);
		ApplyEffectToObject(DURATION_TYPE_TEMPORARY, EffectPolymorph(162), oCreature, 1.0f);	
		return GEAR_KITM_MUNDANE;
	}
	else if(nRace == 16) // zombie
	{
		FeatRemove(oCreature, 258);
		FeatRemove(oCreature, 1773);
		
		FeatAdd(oCreature, 228, FALSE); // darkvision
		
		SetBaseAbilityScore(oCreature, ABILITY_STRENGTH,
			GetAbilityScore(oCreature, ABILITY_STRENGTH, TRUE) + 2);
		SetBaseAbilityScore(oCreature, ABILITY_DEXTERITY,
			GetAbilityScore(oCreature, ABILITY_DEXTERITY, TRUE) - 2);
		SetBaseAbilityScore(oCreature, ABILITY_CONSTITUTION, 10);
		SetBaseAbilityScore(oCreature, ABILITY_INTELLIGENCE, 1);
		SetBaseAbilityScore(oCreature, ABILITY_WISDOM, 10);
		SetBaseAbilityScore(oCreature, ABILITY_CHARISMA, 1);
		
		ApplyEffectToObject(DURATION_TYPE_PERMANENT, SupernaturalEffect(EffectMovementSpeedDecrease(50)), oCreature);
		
		// Known bug in EffectDamageReduction -- it treats DAMAGE_TYPE_PIERCING as DAMAGE_TYPE_SLASHING and vice versa, but we
		// can't change the constants because those damage constants are correct when dealing damage.
		ApplyEffectToObject(DURATION_TYPE_PERMANENT, SupernaturalEffect(EffectDamageReduction(5, DAMAGE_TYPE_PIERCING, 0, DR_TYPE_DMGTYPE)), oCreature);
		ApplyEffectToObject(DURATION_TYPE_PERMANENT, SupernaturalEffect(EffectACIncrease(2, AC_NATURAL_BONUS)), oCreature);	
		UndeadEffects(oCreature);
		
		SetCreatureAppearanceType(oCreature, APPEARANCE_TYPE_ZOMBIE);
		XPObjectAttributesSetRace(oCreature, RACIAL_TYPE_UNDEAD);
		XPObjectAttributesSetSubRace(oCreature, RACIAL_SUBTYPE_UNDEAD);
		ApplyEffectToObject(DURATION_TYPE_TEMPORARY, EffectPolymorph(162), oCreature, 1.0f);	
		return GEAR_KIT_NONE;
	}
	else if(nRace == 17) // ghoul
	{
		FeatRemove(oCreature, 258);
		FeatRemove(oCreature, 1773);
		
		FeatAdd(oCreature, 228, FALSE); // darkvision
		
		UndeadEffects(oCreature);
		
		SetBaseAbilityScore(oCreature, ABILITY_STRENGTH, 13);
		SetBaseAbilityScore(oCreature, ABILITY_DEXTERITY, 15);
		SetBaseAbilityScore(oCreature, ABILITY_CONSTITUTION, 10);
		SetBaseAbilityScore(oCreature, ABILITY_INTELLIGENCE, 13);
		SetBaseAbilityScore(oCreature, ABILITY_WISDOM, 14);
		SetBaseAbilityScore(oCreature, ABILITY_CHARISMA, 12);		

		object oClaw1 = CreateItemOnObject("zitem_hand", oCreature); 
		object oClaw2 = CreateItemOnObject("zitem_hand", oCreature);
		object oBite  =	CreateItemOnObject("zitem_bite", oCreature);
		object oSkin  = CreateItemOnObject("zitem_skin", oCreature);
		
		AddItemProperty(DURATION_TYPE_PERMANENT, ItemPropertyOnHitProps(IP_CONST_ONHIT_HOLD, IP_CONST_ONHIT_SAVEDC_14, IP_CONST_ONHIT_DURATION_100_PERCENT_3_ROUND), oClaw1);
		AddItemProperty(DURATION_TYPE_PERMANENT, ItemPropertyOnHitProps(IP_CONST_ONHIT_HOLD, IP_CONST_ONHIT_SAVEDC_14, IP_CONST_ONHIT_DURATION_100_PERCENT_4_ROUND), oClaw2);
		AddItemProperty(DURATION_TYPE_PERMANENT, ItemPropertyOnHitProps(IP_CONST_ONHIT_DISEASE, IP_CONST_ONHIT_SAVEDC_14, DISEASE_GHOUL_ROT), oBite);
		AddItemProperty(DURATION_TYPE_PERMANENT, ItemPropertyTurnResistance(2), oSkin);
		
		AssignCommand(oCreature, ActionEquipItem(oClaw1, INVENTORY_SLOT_CWEAPON_L));
		AssignCommand(oCreature, ActionEquipItem(oClaw2, INVENTORY_SLOT_CWEAPON_R));
		AssignCommand(oCreature, ActionEquipItem(oBite,  INVENTORY_SLOT_CWEAPON_B));
		AssignCommand(oCreature, ActionEquipItem(oSkin,  INVENTORY_SLOT_CARMOUR));
		
		SetCreatureAppearanceType(oCreature, APPEARANCE_TYPE_GHOUL);
		XPObjectAttributesSetRace(oCreature, RACIAL_TYPE_UNDEAD);
		XPObjectAttributesSetSubRace(oCreature, RACIAL_SUBTYPE_UNDEAD);
		ApplyEffectToObject(DURATION_TYPE_TEMPORARY, EffectPolymorph(162), oCreature, 1.0f);	
		return GEAR_KIT_NONE;
	}
	else if(nRace == 18) // shadow
	{
		FeatRemove(oCreature, 258);
		FeatRemove(oCreature, 1773);
		
		FeatAdd(oCreature, 228, FALSE); // darkvision
		FeatAdd(oCreature, 2179, FALSE); // Shadow touch attack

                SetLocalString(oCreature, "ACR_CREATURE_BEHAVIOR", "BEHAVIOR_TYPE_TANK");
		
		UndeadEffects(oCreature);
		IncorporealEffects(oCreature);
		
		SetBaseAbilityScore(oCreature, ABILITY_STRENGTH, 14);
		SetBaseAbilityScore(oCreature, ABILITY_DEXTERITY, 14);
		SetBaseAbilityScore(oCreature, ABILITY_CONSTITUTION, 10);
		SetBaseAbilityScore(oCreature, ABILITY_INTELLIGENCE, 6);
		SetBaseAbilityScore(oCreature, ABILITY_WISDOM, 12);
		SetBaseAbilityScore(oCreature, ABILITY_CHARISMA, 13);
		
		object oSkin  = CreateItemOnObject("zitem_skin", oCreature);
		
		AddItemProperty(DURATION_TYPE_PERMANENT, ItemPropertyTurnResistance(2), oSkin);
		
		AssignCommand(oCreature, ActionEquipItem(oSkin,  INVENTORY_SLOT_CARMOUR));
		
		SetCreatureAppearanceType(oCreature, 496);
		XPObjectAttributesSetRace(oCreature, RACIAL_TYPE_UNDEAD);
		XPObjectAttributesSetSubRace(oCreature, RACIAL_SUBTYPE_UNDEAD);
		ApplyEffectToObject(DURATION_TYPE_TEMPORARY, EffectPolymorph(162), oCreature, 1.0f);	
		ApplyEffectToObject(DURATION_TYPE_PERMANENT, SupernaturalEffect(EffectSetScale(0.5, 0.5, 0.5)), oCreature);
		return GEAR_KIT_NONE;
	}
	SendMessageToAllDMs("error: failed to assign a race.");
	return -1;
}

void SetAlignment(object oCreature, int nAlignment)
{
	if(nAlignment == 1)
	{
		AdjustAlignment(oCreature, ALIGNMENT_LAWFUL, 100);
		AdjustAlignment(oCreature, ALIGNMENT_GOOD, 100);
	}
	if(nAlignment == 2)
	{
		AdjustAlignment(oCreature, ALIGNMENT_NEUTRAL, 100);
		AdjustAlignment(oCreature, ALIGNMENT_GOOD, 100);
	}
	if(nAlignment == 3)
	{
		AdjustAlignment(oCreature, ALIGNMENT_CHAOTIC, 100);
		AdjustAlignment(oCreature, ALIGNMENT_GOOD, 100);
	}
	if(nAlignment == 4)
	{
		AdjustAlignment(oCreature, ALIGNMENT_NEUTRAL, 100);
		AdjustAlignment(oCreature, ALIGNMENT_LAWFUL, 100);
	}
	if(nAlignment == 5)
	{
		AdjustAlignment(oCreature, ALIGNMENT_NEUTRAL, 100);
	}
	if(nAlignment == 6)
	{
		AdjustAlignment(oCreature, ALIGNMENT_NEUTRAL, 100);
		AdjustAlignment(oCreature, ALIGNMENT_CHAOTIC, 100);
	}
	if(nAlignment == 7)
	{
		AdjustAlignment(oCreature, ALIGNMENT_LAWFUL, 100);
		AdjustAlignment(oCreature, ALIGNMENT_EVIL, 100);
	}
	if(nAlignment == 8)
	{
		AdjustAlignment(oCreature, ALIGNMENT_NEUTRAL, 100);
		AdjustAlignment(oCreature, ALIGNMENT_EVIL, 100);
	}
	if(nAlignment == 9)
	{
		AdjustAlignment(oCreature, ALIGNMENT_CHAOTIC, 100);
		AdjustAlignment(oCreature, ALIGNMENT_EVIL, 100);
	}
}


#endif