// ga_door_close
/*
    This closes a door
        sTag    = The tag of the door to close
        nLock   = Set to 1 if you want to lock the door after it closes
*/
// FAB 10/11

void main(string sTag, int nLock)
{

    object oDoor = GetObjectByTag( sTag );

    DelayCommand ( 0.1, AssignCommand( oDoor, ActionCloseDoor( oDoor ) ) );
    if ( nLock == 1 ) SetLocked( oDoor, TRUE );

}
