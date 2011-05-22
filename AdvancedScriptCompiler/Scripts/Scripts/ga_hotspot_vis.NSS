// ga_hotspot_vis(int bVisible, string sMap, string sHotspot)
/*
	Flag sHotspot on sMap as bVisible
	Sets a var that is to be referenced in the world map condition script
	
	Params:
		int bVisible 		- 0 = hidden, 1 = visible
		string sMap 		- map name (do not include the ".wmp" extension)
		string sHotspot		- the "name" of a Map Point
	
*/
// ChazM 4/26/07
// ChazM 5/1/07 - func name change

#include "ginc_worldmap"
		
void main(int bVisible, string sMap, string sHotspot)
{
	FlagHotspotVisibility(bVisible, sMap, sHotspot);
}