////////////////////////////////////////////////////////////////////////////////
// Local Var Manager
// Original Scripter:  Caos81      Design: Caos81
//------------------------------------------------------------------------------
// Last Modified By:   Caos81           28/01/2009
//------------------------------------------------------------------------------
////////////////////////////////////////////////////////////////////////////////

// This script routes or executes all Player UI input.

#include "wand_inc"

void main(int iTarget)
{
	
	object oPc = OBJECT_SELF;
	object oTarget = IntToObject(iTarget);

	if (!IsDm(oPc)) {
		DisplayMessageBox(oPc, -1, WAND_NO_SPAM);
		return;
	}

	SetLvmTarget(oPc, oTarget);
	
	DisplayGuiScreen(oPc, WAND_GUI_LV_MANAGER, FALSE, WAND_GUI_LV_MANAGER);

	InitTargetVarRepository (oPc, oTarget);

}	