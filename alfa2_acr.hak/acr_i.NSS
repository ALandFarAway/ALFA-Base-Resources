////////////////////////////////////////////////////////////////////////////////
//
//  System Name : Alfa Core Rules
//     Filename : acr_i
//        Date  : 2009-07-28
//       Author : Ronan
//
//    Var Prefix: None.
//  Dependencies: Various 2da files.
//
//  Description
//  ALFA's global include file, which includes all new constants (skills, etc).
//
//  Revision History
//  date  author  remarks
//  2006/12/02  Ronan   Inception
//  2007/01/24  Cipher  Added placeholder functions for SetName() and SetLockLockable()
//                      until they are added into NWN2 to allow the source code to compile
//  2007/06/15  Cipher  Added new global variables and functions
//  2007/07/21  AcadiusLost  Cleared placeholder definitions for SetName and SetLockLockable
//  2007/07/23  Cipher  Removed placeholder definitions entirely - not needed
//  2007/07/27  Cipher  Replaced ACR_PLAYER_FLAGS with a bit field in the characters table
//  2008/01/19  AcadiusLost  Switched skill constants for implemented ones.
//  2008/12/29  AcadiusLost  Stopgap measure for mystery status reads on PC ID=0
//  2009/07/07  AcadiusLost  1.23 updates for custom skills
//  2009/07/28  AcadiusLost  Additional PGtF regional feat constants added.
//  2011/07/10  Basilica     Changed to cache player status
//  2011/09/08  Ronan     Added Bladesinger, Loremaster and Mystic Theurge constants.
////////////////////////////////////////////////////////////////////////////////

#ifndef ACR_I
#define ACR_I

////////////////////////////////////////////////////////////////////////////////
// Includes ////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////
#include "acr_db_persist_i"

////////////////////////////////////////////////////////////////////////////////
// Constants ///////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////

// Item tags:
const string ACR_NWN_GOLD_TAG = "NW_IT_GOLD001";

// Module local variables:
const string ACR_MOD_PROTECTION_LEVEL = "ACR_MOD_PROTECTION_LEVEL";

// Protection levels (must match GameWorldConfiguration.MemberProtectionLevel):
const int MEMBER_PROTECTION_LEVEL_OPEN = 0;
const int MEMBER_PROTECTION_LEVEL_QUARANTINE = 1;
const int MEMBER_PROTECTION_LEVEL_QUARANTINE_DM_ONLY_TELLS = 2;
const int MEMBER_PROTECTION_LEVEL_BOOT_5S_DELAY = 3;
const int MEMBER_PROTECTION_LEVEL_BOOT_IMMEDIATELY = 4;

// Base item types:
const int BASE_ITEM_TRADE_GOODS = 199;
const int BASE_ITEM_SHORT_MAGICSTAFF = 201;
const int BASE_ITEM_SMALL_SPEAR = 202;

// Classes:

const int CLASS_BLADESINGER = 104;
const int CLASS_LOREMASTER = 106;
const int CLASS_MYSTICTHEURGE = 44;

// Racial types:

const int RACIAL_TYPE_PLANT = 22;


// Action Modes:
const int ACTION_MODE_DARKVISION = 24;


// Chat Modes:

const int CHAT_MODE_SILENT_TALK = 13;

// Appearance types:

const int APPEARANCE_TYPE_DWARF_GOLD = 569;
const int APPEARANCE_TYPE_DWARF_GRAY = 570;
const int APPEARANCE_TYPE_ELF_DROW = 567;
const int APPEARANCE_TYPE_ELF_SUN = 565;
const int APPEARANCE_TYPE_ELF_WOOD = 566;
const int APPEARANCE_TYPE_ELF_WILD = 1036;
const int APPEARANCE_TYPE_GNOME_DEEP = 568;
const int APPEARANCE_TYPE_HALF_DROW = 1041;
const int APPEARANCE_TYPE_HALFLING_STRONG = 571;
const int APPEARANCE_TYPE_ORC_GRAY = 45;
const int APPEARANCE_TYPE_YUANTI = 40;
const int APPEARANCE_TYPE_AASIMAR = 563;
const int APPEARANCE_TYPE_TIEFLING = 564;
const int APPEARANCE_TYPE_GENASI_AIR = 1039;
const int APPEARANCE_TYPE_GENASI_EARTH = 1037;
const int APPEARANCE_TYPE_GENASI_FIRE = 1038;
const int APPEARANCE_TYPE_GENASI_WATER = 1040;


// Wing models
const int WING_MODEL_HUMAN_WHITE_MALE       = 31;
const int WING_MODEL_HUMAN_WHITE_FEMALE     = 21;
const int WING_MODEL_DWARF_WHITE_MALE       = 32;
const int WING_MODEL_DWARF_WHITE_FEMALE     = 33;
const int WING_MODEL_GNOME_WHITE_MALE       = 34;
const int WING_MODEL_GNOME_WHITE_FEMALE     = 35;
const int WING_MODEL_HALFORC_WHITE_MALE     = 36;
const int WING_MODEL_HALFORC_WHITE_FEMALE   = 37;
const int WING_MODEL_HUMAN_RED_MALE         = 38;
const int WING_MODEL_HUMAN_RED_FEMALE       = 14;
const int WING_MODEL_DWARF_RED_MALE         = 39;
const int WING_MODEL_DWARF_RED_FEMALE       = 40;
const int WING_MODEL_GNOME_RED_MALE         = 41;
const int WING_MODEL_GNOME_RED_FEMALE       = 42;
const int WING_MODEL_HALFORC_RED_MALE       = 43;
const int WING_MODEL_HALFORC_RED_FEMALE     = 44;
const int WING_MODEL_HUMAN_LEATHER_MALE     = 45;
const int WING_MODEL_HUMAN_LEATHER_FEMALE   = 46;
const int WING_MODEL_DWARF_LEATHER_MALE     = 47;
const int WING_MODEL_DWARF_LEATHER_FEMALE   = 48;
const int WING_MODEL_GNOME_LEATHER_MALE     = 49;
const int WING_MODEL_GNOME_LEATHER_FEMALE   = 50;
const int WING_MODEL_HALFORC_LEATHER_MALE   = 51;
const int WING_MODEL_HALFORC_LEATHER_FEMALE = 52;

// Spells and spell-like abilities:

const int SPELL_INVALID = 0;
const int SPELL_ACID_FOG_ACR = 1216;
const int SPELL_DIMENSIONAL_ANCHOR = 3089;
const int SPELL_ELDRITCH_BLAST_1 = 844;
const int SPELL_ELDRITCH_BLAST_2 = 949;
const int SPELL_ELDRITCH_BLAST_3 = 950;
const int SPELL_ELDRITCH_BLAST_4 = 951;
const int SPELL_ELDRITCH_BLAST_5 = 952;
const int SPELL_ELDRITCH_BLAST_6 = 953;
const int SPELL_ELDRITCH_BLAST_7 = 954;
const int SPELL_ELDRITCH_BLAST_8 = 955;
const int SPELL_ELDRITCH_BLAST_9 = 956;
const int SPELL_FEATHER_FALL = 3086;
const int SPELL_GLIBNESS = 3125;
const int SPELL_LOREMASTER_GREATERLORE = 3018;
const int SPELL_LOREMASTER_TRUELORE = 3019;
const int SPELL_READ_MAGIC = 3003;
const int SPELL_RECALL_SPIRIT = 1157;
const int SPELL_WATER_BREATHING = 3113;

// Feat spell scripts:

const int SPELL_CRAFT = 2999;

// Skills:

// Custom skill constants, these reference the appropriate lines in both skills.2da
//  and the cls_skill_* 2DA files.  1/19/2008 - reflect the limit of 55 rows.

const int SKILL_BALANCE = 30;
const int SKILL_CLIMB = 31;
const int SKILL_CRAFT__ALCHEMY = 64;
const int SKILL_CRAFT_ARMORSMITHING = 65;
const int SKILL_CRAFT_BOWMAKING = 66;
const int SKILL_CRAFT_WEAPONSMITHING = 67;
const int SKILL_DECIPHER_SCRIPT = 32;
const int SKILL_DISGUISE = 34;
const int SKILL_ESCAPE_ARTIST = 35;
const int SKILL_FORGERY = 36;
const int SKILL_GATHER_INFORMATION = 37;
const int SKILL_HANDLE_ANIMAL = 38;
const int SKILL_JUMP = 39;
const int SKILL_KNOWLEDGE_ARCANA = 40;
const int SKILL_KNOWLEDGE_DUNGEONEERING = 33;
const int SKILL_KNOWLEDGE_ENGINEERING = 58;
const int SKILL_KNOWLEDGE_GEOGRAPHY = 55;
const int SKILL_KNOWLEDGE_HISTORY = 41;
const int SKILL_KNOWLEDGE_LOCAL = 59;
const int SKILL_KNOWLEDGE_NATURE = 42;
const int SKILL_KNOWLEDGE_NOBILITY = 56;
const int SKILL_KNOWLEDGE_RELIGION = 43;
const int SKILL_KNOWLEDGE_THE_PLANES = 44;
const int SKILL_PERFORM_ACT = 45;
const int SKILL_PERFORM_COMEDY = 63;
const int SKILL_PERFORM_DANCE = 46;
const int SKILL_PERFORM_KEYBOARD = 61;
const int SKILL_PERFORM_ORATORY = 47;
const int SKILL_PERFORM_PERCUSSION = 60;
const int SKILL_PERFORM_STRING_INSTRUMENTS = 48;
const int SKILL_PERFORM_SING = 49;
const int SKILL_PERFORM_WIND_INSTRUMENTS = 62;
const int SKILL_PROFESSION = 50;
const int SKILL_SENSE_MOTIVE = 51;
const int SKILL_SPEAK_LANGUAGE = 52;
const int SKILL_SWIM = 53;
const int SKILL_USE_ROPE = 54;

// Regional Feats:
const int FEAT_REGION_INVALID = -1;
const int FEAT_REGION_AGLAROND = 3502;
const int FEAT_REGION_ALTUMBEL = 3561;
const int FEAT_REGION_AMN = 3503;
const int FEAT_REGION_ANAUROCH = 3504;
const int FEAT_REGION_CALIMSHAN = 3505;
const int FEAT_REGION_CHESSENTA = 3506;
const int FEAT_REGION_CHONDALWOOD = 3507;
const int FEAT_REGION_CHULT = 3508;
const int FEAT_REGION_CORMYR = 3509;
const int FEAT_REGION_DALELANDS = 3510;
const int FEAT_REGION_DAMARA = 3511;
const int FEAT_REGION_DAMBRATH = 3562;
const int FEAT_REGION_DRAGON_COAST = 3512;
const int FEAT_REGION_DWARF_GOLD = 3513;
const int FEAT_REGION_DWARF_GRAY = 3514;
const int FEAT_REGION_DWARF_SHIELD = 3515;
const int FEAT_REGION_ELF_DROW = 3516;
const int FEAT_REGION_ELF_MOON = 3517;
const int FEAT_REGION_ELF_SUN = 3518;
const int FEAT_REGION_ELF_WILD = 3519;
const int FEAT_REGION_ELF_WOOD = 3520;
const int FEAT_REGION_EVERMEET = 3521;
//const int FEAT_REGION_FOREST_OF_AMTAR = -1;
const int FEAT_REGION_GNOME_DEEP = 3522;
const int FEAT_REGION_GNOME_ROCK = 3523;
const int FEAT_REGION_GOLDEN_WATER = 3563;
const int FEAT_REGION_GREAT_DALE = 3524;
const int FEAT_REGION_GREAT_GLACIER = 3564;
const int FEAT_REGION_HALFELF = 3525;
const int FEAT_REGION_HALFORC = 3526;
const int FEAT_REGION_HALFLING_GHOSTWISE = 3527;
const int FEAT_REGION_HALFLING_LIGHTFOOT = 3528;
const int FEAT_REGION_HALFLING_STRONGHEART = 3529;
const int FEAT_REGION_HALRUAA = 3530;
const int FEAT_REGION_HIGH_FOREST = 3531;
const int FEAT_REGION_HORDELANDS = 3532;
const int FEAT_REGION_IMPILTUR = 3533;
//const int FEAT_REGION_INNER_SEA = -1;
const int FEAT_REGION_LAKE_OF_STEAM = 3534;
const int FEAT_REGION_LAPALIIYA = 3565;
const int FEAT_REGION_LANTAN = 3535;
const int FEAT_REGION_LUIREN = 3536;
const int FEAT_REGION_MOONSEA = 3537;
const int FEAT_REGION_MOONSHAE_ISLES = 3538;
//const int FEAT_REGION_MISTY_VALE = -1;
const int FEAT_REGION_MULHORAND = 3539;
const int FEAT_REGION_NARFELL = 3540;
const int FEAT_REGION_NELANTHER = 3541;
//const int FEAT_REGION_NIMBRAL = -1;
const int FEAT_REGION_NORTH = 3542;
const int FEAT_REGION_ORC = 3543;
//const int FEAT_REGION_OUTER_SEA = -1;
const int FEAT_REGION_RASHEMEN = 3544;
//const int FEAT_REGION_RATHGAUNT_HILLS = -1;
//const int FEAT_REGION_RETHILD = -1;
const int FEAT_REGION_RIDE = 3566;
//const int FEAT_REGION_SAMARACH = -1;
const int FEAT_REGION_SEMBIA = 3545;
const int FEAT_REGION_SESPECH = 3546;
const int FEAT_REGION_SHAAR = 3547;
const int FEAT_REGION_SILVERYMOON = 3548;
const int FEAT_REGION_SHADOVAR = 3567;
const int FEAT_REGION_SHOU_EXPATRIATE = 3568;
const int FEAT_REGION_SILVER_MARCHES = 3548;
//const int FEAT_REGION_SMOKING_MOUNTAINS = -1;
//const int FEAT_REGION_SWAGDAR = -1;
const int FEAT_REGION_SWORD_COAST = 3569;
const int FEAT_REGION_TASHALAR = 3549;
//const int FEAT_REGION_THARSULT = -1;
//const int FEAT_REGION_THINDOL = -1;
const int FEAT_REGION_TETHYR = 3550;
const int FEAT_REGION_THAY = 3551;
const int FEAT_REGION_THESK = 3552;
const int FEAT_REGION_TURMISH = 3553;
//const int FEAT_REGION_UNDERDARK_BURRIED_REALMS = 3052;
//const int FEAT_REGION_UNDERDARK_DARKLANDS = 3053;
//const int FEAT_REGION_UNDERDARK_EARTHROOT = 3054;
//const int FEAT_REGION_UNDERDARK_GLIMMERSEA = 3055;
//const int FEAT_REGION_UNDERDARK_GREAT_BHAERYNDEN = 3056;
//const int FEAT_REGION_UNDERDARK_NORTHDARK = 3057;
//const int FEAT_REGION_UNDERDARK_OLD_SHANATAR = 3058;
const int FEAT_REGION_UNTHER = 3554;
const int FEAT_REGION_UTHGART = 3570;
const int FEAT_REGION_VAASA = 3555;
const int FEAT_REGION_VAST = 3556;
const int FEAT_REGION_VILHON_REACH = 3557;
const int FEAT_REGION_WATERDEEP = 3558;
//const int FEAT_REGION_WEALDATH = -1;
const int FEAT_REGION_WESTERN_HEARTLANDS = 3559;
const int FEAT_REGION_WIZARDS_REACH = 3571;
const int FEAT_REGION_OTHER = 3560;

// Standard and Background feats
const int FEAT_COSMOPOLITAN      = 2600;
const int FEAT_DISCIPLINE        = 2601;
const int FEAT_FEARLESS_BK       = 2602;
const int FEAT_FORGEHEART        = 2603;
const int FEAT_FORESTER          = 2604;
const int FEAT_SPELLWISE         = 2605;
const int FEAT_STREET_SMART      = 2606;
const int FEAT_SUREFOOTED        = 2607;
const int FEAT_SURVIVOR          = 2608;
const int FEAT_TREETOPPER        = 2609;

const int FEAT_ACROBATIC         = 2610;
const int FEAT_AGILE             = 2611;
const int FEAT_ANIMAL_AFFINITY   = 2612;
const int FEAT_ATHLETIC          = 2613;
const int FEAT_DECEITFUL         = 2614;
const int FEAT_DEFT_HANDS        = 2615;
const int FEAT_DILIGENT          = 2616;
const int FEAT_INVESTIGATOR      = 2617;
const int FEAT_MAGICAL_APTITUDE  = 2618;
const int FEAT_PERSUASIVE        = 2619;

// Skill focus feats.
const int FEAT_SKILL_FOCUS_BALANCE = 3630;
const int FEAT_SKILL_FOCUS_CLIMB = 3631;
const int FEAT_SKILL_FOCUS_DECIPHER = 3632;
const int FEAT_SKILL_FOCUS_DISGUISE = 3633;
const int FEAT_SKILL_FOCUS_ESC_ART = 3634;
const int FEAT_SKILL_FOCUS_FORGERY = 3635;
const int FEAT_SKILL_FOCUS_GATH_INFO = 3636;
const int FEAT_SKILL_FOCUS_HAND_ANIM = 3637;
const int FEAT_SKILL_FOCUS_JUMP = 3638;
const int FEAT_SKILL_FOCUS_PROF = 3639;
const int FEAT_SKILL_FOCUS_RIDE_ACR = 3640;
const int FEAT_SKILL_FOCUS_SENS_MOTV = 3641;
const int FEAT_SKILL_FOCUS_SPK_LANG = 3642;
const int FEAT_SKILL_FOCUS_SWIM = 3643;
const int FEAT_SKILL_FOCUS_USE_ROPE = 3644;
const int FEAT_SKILL_FOCUS_KNOW_ARC = 3645;
const int FEAT_SKILL_FOCUS_KNOW_DUNG = 3646;
const int FEAT_SKILL_FOCUS_KNOW_ENG = 3647;
const int FEAT_SKILL_FOCUS_KNOW_GEO = 3648;
const int FEAT_SKILL_FOCUS_KNOW_HIST = 3649;
const int FEAT_SKILL_FOCUS_KNOW_LOC = 3650;
const int FEAT_SKILL_FOCUS_KNOW_NATR = 3651;
const int FEAT_SKILL_FOCUS_KNOW_NOBL = 3652;
const int FEAT_SKILL_FOCUS_KNOW_PLAN = 3653;
const int FEAT_SKILL_FOCUS_KNOW_RELG = 3654;
const int FEAT_SKILL_FOCUS_PERF_ACT = 3655;
const int FEAT_SKILL_FOCUS_PERF_COMD = 3656;
const int FEAT_SKILL_FOCUS_PERF_DANC = 3657;
const int FEAT_SKILL_FOCUS_PERF_KEYB = 3658;
const int FEAT_SKILL_FOCUS_PERF_ORAT = 3659;
const int FEAT_SKILL_FOCUS_PERF_PERC = 3660;
const int FEAT_SKILL_FOCUS_PERF_SING = 3661;
const int FEAT_SKILL_FOCUS_PERF_STRG = 3662;
const int FEAT_SKILL_FOCUS_PERF_WIND = 3663;
const int FEAT_SKILL_FOCUS_CRFT_ALCH = 3664;
const int FEAT_SKILL_FOCUS_CRFT_ARM = 3665;
const int FEAT_SKILL_FOCUS_CRFT_BOW = 3666;
const int FEAT_SKILL_FOCUS_CRFT_WPN = 3667;

// Crafting feats:
const int FEAT_CRAFT = 3618;
const int FEAT_CRAFT_CONSTRUCT = 3581;
const int FEAT_FORGE_RING = 3572;
const int FEAT_CRAFT_ROD = 3573;
const int FEAT_CRAFT_STAFF = 3574;

// Bladesinger feats:
const int FEAT_BLADESINGER_SPELLCASTING_BARD = 3587;
const int FEAT_BLADESINGER_SPELLCASTING_SORCERER = 3588;
const int FEAT_BLADESINGER_SPELLCASTING_WIZARD = 3589;
const int FEAT_BLADESINGER_BLADESONG_STYLE = 3590;
const int FEAT_BLADESINGER_SONG_CELERITY = 3591;
const int FEAT_BLADESINGER_SONG_FURY = 3592;
const int FEAT_BLADESINGER_SPELLSONG = 3593;
const int FEAT_BLADESINGER_SONG_CELERITY_2 = 3617;

// Loremaster feats:
const int FEAT_LOREMASTER_SPELLCASTING_WIZARD = 3601;
const int FEAT_LOREMASTER_SPELLCASTING_CLERIC = 3602;
const int FEAT_LOREMASTER_SPELLCASTING_DRUID = 3603;
const int FEAT_LOREMASTER_SPELLCASTING_PALADIN = 3604;
const int FEAT_LOREMASTER_SPELLCASTING_RANGER = 3605;
const int FEAT_LOREMASTER_SPELLCASTING_SS = 3606;
const int FEAT_LOREMASTER_SPELLCASTING_FS = 3607;
const int FEAT_LOREMASTER_SPELLCASTING_BARD = 3609;
const int FEAT_LOREMASTER_SPELLCASTING_SORCERER = 3611;

const int FEAT_LORE = 3612;
const int FEAT_BONUSLANGUAGE1 = 3613;
const int FEAT_BONUSLANGUAGE2 = 3616;
const int FEAT_GREATERLORE = 3614;
const int FEAT_TRUELORE = 3615;

// Mystic Theurge feats:
const int FEAT_MYSTICTHEURGE_SPELLCASTING_WIZARD = 3594;
const int FEAT_MYSTICTHEURGE_SPELLCASTING_CLERIC = 3595;
const int FEAT_MYSTICTHEURGE_SPELLCASTING_DRUID = 3596;
const int FEAT_MYSTICTHEURGE_SPELLCASTING_PALADIN = 3597;
const int FEAT_MYSTICTHEURGE_SPELLCASTING_RANGER = 3598;
const int FEAT_MYSTICTHEURGE_SPELLCASTING_SS = 3599;
const int FEAT_MYSTICTHEURGE_SPELLCASTING_FS = 3600;
const int FEAT_MYSTICTHEURGE_SPELLCASTING_BARD = 3608;
const int FEAT_MYSTICTHEURGE_SPELLCASTING_SORCERER = 3610;

const int FEAT_PRACTICED_SPELLCASTER_SPIRIT_SHAMAN = 2003;
const int FEAT_PRACTICED_SPELLCASTER_FAVORED_SOUL = 2068;

// Unlisted OE PrC spellcasting feats:
const int FEAT_ARCTRICKSTER_SPELLCASTING_BARD = 1512;
const int FEAT_ARCTRICKSTER_SPELLCASTING_SORCERER = 1513;
const int FEAT_ARCTRICKSTER_SPELLCASTING_WIZARD = 1514;

const int FEAT_ELDRITCH_KNIGHT_SPELLCASTING_BARD = 1820;
const int FEAT_ELDRITCH_KNIGHT_SPELLCASTING_SORCERER = 1821;
const int FEAT_ELDRITCH_KNIGHT_SPELLCASTING_WIZARD = 1822;

const int FEAT_HARPER_SPELLCASTING_CLERIC = 1576;
const int FEAT_HARPER_SPELLCASTING_DRUID = 1577;
const int FEAT_HARPER_SPELLCASTING_SORCERER = 1578;
const int FEAT_HARPER_SPELLCASTING_WIZARD = 1579;
const int FEAT_HARPER_SPELLCASTING_WARLOCK = 1580;
const int FEAT_HARPER_SPELLCASTING_BARD = 1581;
const int FEAT_HARPER_SPELLCASTING_PALADIN = 1582;
const int FEAT_HARPER_SPELLCASTING_RANGER = 1583;
const int FEAT_HARPER_SPELLCASTING_FAVORED_SOUL = 2078;
const int FEAT_HARPER_SPELLCASTING_SPIRIT_SHAMAN = 2013;

const int FEAT_WARPRIEST_SPELLCASTING_CLERIC = 1808;
const int FEAT_WARPRIEST_SPELLCASTING_DRUID = 1809;
const int FEAT_WARPRIEST_SPELLCASTING_PALADIN = 1810;
const int FEAT_WARPRIEST_SPELLCASTING_RANGER = 1811;
const int FEAT_WARPRIEST_SPELLCASTING_SPIRIT_SHAMAN = 2014;
const int FEAT_WARPRIEST_SPELLCASTING_FAVORED_SOUL = 2079;

const int FEAT_ARCANE_SCHOLAR_SPELLCASTING_BARD = 1887;
const int FEAT_ARCANE_SCHOLAR_SPELLCASTING_SORCERER = 1888;
const int FEAT_ARCANE_SCHOLAR_SPELLCASTING_WIZARD = 1889;

const int FEAT_RED_WIZARD_SPELLCASTING_WIZARD = 1886;
const int FEAT_SPELL_POWER_1 = 1881;
const int FEAT_SPELL_POWER_2 = 1882;
const int FEAT_SPELL_POWER_3 = 1883;
const int FEAT_SPELL_POWER_4 = 1884;
const int FEAT_SPELL_POWER_5 = 1885;

const int FEAT_STORMLORD_SPELLCASTING_CLERIC = 2033;
const int FEAT_STORMLORD_SPELLCASTING_DRUID = 2034;
const int FEAT_STORMLORD_SPELLCASTING_PALADIN = 2035;
const int FEAT_STORMLORD_SPELLCASTING_RANGER = 2036;
const int FEAT_STORMLORD_SPELLCASTING_SPIRIT_SHAMAN = 2037;
const int FEAT_STORMLORD_SPELLCASTING_FAVORED_SOUL = 2080;

const int FEAT_DOOMGUIDE_CLERIC_SPELLCASTING = 2249;
const int FEAT_DOOMGUIDE_PALADIN_SPELLCASTING = 2250;
const int FEAT_DOOMGUIDE_DRUID_SPELLCASTING = 2251;
const int FEAT_DOOMGUIDE_SPIRIT_SHAMAN_SPELLCASTING = 2252;
const int FEAT_DOOMGUIDE_FAVORED_SOUL_SPELLCASTING = 2253;
const int FEAT_DOOMGUIDE_RANGER_SPELLCASTING = 2254;

const int FEAT_SACREDFIST_SPELLCASTING_CLERIC = 1549;
const int FEAT_SACREDFIST_SPELLCASTING_DRUID = 1550;
const int FEAT_SACREDFIST_SPELLCASTING_PALADIN = 1551;
const int FEAT_SACREDFIST_SPELLCASTING_RANGER = 1552;
const int FEAT_SACREDFIST_SPELLCASTING_SPIRIT_SHAMAN = 2101;
const int FEAT_SACREDFIST_SPELLCASTING_FAVORED_SOUL = 2102;

// Mode Feats
const int FEAT_ACR_COMBAT_EXPERTISE          = 3668;
const int FEAT_ACR_IMPROVED_COMBAT_EXPERTISE = 3669;
const int FEAT_ACR_POWER_ATTACK              = 3670;
const int FEAT_ACR_IMPROVED_POWER_ATTACK     = 3671;

// Domain feats
const int FEAT_CHAOS_DOMAIN_POWER      = 3672;
const int FEAT_LAW_DOMAIN_POWER        = 3673;
const int FEAT_COLD_DOMAIN_POWER       = 3674;
const int FEAT_MOON_DOMAIN_POWER       = 3725;
const int FEAT_SCALYKIND_DOMAIN_POWER  = 3732;
const int FEAT_SLIME_DOMAIN_POWER      = 3733;
const int FEAT_SPIDER_DOMAIN_POWER     = 3734;

// Other feats.
const int FEAT_A_THOUSAND_FACES = 3739;
const int FEAT_TIMELESS_BODY = 3738;

// Item materials:
int    GMATERIAL_INVALID = -1;
int    GMATERIAL_WOOD = 100;
int    GMATERIAL_ARANDUR = 101;
int    GMATERIAL_ASTRAL_DRIFTMETAL = 102;
int    GMATERIAL_BLUEWOOD = 103;
int    GMATERIAL_ALCHEMICAL_COPPER = 104;
int    GMATERIAL_DLARUN = 105;
int    GMATERIAL_DRAGONFANG = 106;
int    GMATERIAL_DRAGONHIDE = 107;
int    GMATERIAL_FEVER_IRON = 108;
int    GMATERIAL_FIENDBONE = 109;
int    GMATERIAL_FRYSTALLINE = 110;
int    GMATERIAL_ALCHEMICAL_GOLD = 111;
int    GMATERIAL_HIZAGKUUR = 112;
int    GMATERIAL_LIVING_METAL = 113;
int    GMATERIAL_PANDEMONIC_SILVER = 114;
int    GMATERIAL_ALCHEMICAL_PLATINUM = 115;
int    GMATERIAL_SERREN = 116;
int    GMATERIAL_SONDAR = 117;
int    GMATERIAL_SUZAILIAN_CHAINWEAVE = 118;
int    GMATERIAL_NONSPECIFIC_METAL = 119;
int    GMATERIAL_NONSPECIFIC_NONMETAL = 120;

// Item properties:
int ITEM_PROPERTY_COPPER_VALUE = 200;
int ITEM_PROPERTY_SILVER_VALUE = 201;
int ITEM_PROPERTY_DROWCRAFT = 202;
int ITEM_PROPERTY_NONLETHAL = 203;
int ITEM_PROPERTY_TRADESCROLL = 204;
int ITEM_PROPERTY_USE_LIMITATION_GENDER = 205;
int ITEM_PROPERTY_USE_LIMITATION_SIZE = 206;
int ITEM_PROPERTY_NONDETECTION = 207;
int ITEM_PROPERTY_MATERIAL = 208;
int ITEM_PROPERTY_AMBIENT_COLD_PROTECTION = 209;
int ITEM_PROPERTY_CRAFTING_PROJECT = 126;
int ITEM_PROPERTY_FEATHER_FALL = 127;

int IP_MISC_OFFSET = 0;
int IP_FEAT_OFFSET = 10000;

// Item Property Feats:
const int IP_CONST_FEAT_DARKVISION = 500;
const int IP_CONST_FEAT_LOWLIGHTVISION = 501;

const int IPRP_FEATS_ALERTNESS = 0;
const int IPRP_FEATS_COMBAT_CASTING = 3;
const int IPRP_FEATS_DODGE = 4;
const int IPRP_FEATS_EXTRA_TURNING = 5;
const int IPRP_FEATS_MOBILITY = 27;
const int IPRP_FEATS_SPELL_PENETRATION = 15;
const int IPRP_FEATS_TWO_WEAPON_FIGHTING = 17;
const int IPRP_FEATS_WEAPON_FINESSE = 19;

// Area of Effects:
int AOE_CIRCLE_RADIUS_1            = 200;
int AOE_CIRCLE_RADIUS_2            = 201;
int AOE_CIRCLE_RADIUS_3            = 202;
int AOE_CIRCLE_RADIUS_4            = 203;
int AOE_CIRCLE_RADIUS_5            = 204;
int AOE_CIRCLE_RADIUS_6            = 205;
int AOE_CIRCLE_RADIUS_7            = 206;
int AOE_CIRCLE_RADIUS_8            = 207;
int AOE_CIRCLE_RADIUS_9            = 208;
int AOE_CIRCLE_RADIUS_10           = 209;
int AOE_CIRCLE_RADIUS_11           = 210;
int AOE_CIRCLE_RADIUS_12           = 211;
int AOE_CIRCLE_RADIUS_13           = 212;
int AOE_CIRCLE_RADIUS_14           = 213;
int AOE_CIRCLE_RADIUS_15           = 214;
int AOE_CIRCLE_RADIUS_16           = 215;
int AOE_CIRCLE_RADIUS_17           = 216;
int AOE_CIRCLE_RADIUS_18           = 217;
int AOE_CIRCLE_RADIUS_19           = 218;
int AOE_CIRCLE_RADIUS_20           = 219;
int AOE_CIRCLE_RADIUS_21           = 220;
int AOE_CIRCLE_RADIUS_22           = 221;
int AOE_CIRCLE_RADIUS_23           = 222;
int AOE_CIRCLE_RADIUS_24           = 223;
int AOE_CIRCLE_RADIUS_25           = 224;
int AOE_CIRCLE_RADIUS_26           = 225;
int AOE_CIRCLE_RADIUS_27           = 226;
int AOE_CIRCLE_RADIUS_28           = 227;
int AOE_CIRCLE_RADIUS_29           = 228;
int AOE_CIRCLE_RADIUS_30           = 229;
int AOE_CIRCLE_RADIUS_31           = 230;
int AOE_CIRCLE_RADIUS_32           = 231;
int AOE_CIRCLE_RADIUS_33           = 232;
int AOE_CIRCLE_RADIUS_34           = 233;
int AOE_CIRCLE_RADIUS_35           = 234;
int AOE_CIRCLE_RADIUS_36           = 235;
int AOE_CIRCLE_RADIUS_37           = 236;
int AOE_CIRCLE_RADIUS_38           = 237;
int AOE_CIRCLE_RADIUS_39           = 238;
int AOE_CIRCLE_RADIUS_40           = 239;
int AOE_CIRCLE_RADIUS_41           = 240;
int AOE_CIRCLE_RADIUS_42           = 241;
int AOE_CIRCLE_RADIUS_43           = 242;
int AOE_CIRCLE_RADIUS_44           = 243;
int AOE_CIRCLE_RADIUS_45           = 244;
int AOE_CIRCLE_RADIUS_46           = 245;
int AOE_CIRCLE_RADIUS_47           = 246;
int AOE_CIRCLE_RADIUS_48           = 247;
int AOE_CIRCLE_RADIUS_49           = 248;
int AOE_CIRCLE_RADIUS_50           = 249;

//! ACR_PLAYER_FLAGS Bit Maps
//! Define all booleans as bits to conserve memory
const int ACR_PLAYER_FLAG_DEAD        = 0x001;
const int ACR_PLAYER_FLAG_DYING       = 0x002;
const int ACR_PLAYER_FLAG_SUBDUED     = 0x004;
const int ACR_PLAYER_FLAG_STAGGERED   = 0x008;
const int ACR_PLAYER_FLAG_BLEEDING    = 0x010;
const int ACR_PLAYER_FLAG_UNCONSCIOUS = 0x020;
const int ACR_PLAYER_FLAG_STABILIZED  = 0x040;
const int ACR_PLAYER_FLAG_MUTILATED   = 0x080;
const int ACR_PLAYER_FLAG_DECAYED     = 0x100;

const int ACR_PLAYER_FLAG_ALL         = 0xFFF;

//
// The following flags must immediately hit the database so that they can be
// referenced by the death system (which bypasses the cache as it works on the
// placeholder item or placeable).
//

int ACR_PLAYER_FLAG_UNCACHEABLE_FLAGS = ACR_PLAYER_FLAG_DEAD      |
                                        ACR_PLAYER_FLAG_MUTILATED |
                                        ACR_PLAYER_FLAG_DECAYED;

////////////////////////////////////////////////////////////////////////////////
// Structures //////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////

////////////////////////////////////////////////////////////////////////////////
// Global Variables ////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////

////////////////////////////////////////////////////////////////////////////////
// Function Prototypes /////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////

//! This function sets one or more status flags in the player status bit field
//!  - oPC: The player whose status to adjust
//!  - nStatus: The status flag(s) to set
//!  - Returns: nothing
void ACR_SetPlayerStatusFlags(object oPC, int nStatus);

//! This function unsets one or more status flags in the player status bit field
//!  - oPC: The player whose status to adjust
//!  - nStatus: The status flag(s) to unset
//!  - Returns: nothing
void ACR_UnsetPlayerStatusFlags(object oPC, int nStatus);

//! This function retrieves the player status flags
//!  - oPC: The player whose status to adjust
//!  - Returns: The integer status value
int ACR_GetPlayerStatusFlags(object oPC);

//! This function determines if a player is dead.
//!  - oPC: The player whose status to check
//!  - Returns: TRUE if dead, FALSE if alive
int ACR_GetIsPlayerDead(object oPC);

//! This function determines if a player is dying.
//!  - oPC: The player whose status to check
//!  - Returns: TRUE if dying, FALSE if alive
int ACR_GetIsPlayerDying(object oPC);

//! This function determines if a player is subdued.
//!  - oPC: The player whose status to check
//!  - Returns: TRUE if subdued, FALSE otherwise
int ACR_GetIsPlayerSubdued(object oPC);

//! This function determines if a player is staggered.
//!  - oPC: The player whose status to check
//!  - Returns: TRUE if staggered, FALSE otherwise
int ACR_GetIsPlayerStaggered(object oPC);

//! This function determines if a player is bleeding.
//!  - oPC: The player whose status to check
//!  - Returns: TRUE if bleeding, FALSE otherwise
int ACR_GetIsPlayerBleeding(object oPC);

//! This function determines if a player is unconscious.
//!  - oPC: The player whose status to check
//!  - Returns: TRUE if unconscious, FALSE if conscious
int ACR_GetIsPlayerUnconscious(object oPC);

//! This function determines if a player has stabilized.
//!  - oPC: The player whose status to check
//!  - Returns: TRUE if stabilized, FALSE otherwise
int ACR_GetIsPlayerStabilized(object oPC);

//! This function determines if a corpse has been mutilated.
//!  - oCorpse: The player or corpse object whose status to check
//!  - Returns: TRUE if mutilated, FALSE if not mutilated
int ACR_GetIsCorpseMutilated(object oCorpse);

//! This function determines if a corpse has been decayed.
//!  - oCorpse: The player or corpse object whose status to check
//!  - Returns: TRUE if decayed, FALSE if not decayed
int ACR_GetIsCorpseDecayed(object oCorpse);

//! This function gets the member protection level for the module.
//!  - Returns: MEMBER_PROTECTION_LEVEL_*
int ACR_GetProtectionLevel();

////////////////////////////////////////////////////////////////////////////////
// Function Definitions ////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////

void ACR_SetPlayerStatusFlags(object oPC, int nStatus)
{
	int FlushRequired;
	int OldStatus = ACR_GetPlayerStatusFlags(oPC);

	//
	// Ensure that if we are modifying the dead flag that it is immediately set
	// so that the death system can query it at any time.  The death system will
	// issue set/get flags operations on the placeholder corpse objects and so
	// it can't use the cache.
	//

	if ((OldStatus & ACR_PLAYER_FLAG_UNCACHEABLE_FLAGS) != (nStatus & ACR_PLAYER_FLAG_UNCACHEABLE_FLAGS))
		FlushRequired = TRUE;
	else
		FlushRequired = FALSE;

	SetLocalInt(oPC, ACR_PLAYERSTATUS_CACHE_VAR, ACR_GetPlayerStatusFlags(oPC) | nStatus);
	ACR_AsyncSQLQueryEx("UPDATE characters SET Status=Status | " + IntToString(nStatus) + " WHERE id=" + IntToString(ACR_GetCharacterID(oPC)), oPC);

	if (FlushRequired)
		ACR_FlushQueryQueue(oPC);
}

void ACR_UnsetPlayerStatusFlags(object oPC, int nStatus)
{
	SetLocalInt(oPC, ACR_PLAYERSTATUS_CACHE_VAR, ACR_GetPlayerStatusFlags(oPC) & ~(nStatus));
	ACR_AsyncSQLQueryEx("UPDATE characters SET Status=Status & ~(" + IntToString(nStatus) + ") WHERE id=" + IntToString(ACR_GetCharacterID(oPC)), oPC);
}

int ACR_GetPlayerStatusFlags(object oPC)
{
	int nPCID = ACR_GetCharacterID(oPC);
	if (nPCID == 0) {
		// Invalid call for status, log and return 0 instead of querying.  (stopgap measure)
		WriteTimestampedLogEntry("Invalid status query on "+GetName(oPC)+" with PCPlayerName= "+GetPCPlayerName(oPC)+" in area "+GetName(GetArea(oPC))+".");
		return 0;
	}

	//
	// Only use the cache if we are a PC.  Otherwise we must talk to the
	// database directly so that the death system can always get the death
	// status at any time.
	//

	if (GetIsPC(oPC))
		return GetLocalInt(oPC, ACR_PLAYERSTATUS_CACHE_VAR);

	ACR_SQLQuery("SELECT Status FROM characters WHERE id=" + IntToString(nPCID));
	return (ACR_SQLFetch() == SQL_SUCCESS) ? StringToInt(ACR_SQLGetData(0)) : 0;
}

int ACR_GetIsPlayerDead(object oPC)
{
    return (ACR_GetPlayerStatusFlags(oPC) & ACR_PLAYER_FLAG_DEAD);
}

int ACR_GetIsPlayerDying(object oPC)
{
    return (ACR_GetPlayerStatusFlags(oPC) & ACR_PLAYER_FLAG_DYING);
}

int ACR_GetIsPlayerSubdued(object oPC)
{
    return (ACR_GetPlayerStatusFlags(oPC) & ACR_PLAYER_FLAG_SUBDUED);
}

int ACR_GetIsPlayerStaggered(object oPC)
{
    return (ACR_GetPlayerStatusFlags(oPC) & ACR_PLAYER_FLAG_STAGGERED);
}

int ACR_GetIsPlayerBleeding(object oPC)
{
    return (ACR_GetPlayerStatusFlags(oPC) & ACR_PLAYER_FLAG_BLEEDING);
}

int ACR_GetIsPlayerUnconscious(object oPC)
{
    return (ACR_GetPlayerStatusFlags(oPC) & ACR_PLAYER_FLAG_UNCONSCIOUS);
}

int ACR_GetIsPlayerStabilized(object oPC)
{
    return (ACR_GetPlayerStatusFlags(oPC) & ACR_PLAYER_FLAG_STABILIZED);
}

int ACR_GetIsCorpseMutilated(object oCorpse)
{
    return (ACR_GetPlayerStatusFlags(oCorpse) & ACR_PLAYER_FLAG_MUTILATED);
}

int ACR_GetIsCorpseDecayed(object oCorpse)
{
    return (ACR_GetPlayerStatusFlags(oCorpse) & ACR_PLAYER_FLAG_DECAYED);
}

int ACR_GetProtectionLevel()
{
	return GetLocalInt(GetModule(), ACR_MOD_PROTECTION_LEVEL);
}

#endif
