// gb_follow_hb
/*
	creature will follow another creature stored as local obj "Leader"
	
*/
// ChazM 9/12/05

void DoFollow(object oMaster, float fDistance)
{
	// check not doing some other action 
	if(GetIsObjectValid(oMaster) &&
	    GetCurrentAction(OBJECT_SELF) != ACTION_FOLLOW &&
	    GetCurrentAction(OBJECT_SELF) != ACTION_DISABLETRAP &&
	    GetCurrentAction(OBJECT_SELF) != ACTION_OPENLOCK &&
	    GetCurrentAction(OBJECT_SELF) != ACTION_REST &&
	    GetCurrentAction(OBJECT_SELF) != ACTION_ATTACKOBJECT)
	{	
		// check not involved in any combat related stuff
		if(!GetIsObjectValid(GetAttackTarget()) &&
		  !GetIsObjectValid(GetAttemptedSpellTarget()) &&
		  !GetIsObjectValid(GetAttemptedAttackTarget()) &&
		  !GetIsObjectValid(GetNearestCreature(CREATURE_TYPE_REPUTATION, REPUTATION_TYPE_ENEMY, OBJECT_SELF, 1, CREATURE_TYPE_PERCEPTION, PERCEPTION_SEEN)))
		{
			// we must not be following any more, so follow again.
	       	if(GetDistanceToObject(oMaster) > fDistance)
	       	{
				//ClearActions(CLEAR_NW_CH_AC1_49);
			     ActionForceFollowObject(oMaster, fDistance);
	       	}
		}
	}
}

void main()
{
	object oLeader = GetLocalObject(OBJECT_SELF, "Leader");
	float fDistance = GetLocalFloat(OBJECT_SELF, "FollowDistance");
	DoFollow(oLeader, fDistance);
	ExecuteScript("nw_c2_default1", OBJECT_SELF);
}