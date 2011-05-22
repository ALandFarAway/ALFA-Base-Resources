// ga_start_convo
/*
   This script starts a new conversation.  Handy when you want to jump directly from one conversation to another.
	
   
   Parameters:
     	string sTarget   		= Target who will start convo with the PC.  See "ginc_param_const" for options
		string sConversation 	 = The resource reference (filename) of a conversation.  "" = Use default (owners) conversation
		int bPrivateConversation = Specify whether the conversation is audible to everyone or only to the PC.
		int bPlayHello		 = Determines if initial greeting is played. 
		int bIgnoreStartDistance = 1 (TRUE) = start at any distance.
		int bDisableCutsceneBars = 1 (TRUE) = Diable cutscene bars (applies to NWN2 style conversations)
*/

// ChazM 9/14/05
// ChazM 9/20/06 - fixed inc.

#include "ginc_param_const"

void main(string sTarget, string sConversation, int bPrivateConversation, int bPlayHello, int bIgnoreStartDistance, int bDisableCutsceneBars)
{
	object oPC = (GetPCSpeaker()==OBJECT_INVALID?OBJECT_SELF:GetPCSpeaker());
	object oTarget = GetTarget(sTarget);

	AssignCommand(oTarget, ActionStartConversation(oPC, sConversation, bPrivateConversation, bPlayHello, bIgnoreStartDistance, bDisableCutsceneBars));
}
