// gc_global_int
/*
    This script checks a global int variable's value
        sVariable   = This is the name of the variable  to check
        sCheck      = This is what you want to see what the local string is set to.
					  Default is an = check, but you can also specify <,>,or !
					  So an sCheck of "<50" returns TRUE if sVariable is less than 50,
					  an sCheck of "9" or "=9" returns TRUE if sVariable is equal to 9
					  and an sCheck of "!0" returns TRUE if sVariable is not equal to 0.
*/
// FAB 10/4
// EPF 4/12/05 changing variable names and implementation, removing superfluous third parameter
//     adding != functionality, moving common things to ginc_var_check
// ChazM 9/2/05 Updated to use CompareInts()

#include "ginc_var_ops"

int StartingConditional(string sVariable, string sCheck)
{
	int nValue = GetGlobalInt(sVariable);
    int iRet = CompareInts(nValue, sCheck);

    //PrintString ("gc_global_int: nValue = " + IntToString(nValue) + ",  sCheck = " + sCheck + " -- return val: " + IntToString(iRet));
    return (iRet);
}