////////////////////////////////////////////////////////////////////////////////
//
//  System Name : ALFA Core Rules
//     Filename : acr_1sc_spawn_i
//       Author : Paazin
//
//
//  Dependencies external of nwscript:
//  acr_spawn_i
//
//  Description
//  Handles various elements for the phat_loot automatic treasure
//  generation system.
//
////////////////////////////////////////////////////////////////////////////////

#ifndef ACR_1SC_SPAWN_I
#define ACR_1SC_SPAWN_I

// Local Variables on AOE object:
//
// PL_SPAWNABLE		(int)		Spawn a placeable
// PL_NO_TRAP		(int)		Do not trap/lock this placeable
// PL_RESREF		(string)	Resref of placable to spawn (otherwise random)
// PL_SEARCH_DC		(int)		Custom DC for finding this loot item
// PL_WP		(object)	Waypoint assocated to this
// PL_CHECK_<PID>	(int)		Player has already done search check

// Includes
// 

#include "acr_spawn_i"
#include "acr_effects_i"

// Constants
//

const string _AOE_LOOT_DETECT_INDEX = "aoe_loot_detect_index";
const string _AOE_LOOT_DETECT_PREFIX = "aoe_loot_detect_effect_";

// Declaration
// 

// public

// Return AOE object for loot detector with a given radius (defaults to 10.0f)
object ACR_SpawnLootDetector(float fRadius = 10.0f);

// private

// Return AOE phat loot spawn detection effect with a given radius
effect _EffectLootDetection(float fRadius);

// Implementation
// 

effect _EffectLootDetection(float fRadius)
{
	int index = GetGlobalInt(_AOE_LOOT_DETECT_INDEX) + 1;
	SetGlobalInt(_AOE_LOOT_DETECT_INDEX, index);



	return EffectAreaOfEffect(ACR_GetAOERadiusID(fRadius), "1sc_trg_onenter", "****", "****", _AOE_LOOT_DETECT_PREFIX+IntToString(index));
}

object ACR_SpawnLootDetector(float fRadius)
{
	object o, oWP;
	int aoe_index, search_dc;
	string sResref;

	oWP = OBJECT_SELF;

	ApplyEffectAtLocation(DURATION_TYPE_PERMANENT, _EffectLootDetection(fRadius), ACR_GetSpawnLocation(oWP));

	aoe_index = GetGlobalInt(_AOE_LOOT_DETECT_INDEX);

	// Return created detector
	o = GetObjectByTag(_AOE_LOOT_DETECT_PREFIX + IntToString(aoe_index));

	// preset some DC
	SetLocalInt(o, "PL_SEARCH_DC", 15 + Random(11) - Random(11));

	// preset some placeable resref
	switch (Random(5)) {
		case 0:
		case 1:
			sResref = "phat_lewt_chest_small";
			break;
		case 2:
		case 3:
			sResref = "phat_lewt_chest_large";
			break;
		default:
			sResref = "phat_lewt_crate";
	}

	SetLocalString(o, "PL_RESREF", sResref);

	SetLocalObject(o, "PL_WP", oWP);

	DestroyObject(ACR_SpawnObjectAtLocation("c_faction_pig", OBJECT_TYPE_CREATURE, GetLocation(oWP), oWP));

	WriteTimestampedLogEntry("Spawning "+_AOE_LOOT_DETECT_PREFIX + IntToString(aoe_index));

	ACR_AddObjectToSpawnPoint(oWP, o);
	

	return o;
}

#endif