// gr_followleader
/*
    Sets player to auto-follow the party leader.

    This script for use with the dm_runscript console command
*/
// ChazM 11/6/05

void main()
{
    object oLeader = GetFactionLeader(OBJECT_SELF);
    if (GetIsObjectValid(oLeader) == TRUE)
    {
        AssignCommand(OBJECT_SELF, ActionForceFollowObject(oLeader, 3.0f));
    }
}
