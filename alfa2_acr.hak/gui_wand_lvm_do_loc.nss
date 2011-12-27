////////////////////////////////////////////////////////////////////////////////
// Local Var Manager
// Original Scripter:  Caos81      Design: Caos81
//------------------------------------------------------------------------------
// Last Modified By:   Caos81           27/01/2009
//------------------------------------------------------------------------------
////////////////////////////////////////////////////////////////////////////////

#include "wand_inc"
#include "wand_inc_misc"


void main(int iVarIndex, string sVarName, float fVarValueX, float fVarValueY, float fVarValueZ, int iVarValueArea, float fVarValueOrientation) {    	
	
	object oSubject = OBJECT_SELF;

	// SECURITY CHECK
	if (!IsDm(oSubject)) {
		DisplayMessageBox(oSubject, -1, WAND_NO_SPAM);
        return;
    }

	object oArea = IntToObject(iVarValueArea);
	
	// Consistency check
	if (!GetIsObjectValid(oArea) && iVarValueArea >= 0) {
		DisplayMessageBox(oSubject, -1, WAND_WRONG_VALUES);
		return;
	}

	object oTarget = GetLvmTarget(oSubject);
	location lLocation = Location(oArea, Vector(fVarValueX, fVarValueY, fVarValueZ), fVarValueOrientation);
	
	// New var
	if (iVarIndex < 0) {
		iVarIndex = GetVariableIndex (oTarget, sVarName, VARIABLE_TYPE_LOCATION);
		
		// Let's check if we already have a local var with the same name and type	
		if (iVarIndex != VARIABLE_INVALID_INDEX) {
			DisplayMessageBox(oSubject, -1, WAND_ALREADY_EXISTING);
			return;
		}	
				
		SetLocalLocation(oTarget, sVarName, lLocation);			
		
		// We retrieve the new var index
		iVarIndex = GetVariableIndex (oTarget, sVarName, VARIABLE_TYPE_LOCATION);	
			
		AddVar(oSubject, oTarget, iVarIndex);
	}
	// Changed var
	else {
		sVarName = GetVariableName(oTarget, iVarIndex);	
		
		SetLocalLocation(oTarget, sVarName, lLocation);
		ModifyVar(oSubject, oTarget, iVarIndex);
	}	
}