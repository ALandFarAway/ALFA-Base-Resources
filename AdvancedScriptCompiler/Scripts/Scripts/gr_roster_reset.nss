// gr_roster_reset
// Resets all roster members in-game to average PC level

#include "ginc_debug"
#include "ginc_misc"

void main()
{
	int nXP = GetPCAverageXP();
	
	string sRM = GetFirstRosterMember();
	object oRM;
	while ( sRM != "" )
	{
		oRM = GetObjectFromRosterName( sRM );
		if ( GetIsObjectValid( oRM ) == TRUE )
		{
			PrettyMessage( "gr_roster_reset: " + GetName( oRM ) + " reset with " + IntToString( nXP ) + " xp." );
			ResetCreatureLevelForXP( oRM, nXP, TRUE );
			ForceRest( oRM );
		}
		sRM = GetNextRosterMember();	
	}
}