////////////////////////////////////////////////////////////////////////////////
// PC Inventory Manager
// Original Scripter:  Caos81      Design: Caos81
//------------------------------------------------------------------------------
// Last Modified By:   Caos81           28/01/2009
//------------------------------------------------------------------------------
////////////////////////////////////////////////////////////////////////////////

#include "wand_inc"
#include "wand_inc_misc"

void _GiveItem (object oSubject, object oTarget) {
	object oNewItem, oItem = GetLastDraggedItem (oSubject);

	oNewItem = CopyItem(oItem, oTarget, TRUE);
	
	DestroyObject(oItem, 0.0);	
	
	ResetInventoryListboxes(oSubject);	
	DelayCommand(0.1, DisplayInventory (oSubject, oTarget));	
}

void main()
{    
	object oPc = OBJECT_SELF;
	
	if (!IsDm(oPc)) {
		DisplayMessageBox(oPc, -1, WAND_NO_SPAM);
		return;
	}
	
	DelayCommand(0.2, _GiveItem (oPc, GetPimTarget(oPc)));
}