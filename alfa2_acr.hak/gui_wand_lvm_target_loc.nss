#include "wand_inc"
#include "wand_inc_misc"

void main (int iTarget, float fX, float fY, float fZ) {
	object oSubject = OBJECT_SELF;
	vector vPosition;
	float fFacing;
	object oArea, oTarget = IntToObject(iTarget);

	if (GetIsObjectValid(oTarget)) {
		vPosition = GetPosition(oTarget);
		oArea = GetArea(oTarget);
		fFacing = GetFacing(oTarget);
	}
	else {
		vPosition = Vector(fX, fY, fZ);
		oArea = GetArea(oSubject);
		fFacing = 0.0;
	}
	
	SetGUIObjectText(oSubject, WAND_GUI_LV_MANAGER, "VAR_LOC_INPUT_AREA", -1, GetAreaShortDesc(oArea));
	SetLocalGUIVariable(oSubject, WAND_GUI_LV_MANAGER, 106, IntToString(ObjectToInt(oArea)));
	SetGUIObjectText(oSubject, WAND_GUI_LV_MANAGER, "VAR_NAME_NEW", -1, WAND_NEW_VAR_NAME);		
	SetGUIObjectText(oSubject, WAND_GUI_LV_MANAGER, "VAR_LOC_INPUT_X", -1, MyFloatToString(vPosition.x));
	SetGUIObjectText(oSubject, WAND_GUI_LV_MANAGER, "VAR_LOC_INPUT_Y", -1, MyFloatToString(vPosition.y));
	SetGUIObjectText(oSubject, WAND_GUI_LV_MANAGER, "VAR_LOC_INPUT_Z", -1, MyFloatToString(vPosition.z));
	SetListBoxRowSelected(oSubject, WAND_GUI_LV_MANAGER, "AREA_LIST", "Area_" + IntToString(ObjectToInt(oArea)));
	SetGUIObjectText(oSubject, WAND_GUI_LV_MANAGER, "VAR_LOC_INPUT_ORIENT", -1, MyFloatToString(fFacing));	
}