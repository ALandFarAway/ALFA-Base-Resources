// gr_jumpleader
/*
    Teleports player to the party leader.

    This script for use with the dm_runscript console command
*/
// ChazM 11/6/05

void main()
{
    object oLeader = GetFactionLeader(OBJECT_SELF);
    if (GetIsObjectValid(oLeader) == TRUE)
    {
        AssignCommand(OBJECT_SELF, JumpToObject(oLeader));
    }
}
