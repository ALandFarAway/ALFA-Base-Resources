// gtr_speak_node
/*
	Speak Trigger OnEnter handler to initiate a conversation.
	For custom conditions, modify <CUSTOM CONDITION>, save as a new script and attach to trigger's OnEnter.
	Suggested name: XX_trsn_xxx
	
	Starts a conversation based on variables set on trigger.
	The following variables will be examined on the trigger.  First 2 paramaters are required. Order is not important
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

	
*/
// ChazM 6/25/05 - split functions into include
// BMA-OEI 3/6/06 - formated script
// ChazM 5/22/07 - Added comments

#include "ginc_trigger"

void main ()
{
    object oPC = GetEnteringObject();

	if (StandardSpeakTriggerConditions(oPC) == FALSE)
	{
		return;
	}
	
	//if (<CUSTOM CONDITION> == FALSE)
	//{
	//	return;
	//}

	DoSpeakTrigger(oPC);
}