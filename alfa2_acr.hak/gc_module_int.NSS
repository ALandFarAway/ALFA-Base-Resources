/////////////////////////////////////////////////////////////////////////////
//
//  System Name : ALFA Core Rules
//     Filename : gc_module_int.nss
//    $Revision:: 1        $ current version of the file
//        $Date:: 2023-03-20 date the file was created or modified
//       Author : Wynna 
//
//
//  Description
//  *This script checks a local int on the module
   
//  
////////////////////////////////////////////////////////////////////////////////
// Includes ////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////

#include "ginc_var_ops"
#include "ginc_param_const"

int StartingConditional(string sVariable, string sCheck)
{
    
    int nValue = GetLocalInt(GetModule(), sVariable);
    int iRet = CompareInts(nValue, sCheck);

    PrintString ("gc_module_int: nValue = " + IntToString(nValue));
    SendMessageToAllDMs("gc_module_int: nValue = " + IntToString(nValue));
	return (iRet);
}