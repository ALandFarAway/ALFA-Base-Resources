////////////////////////////////////////////////////////////////////////////////
// Local Var Manager
// Original Scripter:  Caos81      Design: Caos81
//------------------------------------------------------------------------------
// Last Modified By:   Caos81           27/01/2009
//------------------------------------------------------------------------------
////////////////////////////////////////////////////////////////////////////////

#include "wand_inc"
#include "wand_inc_misc"

void main(int iVarId) {    	

	object oSubject = OBJECT_SELF;
	
	// SECURITY CHECK
	if (!IsDm(oSubject)) {
		DisplayMessageBox(oSubject, -1, WAND_NO_SPAM);
        return;
    }
	
	object oArea = IntToObject(iVarId);
	string sVarValueName = (GetIsObjectValid(oArea)) ? GetAreaShortDesc(oArea) : "OBJECT_INVALID";
			
	SetGUIObjectText(oSubject, WAND_GUI_LV_MANAGER, "VAR_LOC_INPUT_AREA", -1, sVarValueName);
}