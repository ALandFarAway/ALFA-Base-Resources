////////////////////////////////////////////////////////////////////////////////
// PC Inventory Manager
// Original Scripter:  Caos81      Design: Caos81
//------------------------------------------------------------------------------
// Last Modified By:   Caos81           28/01/2009
//------------------------------------------------------------------------------
////////////////////////////////////////////////////////////////////////////////

#include "wand_inc"
#include "wand_inc_conf"

void EquipItem(object oItem, int iSlot){

    ClearAllActions();
    ActionEquipItem(oItem, iSlot);
}

void CheckActionResult (object oSubject, object oTarget, object oEquippedItem, int iSlot) {
	if (GetItemInSlot(iSlot, oTarget) != oEquippedItem) {
		SelectListBoxItem (oSubject, oEquippedItem);
		DisplayMessageBox(oSubject, -1, WAND_PIM_EQUIPPING_ERROR);
	}
	else {
		string sItemName = GetName(oEquippedItem);
		
		SetGUIObjectHidden(oSubject, WAND_GUI_PC_INVENTORY, "PANE_INVENTORY_RADIAL_EQUIP", FALSE);
		SetGUIObjectHidden(oSubject, WAND_GUI_PC_INVENTORY, "SLOT_TEXTURE_"+IntToString(iSlot)+"_OVERLAY", FALSE);
		SetGUIObjectText(oSubject, WAND_GUI_PC_INVENTORY, "SELECTED_ITEM_NAME", -1, sItemName);	
	}
}

void main(int iItemId, int iSlot) {  
  	
	object oSubject = OBJECT_SELF;
	
	if (!IsDm(oSubject)) {
		DisplayMessageBox(oSubject, -1, WAND_NO_SPAM);
        return;
    }
		
	object oItem = IntToObject(iItemId);
	object oTarget = GetPimTarget(oSubject);
	
	if (GetItemPossessor(oItem) != oTarget) {
		DisplayMessageBox(oSubject, -1, WAND_PIM_EQUIP_INVALID_OWNER);
		return;
	}
	
	if (ITEM_LEVEL_RESTRICTION		
		&& GetGoldPieceValue(oItem) > StringToInt(Get2DAString("itemvalue", "MAXSINGLEITEMVALUE", GetHitDice(oTarget) - 1))){
		SetGUIObjectHidden(oSubject, WAND_GUI_PC_INVENTORY, "PANE_INVENTORY_RADIAL", FALSE);
		DisplayMessageBox(oSubject, -1, WAND_PIM_EQUIP_LEVEL_RESTRICTED);
		return;	
	}
	
	if (!GetIdentified(oItem)) {
		SetGUIObjectHidden(oSubject, WAND_GUI_PC_INVENTORY, "PANE_INVENTORY_RADIAL", FALSE);
		DisplayMessageBox(oSubject, -1, WAND_PIM_EQUIP_UNIDENTIFIED);
		return;	
	}
	
	AssignCommand(oTarget, EquipItem(oItem, iSlot));
	ResetInventoryListboxes(oSubject);	
	DelayCommand(0.1, DisplayInventory (oSubject, oTarget));
	DelayCommand(0.4, CheckActionResult (oSubject, oTarget, oItem, iSlot));
}