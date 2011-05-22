// ga_door_open
/*
    This opens a door
        sTag    = The tag of the door to open
*/
// FAB 10/11

void main(string sTag)
{

    object oDoor = GetObjectByTag( sTag );

    SetLocked( oDoor, FALSE );
    DelayCommand ( 0.1, AssignCommand( oDoor, ActionOpenDoor( oDoor ) ) );

}
