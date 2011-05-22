// gb_comp_death
/*
   OnDeath handler to queue KnockOut script for companions
*/
// ChazM 8/17/05
// BMA-OEI 12/19/05 knock out death system
// BMA-OEI 1/26/06 exit if owned and controlled
// BMA-OEI 2/27/06 DeathScript support, exit if not in PC faction
// BMA-OEI 2/28/06  
// NLC 7/14/08 - Increased NX2's hardcore quotient.

#include "ginc_companion"
#include "ginc_death"
#include "ginc_debug"
#include "x2_inc_switches"

const string VAR_GLOBAL_NX2_TRANSITIONS = "bNX2_TRANSITIONS";

void main()
{
	object oDead = OBJECT_SELF;
	PrintString( "gb_comp_death: " + GetName(oDead) + " executing OnDeath event" );

	// Abort if dying character is owned PC (owned PCs should fire module OnDeath)
	if ( GetIsOwnedByPlayer( oDead ) == TRUE )
	{
		PrintString( "** gb_comp_death: " + GetName(oDead) + " is owned by a player. ABORT!" );
		return;	
	}
	
	// Check for additional death script
	string sDeathScript = GetLocalString( oDead, "DeathScript" );
	if ( sDeathScript != "" )	ExecuteScript( sDeathScript, oDead );

	// Abort if dying character is not in PC faction
	if ( GetIsObjectInParty( oDead ) == FALSE )
	{
		PrintString( "** gb_comp_death: " + GetName(oDead) + " not in " + GetName(GetFirstPC()) + "'s party. ABORT!" );
		return;
	}
	if( !GetGlobalInt( VAR_GLOBAL_NX2_TRANSITIONS ) )
	{
		//NX2 is HARDCORE! No auto-ressing!
		AssignCommand( oDead, KnockOutCreature( oDead ) );
	}
	else
	{
		if ( GetIsDeathPopUpDisplayed(oDead) == FALSE )
		{
			if ( GetIsPartyPossessible(oDead) == FALSE )
			{
				PrettyDebug( "** ginc_death: " + GetName(oDead) + "'s party wiped. displaying death screen", 30.0 );	
				ShowProperDeathScreen( oDead );
			}
		}
	}
}