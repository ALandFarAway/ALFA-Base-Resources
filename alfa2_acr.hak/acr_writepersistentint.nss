// Generic script to write out a persistent int, for use in conversation actions

#include "acr_db_persist_i"

void main(string sVariableName)
{   
	object oPC = GetPCSpeaker(); 

	SendMessageToPC(oPC, "The slip of parchment reads '" + IntToString(ACR_GetPersistentInt(oPC, sVariableName)) + "'");
}
 

