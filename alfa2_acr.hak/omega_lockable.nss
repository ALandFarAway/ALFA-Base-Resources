////////////////////////////////////////////////////////////////////////////////
//
//  System Name : ACR Configuration File
//     Filename : acf_plc_onused.nss
//    $Revision:: 183        $ current version of the file
//        $Date:: 2006-12-21#$ date the file was created or modified
//       Author : Ronan
//
//  Local Variable Prefix =
//
//  Dependencies external of nwscript:
//
//  Description
//  This script calls the ACR's OnUsed code for placeables, and any
//  custom code a server may need. It is not updated in ACR updates.
//
//  Revision History
////////////////////////////////////////////////////////////////////////////////

////////////////////////////////////////////////////////////////////////////////
// Includes ////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////

#include "acr_placeable_i"
#include "dmfi_inc_langexe" 
#include "acr_quest_i"
#include "acr_door_i"

void main() {
 

	if(GetLockLockable(GetItemActivatedTarget()) == TRUE)
		{SetLockLockable(GetItemActivatedTarget(), FALSE);
   		 SendMessageToPC(GetItemActivator(), GetName(GetItemActivatedTarget()) + " set NOT lockable.");
		 SendMessageToPC(GetItemActivator(), "Unlock DC = " + IntToString(GetLockUnlockDC(GetItemActivatedTarget())));
		 }
	else
		{SetLockLockable(GetItemActivatedTarget(), TRUE);
		 SendMessageToPC(GetItemActivator(), GetName(GetItemActivatedTarget()) + " set lockable.");
		 SendMessageToPC(GetItemActivator(), "Unlock DC = " + IntToString(GetLockUnlockDC(GetItemActivatedTarget())));
		 }
		
	
	
}