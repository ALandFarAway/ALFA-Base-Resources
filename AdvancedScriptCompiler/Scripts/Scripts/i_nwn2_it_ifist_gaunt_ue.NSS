// i_nwn2_it_ifist_gaunt_ue

#include "x2_inc_itemprop"

void main()
{
    // * This code runs when the item is equipped
    object oPC      = GetPCItemLastUnequippedBy();
    object oItem    = GetPCItemLastUnequipped();
	object oBelt;
	object oHammer;
	
	// Standard Gaunt Properties

	itemproperty ipDamBonus2 = ItemPropertyDamageBonus(IP_CONST_DAMAGETYPE_BLUDGEONING, IP_CONST_DAMAGEBONUS_1d4);
	itemproperty ipStrBonus = ItemPropertyAbilityBonus(IP_CONST_ABILITY_STR, 3);
	itemproperty ipRaceDamBonus = ItemPropertyDamageBonusVsRace(IP_CONST_RACIALTYPE_GIANT, 
		IP_CONST_DAMAGETYPE_BLUDGEONING, IP_CONST_DAMAGEBONUS_1d8);
	itemproperty ipAttBonus = ItemPropertyAttackBonus(1);
	
	// Standard Belt Properties
	
	itemproperty ipSaveBonus = ItemPropertyBonusSavingThrowVsX(IP_CONST_SAVEVS_UNIVERSAL, 1);
	itemproperty ipConBonus = ItemPropertyAbilityBonus(IP_CONST_ABILITY_CON, 3);

	IPRemoveAllItemProperties(oItem, DURATION_TYPE_PERMANENT);
	
	AddItemProperty(DURATION_TYPE_PERMANENT, ipDamBonus2, oItem);
	AddItemProperty(DURATION_TYPE_PERMANENT, ipRaceDamBonus, oItem);
	AddItemProperty(DURATION_TYPE_PERMANENT, ipStrBonus, oItem);
	AddItemProperty(DURATION_TYPE_PERMANENT, ipAttBonus, oItem);
	
	if (GetResRef(GetItemInSlot(INVENTORY_SLOT_BELT, oPC)) == "nwn2_it_ifist_belt")
	{
		oBelt = GetItemInSlot(INVENTORY_SLOT_BELT, oPC);
		IPRemoveAllItemProperties(oBelt, DURATION_TYPE_PERMANENT);
		
		AddItemProperty(DURATION_TYPE_PERMANENT, ipSaveBonus, oBelt);
		AddItemProperty(DURATION_TYPE_PERMANENT, ipConBonus, oBelt);
	}
	
	if (GetResRef(GetItemInSlot(INVENTORY_SLOT_RIGHTHAND, oPC)) == "nwn2_it_ifist_hammer")
	{
		oHammer = GetItemInSlot(INVENTORY_SLOT_RIGHTHAND, oPC);
		AssignCommand(oPC, ClearAllActions());
		AssignCommand(oPC, ActionUnequipItem(oHammer));
		SendMessageToPCByStrRef(oPC, 7955);
	}
}