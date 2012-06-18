// Generic script to add to a persistent ACR integer, for use in conversation conditionals
//    Default adds the given integer to the given value. 

#include "acr_db_persist_i"

void main(string sVariableName, int nVariableValue)
{   
	object oPC = GetPCSpeaker(); 

	ACR_SetPersistentInt(oPC, sVariableName, 
		ACR_GetPersistentInt(oPC, sVariableName) + nVariableValue);
}
 

