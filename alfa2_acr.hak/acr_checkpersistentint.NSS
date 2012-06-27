// Generic script to check a persistent ACR integer, for use in conversation conditionals
//    Default checks whether the given variable is TRUE (=1) for the PCSpeaker.
//    if bLessThan is true, also return if value is < value given

#include "acr_db_persist_i"

int StartingConditional(string sVariableName, int sVariableValue, int bLessThan)
{   
	object oPC = GetPCSpeaker(); 
	int sVal = ACR_GetPersistentInt(oPC, sVariableName);


	if (sVal == sVariableValue) {
		return TRUE;
	} else if ((sVal < sVariableValue) && (bLessThan))
		return TRUE;

	return FALSE;
}
 
