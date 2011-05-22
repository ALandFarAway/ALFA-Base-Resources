//::///////////////////////////////////////////////
//:: Associate: On Spawn In
//:: NW_CH_AC9
//:: Copyright (c) 2001 Bioware Corp.
//:://////////////////////////////////////////////
//:://////////////////////////////////////////////
//:: Created By: Preston Watamaniuk
//:: Created On: Nov 19, 2001
//:://////////////////////////////////////////////
// ChazM 5/9/06 - added spawn stuff specific to type
// ChazM 9/6/06 - changed default for open locks and disarm traps to off
// DBR 9/18/06 - Familiars are no longer cowards. They can participate in fights, 
			//and are protected by DetermineCombatRounds()'s bias for non-familiar enemies.
// ChazM 9/18/06 - If I have any levels in rogue then default to opening locks and finding traps
// DBR 10/16/06 - Put Summons, Animal Companions, and Henchmen into Defend Master mode by default.
// ChazM 2/21/07 Script deprecated. Use gb_assoc_* scripts instead.

#include "ginc_event_handlers"

void main()
{
    ConvertToAssociateEventHandler(CREATURE_SCRIPT_ON_SPAWN_IN, SCRIPT_ASSOC_SPAWN);
}    
/*
#include "X0_INC_HENAI"

void main()
{
    SetAssociateListenPatterns();//Sets up the special henchmen listening patterns

    bkSetListeningPatterns();      // Goes through and sets up which shouts the NPC will listen to.

    SetAssociateState(NW_ASC_POWER_CASTING);
    SetAssociateState(NW_ASC_HEAL_AT_50);
	
	if (GetLevelByClass(CLASS_TYPE_ROGUE) > 0)
	{
    	SetAssociateState(NW_ASC_RETRY_OPEN_LOCKS);
    	SetAssociateState(NW_ASC_DISARM_TRAPS);
	}	
		
    SetAssociateState(NW_ASC_MODE_DEFEND_MASTER, FALSE);
    SetAssociateState(NW_ASC_USE_RANGED_WEAPON, FALSE); //User ranged weapons by default if true.
    SetAssociateState(NW_ASC_DISTANCE_2_METERS);

    // April 2002: Summoned monsters, associates and familiars need to stay
    // further back due to their size.
    int nType = GetAssociateType(OBJECT_SELF);
    switch (nType)
    {
        case ASSOCIATE_TYPE_ANIMALCOMPANION:
        case ASSOCIATE_TYPE_DOMINATED:
        case ASSOCIATE_TYPE_FAMILIAR:
        case ASSOCIATE_TYPE_SUMMONED:
            SetAssociateState(NW_ASC_DISTANCE_4_METERS);
            break;

    }
	// ChazM 5/9/06 - spawn stuff specific to type 
    switch (nType)
    {
        case ASSOCIATE_TYPE_ANIMALCOMPANION:
		    SetAssociateState(NW_ASC_MODE_DEFEND_MASTER, TRUE);
            break;

        case ASSOCIATE_TYPE_DOMINATED:
            break;
		
        case ASSOCIATE_TYPE_FAMILIAR:
			// in NWN2, familiars are easily killed things that should stay out of combat.
			// DBR 9/19/06 Changing to Puppet-mode, combat AI favors non-familiar enemies, so they should be safe. 
			//SetCombatCondition(X0_COMBAT_FLAG_COWARDLY);
			SetAssociateState(NW_ASC_MODE_PUPPET);
            break;

        case ASSOCIATE_TYPE_SUMMONED:
		    SetAssociateState(NW_ASC_MODE_DEFEND_MASTER, TRUE);		
            break;

        case ASSOCIATE_TYPE_HENCHMAN:
		    SetAssociateState(NW_ASC_MODE_DEFEND_MASTER, TRUE);		
            break;
			
    }
    
//    if (GetAssociate(ASSOCIATE_TYPE_ANIMALCOMPANION, GetMaster()) == OBJECT_SELF  ||
//        GetAssociate(ASSOCIATE_TYPE_DOMINATED, GetMaster()) == OBJECT_SELF  ||
//        GetAssociate(ASSOCIATE_TYPE_FAMILIAR, GetMaster()) == OBJECT_SELF  ||
//        GetAssociate(ASSOCIATE_TYPE_SUMMONED, GetMaster()) == OBJECT_SELF)
//    {
//            SetAssociateState(NW_ASC_DISTANCE_4_METERS);
//    }
//
    // * Feb 2003: Set official campaign henchmen to have no inventory
    // SetLocalInt(OBJECT_SELF, "X0_L_NOTALLOWEDTOHAVEINVENTORY", 10) ;

    //SetAssociateState(NW_ASC_MODE_DEFEND_MASTER);
    SetAssociateStartLocation();
    // SPECIAL CONVERSATION SETTTINGS
    //SetSpawnInCondition(NW_FLAG_SPECIAL_CONVERSATION);
    //SetSpawnInCondition(NW_FLAG_SPECIAL_COMBAT_CONVERSATION);
            // This causes the creature to say a special greeting in their conversation file
            // upon Perceiving the player. Attach the [NW_D2_GenCheck.nss] script to the desired
            // greeting in order to designate it. As the creature is actually saying this to
            // himself, don't attach any player responses to the greeting.


// CUSTOM USER DEFINED EVENTS
//
//    The following settings will allow the user to fire one of the blank user defined events in the NW_D2_DefaultD.  Like the
//    On Spawn In script this script is meant to be customized by the end user to allow for unique behaviors.  The user defined
//    events user 1000 - 1010
//
    //SetSpawnInCondition(NW_FLAG_PERCIEVE_EVENT);         //OPTIONAL BEHAVIOR - Fire User Defined Event 1002
    //SetSpawnInCondition(NW_FLAG_ATTACK_EVENT);           //OPTIONAL BEHAVIOR - Fire User Defined Event 1005
    //SetSpawnInCondition(NW_FLAG_DAMAGED_EVENT);          //OPTIONAL BEHAVIOR - Fire User Defined Event 1006
    //SetSpawnInCondition(NW_FLAG_DISTURBED_EVENT);        //OPTIONAL BEHAVIOR - Fire User Defined Event 1008
    //SetSpawnInCondition(NW_FLAG_END_COMBAT_ROUND_EVENT); //OPTIONAL BEHAVIOR - Fire User Defined Event 1003
    //SetSpawnInCondition(NW_FLAG_ON_DIALOGUE_EVENT);      //OPTIONAL BEHAVIOR - Fire User Defined Event 1004
    //SetSpawnInCondition(NW_FLAG_DEATH_EVENT);            //OPTIONAL BEHAVIOR - Fire User Defined Event 1007
}
*/