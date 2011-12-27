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
	object oVarValue = GetLocalObject(oTarget, sVarName);
	string sVarValue = (GetIsObjectValid(oVarValue)) ? IntToString(ObjectToInt(oVarValue)) : "-1";
	string sVarValueName = (GetIsObjectValid(oVarValue)) ? GetObjectShortDesc(oVarValue) : "OBJECT_INVALID";	

	SetLocalGUIVariable(oSubject, WAND_GUI_LV_MANAGER, 1, IntToString(iVarId));
 	SetGUIObjectText(oSubject, WAND_GUI_LV_MANAGER, "VAR_NAME", -1, sVarName);
	SetGUIObjectText(oSubject, WAND_GUI_LV_MANAGER, "VAR_NAME_NEW", -1, WAND_NEW_VAR_NAME);		
	SetGUIObjectText(oSubject, WAND_GUI_LV_MANAGER, "VAR_OBJ_INPUT", -1, sVarValue);
	SetGUIObjectText(oSubject, WAND_GUI_LV_MANAGER, "VAR_OBJ_NAME", -1, sVarValueName);
	
	
	if (iVarId >= 0) 
		SetGUIObjectDisabled(oSubject, WAND_GUI_LV_MANAGER, "DELETE_OBJ", FALSE);	
	else
		SetGUIObjectDisabled(oSubject, WAND_GUI_LV_MANAGER, "DELETE_OBJ", TRUE);
}