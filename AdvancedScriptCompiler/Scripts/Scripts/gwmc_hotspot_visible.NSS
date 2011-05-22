// gwmc_hotspot_visible()
/*
	Conditional script for world map hotspots (aka Map Points).  Returns TRUE if this hotspot should be displayed
	on the world map.  Hotpsots will not display until they are flagged to show using ShowHotspot() in "ginc_worldmap"
	
	See "ginc_worldmap_constants" for info on customizing scripts for a campaign.
*/	
// ChazM 4/26/07

#include "ginc_worldmap_constants"
	
int StartingConditional()
{
	string sHotspot = GetSelectedMapPointTag();
	object oPC = OBJECT_SELF;
	
	if (GetGlobalInt("HotspotsVisibleDebug"))
		return (TRUE);
	
	// Get map name and origin (stored on PC by whoever called ShowWorldMap()).		
	string sMap 			= GetLocalString(oPC, VAR_WORLD_MAP_NAME);
	//string sHotspotOrigin 	= GetLocalString(oPC, VAR_WORLD_MAP_HOTSPOT_ORIGIN);
	
	// check the "visible" flag.  Hotspots are hidden until Visible flag is set.
 	int iVisible = GetHotspotVisibleFlag(sMap, sHotspot);

	// ==========================================================================
	// Campaign specific code
	// ==========================================================================
/*		 	
	// example:
	if (sHotspot == HS_MAUSOLEUM)
	{
		// gnomes always see this location.
		// dwarves see it if marked visible
		// all others don't see it.
		if (GetRacialType(oPC) == RACIAL_TYPE_GNOME)
			iVisible = TRUE;
		else if (GetRacialType(oPC) != RACIAL_TYPE_DWARF)
			iVisible = FALSE;
	}
	
	if (sHotspot == HS_SCRUBLAND)
	{
		// everyone always see this location
		iVisible = TRUE;
	}
*/
				
	return (iVisible);
}	