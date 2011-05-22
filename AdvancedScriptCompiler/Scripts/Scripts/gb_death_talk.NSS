//gb_death_talk
/*
    when creature dead, a conversation starts
*/

#include "nw_i0_plot"               

void main()
{
	string sTalkerTag = GetLocalString(OBJECT_SELF, "TalkerTag");
	string sConversation = GetLocalString(OBJECT_SELF, "Conversation");
	object oNPC = GetObjectByTag(sTalkerTag);
	object oPC = GetNearestPC();

	if (sTalkerTag == "")
	{
		oNPC = oPC;
	}

	AssignCommand(oNPC, ClearAllActions(TRUE));

	//PrintString(GetName (oNPC) + "starting convo " + sConversation + " with " + GetName(oPC));
	AssignCommand(oNPC, ActionStartConversation(oPC, sConversation));
}

 

 
