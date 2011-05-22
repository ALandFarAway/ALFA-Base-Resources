// gr_pc_spawn
/*
	the spawn-like script for PC's
	Sets up listening patterns and variables.
*/
// ChazM 9/13/06
// ChazM 9/14/06 Added Set DoneSpawn
// ChazM 9/20/06 - fixed inc.
// DBR 9/21/06 - Added a class check before setting the 'Open Lock' and 'Disable Trap' behavior.

#include "x0_inc_henai"
#include "ginc_math"

// this is run on the PC, so OBJECT_SELF != module for this funciton.
void main()
{
	PrettyDebug(GetName(OBJECT_SELF) + ": PC Spawn script run!");
	// Always set up listening patterns
	
    // Sets up the special henchmen listening patterns (gb_setassociatelistenpatterns)
    SetAssociateListenPatterns();

	// Set standard combat listening patterns (x0_i0_spawncond)
	SetListeningPatterns();
	
    // Set additional henchman listening patterns (x0_inc_henai)
    bkSetListeningPatterns();

	// Only set up variables if we haven't done this before.
	int iDoneSpawn = GetLocalInt(OBJECT_SELF, "DoneSpawn");
	if (iDoneSpawn)
		return;
	SetLocalInt(OBJECT_SELF, "DoneSpawn", TRUE);
		
    // Default behavior for henchmen at start
    SetAssociateState(NW_ASC_SCALED_CASTING);
    SetAssociateState(NW_ASC_HEAL_AT_50);
	if (GetLevelByClass(CLASS_TYPE_ROGUE) > 0)
	{
    	SetAssociateState(NW_ASC_RETRY_OPEN_LOCKS);
    	SetAssociateState(NW_ASC_DISARM_TRAPS);
	}		

	// PC's won't use items by default when not controlled. 
	// This way they have someplace to put their scrolls and potions w/o them dissappearing.
	SetLocalIntState(OBJECT_SELF, N2_TALENT_EXCLUDE, TALENT_EXCLUDE_ITEM, TRUE);
	    
    // * July 2003. Set this to true so henchmen
    // * will hopefully run off a little less often
    // * by default
    // * September 2003. Bad decision. Reverted back
    // * to original. This mode too often looks like a bug
    // * because they hang back and don't help each other out.
	
	// Players (like companions) defaulted to Defend.
    SetAssociateState(NW_ASC_MODE_DEFEND_MASTER, TRUE);
    SetAssociateState(NW_ASC_DISTANCE_2_METERS);

    // Use melee weapons by default
    SetAssociateState(NW_ASC_USE_RANGED_WEAPON, FALSE);

    // Set starting location
    //SetAssociateStartLocation();

    // Set respawn location
    //SetRespawnLocation();

    // For some general behavior while we don't have a master,
    // let's do some immobile animations
    SetSpawnInCondition(NW_FLAG_IMMOBILE_AMBIENT_ANIMATIONS);
	
}