// ga_roster_selectable
/*

//RWT-OEI 09/14/05
//Sets the roster member as being selectable or not. Roster members
//that are not selectable cannot be changed via the Party Selection
//GUI on the client side, but can still be added/removed from a
//party via script. Note that if a roster member is set as non-selectable
//while they are currently in a party, they will remain in the party
//and cannot be removed via the Party Selection GUI.
//Returns FALSE if it was unable to locate the roster member
int SetIsRosterMemberSelectable( string sRosterName, int bSelectable );
*/
// ChazM 12/2/05
	
void main( string sRosterName, int bSelectable)
{
	int bResult =  SetIsRosterMemberSelectable(sRosterName, bSelectable);
}