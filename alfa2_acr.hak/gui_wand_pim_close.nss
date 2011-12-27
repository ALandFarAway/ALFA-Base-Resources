////////////////////////////////////////////////////////////////////////////////
// PC Inventory Manager
// Original Scripter:  Caos81      Design: Caos81
//------------------------------------------------------------------------------
// Last Modified By:   Caos81           03/02/2009
//------------------------------------------------------------------------------
////////////////////////////////////////////////////////////////////////////////

#include "wand_inc"

void main(int iTarget) {

	object oPc = OBJECT_SELF;

	if (!IsDm(oPc)) {
		DisplayMessageBox(oPc, -1, WAND_NO_SPAM);
		return;
	}

	SetPimTarget(oPc, OBJECT_INVALID);
}	