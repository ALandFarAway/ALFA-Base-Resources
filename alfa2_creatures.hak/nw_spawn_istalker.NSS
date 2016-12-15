// nw_spawn_istalker
/*
	This is the custom spawn script for the invisible stalker.
	It applies improved invisibility as a supernatural effect.
*/
// 20nov2014 RJHall

void main()
{
	effect eCover = EffectConcealment( 50 );
	effect eNat = SupernaturalEffect( eCover );
	ApplyEffectToObject( DURATION_TYPE_PERMANENT, eNat, OBJECT_SELF, 0.0f );
}