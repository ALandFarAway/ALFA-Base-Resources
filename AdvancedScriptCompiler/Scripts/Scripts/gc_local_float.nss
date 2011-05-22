// gc_local_float(string sVariable, string sCheck, string sTarget)
/* This script checks a local float variable's value.

   Parameters:
     string sVariable = This is the name of the variable.
     string sCheck    = This is the operation to compare local float to.
                        e.g. If sCheck = "<10.0" then return TRUE if sVariable < 10.0
                        If sCheck = "9.0" or "=9.0" then return TRUE OR FALSE if sVariable is equal to 9.0.
                        We cannot guarentee float accuracy, so == comparisons will generally fail.
     string sTarget   = Identifier or tag of the Target. If blank then use OWNER.
*/
// FAB 10/4
// EPF 4/12/05 changing variable names and implementation,
//     adding != functionality, moving common things to ginc_var_check
// BMA 4/27/05 add GetTarget(), logic fix, description update
// BMA 7/19/05 added object invalid printstring

#include "ginc_param_const"
#include "ginc_var_ops"

int StartingConditional(string sVariable, string sCheck, string sTarget)
{
    object oTarget = GetTarget(sTarget, TARGET_OBJECT_SELF);
	if (GetIsObjectValid(oTarget) == FALSE) PrintString("gc_local_float: " + sTarget + " is invalid");
    
    float fValue = GetLocalFloat(oTarget, sVariable);
    
	float fCheck;
	
    string sOperator = GetStringLeft(sCheck, 1);
    if(sOperator == ">" || sOperator == "<" || sOperator == "=" || sOperator == "!")
    {
        fCheck = StringToFloat( GetStringRight( sCheck,GetStringLength(sCheck)-1 ) );
    }
    else	
    {
        fCheck = StringToFloat(sCheck);
        sOperator = "=";
    }
    
    return CheckVariableFloat(fValue, sOperator, fCheck);
}