////////////////////////////////////////////////////////////////////////////////
// Local Var Manager
// Original Scripter:  Caos81      Design: Caos81
//------------------------------------------------------------------------------
// Last Modified By:   Caos81           27/01/2009
//------------------------------------------------------------------------------
////////////////////////////////////////////////////////////////////////////////

#include "wand_inc"
#include "wand_inc_misc"


void main(int iVarIndex, string sVarName, float fVarValue)
{    	
	object oSubject = OBJECT_SELF;

	// SECURITY CHECK
	if (!IsDm(oSubject)) {
		DisplayMessageBox(oSubject, -1, WAND_NO_SPAM);
        return;
    }
	
	object oTarget = GetLvmTarget(oSubject);
	
	// New var
	if (iVarIndex < 0) {
	
		iVarIndex = GetVariableIndex (oTarget, sVarName, VARIABLE_TYPE_FLOAT);
		
		// Let's check if we already have a local var with the same name and type	
		if (iVarIndex != VARIABLE_INVALID_INDEX) {
			DisplayMessageBox(oSubject, -1, WAND_ALREADY_EXISTING);
			return;
		}	
		
		SetLocalFloat(oTarget, sVarName, fVarValue);			
		
		// We retrieve the new var index
		iVarIndex = GetVariableIndex (oTarget, sVarName, VARIABLE_TYPE_FLOAT);	
			
		AddVar(oSubject, oTarget, iVarIndex);
	}
	// Changed var
	else {
		sVarName = GetVariableName(oTarget, iVarIndex);	
		
		SetLocalFloat(oTarget, sVarName, fVarValue);
		ModifyVar(oSubject, oTarget, iVarIndex);
	}	
}