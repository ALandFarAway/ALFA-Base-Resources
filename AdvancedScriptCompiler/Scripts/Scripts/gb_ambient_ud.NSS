// gb_ambient_ud
/*
    User defined for Ambient lifer's
	Note: Commoner's will run from fights automatically.  Commoner here refers to the creature's class, not faction.
	Set creature to only commoner class of less than 10.
	
	How to use:
	Place Observation Points near things to look at (tag: wp_observe)
	Place Shopping Points near places to shop (tag: wp_shop)
	The following vars can be on these:
	"Type" - not currently used, but may be later to further refine what is done at the WP
	"ObjectLookTag" - Object to look at.  If no object specified, then ALC will face same direction as WP
	"Radius" - Distance to randomly venture from WP.  For shopping this will be a distance to the left or right of WP
	
	Create ALC's:
	scripts: gb_ambient_sp and gb_ambient_ud
	variables:
		POI: weighted value for going to an observarion point
		Shop: weighted value for going to an shoping pointt
		Door: weighted value for going to a door (not yet implemented)
		TalkFreq: number of hearbeats to skip between attempting to talk to another ALC
*/

// ChazM 6/22/05
// ChazM 7/27/05 fixed PickRandomTagInArea(), modified ObjPrintString()
// EPF 11/16/05 Fixed an error where iTotal was calculated improperly in main(), removed speak strings.
// EPF 11/17/05 Tweaking with the availability of new animations, removing original DoConversation that
//				used DelayCommand(), Adding DoAngryTalk() and DoNormalTalk().
//				Fixed a bug where the guys weren't facing each other because the OBJECT_SELF position wasn't getting found.


#include "ginc_behavior"
#include "ginc_group"
#include "ginc_debug"
	
//const string TALK_TO_TAG = "1302_Greycloaks";	

// Creature variables
const string ALC_VAR_POI			= "POI"; // variable for frequency to choose POI
const string ALC_VAR_DOOR			= "Door"; // variable for frequency to choose Doors
const string ALC_VAR_SHOP			= "Shop"; // variable for frequency to go shopping
const string ALC_VAR_Worship		= "Worship"; // variable for frequency to go shopping

const string ALC_VAR_TALK_FREQ		= "TalkFreq"; // heartbeats to skip between talk checks.



// POI waypoints
const string POI_TAG 				= "wp_observe"; 
const string SHOP_TAG				= "wp_shop";



// Waypoint variables
const string VAR_TYPE 			= "Type";			// 
const string VAR_OBJECT_LOOK 	= "ObjectLookTag";	// Tag of Object to look at
const string VAR_RADIUS			= "Radius";

// Door Tag
const string DOOR_ALC_TAG 			= "DoorALCExit";

// add name of caller to the print sring
void ObjPrintString(string sString)
{
	//PrintString (GetName(OBJECT_SELF) + ": " +  sString);
}

void DoAngryTalk(object oResponder)
{
	//dude greets me
	AssignCommand(oResponder, ActionPlayAnimation(ANIMATION_FIREFORGET_GREETING));
	ActionWait(2.f);
	AssignCommand(oResponder, ActionWait(2.f));
			
	//I cuss him out
	ActionPlayAnimation(ANIMATION_LOOPING_TALK_FORCEFUL, 1.f, 5.f);
	AssignCommand(oResponder, ActionPlayAnimation(ANIMATION_LOOPING_LISTEN, 1.f, 5.f));

	ActionPlayAnimation(ANIMATION_LOOPING_LISTEN, 1.f, 5.f);
	AssignCommand(oResponder, ActionPlayAnimation(ANIMATION_LOOPING_TALK_PLEADING, 1.f, 5.f));
}

void DoNormalTalk(object oResponder)
{
	//greet
	ActionPlayAnimation(ANIMATION_FIREFORGET_GREETING);
	ActionWait(4.f);
	AssignCommand(oResponder, ActionWait(2.f));
	
	//return greeting
	AssignCommand(oResponder, ActionPlayAnimation(ANIMATION_FIREFORGET_GREETING));
	AssignCommand(oResponder, ActionWait(2.f));

	//talk
	ActionPlayAnimation(ANIMATION_LOOPING_TALK_NORMAL, 1.f, 5.f);
	AssignCommand(oResponder, ActionPlayAnimation(ANIMATION_LOOPING_LISTEN, 1.f, 5.f));

	//respond
	ActionPlayAnimation(ANIMATION_LOOPING_LISTEN, 1.f, 5.f);
		
	if(Random(3) != 0)
	{
		AssignCommand(oResponder, ActionPlayAnimation(ANIMATION_LOOPING_TALK_LAUGHING, 1.f, 5.f));
	}
	else
	{
		AssignCommand(oResponder, ActionPlayAnimation(ANIMATION_LOOPING_TALK_NORMAL, 1.f, 5.f));
	}
	
	//maybe react
	if(Random(4) == 0)
	{
		int nReaction = Random(4) + 1;
		switch(nReaction)
		{
		case 1: //yawn
			ActionPlayAnimation(ANIMATION_LOOPING_PAUSE_TIRED, 1.f, 2.f);
			break;
		case 2:	//cheer
			ActionPlayAnimation(ANIMATION_FIREFORGET_VICTORY1);
			ActionWait(2.5f);
			AssignCommand(oResponder, ActionWait(2.5f));
			break;
		case 3:	//nod
			ActionPlayAnimation(ANIMATION_FIREFORGET_READ);
			ActionWait(2.f);
			AssignCommand(oResponder, ActionWait(2.5f));
			break;
		case 4:	//bow
			ActionPlayAnimation(ANIMATION_FIREFORGET_BOW);
			ActionWait(2.f);
			AssignCommand(oResponder, ActionWait(2.f));

			AssignCommand(oResponder, ActionPlayAnimation(ANIMATION_FIREFORGET_BOW));
			AssignCommand(oResponder, ActionWait(2.f));
			ActionWait(2.f);
			break;
		}
	}
	
}
	
// strike up conversation w/ neareast NPC if the NPC is relatively close and neither of us is
// already talking and NPC has the tag of someone I will talk to.
int DoConversation()
{
	float fDelay;
	float fDistance;
	object oNearestCreature;
	//vector vPos = GetPosition(OBJECT_SELF);
	int iRet = FALSE;


	ObjPrintString ("Looking for convo partner");
	//ClearAllActions(TRUE);
	oNearestCreature =  GetNearestCreature(CREATURE_TYPE_PLAYER_CHAR, PLAYER_CHAR_NOT_PC); 
	fDistance = GetDistanceBetween(OBJECT_SELF, oNearestCreature);
	if(fDistance <= 5.f && fDistance >= 1.5f && 
		!GetLocalInt(oNearestCreature, "bConversing") && !GetLocalInt(OBJECT_SELF, "bConversing") && 
		GetLocalInt(oNearestCreature, "ALC"))
	{
		// for passing object self as param for an action inside an AssignCommand()
		object oSelf = OBJECT_SELF;

		SetLocalInt(oNearestCreature, "bConversing", TRUE);
		SetLocalInt(OBJECT_SELF, "bConversing", TRUE);

		ObjPrintString ("Found convo partner: " + GetName(oNearestCreature));
		//set up conversation state
		ClearAllActions(TRUE);
		AssignCommand(oNearestCreature, ClearAllActions(TRUE));
		
		
		// Face each other
		SetFacingPoint(GetPosition(oNearestCreature));
		ActionWait(1.f);
		vector vSelf = GetPosition(OBJECT_SELF);
		AssignCommand(oNearestCreature, SetFacingPoint(vSelf));
		AssignCommand(oNearestCreature, ActionWait(1.f));

		// 1 in 4 chance of argument
		if(Random(4) == 0)
		{
			DoAngryTalk(oNearestCreature);
		}
		else
		{
			DoNormalTalk(oNearestCreature);
		}

		// end conversation state
		ActionDoCommand(SetLocalInt(OBJECT_SELF, "bConversing", FALSE));
		AssignCommand(oNearestCreature, ActionDoCommand(SetLocalInt(OBJECT_SELF, "bConversing", FALSE)));
		NoInterrupt();
		AssignCommand(oNearestCreature, NoInterrupt());
		iRet = TRUE;
	}
	return (iRet);
}

// Randomly selects one of the objects in the area with the specified tag
object PickRandomTagInArea(string sTag)
{
	string sGroupName = GetTag(GetArea(OBJECT_SELF)) + sTag;
	//PrintString ("PickRandomTagInArea: sGroupName = " + sGroupName);

	//create group if this is the first time.
	if (IsGroupEmpty(sGroupName)) 
	{
		int i = 1;
		object oObj = GetNearestObjectByTag(sTag, OBJECT_SELF, i);
		while (GetIsObjectValid(oObj))
		{
			
			GroupAddMember(sGroupName, oObj);
			i++;
			oObj = GetNearestObjectByTag(sTag, OBJECT_SELF, i);
		}
	}
	//PrintString (""GetNumObjects(sGroupName))
	int iIndex = Random(GroupGetNumObjects(sGroupName))+1;
	return (GroupGetObjectIndex(sGroupName, iIndex));
}


// creature turns to face the specified object, or else looks in directions of WP.
void ActionPOIAlign(object oDest)
{
	string sObjectLook = GetLocalString(oDest, VAR_OBJECT_LOOK);
	object oObjectLook = OBJECT_INVALID;
	if (sObjectLook != "")
		 oObjectLook = GetNearestObjectByTag(sObjectLook, oDest);

	ObjPrintString ("Name of |" + sObjectLook + "| is: " + GetName(oObjectLook));
	if (GetIsObjectValid(oObjectLook))
		ActionOrientToObject(oObjectLook, ORIENT_FACE_TARGET);
	else
		ActionOrientToObject(oDest, ORIENT_FACE_SAME_AS_TARGET);

}

// move to indicated tag as far as Radius stored on tag.
void ActionMoveNearWP(object oDest, int bRun = FALSE)
{
	float fDistance = GetLocalFloat(oDest, VAR_RADIUS);
	ObjPrintString ("fDistance: " + LocationToString(GetLocation(oDest)));
	ObjPrintString ("Dest WP location: " + LocationToString(GetLocation(oDest)));

	location lDest = GetNearbyLocation(GetLocation(oDest), fDistance);
	ObjPrintString ("moving to location: " + LocationToString(lDest));
	ActionMoveToLocation (lDest, bRun);
}	

// move to indicated tag as far as Radius stored on tag.
void ActionMoveAlongSideWP(object oDest, int bRun = FALSE)
{
	float fDistance = GetLocalFloat(oDest, VAR_RADIUS);
	ObjPrintString ("fDistance: " + LocationToString(GetLocation(oDest)));
	ObjPrintString ("Dest WP location: " + LocationToString(GetLocation(oDest)));

	// TODO: replace w/ function that will get a location that is at right angles to the 
	// facing of the waypoint, up to fDistance away in either direction
	location lDest = GetLocation(oDest);
	//location lDest = GetNearbyLocation(GetLocation(oDest), fDistance);
	ObjPrintString ("moving to location: " + LocationToString(lDest));
	ActionMoveToLocation (lDest, bRun);
}	



void ALC_DetermineAction()
{
	ObjPrintString("ALC_DetermineAction");
	int iPOI = GetLocalInt(OBJECT_SELF, ALC_VAR_POI);
	int iDoor = GetLocalInt(OBJECT_SELF, ALC_VAR_DOOR);
	int iShop = GetLocalInt(OBJECT_SELF, ALC_VAR_SHOP);
	//int iWorship = GetLocalInt(OBJECT_SELF, ALC_VAR_WORSHIP);

	int iTotal = iPOI + iDoor + iShop;
	int iRand = Random(iTotal) + 1;

	if (iRand <= iPOI)
	{
		object oDest = PickRandomTagInArea(POI_TAG);
		ActionMoveNearWP(oDest);
		ActionPOIAlign(oDest);
//		ActionSpeakString ("Pretty Tree");
		ActionWait(5.0f);
	} 
	else if (iRand < iPOI + iDoor)
	{
//		ActionSpeakString("I want to go to a door.");
	}
	else if (iRand < iPOI + iDoor + iShop)
	{
		object oDest = PickRandomTagInArea(SHOP_TAG);
		ActionMoveAlongSideWP(oDest);
		ActionPOIAlign(oDest);
//		ActionSpeakString ("Nice goods.");
		ActionWait(5.0f);
	}
//	else if (iRand < iPOI + iDoor + iShop + iWorship)
//	{
//		object oDest = PickRandomTagInArea(SHOP_TAG);
//		ActionMoveAlongSideWP(oDest);
//		ActionPOIAlign(oDest);
//		ActionSpeakString ("Nice goods.");
//		ActionWait(5.0f);
//	}
	else 
	{
//		ActionSpeakString("I want to do something else.");
	}
}


// 
void ReactToPerceivedObject()
{
	object oCreature = GetLastPerceived();
//	SpeakString("Perceived " + GetName(oCreature));
	if (GetIsPC(oCreature))
		return;
	//if (GetIsInCombat(oCreature))

	// the problem w/ looking for opportunities in the perceive object is that
	// they won't fire again until the object leaves and comes back.  This means in cramped quarters
	// they won't talk anymore.
	/*if(Random(5) == 0) 
	{
		if(!GetLocalInt(oCreature, "bConversing") &&
			!GetLocalInt(OBJECT_SELF, "bConversing") && GetTag(oCreature) == TALK_TO_TAG)
			DoConversation();
	}
	*/

}
int IncLocalInt(object oObject, string sVarName)
{
	int iValue = GetLocalInt(oObject, sVarName) + 1;
	SetLocalInt(oObject, sVarName, iValue);
	return iValue;
}

// randomly check each HB if we will look for someone to start a convo with.
int CheckThisHB()
{
	int iTalkFreq = GetLocalInt(OBJECT_SELF, ALC_VAR_TALK_FREQ);
	if(Random(iTalkFreq) == 0) 
		return TRUE;

	//if (iTalkFreq > 0)
	//{
//		int iHBCount = IncLocalInt(OBJECT_SELF, "HBCount");
//		if (iHBCount >= iTalkFreq)
//		{
//			SetLocalInt(OBJECT_SELF, "HBCount", 0);
//			return TRUE;
//		}
	//}
	return FALSE;
}


void main()
{
    int iEvent = GetUserDefinedEventNumber();

    switch (iEvent)
	{
		case EVENT_HEARTBEAT: 	// 1001
	        if (GetAILevel(OBJECT_SELF) == AI_LEVEL_VERY_LOW)
	            return;
			if (GetLocalInt(OBJECT_SELF, "bConversing"))
				return;
			// look for oportunities every once in a while
			if (CheckThisHB())
			{
				ObjPrintString ("Do HB Check");
				if (DoConversation())
					return;
			}

			// pick a new goal if not doing anything
		    if (!IsBusy())
	        	ALC_DetermineAction();
			break;	

		case EVENT_PERCEIVE: 	// 1002
			ReactToPerceivedObject();
			break;	

		case EVENT_END_COMBAT_ROUND: 	// 1003
			break;	

		case EVENT_DIALOGUE: 	// 1004
			// shouts already cause commoners to flee combats
			break;	

		case EVENT_ATTACKED: 	// 1005
			break;	

		case EVENT_DAMAGED:		// 1006
			break;
	
		case EVENT_DISTURBED: 	// 1008
			break;	

		case EVENT_SPELL_CAST_AT: 	// 1011
			break;	
	}

}