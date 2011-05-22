// gp_talk_door
//
// Start a conversation with a door.

// EPF 10/28/05
	
void main()
{
	object oUser = GetClickingObject();
    ActionStartConversation(oUser);
}