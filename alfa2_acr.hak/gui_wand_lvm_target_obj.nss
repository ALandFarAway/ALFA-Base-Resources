#include "wand_inc"

void main (int iTarget) {
	object oPc = OBJECT_SELF;
	object oTarget = IntToObject(iTarget);
	
	
	SetGUIObjectText(oPc, WAND_GUI_LV_MANAGER, "VAR_OBJ_INPUT", -1, IntToString(iTarget));
	SetGUIObjectText(oPc, WAND_GUI_LV_MANAGER, "VAR_OBJ_NAME", -1, GetName(oTarget));
}