//ga_roster_spawn_rand_loc
/*
	creates a list of roster names randomly disbursed in  a radius around a target
*/
// ChazM 12/5/05

#include "ginc_param_const"
#include "ginc_math"
	
	
void main(string sRosterNameList, string sTargetLocationTag, float fRadius)
{
	int nPos = 0;
	string sRosterName = GetStringParam(sRosterNameList, nPos);
	object oLocationObject = GetTarget(sTargetLocationTag, TARGET_OWNER);
	location lLocation = GetLocation(oLocationObject);
	object oSpawn;
 	location lRandLoc;

	while (sRosterName != "")
	{
		lRandLoc = GetNearbyLocation(lLocation, fRadius, 0.0f);
		oSpawn = SpawnRosterMember(sRosterName, lRandLoc);	
		sRosterName = GetStringParam(sRosterNameList, ++nPos);
	}
}
	