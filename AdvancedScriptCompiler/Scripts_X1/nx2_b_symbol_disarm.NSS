// nx2_b_symbol_disarm
/*
	Disarm script for symbol spell trap portion. Checks to see if corresponding AOE is still 
	around and if not destroys itself.
*/
// MDiekmann 8/31/07

#include "ginc_debug"
#include "ginc_event_handlers"

void main()
{	
	string sType 		= GetLocalString(OBJECT_SELF, "Symbol_Type");
	string sAOETag 		= "symbol_of_" + sType;
	object oAOE 		= GetNearestObjectByTag(sAOETag);
	
	PrettyDebug("Looking for " + sAOETag);
	
	DestroyObject(oAOE);
	PrettyDebug("Destroying " + sAOETag);
}