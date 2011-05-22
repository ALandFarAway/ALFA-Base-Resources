// i_temp_eq
/*
   Template for an Equip item script.
*/
// ChazM 3/1/05

void main()
{
    // * This code runs when the item is equipped
    object oPC      = GetPCItemLastEquippedBy();
    object oItem    = GetPCItemLastEquipped();
	
	if (GetResRef(GetItemInSlot(INVENTORY_SLOT_ARMS, oPC)) != "nwn2_it_ifist_gaunt" ||
		GetResRef(GetItemInSlot(INVENTORY_SLOT_BELT, oPC)) != "nwn2_it_ifist_belt")
	{
		AssignCommand(oPC, ClearAllActions());
		AssignCommand(oPC, ActionUnequipItem(oItem));
		SendMessageToPCByStrRef(oPC, 7955);
	}
}