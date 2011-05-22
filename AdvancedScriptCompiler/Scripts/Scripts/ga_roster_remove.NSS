//ga_roster_remove
/*

//RWT-OEI 09/14/05
//Removes a NPC from the global roster of NPCs available to be added to
//a player's party.  Roster Name is the 'identifying name' that was given
//to this NPC when it was added to the Roster. Returns TRUE if the NPC
//was found and removed. False if the NPC was not found in the roster
int RemoveRosterMember( string sRosterName );
*/
// ChazM 12/2/05
	
void main( string sRosterName)
{
	int bResult = RemoveRosterMember(sRosterName);
}