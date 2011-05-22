// gb_comp_spawn
/*
	companion On Spawn
*/
// ChazM 12/5/05
// BMA-OEI 12/19/05 spawn as killable companions
// ChazM 6/15/06 - default follow distance changed back to 2 meters
// ChazM 8/3/06 - Companions default to defend master mode
// ChazM 8/21/06 - removed kinc_globals include
// ChazM 8/24/06 - changed check for setting associate state.
// ChazM 8/24/06 - changed default for open locks and disarm traps to off
// ChazM 9/8/06 - chaged casting default to SCALED_CASTING
// ChazM 9/18/06 - If I have any levels in rogue then default to opening locks and finding traps
// BMA-OEI 10/19/06 - Roster members default N2_COMBAT_MODE_USE_DISABLED
// ChazM 2/12/07 - added the option for a spawn script
// ChazM 3/8/07 - moved IdentifyEquippedItems() to ginc_item

#include "x0_inc_henai"
#include "x2_inc_banter"
#include "ginc_companion"
#include "ginc_item"            


void main()
{
    string sAreaTag = GetTag(GetArea(OBJECT_SELF));
    string sModuleTag = GetTag(GetModule());
    string sMyTag = GetTag(OBJECT_SELF);

    // Sets up the special henchmen listening patterns (gb_setassociatelistenpatterns)
    SetAssociateListenPatterns();

	// Set standard combat listening patterns (x0_i0_spawncond)
	SetListeningPatterns();
	
    // Set additional henchman listening patterns (x0_inc_henai)
    bkSetListeningPatterns();

    // Default behavior for henchmen at start
    SetAssociateState(NW_ASC_SCALED_CASTING);
    SetAssociateState(NW_ASC_HEAL_AT_50);
	
	if (GetLevelByClass(CLASS_TYPE_ROGUE) > 0)
	{
    	SetAssociateState(NW_ASC_RETRY_OPEN_LOCKS);
    	SetAssociateState(NW_ASC_DISARM_TRAPS);
	}		
    
    // * July 2003. Set this to true so henchmen
    // * will hopefully run off a little less often
    // * by default
    // * September 2003. Bad decision. Reverted back
    // * to original. This mode too often looks like a bug
    // * because they hang back and don't help each other out.
	//
	// companions defaulted to defend master - hoping not a repeat
	// of previous bad desicion...
	//if (GetAssociateType(OBJECT_SELF) == ASSOCIATE_TYPE_NONE) // won't work - henchmen won't be set yet as associates
	//if (GetCompanionNumberByTag(GetTag(OBJECT_SELF)) > 0) // don't want dependency on kinc_companion
	if (GetIsRosterMember(OBJECT_SELF))
	{
    	SetAssociateState(NW_ASC_MODE_DEFEND_MASTER, TRUE);
		
		// BMA-OEI 10/19/06 - Disable combat mode switching during combat
		SetLocalInt(OBJECT_SELF, N2_COMBAT_MODE_USE_DISABLED, TRUE);
	}
		
    SetAssociateState(NW_ASC_DISTANCE_2_METERS);

    // Use melee weapons by default
    SetAssociateState(NW_ASC_USE_RANGED_WEAPON, FALSE);

    // Set starting location
    SetAssociateStartLocation();

    // Set respawn location
    SetRespawnLocation();

    // For some general behavior while we don't have a master,
    // let's do some immobile animations
    SetSpawnInCondition(NW_FLAG_IMMOBILE_AMBIENT_ANIMATIONS);

    // * September 2003
	IdentifyEquippedItems();
 
	// Companion corpses do not decay
	SetIsDestroyable( FALSE, TRUE, TRUE );
    
	//option for a spawn script (ease of AI hookup)
	string sSpawnScript=GetLocalString(OBJECT_SELF,"SpawnScript");
	if (sSpawnScript!="")
		ExecuteScript(sSpawnScript,OBJECT_SELF);
   
}