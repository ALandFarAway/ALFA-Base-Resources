//ga_roster_add_object
/*
//RWT-OEI 09/12/05
//Adds a NPC to the global roster of NPCs available to be added to
//a player's party. Roster Name is a 10-character name used to 
//reference that NPC in other Roster related functions. 
//The NPC will be left in the game world, but will now exist
//in the roster as well.
//Returns false on any error
int AddRosterMemberByCharacter( string sRosterName, object oCharacter );
*/
// ChazM 12/2/05

#include "ginc_param_const"
	
void main(string sRosterName, string sTarget)
{
	object oCharacter = GetTarget(sTarget, TARGET_OWNER);
	int bResult = AddRosterMemberByCharacter(sRosterName, oCharacter);

}
		