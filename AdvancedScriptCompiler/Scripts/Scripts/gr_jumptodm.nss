// gr_jumptodm
/*
    jumpts player to the a DM.

    This script for use with the dm_runscript console command
*/
// ChazM 11/13/05

void main()
{
    object oDM = GetObjectByTag("gr_dm");
    if (GetIsObjectValid(oDM) == TRUE)
    {
        AssignCommand(OBJECT_SELF, JumpToObject(oDM));
    }

}
