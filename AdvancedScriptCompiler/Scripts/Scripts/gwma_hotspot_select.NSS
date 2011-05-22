// gwma_hotspot_select
/*
	Select script for when a hotspot is first selected (and highlighted) on the worldmap.  
	
	See "ginc_worldmap_constants" for info on customizing scripts for a campaign.
*/
// ChazM 4/26/07
// ChazM 6/25/07 - removed call to WorldMapReady() as this has side effect of setting lock time.

#include "ginc_worldmap_constants"

// GUI elements
const string GUI_SCREEN_WORLDMAP 		= "SCREEN_WORLDMAP";
const string GUI_TRIP_WARNING_TEXT 		= "TripWarningTXT";


void main()
{
	string sHotspotDestination = GetSelectedMapPointTag();
	object oPC = OBJECT_SELF;
	//if (!WorldMapReady(oPC))
	//	return;
		
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
	// use various 2da lookup to do standard processing here.
	
	

		
	// ==========================================================================
	// Special Exceptions Processing
	// ==========================================================================

	
	
	//SetGUIObjectText(oPC, GUI_SCREEN_WORLDMAP, GUI_TRIP_WARNING_TEXT, -1, "Some Text to display");
}