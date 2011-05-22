// ginc_actions
/*
    various encapsulated action funtions
	Main characteristic of action functions is that they are applied to the object that runs them,
	a target is not supplied as a parameter.  
*/
	
// ChazM 3/9/05
// ChazM 5/5/05 added constants and prototypes section, added ActionOrientTOTag(), ActionMoveToTag(), ActionTurnHostile(), FindDestinationByTag()
// ChazM 5/12/05 added ActionPlayAnimationUncommandable() and ActionPrintString()
// ChazM 5/26/05 added ginc_group include
// ChazM 5/27/05 added ActionFireEvent(), IncrementGlobalInt(), NoInterrupt(), and CheckOrderComplete()
// ChazM 5/31/05 modified IncrementGlobalInt()
// ChazM 6/6/05	no longer includes ginc_group
// ChazM 6/14/05 added ActionForceMoveToTag()
// ChazM 6/28/05 added ActionForceExit()
// ChazM 7/29/05 added ActionStartConversationNode()
// ChazM 9/21/05 added ActionJumpToTag()
// EPF 11/15/05	-- StandardAttack() now changes the Attacker to be hostile instead of a temporary enemy, since personal rep is out.
// ChazM 11/29/05 added SetNode() and ActionSpeakNode(), removed ActionStartConversationNode()
// DBR 12/16/05 - Added parameter to NoInterrupt() for immediate focused action.
// ChazM 9/18/06 - Updated ActionForceExit(), added RemoveCreature()
// ChazM 9/18/06 - changed RemoveCreature() to ActionRemoveMyself()/RemoveMyself()
// ChazM 9/21/06 - removed nw_i0_generic, added ExecuteDCR(), modified ActionTurnHostile(), StandardAttack()
// ChazM 5/10/07 - added param bSetToHostile to StandardAttack()
// MDiekmann 6/14/07 - changed ActionForceExit() to use ActionForceMoveToObject instead of ActionForceMoveToLocation to stop issue with collisions quitting movement.
// ChazM 7/17/07 - ActionForceExit() fix for when destination location is invalid.

//void main(){}

///////////////////////////////////////////////
// constants
///////////////////////////////////////////////
const int ORIENT_FACE_TARGET			= 1;
const int ORIENT_FACE_SAME_AS_TARGET 	= 2;


///////////////////////////////////////////////
// Prototypes
///////////////////////////////////////////////

void ActionForceMoveToTag(string sTag ,int bRun=FALSE, float fRange = 1.0f, float fTimeout = 30.0f);
void ActionMoveToTag(string sTag ,int bRun=FALSE, float fRange = 1.0f);
void ActionJumpToTag(string sTag, int bWalkStraightLineToPoint=FALSE);

void ActionOrientToObject(object oTarget, int iOrientation = ORIENT_FACE_TARGET);
void ActionOrientToTag(string sTag, int iOrientation = ORIENT_FACE_TARGET);

void ActionCreateObject (int nObjectType, string sTemplate, location lLocation, int bUseAppearAnimation=FALSE, string sNewTag="");

void ExecuteDCR(object oExecutor = OBJECT_SELF);
void ActionTurnHostile();
void StandardAttack(object oAttacker, object oTarget, int bSetToHostile=TRUE);

void ActionPlayAnimationUncommandable(int nAnimation, float fSpeed=1.0, float fDurationSeconds=0.0);
void ActionPrintString(string sMsg);

void ActionFireEvent(string sTag, int iEventNum);
int IncrementGlobalInt(string sVarName);
void NoInterrupt (float fTimeOut = 180.0f, int bFocusNow=0);

void ActionRemoveMyself();
void ActionForceExit(string sExitTag = "WP_EXIT", int bRun=FALSE);
//void ActionStartConversationNode(object oPC, string sConversation, int iNodeIndex);
void ActionSpeakNode(int iNodeIndex, string sDialog = "", object oObjectToConverseWith = OBJECT_SELF, int iOnceOnly = TRUE);



// private prototypes
object FindDestinationByTag(string sTarget);
void CheckOrderComplete(int iOrderNum);
void RemoveMyself();


///////////////////////////////////////////////
// Function Definitions
///////////////////////////////////////////////


void ActionForceMoveToTag(string sTag ,int bRun=FALSE, float fRange = 1.0f, float fTimeout = 30.0f)
{
    object oWayPoint = GetObjectByTag(sTag);
    ActionForceMoveToObject(oWayPoint, bRun, fRange, fTimeout); 
}

void ActionMoveToTag(string sTag ,int bRun=FALSE, float fRange = 1.0f)
{
    object oWayPoint = GetObjectByTag(sTag);
    ActionMoveToObject(oWayPoint, bRun, fRange); 
}


void ActionJumpToTag(string sTag, int bWalkStraightLineToPoint=FALSE)
{
    ActionJumpToObject(GetObjectByTag(sTag), bWalkStraightLineToPoint);
}


// Orient to a target object 
void ActionOrientToObject(object oTarget, int iOrientation = ORIENT_FACE_TARGET)
{
	switch (iOrientation){
		case ORIENT_FACE_TARGET:
		    //ActionDoCommand(SetFacingPoint( GetPositionFromLocation(GetLocation(oTarget))));
		    ActionDoCommand(SetFacingPoint(GetPosition(oTarget)));
			break;
				
		case ORIENT_FACE_SAME_AS_TARGET:
			ActionDoCommand(SetFacing(GetFacing(oTarget)));
			break;
	}
	
    ActionWait(0.5f);  // need time to change facing
}

// Orient to an object with sTag
void ActionOrientToTag(string sTag, int iOrientation = ORIENT_FACE_TARGET)
{
	object oTarget = FindDestinationByTag(sTag);
	ActionOrientToObject(oTarget, iOrientation);
}



// wrapper for CreateObject that returns a void (so it can be assigned as an action)
void ActionCreateObject (int nObjectType, string sTemplate, location lLocation, int bUseAppearAnimation=FALSE, string sNewTag="")
{
    CreateObject(nObjectType, sTemplate, lLocation, bUseAppearAnimation, sNewTag);
}

void ExecuteDCR(object oExecutor = OBJECT_SELF)
{
	//DetermineCombatRound();
	ExecuteScript("gr_dcr", oExecutor);
}

// change to hostile faciton and look for something to attack.
void ActionTurnHostile()
{
	ChangeToStandardFaction(OBJECT_SELF, STANDARD_FACTION_HOSTILE);
	//DetermineCombatRound();
	ExecuteDCR(OBJECT_SELF);
}

// 
void StandardAttack(object oAttacker, object oTarget, int bSetToHostile=TRUE)
{
    PrintString ("Setting " + GetName(oAttacker) + " to attack " + GetName(oTarget));

	// make sure action queue is empty / conversation is finished
	AssignCommand(oAttacker, ClearAllActions(TRUE));
	// make target enemy of attacker
	if (bSetToHostile)
    	ChangeToStandardFaction(oAttacker, STANDARD_FACTION_HOSTILE);

	// tell attacker to initiate combat - attacker will determine best who to attack and how.
    //AssignCommand(oAttacker, DetermineCombatRound());
	AssignCommand(oAttacker, ExecuteDCR(oAttacker));
	
    // This is here only temporarily to further push an attack because above not fully working currently
    AssignCommand(oAttacker, ActionAttack(oTarget));
}

// internal funcs

// look for waypoint w/ Tag.  If not found then look for an object in the area, and finally, look for any obj
object FindDestinationByTag(string sTarget)
{
	object oTarget = GetWaypointByTag(sTarget);
	if (!GetIsObjectValid(oTarget))
	{
		oTarget = GetNearestObjectByTag(sTarget);	// search area	
		if (!GetIsObjectValid(oTarget))
		{
			oTarget = GetObjectByTag(sTarget);	// search module
		}	
	}
	return (oTarget);
}


// When ActionPlayAnimation() (and likely several others) is active, GetCurrentAction() returns ACTION_INVALID
// This could be misinterpreted as having an empty queue.  To avoid having the queue cleared in this case, use this function.
// Be mindful of the queue being unmodifiable while this is active.
void ActionPlayAnimationUncommandable(int nAnimation, float fSpeed=1.0, float fDurationSeconds=0.0)
{
    ActionDoCommand(SetCommandable(FALSE));
    ActionPlayAnimation(nAnimation, fSpeed, fDurationSeconds);
    ActionDoCommand(SetCommandable(TRUE));
}


// For adding PrintString() to an action queue.
void ActionPrintString(string sMsg)
{
    ActionDoCommand(PrintString(sMsg));
}


//This is only for user defined event numbers.
void ActionFireEvent(string sTag, int iEventNum)
{
    ActionDoCommand(SignalEvent(GetObjectByTag(sTag), EventUserDefined(iEventNum)));
}

// Return a unique order number
int IncrementGlobalInt(string sVarName)
{
	int iValue = GetGlobalInt(sVarName) + 1;
	SetGlobalInt(sVarName, iValue);
	return (iValue);
	
}

// more actions can not be put on queue after this call until
// all actions have completed
/*  Example of how this function might be used.
		ActionPlayAnimation (ANIMATION_FIREFORGET_GREETING);
		ActionSpeakString("Skee!");
		ActionMoveToWP("xWP_Shelk_01"); // walk to WP
		NoInterrupt();
		// commands after the NoInterrupt will occur after commandable is turned on and could be interrupted.		
		ActionSpeakString("Skee!");
*/       //new bFocusNow param prevents the 0.2 second delay before SetCommandable(FALSE), but doesn't allow further
		//  interuptable actions to be queued after the non-interuptable ones.
void NoInterrupt (float fTimeOut = 180.0f, int bFocusNow=0)
{
    //int iOrderNum = Random(10000);
    int iOrderNum = IncrementGlobalInt("N2_CurrentOrderNum");
	
    SetLocalInt(OBJECT_SELF, "N2_ActionOrderNumber", iOrderNum);
    ActionDoCommand(SetCommandable(TRUE));
    ActionDoCommand(SetLocalInt(OBJECT_SELF, "N2_ActionOrderNumber", 0));

	if (bFocusNow)
		SetCommandable(FALSE);
	else// this won't occur until .2 seconds after entire script has executed.
		DelayCommand(0.2f, SetCommandable(FALSE));
    
    

    // If all the commands aren't finished within the time out period (for example, 
	// got stuck on a rock while moving and can't pathfind around it), then we will
	// recover by becoming commandable again.
    DelayCommand(fTimeOut, CheckOrderComplete(iOrderNum));
}

// destroy oCreature or despawn oCreature if roster member
// auto sets plot flag and destroyable attribute so non-roster creatures will be destroyed.
void RemoveMyself()
{
	object oCreature = OBJECT_SELF;
	if (GetIsRosterMember(oCreature))
	{	// will always work for a roster member (regardless of plot or destroyable flag)
		DespawnRosterMember(GetRosterNameFromObject(oCreature));
	}		
	else
	{
		SetPlotFlag(oCreature,FALSE);
		SetIsDestroyable(TRUE);
		DestroyObject(oCreature);
	}		
}

// Action wrapper
void ActionRemoveMyself()
{
	ActionDoCommand(RemoveMyself());
}

// Force move to exit WP and destroy self or despawn if roster member
void ActionForceExit(string sExitTag = "WP_EXIT", int bRun=FALSE)
{
	//location lExitLoc = GetLocation(FindDestinationByTag(sExitTag));
	//ActionForceMoveToLocation(lExitLoc, bRun);
	//object oExit = GetObjectByTag(sExitTag);
	object oExit = GetNearestObjectByTag(sExitTag);
	if (GetIsObjectValid(oExit))
	{
		ActionForceMoveToObject(oExit, bRun);
		ActionDoCommand(SetCommandable(TRUE));
		// SetPlotFlag(OBJECT_SELF,FALSE);
		ActionRemoveMyself();
		//ActionDoCommand(DestroyObject(OBJECT_SELF));
		SetCommandable(FALSE);
	}
	else
	{
		ActionRemoveMyself();
	}		
}



// sets the 2 properties on object for use by gc_node
void SetNode(object oObject, int iNodeIndex, int iOnceOnly = TRUE)
{
	// gc_node will look at these vars.
	SetLocalInt(oObject, "sn_NodeIndex", iNodeIndex); 	// node index to check for
	SetLocalInt(oObject, "sn_OnceOnly", iOnceOnly);		// signal whether we should clear node if true
}		


// sets a node which should be checked for in conversation w/ gc_node and starts convo
void ActionSpeakNode(int iNodeIndex, string sDialog = "", object oObjectToConverseWith = OBJECT_SELF, int iOnceOnly = TRUE)
{
	SetNode(OBJECT_SELF, iNodeIndex, iOnceOnly);
	ActionStartConversation(oObjectToConverseWith, sDialog);
	// SpeakOneLinerConversation(sDialog, OBJECT_SELF);

}
/*
// sets a node which should be check for in conversation w/ gc_node and starts convo
void ActionStartConversationNode(object oPC, string sConversation, int iNodeIndex)
{
	SetLocalInt(OBJECT_SELF, "sn_OnceOnly", TRUE);
	SetLocalInt(OBJECT_SELF, "sn_NodeIndex", iNodeIndex);
	ActionStartConversation(oPC, sConversation, FALSE, FALSE, TRUE);
}	

*/
////////////////////////////////////////////////////////////////////////////////
// Helper function. Do not call these directly from outside file
////////////////////////////////////////////////////////////////////////////////

// Check that order is complete (N2_ActionOrderNumber will be something other than what we set it to).
// If not, we set object to be commandable in hopes of recovering.
void CheckOrderComplete(int iOrderNum)
{
    int iSavedOrderNum = GetLocalInt(OBJECT_SELF, "N2_ActionOrderNumber");
    if (iSavedOrderNum == iOrderNum)
    {
        // time out expired for this order and we are still doing it, so clear it!
        SetCommandable(TRUE);
    }
}