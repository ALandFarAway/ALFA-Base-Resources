//
//  aca_spawntoggle.nss
//
//  To turn on or off all ALFA spawn points in a given area.
//
#include "acr_spawn_i"

void main () {

    object oDM = GetItemActivator();
    object oArea = GetArea(oDM);
	object oWP = ACR_GetSpawnPoint(oArea, 1);
	int nIndex = 1;
	
	if (oWP == OBJECT_INVALID) {
	    SendMessageToPC(oDM, "No ALFA spawn points found in area "+GetName(oArea));
		return;
	}
	
	// check if area has been disabled
	if (GetLocalInt(oArea, "ACR_SPAWNS_OFF")) {
	    // already disabled, so re-enable
		while (oWP != OBJECT_INVALID) {
		    SendMessageToPC(oDM, "Enabling SP: "+GetName(oWP));
	        ACR_SetIsSpawnPointEnabled(oWP, TRUE, TRUE);
			nIndex = nIndex +1;
			oWP = ACR_GetSpawnPoint(oArea, nIndex);
		}
		DeleteLocalInt(oArea, "ACR_SPAWNS_OFF");
	} else {
	    // Area has not yet been disabled, so we want to disable it
	    // already disabled, so re-enable
		while (oWP != OBJECT_INVALID) {
		    SendMessageToPC(oDM, "Disabling SP: "+GetName(oWP));
	        ACR_SetIsSpawnPointEnabled(oWP, FALSE, TRUE);
			nIndex = nIndex +1;
			oWP = ACR_GetSpawnPoint(oArea, nIndex);
		}
		SetLocalInt(oArea, "ACR_SPAWNS_OFF", TRUE);
	}
}

