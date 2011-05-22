// gr_restart
/*
    Restarts the module.  Assumes module name is the file name.

    This script for use with the dm_runscript console command
*/
// ChazM 11/6/05

void main()
{
    string sModuleName = GetName(GetModule());
    StartNewModule(sModuleName);
}
