// gc_global_string
/*
    This script checks a global string variable's value
        sVariable    = This is the name of the variable to check
        sCheck     = This is what you want to see what the local string is set to
*/
// FAB 10/7
// EPF 4/12/05 spring cleaning

int StartingConditional(string sVariable, string sCheck)
{
    if ( GetGlobalString(sVariable) == sCheck ) return TRUE;
    return FALSE;
}