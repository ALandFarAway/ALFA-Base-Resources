// ginc_event_handlers
/*
	event handler related
*/
// ChazM 12/21/05
// ChazM 4/30/06 - Added EventsCleared flag and SafeClearEventHandlers(), SafeRestoreEventHandlers(), added support for remainder of object types
// ChazM 6/16/06 - fixed GetNumScripts(), added ReportEventHandlers()
// ChazM 2/21/07 added SetAssociateEventHandlers(), ConvertToAssociateEventHandler(), SCRIPT_ASSOC_* constants
// ChazM 3/8/07 added Standard default script constants
// ChazM 3/28/07 added SetAllEventHandlers() and SCRIPT_OBJECT_NOTHING

#include "ginc_debug"

// void main() {}
		
//---------------------------------------------------------------------
// Constants
//---------------------------------------------------------------------
const int EVENT_PLACEABLE_SPAWN		= 100; // use w/ gp_pseudo_spawn_hb


const string EVENTS_CLEARED_FLAG 	= "EH_CLEARED";
const string EVENTS_SAVE_PREFIX 	= "EH_SAVE";

// Standard associate scripts                               // Reference value
const string SCRIPT_ASSOC_ATTACK    = "gb_assoc_attack";    // 5
const string SCRIPT_ASSOC_BLOCK     = "gb_assoc_block";     // e
const string SCRIPT_ASSOC_COMBAT    = "gb_assoc_combat";    // 3
const string SCRIPT_ASSOC_CONV      = "gb_assoc_conv";      // 4
const string SCRIPT_ASSOC_DAMAGE    = "gb_assoc_damage";    // 6
const string SCRIPT_ASSOC_DEATH     = "gb_assoc_death";     // 7
const string SCRIPT_ASSOC_DISTRB    = "gb_assoc_distrb";    // 8
const string SCRIPT_ASSOC_HEART     = "gb_assoc_heart";     // 1
const string SCRIPT_ASSOC_PERCEP    = "gb_assoc_percep";    // 2
const string SCRIPT_ASSOC_REST      = "gb_assoc_rest";      // a
const string SCRIPT_ASSOC_SPAWN     = "gb_assoc_spawn";     // 9
const string SCRIPT_ASSOC_SPELL     = "gb_assoc_spell";     // b
const string SCRIPT_ASSOC_USRDEF    = "gb_assoc_usrdef";    // d


// Standard default scripts                               // Reference value
const string SCRIPT_DEFAULT_ATTACK    = "nw_c2_default5";   // 5
const string SCRIPT_DEFAULT_BLOCK     = "nw_c2_defaulte";   // e
const string SCRIPT_DEFAULT_COMBAT    = "nw_c2_default3";   // 3
const string SCRIPT_DEFAULT_CONV      = "nw_c2_default4";   // 4
const string SCRIPT_DEFAULT_DAMAGE    = "nw_c2_default6";   // 6
const string SCRIPT_DEFAULT_DEATH     = "nw_c2_default7";   // 7
const string SCRIPT_DEFAULT_DISTRB    = "nw_c2_default8";   // 8
const string SCRIPT_DEFAULT_HEART     = "nw_c2_default1";   // 1
const string SCRIPT_DEFAULT_PERCEP    = "nw_c2_default2";   // 2
const string SCRIPT_DEFAULT_REST      = "nw_c2_defaulta";   // a
const string SCRIPT_DEFAULT_SPAWN     = "nw_c2_default9";   // 9
const string SCRIPT_DEFAULT_SPELL     = "nw_c2_defaultb";   // b
const string SCRIPT_DEFAULT_USRDEF    = "nw_c2_defaultd";   // d

// Misc scripts
const string SCRIPT_OBJECT_NOTHING    = "go_nothing";    // nothing script (for any object)

//---------------------------------------------------------------------
// Prototypes
//---------------------------------------------------------------------


//---------------------------------------------------------------------
// Functions
//---------------------------------------------------------------------

void SetAssociateEventHandlers(object oAssociate)
{
    SetEventHandler(oAssociate,CREATURE_SCRIPT_ON_HEARTBEAT,        SCRIPT_ASSOC_HEART);
    SetEventHandler(oAssociate,CREATURE_SCRIPT_ON_NOTICE,           SCRIPT_ASSOC_PERCEP);
    SetEventHandler(oAssociate,CREATURE_SCRIPT_ON_SPELLCASTAT,      SCRIPT_ASSOC_SPELL);
    SetEventHandler(oAssociate,CREATURE_SCRIPT_ON_MELEE_ATTACKED,   SCRIPT_ASSOC_ATTACK);
    SetEventHandler(oAssociate,CREATURE_SCRIPT_ON_DAMAGED,          SCRIPT_ASSOC_DAMAGE);
    SetEventHandler(oAssociate,CREATURE_SCRIPT_ON_DISTURBED,        SCRIPT_ASSOC_DISTRB);
    SetEventHandler(oAssociate,CREATURE_SCRIPT_ON_END_COMBATROUND,  SCRIPT_ASSOC_COMBAT);
    SetEventHandler(oAssociate,CREATURE_SCRIPT_ON_DIALOGUE,         SCRIPT_ASSOC_CONV);
    SetEventHandler(oAssociate,CREATURE_SCRIPT_ON_SPAWN_IN,         SCRIPT_ASSOC_SPAWN);
    SetEventHandler(oAssociate,CREATURE_SCRIPT_ON_RESTED,           SCRIPT_ASSOC_REST);
    SetEventHandler(oAssociate,CREATURE_SCRIPT_ON_DEATH,            SCRIPT_ASSOC_DEATH);
	SetEventHandler(oAssociate,CREATURE_SCRIPT_ON_USER_DEFINED_EVENT,SCRIPT_ASSOC_USRDEF);
    SetEventHandler(oAssociate,CREATURE_SCRIPT_ON_BLOCKED_BY_DOOR,  SCRIPT_ASSOC_BLOCK);
}


// this will only replace event handlers determined to be safe to replace.
void ConvertToAssociateEventHandler(int iEventHandler, string sNewEventScript)
{
    object oAssociate = OBJECT_SELF;
    
    // Only replace script event if it is one of the default ones we are confident is safe to replace.
    // Done with caution because one of these script could be called via ExecuteScript() and not 
    // actually be the event handler.
    string sVarName = "NotAReplaceableEventScript" + IntToString(iEventHandler);
    if (GetLocalInt(oAssociate, sVarName) == FALSE)
    {
        string sCurrentEventScript = GetEventHandler(oAssociate, iEventHandler);
        string sPrefix = GetStringLeft(sCurrentEventScript, 7); //
        int iLength = GetStringLength(sCurrentEventScript);
        if ((sPrefix == "nw_ch_a" && iLength == 9)
            || (sPrefix == "x0_ch_h") 
            || (sPrefix == "x0_hen_")
            || (sPrefix == "x2_hen_")
            )
            SetEventHandler(oAssociate, iEventHandler, sNewEventScript);
        else
            SetLocalInt(oAssociate, sVarName, TRUE);
    }            
    // in any case, execute the replacement script        
    ExecuteScript(sNewEventScript, OBJECT_SELF);
}


int GetEventsClearedFlag(object oObject)
{
	int bEventsCleared = GetLocalInt(oObject, EVENTS_CLEARED_FLAG);
	return (bEventsCleared);	
}

void SetEventsClearedFlag(object oObject, int bFlag)
{
	SetLocalInt(oObject, EVENTS_CLEARED_FLAG, bFlag);
}
/*
int    OBJECT_TYPE_CREATURE         = 1;
int    OBJECT_TYPE_ITEM             = 2;
int    OBJECT_TYPE_TRIGGER          = 4;
int    OBJECT_TYPE_DOOR             = 8;
int    OBJECT_TYPE_AREA_OF_EFFECT   = 16;
int    OBJECT_TYPE_WAYPOINT         = 32;
int    OBJECT_TYPE_PLACEABLE        = 64;
int    OBJECT_TYPE_STORE            = 128;
int    OBJECT_TYPE_ENCOUNTER		= 256;
int    OBJECT_TYPE_LIGHT            = 512;
int    OBJECT_TYPE_PLACED_EFFECT    = 1024;
*/

			
int GetNumScripts(object oObject)
{
	int iObjectType = GetObjectType(oObject); // doesn't appear to have a value for areas and modules
	int iNumScripts = 0;
	
	// see nwscript.nss for list of script event handlers
	switch (iObjectType)
	{
		case OBJECT_TYPE_CREATURE:
			iNumScripts = 13;
			break;	
		case OBJECT_TYPE_ITEM: // items don't have scripts 
			iNumScripts = 0;	
			break;	
		case OBJECT_TYPE_TRIGGER:
			iNumScripts = 7;	
			break;	
		case OBJECT_TYPE_DOOR:
			iNumScripts = 15;	
			break;	
		case OBJECT_TYPE_AREA_OF_EFFECT:
			iNumScripts = 4;	
			break;	
		case OBJECT_TYPE_WAYPOINT:
			iNumScripts = 0;	
			break;	
		case OBJECT_TYPE_PLACEABLE:
			iNumScripts = 15;	
			break;	
		case OBJECT_TYPE_STORE:
			iNumScripts = 2;	
			break;	
		case OBJECT_TYPE_ENCOUNTER:
			iNumScripts = 5;	
			break;	
		case OBJECT_TYPE_LIGHT:
			iNumScripts = 0;	
			break;	
		case OBJECT_TYPE_PLACED_EFFECT:
			iNumScripts = 0;	
			break;	
	}
	return (iNumScripts);	
}

void SaveEventHandlers(object oObject)
{
	string sEventHandler;
	string sVarName;
	int iNumScripts = GetNumScripts(oObject);
	int i;

	for (i=0; i<iNumScripts; i++)
	{
		sEventHandler = GetEventHandler(oObject, i);
		sVarName = EVENTS_SAVE_PREFIX + IntToString(i);
		SetLocalString(oObject, sVarName, sEventHandler);
	}
}


// set all event handlers to the same script.
// this would typically only be "" or SCRIPT_OBJECT_NOTHING
void SetAllEventHandlers(object oObject, string sScriptName)
{
	int iNumScripts = GetNumScripts(oObject);
	int i;

	for (i=0; i<iNumScripts; i++)
	{
		SetEventHandler(oObject, i, sScriptName);
	}
}

void ClearEventHandlers(object oObject)
{
	string sScriptName = "";
	SetAllEventHandlers(oObject, sScriptName);
	SetEventsClearedFlag(oObject, TRUE);
}

void RestoreEventHandlers(object oObject)
{
	string sEventHandler;
	string sVarName;
	int iNumScripts = GetNumScripts(oObject);
	int i;

	for (i=0; i<iNumScripts; i++)
	{
		sVarName = EVENTS_SAVE_PREFIX + IntToString(i);
		sEventHandler = GetLocalString(oObject, sVarName);
		SetEventHandler(oObject, i, sEventHandler);
	}
	SetEventsClearedFlag(oObject, FALSE);
}

void DeleteSavedEventHandlers(object oObject)
{
	string sVarName;
	int iNumScripts = GetNumScripts(oObject);
	int i;

	for (i=0; i<iNumScripts; i++)
	{
		sVarName = "EH_SAVE" + IntToString(i);
		DeleteLocalString(oObject, sVarName);
	}
}

// save and clear event handlers if they haven't already been flagged as cleared.
void SafeClearEventHandlers(object oObject)
{
	if (GetEventsClearedFlag(oObject) == FALSE)		
	{
		SaveEventHandlers(oObject);
		ClearEventHandlers(oObject);
	}		
}

//	restore event handlers if they were previously flagged as cleared.
void SafeRestoreEventHandlers(object oObject)
{
	if (GetEventsClearedFlag(oObject) == TRUE)		
	{
		RestoreEventHandlers(oObject);
		DeleteSavedEventHandlers(oObject);
	}			
}
	
void ReportEventHandlers(object oObject)	
{	
	string sEventHandler;
	string sVarName;
	int iNumScripts = GetNumScripts(oObject);
	int i;
	
	int iObjectType = GetObjectType(oObject); // doesn't appear to have a value for areas and modules

	PrettyDebug (" object type of " + GetName(oObject)+ " is " + IntToString(iObjectType));
	PrettyDebug (" iNumScripts =  " + IntToString(iNumScripts));

	for (i=0; i<iNumScripts; i++)
	{
		sEventHandler = GetEventHandler(oObject, i);
		PrettyDebug(" Script " + IntToString(i) + " = " + sEventHandler);
	}
}
	
	