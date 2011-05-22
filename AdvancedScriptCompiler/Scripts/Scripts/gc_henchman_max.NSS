//::///////////////////////////////////////////////////////////////////////////
//::
//::	gc_henchman_max
//::
//::	Compares the maximum number of allowed Henchmen (as a number) to a criteria (henchmen are not companions).
//::
//::        Parameters:     string sCheck - works just like gc_local_int
//::					              it is the operation to check on the value of the variable.
//::
//::                         Default is ==, but you can also specify <, >, or !
//::                         e.g. sCheck of "<50" returns TRUE if sVariable's value is <50
//::                         a sCheck of "9" or "=9" returns TRUE if sVariable's value is equal to 9
//::                         and a sCheck of "!0" returns TRUE if sVariable's value is not equal to 0.
//::
//::///////////////////////////////////////////////////////////////////////////
// DBR 1/28/06  - I so ripped this off of gc_local_int. Thanks FAB. I like you.

#include "ginc_param_const"
#include "ginc_var_ops"
//#include "ginc_henchman"



int StartingConditional(string sCheck)
{
    int nValue = GetMaxHenchmen();
    int iRet = CompareInts(nValue, sCheck);

    return (iRet);
}