void main() {
    object oCaster = GetAreaOfEffectCreator();
    if ( !GetIsObjectValid( oCaster ) || GetIsDead(oCaster) ) {
        DestroyObject( OBJECT_SELF, 0.0 );
    }
}