////////////////////////////////////////////////////////////////////////////////
// Local Var Manager
// Original Scripter:  Caos81      Design: Caos81
//------------------------------------------------------------------------------
// Last Modified By:   Caos81           27/01/2009
//------------------------------------------------------------------------------
////////////////////////////////////////////////////////////////////////////////
#include "wand_inc"
#include "wand_inc_misc"

void main(int iItemId, int iSlot) { 
   	
	object oSubject = OBJECT_SELF;

	// SECURITY CHECK
	if (!IsDm(oSubject)) {
		DisplayMessageBox(oSubject, -1, WAND_NO_SPAM);
        return;
    }	
	
	object oItem = IntToObject(iItemId);
	
	if (!GetIsObjectValid(oItem)) {
		DisplayMessageBox(oSubject, -1, WAND_WRONG_VALUES);
        return;
	}
		
	string sItemName = GetName(oItem);
	object oTarget = GetPimTarget(oSubject);
	
	ResetListBoxesSelection (oSubject);
 	SetGUIObjectText(oSubject, WAND_GUI_PC_INVENTORY, "SELECTED_ITEM_NAME_EQUIPMENT", -1, sItemName);
	SetLocalGUIVariable(oSubject, WAND_GUI_PC_INVENTORY, 0, IntToString(iItemId));	
	SetLocalGUIVariable(oSubject, WAND_GUI_PC_INVENTORY, 4, IntToString(iSlot));	
}