// nx2_b_symbol_hb
/*
	Heartbeat script for symbol spell trap portion. Checks to see if corresponding AOE is still 
	around and if not destroys itself.	
*/
// MDiekmann 8/31/07

#include "ginc_debug"

void main()
{
	string sType 	= GetLocalString(OBJECT_SELF, "Symbol_Type");
	string sAOETag 	= "symbol_of_" + sType;
	object oAOE 	= GetObjectByTag(sAOETag);
	
	PrettyDebug("Looking for " + sAOETag);
	
	if(!GetIsObjectValid(oAOE))
	{
		DestroyObject(OBJECT_SELF);
		PrettyDebug("Destroying self");
	}
}