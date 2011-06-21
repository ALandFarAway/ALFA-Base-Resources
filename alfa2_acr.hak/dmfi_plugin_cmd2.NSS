#include "dmfi_inc_sendtex"

void main()
{

	object oPC = OBJECT_SELF;
	object oSpeaker = GetLocalObject(OBJECT_SELF, "DMFI_CUSTOM_SPEAKER");
	object oTarget = GetLocalObject(OBJECT_SELF, "DMFI_CUSTOM_TARGET");
	string sInput = GetLocalString(OBJECT_SELF, "DMFI_CUSTOM_CMD");
	
	SendText(oSpeaker, "DEBUG: CMD 2");

}	
			