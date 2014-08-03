////////////////////////////////////////////////////////////////////////////////
//
//  System Name : ALFA Core Rules
//     Filename : acr_mod_events_i.nss
//    $Revision:: 616        $ current version of the file
//        $Date:: 2009-12-29#$ date the file was created or modified
//       Author : Ronan & Cipher & AcadiusLost
//
//  Description
//  This file contains functions which process all module event scripts for
//  ALFA modules.
//
//  Of note is the presence of only a single loop in each event. Subsystems
//  residing in an event should not contain their own inventory or effect loops,
//  instead the subsystems should share a single loop. This is done for reasons
//  of efficiency, NWScript is not quick when doing things like looping through
//  items in an inventory, or objects in an area.
//
//  Revision History
//  2006/08/18  Cipher  Added pc initialization, rest processing, & minor reformatting
//  2006/09/09  Cipher  Changed ALFA prefix to ACR
//  2006/09/15  Ronan   Added game constant cache system, and updated to ACR_ convention
//  2006/09/15  Cipher  Added support for scrying spells
//  2006/09/15  Cipher  Added death system functions
//  2006/12/22  Cipher  Added OnModuleStart and OnPCLoaded event handlers
//  2007/01/20  Cipher  Moved ExecuteScript() item script to ACR_ModuleOnActivateItem()
//  2007/03/31  AcadiusLost  commented out calls to Death system scripts, for now.
//  2007/04/15  AcadiusLost  edited OnActivate to explicitly pass oItem in ExecuteScript
//  2007/04/26  AcadiusLost  Added Module Switches to OnModuleLoad handler
//  2007/05/03  AcadiusLost  Added death effect to ACR_ModuleOnPlayerDying()- temporarily
//  2007/05/03  Cipher  Added call to ACR_PlayerOnDying() and initialized spell hooking
//  2007/05/25  Cipher  Added NWNX initialization and 1984 logging hooks
//  2007/07/01  Cipher  Added OnPCLoaded() event calls. This solves PC instantiation workarounds
//  2007/07/13  Cipher  Added SQL table creation function call
//  2007/07/14  AcadiusLost  Moved DM item granting to OnPCLoaded, added starting equipment handling.
//                      Also changed ACR_ModuleOnPlayerDeath() to use GetLastHostileActor(), and 
//                      ACR_ModuleOnUnacquireItem() to check GetIsObjectValid(oItem), and ACR_ModuleOnAcquireItem
//                      to use GetItemPossessor(GetModuleItemAquired()) to avoid strange cases.
//  2007/07/18  AcadiusLost  Moved ACR_RestOnClientEnter to OnPCLoaded
//  2007/07/21  Cipher  Revised ACR_SQLGetData() calls, skip item acquisition logging on logins
//  2007/09/02  Cipher  Added rebuild journal quest entries on login
//  2007/09/15  AcadiusLost Pushed back RestOnClientEnter with a DelayCommand() to give PC status 
//                      adjust a chance to apply damage before calculating offcamera rest healing.
//  2007/09/15  Cipher  Moved journal rebuild to the OnPCLoaded event
//  2007/09/20  Cipher  Added quest hook for item bounties
//  2007/09/21  Cipher  Moved inventory item checks on login to the ItemOnAcquired function to avoid redundancy
//  2007/10/28  AcadiusLost Merged with DMFI 1.05 for OnPCLoad event.  Added "#include "dmfi_inc_initial"
//  2007/10/31  AcadiusLost Changed DMFI call to an ExecuteScript() so it isn't needed to compile the ACR.
//  2007/11/02  AcadiusLost Shifted DMFI call outside the DM/Player conditional so it is called for both.
//  2007/11/15  AcadiusLost removed module switch for UMD scrolls (adding ALFA scrolls) 
//  2007/11/25  AcadiusLost added OnEquip handling for Martial Bastardswords
//  2007/11/30  AcadiusLost added OnModuleLoad call to initialize chat plugin cache
//  2007/12/16  AcadiusLost added calls to acr_items_i to handle item scripts, moved bastardsword code.
//  2007/12/17  AcadiusLost - pushed death and resting includes to acr_items_i, shifted item activation code as well.
//  2008/03/19  AcadiusLost - shifted death logging into acr_death_i, due to addition of "death floor"
//  2008/04/16  Cipher  Fixed logout logging.
//  2008/04/16  Cipher  Fixed acquire logging.
//  2008/08/27  AcadiusLost - added hooks for nonlethal damage system
//  2008/09/19  AcadiusLost - prepare for Custom skills, regions, logging fix for NLD
//  2008/09/21  AcadiusLost - Nonlethal OnExit event added.
//  2008/12/08  AcadiusLost - Added handling for server names with apostrophes eg. "Baldur's Gate"
//                    Item acquire/unacquire optimizations (commented out SQL illegal item checks), deprecated storageobjects 
//                  also amended spawn debug wand tag for GetItemPossessedBy() for DMs.
//  2008/12/10  AcadiusLost - optimized class checking OnPCLoaded()
//  2009/01/19  AcadiusLost - switched Servers table update to take GetName(oModule) to allow synchronicity with pwdata entries.
//  2009/02/07  AcadiusLost - Changed initialization of the AutoSave() cycle for PCs.
//  2009/03/10  AcadiusLost - Added initialization for the DM Client Extension suite in OnClientEnter.
//  2009/07/07  AcadiusLost - updated to add custom skill framework with 1.23
//  2009/07/18  AcadiusLost - Added language and region hooks into PC Load and Levelup events.
//  2009/08/03  AcadiusLost - Added IP-logging onLogin
//  2009/08/08  AcadiusLost - Added handling for OnChat event (1.23)
//  2009/12/29  AcadiusLost - Removed autoassignment of subdual widget OnPCLoaded (no longer needed)
//    2011/05/29    Ronan        - Added OnModuleLoad parameters for global module settings.
//      2011/06/04      Zelknolf        - Added hook for display of NPC creator GUI
//    2011/06/24    AcadiusLost    - merged in fix for clearing IsOnline bits in Characters table OnModuleLoad()
//    2011/06/25    Ronan - Added in the service heartbeats for asynchronous SQL writes.
// 2011/07/02  Basilica - Added persistent database callouts for cache management.
// 2011/12/26  Basilica - Added server admin command directives.
// 2012/01/02  Basilica - Added latency monitor support.
// 2012/01/05  Basilica - Added server IPC callouts.
// 2012/01/09  Basilica - CE integration.
// 2012/01/14  Basilica - Changed to use ACR_RPXPMarkActive for marking RPXP.
// 2012/01/19  Basilica - Added callout for area instancing system.
// 2012/03/03  Basilica - Added callout for SCliExt OnLeave.
// 2012/04/15  Basilica - Added infrastructure for deleting unneeded static objects at module startup.
// 2012/04/16  Basilica - Log module and HAK build date to server log at module startup.
// 2012/04/28  Basilica - Prevent creation of new characters or players with trailing spaces.
// 2014/01/16  Basilica - Added module event hook for override patchable scripts.
// 2014/08/01  Basilica - Added initialization callout to ACR_DatabaseConnector.
//
////////////////////////////////////////////////////////////////////////////////

#ifndef ACR_MOD_EVENTS_I
#define ACR_MOD_EVENTS_I

////////////////////////////////////////////////////////////////////////////////
// Constants ///////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////

const string _ONLOAD_DEBUG = "ACR_ModuleOnModuleLoad";
const string ACR_MOD_STATUS = "ACR_MOD_STATUS";

//! Local variable definitions
const string ACR_MOD_SPELLBOOK = "ACR_MOD_SPELLBOOK";
const string ACR_MOD_HOLYSYMBOL = "ACR_MOD_HOLYSYMBOL";
const string ACR_MOD_STARTINGGOLD = "ACR_MOD_STARTINGGOLD";
const string ACR_MOD_STARTARMORX = "ACR_MOD_STARTARMORX";
const string ACR_MOD_FIRSTAID_IT = "ACR_MOD_FIRSTAID_IT";

const string ACR_MOD_LAST_TELL_TO = "ACR_MOD_LAST_TELL_TO";
const string ACR_MOD_LAST_TELL_FROM = "ACR_MOD_LAST_TELL_FROM";
const string ACR_MOD_SUPPRESS_LANGUAGE = "ACR_MOD_SUPPRESS_LANGUAGE";


//! ACR_MOD_STATUS Module Status Flags (bitmask)
const int ACR_MOD_NWNX_FAILED = 0x01;

//! The time period for OnModuleLoad() rescheduling, necessary for NWNX failures.
const float ACR_MOD_RELOAD_CYCLE = 10.0;


const float ACR_TALK_SPHERE_RADIUS = 20.0f;
const float ACR_WHISPER_SPHERE_RADIUS = 3.0f;

const int ACR_ASSEMBLY_LOADER_INITIALIZE = 0;

const int ACR_CANDLEKEEP_INITIALIZE_ARCHIVES = 0;

const int ACR_CHOOSERCREATOR_INITIALIZE = 0;

const int ACR_DATABASE_CONNECTOR_INITIALIZE = 0;

//! Define to 1 to enable language handling debugging.
#define DEBUG_LANG 0

////////////////////////////////////////////////////////////////////////////////
// Structures //////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////

////////////////////////////////////////////////////////////////////////////////
// Global Variables ////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////

////////////////////////////////////////////////////////////////////////////////
// Function Prototypes /////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////

// Runs the ALFA OnModuleLoad event.

void ACR_ModuleOnModuleLoad();
void ACR_ModuleOnModuleStart();
void ACR_ModuleOnClientEnter();
void ACR_ModuleOnClientLeave();
void ACR_ModuleOnAcquireItem();
void ACR_ModuleOnUnacquireItem();
void ACR_ModuleOnActivateItem();
void ACR_ModuleOnPCLoaded();
void ACR_ModuleOnPlayerDeath();
void ACR_ModuleOnPlayerDying();
void ACR_ModuleOnPlayerLevelUp();
void ACR_ModuleOnPlayerRespawn();
void ACR_ModuleOnPlayerRest();
void ACR_ModuleOnHeartbeat();
void ACR_ModuleOnUserDefined();
void ACR_ModuleOnPlayerEquip();
void ACR_ModuleOnPlayerUnequip();
void ACR_ModuleOnCutsceneAbort();

// special handler for the OnChat event (new in 1.23)
int ACR_ModuleOnChat(object oSpeaker, object oTarget, int nMode, string sText);

//! Returns the state of the desired module status bit
//! - nStatus: One of the status flags defined for ACR_MOD_STATUS
//! - returns: TRUE is set, FALSE if not set
int ACR_GetModuleStatus(int nStatus);

//! Sets the state of the desired module status bit
//! - nStatus: One of the status flags defined for ACR_MOD_STATUS
//! - returns: Nothing
void ACR_SetModuleStatus(int nStatus);

//! Called when a new PC is created.
//!  - oPC : Player to initialize.
void ACR_HandlePCCreation( object oPC );

// Private

//! Start up latency and health monitoring for the server
void ACR_ModuleInitHealthChecks();

//! Perform startup time area cleanup.
void ACR_PerformModuleStartupCleanup();

//! Sweep unneeded objects from the area, such as walkmesh helpers.
//!  - AreaObject: the area to remove unneeded objects from.
void ACR_SweepAreaOfUnneededObjects(object AreaObject);

//! Wrapper for ACR_ModuleInitHealthChecks().
void ACR_StartModuleInitHealthChecks();

//! Parse a new language
string _ParseLang(object pc, string text);

//! Parse a new language
int _HandleLang(object pc, string text, int mode, string lang, object DMFIToolOwner);

//! Check if a mouthpiece should have messages relayed from a speaker.
//!  - oMouthPiece: Supplies the mouthpiece, i.e. controlling object (e.g. DM).
//!  - oSpeaker: Supplies the actual physical speaker (e.g. controlled object).
//!  - fDistance: Supplies the distance for the range check.
//!  - Returns: TRUE if the objects were out of range to receive the message
//              through conventional means, i.e. we should relay it.
int _MouthPieceNotInRange(object oMouthPiece, object oSpeaker, float fDistance);

//! Wrapper for SpeakString that suppresses voice throw reception.
//!  - sToSpeak: The string to send.
//!  - nTalkVolume: The volume to use.
void _SpeakString(string sToSpeak, int nTalkVolume);

//! Distribute translated chat message to DM avatars as they do not reliably
//  appear to be enumerated within an object shape region.
//!  - sTranslatedMessage: The message to distribute.
//!  - oSpeaker: The speaking object.
//!  - fRange: The maximum range to deliver the message at.
void _DistributeTranslationToDMAvatars(string sTranslatedMessage, object oSpeaker, float fRange);

//! Distribute translated chat message to a mouthpiece object (i.e. controlling
//  DMs or players).
//!  - sTranslatedMessage: The message to distribute to objects that can
//     translate the language.
//!  - sScrambledMessage: The message to distribute to objects that cannot
//     translate the language.
//!  - oSpeaker: The speaking object.
//!  - fRange: The maximum range to deliver the message at.
//!  - oListener: The object that might is within hearing range of the message.
void _DistributeTranslationToMouthPiece(string sTranslatedMessage, string sScrambledMessage, object oSpeaker, float fRange, object oListener);

//!  Distribute translated chat message to appropriate recipients, for party.
//!  - sTranslatedMessage: The message to distribute to objects that can
//     translate the language.
//!  - sScrambledMessage: The message to distribute to objects that cannot
//     translate the language.
//!  - sLanguage: The language (e.g. Elven).
//!  - oSpeaker: The speaking object.
void _DistributeTranslationParty(string sTranslatedMessage, string sScrambledMessage, string sLanguage, object oSpeaker);

//!  Distribute translated chat message to appropriate recipients, for talk or
//   whisper.
//!  - sTranslatedMessage: The message to distribute to objects that can
//     translate the language.
//!  - sScrambledMessage: The message to distribute to objects that cannot
//     translate the language.
//!  - sLanguage: The language (e.g. Elven).
//!  - oSpeaker: The speaking object.
//!  - fRange: The range to distribute the message at.
void _DistributeTranslationSpoken(string sTranslatedMessage, string sScrambledMessage, string sLanguage, object oSpeaker, float fRange);

//!  Distribute translated chat message to appropriate recipients.
//!  - sOriginalMessage: The message to distribute to objects that can
//     translate the language.
//!  - sScrambledMessage: The message to distribute to objects that cannot
//     translate the language.
//!  - sLanguage: The language (e.g. Elven).
//!  - oSpeaker: The speaking object.
//!  - nMode: The chat mode (CHAT_MODE_WHISPER, CHAT_MODE_TALK,
//     CHAT_MODE_PARTY)
void _DistributeTranslation(string sOriginalMessage, string sScrambledMessage, string sLanguage, object oSpeaker, int nMode);

//! Force linkage to functions that CLR scripts will want to call in the
//  context of acf_mod_onmoduleload.nss.  Note that this function is never
//  really run but must make a reference to every symbol that should be force
//  included so that it can be resolved at runtime.
void ACR_ModuleInit_ForceLinkageForCLRScripts();

//! Show player UIs.
void _createPlayerGUIs( object oPC );

//! Update player UIs for mod events.
void _updatePlayerGUIs( object oPC );

//! Load CLR script assemblies.
void _LoadAssemblies();

// This is needed to establish the server and gameobject structures that 
// ACR_CreatureBehavior uses.
void ACR_InitializeCreatureBehavior();

//! Hook for override script files deployed by the content patcher to 
//! Returns TRUE to continue processing, else FALSE to stop.  The return value
//  is only used if Precall is TRUE.
//! - Event: Supplies the name of the event (ACR_MODULE_ON_* from
//           acr_mod_event_hook_i.nss).
//! - Precall: Supplies TRUE if the call happens before normal processing, else
//             FALSE if it happens after normal processing.
int ACR_ModuleOverrideEvent(string Event, int Precall);

////////////////////////////////////////////////////////////////////////////////
// Includes ////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////
#include "acr_settings_i"
#include "acr_debug_i"
#include "acr_time_i"
#include "acr_xp_i"
//#include "acr_storageobj_i"
#include "acr_spawn_i"
#include "acr_db_persist_i"
//#include "acr_game_const_i"
#include "acr_scry_i"
#include "acr_tools_i"
#include "acr_1984_i"
#include "acr_quest_i"
#include "acr_chat_i"
#include "acr_xp_i"
#include "acr_items_i"
#include "acr_skills_i"
#include "acr_nonlethal_i"
#include "acr_language_i"
#include "acr_feat_events_i"
#include "acr_srvadmin_i"
#include "acr_server_ipc_i"
#include "acr_version_i"
#include "acr_scliext_i"
#include "acr_area_instance_i"
#include "acr_wealth_i"
#include "acr_gui_i"
#include "acr_language_i"
#include "acr_pchide_i"
#include "acr_movement_i"
#include "acf_spawn_i"
#include "acf_settings_i"

#include "x2_inc_switches"
#include "dmfi_inc_initial"
#include "dmfi_inc_lang"

#include "acr_roll_i"

#include "nwnx_craft_system"

#include "acr_craft_creation_i"
#include "acr_notifications_i"
#include "nwnx_objectattributes_include"

#include "acr_mod_event_hook_i"

////////////////////////////////////////////////////////////////////////////////
// Function Definitions ////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////

void _SpeakString(string sToSpeak, int nTalkVolume)
{
    // Note - there is a bug in the NWScript plugin that under these conditions:
    //
    // "If a script is executed from a script situation (DelayCommand,
    //  AssignCommand, and so forth, other 'action' types in NWScript), and the
    //  script makes a recursive call to itself, then the recursion is not
    //  properly detected and a new, stacked program object for the script is
    //  not created.  This results in the recursive instance using the global
    //  variables and OBJECT_SELF of the previous instance (modifications are
    //  visible between the two, in particular, if the recursive call sets a new
    //  OBJECT_SELF then OBJECT_SELF appears to have changed in the calling
    //  instance).
    //
    //  The problem occurs because the NWScript JIT backend does not correctly
    //  increment the internal nesting level from a script when the script is
    //  called because of a script situation.  If the script had already been
    //  recursively invoked, the nesting level would have necessitated a new
    //  script object being temporarily created, as entry into a script from
    //  the entrypoint always increments the nesting level across the call.
    //
    //  This will be fixed in a future release."
    //
    // Work around the bug for now by capturing OBJECT_SELF up front and not
    // using globals in this AssignCommand action, as the SpeakString engine
    // function will cause a recursive call to the OnChat script, which we're
    // already running from.

    object Self = OBJECT_SELF;

#if DEBUG_LANG
    WriteTimestampedLogEntry("_SpeakString(" + GetName(Self) + ": Speaking " + sToSpeak + ", volume: " + IntToString(nTalkVolume) + ".");
#endif

    SetLocalInt(Self, ACR_MOD_SUPPRESS_LANGUAGE, 1);
    SpeakString(sToSpeak, nTalkVolume);
    DeleteLocalInt(Self, ACR_MOD_SUPPRESS_LANGUAGE);

    // If the NWScript plugin bug is present, this shows the name of the module
    // and not the name of the object that spoke above.
#if DEBUG_LANG
    WriteTimestampedLogEntry("_SpeakString finished for " + GetName(OBJECT_SELF) + ".");
#endif
}

void _DistributeTranslationToDMAvatars(string sTranslatedMessage, object oSpeaker, float fRange)
{
    object oPC;
    object oOriginArea = GetArea(oSpeaker);

    for (oPC = GetFirstPC(FALSE); GetIsObjectValid(oPC); oPC = GetNextPC(FALSE))
    {
        if (!GetIsDM(oPC) && !GetIsDMPossessed(oPC))
        {
#if DEBUG_LANG
            WriteTimestampedLogEntry("_DistributeTranslationToDMAvatars: " + GetName(oPC) + " is not a DM");
#endif

            continue;
        }

        if (GetArea(oPC) != oOriginArea)
        {
#if DEBUG_LANG
            WriteTimestampedLogEntry("_DistributeTranslationToDMAvatars: " + GetName(oPC) + " is in the wrong area");
#endif

            continue;
        }

        if (GetDistanceBetween(oSpeaker, oPC) > fRange)
        {
#if DEBUG_LANG
            WriteTimestampedLogEntry("_DistributeTranslationToDMAvatars: " + GetName(oPC) + " is out of range");
#endif

            continue;
        }

#if DEBUG_LANG
        WriteTimestampedLogEntry("_DistributeTranslationToDMAvatars: Relay message to " + GetName(oPC));
#endif

        SendMessageToPC(oPC, sTranslatedMessage);
    }
}

void _DistributeTranslationToMouthPieces(string sTranslatedMessage, string sScrambledMessage, object oSpeaker, float fRange, object oListener)
{
    object oMouthPiece = GetLocalObject(oListener, "MouthPiece");
    string sHeardDescriptor;

    if (oMouthPiece == OBJECT_INVALID)
    {
#if DEBUG_LANG
        WriteTimestampedLogEntry("_DistributeTranslationToMouthPieces: No mouthpiece for " + GetName(oListener));
#endif

        return;
    }

    // If the mouthpiece object would normally receive the message then do not
    // synthesize a new report.
    if (!_MouthPieceNotInRange(oMouthPiece, oSpeaker, fRange))
    {
#if DEBUG_LANG
        WriteTimestampedLogEntry("_DistributeTranslationToMouthPieces: Listener " + GetName(oListener) + " mouthpiece " + GetName(oMouthPiece) + " is in normal hearing range not relaying");
#endif

        return;
    }

#if DEBUG_LANG
    WriteTimestampedLogEntry("_DistributeTranslationToMouthPieces: Distributing message to " + (GetIsDM(oMouthPiece) ? "DM" : "player") + " mouthpiece " + GetName(oMouthPiece) + ".");
#endif

    sHeardDescriptor = " <i><c=gray>(" + GetName(oListener) + ")</c</i>";

    // Choose whether to send the translated or scrambled message, and hand it
    // on.
    //
    // TODO:  If we wanted to support having familiars that understood a
    //        language, this is where we would do it.  Right now we only allow a
    //        DM mouthpiece to receive translated messages.

    if (GetIsDM(oMouthPiece))
        SendMessageToPC(oMouthPiece, sTranslatedMessage + sHeardDescriptor);
    else
        SendMessageToPC(oMouthPiece, sScrambledMessage + sHeardDescriptor);
}

void _DistributeTranslationParty(string sTranslatedMessage, string sScrambledMessage, string sLanguage, object oSpeaker)
{
    int bTranslate = (sLanguage != "common");
    object oListener;

    if (!bTranslate)
    {
#if DEBUG_LANG
        WriteTimestampedLogEntry("_DistributeTranslationParty: No translation required for untranslated message.");
#endif

        return;
    }

    for (oListener = GetFirstPC(FALSE);
         GetIsObjectValid(oListener);
         oListener = GetNextPC(FALSE))
    {
        if ((ACR_IsLanguageKnown(oListener, sLanguage) && GetFactionEqual(oSpeaker, oListener))
            || ACR_GetIsDMControlled(oListener) || oListener == oSpeaker)
        {
#if DEBUG_LANG
            WriteTimestampedLogEntry("_DistributeTranslationParty: Distributing message to party or DM recipient " + GetName(oListener));
#endif

            SendMessageToPC(oListener, sTranslatedMessage);
        }
    }
}

void _DistributeTranslationSpoken(string sTranslatedMessage, string sScrambledMessage, string sLanguage, object oSpeaker, float fRange)
{
    int bTranslate = (sLanguage != "common");
    location lSpeaker = GetLocation(oSpeaker);
    object oListener;

#if DEBUG_LANG
    WriteTimestampedLogEntry("_DistributeTranslationSpoken: Distributing message of language " + sLanguage);
#endif


    // First, distribute the message to objects in range.  Note that DM avatars
    // are not reliably enumerated here so they are handled separately.
    //
    // Additionally, distribute the message to mouthpiece listeners if they are
    // within range and would not normally receive the message.
    for (oListener = GetFirstObjectInShape(SHAPE_SPHERE, fRange, lSpeaker);
         GetIsObjectValid(oListener);
         oListener = GetNextObjectInShape(SHAPE_SPHERE, fRange, lSpeaker))
    {
        if (bTranslate && ACR_IsLanguageKnown(oListener, sLanguage) && !GetIsDM(oListener))
        {
#if DEBUG_LANG
            WriteTimestampedLogEntry("_DistributeTranslationSpoken: Distributing message to non-DM listener " + GetName(oListener) + ".");
#endif

            SendMessageToPC(oListener, sTranslatedMessage);
        }

        _DistributeTranslationToMouthPieces(sTranslatedMessage, sScrambledMessage, oSpeaker, fRange, oListener);
    }

    if (bTranslate)
        _DistributeTranslationToDMAvatars(sTranslatedMessage, oSpeaker, fRange);
}

void _DistributeTranslation(string sOriginalMessage, string sScrambledMessage, string sLanguage, object oSpeaker, int nMode)
{
    string sDisplayLanguage;
    string sModeColor;
    string sModeDescriptor;
    string sTranslatedMessage;
    string sUntranslatedMessage;
    float fRange;
    int nTalkVolume;

    // Distribute the translated version of the message.

    switch (nMode)
    {

    case CHAT_MODE_PARTY:
        sModeColor = "FFFFFF";
        sModeDescriptor = ", Party";
        fRange = 0.0f;
        nTalkVolume = TALKVOLUME_TALK;
        break;

    case CHAT_MODE_TALK:
        sModeColor = "FFFFFF";
        sModeDescriptor = "";
        fRange = ACR_TALK_SPHERE_RADIUS;
        nTalkVolume = TALKVOLUME_TALK;
        break;

    case CHAT_MODE_WHISPER:
        sModeColor = "808080";
        sModeDescriptor = ", Whisper";
        fRange = ACR_WHISPER_SPHERE_RADIUS;
        nTalkVolume = TALKVOLUME_WHISPER;
        break;

    case CHAT_MODE_SILENT_TALK:
        return;

    default:
        WriteTimestampedLogEntry("_DistributeTranslation: Unhandled chat mode " + IntToString(nMode) + "!");
        return;

    }

    sTranslatedMessage = "<color=#D7C5B9>"+GetName(oSpeaker)+" : </color><color=#" + sModeColor + "> ["+_CapitalizeWord(sLanguage)+sModeDescriptor + "] "+sOriginalMessage;
    sUntranslatedMessage = "<color=#D7C5B9>"+GetName(oSpeaker)+" : </color><color=#" + sModeColor + "> [Untranslated"+sModeDescriptor + "] "+sScrambledMessage;

    switch (nMode)
    {

    case CHAT_MODE_PARTY:
        _DistributeTranslationParty(sTranslatedMessage, sUntranslatedMessage, sLanguage, oSpeaker);
        break;

    case CHAT_MODE_TALK:
    case CHAT_MODE_WHISPER:
        _DistributeTranslationSpoken(sTranslatedMessage, sUntranslatedMessage, sLanguage, oSpeaker, fRange);
        break;

    }

    // Finally, distribute the scrambled version of the message.

    if (GetIsPC(oSpeaker) || ACR_GetIsDMControlled(oSpeaker))    
        SendChatMessage(oSpeaker, oSpeaker, nMode, sScrambledMessage, FALSE);
    else
        AssignCommand(oSpeaker, _SpeakString(sScrambledMessage, nTalkVolume));
}

void ACR_CheckBodyPartsOnLevelUp(object oPC)
{
    int nRace = GetRacialType(oPC);
    int nWings = 0;
    if(GetLevelByClass(CLASS_TYPE_FAVORED_SOUL, oPC) == 17)
    {
        if(GetAlignmentGoodEvil(oPC) == ALIGNMENT_EVIL)
        {
            if(nRace == RACIAL_TYPE_DWARF)
            {
                if(GetGender(oPC) == GENDER_FEMALE)
                    nWings = WING_MODEL_DWARF_LEATHER_FEMALE;
                else
                    nWings = WING_MODEL_DWARF_LEATHER_MALE;
            }
            else if(nRace == RACIAL_TYPE_GNOME)
            {
                if(GetGender(oPC) == GENDER_FEMALE)
                    nWings = WING_MODEL_GNOME_LEATHER_FEMALE;
                else
                    nWings = WING_MODEL_GNOME_LEATHER_MALE;
            }
            else if(nRace == RACIAL_TYPE_HALFORC)
            {
                if(GetGender(oPC) == GENDER_FEMALE)
                    nWings = WING_MODEL_HALFORC_LEATHER_FEMALE;
                else
                    nWings = WING_MODEL_HALFORC_LEATHER_MALE;
            }
            else
            {
                if(GetGender(oPC) == GENDER_FEMALE)
                    nWings = WING_MODEL_HUMAN_LEATHER_FEMALE;
                else
                    nWings = WING_MODEL_HUMAN_LEATHER_MALE;
            }
        }
        else
        {
            if(nRace == RACIAL_TYPE_DWARF)
            {
                if(GetGender(oPC) == GENDER_FEMALE)
                    nWings = WING_MODEL_DWARF_WHITE_FEMALE;
                else
                    nWings = WING_MODEL_DWARF_WHITE_MALE;
            }
            else if(nRace == RACIAL_TYPE_GNOME)
            {
                if(GetGender(oPC) == GENDER_FEMALE)
                    nWings = WING_MODEL_GNOME_WHITE_FEMALE;
                else
                    nWings = WING_MODEL_GNOME_WHITE_MALE;
            }
            else if(nRace == RACIAL_TYPE_HALFORC)
            {
                if(GetGender(oPC) == GENDER_FEMALE)
                    nWings = WING_MODEL_HALFORC_WHITE_FEMALE;
                else
                    nWings = WING_MODEL_HALFORC_WHITE_MALE;
            }
            else
            {
                if(GetGender(oPC) == GENDER_FEMALE)
                    nWings = WING_MODEL_HUMAN_WHITE_FEMALE;
                else
                    nWings = WING_MODEL_HUMAN_WHITE_MALE;
            }
        }
        XPObjectAttributesSetWingVariation(oPC, nWings);
    }
    if(GetLevelByClass(CLASS_TYPE_DRAGONDISCIPLE, oPC) == 9)
    {
        if(nRace == RACIAL_TYPE_DWARF)
        {
            if(GetGender(oPC) == GENDER_FEMALE)
                nWings = WING_MODEL_DWARF_RED_FEMALE;
            else
                nWings = WING_MODEL_DWARF_RED_MALE;
        }
        else if(nRace == RACIAL_TYPE_GNOME)
        {
            if(GetGender(oPC) == GENDER_FEMALE)
                nWings = WING_MODEL_GNOME_RED_FEMALE;
            else
                nWings = WING_MODEL_GNOME_RED_MALE;
        }
        else if(nRace == RACIAL_TYPE_HALFORC)
        {
            if(GetGender(oPC) == GENDER_FEMALE)
                nWings = WING_MODEL_HALFORC_RED_FEMALE;
            else
                nWings = WING_MODEL_HALFORC_RED_MALE;
        }
        else
        {
            if(GetGender(oPC) == GENDER_FEMALE)
                nWings = WING_MODEL_HUMAN_RED_FEMALE;
            else
                nWings = WING_MODEL_HUMAN_RED_MALE;
        }
        XPObjectAttributesSetWingVariation(oPC, nWings);
    }
}

void ACR_ModuleOnModuleLoad()
{
    // Set global module settings.
    SetServerData(ACR_SERVER_ID, ACR_SERVER_NAME, ACR_SERVER_REGION, ACR_SERVER_IP);

	 _LoadAssemblies();

    // Check and warn the user if the module wasn't built with the same ACR
    // version as a script contained within the hak.  (This script is built
    // with the module and returns the module's view of the version number.  The
    // acr_version_check script is built with the hak and returns the hak's view
    // of the version number.)
    ClearScriptParams();
    AddScriptParameterString(ACR_GetVersion());
    if (ExecuteScriptEnhanced("acr_version_check", OBJECT_SELF) != TRUE)
    {
        WriteTimestampedLogEntry("acr_mod_events_i: ** WARNING **: Module ACR version doesn't match alfa2_acr.hak ACR version!  This is usually caused by compiling the module against a different set of script headers than alfa2_acr.hak was constructed against.");
    }

    object oModule = GetModule();
    
    // ORDER MATTERS !!

    // Start the debuging system and create debugging ids for the module event scripts
    ACR_InitializeDebugging();
    ACR_CreateDebugSystem(_ONLOAD_DEBUG, DEBUG_TARGET_LOG | DEBUG_TARGET_DB, DEBUG_TARGET_LOG | DEBUG_TARGET_DB, DEBUG_TARGET_LOG | DEBUG_TARGET_DB);
    string sServerId = IntToString(ACR_GetServerId());
    ACR_PrintDebugMessage("acr_mod_events_i: ALFA " + sServerId + " loading the ALFA Core Rules.", _ONLOAD_DEBUG, DEBUG_LEVEL_INFO);

    // Check NWNX status
    if (! NWNXInstalled())
    {
        // record the status
        ACR_SetModuleStatus(ACR_MOD_NWNX_FAILED);
        ACR_PrintDebugMessage("acr_mod_events_i: NWNX unavailable on ALFA server " + sServerId + ". Rescheduling OnModuleLoad(). Server restart may be required.", _ONLOAD_DEBUG, DEBUG_LEVEL_FATAL);

        // reschedule the OnModuleLoad() handler
        DelayCommand(ACR_MOD_RELOAD_CYCLE, ACR_ModuleOnModuleLoad());
        return;
    }
    else
    {
        // create the SQL tables if need be
        ACR_CreateSQLTables();
    }
    
    // Initialize asynchronous writes
    ACR_StartAsyncService();

    // Load database-side configuration directives
    ACR_LoadDatabaseConfiguration();

    // Initialize spell hook
    SetLocalString(oModule, "X2_S_UD_SPELLSCRIPT", "acr_spellhook");

    // Initialize storage objects used by many systems.
    // ACR_InitializeStorageObjects();

    // Initialize game engine constants.
    //ACR_InitializeGameConstants();

    // Initialize the spawn system.
    ACR_InitializeSpawns(_SPAWN_AREA_DESPAWN_DELAY, _SPAWN_REFRESH_DELAY, _SPAWN_PRESPAWN_SEAMLESS, _SPAWN_PRESPAWN_PREDICTION);

    // Initialize the time system.
    ACR_InitializeTime();
//    ACR_PrintDebugMessage("acr_mod_events_i: Starting date: " + GetDateAsString(), _ONLOAD_DEBUG, DEBUG_LEVEL_INFO);
//    ACR_PrintDebugMessage("acr_mod_events_i: Sarting time: " + GetTimeAsString(), _ONLOAD_DEBUG, DEBUG_LEVEL_INFO);
    ACR_PrintDebugMessage("acr_mod_events_i: Time compression ratio: " + FloatToString(ACR_GetGameToRealTimeRatio()), _ONLOAD_DEBUG, DEBUG_LEVEL_INFO);

    // Initialize one-time PC status setups
    ACR_PCOnModuleLoad();

    // Recreate player corpses
    ACR_RestoreCorpsesOnModuleLoad();

    // Set bioware/obsidian module switches as desired:
    SetModuleSwitch(MODULE_SWITCH_ENABLE_INVISIBLE_GLYPH_OF_WARDING, TRUE);
    SetModuleSwitch(MODULE_SWITCH_ENABLE_CROSSAREA_WALKWAYPOINTS, TRUE);
    //SetModuleSwitch(MODULE_SWITCH_ENABLE_UMD_SCROLLS, TRUE);
    SetModuleSwitch(MODULE_SWITCH_ENABLE_NPC_AOE_HURT_ALLIES, TRUE);
    SetModuleSwitch(MODULE_SWITCH_ENABLE_MULTI_HENCH_AOE_DAMAGE, TRUE);
    SetModuleSwitch(MODULE_SWITCH_AOE_HURT_NEUTRAL_NPCS, TRUE);
    SetModuleSwitch(MODULE_VAR_AI_STOP_EXPERTISE_ABUSE, TRUE);
    SetModuleSwitch(MODULE_SWITCH_ENABLE_TAGBASED_SCRIPTS, TRUE);

    string sSID = IntToString(ACR_SERVER_ID);
    // grab the server name from the module properties so it will be updated.
    string sServerName = GetName(oModule);

    // Try and discover the external address of the server from the database
    // connection.  If that fails, fall back to the hardcoded default in the
    // configuration file.
    //
    // This is now superseded by the server communicator in most cases.
    string sExtAddress = ACR_GetServerAddressFromDatabase();

    if (sExtAddress == "")
        sExtAddress = ACR_SERVER_IP;

    // check that the server information is in the database
    ACR_SQLQuery("SELECT * FROM servers WHERE ID=" + sSID);

    // create the record if it does not already exist
    if (ACR_SQLFetch() != SQL_SUCCESS)
    {
        ACR_SQLQuery("INSERT INTO servers (ID, Name, IPAddress) VALUES(" + sSID + ",'" + ACR_SQLEncodeSpecialChars(sServerName) + "','" + sExtAddress + "')"); 
    }
    else
    {    
        // update server name and ip address if they've changed
        if (ACR_SQLGetData(1) != sServerName)
        {
            ACR_SQLQuery("UPDATE servers SET Name='" + ACR_SQLEncodeSpecialChars(sServerName) + "' WHERE ID=" + sSID);
        }
    }

    //  EDIT: Only where ServerID = the ID of the server that has just finished loading.
        ACR_SQLQuery("UPDATE characters SET IsOnline=0 WHERE ServerID=" + sSID);
    
    // Initialize chatlogging buffer
    ACR_InitializeChat();

    // Initialize server IPC support
    ACR_ServerIPC_OnModuleLoad();

    // This should be the last time in this function.
    ACR_PrintDebugMessage("acr_mod_events_i: ALFA server " + sServerId + " loaded.", _ONLOAD_DEBUG, DEBUG_LEVEL_INFO);

    // Start the health monitor (in a DelayCommand to reset the instruction/loop
    // count limit).
    DelayCommand(0.1f, ACR_StartModuleInitHealthChecks());
    // Delete unnecessary objects, such as walkmesh helpers, from statically
    // placed areas.
    ACR_PerformModuleStartupCleanup();
    ACR_LogEvent(OBJECT_INVALID, ACR_LOG_SERVER_LOAD, "Server " + sServerId + " loaded module " + GetName(GetModule()) + ".");

    WriteTimestampedLogEntry("Module compiled on: " + ACR_GetBuildDate() + ", HAK compiled on: " + ACR_GetHAKBuildDate() + ", module ACR version: " + ACR_GetVersion());

    // Increment the global server startup counter statistic.
    ACR_IncrementStatistic("MODULE_LOADS");

    // The following function call is never called.  This is intentional; the
    // purpose of this line is to ensure that the compiler cannot elide any
    // symbols referenced by ACR_ModuleInit_ForceLinkageForCLRScripts.
    if (Random(2) == 42)
        ACR_ModuleInit_ForceLinkageForCLRScripts();

    // This is needed to establish the server and gameobject structures that 
    // ACR_CreatureBehavior uses.
    ACR_InitializeCreatureBehavior();
}

void ACR_ModuleOnModuleStart()
{
}

void ACR_ModuleOnClientEnter()
{
    object oPC = GetEnteringObject(), oCorpse = OBJECT_INVALID;

	 if (!ACR_ModuleOverrideEvent(ACR_MODULE_ON_CLIENT_ENTER, TRUE))
	 	return;

    // exit if the database is unavailable
    if (ACR_GetModuleStatus(ACR_MOD_NWNX_FAILED))
    {
        ACR_PrintDebugMessage("acr_mod_events_i: ERROR - NWNX Unavailable on " + GetName(oPC) + " login.", _ONLOAD_DEBUG, DEBUG_LEVEL_FATAL);
           // boot players and log the error
           if (! GetIsDM(oPC))
            {
                SendMessageToPC(oPC, "Booted because NWNX isn't running on the server (server internal error).");
                BootPC(oPC);
                return;
            }
    }

    // Code executed for DMs and PCs goes here

    // initialize the player - RUN THIS BEFORE INITIALIZING OTHER SYSTEMS
    if (!ACR_PCOnClientEnter(oPC))
     {
        return;
     }
    
    // Zero out the RP XP timer. Though this looks ill-placed, we need it to detect redundant
    // tickers.
    SetLocalInt(oPC, _RPXP_HB, 0);

    // notify database system of login
    ACR_DBPersistOnIncomingPlayer(oPC);

    //initialize for chatlogging
    ACR_ChatOnClientEnter(oPC);

    // Initialize DM Client Extension pack (optional)
    ExecuteScript("wand_init", oPC);
    
    if (ACR_GetIsDMControlled(oPC))
    {
        // log the entry
        ACR_LogEvent(oPC, ACR_LOG_LOGIN, "Dungeon Master: " + ACR_SQLEncodeSpecialChars(GetName(oPC)) + " from IP: "+GetPCIPAddress(oPC));

        ACR_IncrementStatistic("DM_LOGINS");
    }
    else
    {
        // log the entry
        ACR_LogEvent(oPC, ACR_LOG_LOGIN, "Character: " + ACR_SQLEncodeSpecialChars(GetName(oPC))+ " from IP: "+GetPCIPAddress(oPC));
        
        // manage dead PCs - important for this to be done first
        ACR_DeathOnClientEnter(oPC);
		
        ACR_SkillsOnClientEnter(oPC);
		
		// If this is a first login, run the character creation function.
		if ( GetLocalInt( oPC, ACR_NEW_CHARACTER ) ) {
			ACR_HandlePCCreation( oPC );
			DeleteLocalInt( oPC, ACR_NEW_CHARACTER );
		}
    }
    
    // Do custom feat stuff.
    ACR_FeatOnClientEnter(oPC);

    // Let the IPC subsystem know of the login event.
    ACR_ServerIPC_OnClientEnter(oPC);

    // Let the wealth subsystem know of the login event.
    ACR_WealthOnClientEnter(oPC);

    ACR_IncrementStatistic("PLAYER_LOGINS");

	 ACR_ModuleOverrideEvent(ACR_MODULE_ON_CLIENT_ENTER, FALSE);
}

void _createPlayerGUIs( object oPC )
{
//  ACR_OpenUniversalGUI( oPC );

    if(GetHasFeat(FEAT_ACR_COMBAT_EXPERTISE, oPC) || GetHasFeat(FEAT_ACR_POWER_ATTACK, oPC))
    {
        DisplayGuiScreen(oPC, "SCREEN_MODEBAR_2", FALSE, "modebar_2.xml");
    }

    if (ACR_GetIsDMControlled(oPC))
    {
        DisplayGuiScreen(oPC, "zspawn_b", FALSE, "zspawn_b.xml");
    }
}

void _updatePlayerGUIs( object oPC ) {
	if ( GetHasFeat( FEAT_ACR_COMBAT_EXPERTISE, oPC ) ) {
		_HandlePowExpGUIEvent( oPC, POWER_EXPERT_EVENT_OPEN_MENU, 0 );
		_HandlePowExpGUIEvent( oPC, POWER_EXPERT_EVENT_COMBAT_EXPERTISE_MENU, 0 );
	}
	if ( GetHasFeat( FEAT_ACR_POWER_ATTACK, oPC ) ) {
		_HandlePowExpGUIEvent( oPC, POWER_EXPERT_EVENT_OPEN_MENU, 0 );
		_HandlePowExpGUIEvent( oPC, POWER_EXPERT_EVENT_POWER_ATTACK_MENU, 0 );
	}
}

void ACR_ModuleOnPCLoaded()
{
    object oPC = GetEnteringObject();

	 if (!ACR_ModuleOverrideEvent(ACR_MODULE_ON_PC_LOADED, TRUE))
	 	return;
    
    CraftingOnPCLoaded(oPC);
    HorseOnPCLoaded(oPC);
    
    // process DMs
    if (ACR_GetIsDMControlled(oPC))
    {
         ACR_PCOnPCLoadedAsDM(oPC);
        if (GetItemPossessedBy(oPC, "abr_spawn_debug") == OBJECT_INVALID) { CreateItemOnObject("acr_spawn_debug", oPC); }
        if (GetItemPossessedBy(oPC, "acr_dcsetter") == OBJECT_INVALID) { CreateItemOnObject("abr_it_dmdcsetter", oPC); }
        ExecuteScript("dmfi_mod_pcload", GetModule());
        SetCollision( oPC, FALSE );
    }
    // process players
    else
    {
        int bSave = FALSE;
        
        // PC has Wizard levels, issue them a spellbook if they weren't issued one already
        if (ACR_HasCasterClass(oPC, "ARCANE")) {
            if (!ACR_GetPersistentInt(oPC, ACR_MOD_SPELLBOOK)) {
                bSave = TRUE;
                SetIdentified(CreateItemOnObject(ACR_MOD_SPELLBOOK_RESREF, oPC), TRUE);
                ACR_SetPersistentInt(oPC, ACR_MOD_SPELLBOOK, TRUE);
            }
        }
        // PC has Cleric/Ranger/Druid levels, issue them a holy symbol if they weren't issued one already
        if (ACR_HasCasterClass(oPC, "DIVINE")) {
            if  (!ACR_GetPersistentInt(oPC, ACR_MOD_HOLYSYMBOL)) {
                bSave = TRUE;
                SetIdentified(CreateItemOnObject(ACR_MOD_HOLYSYMBOL_RESREF, oPC), TRUE);
                ACR_SetPersistentInt(oPC, ACR_MOD_HOLYSYMBOL, TRUE);
            }    
        }
        if (!ACR_GetPersistentInt(oPC, ACR_MOD_STARTINGGOLD))
        {
            GiveGoldToCreature(oPC, 300);
            ACR_SetPersistentInt(oPC, ACR_MOD_STARTINGGOLD, TRUE);
            bSave = TRUE;
        }
        if ((GetXP(oPC) <= 1) && !ACR_GetPersistentInt(oPC, ACR_MOD_STARTARMORX))
        {
            DestroyObject(GetItemInSlot(INVENTORY_SLOT_CHEST, oPC));
            ACR_SetPersistentInt(oPC, ACR_MOD_STARTARMORX, TRUE);
            bSave = TRUE;
        }
        if (!ACR_GetPersistentInt(oPC, ACR_MOD_FIRSTAID_IT))
        {
            SetIdentified(CreateItemOnObject(ACR_MOD_HEALKIT_RESREF, oPC), TRUE);
            ACR_SetPersistentInt(oPC, ACR_MOD_FIRSTAID_IT, TRUE);
            bSave = TRUE;
        }

        // DO THIS FIRST
        // restore the player's status and location
        ACR_PCOnPCLoaded(oPC);

        // process dead players
        ACR_DeathOnPCLoaded(oPC);

        // rebuild the characters journal quest entries
        ACR_RebuildJournalQuestEntries(oPC);
        
        // queue up the skillpoint convo if it's an unconverted PC
        ACR_SkillsOnPCLoaded(oPC);

        // save the bic if inventory has been modified
        if (bSave) { ACR_PCSave(oPC, FALSE); }
                            
        // Initialize nonlethal damage system for the PC
        DelayCommand(4.0, ACR_NLD_OnPCLoaded(oPC));
    
        //  only do this if the PC is already adapted to custom skills.
        if (GetSkillRank(0, oPC, TRUE) == 2) {
            // Initialize DMFI for the entering player or DM
            ExecuteScript("dmfi_mod_pcload", GetModule());
            // initialize/award RP XP, start this after the PC is already in.
            DelayCommand(30.0, ACR_XPOnClientLoaded(oPC));
            // process simulated rest (spell uses handled accordingly)
            //  delay this long enough for the status restore to take effect for HP.
            DelayCommand(1.5, ACR_RestOnClientEnter(oPC));
        }
		
		// Refresh their PC Hide.
		ACR_RecalculatePCHide( oPC );
    }

    ACR_SCliExtOnPCLoaded(oPC);

    // Open any GUIs that we expect to linger open.
    _createPlayerGUIs(oPC);
	
	// Check for player offline messages.
	ACR_ReportOfflineMessages( oPC );

	 ACR_ModuleOverrideEvent(ACR_MODULE_ON_PC_LOADED, FALSE);
}

void ACR_ModuleOnClientLeave()
{
    object oPC = GetExitingObject();

	 if (!ACR_ModuleOverrideEvent(ACR_MODULE_ON_CLIENT_LEAVE, TRUE))
	 	return;

    // Code executed for DMs and PCs goes here.

    if(ACR_GetIsDMControlled(oPC))
    {
        // Code only executed for DMs goes here.

        // log the departure
        ACR_LogEvent(oPC, ACR_LOG_LOGOUT, "Dungeon Master: " + ACR_SQLEncodeSpecialChars(GetName(oPC)));
    }
    else
    {
        // Code only executed for PCs goes here.

        // log the departure
        ACR_LogOnExit(oPC);

#if 0
        object oItem = GetFirstItemInInventory(oPC);
        // Commented this loop out for now, since we don't do anything there
        /*
        while(oItem != OBJECT_INVALID)
        {
            // Code which executes on a PC's items goes here.
            oItem = GetNextItemInInventory();
        }
        */

#endif
        // track resting across sessions
        ACR_RestOnClientLeave(oPC);
        
        // clean up Subdual mode leftovers
        ACR_NonLethalOnClientExit(oPC);
           ACR_SkillsOnClientExit(oPC);
    }

 
    // cancel xp craft if in session
    if (GetLocalObject(oPC,"XC_ITEM_TO_CRAFT") != OBJECT_INVALID) {
        XPCraft_ActionCancelChanges(oPC);
    }
    
    ACR_PCOnClientLeave(oPC);
    
    // bank logged XP
    ACR_XPOnClientExit(oPC);

    // clean up chatlogging pointers
    ACR_ChatOnClientExit(oPC);

    // notify database system of logout
    ACR_DBPersistOnOutgoingPlayer(oPC);

    // Let the IPC subsystem know of the logout event.
    ACR_ServerIPC_OnClientLeave(oPC);

    // Let the area instancing subsystem know of the logout event.
    ACR_AreaInstance_OnClientLeave(oPC, FALSE);

    // Notify the CE subsystem so that it can purge its local state.
    ACR_SCliExtOnClientLeave(oPC);

	 ACR_ModuleOverrideEvent(ACR_MODULE_ON_CLIENT_LEAVE, FALSE);
	 
	 HorseOnExit(oPC);
}

void ACR_ModuleOnAcquireItem()
{
    object oItem = GetModuleItemAcquired();
    object oAcquiredFrom = GetModuleItemAcquiredFrom();
    object oAcquiredBy = GetModuleItemAcquiredBy();
    int nItemStackSize = GetModuleItemAcquiredStackSize(), bLogEvent = TRUE;
    string sTag;

	 if (!ACR_ModuleOverrideEvent(ACR_MODULE_ON_ACQUIRE_ITEM, TRUE))
	 	return;
	 	
	 	HorseOnAcquire();

    // SendMessageToAllDMs("Acquired Item: "+GetName(oItem)+" by "+GetName(oAcquiredBy)+" with valid: "+IntToString(GetIsObjectValid(oAcquiredBy))+ " in area "+GetName(GetArea(oAcquiredBy))+" with valid: "+IntToString(GetIsObjectValid(GetArea(oAcquiredBy))));
 
    // only process player acquisitions
    if (! GetIsPC(oAcquiredBy)) { return; }

    // ignore acquisition events triggered by DMs (for logging only)
    if (ACR_GetIsDMControlled(oAcquiredBy)) { bLogEvent = FALSE; }

    // ignore acquisition events triggered by logins (for logging only)
    else if (! GetIsObjectValid(GetArea(oAcquiredBy))) { bLogEvent = FALSE; }
    
    ACR_ItemOnAcquire(oItem, oAcquiredBy, oAcquiredFrom);
    
    ACR_CraftingOnAcquireObject(oItem, oAcquiredBy, oAcquiredFrom);
    
    // track the presence of non-detection items
    //  We don't use these yet, skip this call.
    //ACR_ManageNonDetectionOnAcquire(oItem, oAcquiredBy);

    // trap items with illegal properties
    // Since we don't use this yet, commenting out.
    //  if/when this is restored, should cache the list to a local array on the module
    //   as querying the database each time is extremely inefficient.
    /*
    if (ACR_GetHasIllegalProperties(oItem))
    {
        sEvent = ACR_LOG_ACQUIRE_ILLEGAL;
                
        // quarantine the item?
    }
    */
    
    // log item acquisitions
        sTag = GetTag(oItem);

    if ((sTag == "acr_nld_fist") || (sTag == "acr_ignore_acquire")) {
        sTag = GetLocalString(oItem, "ACR_IGNORE_ACQUIRE_TEMP");
        if (sTag != "") {
            SetTag(oItem, sTag);
            DeleteLocalString(oItem, "ACR_IGNORE_ACQUIRE_TEMP");
        }
        // don't need to log this, OOC from toggling subdual mode
    } else if (bLogEvent) {
        ACR_LogOnAcquired(oItem, oAcquiredBy, GetStolenFlag(oItem));
        // Also only need to process quest item acquisitions if PC is already in the mod.
        // grant quest XP for acquired quest items
        ACR_QuestItemOnAcquire(oAcquiredBy, oItem);
    }

	 ACR_ModuleOverrideEvent(ACR_MODULE_ON_ACQUIRE_ITEM, FALSE);
}

void ACR_ModuleOnUnAcquireItem() {
    object oItem = GetModuleItemLost();
    object oLostBy = GetModuleItemLostBy();
    string sTag;
    
    // only process player drops
    if (! GetIsPC(oLostBy)) { return; }
    ACR_WealthItemDroppedBy(oLostBy, oItem);
	 if (!ACR_ModuleOverrideEvent(ACR_MODULE_ON_UNACQUIRE_ITEM, TRUE))
	 	return;


	// flag items that are carried by DM avatars, so we can note that if they're ever acquired
	// by a PC.
	if (ACR_GetIsDMControlled(oLostBy)) { SetLocalInt(oItem, "DM_MULED", ACR_GetCharacterID(oLostBy)); }
 
    // fire handler for special items.
    ACR_ItemOnUnAcquire(oItem, oLostBy);

    // Nonlethal / subdual handling:
    ACR_NLD_OnWeaponSwitch(oLostBy, oItem, FALSE);
    
    // destroyed item in inventory are invalid but not OBJECT_INVALID
    // Items sold to stores fall into this category, so run scripts on them anyway
    //if (! GetIsObjectValid(oItem)) {
    //    SendMessageToPC(oLostBy, "Item has been destroyed.");
    //    return; 
    //}
    
    // track the presence of non-detection items
    ACR_ManageNonDetectionOnUnAcquire(oItem, oLostBy);

    // trap items with illegal properties
    //  Again, we don't have this managed via SQL tables, large waste of resources.
    //  commenting out for now, will replace with a locally cached version if it comes back later.
    /*
    if (ACR_GetHasIllegalProperties(oItem))
    {
        // log the event
        ACR_LogEvent(oLostBy, ACR_LOG_DROP_ILLEGAL, "Item: " + ACR_SQLEncodeSpecialChars(GetName(oItem)) + ", By: " + ACR_SQLEncodeSpecialChars(GetName(oLostBy)));
                
        // quarantine the item?
    }
    else */


        sTag = GetTag(oItem);

    if ((sTag == "acr_nld_fist") || (sTag == "acr_ignore_acquire")) {
        // don't need to log this, OOC from toggling subdual mode
        sTag = GetLocalString(oItem, "ACR_IGNORE_ACQUIRE_TEMP");
        if (sTag != "") {
            SetTag(oItem, sTag);
        DeleteLocalString(oItem, "ACR_IGNORE_ACQUIRE_TEMP");
        }
    } else {
        // log item acquisitions
        ACR_LogOnUnacquired(oItem, oLostBy, GetStolenFlag(oItem));
    }

	 ACR_ModuleOverrideEvent(ACR_MODULE_ON_UNACQUIRE_ITEM, FALSE);
}

void ACR_ModuleOnActivateItem() {
    object oItem = GetItemActivated();
    object oActivator = GetItemActivator();
    object oTarget = GetItemActivatedTarget();
    location locTarget = GetItemActivatedTargetLocation();

	 if (!ACR_ModuleOverrideEvent(ACR_MODULE_ON_ACTIVATE_ITEM, TRUE))
	 	return;

    // handle items.
    ACR_ItemOnActivate(oItem, oActivator, oTarget, locTarget);

    // log item activation
    ACR_LogEvent(oActivator, ACR_LOG_ACTIVATE, "Item: " + ACR_SQLEncodeSpecialChars(GetName(oItem)) + ", By: " + ACR_SQLEncodeSpecialChars(GetName(oActivator)));

	 ACR_ModuleOverrideEvent(ACR_MODULE_ON_ACTIVATE_ITEM, FALSE);
}

void ACR_ModuleOnPlayerDeath() {
    object oDead = GetLastPlayerDied();
    object oKiller = GetLastHostileActor();

	 if (!ACR_ModuleOverrideEvent(ACR_MODULE_ON_PLAYER_DEATH, TRUE))
	 	return;

    // *** check for disguises here - player names need to be restored for proper data logging on death ***
    
    // process the player death
    ACR_PlayerOnDeath(oDead, oKiller);
    // logging handled in ACR_PlayerOnDeath() - so we don't log false-positives from instakill protection.
    ACR_NLD_OnDeath(oDead);

	 ACR_ModuleOverrideEvent(ACR_MODULE_ON_PLAYER_DEATH, FALSE);
}

void ACR_ModuleOnPlayerDying() {
    object oDying = GetLastPlayerDying();
    object oAttacker = GetLastAttacker();

	 if (!ACR_ModuleOverrideEvent(ACR_MODULE_ON_PLAYER_DYING, TRUE))
	 	return;

    // process the player dying
    ACR_PlayerOnDying(oDying, oAttacker);

	 ACR_ModuleOverrideEvent(ACR_MODULE_ON_PLAYER_DYING, FALSE);
}

void ACR_ModuleOnPlayerLevelUp() {
    object oPC = GetPCLevellingUp();

	 if (!ACR_ModuleOverrideEvent(ACR_MODULE_ON_PLAYER_LEVEL_UP, TRUE))
	 	return;

	
	if(ACR_GetIsMember(oPC) == FALSE)
	{
		if(ACR_GetECL(oPC) > 3)
		{
			int nRemovedXP = GetXP(oPC) - 5999;
			SetXP(oPC, 5999);
			GiveXPToCreature(oPC, nRemovedXP);
			SendMessageToPC(oPC, "You can not level past level 3 without being accepted as a member. See the 'Joining ALFA' link on the left hand side of www.alandfaraway.org for more information.");
			return;
		}
	}

    // handle the level up attempt
    ACR_ProcessLevelUpAttempt(oPC);
    
    // apply any hidden skill changes  
    ACR_SkillsOnPCLevelUp(oPC);
    
    // Handle ALFA's custom feat events.
    ACR_FeatsOnPCLevelUp( oPC );

    // apply extra languages if necessary
    ACR_LanguagesOnLevelUp(oPC);

    // check for major changes to anatomy.
    // ACR_CheckBodyPartsOnLevelUp(oPC); // DMA opposes wings on PCs; this feature is disabled pending agreement or LA ruling.
    
    // Update GUIs.
    _updatePlayerGUIs( oPC );
	
    // log the level up attempt
    ACR_LogEvent(oPC, ACR_LOG_LEVELUP, "Character: " + ACR_SQLEncodeSpecialChars(GetName(oPC)) + ", Level: " + IntToString(GetHitDice(oPC)));

	 ACR_ModuleOverrideEvent(ACR_MODULE_ON_PLAYER_LEVEL_UP, FALSE);
}

void ACR_ModuleOnPlayerRespawn() {
    object oPC = GetLastRespawnButtonPresser();

	 if (!ACR_ModuleOverrideEvent(ACR_MODULE_ON_PLAYER_RESPAWN, TRUE))
	 	return;

	 ACR_ModuleOverrideEvent(ACR_MODULE_ON_PLAYER_RESPAWN, FALSE);
}

void ACR_ModuleOnPlayerRest() {
    object oPC = GetLastPCRested();
    int nRestState = GetLastRestEventType();

	 if (!ACR_ModuleOverrideEvent(ACR_MODULE_ON_PLAYER_REST, TRUE))
	 	return;

    ACR_OnPlayerRest(oPC, nRestState);

	 ACR_ModuleOverrideEvent(ACR_MODULE_ON_PLAYER_REST, FALSE);
}

void ACR_ModuleOnHeartbeat() {
}

void ACR_ModuleOnUserDefined() {
    int nEvent = GetUserDefinedEventNumber();

	 if (!ACR_ModuleOverrideEvent(ACR_MODULE_ON_USER_DEFINED, TRUE))
	 	return;

	 ACR_ModuleOverrideEvent(ACR_MODULE_ON_USER_DEFINED, FALSE);
}

void ACR_ModuleOnPlayerEquip() {
    object oItem = GetPCItemLastEquipped();
    object oPC = GetPCItemLastEquippedBy();

	 if (!ACR_ModuleOverrideEvent(ACR_MODULE_ON_PLAYER_EQUIP, TRUE))
	 	return;
    
    // Crafting system hook.
    ACR_CraftOnEquipItem(oPC, oItem);
    
    // handle equipped items.
    ACR_ItemOnEquip(oItem, oPC);
    
    // handle nonlethal damage modes
    ACR_NLD_OnWeaponSwitch(oPC, oItem);

    // Do feat-specific stuff.
    ACR_FeatOnEquipItem(oPC, oItem);

	 ACR_ModuleOverrideEvent(ACR_MODULE_ON_PLAYER_EQUIP, FALSE);
}

void ACR_ModuleOnPlayerUnequip() {
    object oItem = GetPCItemLastUnequipped();
    object oPC = GetPCItemLastUnequippedBy();

	 if (!ACR_ModuleOverrideEvent(ACR_MODULE_ON_PLAYER_UNEQUIP, TRUE))
	 	return;
	 	
	 	if(GetBaseItemType(oItem) == BASE_ITEM_CLOAK)
      CloakRemoved();
    
    // handle unequipped items
    ACR_ItemOnUnEquip(oItem, oPC);
    
    // Subdual / nonlethal handling
    DelayCommand(0.1, ACR_NLD_OnWeaponSwitch(oPC, oItem, FALSE));
    
    // Do feat-specific stuff.
    ACR_FeatOnUnequipItem(oPC, oItem);    

	 ACR_ModuleOverrideEvent(ACR_MODULE_ON_PLAYER_UNEQUIP, FALSE);
}

void ACR_ModuleOnCutsceneAbort() {
    object oPC = GetLastPCToCancelCutscene();

	 if (!ACR_ModuleOverrideEvent(ACR_MODULE_ON_CUTSCENE_ABORT, TRUE))
	 	return;

    // End the scrying effect for the PC aborting the cutscene
    if (ACR_GetIsScrying(oPC)) { ACR_ScryEnd(oPC); }

	 ACR_ModuleOverrideEvent(ACR_MODULE_ON_CUTSCENE_ABORT, FALSE);
}

string _ParseLang(object oSpeaker, string sText)
{
    string sLangPick;
    int n;

    n = FindSubString(sText,ACR_LANG_MSG_TOKEN);

    // @Abcdef -> abc
    sText = GetStringLowerCase(GetStringRight(GetSubString(sText, n, 4),3));

    sLangPick = ACR_LanguageAbbreviationToFullName(sText);

    if ( !ACR_IsLanguageKnown(oSpeaker, sLangPick) ) {
        SendMessageToPC(oSpeaker, "You don't know how to speak "+ACR_LangIDToString(sLangPick)+".");
        return ACR_GetDefaultLanguage( oSpeaker );
    }

    return sLangPick;
}

int _canXPForChatEvent(object oSpeaker, string sText)
{
    // Convert the text into a salted MD5 representation.
    sText = ACR_GetSaltedMD5(sText);

    string sOldChat1 = GetLocalString(oSpeaker, "SAVED_CHAT_1");
    string sOldChat2 = GetLocalString(oSpeaker, "SAVED_CHAT_2");
    string sOldChat3 = GetLocalString(oSpeaker, "SAVED_CHAT_3");
    string sOldChat4 = GetLocalString(oSpeaker, "SAVED_CHAT_4");
    string sOldChat5 = GetLocalString(oSpeaker, "SAVED_CHAT_5");

    SetLocalString(oSpeaker, "SAVED_CHAT_1", sText);
    SetLocalString(oSpeaker, "SAVED_CHAT_2", sOldChat1);
    SetLocalString(oSpeaker, "SAVED_CHAT_3", sOldChat2);
    SetLocalString(oSpeaker, "SAVED_CHAT_4", sOldChat3);
    SetLocalString(oSpeaker, "SAVED_CHAT_5", sOldChat4);

    if(sText == sOldChat1) return FALSE;
    if(sText == sOldChat2) return FALSE;
    if(sText == sOldChat3) return FALSE;
    if(sText == sOldChat4) return FALSE;
    if(sText == sOldChat5) return FALSE;

    return TRUE;
}

int ACR_ModuleOnChat(object oSpeaker, object oTarget, int nMode, string sText)
{
    int ProtectionLevel;
    int len;
    string sMessage, sCommand, c, sLangPick;

    // iterate the RPXP function to indicate an active PC
    if(_canXPForChatEvent(oSpeaker, sText))
        ACR_RPXPMarkActive(oSpeaker);

    ProtectionLevel = ACR_GetProtectionLevel();

    switch (nMode) {
        case CHAT_MODE_SERVER:
            // Local server console said something, check for server admin cmd
            // But not if this isn't the first player on the server, else we
            // handle the command once per every player.
            if (oTarget != GetFirstPC())
                return TRUE;
        case CHAT_MODE_SILENT_SHOUT:
            // DM channel command, check for server admin cmd
            len = GetStringLength(sText);
            c = GetStringLowerCase(GetStringLeft(sText, 4));

            if (c == "#sa " || c == "!sa ")
            {
                if (ACR_SrvAdmin_OnChat(oSpeaker, GetStringRight(sText, len-4)))
                    return FALSE;
                return TRUE;
            }
        case CHAT_MODE_SHOUT:
            return TRUE;
        case CHAT_MODE_TELL:
            // Record the last tell to and last tell from player ids for the
            // re-tell and reply commands.
            SetLocalInt(oSpeaker, ACR_MOD_LAST_TELL_TO, ACR_GetPlayerID(oTarget));
            SetLocalInt(oTarget, ACR_MOD_LAST_TELL_FROM, ACR_GetPlayerID(oSpeaker));

				//
				// Check that protection level allows for the speaker to send tells
				// to other players.
				//

				if ((ProtectionLevel >= MEMBER_PROTECTION_LEVEL_QUARANTINE_DM_ONLY_TELLS) &&
				    (!ACR_GetIsMember(oSpeaker)))
				{

					 if (ProtectionLevel > MEMBER_PROTECTION_LEVEL_QUARANTINE_DM_ONLY_TELLS)
					 {
					   SendMessageToPC(oSpeaker, "You don't have permission to send tells.");
					 	return FALSE;
					 }

					 if (!ACR_GetIsDMControlled(oTarget))
					 {
					 	SendMessageToPC(oSpeaker, "You don't have permission to send tells to a non-DM player.");
						return FALSE;
					 }
				}

            return TRUE;
    }

	 //
	 // Check protection level for non-tells - which allows all of the
	 // protection checks to be handled here, including the case for various
	 // custom commands like #t, etc. - which shouldn't be allowed (as the
	 // only functionality afforded such a quarantined member is to ask a DM for
	 // help).
	 //
	 // Note that this implies that non-members can't use the IRC gateway or any
	 // cross-server tells, but they would have to be quarantined anyway so
	 // cross-server tells would already not allow a reply to be received.
	 //
	 // N.B.  Non-PC objects are treated as though they are members by
	 //       ACR_GetIsMember().  This simplifies handling of various cases
	 //       where NPCs, items, placeables, etc. may speak on behalf of a
	 //       script.
	 //

	 if ((nMode != CHAT_MODE_TELL) &&
	     (nMode != CHAT_MODE_SERVER) &&
	     (ProtectionLevel >= MEMBER_PROTECTION_LEVEL_QUARANTINE_DM_ONLY_TELLS) &&
		  (ACR_GetIsMember(oSpeaker) == FALSE))
	 {
	    SendMessageToPC(oSpeaker, "You don't have permission to send non-tell messages.");
	    return FALSE;
	 }

    len = GetStringLength(sText);

    c = GetStringLeft(sText, 1);

    // Is this someone setting a listening anchor?
    if(sText == "#1" || sText == "#2" || sText == "#3" || sText == "#4" || sText == "#5" || sText == "#6" || sText == "#7" || sText == "#8" || sText == "#9" || sText == "#0")
    {
           object PlayerAvatar = GetOwnedCharacter(oSpeaker);
        oTarget = GetPlayerCurrentTarget(oSpeaker);
        if(!GetIsObjectValid(oTarget))
        {
                // Allow setting an empty target to delete an already set mouthpiece target.
                  object SpeakTo;
                  if ((SpeakTo = GetLocalObject(PlayerAvatar, "SpeakTo_" + sText)) != OBJECT_INVALID)
                {
                    DeleteLocalObject(PlayerAvatar, "SpeakTo_" + sText);
                    SendMessageToPC(oSpeaker, "Clearing speak to association for " + sText);

                    if (GetLocalObject(SpeakTo, "MouthPiece") == PlayerAvatar)
                        DeleteLocalObject(SpeakTo, "MouthPiece");
                }
                else
                {
                SendMessageToPC(oSpeaker, "You must select an object to do that.");
                }
            return FALSE;
        }
        if(GetIsPC(oTarget))
        {
            SendMessageToPC(oSpeaker, "If you're that eager to write for all of the characters in this story, perhaps you should take up fanfiction?");
            return FALSE;
        }
        if(ACR_GetIsDMControlled(PlayerAvatar) || GetLocalInt(oTarget, "HENCHMAN_LEADER") == ACR_GetPlayerID(oSpeaker) || GetMaster(oTarget) == oSpeaker)
        {
                  // Check if another player owned this mouthpiece.  If so then try
                // and remove the association on their and and warn the previous
                // controller.
                  object PreviousMouthPiece = GetLocalObject(oTarget, "MouthPiece");
                if (PreviousMouthPiece != OBJECT_INVALID && PreviousMouthPiece != PlayerAvatar)
                {
                    SendMessageToPC(PreviousMouthPiece, "Mouthpiece (speak-to) control lost for object: " + GetName(oTarget) + " because another player or DM has taken control.");

                    int i;
                    for (i = 1; i < 10; i += 1)
                    {
                        if (GetLocalObject(PreviousMouthPiece, "SpeakTo_#" + IntToString(i)) == oTarget)
                        {
                            DeleteLocalObject(PreviousMouthPiece, "SpeakTo_#" + IntToString(i));
                        }
                    }
                }
            SetLocalObject(PlayerAvatar, "SpeakTo_" + sText, oTarget);
            SetLocalObject(oTarget, "MouthPiece", PlayerAvatar);
            SendMessageToPC(oSpeaker, "Setting "+GetName(oTarget)+" as anchored to "+sText+".");
            return FALSE;
        }
        SendMessageToPC(oSpeaker, "You cannot anchor your chat to that object.");
        return FALSE;
    }
	// Do we want to know what our currently set anchors are?
	else if ( sText == "#alist" )
	{
		object PlayerAvatar = GetOwnedCharacter(oSpeaker);
		int i = 0;
		int nListed = 0;
		SendMessageToPC( oSpeaker, "Listing speaking anchors:" );
		SendMessageToPC( oSpeaker, "#<C=lightblue>index</C> - <C=lightblue>name</C> ( <C=lightblue>tag</C> ) - <C=lightblue>area name</C> ( <C=lightblue>area_tag</C> ) - <C=lightblue>health</C>" );
		for ( i = 0; i < 10; i++ ) {
			string sAnchor = "SpeakTo_#" + IntToString( i );
			object oAnchor = GetLocalObject( PlayerAvatar, sAnchor );
			if ( GetIsObjectValid( oAnchor ) ) {
				string sOutput = "#" + IntToString(i);
				sOutput += " - " + GetName( oAnchor ) + " ( " + GetTag( oAnchor ) + " )";
				sOutput += " - " + GetName( GetArea( oAnchor ) ) + " ( " + GetTag( GetArea( oAnchor ) ) + " )";
				sOutput += " - " + IntToString( GetCurrentHitPoints( oAnchor ) ) + "/" + IntToString( GetMaxHitPoints( oAnchor ) ) + " HP";
				SendMessageToPC( oSpeaker, sOutput );
				nListed++;
			}
			if ( nListed == 0 ) SendMessageToPC( oSpeaker, "<i>No anchors found.</i>" );
		}
	}
    // Is this someone speaking through the anchor?
    else if(GetStringLeft(sText, 2) == "#1" || GetStringLeft(sText, 2) == "#2" || GetStringLeft(sText, 2) == "#3" || GetStringLeft(sText, 2) == "#4" || GetStringLeft(sText, 2) == "#5" || GetStringLeft(sText, 2) == "#6" || GetStringLeft(sText, 2) == "#7" || GetStringLeft(sText, 2) == "#8" || GetStringLeft(sText, 2) == "#9" || GetStringLeft(sText, 2) == "#0")
    {
           object PlayerAvatar = GetOwnedCharacter(oSpeaker);
        string sAnchor = "SpeakTo_" + GetStringLeft(sText, 2);
        object oAnchor = GetLocalObject(PlayerAvatar, sAnchor);
        sText = GetStringRight(sText, len-3);
        c = GetStringLeft(sText, 1);

        // We haven't anchored to this number; maybe we're trying to grab by a tag?
        if(!GetIsObjectValid(oAnchor))
        {
            oTarget = GetObjectByTag(sText);
            if(!GetIsObjectValid(oTarget))
            {
                SendMessageToPC(oSpeaker, "You must specify a valid object tag to do that.");
                return FALSE;
            }
            if(GetIsPC(oTarget))
            {
                SendMessageToPC(oSpeaker, "If you're that eager to write for all of the characters in this story, perhaps you should take up fanfiction?");
                return FALSE;
            }
            if(ACR_GetIsDMControlled(oSpeaker) || GetLocalInt(oTarget, "HENCHMAN_LEADER") == ACR_GetPlayerID(oSpeaker) || GetMaster(oTarget) == oSpeaker)
            {
                SetLocalObject(PlayerAvatar, sAnchor, oTarget);
                SetLocalObject(oTarget, "MouthPiece", PlayerAvatar);
                SendMessageToPC(oSpeaker, "Setting "+GetName(oTarget)+" as anchored to "+sText+".");
                return FALSE;
            }
            SendMessageToPC(oSpeaker, "You cannot anchor your chat to that object.");
            return FALSE;
        }

        int nTalkVolume = TALKVOLUME_TALK;
        if(nMode == CHAT_MODE_WHISPER) nTalkVolume = TALKVOLUME_WHISPER;

        // We assume that DMs know what they're doing. Their targets can speak foreign languages.
        if(ACR_GetIsDMControlled(PlayerAvatar))
        {
                 if (FindSubString(sText, "@") != -1)
                {
                sLangPick = _ParseLang(PlayerAvatar, sText);
                sText = _RemoveLangTag(sText);
                }
                else
                {
                    sLangPick = ACR_GetDefaultLanguage(PlayerAvatar);
                }
            int nHandleLang = _HandleLang(oAnchor, sText, nMode, sLangPick, PlayerAvatar);
            if (nHandleLang)
            {
                AssignCommand(oAnchor, _SpeakString(sText, nTalkVolume));
            }
            return FALSE;
        }
  
        // Players we can't trust as much. Their anchors can only speak common.
        else
        {
            sLangPick = "common";
                int nHandleLang = _HandleLang(oAnchor, sText, nMode, sLangPick, PlayerAvatar);
                if (nHandleLang)
                {
                AssignCommand(oAnchor, _SpeakString(sText, nTalkVolume));
                }
        }
        return FALSE;
    }
	
    // Allow DMs to use #setdesc to change an object's description.
    else if( GetStringLeft( sText, 8 ) == "#setdesc" )
    {
		// DM-only command.
		if ( !ACR_GetIsDMControlled( oSpeaker ) ) {
			SendMessageToPC( oSpeaker, "This command may only be used by DMs." );
			return FALSE;
		}
		
		// Get the target to set a description.
		object oTarget = GetPlayerCurrentTarget( oSpeaker );
		if ( !GetIsObjectValid( oTarget ) ) {
			SendMessageToPC( oSpeaker, "Invalid use. Select a target to set its description." );
			return FALSE;
		}
		
		// Get the desired description.
        sText = GetStringRight( sText, len - 9 );
		SetDescription( oTarget, sText );
		
        return FALSE;
    }
	
    // Allow DMs to use #sethp to set a target's hit points.
    else if( GetStringLeft( sText, 6 ) == "#sethp" )
    {
		// DM-only command.
		if ( !ACR_GetIsDMControlled( oSpeaker ) ) {
			SendMessageToPC( oSpeaker, "This command may only be used by DMs." );
			return FALSE;
		}

		// Get the target to set a description.
		object oTarget = GetPlayerCurrentTarget( oSpeaker );
		if ( !GetIsObjectValid( oTarget ) ) {
			SendMessageToPC( oSpeaker, "Invalid use. Select a target to set its health." );
			return FALSE;
		}

		// Get the amount of HP.
		string sHP = GetStringRight( sText, len - 7 );
		int nHP = StringToInt( sHP );
		if ( sHP != "0" && nHP == 0) {
			SendMessageToPC( oSpeaker, "Health must be a number." );
			return FALSE;
		}
		if ( nHP < 0 ) {
			SendMessageToPC( oSpeaker, "Health must be greater than or equal to zero." );
			return FALSE;
		}

		// Attempt to set the HP.
		SetHitPoints( oTarget, nHP );

		return FALSE;
    }
	
    // Is this someone adding to the DM requests queue?
    else if(GetStringLeft(sText, 3) == "#dm")
    {
        sText = GetStringRight(sText, len - 4);
        object oDM = GetFirstPC(TRUE);
        while(GetIsObjectValid(oDM))
        {
            if(ACR_GetIsDMControlled(oDM))
            {
                NotifyPlayer(oDM, NOTIFY_TYPE_INFO, "Request from " + GetName(oSpeaker), GetName(oSpeaker) + ": " + sText);
            }
            oDM = GetNextPC(TRUE);
        }
        return FALSE;
    }

    // roll command
    if (c == "#" || c == "!")
    {
        // Check first for server admin cmd, which needs unedited casing
        c = GetStringLowerCase(GetStringLeft(sText, 4));

        if (c == "#sa " || c == "!sa ")
        {
            ACR_SrvAdmin_OnChat(oSpeaker, GetStringRight(sText, len-4));
            return FALSE;
        }
        else if (ACR_ServerIPC_OnChat(oSpeaker, nMode, sText))
        {
            return FALSE;
        }
		else if(c == "#ifs" || c == "#ifl" || c == "#not")
		{
			if(!GetIsDM(oSpeaker) && !GetIsDMPossessed(oSpeaker))
			{
				SendMessageToPC(oSpeaker, "This functionality is only available to DMs.");
				return FALSE;
			}
			sText = GetStringRight(sText, len-4);
			int nDC = -1;
			int nSkill;
			string sTickle;
			if(c == "#ifs")
			{
				nSkill = SKILL_SPOT;
				sTickle = "You spot something!";
				nDC = StringToInt(GetStringLeft(sText, 2));
				sText = GetStringRight(sText, len-7);
			}
			else if(c == "#ifl")
			{
				nSkill = SKILL_LISTEN;
				sTickle = "You hear something!";
				nDC = StringToInt(GetStringLeft(sText, 2));
				sText = GetStringRight(sText, len-7);
			}
			else
			{
				nSkill = -1;
				sTickle = "You notice something!";
			}
			string sSuccess = "";
			string sFailure = "";
			object oTarget = GetFirstPC(TRUE);
			while(GetIsObjectValid(oTarget))
			{
				if(GetArea(oSpeaker) == GetArea(oTarget) &&
				   oSpeaker != oTarget)
				{
					if(nSkill > -1)
					{
						if(ACR_SkillCheck(nSkill, oTarget, nDC, FALSE, FALSE, 0))
						{
							NotifyPlayer(oTarget, NOTIFY_TYPE_INFO, sTickle, sText, NOTIFY_WINDOW_MESSAGE_BOX, "", "", "OK", "");
							sSuccess += GetName(oTarget) + ",";
						}
						else
						{
              sFailure += GetName(oTarget) + ",";
						}
					}
					else
					{
						NotifyPlayer(oTarget, NOTIFY_TYPE_INFO, sTickle, sText, NOTIFY_WINDOW_MESSAGE_BOX, "", "", "OK", "");
						sSuccess += GetName(oTarget) + ",";
					}
				}
				oTarget = GetNextPC(TRUE);
			}
			if(sSuccess == "") sSuccess = "No one";
			if(sFailure == "") sFailure = "No one";
			sText = sSuccess + " received:\n" + sText + "\n" + sFailure + " did not.";
			sTickle = "Results of " + (nSkill > -1 ? " perception check, DC " + IntToString(nDC) : " notification");
			NotifyPlayer(oSpeaker, NOTIFY_TYPE_INFO, sTickle, sText, NOTIFY_WINDOW_MESSAGE_BOX, "", "", "OK", "");
			return FALSE;
		}

        sCommand = GetStringRight(GetStringLowerCase(sText), len-1);
        
        ParseRoll(oSpeaker, sCommand);

        return FALSE;
    }

    sLangPick = ACR_GetDefaultLanguage( oSpeaker );

    // the player is attempting to specify a different language.
    if (c == "@" || TestStringAgainstPattern("**@**",sText)) {
        sLangPick = _ParseLang(oSpeaker, sText);
        sText = _RemoveLangTag(sText);
    }
    

    return _HandleLang(oSpeaker, sText, nMode, sLangPick, oSpeaker);
}


int ACR_GetModuleStatus(int nStatus) {
    return (GetLocalInt(GetModule(), ACR_MOD_STATUS) & nStatus);
}

void ACR_SetModuleStatus(int nStatus) {
    object oModule = GetModule();
    SetLocalInt(oModule, ACR_MOD_STATUS, GetLocalInt(oModule, ACR_MOD_STATUS) | nStatus);
}


void ACR_HandlePCCreation( object oPC ) {
	// Fix hidden perform skill.
	ACR_AdjustHiddenPerformSkill( oPC );
}


int _MouthPieceNotInRange(object oMouthPiece, object oSpeaker, float fDistance)
{
    // Switch to the controlled character in case the DM avatar is possessing
    // someone and thus shunted to limbo.
    oMouthPiece = GetControlledCharacter(oMouthPiece);

    // If the objects aren't in the same area, then they are out of range for
    // normal message hearing.
    if (GetArea(oMouthPiece) != GetArea(oSpeaker))
        return TRUE;

    // If the distance between the objects exceeds the nominal transmission
    // distance for the associated talk type, then they are out of range for
    // normal message hearing.
    if (GetDistanceBetween(oMouthPiece, oSpeaker) > fDistance)
        return TRUE;

    // Otherwise, the message will be heard normally and won't need to be
    // relayed explicitly.
    return FALSE;
}

int _HandleLang(object oSpeaker, string sText, int nMode, string sLangPick, object DMFIToolOwner)
{
    // If we are to override language processing then stop now.  This is used
    // when we are distributing the scrambled version of a phrase that has been
    // voice thrown with a non-"common" language.  We have to suppress the
    // usual language handling here because :
    //
    // - For the voice throwing case we do language handling on the *send* side,
    //   rather than as a respons to a chat event.  This takes care of sending
    //   the translated text to those who ought to receive it.
    // - Then, on the send side, we send the scrambled version.  This is either
    //   done with SendChatMessage with the callback invoke suppressed (if the
    //   sender was a PC), in which case we would never get into _HandleLang for
    //   that case.  But if the sender was an NPC, we do ultimately re-enter the
    //   language handler for the scrambled text - and in that case we must
    //   recognize that we already distributed text to mouthpiece receivers.  If
    //   we didn't then they would get a mouthpiece redirection with the
    //   scrambled text with a language of "Common".

#if DEBUG_LANG
    WriteTimestampedLogEntry("_HandleLang(" + GetName(oSpeaker) + ", " + sText + ", " + IntToString(nMode) + ", " + sLangPick + ", " + GetName(DMFIToolOwner) + ")");
#endif

    if (GetLocalInt(oSpeaker, ACR_MOD_SUPPRESS_LANGUAGE))
    {
#if DEBUG_LANG
        WriteTimestampedLogEntry("Suppressing processing of language handling.");
#endif
        return TRUE;
    }

    object oTool = _GetDMFITool(DMFIToolOwner);
    string sNewString;
    
    if (sLangPick == "")
        sLangPick = "common";

    if (sLangPick == "common")
    {
        sNewString = sText;
    }
    else
    {
        object oTool = _GetDMFITool(DMFIToolOwner);
        sNewString = DMFI_ProcessLanguage(sText, sLangPick, oTool);
    }

    _DistributeTranslation(sText, sNewString, sLangPick, oSpeaker, nMode);

    return FALSE;
}

void ACR_ModuleInitHealthChecks()
{
    object Obj;
    int HighestObjectId = ObjectToInt(GetModule());

    // Start the latency monitor script up.  The latency monitor requires CLR
    // script support to function.  See LatencyMonitor\LatencyMonitor.cs for
    // more details on how to use server latency measurements.

    ExecuteScript("latencymonitor", OBJECT_SELF);

    // Connect the latency monitor to the health monitor script.

    SetGlobalString("ACR_SERVER_LATENCY_SCRIPT", "acr_healthmonitor");

    // Find the first object id assigned to dynamic objects so that the health
    // monitor subsystem can distinguish statically placed objects from those
    // that have been dynamically instantiated.
    Obj = CreateObject(OBJECT_TYPE_WAYPOINT, "nw_waypoint001", GetStartingLocation(), FALSE);

    if (Obj != OBJECT_INVALID)
    {
        HighestObjectId = ObjectToInt(Obj);
        DestroyObject(Obj);
    }

    WriteTimestampedLogEntry("Dynamically created objects start at ObjectId=" + IntToString(HighestObjectId));
    SetGlobalInt("ACR_FIRST_DYNAMIC_OBJECT_ID", HighestObjectId);
}

void ACR_StartModuleInitHealthChecks()
{
    // This function is just here so that a more obvious name shows up in the
    // stack trace if you boot the server when not in JIT mode and hit a TMI.
    // A TMI here means that you should boot the server in JIT mode.

    ACR_ModuleInitHealthChecks();
}

void ACR_SweepAreaOfUnneededObjects(object AreaObject)
{
    // Simply call the area instance cleanp function, which also handles cleanup
    // of a dynamically instantiated area copy.

    ACR_AreaInstance_StartupCleanup(AreaObject);
}

void ACR_PerformModuleStartupCleanup()
{
    object AreaObject;

    // Queue a cleanup task for each area that exists in the module.  The tasks
    // run in separate DelayCommands as they iterate over large numbers of
    // objects and may otherwise trip the instruction or loop count limits if
    // done all in one go.

    AreaObject = GetFirstArea();

    while (AreaObject != OBJECT_INVALID)
    {
        DelayCommand(0.0001f, ACR_SweepAreaOfUnneededObjects(AreaObject));
        AreaObject = GetNextArea();
    }
}

void ACR_ModuleInit_ForceLinkageForCLRScripts()
{
    // This code never runs.  It is simply here to force the compiler to include
    // certain symbols that CLR script code requires.

    ACR_AsyncSQLQueryEx("", OBJECT_INVALID);
    ACR_GetPersistentString(OBJECT_INVALID, "");
    ACR_GetServerAddressFromDatabase();
    ACR_SetPersistentString(OBJECT_INVALID, "", "");
    ACR_SQLQuery("");
    ACR_FlushQueryQueue(OBJECT_INVALID);
    ACR_PCSave(OBJECT_INVALID);
    ACR_GetVersion();
    ACR_DeletePersistentVariable(OBJECT_INVALID, "");
    ACR_GetBuildDate();
    ACR_GetHAKBuildDate();
    ACR_IncrementStatistic("DUMMY_STATISTIC");
    ACR_GetHAKVersion();
    ACR_RunScriptOnServer(0, "", "");
    ACR_LogEvent(OBJECT_INVALID, "", "", OBJECT_INVALID);
    ACR_PPSValidatePC(OBJECT_INVALID);
    ACR_PCUpdateStatus(OBJECT_INVALID, FALSE);
    ACR_RestOnClientEnter(OBJECT_INVALID);
    ACR_XPOnClientLoaded(OBJECT_INVALID);
	 ACR_GetIsMember(OBJECT_INVALID);
}

void _LoadAssemblies()
{
	// Note that the assembly loader must be loaded FIRST, before any other
	// CLRScript assembly that might choose to reference ALFA.Shared.dll.
	// Otherwise, a LoaderException for an unresolved reference to the shared
	// assembly is logged to the NWScript Accelerator plugin log file, and the
	// CLRScript assembly in question does not function properly.

	ClearScriptParams();
	AddScriptParameterInt(ACR_ASSEMBLY_LOADER_INITIALIZE);
	ExecuteScriptEnhanced("ACR_AssemblyLoader", GetModule(), TRUE);

	ClearScriptParams();
	AddScriptParameterInt(ACR_CANDLEKEEP_INITIALIZE_ARCHIVES);
	ExecuteScriptEnhanced("ACR_Candlekeep", GetModule(), TRUE);

	ClearScriptParams();
	AddScriptParameterInt(ACR_CHOOSERCREATOR_INITIALIZE);
	ExecuteScriptEnhanced("ACR_ChooserCreator", GetModule(), TRUE);

	// All assemblies and NWScript code that reference the SQL database during
	// startup must run after ACR_DatabaseConnector is initialized.  Note that
	// the database connector will block for a time until the the database is
	// brought online.

	ClearScriptParams();
	AddScriptParameterInt(ACR_DATABASE_CONNECTOR_INITIALIZE);
	ExecuteScriptEnhanced("ACR_DatabaseConnector", GetModule(), TRUE);
}

// This is needed to establish the server and gameobject structures that 
// ACR_CreatureBehavior uses.
void ACR_InitializeCreatureBehavior()
{
    ClearScriptParams();
    AddScriptParameterInt(100); // Is CREATUREBEHAVIOR_MODULE_ON_STARTED; acr_creature_i was being mean, so has to be magic numbered.
    ExecuteScriptEnhanced("acr_creaturebehavior", GetModule(), TRUE);
}

int ACR_ModuleOverrideEvent(string Event, int Precall)
{
	object Module = GetModule();
	string Script;

	Script = GetLocalString(Module, Event + (Precall ? ACR_MODULE_HOOK_PRE : ACR_MODULE_HOOK_POST));

	if (Script == "")
		return TRUE;

	ClearScriptParams();
	return ExecuteScriptEnhanced(Script, Module, TRUE);
}

#endif
