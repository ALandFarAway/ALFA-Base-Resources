// gr
/*
    Starts the gr_convo which gives access to the various gr_* scripts

    This script for use with the dm_runscript console command
*/
// ChazM 11/6/05

void main()
{
    //object oLeader = GetFactionLeader(OBJECT_SELF);
    //if (GetIsObjectValid(oLeader) == TRUE)
    //{
	AssignCommand(OBJECT_SELF, ActionStartConversation(OBJECT_SELF, "gr_convo", TRUE, FALSE));
    //}
}