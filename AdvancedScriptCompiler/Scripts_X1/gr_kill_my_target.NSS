// gr_kill_my_target()
/*
 	Inflict massive damage to the currently active attack taget
*/ 
// ChazM 7/13/07

#include "ginc_debug"

const int KILL_MASSIVE_DAMAGE 	= 9999;

object GetMyTarget()
{
	object oTarget = GetAttackTarget();
	if (!GetIsObjectValid(oTarget))
	{
		oTarget = GetAttemptedAttackTarget();
	}
	if (!GetIsObjectValid(oTarget))
	{
		oTarget = GetAttemptedSpellTarget();
	}
	if (!GetIsObjectValid(oTarget))
	{
		PrettyDebug("GetMyTarget() - could not get a target");
	}
		
	return(oTarget);
}	

void main()
{
	object oKiller = OBJECT_SELF;
	location lKiller = GetLocation( OBJECT_SELF );
	effect eKill = EffectDamage( KILL_MASSIVE_DAMAGE );

	object oTarget = GetMyTarget();
	PrettyDebug( "gr_kill_target: searching for target of " + GetName(oKiller) );
	
	if ( GetIsObjectValid( oTarget ) == TRUE )
	{
		if ( ( GetIsDead( oTarget ) == FALSE ) && ( GetIsEnemy( oTarget ) == TRUE ) )
		{
			DelayCommand( 0.1f, ApplyEffectToObject( DURATION_TYPE_INSTANT, eKill, oTarget ) );
			PrettyMessage( "gr_kill_target: ** applying " + IntToString(KILL_MASSIVE_DAMAGE) + " damage to " + GetName(oTarget) );
		}
	}
}