//:://////////////////////////////////////////////////
//:: NW_C2_DEFAULT2
/*
  Default OnPerception event handler for NPCs.

  Handles behavior when perceiving a creature for the
  first time.
 */ 
//:://////////////////////////////////////////////////
// ChazM - 4/21/05 modified so NPC's can stay focused
// ChazM 1/6/06 removed call to WalkWayPoints()
// ChazM 3/6/06 Added exit condition if object is script hidden
// ChazM - 1/26/07 - EvenFlw modifications, further reorganized 

//#include "nw_i0_generic"
#include "ginc_behavior"

// If we see a PC, and we're supposed to be ambient, then set flag active. 
void RunAnimation(object oPercep) {
	if (!GetIsInCombat() 
		&& !GetIsEnemy(oPercep)
		&& !IsInConversation(OBJECT_SELF)) 
   	{
   		if(GetIsPC(oPercep) &&
            (GetSpawnInCondition(NW_FLAG_AMBIENT_ANIMATIONS)
            || GetSpawnInCondition(NW_FLAG_AMBIENT_ANIMATIONS_AVIAN)
            || GetSpawnInCondition(NW_FLAG_IMMOBILE_AMBIENT_ANIMATIONS)
            || GetIsEncounterCreature()))
        {
            SetAnimationCondition(NW_ANIM_FLAG_IS_ACTIVE);
        }
	}
}

void ReactToSeenCreature(object oPercep)
{
	// if I saw a PC, maybe I should say something.
	if(GetIsPC(oPercep)) 
	{
		if(GetSpawnInCondition(NW_FLAG_SPECIAL_COMBAT_CONVERSATION))
		 	SpeakOneLinerConversation();
		if(!GetIsInCombat() && !GetIsEnemy(oPercep) && GetSpawnInCondition(NW_FLAG_SPECIAL_CONVERSATION))
		 	ActionStartConversation(OBJECT_SELF);
	}
	
	// Special behavior
	if(GetBehaviorState(NW_FLAG_BEHAVIOR_SPECIAL)) 
	{
		DetermineSpecialBehavior();
	} 
	else if(GetIsEnemy(oPercep)) // an enemy, and I don't have special behavior
	{
		if(!GetHasEffect(EFFECT_TYPE_SLEEP)) 
		{
		 	SetFacingPoint(GetPosition(oPercep));
		 	SpeakString("NW_I_WAS_ATTACKED", TALKVOLUME_SILENT_TALK);
		 	if(!GetIsInCombat())
		     	DetermineCombatRound();
		}
	}

}


void ReactToHeardCreature(object oPercep)
{
	if(GetIsEnemy(oPercep))
	{
		SetLocalInt(OBJECT_SELF, "EVENFLWSEARCH", 1);
		if (GetDistanceToObject(oPercep) <= 7.0
			&& !GetIsInCombat() )
		{
			if(TalentSeeInvisible()) 
			{
				__TurnCombatRoundOn(TRUE);
				__TurnCombatRoundOn(FALSE);
			} 
			else 
			{
				// either look around...
				if(d2()==1) 
				{
					ActionPlayAnimation(ANIMATION_FIREFORGET_HEAD_TURN_LEFT, 0.5);
					ActionPlayAnimation(ANIMATION_FIREFORGET_HEAD_TURN_RIGHT, 0.5);
					ActionPlayAnimation(ANIMATION_FIREFORGET_PAUSE_SCRATCH_HEAD, 0.5);
				} 
				else // or move toward what I heard
				{
					ActionMoveToLocation(GetLocation(oPercep), TRUE);
					float delay=IntToFloat(7+d8())/10.f;
					DelayCommand(delay, DetermineCombatRound());
				}
			}
		}
	} 
}

void ReactToVanishedCreature(object oPercep)
{
	if(GetIsEnemy(oPercep)) 
	{
		SetLocalInt(OBJECT_SELF, "EVENFLWSEARCH", 1);
		if (!GetIsObjectValid(GetAttackTarget())) 
		{
			ActionMoveToLocation(GetLocation(oPercep), TRUE);
			float delay=IntToFloat(7+d8())/10.f;
			DelayCommand(delay, DetermineCombatRound());
		}
		if (GetAttemptedAttackTarget() == oPercep 
			|| GetAttackTarget() == oPercep) 
		{
			if (GetArea(oPercep) != GetArea(OBJECT_SELF) 
				|| GetHasSpellEffect(SPELL_ETHEREALNESS, oPercep)) 
			{
				ClearAllActions();
				DetermineCombatRound();
			} 
			else 
			{
				if(TalentSeeInvisible()) 
				{
					__TurnCombatRoundOn(TRUE);
					__TurnCombatRoundOn(FALSE);
				}
				ActionMoveToLocation(GetLocation(oPercep), TRUE);
				float delay = IntToFloat(7+d8())/10.f;
				DelayCommand(delay, DetermineCombatRound());
			}
		}
	} 
}

void main()
{
    if (GetAILevel() == AI_LEVEL_VERY_LOW) 
		return;
	if (GetScriptHidden(OBJECT_SELF))
		return;
		
    int iFocused 		= GetIsFocused();
    object oPercep 		= GetLastPerceived();
    int bSeen 			= GetLastPerceptionSeen();
    int bHeard 			= GetLastPerceptionHeard();
	int bVanished		= GetLastPerceptionVanished();
    //int bInaudible		= !bHeard && !bSeen && !bVanished;
	
	if (iFocused <= FOCUSED_STANDARD 
		&& GetIsObjectValid(oPercep) 
		&& GetObjectType(oPercep)==OBJECT_TYPE_CREATURE) 
	{
	    if(bSeen) 
		{
			ReactToSeenCreature(oPercep);
    	} 
		else if(bHeard) 
		{
			ReactToHeardCreature(oPercep);
    	} 
		else if(bVanished) 
		{
			ReactToVanishedCreature(oPercep);
    	}
		
	 	RunAnimation(oPercep);
	} // end if focused
    if(GetSpawnInCondition(NW_FLAG_PERCIEVE_EVENT) && GetLastPerceptionSeen())
    {
        SignalEvent(OBJECT_SELF, EventUserDefined(EVENT_PERCEIVE));
    }
}