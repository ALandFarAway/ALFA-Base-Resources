// ginc_baddie_stream
/*
	include for streaming baddies
*/
// ChazM 10/29/95		
#include "ginc_misc"	
		
const string WP_PREFIX 		= "wp_";
const string SPAWNED_SUFFIX = "_spawned";
const string NEEDED_SUFFIX	= "_needed";
const string KILLED_SUFFIX	= "_killed";

int GetBaddiesVar(string sSuffix, string sTemplate);
int IncrementBaddiesVar(string sSuffix, string sTemplate, int nCount=1);
void RandomSpawn(string sTemplate, string sWaypoint);
int MaxAB(int a, int b);

//void main() {} 
	
// This will create a steady stream of creatures of the specific type
// string sResRef - template of creatrure
// int iMaxBaddies - max number of baddies to spawn in
// on death needs to be set to use script similar to b_baddy_death template
// waypoints should be named "wp_" + resref of creature.
void CreateStreamedEncounter(string sResRef, int iMaxBaddies)
{
	// Spawn trial baddies
 	string sSpawnPointTag = WP_PREFIX + sResRef;
	int nBaddiesSpawned = SpawnCreaturesAtWPs(sResRef, sSpawnPointTag);
	IncrementBaddiesVar(SPAWNED_SUFFIX, sResRef, nBaddiesSpawned);

	// Track victory condition
	int nBaddiesNeeded = MaxAB(nBaddiesSpawned, iMaxBaddies);
	IncrementBaddiesVar(NEEDED_SUFFIX, sResRef, nBaddiesNeeded);

}

int GetBaddiesVar(string sSuffix, string sTemplate)
{
	object oModule = GetModule();
	string sVariable = sTemplate + sSuffix;
	int nRet = GetLocalInt(oModule, sVariable);
	//DebugMessage(sTemplate + " has spawned " + IntToString(nRet), 150, 150); 
	return (nRet);
}

int IncrementBaddiesVar(string sSuffix, string sTemplate, int nCount=1)
{
	object oModule = GetModule();
	string sVariable = sTemplate + sSuffix;
	int nSpawned = GetLocalInt(oModule, sVariable);
	nSpawned = nSpawned + nCount;
	SetLocalInt(oModule, sVariable, nSpawned);
	return (nSpawned);
}

void RandomSpawn(string sTemplate, string sWaypoint)
{
	DebugPostString(GetFirstPC(), "RandomSpawn(" + sTemplate + "," + sWaypoint + ")", 100, 100, 5.0f);
	DebugMessage("random spawn " + sTemplate + " at " + sWaypoint);
	object oWP = GetRandomObjectInArea(sWaypoint);
	location lWP = GetLocation(oWP);
	CreateObject(OBJECT_TYPE_CREATURE, sTemplate, lWP, TRUE);
	IncrementBaddiesVar(SPAWNED_SUFFIX, sTemplate, 1);	
}


// Return max between a or b
int MaxAB(int a, int b)
{
	if (a > b)
	{
		return (a);
	}
	else
	{
		return (b);
	}
}
