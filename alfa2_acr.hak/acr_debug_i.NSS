////////////////////////////////////////////////////////////////////////////////
//
//  System Name : ALFA Core Scripts
//     Filename : acr_debug_i
//      Version : 0.1
//         Date : 4/6/06
//       Author : Ronan
//
//  Local Variable Prefix = ACR_BUG
//
//  Description
//  These scripts provide tools to configure and run the debugging system.
//
//  Revision History
//  2011/04/19 Zelknolf: Fixing function declarations
////////////////////////////////////////////////////////////////////////////////

#ifndef ACR_DEBUG_I
#define ACR_DEBUG_I

// This include must be done prematurely due to dependent constants.
#include "acr_tools_i"

////////////////////////////////////////////////////////////////////////////////
// Constants ///////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////

// Do not print debug messages anywhere.
const int DEBUG_TARGET_NONE =   0;
// Print debug messages to all DMs.
const int DEBUG_TARGET_DMS =    BIT_1;
// Print debug messages to all PCs.
const int DEBUG_TARGET_PCS =    BIT_2;
// Print debug messages to logfile.
const int DEBUG_TARGET_LOG =    BIT_3;
// Print debug messages to a database.
const int DEBUG_TARGET_DB =     BIT_4;
// Speak debug messages in the talk channel.
const int DEBUG_TARGET_TALK =   BIT_5;
// Shout the debug message across the server.
const int DEBUG_TARGET_SHOUT =  BIT_6;

// Signifies a fatal error, keeping the associated system from performing its
// task.
const int DEBUG_LEVEL_FATAL = 1;

// Signifies a non-fatal error or odd behavior, which does not keep the
// associated system from performing its task.
const int DEBUG_LEVEL_WARNING = 2;

// Signifies general debugging information, not any sort of odd behavior or
// error.
const int DEBUG_LEVEL_INFO = 3;

// The prefix of all debug messages by level,
string _DEBUG_MESSAGE_PREFIX_FATAL = "ERROR: ";
string _DEBUG_MESSAGE_PREFIX_WARNING = "Warning: ";
string _DEBUG_MESSAGE_PREFIX_INFO = "";

string _DEBUG_SYSTEMS_LSA = "ACR_BUG_S_";

string _DEBUG_TARGETS_INFO_LI = "ACR_BUG_IT_";
string _DEBUG_TARGETS_WARNING_LI = "ACR_BUG_WT_";
string _DEBUG_TARGETS_FATAL_LI = "ACR_BUG_FT_";

// The default "catch-all" system for debug messages.
const string DEBUG_SYSTEM_DEFAULT = "ACR_BUG";
const string _DEBUG_SYSTEM_DEFAULT_PREFIX = "";
const int _DEBUG_SYSTEM_INFO_TARGETS = DEBUG_TARGET_NONE;
const int _DEBUG_SYSTEM_WARNING_TARGETS = DEBUG_TARGET_NONE;
const int _DEBUG_SYSTEM_FATAL_TARGETS = DEBUG_TARGET_LOG;

// Debug storage object pointer.
const string _DEBUG_STORAGE_OBJECT_LO = "ACR_BUG_SO";

// The number of debug systems initialized.
const string _DEBUG_NUMBER_LI = "ACR_BUG_NUM";

////////////////////////////////////////////////////////////////////////////////
// Structures //////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////

////////////////////////////////////////////////////////////////////////////////
// Global Variables ////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////

////////////////////////////////////////////////////////////////////////////////
// Function Prototypes /////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////

//! *** PUBLIC FUNCTIONS ***

//! Prints a debug message from the system id specified with the warning level
//! specified. To create a system id, see the CreateDebugSystem() function.
//! Valid warning levels are:
//! DEBUG_LEVEL_FATAL
//! Signifies a fatal error, keeping the associated system from performing its
//! task.
//! DEBUG_LEVEL_WARNING
//! Signifies a non-fatal error or odd behavior, which does not keep the
//! associated system from performing its task.
//! DEBUG_LEVEL_INFO
//! Signifies general debugging information, not any sort of odd behavior or
//! error.
//! If oTarget is specified, it is the object which speaks or shouts the message
//! if DEBUG_TARGET_TALK or DEBUG_TARGET_SHOUT is enabled.
void ACR_PrintDebugMessage(string sMessage, string sSystemName = DEBUG_SYSTEM_DEFAULT, int nLevel = DEBUG_LEVEL_FATAL, object oTarget = OBJECT_INVALID);

//! Returns a systemId integer which refers to the debugging messages for the
//! system.
//! prefix is the prefix printed on all debugging messages printed.
//! The target parameters are bit-wise variables indicating the places where
//! debug messages are sent for each debug warning level (see the
//! PrintDebugMessage() function for explainations of warning levels).
//! For example,
//! int spawnId = CreateSystemId("Spawn system: ", DEBUG_TARGET_NONE,
//!                              DEBUG_TARGET_LOG,
//!                              DEBUG_TARGET_LOG | DEBUG_TARGET_DMS );
//! This call creates a system where no informational messages are printed,
//! warning messages go to the log, and fatal errors are sent to all DMs and sent
//! to the log. The targets of the three debug levels can be changed in-game by
//! a DM-tool as well.
//! The possible message targets include, DEBUG_TARGET_DMS, DEBUG_TARGET_PCS,
//! DEBUG_TARGET_LOG, DEBUG_TARGET_DB, DEBUG_TARGET_TALK and DEBUG_TARGET_SHOUT.
int ACR_CreateDebugSystem(string sName, int nInfoTargets = DEBUG_TARGET_NONE, int nWarningTargets = DEBUG_TARGET_LOG, int nFatalTargets = DEBUG_TARGET_LOG);

//! Initializes the debugging system. This function MUST be called from the
//! OnModuleLoad event for the debugging system to function correctly.
void ACR_InitializeDebugging();

//! Returns the number of debugging systems which have been created.
int ACR_GetNumberOfDebuggingSystems();

//! Gets the name of the debugging system at nIndex.
string ACR_GetDebuggingSystemPrefix(string sSystemName);

//! Gets the places informational messages are sent for debugging systen at index
//! nIndex.
int ACR_GetDebuggingInfoTargets(string sSystemName);

//! Gets the places warning messages are sent for debugging systen at index
//! nIndex.
int ACR_GetDebuggingWarningTargets(string sSystemName);

//! Gets the places fatal error messages are sent for debugging systen at index
//! nIndex.
int ACR_GetDebuggingFatalTargets(string sSystemName);

//! Sets the places informational messages are sent for the debugging system at
//! index nIndex. nTargets is a bitwise field which can contain the following
//! flags: DEBUG_TARGET_DMS, DEBUG_TARGET_PCS, DEBUG_TARGET_LOG, DEBUG_TARGET_DB,
//! DEBUG_TARGET_TALK and DEBUG_TARGET_SHOUT.
void ACR_SetDebuggingInfoTargets(string sSystemName, int nTargers);

//! Sets the places warning messages are sent for the debugging system at
//! index nIndex. nTargets is a bitwise field which can contain the following
//! flags: DEBUG_TARGET_DMS, DEBUG_TARGET_PCS, DEBUG_TARGET_LOG, DEBUG_TARGET_DB,
//! DEBUG_TARGET_TALK and DEBUG_TARGET_SHOUT.
void ACR_SetDebuggingWarningTargets(string sSystemName, int nTargers);

//! Sets the places fatal error messages are sent for the debugging system at
//! index nIndex. nTargets is a bitwise field which can contain the following
//! flags: DEBUG_TARGET_DMS, DEBUG_TARGET_PCS, DEBUG_TARGET_LOG, DEBUG_TARGET_DB,
//! DEBUG_TARGET_TALK and DEBUG_TARGET_SHOUT.
void ACR_SetDebuggingFatalTargets(string sSystemName, int nTargers);

//! Loads the names of the debugging systems into custom coversation tokens
//! starting at nStartToken. Returns the number of names loaded.
//! If nStartIndex is defined, it starts at that debugging system.
int ACR_LoadDebugNamesIntoCustomTokens(int nStartToken, int nStartIndex = 0);

//! *** PRIVATE FUNCTIONS ***

//! This sends a debug message to the specified target(s).
//! Not for external use.
void _SendDebugMessage(string sMessage, int nTargets, object oTarget);

////////////////////////////////////////////////////////////////////////////////
// Includes ////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////

// For the ArrayInt and ArrayString functions,
#include "acr_array_i"

////////////////////////////////////////////////////////////////////////////////
// Function Definitions ////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////

////////////////////////////////////////////////////////////////////////////////
// *** BEGIN PUBLIC FUNCTIONS ***
////////////////////////////////////////////////////////////////////////////////

void ACR_InitializeDebugging() {
    SetLocalObject( GetModule(), _DEBUG_STORAGE_OBJECT_LO, GetModule() );
    ACR_CreateDebugSystem(_DEBUG_SYSTEM_DEFAULT_PREFIX, _DEBUG_SYSTEM_INFO_TARGETS, _DEBUG_SYSTEM_WARNING_TARGETS, _DEBUG_SYSTEM_FATAL_TARGETS);
}

void ACR_PrintDebugMessage(string sMessage, string sSystemName = DEBUG_SYSTEM_DEFAULT, int nLevel = DEBUG_LEVEL_FATAL, object oTarget = OBJECT_INVALID) {
    int nTargets = 0;
    object oDebugStorageObject = GetLocalObject(GetModule(), _DEBUG_STORAGE_OBJECT_LO);
    int nNumSystems = GetLocalInt(oDebugStorageObject, _DEBUG_NUMBER_LI);
    string sPrefix;

    switch(nLevel) {
        case DEBUG_LEVEL_INFO:
            nTargets = GetLocalInt(oDebugStorageObject, _DEBUG_TARGETS_INFO_LI + sSystemName);
            sPrefix = _DEBUG_MESSAGE_PREFIX_INFO;
            break;
        case DEBUG_LEVEL_WARNING:
            nTargets = GetLocalInt(oDebugStorageObject, _DEBUG_TARGETS_WARNING_LI + sSystemName);
            sPrefix = _DEBUG_MESSAGE_PREFIX_WARNING;
            break;
        case DEBUG_LEVEL_FATAL:
            nTargets = GetLocalInt(oDebugStorageObject, _DEBUG_TARGETS_FATAL_LI + sSystemName);
            sPrefix = _DEBUG_MESSAGE_PREFIX_FATAL;
            break;
        default:
            ACR_PrintDebugMessage("DEBUGGER ERROR: Invalid debug message level specified.", sSystemName, DEBUG_LEVEL_WARNING);
            return;
            break;
    }

    _SendDebugMessage(sSystemName + ": " + sMessage, nTargets, oTarget);
}

int ACR_CreateDebugSystem(string sName, int nInfoTargets = DEBUG_TARGET_NONE, int nWarningTargets = DEBUG_TARGET_LOG, int nFatalTargets = DEBUG_TARGET_LOG) {
    object oDebugStorageObject = GetLocalObject(GetModule(), _DEBUG_STORAGE_OBJECT_LO);

    // Create the system.
    SetLocalInt(oDebugStorageObject, _DEBUG_TARGETS_INFO_LI + sName, nInfoTargets);
    SetLocalInt(oDebugStorageObject, _DEBUG_TARGETS_WARNING_LI + sName, nWarningTargets);
    SetLocalInt(oDebugStorageObject, _DEBUG_TARGETS_FATAL_LI + sName, nFatalTargets);

    // Increment the total number of systems.
    int nNum = GetLocalInt(oDebugStorageObject, _DEBUG_NUMBER_LI);
    SetLocalArrayString(oDebugStorageObject, _DEBUG_SYSTEMS_LSA, nNum, sName);
    SetLocalInt(oDebugStorageObject, _DEBUG_NUMBER_LI, nNum + 1);
	return nNum+1;
}

int ACR_GetNumberOfDebuggingSystems() {
    return GetLocalInt(GetLocalObject(GetModule(), _DEBUG_STORAGE_OBJECT_LO), _DEBUG_NUMBER_LI);
}

int ACR_GetDebuggingInfoTargets(string sSystemName) {
    return GetLocalInt(GetLocalObject(GetModule(), _DEBUG_STORAGE_OBJECT_LO), _DEBUG_TARGETS_INFO_LI + sSystemName);
}

int ACR_GetDebuggingWarningTargets(string sSystemName) {
    return GetLocalInt(GetLocalObject(GetModule(), _DEBUG_STORAGE_OBJECT_LO), _DEBUG_TARGETS_WARNING_LI + sSystemName);
}

int ACR_GetDebuggingFatalTargets(string sSystemName) {
    return GetLocalInt(GetLocalObject(GetModule(), _DEBUG_STORAGE_OBJECT_LO), _DEBUG_TARGETS_FATAL_LI + sSystemName);
}

void ACR_SetDebuggingInfoTargets(string sSystemName, int nTargers) {
    SetLocalInt(GetLocalObject(GetModule(), _DEBUG_STORAGE_OBJECT_LO), _DEBUG_TARGETS_INFO_LI + sSystemName, nTargers);
}

void ACR_SetDebuggingWarningTargets(string sSystemName, int nTargers) {
    SetLocalInt(GetLocalObject(GetModule(), _DEBUG_STORAGE_OBJECT_LO), _DEBUG_TARGETS_WARNING_LI + sSystemName, nTargers);
}

void ACR_SetDebuggingFatalTargets(string sSystemName, int nTargers) {
    SetLocalInt(GetLocalObject(GetModule(), _DEBUG_STORAGE_OBJECT_LO), _DEBUG_TARGETS_FATAL_LI + sSystemName, nTargers);
}

int ACR_LoadDebugNamesIntoCustomTokens(int nStartToken, int nStartIndex = 0) {
    object oDebugStorageObject = GetLocalObject(GetModule(), _DEBUG_STORAGE_OBJECT_LO);
    int nNumSystems = GetLocalInt(oDebugStorageObject, _DEBUG_NUMBER_LI);
    LoadStringArrayIntoCustomTokens(oDebugStorageObject, _DEBUG_SYSTEMS_LSA, nNumSystems, nStartToken, nStartIndex);
    return nNumSystems - nStartIndex;
}

////////////////////////////////////////////////////////////////////////////////
// *** BEGIN PRIVATE FUNCTIONS ***
////////////////////////////////////////////////////////////////////////////////

void _SendDebugMessage(string sMessage, int nTargets, object oTarget) {

    if(nTargets & DEBUG_TARGET_PCS) {
        object oPC = GetFirstPC();
        while(GetIsObjectValid(oPC)) {
            SendMessageToPC(oPC, sMessage);
            oPC = GetNextPC();
        }
    }

    if(nTargets & DEBUG_TARGET_DMS) {
        SendMessageToAllDMs(sMessage);
    }

    if(nTargets & DEBUG_TARGET_LOG) {
        WriteTimestampedLogEntry(sMessage);
    }

    if(GetIsObjectValid(oTarget)) {
        if(nTargets & DEBUG_TARGET_TALK) {
            AssignCommand(oTarget, SpeakString(sMessage, TALKVOLUME_TALK));
        }

        if(nTargets & DEBUG_TARGET_SHOUT) {
            AssignCommand(oTarget, SpeakString(sMessage, TALKVOLUME_SHOUT));
        }
    }
}

#endif