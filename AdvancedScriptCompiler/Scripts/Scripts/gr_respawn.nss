#include "ginc_death"
#include "ginc_debug"

void main()
{
	object oPC = OBJECT_SELF;
	PrettyDebug( "gr_respawn: DEBUG - resurrecting " + GetName(oPC) + "'s faction" );
	ResurrectFaction( oPC );
}