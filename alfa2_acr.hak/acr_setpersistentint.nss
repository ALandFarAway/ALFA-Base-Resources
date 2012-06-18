// Generic script to set a persistent ACR integer, for use in conversation conditionals
//    Default sets the given integer to the given value. 
//      -bDeleteVar = TRUE (1) will delete the integer for PCSpeaker instead.

#include "acr_db_persist_i"

void main(string sVariableName, int nVariableValue, int bDeleteVar)
{   
	object oPC = GetPCSpeaker(); 

	if (bDeleteVar == TRUE) {
		ACR_DeletePersistentVariable(oPC, sVariableName);
	} else {
		ACR_SetPersistentInt(oPC, sVariableName, nVariableValue);
	}
}
 

