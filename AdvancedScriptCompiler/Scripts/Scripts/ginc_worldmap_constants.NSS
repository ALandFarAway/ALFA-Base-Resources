// ginc_worldmap_constants
/*
	Holds world map constants specific to a campaign
	
	To customize the worldmap behavior, copy the following scripts into the campaign folder and modify as desired:
		gwmc_hotspot_visible
		gwma_hotspot_select
		gwma_hotspot_travel
		ginc_worldmap_constants

	You will also need two 2da files - one for the list of hotspots and one indicating the connections between them.
	See "ginc_worldmap" for more details on the 2da file names and columns.
			
*/
// ChazM 4/26/07
#include "ginc_worldmap"


// Modules
const string MODULE_EXAMPLE	= "SomeModule";


// Location Tags - example
const string HS_ORCHARD 	= "orchard";	// location description here.
const string HS_MAUSOLEUM 	= "mausoleum";	// location description here.
const string HS_SCRUBLAND 	= "scrubland";	// location description here.
