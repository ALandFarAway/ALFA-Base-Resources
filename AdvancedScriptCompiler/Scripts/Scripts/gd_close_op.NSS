// gd_close_op
/*
    closes door after someone opens a door
    goes on the onOpen event of a door.
*/
// Chazm 3/8/05
void main()
{
   DelayCommand(9.0, ActionCloseDoor(OBJECT_SELF));
}