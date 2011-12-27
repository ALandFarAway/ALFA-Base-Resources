////////////////////////////////////////////////////////////////////////////////
//
//  System Name : ALFA Core Rules
//     Filename : acr_srvadmin_i
//    $Revision:: 1          $ current version of the file
//        $Date:: 2011-12-26#$ date the file was created or modified
//       Author : Basilica
//
//    Var Prefix: SRVADMIN
//  Dependencies: NWNX, MYSQL, CLRSCRIPT(acr_srvadmin)
//
//  Description
//  This file contains logic for allowing server admins (both players and local
//  administrators) to issue extended utility commands.
//
//  Revision History
//  2011/12/26  Basilica    - Created.
//
////////////////////////////////////////////////////////////////////////////////

////////////////////////////////////////////////////////////////////////////////
// Includes ////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////
#include "acr_settings_i"
#include "acr_db_persist_i"
#include "acr_1984_i"

////////////////////////////////////////////////////////////////////////////////
// Constants ///////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////

const string ACR_SRVADMIN_RUNSCRIPTLET_PREFIX = "rs ";
const string ACR_SRVADMIN_RUNSCRIPT_PREFIX    = "runscript ";
const string ACR_SRVADMIN_SCRIPT_NAME         = "acr_srvadmin";

////////////////////////////////////////////////////////////////////////////////
// Structures //////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////

////////////////////////////////////////////////////////////////////////////////
// Global Variables ////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////

////////////////////////////////////////////////////////////////////////////////
// Function Prototypes /////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////

//! Handle a chat event that appears to be a server admin command.  If it is a
//  valid server admin command and the ACL check passes, then dispatch the
//  request.
//!  - oPC: the character that triggered the event; supply OBJECT_INVALID to
//          indicate that the local server administrator (at the console) made
//          the request.
//!  - sCmd: the command string after "#sa " or "!sa " (original casing).
//!  - Returns: TRUE if it was a recognized command.
int ACR_SrvAdmin_OnChat(object oPC, string sCmd);

//! Send feedback for a server admin command to the user.
//!  - oPC: the character that triggered the event; supply OBJECT_INVALID to
//          indicate that the local server administrator (at the console) made
//          the request.
//!  - sFeedback: the feedback string to send.
void ACR_SrvAdmin_SendFeedback(object oPC, string sFeedback);



////////////////////////////////////////////////////////////////////////////////
// Function Definitions ////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////

int ACR_SrvAdmin_OnChat(object oPC, string sCmd)
{
	// If we are not the console and not a bona fide server admin, take no
	// further actions.
	if (oPC != OBJECT_INVALID && !ACR_IsServerAdmin(oPC))
		return FALSE;

	string LowerCmd = GetStringLowerCase(sCmd);
	int Len = GetStringLength(sCmd);

	if (GetStringLeft(LowerCmd, 3) == ACR_SRVADMIN_RUNSCRIPTLET_PREFIX)
	{
		AddScriptParameterString(GetStringRight(sCmd, Len-3));
		ExecuteScriptEnhanced(ACR_SRVADMIN_SCRIPT_NAME, oPC);
		ACR_LogServerAdminCommand(oPC, sCmd);
		ACR_SrvAdmin_SendFeedback(oPC, "RunScriptlet(" + sCmd + ") completed.");
		return TRUE;
	}
	else if (GetStringLeft(LowerCmd, 10) == ACR_SRVADMIN_RUNSCRIPT_PREFIX)
	{
		ACR_LogServerAdminCommand(oPC, sCmd);
		ExecuteScriptEnhanced(GetStringRight(sCmd, Len-10), oPC);
		ACR_SrvAdmin_SendFeedback(oPC, "RunScript(" + sCmd + ") completed.");
		return TRUE;
	}

	return FALSE;
}

void ACR_SrvAdmin_SendFeedback(object oPC, string sFeedback)
{
	if (oPC == OBJECT_INVALID)
		WriteTimestampedLogEntry("SACMD: " + sFeedback);
	else
		SendMessageToPC(oPC, "SACMD: " + sFeedback);
}


