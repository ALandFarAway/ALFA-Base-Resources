// gtr_enable_map_note
/*
	Description: enable map pin specified on trigger variable.
*/
// ChazM 1/31/07
// ChazM 4/16/07 Cleaned up message to PC and made message optional.
// ChazM 4/18/07 Removed map note name.  Added INDICATE_MAP_NOTE_NAME
// ChazM 7/20/07 Add sound effect

#include "ginc_debug"

// variables on the trigger
const string VAR_MAP_NOTE_TAG 		= "MAP_NOTE_TAG";		// string - tag of the map note to act on
const string VAR_MAP_NOTE_NO_MESSAGE= "MAP_NOTE_NO_MESSAGE"; // int - 0 = inform player

// other constants
const int INDICATE_MAP_NOTE_NAME 	= FALSE; 	// TRUE=include map note name in message.

// String Refs
const int STR_REF_MAP_NOTE_ADDED 	= 186237; 	// "Map Note added:"
const int STR_REF_MAP_NOTE_ADDED2 	= 195669;	// "Map Note added."
const string SOUND_MAP_NOTE_ENABLED = "map_note_enabled";

void main()
{
	object oPC = GetEnteringObject();
	if (!GetIsPC(oPC))
		return;

	int nEnabled = TRUE;
	string sMapPinTag = GetLocalString(OBJECT_SELF, "MAP_NOTE_TAG");
	object oMapPin = GetNearestObjectByTag(sMapPinTag);
	
	if (GetIsObjectValid(oMapPin))
	{
		SetMapPinEnabled (oMapPin, nEnabled);
		if (GetLocalInt(OBJECT_SELF, VAR_MAP_NOTE_NO_MESSAGE) == FALSE)
		{
			string sOut;
			if (INDICATE_MAP_NOTE_NAME) {
				sOut = GetStringByStrRef(STR_REF_MAP_NOTE_ADDED) + GetName(oMapPin);
			} else {
				sOut = GetStringByStrRef(STR_REF_MAP_NOTE_ADDED2);
			}			
			SendMessageToPC(oPC, sOut);
			AssignCommand(oPC, PlaySound(SOUND_MAP_NOTE_ENABLED));
		}			
	}
	else
	{
		PrettyError("Couldn't find Map Note " + sMapPinTag);
	}
	
	// We don't need this trigger anymore.
	DestroyObject (OBJECT_SELF, 0.1f);
}