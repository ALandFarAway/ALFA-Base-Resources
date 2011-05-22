// ga_equip_slot(string sTarget, int nSlot, string sItemTag)
/*
	Equip specified equipment slot with specified item

	Parameters:
		string sTarget - Tag of creature to unequip.  Defaults to conversation owner.
		
		int nSlot - the equipment slot to unequip.
				INVENTORY_SLOT_HEAD			= 0;
				INVENTORY_SLOT_CHEST		= 1;
				INVENTORY_SLOT_BOOTS		= 2;
				INVENTORY_SLOT_ARMS			= 3;
				INVENTORY_SLOT_RIGHTHAND	= 4;
				INVENTORY_SLOT_LEFTHAND		= 5;
				INVENTORY_SLOT_CLOAK		= 6;
				INVENTORY_SLOT_LEFTRING		= 7;
				INVENTORY_SLOT_RIGHTRING	= 8;
				INVENTORY_SLOT_NECK      	= 9;
				INVENTORY_SLOT_BELT      	= 10;
				INVENTORY_SLOT_ARROWS    	= 11;
				INVENTORY_SLOT_BULLETS   	= 12;
				INVENTORY_SLOT_BOLTS     	= 13;
				INVENTORY_SLOT_CWEAPON_L 	= 14;
				INVENTORY_SLOT_CWEAPON_R 	= 15;
				INVENTORY_SLOT_CWEAPON_B 	= 16;
				INVENTORY_SLOT_CARMOUR   	= 17;
				
		string sItemTag - tag of item in inventory to equip				
*/                         
// ChazM 6/29/07


#include "ginc_param_const"
//#include "ginc_item"

void main(string sTarget, int nSlot, string sItemTag)
{
	object oTarget = GetTarget(sTarget);
	object oItem = GetItemPossessedBy(oTarget, sItemTag);
	if (GetIsObjectValid(oItem))
	{
		AssignCommand(oTarget, ActionEquipItem(oItem, nSlot));
	}		
	
}	