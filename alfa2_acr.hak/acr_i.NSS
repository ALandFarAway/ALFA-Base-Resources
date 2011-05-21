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
////////////////////////////////////////////////////////////////////////////////

////////////////////////////////////////////////////////////////////////////////
// Includes ////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////
#include "acr_db_persist_i"

////////////////////////////////////////////////////////////////////////////////
// Constants ///////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////

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

////////////////////////////////////////////////////////////////////////////////
// Function Definitions ////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////

void ACR_SetPlayerStatusFlags(object oPC, int nStatus)
{
	ACR_SQLQuery("UPDATE characters SET Status=Status | " + IntToString(nStatus) + " WHERE id=" + IntToString(ACR_GetCharacterID(oPC)));
}

void ACR_UnsetPlayerStatusFlags(object oPC, int nStatus)
{
	ACR_SQLQuery("UPDATE characters SET Status=Status & ~(" + IntToString(nStatus) + ") WHERE id=" + IntToString(ACR_GetCharacterID(oPC)));
}

int ACR_GetPlayerStatusFlags(object oPC)
{
	int nPCID = ACR_GetCharacterID(oPC);
	if (nPCID == 0) {
		// Invalid call for status, log and return 0 instead of querying.  (stopgap measure)
		WriteTimestampedLogEntry("Invalid status query on "+GetName(oPC)+" with PCPlayerName= "+GetPCPlayerName(oPC)+" in area "+GetName(GetArea(oPC))+".");
		return 0;
	}
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