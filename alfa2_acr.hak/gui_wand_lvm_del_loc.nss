////////////////////////////////////////////////////////////////////////////////
// Local Var Manager
// Original Scripter:  Caos81      Design: Caos81
//------------------------------------------------------------------------------
// Last Modified By:   Caos81           27/01/2009
//------------------------------------------------------------------------------
////////////////////////////////////////////////////////////////////////////////

#include "wand_inc"
#include "wand_inc_misc"


void main(int iVarIndex)
{    	
	object oSubject = OBJECT_SELF;
	
	// SECURITY CHECK
	if (!IsDm(oSubject)) {
		DisplayMessageBox(oSubject, -1, WAND_NO_SPAM);
        return;
    }
	
	object oTarget = GetLvmTarget(oSubject);
		
	// Consistency check
	if (GetVariableType(oTarget, iVarIndex) == VARIABLE_TYPE_NONE) {
		DisplayMessageBox(oSubject, -1, WAND_WRONG_VALUES);
		return;
	}		

	string sVarName = GetVariableName(oTarget, iVarIndex);		
	
	DeleteLocalLocation(oTarget, sVarName);
	
	ResetTargetVarRepository (oSubject);
	InitTargetVarRepository(oSubject, oTarget);	
}