//::///////////////////////////////////////////////////////////////////////////
//::
//::	ginc_roster.nss
//::
//::	Various Roster List management functions
//::
//::///////////////////////////////////////////////////////////////////////////
//::
//::	Created by: BMA-OEI
//::	Created on: 10/18/05
//::
//::///////////////////////////////////////////////////////////////////////////

#include "ginc_debug"


//-------------------------------------------------
// Function Prototypes
//-------------------------------------------------

void PrintRosterList();
void AddCompanionsToRosterList();
void ClearRosterList();
void TestAddRosterMemberByTemplate(string sRosterName, string sTemplate);
void TestRemoveRosterMember(string sRosterName);


//-------------------------------------------------
// Function Definitions
//-------------------------------------------------

// List roster member names on screen
void PrintRosterList()
{
	int nCount = 0;
	string sRosterName = GetFirstRosterMember();

	PrettyMessage("Printing Roster List...");

	while (sRosterName != "")
	{
		nCount = nCount + 1;
		PrettyMessage(" Member " + IntToString(nCount) + ": " + sRosterName);
		sRosterName = GetNextRosterMember();
	}
	
	PrettyMessage("Roster List finished (" + IntToString(nCount) + " members).");
}

// Add all campaign companions to roster
void AddCompanionsToRosterList()
{
	TestAddRosterMemberByTemplate("ammon_jerro", "co_ammon_jerro");
	TestAddRosterMemberByTemplate("bishop", "co_bishop");
	TestAddRosterMemberByTemplate("casavir", "co_casavir");
	TestAddRosterMemberByTemplate("construct", "co_construct");
	TestAddRosterMemberByTemplate("elanee", "co_elanee");
	TestAddRosterMemberByTemplate("grobnar", "co_grobnar");
	TestAddRosterMemberByTemplate("khelgar", "co_khelgar");
	TestAddRosterMemberByTemplate("neeshka", "co_neeshka");
	TestAddRosterMemberByTemplate("qara", "co_qara");
	TestAddRosterMemberByTemplate("sand", "co_sand");
	TestAddRosterMemberByTemplate("shandra", "co_shandra");
	TestAddRosterMemberByTemplate("zhjaeve", "co_zhjaeve");
}

// Remove all members from roster
void ClearRosterList()
{
	int nCount = 0;
	int bSuccess = 0;
	string sMember = GetFirstRosterMember();
	
	while (sMember != "")
	{
		nCount++;
		bSuccess = RemoveRosterMember(sMember);
		if (bSuccess == TRUE)
		{
			PrettyMessage("ginc_roster: ClearRosterList() successfully removed " + sMember);
		}	
		else
		{
			PrettyError("ginc_roster: ClearRosterList() could not find " + sMember);
		}
		sMember = GetFirstRosterMember();
	}
}

// Attempt AddRosterMemberByTemplate()
void TestAddRosterMemberByTemplate(string sRosterName, string sTemplate)
{
	int bResult = AddRosterMemberByTemplate(sRosterName, sTemplate);
	if (bResult == TRUE)
	{
		PrettyMessage("ginc_roster: successfully added " + sRosterName + " (" + sTemplate + ")");	
	}
	else
	{
		PrettyError( "ginc_roster: failed to add " + sRosterName + " (" + sTemplate + ")");
	}
}

// Attempt RemoveRosterMember()
void TestRemoveRosterMember(string sMember)
{
	int bResult = RemoveRosterMember(sMember);
	if (bResult == TRUE)
	{
		PrettyMessage("ginc_roster: successfully removed " + sMember);
	}
	else
	{
		PrettyError("ginc_error: failed to remove " + sMember);	
	}
}

//void main(){}