////////////////////////////////////////////////////////////////////////////////
// Local Var Manager
// Original Scripter:  Caos81      Design: Caos81
//------------------------------------------------------------------------------
// Last Modified By:   Caos81           05/02/2009
//------------------------------------------------------------------------------
////////////////////////////////////////////////////////////////////////////////

#include "wand_inc"

void main(string sTabName) {
	
	object oPc = OBJECT_SELF;
		
	if (!IsDm(oPc)) {
		DisplayMessageBox(oPc, -1, WAND_NO_SPAM);
		return;
	}

	ResetListBoxesSelection (oPc);
	HideTabs(oPc);
	SetGUIObjectHidden(oPc, WAND_GUI_PC_INVENTORY, sTabName, FALSE);
}	