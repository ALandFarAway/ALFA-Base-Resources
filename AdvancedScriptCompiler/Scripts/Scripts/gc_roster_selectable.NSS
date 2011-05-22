//gc_roster_selectable
/*

//RWT-OEI 09/14/05
//Returns TRUE if the member is selectable. This is different than 
//available because it is possible for the NPC to -not- be in another
//party but still set to be not selectable (Due to plot reasons, etc.)
int GetIsRosterMemberSelectable( string sRosterName );
*/
// ChazM 12/2/05
	
int StartingConditional( string sRosterName)
{
	int bResult = GetIsRosterMemberSelectable(sRosterName);
	return (bResult);
}