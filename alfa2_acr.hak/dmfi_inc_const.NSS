////////////////////////////////////////////////////////////////////////////////
// dmfi_inc_const - DM Friendly Initiative -  Define True Constants
// Original Scripter:  Demetrious      Design: DMFI Design Team
//------------------------------------------------------------------------------
// Last Modified By:   Demetrious           10/9/6 -> Qk for 1.10 11/07
//					   AcadiusLost			11/13/07 - added language switches
//					   AcaduysLOst			09/21/08 - disabled textemotes
//------------------------------------------------------------------------------
////////////////////////////////////////////////////////////////////////////////

// ALFA ACR change: DMFI_PLAYER_NAME_CHANGING = FALSE (changed PC names break ACR persistency)
//  also, added constant for lore DC

const int DMFI_LANGUAGELORE_DC = 25;					// increased difficulty to understand unknown tongues.
const int DMFI_LANGUAGETRANSLATE_DC = 45;	        // lore difficulty to translate unknown tongues.

// CONFIGURATION OPTIONS - You can change these - compile all scripts to see changes
// implemented in your module following any change.

const int DMFI_EMOTES_ENABLED = FALSE;				// Are emotes enabled on UI text entry?
const int DMFI_PLAYER_NAME_CHANGING = FALSE;			// Can PCs change their names?

const int DMFI_PCLANGUAGES_ENABLED = TRUE;			// Are player languages enabled?
const int DMFI_GIVE_COMMON=FALSE;					// Should all PCs be granted 'Common'?
const int DMFI_GIVE_DEFAULT_LANGUAGES=TRUE;		// Do we give out racial / class oriented PHB languaes?
const int DMFI_CHOOSE_LANGUAGES=TRUE;				// Should we show the Language Selection UI?	

// const int DMFI_ENABLE_LORELANG=TRUE;                //should the listener do a lore check to understand a language? (Qk)

const string DMFI_RUNSCRIPT_PREFIX="dmfi";			// If != "", limit runscript function to this prefix alone?
const int DMFI_PC_RUNSCRIPT_ALLOWED=FALSE;			// Can PCs have access to ANY runscript functionality?

const int DMFI_UPDATE_INVENTORY = TRUE;				// Should inventory bags auto-update on DM actions?  This 
													// can be expensive for players with a lot of items.  If you
													// run a PW and use these frequently on established players
													// I would strongly evaluate this option.

const string DMFI_POPUPMESSAGE =  "<color=Gold>GENERAL MESSAGE:</color>\n\n";
													//The string message for popup windows if you want to customize it (Qk)				
const string DMFI_STORE_DB = "DMFI_DB_MNGRTOOL";    //Name for the Manager Tool Database

const int DMFI_FOLLOWOFF = TRUE;                    //Do you like the follow off button? if FALSE will change to
													//standard follow function without the follow off button


// GLOBAL PRE-FIX CONSTANTS - you can change these if you really want although not suggested.
const string DMFI_CHAR_CMD = ".";
const string DMFI_CHAR_EMOTE = "*";
const string DMFI_CHAR_RUNSCRIPT = "[";

// DO NOT TOUCH BELOW HERE.  ONLY CHANGE THINGS ^^^^^^^ UP THERE ^^^^^^
//*********************************************************************

// Listener constants

const string DMFI_LISTENER_PC = "oDMFIListenerPC";
const string DMFI_HEARD_TEXT = "sDMFIHeard";
const string DMFI_HEARD_MODE = "sDMFIHeardMode";
const string DMFI_HEARD_SUPRESS = "sDMFIHeardSupress";
const string DMFI_OBJECT_SPEAKER = "oDMFISpeaker";
const string DMFI_OBJECT_LISTENER = "oDMFIListener";
const string DMFI_EXECUTE = "dmfi_exe_main";
const string DMFI_LISTEN_MONITOR = "nListenerMonitor";
const string DMFI_LISTENER_MISSING = "nListenerMissing:";
const string DMFI_FOLLOW = "DMFIFollow";
const string DMFI_FOLLOW_NPC = "DMFIFollowNPC";
const string DMFI_FOLLOW_TARGET = "DMFIFollowTarget";
const string DMFI_LISTEN = "DMFIListen";
const string DMFI_LISTEN_ON = "DMFIListenOn";
const string DMFI_LISTEN_END = "DMFIListenEnd";
const string DMFI_LISTENER = "oDMFIListener";
const string DMFI_LISTENER_REF = "dmfi_listener";
const string DMFI_LISTENER_TAG = "dmfi_listener";

// FAKE DM FLAG
const string DMFI_DM_STATE = "I_AM_A_DM";

// UI CONSTANTS
const string SCREEN_DMFI_SKILLS = "SCREEN_DMFI_SKILLS";
const string SCREEN_DMFI_CHGITEM = "SCREEN_DMFI_CHGITEM";
const string SCREEN_DMFI_CHGNAME = "SCREEN_DMFI_CHGNAME";
const string SCREEN_DMFI_PLAYER = "SCREEN_DMFI_PLAYER";
const string SCREEN_DMFI_FOLLOWOFF = "SCREEN_DMFI_FOLLOWOFF";
const string SCREEN_DMFI_LANGOFF = "SCREEN_DMFI_LANGOFF";
const string SCREEN_DMFI_LIST = "SCREEN_DMFI_LIST";
const string SCREEN_DMFI_VFXTOOL = "SCREEN_DMFI_VFXTOOL";
const string SCREEN_DMFI_AMBTOOL = "SCREEN_DMFI_AMBTOOL";
const string SCREEN_DMFI_DMLIST = "SCREEN_DMFI_DMLIST";
const string SCREEN_DMFI_COMMANDREF = "SCREEN_DMFI_COMMANDREF";
const string SCREEN_DMFI_SNDTOOL = "SCREEN_DMFI_SNDTOOL";
const string SCREEN_DMFI_MUSICTOOL = "SCREEN_DMFI_MUSICTOOL";
const string SCREEN_DMFI_DICETOOL = "SCREEN_DMFI_DICETOOL";
const string SCREEN_DMFI_ = "SCREEN_DMFI_";
const string SCREEN_DMFI_DM = "SCREEN_DMFI_DM";
const string SCREEN_DMFI_TEXT = "SCREEN_DMFI_TEXT";
const string SCREEN_DMFI_CHOOSE = "SCREEN_DMFI_CHOOSE";
const string SCREEN_DMFI_BATTLE = "SCREEN_DMFI_BATTLE";
const string SCREEN_DMFI_TRGTOOL = "SCREEN_DMFI_TRGTOOL";
const string SCREEN_DMFI_MNGRTOOL = "SCREEN_DMFI_MNGRTOOL";
const string SCREEN_DMFI_VFXINPUT = "SCREEN_DMFI_VFXINPUT";
const string SCREEN_DMFI_DESC = "SCREEN_DMFI_DESC";
const string DMFI_UI_ACTIVELANG = "ActiveLang";
const string DMFI_UI_LISTTITLE = "ListTitle";
const string DMFI_UI_SKILLTITLE = "SkillTitle";
const string DMFI_UI_LIST = "List";
const string DMFI_UI_DMLIST ="dmlist";

const string DMFI_REQ_INT = "DMFI_REQ_INT";
const string DMFI_UI_PAGE = "DMFI_UI_PAGE";
const string DMFI_UI_LIST_TITLE = "DMFILISTTITLE";
const string DMFI_LAST_UI_COM = "DMFILastUICom";
const string DMFI_AMB_NIGHT = "DMFIAmbNight";
const string DMFI_MUSIC_TIME = "DMFIMusicTime";
const string DMFI_CURRENT = "CURRENT";

const string DMFI_LIST_PRIOR = "DMFI_LIST_PRIOR";
const int DMFI_LIST_ABILITY = 1;
const int DMFI_LIST_LANG = 2;
const int DMFI_LIST_NUMBER = 3;
const int DMFI_LIST_TYPE = 4;

const string DMFI_MODE_CHAT = "PlayerModeChat";

const string SCREEN_MESSAGEBOX_REPORT = "SCREEN_MESSAGEBOX_REPORT";
const string SCREEN_MESSAGEBOX_DEFAULT = "SCREEN_MESSAGEBOX_DEFAULT";

// OBJECT CONSTANTS OR FILE NAMES
const string DMFI_TEMP = "DMFITemp";
const string DMFI_PC_UI_STATE = "dmfi_pc_ui_state";
const string DMFI_CONV_DEF = "dmfi_conv_def";
const string DMFI_CONV_DEF_PC = "dmfi_conv_def_pc";
const string DMFI_ITEM_TARGET = "DMFIItemTarget";
const string DMFI_EXE_CONV = "dmfi_exe_conv";
const string DMFI_EXE_CONV_PC = "dmfi_exe_conv_pc";
const string DMFI_FILE_LOCKER = "DMFI_FILE_LOCKER";
const string DMFI_ITEM_TAG = "dmfi_exe_tool";
const string DMFI_LAST_COMMAND = "DMFILastCommand";
const string DMFI_PAGE = "DMFIPage";
const string DMFI_PAGES = "DMFIPages";
const string DMFI_PLUGIN_TAG = "DMFI_Plugin_";
const string DMFI_SPEAKER = "DMFISpeaker";
const string DMFI_STORE = "DMFIStore";
const string DMFI_TARGET = "DMFITarget";
const string DMFI_TARGET_LOC = "DMFITargetLoc";
const string DMFI_TOOL = "DMFITool";
const string DMFI_TOOL_ACQUIRED = "DMFIToolAcquired";
const string DMFI_TOOL_DESTROYED = "DMFIToolDestroyed";
const string DMFI_TOOL_PC = "DMFIToolPC";
const string DMFI_TRANSLATE = "DMFITranslate";
const string DMFI_VOICEREF = "DMFIVoiceRef";
const string DMFI_DATABASE = "DMFIDatabase";
const string DMFI_TOOL_VERSION = "DMFIToolVersion";
const string DMFI_STORAGE = "nw_it_contain006";
const string DMFI_APPEARANCE = "DMFIAppearance";
const string DMFI_INVENTORY_TARGET = "DMFIInventoryTarget";
const string DMFI_INVEN_TEMP = "Inventory Target: ";

// PARSE CONSTANTS
const string DMFI_sTool = "DMFIsTool";
const string DMFI_sCommand = "DMFIsCommand";
const string DMFI_sParam1 = "DMFIsParam1";
const string DMFI_sParam2 = "DMFIsParam2";

//EVENT CONSTANTS
const int DMFI_PRE_EVENT = 1998;
const int DMFI_POST_EVENT = 1999;

//STATE CONSTANTS
const int DMFI_STATE_ERROR =2;
const int DMFI_STATE_NO_ACTION = 0;
const int DMFI_STATE_SUCCESS = 1;

//FUNCTION TYPE CONSTANTS
const string DMFI_COMMAND = "Command";
const string DMFI_EMOTE = "Emote";
const string DMFI_LANGUAGE = "Language";

//RESREF CONSTANTS
const string DMFI_WAYPOINT_RESREF = "nw_waypoint001";
const string DMFI_STORAGE_RESREF = "plc_secretobject";
const string DMFI_TOOL_RESREF = "dmfi_exe_tool";
const string DMFI_PCTOOL_RESREF = "dmfi_exe_pc";
const string DMFI_PORTAL = "dmfi_portal";

//SOUND FILE CONSTANTS
const string DMFI_EMOTE_LAUGH = "vs_fshaldrf_haha";
const string DMFI_EMOTE_WHISTLE = "as_pl_whistle2";

// dmfi_inc constants
const string DMFI_2DA = "sDMFI2DA_";

// dmfi_exe_main constants
const string DMFI_VOICE_TOGGLE = "DMFIVoiceToggle";
const string DMFI_LANGUAGE_TOGGLE = "DMFILangToggle";
const string DMFI_CHOOSE = "DMFIChoose";

const string DMFI_LAST_ROLLER = "DMFILastRoller";
const string DMFI_LAST_ROLL = "DMFILastRoll";

const string DMFI_MESSAGE_LIST = "DMFIMessage";
const string DMFI_MESSAGE_LIST_MAX = "DMFIMessageListMax";
const string DMFI_MESSAGE_REF = "DMFIMessageRef";

const string DMFI_HEARD = "DMFI_Heard";
const string DMFI_VOICE_CHAT_DISABLED = "DMFIVCDisabled";

// dmfi_exe_conv constants
const string DMFI_LOOP = "DMFI_Loop";
const string DMFI_PRIOR_PAGE = "DMFIPriorPage";
const string DMFI_PLUGIN_PROCESSED = "DMFIPluginProcessed";
const string DMFI_2DA_ON_TOOL = "DMFITool2da";
const string DMFI_PROMPT = "PROMPT_";

const string DMFI_VFX_DURATION = "DMFIVFXDuration";
const string DMFI_VFX_LAST = "DMFIVFXLast";
const string DMFI_VFX_RECENT = "DMFIRecent";

const string DMFI_AMBIENT_LOCATION = "DMFIAmbientLoc";
const string DMFI_AMBIENT_VOLUME = "DMFIAmbientVolume";

const string DMFI_SOUND_DELAY = "DMFISoundDelay";
const string DMFI_SOUND_VOLUME = "DMFISoundVolume";
const string DMFI_SOUND_LAST = "DMFISoundLast";
const string DMFI_SOUND_LAST_PRM = "DMFISoundParam";

const string DMFI_DICEBAG_DC = "DMFIDicebagDC";
const string DMFI_DICEBAG_DETAIL = "DMFIDicebagDetail";
const string DMFI_DICEBAG_REPORT= "DMFIDicebagReport";
const string DMFI_DICEBAG_ROLL = "DMFIDicebagRoll";

const string DMFI_PC_DICE = "DMFIPCDice";
const string DMFI_PC_NUMBER = "DMFIPCNumber";

const string DMFI_DEF_APP = "DMFIDefApp";

// dmif_inc_tool constants
const string DMFI_MUSIC_INITIALIZED = "DMFIMusicInitialized";
const string DMFI_MUSIC_BATTLE = "DMFIMusicBattle";
const string DMFI_MUSIC_DAY = "DMFIMusicDay";
const string DMFI_MUSIC_NIGHT = "DMFIMusicNight";

const string DMFI_PC = "Player";
const string DMFI_DM = "DM";
const string DMFI_STRING_EXECUTE = "Execute";
const string DMFI_STRING_PRIORITY = "Priority";
const string DMFI_STRING_OVERRIDE = "Override";
const string DMFI_STRING_LANGUAGE = "Language";
const string DMFI_STRING_COMMAND = "Command";
const string DMFI_STRING_EMOTE = "Emote";
const string DMFI_STRING_RULE = "Rule";
const string DMFI_STRING_NAME = "'Name";
const string DMFI_STRING_DMONLY = "DMOnly";
const string DMFI_STRING_MAX = "MAX";

const string DMFI_ITEM_PROPS = "ItemProps";

const string DMFI_STR_EFFECT = "DMFI_STR_EFFECT";
const string DMFI_DEX_EFFECT = "DMFI_DEX_EFFECT";
const string DMFI_CON_EFFECT = "DMFI_CON_EFFECT";
const string DMFI_SR_EFFECT = "DMFI_SR_EFFECT";
const string DMFI_HP_EFFECT = "DMFI_HP_EFFECT";

// 2da file reference constants
const string DMFI_2DA_COLUMN = "Label";
const string DMFI_2DA_COL_RESOURCE = "Resource";
const string DMFI_2DA_COL_DESCRIPT = "Description";
const string DMFI_2DA_COL_NAME = "Name";
const string DMFI_2DA_MUSIC = "ambientmusic";
const string DMFI_2DA_VFX = "visualeffects";
const string DMFI_2DA_COL_MAXVALUE = "MAXSINGLEITEMVALUE";

//const string DMFI_2DA_SOUND = "";
const string DMFI_2DA_AMBIENT = "ambientsound";
const string DMFI_2DA_SKILLS = "skills";
const string DMFI_2DA_ITEMVALUE = "itemvalue";
const string DMFI_2DA_DISEASE = "disease";
const string DMFI_2DA_POISON = "poison";


// Special use strings
const string PRM_ = " ";

// Page name constants
const string PG_MAIN = "MAIN";
const string PG_MUSIC = "MUSIC";
const string PG_DICEBAG = "DICEBAG";
const string PG_AMBIENT = "AMBIENT";
const string PG_VFX = "VFX";
const string PG_WEATHER = "WEATHER";
const string PG_SERVER = "SERVER";
const string PG_TARGET = "TARGET";
const string PG_CONFIRM_ACTION = "CONFIRMATION";
const string PG_INITIALIZE = "INITIALIZE";
const string PG_SOUND = "SOUND";
const string PG_CREATURE = "CREATURE";
const string PG_ITEM = "ITEM";
const string PG_MUSIC_CATEGORY = "MUSIC_CATEGORY";
const string PG_AMBIENT_CATEGORY = "AMBIENT_CATEGORY";

const string PG_LIST_ABILITY = "LIST_ABILITY";
const string PG_LIST_SKILL = "LIST SKILL";
const string PG_LIST_MUSIC_NWN2 = "LIST_MUSIC_NWN2";
const string PG_LIST_MUSIC_BATTLE = "LIST_MUSIC_BATTLE";
const string PG_LIST_MUSIC_MOTB = "LIST_MUSIC_MOTB";
const string PG_LIST_MUSIC_NWN1 = "LIST_MUSIC_NWN1";
const string PG_LIST_MUSIC_XP = "LIST_MUSIC_XP";

const string PG_LIST_SOUND = "LIST_SOUND";

const string PG_LIST_VFX_SPELL = "LIST_VFX_SPELL";
const string PG_LIST_VFX_IMP = "LIST_VFX_IMP";
const string PG_LIST_VFX_DUR = "LIST_VFX_DUR";
const string PG_LIST_VFX_MISC = "LIST_VFX_MISC";
const string PG_LIST_VFX_RECENT = "LIST_VFX_RECENT";

const string PG_LIST_AMBIENT_PEOPLE = "LIST_AMBIENT_PEOPLE";
const string PG_LIST_AMBIENT_CAVE = "LIST_AMBIENT_CAVE";
const string PG_LIST_AMBIENT_MAGIC = "LIST_AMBIENT_MAGIC";
const string PG_LIST_AMBIENT_MISC = "LIST_AMBIENT_MISC";

const string PG_LIST_10 = "LIST_10";
const string PG_LIST_50 = "LIST_50";
const string PG_LIST_300 = "LIST_300";
const string PG_LIST_100 = "LIST_100";
const string PG_LIST_24 = "LIST_24";
const string PG_LIST_DURATIONS = "LIST_DURATIONS";
const string PG_LIST_EFFECT = "LIST_EFFECT";
const string PG_LIST_DICE = "LIST_DICE";
const string PG_LIST_DISEASE = "LIST_DISEASE";
const string PG_LIST_POISON = "LIST_POISON";
const string PG_LIST_SOUND_CITY = "LIST_SOUND_CITY";
const string PG_LIST_SOUND_NATURE = "LIST_SOUND_NATURE";
const string PG_LIST_SOUND_PEOPLE = "LIST_SOUND_PEOPLE";
const string PG_LIST_SOUND_MAGICAL = "LIST_SOUND_MAGIC";
const string PG_LIST_APPEARANCE = "LIST_APPEARANCE";
const string PG_LIST_DMLANGUAGE = "LIST_DMLANGUAGE";

// These pages hold dynamic data
const string PG_TARGET_PC = "TARGET_PC";
const string PG_TARGET_NPC = "TARGET_NPC";
const string PG_TARGET_LOCAL = "TARGET_LOCAL";
const string PG_TARGET_PARTY = "TARGET_PARTY";
const string PG_TARGET_ITEM = "TARGET_ITEM";
const string PG_TARGET_OBJECT = "TARGET_OBJECT";
const string PG_TARGET_ITEMPROP = "TARGET_ITEMPROP";
const string PG_TARGET_EFFECT = "TARGET_EFFECT";

// PC ONLY PAGES
const string PG_PCMAIN = "PCMAIN";
const string PG_LIST_LANGUAGE = "LIST_LANGUAGE";
const string PG_LIST_POSSLANGUAGE = "LIST_POSSLANGUAGE";

const string DMFI_UI_ABILITY = "ability";
const string DMFI_UI_SKILL = "skill";
const string DMFI_UI_LANGUAGE = "language on";
const string DMFI_UI_DICE = "dice";



//void main() {}