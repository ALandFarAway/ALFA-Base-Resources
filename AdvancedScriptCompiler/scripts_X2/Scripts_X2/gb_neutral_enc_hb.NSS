//	gb_neutral_enc_hb 
/*  
    Heartbeat for neutral encounters on the overland map.
*/
// JH/EF-OEI: 01/17/08

#include "nw_i0_generic"
#include "ginc_debug"
#include "ginc_overland_ai"

void main()
{
	if(GetLocalInt(OBJECT_SELF, "bWaylaid"))
	{
		SetWalkCondition(NW_WALK_FLAG_PAUSED, TRUE);
		ClearAllActions(TRUE);
		return;
	}
	
	if(GetLocalInt(OBJECT_SELF, VAR_BEHAVIOR_STATE) == BEHAVIOR_STATE_NPC_COMBAT)
	{
		object oChasing = GetLocalObject(OBJECT_SELF, "oChasing");
		if( GetIsObjectValid(oChasing) && !GetScriptHidden(oChasing) )
		{
			SetWalkCondition(NW_WALK_FLAG_PAUSED, TRUE);
			ClearAllActions();
			return;
		}
		
		else 
		{
			SetWalkCondition(NW_WALK_FLAG_PAUSED, FALSE);
			DeleteLocalObject(OBJECT_SELF, "oChasing");
			ClearAllActions();
			SetOLBehaviorState(BEHAVIOR_STATE_NONE, OBJECT_SELF);
		}
	}
	
	if(!IsMarkedAsDone())
	{
		SetLocalInt(OBJECT_SELF, "bNeutral", TRUE);
		MarkAsDone();
	}
	object oPC = GetFactionLeader(GetFirstPC());
	//	Pause lifespan timer if the party isn't on the Overland Map.	*/	
	if(GetArea(oPC) != GetArea(OBJECT_SELF))
	{
		return;
	}	

	if(IsInConversation(oPC) || IsInConversation(OBJECT_SELF) || GetGlobalInt(VAR_ENC_IGNORE) || GetLocalInt(oPC, "bLoaded") != TRUE)
	{
		ClearAllActions();
		return;
	} 
		
	// * if not runnning normal or better Ai then exit for performance reasons
    if (GetAILevel() == AI_LEVEL_VERY_LOW)
	{
		return;
	}
	
    // If we have the 'constant' waypoints flag set, walk to the next
    // waypoint.
    if (GetWalkCondition(NW_WALK_FLAG_CONSTANT))
	{
		WalkWayPoints(TRUE, "heartbeat");
	}

    // Send the user-defined event signal if specified
    if(GetSpawnInCondition(NW_FLAG_HEARTBEAT_EVENT))
    {
        SignalEvent(OBJECT_SELF, EventUserDefined(EVENT_HEARTBEAT));
    }
}