// gb_comp_percep.nss
/*
	Companion OnPerception handler
	
	Based off Associate OnDamaged (X0_CH_HEN_PERCEP)
*/
// ChazM 12/5/05
// ChazM 5/18/05 reference to master now uses GetCurrentMaster() - returns master for associate or companion
// ChazM 7/11/06 added exception for force follow.
// BMA-OEI 7/14/06 -- Rewrote to preserve action queue, follow mode interruptible
// DBR - 08/03/06 added support for NW_ASC_MODE_PUPPET
// DBR - 09/08/06 - fix for companions training down a line of hostiles - added GetCurrentAction/GetNumActions check
// DBR - 09/13/06 - Removed specific target for HenchmanCombatRound() when a hostile is seen
// DBR - 10/25/06 - Added checks for Defend Master new behavior - companions do not attack those that are not in combat.


#include "X0_INC_HENAI"
#include "ginc_companion"

void OriginalHenchPercep();

void main()
{
	// 5/2/06 BDF: The segment below checks to see if the owner is in the process of casting a spell (i.e. True Name!)
	// or has any other actions queued.  If so, let's escape so that the OriginalHenchPercep() cannot inadvertantly
	// interrupt or clear any actions that the player may have queued up while they were in possession of this creature.
	// Ok to interrupt if we are just following.
	//if (GetNumActions(OBJECT_SELF) == 0)
	
	OriginalHenchPercep();
}

void OriginalHenchPercep()
{
    //This is the equivalent of a force conversation bubble, should only be used if you want an NPC
    //to say something while he is already engaged in combat.
	if (GetAssociateState(NW_ASC_MODE_PUPPET)==FALSE)	//DBR 8/03/06 If I am a puppet. I put nothing on the ActionQueue myself.
	{	
	    if( GetSpawnInCondition(NW_FLAG_SPECIAL_COMBAT_CONVERSATION) == TRUE )
	    {
	        ActionStartConversation( OBJECT_SELF );
	    }
		
		if ( GetAssociateState(NW_ASC_MODE_STAND_GROUND) == FALSE )
		{
			if ( GetActionMode(OBJECT_SELF, ACTION_MODE_STEALTH) == FALSE )
			{
				// Ignore if I already have a valid target
				if ( ( GetIsObjectValid(GetAttemptedAttackTarget()) == FALSE ) && 
					 ( GetIsObjectValid(GetAttemptedSpellTarget()) == FALSE ) )
				{
					if ( GetLastPerceptionSeen() == TRUE )
					{
						object oSeen = GetLastPerceived();
						
						if ( GetIsEnemy(oSeen) == TRUE )
						{
							if ( (GetNumActions(OBJECT_SELF)<=0) ||	//HencmenCR isn't like DCR - we only want to call it to start attacking a new target 
								((GetCurrentAction(OBJECT_SELF)==ACTION_FOLLOW)))
							{
								// SetFacingPoint( GetPosition(oSeen) );
								// DBR 10/25/06 - new behavior, we do not wish 'defending' companions to fight those that are not in combat.								
								if (!GetAssociateState(NW_ASC_MODE_DEFEND_MASTER) || (GetIsInCombat(oSeen)))								
									HenchmenCombatRound( );
							}
							else
							{
								// DBR 10/25/06 - new behavior, we do not wish 'defending' companions to fight those that are not in combat.								
								if (!GetAssociateState(NW_ASC_MODE_DEFEND_MASTER) || (GetIsInCombat(oSeen)))															
									ActionDoCommand(HenchmenCombatRound());	//if perception ignored, check for hostiles when I am done with my actions. (must be no target specified)							
							}
						}
						else if ( ( GetSpawnInCondition(NW_FLAG_SPECIAL_CONVERSATION) == TRUE ) &&
								  ( GetIsPC(oSeen) == TRUE ) )
						{
							ActionStartConversation( OBJECT_SELF );
						}
					}
				}
			}
		}
	}
	
	
	if ( GetSpawnInCondition(NW_FLAG_PERCIEVE_EVENT) == TRUE )
	{
		SignalEvent( OBJECT_SELF, EventUserDefined(EVENT_PERCEIVE) );
	}
}