//	gb_hostile_enc_bl
/*
    If the PC blocks a hostile creature on the overland map, it will
	initiate conversation.
*/
// JH/EF-OEI: 01/16/08

#include "ginc_debug"

void main()
{
	PrettyDebug("Blocked event firing.");
    object oBlocker = GetBlockingDoor();
	string sConv	= GetLocalString(OBJECT_SELF, "sConv");
	
	/*	If the creature blocking me is the PC, initiate conversation.	*/
    if (GetObjectType(oBlocker) == OBJECT_TYPE_CREATURE && GetIsPC(oBlocker))
    {
		PrettyDebug("Starting Conversation.");
		ClearAllActions(TRUE);
		ActionStartConversation(oBlocker, sConv, FALSE, FALSE, TRUE, FALSE);
        return;
    }
}