// ga_rm_set_hangout(string sRosterName, string sHangOutWPTag)
/*
	Sets the "hangout" to the tag of where this roster member should hang out.
	
	Parameters:
		string sRosterName	- the roster name of the character. "" = dialog owner
		string sHangOutWPTag - the tag of the waypoint where the character should hang out at.
	
			
	ga_go_to_hangout()
	This should be used in conjunction with a call to SpawnNonPartyRosterMemberAtHangout() in the module load script.
	
*/
// ChazM 5/1/07 

#include "ginc_companion"

void main (string sRosterName, string sHangOutWPTag)
{
	if (sRosterName == "")
	{
		object oSelf = OBJECT_SELF;
		string sRosterName = GetRosterNameFromObject(oSelf);
		if (sRosterName == "")
		{
			PrettyError("ga_set_hangout failed - couldn't get Roster Name for " + GetName(oSelf));
			return;
		}
	}

	SetHangOutSpot(sRosterName, sHangOutWPTag);
}