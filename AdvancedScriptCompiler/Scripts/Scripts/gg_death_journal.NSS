// gg_death_journal
/*
	GroupOnDeath handler to advance journal state of first PC.
	Checks group local variables sQuestTag, nEntry, and bOverride
*/
// EPF 12/3/05
// BMA-OEI 5/23/06 -- Updated w/ new group functions
	
#include "ginc_group"
	
void main()
{
	string sGroupName = GetGroupName( OBJECT_SELF );

	// Update number of sGroupName members killed
	IncGroupNumKilled( sGroupName );

	// If all group members are dead or invalid
	if ( GetIsGroupValid( sGroupName, TRUE ) == FALSE )
	{
		string sQuest = GetGroupString( sGroupName, "sQuestTag" );
		int nEntry = GetGroupInt( sGroupName, "nEntry" );
		int bOverride = GetGroupInt( sGroupName, "bOverride" );
		AddJournalQuestEntry( sQuest, nEntry, GetFirstPC(), TRUE, FALSE, bOverride );
	}
}