// gr_item_report
/*

*/
// ChazM 10/26/06
// ChazM 3/30/07 updated

#include "ginc_debug"
object oFirstPC = GetFirstPC();

void ReportOut(string sOut)
{
	PrettyDebug (sOut);
	SendMessageToPC(oFirstPC, sOut);
}

// Create a single Item Report
void ReportItem(object oItem)
{
	string sOut = "";
	sOut += GetName(oItem);
	sOut += " GP Value=" + IntToString(GetGoldPieceValue(oItem));
	sOut += " Weight=" + IntToString(GetWeight(oItem));
	sOut += " Stack Size=" + IntToString(GetItemStackSize(oItem));
	sOut += " Charges=" + IntToString(GetItemCharges(oItem));
/*	
		XML(TAG_ITEM_AC_VALUE, IntToString(GetItemACValue(oItem)));
		XMLBaseItemType(oItem);
		XMLItemProperties(oItem);
*/		
	ReportOut (sOut);
}

void ReportInventoryItems(object oPC)
{
    object oInventoryItem = GetFirstItemInInventory(oPC);
    while (oInventoryItem != OBJECT_INVALID)
    {
		ReportItem(oInventoryItem);
        oInventoryItem = GetNextItemInInventory(oPC);
    }
}

	
// Create all INVENTORY XML output
void ReportInventory(object oPC)
{
	ReportOut(GetName(oPC) + " Inventory:");
	ReportInventoryItems(oPC);
}



void main()
{
	object oPC = (GetPCSpeaker()==OBJECT_INVALID?OBJECT_SELF:GetPCSpeaker());
	//object oItem = GetFirstItemInInventory(oPC);

	ReportInventory(oPC);
		
}