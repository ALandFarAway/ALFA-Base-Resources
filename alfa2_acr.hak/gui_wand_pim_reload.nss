////////////////////////////////////////////////////////////////////////////////
// PC Inventory Manager
// Original Scripter:  Caos81      Design: Caos81
//------------------------------------------------------------------------------
// Last Modified By:   Caos81           03/02/2009
//------------------------------------------------------------------------------
////////////////////////////////////////////////////////////////////////////////

// This script routes or executes all Player UI input.

#include "wand_inc"

void main() {

	object oPc = OBJECT_SELF;
	
	if (!IsDm(oPc)) {
		DisplayMessageBox(oPc, -1, WAND_NO_SPAM);
		return;
	}

	object oTarget = GetPimTarget(oPc); 
	ResetInventoryListboxes(oPc);
	DisplayInventory (oPc, oTarget);
}	