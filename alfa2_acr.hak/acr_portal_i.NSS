////////////////////////////////////////////////////////////////////////////////
//
//  System Name : ACR Portalling System
//     Filename : acr_portal_i
//      Version : 0.3
//         Date : 2/12/09
//       Author : AcadiusLost
//
//  Local Variable Prefix = ACR_PTL
//
//
//  Dependencies external of nwscript:
//   acr_time_i, NWNx4, xp_mysql plugin, connection to a valid MySQL database,
//   vault plugin for seamless portal support.
//
//  Description
//	  This file includes the functions which enable successful portalling
//	  between linked ALFA servers.  It uses cross-server persistent variables.
//
//  Revision History:
//   0.1: 1/19/2009, AcadiusLost inception.
//   0.2: 2/09/2009, AcadiusLost: various fixes
//   0.3: 2/11/2009, AcadiusLost: Added NormalizePC() and ReportInformation()
//	 0.4: 2/12/2009, AcadiusLost: Fixed check for correct destination on server
//	 0.5: 1/6/2012, Basilica: Added beginnings of seamless portal support.
////////////////////////////////////////////////////////////////////////////////

#ifndef ACR_PORTAL_I
#define ACR_PORTAL_I

////////////////////////////////////////////////////////////////////////////////
// Constants ///////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////

//! Determines the minimum number of real-life hours that must pass before a PC
//!  may portal again between servers.  This assists in countering server-hopping
//!  and helps maintain RP consistency for players on both servers.
const int ACR_PTL_COOLDOWN = 24;

//! Temporary p-variable to store data on the current portalling attempt.
const string _ACR_PTL_PASSPORT = "ACR_PTL_PASSPORT";

//! Persistent variable to record a PC's last successful server transition.
const string _ACR_PTL_RECORD = "ACR_PTL_RECORD";

//! Local String to cache a recent SQL timestamp on the mod.
const string _ACR_PTL_TIMESTAMP = "ACR_PTL_TIMESTAMP";

//! Local String to cache a recent SQL timestamp on the mod.
const string _ACR_PTL_PING = "ACR_PTL_PING";

////////////////////////////////////////////////////////////////////////////////
// Structures //////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////

////////////////////////////////////////////////////////////////////////////////
// Global Variables ////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////

////////////////////////////////////////////////////////////////////////////////
// Function Prototypes /////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////

//! Main function to issue a pass to the destination server.
//!  oPC: The PC who will be travelling to the new server.
//!  nDestServerID: The serverID of the destination server.
//!  nPortalNumber: the number of the portal (for multiple portals between the same servers)
//!  bAdjacent: Whether the destination server portal is meant to be geopraphically 
//!   adjacent to the departure server one (circumvents cooldown settings)
void ACR_PortalPC_Start(object oPC, int nDestServerID, int nPortalNumber, int bAdjacent=FALSE);

//! Function to check if a given server is online and
//!  accessible to the requesting player.
//!   nServerID: The ID# of the server to check.
//!   oPC: The character requesting to portal.
//!  returns: 	0 (The server is not available for use by oPC)
//!				1 (The server is available for use by oPC)
int ACR_PortalCheckServer(int nServerID, object oPC);

//! Function to check for a valid pass to portal to a server.
int ACR_PortalCheckPass(object oPC, int nServerID);

//! Function to check how long a PC must wait before
//!  being allowed to portal. (based on cooldown setting)
//!   
//!  returns: 	0 (The PC is valid to portal)
//!				1+ (number of RL hours till they will be valid)
int ACR_PortalCheckCooldown(object oTraveller);

//! Function to display server portalling information on a PC
//!  oTraveller: the PC who has travelled.
//!  oInquirer: the DM (presumably) who wants to know.
void ACR_PortalInformationReport(object oTraveller, object oInquirer);

//
//  Private functions
//

//! Private function to return number of RL hours between two time/dates in SQL 
//!  timestamp format.  SecondStamp > FirstStamp : positive #
int _GetHoursBetween(string sFirstStamp, string sSecondStamp);

//! Private function to return number of RL minutes between two time/dates in SQL 
//!  timestamp format.  SecondStamp > FirstStamp : positive #
int _GetMinutesBetween(string sFirstStamp, string sSecondStamp);

//! Private function to return a portal pass string
//!   nDestServerID: the number of the destination server
//!   nPortalNumber: the number of the portal (for multiple portals between the same servers)
//! Returns:  a string containing the origin and destination servers, plus portal number
//!   with format" 003_PortalTo_010_01"  For a portal pass from TSM to BG #1
//! On error: returns PORTAL_INVALID
string _BuildPortalPass(int nDestServerID, int nPortalNumber=1);

//! Private function to write a variable to the SQL DB to collect a timestamp
void _PingSQL();

//! Private function to obtain a current SQL timestamp from the database.  
//!  Returns the string timestamp in MySQL text format. Use after _PingSQL().
string _CheckSQLForTimeStamp();

////////////////////////////////////////////////////////////////////////////////
// Includes ////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////

#include "acr_time_i"
#include "acr_settings_i"
#include "acr_server_ipc_i"

////////////////////////////////////////////////////////////////////////////////
// Function Definitions ////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////

void ACR_PortalPC_Start(object oPC, int nDestServerID, int nPortalNumber, int bAdjacent)
{
	// Mark the passport for the player and send them on their way with a
	// seamless portal.  If the portal was adjacent, update the passport data
	// but do not move the last timestamp forward.  This, except for the PC's
	// first portal, allows the player to initiate a non-adjacent portal without
	// penalty.

	if (bAdjacent)
		ACR_SetPersistentStringNoTimestamp(oPC, _ACR_PTL_PASSPORT, _BuildPortalPass(nDestServerID, nPortalNumber));
	else
		ACR_SetPersistentString(oPC, _ACR_PTL_PASSPORT, _BuildPortalPass(nDestServerID, nPortalNumber));

	ACR_StartServerToServerPortal(nDestServerID, nPortalNumber, oPC);
}

int ACR_PortalCheckServer(int nServerID, object oPC) {

#if SERVER_IPC_ENABLED
	if(ACR_GetIsServerOnline(nServerID) == FALSE)
	{
		return FALSE;
	}
	if(ACR_GetIsMember(oPC))
	{
		return TRUE;
	}
	if (ACR_GetIsServerPublic(nServerID) == FALSE)
	{
		SendMessageToPC(oPC, "Your account is not yet approved for use on non-public servers.  Visit http://www.alandfaraway.org and click 'Joining ALFA' under the New Players menu to apply for full membership.");
		return FALSE;
	}
	return TRUE;
#else
	string sDestID = IntToString(nServerID);
	// join the Servers and pwdata tables to get the timestamp corresponding to nServerID.	
	ACR_SQLQuery("SELECT pwdata.Value, pwdata.Last, pwdata.Name, servers.ID, servers.Name FROM pwdata JOIN servers ON pwdata.Name = servers.Name WHERE servers.ID = '"+sDestID+"' AND pwdata.Key = '"+ACR_MODULE_TIME+"'");
	if (ACR_SQLFetch() != SQL_SUCCESS) {
		// no record of ACR_TIME_SERVERTIME for that ServerID, looks like the server is down (or never existed)
		return FALSE;
	} else {
		// A corresponding server timestamp was found. Just output this for now.
		string sLastTimestampUpdate = ACR_SQLGetData(1);
		string sDestServerCurrentName = ACR_SQLGetData(4);
		SetLocalString(GetModule(), _ACR_PTL_TIMESTAMP, sLastTimestampUpdate);
		return TRUE;
	}
#endif
}

int ACR_PortalCheckCooldown(object oTraveller) 
{
    int nTime = ACR_GetPersistentInt(oTraveller, _ACR_PTL_TIMESTAMP);
    if (nTime == 0) 
    {
        // PC appears to have never successfully ported before.  Clear to portal.
        SendMessageToPC(oTraveller, "No prior portalling attempt on record.  Portal at will.");
        return 0;
    } 
    else 
    {
        // check the former portalling record to see if it's recent.
        int nCurrentTime = ACR_GetGameHoursSinceStart();
        int nHoursSincePortal = FloatToInt(HoursToSeconds(nCurrentTime - nTime) / (60.0f * 60.0f));
        SendMessageToPC(oTraveller, "Estimated RL Hours since last portalling: "+IntToString(nHoursSincePortal));
        if (nHoursSincePortal > ACR_PTL_COOLDOWN) 
        {
            return 0;
        } 
        else 
        {
            return (24 - nHoursSincePortal);
        }
    }
}

//! Function to check for a valid pass to portal to a server.
int ACR_PortalCheckPass(object oPC, int nServerID) {

    // retrieve the portalling record from the database
    ACR_SQLQuery("SELECT Value, Last FROM pwdata WHERE Name='" + ACR_SQLEncodeSpecialChars(GetName(oPC)) + "' and Tag='" + ACR_GetPCPublicCDKey(oPC) + "' and `Key`='"+_ACR_PTL_PASSPORT+"'");
	if (ACR_SQLFetch() != SQL_SUCCESS) {
	    // there is no record of the PC's portalling pass.
		SendMessageToPC(oPC, "Portalling pass not found");
		return FALSE;
	} else {
		// Pass was retrieved. Get the data
		string sPass = ACR_SQLGetData(0);
		string sLast = ACR_SQLGetData(1);
		string sDay = GetSubString(sLast, 8, 2);
		int nPassDest = StringToInt(GetSubString(sPass, 13, 3));
		SetLocalString(oPC,  _ACR_PTL_PASSPORT, sPass);
		SendMessageToPC(oPC, "Pass found, Data: "+sPass+", written "+sLast+".");
		if (nPassDest == nServerID) {
			return TRUE;
		} else {
			return FALSE;
		}
	}
}

void ACR_PortalInformationReport(object oTraveller, object oInquirer) {
	SendMessageToPC(oInquirer, "Quarantine information on "+GetName(oTraveller)+":");
	SendMessageToPC(oInquirer, "-------------------------------");
	string sType, sLastServer;
	// Query for both a passport and a last portalling record. We would also like to know stored location (at least for server/area)
	ACR_SQLQuery("SELECT pwdata.Value, pwdata.Last, pwdata.Key, characters.ID, characters.ServerID, characters.Location FROM pwdata JOIN characters ON pwdata.Name = characters.Name WHERE characters.ID = '"+IntToString(ACR_GetCharacterID(oTraveller))+"' AND ( pwdata.Key = '"+_ACR_PTL_PASSPORT+"' OR pwdata.Key = '"+_ACR_PTL_RECORD+"') ORDER BY pwdata.Last");
	while (ACR_SQLFetch() == SQL_SUCCESS) {
		// records here could be either Passport or Portal Records.  Gather the info for reporting.
		if (sLastServer == "") {
			// this is the first record retrieved, collect general info on the PC from this record
			sLastServer = ACR_SQLGetData(4);
			SendMessageToPC(oInquirer, "Current ServerID = "+sLastServer+", Last valid saved location was "+ACR_SQLGetData(5));
		}
		sType = ACR_SQLGetData(2);
		if ( sType == _ACR_PTL_RECORD) {
			// got a portalling record here.
			SendMessageToPC(oInquirer, ACR_SQLGetData(0)+" on "+ACR_SQLGetData(1)+".");
		} else if ( sType == _ACR_PTL_PASSPORT ) {
			// Current portalling passport
			SendMessageToPC(oInquirer, "Current Passport: "+ACR_SQLGetData(0)+" generated "+ACR_SQLGetData(1)+".");
		}
	}
	SendMessageToPC(oInquirer, "       ");
	SendMessageToPC(oInquirer, "       ");		
}






int _GetHoursBetween(string sFirstStamp, string sSecondStamp) {

	int nDay1 = StringToInt(GetSubString(sFirstStamp, 8, 2));
	int nDay2 = StringToInt(GetSubString(sSecondStamp, 8, 2));
	int nHour1 = StringToInt(GetSubString(sFirstStamp, 11, 2));
	int nHour2 = StringToInt(GetSubString(sSecondStamp, 11, 2));
	int nMonth1 = StringToInt(GetSubString(sFirstStamp, 5, 2));
	int nMonth2 = StringToInt(GetSubString(sSecondStamp, 5, 2));
	int nYear1 = StringToInt(GetSubString(sFirstStamp, 0, 4));
	int nYear2 = StringToInt(GetSubString(sSecondStamp, 0, 4));
	int nTotal1 = (8760 * nYear1) + (720 * nMonth1) +(24 * nDay1) + nHour1;
	int nTotal2 = (8760 * nYear2) + (720 * nMonth2) +(24 * nDay2) + nHour2;
	
	return (nTotal2 - nTotal1);
}

int _GetMinutesBetween(string sFirstStamp, string sSecondStamp) {

	int nDay1 = StringToInt(GetSubString(sFirstStamp, 8, 2));
	int nDay2 = StringToInt(GetSubString(sSecondStamp, 8, 2));
	int nHour1 = StringToInt(GetSubString(sFirstStamp, 11, 2));
	int nHour2 = StringToInt(GetSubString(sSecondStamp, 11, 2));
	int nMonth1 = StringToInt(GetSubString(sFirstStamp, 5, 2));
	int nMonth2 = StringToInt(GetSubString(sSecondStamp, 5, 2));
	int nYear1 = StringToInt(GetSubString(sFirstStamp, 0, 4));
	int nYear2 = StringToInt(GetSubString(sSecondStamp, 0, 4));
	int nTotal1 = (8760 * nYear1) + (720 * nMonth1) +(24 * nDay1) + nHour1;
	nTotal1 = (nTotal1 * 60) + StringToInt(GetSubString(sFirstStamp, 14, 2));
	int nTotal2 = (8760 * nYear2) + (720 * nMonth2) +(24 * nDay2) + nHour2;
	nTotal2 = (nTotal2 * 60) + StringToInt(GetSubString(sSecondStamp, 14, 2));
	
	return (nTotal2 - nTotal1);
}

//! Private function to return a portal pass string
string _BuildPortalPass(int nDestServerID, int nPortalNumber=1) {

	
	string sServerID = IntToString(ACR_GetServerId());
	if (GetStringLength(sServerID) == 1) {
		sServerID = "00"+sServerID;
	} else if (GetStringLength(sServerID) == 2) {
		sServerID = "0"+sServerID;
	}
	string sPass = sServerID + "_PortalTo_";
	// repeat the process for the destination server
	sServerID = IntToString(nDestServerID);
	if (GetStringLength(sServerID) == 1) {
		sServerID = "00"+sServerID;
	} else if (GetStringLength(sServerID) == 2) {
		sServerID = "0"+sServerID;
	}
	sPass += sServerID + "_";
	// now add on the Portal number.
	string sPortal = IntToString(nPortalNumber);
	if (GetStringLength(sPortal) == 1) {
		sPortal = "0"+sPortal;
	}
	sPass += sPortal;
	
	if (GetStringLength(sPass) == 19) {
		// correct length, return pass
		return sPass;
	} else {
		return "PORTAL_INVALID";
	}
}

void _PingSQL() {
	// writes (or updates) a record in pwdata to check for a timestamp later
	ACR_SetPersistentInt(GetModule(), _ACR_PTL_PING, Random(900));	
}

string _CheckSQLForTimeStamp() {

	object oMod = GetModule();
	ACR_SQLQuery("SELECT Value, Last, Name FROM pwdata WHERE Name = '"+ACR_SQLEncodeSpecialChars(GetName(oMod))+"' AND pwdata.Key = '"+_ACR_PTL_PING+"'");
	if (ACR_SQLFetch() != SQL_SUCCESS) {
		return "";
	} else {
		return ACR_SQLGetData(1);
	}
}

#endif