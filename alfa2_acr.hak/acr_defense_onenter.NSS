#include "acr_quest_i"

const string ACR_QST_FAILURE_STATE = "ACR_QST_FAILURE_STATE";
const string DEFENSE_QUEST_ID = "DEF_QST_ID";
const string DEFENSE_QUEST_COUNTER = "DEF_QST_COUNTER";

const string DEFENSE_QUEST_TRICKLE_DELAY = "DEF_QST_TRICKLE_DELAY";
const string DEFENSE_QUEST_INITIAL_DELAY = "DEF_QST_INITIAL_DELAY";
const string DEFENSE_QUEST_WAVE_DELAY = "DEF_QST_WAVE_DELAY";

const string DEFENSE_QUEST_SPAWN_WAYPOINT = "DEF_QST_SPAWN_WAYPOINT";
const string DEFENSE_QUEST_WALK_WAYPOINT = "DEF_QST_WALK_WAYPOINT";

const string DEFENSE_QUEST_TRICKLE_SPAWN_CREATURE = "DEF_QST_TRICKLE_SPAWN_";
const string DEFENSE_QUEST_WAVE_SPAWN_CREATURE = "DEF_QST_WAVE_SPAWN_";

const string DEFENSE_QUEST_START_MESSAGE = "DEF_QST_START_MESSAGE";
const string DEFENSE_QUEST_WAVE_MESSAGE = "DEF_QST_WAVE_MESSAGE";
const string DEFENSE_QUEST_END_MESSAGE = "DEF_QST_END_MESSAGE";

void ACR_AdvanceDefenseQuest(int questID)
{
	int lowerState = GetLocalInt(OBJECT_SELF, ACR_QST_LOWER_STATE);
	int upperState = GetLocalInt(OBJECT_SELF, ACR_QST_UPPER_STATE);
	string sQuest = GetLocalString(OBJECT_SELF, ACR_QST_NAME);
	
	object oPC = GetFirstPC(TRUE);
	while(GetIsObjectValid(oPC))
	{
		if(ACR_RetrieveQuestState(sQuest, oPC) == lowerState &&
		   GetLocalInt(oPC, DEFENSE_QUEST_ID) == questID)
		{
			ACR_AddPersistentJournalQuestEntry(sQuest, upperState, oPC, FALSE, FALSE, TRUE, 0, 0.0f);
		}
		oPC = GetNextPC(TRUE);
	}
}

void ACR_FailDefenseQuest(int questID)
{
	int lowerState = GetLocalInt(OBJECT_SELF, ACR_QST_LOWER_STATE);
	int failState = GetLocalInt(OBJECT_SELF, ACR_QST_FAILURE_STATE);
	string sQuest = GetLocalString(OBJECT_SELF, ACR_QST_NAME);
	
	object oPC = GetFirstPC(TRUE);
	while(GetIsObjectValid(oPC))
	{
		if(ACR_RetrieveQuestState(sQuest, oPC) == lowerState &&
		   GetLocalInt(oPC, DEFENSE_QUEST_ID) == questID)
		{
			ACR_AddPersistentJournalQuestEntry(sQuest, failState, oPC, FALSE, FALSE, TRUE, 0, 0.0f);
		}
		oPC = GetNextPC(TRUE);
	}	
}

int ACR_CheckForDefenseFailure()
{
	object oEntering = GetEnteringObject();
	if(GetIsPC(oEntering)) return FALSE;
	
	object oContained = GetFirstInPersistentObject();
	while(GetIsObjectValid(oContained))
	{
		if(GetIsPC(oContained) && !GetIsDMPossessed(oContained)) return FALSE;
		if(GetIsPC(GetMaster(oContained))) return FALSE;
		oContained = GetNextInPersistentObject();
	}
	return TRUE;
}

void _DefenseSpawnMove(object oCreature, int questID)
{
	if(!GetIsObjectValid(oCreature)) return;
	if(GetLocalInt(OBJECT_SELF, DEFENSE_QUEST_ID) != questID) return;
	
	int nAction = GetCurrentAction(oCreature);
	if(nAction == ACTION_INVALID ||
	   nAction == ACTION_WAIT)
	{
		object oMovePoint = GetWaypointByTag(GetLocalString(OBJECT_SELF, DEFENSE_QUEST_WALK_WAYPOINT));
		AssignCommand(oCreature, ActionMoveToLocation(GetLocation(oMovePoint), TRUE));
	}
	DelayCommand(6.0f, _DefenseSpawnMove(oCreature, questID));
}

void ACR_DefenseSpawnCreature(string sCreature, location lLoc, int questID)
{
	object oCreature = CreateObject(OBJECT_TYPE_CREATURE, sCreature, lLoc, TRUE);
	AssignCommand(oCreature, ActionMoveToLocation(GetLocation(GetWaypointByTag(GetLocalString(OBJECT_SELF, DEFENSE_QUEST_WALK_WAYPOINT))), TRUE));
	DelayCommand(6.0f, _DefenseSpawnMove(oCreature, questID));
}

void ACR_TrickleSpawn(int questID)
{
	if(GetLocalInt(OBJECT_SELF, DEFENSE_QUEST_ID) != questID) return;
	
	object spawnPoint = GetWaypointByTag(GetLocalString(OBJECT_SELF, DEFENSE_QUEST_SPAWN_WAYPOINT));
	
	int count = 1;
	string creatureToSpawn = GetLocalString(OBJECT_SELF, DEFENSE_QUEST_TRICKLE_SPAWN_CREATURE + IntToString(count));
	while(creatureToSpawn != "")
	{
		ACR_DefenseSpawnCreature(creatureToSpawn, GetLocation(spawnPoint), questID);
		count++;
		creatureToSpawn = GetLocalString(OBJECT_SELF, DEFENSE_QUEST_TRICKLE_SPAWN_CREATURE + IntToString(count));
	}
	
	float trickleDelay = GetLocalFloat(OBJECT_SELF, DEFENSE_QUEST_TRICKLE_DELAY);
	DelayCommand(trickleDelay, ACR_TrickleSpawn(questID));
}

void ACR_WaveSpawn(int questID, int waveToSpawn)
{
	if(GetLocalInt(OBJECT_SELF, DEFENSE_QUEST_ID) != questID) return;
	
	object spawnPoint = GetWaypointByTag(GetLocalString(OBJECT_SELF, DEFENSE_QUEST_SPAWN_WAYPOINT));
	
	int count = 1;
	string creatureToSpawn = GetLocalString(OBJECT_SELF, DEFENSE_QUEST_WAVE_SPAWN_CREATURE + IntToString(waveToSpawn) + "_" + IntToString(count));
	if(creatureToSpawn == "")
	{
		// Advance the quest of everyone associated with this run
		ACR_AdvanceDefenseQuest(questID);
		
		// And clear out our tracking of this run of it.
		DeleteLocalInt(OBJECT_SELF, DEFENSE_QUEST_ID);
		
		// And make sure that no further heartbeats fire.
		return;
	}
	while(creatureToSpawn != "")
	{
		ACR_DefenseSpawnCreature(creatureToSpawn, GetLocation(spawnPoint), questID);
		count++;
		creatureToSpawn = GetLocalString(OBJECT_SELF, DEFENSE_QUEST_WAVE_SPAWN_CREATURE + IntToString(waveToSpawn) + "_" + IntToString(count));
	}
	
	float waveDelay = GetLocalFloat(OBJECT_SELF, DEFENSE_QUEST_WAVE_DELAY);
	DelayCommand(waveDelay, ACR_WaveSpawn(questID, waveToSpawn + 1));
}

void main()
{
	int currentQuestID = GetLocalInt(OBJECT_SELF, DEFENSE_QUEST_ID);
	if(currentQuestID != 0)
	{
		// If there is a current quest ID, then this is an existing defense quest. Check for failure.
		if(ACR_CheckForDefenseFailure())
		{
			ACR_FailDefenseQuest(currentQuestID);
			DeleteLocalInt(OBJECT_SELF, DEFENSE_QUEST_ID);
		}
		SetLocalInt(GetEnteringObject(), DEFENSE_QUEST_ID, currentQuestID);
	}
	else
	{
		object oPC = GetEnteringObject();
		if(!GetIsPC(oPC)) return;
			
		if(ACR_RetrieveQuestState(GetLocalString(OBJECT_SELF, ACR_QST_NAME), oPC) == GetLocalInt(OBJECT_SELF, ACR_QST_LOWER_STATE))
		{
			int newQuestID = GetLocalInt(OBJECT_SELF, DEFENSE_QUEST_COUNTER) + 1;
			if(newQuestID < 1) newQuestID = 1;
			SetLocalInt(OBJECT_SELF, DEFENSE_QUEST_COUNTER, newQuestID);
			SetLocalInt(OBJECT_SELF, DEFENSE_QUEST_ID, newQuestID);
			SetLocalInt(oPC, DEFENSE_QUEST_ID, newQuestID);
		
			float initialDelay = GetLocalFloat(OBJECT_SELF, DEFENSE_QUEST_INITIAL_DELAY);
			float trickleDelay = GetLocalFloat(OBJECT_SELF, DEFENSE_QUEST_TRICKLE_DELAY);
			float waveDelay = GetLocalFloat(OBJECT_SELF, DEFENSE_QUEST_WAVE_DELAY);
		
			DelayCommand(initialDelay, ACR_TrickleSpawn(newQuestID));
			DelayCommand(initialDelay + waveDelay, ACR_WaveSpawn(newQuestID, 1));
		}
	}
}