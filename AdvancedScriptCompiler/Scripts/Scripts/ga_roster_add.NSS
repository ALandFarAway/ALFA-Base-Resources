//::///////////////////////////////////////////////////////////////////////////
//::
//::	ga_roster_add.nss
//::
//::	Add creature by template to global roster.
//::	
//::	Parameters:
//::		string sRosterName = 10-character name to reference in other
//::								roster or party functions.
//::		string sTemplate   = Creature template to add to roster
//::
//::///////////////////////////////////////////////////////////////////////////
//::
//::	Created by: Ben Ma
//::	Created on: 10-25-05
//::
//::///////////////////////////////////////////////////////////////////////////

#include "ginc_debug"

void main(string sRosterName, string sTemplate)
{
	int bResult = AddRosterMemberByTemplate(sRosterName, sTemplate);
	if (bResult == TRUE)
	{
		PrettyMessage("ga_roster_add: successfully added " + sRosterName + " (" + sTemplate + ")");	
	}
	else
	{
		PrettyError( "ga_roster_add: failed to add " + sRosterName + " (" + sTemplate + ")");
	}
}