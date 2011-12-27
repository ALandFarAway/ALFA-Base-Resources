////////////////////////////////////////////////////////////////////////////////
// PC Inventory Manager
// Original Scripter:  Caos81      Design: Caos81
//------------------------------------------------------------------------------
// Last Modified By:   Caos81           02/02/2009
//------------------------------------------------------------------------------
////////////////////////////////////////////////////////////////////////////////

#include "wand_inc"

void UnequipItem(object oItem){
    ClearAllActions();
    ActionUnequipItem(oItem);
}

// TODO: Unequip check
void CheckActionResult (object oSubject, object oTarget, object oUnequippedItem) {
	/*
	if (GetItemInSlot(iSlot, oTarget) != oEquippedItem) {
		DisplayMessageBox(oSubject, -1, WAND_PIM_EQUIPPING_ERROR);
	}
	else {
		SetGUIObjectHidden(oSubject, WAND_GUI_PC_INVENTORY, "PANE_INVENTORY_RADIAL_EQUIP", FALSE);
		SetGUIObjectHidden(oSubject, WAND_GUI_PC_INVENTORY, "SLOT_TEXTURE_"+IntToString(iSlot)+"_OVERLAY", FALSE);
	}
	*/
	
	SelectListBoxItem (oSubject, oUnequippedItem);
}


void main(int iItemId) {  
  	
	object oSubject = OBJECT_SELF;
	
	if (!IsDm(oSubject)) {
		DisplayMessageBox(oSubject, -1, WAND_NO_SPAM);
        return;
    }
	
	object oItem = IntToObject(iItemId);
	object oTarget = GetPimTarget(oSubject);
	
	if (!GetIsObjectValid(oItem)) {
		DisplayMessageBox(oSubject, -1, WAND_WRONG_VALUES);
        return;
	}
	
	if (GetItemPossessor(oItem) != oTarget) {
		DisplayMessageBox(oSubject, -1, WAND_PIM_EQUIP_INVALID_OWNER);
		return;
	}
	
	AssignCommand(oTarget, UnequipItem(oItem));	
	ResetInventoryListboxes(oSubject);	
	DelayCommand(0.1, DisplayInventory (oSubject, oTarget));
	DelayCommand(0.3, CheckActionResult (oSubject, oTarget, oItem));	
}