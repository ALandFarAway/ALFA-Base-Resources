// ga_reset_level( string sCreature, int bUseXPMods )
/*
	Resets creature to PCs average experience level using its current level-up package.
	Creature is also force rested ( full heal, spells refreshed ).

	Parameters:
		string sCreature 	= Tag of creature
		int bUseXPMods 		= If TRUE, XP modifiers will be applied before the experience is awarded
*/
// BMA-OEI 5/08/06
// BMA-OEI 8/09/06 -- Added GetPCAverageXP(), ForceRest()

#include "ginc_debug"
#include "ginc_misc"

void main( string sCreature, int bUseXPMods )
{
	object oCreature = GetObjectByTag( sCreature );
	if ( GetIsObjectValid( oCreature ) == FALSE )
	{
		PrettyError( "ga_reset_level: object '" + sCreature + "' is invalid!" );
	}
	
	int nXP = GetPCAverageXP();
	ResetCreatureLevelForXP( oCreature, nXP, bUseXPMods );
	ForceRest( oCreature );
}