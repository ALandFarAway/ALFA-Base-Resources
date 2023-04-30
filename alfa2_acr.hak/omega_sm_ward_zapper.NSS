#include "003_silverymoon_i"

void main() {
 	// Get the targetted PC.
	object oUser = GetItemActivator();
	object oTarget = GetItemActivatedTarget();
	
	// Strip Silverymoon's wards.
	if ( RemoveSilverymoonWards( oTarget ) ) {
		SendMessageToPC( oUser, "Ward effects purged from " + GetName( oTarget ) + "." );
		SendMessageToPC( oTarget, "Ward effects purged by " + GetName( oUser ) + "." );
	} else {
		SendMessageToPC( oUser, "Could not remove Silverymoon's wards from " + GetName( oTarget ) + "." );
	}
}