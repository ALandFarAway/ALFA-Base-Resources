// gc_local_int(string sVariable, string sCheck, string sTarget)
/* This script checks a local int variable's value.

   Parameters:
     string sVariable  = The name of the variable
     string sCheck     = The operation to check on the value of the variable.
                         Default is ==, but you can also specify <, >, or !
                         e.g. sCheck of "<50" returns TRUE if sVariable's value is <50
                         a sCheck of "9" or "=9" returns TRUE if sVariable's value is equal to 9
                         and a sCheck of "!0" returns TRUE if sVariable's value is not equal to 0.
     string sTarget    = Tag or identifier of Target. If blank then use dialog OWNER.
*/
// FAB 10/4
// EPF 4/12/05 changing variable names and implementation,
//     adding != functionality, moving common things to ginc_var_check
// ChazM 4/15 change implementation, added PrintString
// BMA 4/27/05 new description, added GetTarget()
// BMA 7/19/05 added object invalid printstring

#include "ginc_var_ops"
#include "ginc_param_const"

int StartingConditional(string sVariable, string sCheck, string sTarget)
{
    object oTarg = GetTarget(sTarget, TARGET_OBJECT_SELF);
	if (GetIsObjectValid(oTarg) == FALSE) PrintString("gc_local_int: " + sTarget + " is invalid");
    
    int nValue = GetLocalInt(oTarg, sVariable);
    int iRet = CompareInts(nValue, sCheck);

    PrintString ("gc_local_int: nValue = " + IntToString(nValue) + ",  sCheck = " + sCheck + " -- return val: " + IntToString(iRet));
    return (iRet);
}