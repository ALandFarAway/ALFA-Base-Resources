////////////////////////////////////////////////////////////////////////////////
// eXtended Sleight of Hand System
// Original Scripter:  Caos81      Design: Caos81
//------------------------------------------------------------------------------
// Last Modified By:   Caos81           18/2/2007
//------------------------------------------------------------------------------
////////////////////////////////////////////////////////////////////////////////

#include "wand_inc"

void main(string sVarValue) { 
   	
	object oSubject = OBJECT_SELF;
	object oVarValue = IntToObject(StringToInt(sVarValue));
	string sVarValueName;
		
	if (GetIsObjectValid(oVarValue)) {
		sVarValueName = GetName(oVarValue);
	}
	else if (sVarValue == "-1")	{
		sVarValueName =  WAND_LV_MANAGER_OBJ_INV_REF;
	}
	else {
		DisplayMessageBox(oSubject, -1, WAND_WRONG_VALUES);
		return;
	}	

	SetGUIObjectText(oSubject, WAND_GUI_LV_MANAGER, "VAR_OBJ_NAME", -1, sVarValueName);
}