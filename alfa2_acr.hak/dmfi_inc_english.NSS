////////////////////////////////////////////////////////////////////////////////
// dmfi_inc_english - DM Friendly Initiative -  Include file for English Translation
// Original Scripter:  Demetrious      Design: DMFI Design Team
//------------------------------------------------------------------------------
// Last Modified By:   Demetrious           1/12/7
//                    AcadiusLost (535-skills) 1/7/2008
//                    AcadiusLost  added Netherese and Loross, edit to skills 7/10/09
//------------------------------------------------------------------------------
////////////////////////////////////////////////////////////////////////////////
/*
This file holds the English translation for the DMFI Tools.

In v1.02, we have moved to a UI based format and in doing so, the translation code
is now NOT in good shape.  Please, if you have a translation for this file and the xml files
contact with the DMFI and we'll publish it. 

Thanks for your patience.  Demetrious - Qk

*/
// **************************** MESSAGING CONSTANTS ****************************

// Initialization type constants
const string TXT_ACQUIRE = "Please APPEAR and then use the DMFI Tool to initialize the system";
const string TXT_BASE_COMMAND = "DMFI Command: ";
const string TXT_DATA_LOAD = "Please wait while data is written to new DMFI Tool.";
const string TXT_DEBUG = "Debug: ";
const string TXT_DM_TOOL_WARNING = "This tool is for use by DMs ONLY.";

const string TXT_INITIALIZE_TOOL = "DMFI Database Detroyed.";  //context editted
const string TXT_INITIALIZE_DATABASE = "DMFI NOTICE:  Tool Database Updated.  Please log off the server to gain a current tool.";

const string TXT_ONE_TOOL = "Only one DMFI Tool allowed per character.";
const string TXT_UNACQUIRE = "You cannot drop this item.";
const string TXT_VERSION = "DMFI Base System Version: ";

// Plugin Messaging
const string TXT_PLUGIN_LOADED = "DMFI Plugins Loaded:";
const string TXT_PLUGIN_COMMAND = "DMFI Command Plugin: ";
const string TXT_PLUGIN_EMOTE = "DMFI Emote Plugin: ";
const string TXT_PLUGIN_LANGUAGE = "DMFI Language Plugin: ";
const string TXT_PLUGIN_LANG_ADDED = "DMFI Language Added via Plugin: ";
const string TXT_PLUGINS_INITIALIZED = "Success: All Plugins have been acquired";

// Targetting constants
const string TXT_ITEM_TARGET = "DMFI Item Target: ";
const string TXT_ROLLER = "Roller: ";
const string TXT_SUB_TARGET_REMOVED = "Any valid sub-targets deleted.";
const string TXT_TARGET = "DMFI Target: ";
const string TXT_TARGET_LOC = "Target is a Location.";
const string TXT_TARGET_TEMP = "Invalid Target: Target temporarily set to self.";

const string TXT_MESSAGE_DELIVERED = "DMFI Message Sent: ";

//Languages
const string TXT_ALL_LANGUAGES = "ALL LANGUAGES GRANTED TO DMs.";
const string TXT_LANGUAGE= "DMFI Langugage Granted: ";
const string TXT_LANGUAGE_KNOWN = "DMFI Language Already Known: ";
const string TXT_LANGUAGE_LIST = "DMFI Languages known by target: ";
const string TXT_LANGUAGE_REMOVED = "DMFI Language Removed: ";
const string TXT_NO_LANGUAGE = "Log Off!";

//Voice Throw
const string TXT_NO_ASSOCIATE = "Requires valid associate target.";  //edit
const string TXT_TRANSLATED = "Translated: ";
const string TXT_VOICE_TARGET = "DMFI Voice Target: ";
const string TXT_VOICE_TARGET_INVALID = "DMFI Voice Target not found: ";

// Parameter missing type constants
const string TXT_BACK_BATTLE_STOP = "'play' 'battle' or 'stop' parameter required.";
const string TXT_COMMAND_NOT_FOUND="DMFI Command Not Found:  Mistyped or command not known.";
const string TXT_CREATURE = "DMFI Target must be NPC or PC for this function.";
const string TXT_DAY_NIGHT = "'day' or 'night' parameter required.";
const string TXT_DAY_NIGHT_BATTLE = "'day' 'night' 'both' or 'battle' parameter required.";
const string TXT_DM_PC_PARTY = "'dm' 'pc' or 'party' parameter required.";
const string TXT_EFFECT = "DMFI Target must be a creature or placeable for this parameter.";
const string TXT_GOLD_NETWORTH_XP_INFO = "'gold' 'networth' 'xp' or 'information' parameter required.";
const string TXT_HIGH_MED_LOW = "'high' 'med' or 'low' parameter required.";
const string TXT_ITEM = "DMFI Target must be an item for this parameter.";
const string TXT_INVALID_ROLLER_TARGET = "DMFI Last Roller Not Found:  Object Invalid.";
const string TXT_INT = "Int Parameter required.";
const string TXT_INVENTORY = "DMFI Target must have an inventory for this parameter.";
const string TXT_INVALID_OBJECT = "Target Not Valid.";
const string TXT_INVALID_TARGET_OBJECT = "DMFI Target Invalid for Request:  NPC/PC Required";
const string TXT_KEY_MESSAGE_MISSING = "'key' or 'message' parameter required.";
const string TXT_NAME_OBJECT = "Non-PC Object required.";
const string TXT_NAME_REQUIRED = "Valid PC Name required.";
const string TXT_NO_EFFECT = "No valid effects found.";
const string TXT_NO_VALID_OBJECT = "No Valid Objects Found.";
const string TXT_OWN_ITEM = "You must name a valid item in your possession.  '.rename currentname newname'";
const string TXT_PAGE_NOT_FOUND = "ERROR: Page Not Found";
const string TXT_PARAM_MISSING = "PARAMETER MISSING or MISTYPED: ";
const string TXT_PC_PARTY_BEST = "'pc' 'party' or 'best' parameter required.";
const string TXT_PC_PARTY = "'pc' or 'party' parameter required.";
const string TXT_PC_REQ = "DMFI Target must be a PC for this action.";
const string TXT_STRING = "String Parameter required.";
const string TXT_TARGET_SELF = "'target' or 'self' parameter required.";


// SET related constants
const string TXT_SET_DESCRIPTION = "New Description: ";
const string TXT_SET_NAME_PRIOR = "DMFI Target: ";
const string TXT_SET_NAME_POST = "  New Set Name: ";

const string TXT_RETURN_ORIGINAL = "Original Name Restored.";

const string TXT_SET_DICEBAG_DC = "DMFI Dicebag DC set to: ";
const string TXT_SET_DETAILHIGH = "DMFI Dicebag Detail set to HIGH.  Shows ROLL vs. DC";
const string TXT_SET_DETAILMED = "DMFI Dicebag Detail set to MED.  Shows ROLL and RESULT only";
const string TXT_SET_DETAILLOW = "DMFI Dicebag Detail set to LOW.  Pass / Fail Only";
const string TXT_SET_REPORTDM = "DMFI Dicebag Reporting set to DM ONLY.";
const string TXT_SET_REPORTPC = "DMFI Dicebag Reporting set to DM and attempting PC ONLY.";
const string TXT_SET_REPORTPARTY = "DMFI Dicebag Reporting set to DM and entire PC PARTY.";
const string TXT_SET_ROLLPC = "DMFI Dicebag set to roll dice for targetted PC.";
const string TXT_SET_ROLLPARTY = "DMFI Dicebag set to roll dice for every individual party member.";
const string TXT_SET_ROLLBEST = "DMFI Dicebag set to roll a single check for the PC in the party with the best modifier.";

const string TXT_SET_MUSIC_DAY = "DMFI Music:  Day music set to: ";
const string TXT_SET_MUSIC_NIGHT = "DMFI Music:  Night music set to: ";
const string TXT_SET_MUSIC_BOTH = "DMFI Music:  Both day and night music set to: ";
const string TXT_SET_MUSIC_BATTLE = "DMFI Music:  Battle music set to: ";

const string TXT_SET_AMBIENT_DAY = "DMFI Ambient Sound (volume applied): Day set to: ";
const string TXT_SET_AMBIENT_DELAY = "DMFI Ambient Delay set to: ";
const string TXT_SET_AMBIENT_NIGHT = "DMFI Ambient Sound (volume applied): Night set to: ";
const string TXT_SET_AMBIENT_VOLUME = "DMFI Ambient Volume set to: ";

const string TXT_SET_SOUND_VOLUME = "DMFI Placeable Sound Volumen set to: ";
const string TXT_SET_SOUND_DELAY= "DMFI Placeable Sound Delay set to: ";

const string TXT_SET_VFX_DURATION = "DMFI VFX Duration set to: ";


// Command constants
const string TXT_FOLLOW_ON = "DMFI Set to Follow: ";
const string TXT_FOLLOW_OFF = "DMFI Follow Turned Off.";
const string TXT_FOLLOW_TARGET_SET = "DMFI Follow Target set.  NPCs can be set to follow this target: ";
const string TXT_FOLLOWING = " set to follow: ";
const string TXT_NOT_FOLLOWING = "NPC Follow Turned Off.";

const string TXT_MUSIC_BACKGROUND = "Background Music Started.";
const string TXT_MUSIC_BATTLE = "Battle Music started.";
const string TXT_MUSIC_STOP = "Music Stopped.";
const string TXT_MUSIC_RESTORE = "Music Restored to Default Settings";
const string TXT_MUSIC_DEFAULT = "Current Music Set to Default Settings";

const string TXT_SOUND_PLAYED= "DMFI Sound executed: ";
const string TXT_VFX_PLAYED = "DMFI Visual Effect: Ref: ";
const string TXT_VFX_LABEL = " Label: ";

const string TXT_AMBIENT_PLAY= "Ambient Sounds started.";
const string TXT_AMBIENT_STOP= "Ambient Sounds stopped.";

const string TXT_NOT_TRAINED = " FAILED:  Training is required for this skill.";
const string TXT_ROLL_PASSED = " SUCCESS ";
const string TXT_ROLL_FAILED = " FAILED ";
const string TXT_ROLL = "DMFI Dice Roll for: ";
const string TXT_MODIFIER = "  Mod: ";
const string TXT_TOTAL = "  TOTAL: ";
const string TXT_AGAINST_DC = "  Against DC: ";

const string TXT_DAY = "DMFI Environment: Daytime";
const string TXT_NIGHT = "DMFI Environment: Night";

const string TXT_FACING_COMPLETE = "DMFI Set Facing Complete.";
const string TXT_FACING_ERROR = "DMFI Facing Target Not Found.  Please check spelling.";

const string TXT_ROLL_DICE = "DMFI Dicebag Result: ";
const string TXT_ROLL_DICE_FORMAT_ERROR = "DMFI Dice format is .roll 2d4 where you roll d4 times 2. D&D Dice only.";

const string TXT_ITEMPROP_REMOVED = "Item Property Removed from target.";
const string TXT_EFFECT_REMOVED = "Effect Removed from target.";

const string TXT_WEATHER_CLEAR = "Weather set to Clear";
const string TXT_WEATHER_RAIN = "Weather set to Rain";
const string TXT_WEATHER_SNOW = "Weather set to Snow";
const string TXT_TIME = "Time set to hour: ";

const string TXT_INVENTORY_UBER = "Uber Items taken from target player";
const string TXT_INVENTORY_IDENTIFIED = "All inventory items for the target have been identified";
const string TXT_INVENTORY_STRIPPED = "All inventory items removed from target";

const string TXT_PLOT_CURSED_DROPPED_FLAG = "Note: Plot, Cursed, and Dropped Status toggled on items to ensure removal.";

const string TXT_PC_INVENTORY_STRIPPED = "DM has removed all of your inventory items. SERVER LOG NOTED. ";
const string TXT_PC_INVENTORY_IDENTIFIED = "DM has identified all inventory items for you.";
const string TXT_PC_INVENTORY_UBER = "DM has removed items from your inventory that are too strong for this module. SEVER LOG NOTED. ";

const string TXT_DM_ACTION = "DMFI Action Alert: ";

const string TXT_BOOTED = "DMFI Removed Player from Server: ";
const string TXT_DM_FROZEN = "Your character is DM frozen for 60 seconds.";
const string TXT_FROZEN = "DMFI Target is frozen for 60 seconds.";

const string TXT_STORE_PC = "DMFI Target saved for later use.";
const string TXT_STORE_PARTY = "DMFI Target's PARTY saved for later use.";
const string TXT_RECALL = "Any valid DMFI Stored PCs recalled.";
const string TXT_REPORT = "Reporting data for all PCs:";

const string TXT_PLAYERNAME = "PC Name: ";
const string TXT_CDKEY = "PC CD Key: ";
const string TXT_IPADRESS = "PC IP Address: ";

const string TXT_EFFECT_APPLIED = "DMFI Effect Applied: ";
const string TXT_EFFECT_ERROR = "DMFI Effect not found.  Examine DMFI Tool for accurate list of effects.";

// ALL NEW TXT items
const string TXT_SCALE = "DMFI Target Scale Percent: ";
const string TXT_INVALID_RESREF = "ResRef or Location is invalid for creation."; 
const string TXT_CREATE_DMTOOL = "DM Tool NOT in Database.  Wait while one is created.";  
const string TXT_CREATE_PCTOOL = "PC Tool NOT in Database.  Wait while one is created.";  
const string TXT_DMTOOL_STORED = "New DM Tool created in database.  To update, please log off / rejoin server.";
const string TXT_PCTOOL_STORED = "New PC Tool created in database.  Players:  To update, please log off / rejoin server.";

// ************************* CONVERSATION CONSTANTS ****************************
const string CV_PC_FOLLOW_ON = "Follow current target.";
const string CV_PC_FOLLOW_OFF = "Cancel Any Follow orders.";
const string CV_PC_ROLL_ABILITY = "Roll an Ability / Save Check.";
const string CV_PC_ROLL_SKILL = "Roll a Skill Check.";
const string CV_PC_ROLL_DICE = "Roll dem Bones.";
const string CV_PC_LANGUAGE = "Turn on a Language Toggle.";
const string CV_PC_LANGUAGE_OFF = "Deactivate the Language Toggle.";

const string CV_LD_D2 = "d2";
const string CV_LD_D3 = "d3";
const string CV_LD_D4 = "d4";
const string CV_LD_D6 = "d6";
const string CV_LD_D8 = "d8";
const string CV_LD_D10 = "d10";
const string CV_LD_D12 = "d12";
const string CV_LD_D20 = "d20";
const string CV_LD_D100 = "d100";

const string CV_SV_INVEN_IDENTIFY = "Identify ALL items for target.";
const string CV_SV_INVEN_STRIP = "Strip ALL items from target.";
const string CV_SV_INVEN_UBER = "Remove Uber Items from target.";
const string CV_SV_FREEZE = "Freeze player (behavoir)";
const string CV_SV_BOOT = "Boot Player from server.";

// Added 11/20/06
const string CV_SV_SCALE = "Scale target to percent.";

const string CV_IT_IDENTIFY = "Identify Item.";
const string CV_IT_DESTROY = "Destroy Item.";
const string CV_IT_TAKE = "Take Item.";
const string CV_IT_CURSED = "Toggle Cursed State.";
const string CV_IT_PLOT = "Toggle Plot State";
const string CV_IT_STOLEN = "Toggle Stolen State";
const string CV_RS_ITEM = "DMFI Item Manipulation";

const string CV_MC_NWN2 = "NWN2";
const string CV_MC_NWN1 = "NWN1";
const string CV_MC_XP = "Expansion";
const string CV_MC_BATTLE = "Battle";
const string CV_MC_MOTB = "MotB";
const string CV_MUSIC = "Music";

const string CV_AM_CAVE = "Cave";
const string CV_AM_MAGIC = "Magic";
const string CV_AM_PEOPLE = "People";
const string CV_AM_MISC = "Misc";
const string CV_AMBIENT = "Ambient";	

const string CV_SD_CITY = "City";
const string CV_SD_MAGIC = "Magic";
const string CV_SD_NATURE = "Nature";
const string CV_SD_PEOPLE = "People";
const string CV_SOUND = "Sound";	

const string CV_DI_ABIL = "Ability/SVs";
const string CV_DI_SKILL = "Skills";
const string CV_DI_DICE = "Dice";
const string CV_DICE = "Dice";

const string CV_VF_SPELLS = "Spells";
const string CV_VF_INVOCATION = "Invocation";
const string CV_VF_DURATION = "Duration";
const string CV_VF_MISC = "Misc";
const string CV_VF_RECENT = "Recent";
const string CV_VFX = "VFX";

const string CV_TOOL = "Tool";

const string CV_PROMPT_TIME = "Please choose the new hour:";
const string CV_PROMPT_EFFECTS = "Please choose the effect to remove:";
const string CV_PROMPT_SCALE = "Select PERCENT to scale:\nObsidian bug 200% then 50% != 100%";

const string CV_PROMPT_DC = "Please choose the new DC to roll against:";
const string CV_PROMPT_DELAY = "Select the new localized sound delay:";
const string CV_PROMPT_DURATION = "Please choose the new duration in seconds: (only applies to duration based effects)";

const string CV_PROMPT_VOLUME = "Please set the ambient sound volume.  Note: This is applied to FUTURE changes or play commands.";
const string CV_PROMPT_MS_TRACK = ":  Please select a music track:";
const string CV_PROMPT_ABILITY = "Please select an ability or save:";
const string CV_PROMPT_SV = "Please select a skill:";
const string CV_PROMPT_DICE = "Please select a number of dice to roll:";
const string CV_PROMPT_VFX = "Choose a VFX to play:";	
const string CV_PROMPT_SOUND = "Please select a sound to play at target location:";

const string CV_PROMPT_GRANT = "Choose a language to grant:";
const string CV_PROMPT_REMOVE = "Choose a language to remove:";
const string CV_PROMPT_CHOOSE = "Remaining Language Selections: ";

// **************************** COMMAND CONSTANTS ****************************** DO NOT TRANSLATE THIS
const string PRM_AMBIENT = "ambient";
const string PRM_BOOT = "boot";
const string PRM_CREATURE = "creature";
const string PRM_DAY = "day";
const string PRM_DELETE = "delete";
const string PRM_DICEBAG = "dicebag";
const string PRM_DISEASE = "disease";
const string PRM_DM = "dm";
const string PRM_FOLLOW = "follow";
const string PRM_FREEZE = "freeze";
const string PRM_INFORMATION = "information";
const string PRM_INITIALIZE = "initialize";
const string PRM_INVENTORY = "inventory";
const string PRM_LANGUAGE = "language";
const string PRM_LIST = "list";
const string PRM_LISTEN = "listen";
const string PRM_MUSIC = "music";
const string PRM_NIGHT = "night";
const string PRM_NPC = "npc";
const string PRM_POISON = "poison";
const string PRM_REMOVE = "remove";
const string PRM_RELOAD = "reload";
const string PRM_RENAME = "rename";
const string PRM_REPEAT = "repeat";
const string PRM_REPORT = "report";
const string PRM_ROLL = "roll";
const string PRM_SCALE = "scale";
const string PRM_SET = "set";
const string PRM_SOUND = "sound";
const string PRM_TARGET = "target";
const string PRM_TIME = "time";
const string PRM_TOGGLE = "toggle";
const string PRM_VFX = "vfx";
const string PRM_VOICE = "voice";
const string PRM_WEATHER = "weather";

// SPECIAL CASES WHERE AN EMPTY CHARACTER IS INCLUDED IN THE STRING
const string PRM_MESSAGE_PARTY = "[party ";
const string PRM_MESSAGE_LOCAL = "[local ";

// ************************** PARAMETER CONSTANTS ******************************

// NOTE:  These are just like EMOTE Constants but are partial.
const string PRM_ABILITY_STRENGTH = "streng";
const string PRM_ABILITY_DEXTERITY = "dex";
const string PRM_ABILITY_CONSTITUTION = "cons";
const string PRM_ABILITY_INTELLIGENCE = "inte";
const string PRM_ABILITY_WISDOM = "wis";
const string PRM_ABILITY_CHARISMA = "cha";

const string PRM_SAVE_FORTITUDE = "fort"; //note 3 letters will match perform
const string PRM_SAVE_REFLEX = "ref";
const string PRM_SAVE_WILL = "wil";

//const string PRM_SKILL_ANIMAL_EMPATHY = "ani";
const string PRM_SKILL_CONCENTRATION = "conc";
const string PRM_SKILL_DISABLE_TRAP = "disable";
//const string PRM_SKILL_DISCIPLINE = "disc";   // ALFA edit
const string PRM_SKILL_HEAL = "hea";
const string PRM_SKILL_HIDE = "hid";
const string PRM_SKILL_LISTEN = "listen";
//const string PRM_SKILL_LORE = "lor";   // ALFA edit
const string PRM_SKILL_MOVE_SILENTLY = "mov";
const string PRM_SKILL_OPEN_LOCK = "open";
const string PRM_SKILL_PARRY = "par";
//const string PRM_SKILL_PERFORM = "perf";  // ALFA edit
const string PRM_SKILL_PERSUADE = "pers";
const string PRM_SKILL_PICK_POCKET = "pick";
const string PRM_SKILL_SEARCH = "sea";
//const string PRM_SKILL_SET_TRAP = "settra";   // ALFA edit
const string PRM_SKILL_SPELLCRAFT = "spel"; // ALFA edit
const string PRM_SKILL_SPOT = "spo";
//const string PRM_SKILL_TAUNT = "tau";   // ALFA edit
const string PRM_SKILL_USE_MAGIC_DEVICE = "usema";
const string PRM_SKILL_APPRAISE = "app";
const string PRM_SKILL_TUMBLE = "tum";
//const string PRM_SKILL_CRAFT_TRAP = "crafttr";   // ALFA edit
const string PRM_SKILL_BLUFF = "blu";
const string PRM_SKILL_INTIMIDATE = "inti";
//const string PRM_SKILL_CRAFT_ARMOR = "craftarm";   // ALFA edit
//const string PRM_SKILL_CRAFT_WEAPON = "craftwea";   // ALFA edit
const string PRM_SKILL_DIPLOMACY = "dip";
const string PRM_SKILL_SLEIGHT_OF_HAND = "sle";
//const string PRM_SKILL_CRAFT_ALCHEMY = "craftal";   // ALFA edit
const string PRM_SKILL_SURVIVAL = "sur";
// ALFA additions: custom skills
const string PRM_SKILL_BALANCE = "bal";
const string PRM_SKILL_CLIMB = "clim";
const string PRM_SKILL_CRAFT__ALCHEMY = "craft(al";
const string PRM_SKILL_CRAFT_ARMORSMITHING = "craft(ar";
const string PRM_SKILL_CRAFT_BOWMAKING = "craft(b";
const string PRM_SKILL_CRAFT_WEAPONSMITHING = "craft(w";
const string PRM_SKILL_DECIPHER_SCRIPT = "decip";
const string PRM_SKILL_DISGUISE = "disg";
const string PRM_SKILL_ESCAPE_ARTIST = "escap";
const string PRM_SKILL_FORGERY = "forger";
const string PRM_SKILL_GATHER_INFORMATION = "gath";
const string PRM_SKILL_HANDLE_ANIMAL = "handl";
const string PRM_SKILL_JUMP = "jum";
const string PRM_SKILL_KNOWLEDGE_ARCANA = "knowledge(arc";
const string PRM_SKILL_KNOWLEDGE_DUNGEONEERING = "knowledge(dun";
const string PRM_SKILL_KNOWLEDGE_GEOGRAPHY = "knowledge(geo";
const string PRM_SKILL_KNOWLEDGE_HISTORY = "knowledge(hist";
const string PRM_SKILL_KNOWLEDGE_NATURE = "knowledge(nat";
const string PRM_SKILL_KNOWLEDGE_NOBILITY = "knowledge(nob";
const string PRM_SKILL_KNOWLEDGE_RELIGION = "knowledge(rel";
const string PRM_SKILL_KNOWLEDGE_THEPLANES = "knowledge(thep";
const string PRM_SKILL_PERFORM_ACT = "perform(act";
const string PRM_SKILL_PERFORM_COMEDY = "perform(com";
const string PRM_SKILL_PERFORM_DANCE = "perform(danc";
const string PRM_SKILL_PERFORM_KEYBOARDS = "perform(key";
const string PRM_SKILL_PERFORM_ORATORY = "perform(ora";
const string PRM_SKILL_PERFORM_PERCUSSION = "perform(percu";
const string PRM_SKILL_PERFORM_STRINGINSTRUMENTS = "perform(stri";
const string PRM_SKILL_PERFORM_WINDINSTRUMENTS = "perform(wind";
const string PRM_SKILL_PERFORM_SING = "perform(sing";
const string PRM_SKILL_PROFESSION = "profes";
const string PRM_SKILL_RIDE = "ride";
const string PRM_SKILL_SENSE_MOTIVE = "sensemot";
const string PRM_SKILL_SPEAK_LANGUAGE = "speakla";
const string PRM_SKILL_SWIM = "swim";
const string PRM_SKILL_USE_ROPE = "usero";


// general use params - not translate
const string PRM_AC = "ac";
const string PRM_BATTLE = "battle";
const string PRM_BEST = "best";
const string PRM_BOTH = "both";
const string PRM_CITY = "city";
const string PRM_CLEAR = "clear";
const string PRM_COM = "COM";
const string PRM_DC = "dc";
const string PRM_DESCRIPTION = "description";
const string PRM_DEFAULT = "default";
const string PRM_DELAY = "delay";
const string PRM_DETAIL = "detail";
const string PRM_DUR = "dur";
const string PRM_EFFECT = "effect";
const string PRM_EXTRAORDINARY = "extraord.";
const string PRM_FACING = "facing";
const string PRM_GRANT = "grant";
const string PRM_GOLD = "gold";
const string PRM_HIGH = "high";
const string PRM_IDENTIFY = "identify";
const string PRM_ITEM = "item";
const string PRM_ITEMNAME = "itemname";
const string PRM_ITEMPROP = "itemprop";
const string PRM_ITEMTARGET = "itemtarget";
const string PRM_KEY = "key";
const string PRM_LOC = "loc";
const string PRM_LOCAL = "local";
const string PRM_LOW = "low";
const string PRM_MAGICAL = "magical";
const string PRM_MED = "med";
const string PRM_MESSAGE = "message";
const string PRM_NAME = "name";
const string PRM_NATURE = "nature";
const string PRM_NETWORTH = "networth";
const string PRM_OBJECT = "object";
const string PRM_PLACEABLE = "placeable";
const string PRM_ON = "on";
const string PRM_OFF = "off";
const string PRM_PARTY = "party";
const string PRM_PC = "pc";
const string PRM_PEOPLE = "people";
const string PRM_PLAY = "play";
const string PRM_PLUGINS = "plugins";
const string PRM_RAIN = "rain";
const string PRM_SELF = "self";
const string PRM_SIT = "sit";
const string PRM_SNOW = "snow";
const string PRM_SOUNDLOC = "soundloc";
const string PRM_STANDARD = "standard";
const string PRM_STOP = "stop";
const string PRM_STRIP = "strip";
const string PRM_SUPERNATURAL = "supernat.";
const string PRM_TEST = "test";
const string PRM_RESTORE = "restore";
const string PRM_UBER = "uber";
const string PRM_VFXLOC = "vfxloc";
const string PRM_VFXTYPE = "vfxtype";
const string PRM_VOL = "vol";
const string PRM_XP = "xp";

const string PRM_PLOTP = "placeableplot";

const string PRM_NORAIN = "norain";



const string PRM_ANIMAL = "a";
const string PRM_FAMILIAR = "f";
const string PRM_DOMINATED = "d";
const string PRM_SUMMONED = "s";


// ****************************** EFFECT CONSTANTS *****************************
const string EFF_BLINDNESS = "bli";
const string EFF_CHARMED = "cha";
const string EFF_CONFUSED = "con";
const string EFF_CUTDOMINATED = "cutscenedom";
const string EFF_CUTGHOST = "cutscenegho";
const string EFF_CUTIMMOBILIZE = "cutsceneimm";
const string EFF_CUTPARALYZE = "cutscenepar";
const string EFF_DARKNESS = "dar";
const string EFF_DAZED = "daz";
const string EFF_DEAF = "dea";
const string EFF_DISPELALL = "all";
const string EFF_DISPELBEST = "best";
const string EFF_DOMINATED = "dom";
const string EFF_ENTANGLE = "ent";
const string EFF_ETHEREAL = "eth";
const string EFF_FRIGHTENED = "fri";
const string EFF_HASTE = "has";
const string EFF_KNOCKDOWN = "kno";
const string EFF_PARALYZE = "par";
const string EFF_PETRIFY = "pet";
const string EFF_RESURRECTION = "res";
const string EFF_SEEINVIS = "see";
const string EFF_SILENCE = "sil";
const string EFF_SLEEP = "sle";
const string EFF_SLOW = "slo";
const string EFF_STUNNED = "stu";
const string EFF_TIMESTOP = "tim";
const string EFF_TRUESEEING = "tru";
const string EFF_TURNED = "tur";
const string EFF_ULTRAVISION = "ult";


// ****************************** EMOTE CONSTANTS ******************************
const string EMT_ABL_STRENGTH = "strength";
const string EMT_ABL_DEXTERITY = "dexterity";
const string EMT_ABL_CONSTITUTION = "constitution";
const string EMT_ABL_INTELLIGENCE = "intelligence";
const string EMT_ABL_WISDOM = "wisdom";
const string EMT_ABL_CHARISMA = "charisma";

const string EMT_SAVE_FORTITUDE = "fortitude";
const string EMT_SAVE_REFLEX = "reflex";
const string EMT_SAVE_WILL = "will";

// NWN2 edit:  clean up of the skills
const string EMT_SKL_APPRAISE = "appraise";
const string EMT_SKL_BLUFF = "bluff";
const string EMT_SKL_CONCENTRATION = "concentration";
//const string EMT_SKL_CRAFT_ALCHEMY = "craftalchemy";   // ALFA edit
//const string EMT_SKL_CRAFT_ARMOR = "craftarmor";   // ALFA edit
//const string EMT_SKL_CRAFT_TRAP = "craft trap";   // ALFA edit
//const string EMT_SKL_CRAFT_WEAPON = "craftweapon";   // ALFA edit
const string EMT_SKL_DIPLOMACY = "diplomacy";
const string EMT_SKL_DISABLE_TRAP = "disable trap";
//const string EMT_SKL_DISCIPLINE = "discipline";   // ALFA edit
const string EMT_SKL_HEAL = "heal";
const string EMT_SKL_HIDE = "hide";
const string EMT_SKL_INTIMIDATE = "intimidate";
const string EMT_SKL_LISTEN = "listen";
//const string EMT_SKL_LORE = "lore";   // ALFA edit
const string EMT_SKL_MOVE_SILENTLY = "move silently";
const string EMT_SKL_OPEN_LOCK = "open lock";
const string EMT_SKL_PARRY = "parry";
//const string EMT_SKL_PERFORM = "perform";    // ALFA edit
const string EMT_SKL_SEARCH = "search";
//const string EMT_SKL_SET_TRAP = "settrap";   // ALFA edit
const string EMT_SKL_SLEIGHT_OF_HAND = "slight of hand";
const string EMT_SKL_SPELLCRAFT = "spellcraft";
const string EMT_SKL_SPOT = "spot";
const string EMT_SKL_SURVIVAL = "survival";
//const string EMT_SKL_TAUNT = "taunt";   // ALFA edit
const string EMT_SKL_TUMBLE = "tumble";
const string EMT_SKL_USE_MAGIC_DEVICE = "use magic device";
// ALFA additions: custom skills
const string EMT_SKL_BALANCE = "balance";
const string EMT_SKL_CLIMB = "climb";
const string EMT_SKL_CRAFT__ALCHEMY = "craft alchemy";
const string EMT_SKL_CRAFT_ARMORSMITHING = "craft armor";
const string EMT_SKL_CRAFT_BOWMAKING = "craft bow";
const string EMT_SKL_CRAFT_WEAPONSMITHING = "craft weapon";
const string EMT_SKL_DECIPHER_SCRIPT = "decipher script";
const string EMT_SKL_DISGUISE = "disguise";
const string EMT_SKL_ESCAPE_ARTIST = "escape artist";
const string EMT_SKL_FORGERY = "forgery";
const string EMT_SKL_GATHER_INFORMATION = "gather information";
const string EMT_SKL_HANDLE_ANIMAL = "handle animal";
const string EMT_SKL_JUMP = "jump";
const string EMT_SKL_KNOWLEDGE_ARCANA = "knowledge (arcana)";
const string EMT_SKL_KNOWLEDGE_DUNGEONEERING = "knowledge (dungeoneering)";
const string EMT_SKL_KNOWLEDGE_GEOGRAPHY = "knowledge (geography)";
const string EMT_SKL_KNOWLEDGE_HISTORY = "knowledge (history)";
const string EMT_SKL_KNOWLEDGE_NATURE = "knowledge (nature)";
const string EMT_SKL_KNOWLEDGE_NOBILITY = "knowledge (nobility)";
const string EMT_SKL_KNOWLEDGE_RELIGION = "knowledge (religion)";
const string EMT_SKL_KNOWLEDGE_THEPLANES = "knowledge (the planes)";
const string EMT_SKL_PERFORM_ACT = "perform (act)";
const string EMT_SKL_PERFORM_COMEDY = "perform (comedy)";
const string EMT_SKL_PERFORM_DANCE = "perform (dance)";
const string EMT_SKL_PERFORM_ORATORY = "perform (oratory)";
const string EMT_SKL_PERFORM_KEYBOARDS = "perform (keyboards)";
const string EMT_SKL_PERFORM_PERCUSSION = "perform (percussion)";
const string EMT_SKL_PERFORM_STRINGINSTRUMENTS = "perform (string inst.)";
const string EMT_SKL_PERFORM_WINDINSTRUMENTS = "perform (wind inst.)";
const string EMT_SKL_PERFORM_SING = "perform (sing)";
const string EMT_SKL_PROFESSION = "profession";
const string EMT_SKL_RIDE = "ride";
const string EMT_SKL_SENSE_MOTIVE = "sense motive";
const string EMT_SKL_SPEAK_LANGUAGE = "speak language";
const string EMT_SKL_SWIM = "swim";
const string EMT_SKL_USE_ROPE = "use rope";


const string EMT_ACTIVATE = "activate";
const string EMT_AGREE = "agree";
const string EMT_BACK = "back";
const string EMT_BARD = "bard";
const string EMT_BEG = "beg";
const string EMT_BEND = "bend";
const string EMT_BOOGIE = "boogie";
const string EMT_BOOK = "book";
const string EMT_BORED = "bored";
const string EMT_BOW = "bow";
const string EMT_BOX = "box";
const string EMT_CANTRIP = "cantrip";
const string EMT_CARRY = "carry";
const string EMT_CAST = "cast";
const string EMT_CELEBRATE = "celebrate";
const string EMT_CHATS = "chat";
const string EMT_CHEER = "cheer";
const string EMT_CHUCKLE = "chuckle";
const string EMT_COLLAPSE = "collapse";
const string EMT_COOK = "cook";
const string EMT_CRAFT = "craft";
const string EMT_CURTSEY = "curtsey";
const string EMT_DANCE = "dance";
const string EMT_DEATH = "death";
const string EMT_DEMAND = "demand";
const string EMT_DIE = "die";
const string EMT_DODGE = "dodge";
const string EMT_DOWN = "down";
const string EMT_DRINK = "drink";
const string EMT_DRUM = "drum";
const string EMT_DRUNK = "drunk";
const string EMT_DUCK = "duck";
const string EMT_EXAMINE = "examine";
const string EMT_EXHAUSTED = "exhausted";
const string EMT_FALL = "fall";
const string EMT_FAR = "far";
const string EMT_FATIGUE = "fatigue";
const string EMT_FIDDLE = "fiddle";
const string EMT_FIDGET = "fidget";
const string EMT_FLOOR = "floor";
const string EMT_FLOP = "flop";
const string EMT_FLUTE = "flute";
const string EMT_FORGE = "forge";
const string EMT_FORWARD = "forward";
const string EMT_FROLIC = "frolic";
const string EMT_GIGGLE = "giggle";
const string EMT_GREET = "greet";
const string EMT_GROUND = "ground";
const string EMT_GUITAR = "guitar";
const string EMT_HAHA = "haha";
const string EMT_HELLO = "hello";
const string EMT_HI = "hi";
const string EMT_HOORAY = "hooray";
const string EMT_HUM = "hum";
const string EMT_HURT = "hurt";
const string EMT_HURRY = "hurry";
const string EMT_HURRI = "hurri"; // for hurries, hurried
const string EMT_INJURE = "injure";
const string EMT_INTIMIDATE = "intimidate";
const string EMT_KNEEL = "kneel";
const string EMT_LAUGH = "laugh";
const string EMT_LAY = "lay";
const string EMT_LEFT = "left";
const string EMT_LETS_GO = "let's go";
const string EMT_LIMP = "limp";
const string EMT_LOAD = "load";
const string EMT_LOL = "lol";
const string EMT_LOOK = "look";
const string EMT_LUTE = "lute";
const string EMT_MEAL = "meal";
const string EMT_MEDITATE = "meditate";
const string EMT_MESS = "mess";
const string EMT_MOCK = "mock";
const string EMT_MOVE = "move";
const string EMT_MUSIC = "music";
const string EMT_NAP = "nap";
const string EMT_NOD = "nod";
const string EMT_PAPER = "paper";
const string EMT_PEER = "peer";
const string EMT_PLAY = "play";
const string EMT_PLEAD = "plead";
const string EMT_PRAY = "pray";
const string EMT_PRONE = "prone";
const string EMT_READ = "read";
const string EMT_REST = "rest";
const string EMT_RIGHT = "right";
const string EMT_SALUTE = "salute";
const string EMT_SCAN = "scan";
const string EMT_SCRATCH = "scratch";
const string EMT_SEARCH = "search";
const string EMT_SCOUT = "scout";
const string EMT_SHAKES_HEAD = "shakes head";
const string EMT_SHOVEL = "shovel";
const string EMT_SING = "sing";
const string EMT_SIP = "sip";
const string EMT_SNORE = "snore";
const string EMT_SONG = "song";
const string EMT_SPASM = "spasm";
const string EMT_SPEAK = "speak";
const string EMT_STAND = "stand";
const string EMT_STEAL = "steal";
const string EMT_STOOP = "stoop";
const string EMT_STORY = "story";
const string EMT_STRETCH = "stretch";
const string EMT_SWAY = "sway";
const string EMT_SWIPE = "swipe";
const string EMT_TALK = "talk";
const string EMT_TAUNT = "taunt";
const string EMT_TELLS = "tells";
const string EMT_THREATEN = "threaten";
const string EMT_TINKER = "tinker";
const string EMT_TIRED = "tired";
const string EMT_TRIPS = "trip";
const string EMT_UP = "up";
const string EMT_USE = "use";
const string EMT_WAVE = "wave";
const string EMT_WHISTLES = "whistle";
const string EMT_WILDSHAPE = "wildshape";
const string EMT_WOOZY = "woozy";
const string EMT_WORSHIP = "worship";
const string EMT_YAWN = "yawn";

// Voice Chat related emotes - added 11/11/06

const string EMT_ATTACK = "attack";
const string EMT_BATTLECRY = "battle";
const string EMT_HEAL = "heal";
const string EMT_HELP = "help";
const string EMT_ENEMIES = "enemies";
const string EMT_FLEE = "flee";
const string EMT_GUARDME = "guard";
const string EMT_ME = "me";
const string EMT_HOLD = "hold";

const string EMT_PAIN = "pain";
const string EMT_NEAR = "near";
const string EMT_POISONED = "poisoned";
const string EMT_SPELL_FAIL = "spell fail";
const string EMT_WEAPON_SUCKS = "weapon suck";
const string EMT_FOLLOW_ME = "follow";
const string EMT_HERE = "here";
const string EMT_GROUP = "group";
const string EMT_MOVE_OVER = "move over";
const string EMT_CANTDO = "can't do";
const string EMT_CANDO = "can do";
const string EMT_TASKCOMPLETE = "complete";
const string EMT_ENCUMBERED = "encumbered";
const string EMT_SELECTED = "selected";
const string EMT_NO = "no";
const string EMT_STOP = "stop";
const string EMT_GOODBYE = "goodbye";
const string EMT_THANKS = "thanks";
const string EMT_CUSS = "cuss";
const string EMT_TALKTOME = "talk to me";
const string EMT_GOODIDEA = "good idea";
const string EMT_BADIDEA = "bad idea";
const string EMT_PICK_LOCK = "pick lock";
const string EMT_CHECK_AREA = "check the area";
const string EMT_YES = "yes";
const string EMT_COVER = "cover";

//////////////////////////////////////////////////////////////

const string TXT_TOGGLE_CURSED = "Item Cursed State: ";
const string TXT_TOGGLE_PLOT = "Item Plot State: ";
const string TXT_TOGGLE_STOLEN = "Item Stolen State: ";

const string TXT_CURSED = "Cursed";
const string TXT_PLOT = "Plot";
const string TXT_STOLEN = "Stolen";
const string TXT_ITEM_STATE = "State: ";

const string TXT_ITEM_TAKEN = "Item Taken from Target: ";
const string TXT_ITEM_IDENTIFIED = "Item Identified (note: name will not refresh until moved): ";
const string TXT_ITEM_RETRIEVED = "DMFI Tool Retrieved from database.";
const string TXT_DATABASE_INITIALIZED = "DMFI Tool stored to database.";

const string PRM_CURSED = "curse";
const string PRM_PLOT = "plot";
const string PRM_STOLEN = "stolen";
const string PRM_TAKE = "take";
const string PRM_UI = "ui";

const string TXT_RENAME_OBJ_SUCCESS = "Name Successfully Changed.";
const string TXT_RENAME_ITM_SUCCESS = "Item Name Successfully Changed.  Note:  You must move the item to 'refresh' the item name.";
const string TXT_RENAME_INVALID_TARGET = "You can only rename yourself, your associates, or possessed inventory items.";

////////////////////////////// NEW WITH 1.01 ///////////////////////////////////////////////////////////////////////////////

const string TXT_AGAINST = "Roll Target: ";
const string TXT_AREA = "General Area";
const string TXT_SPEAKING = "Speaking: ";
const string TXT_CHOOSE_ABILITY = "Choose an Ability/Save:";
const string TXT_CHOOSE_SKILL = "Please select a skill:";
const string TXT_CHOOSE_LANGUAGE = "Please select a language:";
const string TXT_CHOOSE_NUMBER = "Select number of dice:";
const string TXT_CHOOSE_TYPE = "Choose which type of dice:";

// LANGUAGE CONSTANTS
const string LNG_ANIMAL = "animal";
const string LNG_ASSASSIN = "assassin";
const string LNG_ABYSSAL = "abyssal";
const string LNG_ALZHEDO = "alzhedo";  //was missing
const string LNG_AQUAN = "aquan";
const string LNG_AURAN = "auran";
const string LNG_ALGARONDAN = "algarondan";
const string LNG_CANT = "cant";
const string LNG_CELESTIAL = "celestial";
const string LNG_CHESSENTAN = "chessentan";
const string LNG_CHONDATHAN = "chondathan";
const string LNG_CHULTAN = "chultan";
const string LNG_DWARF = "dwarf";
const string LNG_DROW = "drow";
const string LNG_DROWSIGN = "drowsign";
const string LNG_DRUIDIC = "druidic";
const string LNG_DRACONIC = "draconic";
const string LNG_DAMARAN = "damaran";
const string LNG_DAMBRATHAN = "dambrathan";
const string LNG_DURPARI = "durpari";
const string LNG_ELVEN = "elven";
const string LNG_GNOME = "gnome";
const string LNG_GOBLIN = "goblin";
const string LNG_GIANT = "giant"; 
const string LNG_GNOLL = "gnoll";
const string LNG_HALFLING = "halfling";
const string LNG_IGNAN = "ignan";
const string LNG_HALARDRIM = "halardrim";
const string LNG_HALRUAAN = "halruaan";
const string LNG_ILLUSKAN = "illuskan";
const string LNG_IMASKAR = "imaskar";
const string LNG_INFERNAL = "infernal";
const string LNG_LEETSPEAK = "leetspeak";
const string LNG_LANTANESE = "lantanese";
const string LNG_LOROSS = "loross"; // ALFA addition
const string LNG_MIDANI = "midani";
const string LNG_MULHORANDI = "mulhorandi";
const string LNG_NETHERESE = "netherese";  // ALFA addition
const string LNG_RASHEMI = "rashemi";
//const string LNG_RAUMVIRA = "raumvira";  // ALFA-removed, replaced with Netherese
const string LNG_SERUSAN = "serusan";
const string LNG_SHAARAN = "shaaran";
const string LNG_SHOU = "shou";
const string LNG_SYLVAN = "sylvan";
const string LNG_TERRAN = "terran";
const string LNG_TREANT = "treant";
//const string LNG_TALFIRIC = "talfiric"; ALFA-removed, replaced with Loross
const string LNG_TASHALAN = "tashalan";
const string LNG_TUIGAN = "tuigan";
const string LNG_TURMIC = "turmic";
const string LNG_ORC = "orc";
const string LNG_NEXALAN = "nexalan";
//const string LNG_OILLUSK = "oillusk";  ALFA-removed, replaced with Yuan-Ti
const string LNG_YUANTI = "yuan-ti";
const string LNG_UNDERCOMMON = "undercommon";
const string LNG_ULUIK = "uluik";
const string LNG_UNTHERIC = "untheric";
const string LNG_VAASAN = "vaasan";  // was missing

/////////////////////////////////////////////// New with POST 1.01 //////////////////////////////////////

const string PRM_DICE = "dice";
const string PRM_UPDATE = "update";
const string TXT_TOOL_VERSION_ERROR = "DMFI Tool Error: Incorrect Version / Updating.";
const string TXT_DB_VERSION_ERROR = "DATABASE INVALID:  Requires rebuilding.";
const string TXT_DB_VERSION = "DMFI DATABASE Version: ";
const string TXT_MAX_VALUE = "Maximum Allowed Value: ";
const string TXT_CREATE_STORAGE = "Creating Storage Bag: ";
const string TXT_REPORT_GOLD = " GOLD VALUE: ";
const string TXT_REPORT_NETWORTH = " NET WORTH: ";
const string TXT_REPORT_XP = " CURRENT XP: ";
const string TXT_CLIPBOARD_EMPTY = "Clipboard Empty - No copied creatures";
const string PRM_FACTION = "faction";
const string PRM_HOSTILE = "hostile";
const string PRM_COMMONER = "commoner";
const string PRM_MERCHANT = "merchant";
const string PRM_DEFENDER = "defender";
const string TXT_DEFAULT_FACTION_REQ = "Default Faction Required as Parameter.";
const string TXT_FACTION_SET = "Target set to faction: ";
const string PRM_SERVER = "server";
const string TXT_FACTION_HOSTILE = "START BATTLE: All NPCs set to HOSTILE";
const string TXT_FACTION_COMMONER = "STOP BATTLE:  All NPCs set to Commoner";
const string LNG_COMMON = "common";
const string TXT_DM_MESS = "DM Message: ";
const string PRM_COPY = "copy";
const string PRM_PASTE = "paste";
const string TXT_NON_PC = "Target must NOT be a PC for this function.";
const string TXT_TRANSLATED_LORE = "Lore Check Passed: Language Translated.";
const string TXT_NAME_CHANGING_DISABLED = "PC name changing is disabled.";
const string TXT_PC_LANG_DISABLED = "DMFI  PC Languages disabled for performance reasons on this server.";
const string TXT_EMOTES_DISABLED  = "DMFI Emotes disabled for performance reasons on this server.";
const string TXT_LANGUAGES_RESET = "DMFI Languages Reset by Server.";
const string TXT_LANGUAGES_DMRESET = "Target Languages Reset.";
const string TXT_LANGUAGES_SERVER_ERROR = "SERVER ERROR:  WE REQUIRE ONE VALID LANGUAGE - Tell your admin.";
const string PRM_APPEARANCE = "appearance";
const string CV_PROMPT_APPEARANCE = "Please select a new appearance:";
const string TXT_APPEARANCE_SET = "DMFI Appearance: ";
const string TXT_BATTLE_STR = "Battle Effects: Str: ";
const string TXT_BATTLE_DEX = " Dex: ";
const string TXT_BATTLE_CON = " Con: ";
const string TXT_BATTLE_SR = " SR: ";
const string TXT_BATTLE_HP = " HP: ";
const string TXT_IS_A_PC = "Action done to PC: ";

const string ASCANT_A = "*sighs, sadly*";
const string ASCANT_B = "*looks down*";
const string ASCANT_C =  "*winks*";
const string ASCANT_D =  "*sighs, thoughtfully*";
const string ASCANT_E =  "*looks up*";
const string ASCANT_F = "*clears throat*";
const string ASCANT_G =  "*smiles pleasantly*";
const string ASCANT_H = "*looks bored*";
const string ASCANT_I = "*looks to the right*";
const string ASCANT_J =  "*smiles weakly*";
const string ASCANT_K = "*nods politely*";
const string ASCANT_L =  "*looks ahead*";
const string ASCANT_M =  "*eyes twinkle merrily*";
const string ASCANT_N =  "*cracks a finger*";
const string ASCANT_O =  "*taps foot to a musicial beat*";
const string ASCANT_P =  "*looks sad*";
const string ASCANT_Q =  "*grins*";
const string ASCANT_R =  "*taps foot impatiently*";
const string ASCANT_S =  "*rolls eyes*";
const string ASCANT_T =  "*looks to the left*";
const string ASCANT_U =  "*frowns*";
const string ASCANT_V =  "*scratches left knuckle with right hand*";
const string ASCANT_W =  "*smiles*";
const string ASCANT_X =  "*gives a half-smile*";
const string ASCANT_Y =  "*scratches chin*";
const string ASCANT_Z =  "*stretches legs*";
const string ASCANT_DEFAULT = "*nods*";

const string CANT_A = "*shields eyes*";
const string CANT_B = "*blusters*";
const string CANT_C = "*coughs*";
const string CANT_D = "*furrows brow*";
const string CANT_E = "*examines ground*";
const string CANT_F = "*frowns*";
const string CANT_G = "*glances up*";
const string CANT_H = "*looks thoughtful*";
const string CANT_I = "*looks bored*";
const string CANT_J = "*rubs chin*";
const string CANT_K = "*scratches ear*";
const string CANT_L = "*looks around*";
const string CANT_M = "*mmm hmm*";
const string CANT_N = "*nods*";
const string CANT_O = "*grins*";
const string CANT_P = "*smiles*";
const string CANT_Q = "*shivers*";  
const string CANT_R = "*rolls eyes*"; 
const string CANT_S = "*scratches nose*";
const string CANT_T = "*turns a bit*"; 
const string CANT_U = "*glances idly*"; 
const string CANT_V = "*runs hand through hair*"; 
const string CANT_W = "*waves*"; 
const string CANT_X = "*stretches*";
const string CANT_Y = "*yawns*";
const string CANT_Z = "*shrugs*"; 
const string CANT_DEFAULT = "*nods*";

const string DCANT_A = "*shields left thumb with right hand*";
const string DCANT_B =  "*makes a fist, then extends fingers rapidly*";
const string DCANT_C =  "*makes a fist*";
const string DCANT_D =  "*curls fingers towards palm*";
const string DCANT_E =  "*runs right index finger against the left index finger*";
const string DCANT_F =  "*taps thumbs together*";
const string DCANT_G =  "*stretches fingers wide*";
const string DCANT_H =  "*taps palm four times*";
const string DCANT_I =  "*rubs palm and forefinger together*";
const string DCANT_J =  "*rubs palm with thumb*";
const string DCANT_K =  "*holds hand up, pinky curled down*";
const string DCANT_L =  "*flips palm around*";
const string DCANT_M =  "*makes a cutting motion with two fingers*";
const string DCANT_N =  "*waves three fingers forward*";
const string DCANT_O =  "*makes an 'X' with fingers*";
const string DCANT_P =  "*holds fingers still*";
const string DCANT_Q =  "*flexes fingers*";
const string DCANT_R =  "*taps index finger in other hand's palm*";
const string DCANT_S =  "*makes a small slash with four fingers*";
const string DCANT_T =  "*turns palm a bit*";
const string DCANT_U =  "*holds palm flat, index finger down*";
const string DCANT_V =  "*gestures with one finger in a circle*";
const string DCANT_W =  "*waves two fingers forward*";
const string DCANT_X =  "*holds palm vertical*";
const string DCANT_Y =  "*holds palm horizontal*";
const string DCANT_Z =  "*slashes two fingers in the air*";

const string as_bell_church01 = "Bell church";
const string as_cv_belltower1 = "Bell tower";
const string as_cv_boilergrn1 = "Boiler";
const string as_cv_boomdist1 = "Boom dist";
const string as_cv_claybreak1 = "Clay break";
const string as_hr_x2chnratl1 = "Chain rattle";
const string as_cv_crank1 = "Crank";
const string al_cv_firecamp1 = "Campfire";
const string al_na_firelarge2 = "Fire large";
const string al_cv_firesmldr1 = "Fire smolder";
const string as_cv_glasbreak1 = "Glass break";
const string as_na_x2lowrum2 = "Low Rumble";
const string amb_metal_creaking_1 = "Metal creak";
const string al_cv_millwheel1 = "Millwheel";
const string as_cv_minepick1 = "Mine pick";
const string as_cv_mineshovl1 = "Mine shovel";
const string as_hr_x2drnoise4 = "x2dr noise";
const string as_hr_x2drnoise = "x2dr2 noise";
const string cs_shipsink_long = "Ship sink";
const string as_cv_smithhamr1 = "Smith hammer";
const string as_cv_woodbreak1 = "Wood break";
const string as_cv_bldgcrumb1 = "Boulder crumb";
const string amb_caverumb_01 = "Cave rumb1";
const string amb_caverumb_02 = "Cave rumb2";
const string amb_cavewind_03 = "Cave rumb3";
const string amb_cavewind_04 = "Cave rumb4";
const string al_wt_gustcavrn1 ="Gust cavern";
const string al_wt_gustchasm1 = "Gust chasm";
const string al_wt_gustgrass1 = "Gust grass";
const string as_wt_gustdraft1 = "Gust draft";
const string as_wt_gusforst1 = "Gust forest";
const string as_wt_gustsoft1 =" Gust soft";
const string as_wt_guststrng1 = "Gust strong";
const string as_na_lavaburst1 = "Lava burst";
const string al_na_lavafire1 = "Lava fire";
const string al_na_lavagyser1 ="Lava gyser";
const string al_na_lavalake1 = "Lava lake";
const string amb_ocean_lp1 = "Ocean";
const string al_wt_rainlight1="Rain light";
const string al_wt_rainhard1 ="Rain hard";
const string as_na_rockfallg1="Rock fall";
const string as_na_rockcavsm1="Rock cave";
const string al_na_sludglake1="Sludge lake";
const string al_na_steamsm1="Steam small";
const string as_na_steamlong1="Steam long";
const string al_na_steamlg1="Steam large";
const string al_na_stream4="Stream";
const string al_na_cvstream2="Cave stream";
const string al_na_cvstream1="Cave stream";
const string as_na_surf1="Surf1";
const string as_na_surf2="Surf2";
const string as_wt_thunderds1="Thunder";
const string as_wt_thundercl1="Thunder close";
const string al_na_waterfall2="Waterfall";
const string as_na_waterlap3="Water laps";
const string al_na_wtrflvoid1="Water flow";
const string al_na_waterpipe1="Water pipe";
const string al_na_watertunl1="Water tunnel";
const string al_wind_leaves="Wind leaves";
const string as_pl_ailingm1="Ailing man";
const string as_pl_ailingf1="Ailing woman";
const string c_orc_atk1="Orc attack";
const string c_orc_bat1="Orc battle";
const string as_pl_battlegrp1="Battle group";
const string as_pl_chantingm1="Chanting men";
const string as_pl_comyaygrp1="Common group";
const string as_pl_crptvoice1="Crypt voice";
const string cs_kos_death="KOS Death";
const string as_pl_despairm1="Despair Men";
const string as_an_dragonror1="Dragon roar";
const string as_pl_evilchantm="Evil chant";
const string as_cv_flute1="Flute";
const string as_hr_x2ghost4="Ghost";
const string as_hr_x2ghost2="Ghost2";
const string as_an_lizrdhiss1="Lizardhiss";
const string as_cv_lute1="Lute";
const string as_pl_marketgrp1="Market";
const string as_an_mephgrunt1= "Mephgrunt";
const string as_pl_officerm1="Office";
const string as_an_ogregrunt1="Ogre grunt";
const string as_an_orcgrunt1="Orc grunt";
const string as_cv_shopfruit1="Shop fruit";
const string as_pl_taverngrp1="Tavern group";
const string as_pl_towncrym1="Town cryer";
const string wilhelm_scream="Wilhelm scream";
const string as_pl_yelcitycf1="Yell city f";
const string as_pl_yellcitym1="Yell city m";
const string as_pl_zombief1= "Zombie";
const string al_mg_ballmagic1= "Ball Magic";
const string al_mg_cauldron1= "Cauldron";
const string al_mg_crystalev1= "Crystal Evil";
const string al_mg_crystalgd1= "Crystal Good";
const string al_mg_crystalic1= "Crystal Ice";
const string al_mg_crystallv1= "Crystal 1";
const string al_mg_crystalnt1= "Crystal 2";
const string al_eerie_caveloop1= "Cave eerie1";
const string al_eerie_caveloop2= "Cave eerie2";
const string al_eerie_caveloop4= "Cave eerie3";
const string al_eerie_droneloop1= "Drone loop";
const string al_mg_entrevil1= "Enter evil";
const string al_mg_entrmyst1= "Enter emst";
const string al_mg_entrscry1= "Enter scary";
const string as_mg_frstmagic1= "Frost Magic";
const string al_mg_pillrlght1= "Pillar light";
const string al_mg_portal3= "Portal 1";
const string al_mg_portal4= "Portal 2";
const string al_mg_portal2= "Portal 3";
const string as_mg_telepin1="Teleport in";
const string al_mg_spirtbarrow_01="Motb Barrow";
const string al_en_deathgodamb="Motb GoDamb";
const string al_en_roomtone="Motb RoomTone";

const string EFT_INVALIDEFFECT = "Invalid";
const string EFT_DAMAGE_RESISTANCE = "Damage Resistance"; 
const string EFT_REGENERATE = "Rengenerate";
const string EFT_DAMAGE_REDUCTION = "Damage Reduction";
const string EFT_TEMPORARY_HITPOINTS = "Temporary Hitpoints";
const string EFT_ENTANGLE = "Entangle";
const string EFT_INVULNERABLE =  "Invulnerable";
const string EFT_DEAF =  "Deaf";
const string EFT_RESURRECTION =  "Resurrection";
const string EFT_IMMUNITY =  "Immunity";
const string EFT_ENEMY_ATTACK_BONUS =  "Enemy Attack Bonus";
const string EFT_ARCANE_SPELL_FAILURE =  "Arcane Spell Failure";
const string EFT_AREA_OF_EFFEC =  "Area of Effect";
const string EFT_BEAM =  "Beam";
const string EFT_CHARMED =  "Charmed";
const string EFT_CONFUSED =  "Confused";
const string EFT_FRIGHTENED =  "Frightened";
const string EFT_DOMINATED =  "Dominated";
const string EFT_PARALYZE =  "Paralyzed";
const string EFT_DAZED =  "Dazed";
const string EFT_STUNNED =  "Stunned";
const string EFT_SLEEP =  "Sleep";
const string EFT_POISON =  "Poison";
const string EFT_DISEASE =  "Disease";
const string EFT_CURSE =  "Curse";
const string EFT_SILENCE =  "Silence";
const string EFT_TURNED =  "Turned";
const string EFT_HASTE =  "Haste";
const string EFT_SLOW =  "Slow";
const string EFT_ABILITY_INCREASE =  "Ability Increase";
const string EFT_ABILITY_DECREASE = "Ability Decrease";
const string EFT_ATTACK_INCREASE = "Attack Increase";
const string EFT_ATTACK_DECREASE = "Atttack Decrease";
const string EFT_DAMAGE_INCREASE = "Damage Increase";
const string EFT_DAMAGE_DECREASE = "Damage Decrease";
const string EFT_DAMAGE_IMMUNITY_INCREASE = "Immunity Increase";
const string EFT_DAMAGE_IMMUNITY_DECREASE = "Immunity Decrease";
const string EFT_AC_INCREASE = "AC Increase";
const string EFT_AC_DECREASE = "AC Decrease";
const string EFT_MOVEMENT_SPEED_INCREASE  = "Movement Speed Increase";
const string EFT_MOVEMENT_SPEED_DECREASE = "Movement Speed Decrease";
const string EFT_SAVING_THROW_INCREASE = "Saving Throw Increase";
const string EFT_SAVING_THROW_DECREASE = "Saving Throw Decrease";
const string EFT_SPELL_RESISTANCE_INCREASE= "Spell Resistance Increase";
const string EFT_SPELL_RESISTANCE_DECREASE = "Spell Resistance Decrease";
const string EFT_SKILL_INCREASE = "Skill Increase";
const string EFT_SKILL_DECREASE  = "Skill Decrease";
const string EFT_INVISIBILITY = "Invisibility";
const string EFT_GREATERINVISIBILITY = "Improved Invisibility";
const string EFT_DARKNESS = "Darkness";
const string EFT_DISPELMAGICALL= "Dispel Magic";
const string EFT_ELEMENTALSHIELD = "Elemental Shield";
const string EFT_NEGATIVELEVEL  = "Negative Level";
const string EFT_POLYMORPH = "Polymorph";
const string EFT_SANCTUARY = "Sanctuary";
const string EFT_TRUESEEING  = "Trueseeing";
const string EFT_SEEINVISIBLE = "See Invisible";
const string EFT_TIMESTOP = "Timestop";
const string EFT_BLINDNESS  = "Blindness";
const string EFT_SPELLLEVELABSORPTION = "Spell Level Absorption";
const string EFT_DISPELMAGICBEST  = "Sleep";
const string EFT_ULTRAVISION = "Dispel Magic Best";
const string EFT_MISS_CHANCE = "Miss Chance";
const string EFT_CONCEALMENT = "Concealment";
const string EFT_SPELL_IMMUNITY = "Spell Immunity";
const string EFT_VISUALEFFECT  = "Visual Effect";
const string EFT_DISAPPEARAPPEAR  = "Disappear Appear";
const string EFT_SWARM   = "Swarm";
const string EFT_TURN_RESISTANCE_DECREASE = "Turn Resistance Decrease";
const string EFT_TURN_RESISTANCE_INCREASE = "Turn Resistance Increase";
const string EFT_PETRIFY = "Petrify";
const string EFT_CUTSCENE_PARALYZE = "Cutscene Paralyze";
const string EFT_ETHEREAL = "Ethereal";
const string EFT_SPELL_FAILURE = "Spell Failure";
const string EFT_CUTSCENEGHOST = "Cutscene Ghost";
const string EFT_CUTSCENEIMMOBILIZE  = "Custscene Immobilize";
const string EFT_BARDSONG_SINGING = "Bardsong Singing";
const string EFT_HIDEOUS_BLOW = "Hideous Blow";
const string EFT_NWN2_DEX_ACMOD_DISABLE = "NWN2 Dex AC Mod Disable";
const string EFT_DETECTUNDEAD = "Detect Undead";
const string EFT_SHAREDDAMAGE = "Share Damge";
const string EFT_ASSAYRESISTANCE = "Assay Resistance";
const string EFT_DAMAGEOVERTIME = "Damage Overtime";
const string EFT_ABSORBDAMAGE = "Absorb Damage";
const string EFT_AMORPENALTYINC = "Armor Penalty Increase";
const string EFT_DISINTEGRATE = "Disintegrate";
const string EFT_HEAL_ON_ZERO_HP = "Heal on 0 HP";
const string EFT_BREAK_ENCHANTMENT = "Break Enchantment";
const string EFT_MESMERIZE = "Mesmerize";
const string EFT_ON_DISPEL = "Dispel";
const string EFT_BONUS_HITPOINTS = "Bonus Hitpoints";
const string EFT_JARRING = "Jarring";
const string EFT_MAX_DAMAGE = "Max Damage";
const string EFT_WOUNDING = "Wounding";
const string EFT_WILDSHAPE = "Wildshape";

const string DMFI_Default = "Default";
const string DMFI_Assimar = "Assimar";
const string DMFI_Badger = "Badger";
const string DMFI_Badger_Dire = "Badger Dire";
const string DMFI_Bat = "Bat";
const string DMFI_Bear_Brown = "Bear Brown";
const string DMFI_Bear_Dire = "Bear Dire";
const string DMFI_Bear_Polar = "Bear Polar";
const string DMFI_Beetle = "Beetle";
const string DMFI_Beetle_Bombadier = "Beetle Bombadier";
const string DMFI_Beetle_Fire = "Beetle Fire";
const string DMFI_Beetle_Stag = "Beetle Stag";
const string DMFI_Beholder = "Beholder";
const string DMFI_Bird = "Bird";
const string DMFI_Bladeling = "Bladeling";
const string DMFI_Bladeling_Warrior_A = "Bladeling Warrior";
const string DMFI_Boar = "Boar";
const string DMFI_Boar_Dire = "Boar Dire";
const string DMFI_Bodak = "Bodak";
const string DMFI_Bugbear = "Bugbear";
const string DMFI_CargoShip = "CargoShip";
const string DMFI_Cat = "Cat";
const string DMFI_Cat_Panther = "Cat Panther";
const string DMFI_Chicken = "Chicken";
const string DMFI_Cow = "Cow";
const string DMFI_Deer = "Deer";
const string DMFI_Deer_Stag = "Deer Stag";
const string DMFI_Demon_Balor = "Demon Balor";
const string DMFI_Demon_Hezrou = "Demon Hezrou";
const string DMFI_Demon_Marilith = "Demon Marilith";
const string DMFI_Devil_Deva = "Devil Deva";
const string DMFI_Devil_Erinyes = "Devil Erinyes";
const string DMFI_Devil_Horned = "Devil Horned";
const string DMFI_Devil_PitFiend = "Devil PitFiend";
const string DMFI_Dog_Dire_Wolf = "Dog Dire Wolf";
const string DMFI_Dog_Hell_Hound = "Dog Hell Hound";
const string DMFI_Dog_Shadow_Mastif = "Dog Shadow Mastif";
const string DMFI_Dog_Winter_Wolf = "Dog Winter Wolf";
const string DMFI_Dog_Wolf = "Dog Wolf";
const string DMFI_Doppleganger = "Doppleganger";
const string DMFI_Dragon_Black = "Dragon Black";
const string DMFI_Dragon_Pseudo = "Dragon Pseudo";
const string DMFI_Dragon_Red = "Dragon Red";
const string DMFI_Dryad = "Dryad";
const string DMFI_Dwarf = "Dwarf";
const string DMFI_Elemental_Air = "Elemental Air";
const string DMFI_Elemental_Earth = "Elemental Earth";
const string DMFI_Elemental_Fire = "Elemental Fire";
const string DMFI_Elemental_Water = "Elemental Water";
const string DMFI_Elf = "Elf";
const string DMFI_Eyeball = "Eyeball";
const string DMFI_Faerie_Dragon = "Faerie Dragon";
const string DMFI_Gargoyle = "Gargoyle";
const string DMFI_Ghast = "Ghast";
const string DMFI_Ghost = "Ghost";
const string DMFI_Ghoul = "Ghoul";
const string DMFI_Giant_Fire = "Giant Fire";
const string DMFI_Giant_Frost = "Giant Frost";
const string DMFI_Githyanki = "Githyanki";
const string DMFI_Githyanki_Female = "Githyanki Female";
const string DMFI_Githzerai = "Githzerai";
const string DMFI_Gnoll = "Gnoll";
const string DMFI_Gnome = "Gnome";
const string DMFI_Goblin = "Goblin";
const string DMFI_Golem_Blade = "Golem Blade";
const string DMFI_Golem_Iron = "Golem Iron";
const string DMFI_Half_Orc = "HalfOrc";
const string DMFI_HalfDragon = "HalfDragon";
const string DMFI_Horse_Black_Stallion = "Horse Black Stallion";
const string DMFI_Horse_Brown = "Horse Brown";
const string DMFI_Horse_Palomino = "Horse Palomino";
const string DMFI_Horse_Pinto = "Horse Pinto";
const string DMFI_Horse_White_Stallion = "Horse White Stallion";
const string DMFI_Horse_Nightmare = "Horse Nightmare";
const string DMFI_Horse_Skeletal = "Horse Skeletal";
const string DMFI_HoundArchon = "HoundArchon";
const string DMFI_Imp = "Imp";
const string DMFI_Kobold = "Kobold";
const string DMFI_Lantern_Archon = "Lantern Archon";
const string DMFI_Lich = "Lich";
const string DMFI_Lizardfolk = "Lizardfolk";
const string DMFI_Mephit_Fire = "Mephit Fire";
const string DMFI_Mephit_Ice = "Mephit Ice";
const string DMFI_Mindflayer = "Mindflayer";
const string DMFI_Mummy_Common = "Mummy Common";
const string DMFI_Nightshade_Nightwalker = "Nightshade Nightwalker";
const string DMFI_NPC_Ahja = "NPC Ahja";
const string DMFI_NPC_Aldanon = "NPC Aldanon";
const string DMFI_NPC_AmmonJerro = "NPC AmmonJerro";
const string DMFI_NPC_ChildHHF = "NPC ChildHHF";
const string DMFI_NPC_ChildHHM = "NPC ChildHHM";
const string DMFI_NPC_Ctann = "NPC Ctann";
const string DMFI_NPC_Duncan = "NPC Duncan";
const string DMFI_NPC_Durler = "NPC Durler";
const string DMFI_NPC_Garius = "NPC Garius";
const string DMFI_NPC_GithCaptain = "NPC GithCaptain";
const string DMFI_NPC_Hezebel = "NPC Hezebel";
const string DMFI_NPC_HostTower = "NPC HostTower";
const string DMFI_NPC_HunterStaute = "NPC HunterStaute";
const string DMFI_NPC_Jacoby = "NPC Jacoby";
const string DMFI_NPC_Jalboun = "NPC Jalboun";
const string DMFI_NPC_Kharlever = "NPC Kharlever";
const string DMFI_NPC_KingofShadows = "NPC KingofShadows";
const string DMFI_NPC_Kralwok = "NPC Kralwok";
const string DMFI_NPC_LordNasher = "NPC LordNasher";
const string DMFI_NPC_Lorne = "NPC Lorne";
const string DMFI_NPC_Mephasm = "NPC Mephasm";
const string DMFI_NPC_Morkai = "NPC Morkai";
const string DMFI_NPC_Nolaloth = "NPC Nolaloth";
const string DMFI_NPC_Sarya = "NPC Sarya";
const string DMFI_NPC_Shandra = "NPC Shandra";
const string DMFI_NPC_Sydney = "NPC Sydney";
const string DMFI_NPC_Tenavrok = "NPC Tenavrok";
const string DMFI_NPC_TorioClaven = "NPC TorioClaven";
const string DMFI_NPC_Uthanck = "NPC Uthanck";
const string DMFI_NPC_Zaxis = "NPC Zaxis";
const string DMFI_NPC_Zeeaire = "NPC Zeeaire";
const string DMFI_NPC_Zees_Lt = "NPC Zees_Lt";
const string DMFI_NPC_Zhjaeve = "NPC Zhjaeve";
const string DMFI_NPC_Zokan = "NPC Zokan";
const string DMFI_Nymph = "Nymph";
const string DMFI_Ogre = "Ogre";
const string DMFI_Ogre_Mage = "OgreMage";
const string DMFI_Orc_A = "Orc";
const string DMFI_Pig = "Pig";
const string DMFI_Pixie = "Pixie";
const string DMFI_PushBlock = "PushBlock";
const string DMFI_Rabbit = "Rabbit";
const string DMFI_Rakshasas = "Rakshasas";
const string DMFI_Rat = "Rat";
const string DMFI_Rat_Dire = "Rat Dire";
const string DMFI_Salamander = "Salamander";
const string DMFI_Shadow = "Shadow";
const string DMFI_Shadow_Reaver = "Shadow Reaver";
const string DMFI_Siegetower = "Siegetower";
const string DMFI_SiegetowerB = "SiegetowerB";
const string DMFI_Sirene = "Sirene";
const string DMFI_Skeleton = "Skeleton";
const string DMFI_Skeleton_Common = "Skeleton Common";
const string DMFI_SmugglerWagon = "SmugglerWagon";
const string DMFI_Spectre = "Spectre";
const string DMFI_Spider_Blade = "Spider Blade";
const string DMFI_Spider_Dire = "Spider Dire";
const string DMFI_Spider_Giant = "Spider Giant";
const string DMFI_Spider_Glow = "Spider Glow";
const string DMFI_Spider_Kristal = "Spider Kristal";
const string DMFI_Spider_Phase = "Spider Phase";
const string DMFI_Spider_Wraith = "Spider Wraith";
const string DMFI_Succubus = "Succubus";
const string DMFI_Sylph = "Sylph";
const string DMFI_Tiger = "Tiger";
const string DMFI_Tiger_Dire = "Tiger Dire";
const string DMFI_Troll = "Troll";
const string DMFI_Troll_Forest = "Troll Forest";
const string DMFI_Troll_War = "Troll War";
const string DMFI_Umberhulk = "Umberhulk";
const string DMFI_Vampire = "Vampire";
const string DMFI_Vampire_Hd_Female = "Vampire Hd Female";
const string DMFI_Vampire_Hd_Male = "Vampire Hd Male";
const string DMFI_Vampire_Female = "Vampire Female";
const string DMFI_Vampire_Male = "Vampire Male";
const string DMFI_Weasel = "Weasel";
const string DMFI_Werewolf = "Werewolf";
const string DMFI_Will_O_Wisp = "Will O Wisp";
const string DMFI_Wraith = "Wraith";
const string DMFI_Wyvern_Blade = "Wyvern Blade";
const string DMFI_Wyvern_Crown = "Wyvern Crown";
const string DMFI_Wyvern_Horn = "Wyvern Horn";
const string DMFI_Zombie = "Zombie";
//Qk : added for motb 1.10

const string DMFI_Akachi = "Akachi";
const string DMFI_Okku = "Okku Bear";
const string DMFI_Panther = "Panther";
const string DMFI_Wolverine = "Wolverine";
const string DMFI_InvisibleStalker = "Invisible Stalker";
const string DMFI_Homunculus = "Homunculus";
const string DMFI_GolemImaskari = "Golem Imaskari";
const string DMFI_RedWizCompanion = "Red Wizard Companion";
const string DMFI_DeathKnight = "Death Knight";
const string DMFI_BarrowGuardian = "Barrow Guardian";
const string DMFI_SeaMonster = "Sea Monster";
const string DMFI_OneOfMany = "One of Many";
const string DMFI_ShamblingMoud = "Shambling Moud";
const string DMFI_Solar = "Solar";
const string DMFI_WolverineDire = "Dire Wolverine";
const string DMFI_DragonBlue = "Blue Dragon";
const string DMFI_Djinn = "Djinn";
const string DMFI_GnollThayan = "Gnoll Thayan";
const string DMFI_GolemClay = "Clay Golem";
const string DMFI_GolemFaithless ="Faithless Golem";
const string DMFI_Demilich = "Demilich";
const string DMFI_HagAnnis = "Annis Hag";
const string DMFI_HagGreen = "Green Hag";
const string DMFI_HagNight = "Night Hag";
const string DMFI_HorseWhite = "White Horse";
const string DMFI_DemilichSmall = "Small Demilich";
const string DMFI_LeopardSnow = "Snow Leopard";
const string DMFI_Treant = "Treant";
const string DMFI_TrollFell = "Fell Troll";
const string DMFI_Uthraki = "Uthraki";
const string DMFI_Wyvern = "Wyvern";
const string DMFI_RavenousIncarnation = "Ravenous Incarnation";
const string DMFI_ElfWild = "Wild Elf";
const string DMFI_HalfDrow = "Half drow";
const string DMFI_Magda = "Magda NPC";
const string DMFI_Nefris = "Nefris NPC";
const string DMFI_ElfWild2 = "ElfWild2";
const string DMFI_EarthGenasi = "Earth Genasi";
const string DMFI_FireGenasi = "Fire Genasi";
const string DMFI_AirGenasi = "Air Genasi";
const string DMFI_WaterGenasi = "Water Genasi";
const string DMFI_HalfDrow2 = "Half Drow";
const string DMFI_DogWolfTheltor = "Theltor dog";
const string DMFI_HagSpawn = "Hag Spawn";



////////////////////////////////////// NEW POST 1.03 //////////////////////////////

const string PRM_MANAGE = "manage";
const string PRM_GIVE = "give";
const string TXT_INVENTORY_MANAGE = "Inventory Copied for Manipulation.";
const string TXT_INVENTORY_ONLY = "Item must be in your inventory for this inventory action.";
const string TXT_INVENTORY_TARGET_INVALID = "Inventory Manage Target Invalid";
const string TXT_ITEM_GIVE = "Item or Items Given: ";
const string TXT_ITEM_CONTAINER_ERROR = "Error: Can only give contents of containers.  Empty containters NOT valid target.";


//////////////////////////////////// NEW IN 1.10 //////////////////////////////
//Translators be careful as this file changed some lines from 1.04
const string DMFI_STATUS_SHEET = "<b>DMFI STATUS SHEET</b>\n\n";
const string DONE_UI_BUTTON = "Done";
const string ONLY_ITEMCREAT = "You can only store items or creatures";
const string SUCCESS_ADD = "Succesfully added";
const string SLOT_EMPTY = "Empty";
const string TXT_NOTDMEQUAL = "You cannot manage the inventory to yourself";
//void main() {}