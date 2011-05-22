// gb_comp_rest
/*
	companion On Rest
*/
// ChazM 12/5/05

#include "ginc_debug"

void main()
{
	object oPC = GetLastPCRested();
	int nType = GetLastRestEventType();
	
	//PrettyMessage("gb_comp_rest: rest event fired for " + GetName(oPC) + " type " + IntToString(nType));

}