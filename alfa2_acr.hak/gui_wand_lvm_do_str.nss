////////////////////////////////////////////////////////////////////////////////
// Local Var Manager
// Original Scripter:  Caos81      Design: Caos81
//------------------------------------------------------------------------------
// Last Modified By:   Caos81           27/01/2009
//------------------------------------------------------------------------------
////////////////////////////////////////////////////////////////////////////////

#include "wand_inc"
#include "wand_inc_misc"

void main(int iVarIndex, string sVarName, string sVarValue)
{    	
	object oSubject = OBJECT_SELF;

	if (!IsDm(oSubject)) {
		DisplayMessageBox(oSubject, -1, WAND_NO_SPAM);
        return;
    }

	object oTarget = GetLvmTarget(oSubject);

	// New var
	if (iVarIndex < 0) {

		iVarIndex = GetVariableIndex (oTarget, sVarName, VARIABLE_TYPE_STRING);
		
		// Let's check if we already have a local var with the same name and type	
		if (iVarIndex != VARIABLE_INVALID_INDEX) {
			DisplayMessageBox(oSubject, -1, WAND_ALREADY_EXISTING);
			return;
		}	
				
		SetLocalString(oTarget, sVarName, sVarValue);			
		
		// We retrieve the new var index
		iVarIndex = GetVariableIndex (oTarget, sVarName, VARIABLE_TYPE_STRING);	
			
		AddVar(oSubject, oTarget, iVarIndex);
	}
	// Changed var
	else {
		sVarName = GetVariableName(oTarget, iVarIndex);	
		
		SetLocalString(oTarget, sVarName, sVarValue);
		ModifyVar(oSubject, oTarget, iVarIndex);
	}
}