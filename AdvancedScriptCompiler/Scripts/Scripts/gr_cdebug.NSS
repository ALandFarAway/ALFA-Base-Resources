// gr_cdebug
/*
    Starts the debug conversation for this campaign

    This script for use with the runscript console command
*/
// ChazM 4/2/07

void main()
{
	string sDebugConvo = "00_cdebug";
    AssignCommand(OBJECT_SELF, ActionStartConversation(OBJECT_SELF, sDebugConvo, TRUE, FALSE));
}