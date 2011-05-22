// gr_debug
/*
    Starts the debug conversation for this module

    This script for use with the dm_runscript console command
*/
// ChazM 2/24/06

void main()
{
	string sDebugConvo = "00_debug";
    AssignCommand(OBJECT_SELF, ActionStartConversation(OBJECT_SELF, sDebugConvo, TRUE, FALSE));
}