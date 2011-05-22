// i_nwn2_it_ifist_belt_ue

#include "x2_inc_itemprop"

void main()
{
    // * This code runs when the item is equipped
    object oPC      = GetPCItemLastUnequippedBy();
    object oItem    = GetPCItemLastUnequipped();
	object oGaunt;
	object oHammer;
	
	// Standard Belt Properties
	
	itemproperty ipSaveBonus = ItemPropertyBonusSavingThrowVsX(IP_CONST_SAVEVS_UNIVERSAL, 1);
	itemproperty ipConBonus = ItemPropertyAbilityBonus(IP_CONST_ABILITY_CON, 3);
	
	// Standard Gauntlet Properties
	
	itemproperty ipDazeHit = ItemPropertyOnHitProps(IP_CONST_ONHIT_DAZE, IP_CONST_ONHIT_SAVEDC_14, 
		IP_CONST_ONHIT_DURATION_5_PERCENT_5_ROUNDS);
	itemproperty ipDamBonus2 = ItemPropertyDamageBonus(IP_CONST_DAMAGETYPE_BLUDGEONING, IP_CONST_DAMAGEBONUS_1d4);
	itemproperty ipStrBonus = ItemPropertyAbilityBonus(IP_CONST_ABILITY_STR, 3);
	itemproperty ipRaceDamBonus = ItemPropertyDamageBonusVsRace(IP_CONST_RACIALTYPE_GIANT, 
		IP_CONST_DAMAGETYPE_BLUDGEONING, IP_CONST_DAMAGEBONUS_1d8);	
	itemproperty ipAttBonus = ItemPropertyAttackBonus(1);
		
	IPRemoveAllItemProperties(oItem, DURATION_TYPE_PERMANENT);	
	
	AddItemProperty(DURATION_TYPE_PERMANENT, ipSaveBonus, oItem);
	AddItemProperty(DURATION_TYPE_PERMANENT, ipConBonus, oItem);
	
	if (GetResRef(GetItemInSlot(INVENTORY_SLOT_ARMS, oPC)) == "nwn2_it_ifist_gaunt")
	{
		oGaunt = GetItemInSlot(INVENTORY_SLOT_ARMS, oPC);
		IPRemoveAllItemProperties(oGaunt, DURATION_TYPE_PERMANENT);
		
		AddItemProperty(DURATION_TYPE_PERMANENT, ipDamBonus2, oGaunt);
		AddItemProperty(DURATION_TYPE_PERMANENT, ipRaceDamBonus, oGaunt);
		AddItemProperty(DURATION_TYPE_PERMANENT, ipStrBonus, oGaunt);
		AddItemProperty(DURATION_TYPE_PERMANENT, ipAttBonus, oGaunt);
	}
	
	if (GetResRef(GetItemInSlot(INVENTORY_SLOT_RIGHTHAND, oPC)) == "nwn2_it_ifist_hammer")
	{
		oHammer = GetItemInSlot(INVENTORY_SLOT_RIGHTHAND, oPC);
		AssignCommand(oPC, ClearAllActions());
		AssignCommand(oPC, ActionUnequipItem(oHammer));
		SendMessageToPCByStrRef(oPC, 7955);
	}	
	
}