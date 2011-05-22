// ginc_trigger
/*
	trigger related functions

		
	The following variables will be examined on a Speak trigger.  First 2 paramaters are required. Order is not important
	NPC_Tag 		- Tag of creature to make comment.  Must be in this area.  Blank defaults to the entering PC.
	Conversation 	- Conversation file to play.  
	Node			- Node of the conversation to speak.  Node indexes are set using gc_node() in the dialog conditionals.
					  Do not define a node 0, as this is reserved.
	Run				- Set to following:
						2 - Target Jumps to PC
						1 - Target runs to PC
						0 - (default) Target Walks to PC 
					   -1 - Target Stays Put (and TalkNow=1 by default)
	TalkNow			- Set to following:
						0 - (default) use default based on Run mode.
						1 - talk immediately, regardless of distance 
						2 - only talk when close (default except when Run = -1)
	CutsceneBars	- Set to following:
						0 - (default) no cutscene bars 
						1 - show cutscene bars
	OnceOnly		- Controls whether or not NPC's Node index is cleared after it's first use.  Set to following:
						0 - (default) the node index is not reset by gc_node
						1 - gc_node will reset the node index to 0 so that it only recognizes it once
	MultiUse		- Controls whether the Speak Trigger fires only once or on every enter
						0 - (default) Only triggers once
						1 - Triggers every time.
	CombatCutsceneSetup - Controls whether to Plot party, Hide hostiles, hold AI for duration of conversation.
						0 - (default) Normal speak trigger
						1 - Use CombatCutsceneSetup() and QueueCombatCutsceneCleanUp()
	DoNotChangePlayer	- Controls whether or not the player will be warped to the trigger if a companion or henchman walks into it
						0 - (default) He sure will, good for standard speak triggers
						1 - Heck no. No warping so no weird jumps for player.
	
*/
// ChazM 4/6/05
// ChazM 4/19/05 - added -1 Run option
// ChazM 5/3/05 - added Jump option, TalkNow, and CutsceneBars	
// ChazM 5/6/05 - fixed TalkNow to start convo before running to player	
// ChazM 5/25/05 - added OnceOnly	
// EPF 6/3/05 - Making the entering object the target of the GetNearestObjectByTag() call, which is more reliable than having the 
// 		trigger own the function.
// ChazM 6/14/05 - Fixed problem with target not being found.
// ChazM 6/14/05 - Blank for NPC_Tag now refers to the entering PC.
// ChazM 6/25/05 - Split functions from gtr_speak_node into this include
// ChazM 7/13/05 - Added bunch of PrintString()'s
// ChazM 7/13/05 - Modified StandardSpeakTriggerConditions() to support MultiUse
// EPF 7/29/05 - Speak trigger will now fire even if a player is in combat.
// ChazM 9/12/05 - Modified GetTriggerTarget()
// EPF 9/24/95 - found a second instance of a check that aborts the speak trigger if the player was in combat.  Commented it out.
// BMA-OEI 1/6/06 - changed default GetTriggerTarget() to OBJECT_SELF
// BMA-OEI 1/13/06 - added GetTriggerTarget() warning, triggers as owners mess up random cams
// BMA-OEI 2/7/06 - Added comments/debug lines to GetTriggerTarget(), DoSpeakTrigger()
// EPF 2/10/06	- fixed compiler error in line 146.
// BMA-OEI 2/28/06 - added PrepareForConversation()
// BMA-OEI 3/6/06 - added CombatCutsceneSetup, updated StandardSpeakTriggerConditions() for any PC party member
// BMA-OEI 3/7/06 - modified CombatCutsceneCleanUp to use IPoint Cleaner
// BMA-OEI 3/21/06 - TODO: GetIsCompanionPossessionBlocked() check
// DBR 6/16/06 - Put in check for PC faction members in same area already in a MP cutscene. Also with BMA put in cases for all kinds of un-possessed companions setting off the trigger.
// ChazM 5/18/07 - added StandarInterjectionTriggerConditions(), DoInterjectionTrigger()
// ChazM 5/21/07 - interjection changes, added GetIsHighestPriorityNPCinParty()
// ChazM 5/25/07 - changed "interjection" to "bark".  Now uses seperate conversation files.
// ChazM 5/25/07 - Added MultiUse to priority consideration for barking.
// MDiekmann 6/25/07 - Modified DoSpeakTrigger() to now allow for not warping a player if a companion or henchman walks over a trigger
// ChazM 8/23/07 - Modified DoBarkTrigger()/StandardBarkTriggerConditions() - added MultiUseDelay support
#include "ginc_transition"
#include "ginc_cutscene"
//#include "ginc_misc"
#include "ginc_vars"
#include "ginc_autosave"

#include "x2_inc_switches"
// ================================================================
// CONSTANTS
// ================================================================

const string VAR_LAST_BARK_TRIGGER 	= "__LAST_BARK_TRIGGER";


// ================================================================
// ***** PROTOTYPES *****
// ================================================================
	
// Return Target by tag or special identifier.  Leave sTarget blank to use entering object. 
object GetTriggerTarget(string sTarget, object oTriggeringObject);

// Check standard speak trigger conditions for entering object
int StandardSpeakTriggerConditions(object oEnter);
	
void DoSpeakTrigger(object oEnter);

// Barks
void DoBarkTrigger(object oEnter);
int GetIsHighestPriorityNPCinParty(object oEnter, int bPriorityListedOnly, int bMultiUse);
int StandardBarkTriggerConditions(object oEnter);



// ================================================================
// ***** DEFINITIONS *****
// ================================================================

// Return Speaker Target by tag or special identifier.  Leave sTarget blank to use triggering object. 
object GetTriggerTarget(string sTarget, object oTriggeringObject)
{
	object oTarget = OBJECT_INVALID;
	
	if (sTarget == "")
	{
		oTarget = oTriggeringObject;
	}
	else
	{
	    oTarget = GetNearestObjectByTag(sTarget, oTriggeringObject);
	
		if (GetIsObjectValid(oTarget) == FALSE)
		{
		    oTarget = GetNearestObjectByTag(sTarget);
		}
	}

	if (GetIsObjectValid(oTarget) == FALSE)
	{
		PrettyDebug("GetTriggerTarget: ERROR - NPC target: " + sTarget + " was not found!");
	}
	
	return (oTarget);
}

// Standard SpeakTrigger should fire only if oEnter is in the PC party
int StandardSpeakTriggerConditions(object oEnter)
{	

	// Check if oEnter is in the PC's faction
	if ( GetIsPC( oEnter ) == FALSE )
	{
		PrettyDebug( "SpeakTrigger: " + GetName(oEnter) + " is not a PC." );
		object oPC = GetFirstPC();

		if ( GetFactionEqual( oEnter, oPC ) == FALSE )
		{
			PrettyDebug( "SpeakTrigger: " + GetName(oEnter) + " is not in " + GetName(oPC) + "'s party." );
			return ( FALSE );		
		}
	}

	// Check if SpeakTrigger can fire more than once
	int bMultiUse = GetLocalInt(OBJECT_SELF, "MultiUse");

    if ((bMultiUse == FALSE) && IsMarkedAsDone())
	{
		PrettyDebug( "SpeakTrigger: cannot fire more than once" );
		return (FALSE);
	} 

// EPF 7/29/05 -- after modifying DetermineCombatRound(), it should be okay to fire a speak trigger, even when in combat.
//    if (GetIsInCombat(oPC)) 
//		return FALSE;
	
/*  This is prone to error by typing scripts as var values and removed for now:
//	ConditionScript	- Condition script to run on entering PC to see if speak trigger should fire.
//						use	SetExecutedScriptReturnValue() with TRUE or FALSE to check conditions
//						use stc_template as a template for the speak trigger conditions

	string sConditionScript = GetLocalString(OBJECT_SELF, "ConditionScript");
	if (sConditionScript != "")
		if (!ExecuteScriptAndReturnInt(sConditionScript, oPC))
			return FALSE;
*/
	//DBR 6/16/06 - Check to make sure no one in this area is in a MP conversation
	object oPCF = GetFirstFactionMember(oEnter,FALSE);
	while (GetIsObjectValid(oPCF))
	{
		if ((IsInMultiplayerConversation(oPCF))&&(GetArea(oEnter)==GetArea(oPCF))) //MP conversation going on in this area
		{
			DelayCommand( 0.1f, PrettyError( "SpeakTrigger: " + GetName(oPCF) + " is already in a MP cutscene." ) );
			return FALSE;
		}
		oPCF = GetNextFactionMember(oEnter,FALSE);	
	}

	PrettyDebug( "SpeakTrigger: " + GetName(oEnter) + " passed the StandardSpeakTriggerConditions!" );	
	return (TRUE);
}



void DoSpeakTrigger(object oEnter)
{
	string sNPCTag 			= GetLocalString(OBJECT_SELF, "NPC_Tag");
	string sConversation 	= GetLocalString(OBJECT_SELF, "Conversation");
	int iNodeIndex 			= GetLocalInt(OBJECT_SELF, "Node");
	int nRun 				= GetLocalInt(OBJECT_SELF, "Run");
	// Don't use 0 as user input for this since that is default if not there.
	int nTalkNow 			= GetLocalInt(OBJECT_SELF, "TalkNow");
	int bCutsceneBars 		= GetLocalInt(OBJECT_SELF, "CutsceneBars");
	int bOnceOnly 			= GetLocalInt(OBJECT_SELF, "OnceOnly");
	int bCombatCutsceneSetup = GetLocalInt(OBJECT_SELF, "CombatCutsceneSetup");
	int bDoNotChangePlayer	= GetLocalInt(OBJECT_SELF, "DoNotChangePlayer");

	// Default values of ActionStartConversation()
	int bPrivateConversation	= FALSE;
	int bPlayHello				= TRUE;
	int bIgnoreStartDistance	= FALSE;
	int bDisableCutsceneBars	= TRUE;

	bDisableCutsceneBars = !bCutsceneBars;

	// Find conversation Speaker
	// BMA-OEI 3/21/06 should we verify this in StandardSpeakTriggerConditions?
	object oTarg = GetTriggerTarget(sNPCTag, oEnter);

	if (GetIsObjectValid(oTarg) == FALSE)
	{
		PrettyDebug("DoSpeakTrigger: ERROR - Target speaker is invalid!");
		return;
	}

	if (GetIsPC(oTarg) == TRUE)
	{
		PrettyDebug("DoSpeakTrigger: WARNING - SPEAKER: " + GetName(oTarg) + " is controlled by a PC!");
	}

//	DetermineCombatRound() modified so hopefully it should be okay to converse even while in combat.
//	EPF 9/24/05
//    if (GetIsInCombat(oTarg)) 
//	{
//		return;
//	}

	// Store info on target object
    SetLocalInt(oTarg, "sn_NodeIndex", iNodeIndex );
    SetLocalInt(oTarg, "sn_OnceOnly", bOnceOnly );

	// If CombatCutsceneSetup is required
	if (bCombatCutsceneSetup == 1)
	{
		CombatCutsceneSetup(oEnter);
	}

	// Revive and remove negative effects on PC party and oTarg
	//NLC 7/11 - IF we are not running NX2...
	if(GetGlobalInt(VAR_GLOBAL_NX2_TRANSITIONS) == FALSE)
		MakeConversable(oEnter, TRUE);
	
	MakeConversable(oTarg, FALSE);

	ClearPartyActions(oEnter, TRUE);

	//DBR 6/16/06
	if(!bDoNotChangePlayer)
	{
		if (GetIsOwnedByPlayer(oEnter) && (!GetIsPC(oEnter)))	//oEnter is A "created" character not being possessed by anyone.
		{
			oEnter = SetOwnersControlledCompanion(GetControlledCharacter(oEnter),oEnter);	//Warp the PC into his created character and return	
		}
		else if (GetIsCompanionPossessionBlocked(oEnter)&&(!GetIsPC(oEnter))&&(!GetIsOwnedByPlayer(oEnter)))	// oEnter is a companion who is not being controlled, and is blocked from possession
		{
			if (GetCanTalkToNonPlayerOwnedCreatures(oTarg))	//Target can talk to anyone, so whoever the faction leader is A-O-K to talk to this guy
			{
				object oLeader = GetFactionLeader(oEnter);
				AssignCommand(oLeader, ClearAllActions(TRUE));
				AssignCommand(oLeader, JumpToObject(oEnter));
				oEnter = oLeader;
			}
			else	//Picky NPC, force possession of an owned character and use them (since it is companion only in this case, any PC will do
			{
				object oLeader = GetFactionLeader(oEnter);
				object oOwned = SetOwnersControlledCompanion(oLeader,GetOwnedCharacter(oLeader));	//Warp the PC into his created character and return	
				AssignCommand(oOwned, ClearAllActions(TRUE));
				AssignCommand(oOwned, JumpToObject(oEnter));
				oEnter = oOwned;			
			}
		}
		else if (!GetIsCompanionPossessionBlocked(oEnter)&&(!GetIsPC(oEnter))&&(!GetIsOwnedByPlayer(oEnter)))	// oEnter is a companion who is not being controlled, but can be
		{
			oEnter = SetOwnersControlledCompanion(GetFactionLeader(oEnter),oEnter);	//Force possession of Faction Leader into Companion
		}		
		//All other cases involve oEnter being a PC or companion who is CURRENTLY being possessed by a player. They are fine to pass in, and engine will handle a swap if need be.
		// If oEnter is still not controlled by a player
		if (GetIsPC(oEnter) == FALSE)
		{
			object oLeader = GetFactionLeader(oEnter);
		
			AssignCommand(oLeader, ClearAllActions(TRUE));
			AssignCommand(oLeader, JumpToObject(oEnter));
			oEnter = oLeader;
		}
	}

	AssignCommand(oTarg, ClearAllActions(TRUE));	

	// If oTarg shouldn't move, start conversation immediately
	if (nRun == -1)
	{
		nTalkNow = 1;
	}

	bIgnoreStartDistance = TRUE;

	if (nTalkNow == 1)
	{
		AssignCommand(oTarg, ActionStartConversation(oEnter, sConversation, bPrivateConversation, bPlayHello, bIgnoreStartDistance, bDisableCutsceneBars));
	}
	else
	{
		PrettyDebug("DoSpeakTrigger: WARNING - TalkNow = 0, PC may not be ready for conversation!");

		// If oTarg is too far from the PC
		if (GetDistanceBetween(oEnter, oTarg) >= 3.0f) 
		{
			bIgnoreStartDistance = FALSE;

			switch (nRun)
			{
				case -1:	// Don't move
					break;
				case 0:		// Walk
					AssignCommand(oTarg, ActionForceMoveToObject(oEnter, FALSE, 2.0f));
					break;
				case 1:		// Run
					AssignCommand(oTarg, ActionForceMoveToObject(oEnter, TRUE, 2.0f));
					break;
				case 2:		// Jump
		    		AssignCommand(oTarg, JumpToObject(oEnter));
					break;
			}
		}

		AssignCommand(oTarg, ActionStartConversation(oEnter, sConversation, bPrivateConversation, bPlayHello, bIgnoreStartDistance, bDisableCutsceneBars));
	}	

	// If CombatCutsceneSetup is required
	//if (bCombatCutsceneSetup == 1)
	//{
	//	object oIPCleaner = CreateObject(OBJECT_TYPE_PLACEABLE, IPC_RESREF, GetLocation(oEnter));
	//	AssignCommand(oIPCleaner, QueueCombatCutsceneCleanUp());
	//}

	MarkAsDone();	
}


// -------------------------------------
// Barks
// -------------------------------------

void DoBarkTrigger(object oEnter)
{
	//string sNPCTag 			= GetLocalString(OBJECT_SELF, "NPC_Tag");
	int nNodeIndex 			= GetLocalInt(OBJECT_SELF, "Node");
	string sConversationPrefix 	= GetLocalString(OBJECT_SELF, "ConversationPrefix"); 
	if (sConversationPrefix == "")
		sConversationPrefix = "00_bark_";
		
	string sConversation 	= sConversationPrefix + GetTag(oEnter);
	//string sTalkTarget		= GetLocalString(OBJECT_SELF, "TalkTarget");
	//string sConversation 	= "00_bark_" + GetTag(oEnter); 

	// Default values of ActionStartConversation()
	int bPrivateConversation	= FALSE;
	int bPlayHello				= FALSE;
	int bIgnoreStartDistance	= FALSE;
	int bDisableCutsceneBars	= TRUE;
		
   	SetLocalInt(oEnter, "sn_NodeIndex", nNodeIndex );
    //SetLocalInt(oEnter, "sn_OnceOnly", FALSE ); // don't reset sn_NodeIndex to 0 (we set it every time anyways...)
	object oLeader = GetFactionLeader(oEnter);

	PrettyDebug(GetName(oEnter) + " Starting conversation with " + GetName(oLeader));
	
	SetLocalObject(oEnter, VAR_LAST_BARK_TRIGGER, OBJECT_SELF); // for use by ga_bark_trigger_reset
	//AssignCommand(oEnter, ActionStartConversation(oLeader, sConversation, bPrivateConversation, bPlayHello, bIgnoreStartDistance, bDisableCutsceneBars));
	AssignCommand(oEnter, SpeakOneLinerConversation(sConversation));
	
	int nCurrentTime = GetCurrentTimeHash();
	SetLocalInt(OBJECT_SELF, "Time", nCurrentTime);

	MarkAsDone();	
}

// looks for someone else in the party that who's priority is listed higher for the trigger.
// Returns TRUE if there is no one else with higher priority.
// if bPriorityListedOnly is TRUE, then NPC must be on list to return TRUE
int GetIsHighestPriorityNPCinParty(object oEnter, int bPriorityListedOnly, int bMultiUse)
{
	// if Multi-Use and don't have to be on the list, then it will always be true.
	if (bMultiUse && !bPriorityListedOnly)
		return TRUE;
		
	string sThisNPCTag = GetTag(oEnter);
	object oTarget;
	int i = 1;
	string sTag = GetLocalString(OBJECT_SELF, "Priority" + IntToString(i));
	
	while (sTag != "")
	{
		// I am listed and am highest priority
		if (sTag == sThisNPCTag)
			return TRUE;

		// if it's multi use, then priority doesn't matter (everyone gets to bark).
		// if it's single use, then make sure the best guy for the job does it.
		if (bMultiUse == FALSE)						
		{
			oTarget = GetNearestObjectByTag(sTag);
			if (GetIsObjectValid(oTarget))
			{
				if (GetIsPC(GetFactionLeader(oTarget)))
					return FALSE; // found someone else who is higher priority in the party.
			}
		}			
		i++;				
		sTag = GetLocalString(OBJECT_SELF, "Priority" + IntToString(i));
	}
	
	// not found in priority, so return true only if not required to be on priority list
	return !bPriorityListedOnly;
}


int StandardBarkTriggerConditions(object oEnter)
{
	
	// must be a non-controlled/non-owned party member entering the trigger.
	//if (GetIsPC(oEnter))
	//	return (FALSE);
	if (GetIsOwnedByPlayer(oEnter))
		return (FALSE);

		
	// Check if SpeakTrigger can fire more than once
	int bMultiUse = GetLocalInt(OBJECT_SELF, "MultiUse");
    if ((bMultiUse == FALSE) && IsMarkedAsDone())
	{
		PrettyDebug( "BarkTrigger: cannot fire more than once" );
		return(FALSE);
	} 
	
	// if we are using a MultiUseDelay, check that sufficient time has passed.		
	int nMultiUseDelay = GetLocalInt(OBJECT_SELF, "MultiUseDelay");
	if (nMultiUseDelay > 0)
	{
		int nCurrentTime = GetCurrentTimeHash();
		int nLastTime = GetLocalInt(OBJECT_SELF, "Time");
		//PrettyMessage( "nCurrentTime = " + IntToString( nCurrentTime ) + ", nLastTime = " + IntToString( nLastTime ) );
		if ( GetTimeHashDifference( nCurrentTime, nLastTime ) < nMultiUseDelay )
		{
			PrettyDebug( "BarkTrigger: insufficient time has passed since last firing" );
			return (FALSE);
		}		
	}	

	object oLeader = GetFactionLeader(oEnter);
	// must be in a PC party		
	if (!GetIsPC(oLeader))
		return (FALSE);					
/*
	// are we in range?  (we do this check last to reduce number of distance checks)
	float fRange = 20.0f;
	if (nRange > 0)
		fRange = IntToFloat(nRange);
		
	if (GetDistanceToObject(oLeader) > fRange)
		return FALSE;
*/		
	int bPriorityListedOnly = GetLocalInt(OBJECT_SELF, "PriorityListedOnly");
	if (!GetIsHighestPriorityNPCinParty(oEnter, bPriorityListedOnly, bMultiUse))
		return (FALSE);

	return (TRUE);
}