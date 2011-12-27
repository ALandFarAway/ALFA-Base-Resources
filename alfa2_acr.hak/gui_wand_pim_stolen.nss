////////////////////////////////////////////////////////////////////////////////
// PC Inventory Manager
// Original Scripter:  Caos81      Design: Caos81
//------------------------------------------------------------------------------
// Last Modified By:   Caos81           28/01/2009
//------------------------------------------------------------------------------
////////////////////////////////////////////////////////////////////////////////

#include "wand_inc"
#include "wand_inc_misc"

void main(int iItemId, int iSlot)
{    	
	object oSubject = OBJECT_SELF;
	
	if (!IsDm(oSubject)) {
		DisplayMessageBox(oSubject, -1, WAND_NO_SPAM);
        return;
    }

	object oItem = IntToObject(iItemId);
	
	if (GetStolenFlag(oItem))
		SetStolenFlag(oItem, FALSE);
	else
		SetStolenFlag(oItem, TRUE);	

	SendMessageToPC(oSubject, "iSlot: " + IntToString(iSlot));
	
	if (iSlot == -1)	
		ModifyItem(oSubject, oItem);
	else
		SetLocalGUIVariable(oSubject, WAND_GUI_PC_INVENTORY, WAND_PIM_SLOT_TOOLTIP_OFFSET + iSlot, GetEquippedItemTooltip (oItem));	
}