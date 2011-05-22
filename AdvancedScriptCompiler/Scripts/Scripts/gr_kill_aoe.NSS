// gr_kill_aoe( float fRadius )
// Inflict massive damage to hostiles within fRadius meters
// BMA-OEI 8/30/06

#include "ginc_debug"

const float KILL_AOE_MIN_RADIUS 	= 9.0f;
const int KILL_AOE_MASSIVE_DAMAGE 	= 9999;

void main( float fRadius )
{
	if ( fRadius < 0.1f )
	{
		fRadius = KILL_AOE_MIN_RADIUS;
	}

	object oKiller = OBJECT_SELF;
	location lKiller = GetLocation( OBJECT_SELF );
	effect eKill = EffectDamage( KILL_AOE_MASSIVE_DAMAGE );

	object oTarget = GetFirstObjectInShape( SHAPE_SPHERE, fRadius, lKiller, TRUE, OBJECT_TYPE_CREATURE );
	PrettyDebug( "gr_kill_aoe: searching for creatures hostile to " + GetName(oKiller) + " within " + FloatToString(fRadius) + " meters" );
	
	while ( GetIsObjectValid( oTarget ) == TRUE )
	{
		if ( ( GetIsDead( oTarget ) == FALSE ) && ( GetIsEnemy( oTarget ) == TRUE ) )
		{
			DelayCommand( 0.1f, ApplyEffectToObject( DURATION_TYPE_INSTANT, eKill, oTarget ) );
			PrettyMessage( "gr_kill_aoe: ** applying " + IntToString(KILL_AOE_MASSIVE_DAMAGE) + " damage to " + GetName(oTarget) );
		}
		
		oTarget = GetNextObjectInShape( SHAPE_SPHERE, fRadius, lKiller, TRUE, OBJECT_TYPE_CREATURE );
	}
}