/*	Overland Map AI include file
	 
	NLC: 2/28/08
	JSH: 7/31/08 - Added checks for Fearsome Roster and Imp Fearsome Roster
	to GetIsEncounterScared function.	
*/

//BEHAVIOR_STATE_CONSTANTS
#include "ginc_overland"
#include "nw_i0_generic"
#include "ginc_overland"

const int BEHAVIOR_STATE_NONE = 0;
const int BEHAVIOR_STATE_DUMB = 1000;
const int BEHAVIOR_STATE_UNALERT = 2000;
const int BEHAVIOR_STATE_ALERT = 3000;
const int BEHAVIOR_STATE_NPC_CHASING = 4000;
const int BEHAVIOR_STATE_NPC_COMBAT = 4500;
const int BEHAVIOR_STATE_CHASING = 5000;
const int BEHAVIOR_STATE_CHATTING = 6000;
const int BEHAVIOR_STATE_FLEEING = 8000;
const int BEHAVIOR_STATE_DESPAWNING = 9000;

const int HEARTBEAT_RATE_DEFAULT = 6000;
const int HEARTBEAT_RATE_COMBAT = 6000;
const int HEARTBEAT_RATE_DETECTING = 1000;
const int HEARTBEAT_RATE_CHASING = 100;

const int NPC_COMBAT_NO_RESULT			= 0;
const int NPC_COMBAT_RESULT_NPC_DAMAGE	= 100;
const int NPC_COMBAT_RESULT_ENC_DAMAGE	= 200;

const int AGGRO_VFX_ID	= 9999;

const string VAR_LIFESPAN_TIMER = "fLifespanTimer";
const string VAR_CHASE_TIMER = "fChaseTimer";
const string VAR_SEARCH_COOLDOWN = "fSearchCooldown";
const string VAR_BEHAVIOR_STATE	= "nBehaviorState";

const float SEARCH_DIST = 10.0f;
const float AI_CHASE_DURATION = 10.0f;
const float AI_AWARENESS_DISTANCE = 30.0f;
const float ENCOUNTER_CONVERSATION_DISTANCE = 2.0f;
const float SEARCH_COOLDOWN = 3.0f;

//Getters - Functions for other systems to read into the AI state of creatures/
int GetIsActorChasing(object oEnc);

//Utility Functions
void RemoveAggroVFX(object oEnc = OBJECT_SELF);
void RunStateManager(object oPC);
void PursueParty(object oPC);
void SetOLBehaviorState(int nBehaviorState, object oEnc = OBJECT_SELF);
void SetEncounterFlagAfraid(object oEnc);
int GetIsSearchSuccessful(object oPC, object oEnc = OBJECT_SELF);
int GetIsEncounterScared(object oEnc = OBJECT_SELF);
float DecrementSearchCooldown(object oEnc = OBJECT_SELF);
float IncrementLifespanTimer(object oEnc = OBJECT_SELF);
float IncrementChaseTimer(object oEnc = OBJECT_SELF);
void PlayCombatStinger();

//AI Update Functions
void RunDumbAI();
void RunUnalertAI();
void RunAlertAI();
void RunChasingAI();
void RunNPCChasingAI();
void RunNPCCombatAI();
void RunCombatAI();
void RunChattingAI();
void RunFleeingAI();
void RunDespawningAI();

//State Transition Functions
void ResetBehavior();
void TransitionNoneToDumb();
void TransitionNoneToAlert();
void TransitionNoneToUnalert();
void TransitionNoneToDespawning();
void TransitionDumbToUnalert();
void TransitionDumbToAlert();
void TransitionDumbToDespawning();
void TransitionUnalertToDumb();
void TransitionUnalertToAlert();
void TransitionUnalertToDespawning();
void TransitionAlertToUnalert();
void TransitionAlertToChasing();
void TransitionAlertToFleeing();
void TransitionChasingToDespawning();
void TransitionChasingToCombat();
void TransitionChasingToChatting();
void TransitionChasingToFleeing();
void TransitionChattingToChasing();
void TransitionChattingToFleeing();
void TransitionFleeingToDespawning();
void TransitionDespawningToNone();
void TransitionToNPCChasing(object oNPC);
void TransitionToNPCCombat(object oNPC, object oEncounter = OBJECT_SELF);

//Guard Functions
void RunGuardAI(object oGuard = OBJECT_SELF);
object GetNeutralInRange(object oEncounter = OBJECT_SELF);
float GetPCOrNeutralDistance(object oPC, object oEncounter = OBJECT_SELF);
int DetermineNPCCombatOutcome(object oNPC, object oEncounter = OBJECT_SELF);

//Getters - Functions for other systems to read into the AI state of creatures/
int GetIsActorChasing(object oEnc)
{
	int nBehaviorState = GetLocalInt(OBJECT_SELF, VAR_BEHAVIOR_STATE);
	if(nBehaviorState == BEHAVIOR_STATE_CHASING)
		return TRUE;
		
	else
		return FALSE;
}

/*
	NLC - Overland MAP AI State Manager
	This organizes how AIs transition from one behavior state to another
	on the OL MAP, and runs the appropriate AI when necessary.
*/
void RunStateManager(object oPC)
{
	float fLifespanTimer			= GetLocalFloat(OBJECT_SELF, VAR_LIFESPAN_TIMER);
	float fChaseTimer				= GetLocalFloat(OBJECT_SELF, VAR_CHASE_TIMER);
	float fSearchCooldown			= GetLocalFloat(OBJECT_SELF, VAR_SEARCH_COOLDOWN);
	float fSearchDist 				= GetLocalFloat(OBJECT_SELF, "fSearchDist");
	float fLifespan					= IntToFloat(GetLocalInt(OBJECT_SELF, VAR_ENC_LIFESPAN));
	float fPCDistance 				= GetDistanceBetween(oPC, OBJECT_SELF);
	
	int nBehaviorState		 		= GetLocalInt(OBJECT_SELF, VAR_BEHAVIOR_STATE);	
	
	switch ( nBehaviorState )
	{
		
		case BEHAVIOR_STATE_NONE:
		{
			if (fLifespanTimer >= fLifespan)
				TransitionNoneToDespawning();
				
			else if (fPCDistance <= fSearchDist)
				TransitionNoneToAlert();
		
			else if (fPCDistance <= AI_AWARENESS_DISTANCE)
				TransitionNoneToUnalert();
						
			else
				TransitionNoneToDumb();
		}
		break;
			
		case BEHAVIOR_STATE_DUMB:
		{
			if (fLifespanTimer >= fLifespan)
				TransitionDumbToDespawning();

			if (fPCDistance <= fSearchDist)
			{
				TransitionDumbToAlert();
			}
			
			object oNeutral = GetNeutralInRange();
			if(GetIsObjectValid(oNeutral) && fLifespanTimer > 0.0f && !GetIsPC(oNeutral) && GetLocalInt(OBJECT_SELF, "bSpecialEncounter") == FALSE)
			{
				TransitionToNPCChasing(oNeutral);
			}
			else if (fPCDistance <= AI_AWARENESS_DISTANCE)
			{
				TransitionDumbToUnalert();
			}
			else
				RunDumbAI();
		}
		break;
		
		case BEHAVIOR_STATE_UNALERT:
		{
			if (fLifespanTimer >= fLifespan)
				TransitionDumbToDespawning();

			if (fPCDistance <= fSearchDist)
			{
				TransitionUnalertToAlert();
			}
			
			else if (fPCDistance > AI_AWARENESS_DISTANCE)
			{
				TransitionUnalertToDumb();
			}
			
			object oNeutral = GetNeutralInRange();
			if(GetIsObjectValid(oNeutral) && fLifespanTimer > 0.0f && !GetIsPC(oNeutral) && GetLocalInt(OBJECT_SELF, "bSpecialEncounter") == FALSE)
			{
				TransitionToNPCChasing(oNeutral);
			}
			
			else
				RunUnalertAI();	
		}		
		break;
		
		case BEHAVIOR_STATE_ALERT:
		{
			if(IsInConversation(oPC))
			{
				ClearAllActions(TRUE);
			}
			
			else if (fSearchCooldown == 0.0f && fPCDistance > fSearchDist)			
			{
				TransitionAlertToUnalert();
			}
			object oNeutral = GetNeutralInRange();
			if(GetIsObjectValid(oNeutral) && fLifespanTimer > 0.0f && !GetIsPC(oNeutral) && GetLocalInt(OBJECT_SELF, "bSpecialEncounter") == FALSE)
			{
				TransitionToNPCChasing(oNeutral);
			}
			
			else if ( fSearchCooldown <= 0.0f)
			{
				SetLocalFloat(OBJECT_SELF, "fSearchCooldown", SEARCH_COOLDOWN);
				
				
				if(GetIsSearchSuccessful(oPC))
				{
					if( GetIsEncounterScared() )
					{
						TransitionAlertToFleeing();
					}
					
					else 
					{
						TransitionAlertToChasing();
					}
				}
				
				else
				{
					effect eAlert = EffectNWN2SpecialEffectFile("fx_OverlandMap_Searching01");
					ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eAlert, OBJECT_SELF, SEARCH_COOLDOWN);
					// JWR-OEI 10/03/08: Move away, otherwise fPCDistance > fSearchDist
					// will NEVER be true and we're stuck in a loop!
					//ActionMoveAwayFromObject(oPC, FALSE);
					// using away from location to help prevent them getting stuck
					// against walls in confined spaces.
					ActionMoveAwayFromLocation(GetLocation(OBJECT_SELF));
					
				}
			}
			
			else
			{
				RunAlertAI();
			}
		}
		break;
		
		case BEHAVIOR_STATE_NPC_CHASING:
		{
			object oNPC = GetLocalObject(OBJECT_SELF, "oFollow");
			float fNPCDistance = GetDistanceBetween(OBJECT_SELF, oNPC);
			
			if(!GetIsObjectValid(oNPC) || GetIsPC(oNPC) || GetScriptHidden(oNPC))
			{
				DeleteLocalObject(OBJECT_SELF, "oFollow");
				ResetBehavior();
			}
			
			else if(fNPCDistance <= ENCOUNTER_CONVERSATION_DISTANCE)
			{
				TransitionToNPCCombat(oNPC);
			}
			
			else
				RunNPCChasingAI();
			
		}
		break;
		
		case BEHAVIOR_STATE_NPC_COMBAT:
		{
			object oNPC = GetLocalObject(OBJECT_SELF, "oFollow");
			if(!GetIsObjectValid(oNPC) || GetIsPC(oNPC) || GetScriptHidden(oNPC))
			{
				DeleteLocalObject(OBJECT_SELF, "oFollow");
				ResetBehavior();
			}
			
			else
				RunNPCCombatAI();
		}
		break;
		
		case BEHAVIOR_STATE_CHASING:
		{
			/*			
			if( GetIsEncounterScared() )
				TransitionChasingToFleeing();
			Commenting this out for performance reasons			
			PrettyDebug("Search Cooldown:" + FloatToString(fSearchCooldown) + " fChaseTimer:" + FloatToString(fChaseTimer) );
			*/
						
			if (fSearchCooldown == 0.0f && fPCDistance > fSearchDist)
				TransitionChasingToDespawning();
			
			object oNeutral = GetNeutralInRange();
			if( GetIsObjectValid(oNeutral) && fLifespanTimer > 0.0f && !GetIsPC(oNeutral) && GetLocalInt(OBJECT_SELF, "bSpecialEncounter") == FALSE && GetDistanceBetween(oNeutral, OBJECT_SELF) < fPCDistance )
			{
				TransitionToNPCChasing(oNeutral);
			}
			
			else if (fChaseTimer > AI_CHASE_DURATION)
			{
				TransitionChasingToDespawning();
			}
			
			else if (fPCDistance <= ENCOUNTER_CONVERSATION_DISTANCE)
			{
				PrettyDebug("ginc_overland_ai: Starting convo with " + GetTag(OBJECT_SELF));
				TransitionChasingToChatting();
				ClearAllActions(TRUE);
				PlayCombatStinger();
				ActionStartConversation(oPC, GetEncounterConversation(), FALSE,FALSE,TRUE,FALSE);
			}
			
			else
				RunChasingAI();
		}
		break;
		
		case BEHAVIOR_STATE_CHATTING:
			if( !IsInConversation(OBJECT_SELF) )
				TransitionChattingToChasing();
			
			else
				RunChattingAI();
		break;
		
		case BEHAVIOR_STATE_FLEEING:
			RunFleeingAI();
		break;
		
		case BEHAVIOR_STATE_DESPAWNING:
			if( GetLocalInt(OBJECT_SELF, VAR_SE_FLAG) &&		//if I have a Local Location I am a Special Encounter
				GetDistanceBetweenLocations( GetLocation(OBJECT_SELF), GetSEStartLocation() ) < 1.0f)
			
				TransitionDespawningToNone();
			else
				RunDespawningAI();
		break;
		
		default:
		break;
	}
}

void RemoveAggroVFX(object oEnc = OBJECT_SELF)
{
	effect eEffect = GetFirstEffect(oEnc);
	PrettyDebug("Removing aggro vfx from " + GetName(oEnc));
	while(GetIsEffectValid(eEffect))
	{
		PrettyDebug("Effect");
		PrettyDebug(IntToString(GetEffectSpellId(eEffect)));
		if(GetEffectSpellId(eEffect) == AGGRO_VFX_ID)
			RemoveEffect(oEnc, eEffect);
		
		eEffect = GetNextEffect(oEnc);
	}	
}

/*	Assigns the overland creature to pursue the party.	*/
void PursueParty(object oPC)
{
	if(GetIsPC(oPC)) 
	{
		PrettyDebug(GetName(OBJECT_SELF) + "Target Acquired.");
		ClearAllActions(TRUE);
		SetLocalObject(OBJECT_SELF, "oFollow",oPC);
		ActionForceFollowObject(oPC,0.f);
		ActionDoCommand(SignalEvent(OBJECT_SELF, EventUserDefined(100)));
	}
}

void PursueNPC(object oNPC)
{
	ClearAllActions(TRUE);
	SetLocalObject(OBJECT_SELF, "oFollow", oNPC);
	ActionForceFollowObject(oNPC,0.f);
}

void SetOLBehaviorState(int nBehaviorState, object oEnc)
{
	SetLocalInt(oEnc, VAR_BEHAVIOR_STATE, nBehaviorState);
}

void SetEncounterFlagAfraid(object oEnc)
{
	SetLocalInt(oEnc, "nAfraid", 1);
}

int GetIsSearchSuccessful(object oPC, object oEnc = OBJECT_SELF)
{
	int nSurvivalDC = GetLocalInt(oEnc, "nSurvivalDC");
	int nSkillToUse = SKILL_HIDE;
	
	if( GetSkillRank(SKILL_MOVE_SILENTLY, oPC) > GetSkillRank(SKILL_HIDE, oPC))
		nSkillToUse = SKILL_MOVE_SILENTLY;
		
	int nResult = !GetIsSkillSuccessful(oPC, nSkillToUse, nSurvivalDC);
	SetLocalFloat(oEnc, VAR_SEARCH_COOLDOWN, SEARCH_COOLDOWN);
	return nResult;
}
	
int GetIsEncounterScared(object oEnc = OBJECT_SELF)
{
	if (GetLocalInt(oEnc, "NX2_ENC_NO_FEAR"))	//If the encounter is flagged to be fearless, be fearless (regardless of what the flag says).
		return FALSE;
	
	else if (GetLocalInt(oEnc, "nAfraid"))	//If the Afraid flag is set, the encounter is scared. No brainer here.
		return TRUE;
	
	else 
	{
		object oPC	= GetFactionLeader(GetFirstPC());
	
		float fCR = GetChallengeRating(oEnc) + 5;
	
		//	If the party has Fearsome Roster or Improved Fearsome Roster feat,
		//	monsters run away as if the party is 1 or 2 CRs higher than it
		//	really is.
		if (GetHasFeat(FEAT_TW_FEARSOME_ROSTER, oPC))
			fCR = GetChallengeRating(oEnc) + 4;
		
		if (GetHasFeat(FEAT_TW_IMPROVED_FEARSOME_ROSTER, oPC))
			fCR = GetChallengeRating(oEnc) + 3;
		
		if( FloatToInt(fCR) < GetPartyChallengeRating() )
		{
			SetEncounterFlagAfraid(oEnc);
			return TRUE;
		}	
	}
	
	return FALSE;
}

float DecrementSearchCooldown(object oEnc = OBJECT_SELF)
{
	float fCooldown = GetLocalFloat(oEnc, VAR_SEARCH_COOLDOWN);
	float fHeartrate = IntToFloat(GetCustomHeartbeat(OBJECT_SELF)) / 1000.0f; //heartrate in seconds
	
	fCooldown -= fHeartrate;
	
	if(fCooldown < 0.0f)
		fCooldown = 0.0f;
	
	SetLocalFloat(oEnc, VAR_SEARCH_COOLDOWN, fCooldown);
	return fCooldown;
}

float IncrementLifespanTimer(object oEnc = OBJECT_SELF)
{
	float fHeartrate = IntToFloat(GetCustomHeartbeat(OBJECT_SELF)) / 1000.0f;
	float fLifespanTimer = GetLocalFloat(OBJECT_SELF, VAR_LIFESPAN_TIMER);
	
	if(fLifespanTimer >= 0.0f)				//Lifespan timers less than zero indicate that the creature is immortal.
		fLifespanTimer += fHeartrate;
	
	SetLocalFloat(oEnc, VAR_LIFESPAN_TIMER, fLifespanTimer);
	
	return fLifespanTimer;
}

float IncrementChaseTimer(object oEnc = OBJECT_SELF)
{
	float fHeartrate = IntToFloat(GetCustomHeartbeat(OBJECT_SELF)) / 1000.0f;
	float fChaseTimer = GetLocalFloat(OBJECT_SELF, VAR_CHASE_TIMER);
	
	fChaseTimer += fHeartrate;
	
	SetLocalFloat(oEnc, VAR_CHASE_TIMER, fChaseTimer);
	
	return fChaseTimer;
}

void RunDumbAI()
{
}

void RunUnalertAI()
{
//	PrettyDebug(GetName(OBJECT_SELF) + "Running Unalert AI");
	int iBehavior = Random(100)+1;
	
	if(iBehavior <=10)
	{
		ClearAllActions(TRUE);
		//ActionPlayAnimation(ANIMATION_FIREFORGET_SEARCH);
		//DelayCommand(5.0f, ActionRandomWalk());
	}
		
	else if ( GetCurrentAction() != ACTION_RANDOMWALK)
	{
		ClearAllActions(TRUE);
		ActionRandomWalk();
	}
}

void RunAlertAI()
{
//	PrettyDebug(GetName(OBJECT_SELF) + "Running alert AI");
/*	int iBehavior = Random(99)+1;

	if(iBehavior <=50)
	{
		ClearAllActions(TRUE);
		//ActionPlayAnimation(ANIMATION_FIREFORGET_SEARCH);	
	}
		
	else if ( GetCurrentAction() != ACTION_MOVETOPOINT)
	{
		ClearAllActions(TRUE);
		ActionRandomWalk();
	}
*/
}

void RunChasingAI()
{
//	PrettyDebug(GetName(OBJECT_SELF) + "Running Chase AI");
	object oFollow = GetLocalObject(OBJECT_SELF, "oFollow");
	if(IsInConversation(GetFactionLeader(GetFirstPC())))
	{
		ClearAllActions(TRUE);
		return;
	}
	IncrementChaseTimer();
	
	if(GetCurrentAction() != ACTION_FOLLOW || GetScriptHidden(oFollow))
	{
		object oPC = GetFactionLeader(GetFirstPC());
//		vector vTarget = GetPosition(oPC);
//		SetFacingPoint(vTarget);			//Commenting out for Performance.
		PursueParty(oPC);
	}
	
	else if(!GetIsObjectValid(oFollow))
	{
		ClearAllActions(TRUE);
		//ActionPlayAnimation(ANIMATION_FIREFORGET_SEARCH);
		DelayCommand(5.0f, ActionRandomWalk());
		SetOLBehaviorState(BEHAVIOR_STATE_UNALERT);
	}
}

void RunNPCChasingAI()
{
//	PrettyDebug(GetName(OBJECT_SELF) + "Running Chase AI");
	object oFollow = GetLocalObject(OBJECT_SELF, "oFollow");
	if(IsInConversation(GetFirstPC()))
	{
		ClearAllActions(TRUE);
		return;
	}
	
	if(GetCurrentAction() != ACTION_FOLLOW )
	{
//		object oPC = GetFactionLeader(GetFirstPC());
//		vector vTarget = GetPosition(oPC);
//		SetFacingPoint(vTarget);			//Commenting out for Performance.
		PursueNPC(oFollow);
	}
	
	else if(!GetIsObjectValid(oFollow))
	{
		ClearAllActions(TRUE);
		//ActionPlayAnimation(ANIMATION_FIREFORGET_SEARCH);
		DelayCommand(5.0f, ActionRandomWalk());
		SetOLBehaviorState(BEHAVIOR_STATE_UNALERT);
	}
}

void RunNPCCombatAI()
{
	object oNPC = GetLocalObject(OBJECT_SELF, "oFollow");
	ClearCombatOverrides(OBJECT_SELF);
	ClearCombatOverrides(oNPC);
	
	if(GetIsPC(oNPC))
	{
		ClearAllActions(TRUE);
		DeleteLocalObject(OBJECT_SELF, "oFollow");
		ResetBehavior();
	}
	
	else
	{
		ClearAllActions(TRUE);
	
		AssignCommand(oNPC, ClearAllActions(TRUE));
	
		int nResult = DetermineNPCCombatOutcome(oNPC, OBJECT_SELF);
	
		if (nResult == NPC_COMBAT_RESULT_NPC_DAMAGE)
		{
			SetCombatOverrides(OBJECT_SELF, oNPC, 1, 0, OVERRIDE_ATTACK_RESULT_HIT_SUCCESSFUL, 1,1, TRUE, TRUE, TRUE, TRUE);
			SetCombatOverrides(oNPC, OBJECT_SELF, 1, 0, OVERRIDE_ATTACK_RESULT_MISS, 0,0, TRUE, TRUE, TRUE, TRUE);
			ActionAttack(oNPC);
			AssignCommand(oNPC, ActionAttack(OBJECT_SELF));
		}
	
		else if (nResult == NPC_COMBAT_RESULT_ENC_DAMAGE)
		{
			SetCombatOverrides(oNPC, OBJECT_SELF, 1, 0, OVERRIDE_ATTACK_RESULT_HIT_SUCCESSFUL, 1,1, TRUE, TRUE, TRUE, TRUE);
			SetCombatOverrides(OBJECT_SELF, oNPC, 1, 0, OVERRIDE_ATTACK_RESULT_MISS, 0,0, TRUE, TRUE, TRUE, TRUE);
			AssignCommand(oNPC, ActionAttack(OBJECT_SELF));
			ActionAttack(oNPC);
		}
	}
}

void RunChattingAI()
{
//	PrettyDebug(GetName(OBJECT_SELF) + "Running Chatting AI");
}

// JWR-OEI 10/02/08 - Cleaned up typos, fixed case where fleeing mobs 
// just "stand around" and various polish.
void RunFleeingAI()
{
	//	PrettyDebug(GetName(OBJECT_SELF) + "Running Flee AI");
	object oPC = GetFactionLeader(GetFirstPC());
	int nCowerCounter = GetLocalInt(OBJECT_SELF, "nCower");
	float fDist = GetDistanceBetween(OBJECT_SELF, oPC);
	//SpeakString("**** (Distance-----> "+FloatToString(fDist)+" nCowerCounter----->"+IntToString(nCowerCounter));

	if ( fDist > 9.0f || nCowerCounter > 12000)
	{
		TransitionFleeingToDespawning();
	}
	else if( fDist <= 9.0f )
	{
		ClearAllActions(TRUE);
		int nHeartbeat = GetCustomHeartbeat(OBJECT_SELF);
		ModifyLocalInt(OBJECT_SELF, "nCower", nHeartbeat);
		if ( nCowerCounter > 8000 )
			ActionMoveAwayFromObject(oPC, FALSE);
		
		//PlayCustomAnimation(OBJECT_SELF, "idlecower", 1);
	}
}

void RunDespawningAI()
{
//	PrettyDebug(GetName(OBJECT_SELF) + "Running Despawn AI");
	object oPC = GetFactionLeader(GetFirstPC());


	if ( GetLocalInt(OBJECT_SELF, VAR_SE_FLAG) )
	{
		ClearAllActions(TRUE);
		ActionMoveToLocation(GetLocalLocation(OBJECT_SELF, VAR_SE_START_LOC), TRUE);
	}

	else if(GetDistanceBetween(OBJECT_SELF, oPC) > 5.0f)
	{
		RemoveSEFFromObject(OBJECT_SELF, "fx_map_hostile");
		ApplyEffectToObject(DURATION_TYPE_INSTANT, EffectNWN2SpecialEffectFile("fx_ambient_fade"), OBJECT_SELF);
		DestroyObject(OBJECT_SELF, 1.0f);
	}	

	else if ( GetCurrentAction() != ACTION_MOVETOPOINT)
	{
		ClearAllActions(TRUE);
		ActionMoveAwayFromObject(oPC);
	}

}

void ResetBehavior()
{
	ClearAllActions(TRUE);
	SetCustomHeartbeat(OBJECT_SELF, HEARTBEAT_RATE_DETECTING);
	SetOLBehaviorState(BEHAVIOR_STATE_NONE);
	object oPC = GetFactionLeader(GetFirstPC());
	RunStateManager(oPC);
}
void TransitionNoneToUnalert()
{
//	PrettyDebug(GetName(OBJECT_SELF) + "Transitioning None to Unalert");
	SetCustomHeartbeat(OBJECT_SELF, HEARTBEAT_RATE_DETECTING);
	SetOLBehaviorState(BEHAVIOR_STATE_UNALERT);
}

void TransitionNoneToAlert()
{
// 	PrettyDebug(GetName(OBJECT_SELF) + "Transition None To Alert");
	ClearAllActions(TRUE);
	SetCustomHeartbeat(OBJECT_SELF, HEARTBEAT_RATE_DETECTING);
	SetOLBehaviorState(BEHAVIOR_STATE_ALERT);
}

void TransitionNoneToDumb()
{
//	PrettyDebug(GetName(OBJECT_SELF) + "Transitioning None to Dumb");
	SetOLBehaviorState(BEHAVIOR_STATE_DUMB);
}

void TransitionNoneToDespawning()
{
//	PrettyDebug(GetName(OBJECT_SELF) + ":TransitionNoneToDespawning");
	SetCustomHeartbeat(OBJECT_SELF, HEARTBEAT_RATE_DEFAULT);
	SetOLBehaviorState(BEHAVIOR_STATE_DESPAWNING);
	
	object oPC = GetFactionLeader(GetFirstPC());
	
	ClearAllActions(TRUE);
	SetEventHandler(OBJECT_SELF, EVENT_DIALOGUE, "");
	ActionMoveAwayFromObject(oPC);
}

void TransitionDumbToUnalert()
{
//	PrettyDebug(GetName(OBJECT_SELF) + "Transitioning Dumb to Unlaret");
	SetCustomHeartbeat(OBJECT_SELF, HEARTBEAT_RATE_DETECTING);
	SetOLBehaviorState(BEHAVIOR_STATE_UNALERT);
}
void TransitionDumbToAlert()
{
//	PrettyDebug(GetName(OBJECT_SELF) + "TransitionDumbToAlert");
	ClearAllActions(TRUE);
	SetCustomHeartbeat(OBJECT_SELF, HEARTBEAT_RATE_DETECTING);
	SetOLBehaviorState(BEHAVIOR_STATE_ALERT);
}

void TransitionDumbToDespawning()
{
//	PrettyDebug(GetName(OBJECT_SELF) + "TransitionDumbToDespawning");
	SetCustomHeartbeat(OBJECT_SELF, HEARTBEAT_RATE_DEFAULT);
	SetOLBehaviorState(BEHAVIOR_STATE_DESPAWNING);
	
	object oPC = GetFactionLeader(GetFirstPC());
	
	ClearAllActions(TRUE);
	SetEventHandler(OBJECT_SELF, EVENT_DIALOGUE, "");
	ActionMoveAwayFromObject(oPC);
}
void TransitionUnalertToDumb()
{
//	PrettyDebug(GetName(OBJECT_SELF) + "TransitionUnalertToDumb");
	SetCustomHeartbeat(OBJECT_SELF, HEARTBEAT_RATE_DEFAULT);
	SetOLBehaviorState(BEHAVIOR_STATE_DUMB);
}

void TransitionUnalertToAlert()
{
//	PrettyDebug(GetName(OBJECT_SELF) + "TransitionUnalertToAlert");
	ClearAllActions(TRUE);
	SetCustomHeartbeat(OBJECT_SELF, HEARTBEAT_RATE_DETECTING);
	SetOLBehaviorState(BEHAVIOR_STATE_ALERT);
}

void TransitionUnalertToDespawning()
{
//	PrettyDebug(GetName(OBJECT_SELF) + "TransitionUnalertToDespawning");
	SetCustomHeartbeat(OBJECT_SELF, HEARTBEAT_RATE_DEFAULT);
	SetOLBehaviorState(BEHAVIOR_STATE_DESPAWNING);
	
	object oPC = GetFactionLeader(GetFirstPC());
	
	ClearAllActions(TRUE);
	SetEventHandler(OBJECT_SELF, EVENT_DIALOGUE, "");
	ActionMoveAwayFromObject(oPC);
}
void TransitionAlertToUnalert()
{
//	PrettyDebug(GetName(OBJECT_SELF) + "TransitionAlertToUnAlert");
	SetCustomHeartbeat(OBJECT_SELF, HEARTBEAT_RATE_DETECTING);
	SetOLBehaviorState(BEHAVIOR_STATE_UNALERT);
}

void TransitionAlertToChasing()
{
//	PrettyDebug(GetName(OBJECT_SELF) + "TransitionAlertToChasing");
	SetCustomHeartbeat(OBJECT_SELF, HEARTBEAT_RATE_CHASING);
	SetOLBehaviorState(BEHAVIOR_STATE_CHASING);
	object oPC = GetFactionLeader(GetFirstPC());
	vector vTarget = GetPosition(oPC);
	
	effect eChase = EffectNWN2SpecialEffectFile("fx_OverlandMap_Detect");
	eChase = SetEffectSpellId(eChase, AGGRO_VFX_ID);
	ApplyEffectToObject(DURATION_TYPE_PERMANENT, eChase, OBJECT_SELF);
	
	SetFacingPoint(vTarget);
	PlayVoiceChat(VOICE_CHAT_BATTLECRY1);
	PursueParty(oPC);
}

void TransitionAlertToFleeing()
{
//	PrettyDebug(GetName(OBJECT_SELF) + "TransitionAlertToFleeing");
	SetCustomHeartbeat(OBJECT_SELF, HEARTBEAT_RATE_DETECTING);
	SetOLBehaviorState(BEHAVIOR_STATE_FLEEING);

	effect eCower = EffectNWN2SpecialEffectFile("fx_OverlandMap_Cower");
	ApplyEffectToObject(DURATION_TYPE_PERMANENT, eCower, OBJECT_SELF);

	object oPC = GetFactionLeader(GetFirstPC());
		
	ClearAllActions(TRUE);
	// JWR-OEI - Set to False to stop "jerkiness" of
	// OL creatures running away at first.
	ActionMoveAwayFromObject(oPC, FALSE);
}

void TransitionChasingToDespawning()
{
	PrettyDebug(GetName(OBJECT_SELF) + " TransitionChasingToDespawning");
	SetCustomHeartbeat(OBJECT_SELF, HEARTBEAT_RATE_DEFAULT);
	SetOLBehaviorState(BEHAVIOR_STATE_DESPAWNING);
	effect eDeaggro = EffectNWN2SpecialEffectFile("fx_OverlandMap_Deaggro");
	object oPC = GetFactionLeader(GetFirstPC());
	
	RemoveAggroVFX(OBJECT_SELF);
	ApplyEffectToObject(DURATION_TYPE_INSTANT, eDeaggro, OBJECT_SELF);
	ClearAllActions(TRUE);
	SetEventHandler(OBJECT_SELF, EVENT_DIALOGUE, "");
	ActionMoveAwayFromObject(oPC);
}

void TransitionChasingToChatting()
{
//	PrettyDebug(GetName(OBJECT_SELF) + "TransitionChasingToChatting");
	SetCustomHeartbeat(OBJECT_SELF, HEARTBEAT_RATE_DETECTING);
	SetOLBehaviorState(BEHAVIOR_STATE_CHATTING);
}

void TransitionChasingToFleeing()
{
//	PrettyDebug(GetName(OBJECT_SELF) + "TransitionChasingToFleeing");
	SetCustomHeartbeat(OBJECT_SELF, HEARTBEAT_RATE_DETECTING);
	SetOLBehaviorState(BEHAVIOR_STATE_FLEEING);
	
	effect eCower = EffectNWN2SpecialEffectFile("fx_OverlandMap_Cower");
	ApplyEffectToObject(DURATION_TYPE_PERMANENT, eCower, OBJECT_SELF);
	
	object oPC = GetFactionLeader(GetFirstPC());
	ClearAllActions(TRUE);
	ActionMoveAwayFromObject(oPC, TRUE);
}

void TransitionChattingToChasing()
{
	SetCustomHeartbeat(OBJECT_SELF, HEARTBEAT_RATE_CHASING);
	SetOLBehaviorState(BEHAVIOR_STATE_CHASING);

	object oPC = GetFactionLeader(GetFirstPC());
	vector vTarget = GetPosition(oPC);
	
	
	SetFacingPoint(vTarget);
	PursueParty(oPC);
}

void TransitionChattingToFleeing()
{
//	PrettyDebug(GetName(OBJECT_SELF) + "TransitionChattingToFleeing");
	SetCustomHeartbeat(OBJECT_SELF, HEARTBEAT_RATE_DETECTING);
	SetOLBehaviorState(BEHAVIOR_STATE_FLEEING);

	effect eCower = EffectNWN2SpecialEffectFile("fx_OverlandMap_Cower");
	ApplyEffectToObject(DURATION_TYPE_PERMANENT, eCower, OBJECT_SELF);

	object oPC = GetFactionLeader(GetFirstPC());
	
	ClearAllActions(TRUE);
	ActionMoveAwayFromObject(oPC, TRUE);
}

void TransitionFleeingToDespawning()
{
	SetCustomHeartbeat(OBJECT_SELF, HEARTBEAT_RATE_DEFAULT);
	SetOLBehaviorState(BEHAVIOR_STATE_DESPAWNING);
	
	object oPC = GetFactionLeader(GetFirstPC());
	
	ClearAllActions(TRUE);
	SetEventHandler(OBJECT_SELF, EVENT_DIALOGUE, "");
	// JWR-OEI changed this because they're fleeing! They should run!
	ActionMoveAwayFromObject(oPC, TRUE);
}


void TransitionDespawningToNone()
{
//	PrettyDebug(GetName(OBJECT_SELF) + "TransitionDespawningToNone");
	SetCustomHeartbeat(OBJECT_SELF, HEARTBEAT_RATE_DETECTING);
	SetOLBehaviorState(BEHAVIOR_STATE_NONE);
}

void TransitionToNPCChasing(object oNPC)
{
	SetCustomHeartbeat(OBJECT_SELF, HEARTBEAT_RATE_CHASING);
	SetOLBehaviorState(BEHAVIOR_STATE_NPC_CHASING);
	SetOLBehaviorState(BEHAVIOR_STATE_NPC_CHASING, oNPC);
	ClearAllActions(TRUE);
	PursueNPC(oNPC);
}

void TransitionToNPCCombat(object oNPC, object oEncounter = OBJECT_SELF)
{
	AssignCommand(oNPC, ClearAllActions(TRUE));
	ClearAllActions(TRUE);
	
	SetOLBehaviorState(BEHAVIOR_STATE_NPC_COMBAT, oNPC);
	SetOLBehaviorState(BEHAVIOR_STATE_NPC_COMBAT);
	
	AssignCommand(oNPC, SetWalkCondition(NW_WALK_FLAG_PAUSED, TRUE));
	SetCustomHeartbeat(oNPC, HEARTBEAT_RATE_COMBAT);
	SetCustomHeartbeat(OBJECT_SELF, HEARTBEAT_RATE_COMBAT);
	
	SetLocalObject(oNPC, "oChasing", OBJECT_SELF);
	
	// Set up the encounter mating placeable.
	object oIP = CreateObject(OBJECT_TYPE_PLACEABLE, "nx2_plc_enc_ipoint", GetLocation(OBJECT_SELF));
	SetCustomHeartbeat(oIP, 500);
	SetLocalObject(oIP, "oCombatant1", OBJECT_SELF);
	SetLocalObject(oIP, "oCombatant2", oNPC);
	
	RunNPCCombatAI();
}

object GetNeutralInRange(object oEncounter = OBJECT_SELF)
{
	float fSearchDist = GetLocalFloat(oEncounter, "fSearchDist");
	location lEnc = GetLocation(oEncounter);
	object oGuard = GetFirstObjectInShape(SHAPE_SPHERE, fSearchDist, lEnc, TRUE);
	object oRet = OBJECT_INVALID;
	while(GetIsObjectValid(oGuard))
	{
		if( GetLocalInt(oGuard, "bGuard") && !GetScriptHidden(oGuard) && !GetIsPC(oGuard) &&
			GetLocalInt(oGuard, VAR_BEHAVIOR_STATE) != BEHAVIOR_STATE_NPC_CHASING &&
			GetLocalInt(oGuard, VAR_BEHAVIOR_STATE) != BEHAVIOR_STATE_NPC_COMBAT)
		{	
			return oGuard;
		}
		else if( GetLocalInt(oGuard, "bNeutral") && !GetIsPC(oGuard) && !GetScriptHidden(oGuard) &&
			(GetLocalInt(oGuard, VAR_BEHAVIOR_STATE) != BEHAVIOR_STATE_NPC_CHASING &&
			 GetLocalInt(oGuard, VAR_BEHAVIOR_STATE) != BEHAVIOR_STATE_NPC_COMBAT &&
			 !GetLocalInt(oGuard, "bWaylaid") ) )
		{
			oRet = oGuard;
		}
		
		oGuard = GetNextObjectInShape(SHAPE_SPHERE, fSearchDist, lEnc, TRUE);
	}
	
	return oRet;
}

float GetPCOrNeutralDistance(object oPC, object oEncounter = OBJECT_SELF)
{
	float fResult = GetDistanceBetween(oPC, oEncounter);
	object oNeutral = GetNeutralInRange();
	if(GetIsObjectValid(oNeutral))
	{
		float fNeutralDistance = GetDistanceBetween(oEncounter, oNeutral);
		if( fNeutralDistance < fResult )
			fResult = fNeutralDistance;
	}
	
	return fResult;
}

int DetermineNPCCombatOutcome(object oNPC, object oEncounter = OBJECT_SELF)
{
	int nNeutralCR	= FloatToInt(GetChallengeRating(oNPC));
	int nEncCR		= FloatToInt(GetChallengeRating(oEncounter));
	
	if (GetGlobalInt("00_bWeaponsUpgraded")==TRUE)
	{
		nNeutralCR+= 2;
	}
	
	if (GetGlobalInt("00_bArmorUpgraded")==TRUE)
	{
		nNeutralCR+= 2;
	}
	
	int nEncAdvantage = nEncCR - nNeutralCR;
	nEncAdvantage *= 5;
	
	int nEncWinChance = 50 + nEncAdvantage;
//	PrettyDebug("WinChance: " + IntToString(nEncWinChance));
	if (nEncWinChance < 5)
		nEncWinChance = 5;
		
	if (nEncWinChance > 95)
		nEncWinChance = 95;
		
	int nResult = Random(100)+1;
//	PrettyDebug("WinChance: " + IntToString(nEncWinChance));
//	PrettyDebug("Result: " +  IntToString(nResult));
	
	if(nResult > nEncWinChance)
		return NPC_COMBAT_RESULT_ENC_DAMAGE;
		
	else
		return NPC_COMBAT_RESULT_NPC_DAMAGE;
}

//Guard AI
void RunGuardAI(object oGuard = OBJECT_SELF)
{
	int nBehaviorState = GetLocalInt(oGuard, VAR_BEHAVIOR_STATE);
	
	object oChasing = GetLocalObject(oGuard, "oChasing");

	if(nBehaviorState == BEHAVIOR_STATE_NPC_COMBAT && GetIsObjectValid(oChasing))
	{
		return;
	}
	
	else if(nBehaviorState == BEHAVIOR_STATE_NPC_COMBAT)
	{
		DeleteLocalObject(oGuard, "oChasing");
		AssignCommand(oGuard, SetWalkCondition(NW_WALK_FLAG_PAUSED, FALSE));
		SetOLBehaviorState(BEHAVIOR_STATE_NONE, oGuard);
	}
	
	if(GetIsObjectValid(oChasing))
	{
		if(GetDistanceBetween(oGuard, oChasing) < ENCOUNTER_CONVERSATION_DISTANCE)
		{
			ClearAllActions(TRUE);
			SetOLBehaviorState(BEHAVIOR_STATE_NPC_COMBAT);
			AssignCommand(oChasing, TransitionToNPCCombat(oGuard));
		}
		
		else if(GetCurrentAction(oGuard) != ACTION_FOLLOW)
		{
			ClearAllActions(TRUE);
			AssignCommand(oGuard, ActionForceFollowObject(oChasing, 0.0f));
		}
	}

	
	location lGuard = GetLocation(oGuard);
	object oCreature = GetFirstObjectInShape(SHAPE_SPHERE, 5.0f, lGuard, TRUE);
	
	while(GetIsObjectValid(oCreature))
	{
		if(	GetLocalInt(oCreature, VAR_BEHAVIOR_STATE) != BEHAVIOR_STATE_NPC_CHASING &&
			GetLocalInt(oCreature, VAR_BEHAVIOR_STATE) != BEHAVIOR_STATE_NPC_COMBAT  &&
			GetLocalInt(oCreature, VAR_BEHAVIOR_STATE) != BEHAVIOR_STATE_FLEEING  	 &&
			GetLocalInt(oCreature, VAR_BEHAVIOR_STATE) != BEHAVIOR_STATE_DESPAWNING )
		{
			if(GetLocalInt(oCreature, "nLifespan") > 0 && !GetLocalInt(oCreature, "bAfraid") && GetLocalInt(OBJECT_SELF, "bSpecialEncounter") != TRUE)
			{

				ClearAllActions(TRUE);
				AssignCommand(oGuard, ActionForceFollowObject(oCreature, 0.0f));
				SetLocalObject(oGuard, "oChasing", oCreature);
			}
		}
		oCreature = GetNextObjectInShape(SHAPE_SPHERE, 5.0f, lGuard, TRUE);
	}
	
	if (GetWalkCondition(NW_WALK_FLAG_CONSTANT))
	{
		WalkWayPoints(TRUE, "heartbeat");
	}
}

// Randomly plays one of three combat stingers.
void PlayCombatStinger()
{
	int nNum = Random(3) + 1;
	string sStinger = "nx2_mus_entercombat" + IntToString(nNum);
	PlaySound(sStinger, TRUE);
	
	PrettyDebug("ginc_overland_ai: Playing combat stinger " + sStinger);
}