////////////////////////////////////////////////////////////////////////////////
/*
    This script covers the GUI-interface for the new ACR resting system, wherein
    casters are given opportunity to customize their spell payload for the day
    before entering play.
*/
////////////////////////////////////////////////////////////////////////////////

////////////////////////////////////////////////////////////////////////////////
// Includes ////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////

#include "acr_resting_i"

////////////////////////////////////////////////////////////////////////////////
// Constants ///////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////

////////////////////////////////////////////////////////////////////////////////
// Structures //////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////

////////////////////////////////////////////////////////////////////////////////
// Global Variables ////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////

////////////////////////////////////////////////////////////////////////////////
// Function Prototypes /////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////

////////////////////////////////////////////////////////////////////////////////
// Function Definitions ////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////

void main(string sParam)
{
    if(sParam == "10")
    {
        // Extra click, make sure the GUI is closed and-- return.
        CloseGUIScreen(OBJECT_SELF, "acr_resting");
        return;
    }
    if (!GetLocalInt(OBJECT_SELF, ACR_FREE_SPELL_PREP))
    {
        SendMessageToPC(OBJECT_SELF, "You cannot prepare spells right now-- this is probably a bug. Submit a ticket to the ACR and tell us how you did it!");
        return;
    }
    if (!ACR_REST_ENABLED)
    { 
        SendMessageToPC(OBJECT_SELF, "Whoops! Looks like the ACR resting system isn't turned on right now. Submit a ticket to your server team about this!");
        return; 
    }
    if (ACR_GetIsPlayerDead(OBJECT_SELF)) 
    { 
        SendMessageToPC(OBJECT_SELF, "Whoops! We didn't realise you were dead until just now. Sorry about that!");
        return; 
    }
    if (ACR_PPSIsPlayerQuarantined(OBJECT_SELF))
    { 
        SendMessageToPC(OBJECT_SELF, "Whoops! We didn't realise you were in quarantine until just now. Sorry about that!");
        return; 
    }
    CloseGUIScreen(OBJECT_SELF, "acr_resting");

    DeleteLocalInt(OBJECT_SELF, ACR_FREE_SPELL_PREP);
    if(GetLevelByClass(CLASS_TYPE_CLERIC, OBJECT_SELF))
	    _playerRestoreSpells(OBJECT_SELF, IntToString(CLASS_TYPE_CLERIC),  GetCurrentHitPoints(OBJECT_SELF));
    if(GetLevelByClass(CLASS_TYPE_DRUID, OBJECT_SELF))
	    _playerRestoreSpells(OBJECT_SELF, IntToString(CLASS_TYPE_DRUID),   GetCurrentHitPoints(OBJECT_SELF));
    if(GetLevelByClass(CLASS_TYPE_PALADIN, OBJECT_SELF))
	    _playerRestoreSpells(OBJECT_SELF, IntToString(CLASS_TYPE_PALADIN), GetCurrentHitPoints(OBJECT_SELF));
    if(GetLevelByClass(CLASS_TYPE_RANGER, OBJECT_SELF))
	    _playerRestoreSpells(OBJECT_SELF, IntToString(CLASS_TYPE_RANGER),  GetCurrentHitPoints(OBJECT_SELF));
    if(GetLevelByClass(CLASS_TYPE_WIZARD, OBJECT_SELF))
 	    _playerRestoreSpells(OBJECT_SELF, IntToString(CLASS_TYPE_WIZARD),  GetCurrentHitPoints(OBJECT_SELF));
}
