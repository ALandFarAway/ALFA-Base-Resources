// ga_rm_go_to_hangout(string sRosterName)
/*
	Makes Roster Member leave the party and go to his hangout.
	(hangout can be set with ga_set_hangout)
	
	Parameters:
		string sRosterName	- the roster name of the character. "" = dialog owner
			
	This should be used in conjunction with a call to SpawnNonPartyRosterMemberAtHangout() in the module load script.
	
	This script will change the hangout location automatically if the roster members hangout is not set, or is set to "spawn_<roster name>"
	The hangout will be changed to "hangout_<roster name>"
	
*/
// ChazM 5/1/07 
// ChazM 6/18/07 - Added defualt hangout change.

#include "ginc_companion"

int IsHangoutSpawnOrBlank(string sRosterName)
{
	int nRet = FALSE;
	
	string sHangoutSpot = GetHangOutSpot(sRosterName);
	string sStandardSpawnTag = "spawn_" + sRosterName;
	if ((sHangoutSpot == "") || (sHangoutSpot == sStandardSpawnTag))
		nRet = TRUE;
		
	return (nRet);		
}

// the standard hangout spot is "hangout_<roster name>"
void SetStandardHangout(string sRosterName)
{
	string sStandardHangoutTag = "hangout_" + sRosterName;
	SetHangOutSpot(sRosterName, sStandardHangoutTag);
}

void main (string sRosterName)
{
	if (sRosterName == "")
	{
		object oSelf = OBJECT_SELF;
		string sRosterName = GetRosterNameFromObject(oSelf);
		if (sRosterName == "")
		{
			PrettyError("ga_rm_go_to_hangout failed - couldn't get Roster Name for " + GetName(oSelf));
			return;
		}
	}
	
	// change to default hangout spot if using the standard spawn or if not set
	if (IsHangoutSpawnOrBlank(sRosterName))
		SetStandardHangout(sRosterName);
	
	GoToHangOutSpot(sRosterName);
}