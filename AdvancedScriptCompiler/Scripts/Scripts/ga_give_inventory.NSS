// ga_give_inventory
/*
	This script takes items from sGiver's inventory and gives it to sReceiver.
	
	Parameters:
		string sGiver = Tag of object giving items.  Default is OWNER.
		string sReceiver = Tag of object receiving items.  Default is PC.
		int iInventoryContents = Which items to donate: 
			0 = All inventory items, equipped items and gold. (Giver must be creature)
			1 = All inventory items only. 
	        2 = All equipped items only. (Giver must be creature)
*/
// CGaw 3/10/06
// ChazM 3/15/06 - minor changes	


#include "ginc_item"
#include "ginc_param_const"
	
void main(string sGiver, string sReceiver, int iInventoryContents)
{
	object oGiver = GetTarget(sGiver, TARGET_OWNER);
	object oReceiver = GetTarget(sReceiver, TARGET_PC);
	PrettyDebug ("sGiver = " + GetName(oGiver));
	PrettyDebug ("sReceiver = " + GetName(oReceiver));

	switch(iInventoryContents)
	{
		case 0: 
			GiveEverything(oGiver, oReceiver);
			break;
		case 1:
			GiveAllInventory(oGiver, oReceiver);
			break;
		case 2:
			GiveAllEquippedItems(oGiver, oReceiver);
			break;
	}
}