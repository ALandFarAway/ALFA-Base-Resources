////////////////////////////////////////////////////////////////////////////////
//
//  System Name : ALFA Core Rules
//     Filename : acr_mod_event_hook_i.nss
//    $Revision:: 1          $ current version of the file
//        $Date:: 2014-01-16#$ date the file was created or modified
//       Author : Basilica
//
//  Description
//  This file contains definitions usable to hook module event scripts from a
//  content patchable override script (for rapid deployment).
//
//  To utilize these scripts, acr_patch_initialize.[ncs|ndb|nss] should be
//  rolled out as an override file via the content patch system.  The
//  acr_patch_initialize script then uses the following to establish a hook:
//
//  SetLocalString(GetModule(),
//  	ACR_MODULE_ON_CLIENT_ENTER + ACR_MODULE_HOOK_PRE,
//  	"acr_patch_on_module_enter_pre");
//
//  ... to establish a pre-call hook for module enter that invokes the
//  "acr_patch_on_module_enter_pre" script (which should also be distributed
//  as an override file via the content patch system).
//
//  The script MUST be an int StartingConditional() and not a void main().
//  
//  For a pre-call hook script, if the return value from StartingConditional()
//  is FALSE, then the ACR processing is stopped.  Otherwise, future processing
//  is continued.
//    
//  No hook scripts are defined by default and these hooks should not be used by
//  individual modules - they are for use by the patching system instead.  An
//  individual module can customize the acf_*.nss scripts to perform pre-, or
//  post- call hooks for the module events.
//
//  Revision History
//  2014/01/16  Basilica - Created.
//
////////////////////////////////////////////////////////////////////////////////

#ifndef ACR_MOD_EVENT_HOOK_I
#define ACR_MOD_EVENT_HOOK_I

////////////////////////////////////////////////////////////////////////////////
// Constants ///////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////


//! Precall name.  Appended to an event name to form a global variable that is
//  the name of a script to run when that event fires (before ACR processing).
const string ACR_MODULE_HOOK_PRE = "_PRE";

//! Postcall name.  Appended to an event name to form a global variable that is
//  the name of a script to run when that event fires (after ACR processing).
const string ACR_MODULE_HOOK_POST = "_POST";

//! Event names.

const string ACR_MODULE_ON_CLIENT_ENTER = "ACR_MODULE_ON_CLIENT_ENTER";
const string ACR_MODULE_ON_CLIENT_LEAVE = "ACR_MODULE_ON_CLIENT_LEAVE";
const string ACR_MODULE_ON_ACQUIRE_ITEM = "ACR_MODULE_ON_ACQUIRE_ITEM";
const string ACR_MODULE_ON_UNACQUIRE_ITEM = "ACR_MODULE_ON_UNACQUIRE_ITEM";
const string ACR_MODULE_ON_ACTIVATE_ITEM = "ACR_MODULE_ON_ACTIVATE_ITEM";
const string ACR_MODULE_ON_PC_LOADED = "ACR_MODULE_ON_PC_LOADED";
const string ACR_MODULE_ON_PLAYER_DEATH = "ACR_MODULE_ON_PLAYER_DEATH";
const string ACR_MODULE_ON_PLAYER_DYING = "ACR_MODULE_ON_PLAYER_DYING";
const string ACR_MODULE_ON_PLAYER_LEVEL_UP = "ACR_MODULE_ON_PLAYER_LEVEL_UP";
const string ACR_MODULE_ON_PLAYER_RESPAWN = "ACR_MODULE_ON_PLAYER_RESPAWN";
const string ACR_MODULE_ON_PLAYER_REST = "ACR_MODULE_ON_PLAYER_REST";
const string ACR_MODULE_ON_USER_DEFINED = "ACR_MODULE_ON_USER_DEFINED";
const string ACR_MODULE_ON_PLAYER_EQUIP = "ACR_MODULE_ON_PLAYER_EQUIP";
const string ACR_MODULE_ON_PLAYER_UNEQUIP = "ACR_MODULE_ON_PLAYER_UNEQUIP";
const string ACR_MODULE_ON_CUTSCENE_ABORT = "ACR_MODULE_ON_CUTSCENE_ABORT";

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
// Includes ////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////

////////////////////////////////////////////////////////////////////////////////
// Function Definitions ////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////

#endif
