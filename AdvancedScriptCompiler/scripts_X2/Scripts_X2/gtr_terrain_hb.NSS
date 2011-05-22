//	gtr_terrain_hb
/*
	Heartbeat script for terrain triggers. This controls whether or not an encounter
	spawns while the party is within the boundaries of the trigger.
*/
//	NLC 2/28/08

#include "ginc_overland"
#include "ginc_misc"
#include "ginc_wp"
#include "ginc_math"

void main()
{
	int nEncounterChance	= GetLocalInt(OBJECT_SELF, VAR_ENC_CHANCE);
	int nEncounterRoll		= Random(100)+1;
	int nGameDifficulty		= GetGameDifficulty();
	
	//Encounter chance modifiers:
	//Easy: -5% chance.
	//D&D Harcore: +5% Chance.
	//Difficult: +10% Chance.
	if( nGameDifficulty <= GAME_DIFFICULTY_EASY )
	{
		nEncounterChance -= 5;
	}
	
	else if (nGameDifficulty == GAME_DIFFICULTY_CORE_RULES )
	{
		nEncounterChance += 5;
	}
	
	else if ( nGameDifficulty == GAME_DIFFICULTY_DIFFICULT )
	{
		nEncounterChance += 10;
	}
	
	object oPC 				= GetFactionLeader(GetFirstPC());
	object oEnc;
			
	string sWPTag 			= TAG_HOSTILE_SPAWN;
	string sTable, sEncounterRR; 
	int nRow;				
		
	float fCR;
	int nTerrain = GetTerrainType(OBJECT_SELF);
	float fMoveRate = GetTerrainMovementRate(nTerrain);	

	if (GetIsInSubArea(oPC))
	{
		SetMovementRateFactor(oPC, fMoveRate);
//		PrettyDebug("Debug... terrain hb running");
		/*	Don't roll for encounters if PC is in conversation.	*/
		if (IsInConversation(oPC))
		{
//			PrettyDebug("PC is in conversation. No encounter roll.");
			return;
		}
	
//		PrettyDebug("Encounter Chance: " + IntToString(nEncounterChance));
//		PrettyDebug("Encounter Roll: " + IntToString(nEncounterRoll));
	
		/*	An encounter will spawn if the Encounter Chance is met and
			sufficient time has passed between the previous encounter.	*/	
		if (nEncounterRoll <= nEncounterChance)
		{
			sTable			= GetEncounterTable(OBJECT_SELF);
			
			PrettyDebug("Encounter time!");
								
			InitializeEncounter(oPC);

		}
	}
}