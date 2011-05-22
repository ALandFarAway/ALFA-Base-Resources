// gc_global_float
/*
    This script checks a global float variable's value
        sVariable   = This is the name of the variable to check
        sCheck      = This is what you want to see what the local string is set to.
					  Default is an = check, but you can also specify <,>,or !
					  So an sCheck of "<50" returns TRUE if sVariable is less than 50,
					  an sCheck of "9" or "=9" returns TRUE if sVariable is equal to 9
					  and an sCheck of "!0" returns TRUE if sVariable is not equal to 0.
*/
// FAB 10/4
// EPF 4/12/05 changing variable names and implementation, removing superfluous third parameter
//     adding != functionality, moving common things to ginc_var_check

#include "ginc_var_ops"

int StartingConditional(string sVariable, string sCheck)
{

    float fCheck;
	float fValue;
	string sOperator = GetStringLeft(sCheck, 1);

	fValue = GetGlobalFloat(sVariable);

	//first we consider cases where the user specified an operator as the first character
	//of sCheck
	if(sOperator == ">" || sOperator == "<" || sOperator == "=" || sOperator == "!")
	{
		fCheck = StringToFloat( GetStringRight( sCheck,GetStringLength(sCheck)-1 ) );
	}
	//default case -- no operator specified so use whole string as our check value
	else	
	{
		fCheck = StringToFloat(sCheck);
		sOperator = "=";
	}
	
	return CheckVariableFloat(fValue, sOperator, fCheck);
}