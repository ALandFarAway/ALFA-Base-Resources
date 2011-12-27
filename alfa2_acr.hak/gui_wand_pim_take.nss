////////////////////////////////////////////////////////////////////////////////
// PC Inventory Manager
// Original Scripter:  Caos81      Design: Caos81
//------------------------------------------------------------------------------
// Last Modified By:   Caos81           28/01/2009
//------------------------------------------------------------------------------
////////////////////////////////////////////////////////////////////////////////

#include "wand_inc"
#include "wand_inc_misc"

void main(string sItemId)
{    	
	object oSubject = OBJECT_SELF;
	
	if (!IsDm(oSubject)) {
		DisplayMessageBox(oSubject, -1, WAND_NO_SPAM);
        return;
    }

	object oItem = IntToObject(StringToInt(sItemId));
	object oTarget = GetPimTarget(oSubject);
	
	CopyItem(oItem, oSubject, TRUE);

	DestroyObject(oItem, 0.0, FALSE);		

	ResetInventoryListboxes(oSubject);	
	DelayCommand(0.1, DisplayInventory (oSubject, oTarget));
}