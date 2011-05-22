//kinc_combat
//combat support library
//NLC 6/24/08 - Happy Birthday, ME!
/*
	
*/
#include "hench_i0_ai"
#include "hench_i0_act"
#include "nw_i0_generic"
#include "ginc_event_handlers"
#include "ginc_math"
// -------------------------------------------------------
// Function Prototypes
// -------------------------------------------------------

// -------------------------
// AI Functions
// -------------------------

//Suspends the creature's AI scripts for up to fSafetyOverride seconds. 
//If you want the creature to still have their heartbeat script, set bSuspendHeartbeat to FALSE.
//Set fSafetyOverride to 0 or less to not do this.
void SuspendAI(object oCreature = OBJECT_SELF, int bSuspendHeartbeat = TRUE, float fSafetyOverride = 6.0f);

//Resumes a creatures AI, restoring the original scripts set before SuspendAI() was run.
void ResumeAI(object oObject = OBJECT_SELF);

//Returns whether a creature has had its AI suspended through the SuspendAI() function.
int GetIsAISuspended(object oObject = OBJECT_SELF);
void SaveEventHandler(object oCreature, int nEventHandler);
void RestoreAIEventHandlers(object oObject);

// -------------------------
// Creature Utility Functions
// -------------------------

//Returns a random member of oFactionMember's faction.
//If fDist is passed in, it will only return members within fDist meters of oFactionMember.
object GetRandomFactionMember(object oFactionMember = OBJECT_SELF, float fDist = 0.0f);

//This returns a random location around oObject. If bExactDistance is true, it returns a random location
//that is exactly fDistance meters away from oObject. If bExactDistance is false, it returns a random location
//within fDistance meters of oObject. NOTE: This does *not* test to see if that location is "safe" or on the walkmesh.
//You should use CalcSafeLocation on the location you receive from this function to do that.
location GetRandomLocationAroundObject(float fDistance, object oObject = OBJECT_SELF, int bExactDistance = TRUE, float fOrientation = 180.0f);

// -------------------------------------------------------
// Function Definitions
// -------------------------------------------------------

//AI Functions

//Suspends the creature's AI scripts for up to fSafetyOverride seconds. 
//If you want the creature to still have their heartbeat script, set bSuspendHeartbeat to FALSE.
//Set fSafetyOverride to 0 or less to not do this.
void SuspendAI(object oCreature = OBJECT_SELF, int bSuspendHeartbeat = TRUE, float fSafetyOverride = 6.0f)
{
	if(GetIsAISuspended(oCreature))
		return;
	
	AssignCommand(oCreature, ClearAllActions(TRUE));
	int nNumScripts = GetNumScripts(oCreature);
	int i;
	

	
	for(i=0; i < nNumScripts; i++)
	{
		if	(i != CREATURE_SCRIPT_ON_DEATH)											//Skip the iteration for OnDeath
		{
			if (bSuspendHeartbeat == TRUE || 										//If we don't care about the heartbeat, go ahead.
				(bSuspendHeartbeat == FALSE && i != CREATURE_SCRIPT_ON_HEARTBEAT) )	//Or, if we aren't suspending the heartbeat
			{																		//and the current step isn't the heartbeat.
				SaveEventHandler(oCreature, i);										//Back up the current event handler.
				SetEventHandler(oCreature, i, "");									//And then clear it.
			}
		}
	}
	
	SetEventsClearedFlag(oCreature, TRUE);
		
	if(fSafetyOverride > 0.0f)
	{
		PrettyDebug("Assigning Safety Override");
		AssignCommand(GetArea(oCreature), DelayCommand(fSafetyOverride, ResumeAI(oCreature)));
	}
}

//Resumes a creatures AI, restoring the original scripts set before SuspendAI() was run.
void ResumeAI(object oObject = OBJECT_SELF)
{
	PrettyDebug(GetName(oObject) + " resuming AI.");
	RestoreAIEventHandlers(oObject);
}


//Returns whether a creature has had its AI suspended through the SuspendAI() function.
int GetIsAISuspended(object oObject = OBJECT_SELF)
{
	return GetEventsClearedFlag(oObject);
}

//Eventhandler saving/loading functions. These are mostly borrowed from ginc_event_handlers, 
//but they do more specific things here.
void SaveEventHandler(object oCreature, int nEventHandler)
{
	
	string sEventHandler = GetEventHandler(oCreature, nEventHandler);
	string sVarName = EVENTS_SAVE_PREFIX + IntToString(nEventHandler);
	PrettyDebug("Saving: " + sEventHandler);
	SetLocalString(oCreature, sVarName, sEventHandler);
}

void RestoreAIEventHandlers(object oObject)
{
	string sEventHandler;
	string sVarName;
	int iNumScripts = GetNumScripts(oObject);
	int i;

	for (i=0; i<iNumScripts; i++)
	{
		sVarName = EVENTS_SAVE_PREFIX + IntToString(i);
		sEventHandler = GetLocalString(oObject, sVarName);
		if(sEventHandler!= "")
			SetEventHandler(oObject, i, sEventHandler);
	}
	SetEventsClearedFlag(oObject, FALSE);
}


//Getters

object GetRandomFactionMember(object oFactionMember = OBJECT_SELF, float fDist = 0.0f)
{
     object oIterator = GetFirstFactionMember(oFactionMember, FALSE);
     object oResult = OBJECT_INVALID;

     int i=1;
     
     while( GetIsObjectValid(oIterator) )
     {
           PrettyDebug(GetName(oIterator));
           
           if(fDist > 0.0f)
           {
                if( GetDistanceBetween(OBJECT_SELF, oIterator) > fDist )
                     oIterator = GetNextFactionMember(oFactionMember, FALSE);
                else
                {
                     if( Random(i) == 0)
                           oResult = oIterator;
           
                     i++;
                     oIterator = GetNextFactionMember(oFactionMember, FALSE);
                }
           }
           
           else
           {
                if( Random(i) == 0)
                     oResult = oIterator;
           
                i++;
                oIterator = GetNextFactionMember(oFactionMember, FALSE);
           }
     }
     
     return oResult;
}

//This returns a random location around oObject. If bExactDistance is true, it returns a random location
//that is exactly fDistance meters away from oObject. If bExactDistance is false, it returns a random location
//within fDistance meters of oObject. NOTE: This does *not* test to see if that location is "safe" or on the walkmesh.
//You should use CalcSafeLocation on the location you receive from this function to do that.
location GetRandomLocationAroundObject(float fDistance, object oObject = OBJECT_SELF, int bExactDistance = TRUE, float fOrientation = 180.0f)
{
	vector vObject = GetPosition(oObject);
	float fAngle = RandomFloat(360.0f);
	if(!bExactDistance)
		fDistance = RandomFloat(fDistance);
	
	float fXVariance = cos(fAngle)*fDistance;
	float fYVariance = sin(fAngle)*fDistance;
						
	vObject.x += fXVariance;
	vObject.y += fYVariance;
	
	location lResult = Location(GetArea(oObject), vObject, fOrientation);
	return lResult;
}