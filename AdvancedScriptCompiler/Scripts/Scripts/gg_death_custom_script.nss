// gg_death_custom_script
/*
	Executes a custom script on the module when a group dies.
*/
// ChazM 4/19/06
// BMA-OEI 5/23/06 -- Updated w/ new group functions, moved ExecuteScript() to module

#include "ginc_group"

void main()
{
	string sGroupName = GetGroupName( OBJECT_SELF );

	// Update number of sGroupName members killed
	IncGroupNumKilled( sGroupName );

	// If all group members are dead or invalid
	if ( GetIsGroupValid( sGroupName, TRUE ) == FALSE )
	{
		object oModule = GetModule();
		string sCustomScript = GetGroupString( sGroupName, "CustomScript" );
		AssignCommand( oModule, ExecuteScript( sCustomScript, oModule ) );
	}
}