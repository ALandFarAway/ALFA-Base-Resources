// gr_outofmyway.nss
/*
	Force nearby creatures to move away from the PC.
*/
// BMA-OEI 5/02/06

#include "ginc_debug"

const int 	MAX_CREATURES 	= 10;
const float MAX_DISTANCE	= 5.0f;

void main()
{
	location lTarget = GetLocation( OBJECT_SELF );
	effect eVis = EffectVisualEffect( 535 );
	ApplyEffectToObject( DURATION_TYPE_TEMPORARY, eVis, OBJECT_SELF, 3.0f );
	int nCount = 1;
	
	object oCreature = GetNearestCreature( CREATURE_TYPE_IS_ALIVE, CREATURE_ALIVE_TRUE, OBJECT_SELF, nCount );
	while ( ( GetIsObjectValid( oCreature ) == TRUE ) && ( nCount < MAX_CREATURES ) )
	{
		if ( GetDistanceBetween( oCreature, OBJECT_SELF ) < MAX_DISTANCE )
		{
			PrettyMessage( "gr_outofmyway: attempting to move " + GetName( oCreature ) + " away from " + GetName( OBJECT_SELF ) );
			AssignCommand( oCreature, ClearAllActions() );
			AssignCommand( oCreature, ActionMoveAwayFromLocation( lTarget, FALSE, MAX_DISTANCE ) );
		}
		
		nCount = nCount + 1;
		oCreature = GetNearestCreature( CREATURE_TYPE_IS_ALIVE, CREATURE_ALIVE_TRUE, OBJECT_SELF, nCount );	
	}
}