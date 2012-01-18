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
 

	if(GetLocked(GetItemActivatedTarget()) == TRUE)
		{ActionUnlockObject(GetItemActivatedTarget());
   		 SendMessageToPC(GetItemActivator(), GetName(GetItemActivatedTarget()) + " unlocked.");
		 SendMessageToPC(GetItemActivator(), "Unlock DC = " + IntToString(GetLockUnlockDC(GetItemActivatedTarget())));
		 }
	else
		{ActionLockObject(GetItemActivatedTarget());
		 SendMessageToPC(GetItemActivator(), GetName(GetItemActivatedTarget()) + " locked.");
		 SendMessageToPC(GetItemActivator(), "Unlock DC = " + IntToString(GetLockUnlockDC(GetItemActivatedTarget())));
		 }
		
	
	
}