/*	Overland Map constant include file
	NLC: 6/29/08 - Created and forked from ginc_overland.
*/
//STRREFs
const int STRREF_ENC_XP_AWARD = 225358;			//"XP awarded for completing encounter"

//Encounter Constants
const int SE_RATE_MINIMUM			= 3;		//This is the minimum cooldown (in rounds) for Special Encounters.
const int SE_RATE_VARIANCE			= 20;		//This is the variance in the above rate. So after a Special Encounter spawns
												//it will be between SE_RATE_MINIMUM and SE_RATE_MINIMUM + SE_RATE_VARIANCE 
												//before the next one spawns.
												//Note that you can divide these values by 10 to convert them to minutes.
//Terrain Speed Modifier Constants
const float NX2_TERRAIN_SPD_SURVIVAL_MOD = 0.01f;	//%Movement rate change that is granted per rank of survival. For NX2, it is 1% per rank.
const float NX2_TERRAIN_SPD_FAV_ROAD_BONUS = 0.1f;	//Flat bonus granted for having Favored of the Road. In NX2, it is 10% (even on Road terrain.)
const float NX2_TERRAIN_SPD_HOSTILE_MULT = 1.3f;	//This is the movement speed multiplier given to Hostile Encounters. NX2: 130%
const float NX2_TERRAIN_SPD_NEUTRAL_MULT = 0.8f;	//This is the movement speed multiplier given to Neutral Encounters. NX2: 80% 
const float NX2_TERRAIN_SPD_AFRAID_MULT = 0.7f;		//This is the movement speed multiplier given to Fleeing Encounters. NX2: 70% 
																				
const string VAR_CURRENT_DAY		= "00_nCampaignDay";
const string VAR_CURRENT_MONTH		= "00_nCampaignMonth";
const string VAR_CURRENT_YEAR		= "00_nCampaignYear";

const string ENCOUNTER_AREAS_2DA	= "om_encounter_table";
const string AREA_COLUMN			= "AREA_LABEL";
const string SHUTOFF_COLUMN			= "sShutoffGlobalVariableName";
const string MAX_POP_COLUMN			= "nMaxPopulation";
const string ENC_2DA				= "ENC_2DA";
const string ENC_XP_2DA				= "nx2_enc_xpawards";

const string TAG_HOSTILE_SPAWN		= "wp_hostile";
const string TAG_NEUTRAL_SPAWN		= "wp_neutral";
const string TAG_PLAYER_MARKER		= "wp_player_marker";

const string ENC_GROUP_NAME_1		= "EncounterGroup1";
const string ENC_GROUP_NAME_2		= "EncounterGroup2";
const string ENC_GROUP_NAME_3		= "EncounterGroup3";
const string ENC_GROUP_NAME_4		= "EncounterGroup4";
const string ENC_GROUP_NAME_5		= "EncounterGroup5";

const string TABLE_MOVEMENT_RATE	= "om_terrain_rate";
const string TABLE_PLOT_ENC = "om_enc_nx2_plot";

const string VAR_ENC_IGNORE			= "00_bEncIgnoreParty";
const string VAR_ENC_TIMER 			= "nEncounterTimer";
const string VAR_ENC_CHANCE			= "nEncounterChance";
const string VAR_ENC_LIFESPAN		= "nLifespan";
const string VAR_ENC_SPECIAL_COOLDOWN = "nSpecialEncounterCooldown";

const string VAR_SE_TABLE			= "sSpecialEncounterTable";
const string VAR_SE_START_LOC		= "lSEStart";
const string VAR_SE_FLAG			= "bSpecialEncounter";

const string VAR_GOODIES_TOTAL		= "nTotalGoodies";
const string VAR_GOODIES_WEIGHT		= "nWeight";
const string VAR_GOODIES_RR			= "sResRef";
const string VAR_GOODIES_NAME		= "sName";
const string VAR_GOODIES_DISC_SKILL = "nDiscoverySkill";
const string VAR_GOODIES_DISC_DC	 = "nDiscoveryDC";
const string VAR_GOODIES_DISC_STR	 = "sDiscoveryString";
const string VAR_GOODIES_AC_STR	 	= "sActivateString";
const string VAR_GOODIES_ITEMS	 	= "sItemRewards";
const string VAR_GOODIES_GOLD	 	= "nGoldReward";
const string VAR_GOODIES_GOODS		= "sGoodsRewards";
const string VAR_GOODIES_RARERES	= "sRareResRewards";
const string VAR_GOODIES_XP			= "nXPReward";
const string VAR_GOODIES_RADIUS		= "fSeedRadius";
const string VAR_GOODIES_TABLE		= "sGoodieTable";
const string VAR_GOODIES_TERRAIN_ROW = "TERRAIN_TYPES";
const string VAR_GOODIES_RR_ROW 	= "GOODIE_RESREF";

const string VAR_PARTY_LOCATION		= "00_lPlayerMarker";
const string VAR_PC_TERRAIN			= "00_nTerrain";

const string VFX_HOSTILE_ENC_SPAWN 	= "fx_map_spawn_hostile";
const string VFX_HOSTILE_ENC		= "fx_map_hostile";

const string WP_PARTY_FAILSAFE		= "wp_plains01_party_default";
const string WP_ENEMY_FAILSAFE		= "wp_plains01_enemy_default";

const string WP_PREFIX_HILLS		= "wp_hills";
const string WP_PREFIX_ROAD			= "wp_road";
const string WP_PREFIX_FOREST		= "wp_forest";
const string WP_PREFIX_BEACH		= "wp_beach";
const string WP_PREFIX_DESERT		= "wp_desert";
const string WP_PREFIX_MOUNTAINS	= "wp_mountains";
const string WP_PREFIX_SWAMP		= "wp_swamp";
const string WP_PREFIX_PLAINS		= "wp_plains";
const string WP_PREFIX_JUNGLE		= "wp_jungle";

const string WP_PARTY_DESIGNATOR	= "_party_";
const string WP_ENEMY_DESIGNATOR	= "_enemy_";
const string WP_SUFFIX_DEFAULT		= "default";

const string WP_DEST_TAG			= "_wp_from_";
const string PLC_TRAVEL_TAG			= "_plc_to_";
const string IP_TRAVEL_TAG			= "_ip_to_";
const string IP_GOODIE_SEED_TAG			= "nx2_ip_goodie_seed";
// Terrain Constants

const int TERRAIN_JUNGLE			= 1; // Jungle
const int TERRAIN_DESERT			= 2; // Desert
const int TERRAIN_BEACH				= 3; // Beach
const int TERRAIN_ROAD				= 4; // Road
const int TERRAIN_PLAINS			= 5; // Plains
const int TERRAIN_SWAMP				= 6; // Swamp
const int TERRAIN_HILLS				= 7; // Hills
const int TERRAIN_FOREST			= 8; // Forest
const int TERRAIN_MOUNTAINS			= 9; // Mountains

//Goodie Constants
const float GOODIE_DETECT_RADIUS	= 6.0f;

//UI Constants
const string GUI_SCREEN_DEFAULT_PARTY_BAR = "SCREEN_PARTY_BAR";
const string GUI_SCREEN_DEFAULT_HOTBAR = "SCREEN_HOTBAR";
const string GUI_SCREEN_DEFAULT_HOTBAR_2 = "SCREEN_HOTBAR_2";
const string GUI_SCREEN_DEFAULT_HOTBAR_V1 = "SCREEN_HOTBAR_V1";
const string GUI_SCREEN_DEFAULT_HOTBAR_V2 = "SCREEN_HOTBAR_V2";
const string GUI_SCREEN_DEFAULT_MODEBAR = "SCREEN_MODEBAR";
const string GUI_SCREEN_DEFAULT_PLAYERMENU = "SCREEN_PLAYERMENU";
const string GUI_SCREEN_DEFAULT_ACTIONQUEUE = "SCREEN_ACTIONQUEUE";

const string GUI_SCREEN_OL_PARTY_BAR = "SCREEN_OL_PARTY_BAR";
const string XML_OL_PARTY_BAR = "nx2_ol_partybar.xml";
const string GUI_SCREEN_OL_FRAME = "SCREEN_OL_FRAME";
const string XML_OL_FRAME = "nx2_ol_frame.xml";
const string GUI_SCREEN_OL_MENU = "SCREEN_OL_MENU";
const string XML_OL_MENU = "nx2_ol_menu.xml";
const string GUI_SCREEN_OL_PLAYERMENU = "SCREEN_OL_PLAYERMENU";
const string XML_OL_PLAYERMENU = "nx2_ol_playermenu.xml";