// OnAcquire Script for Staff of Balpheron "n2_wmgst001"
// Regulates Item Recharging.
// CGaw OEI 7/13/06

#include "ginc_debug"
#include "ginc_item"

void AddItemProperties(object oItem)
{
	itemproperty ipDispel = ItemPropertyCastSpell(IP_CONST_CASTSPELL_DISPEL_MAGIC_10, 
		IP_CONST_CASTSPELL_NUMUSES_2_CHARGES_PER_USE);
	itemproperty ipImpInv = ItemPropertyCastSpell(IP_CONST_CASTSPELL_IMPROVED_INVISIBILITY_7, 
		IP_CONST_CASTSPELL_NUMUSES_3_CHARGES_PER_USE);
	itemproperty ipAResist = ItemPropertyCastSpell(IP_CONST_CASTSPELL_ASSAY_RESISTANCE_7, 
		IP_CONST_CASTSPELL_NUMUSES_3_CHARGES_PER_USE);
	itemproperty ipLSMantle = ItemPropertyCastSpell(IP_CONST_CASTSPELL_LESSER_SPELL_MANTLE_9, 
		IP_CONST_CASTSPELL_NUMUSES_4_CHARGES_PER_USE);
	itemproperty ipDBFire = ItemPropertyCastSpell(IP_CONST_CASTSPELL_DELAYED_BLAST_FIREBALL_15, 
		IP_CONST_CASTSPELL_NUMUSES_5_CHARGES_PER_USE);
	itemproperty ipChLight = ItemPropertyCastSpell(IP_CONST_CASTSPELL_CHAIN_LIGHTNING_15, 
		IP_CONST_CASTSPELL_NUMUSES_5_CHARGES_PER_USE);
	itemproperty ipWFire = ItemPropertyCastSpell(IP_CONST_CASTSPELL_WALL_OF_FIRE_9, 
		IP_CONST_CASTSPELL_NUMUSES_4_CHARGES_PER_USE);
	itemproperty ipILMStrm = ItemPropertyCastSpell(IP_CONST_CASTSPELL_ISAACS_LESSER_MISSILE_STORM_13, 
		IP_CONST_CASTSPELL_NUMUSES_4_CHARGES_PER_USE);
	itemproperty ipMMiss = ItemPropertyCastSpell(IP_CONST_CASTSPELL_MAGIC_MISSILE_9, 
		IP_CONST_CASTSPELL_NUMUSES_1_CHARGE_PER_USE);
	itemproperty ipIMArm = ItemPropertyCastSpell(IP_CONST_CASTSPELL_IMPROVED_MAGE_ARMOR_10, 
		IP_CONST_CASTSPELL_NUMUSES_2_CHARGES_PER_USE);
	itemproperty ipPfE = ItemPropertyCastSpell(IP_CONST_CASTSPELL_PROTECTION_FROM_EVIL_1, 
		IP_CONST_CASTSPELL_NUMUSES_1_CHARGE_PER_USE);
	itemproperty ipGoInv = ItemPropertyCastSpell(IP_CONST_CASTSPELL_GLOBE_OF_INVULNERABILITY_11, 
		IP_CONST_CASTSPELL_NUMUSES_5_CHARGES_PER_USE);
	itemproperty ipCoCold = ItemPropertyCastSpell(IP_CONST_CASTSPELL_CONE_OF_COLD_15, 
		IP_CONST_CASTSPELL_NUMUSES_4_CHARGES_PER_USE);
	itemproperty ipLightBolt = ItemPropertyCastSpell(IP_CONST_CASTSPELL_LIGHTNING_BOLT_10, 
		IP_CONST_CASTSPELL_NUMUSES_2_CHARGES_PER_USE);
	itemproperty ipScinSphere = ItemPropertyCastSpell(IP_CONST_CASTSPELL_SCINTILLATING_SPHERE_5, 
		IP_CONST_CASTSPELL_NUMUSES_2_CHARGES_PER_USE);
	itemproperty ipLMBlank = ItemPropertyCastSpell(IP_CONST_CASTSPELL_LESSER_MIND_BLANK_9, 
		IP_CONST_CASTSPELL_NUMUSES_3_CHARGES_PER_USE);
	itemproperty ipGStoneskin = ItemPropertyCastSpell(IP_CONST_CASTSPELL_GREATER_STONESKIN_11, 
		IP_CONST_CASTSPELL_NUMUSES_5_CHARGES_PER_USE);
			
	AddItemProperty(DURATION_TYPE_PERMANENT, ipDispel, oItem);
	AddItemProperty(DURATION_TYPE_PERMANENT, ipImpInv, oItem);
	AddItemProperty(DURATION_TYPE_PERMANENT, ipAResist, oItem);
	AddItemProperty(DURATION_TYPE_PERMANENT, ipLSMantle, oItem);
	AddItemProperty(DURATION_TYPE_PERMANENT, ipDBFire, oItem);
	AddItemProperty(DURATION_TYPE_PERMANENT, ipChLight, oItem);
	AddItemProperty(DURATION_TYPE_PERMANENT, ipWFire, oItem);
	AddItemProperty(DURATION_TYPE_PERMANENT, ipILMStrm, oItem);
	AddItemProperty(DURATION_TYPE_PERMANENT, ipMMiss, oItem);
	AddItemProperty(DURATION_TYPE_PERMANENT, ipIMArm, oItem);
	AddItemProperty(DURATION_TYPE_PERMANENT, ipPfE, oItem);
	AddItemProperty(DURATION_TYPE_PERMANENT, ipGoInv, oItem);
	AddItemProperty(DURATION_TYPE_PERMANENT, ipCoCold, oItem);
	AddItemProperty(DURATION_TYPE_PERMANENT, ipLightBolt, oItem);
	AddItemProperty(DURATION_TYPE_PERMANENT, ipScinSphere, oItem);
	AddItemProperty(DURATION_TYPE_PERMANENT, ipLMBlank, oItem);
	AddItemProperty(DURATION_TYPE_PERMANENT, ipGStoneskin, oItem);
}

void RechargeStaff(object oItem, object oPossessor)
{
	int nTimesAcquired = GetLocalInt(OBJECT_SELF, "Times_Item_Acquired");
	int nCurrentCharges = GetItemCharges(oItem);
	
	if (nTimesAcquired > 1 || GetItemPossessor(oItem) != oPossessor)
	{
		SetLocalInt(oItem, "Times_Item_Acquired", nTimesAcquired - 1);
		return;
	}

	else if (nCurrentCharges == 30)
	{
		DelayCommand(18.0f, RechargeStaff(oItem, oPossessor));
	}
	
	else if (nCurrentCharges < 5)
	{
		IPRemoveMatchingItemProperties(oItem, ITEM_PROPERTY_CAST_SPELL, DURATION_TYPE_PERMANENT, -1);
		AddItemProperties(oItem);	
		SetItemCharges(oItem, nCurrentCharges + 1);
		DelayCommand(18.0f, RechargeStaff(oItem, oPossessor));
	}		
	
	else		
	{
		SetItemCharges(oItem, nCurrentCharges + 1);
		DelayCommand(18.0f, RechargeStaff(oItem, oPossessor));
	}
}

void main()
{
	object oPossessor = GetModuleItemAcquiredBy();
    object oItem = GetModuleItemAcquired();
	int nCurrentCharges = GetItemCharges(oItem);
	int nTimesAcquired = GetLocalInt(oItem, "Times_Item_Acquired"); 
	string sStaffTag = GetTag(oItem);	
				
	SetLocalInt(oItem, "Times_Item_Acquired", nTimesAcquired + 1);
	
	if (sStaffTag == "n2_wmgst001")
	{
		RechargeStaff(oItem, oPossessor);
	}
}
