// ginc_utility.nss
/*
    This is the main utility script for NWN2
*/
// FAB 10/12/04
// ChazM 3/8/05	- file name changed
// BMA-OEI 8/03/05 - error checking if waypoint not valid, rewrote for legibility
// BMA-OEI 8/04/05 - added UT_FakeEncounter()
// BMA-OEI 8/28/05 - added UT_SpawnAtWP()
	
// **************
// SCRIPT DEFINES
// **************

// This function spawns resref sTemplate at each waypoint sWaypoint in the module. 
void UT_FakeEncounter(string sTemplate, string sWaypoint, int bUseAppearAnimation = FALSE);

// This function spawns someone with resref sObject at waypoint "sp_<sObject><nInstance>".
// This command can be delayed and the object can be given a new tag after being spawned.
// If a delay isn't necessary then use GN_Spawn.
void UT_SpawnDelay(string sObject, int nInstance = 0, float fDelay = 0.0, string sNewTag = "");

// This function spawns someone with resref sObject at waypoint "sp_<sObject><nInstance>".
// It can be given a new tag after it is spawned. The function returns the object ID of what was created.
// If a delay is necessary then use GN_SpawnDaly (but you won't be able to get the object ID from that function).
object UT_Spawn(string sObject, int nInstance = 0, string sNewTag = "");

object UT_SpawnAtWP(string sTemplate, string sWaypoint, string sNewTag = "", int bUseAppearAnimation = FALSE);

// ***********************************
// PRIVATE FUNCTIONS - don't use these
// ***********************************

object UT_CreateObjectAtLocation(string sObject, location lLoc, string sNewTag, int bUseAppearAnimation = FALSE)
{
	object oCreature;

	if (sNewTag == "")
	{
		oCreature = CreateObject(OBJECT_TYPE_CREATURE, sObject, lLoc);
	}
	else
	{	
		oCreature = CreateObject(OBJECT_TYPE_CREATURE, sObject, lLoc, FALSE, sNewTag);
	}
	return oCreature;
}

void UT_CreateObjectAtLocVoid(string sObject, location lLoc, string sNewTag, int bUseAppearAnimation = FALSE)
{
	UT_CreateObjectAtLocation(sObject, lLoc, sNewTag, bUseAppearAnimation);
}

// **************
// MAIN FUNCTIONS
// **************

void UT_FakeEncounter(string sTemplate, string sWaypoint, int bUseAppearAnimation = FALSE)
{
	object oWP;
	int nCount = 0;
	location lLoc;

	oWP = GetObjectByTag(sWaypoint, nCount);
	while (GetIsObjectValid(oWP) == TRUE)
	{
		lLoc = GetLocation(oWP);
		UT_CreateObjectAtLocVoid(sTemplate, lLoc, "", bUseAppearAnimation);
		nCount = nCount + 1;
		oWP = GetObjectByTag(sWaypoint, nCount);
	}
	PrintString("ginc_utility: UT_FakeEncounter() spawned " + IntToString(nCount) + " " + sTemplate);
}

void UT_SpawnDelay(string sTemplate, int nInstance = 0, float fDelay = 0.0, string sNewTag = "")
{
	object oWP;
    location lLoc;

	if (nInstance != 0)
	{
		oWP = GetWaypointByTag("sp_" + sTemplate + IntToString(nInstance));
	}
	else
	{
		oWP = GetWaypointByTag("sp_" + sTemplate);
	}
	
	if (GetIsObjectValid(oWP) == TRUE)
	{
		lLoc = GetLocation(oWP);
		DelayCommand(fDelay, UT_CreateObjectAtLocVoid(sTemplate, lLoc, sNewTag));
	}
	else
	{
		PrintString("ginc_utility: UT_SpawnDelay() invalid waypoint");
	}
}

object UT_Spawn(string sTemplate, int nInstance = 0, string sNewTag = "")
{
	object oCreature;
	object oWP;
    location lLoc;

	if (nInstance != 0)
	{
		oWP = GetWaypointByTag("sp_" + sTemplate + IntToString(nInstance));
	}
	else
	{
		oWP = GetWaypointByTag("sp_" + sTemplate);
	}
	
	if (GetIsObjectValid(oWP) == TRUE)
	{
		lLoc = GetLocation(oWP);
		oCreature = UT_CreateObjectAtLocation(sTemplate, lLoc, sNewTag);
	}
	else
	{
		PrintString("ginc_utility: UT_Spawn() invalid waypoint");
	}
	return oCreature;
}

object UT_SpawnAtWP(string sTemplate, string sWaypoint, string sNewTag = "", int bUseAppearAnimation = FALSE)
{
	object oCreature;
	object oWP = GetObjectByTag(sWaypoint);
	location lWP = GetLocation(oWP);

	oCreature = UT_CreateObjectAtLocation(sTemplate, lWP, sNewTag, bUseAppearAnimation);

	return oCreature;
}


// TEST MAIN - uncomment to debug the include file
/*void main()
{



}*/