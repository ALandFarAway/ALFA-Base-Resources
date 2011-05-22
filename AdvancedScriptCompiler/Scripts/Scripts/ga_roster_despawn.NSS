//ga_roster_despawn
/*
//RWT-OEI 09/15/05
//Despawn Roster Member
//This function removes the Roster Member from the game after saving them
//out so that any changes will be preserved.  This is the matching function
//to SpawnRosterMember() and in general should be the only script function
//used to remove Party Member NPCs from the game world. 
int DespawnRosterMember( string sRosterName );
*/
// ChazM 12/2/05

#include "ginc_param_const"
	
void main(string sRosterName)
{
	int bResult = DespawnRosterMember(sRosterName);
}
	