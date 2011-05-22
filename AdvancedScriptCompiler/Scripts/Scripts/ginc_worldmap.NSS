// ginc_worldmap
/*
	General purpose functions and constants for the NWN2 world map functionality
	
	Two 2da files are required for each world map.  See constants list below for required name and columns
	
*/	
// ChazM 4/23/07
// ChazM 5/1/07 - hotspot func name changes, updated numeric range matching to ensure the comparison values are integers.
// ChazM 6/11/07 -- added autosave into DoShowWorldMap() based on campaign swicth
// ChazM 6251/07 - commented out unused constants
	
#include "ginc_debug"
// ginc_companion -> ForceRestParty()
#include "ginc_companion"
#include "ginc_transition"
#include "ginc_2da"
#include "ginc_math"
#include "ginc_autosave"
#include "x2_inc_switches"

//==========================================================
// CONSTANT DECLARATIONS
//==========================================================

// *** 2DA FILE INFO

// This 2da defines the set of hotspots
const string HOTSPOTS_2DA_SUFFIX	= "_hs";	// 2da must be "<map name>_hs".  
const string COL_HOTSPOT_TAG		= "HotspotTag";	// Tag (currently name) as listed in the world map
const string COL_WP_TAG				= "WPTag";		// tag of waypoint this hotspot represents
const string COL_MODULE				= "Module";		// module the waypoint is located in. (filename w/o extension)

// This 2da defines the set of connections of all hotspots
const string HOTSPOT_CONNECTIONS_2DA_SUFFIX = "_hsc";	// 2da must be "<map name>_hsc".  
const string COL_ORIGIN_TAG			= "OriginTag";		// a HotspotTag from above
const string COL_DESTINATION_TAG	= "DestinationTag";	// another HotspotTag from above
const string COL_TRAVEL_TIME_TAG	= "numTravelTime";	// time required for travel.  the "num" prefix prevents numbers from being treated as String Refs

// GENERAL //

// these are used with the Encounter message box
const int STRREF_ENCOUNTER_MESSAGE 		= 182995;
const string ENCOUNTER_MESSAGE_OVERRIDE = "00_bOverrideEncounterMessage";
const string LAST_DESTINATION 			= "00_sLastDestination";
const string LAST_MODULE 				= "00_sLastModule";
const string PC_CLICKER 				= "oLastWorldMapClicker";	//this is stored on the module not 

// these are for locking the world map so only one user can use it at a time
//const string WORLD_MAP_LOCKED 			= "00_bWorldMapLocked";
//const string WORLD_MAP_LOCKER 			= "oWorldMapLocker";
const int STRING_REF_MAP_LOCKED 		= 183512;
const string WORLD_MAP_LOCKED_DAY 		= "00_nWorldMapLockDay";
const string WORLD_MAP_LOCKED_HOUR 		= "00_nWorldMapLockHour";
const string WORLD_MAP_LOCKED_MINUTE 	= "00_nWorldMapLockMinute";
const string WORLD_MAP_LOCKED_SECOND 	= "00_nWorldMapLockSecond";
const int WORLD_MAP_LOCK_COOLDOWN 		= 18;	//seconds until we allow another click
const string WORLD_MAP_LOCK_INITIALIZED = "00_bWorldMapLockInit";

// WorldMap Var Name constant
const string VAR_WM_VISIBLE_PREFIX		= "00_VIS";

// these are set on the pc before the world map is pulled up.
const string VAR_WORLD_MAP_HOTSPOT_ORIGIN = "00_sWORLD_MAP_HOTSPOT_ORIGIN";
const string VAR_WORLD_MAP_NAME 		= "00_sWORLD_MAP_NAME";



//==========================================================
// FUNCTION DECLARATIONS
//==========================================================
	
// ** hotspot functions	**
/*
//Flag a hotspot as visible (for the world map)
void ShowHotspot(string sHotspot);
	
//Flag a hotspot as not visible (for the world map)
void HideHotspot(string sHotspot);

//returns true if a hotspot is flagged as visible (for the world map)
int GetIsHotspotVisible(string sHotspot);
*/
	
// show a "you have encountered a thing on the world map" message.  Callback initiates the transition.
void ShowEncounterMessage(string sDestination, string sModule);


// ** world map lockout functions **

// multiple PCs simultaneously clicking travel on the world map causes problems.  We use a cooldown time to preven this.
void SetWorldMapLocked();
int GetWorldMapLocked();



//==========================================================
// FUNCTION DEFINITONS
//==========================================================

string GetHotspots2DA(string sMapName)
{
	return (sMapName + HOTSPOTS_2DA_SUFFIX);
}

string GetHotspotConnections2DA(string sMapName)
{
	return (sMapName + HOTSPOT_CONNECTIONS_2DA_SUFFIX);
}


// returns -1 if not found
int GetHotspotRow(string s2DA, string sHotspot)
{
	int iHotspotRow = Search2DA(s2DA, COL_HOTSPOT_TAG, sHotspot);
	return (iHotspotRow);
}

// returns -1 if not found
int GetHotspotConnectionRow(string s2DA, string sHotspotOrigin, string sHotspotDestination)
{
	int iHotspotConnectionsRow = Search2DA2Col(s2DA, COL_ORIGIN_TAG, COL_DESTINATION_TAG, sHotspotOrigin, sHotspotDestination);
	return (iHotspotConnectionsRow);
}

// whether to show or hide each hotspot is determined by the setting of
// global variables.  The world map conditional script looks at these.
int GetHotspotVisibleFlag(string sMap, string sHotspot)
{
	return GetGlobalInt(VAR_WM_VISIBLE_PREFIX + sMap + sHotspot);
}

void FlagHotspotVisibility(int bVisible, string sMap, string sHotspot)
{
	SetGlobalInt(VAR_WM_VISIBLE_PREFIX + sMap + sHotspot, bVisible);
}

//
void FlagHotspotsMatchingStringVisibility(int bVisible, string sMap, string sCol, string sMatchValue)
{
	string s2DA = GetHotspots2DA(sMap);
	int nRow=0;
	
	string sHotspot = Get2DAString(s2DA, COL_HOTSPOT_TAG, nRow);
	string sEntry = Get2DAString(s2DA, sCol, nRow);
	
	// look throug all hotspots
	while (sHotspot != "")
	{
		if (sEntry == sMatchValue)
		{
			FlagHotspotVisibility(bVisible, sMap, sHotspot);
		}			
		nRow++;
		sEntry = Get2DAString(s2DA, sCol, nRow);
		sHotspot = Get2DAString(s2DA, COL_HOTSPOT_TAG, nRow);
	}
}

// assumes sValue is trimmed
// is this really just an integer?
int GetIsValidInt(string sValue)
{
	return (sValue == IntToString(StringToInt(sValue)));
}

void FlagHotspotsMatchingRangeVisibility(int bVisible, string sMap, string sCol, int nMin, int nMax)
{
	string s2DA = GetHotspots2DA(sMap);
	int nRow=0;
	
	string sHotspot = Get2DAString(s2DA, COL_HOTSPOT_TAG, nRow);
	string sEntry;
	int nEntry;
	
	// look throug all hotspots
	while (sHotspot != "")
	{
		sEntry = Get2DAString(s2DA, sCol, nRow);
		nEntry = StringToInt(sEntry);
		
		if (GetIsValidInt(sEntry) && IsIntInRange(nEntry, nMin, nMax))
		{
			FlagHotspotVisibility(bVisible, sMap, sHotspot);
		}			
		nRow++;
		sHotspot = Get2DAString(s2DA, COL_HOTSPOT_TAG, nRow);
	}
}


void ShowEncounterMessage(string sDestination, string sModule)
{
	// so the callback knows where to jump the player to.
	SetGlobalString(LAST_DESTINATION, sDestination);
	SetGlobalString(LAST_MODULE, sModule);
	SetLocalObject(GetModule(),PC_CLICKER, OBJECT_SELF);
	SetCommandable(FALSE);	//freeze player until the callback is clicked.
	DisplayMessageBox(OBJECT_SELF, STRREF_ENCOUNTER_MESSAGE, "", "gui_map_transition");
}

void SetWorldMapLocked()
{
	SetGlobalInt(WORLD_MAP_LOCKED_DAY, GetCalendarDay());
	SetGlobalInt(WORLD_MAP_LOCKED_HOUR, GetTimeHour());
	SetGlobalInt(WORLD_MAP_LOCKED_MINUTE, GetTimeMinute());
	SetGlobalInt(WORLD_MAP_LOCKED_SECOND, GetTimeSecond());
	
	SetGlobalInt(WORLD_MAP_LOCK_INITIALIZED, TRUE);	//so we know the timer is initialized
	
	PrettyMessage("World map locked at time " + IntToString(GetTimeHour()) + ":" + IntToString(GetTimeMinute()) + ":" + IntToString(GetTimeSecond()));
}


// Note: This presumes 60 minutes in an hour, which isn't typically the case.
// This should be ok however, unless minutes/hour is set to be greater than 60.
int TimeToSeconds(int nHour, int nMinute, int nSecond)
{
	//for ease, we just convert the time into seconds -- 60 for 60 seconds in a minute, 3600 for number of seconds in an hour.
	return nSecond + nMinute * 60 + nHour * 3600;
}

int GetWorldMapLocked()
{
	if(GetIsSinglePlayer())
	{
		return FALSE;
	}

	if(!GetGlobalInt(WORLD_MAP_LOCK_INITIALIZED))
	{
		return FALSE;
	}

	int nLockedHour = GetGlobalInt(WORLD_MAP_LOCKED_HOUR);
	int nLockedMinute = GetGlobalInt(WORLD_MAP_LOCKED_MINUTE);
	int nLockedSecond = GetGlobalInt(WORLD_MAP_LOCKED_SECOND);
	
	int nCurrentHour = GetTimeHour();
	int nCurrentMinute = GetTimeMinute();
	int nCurrentSecond = GetTimeSecond();
	
	int nTotalLockedSeconds = TimeToSeconds(nLockedHour,nLockedMinute,nLockedSecond);
	int nTargetTime = nTotalLockedSeconds + WORLD_MAP_LOCK_COOLDOWN;	//10 sec cooldown
	
	int nCurrentSeconds = TimeToSeconds(nCurrentHour,nCurrentMinute,nCurrentSecond);
	
//	PrettyDebug("Target time for unlock = " + IntToString(nTargetTime));
//	PrettyDebug("Current time in seconds = " + IntToString(nCurrentSeconds));		
	
	//same day
	if(nTargetTime < nCurrentSeconds)
	{
//		PrettyDebug(IntToString(nCurrentSeconds - nTotalLockedSeconds) + " seconds passed since the last transition.");
		return FALSE;
	}		
	
	//we've rolled to the next calendar day
	int nLockedDay = GetGlobalInt(WORLD_MAP_LOCKED_DAY);
	int nCurrentDay = GetCalendarDay();
	
	//!= is the check here because the day change could roll the month
	//so going from month 1 day 28 to month 2 day 0 should still register as a day having passed.
	if(nCurrentDay != nLockedDay && nCurrentSeconds > WORLD_MAP_LOCK_COOLDOWN)
	{
		return FALSE;
	}
		
	return TRUE;
}


/*	
void StoreWorldMapIndexes(object oPC, string sOriginHotspot, string sDestHotspot)
{

	// a hotspots list - must include columns: HotspotTag, Module, WPTag
	int iHotspotOriginRow = Search2DA(HOTSPOTS_2DA, COL_HOTSPOT_TAG, sOriginHotspot);
	SetLocalInt(oPC, VAR_HOTSPOT_ORIGIN_ROW, iHotspotOriginRow);
	
	int iHotspotDestRow = Search2DA(HOTSPOTS_2DA, COL_HOTSPOT_TAG, sDestHotspot);
	SetLocalInt(oPC, VAR_HOTSPOT_DEST_ROW, iHotspotDestRow);
	

	// a connections list - contains info on connection between all hotspots
	// must include columns: OriginTag, DestinationTag, numTravelTime
	int iHotspotConnectionsRow = Search2DA2Col(HOTSPOT_CONNECTIONS_2DA, COL_ORIGIN_TAG, COL_DESTINATION_TAG, sOriginHotspot, sDestHotspot);
	SetLocalInt(oPC, VAR_HOTSPOT_CONNECTIONS_ROW, iHotspotConnectionsRow);
}
*/
void JumpParty(object oPartyMember, object oDestination)
{
    object oThisArea = GetArea(oPartyMember);
    object oJumper = GetFirstFactionMember(oPartyMember);

    while (GetIsObjectValid(oJumper))
    {
		PrettyDebug("Jumping " + GetName(oJumper) + " to " + GetTag(oDestination));
        AssignCommand(oJumper, JumpToObject(oDestination));
        oJumper = GetNextFactionMember(oPartyMember);
    }
}

// check if world map locked, various initializations	
int WorldMapReady(object oPC)
{
	if(!GetIsSinglePlayer())
	{
		if(GetWorldMapLocked())
		{
			SendMessageToPC(oPC, GetStringByStrRef(STRING_REF_MAP_LOCKED));
			return FALSE;
		}
		else
		{
			SetWorldMapLocked(); // locks it for a period of time
		}
	}
	return(TRUE);
}	


// sHotspotDestination - tag of the hotspot to travel to. 
// 2da lookups are used to get the associated module and waypoint tag to jump to.
void TravelToHotspot(object oPC, string sHotspots2DA, string sHotspotDestination)
{	
	if (sHotspotDestination == "")
	{
		PrettyError("TravelToHotspot() - sHotspotDestination is empty string ");
	}		
	//PrettyDebug("TravelToHotspot() - sHotspotDestination = " + sHotspotDestination);
	
	int iHotspotDestRow = GetHotspotRow(sHotspots2DA, sHotspotDestination); 
	//PrettyDebug("TravelToHotspot() - iHotspotDestRow = " + IntToString(iHotspotDestRow));

	string sHotspotDestWPTag = Get2DAString(sHotspots2DA, COL_WP_TAG, iHotspotDestRow); // with row we get the associated WP Tag
	string sHotspotDestModule = Get2DAString(sHotspots2DA, COL_MODULE, iHotspotDestRow); // ... and module
	//PrettyDebug("TravelToHotspot() - sHotspotDestWPTag = " + sHotspotDestWPTag);
	//PrettyDebug("TravelToHotspot() - sHotspotDestModule = " + sHotspotDestModule);
	object oDestination = GetObjectByTag(sHotspotDestWPTag); // and get the waypoint object.
	
	if(GetIsObjectValid(oDestination))
	{
		ForceRestParty( oPC );
		// BMA-OEI 6/14/06
		SinglePartyTransition( oPC, oDestination );
		//JumpPartyToArea(oPC, oDestination);
	}
	else
	{
		ForceRestParty( oPC );
		PrettyDebug("Unable to find waypoint in current module.  Initiating module transition.");
		PrettyDebug("Loading module. Destination = " + sHotspotDestModule);
		//LoadNewModule(sModule, sDestination);
		SaveRosterLoadModule(sHotspotDestModule, sHotspotDestWPTag);
	}
}


// Wrapper for ShowWorldMap().  This stores the origin and map name on the
// PC for later use by the various world map scripts.
// The world map scripts won't function properly if these vars are not saved on the PC.
void DoShowWorldMap(string sMap, object oPC, string sOrigin)
{
	// BMA-OEI 8/22/06 -- Autosave before transition
	if (GetGlobalInt(CAMPAIGN_SWITCH_WORLD_MAP_AUTO_SAVE))
		AttemptSinglePlayerAutoSave();

	// store map and origin on player for use w/ map scripts
	SetLocalString(oPC, VAR_WORLD_MAP_NAME, sMap);
	SetLocalString(oPC, VAR_WORLD_MAP_HOTSPOT_ORIGIN, sOrigin);
	ShowWorldMap(sMap, oPC, sOrigin );
}