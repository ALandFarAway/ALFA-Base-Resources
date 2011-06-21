#include "dmfi_inc_sendtex"
#include "dmfi_inc_const"

void main()
{

	object oPC = OBJECT_SELF;
	object oSpeaker = GetLocalObject(OBJECT_SELF, "DMFI_CUSTOM_SPEAKER");
	object oTarget = GetLocalObject(OBJECT_SELF, "DMFI_CUSTOM_TARGET");
	string sInput = GetLocalString(OBJECT_SELF, "DMFI_CUSTOM_CMD");
	
	SendText(oSpeaker, "DEBUG: CMD 1");
	SendText(oSpeaker, "DEBUG: sInput: " + sInput);
	SendText(oSpeaker, "DEBUG: oPlayer: " + GetName(oPC));
	SendText(oSpeaker, "DEBUG: oSpeaker: " + GetName(oSpeaker));
	SendText(oSpeaker, "DEBUG: oTarget: " + GetName(oTarget));	
	
	if (sInput==".stop")
	{
		// Setting this variable will not allow further plugins OR
		// the default DMFI behavior to run - Set it for OVERRIDES!
		SetLocalInt(GetModule(), DMFI_STRING_OVERRIDE, 1);
		SendText(oSpeaker, "DEBUG: OVERRIDE - CMD2 will not run.");
	}	

}	
			