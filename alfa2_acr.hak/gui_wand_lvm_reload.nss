////////////////////////////////////////////////////////////////////////////////
// Local Var Manager
// Original Scripter:  Caos81      Design: Caos81
//------------------------------------------------------------------------------
// Last Modified By:   Caos81           02/02/2009
//------------------------------------------------------------------------------
////////////////////////////////////////////////////////////////////////////////

#include "wand_inc"

void main()
{
	
	object oPc = OBJECT_SELF;
	
	if (!IsDm(oPc)) {
		DisplayMessageBox(oPc, -1, WAND_NO_SPAM);
		return;
	}
	
	object oTarget = GetLvmTarget(oPc);
	
	ResetTargetVarRepository(oPc);
	InitTargetVarRepository (oPc, oTarget);
}	