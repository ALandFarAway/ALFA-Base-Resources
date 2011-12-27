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
	location lVarValue = GetLocalLocation(oTarget, sVarName);
	vector vLocationVector = GetPositionFromLocation(lVarValue);	
	string sVarValueX = MyFloatToString(vLocationVector.x);
	string sVarValueY = MyFloatToString(vLocationVector.y);	
	string sVarValueZ = MyFloatToString(vLocationVector.z);	
	object oArea = GetAreaFromLocation(lVarValue);
	string sVarValueArea = (GetIsObjectValid(oArea)) ? GetAreaShortDesc(oArea) : "OBJECT_INVALID";
	string sVarValueOrientation = (iVarId < 0) ? MyFloatToString(IntToFloat(0)) : MyFloatToString(GetFacingFromLocation(lVarValue));
		
	SetLocalGUIVariable(oSubject, WAND_GUI_LV_MANAGER, 1, IntToString(iVarId));
	
 	SetGUIObjectText(oSubject, WAND_GUI_LV_MANAGER, "VAR_NAME", -1, sVarName);
	SetGUIObjectText(oSubject, WAND_GUI_LV_MANAGER, "VAR_NAME_NEW", -1, WAND_NEW_VAR_NAME);		
	SetGUIObjectText(oSubject, WAND_GUI_LV_MANAGER, "VAR_LOC_INPUT_X", -1, sVarValueX);
	SetGUIObjectText(oSubject, WAND_GUI_LV_MANAGER, "VAR_LOC_INPUT_Y", -1, sVarValueY);
	SetGUIObjectText(oSubject, WAND_GUI_LV_MANAGER, "VAR_LOC_INPUT_Z", -1, sVarValueZ);
	SetGUIObjectText(oSubject, WAND_GUI_LV_MANAGER, "VAR_LOC_INPUT_AREA", -1, sVarValueArea);
	SetListBoxRowSelected(oSubject, WAND_GUI_LV_MANAGER, "AREA_LIST", "Area_"+IntToString(ObjectToInt(oArea)));
	SetGUIObjectText(oSubject, WAND_GUI_LV_MANAGER, "VAR_LOC_INPUT_ORIENT", -1, sVarValueOrientation);	
	
	if (iVarId >= 0) 
		SetGUIObjectDisabled(oSubject, WAND_GUI_LV_MANAGER, "DELETE_FLOAT", FALSE);	
	else
		SetGUIObjectDisabled(oSubject, WAND_GUI_LV_MANAGER, "DELETE_FLOAT", TRUE);		
}