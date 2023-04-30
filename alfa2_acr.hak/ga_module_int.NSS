/////////////////////////////////////////////////////////////////////////////
//
//  System Name : ALFA Core Rules
//     Filename : ga_module_int.nss
//    $Revision:: 1        $ current version of the file
//        $Date:: 2023-03-20 date the file was created or modified
//       Author : Wynna 
//
//
//  Description
//  *This script puts a local int on the module
   
//  
////////////////////////////////////////////////////////////////////////////////
// Includes ////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////



#include "ginc_param_const"
#include "ginc_var_ops"

void main(string sVariable, string sValue)
{
    
	int nValue = StringToInt(sValue);

	SetLocalInt(GetModule(), sVariable, nValue);
	
	PrintString ("ga_module_int: nValue = " + IntToString(nValue) + ",  GetLocalInt = " + IntToString(GetLocalInt(GetModule(), sVariable)));
    SendMessageToAllDMs("ga_module_int: nValue = " + IntToString(nValue) + ",  sCheck = " + IntToString(GetLocalInt(GetModule(), sVariable)));
	
    }