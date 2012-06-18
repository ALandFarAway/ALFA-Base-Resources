#include "acr_settings_i"
#include "acr_language_i"
#include "acr_i"

// 2008/09/17  AcadiusLost - inception

void main ( int nRegion ) {

    object oPC = GetPCSpeaker();
	
	if (nRegion == -1 ) {
	    // default starting region, use the current server
		ACR_SetCharacterRegion(oPC, ACR_GetServerRegion());
	} else {
		// add the selected starting region
		ACR_SetCharacterRegion(oPC, nRegion); 
	}  
	//SendMessageToPC(oPC, "Your starting region has been defined as "+IntToString(nRegion)+".");
			
}
