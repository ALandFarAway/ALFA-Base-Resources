//ga_roster_add_blueprint
/*
//RWT-OEI 09/12/05
//Adds a NPC to the global roster of NPCs available to be added to 
//a player's party. Roster Name is a 10-character name used to reference
//that NPC in other Roster related functions.
//The template is the blueprint to use to create the NPC for the first
//time. The NPC will not appear in the game world, but will be in the
//Roster. Returns false on any error
int AddRosterMemberByTemplate( string sRosterName, string sTemplate );
*/
// ChazM 12/2/05
	
void main( string sRosterName, string sTemplate )
{
	int bResult = AddRosterMemberByTemplate(sRosterName, sTemplate);
}
		