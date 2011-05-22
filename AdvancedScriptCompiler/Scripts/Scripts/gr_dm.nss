// gr_dm
/*
    Summons the DM.

    This script for use with the dm_runscript console command
*/
// ChazM 11/13/05
	
#include "x0_i0_position"
#include "ginc_debug"	
	
void main()
{
	int bValid = GetIsObjectValid(OBJECT_SELF);
	PrettyDebug("GetIsObjectValid(OBJECT_SELF) returns: " + IntToString(bValid));
	location lMyLoc = GetLocation(OBJECT_SELF);

	PrettyDebug("creating DM at location: " + LocationToString(lMyLoc));

    CreateObject(OBJECT_TYPE_CREATURE, "gr_dm", lMyLoc);
}