// gtr_bark_node
/*
	Bark Trigger OnEnter handler.
	
	Will cause Non-PC-owned party members to attempt an interjection (aka "bark").
	
	Useage:
	Set up dialogs "00_bark_<tag>".  
	Dialog notes:	
		- use gc_node for the condition for each node.
		- only use single nodes w/ no responses. (Speak One Liner won't use nodes w/ responses)
		- don't use speaker tags (Speak One Liner won't use lines w/ Speaker Tags)
		- set "Show Once?" to Once/Game when using MultiUse
		- add a blank node to the end of the dialog with the action script "ga_bark_trigger_reset" - 
		  	not required, but helps prevent trigger from being "used up" when a node is missing in the dialog.
	
	Trigger Variables for the Bark trigger:
	Node			- Node of the conversation to speak.  Node indexes are set using gc_node() in the dialog conditionals.
					  Do not define a node 0, as this is reserved.
	
	MultiUse		- Do all party members crossing trigger attempt to speak?
						0 - (default) Only 1 character will speak.
						1 - All party members will speak.  Priority is ignored. (Setting the Show Once property 
							will be needed to prevent bark repeats every time trigger is entered.)

	MultiUseDelay	- Number of hours that must pass before a mutli-use trigger will fire again.
								
	ConversationPrefix 	- Conversation file  = ConversationPrefix + Tag of creature.   
					Defualt ConversationPrefix is "00_bark_"
	
	PriorityListedOnly - Controls whether an NPC not on the Priority List will bark
					0 - (defualt) will bark if no one on priority list is in the party.
					1 - will not bark if not on priority list.
					
	Priority1, Priority2, etc. - Use these to define the tags of the NPC's and indicate the priority of which NPC should "bark".
					Any number of NPC priorities can be listed.

	More about MultiUse & PriorityListedOnly:
		MultiUse=1 & PriorityListedOnly=0 => everyone in Party will bark.
		MultiUse=1 & PriorityListedOnly=1 => everyone listed (on priority list) will bark.
		MultiUse=0 & PriorityListedOnly=1 => Only highest priority person in party will bark.
		MultiUse=0 & PriorityListedOnly=0 => As above but if no one in party is on the priority list then the first to enter trigger will bark.
					
	See DoBarkTrigger() in ginc_trigger for additional info.
	For custom conditions, modify <CUSTOM CONDITION>, save as a new script and attach to trigger's OnEnter.
	Suggested name: XX_trbn_xxx
	
*/
// ChazM 5/18/07
// ChazM 5/21/07 - added comments
// ChazM 5/25/07 - renamed, comment changes
// ChazM 5/25/07 - changed "interjection" to "bark".
// ChazM 5/25/07 - more comment changes
// ChazM 8/23/07 - yet more comment changes
// TDE 9/24/08 - Added an override to disable a trigger

#include "ginc_trigger"

void main ()
{
    object oEnter = GetEnteringObject();
	
	if (StandardBarkTriggerConditions(oEnter) == FALSE || GetLocalInt(OBJECT_SELF, "bTriggerOverride"))
		return;
			
	DoBarkTrigger(oEnter);		
}