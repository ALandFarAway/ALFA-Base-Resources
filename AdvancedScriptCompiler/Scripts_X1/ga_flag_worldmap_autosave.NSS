// ga_flag_worldmap_autosave(int bOn)
/*
	Description:
	
	Sets whether or not accessing the world map does a single player autosave.
	
	(only applies to calls to DoShowWorldMap() in "ginc_worldmap"
	
*/
// ChazM 6/11/07

#include "x2_inc_switches"

void main(int bOn)
{
	SetGlobalInt(CAMPAIGN_SWITCH_WORLD_MAP_AUTO_SAVE, bOn);
}