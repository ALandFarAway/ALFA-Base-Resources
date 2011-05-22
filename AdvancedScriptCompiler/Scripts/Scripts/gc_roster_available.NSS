//gc_roster_available
/*
//RWT-OEI 09/14/05
//Returns TRUE if the member is available to be added to a party at this
//time. If the member is currently claimed by another party, it will 
//not be available. If the member is set unselectable, it will
//not be available.
int GetIsRosterMemberAvailable( string sRosterName );
*/
// ChazM 12/2/05
	
int StartingConditional( string sRosterName)
{
	int bResult = GetIsRosterMemberAvailable(sRosterName);
	return (bResult);
}