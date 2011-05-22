// ga_hotspots_match_range_vis(int bVisible, string sMap, string sCol, int nMin, int nMax)
/*
	Flag all hotspots with matching numeric range criteria to bVisible
	Sets vars that are to be referenced in the world map condition script
	
	Params:
		int bVisible 	- 0 = hidden, 1 = visible
		string sMap 	- map name (do not include the ".wmp" extension)
		string sCol		- colum to look at in the map hotspots 2da (<map>_hs.2da)
		int nMin		- minimum value
		int nMax		- max value
		
		Note: if nMax < nMin, the range wraps; i.e. the range is all values not between max and min.
		
	Example: 
		set all hotspot marked 20-29 in column "RefNum" to be visible for map "Rashemen":
		ga_hotspots_match_range_vis(1,"Rashemen", "RefNum", 20, 29)

		set all hotspot not marked 40-59 (i.e. >=60 or <=39) in column "RefNum" to be hidden for map "Rashemen":
		ga_hotspots_match_range_vis(0,"Rashemen", "RefNum", 60, 39)
		
			
*/	
// ChazM 4/26/07
// ChazM 5/1/07 - func name change
	
#include "ginc_worldmap"
	
void main(int bVisible, string sMap, string sCol, int nMin, int nMax)
{
	FlagHotspotsMatchingRangeVisibility(bVisible, sMap, sCol, nMin, nMax);	
}