////////////////////////////////////////////////////////////////////////////////
//
//  System Name : ALFA Core Rules
//     Filename : acr_server_misc_i
//    $Revision:: 1          $ current version of the file
//        $Date:: 2012-01-08#$ date the file was created or modified
//       Author : Basilica
//
//    Var Prefix: SERVER_MISC
//  Dependencies: NWNX, MYSQL, CLRSCRIPT(acr_servermisc)
//
//  Description
//  This file contains logic for interfacing with the miscellaneous support
//  C# script (acr_servermisc).
//
//  Revision History
//  2012/01/08  Basilica    - Created.
//  2012/01/19  Basilica    - Added area instancing support.
//
////////////////////////////////////////////////////////////////////////////////

////////////////////////////////////////////////////////////////////////////////
// Includes ////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////

////////////////////////////////////////////////////////////////////////////////
// Constants ///////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////

// The server misc support script name.
const string ACR_SERVER_MISC_SUPPORT_SCRIPT                  = "acr_servermisc";

// The local variable (type object) used to return data from the support script.
const string ACR_SERVER_MISC_OBJECT_RETVAL_VAR               = "ACR_SERVER_MISC_RETURN_OBJECT";

// Commands for the server misc C# script:

// This command runs the updater script for the server, if one is defined.
const int ACR_SERVER_MISC_EXECUTE_UPDATER_SCRIPT             = 0;

// This command creates an instanced area.
const int ACR_SERVER_MISC_CREATE_AREA_INSTANCE               = 1;

// This command releases an instanced area.
const int ACR_SERVER_MISC_RELEASE_AREA_INSTANCE              = 2;

////////////////////////////////////////////////////////////////////////////////
// Structures //////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////

////////////////////////////////////////////////////////////////////////////////
// Global Variables ////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////

////////////////////////////////////////////////////////////////////////////////
// Function Prototypes /////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////

//! Execute the server's updater script, if one is defined.
//!  - Returns: TRUE if the updater was launched.
int ACR_ExecuteServerUpdaterScript();

//! Create an instanced area.  If an available instance in the free pool can be
//  found, it will be reused.
//!  - TemplateArea: Supplies the area that serves as the template for the new
//                   instanced area.
//!  - Returns: The area instance, else OBJECT_INVALID on failure.
object ACR_InternalCreateAreaInstance(object TemplateArea);

//! Release an instanced area.  It will be put back onto the free list of the
//  area supports free list pooling, otherwise the area is deleted.
//!  - InstancedArea: Supplies the area instance to release.
void ACR_InternalReleaseAreaInstance(object InstancedArea);

//! Make a raw call to the support script.
//!  - Command: Supplies the command to request (e.g. ACR_SERVER_MISC_EXECUTE_UPDATER_SCRIPT).
//!  - P0: Supplies the first command-specific parameter.
//!  - P1: Supplies the second command-specific parameter.
//!  - P2: Supplies the third command-specific parameter.
//!  - P3: Supplies the fourth command-specific parameter.
//!  - P4: Supplies the fifth command-specific parameter.
//!  - ObjectSelf: Supplies the OBJECT_SELF to run the script on.
//!  - Returns: The command-specific return code is returned.
int ACR_CallServerMiscScript(int Command, int P0, int P1, string P2, string P3, object P4, object ObjectSelf = OBJECT_SELF);

////////////////////////////////////////////////////////////////////////////////
// Function Definitions ////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////

int ACR_ExecuteServerUpdaterScript()
{
	return ACR_CallServerMiscScript(
		ACR_SERVER_MISC_EXECUTE_UPDATER_SCRIPT,
		0,
		0,
		"",
		"",
		OBJECT_INVALID);
}

object ACR_InternalCreateAreaInstance(object TemplateArea)
{
	if (ACR_CallServerMiscScript(
		ACR_SERVER_MISC_CREATE_AREA_INSTANCE,
		0,
		0,
		"",
		"",
		TemplateArea) == FALSE)
	{
		return OBJECT_INVALID;
	}

	object Module = GetModule();
	object InstancedArea = GetLocalObject(Module, ACR_SERVER_MISC_OBJECT_RETVAL_VAR);
	DeleteLocalObject(Module, ACR_SERVER_MISC_OBJECT_RETVAL_VAR);

	return InstancedArea;
}

void ACR_InternalReleaseAreaInstance(object InstancedArea)
{
	ACR_CallServerMiscScript(
		ACR_SERVER_MISC_RELEASE_AREA_INSTANCE,
		0,
		0,
		"",
		"",
		InstancedArea);
}

int ACR_CallServerMiscScript(int Command, int P0, int P1, string P2, string P3, object P4, object ObjectSelf = OBJECT_SELF)
{
	AddScriptParameterInt(Command);
	AddScriptParameterInt(P0);
	AddScriptParameterInt(P1);
	AddScriptParameterString(P2);
	AddScriptParameterString(P3);
	AddScriptParameterObject(P4);

	return ExecuteScriptEnhanced(ACR_SERVER_MISC_SUPPORT_SCRIPT, ObjectSelf, TRUE);
}

