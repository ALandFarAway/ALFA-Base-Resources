////////////////////////////////////////////////////////////////////////////////
//
//  System Name : ALFA Core Rules
//     Filename : acr_spawn_i
//      Version : 0.211
//         Date : 12/25/2009
//       Author : Ronan & AcadiusLost
//
//  Local Variable Prefix = ACR_SPA
//
//
//  Dependencies external of nwscript:
//
//  Description
//  This system dynamically spawns creatures and other objects inside of areas
//  such a way that the player does not know the creatures were not statically
//  placed there.
//
//  Revision History
//      0.100 Commited code by Ronan, 6/6/06
//      0.101 (2/25/07, AcadiusLost): test adaption for NWN2.  Removed weather info, 
//              inserted a placeholder float (25.0) for ACR_GetPCVisualRange(),
//              also commented out a section that dynamically named the spawns
//              using the currently-unavailable (in NWN2 1.04) function SetName().
//                code now appears to compile under NWN2.
//      0.102 (2/28/07, AcadiusLost): altered _SpawnAreaHeartbeat to run even with no PCs around
//              for testing purposes.  Added debug report to ACR_ReportSpawnDeath().
//      0.103 (3/3/07, AcadiusLost): addded spawn position randomization options. 
//              new function _RandomizeLocation(), added calls from _SpawnPoint().
//              Also added a pointer back to the parent waypoint to each child in _SpawnObject()
//              Added a body to the ACR_ReportSpawnDeath() function, decrementing _WP_SPAWN_RESPAWN_COUNT.
//      0.104 (3/4/07, AcadiusLost): Changed day of spawn (in & out) to 5 bits each, 1-28, 
//              -replaced 25.0 visual range placeholder with PC_PERCEPTION_RANGE constant
//              -_DespawnPointWithData modified to include amendment of _SPAWN_FLAGS_SPAWNED
//              -setting of _SPAWN_CHILD_COUNT in _SpawnPoint, and decrement in ACR_ReportSpawnDeath()
//      0.105 (3/7/07, AcadiusLost): Added support for random despawn delays to ACR_ReportSpawnDeath()
//      0.106 (3/12/07, AcadiusLost): altered ACR_ReportSpawnDeath() and _GetShouldSpawnBeActive
//              to move respawn delay implementation to the latter function.  Also added BIT_25 to
//              the SPAWN_FLAGS int, "_SPAWN_FLAGS_START_RESPAWN_D" as a way for ReportSpawnDeath to
//              pass the need to start the respawn delay out to GetShouldSpawnBeActive on the next hb.
//              also added LocalInt "_WP_RESPAWN_DELAY_START" to compare to for respawn delays.
//              Private function _RespawnPoll() also altered to actually change the flag for respawn.
//      0.106 (3/13/2007, AcadiusLost): cleaned up debugging reports.  Ready to commit.
//      0.107 (3/17/2007, AcadiusLost): Fixed definition of ACR_SpawnOnAreaEnter
//      0.108 (3/18/2007, AcadiusLost): Added check to _GetShouldSpawnBeActive() for prespawn prediction.
//               also added check to ACR_ReportSpawnDeath(), to handle death of non-spawned creatures/NPCs
//      0.109 (3/24/2007, AcadiusLost): switched out ACR_SPAWN_WITH_PC_IN_AREA for 
//               ACR_SPAWN_ONLY_WHEN_NO_PC_IN_AREA, which was more intuitive.  Also fixed
//               the prespawn prediction algorithm and moved the spawn reserves check up
//               to earlier in the GetShouldSpawnBeActive check.  Also, commented out unused 
//               local variable accesses in _SpawnPoint() and _SpawnObject().  Added IN_SIGHT controls 
//               for randomized location spawn children as well.  Changed the function definition of 
//               _SpawnObject, to allow _SpawnPoint to pass it knowledge on whether the child is being
//               spawned at an alternate location (defaults to FALSE for compatibility)
//      0.200 (3/26/2007, AcadiusLost): Numerous changes, merged in some of Ronan's updated code,
//               Added framework for Group Spawning from files, staggered initialization to avoid TMIs,
//               combined DepawnPointWithData and DespawnPoint, separated SpawnAreaEnter from 
//               PrespawnArea, passed nFlags between functions.  Also accounted for the exception case of a 
//               spawn point which passes it's tests and attempts to spawn, only to fail due to offsite 
//               random-position spawning and IN_SIGHT controls.  Removed time since refresh checks in AreaEnter.
//      0.201 (3/30/2007, AcadiusLost): Enabled / fixed Group Spawning by files- added the pointer to the
//               waypoint in the executescript() call, also added _GetSpawnLocationFrom... function bodies.
//      0.202 (3/30/2007, AcadiusLost): Moved all the info reports on the system to ACR_PrintDebugMessage() calls
//      0.203 (6/20/2007, AcadiusLost): fixed _BuffSelf() for NWN2v1.06, fixed ownership of ExecuteScript() call
//               for SPAWN_IN_SCRIPT in _SpawnObject()
//      0.204 (9/2/2007, AcadiusLost): Changed default spawn debug reporting to the logs instead of DM channel.
//      0.205 (10/4/2007, AcadiusLost): changed Protection From Chaos in BuffSelf() to compile under patch 1.10
//      0.206 (10/7/2007, AcadiusLost): commented out Protection from Chaos, so code will compile under MotB as well as 1.10
//      0.207 (10/9/2007, AcadiusLost): Fixed ACR_SetIsSpawnPointEnabled() to refer to _SPAWN_FLAGS.
//      0.208 (10/22/2006, AcadiusLost): Fixed ACR_SetIsSpawnPointEnabled() to update flags before calling _RefreshSpawnPoint()
//               also #included acr_death_i and special handling for persistent storage object being despawned. 
//     2008/04/19 AcadiusLost - changed spawn errors to DEBUG_INFO, added failsafe to DespawnArea calls
//     2008/08/30 AcadiusLost - changed RandomFloat for ACR_RandomFloat()
//	   2009/01/31 AcadiusLost - Enabled/Adapted SetName() for NWN2 functions.
// 	   2009/02/09 AcadiusLost - Switched to use GetFirstName() instead of GetName() to avoid lastname doubling. Also removed information-level debug logging
//     2009/12/25 AcadiusLost - SPAWN_IS_ACTIVE fix, Chance to spawn % fix
//     2011/04/19 Zelknolf - _WP_RESPAWN_DELAY_START has gotten an initialized value.
//		2011/05/29 Ronan - Removed acf_spawn_i references in place of spawn settings set OnModuleLoad.
//		2011/06/09 Ronan - Added support for spawning lights, trigger, AoEs and encounters.
////////////////////////////////////////////////////////////////////////////////

#ifndef ACR_SPAWN_I
#define ACR_SPAWN_I

// This include must be done prematurely due to dependent constants.
#include "acr_tools_i"

////////////////////////////////////////////////////////////////////////////////
// Constants ///////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////

// Name of the spawn system, used for debugging purposes.
const string _SPAWN_SYSTEM_NAME = "acr_spawn_i";

// Prefixes on the scripts used specifically for the spawn system.
const string _SPAWN_GROUP_SCRIPT_PREFIX = "as_group_";

// The tag of spawn waypoints.
const string _SPAWN_WAYPOINT_TAG = "ACR_SPAWN_WP";

// Length of the array of spawn points stored on an area.
const string _SPAWN_WAYPOINT_ARRAY_LENGTH = "ACR_SPA_WAL";

// The array name of spawn points stored on an area.
const string _SPAWN_WAYPOINT_ARRAY = "ACR_SPA_WA_";

// The local time (in seconds) integer the area's spawns were last refreshed.
const string _SPAWN_LAST_REFRESHED = "ACR_SPA_LR";

// Bitwise flags indicating the state of the spawn system on an area.
const string _SPAWN_AREA_FLAGS = "ACR_SPA_AF";

// If set, the area is currently active and being serviced by the spawn area
// heartbeat.
const int _SPAWN_AREA_FLAG_ACTIVE = BIT_1;

// The name of the array of spawned children.
const string _SPAWNED_OBJECT_ARRAY = "ACR_SPA_OA_";

// The length of the array of spawned children.
const string _SPAWNED_OBJECT_ARRAY_LENGTH = "ACR_SPA_OAL";

// The array of resrefs of creatures which will always be spawned.
// String value.
const string _WP_SPAWN_RESREF_ARRAY = "ACR_SPAWN_RESNAME_";

// The array of resrefs of creatures which will be spawned randomly.
// String value.
const string _WP_SPAWN_RESREF_RANDOM_ARRAY = "ACR_SPAWN_RANDOM_RESNAME_";

// The type of object spawned.
// Creatures: 0
// Placables: 1
// Items: 2
// Store: 3
// Waypoint: 4
// Trigger: 5
// Encounter: 6
// Light: 7
const string _WP_SPAWN_TYPE = "ACR_SPAWN_TYPE";

// The minumum and maximum of creatures spawned. If they are not equal, a random number will be chosen.
const string _WP_SPAWN_NUMBER_MIN = "ACR_SPAWN_RESNAMES_MIN";
const string _WP_SPAWN_NUMBER_MAX = "ACR_SPAWN_RESNAMES_MAX";
const int _SPAWN_NUMS_MAX = 31; // 5-bit number's range is 0-31
const int _SPAWN_NUMS_NUM_RESREFS_START = 0;
const int _SPAWN_NUMS_NUM_RESREFS_END = 4;
const int _SPAWN_NUMS_RESREFS_MIN_START = 5;
const int _SPAWN_NUMS_RESREFS_MIN_END = 9;
const int _SPAWN_NUMS_RESREFS_MAX_START = 10;
const int _SPAWN_NUMS_RESREFS_MAX_END = 14;

// Tracks how many spawned children a given waypoint has left active
const string _SPAWN_CHILD_COUNT = "ACR_SPAWN_CHILD_COUNT";

// The array of spawn group scripts always spawned at this point.
// String value.
const string _WP_SPAWN_GROUP_ARRAY = "ACR_SPAWN_GROUP_";

// The array of spawn groups which will be spawned randomly.
// String value.
const string _WP_SPAWN_GROUP_RANDOM_ARRAY = "ACR_SPAWN_RANDOM_GROUP_";

// The minumum and maximum of groups spawned. If they are not equal, a random number will be chosen.
const string _WP_SPAWN_GROUP_NUMBER_MIN = "ACR_SPAWN_GROUP_MIN";
const string _WP_SPAWN_GROUP_NUMBER_MAX = "ACR_SPAWN_GROUP_MAX";
const int _SPAWN_NUMS_GROUP_NUM_START = 15;
const int _SPAWN_NUMS_GROUP_NUM_END = 19;
const int _SPAWN_NUMS_GROUP_MIN_START = 20;
const int _SPAWN_NUMS_GROUP_MIN_END = 24;
const int _SPAWN_NUMS_GROUP_MAX_START = 25;
const int _SPAWN_NUMS_GROUP_MAX_END = 30;

// The location where creatures spawned from this spawn point appear from on spawn and disapear to when they despawn.
const string _WP_SPAWN_WAYPOINT = "ACR_SPAWN_IN_WAYPOINT";
const string _WP_DESPAWN_WAYPOINT = "ACR_SPAWN_OUT_WAYPOINT";

// The random range from the waypoint in which the creature or creatures may be centered on.
const string _WP_SPAWN_RANDOM_RANGE = "ACR_SPAWN_RANDOM_RANGE";

// The random radius around the centerpoint for spawn children to appear (like a "scatter")
const string _WP_SPAWN_RANDOM_RADIUS = "ACR_SPAWN_RANDOM_RADIUS";

// The prefix added to a creatures name when it is spawned.
// String value.
const string _WP_SPAWN_NAME_PREFIX = "ACR_SPAWN_NAME_PREFIX";

// The suffix added to a creature's name when it is spawned.
// String value.
const string _WP_SPAWN_NAME_SUFFIX = "ACR_SPAWN_NAME_SUFFIX";

// The string which replaces the creature's original name when its spawned.
const string _WP_SPAWN_NAME = "ACR_SPAWN_NAME";

// The name of the faction this creature should belong to when it is spawned.
// String value.
const string _WP_SPAWN_FACTION = "ACR_SPAWN_FACTION";

// These scripts run on each creature spawned from this waypoint.
// OBJECT_SELF points to the spawned creature when this script is executed.
// String value, with the index starting at 1.
const string _WP_SPAWN_IN_SCRIPT_ARRAY = "ACR_SPAWN_IN_SCRIPT_";

// These scripts run on the waypoint when it spawns its children.
// OBJECT_SELF points to the waypoint when this script is executed.
// String value, with the index starting at 1.
const string _WP_SPAWN_SCRIPT_ARRAY = "ACR_SPAWN_SCRIPT_";

// The script run before this waypoint spawns. OBJECT_SELF points to the
// waypoint when this script is executed. If the script calls the function
// ACR_DisallowSpawn(), the waypoint will not be spawned. If it calls
// ACR_ForceSpawn(), the waypoint will always be spawned, regardless of other
// settings. If it doesn't call anything, the spawn point's behavior will be the
// default.
const string _WP_IS_ACTIVE_SCRIPT = "ACR_SPAWN_IS_ACTIVE_SCRIPT";

// The number of times this spawn will respawn after all its children are dead.
// If -1, the spawn is unlimited.
// Integer value.
const string _WP_SPAWN_RESPAWN_COUNT = "ACR_SPAWN_RESPAWN_COUNT";

// name of an object pointer stored on a child, back to the parental spawn waypoint.
// important to reference the waypoint to adjust respawn "inventory" on spawn death.
const string _SPAWN_PARENT_WP = "ACR_SPAWN_PARENT_WP";

// The number of seconds a spawn will remain spawned.
// The used value is randomly chosen between the min and the max.
// 0 indicates no time limit.
const string _WP_MIN_SPAWN_DURATION = "ACR_MIN_SPAWN_DURATION";
const string _WP_MAX_SPAWN_DURATION = "ACR_MAX_SPAWN_DURATION";

// The number of game hours that a killed spawn will wait to respawn after it has been destroyed.
// Float values, equal values will remove randomness, setting to 0 will give respawn on the next heartbeat.
const string _WP_RESPAWN_DELAY_MIN = "ACR_RESPAWN_DELAY_MIN";
const string _WP_RESPAWN_DELAY_MAX = "ACR_RESPAWN_DELAY_MAX";

// used to store the time, in number of seconds since module load, at which a spawn point was 
//  killed off, used for reference in determining when a respawn timer should expire.
//    integer value.
const string _WP_RESPAWN_DELAY_START = "ACR_RESPAWN_DELAY_START";

// The chance this spawn has to spawn, per game day.
// Float value.
const string _WP_SPAWN_CHANCE = "ACR_SPAWN_CHANCE";

// Indicates the VFX which should be played on each creature when it spawns.
// Integer value.
const string _WP_SPAWN_IN_VFX = "ACR_SPAWN_IN_VFX";

// Indicates the VFX which should be played on the spawn location itself when
// the spawn activates.
const string _WP_SPAWN_VFX = "ACR_SPAWN_VFX";

// Indicates the SFX which should be played on each creature when it spawns.
// String value.
const string _WP_SPAWN_IN_SFX = "ACR_SPAWN_IN_SFX";

// Indicates the SFX which should be played on the spawn location itself when
// the spawn activates.
const string _WP_SPAWN_SFX = "ACR_SPAWN_SFX";

// Indicates the animation the creature should execute when it spawns. Note that
// this is different from SPAWN_WITH_ANIMATION, as it allows any animation to be
// played, instead of just that creature's default spawn-in animation.
// String value.
const string _WP_SPAWN_ANIMATION = "ACR_SPAWN_ANIMATION";

// The hour this spawn activates at.
// Integer value between 0 and 23. 5 bits needed.
const string _WP_SPAWN_HOUR = "ACR_SPAWN_IN_HOUR";
const int _SPAWN_TIMES_HOUR = 31;        // <--------------what is this for?
const int _SPAWN_TIMES_HOUR_START = 0;
const int _SPAWN_TIMES_HOUR_END = 4;

// The hour this spawn's children despawn.
// Integer value between 0 and 23. 5 bits needed.
const string _WP_DESPAWN_HOUR = "ACR_SPAWN_OUT_HOUR";
//const int _DESPAWN_VALUE_HOUR = BIT_6 | BIT_7 | BIT_8 | BIT_9 | BIT_10;
const int _DESPAWN_TIMES_HOUR_START = 5;
const int _DESPAWN_TIMES_HOUR_END = 9;

// The day of the tenday the spawn should start spawning.
// Integer value from 1 to 10. 4 bits needed.
//  changing this to 5 bits, need 1 to 28.
const string _WP_SPAWN_DAY = "ACR_SPAWN_IN_DAY";
//const int _SPAWN_VALUE_DAY = BIT_11 | BIT_12 | BIT_13 | BIT_14 | BIT_15;
const int _SPAWN_TIMES_DAY_START = 10;
const int _SPAWN_TIMES_DAY_END = 14;

// The day of the tenday the spawn should despawn.
// Integer value from 1 to 10. 4 bits needed.
//  changing this to 5 bits, need 1 to 28.
const string _WP_DESPAWN_DAY = "ACR_SPAWN_OUT_DAY";
//const int _DESPAWN_VALUE_DAY = BIT_16 | BIT_17 | BIT_18 | BIT_19 | BIT_20;
const int _DESPAWN_TIMES_DAY = 245760;
const int _DESPAWN_TIMES_DAY_START = 15;
const int _DESPAWN_TIMES_DAY_END = 19;

// The month of the year the spawn should start spawning.
// Integer value from 1 to 12. 4 bits needed.
const string _WP_SPAWN_MONTH = "ACR_SPAWN_IN_MONTH";
//const int _SPAWN_VALUE_MONTH = BIT_21 | BIT_22 | BIT_23 | BIT_24;
const int _SPAWN_TIMES_MONTH_START = 20;
const int _SPAWN_TIMES_MONTH_END = 23;

// The month of the year the spawn should despawn.
// Integer value from 1 to 12. 4 bits needed.
const string _WP_DESPAWN_MONTH = "ACR_SPAWN_OUT_MONTH";
//const int _DESPAWN_VALUE_MONTH = BIT_25 | BIT_26 | BIT_27 | BIT_28;
const int _DESPAWN_TIMES_MONTH_START = 24;
const int _DESPAWN_TIMES_MONTH_END = 27;

// Each boolean value indicates whether or not the spawn will spawn in various
// sorts of weather.
const int _SPAWN_WFLAGS_CLEAR = BIT_0;
const int _SPAWN_WFLAGS_RAIN_WEAK = BIT_1;
const int _SPAWN_WFLAGS_RAIN_LIGHT = BIT_2;
const int _SPAWN_WFLAGS_RAIN_MEDIUM = BIT_3;
const int _SPAWN_WFLAGS_RAIN_HEAVY = BIT_4;
const int _SPAWN_WFLAGS_RAIN_STORMY = BIT_5;
const int _SPAWN_WFLAGS_SNOW_WEAK = BIT_6;
const int _SPAWN_WFLAGS_SNOW_LIGHT = BIT_7;
const int _SPAWN_WFLAGS_SNOW_MEDIUM = BIT_8;
const int _SPAWN_WFLAGS_SNOW_HEAVY = BIT_9;
const int _SPAWN_WFLAGS_SNOW_STORMY = BIT_10;
const int _SPAWN_WFLAGS_LIGHTNING_WEAK = BIT_11;
const int _SPAWN_WFLAGS_LIGHTNING_LIGHT = BIT_12;
const int _SPAWN_WFLAGS_LIGHTNING_MEDIUM = BIT_13;
const int _SPAWN_WFLAGS_LIGHTNING_HEAVY = BIT_14;
const int _SPAWN_WFLAGS_LIGHTNING_STORMY = BIT_15;
const string _WP_SPAWN_WFLAGS_CLEAR = "ACR_SPAWN_WEATHER_CLEAR";
const string _WP_SPAWN_WFLAGS_RAIN_WEAK = "ACR_SPAWN_WEATHER_RAIN_WEAK";
const string _WP_SPAWN_WFLAGS_RAIN_LIGHT = "ACR_SPAWN_WEATHER_RAIN_LIGHT";
const string _WP_SPAWN_WFLAGS_RAIN_MEDIUM = "ACR_SPAWN_WEATHER_RAIN_MEDIUM";
const string _WP_SPAWN_WFLAGS_RAIN_HEAVY = "ACR_SPAWN_WEATHER_RAIN_HEAVY";
const string _WP_SPAWN_WFLAGS_RAIN_STORMY = "ACR_SPAWN_WEATHER_RAIN_STORMY";
const string _WP_SPAWN_WFLAGS_SNOW_WEAK = "ACR_SPAWN_WEATHER_SNOWN_WEAK";
const string _WP_SPAWN_WFLAGS_SNOW_LIGHT = "ACR_SPAWN_WEATHER_SNOW_LIGHT";
const string _WP_SPAWN_WFLAGS_SNOW_MEDIUM = "ACR_SPAWN_WEATHER_SNOW_MEDIUM";
const string _WP_SPAWN_WFLAGS_SNOW_HEAVY = "ACR_SPAWN_WEATHER_SNOW_HEAVY";
const string _WP_SPAWN_WFLAGS_SNOW_STORMY = "ACR_SPAWN_WEATHER_SNOW_STORMY";
const string _WP_SPAWN_WFLAGS_LIGHTNING_WEAK = "ACR_SPAWN_WEATHER_LIGHTNING_WEAK";
const string _WP_SPAWN_WFLAGS_LIGHTNING_LIGHT = "ACR_SPAWN_WEATHER_LIGHTNING_LIGHT";
const string _WP_SPAWN_WFLAGS_LIGHTNING_MEDIUM = "ACR_SPAWN_WEATHER_LIGHTNING_MEDIUM";
const string _WP_SPAWN_WFLAGS_LIGHTNING_HEAVY = "ACR_SPAWN_WEATHER_LIGHTNING_HEAVY";
const string _WP_SPAWN_WFLAGS_LIGHTNING_STORMY = "ACR_SPAWN_WEATHER_LIGHTNING_STORMY";

// Like the above, but only deals with damage due to extreme conditions.
const int _SPAWN_WFLAGS_IN_DAMAGING_COLD = BIT_16;
const int _SPAWN_WFLAGS_IN_DAMAGING_HEAT = BIT_17;
const string _WP_SPAWN_IN_DAMAGING_COLD = "ACR_SPAWN_IN_COLD_DAMAGING_WEATHER";
const string _WP_SPAWN_IN_DAMAGING_HEAT = "ACR_SPAWN_IN_HEAT_DAMAGING_WEATHER";

// The local int which stores the weather booleans.
const string _SPAWN_WEATHER_FLAGS = "ACR_SPA_WF";

// Boolean value of 0 (no) or 1 (yes).
const string _WP_RESPAWN_IN_PC_SIGHT = "ACR_SPAWN_IN_PC_SIGHT";
const int _SPAWN_FLAGS_IN_PC_SIGHT = BIT_0;

// Boolean value of 0 (no) or 1 (yes).
const string _WP_RESPAWN_WITH_PC_IN_AREA = "ACR_SPAWN_ONLY_WHEN_NO_PC_IN_AREA";
const int _SPAWN_FLAGS_WITH_PC_IN_AREA = BIT_1;

// Boolean value of 0 (no) or 1 (yes).
// Note that this is different from SPAWN_ANIMATION, as it toggles whether or
// to play this creature's default spawn-in animation (if it has one), and
// nothing else
const string _WP_SPAWN_WITH_ANIMATION = "ACR_SPAWN_WITH_ANIMATION";
const int _SPAWN_FLAGS_WITH_ANIMATION = BIT_2;

// Indicates whether or not the spawn is disabled.
// Boolean value of 0 (no) or 1 (yes).
const string _WP_SPAWN_DISABLED = "ACR_SPAWN_IS_DISABLED";
const int _SPAWN_FLAGS_DISABLED = BIT_3;

// Indicates whether or not spawn facing is random (1), or fixed (0).
const string _WP_SPAWN_RANDOM_FACING = "ACR_SPAWN_RANDOM_FACING";
const int _SPAWN_FLAGS_RANDOM_FACING = BIT_4;

// Indicates that a spawn should be given a random name, based on its race.
const string _WP_SPAWN_RANDOM_NAME = "ACR_SPAWN_RANDOM_NAME";
const int _SPAWN_FLAGS_RANDOM_NAME = BIT_5;

// Indicates that the spawn should be placed into stealth mode when it spawns.
const string _WP_SPAWN_IN_STEALTH = "ACR_SPAWN_IN_STEALTH";
const int _SPAWN_IN_STEALTH = BIT_6;

// Indicates that the spawn should be placed into detect mode when it spawns.
const string _WP_SPAWN_IN_DETECT = "ACR_SPAWN_IN_DETECT";
const int _SPAWN_IN_DETECT = BIT_7;

// Indicates that the spawn should spawn with all spells of a long duration
// (hour per level or greater) cast.
const string _WP_SPAWN_BUFFED = "ACR_SPAWN_BUFFED";
const int _SPAWN_BUFFED = BIT_8;

// 32-bit integer which contains many options and values.
const string _SPAWN_TIMES = "ACR_SPA_T";
const string _SPAWN_FLAGS = "ACR_SPA_F";
const string _SPAWN_NUMS = "ACR_SPA_N";

// PRIVATE DATA:
// The following data is only used interally by the spawn system, and are not
// set by users.

// If the spawn point is "recharging", this flag will be true.
const int _SPAWN_FLAGS_WAIT_FOR_RESPAWN = BIT_31;

// If the spawn has been determined not to spawn today, we don't spawn today.
const int _SPAWN_FLAGS_NOT_TODAY = BIT_30;

// If the spawn is activated, we say that it's children are "in" the area and
// active. This does not mean they are physically there, but the spawn
// system will treat them as having appeared prior to a PC's arival in the
// area.
const int _SPAWN_FLAGS_ACTIVATED = BIT_29;

// If the spawn is physically spawned, this bit will be set. When the spawn's
// children are dead or despawned, it will be cleared.
const int _SPAWN_FLAGS_SPAWNED = BIT_28;

// If the spawn point is prevented from spawning by the custom pre-spawn script,
// this bit will be set. It will be cleared afterwards - it only serves to pass
// data from the pre-spawn script to _GetShouldSpawnBeActive().
const int _SPAWN_DISALLOWED = BIT_27;

// If the spawn point is forced to spawn by the custom pre-spawn script, this
// bit will be set. It will always be cleared afterwards - it only serves to
// pass data from the pre-spawn script to _GetShouldSpawnBeActive();
const int _SPAWN_FORCED = BIT_26;

// If the spawn point has just been killed off, this bit will be switched to TRUE
// until a respawn timer can be started, in the next spawn heartbeat.  The timer will
// DelayCommand a switch of the _SPAWN_FLAGS_WAIT_FOR_RESPAWN bit.
const int _SPAWN_FLAGS_START_RESPAWN_D = BIT_25;

// The last game-day the spawn was checked for its % chance to spawn.
const string _WP_LAST_DAY_CHECKED = "ACR_SPA_LDC";

// The last location this spawn point decided to spawn at.
const string _SPAWN_LAST_LOCATION = "ACR_SPA_LL";

// Global spawn system settings
const string _SPAWN_DESPAWN_DELAY_GF = "ACR_SPA_DD";
const string _SPAWN_REFRESH_DELAY_GF = "ACR_SPA_RD";
const string _SPAWN_PRESPAWN_SEAMLESS_GB = "ACR_SPA_PS";
const string _SPAWN_PRESPAWN_PREDICTION_GB = "ACR_SPA_PP";


const string ACR_LOG_SPAWNS	= "ACR_LOG_SPAWNS";

// Controls the coloring of NPC names on spawn-in.
const string ACR_COLOR_NAME = "ACR_COLOR_NAME";


////////////////////////////////////////////////////////////////////////////////
// Structures //////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////

////////////////////////////////////////////////////////////////////////////////
// Global Variables ////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////

// These variables hold the data of the spawn point which is currently being
// processed.
int _nTimes, _nNums, _nWeather, _nFlags;
location _lSpawnLoc;

////////////////////////////////////////////////////////////////////////////////
// Function Prototypes /////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////

//! *** PUBLIC FUNCTIONS ***

//! Initializes the spawn system. Usually called from OnModuleLoad, this function
//! must be run before the spawn system will function.
void ACR_InitializeSpawns(float fDespawnDelay, float fRefreshDelay, int bPrespawnSeamless, int bPrespawnPrediction);

// This is a timer which starts when the last PC exits an area. When the timer
// runs out, that area is despawned.
float GetDespawnDelay();

// The number of seconds in between spawn refreshes on PC-occupied areas.
float GetRefreshDelay();

// Determines whether the spawn system should pre-spawn an area when a PC steps into 
//  a seamless AT- this may affect performance, as the PC won't neccessarily travel to
//  the area (if they back off the AT) but it should help fight spawn lag.
int GetPrespawnsSeamless();

//	Another performance tweak: this controls whether the spawn system should take into
//  account the predicted Seamless AT arrival point of a PC in a neighboring area- it 
//  is only useful if seamless prespawning is enabled (above), in which it protects
//  against a potential for a spawn and a PC to be dropped next to each other without
//  warning.  It may be disabled at a module team's discression for performance reasons
//  if necessary.  Definitely disable this if _SPAWN_PRESPAWN_SEAMLESS = FALSE.
//  note also, this check will be bypassed if a builder has set the spawn point to spawn
//  even within sight of a PC. (ACR_SPAWN_IN_PC_SIGHT = 1)
int GetPrespawnPrediction();

//! Enables or disables (1 or 0) spawn point oWP.
//! If bChangeState is true, the spawn point will try to spawn if it was
//! inactive, and despawn if it was active.
void ACR_SetIsSpawnPointEnabled(object oWP, int bEnabled, int bChangeCurrentState = 0);

//! Reports the death of oObject to the spawn system. Typically goes in the
//! OnDeath event of creatures and placables.
void ACR_ReportSpawnDeath(object oObject);

//! Spawns an object of type nObjectType from spawn point oWP.
//! object SpawnObjectFromPoint(object oWP, string sResRef, int nObjectType);

//! Destroys oWP, removing it as a spawn point.
//! If bDespawnChildren is 1, its children are despawned as well.
//! This function does not actually destroy a spawn point, and really should not be used.
//! Use ACR_SetIsSpawnPointEnabled() instead.
void ACR_DestroySpawnPoint(object oWP, int bDespawnChildren = 0);

//! The script the spawn system executes when a PC enters an area.
void ACR_SpawnOnAreaEnter(object oCreature);

//! This function is called by AT scripts, allows an area to be activated and spawns
//! populated before the PC actually enters.
void ACR_PreSpawnArea(object oArea);

//! The script the spawn system executes when any creatures leaves an area.
void ACR_SpawnOnAreaExit(object oCreature);

//! This function is called when an area instance is created.  It is only 
//  called once for an area instance, even if the instance is reused.
//!  - oAreaInstance: Supplies the newly created area instance.
//!  - Returns: Nothing.
void ACR_SpawnOnAreaInstanceCreate(object oAreaInstance);

//! This function is called when an area instance is cleaned up.  It is caled
//  each time the area instance is about to be deactivated.
//!  - oAreaInstance: Supplies the area instance that is being cleaned up.
//!  - Returns: Nothing.
void ACR_SpawnOnAreaInstanceCleanup(object oAreaInstance);

//! Returns the number of spawn points in oArea.
int ACR_GetNumberOfSpawnPointsInArea(object oArea);

//! Returns the spawn point number nNum in oArea.
//! Returns OBJECT_INVALID if that spawn point does not exist.
object ACR_GetSpawnPoint(object oArea, int nNum);

//! Keeps the spawn point oWP from spawning the next time (and only the next
//! time) the spawn system looks at it. This function should only really be used
//! in the custom pre-spawn script defined by the local string variable
//! ACR_SPAWN_IS_ACTIVE_SCRIPT.
//! If both this function and ACR_ForceSpawn() are called, this function
//! is overridden and the spawn is allowed.
void ACR_DisallowSpawn(object oWP = OBJECT_SELF);

//! Forces the spawn point oWP to spawn, even if the spawn point's logic (such
//! as spawn hour, chance, or other restrictions) would prevent it.
//! This should only be called from a spawn point's pre-spawn script, defined by
//! the local string variable ACR_SPAWN_IS_ACTIVE_SCRIPT.
//! If both this function and ACR_DisallowSpawn() are called, this function
//! takes precedence and the spawn is allowed.
void ACR_ForceSpawn(object oWP = OBJECT_SELF);

//! Physically spawns an object with blueprint resref oResRef and object type
//! nObjectType (see OBJECT_TYPE_* constants) at the spawn point oWP.
//! This function should generally only be called from custom spawn scripts.
object ACR_SpawnObject(string sResRef, int nObjectType, object oWP = OBJECT_SELF);

//! Physically spawns an object with blueprint resref oResRef and object type
//! nObjectType (see OBJECT_TYPE_* constants) at location lLoc, from the spawn
//! point oWP.
//! This function should generally only be called from custom spawn scripts.
object ACR_SpawnObjectAtLocation(string sResRef, int nObjectType, location lLoc, object oWP = OBJECT_SELF);

//! Returns a location fDist away from the spawn point, at fAngle, with the
//! point's facing. This location is relative to the facing of the spawn point
//! itself. In other words, rotating the spawn point in the toolset will rotate
//! the point returned from this function as if the point was an axis.
location ACR_GetSpawnLocationFromDirection(float fAngle, float fDist, object oWP = OBJECT_SELF);

//! Returns a location fDist away from the spawn point, at fAngle, with a new
//! facing fFacing. This location is relative to the facing of the spawn point
//! itself. In other words, rotating the spawn point in the toolset will rotate
//! the point returned from this function as if the point was an axis.
location ACR_GetSpawnLocationFromDirectionAndFacing(float fAngle, float fDist, float fFacing, object oWP = OBJECT_SELF);

//! Returns a location fXDist away from the spawn point on the X (east-west)
//! axis, and fYDist away on the Y (south-north) axis. North and west are
//! positive values, while south and east are negative. This location is
//! relative to the facing of the spawn point itself. In other words, rotating
//! the spawn point in the toolset will rotate the point returned from this
//! function as if the point was an axis.
//! Uses the spawn point's existing facing.
location ACR_GetSpawnLocationFromVector(float fXDist, float fYDist, object oWP = OBJECT_SELF);

//! Returns a location fXDist away from the spawn point on the X (east-west)
//! axis, and fYDist away on the Y (south-north) axis. North and west are
//! positive values, while south and east are negative. This location is
//! relative to the facing of the spawn point itself. In other words, rotating
//! the spawn point in the toolset will rotate the point returned from this
//! function as if the point was an axis.
//! Uses the new facing angle fFacing.
location ACR_GetSpawnLocationFromVectorAndFacing(float fXDist, float fYDist, float fFacing, object oWP = OBJECT_SELF);

//! Runs a spawn group script named sGroupName on the spawn waypoint oWP.
void ACR_SpawnGroup(string sGroupName, object oWP = OBJECT_SELF);

//! Forces spawn point oWP to become active, and spawn. If the point is already
//! active, nothing happens.
void ACR_SpawnPoint(object oWP = OBJECT_SELF);

//! Returns the location this spawn point is spawning at.
//! Note: Always use this function instead of GetLocation(oWP), since spawn
//! points can be randomized to spawn in different places!
location ACR_GetSpawnLocation(object oWP = OBJECT_SELF);

//! Returns a string describing the spawn point oWP. Gives its name, area, area
//! tag and resref, and location in that area.
string ACR_SpawnPointToString(object oWP);

//! If called from a custom spawn script, this function returns one of three
//! values:
//! ACR_SPAWN_ACTIVATED: The spawn has just been activated. From the player's
//!     point of view, its children have just arrived in the area.
//! ACR_SPAWN_SPAWNED: The spawn was already active, and is being respawned.
//!     From the player's point of view, the spawns were already in the area
//!     before he arrived.
//! On an error, it returns 0.
int ACR_GetSpawnEvent(object oWP = OBJECT_SELF);

//! Return if presently this WP is spawned
int ACR_GetIsSpawned(object oWP);

//! Explicitly adds a non-spawnpoint generated object to the spawnpoint group
//! Therefore, is cleaned up when the spawn point is despawned.
//! Returns TRUE on success FALSE on failure
int ACR_AddObjectToSpawnPoint(object oWP, object oObject);

//! *** PRIVATE FUNCTIONS ***

//! Returns 1 of the spawn point oWP should be considered currently spawned
//! in-game (though it may not be). Returns 0 if not.
//! nFlags is passed because it contains information which is likely needed
//! outside this function call, and we want to cut down on GetLocal* calls.
//   -Ronan passes nSeconds to this as well.
int _GetShouldSpawnBeActive(object oWP);

//! Spawns spawn point oWP, creating its children instantly at their
//! destinations.
void _SpawnPoint(object oWP, int nFlags);

//   Ronan distinguished SpawnPoint() from RespawnPoint()
//! Called on an active, but despawned, spawn point, this function returns that
//! point to its active state before it was despawned.
// void _RespawnPoint(object oWP, int nFlags);

//! Despawns spawn point oWP, immediately destroying its children.
void _DespawnPoint(object oWP, int nFlags);

//! Processes oWP as a spawn point, adding it to the list of spawn points in the
//! area.
void _AddSpawnPointFromWaypoint(object oWP);

//! This function looks at all the spawn points in an area to check if their
//! state is correct. It does nothing unless it hasn't been executed for
//! _SPAWN_REFRESH_DELAY seconds.
void _RefreshArea(object oArea);

//! This function despawns all the spawn points in oArea.
void _DespawnArea(object oArea);

//! Spawns oWP if it should be spawned, and despawns it if it shouldn't be.
//! Creatures spawned by this function are done so instantly, as it is assumed
//! this function will be called to bring creatures into being who were there
//! before the arrival of the PCs.
//   -Ronan passes nSeconds to this one as well
void _RefreshSpawnPoint(object oWP);

//! Spawns in a previously unspawned area.
void _SpawnArea(object oArea);

//! Starts the spawn heartbeat on an area.
//! The delay is set by the constant _SPAWN_REFRESH_DELAY.
void _StartSpawnAreaHeartbeat(object oArea, int nAreaFlags);

//! The global spawn system heartbeat.
//! The delay is set by the constant _SPAWN_REFRESH_DELAY.
void _SpawnAreaHeartbeat(object oArea);

//! Polls oArea to see if it has been inactive long enough for it to be
//! despawned.
void _DespawnAreaPoll(object oArea);

//! Polls oWP to see if it has been inactive long enough for it to be respawned.
void _RespawnPoll(object oWP);

//! Gets the number of seconds since oArea's spawns have been refreshed.
float _GetSecondsSinceSpawnRefresh(object oArea);

//! Physically spawns a creature of sResRef with an object type of nObjectType
//! at oWP. nFlags is passed to prevent redundant GetLocalInt() calls.
object _SpawnObject(string sResRef, int nObjectType, object oWP, location lLoc, int nFlags, int nAlternate=FALSE);

//! Semi-intelligently buffs oCreature with all of its hour/level (or longer)
//! duration buffs.
void ActivateLongTermBuffs(object oCreature);

//! Randomizes a location within a given range, used for both RANDOM_RANGE and RANDOM_RADIUS
//!  called from the _SpawnPoint() function
location _RandomizeLocation(location lCenter, float fBound);

//! Works with a counter in _AddSpawnPointFromWaypoint() to make sure all the
//! spawn points in the module were initialized correctly.
void _SpawnPointInitializationCheck(int nNum);

//!  Calculates a new location from a passed one, as modified by the passed distance and angle parameters.
//!   fAngle sets the direction to move for fDist distance. fPointFacing sets the orientation of the returned loc.
location _GetNewLocationFromDirectionAndFacing(location lStart, float fDist, float fAngle, float fPointFacing);

//!  Calculates a new location from a passed location, X and Y adjustments to modify it by, 
//!   and a defined orientation, fOrientAngle.  
location _GetNewLocationFromVectorAndFacing(location lOrigin, float fXOffset, float fYOffset, float fOrientAngle);

//! Handles internal accounting for adding instanced objects to spawn WP
void _AddObjectToSpawnPoint(object oWP, object oObject);

//! Handles internal accounting for adding instances of traps to spawn WP
void _AddTrapToSpawnPoint(object oWP, string sTag);

////////////////////////////////////////////////////////////////////////////////
// Includes ////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////

#include "acr_time_i"
#include "acr_debug_i"
#include "acr_array_i"
#include "acr_death_i"
#include "acr_traps_i"
// #include "acr_weather_i"
// #include "acr_game_const_i"

////////////////////////////////////////////////////////////////////////////////
// Function Definitions ////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////

////////////////////////////////////////////////////////////////////////////////
// *** BEGIN PUBLIC FUNCTIONS ***
////////////////////////////////////////////////////////////////////////////////

void ACR_InitializeSpawns(float fDespawnDelay, float fRefreshDelay, int bPrespawnSeamless, int bPrespawnPrediction) {
	SetGlobalFloat(_SPAWN_DESPAWN_DELAY_GF, fDespawnDelay);
	SetGlobalFloat(_SPAWN_REFRESH_DELAY_GF, fRefreshDelay);
	SetGlobalInt(_SPAWN_PRESPAWN_SEAMLESS_GB, bPrespawnSeamless);
	SetGlobalInt(_SPAWN_PRESPAWN_PREDICTION_GB, bPrespawnPrediction);

	int i;
    object oSpawnWP;
	// Create the debugging system.
    ACR_CreateDebugSystem(_SPAWN_SYSTEM_NAME, DEBUG_TARGET_NONE, DEBUG_TARGET_LOG | DEBUG_TARGET_DMS, DEBUG_TARGET_LOG | DEBUG_TARGET_DMS);	
	// Initialize all the spawn points in the module. To prevent possible TMIs,
    // we DelayCommand() each call.
    float fDelay = 0.0;
    ACR_PrintDebugMessage("Initializing spawn points...", _SPAWN_SYSTEM_NAME, DEBUG_LEVEL_INFO);
    for(i=0; (oSpawnWP = GetObjectByTag(_SPAWN_WAYPOINT_TAG, i)) != OBJECT_INVALID; i++) {
        DelayCommand(fDelay, _AddSpawnPointFromWaypoint(oSpawnWP));
		fDelay += 0.01;
    }
    ACR_PrintDebugMessage(IntToString(i) + " spawn points initialized.", _SPAWN_SYSTEM_NAME, DEBUG_LEVEL_INFO);
	
	// Lets check that we actually got all the spawn points initialized.
    DelayCommand(fDelay + 60.0, _SpawnPointInitializationCheck(i));
}

float GetDespawnDelay() 
{ 
	float fReturn = GetGlobalFloat(_SPAWN_DESPAWN_DELAY_GF); 
	if(fReturn < 1.0f) return 60.0f; // prevent overly quick delays if something happens to our global
	return fReturn;
}

float GetRefreshDelay() 
{
	float fReturn = GetGlobalFloat(_SPAWN_REFRESH_DELAY_GF);
	if(fReturn < 1.0f) return 60.0f; // prevent overly quick delays if something happens to our global
	return fReturn;
}

int GetPrespawnsSeamless() { return GetGlobalInt(_SPAWN_PRESPAWN_SEAMLESS_GB); }

int GetPrespawnPrediction() { return GetGlobalInt(_SPAWN_PRESPAWN_PREDICTION_GB); }

void ACR_SpawnOnAreaEnter(object oCreature) {
    if(GetIsPC(oCreature)) {
        ACR_PreSpawnArea(GetArea(oCreature));
    }
}

void ACR_PreSpawnArea(object oArea) {
	int nAreaFlag = GetLocalInt(oArea, _SPAWN_AREA_FLAGS);

	if(!(nAreaFlag & _SPAWN_AREA_FLAG_ACTIVE)) {
	    ACR_PrintDebugMessage("Spawning "+GetName(oArea), _SPAWN_SYSTEM_NAME, DEBUG_LEVEL_INFO);
        _RefreshArea(oArea);
		_StartSpawnAreaHeartbeat(oArea, nAreaFlag);
    }
}

void ACR_SpawnOnAreaExit(object oCreature) {
 
}

void ACR_SpawnOnAreaInstanceCreate(object oAreaInstance) {

	int i;
	int nSpawnPointsFound = 0;
	object oSpawnWP;
	for (i=0; (oSpawnWP = GetObjectByTag(_SPAWN_WAYPOINT_TAG, i)) != OBJECT_INVALID; i++) {
		if (GetArea(oSpawnWP) != oAreaInstance) {
			continue;
		}
		DelayCommand(0.01f, _AddSpawnPointFromWaypoint(oSpawnWP));
		nSpawnPointsFound++;
	}
	ACR_PrintDebugMessage(GetName(oAreaInstance) + ": Initialized " + IntToString(nSpawnPointsFound) + " spawn points attached to area instance.", _SPAWN_SYSTEM_NAME, DEBUG_LEVEL_INFO);
}

void ACR_SpawnOnAreaInstanceCleanup(object oAreaInstance) {

	// Clear the active flag if it was set, so that the area can be despawned.
	// Note that we are guaranteed that there really weren't any players in the
	// area if we are running instance cleanup, so this is actually safe.
	int nFlags = GetLocalInt(oAreaInstance, _SPAWN_AREA_FLAGS);

	if (nFlags & _SPAWN_AREA_FLAG_ACTIVE) {

		nFlags &= ~(_SPAWN_AREA_FLAG_ACTIVE);
		SetLocalInt(oAreaInstance, _SPAWN_AREA_FLAGS, nFlags);
	}

	_DespawnArea(oAreaInstance);
}

int ACR_GetNumberOfSpawnPointsInArea(object oArea) {
    return GetLocalInt(oArea, _SPAWN_WAYPOINT_ARRAY_LENGTH);
}

object ACR_GetSpawnPoint(object oArea, int nNum) {
    return GetLocalArrayObject(oArea, _SPAWN_WAYPOINT_ARRAY, nNum);
}

void ACR_ReportSpawnDeath(object oObject) {
   object oParentWaypoint = GetLocalObject(oObject, _SPAWN_PARENT_WP);
   if (oParentWaypoint == OBJECT_INVALID) {
      // creature was not spawned by a waypoint, no need to handle the rest
	  return;
   }
   int nReserves = GetLocalInt(oParentWaypoint, _SPAWN_CHILD_COUNT);
   nReserves = nReserves - 1;
   SetLocalInt(oParentWaypoint, _SPAWN_CHILD_COUNT, nReserves);
   if (nReserves == 0) {
      // Last child of the waypoint has been killed, need to decrement respawn counter,
	  //  and set the waypoint to "recharge" in time.
	  int nRespawns = GetLocalInt(oParentWaypoint, _WP_SPAWN_RESPAWN_COUNT);
	  nRespawns = nRespawns - 1;
	  // Get the current game-time, and store it on the waypoint for respawn evaluation later.
	  int nDeathTime = ACR_GetGameSecondsSinceStart();
	  SetLocalInt(oParentWaypoint, _WP_RESPAWN_DELAY_START, nDeathTime);
	  // Set the remaining respawns for the parent waypoint.
	  SetLocalInt(oParentWaypoint, _WP_SPAWN_RESPAWN_COUNT, nRespawns);
	  // Mark the waypoint as no longer spawned, and disabled until the respawn timer is up.
	  //  also, set flag for respawn timer, to be handled in the next spawn heartbeat.
	  int nCurrentFlag = GetLocalInt(oParentWaypoint, _SPAWN_FLAGS);
	  nCurrentFlag = nCurrentFlag | _SPAWN_FLAGS_WAIT_FOR_RESPAWN;
	  nCurrentFlag = nCurrentFlag | _SPAWN_FLAGS_START_RESPAWN_D;
	  nCurrentFlag = nCurrentFlag & ~_SPAWN_FLAGS_SPAWNED; 
	  SetLocalInt(oParentWaypoint, _SPAWN_FLAGS, nCurrentFlag);
	  // need to insert delay here before reactivating spawn point
	  ACR_PrintDebugMessage(GetName(oParentWaypoint)+" is good for "+IntToString(nRespawns)+" more respawns.", _SPAWN_SYSTEM_NAME, DEBUG_LEVEL_INFO);
   }
}

void ACR_SetIsSpawnPointEnabled(object oWP, int bEnabled, int bChangeCurrentState = 0) {
    int nFlags = GetLocalInt(oWP, _SPAWN_FLAGS);
    if(bEnabled) {
        // Turning it on.
        if(nFlags & _SPAWN_FLAGS_DISABLED) {
            // It was disabled, enable it.
            nFlags = nFlags & ~_SPAWN_FLAGS_DISABLED;
			SetLocalInt(oWP, _SPAWN_FLAGS, nFlags);
            if(bChangeCurrentState) {
                // Lets change the current state too.
                _RefreshSpawnPoint(oWP);
            }
        }
    } else {
        // Turning it off.
        if(nFlags | _SPAWN_FLAGS_DISABLED) {
            // It was enabled, disable it.
            nFlags = nFlags | _SPAWN_FLAGS_DISABLED;
			SetLocalInt(oWP, _SPAWN_FLAGS, nFlags);
            if(bChangeCurrentState) {
                // Lets change the current state too.
                _DespawnPoint(oWP, nFlags);
            }
        }
    }
}

void ACR_DestroySpawnPoint(object oWP, int bDespawnChildren = 0) {
	int nFlags = GetLocalInt(oWP, _SPAWN_FLAGS);
    SetLocalInt(oWP, _SPAWN_FLAGS, nFlags | _SPAWN_DISALLOWED);
	if(bDespawnChildren) _DespawnPoint(oWP, nFlags);
}

void ACR_DisallowSpawn(object oWP = OBJECT_SELF) {
    SetLocalInt(oWP, _SPAWN_FLAGS, GetLocalInt(oWP, _SPAWN_FLAGS) | _SPAWN_DISALLOWED);
}

void ACR_ForceSpawn(object oWP = OBJECT_SELF) {
    SetLocalInt(oWP, _SPAWN_FLAGS, GetLocalInt(oWP, _SPAWN_FLAGS) | _SPAWN_FORCED);
}

object ACR_SpawnObject(string sResRef, int nObjectType, object oWP = OBJECT_SELF) {
	location lLoc = _RandomizeLocation(ACR_GetSpawnLocation(oWP), GetLocalFloat(oWP, _WP_SPAWN_RANDOM_RADIUS));
    return _SpawnObject(sResRef, nObjectType, oWP, lLoc, GetLocalInt(oWP, _SPAWN_FLAGS));
}

object ACR_SpawnObjectAtLocation(string sResRef, int nObjectType, location lLoc, object oWP = OBJECT_SELF) {
    return _SpawnObject(sResRef, nObjectType, oWP, lLoc, GetLocalInt(oWP, _SPAWN_FLAGS));
}


location ACR_GetSpawnLocationFromDirection(float fAngle, float fDist, object oWP = OBJECT_SELF) {
    float fPointFacing = GetFacing(oWP);
    return _GetNewLocationFromDirectionAndFacing(ACR_GetSpawnLocation(oWP), fDist, fPointFacing, fPointFacing);
}

location ACR_GetSpawnLocationFromDirectionAndFacing(float fAngle, float fDist, float fFacing, object oWP = OBJECT_SELF) {
    float fPointFacing = GetFacing(oWP);
    return _GetNewLocationFromDirectionAndFacing(ACR_GetSpawnLocation(oWP), fDist, fPointFacing + fAngle, fPointFacing + fFacing);
}

location ACR_GetSpawnLocationFromVector(float fXDist, float fYDist, object oWP = OBJECT_SELF) {
    float fPointFacing = GetFacing(oWP);
    float fCos = cos(fPointFacing);
    return _GetNewLocationFromVectorAndFacing(ACR_GetSpawnLocation(oWP), fXDist*fCos, fYDist*fCos, fPointFacing);
}

location ACR_GetSpawnLocationFromVectorAndFacing(float fXDist, float fYDist, float fFacing, object oWP = OBJECT_SELF) {
    float fPointFacing = GetFacing(oWP);
    float fCos = cos(fPointFacing);
    return _GetNewLocationFromVectorAndFacing(ACR_GetSpawnLocation(oWP), fXDist*fCos, fYDist*fCos, fFacing + fPointFacing);
}

void ACR_SpawnGroup(string sGroupName, object oWP) {
    ExecuteScript(_SPAWN_GROUP_SCRIPT_PREFIX + sGroupName, oWP);
}

void ACR_SpawnPoint(object oWP) {
    _SpawnPoint(oWP, GetLocalInt(oWP, _SPAWN_FLAGS));
}

location ACR_GetSpawnLocation(object oWP = OBJECT_SELF) {
    return GetLocalLocation(oWP, _SPAWN_LAST_LOCATION);
}

string ACR_SpawnPointToString(object oWP)
{
	object oArea = GetArea(oWP);

	return "(Tag: " + GetTag(oWP) + ", Name: " + GetName(oWP) + ", Location: " + LocationToString(GetLocation(oWP)) + ") IN (Tag: " + GetTag(oArea) + ", Name: " + GetName(oArea) + ") ";
}

int ACR_GetIsSpawned(object oWP)
{
	return GetLocalInt(oWP, _SPAWN_FLAGS) & _SPAWN_FLAGS_SPAWNED;
}


int ACR_AddObjectToSpawnPoint(object oWP, object oObject)
{
	_AddObjectToSpawnPoint(oWP, oObject);

	// Spit debug information to logfile
	if (GetLocalInt(GetModule(), ACR_LOG_SPAWNS)) {
        	WriteTimestampedLogEntry("ACR_Spawn: ACR_AddObjectToSpawnPoint "+GetTag(oObject)+" - "+ACR_SpawnPointToString(oWP));
	}

	return TRUE;
}


////////////////////////////////////////////////////////////////////////////////
// *** BEGIN PRIVATE FUNCTIONS ***
////////////////////////////////////////////////////////////////////////////////

void _AddSpawnPointFromWaypoint(object oWP) {

    if(GetObjectType(oWP) != OBJECT_TYPE_WAYPOINT)
        return;

    object oArea = GetArea(oWP);

    // Combine all the spawn times into a single integer.
    int nTimes = 0;
    nTimes += ApplyIntegerLimit( GetLocalInt(oWP, _WP_SPAWN_HOUR), 0, 23) << _SPAWN_TIMES_HOUR_START;
    nTimes += ApplyIntegerLimit( GetLocalInt(oWP, _WP_DESPAWN_HOUR), 0, 23) << _DESPAWN_TIMES_HOUR_START;
    nTimes += ApplyIntegerLimit( GetLocalInt(oWP, _WP_SPAWN_DAY), 1, 28) << _SPAWN_TIMES_DAY_START;
    nTimes += ApplyIntegerLimit( GetLocalInt(oWP, _WP_DESPAWN_DAY), 1, 28) << _DESPAWN_TIMES_DAY_START;
    nTimes += ApplyIntegerLimit( GetLocalInt(oWP, _WP_SPAWN_MONTH), 1, 12) << _SPAWN_TIMES_MONTH_START;
    nTimes += ApplyIntegerLimit( GetLocalInt(oWP, _WP_DESPAWN_MONTH), 1, 12) << _DESPAWN_TIMES_MONTH_START;
    SetLocalInt(oWP, _SPAWN_TIMES, nTimes);
    DeleteLocalInt(oWP, _WP_SPAWN_HOUR);
    DeleteLocalInt(oWP, _WP_DESPAWN_HOUR);
    DeleteLocalInt(oWP, _WP_SPAWN_DAY);
    DeleteLocalInt(oWP, _WP_DESPAWN_DAY);
    DeleteLocalInt(oWP, _WP_SPAWN_MONTH);
    DeleteLocalInt(oWP, _WP_DESPAWN_MONTH);

    // Combine all the boolean flags into a single value.
    int nFlags = 0;
    nFlags = CombineBooleanLocalInt(nFlags, oWP, _WP_RESPAWN_IN_PC_SIGHT, _SPAWN_FLAGS_IN_PC_SIGHT);
    nFlags = CombineBooleanLocalInt(nFlags, oWP, _WP_RESPAWN_WITH_PC_IN_AREA, _SPAWN_FLAGS_WITH_PC_IN_AREA);
    nFlags = CombineBooleanLocalInt(nFlags, oWP, _WP_SPAWN_WITH_ANIMATION, _SPAWN_FLAGS_WITH_ANIMATION);
    nFlags = CombineBooleanLocalInt(nFlags, oWP, _WP_SPAWN_DISABLED, _SPAWN_FLAGS_DISABLED);
    nFlags = CombineBooleanLocalInt(nFlags, oWP, _WP_SPAWN_RANDOM_FACING, _SPAWN_FLAGS_RANDOM_FACING);
    nFlags = CombineBooleanLocalInt(nFlags, oWP, _WP_SPAWN_RANDOM_NAME, _SPAWN_FLAGS_RANDOM_NAME);
    nFlags = CombineBooleanLocalInt(nFlags, oWP, _WP_SPAWN_IN_STEALTH, _SPAWN_IN_STEALTH);
    nFlags = CombineBooleanLocalInt(nFlags, oWP, _WP_SPAWN_IN_DETECT, _SPAWN_IN_DETECT);
    nFlags = CombineBooleanLocalInt(nFlags, oWP, _WP_SPAWN_BUFFED, _SPAWN_BUFFED);
    SetLocalInt(oWP, _SPAWN_FLAGS, nFlags);

    // Do the same for the weather flags.
    int nWeather = 0;
    nWeather = CombineBooleanLocalInt(nWeather, oWP, _WP_SPAWN_WFLAGS_CLEAR, _SPAWN_WFLAGS_CLEAR);
    nWeather = CombineBooleanLocalInt(nWeather, oWP, _WP_SPAWN_WFLAGS_RAIN_WEAK, _SPAWN_WFLAGS_RAIN_WEAK);
    nWeather = CombineBooleanLocalInt(nWeather, oWP, _WP_SPAWN_WFLAGS_RAIN_LIGHT, _SPAWN_WFLAGS_RAIN_LIGHT);
    nWeather = CombineBooleanLocalInt(nWeather, oWP, _WP_SPAWN_WFLAGS_RAIN_MEDIUM, _SPAWN_WFLAGS_RAIN_MEDIUM);
    nWeather = CombineBooleanLocalInt(nWeather, oWP, _WP_SPAWN_WFLAGS_RAIN_HEAVY, _SPAWN_WFLAGS_RAIN_HEAVY);
    nWeather = CombineBooleanLocalInt(nWeather, oWP, _WP_SPAWN_WFLAGS_RAIN_STORMY, _SPAWN_WFLAGS_RAIN_STORMY);
    nWeather = CombineBooleanLocalInt(nWeather, oWP, _WP_SPAWN_WFLAGS_SNOW_WEAK, _SPAWN_WFLAGS_SNOW_WEAK);
    nWeather = CombineBooleanLocalInt(nWeather, oWP, _WP_SPAWN_WFLAGS_SNOW_LIGHT, _SPAWN_WFLAGS_SNOW_LIGHT);
    nWeather = CombineBooleanLocalInt(nWeather, oWP, _WP_SPAWN_WFLAGS_SNOW_MEDIUM, _SPAWN_WFLAGS_SNOW_MEDIUM);
    nWeather = CombineBooleanLocalInt(nWeather, oWP, _WP_SPAWN_WFLAGS_SNOW_HEAVY, _SPAWN_WFLAGS_SNOW_HEAVY);
    nWeather = CombineBooleanLocalInt(nWeather, oWP, _WP_SPAWN_WFLAGS_SNOW_STORMY, _SPAWN_WFLAGS_SNOW_STORMY);
    nWeather = CombineBooleanLocalInt(nWeather, oWP, _WP_SPAWN_WFLAGS_LIGHTNING_WEAK, _SPAWN_WFLAGS_LIGHTNING_WEAK);
    nWeather = CombineBooleanLocalInt(nWeather, oWP, _WP_SPAWN_WFLAGS_LIGHTNING_LIGHT, _SPAWN_WFLAGS_LIGHTNING_LIGHT);
    nWeather = CombineBooleanLocalInt(nWeather, oWP, _WP_SPAWN_WFLAGS_LIGHTNING_MEDIUM, _SPAWN_WFLAGS_LIGHTNING_MEDIUM);
    nWeather = CombineBooleanLocalInt(nWeather, oWP, _WP_SPAWN_WFLAGS_LIGHTNING_HEAVY, _SPAWN_WFLAGS_LIGHTNING_HEAVY);
    nWeather = CombineBooleanLocalInt(nWeather, oWP, _WP_SPAWN_WFLAGS_LIGHTNING_STORMY, _SPAWN_WFLAGS_LIGHTNING_STORMY);
    nWeather = CombineBooleanLocalInt(nWeather, oWP, _WP_SPAWN_IN_DAMAGING_COLD, _SPAWN_WFLAGS_IN_DAMAGING_COLD);
    nWeather = CombineBooleanLocalInt(nWeather, oWP, _WP_SPAWN_IN_DAMAGING_HEAT, _SPAWN_WFLAGS_IN_DAMAGING_HEAT);
    SetLocalInt(oWP, _SPAWN_WEATHER_FLAGS, nWeather);

    // Read the spawn object type, and set it accordingly.
    int nType = GetLocalInt(oWP, _WP_SPAWN_TYPE);
    switch(nType) {
        case 0:
            SetLocalInt(oWP, _WP_SPAWN_TYPE, OBJECT_TYPE_CREATURE);
            break;
        case 1:
            SetLocalInt(oWP, _WP_SPAWN_TYPE, OBJECT_TYPE_PLACEABLE);
            break;
        case 2:
            SetLocalInt(oWP, _WP_SPAWN_TYPE, OBJECT_TYPE_ITEM);
            break;
        case 3:
            SetLocalInt(oWP, _WP_SPAWN_TYPE, OBJECT_TYPE_STORE);
            break;
        case 4:
            SetLocalInt(oWP, _WP_SPAWN_TYPE, OBJECT_TYPE_WAYPOINT);
            break;
		case 5:
			SetLocalInt(oWP, _WP_SPAWN_TYPE, OBJECT_TYPE_TRIGGER);
			break;
		case 6:
			SetLocalInt(oWP, _WP_SPAWN_TYPE, OBJECT_TYPE_ENCOUNTER);
			break;
		case 7:
			SetLocalInt(oWP, _WP_SPAWN_TYPE, OBJECT_TYPE_LIGHT);
			break;
		case 8:
			SetLocalInt(oWP, _WP_SPAWN_TYPE, SPECIAL_OBJECT_TYPE_TRAP);
			break;
    }

    // Now we combine the numbers and min/maxes of the spawn resrefs and groups
    // into one local int.
    int nNums = 0;

    // Count the number of random resrefs listed in this spawn point, and write
    // them to the waypoint.
    int i = 0;
    while(1) {
        if( GetLocalString(oWP, _WP_SPAWN_RESREF_RANDOM_ARRAY + IntToString(i+1)) == "") {
            break;
        }
        if(i > _SPAWN_NUMS_MAX) {
            ACR_PrintDebugMessage("Spawn point " + GetObjectInfoAsString(oWP) + " in area " + GetObjectInfoAsString(oArea) + " has more than 63 random spawn resrefs. Discarding extras.", _SPAWN_SYSTEM_NAME, DEBUG_LEVEL_FATAL);
            break;
        }
        i++;
    }
    nNums += i << _SPAWN_NUMS_NUM_RESREFS_START;

    // Count the number of random spawn groups listed in this spawn point, and
    // write them to the waypoint.
    i = 0;
    while(1) {
        if( GetLocalString(oWP, _WP_SPAWN_GROUP_RANDOM_ARRAY + IntToString(i+1)) == "") {
            break;
        }
        if(i > _SPAWN_NUMS_MAX) {
            ACR_PrintDebugMessage("Spawn point " + GetObjectInfoAsString(oWP) + " in area " + GetObjectInfoAsString(oArea) + " has more than 63 random spawn groups. Discarding extras.", _SPAWN_SYSTEM_NAME, DEBUG_LEVEL_FATAL);
            break;
        }
        i++;
    }
    nNums += i << _SPAWN_NUMS_GROUP_NUM_START;

    // Add in the min/maxes as well.
    nNums += ApplyIntegerLimit( GetLocalInt(oWP, _WP_SPAWN_NUMBER_MIN), 0, _SPAWN_NUMS_MAX) << _SPAWN_NUMS_RESREFS_MIN_START;
    nNums += ApplyIntegerLimit( GetLocalInt(oWP, _WP_SPAWN_NUMBER_MAX), 0, _SPAWN_NUMS_MAX) << _SPAWN_NUMS_RESREFS_MAX_START;
    nNums += ApplyIntegerLimit( GetLocalInt(oWP, _WP_SPAWN_GROUP_NUMBER_MIN), 0, _SPAWN_NUMS_MAX) << _SPAWN_NUMS_GROUP_MIN_START;
    nNums += ApplyIntegerLimit( GetLocalInt(oWP, _WP_SPAWN_GROUP_NUMBER_MAX), 0, _SPAWN_NUMS_MAX) << _SPAWN_NUMS_GROUP_MAX_START;

    // We're done with the nums, so save them.
    SetLocalInt(oWP, _SPAWN_NUMS, nNums);

    // Find and spawn/despawn waypoints, and cache them in place of the waypoint
    // tags.
    string sTag = GetLocalString(oWP, _WP_SPAWN_WAYPOINT);
    if(sTag != "") {
        object oSpawnWP = GetNearestObjectByTag(sTag, oWP);
        if(!GetIsObjectValid(oSpawnWP)) {
            ACR_PrintDebugMessage("Spawn waypoint of tag " + sTag + " in area " + GetObjectInfoAsString(oArea) + " not found.", _SPAWN_SYSTEM_NAME, DEBUG_LEVEL_FATAL);
        } else {
            SetLocalObject(oWP, _WP_SPAWN_WAYPOINT, oSpawnWP);
        }
    }
    DeleteLocalString(oWP, _WP_SPAWN_WAYPOINT);
    sTag = GetLocalString(oWP, _WP_DESPAWN_WAYPOINT);
    if(sTag != "") {
        object oDespawnWP = GetNearestObjectByTag(sTag, oWP);
        if(!GetIsObjectValid(oDespawnWP)) {
            ACR_PrintDebugMessage("Despawn waypoint of tag " + sTag + " in area " + GetObjectInfoAsString(oArea) + " not found.", _SPAWN_SYSTEM_NAME, DEBUG_LEVEL_FATAL);
        } else {
            SetLocalObject(oWP, _WP_DESPAWN_WAYPOINT, oDespawnWP);
        }
    }
    DeleteLocalString(oWP, _WP_DESPAWN_WAYPOINT);

    // Add this waypoint to the area's array of spawn waypoints.
    int nSpawnPoints = GetLocalInt(oArea, _SPAWN_WAYPOINT_ARRAY_LENGTH);
    SetLocalArrayObject(oArea, _SPAWN_WAYPOINT_ARRAY, nSpawnPoints, oWP);
    SetLocalInt(oArea, _SPAWN_WAYPOINT_ARRAY_LENGTH, nSpawnPoints + 1);

    // We set the spawn location, in case some n00b calls ACR_SpawnObject() on
    // this waypoint too early.
    SetLocalLocation(oWP, _SPAWN_LAST_LOCATION, GetLocation(oWP));
}

void _RefreshArea(object oArea) {

    // ACR_PrintDebugMessage(GetName(oArea) + "'s spawns are being refreshed.", _SPAWN_SYSTEM_NAME, DEBUG_LEVEL_INFO);
	SetLocalInt(oArea, _SPAWN_LAST_REFRESHED, ACR_GetGameSecondsSinceStart() );
    int nNumSpawns = GetLocalInt(oArea, _SPAWN_WAYPOINT_ARRAY_LENGTH);
    int i;
    for(i=0; i<nNumSpawns; i++) {
        object oWP = GetLocalArrayObject(oArea, _SPAWN_WAYPOINT_ARRAY, i);
        _RefreshSpawnPoint(oWP);
    }
}

void _DespawnArea(object oArea) {
    // if the area has been reactivated during the despawn delay window, cancel the queued despawn
	int nDespawnAreaFlags = GetLocalInt(oArea, _SPAWN_AREA_FLAGS);
    if(nDespawnAreaFlags & _SPAWN_AREA_FLAG_ACTIVE) { return; }
	// check for PCs anyway, in case some slipped through the cracks. If they're present, the area is active and heartbeats restart.
    if(GetArePCsInArea(oArea)) {
		_RefreshArea(oArea);
		_StartSpawnAreaHeartbeat(oArea, nDespawnAreaFlags);
		return;
    }     
	// otherwise, despawn the area.
    ACR_PrintDebugMessage(GetName(oArea) + " is being despawned.", _SPAWN_SYSTEM_NAME, DEBUG_LEVEL_INFO);
    int i;
    int nNumSpawns = GetLocalInt(oArea, _SPAWN_WAYPOINT_ARRAY_LENGTH);
    for(i=0; i<nNumSpawns; i++) {
        object oWP = GetLocalArrayObject(oArea, _SPAWN_WAYPOINT_ARRAY, i);
        _DespawnPoint(oWP, GetLocalInt(oWP, _SPAWN_FLAGS));
    }
}

void _DespawnPoint(object oWP, int nFlags) {
    // ACR_PrintDebugMessage("Despawning SP: " + GetName(oWP) + ".", _SPAWN_SYSTEM_NAME, DEBUG_LEVEL_INFO);
    int nNumChildren = GetLocalInt(oWP, _SPAWNED_OBJECT_ARRAY_LENGTH);
	// SendMessageToAllDMs("++++++++++ Starting at position "+IntToString(nNumChildren)+", entry "+GetName(GetLocalArrayObject(oWP, _SPAWNED_OBJECT_ARRAY, 0)));
    int i;
    for(i=0; i<nNumChildren; i++ ) {
        object oChild = GetLocalArrayObject(oWP, _SPAWNED_OBJECT_ARRAY, i);
		// SendMessageToAllDMs("** Destroying "+GetName(oChild)+", removing array object "+GetTag(GetLocalArrayObject(oWP, _SPAWNED_OBJECT_ARRAY, i))); 
		
		// manage persistent storage objects: should never drop contents on despawn.
        if (ACR_GetIsPersistentStorageObject(oChild)) {
		    SetLocalInt(oChild, "ACR_PSO_ONDEATH", FALSE); 
		    ACR_PersistentStorageOnDeath(oChild); 
		}
		// Experimental: destroy all items in stores because they might be leaking.
		if(GetObjectType(oChild) == OBJECT_TYPE_STORE) {
			object oItem = GetFirstItemInInventory(oChild);
			while(oItem != OBJECT_INVALID) {
				DestroyObject(oItem);
				oItem = GetNextItemInInventory(oChild);
			}
		}
		
        DestroyObject(oChild);
        DeleteLocalArrayObject(oWP, _SPAWNED_OBJECT_ARRAY, i);
    }
    DeleteLocalInt(oWP, _SPAWNED_OBJECT_ARRAY_LENGTH);
	SetLocalInt(oWP, _SPAWN_FLAGS, nFlags & ~_SPAWN_FLAGS_SPAWNED);
	SetLocalInt(oWP, _SPAWN_CHILD_COUNT, 0);
	
	int count = 0;
	string root = "ACR_TRAP_";
	while(GetLocalString(oWP, root + IntToString(count)) != "")
	{
		object oTrap = GetObjectByTag(GetLocalString(oWP, root + IntToString(count)), 0);
		AssignCommand(oTrap, _PassToCSharp(TRAP_EVENT_DESPAWN_TRAP));
		DeleteLocalString(oWP, root + IntToString(count));
		count++;
	}
}

void _RefreshSpawnPoint(object oWP) {
    // We get these values now to because they are used across multiple
    // functions, and we want to cut down on the number of GetLocal* calls.
    int nFlags = GetLocalInt(oWP, _SPAWN_FLAGS);

    if( _GetShouldSpawnBeActive(oWP) ) {
        // The spawn should be active.
        if( _SPAWN_FLAGS_SPAWNED & nFlags ) {
            // Is spawned.
        } else {
            // Is not spawned.
            _SpawnPoint(oWP, nFlags);
        }
    } else {
        // The spawn should not be active.
        if( _SPAWN_FLAGS_SPAWNED & nFlags ) {
            // Is spawned.
            _DespawnPoint(oWP, nFlags);
        } else {
            // Is not spawned.
        }
    }
}

int _GetShouldSpawnBeActive(object oWP) {

	// Run any forcing spawn/despawn scripts.
	ExecuteScript(GetLocalString(oWP, _WP_IS_ACTIVE_SCRIPT), oWP);
	
	int nFlags = GetLocalInt(oWP, _SPAWN_FLAGS);

    // SendMessageToAllDMs("###### Waypoint "+GetName(oWP)+": _SPAWN_TIMES = "+IntToString(GetLocalInt(oWP, _SPAWN_TIMES)));
    // Has this spawn been forced by any custom pre-spawn script?
    if(_SPAWN_FORCED & nFlags) {
        SetLocalInt(oWP, _SPAWN_FLAGS, (nFlags & ~_SPAWN_FORCED) & ~_SPAWN_DISALLOWED);
        return 1;
    }
	
    // Has this spawn been disallowed by any custom pre-spawn script?
    if(_SPAWN_DISALLOWED & nFlags) {
        // Yes. Clear this bit and exit.
        SetLocalInt(oWP, _SPAWN_FLAGS, (nFlags & ~_SPAWN_FORCED) & ~_SPAWN_DISALLOWED);
        ACR_PrintDebugMessage(GetName(oWP)+" inactive because: Disallowed.", _SPAWN_SYSTEM_NAME, DEBUG_LEVEL_INFO);
        return 0;
    }

	// If the spawn point has just been killed off, test to see if it should be respawned.
	if (_SPAWN_FLAGS_START_RESPAWN_D & nFlags) {
	   float fRespawnDelayMax = ACR_GameHoursToRealSeconds(GetLocalFloat(oWP, _WP_RESPAWN_DELAY_MAX));
	   float fRespawnDelayMin = ACR_GameHoursToRealSeconds(GetLocalFloat(oWP, _WP_RESPAWN_DELAY_MIN));
	   float fRespawnDelay = fRespawnDelayMax;
	   float fLapsedTime = IntToFloat(ACR_GetGameSecondsSinceStart()) - IntToFloat(GetLocalInt(oWP, _WP_RESPAWN_DELAY_START));
       if (fRespawnDelayMax != fRespawnDelayMin) {
	     // then we need to insert randomness to the delay
		 fRespawnDelay = ACR_RandomFloat(fRespawnDelayMin, fRespawnDelayMax);	   
	   }
	   ACR_PrintDebugMessage(GetName(oWP)+"'s respawn will be delayed a further "+FloatToString(fRespawnDelay)+" seconds.", _SPAWN_SYSTEM_NAME, DEBUG_LEVEL_INFO);
	   if (fRespawnDelay <= fLapsedTime) {
	      // no additional delay, amend the spawn flags, allow function to continue, to
		  // make sure all other conditions are met.
	      nFlags = (nFlags & ~_SPAWN_FLAGS_WAIT_FOR_RESPAWN);
		  nFlags = (nFlags & ~_SPAWN_FLAGS_START_RESPAWN_D);
		  SetLocalInt(oWP, _SPAWN_FLAGS, nFlags);
       } else {
	      // still some time to go yet, 
		 DelayCommand((fRespawnDelay - fLapsedTime), _RespawnPoll(oWP));
		 nFlags = (nFlags & ~_SPAWN_FLAGS_START_RESPAWN_D);
		 SetLocalInt(oWP, _SPAWN_FLAGS, nFlags);
		 return 0;
       } 
	}

    // If the spawn point is disabled, or if its in a period between respawns,
    // don't spawn it.
    if(_SPAWN_FLAGS_DISABLED & nFlags || _SPAWN_FLAGS_WAIT_FOR_RESPAWN & nFlags) {
        ACR_PrintDebugMessage(GetName(oWP)+" inactive because: Disabled.", _SPAWN_SYSTEM_NAME, DEBUG_LEVEL_INFO);
        return 0;
    }

	// Is this the last of this spawn point's reserves?
    if(GetLocalInt(oWP, _WP_SPAWN_RESPAWN_COUNT) == 0) {
        // Yes, turn it off.
        ACR_PrintDebugMessage(GetName(oWP)+" inactive because: No more spawns left.", _SPAWN_SYSTEM_NAME, DEBUG_LEVEL_INFO);
        return 0;
    }
	
    // Check the weather stuff.
    object oArea = GetArea(oWP);
    int nWeather = GetLocalInt(oWP, _SPAWN_WEATHER_FLAGS);
    if( GetIsAreaAboveGround(oArea) && !GetIsAreaInterior(oArea) ) {
        // This area is effected by the weather system.
        // These weather functions do not exist in NWN1, commenting out for now.
        // FIX ME !!!
        /*int nClear;
        switch(GetWeather(oArea, WEATHER_TYPE_RAIN))
            case WEATHER_POWER_OFF:
                nClear++;
                break;
            case WEATHER_POWER_WEAK:
                if(nWeather & _SPAWN_WFLAGS_RAIN_WEAK) {
                    return 0;
                }
                break;
            case WEATHER_POWER_LIGHT:
                if(nWeather & _SPAWN_WFLAGS_RAIN_LIGHT) {
                    return 0;
                }
                break;
            case WEATHER_POWER_MEDIUM:
                if(nWeather & _SPAWN_WFLAGS_RAIN_MEDIUM) {
                    return 0;
                }
                break;
            case WEATHER_POWER_HEAVY:
                if(nWeather & _SPAWN_WFLAGS_RAIN_HEAVY) {
                    return 0;
                }
                break;
            case WEATHER_POWER_STORMY:
                if(nWeather & _SPAWN_WFLAGS_RAIN_STORMY) {
                    return 0;
                }
                break;
        }
        switch(GetWeather(oArea, WEATHER_TYPE_LIGHTNING)) {
            case WEATHER_POWER_OFF:
                nClear++;
                break;
            case WEATHER_POWER_WEAK:
                if(nWeather & _SPAWN_WFLAGS_LIGHTNING_WEAK) {
                    return 0;
                }
                break;
            case WEATHER_POWER_LIGHT:
                if(nWeather & _SPAWN_WFLAGS_LIGHTNING_LIGHT) {
                    return 0;
                }
                break;
            case WEATHER_POWER_MEDIUM:
                if(nWeather & _SPAWN_WFLAGS_LIGHTNING_MEDIUM) {
                    return 0;
                }
                break;
            case WEATHER_POWER_HEAVY:
                if(nWeather & _SPAWN_WFLAGS_LIGHTNING_HEAVY) {
                    return 0;
                }
                break;
            case WEATHER_POWER_STORMY:
                if(nWeather & _SPAWN_WFLAGS_RAIN_STORMY) {
                    return 0;
                }
                break;
        }
        switch(GetWeather(oArea, WEATHER_TYPE_SNOW)) {
            case WEATHER_POWER_OFF:
                nClear++;
                break;
            case WEATHER_POWER_WEAK:
                if(nWeather & _SPAWN_WFLAGS_SNOW_WEAK) {
                    return 0;
                }
                break;
            case WEATHER_POWER_LIGHT:
                if(nWeather & _SPAWN_WFLAGS_SNOW_LIGHT) {
                    return 0;
                }
                break;
            case WEATHER_POWER_MEDIUM:
                if(nWeather & _SPAWN_WFLAGS_SNOW_MEDIUM) {
                    return 0;
                }
                break;
            case WEATHER_POWER_HEAVY:
                if(nWeather & _SPAWN_WFLAGS_SNOW_HEAVY) {
                    return 0;
                }
                break;
            case WEATHER_POWER_STORMY:
                if(nWeather & _SPAWN_WFLAGS_SNOW_STORMY) {
                    return 0;
                }
                break;
        }
        if(nClear == 3 & nWeather & _SPAWN_WFLAGS_CLEAR) {
            return 0;
        }

        if( !(nWeather & _SPAWN_WFLAGS_IN_DAMAGING_COLD) && ACR_GetIsWeatherDamagingCold(oArea) ) {
            SendMessageToAllDMs("Spawn inactive because: Cold weather.");
            return 0;
        }
        if( !(nWeather & _SPAWN_WFLAGS_IN_DAMAGING_HEAT) && ACR_GetIsWeatherDamagingHeat(oArea) ) {
            SendMessageToAllDMs("Spawn inactive because: Hot weather.");
            return 0;
        }*/
    }

    // Check the PC proximity stuff- these tests should only be made is the spawn point
	//  is currently inactive- we don't want spawns being despawned just because a PC 
	//  comes into visual range of them.
	if (!(_SPAWN_FLAGS_SPAWNED & nFlags)) {
      if( nFlags & _SPAWN_FLAGS_WITH_PC_IN_AREA) {
          object oPC = GetNearestCreature(CREATURE_TYPE_PLAYER_CHAR, PLAYER_CHAR_IS_PC, oWP);		  
          if(oPC != OBJECT_INVALID) {
            ACR_PrintDebugMessage(GetName(oWP)+" inactive because: PC already in area.", _SPAWN_SYSTEM_NAME, DEBUG_LEVEL_INFO);
            return 0;
          }
      } else if( !(nFlags & _SPAWN_FLAGS_IN_PC_SIGHT) ) {
          object oPC = GetNearestCreature(CREATURE_TYPE_PLAYER_CHAR, PLAYER_CHAR_IS_PC, oWP);
          if( (oPC != OBJECT_INVALID) && (GetDistanceBetween(oWP, oPC) <= PC_PERCEPTION_RANGE )) { // ACR_GetPCVisualRange() )) {
             ACR_PrintDebugMessage(GetName(oWP)+" inactive because: PC in sight.", _SPAWN_SYSTEM_NAME, DEBUG_LEVEL_INFO);
             return 0;
          } else if (GetPrespawnPrediction()) {
		  // check for waypoints generated by the Seamless AT system, indicating a PC's likely arrival point.
			 object oArrivalPoint = GetNearestObjectByTag("ACR_SA_WP", oWP);
			 if( (oArrivalPoint != OBJECT_INVALID) && (GetDistanceBetween(oWP, oArrivalPoint) <= PC_PERCEPTION_RANGE )) { // ACR_GetPCVisualRange() )) {
               ACR_PrintDebugMessage(GetName(oWP)+" inactive because: PC's predicted arrival is in sight.", _SPAWN_SYSTEM_NAME, DEBUG_LEVEL_INFO);
               return 0;
			 }
		   }
	    }
    }
    // Load the data on spawn timing.
    int nTimes = GetLocalInt(oWP, _SPAWN_TIMES);

    // Is it the right month for this spawn point to spawn?
    int nSpawnTime = GetPiecewiseInteger(nTimes, _SPAWN_TIMES_MONTH_START, _SPAWN_TIMES_MONTH_END);
    int nDespawnTime = GetPiecewiseInteger(nTimes, _DESPAWN_TIMES_MONTH_START, _DESPAWN_TIMES_MONTH_END);
    if(nSpawnTime != nDespawnTime && !GetIsIntegerInWindow(GetCalendarMonth(), nSpawnTime, nDespawnTime)) {
        ACR_PrintDebugMessage(GetName(oWP)+" inactive because: Wrong month.", _SPAWN_SYSTEM_NAME, DEBUG_LEVEL_INFO);
        return 0;
    }

    // Is it the right day for this spawn point to spawn?
    nSpawnTime = GetPiecewiseInteger(nTimes, _SPAWN_TIMES_DAY_START, _SPAWN_TIMES_DAY_END);
    nDespawnTime = GetPiecewiseInteger(nTimes, _DESPAWN_TIMES_DAY_START, _DESPAWN_TIMES_DAY_END);
    if(nSpawnTime != nDespawnTime && !GetIsIntegerInWindow(GetCalendarDay(), nSpawnTime, nDespawnTime)) {
        ACR_PrintDebugMessage(GetName(oWP)+" inactive because: Wrong day.", _SPAWN_SYSTEM_NAME, DEBUG_LEVEL_INFO);
        return 0;
    }

    // Is it the right hour for this spawn point to spawn?
    nSpawnTime = GetPiecewiseInteger(nTimes, _SPAWN_TIMES_HOUR_START, _SPAWN_TIMES_HOUR_END);
    nDespawnTime = GetPiecewiseInteger(nTimes, _DESPAWN_TIMES_HOUR_START, _DESPAWN_TIMES_HOUR_END);
    if(nSpawnTime != nDespawnTime && !GetIsIntegerInWindow(GetTimeHour(), nSpawnTime, nDespawnTime)) {
       ACR_PrintDebugMessage(GetName(oWP)+" inactive because: Wrong hour.", _SPAWN_SYSTEM_NAME, DEBUG_LEVEL_INFO);
        return 0;
    }

    // Make sure we haven't already checked this spawn point for a percentage
    // chance to spawn today. If we have, stick with the old decision. If not,
    // re-decide.
    int nLastDayChecked = GetLocalInt(oWP, _WP_LAST_DAY_CHECKED);
    int nToday = ACR_GetGameDaysSinceStart();
	
    float fChance = GetLocalFloat(oWP, _WP_SPAWN_CHANCE);
    if((fChance < 100.0) && (nLastDayChecked != nToday)) {
        // We haven't checked today.
        float fRoll = ACR_RandomFloat(0.0, 100.0);
		SetLocalInt(oWP, _WP_LAST_DAY_CHECKED, nToday);
		
        if(fRoll <= fChance) {
            // Yes, it spawns.
            nFlags = nFlags & ~_SPAWN_FLAGS_NOT_TODAY;
            SetLocalInt(oWP, _SPAWN_FLAGS, nFlags);
        } else {
            // No, it doesn't.
            nFlags = nFlags | _SPAWN_FLAGS_NOT_TODAY;
            SetLocalInt(oWP, _SPAWN_FLAGS, nFlags);
            ACR_PrintDebugMessage(GetName(oWP)+" inactive because: Chance-to-spawn failed.", _SPAWN_SYSTEM_NAME, DEBUG_LEVEL_INFO);
            return 0;
        }
    } else {
        // We've already decided today, stick with that decision.
        if(_SPAWN_FLAGS_NOT_TODAY & nFlags) {
            ACR_PrintDebugMessage(GetName(oWP)+" inactive because: Chance-to-spawn already failed for the day.", _SPAWN_SYSTEM_NAME, DEBUG_LEVEL_INFO);
            return 0;
        } else {
        }
    }
    // ACR_PrintDebugMessage("Spawn active!", _SPAWN_SYSTEM_NAME, DEBUG_LEVEL_INFO);
    return 1;
}

void _SpawnPoint(object oWP, int nFlags) {

    // If this spawn point is already spawned, do nothing.
    int nFlags = GetLocalInt(oWP, _SPAWN_FLAGS);
    if(_SPAWN_FLAGS_SPAWNED & nFlags) {
        return;
    } 
    // Otherwise, we mark it as spawned and continue.
    nFlags = nFlags | _SPAWN_FLAGS_SPAWNED;

    // Determine how long the spawns should remain spawned.
    //int nMinDuration = GetLocalInt(oWP, _WP_MIN_SPAWN_DURATION);
    //int nMaxDuration = GetLocalInt(oWP, _WP_MAX_SPAWN_DURATION);
    //int nDuration = Random(nMaxDuration - nMinDuration + 1) + nMinDuration;
	//      Duration, how is this enforced?  Delaycommand for despawn?
	
    // Erase the records of the last spawns to come from this point ??

    // Find and spawn/despawn waypoints.
    //object oSpawnWP = GetLocalObject(oWP, _WP_SPAWN_WAYPOINT);
    //object oDespawnWP = GetLocalObject(oWP, _WP_DESPAWN_WAYPOINT);

    // Get the object type of this spawn point.
    int nObjectType = GetLocalInt(oWP, _WP_SPAWN_TYPE);

    // Get the spawn's resref and group numbers.
    int nNums = GetLocalInt(oWP, _SPAWN_NUMS);

    // Determine the number of objects spawned.
    int nMin = GetPiecewiseInteger(nNums, _SPAWN_NUMS_RESREFS_MIN_START, _SPAWN_NUMS_RESREFS_MIN_END);
    int nMax = GetPiecewiseInteger(nNums, _SPAWN_NUMS_RESREFS_MAX_START, _SPAWN_NUMS_RESREFS_MAX_END);
    int nNumSpawned = Random(nMax - nMin + 1) + nMin;

    // Determine the location of spawned objects.
    location lLoc = GetLocation(oWP);
	int nOffsiteChild = FALSE;
    float fRandomSpawnRange = GetLocalFloat(oWP, _WP_SPAWN_RANDOM_RANGE);
	float fRandomSpawnRadius = GetLocalFloat(oWP, _WP_SPAWN_RANDOM_RADIUS);
	if (fRandomSpawnRange > 0.0) {
	   lLoc = _RandomizeLocation(lLoc, fRandomSpawnRange);	   
	   nOffsiteChild = TRUE;
	}
	
	// Save the location of the spawn point so other scripts can access it.
	SetLocalLocation(oWP, _SPAWN_LAST_LOCATION, lLoc);

    // Do the spawning for the list of random resrefs.
    int nNumChoices = GetPiecewiseInteger(nNums, _SPAWN_NUMS_NUM_RESREFS_START, _SPAWN_NUMS_NUM_RESREFS_END);
    int i;
    for(i=0; i<nNumSpawned; i++) {
        // Choose a resref index.
        int nNumToSpawn = Random(nNumChoices) + 1;
        string sResRef = GetLocalString(oWP, _WP_SPAWN_RESREF_RANDOM_ARRAY + IntToString(nNumToSpawn));
		// Spawn that resref of object type defined by local int _WP_SPAWN_TYPE, randomizing location if appropriate.
        if (fRandomSpawnRadius > 0.0) {
		    _SpawnObject(sResRef, nObjectType, oWP, _RandomizeLocation(lLoc, fRandomSpawnRadius), nFlags, TRUE);
        } else _SpawnObject(sResRef, nObjectType, oWP, lLoc, nFlags, nOffsiteChild);
    }

	int nTotalChildren = i;
    // Do the spawning for the list of resrefs which always spawn.
    i=1;
    while(1) {
        string sResRef = GetLocalString(oWP, _WP_SPAWN_RESREF_ARRAY + IntToString(i));
        if(sResRef == "") {
            break;
        }
		// Spawn that resref of object type defined by local int _WP_SPAWN_TYPE, randomizing loction if appropriate.
        if (fRandomSpawnRadius > 0.0) {
		  _SpawnObject(sResRef, nObjectType, oWP, _RandomizeLocation(lLoc, fRandomSpawnRadius), nFlags, TRUE);
        } else _SpawnObject(sResRef, nObjectType, oWP, lLoc, nFlags, nOffsiteChild);
        i++;
    }
    nTotalChildren = nTotalChildren + i;
    // Run the spawn groups which always spawn.
    i=1;
    while(1) {
        string sSpawnGroup = GetLocalString(oWP, _WP_SPAWN_GROUP_ARRAY + IntToString(i));
        if(sSpawnGroup == "") {
            break;
        }
        ACR_SpawnGroup(sSpawnGroup, oWP);
        i++;
    }

    // Find the number of random spawn groups we want to run, and run them.
    nMin = GetPiecewiseInteger(nNums, _SPAWN_NUMS_GROUP_MIN_START, _SPAWN_NUMS_GROUP_MIN_END);
    nMax = GetPiecewiseInteger(nNums, _SPAWN_NUMS_GROUP_MAX_START, _SPAWN_NUMS_GROUP_MAX_END);
    nNumChoices = GetPiecewiseInteger(nNums, _SPAWN_NUMS_NUM_RESREFS_START, _SPAWN_NUMS_NUM_RESREFS_END);
    nNumSpawned = Random(nMax - nMin + 1) + nMin;
    for(i=0; i<nNumSpawned; i++) {
        int nNumToSpawn = Random(nNumChoices) + 1;
        ACR_SpawnGroup(GetLocalString(oWP, _WP_SPAWN_GROUP_RANDOM_ARRAY + IntToString(i)), oWP);
    }

    // Run the post-spawn scripts, if any.
    i=1;
    while(1) {
        string sScript = GetLocalString(oWP, _WP_SPAWN_SCRIPT_ARRAY + IntToString(i));
        if(sScript == "") {
            break;
        }
        ExecuteScript(sScript, oWP);
        i++;
    }

    // Play the VFX.
    int nVFX = GetLocalInt(oWP, _WP_SPAWN_VFX);
    if(nVFX) {
        ApplyEffectAtLocation(DURATION_TYPE_INSTANT, EffectVisualEffect(nVFX), lLoc);
    }

    // Play the spawn sound effect.
    AssignCommand(oWP, PlaySound(GetLocalString(oWP, _WP_SPAWN_SFX)) );
    
	int nChildren = GetLocalInt(oWP, _SPAWNED_OBJECT_ARRAY_LENGTH);
    // Lets save any changes to flags & values, and exit.
    
	if (nChildren == 0) {
	   // no children were actually spawned (perhaps due to prespawn prediction or
	   //  offsite conflicts with SPAWN_IN_SIGHT settings.  Mark the point as not
	   //  spawned, so it will try again next heartbeat.
	   nFlags = nFlags & ~_SPAWN_FLAGS_SPAWNED;
	   ACR_PrintDebugMessage("Spawn point "+GetName(oWP)+" was aborted due to all children being within sight of a PC or PC arrival point.", _SPAWN_SYSTEM_NAME, DEBUG_LEVEL_INFO);
	}
	SetLocalInt(oWP, _SPAWN_FLAGS, nFlags);
	SetLocalInt(oWP, _SPAWN_CHILD_COUNT, nChildren);	
}

void _StartSpawnAreaHeartbeat(object oArea, int nAreaFlags) {

    if(nAreaFlags & _SPAWN_AREA_FLAG_ACTIVE) {
        // The area is already active, and therefore being serviced by another
        // heartbeat.
        return;
    }
    // The area is not active, lets change that.
    SetLocalInt(oArea, _SPAWN_AREA_FLAGS, nAreaFlags | _SPAWN_AREA_FLAG_ACTIVE);
    ACR_PrintDebugMessage("Starting " + GetName(oArea) + "'s spawn heartbeat.", _SPAWN_SYSTEM_NAME, DEBUG_LEVEL_INFO);
    DelayCommand(GetRefreshDelay(), _SpawnAreaHeartbeat(oArea));
}

float _GetSecondsSinceSpawnRefresh(object oArea) {
    return IntToFloat(ACR_GetGameSecondsSinceStart() - GetLocalInt(oArea, _SPAWN_LAST_REFRESHED));
}

void _DespawnAreaPoll(object oArea) {
    float nLastRefreshed = _GetSecondsSinceSpawnRefresh(oArea) + 1.0;
    if( nLastRefreshed > GetDespawnDelay()) {
        _DespawnArea(oArea);
    }
}

void _SpawnAreaHeartbeat(object oArea) {
    ACR_PrintDebugMessage(GetName(oArea) + "'s spawn heartbeat entered.", _SPAWN_SYSTEM_NAME, DEBUG_LEVEL_INFO);	
	int nToday2 = ACR_GetGameDaysSinceStart();
	// SendMessageToAllDMs("---Base functions call it hour "+IntToString(GetTimeHour())+", day "+IntToString(GetCalendarDay())+", month "+IntToString(GetCalendarMonth())+", year "+IntToString(GetCalendarYear()));
    if(!GetArePCsInArea(oArea)) {
        // If there aren't any PCs in the area, there is no reason to do
        // anything. Deactivate the area, start the timer to despawn it, and
        // set its state to deactivated.
        DelayCommand( GetDespawnDelay(), _DespawnAreaPoll(oArea) );
        int nFlags = GetLocalInt(oArea, _SPAWN_AREA_FLAGS);
        SetLocalInt(oArea, _SPAWN_AREA_FLAGS, nFlags & ~_SPAWN_AREA_FLAG_ACTIVE);
        ACR_PrintDebugMessage(GetName(oArea) + "'s spawn heartbeat deactivated - no PCs in area.", _SPAWN_SYSTEM_NAME, DEBUG_LEVEL_INFO);
        return;
    }    
    // Otherwise, lets refresh the spawns and schedule the next heartbeat.
    _RefreshArea(oArea);
    DelayCommand( GetRefreshDelay(), _SpawnAreaHeartbeat(oArea) );
}

void _QuickBuff(object oCaster, int nSpell, object oTarget = OBJECT_INVALID) {
	if(oTarget == OBJECT_INVALID) oTarget = oCaster;
	AssignCommand(oCaster, ActionCastSpellAtObject(nSpell, oCaster, METAMAGIC_ANY, FALSE, 0, PROJECTILE_PATH_TYPE_DEFAULT, TRUE));
}

void ActivateLongTermBuffs(object oCaster) {

    // Cast protection from good/evil based on alignment.
    if(GetAlignmentGoodEvil(oCaster) == ALIGNMENT_EVIL) {
		_QuickBuff(oCaster, SPELL_PROTECTION_FROM_GOOD);
    } else {
		_QuickBuff(oCaster, SPELL_PROTECTION_FROM_EVIL);
    }

    // Buff armor, if the creature has any.
    object oItem = GetItemInSlot(INVENTORY_SLOT_CHEST);
    if(oItem != OBJECT_INVALID) {
		_QuickBuff(oCaster, SPELL_MAGIC_VESTMENT, oItem);
    }

    // Buff the shield, if the creature has one.
    object oLeftHandItem = GetItemInSlot(INVENTORY_SLOT_LEFTHAND, oCaster);
    object oRightHandItem = GetItemInSlot(INVENTORY_SLOT_RIGHTHAND, oCaster);
    int nLeftItemType = GetBaseItemType(oLeftHandItem);
    int nRightItemType = GetBaseItemType(oRightHandItem);
    if(GetIsItemShield(oLeftHandItem)) {
		_QuickBuff(oCaster, SPELL_MAGIC_VESTMENT, oLeftHandItem);
    }

    // FIX ME!! Weapon-buffing should be more intelligent. But we need to be
    // able to tell what a weapon is.
	_QuickBuff(oCaster, SPELL_KEEN_EDGE);
	if(GetHasSpell(SPELL_GREATER_MAGIC_WEAPON, oCaster))
		_QuickBuff(oCaster, SPELL_GREATER_MAGIC_WEAPON);
		else _QuickBuff(oCaster, SPELL_MAGIC_WEAPON);
	_QuickBuff(oCaster, SPELL_WEAPON_OF_IMPACT);

	_QuickBuff(oCaster, SPELL_BARKSKIN);
	_QuickBuff(oCaster, SPELL_SPIDERSKIN);
	_QuickBuff(oCaster, SPELL_CONVICTION);
	
	if(GetHasSpell(SPELL_PROTECTION_FROM_ENERGY, oCaster))
		_QuickBuff(oCaster, SPELL_PROTECTION_FROM_ENERGY);
		else _QuickBuff(oCaster, SPELL_ENDURE_ELEMENTS);
	
	_QuickBuff(oCaster, SPELL_FREEDOM_OF_MOVEMENT);
	_QuickBuff(oCaster, SPELL_HEROISM);
	
	if(GetHasSpell(SPELL_IMPROVED_MAGE_ARMOR, oCaster))
		_QuickBuff(oCaster, SPELL_IMPROVED_MAGE_ARMOR);
		else _QuickBuff(oCaster, SPELL_MAGE_ARMOR);	
	
	if(GetHasSpell(SPELL_GREATER_PLANAR_BINDING, oCaster))
		_QuickBuff(oCaster, SPELL_GREATER_PLANAR_BINDING);
		else if(GetHasSpell(SPELL_PLANAR_BINDING, oCaster))
			_QuickBuff(oCaster, SPELL_PLANAR_BINDING);
			else if(GetHasSpell(SPELL_PLANAR_ALLY, oCaster))
				_QuickBuff(oCaster, SPELL_PLANAR_ALLY);
			 	else _QuickBuff(oCaster, SPELL_LESSER_PLANAR_BINDING);
		
	_QuickBuff(oCaster, SPELL_GREATER_RESISTANCE);
	_QuickBuff(oCaster, SPELL_MIND_BLANK);
	_QuickBuff(oCaster, SPELL_ONE_WITH_THE_LAND);
	_QuickBuff(oCaster, SPELL_PREMONITION);
	_QuickBuff(oCaster, SPELL_PROTECTION_FROM_SPELLS);
	_QuickBuff(oCaster, SPELL_PROTECTION_FROM_ARROWS);
	_QuickBuff(oCaster, SPELL_GREATER_BULLS_STRENGTH);
	_QuickBuff(oCaster, SPELL_GREATER_CATS_GRACE);
	_QuickBuff(oCaster, SPELL_GREATER_EAGLE_SPLENDOR);
	_QuickBuff(oCaster, SPELL_GREATER_BEARS_ENDURANCE);
	_QuickBuff(oCaster, SPELL_GREATER_FOXS_CUNNING);
	_QuickBuff(oCaster, SPELL_GREATER_OWLS_WISDOM);
	_QuickBuff(oCaster, SPELL_SEE_INVISIBILITY);
	
	if(GetHasSpell(SPELL_PREMONITION, oCaster))
		_QuickBuff(oCaster, SPELL_PREMONITION);
		else if(GetHasSpell(SPELL_GREATER_STONESKIN, oCaster))
			_QuickBuff(oCaster, SPELL_GREATER_STONESKIN);
			else _QuickBuff(oCaster, SPELL_STONESKIN);
	
	// Delay party buffs a bit in case this guy has buddies spawning in next to him.
	DelayCommand(6.0, _QuickBuff(oCaster, SPELL_MASS_CAMOFLAGE));
}

object _SpawnObject(string sResRef, int nObjectType, object oWP, location lLoc, int nFlags, int nAlternate) {
    // if the object is not being spawned at it's waypoint location, we need to make sure
	// the actual spawn-in location isn't violating the "in PC sight" guidelines.
    if(nAlternate && !(nFlags & _SPAWN_FLAGS_IN_PC_SIGHT)) {
	   object oNeighbor = GetNearestCreatureToLocation(CREATURE_TYPE_PLAYER_CHAR, PLAYER_CHAR_IS_PC, lLoc);
	   if ((oNeighbor != OBJECT_INVALID) && (GetDistanceBetweenLocations(lLoc, GetLocation(oNeighbor)) <= PC_PERCEPTION_RANGE )) { // ACR_GetPCVisualRange() )) {
	      ACR_PrintDebugMessage("Object "+sResRef+" was not spawned by "+GetName(oWP)+" due to proximity of PC "+GetName(oNeighbor), _SPAWN_SYSTEM_NAME, DEBUG_LEVEL_INFO);
	      return OBJECT_INVALID;
	   }
	   if (GetPrespawnPrediction()) {
	      object oTestWP = GetNearestObjectToLocation(OBJECT_TYPE_WAYPOINT, lLoc);
		  int nWP_Index = 1;
		  while ((oTestWP != OBJECT_INVALID) && (GetDistanceBetweenLocations(lLoc, GetLocation(oTestWP)) <= PC_PERCEPTION_RANGE)) { // ACR_GetPC_VisualRange() )) {
		    if (GetTag(oTestWP) == "ACR_SA_WP") {
			   ACR_PrintDebugMessage("Object "+sResRef+" was not spawned by "+GetName(oWP)+" due to proximity to predicted AT arrival point.", _SPAWN_SYSTEM_NAME, DEBUG_LEVEL_INFO);
			   return OBJECT_INVALID;
			} else {
			   nWP_Index = nWP_Index + 1;
			   oTestWP = GetNearestObjectToLocation(OBJECT_TYPE_WAYPOINT, lLoc, nWP_Index);
			}
	      }
	   }
	} 
	
	object oSpawned = OBJECT_INVALID;
	if(nObjectType == SPECIAL_OBJECT_TYPE_TRAP)
	{
		vector vPos = GetPositionFromLocation(lLoc);
		_PassToCSharp(TRAP_EVENT_CREATE_GENERIC, vPos.x, vPos.y, vPos.z, GetAreaFromLocation(lLoc), -1, -1, -1.0f, -1, -1, -1, -1, -1, 1, OBJECT_INVALID, ALIGNMENT_ALL, RACIAL_TYPE_ALL, 1, -1, -1, sResRef);
		_AddTrapToSpawnPoint(oWP, GetLocalString(GetModule(), "ACR_TRAPS_LAST_TAG"));
		oSpawned = GetObjectByTag(GetLocalString(GetModule(), "ACR_TRAPS_LAST_TAG"));
	}
	else
	{
		oSpawned = CreateObject(nObjectType, sResRef, lLoc, nFlags & _SPAWN_FLAGS_WITH_ANIMATION);

		// Check to make sure it spawned ok, print an error and exit if not.
		if(!GetIsObjectValid(oSpawned)) {
			// Spawn failed, CreateObject() didn't work!
			int nNums = GetLocalInt(oWP, _SPAWN_NUMS);
			ACR_PrintDebugMessage("Error spawning resref " + sResRef + " of object type " + GetObjectTypeName(nObjectType) + ".\nSpawn nums: " + IntToHexString(nNums) + "\nSpawn Flags: " + IntToHexString(nFlags), _SPAWN_SYSTEM_NAME, DEBUG_LEVEL_INFO);
			return OBJECT_INVALID;
		}

		// Set the spawned object's name.
		// disabled for now, SetFirstName / GetFirstName are acting unpredictably
		//string sName = GetLocalString(oWP, _WP_SPAWN_NAME);
		//if(sName == "") {
		//    sName = GetFirstName(oSpawned);
		//}
		//SetFirstName(oSpawned, GetLocalString(oWP, _WP_SPAWN_NAME_PREFIX)
		//        + sName
		//        + GetLocalString(oWP, _WP_SPAWN_NAME_SUFFIX) );

		// If it should be in stealth mode, place it there.
		if(nFlags & _SPAWN_IN_STEALTH) {
			SetActionMode(oSpawned, ACTION_MODE_STEALTH, 1);
		}

		// If it should be in detect mode, place it there.
		if(nFlags & _SPAWN_IN_DETECT) {
			SetActionMode(oSpawned, ACTION_MODE_DETECT, 1);
		}

		// If this creature should buff himself, do it.
		if(nFlags & _SPAWN_BUFFED) {
			ActivateLongTermBuffs(oSpawned);
		}

		// Play the spawn animation.
		PlayAnimation( GetLocalInt(oWP, _WP_SPAWN_ANIMATION) );

		// Play the spawn in VFX.
		ApplyEffectAtLocation(DURATION_TYPE_INSTANT, EffectVisualEffect( GetLocalInt(oWP, _WP_SPAWN_IN_VFX) ), GetLocation(oSpawned));

		// Play the spawn in SFX.
		AssignCommand(oSpawned, PlaySound(GetLocalString(oWP, _WP_SPAWN_IN_SFX)) );

		// Determine facing.
		if(nFlags & _SPAWN_FLAGS_RANDOM_FACING) {
			// Spawn facing is random.
			AssignCommand(oSpawned, SetFacing(ACR_RandomFloat(0.0, 360.0)) );
		} else {
			// Spawn facing is not random, do nothing.
		}
		
		// Colorize name if needed.
		if ( GetLocalString( oSpawned, ACR_COLOR_NAME ) != "" ) {
			SetFirstName( oSpawned, "<C='" + GetLocalString( oSpawned, ACR_COLOR_NAME ) + "'>" + GetName( oSpawned ) + "</C>" );
			SetLastName( oSpawned, "" );
		}

		// Set the faction.
		// FIX ME !! Come NWN2.
		// string sSpawnFaction = GetLocalString(oWP, _WP_SPAWN_FACTION);
	}
	
	// Run the spawn-in scripts, if any.
	int i = 1;
	while(1) {
		string sScript = GetLocalString(oWP, _WP_SPAWN_IN_SCRIPT_ARRAY + IntToString(i));
		if(sScript == "") {
			break;
		}
		ExecuteScript(sScript, oSpawned);
		i++;
	}
	_AddObjectToSpawnPoint(oWP, oSpawned);

    // Spit debug information to logfile
    if (GetLocalInt(GetModule(), ACR_LOG_SPAWNS)) {
        WriteTimestampedLogEntry("ACR_Spawn: ACR_SpawnObject "+sResRef+" - "+ACR_SpawnPointToString(oWP));
    }

    return oSpawned;
}



location _RandomizeLocation(location lCenter, float fBound) {

  float fDirection = ACR_RandomFloat(0.0, 360.0);
  vector vCenter = GetPositionFromLocation(lCenter);
  float fRange = ACR_RandomFloat(0.0, fBound);
  float fXmod = sin(fDirection) * fRange;
  float fYmod = cos(fDirection) * fRange;
  vector vSpawnTarget = Vector(vCenter.x+fXmod, vCenter.y+fYmod, vCenter.z);

  return Location(GetAreaFromLocation(lCenter), vSpawnTarget, GetFacingFromLocation(lCenter));
}



void _RespawnPoll(object oWP) {
  // called by a delaycommand, from the _GetShouldSpawnBeActive(), to enable reactivation of the spawn point
  //  with the next area heartbeat (if appropriate).
  int nRespawnFlag = GetLocalInt(oWP, _SPAWN_FLAGS);
  nRespawnFlag = nRespawnFlag & ~_SPAWN_FLAGS_WAIT_FOR_RESPAWN;
  ACR_PrintDebugMessage("Reactivating respawn flag for "+GetName(oWP), _SPAWN_SYSTEM_NAME, DEBUG_LEVEL_INFO);
  SetLocalInt(oWP, _SPAWN_FLAGS, nRespawnFlag);
  return;
}


void _SpawnPointInitializationCheck(int nNum) {
    int nInit = 0;
    object oArea;

	for (ObjectToInt(oArea = GetFirstArea()); oArea != OBJECT_INVALID; ObjectToInt(oArea = GetNextArea()))
		nInit += GetLocalInt(oArea, _SPAWN_WAYPOINT_ARRAY_LENGTH);

    if(nInit != nNum) {
        ACR_PrintDebugMessage("Spawn initialization error! " + IntToString(nNum) + " spawn points scheduled for initialization, but only " + IntToString(nInit) + " initialized! Uninitialized spawn points will NOT work. Please contact ALFA's tech team with this information.", _SPAWN_SYSTEM_NAME, DEBUG_LEVEL_FATAL);
    } else {
        ACR_PrintDebugMessage("Spawn point initialization successful. " + IntToString(nNum) + " spawn points initialized.", _SPAWN_SYSTEM_NAME, DEBUG_LEVEL_INFO);
    }
}


location _GetNewLocationFromDirectionAndFacing(location lStart, float fDist, float fAngle, float fPointFacing) {

  vector vStartPos = GetPositionFromLocation(lStart);
  float fxMod2 = sin(fAngle) * fDist;
  float fyMod2 = cos(fAngle) * fDist;
  vector vNewPos = Vector(vStartPos.x+fxMod2, vStartPos.y+fyMod2, vStartPos.z); 
  return Location(GetAreaFromLocation(lStart), vNewPos, fPointFacing);
}


location _GetNewLocationFromVectorAndFacing(location lOrigin, float fXOffset, float fYOffset, float fOrientAngle) {
  
  vector vOldVector = GetPositionFromLocation(lOrigin);
  vector vNewVector = Vector(vOldVector.x+fXOffset, vOldVector.y+fYOffset, vOldVector.z);
  return Location(GetAreaFromLocation(lOrigin), vNewVector, fOrientAngle);
}

void _AddObjectToSpawnPoint(object oWP, object oObject)
{
	int i;

	// Add this creature to the list of creatures spawned from this waypoint and
	// area.

	i = GetLocalInt(oWP, _SPAWNED_OBJECT_ARRAY_LENGTH);
	SetLocalArrayObject(oWP, _SPAWNED_OBJECT_ARRAY, i, oObject);
	SetLocalInt(oWP, _SPAWNED_OBJECT_ARRAY_LENGTH, i+1);

	// Add a pointer back to the waypoint, for death reporting.
	SetLocalObject(oObject, _SPAWN_PARENT_WP, oWP);
}

void _AddTrapToSpawnPoint(object oWP, string sTag)
{
	int count = 0;
	string root = "ACR_TRAP_";
	while(GetLocalString(oWP, root + IntToString(count)) != "")
	{
		count++;
	}
	
	SetLocalString(oWP, root + IntToString(count), sTag);
}

#endif