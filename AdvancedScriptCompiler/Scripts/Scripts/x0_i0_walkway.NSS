//:://////////////////////////////////////////////////
//:: X0_I0_WALKWAY
/*
  Include library holding the code for WalkWayPoints.

 */
//:://////////////////////////////////////////////////
//:: Copyright (c) 2002 Floodgate Entertainment
//:: Created By: Naomi Novik
//:: Created On: 12/07/2002
//:://////////////////////////////////////////////////
//:: Updated On : 2003/09/03 - Georg Zoeller
//::                           * Added code to allow area transitions if global integer
//::                             X2_SWITCH_CROSSAREA_WALKWAYPOINTS set to 1 on the module
//::                           * Fixed Night waypoints not being run correcty
//::                           * XP2-Only: Fixed Stealth and detect modes spawnconditions
//::                             not working
//::                           * Added support for SleepAtNight SpawnCondition: if you put
//::                             a string on the module called X2_S_SLEEP_AT_NIGHT_SCRIPT,
//::                             pointing to a script, this script will fire if it is night
//::                             and your NPC has the spawncondition set
//::                           * Added the ability to make NPCs turn to the facing of
//::                             a waypoint when setting int X2_L_WAYPOINT_SETFACING to 1 on
//::                             the waypoint

// 5/17/05 ChazM  added NW_WALK_FLAG_PAUSED, modified WalkWayPoints()
// 7/22/05 ChazM  removed speakstring from WalkWayPoints()
// 1/3/06 ChazM   modified WalkWayPoints() - moved ClearActions so doesn't wipe actions from GetNextWalkWayPoint(),
//					GetNextWalkWayPoint() - now calls script w/ name of waypoint 
// 1/4/06 ChazM modified WalkWayPoints(), added ForceResumeWWP(), GetNumWaypoints(), SetCurrentWaypoint(), GetCurrentWaypoint(), 
//					GetPreviousWaypoint(), GetWaypointByNum(), DoWalkWayPointStandardActions() 
// 1/7/06 ChazM updated GetPreviousWaypoint(), SetCurrentWaypoint(), and GetCurrentWaypoint() to 
//				GetCurrentWaypoint(), SetNextWaypoint(), and GetNextWaypoint() by popular demand
// 1/11/06 ChazM modified system to maintain Next, Current, and Previous states.
// 1/19/06 ChazM added GetWPTag() so that waypoint routes can be used by those w/o the proper tag.
// 1/21/06 ChazM Upgraded to Dynamic Scripted Waypoints - waypoint sets can now be swapped dynamically.
// 2/10/06 DBR   Changed name of WP_PREFIX and WN_PREFIX to WW_WP_PREFIX and WW_WN_PREFIX
// 7/9/06 ChazM updated SetWWPController() 
// 8/1/06 ChazM updated SetWWPController() - Set Walk State only if there are waypoints in set.
// 12/23/06 JCM added GetDayNightSwitch(), GetIsPosted()
// -- modified GetWayPointByNum(), MoveToNextWaypoint(), GetNextWalkWayPoint() to check for
// -- day/night transitions and return to post as needed
// 4/6/07 ChazM - JCM's changes added to build.  (Way to go JCM!)

#include "x0_i0_spawncond"
#include "ginc_debug"

//void main(){}

/**********************************************************************
 * CONSTANTS
 **********************************************************************/

const string RR_WAYPOINT_CONTROLLER 	= "nw_waypoint001"; // Res Ref

const string WW_DAY_POST_PREFIX			= "POST_";
const string WW_NIGHT_POST_PREFIX		= "NIGHT_";
const string WW_WP_PREFIX				= "WP_";
const string WW_WN_PREFIX				= "WN_";
const string WW_NUM						= "NUM";
const string WAYPOINT_CONTROLLER_PREFIX = "WC_";
// Waypoint variables:
//        WP_NUM     : number of day waypoints
//        WN_NUM     : number of night waypoints
//        WP_#, WN_# : the waypoint objects
const string VAR_WC_TAG					= "WC_TAG";
	
// vars on the creature
const string VAR_WP_TAG					= "WP_TAG";				// string tag to use instead of creature tag for initialization
const string VAR_WP_SINGLE_POINT_OVERRIDE = "WP_SINGLE_POINT_OVERRIDE"; // boolean, if true then run normally even if only 1 wp

const string VAR_KICKSTART_REPEAT_COUNT = "N2_KICKSTART_REPEAT_COUNT";	// int counter
const string VAR_FORCE_RESUME 			= "N2_FORCE_RESUME";	// boolean
const string VAR_WWP_CONTROLLER 		= "WWP_CONTROLLER";		// WWP Controller Object
const string VAR_WP_PREVIOUS			= "WP_PREV";			// int
const string VAR_WP_CURRENT				= "WP_CUR";				// int
const string VAR_WP_NEXT				= "WP_NEXT";			// int
const string sWalkwayVarname 			= "NW_WALK_CONDITION";	// bit flags, see below

// If set, the creature's waypoints have been initialized.
const int NW_WALK_FLAG_INITIALIZED		= 0x00000001;

// If set, the creature will walk its waypoints constantly,
// moving on in each OnHeartbeat event. Otherwise,
// it will walk to the next only when triggered by an
// OnPerception event.
const int NW_WALK_FLAG_CONSTANT         = 0x00000002;

// Set when the creature is walking day waypoints.
const int NW_WALK_FLAG_IS_DAY           = 0x00000004;

// Set when the creature is walking back
const int NW_WALK_FLAG_BACKWARDS        = 0x00000008;

// Set to Turn off WWP
const int NW_WALK_FLAG_PAUSED           = 0x00000010;

/**********************************************************************
 * FUNCTION PROTOTYPES
 **********************************************************************/

void ForceResumeWWP(object oCreature=OBJECT_SELF);
int GetNumWaypoints(object oCreature=OBJECT_SELF);
int GetNumWaypointsByPrefix(string sPrefix=WW_WP_PREFIX, object oCreature=OBJECT_SELF);

void SetNextWaypoint(int iNextWP);
int GetNextWaypoint();
int GetCurrentWaypoint();
int GetPreviousWaypoint();
object GetWaypointByNum(int iWayPoint, string sPrefix=WW_WP_PREFIX, object oCreature=OBJECT_SELF);

string GetWPPrefix(object oCreature = OBJECT_SELF);
int GetWalkCondition(int nCondition, object oCreature=OBJECT_SELF);// Get whether the condition is set
void SetWalkCondition(int nCondition, int bValid=TRUE, object oCreature=OBJECT_SELF);// Set a given condition


void DoWalkWayPointStandardActions(object oWay, int bKickStart);

// Get a waypoint number suffix, padded if necessary
string GetWaypointSuffix(int i);

// Get the creature's next waypoint.
// If it has just become day/night, or if this is
// the first time we're getting a waypoint, we go
// to the nearest waypoint in our new set.
object GetNextWalkWayPoint(object oCreature=OBJECT_SELF);

// Get the number of the nearest of the creature's current
// set of waypoints (respecting day/night).
int GetNearestWalkWayPoint(object oCreature=OBJECT_SELF);

// HEAVILY REVISED!
// The previous version of this function was too little
// bang-for-the-buck, as it set up an infinite loop and
// made creatures walk around even when there was no one
// in the area.
//
// Now, each time this function is called, the caller
// will move to their next waypoint. The OnHeartbeat and
// OnPerception scripts have been modified to call this
// function as appropriate.
//
// However, also note that the mobile ambient animations
// have been heavily revised. For most creatures, those
// should now be good enough, especially if you put down
// some "NW_STOP" waypoints for them to wander among.
// Specific waypoints will now be more for creatures that
// you really want to patrol back and forth along a pre-set
// path.
//void WalkWayPoints(int nRun = FALSE, float fPause = 1.0, string sWhoCalled="no param");
//void WalkWayPoints(int nRun = FALSE, float fPause = 1.0, int bKickStart=TRUE, string sWhoCalled="no param");
void WalkWayPoints(int bKickStart=FALSE, string sWhoCalled="unknown", int bForcResumeOverride=FALSE);
int IsOkToWalkWayPoints();
void MoveToNextWaypoint(int bKickStart=FALSE, int bForcResumeOverride=FALSE);

// Check to make sure that the walker has at least one valid
// waypoint they will walk to at some point (day or night).
//int CheckWayPoints(object oWalker = OBJECT_SELF);

// Check to see if the specified object is currently walking
// waypoints or standing at a post.
//int GetIsPostOrWalking(object oWalker = OBJECT_SELF);

// ----

object SetWWPController(string sWalkWayPointsTag, object oCreature=OBJECT_SELF);
object GetWWPController(object oCreature=OBJECT_SELF);
object CreateWWPController(string sWalkWayPointsTag);
void LookUpWalkWayPointsSet(object oWWPController, string sPrefix, string sPost);
// Look up the caller's waypoints and store them on the creature.
// Waypoint variables:
//        WP_NUM     : number of day waypoints
//        WN_NUM     : number of night waypoints
//        WP_#, WN_# : the waypoint objects
// bCrossAreas: if set to TRUE, the creature will travel between areas to reach
//              its waypoint
void LookUpWalkWayPoints(object oWWPController);

string GetWPTag(object oCreature=OBJECT_SELF);
object InitWWPController(object oCreature=OBJECT_SELF);

int GetDayNightSwitch(object oCreature=OBJECT_SELF);
int GetIsPosted(object oCreature=OBJECT_SELF);

/**********************************************************************
 * FUNCTION DEFINITIONS
 **********************************************************************/

// Changes the waypoint set this creature will walk
// returns the waypoint controller object found or created.
// sWalkWayPointsTag is the tag of the creature the waypoints are designed for, i.e. no prefix or suffix
object SetWWPController(string sWalkWayPointsTag, object oCreature=OBJECT_SELF)
{
	//PrettyDebug("SetWWPController() - Start"); 

	// find the Waypoint Controller Object
	string sWWPControllerTag = WAYPOINT_CONTROLLER_PREFIX + sWalkWayPointsTag;
	object oWWPController = GetWaypointByTag(sWWPControllerTag);

	// if doesn't exist then create it.
	if (!GetIsObjectValid(oWWPController))
	{
		oWWPController = CreateWWPController(sWalkWayPointsTag);
	}
	// store the Waypoint Controller object (and associated tag) on the creature
	SetLocalObject(oCreature, VAR_WWP_CONTROLLER, oWWPController);
	SetLocalString(oCreature, VAR_WP_TAG, sWalkWayPointsTag);

	// if creature's controller has waypoints, then set walk flag and find nearest in set.
	int iNumWaypoints = GetNumWaypoints(oCreature);
	if (iNumWaypoints > 0)
	{
		// Make sure walk flag gets set so that hearbeat will fire.
		// (Won't be set if there is no waypoint set when creature spawns)
		SetWalkCondition(NW_WALK_FLAG_CONSTANT);
		
		// default next to closest wp.
	    SetLocalInt(oCreature, VAR_WP_NEXT, GetNearestWalkWayPoint(oCreature));
	}	

	//PrettyDebug("SetWWPController() - Tag = " + GetTag(oWWPController)); 
	return (oWWPController);
}

	
// return creature's current wwp controller
object GetWWPController(object oCreature=OBJECT_SELF)
{
	object oWWPController = GetLocalObject(oCreature, VAR_WWP_CONTROLLER);
	//PrettyDebug("GetWWPController() - Tag = " + GetTag(oWWPController)); 
	return (oWWPController);
}


// creature will exit from states such as sit and continue to its current waypoint.
// will walk directly to current waypoint - scripted waypoint script won't be called
void ForceResumeWWP(object oCreature=OBJECT_SELF)
{
    SetLocalInt(oCreature, VAR_FORCE_RESUME, TRUE);
    WalkWayPoints(TRUE, "Force Resume");
}

// returns the number of waypoints for creature's walkwaypoint controller, according to specific prefix (WW_WP_PREFIX or WW_WN_PREFIX)
int GetNumWaypointsByPrefix(string sPrefix=WW_WP_PREFIX, object oCreature=OBJECT_SELF)
{
	object oWWPController = GetWWPController(oCreature);
    return (GetLocalInt(oWWPController, sPrefix + WW_NUM));
}

// returns the number of waypoints for creature's walkwaypoint controller, according to the current time of day
int GetNumWaypoints(object oCreature=OBJECT_SELF)
{
	object oWWPController = GetWWPController(oCreature);
	int iNumWaypoints = GetLocalInt(oWWPController, GetWPPrefix() + WW_NUM);
    return (iNumWaypoints);
}

// **** functions for vars on the creature

// set waypoint we intend to travel to.
void SetNextWaypoint(int iNextWP)
{
    SetLocalInt(OBJECT_SELF, VAR_WP_NEXT, iNextWP);
}

// get waypoint we are currently en route to
int GetNextWaypoint()
{
    return (GetLocalInt(OBJECT_SELF, VAR_WP_NEXT));
}

// get waypoint we're currently at
int GetCurrentWaypoint()
{
    return (GetLocalInt(OBJECT_SELF, VAR_WP_CURRENT));
}

// get waypoint we were at previously
int GetPreviousWaypoint()
{
    return (GetLocalInt(OBJECT_SELF, VAR_WP_PREVIOUS));
}

// Retrieves specified WP object for oCreature's WWP Controller
object GetWaypointByNum(int iWayPoint, string sPrefix=WW_WP_PREFIX, object oCreature=OBJECT_SELF)
{
	object oWWPController = GetWWPController(oCreature);
    object oRet = GetLocalObject(oWWPController, GetWPPrefix() + IntToString(iWayPoint));
    return (oRet);
}

// Get Current WP Prefix 
string GetWPPrefix(object oCreature = OBJECT_SELF)
{
    string sPrefix = WW_WP_PREFIX;

    if (GetSpawnInCondition(NW_FLAG_DAY_NIGHT_POSTING) && !GetIsDay()) 
    	sPrefix = WW_WN_PREFIX;

	return(sPrefix);
}

//--------------------------------------------------------------------------


// Get whether the specified WalkWayPoints condition is set
int GetWalkCondition(int nCondition, object oCreature=OBJECT_SELF)
{
    return (GetLocalInt(oCreature, sWalkwayVarname) & nCondition);
}

// Set a given WalkWayPoints condition
void SetWalkCondition(int nCondition, int bValid=TRUE, object oCreature=OBJECT_SELF)
{
    int nCurrentCond = GetLocalInt(oCreature, sWalkwayVarname);
    if (bValid) {
        // the bit that is true will be set to true in the result
        SetLocalInt(oCreature, sWalkwayVarname, nCurrentCond | nCondition);
    } else {
        // take complement of conditon and "and" it with current conditions which means
        // everything preserved except the bit passed in which will be set to 0
        SetLocalInt(oCreature, sWalkwayVarname, nCurrentCond & ~nCondition);
    }
}


// Get a waypoint number suffix, padded if necessary
string GetWaypointSuffix(int i)
{
    if (i < 10) {
        return "0" + IntToString(i);
    }
    return IntToString(i);
}


// Create a WWP Controller (presumably a requested one did not exist)
// The following variables will be set up on the WWP Controller:
// Waypoint variables:
//      WP_NUM     	: number of day waypoints
//      WN_NUM     	: number of night waypoints
//      WP_#, WN_# 	: the waypoint objects
//		WC_TAG		: string - base tag (for use in creating the script name)
object CreateWWPController(string sWalkWayPointsTag)
{
	// we need unique tag for locating waypoints controllers: "WC_<tag>"
	string sWaypointControllerTag = WAYPOINT_CONTROLLER_PREFIX + sWalkWayPointsTag;
	object oWWPController = CreateObject(OBJECT_TYPE_WAYPOINT, RR_WAYPOINT_CONTROLLER, GetLocation(OBJECT_SELF), FALSE, sWaypointControllerTag);
	SetLocalString(oWWPController, VAR_WC_TAG, sWalkWayPointsTag);
	LookUpWalkWayPoints(oWWPController);
	//PrettyDebug("CreateWWPController(" + sWalkWayPointsTag + ") - WP_NUM = " + IntToString(GetLocalInt(oWWPController, "WP_NUM")));
	
	return (oWWPController);
}


// Look up the Waypoint Controllers waypoints and store them (on the Waypoint Controller).
void LookUpWalkWayPoints(object oWWPController)
{
	//SpawnScriptDebugger();

	LookUpWalkWayPointsSet(oWWPController, WW_WP_PREFIX, WW_DAY_POST_PREFIX);

	if( !GetSpawnInCondition(NW_FLAG_DAY_NIGHT_POSTING)) 
	{
	    // no night-time waypoints: set number of night time waypoints to -1
	    SetLocalInt(oWWPController, WW_WN_PREFIX + WW_NUM, -1); // WW_WN_PREFIX + WW_NUM = "WN_NUM"
	} 
	else 
	{
		LookUpWalkWayPointsSet(oWWPController, WW_WN_PREFIX, WW_NIGHT_POST_PREFIX);
	}
}

// look up all the walk way points for this controller.
// since we are creating the waypoint controller at the same location as the creture to
// walk it, we can use either for the location for GetNearest
void LookUpWalkWayPointsSet(object oWWPController, string sPrefix, string sPost)
{
    // check if the module enables area transitions for walkwaypoints
    int bCrossAreas = GetLocalInt(GetModule(),"X2_SWITCH_CROSSAREA_WALKWAYPOINTS");
					
    string sTag = sPrefix + GetLocalString(oWWPController, VAR_WC_TAG) + "_"; // sPrefix will be "WP_" or "WN_"

    int nNth=1;
    object oWay;

    if (!bCrossAreas)
    {
        oWay = GetNearestObjectByTag(sTag + GetWaypointSuffix(nNth));
    }
    else
    {
       oWay = GetObjectByTag(sTag + GetWaypointSuffix(nNth));
    }

	// if no valid waypoints then look for a post.
    if (!GetIsObjectValid(oWay)) {
        if (!bCrossAreas)
        {
            oWay = GetNearestObjectByTag(sPost + GetWPTag());
        }
        else
        {
            oWay = GetObjectByTag(sPost + GetWPTag());
        }
        if (GetIsObjectValid(oWay)) {
            // no waypoints but a post
            SetLocalInt(oWWPController, sPrefix + WW_NUM, 1);
            SetLocalObject(oWWPController, sPrefix + "1", oWay);
        } else {
            // no waypoints or post
            SetLocalInt(oWWPController, sPrefix +WW_NUM, -1);
        }
    } 
	else 
	{
        // look up and store all the waypoints
        while (GetIsObjectValid(oWay)) 
		{
            SetLocalObject(oWWPController, sPrefix + IntToString(nNth), oWay);
            nNth++;
            if (!bCrossAreas)
            {
                oWay = GetNearestObjectByTag(sTag + GetWaypointSuffix(nNth));
            }
            else
            {
                oWay = GetObjectByTag(sTag + GetWaypointSuffix(nNth));
            }
        }
        nNth--;
        SetLocalInt(oWWPController, sPrefix + WW_NUM, nNth);
    }
}

// Determine and return the creature's next waypoint.
// If it has just become day/night, or if this is the first time we're getting a waypoint, we go
// to the nearest waypoint in our new set.
// vars stored on creatures to track their progression through the waypoints
//        WP_PREV    : the last waypoint number
//        WP_CUR     : the current waypoint number
//        WP_NEXT    : the next waypoint number
object GetNextWalkWayPoint(object oCreature=OBJECT_SELF)
{
	//SpawnScriptDebugger();
    string sPrefix = GetWPPrefix();
	int bDayNightSwitch = GetDayNightSwitch();
	int nPoints = GetNumWaypointsByPrefix(sPrefix);

    // Get the new current waypoint
	int nPrevWay 	= GetLocalInt(oCreature, VAR_WP_CURRENT);
    int nCurWay 	= GetLocalInt(oCreature, VAR_WP_NEXT);
    int nNextWay	= nCurWay; // this will be incremented or decremented below.

	// save previous waypoint for use in determining other actions.
   	//SetLocalInt(oCreature, VAR_WP_CURRENT, nCurWay);

    // Check to see if this is the first time
    if (nCurWay == -1) {
        nNextWay = GetNearestWalkWayPoint(oCreature);
    } else {
        // we're either walking forwards or backwards -- check
        int bGoingBackwards = GetWalkCondition(NW_WALK_FLAG_BACKWARDS, oCreature);
        if (bGoingBackwards) {
            nNextWay--;
            if (nNextWay < 1) {
                nNextWay = 2;
                SetWalkCondition(NW_WALK_FLAG_BACKWARDS, FALSE, oCreature);
            }
        } else {
            nNextWay++;
            if (nNextWay > nPoints) {
                nNextWay = nNextWay - 2;
                SetWalkCondition(NW_WALK_FLAG_BACKWARDS, TRUE, oCreature);
            }
        }
    }

    // update the points
    SetLocalInt(oCreature, VAR_WP_NEXT, nNextWay);
    SetLocalInt(oCreature, VAR_WP_CURRENT, nCurWay);
    SetLocalInt(oCreature, VAR_WP_PREVIOUS, nPrevWay);

	// don't execute scripted waypoints when switching from day to night 
	// as this could cause weirdness.
	if (!bDayNightSwitch)
	{
		// script can update WP_NEXT to override next waypoint location
	    string sScript = sPrefix + GetLocalString(OBJECT_SELF, VAR_WP_TAG);
	    ExecuteScript(sScript, oCreature);
	    nNextWay = GetLocalInt(oCreature, VAR_WP_NEXT); // check in case script changed this value
	}

	// not sure what this is protecting against...
    //if (nNextWay == -1)
	//	return OBJECT_INVALID;

	object oRet = GetWaypointByNum(nNextWay, sPrefix);
	//PrettyDebug(GetName(OBJECT_SELF) + ": tag of next wp = " + GetTag(oRet));
    return oRet;
}


// Get the number of the nearest of the creature's current
// set of waypoints (respecting day/night).
int GetNearestWalkWayPoint(object oCreature=OBJECT_SELF)
{
	object oWWPController = GetWWPController(oCreature);

    string sPrefix = GetWPPrefix();
    int nNumPoints = GetLocalInt(oWWPController, sPrefix + WW_NUM);

	if (nNumPoints < 1) 
		return -1;
    int i;
    int nNearest = -1;
    float fDist = 1000000.0;

    object oTmp;
    float fTmpDist;
    for (i=1; i <= nNumPoints; i++) 
	{
        oTmp = GetLocalObject(oWWPController, sPrefix + IntToString(i));
        fTmpDist = GetDistanceBetween(oTmp, oCreature);
        if (fTmpDist >= 0.0 && fTmpDist < fDist) 
		{
            nNearest = i;
            fDist = fTmpDist;
        }
    }
    return nNearest;
}

// Does the basic walking actions for WalkWayPoints
void DoWalkWayPointStandardActions(object oWay, int bKickStart)
{
    if (GetIsObjectValid(oWay) == TRUE)
    {
        SetWalkCondition(NW_WALK_FLAG_CONSTANT);
		
        if((bKickStart == TRUE) || (GetLocalInt(OBJECT_SELF,"N2_OVERRIDE_MOVE") == 0))
        {
        	ActionMoveToObject(oWay);
        }

        ActionDoCommand(WalkWayPoints(FALSE, "Action Queue"));      
    }
    // GZ: 2003-09-03
    // Since this wasnt implemented and we we don't have time for this either, I
    // added this code to allow builders to react to NW_FLAG_SLEEPING_AT_NIGHT.
    if(GetIsNight())
    {
        if(GetSpawnInCondition(NW_FLAG_SLEEPING_AT_NIGHT))
        {
            string sScript = GetLocalString(GetModule(),"X2_S_SLEEP_AT_NIGHT_SCRIPT");
            if (sScript != "")
            {
                ExecuteScript(sScript,OBJECT_SELF);
            }
        }
	}
}


// checks that we aren't fighting, talking, or see enemies.
int IsOkToWalkWayPoints()
{
    // * don't interrupt current circuit
    object oNearestEnemy = GetNearestCreature(CREATURE_TYPE_REPUTATION, REPUTATION_TYPE_ENEMY);
    int bIsEnemyValid = GetIsObjectValid(oNearestEnemy);

    // * if I can see an enemy I should not be trying to walk waypoints
    if (bIsEnemyValid == TRUE)
    {
        if( GetObjectSeen(oNearestEnemy) == TRUE)
        {
            return FALSE;
        }
    }

    if (GetIsFighting(OBJECT_SELF) || IsInConversation(OBJECT_SELF))
	{
		//PrettyDebug(GetName(OBJECT_SELF) + "--- aborted WalkWayPoints due to convo or fight called by --");
		SetLocalInt(OBJECT_SELF, VAR_KICKSTART_REPEAT_COUNT, 100);
        return FALSE;
	}

	return TRUE;
}


// Move to the next waypoint based on whether we are kickstarting
void MoveToNextWaypoint(int bKickStart=FALSE, int bForcResumeOverride=FALSE)
{
    // if paused then do nothing.
    if (GetWalkCondition(NW_WALK_FLAG_PAUSED))
        return;


	// if NPC busy doing anything, then don't try to walk.
    int iCurrentAction = GetCurrentAction(OBJECT_SELF);

	// Force resume will interrupt actions such as sitting.  
    int bForceResume = GetLocalInt(OBJECT_SELF, VAR_FORCE_RESUME) || bForcResumeOverride;

    if (bForceResume == TRUE)
    {
		bKickStart = TRUE;
        SetLocalInt(OBJECT_SELF, VAR_FORCE_RESUME, FALSE);
        if ((iCurrentAction != ACTION_SIT) && (iCurrentAction != ACTION_INVALID))
        {
            // we're busy doing some action other than sitting so no need to resume.
            return;
        }
    }
    else 
	{
		if (iCurrentAction != ACTION_INVALID)
        	return;
	
		// only kickstart if we are known to need it or if it's happened three times in a row
		if (bKickStart == TRUE)
		{
			int iKickStartRepeatCount = GetLocalInt(OBJECT_SELF, VAR_KICKSTART_REPEAT_COUNT) + 1;
			SetLocalInt(OBJECT_SELF, VAR_KICKSTART_REPEAT_COUNT, iKickStartRepeatCount);
			if (iKickStartRepeatCount < 3)
				return;
		}
	}

	// we made it, so we no longer need a kickstart
	SetLocalInt(OBJECT_SELF, VAR_KICKSTART_REPEAT_COUNT, 0);

//    PrintString ("WalkWayPoints: iCurrentAction = " + IntToString(iCurrentAction));
//    PrintString ("WalkWayPoints: Not busy, so doing WWP. invalid = " + IntToString(ACTION_INVALID) + "; iCurrentAction = " + IntToString(iCurrentAction));

    // heartbeat and perceive can add extra calls to walk way points and
    // these can get through even if we are already doing something since
    // some thing like ActionPlayAnimation, SetFacing, etc. don't register as an action
    ClearActions(CLEAR_X0_I0_WALKWAY_WalkWayPoints);
	
    // Initialize if necessary
    if (!GetWalkCondition(NW_WALK_FLAG_INITIALIZED)) {
		// This should only ever be invalid the very first time 
		InitWWPController(OBJECT_SELF);
	}


    // Move to the next waypoint
    object oWay;
	if (GetIsPosted())
	{
		// if posted just head there
		oWay = OBJECT_INVALID;
	}	
	// Kickstart means we'll head to whatever is currently our next waypoint.
	// otherwise we'll determine a new next waypoint and go there.
    else if (bKickStart)
    {
        oWay = GetWaypointByNum(GetNextWaypoint(), GetWPPrefix()); // where was I going?
        //PrettyDebug("Doing kickstart to " + GetTag(oWay));
    }
    else
	{
        oWay = GetNextWalkWayPoint(OBJECT_SELF);
	}
	if (GetIsObjectValid(oWay))
    	DoWalkWayPointStandardActions(oWay, bKickStart);
}

// Make the caller walk through their waypoints or go to their post.
// 5/17/05 - modified to exit if paused and to not interrupt if creature is currently doing
// any action detectable by GetCurrentAction()
void WalkWayPoints(int bKickStart=FALSE, string sWhoCalled="unknown", int bForcResumeOverride=FALSE)
{
	//PrettyDebug(GetName(OBJECT_SELF) + "--- starting WalkWayPoints called by " + sWhoCalled);
	if (!IsOkToWalkWayPoints())
		return;
	MoveToNextWaypoint(bKickStart, bForcResumeOverride);	
    //PrettyDebug(GetName(OBJECT_SELF) + "---- leaving WalkWayPoints called by " + sWhoCalled);
}

// normally we use the tag of the creature, but this can be overridden by using local string "WP_TAG"
// returns tag to use for purpose of initializing waypoints.
string GetWPTag(object oCreature=OBJECT_SELF)
{
	string sWPTag = GetLocalString(oCreature, VAR_WP_TAG);
	if (sWPTag == "")
		sWPTag = GetTag(oCreature);

	return (sWPTag);
}

// Initialize WWP Controller.  This will set object to use the WWP controller with tag "WC_<Creature TAG>"
object InitWWPController(object oCreature=OBJECT_SELF)
{	
    SetWalkCondition(NW_WALK_FLAG_INITIALIZED, TRUE, oCreature);
	string sWPTag = GetWPTag(oCreature);
	object oWWPController = SetWWPController(sWPTag, oCreature);

	// Use appropriate skills, only once
	// * GZ: 2003-09-03 - ActionUseSkill never worked, added the new action mode stuff
	if(GetSpawnInCondition(NW_FLAG_STEALTH)) {
	    SetActionMode(OBJECT_SELF,ACTION_MODE_STEALTH,TRUE);
	}
	
	// * GZ: 2003-09-03 - ActionUseSkill never worked, added the new action mode stuff
	if(GetSpawnInCondition(NW_FLAG_SEARCH)){
	    SetActionMode(OBJECT_SELF,ACTION_MODE_DETECT,TRUE);
	}
	return (oWWPController);
}

/*
// Check to make sure that the walker has at least one valid
// waypoint to walk to at some point.
int CheckWayPoints(object oWalker = OBJECT_SELF)
{
    if (!GetWalkCondition(NW_WALK_FLAG_INITIALIZED, oWalker)) {
        AssignCommand(oWalker, LookUpWalkWayPoints());
    }

    if (GetLocalInt(oWalker, "WP_NUM") > 0 || GetLocalInt(oWalker, "WN_NUM") > 0)
        return TRUE;
    return FALSE;
}
	
// Check to see if the specified object is currently walking
// waypoints or standing at a post.
int GetIsPostOrWalking(object oWalker = OBJECT_SELF)
{
    if (!GetWalkCondition(NW_WALK_FLAG_INITIALIZED, oWalker)) {
        AssignCommand(oWalker, LookUpWalkWayPoints());
    }

	string sPrefix = GetWPPrefix();
    if (GetLocalInt(oWalker, sPrefix +WW_NUM) > 0)
    	return TRUE;

    return FALSE;
}
*/

// returns whether we need to switch over to day or night waypoint set.
// Modify stuff if we do need to switch.
int GetDayNightSwitch(object oCreature=OBJECT_SELF)
{
	int bTimeToSwitch = FALSE;
	if (GetSpawnInCondition(NW_FLAG_DAY_NIGHT_POSTING)) 
	{
		int bIsWalkingDay = GetWalkCondition(NW_WALK_FLAG_IS_DAY, oCreature);

		if ( (bIsWalkingDay && !GetIsDay()) || (!bIsWalkingDay && GetIsDay()) ) 
		{
			//PrettyDebug("Switch to day=" + IntToString(!bIsWalkingDay));

			// time to switch to different set of waypoints
			bTimeToSwitch = TRUE;
			SetWalkCondition(NW_WALK_FLAG_IS_DAY, !bIsWalkingDay, oCreature);

			// reset next which will send us off to the nearest wp in other set
			SetLocalInt(oCreature, VAR_WP_NEXT, -1);
		}
	}
	return (bTimeToSwitch);
}

// Return whether oCreature is posted (just 1 spot to go).
// Also, if posted then go to that spot.
int GetIsPosted(object oCreature=OBJECT_SELF)
{
	string sPrefix = GetWPPrefix();
	int nPoints = GetNumWaypointsByPrefix(sPrefix);
	if ((nPoints == 1) && (GetLocalInt(oCreature, VAR_WP_SINGLE_POINT_OVERRIDE)==FALSE))
	{
		//PrettyDebug(GetName(OBJECT_SELF) + ": only found 1 wp");
		object oWay = GetWaypointByNum(1, sPrefix);
    	ActionMoveToObject(oWay);
    	ActionDoCommand(SetFacing(GetFacing(oWay)));
		return (TRUE);
    }
	return (FALSE);
}