// gui_map_transition
/*
 Transitions party to a waypoint set in a global variable.
*/
// EPF 8/18/06
// ChazM 8/22/06 - removed "kinc_worldmap" dependency.

//#include "kinc_worldmap"
#include "ginc_companion"
#include "ginc_transition"

// 
const string LAST_DESTINATION = "00_sLastDestination";
const string LAST_MODULE = "00_sLastModule";
const string PC_CLICKER = "oLastWorldMapClicker";	//this is stored on the module not 

void main()
{
	string sDestination = GetGlobalString(LAST_DESTINATION);
	string sModule = GetGlobalString(LAST_MODULE);
	
	object oPC = GetLocalObject(GetModule(), PC_CLICKER);
	
	object oDestination = GetObjectByTag(sDestination);
	
	SetCommandable(TRUE,oPC);
	ForceRestParty(oPC);
	
	if(GetIsObjectValid(oDestination))
	{
		SinglePartyTransition( oPC, oDestination );
	}
	else
	{
		SaveRosterLoadModule(sModule, sDestination);
	}
} 