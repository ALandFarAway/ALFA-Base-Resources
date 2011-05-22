//ga_roster_spawn
/*
//RWT-OEI 09/15/05
//Takes a roster name and script location and places an instance of the
//NPC there if possible.  If the NPC already exists somewhere in the
//module, it will move that NPC to the given location. If the NPC does
//not exist, it will spawn in a new instance of the NPC from the roster
//and place them at the given location. The return value is
//the object ID of the newly spawned NPC, or INVALID_OBJECT if there
//was some error encountered
object SpawnRosterMember( string sRosterName, location lLocation );	
*/
// ChazM 12/2/05

#include "ginc_param_const"
	
void main(string sRosterName, string sTargetLocationTag)
{
	object oLocationObject = GetTarget(sTargetLocationTag, TARGET_OWNER);
	location lLocation = GetLocation(oLocationObject);
	object oSpawn = SpawnRosterMember(sRosterName, lLocation);	
}
	