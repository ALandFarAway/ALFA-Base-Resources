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
		
	object oTarget = GetLvmTarget(oSubject);	
	string sVarName = GetVariableName(oTarget, iVarId);
	string sVarValue = FloatToString(GetLocalFloat(oTarget, sVarName));		

	SetLocalGUIVariable(oSubject, WAND_GUI_LV_MANAGER, 1, IntToString(iVarId));
 	SetGUIObjectText(oSubject, WAND_GUI_LV_MANAGER, "VAR_NAME", -1, sVarName);
	SetGUIObjectText(oSubject, WAND_GUI_LV_MANAGER, "VAR_NAME_NEW", -1, WAND_NEW_VAR_NAME);		
	SetGUIObjectText(oSubject, WAND_GUI_LV_MANAGER, "VAR_FLOAT_INPUT", -1, sVarValue);
	
	if (iVarId >= 0) 
		SetGUIObjectDisabled(oSubject, WAND_GUI_LV_MANAGER, "DELETE_FLOAT", FALSE);	
	else
		SetGUIObjectDisabled(oSubject, WAND_GUI_LV_MANAGER, "DELETE_FLOAT", TRUE);		
}