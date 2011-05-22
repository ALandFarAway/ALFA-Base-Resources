// ga_reset_level_by_xp( string sCreature, int nXP, int bUseXPMods )
/*
	Resets creature to level 0, awards nXP experience and auto-levels 
	to the highest level allowed based on its current level-up package.

	Parameters:
		string sCreature 	= Tag of creature
		int nXP 			= Experience to award, -1 = Use current experience points.
		int bUseXPMods 		= If TRUE, XP modifiers will be applied before the experience is awarded
*/
// BMA-OEI 5/08/06
// ChazM 5/9/07 - added current XP support

#include "ginc_debug"

void main( string sCreature, int nXP, int bUseXPMods )
{
	object oCreature = GetObjectByTag( sCreature );
	if ( GetIsObjectValid( oCreature ) == FALSE )
	{
		PrettyError( "ga_reset_level_by_xp: object '" + sCreature + "' is invalid!" );
	}
	
	if (nXP == -1)
		nXP = GetXP(oCreature);
	
	ResetCreatureLevelForXP( oCreature, nXP, bUseXPMods );
}