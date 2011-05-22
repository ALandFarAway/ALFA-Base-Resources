// gc_rm_in_hangout_area(string sRosterName)
/*
	Check if Roster Member is in the same "area" as his currently set hangout spot.
	(hangout can be set with ga_set_hangout)
	
	Parameters:
		string sRosterName	- the roster name of the character. "" = dialog owner
			
*/
// ChazM 5/4/07 

#include "ginc_companion"


int StartingConditional(string sRosterName)
{
	if (sRosterName == "")
	{
		object oSelf = OBJECT_SELF;
		string sRosterName = GetRosterNameFromObject(oSelf);
		if (sRosterName == "")
		{
			PrettyError("gc_rm_in_hangout_area failed - couldn't get Roster Name for " + GetName(oSelf));
		}
	}
	
	return (GetIsInHangOutArea(sRosterName));
}