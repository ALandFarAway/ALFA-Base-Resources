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
        return;
    }

	object oItem = IntToObject(iItemId);
	
	if (GetDroppableFlag(oItem))
		SetDroppableFlag(oItem, FALSE);
	else
		SetDroppableFlag(oItem, TRUE);	

	if (iSlot == -1)
		ModifyItem(oSubject, oItem);
	else
		SetLocalGUIVariable(oSubject, WAND_GUI_PC_INVENTORY, WAND_PIM_SLOT_TOOLTIP_OFFSET + iSlot, GetEquippedItemTooltip (oItem));		
}