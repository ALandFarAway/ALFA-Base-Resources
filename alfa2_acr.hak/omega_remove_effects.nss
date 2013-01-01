// This script, meant to be used from the Omega Wand, will strip the target of ALL spell effects.

void main() {
	object oTarget = GetItemActivatedTarget();
	object oUser = GetItemActivator();
	
	// Non-DM using?
	if ( !GetIsDM( oUser ) ) {
		SendMessageToAllDMs( GetName( oUser ) + " attempted to use PrC Validation widget in area " + GetName( GetArea( oUser ) ) + "!" );
		return;
	}
	
	// Clear all effects from target.
	effect e;
	for ( e = GetFirstEffect( oTarget ); GetIsEffectValid( e ); e = GetNextEffect( oTarget ) ) {
		RemoveEffect( oTarget, e );
	}
	
	// Send out feedback messages.
	SendMessageToPC( oUser, "All effects purged from " + GetName( oTarget ) + "." );
	SendMessageToPC( oTarget, "All effects purged by " + GetName( oUser ) + "." );
}