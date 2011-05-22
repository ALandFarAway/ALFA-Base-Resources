// ga_roster_party_remove_all( int bDespawnNPC, int bIgnoreSelectable )
/*
	Remove all selectable roster members from oPC's party
	
	Parameters:
		int bDespawnNPC 		= If 1, despawn after removing from party
		int bIgnoreSelectable 	= If 1, also remove non-Selectable roster members 
*/
// BMA-OEI 9/06/06

#include "ginc_companion"

void main( int bDespawnNPC, int bIgnoreSelectable )
{
	object oPC = GetPCSpeaker();
	
	if ( GetIsObjectValid( oPC ) == FALSE )
	{
		oPC = OBJECT_SELF;
	}
	
	RemoveRosterMembersFromParty( oPC, bDespawnNPC, bIgnoreSelectable );
}