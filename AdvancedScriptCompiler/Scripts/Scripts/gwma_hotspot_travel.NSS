// gwma_hotspot_travel
/*
 	Action script for when a hotspot is selected and travel button clicked on the worldmap.  
	Determines the location to send the party.
	
	See "ginc_worldmap_constants" for info on customizing scripts for a campaign.
*/

#include "ginc_worldmap_constants"

void main()
{
	string sHotspotDestination = GetSelectedMapPointTag();
	object oPC = OBJECT_SELF;
	if (!WorldMapReady(oPC))
		return;

	// Get map name and origin (stored on PC by whoever called ShowWorldMap()).		
	string sMap 			= GetLocalString(oPC, VAR_WORLD_MAP_NAME);
	string sHotspotOrigin 	= GetLocalString(oPC, VAR_WORLD_MAP_HOTSPOT_ORIGIN);
	
	// get the 2das for this map name
	string sHotspots2DA 			= GetHotspots2DA(sMap);
	string sHotspotConnections2DA 	= GetHotspotConnections2DA(sMap);
	
	// Get the indexes - these can be used to look up any needed info from the 2da's
	// Two 2da define the basic data.  Additional columns can be added as desired.
	int iHotspotOriginRow 		= GetHotspotRow(sHotspots2DA, sHotspotOrigin);
	int iHotspotDestRow			= GetHotspotRow(sHotspots2DA, sHotspotDestination);
	int iHotspotConnectionsRow 	= GetHotspotConnectionRow(sHotspotConnections2DA, sHotspotOrigin, sHotspotDestination);
	
	// look up info specific to the hotspot origin or destination
	string sHotspotOriginWPTag = Get2DAString(sHotspots2DA, COL_WP_TAG, iHotspotOriginRow);
	string sHotspotOriginModule = Get2DAString(sHotspots2DA, COL_MODULE, iHotspotOriginRow);

	string sHotspotDestWPTag = Get2DAString(sHotspots2DA, COL_WP_TAG, iHotspotDestRow);
	string sHotspotDestModule = Get2DAString(sHotspots2DA, COL_MODULE, iHotspotDestRow);

	
	// look up info specific to the connection of the origin and destination
	string sHotspotConnectionsTravelTime = Get2DAString(sHotspotConnections2DA, COL_TRAVEL_TIME_TAG, iHotspotConnectionsRow);

	// ==========================================================================
	//  Standard Processing
	// ==========================================================================
	// use various 2da lookups to do standard processing here.
	
	

		
	// ==========================================================================
	// Special Exceptions Processing 
	// ==========================================================================


	// travel to sHotspotDestination
	TravelToHotspot(oPC, sHotspots2DA, sHotspotDestination);
}