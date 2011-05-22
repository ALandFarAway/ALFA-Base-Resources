// ga_load_mod
//
// Loads a module, including any data that may have been affected by the player during previous
// visits.  (As opposed to ga_start_mod, which gives you a brand-new copy of the module.)
	
// sModule is the filename of the module, minus the .mod extension.
// sWaypoint is the tag of the waypoint from which the player will begin the module.
// If no waypoint is supplied, the module's default start location is used instead.
	
// EPF 1/16/06
// BMA-OEI 4/12/06 - replaced LNM() with SRLM()

#include "ginc_companion"
	
void main( string sModule, string sWaypoint )
{
	SaveRosterLoadModule( sModule, sWaypoint );
}