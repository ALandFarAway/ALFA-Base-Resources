// ga_hotspots_match_str_vis(int bVisible, string sMap, string sCol, string sMatchValue, string sMatchSpecifications)
/*
	Flag all hotspots with matching value criteria to bVisible
	Sets vars that are to be referenced in the world map condition script
	
	Params:
		int bVisible 	- 0 = hidden, 1 = visible
		string sMap 	- map name (do not include the ".wmp" extension)
		string sCol		- colum to look at in the map hotspots 2da (<map>_hs.2da)
		string sMatchValue	- Value to match.
		string sMatchSpecifications - reserved for later use, but empty string = exact match
		
	Example: 
		set all hotspot in module "A_X1" to be visible for map "Rashemen":
		ga_flag_matching_hotspots(1,"Rashemen", "Module", "A_X1")
	
*/	
// ChazM 4/26/07
// ChazM 5/1/07 - func name change
	
#include "ginc_worldmap"
	
void main(int bVisible, string sMap, string sCol, string sMatchValue, string sMatchSpecifications)
{
	FlagHotspotsMatchingStringVisibility(bVisible, sMap, sCol, sMatchValue);	
}