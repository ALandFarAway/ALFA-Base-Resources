// ga_roster_despawn_all( int bExcludeParty )
/*
	Despawn all roster members, option to exclude members in PC party
*/
// BMA-OEI 7/28/06

#include "ginc_companion"

void main( int bExcludeParty )
{
	DespawnAllRosterMembers( bExcludeParty );
}