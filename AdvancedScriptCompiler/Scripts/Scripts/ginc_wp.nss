// ginc_wp
/*
    Standard include for scripted waypoints

    The functions are organized by job-related categories.  General utility funtions are listed first,
    the rest of the sections are listed in alphabetical order according to job category.

*/
// ChazM 1/6/06
// ChazM 1/7/07 updated GetPreviousWaypoint(), SetCurrentWaypoint(), and GetCurrentWaypoint() to
//              GetCurrentWaypoint(), SetNextWaypoint(), and GetNextWaypoint() by popular demand
// ChazM 1/10/06 Added Conversation section
// ChazM 1/11/06 Added Travel Section
// ChazM 1/17/06 Added RollDice()
// ChazM 1/19/06 Added GetWaypointString(), GetWaypointRangeString(), SelectRandomWaypointFromString(),
//				modified RandomOnwardWaypoint(), GetRandomWaypoint()
// ChazM 1/20/06 included ginc_item
// ChazM 1/24/06 Added StandardRedirectorNode(), StandardRoadNetworkNode(), JumpToNextWP()
// DBR   2/13/06 Standardized RandomFloat()
// ChazM 3/08/06 Modified StandardRedirectorNode(), StandardRoadNetworkNode() - added back in the script hidden stuff
// ChazM 6/18/07 Added ShortConvoIfOtherAvailable(), ChatWithNearestCreature(), ChatWithObjectByTag()
	
#include "x0_i0_walkway"
#include "ginc_actions"
#include "x0_i0_stringlib"
#include "ginc_item"
#include "ginc_math"
#include "ginc_behavior"

//void main(){}
// =====================================================================================
// Prototypes
// =====================================================================================
/*
// some useful functions in x0_i0_walkway:
void ForceResumeWWP(object oCreature=OBJECT_SELF);
int GetNumWaypoints(object oCreature=OBJECT_SELF);
int GetNumWaypointsByPrefix(string sPrefix, object oCreature=OBJECT_SELF);
void SetNextWaypoint(int iNextWP);
int GetNextWaypoint();
int GetCurrentWaypoint();
int GetPreviousWaypoint();
object GetWaypointByNum(int iWayPoint, object oCreature=OBJECT_SELF);
string GetWPPrefix(object oCreature = OBJECT_SELF);
int GetWalkCondition(int nCondition, object oCreature=OBJECT_SELF);// Get whether the condition is set
void SetWalkCondition(int nCondition, int bValid=TRUE, object oCreature=OBJECT_SELF);// Set a given condition
*/

// GENERAL
void FaceAndPause(int iWayPoint, float fPause = 1.0f);
void ActionSpeakOneLiner(string sConversation = "");

//	CONVERSATION
int RandomTalkAnim();
int RandomVictoryAnim();
int RandomPauseAnim();
int RandomInteractionAnim();
int AnimationNeedsWait(int iAnimation);
void AnimateWithOther(object oOther, float fDurationSeconds=5.0f, int iAnimation=ANIMATION_LOOPING_TALK_NORMAL, int iOtherAnimation=ANIMATION_LOOPING_LISTEN, float fSpeed=1.0f);
void TalkToListener(object oListener, float fDurationSeconds=5.0f, int iTalkerAnimation=ANIMATION_LOOPING_TALK_NORMAL);
void ListenToTalker(object oListener, float fDurationSeconds=5.0f, int iTalkerAnimation=ANIMATION_LOOPING_TALK_NORMAL);
void MutualGreeting(object oOther, float fDurationSeconds=2.0f);
void RandomInteractionExchange(object oOther, int iFreq=3, int iRand=7, int iDelta=3);
void StandardExchange(object oOther, int iAnimation, int iRand=7, int iDelta=3);
void AngryTalk(object oOther, int iRand=7, int iDelta=3);
void TypicalTalk(object oOther, int iRand=7, int iDelta=3);
void InitiateConversation(object oOther);
void ShortConversation(object oOther);
void ShortConvoIfOtherAvailable(object oOther);
void ChatWithNearestCreature(int nNth=1);
void ChatWithObjectByTag(string sTag);

//	FARMING
void RandomFarmAction();
void TypicalFarmer();

//  LABOR
void LookInCrate(object oCrate);

	
// TRAVEL
// waypoint string are 2 digits, seperated by commas
const int WAYPOINT_ENTY_LENGTH 	= 3; // 2 digits + a comma delimiter
const int WAYPOINT_DIGITS 		= 2;

// returns a waypoint in the string format used by SelectRandomWaypointFromString()
string GetWaypointString(int iWP, int iExcludedWP=-1);

// returns string w/ all waypoints in the range iMinWP - iMaxWP
string GetWaypointRangeString(int iMinWP, int iMaxWP, int iExcludedWP=-1);

// Returns a random num from a delimited list.
int SelectRandomWaypointFromString(string sWPString, int iExcludedWP=-1);

// get random waypoint from set of all waypoints other than the current one.
int GetRandomWaypoint(int bExcludeCurrent = TRUE);

// pick a random num that isn't a default value or the previous wp.  
int RandomOnwardWaypoint(int iWP1, int iWP2=-1, int iWP3=-1, int iWP4=-1, int iWP5=-1);



// =====================================================================================
// Functions
// =====================================================================================
	
// -------------------------------------------------------------------------------------
// GENERAL
// -------------------------------------------------------------------------------------

// faces the waypoint and waits a default of 1 sec - replicates NWN1 WWP
void FaceAndPause(int iWayPoint, float fPause = 1.0f)
{
    object oWay = GetWaypointByNum(iWayPoint);
    ActionDoCommand(SetFacing(GetFacing(oWay)));
    ActionWait(fPause);
}




// put "speak one liner" on action queue
void ActionSpeakOneLiner(string sConversation = "")
{
    ActionDoCommand(SpeakOneLinerConversation(sConversation));
//    ActionSpeakString
}

int RollDice (int iNumDice, int iNumSides, int iModifier = 0)
{
	int iTotal = iModifier;
	int i;
	for (i=1; i<= iNumDice; i++)
	{
		iTotal += Random(iNumSides)+1;
	}
	return (iTotal);
}


// -------------------------------------------------------------------------------------
// CONVERSATION
// -------------------------------------------------------------------------------------


int RandomTalkAnim()
{
    int nReaction = Random(4) + 1;
    int iAction;
    switch(nReaction)
    {
    case 1:
        iAction = ANIMATION_LOOPING_TALK_PLEADING;
        break;
    case 2:
        iAction = ANIMATION_LOOPING_TALK_FORCEFUL;
        break;
    case 3:
        iAction = ANIMATION_LOOPING_TALK_NORMAL;
        break;
    case 4:
        iAction = ANIMATION_LOOPING_TALK_LAUGHING;
        break;
    }
    return (iAction);
}

int RandomVictoryAnim()
{
    int nReaction = Random(3) + 1;
    int iAction;
    switch(nReaction)
    {
    case 1:
        iAction = ANIMATION_FIREFORGET_VICTORY1;
        break;
    case 2:
        iAction = ANIMATION_FIREFORGET_VICTORY2;
        break;
    case 3:
        iAction = ANIMATION_FIREFORGET_VICTORY3;
        break;
    }
    return (iAction);
}

int RandomPauseAnim()
{
    int nReaction = Random(6) + 1;
    int iAction;
    switch(nReaction)
    {
    case 1:
        iAction = ANIMATION_LOOPING_PAUSE;
        break;
    case 2:
        iAction = ANIMATION_LOOPING_PAUSE2;
        break;
    case 3:
        iAction = ANIMATION_LOOPING_PAUSE_TIRED;
        break;
    case 4:
        iAction = ANIMATION_LOOPING_PAUSE_DRUNK;
        break;
    case 5:
        iAction = ANIMATION_FIREFORGET_PAUSE_SCRATCH_HEAD;
        break;
    case 6:
        iAction = ANIMATION_FIREFORGET_PAUSE_BORED;
        break;
    }
    return (iAction);
}

int RandomInteractionAnim()
{
    int nReaction = Random(5) + 1;
    int iAction;
    switch(nReaction)
    {
    case 1:
        iAction = RandomPauseAnim();
        break;
    case 2: //cheer
        iAction = RandomVictoryAnim();
        break;
    case 3: //nod
        iAction = ANIMATION_FIREFORGET_READ;
        break;
    case 4: //bow
        iAction = ANIMATION_FIREFORGET_BOW;
        break;
    case 5:
        iAction = RandomTalkAnim();
        break;
    }
    return (iAction);
}


int AnimationNeedsWait(int iAnimation)
{
    int iRet = FALSE;
    if ((iAnimation > 100) || (iAnimation == ANIMATION_LOOPING_LISTEN))
        iRet = TRUE;

    return(iRet);
}

// I animate and so does another object.  If Fire & Forget anims, then use waits to keep on same track.
void AnimateWithOther(object oOther, float fDurationSeconds=5.0f, int iAnimation=ANIMATION_LOOPING_TALK_NORMAL, int iOtherAnimation=ANIMATION_LOOPING_LISTEN, float fSpeed=1.0f)
{
    ActionPlayAnimation(iAnimation, fSpeed, fDurationSeconds);
    if (AnimationNeedsWait(iAnimation))
        ActionWait(fDurationSeconds);

    AssignCommand(oOther, ActionPlayAnimation(iOtherAnimation, fSpeed, fDurationSeconds));
    if (AnimationNeedsWait(iOtherAnimation))
        AssignCommand(oOther, ActionWait(fDurationSeconds));
}


void TalkToListener(object oListener, float fDurationSeconds=5.0f, int iTalkerAnimation=ANIMATION_LOOPING_TALK_NORMAL)
{
    AnimateWithOther(oListener, fDurationSeconds, iTalkerAnimation);
}

void ListenToTalker(object oListener, float fDurationSeconds=5.0f, int iTalkerAnimation=ANIMATION_LOOPING_TALK_NORMAL)
{
    AnimateWithOther(oListener, fDurationSeconds, ANIMATION_LOOPING_LISTEN, iTalkerAnimation);
}


void MutualGreeting(object oOther, float fDurationSeconds=2.0f)
{
    AnimateWithOther(oOther, fDurationSeconds, ANIMATION_FIREFORGET_GREETING, ANIMATION_FIREFORGET_GREETING);
}

// exchanges are 1 round where both parties both talk and listen
void RandomInteractionExchange(object oOther, int iFreq=3, int iRand=7, int iDelta=3)
{
    if(Random(iFreq) == 0)
    {
        float fDurationSeconds = RandomFloat(IntToFloat(iRand))+ iDelta;
        TalkToListener(oOther, fDurationSeconds, RandomTalkAnim());
        fDurationSeconds = RandomFloat(IntToFloat(iRand))+ iDelta;
        ListenToTalker(oOther, fDurationSeconds, RandomInteractionAnim());
    }
}

void StandardExchange(object oOther, int iAnimation, int iRand=7, int iDelta=3)
{
    float fDurationSeconds = RandomFloat(IntToFloat(iRand))+ iDelta;
    TalkToListener(oOther, fDurationSeconds, iAnimation);
    fDurationSeconds = RandomFloat(IntToFloat(iRand)) + iDelta;
    ListenToTalker(oOther, fDurationSeconds, iAnimation);
    RandomInteractionExchange(oOther);
}

// Talk encompass multiple exchanges
void AngryTalk(object oOther, int iRand=7, int iDelta=3)
{
    StandardExchange(oOther, ANIMATION_LOOPING_TALK_FORCEFUL);
    RandomInteractionExchange(oOther);
}


void TypicalTalk(object oOther, int iRand=7, int iDelta=3)
{
    StandardExchange(oOther, RandomTalkAnim());
    RandomInteractionExchange(oOther);
}

void InitiateConversation(object oOther)
{
    // approach
    object oSelf = OBJECT_SELF;
    ActionMoveToObject(oOther);
    AssignCommand(oOther, ActionMoveToObject(oSelf));
    ActionOrientToObject(oOther, ORIENT_FACE_TARGET);
    AssignCommand(oOther, ActionOrientToObject(oSelf, ORIENT_FACE_TARGET));
}

// conversations are like talks, but are complete and may contain greetings and/or salutations
void ShortConversation(object oOther)
{
	// hello
    MutualGreeting(oOther);

	// approach
	InitiateConversation(oOther);

	// talk
    TypicalTalk(oOther);
    TypicalTalk(oOther);

	// goodbye
    MutualGreeting(oOther);
}


void ShortConvoIfOtherAvailable(object oOther)
{
	if (!IsBusy(oOther))
	{
		ShortConversation(oOther);			
	}
}


void ChatWithNearestCreature(int nNth=1)
{
	object oTarget = GetNearestObject(OBJECT_TYPE_CREATURE, OBJECT_SELF, nNth);
	// if Target is in the area, let's chat with them
	if (GetIsObjectValid(oTarget) && !(GetIsPC(oTarget)))
	{
		ShortConvoIfOtherAvailable(oTarget);
	}
}

void ChatWithObjectByTag(string sTag)
{
	object oTarget = GetNearestObjectByTag(sTag);
	// if Target is in the area, let's chat with them
	if (GetIsObjectValid(oTarget))
	{
		ShortConvoIfOtherAvailable(oTarget);
	}
}

// -------------------------------------------------------------------------------------
// FARMING
// -------------------------------------------------------------------------------------
void RandomFarmAction()
{
    int iAction = Random(5);
    float fDuration = IntToFloat(Random(5)+3);
    switch (iAction)
    {
        case 0:
        case 1:
           ActionPlayAnimation(ANIMATION_LOOPING_GET_LOW, 1.0, fDuration);
            break;
        case 2:
        case 3:
            ActionPlayAnimation(ANIMATION_LOOPING_GET_MID, 1.0, fDuration);
            break;
        case 4:
            ActionPlayAnimation(ANIMATION_LOOPING_PAUSE_TIRED, 1.0, fDuration);
            break;
    }
}

void TypicalFarmer()
{
    SetNextWaypoint(GetRandomWaypoint());
    RandomFarmAction();
    ActionMoveAwayFromLocation(GetLocation(OBJECT_SELF),FALSE, IntToFloat(Random(2)+1));
    RandomFarmAction();
}

// -------------------------------------------------------------------------------------
// LABOR
// -------------------------------------------------------------------------------------

void LookInCrate(object oCrate)
{
    ActionMoveToObject(oCrate);
    // ActionInteractObject(oCrate);
    ActionDoCommand(AssignCommand(oCrate, PlayAnimation(ANIMATION_PLACEABLE_OPEN)));
    ActionPlayAnimation(ANIMATION_LOOPING_GET_MID, 1.0, RandomFloat(IntToFloat(6))+3);
    ActionDoCommand(AssignCommand(oCrate, PlayAnimation(ANIMATION_PLACEABLE_CLOSE)));

    ActionMoveAwayFromObject(oCrate, FALSE, RandomFloat(IntToFloat(3))+ 1);
    ActionWait(RandomFloat(IntToFloat(2))+ 1);
}

// -------------------------------------------------------------------------------------
// TRAVEL
// -------------------------------------------------------------------------------------

// returns a waypoint in the string format used by SelectRandomWaypointFromString()
string GetWaypointString(int iWP, int iExcludedWP=-1)
{
	if ((iWP < 0) ||(iWP == iExcludedWP))
		return "";
	else
		return GetWaypointSuffix(iWP) + ",";
}


// returns string w/ all waypoints in the range iMinWP - iMaxWP
string GetWaypointRangeString(int iMinWP, int iMaxWP, int iExcludedWP=-1)
{
	int i;
	string sWPString = "";
	for (i=iMinWP; i <= iMaxWP; i++)
	{
		sWPString += GetWaypointString(i, iExcludedWP);
	}
	return (sWPString);
}

// Returns a random num from a delimited list.
// returns 0 if can't find anything.
// string should be in the format "XX,YY,ZZ..."
// a final comma is allowed but not required.
int SelectRandomWaypointFromString(string sWPString, int iExcludedWP=-1)
{
	// add 1 to string length to account for possibly having no ending comma
	int iChoice = Random((GetStringLength(sWPString)+1)/WAYPOINT_ENTY_LENGTH);
	string sWP = GetSubString(sWPString, iChoice*WAYPOINT_ENTY_LENGTH, WAYPOINT_DIGITS);
	int iWP = StringToInt(sWP);

	// iWP will be 0 if we can't get a number out of the string.
	while ((iWP == iExcludedWP) && (iWP != 0))
	{
		sWPString = RemoveListElement(sWPString, sWP); // remove waypoint from list
		iChoice = Random((GetStringLength(sWPString)+1)/WAYPOINT_ENTY_LENGTH);
		sWP = GetSubString(sWPString, iChoice*WAYPOINT_ENTY_LENGTH, WAYPOINT_DIGITS);
		iWP = StringToInt(sWP);
	}
	return(iWP);
}

// get random waypoint from set of all waypoints
int GetRandomWaypoint(int bExcludeCurrent = TRUE)
{
    int iNumWaypoints = GetNumWaypoints();
	int iCurrentWP = GetCurrentWaypoint();		
    int iNextWP = Random(iNumWaypoints) + 1;
	
	// if quick way failed, do long way.
    if (bExcludeCurrent && (iNextWP == iCurrentWP) )
	{
		string sWPString = GetWaypointRangeString(1, iNumWaypoints, iCurrentWP);
		iNextWP = SelectRandomWaypointFromString(sWPString);
	}
    return (iNextWP);
}

// pick a random num that isn't a default value or the previous wp.  
int RandomOnwardWaypoint(int iWP1, int iWP2=-1, int iWP3=-1, int iWP4=-1, int iWP5=-1)
{
	int iWPCount;
	int iPrevWP = GetPreviousWaypoint();
	string sWPString = "";
	sWPString += GetWaypointString(iWP1, iPrevWP);
	sWPString += GetWaypointString(iWP2, iPrevWP);
	sWPString += GetWaypointString(iWP3, iPrevWP);
	sWPString += GetWaypointString(iWP4, iPrevWP);
	sWPString += GetWaypointString(iWP5, iPrevWP);

	int iWP = SelectRandomWaypointFromString(sWPString);
	//int iChoice = Random(GetStringLength(sWPString)/2);
	//int iWP = StringToInt(GetSubString(sWPString, iChoice*2, 2));
	//PrettyDebug(GetName(OBJECT_SELF) + " WP string: " + sWPString);
	return (iWP);
}

void JumpToNextWP(int iWP)
{
	SetNextWaypoint (iWP);
	ActionJumpToObject(GetWaypointByNum(iWP));
}
		
// function for nodes
void StandardRoadNetworkNode(string sWPString, int iRedirecterWP)
{
	int iPrevWP = GetPreviousWaypoint();
	int iWP = SelectRandomWaypointFromString(sWPString, iPrevWP);
	//PrettyDebug ("iWP = " + IntToString (iWP));
	if (0 == iWP)
	{
		ActionDoCommand(SetScriptHidden(OBJECT_SELF, TRUE, FALSE));// hide myself
		ActionWait(1.0f);
		//SetScriptHidden(OBJECT_SELF, TRUE);
		JumpToNextWP(iRedirecterWP);
	}
	else
		SetNextWaypoint(iWP);
}		

// function for the redirector waypoint
void StandardRedirectorNode(string sWPString, float fWaitTime)
{
	int iPrevWP = GetPreviousWaypoint();
	int iWP = SelectRandomWaypointFromString(sWPString, iPrevWP);
	if (0 == iWP)
	{
		PrettyDebug ("No where to go from StandardRedirectorNode()");
	}
	else
	{
		EquipRandomArmorFromInventory();
		ActionWait(fWaitTime);
		JumpToNextWP(iWP);
		ActionWait(1.0f);
		ActionDoCommand(SetScriptHidden(OBJECT_SELF, FALSE));// show myself again
		//SetScriptHidden(OBJECT_SELF, FALSE);// show myself again
	}
}