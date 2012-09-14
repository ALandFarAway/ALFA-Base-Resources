////////////////////////////////////////////////////////////////////////////////
//
//  System Name : ALFA Core Rules
//     Filename : acr_srvadmin_i
//    $Revision:: 1          $ current version of the file
//        $Date:: 2011-12-26#$ date the file was created or modified
//       Author : Basilica
//
//    Var Prefix: SRVADMIN
//  Dependencies: NWNX, MYSQL, CLRSCRIPT(ScriptLoader, ACR_ServerMisc)
//
//  Description
//  This file contains logic for allowing server admins (both players and local
//  administrators) to issue extended utility commands.
//
//  Revision History
//  2011/12/26  Basilica    - Created.
//  2012/01/07  Basilica    - Added #sa runupdater command.
//
////////////////////////////////////////////////////////////////////////////////

////////////////////////////////////////////////////////////////////////////////
// Includes ////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////
#include "acr_settings_i"
#include "acr_db_persist_i"
#include "acr_1984_i"
#include "acr_server_misc_i"

////////////////////////////////////////////////////////////////////////////////
// Constants ///////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////

const string ACR_SRVADMIN_RUNSCRIPTLET_PREFIX = "rs ";
const string ACR_SRVADMIN_RUNSCRIPT_PREFIX    = "runscript ";
const string ACR_SRVADMIN_GETGLOBALI_PREFIX   = "getglobalint ";
const string ACR_SRVADMIN_GETGLOBALF_PREFIX   = "getglobalfloat ";
const string ACR_SRVADMIN_GETGLOBALS_PREFIX   = "getglobalstring ";
const string ACR_SRVADMIN_GETMODULEI_PREFIX   = "getmoduleint ";
const string ACR_SRVADMIN_GETMODULEF_PREFIX   = "getmodulefloat ";
const string ACR_SRVADMIN_GETMODULES_PREFIX   = "getmodulestring ";
const string ACR_SRVADMIN_GETMODULEO_PREFIX   = "getmoduleobject ";
const string ACR_SRVADMIN_LOADSCRIPT_PREFIX   = "loadscript ";
const string ACR_SRVADMIN_BOOT_PREFIX         = "boot ";
const string ACR_SRVADMIN_DUMPVARS_PREFIX     = "dumpvars ";
const string ACR_SRVADMIN_DUMPAREAS_PREFIX    = "dumpareas";
const string ACR_SRVADMIN_DUMPAREAOBJECTS_PREFIX = "dumpareaobjects ";
const string ACR_SRVADMIN_RUNUPDATER_PREFIX   = "runupdater";
const string ACR_SRVADMIN_JUMP_PREFIX         = "jump ";

const string ACR_SRVADMIN_SCRIPT_NAME         = "acr_srvadmin";
const string ACR_SRVADMIN_SCRIPTLOADER_NAME   = "scriptloader";

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

//! Perform a strncmp operation (counted left string compare).
//!  - str: The string to compare the prefix of.
//!  - prefix: The prefix to check for (case sensitive).
//!  - Returns: TRUE if str is prefixed with prefix (case sensitive).
int ACR_IsStrPrefix(string str, string prefix);

//! Log a command to the audit log
//!  - oPC: The initiator of the command, or OBJECT_INVALID if it came from the
//          console.
//!  - sCmd: The command text.
void ACR_SrvAdmin_LogCommand(object oPC, string sCmd);

//! Format an object for feedback display.
//!  - oObjToDump: The object to dump.
//!  - Returns: The formatted object description.
string ACR_SrvAdmin_DumpObject(object oObjToDump);

//! Get the type name of an object.
//!  - oObj: The object to get the type name for.
//! - Returns: The type name of the object.
string ACR_SrvAdmin_GetObjectTypeName(object oObj);

//! Dump the variable list of an object.
//!  - oPC: The person to send the dump to (or else OBJECT_INVALID to write to
//          the server log).
//!  - oObj: The object to dump variables for.
void ACR_SrvAdmin_DumpVariables(object oPC, object oObj);

//! List the objects in an area.
//!  - oPC: The person to send the dump to (or else OBJECT_INVALID to write to
//          the server log).
//!  - oArea: The area to dump objects for.
void ACR_SrvAdmin_DumpAreaObjects(object oPC, object oArea);

//! Map an object name to an object.  The name may be a raw hex objectid,
//  an object tag, or else the special values #module (GetModule()) or
//  #self (OBJECT_SELF) or #area (GetArea(OBJECT_SELF)).
//!  - sObjName: The object name to translate.
//!  - oSelf: Supplies the self object to use if it is required.
//!  - Returns: The object is returned, else OBJECT_INVALID if there was no
//!             mapping.
object ACR_SrvAdmin_TranslateObject(string sObjName, object oSelf);

////////////////////////////////////////////////////////////////////////////////
// Function Definitions ////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////

int ACR_SrvAdmin_OnChat(object oPC, string sCmd)
{
	object oAdmin = oPC, oTmp;

	// If we are not the console and not a bona fide server admin, take no
	// further actions.
	if (oPC != OBJECT_INVALID)
	{
		// Confirm that the server admin is not possessing a NPC
		oTmp = GetOwnedCharacter(oPC);

		if (GetIsObjectValid(oTmp))
			oAdmin = oTmp;

		if (!ACR_IsServerAdmin(oAdmin))
			return FALSE;
	}

	string LowerCmd = GetStringLowerCase(sCmd);
	int Len = GetStringLength(sCmd);

	if (GetStringLeft(LowerCmd, 3) == ACR_SRVADMIN_RUNSCRIPTLET_PREFIX)
	{
		ACR_IncrementStatistic("SA_RUN_POWERSHELL");
		ACR_RunPowerShellScriptlet(GetStringRight(sCmd, Len-3), oPC);
		ACR_SrvAdmin_LogCommand(oAdmin, sCmd);
		ACR_SrvAdmin_SendFeedback(oPC, "RunScriptlet(" + sCmd + ") completed.");
		return TRUE;
	}
	else if (GetStringLeft(LowerCmd, 10) == ACR_SRVADMIN_RUNSCRIPT_PREFIX)
	{
		ACR_IncrementStatistic("SA_RUN_SCRIPT");
		ACR_SrvAdmin_LogCommand(oAdmin, sCmd);
		ExecuteScriptEnhanced(GetStringRight(sCmd, Len-10), oPC);
		ACR_SrvAdmin_SendFeedback(oPC, "RunScript(" + sCmd + ") completed.");
		return TRUE;
	}
	else if (ACR_IsStrPrefix(LowerCmd, ACR_SRVADMIN_GETGLOBALI_PREFIX))
	{
		int Value = GetGlobalInt(GetStringRight(sCmd, Len-GetStringLength(ACR_SRVADMIN_GETGLOBALI_PREFIX)));
		ACR_SrvAdmin_LogCommand(oAdmin, sCmd);
		ACR_SrvAdmin_SendFeedback(oPC, "GetGlobalInt(" + sCmd + ") == " + IntToString(Value));
		return TRUE;
	}
	else if (ACR_IsStrPrefix(LowerCmd, ACR_SRVADMIN_GETGLOBALF_PREFIX))
	{
		float Value = GetGlobalFloat(GetStringRight(sCmd, Len-GetStringLength(ACR_SRVADMIN_GETGLOBALF_PREFIX)));
		ACR_SrvAdmin_LogCommand(oAdmin, sCmd);
		ACR_SrvAdmin_SendFeedback(oPC, "GetGlobalFloat(" + sCmd + ") == " + FloatToString(Value));
		return TRUE;
	}
	else if (ACR_IsStrPrefix(LowerCmd, ACR_SRVADMIN_GETGLOBALS_PREFIX))
	{
		string Value = GetGlobalString(GetStringRight(sCmd, Len-GetStringLength(ACR_SRVADMIN_GETGLOBALS_PREFIX)));
		ACR_SrvAdmin_LogCommand(oAdmin, sCmd);
		ACR_SrvAdmin_SendFeedback(oPC, "GetGlobalString(" + sCmd + ") == " + Value);
		return TRUE;
	}
	else if (ACR_IsStrPrefix(LowerCmd, ACR_SRVADMIN_GETMODULEI_PREFIX))
	{
		int Value = GetLocalInt(GetModule(), GetStringRight(sCmd, Len-GetStringLength(ACR_SRVADMIN_GETMODULEI_PREFIX)));
		ACR_SrvAdmin_LogCommand(oAdmin, sCmd);
		ACR_SrvAdmin_SendFeedback(oPC, "GetModuleInt(" + sCmd + ") == " + IntToString(Value));
		return TRUE;
	}
	else if (ACR_IsStrPrefix(LowerCmd, ACR_SRVADMIN_GETMODULEF_PREFIX))
	{
		float Value = GetLocalFloat(GetModule(), GetStringRight(sCmd, Len-GetStringLength(ACR_SRVADMIN_GETMODULEF_PREFIX)));
		ACR_SrvAdmin_LogCommand(oAdmin, sCmd);
		ACR_SrvAdmin_SendFeedback(oPC, "GetModuleFloat(" + sCmd + ") == " + FloatToString(Value));
		return TRUE;
	}
	else if (ACR_IsStrPrefix(LowerCmd, ACR_SRVADMIN_GETMODULES_PREFIX))
	{
		string Value = GetLocalString(GetModule(), GetStringRight(sCmd, Len-GetStringLength(ACR_SRVADMIN_GETMODULES_PREFIX)));
		ACR_SrvAdmin_LogCommand(oAdmin, sCmd);
		ACR_SrvAdmin_SendFeedback(oPC, "GetModuleString(" + sCmd + ") == " + Value);
		return TRUE;
	}
	else if (ACR_IsStrPrefix(LowerCmd, ACR_SRVADMIN_GETMODULEO_PREFIX))
	{
		object Value = GetLocalObject(GetModule(), GetStringRight(sCmd, Len-GetStringLength(ACR_SRVADMIN_GETMODULEO_PREFIX)));
		ACR_SrvAdmin_LogCommand(oAdmin, sCmd);
		ACR_SrvAdmin_SendFeedback(oPC, "GetModuleObject(" + sCmd + ") == " + ObjectToString(Value) + " <" + GetName(Value) + ">");
		ACR_SrvAdmin_SendFeedback(oPC, ACR_SrvAdmin_DumpObject(Value));
		return TRUE;
	}
	else if (ACR_IsStrPrefix(LowerCmd, ACR_SRVADMIN_LOADSCRIPT_PREFIX))
	{
		string ScriptFileName = GetStringRight(sCmd, Len-GetStringLength(ACR_SRVADMIN_LOADSCRIPT_PREFIX));
		ACR_IncrementStatistic("SA_LOAD_SCRIPT");
		AddScriptParameterString(ScriptFileName);
		ExecuteScriptEnhanced(ACR_SRVADMIN_SCRIPTLOADER_NAME, oPC);
		ACR_SrvAdmin_LogCommand(oAdmin, sCmd);
		ACR_SrvAdmin_SendFeedback(oPC, "LoadScript(" + sCmd + ") completed.");
		return TRUE;
	}
	else if (ACR_IsStrPrefix(LowerCmd, ACR_SRVADMIN_BOOT_PREFIX))
	{
		string AccountName = GetStringLowerCase(GetStringRight(sCmd, Len-GetStringLength(ACR_SRVADMIN_BOOT_PREFIX)));
		object TargetPC;
		int Found = FALSE;

		TargetPC = GetFirstPC();
		while (TargetPC != OBJECT_INVALID)
		{
			if (GetStringLowerCase(GetPCPlayerName(TargetPC)) == AccountName)
			{
				BootPC(TargetPC);
				Found = TRUE;
				break;
			}

			TargetPC = GetNextPC();
		}

		ACR_SrvAdmin_LogCommand(oAdmin, sCmd);

		if (Found)
			ACR_SrvAdmin_SendFeedback(oPC, "Booted " + AccountName + ".");
		else
			ACR_SrvAdmin_SendFeedback(oPC, "Player not found: " + AccountName + ".");

		return TRUE;
	}
	else if (ACR_IsStrPrefix(LowerCmd, ACR_SRVADMIN_DUMPVARS_PREFIX))
	{
		string ObjectName = GetStringRight(sCmd, Len-GetStringLength(ACR_SRVADMIN_DUMPVARS_PREFIX));
		object Obj = ACR_SrvAdmin_TranslateObject(ObjectName, oPC);

		ACR_SrvAdmin_LogCommand(oAdmin, sCmd);

		if (!GetIsObjectValid(Obj))
			ACR_SrvAdmin_SendFeedback(oPC, "Object " + ObjectName + " was not valid.  Specify a valid object tag, an object id (hex), or #module or #self.");
		else
			ACR_SrvAdmin_DumpVariables(oPC, Obj);

		return TRUE;
	}
	else if (LowerCmd == ACR_SRVADMIN_DUMPAREAS_PREFIX)
	{
		object Area = GetFirstArea();

		ACR_SrvAdmin_LogCommand(oAdmin, sCmd);

		while (Area != OBJECT_INVALID)
		{
			ACR_SrvAdmin_SendFeedback(oPC, ACR_SrvAdmin_DumpObject(Area));
			Area = GetNextArea();
		}

		return TRUE;
	}
	else if (ACR_IsStrPrefix(LowerCmd, ACR_SRVADMIN_DUMPAREAOBJECTS_PREFIX))
	{
		object Area = ACR_SrvAdmin_TranslateObject(GetStringRight(sCmd, Len-GetStringLength(ACR_SRVADMIN_DUMPAREAOBJECTS_PREFIX)), oPC);

		ACR_SrvAdmin_LogCommand(oAdmin, sCmd);

		if (Area == OBJECT_INVALID)
			ACR_SrvAdmin_SendFeedback(oPC, "Invalid area specified.");
		else
		{
			ACR_SrvAdmin_SendFeedback(oPC, "Dumping objects for area: " + GetName(Area));
			ACR_SrvAdmin_DumpAreaObjects(oPC, Area);
		}

		return TRUE;
	}
	else if (LowerCmd == ACR_SRVADMIN_RUNUPDATER_PREFIX)
	{
		ACR_SrvAdmin_LogCommand(oAdmin, sCmd);
		ACR_IncrementStatistic("SA_RUN_UPDATER");

		if (ACR_ExecuteServerUpdaterScript())
			ACR_SrvAdmin_SendFeedback(oPC, "Successfully launched updater.");
		else
			ACR_SrvAdmin_SendFeedback(oPC, "Failed to launch updater.");

		return TRUE;
	}
	else if (ACR_IsStrPrefix(LowerCmd, ACR_SRVADMIN_JUMP_PREFIX))
	{
		object Target = ACR_SrvAdmin_TranslateObject(GetStringRight(sCmd, Len-GetStringLength(ACR_SRVADMIN_JUMP_PREFIX)), oPC);

		ACR_SrvAdmin_LogCommand(oAdmin, sCmd);

		if (oPC == OBJECT_INVALID)
		{
			ACR_SrvAdmin_SendFeedback(oPC, "This command cannot be used from the console.");
			return TRUE;
		}

		if (!GetIsObjectValid(Target))
		{
			ACR_SrvAdmin_SendFeedback(oPC, "That is not a valid object.");
			return TRUE;
		}

		AssignCommand(oPC, JumpToObject(Target));
		return TRUE;
	}
	else
	{
		ACR_SrvAdmin_SendFeedback(oPC, "Unrecognized command.  Legal commands include:");
		ACR_SrvAdmin_SendFeedback(oPC, " - rs <scriptlet> : Run a PowerShell/NWScript scriptlet.  The $s object can be used to access NWScript functions, like $s.SendMessageToPC($OBJECT_SELF, 'Message');.  The $sql object (an ALFA.Database) can be used to make database accesses.  The $CreatureAI object can be used to interface with the creature AI systme.");
		ACR_SrvAdmin_SendFeedback(oPC, " - runscript <scriptname> : Run a script by name.");
		ACR_SrvAdmin_SendFeedback(oPC, " - getglobalint <var> : Read a variable.");
		ACR_SrvAdmin_SendFeedback(oPC, " - getglobalfloat <var> : Read a variable.");
		ACR_SrvAdmin_SendFeedback(oPC, " - getglobalstring <var> : Read a variable.");
		ACR_SrvAdmin_SendFeedback(oPC, " - getmoduleint <var> : Read a variable.");
		ACR_SrvAdmin_SendFeedback(oPC, " - getmodulefloat <var> : Read a variable.");
		ACR_SrvAdmin_SendFeedback(oPC, " - getmodulestring <var> : Read a variable.");
		ACR_SrvAdmin_SendFeedback(oPC, " - getmoduleobject <var> : Read a variable.");
		ACR_SrvAdmin_SendFeedback(oPC, " - loadscript <C# Script DLL Path> : Load a C# script assembly and call its main function.");
		ACR_SrvAdmin_SendFeedback(oPC, " - boot <accountname> : Boot a PC by account name (insensitive).");
		ACR_SrvAdmin_SendFeedback(oPC, " - dumpvars <object> : Dump variables on an object (by hex object id, tag, #module, #self, or #area).");
		ACR_SrvAdmin_SendFeedback(oPC, " - dumpareas : Dump a list of areas in the module.");
		ACR_SrvAdmin_SendFeedback(oPC, " - dumpareaobjects <area> : Dump objects in an area (area specified by hex object id, tag, #module, #self, or #area).");
		ACR_SrvAdmin_SendFeedback(oPC, " - runupdater : Run the ACR_UpdaterScript.cmd batch file in the NWNX4 installation directory (if it exists).");
		ACR_SrvAdmin_SendFeedback(oPC, " - jump <object> : Jump to an object (by hex object id or tag).");

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

int ACR_IsStrPrefix(string str, string prefix)
{
	int len = GetStringLength(prefix);

	return GetStringLeft(str,len) == prefix;
}

void ACR_SrvAdmin_LogCommand(object oPC, string sCmd)
{
	string Name;

	if (oPC == OBJECT_INVALID)
		Name = "Server console";
	else
		Name = GetName(oPC) + " (" + GetPCPlayerName(oPC) + ")";

	WriteTimestampedLogEntry("SA: " + Name + " used SA command: " + sCmd);

	// ACR_LogServerAdminCommand(oPC, sCmd);
}

string ACR_SrvAdmin_DumpObject(object oObjToDump)
{
	string Message;
	vector Position;

	Position = GetPosition(oObjToDump);

	Message = ACR_SrvAdmin_GetObjectTypeName(oObjToDump) + " " + ObjectToString(oObjToDump) + " named " + GetName(oObjToDump);
	Message += " tag: " + GetTag(oObjToDump);
	Message += " area: " + ObjectToString(GetArea(oObjToDump)) + " (" + GetName(GetArea(oObjToDump)) + ")";
	Message += " position: [" + FloatToString(Position.x) + ", " + FloatToString(Position.y) + ", " + FloatToString(Position.z) + "]";
	Message += " facing: " + FloatToString(GetFacing(oObjToDump));
	Message += " AILevel: " + IntToString(GetAILevel(oObjToDump));
	Message += " template: " + GetResRef(oObjToDump);

	return Message;
}

string ACR_SrvAdmin_GetObjectTypeName(object oObj)
{
	switch (GetObjectType(oObj))
	{

	case OBJECT_TYPE_CREATURE:
		return "OBJECT_TYPE_CREATURE";
	case OBJECT_TYPE_ITEM:
		return "OBJECT_TYPE_ITEM";
	case OBJECT_TYPE_TRIGGER:
		return "OBJECT_TYPE_TRIGGER";
	case OBJECT_TYPE_DOOR:
		return "OBJECT_TYPE_DOOR";
	case OBJECT_TYPE_AREA_OF_EFFECT:
		return "OBJECT_TYPE_AREA_OF_EFFECT";
	case OBJECT_TYPE_WAYPOINT:
		return "OBJECT_TYPE_WAYPOINT";
	case OBJECT_TYPE_PLACEABLE:
		return "OBJECT_TYPE_PLACEABLE";
	case OBJECT_TYPE_STORE:
		return "OBJECT_TYPE_STORE";
	case OBJECT_TYPE_ENCOUNTER:
		return "OBJECT_TYPE_ENCOUNTER";
	case OBJECT_TYPE_LIGHT:
		return "OBJECT_TYPE_LIGHT";
	case OBJECT_TYPE_PLACED_EFFECT:
		return "OBJECT_TYPE_PLACED_EFFECT";

	}

	if (oObj == GetModule())
		return "OBJECT_TYPE_MODULE";
	else if (GetAreaSize(AREA_HEIGHT, oObj) > 0)
		return "OBJECT_TYPE_AREA";

	return "OBJECT_TYPE_INVALID";
}

void ACR_SrvAdmin_DumpVariables(object oPC, object oObj)
{
	int VarCount = GetVariableCount(oObj);
	int Var;

	for (Var = 0; Var < VarCount; Var += 1)
	{
		string VarDesc = "Var[" + IntToString(Var) + "] (" + GetVariableName(oObj, Var) + "): ";

		switch (GetVariableType(oObj, Var))
		{

		case VARIABLE_TYPE_NONE:
			VarDesc += "<none>";
			break;

		case VARIABLE_TYPE_INT:
			VarDesc += "(int) " + IntToString(GetVariableValueInt(oObj, Var));
			break;

		case VARIABLE_TYPE_FLOAT:
			VarDesc += "(float) " + FloatToString(GetVariableValueFloat(oObj, Var));
			break;

		case VARIABLE_TYPE_STRING:
			VarDesc += "(string) " + GetVariableValueString(oObj, Var);
			break;

		case VARIABLE_TYPE_DWORD:
			VarDesc += "(object) " + ACR_SrvAdmin_DumpObject(GetVariableValueObject(oObj, Var));
			break;

		case VARIABLE_TYPE_LOCATION:
			{
				location l = GetVariableValueLocation(oObj, Var);

				VarDesc += "(location) " + ACR_LocationToString(l);
			}
			break;

		}

		ACR_SrvAdmin_SendFeedback(oPC, VarDesc);
	}
}

void ACR_SrvAdmin_DumpAreaObjects(object oPC, object oArea)
{
	object Obj;

	Obj = GetFirstObjectInArea(oArea);

	while (Obj != OBJECT_INVALID)
	{
		ACR_SrvAdmin_SendFeedback(oPC, ACR_SrvAdmin_DumpObject(Obj));
		Obj = GetNextObjectInArea(oArea);
	}
}

object ACR_SrvAdmin_TranslateObject(string sObjName, object oSelf)
{
	object Obj;

	if (sObjName == "#module")
		Obj = GetModule();
	else if (sObjName == "#self")
		Obj = oSelf;
	else if (sObjName == "#area")
		Obj = GetArea(oSelf);
	else
	{
		Obj = IntToObject(HexStringToInt(sObjName) & 0x7FFFFFFF);

		if (!GetIsObjectValid(Obj))
		{
			Obj = GetObjectByTag(sObjName);
		}
	}

	if (!GetIsObjectValid(Obj))
		Obj = OBJECT_INVALID;

	return Obj;
}

