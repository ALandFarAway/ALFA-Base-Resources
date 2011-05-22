// gp_talk_object.nss
/*
	This script allows you to speak to an object.
	Set a conversation, set Usable to True, and attach this script to the OnUsed event.
*/
// FAB 2/7
// ChazM 2/17/05
// BMA-OEI 9/17/05 file description

void main()
{
	object oUser = GetLastUsedBy();
    ActionStartConversation(oUser);
}