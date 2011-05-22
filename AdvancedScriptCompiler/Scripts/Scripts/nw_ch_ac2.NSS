//::///////////////////////////////////////////////
//:: Associate: On Percieve
//:: NW_CH_AC2
//:: Copyright (c) 2001 Bioware Corp.
//:://////////////////////////////////////////////
//:://////////////////////////////////////////////
//:: Created By: Preston Watamaniuk
//:: Created On: Nov 19, 2001
//:://////////////////////////////////////////////
// DBR - 10/25/06 - Added checks for Defend Master new behavior - associates do not attack those that are not in combat.
// ChazM 2/21/07 Script deprecated. Use gb_assoc_* scripts instead.

#include "ginc_event_handlers"

void main()
{
    ConvertToAssociateEventHandler(CREATURE_SCRIPT_ON_NOTICE, SCRIPT_ASSOC_PERCEP);
}    
/*

#include "X0_INC_HENAI"
void main()
{
    //This is the equivalent of a force conversation bubble, should only be used if you want an NPC
    //to say something while he is already engaged in combat.
    if(GetSpawnInCondition(NW_FLAG_SPECIAL_COMBAT_CONVERSATION))
    {
        ActionStartConversation(OBJECT_SELF);
    }
    
    // * July 2003
    // * If in Stealth mode, don't attack enemies. Wait for player to attack or
    // * for you to be attacked. (No point hiding anymore if you've been detected)
    if(!GetAssociateState(NW_ASC_MODE_STAND_GROUND) && GetActionMode(OBJECT_SELF, ACTION_MODE_STEALTH)== FALSE)
    {
        //Do not bother checking the last target seen if already fighting
        if(!GetIsObjectValid(GetAttemptedAttackTarget()) &&
           !GetIsObjectValid(GetAttackTarget()) &&
           !GetIsObjectValid(GetAttemptedSpellTarget()))
        {
            //Check if the last percieved creature was actually seen
            if(GetLastPerceptionSeen())
            {
                if(GetIsEnemy(GetLastPerceived()))
                {
					//DBR 10/15/06 - 'defending' associates should not attack those are not in combat.
					if (!GetAssociateState(NW_ASC_MODE_DEFEND_MASTER) || (GetIsInCombat(GetLastPerceived())))								
					{
	                    SetFacingPoint(GetPosition(GetLastPerceived()));
    	                HenchmenCombatRound(OBJECT_INVALID);
					}
                }
                //Linked up to the special conversation check to initiate a special one-off conversation
                //to get the PCs attention
                else if(GetSpawnInCondition(NW_FLAG_SPECIAL_CONVERSATION) && GetIsPC(GetLastPerceived()))
                {
                    ActionStartConversation(OBJECT_SELF);
                }
            }
        }
    }
    if(GetSpawnInCondition(NW_FLAG_PERCIEVE_EVENT))
    {
        SignalEvent(OBJECT_SELF, EventUserDefined(1002));
    }
}
*/    
