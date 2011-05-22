//	gb_hostile_enc_pe
/*
    If a hostile creature on the overland map sees the party, pursue them
	if the party is 4+ levels higher than the creature.
*/
// JH/EF-OEI: 01/16/08

#include "ginc_behavior"
#include "ginc_overland"

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
	PrettyDebug("I see the PC!");
//	float fCR = GetChallengeRating(OBJECT_SELF) + 4;
//	if 	((FloatToInt(fCR) < GetPartyChallengeRating()))
//	{
//		PrettyDebug("Party is too strong! Stay where you are!");
		/*	Reduce lifespan to 5 so it goes away faster.	*/
//		SetLocalInt(OBJECT_SELF, "nLifeSpan", 5);				
//	} 
/*		
	else if(	GetDistanceBetween(oPercep, OBJECT_SELF) < SEARCH_DIST &&
			 			!GetIsSkillSuccessful(oPercep, SKILL_SURVIVAL, ) )
	{
		PrettyDebug("We can take the party! Get 'em!");
		PursueParty(oPercep);
	}*/
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
	int nCounter = GetLocalInt(OBJECT_SELF,"nCounter");
    //int bInaudible		= !bHeard && !bSeen && !bVanished;
	
	if (iFocused <= FOCUSED_STANDARD 
		&& GetIsObjectValid(oPercep) 
		&& GetObjectType(oPercep)==OBJECT_TYPE_CREATURE) 
	{
	    if(bSeen && nCounter > 4) 
		{
			ReactToSeenCreature(oPercep);
    	} 
		
	 	RunAnimation(oPercep);
	} // end if focused
    if(GetSpawnInCondition(NW_FLAG_PERCIEVE_EVENT) && GetLastPerceptionSeen())
    {
        SignalEvent(OBJECT_SELF, EventUserDefined(EVENT_PERCEIVE));
    }
}