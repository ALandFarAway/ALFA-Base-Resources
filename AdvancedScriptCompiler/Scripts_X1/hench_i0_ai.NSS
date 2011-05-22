/*

     Companion and Monster AI

    This file contains functions used in the default On* scripts
    for combat. It acts as filter preventing the main hench_o0_ai
    from being called more than it needs to. (Usually only to start
    combat, heartbeat, or end combat round.)

*/

#include "hench_i0_generic"


// void main() {    }


// Resets the combat run script, used in heartbeat and combat round end
void HenchResetCombatRound();

// Sets the location of an unheard or unseen enemy
// Either moved out of range or did attack while not detected
void SetEnemyLocation(object oEnemy);

// Clears the last unheard, unseen enemy location
void ClearEnemyLocation();

// Moves to the last perceived enemy location
int MoveToLastSeenOrHeard(int bDoSearch = TRUE);

// check if ClearAllActions should be done (combat round end), returns TRUE if spellcasting in progress
int HenchCheckEventClearAllActions(int bEndOfRound);

// check if main combat script should be fired from heartbeat
int HenchCheckHeartbeatCombat();

// New determinecombatround call. Determines if call should cause
// main AI script to run
void HenchDetermineCombatRound(object oIntruder = OBJECT_INVALID, int bForceInterrupt = FALSE);

// start combat after action complete
void HenchStartCombatRoundAfterAction(object oTarget);

// start combat in delay command
void HenchStartCombatRoundAfterDelay(object oTarget);

// Simplified combat start, used by commoners
void HenchStartAttack(object oIntruder);

// modified TalentFlee routine
int HenchTalentFlee(object oIntruder = OBJECT_INVALID);

// modified GetNearestSeenOrHeardEnemy to not get dead creatures
object GetNearestSeenOrHeardEnemyNotDead(int bCheckIsPC = FALSE);

// modified DetermineSpecialBehavior, calls HenchDetermineCombatRound instead
void HenchDetermineSpecialBehavior(object oIntruder = OBJECT_INVALID);

// associate (henchman, etc.) determines if enemy is perceived or not
int HenchGetIsEnemyPerceived();

// modified TalentAdvancedBuff routine
int HenchTalentAdvancedBuff(float fDistance);

// get nearest ally that is higher in hit dice
object GetNearestTougherFriend(object oSelf, object oPC);

// main stealth and wandering code
int DoStealthAndWander();

// checks if stealth should be removed because you or nearby friend has been detected
void CheckRemoveStealth();

// try to step past block, otherwise reattack with ranged weapons or spells
void HenchTestStep(object oTarget, location oldLocation, int curTest);

// try to attack nearest enemy instead, otherwise random walk 
void HenchCheckAttackSecondaryTarget(object oOriginalTarget);

// move closer to target if attack fails
void HenchMoveAndDetermineCombatRound(object oTarget);

// move close to master if follow fails
void HenchMoveToMaster(object oMaster);


const int HENCH_AI_SCRIPT_NOT_RUN       = 0;
const int HENCH_AI_SCRIPT_IN_PROGRESS   = 1;
const int HENCH_AI_SCRIPT_ALREADY_RUN   = 2;

const float HENCH_AI_SCRIPT_DELAY       = 0.01;

const string HENCH_AI_SCRIPT_RUN_STATE      =  "AIIntruder";
const string HENCH_AI_SCRIPT_FORCE          =  "AIIntruderForce";
const string HENCH_AI_SCRIPT_INTRUDER_OBJ   =  "AIIntruderObj";
const string HENCH_AI_SCRIPT_POLL           =  "AIIntruderPoll";

const string sHenchLastHeardOrSeen          = "LastSeenOrHeard";


void HenchResetCombatRound()
{
    SetLocalObject(OBJECT_SELF, HENCH_AI_SCRIPT_INTRUDER_OBJ, OBJECT_INVALID);
    SetLocalInt(OBJECT_SELF, HENCH_AI_SCRIPT_FORCE, FALSE);
    SetLocalInt(OBJECT_SELF, HENCH_AI_SCRIPT_RUN_STATE, HENCH_AI_SCRIPT_NOT_RUN);
	DeleteLocalInt(OBJECT_SELF, HENCH_AI_BLOCKED);
}


void SetEnemyLocation(object oEnemy)
{
    SetLocalInt(OBJECT_SELF, sHenchLastHeardOrSeen, TRUE);
    location enemyLocation = GetLocation(oEnemy);
    SetLocalLocation(OBJECT_SELF, sHenchLastHeardOrSeen, enemyLocation);
}


void ClearEnemyLocation()
{
    DeleteLocalInt(OBJECT_SELF, sHenchLastHeardOrSeen);
    DeleteLocalLocation(OBJECT_SELF, sHenchLastHeardOrSeen);
}


int MoveToLastSeenOrHeard(int bDoSearch = TRUE)
{
    location moveToLoc = GetLocalLocation(OBJECT_SELF, sHenchLastHeardOrSeen);
    if (GetDistanceBetweenLocations(GetLocation(OBJECT_SELF), moveToLoc) <= 5.0)
    {
//  Jug_Debug("!1111" + GetName(OBJECT_SELF) + " start search " + LocationToString(moveToLoc));
        ClearAllActions();
        ClearEnemyLocation();
        // go to search
        // TODO add spells to help search
        if (bDoSearch)
        {
            // search around for awhile
            SetActionMode(OBJECT_SELF, ACTION_MODE_DETECT, TRUE);
            ActionRandomWalk();
            DelayCommand(10.0,  HenchDetermineCombatRound(OBJECT_INVALID, TRUE));
        }
        return FALSE;
    }
    else
    {
//      Jug_Debug("!1111" + GetName(OBJECT_SELF) + " moving to enemy location " + LocationToString(moveToLoc));
        ClearAllActions();
        location destLocation = CalcSafeLocation(OBJECT_SELF, moveToLoc, 15.0, FALSE, TRUE);
        if (GetDistanceBetweenLocations(destLocation, GetLocation(OBJECT_SELF)) > 0.1)
        {
//          Jug_Debug("!1111" + GetName(OBJECT_SELF) + " location distance " + FloatToString(GetDistanceBetweenLocations(destLocation, moveToLoc)) + " total distance " + FloatToString(GetDistanceBetweenLocations(destLocation, GetLocation(OBJECT_SELF))));
            ActionMoveToLocation(destLocation, TRUE);
            return TRUE;
        }
        else
        {
//          Jug_Debug("!1111" + GetName(OBJECT_SELF) + " locations the same " + LocationToString(moveToLoc));
            return FALSE;
        }
    }
}


int HenchCheckEventClearAllActions(int bEndOfRound)
{
    if (bEndOfRound)
    {
        DeleteLocalInt(OBJECT_SELF, HENCH_AI_SCRIPT_HB);
    }
    int nCurAction = GetCurrentAction();
//  Jug_Debug(GetName(OBJECT_SELF) + "  HenchCheckEventClearAllActions action " + IntToString(nCurAction));

    if (nCurAction == ACTION_ATTACKOBJECT)
    {
//		Jug_Debug(GetName(OBJECT_SELF) + " action attack");
        if (bEndOfRound)
        {
            ClearAllActions();
        }
    }
	else if (nCurAction == ACTION_INVALID)
	{
//		Jug_Debug(GetName(OBJECT_SELF) + " no action");
		ClearAllActions();
	}
    else if (nCurAction == ACTION_CASTSPELL || nCurAction == ACTION_ITEMCASTSPELL)
    {
        // check cancel if target has died
        // TODO better check for a location target spell
        object oLastSpellTarget = GetAttemptedSpellTarget();
//      	Jug_Debug(GetName(OBJECT_SELF) + " my target is " + GetName(oLastSpellTarget) + " ot " + IntToString(GetObjectType(oLastSpellTarget)) + " tag " + GetTag(oLastSpellTarget) + " hp " + IntToString(GetCurrentHitPoints(oLastSpellTarget)));
		                                                                                                                         
        if (!GetIsObjectValid(oLastSpellTarget) ||                         
            ( GetPartyMembersDyingFlag() == FALSE && GetCurrentHitPoints(oLastSpellTarget) > HENCH_BLEED_NEGHPS) ||
            ( GetSpellId() == SPELL_RAISE_DEAD || GetSpellId() == SPELL_RESURRECTION) )
        {
//			Jug_Debug(GetName(OBJECT_SELF) + " waiting for " + GetName(oLastSpellTarget));
            return TRUE;
        }
//		Jug_Debug(GetName(OBJECT_SELF) + " cancel " + Get2DAString("spells", "Label", GetSpellId()) + " vs " + GetName(oLastSpellTarget));
        // cancel spell - continue on
        ClearAllActions();
    }
	else if (nCurAction == ACTION_HEAL || nCurAction == ACTION_KIDAMAGE ||
        nCurAction == ACTION_SMITEGOOD || nCurAction == ACTION_TAUNT ||
		nCurAction == ACTION_REST)
//        nCurAction == ACTION_ANIMALEMPATHY || nCurAction == ACTION_COUNTERSPELL)
	{
//		Jug_Debug(GetName(OBJECT_SELF) + " other action");
		return TRUE;
	}
    else
    {
//		Jug_Debug(GetName(OBJECT_SELF) + " cancel 2");
		ClearAllActions();
    }
    return FALSE;
}


int HenchCheckHeartbeatCombat()
{
	DeleteLocalInt(OBJECT_SELF, HENCH_AI_BLOCKED);
    if (GetLocalInt(OBJECT_SELF, HENCH_AI_SCRIPT_HB))
    {
        return TRUE;
    }
    SetLocalInt(OBJECT_SELF, HENCH_AI_SCRIPT_HB, TRUE);
    int nCurAction = GetCurrentAction();
    return (nCurAction == ACTION_INVALID) || (nCurAction == ACTION_MOVETOPOINT) ||
        (nCurAction == ACTION_FOLLOW) || (nCurAction == HENCH_ACTION_MOVETOLOCATION);
}


void HenchDetermineCombatRound(object oIntruder = OBJECT_INVALID, int bForceInterrupt = FALSE)
{
//    Jug_Debug(GetName(OBJECT_SELF) + " det com round called with " + GetName(oIntruder) + " force = " + IntToString(bForceInterrupt));

    if(GetAssociateState(NW_ASC_IS_BUSY))
    {
        return;
    }

    string sAIScript = GetLocalString(OBJECT_SELF, "AIScript");
    if (sAIScript == "")
    {
        sAIScript = "hench_o0_ai";
    }

    if (bForceInterrupt)
    {
        SetLocalObject(OBJECT_SELF, HENCH_AI_SCRIPT_INTRUDER_OBJ, oIntruder);
        SetLocalInt(OBJECT_SELF, HENCH_AI_SCRIPT_FORCE, bForceInterrupt);
    }
    else if (GetIsObjectValid(oIntruder) && !GetLocalInt(OBJECT_SELF, HENCH_AI_SCRIPT_FORCE))
    {
        SetLocalObject(OBJECT_SELF, HENCH_AI_SCRIPT_INTRUDER_OBJ, oIntruder);
    }

        // check if we have to actually determine to rerun ai
    int iAIScriptRunState = GetLocalInt(OBJECT_SELF, HENCH_AI_SCRIPT_RUN_STATE);

    if (iAIScriptRunState == HENCH_AI_SCRIPT_IN_PROGRESS)
    {
        return;
    }

    if (bForceInterrupt)
    {
//      Jug_Debug(GetName(OBJECT_SELF) + " det com round using force");
        SetLocalInt(OBJECT_SELF, HENCH_AI_SCRIPT_RUN_STATE, HENCH_AI_SCRIPT_IN_PROGRESS);
        DelayCommand(HENCH_AI_SCRIPT_DELAY, ExecuteScript(sAIScript, OBJECT_SELF));
        return;
    }

    if (iAIScriptRunState == HENCH_AI_SCRIPT_NOT_RUN)
    {
        // first run of HenchDetermineCombatRound
//      Jug_Debug(GetName(OBJECT_SELF) + " det com round not run, do run");
        SetLocalInt(OBJECT_SELF, HENCH_AI_SCRIPT_RUN_STATE, HENCH_AI_SCRIPT_IN_PROGRESS);
        DelayCommand(HENCH_AI_SCRIPT_DELAY, ExecuteScript(sAIScript, OBJECT_SELF));
        return;
    }
    object oLastTarget = GetLocalObject(OBJECT_SELF, sHenchLastTarget);

    if (!GetIsObjectValid(oLastTarget) || GetIsDead(oLastTarget) || !GetIsEnemy(oLastTarget) || GetLocalInt(oLastTarget, sHenchRunningAway))
    {
        oLastTarget = OBJECT_INVALID;
    }
    else if (!GetObjectSeen(oLastTarget) && !GetObjectHeard(oLastTarget))
    {
        oLastTarget = OBJECT_INVALID;
    }
    if (!GetIsObjectValid(oLastTarget))
    {
        // prevent too many calls to main script if already moving to an unseen and
        // unheard monster
        if (!GetLocalInt(OBJECT_SELF, sHenchLastHeardOrSeen) || GetObjectSeen(oIntruder) || GetObjectHeard(oIntruder))
        {
//          Jug_Debug(GetName(OBJECT_SELF) + " det com round no last target");
            SetLocalInt(OBJECT_SELF, HENCH_AI_SCRIPT_RUN_STATE, HENCH_AI_SCRIPT_IN_PROGRESS);
            DelayCommand(HENCH_AI_SCRIPT_DELAY, ExecuteScript(sAIScript, OBJECT_SELF));
        }
    }
    else if (GetIsObjectValid(oIntruder))
    {
        if (GetDistanceToObject(oIntruder) <= 5.0 && GetDistanceToObject(oLastTarget) > 5.0)
        {
//          Jug_Debug(GetName(OBJECT_SELF) + " nearby with long distance target");
            SetLocalInt(OBJECT_SELF, HENCH_AI_SCRIPT_RUN_STATE, HENCH_AI_SCRIPT_IN_PROGRESS);
            DelayCommand(HENCH_AI_SCRIPT_DELAY, ExecuteScript(sAIScript, OBJECT_SELF));
        }
        else if (GetObjectSeen(oIntruder) && !GetObjectSeen(oLastTarget))
        {
//          Jug_Debug(GetName(OBJECT_SELF) + " target seen check");
            SetLocalInt(OBJECT_SELF, HENCH_AI_SCRIPT_RUN_STATE, HENCH_AI_SCRIPT_IN_PROGRESS);
            DelayCommand(HENCH_AI_SCRIPT_DELAY, ExecuteScript(sAIScript, OBJECT_SELF));
        }
    }
}


// start combat after action complete
void HenchStartCombatRoundAfterAction(object oTarget)
{
    SetLocalInt(OBJECT_SELF, HENCH_AI_SCRIPT_POLL, TRUE);
    ActionDoCommand(HenchDetermineCombatRound(oTarget, TRUE));
    DelayCommand(2.0, SetLocalInt(OBJECT_SELF, HENCH_AI_SCRIPT_POLL, FALSE));
}


void HenchStartCombatRoundAfterDelay(object oTarget)
{
    SetLocalInt(OBJECT_SELF, HENCH_AI_SCRIPT_POLL, FALSE);
    HenchDetermineCombatRound(oTarget, TRUE);
}


void HenchStartAttack(object oIntruder)
{
    SetLocalObject(OBJECT_SELF, HENCH_AI_SCRIPT_INTRUDER_OBJ, oIntruder);
    ExecuteScript("hench_o0_att", OBJECT_SELF);
}


// FLEE COMBAT AND HOSTILES
int HenchTalentFlee(object oIntruder = OBJECT_INVALID)
{
    object oTarget = oIntruder;
    if(!GetIsObjectValid(oIntruder))
    {
        oTarget = GetLastHostileActor();
        if(!GetIsObjectValid(oTarget) || GetIsDead(oTarget))
        {
            oTarget = GetNearestCreature(CREATURE_TYPE_REPUTATION, REPUTATION_TYPE_ENEMY, OBJECT_SELF, 1, CREATURE_TYPE_PERCEPTION, PERCEPTION_SEEN);
            float fDist = GetDistanceBetween(OBJECT_SELF, oTarget);
            if(!GetIsObjectValid(oTarget))
            {
                return FALSE;
            }
        }
    }
    ClearAllActions();
    //Look at this to remove the delay
    ActionMoveAwayFromObject(oTarget, TRUE, 10.0f);
    DelayCommand(4.0, ClearAllActions());
    return TRUE;
}


object GetNearestSeenOrHeardEnemyNotDead(int bCheckIsPC = FALSE)
{
    int curCount = 1;
    object oTarget;
    while (1)
    {
        oTarget = GetNearestCreature(CREATURE_TYPE_REPUTATION, REPUTATION_TYPE_ENEMY, OBJECT_SELF, curCount, CREATURE_TYPE_PERCEPTION, PERCEPTION_SEEN, CREATURE_TYPE_IS_ALIVE, TRUE);
        if (!GetIsObjectValid(oTarget))
        {
            break;
        }
        if (!GetPlotFlag(oTarget))
        {
            return oTarget;
        }
        curCount ++;
    }
    curCount = 1;
    while (1)
    {
        oTarget = GetNearestCreature(CREATURE_TYPE_REPUTATION, REPUTATION_TYPE_ENEMY, OBJECT_SELF, curCount, CREATURE_TYPE_PERCEPTION, PERCEPTION_HEARD_AND_NOT_SEEN, CREATURE_TYPE_IS_ALIVE, TRUE);
        if (!GetIsObjectValid(oTarget))
        {
            return OBJECT_INVALID;
        }
        if (!GetPlotFlag(oTarget) && !(bCheckIsPC && GetIsPCGroup(oTarget)) && LineOfSightObject(OBJECT_SELF, oTarget))
        {
            return oTarget;
        }
        curCount++;
    }
    return OBJECT_INVALID;
}


//::///////////////////////////////////////////////
//:: Determine Special Behavior
//:: Copyright (c) 2001 Bioware Corp.
//:://////////////////////////////////////////////
/*
    Determines the special behavior used by the NPC.
    Generally all NPCs who you want to behave differently
    than the default behavior.
    For these behaviors, passing in a valid object will
    cause the creature to become hostile the attacker.

    MODIFIED February 7 2003:
    - Rearranged logic order a little so that the creatures
    will actually randomwalk when not fighting

    - Modified by Tony K to call HenchDetermineCombatRound

    - Modified by LoCash (Jan 12-Mar 06 2004):
      BW's original function was completely broken, it needed
      to be re-written. original code by "fendis_khan".
      many enhancements made. herbivores now work
      "out of the box" as they should, omnivores need faction
      changed to a non-Hostile. Check "Animals" in the Toolset's
      Monster palette for various examples of creatures using
      omnivore, herbivore spawn scripts.

*/
//:://////////////////////////////////////////////
//:: Created By: Preston Watamaniuk
//:: Created On: Dec 14, 2001
//:://////////////////////////////////////////////

void HenchDetermineSpecialBehavior(object oIntruder = OBJECT_INVALID)
{
    object oTarget = GetNearestCreature(CREATURE_TYPE_PERCEPTION, PERCEPTION_SEEN, OBJECT_SELF, 1,
                                        CREATURE_TYPE_REPUTATION, REPUTATION_TYPE_ENEMY);

    // Omnivore behavior routine
    if(GetBehaviorState(NW_FLAG_BEHAVIOR_OMNIVORE))
    {
        // no current attacker and not currently in combat
        if(!GetIsObjectValid(oIntruder) && !GetIsInCombat())
        {
            // does not have a current target
            if(!GetIsObjectValid(GetAttemptedAttackTarget()) &&
               !GetIsObjectValid(GetAttemptedSpellTarget()) &&
               !GetIsObjectValid(GetAttackTarget()))
            {
                // enemy creature nearby
                if(GetIsObjectValid(oTarget) && GetDistanceToObject(oTarget) <= 13.0)
                {
                    ClearAllActions();
                    HenchDetermineCombatRound(oTarget);
                    return;
                }
                int nTarget = 1;
                oTarget = GetNearestCreature(CREATURE_TYPE_PERCEPTION, PERCEPTION_SEEN, OBJECT_SELF, nTarget,
                                             CREATURE_TYPE_REPUTATION, REPUTATION_TYPE_NEUTRAL);

                // neutral creature, too close
                while(GetIsObjectValid(oTarget) && GetDistanceToObject(oTarget) <= 7.0)
                {
                    if(GetLevelByClass(CLASS_TYPE_DRUID, oTarget) == 0 && GetLevelByClass(CLASS_TYPE_RANGER, oTarget) == 0 && GetAssociateType(oTarget) != ASSOCIATE_TYPE_ANIMALCOMPANION)
                    {
                        // oTarget has neutral reputation, and is NOT a druid or ranger or an "Animal Companion"
                        SetLocalInt(OBJECT_SELF, "lcTempEnemy", 8);
                        SetIsTemporaryEnemy(oTarget);
                        ClearAllActions();
                        HenchDetermineCombatRound(oTarget);
                        return;
                    }
                    oTarget = GetNearestCreature(CREATURE_TYPE_PERCEPTION, PERCEPTION_SEEN, OBJECT_SELF, ++nTarget,
                                                 CREATURE_TYPE_REPUTATION, REPUTATION_TYPE_NEUTRAL);
                }

                // non friend creature, too close
                nTarget = 1;
                oTarget = GetNearestCreature(CREATURE_TYPE_PERCEPTION, PERCEPTION_HEARD_AND_NOT_SEEN, OBJECT_SELF, nTarget);

                // heard neutral or enemy creature, too close
                while(GetIsObjectValid(oTarget) && GetDistanceToObject(oTarget) <= 7.0)
                {
                    if(!GetIsFriend(oTarget) && GetLevelByClass(CLASS_TYPE_DRUID, oTarget) == 0 && GetLevelByClass(CLASS_TYPE_RANGER, oTarget) == 0 && GetAssociateType(oTarget) != ASSOCIATE_TYPE_ANIMALCOMPANION)
                    {
                        // oTarget has neutral reputation, and is NOT a druid or ranger or an "Animal Companion"
                        SetLocalInt(OBJECT_SELF, "lcTempEnemy", 8);
                        SetIsTemporaryEnemy(oTarget);
                        ClearAllActions();
                        HenchDetermineCombatRound(oTarget);
                        return;
                    }
                    oTarget = GetNearestCreature(CREATURE_TYPE_PERCEPTION, PERCEPTION_HEARD_AND_NOT_SEEN, OBJECT_SELF, ++nTarget);
                }

                if(!IsInConversation(OBJECT_SELF))
                {
                    // 25% chance of just standing around instead of constantly
                    // randWalking; i thought it looked odd seeing the animal(s)
                    // in a constant state of movement, was not realistic,
                    // at least according to my Nat'l Geographic videos
                    if ( (d4() != 1) && (GetCurrentAction() == ACTION_RANDOMWALK) )
                    {
                        return;
                    }
                    else if ( (d4() == 1) && (GetCurrentAction() == ACTION_RANDOMWALK) )
                    {
                        ClearAllActions();
                        return;
                    }
                    else
                    {
                        ClearAllActions();
                        ActionRandomWalk();
                        return;
                    }
                }
            }
        }
        else if(!IsInConversation(OBJECT_SELF)) // enter combat when attacked
        {
            // after a while (20-25 seconds), omnivore (boar) "gives up"
            // chasing someone who didn't hurt it. but if the person fought back
            // this condition won't run and the boar will fight to death
            if(GetLocalInt(OBJECT_SELF, "lcTempEnemy") != FALSE && (GetLastDamager() == OBJECT_INVALID || GetLastDamager() != oTarget) )
            {
                int nPatience = GetLocalInt(OBJECT_SELF, "lcTempEnemy");
                if (nPatience <= 1)
                {
                    ClearAllActions();
                    ClearPersonalReputation(oTarget);  // reset reputation
                    DeleteLocalInt(OBJECT_SELF, "lcTempEnemy");
                    return;
                }
                SetLocalInt(OBJECT_SELF, "lcTempEnemy", --nPatience);
            }
            ClearAllActions();
            HenchDetermineCombatRound(oIntruder);
        }
    }

    // Herbivore behavior routine
    else if(GetBehaviorState(NW_FLAG_BEHAVIOR_HERBIVORE))
    {
        // no current attacker & not currently in combat
        if(!GetIsObjectValid(oIntruder) && (GetIsInCombat() == FALSE))
        {
            if(!GetIsObjectValid(GetAttemptedAttackTarget()) && // does not have a current target
               !GetIsObjectValid(GetAttemptedSpellTarget()) &&
               !GetIsObjectValid(GetAttackTarget()))
            {
                // NWN2 OC uses the herbivore for NPCs, don't have them run away
                if (((GetRacialType(OBJECT_SELF) == RACIAL_TYPE_ANIMAL) || (GetRacialType(OBJECT_SELF) == RACIAL_TYPE_BEAST)) &&
                    (GetAppearanceType(OBJECT_SELF) > APPEARANCE_TYPE_HUMAN))
                {
                    if(GetIsObjectValid(oTarget) && GetDistanceToObject(oTarget) <= 13.0) // enemy creature, too close
                    {
                        ClearAllActions();
                        ActionMoveAwayFromObject(oTarget, TRUE, 16.0); // flee from enemy
                        return;
                    }
                    int nTarget = 1;
                    oTarget = GetNearestCreature(CREATURE_TYPE_PERCEPTION, PERCEPTION_SEEN, OBJECT_SELF, nTarget,
                                                 CREATURE_TYPE_REPUTATION, REPUTATION_TYPE_NEUTRAL);
                    while(GetIsObjectValid(oTarget) && GetDistanceToObject(oTarget) <= 7.0) // only consider close creatures
                    {
                        if(GetLevelByClass(CLASS_TYPE_DRUID, oTarget) == 0 && GetLevelByClass(CLASS_TYPE_RANGER, oTarget) == 0 && GetAssociateType(oTarget) != ASSOCIATE_TYPE_ANIMALCOMPANION)
                        {
                            // oTarget has neutral reputation, and is NOT a druid or ranger or Animal Companion
                            ClearAllActions();
                            ActionMoveAwayFromObject(oTarget, TRUE, 16.0); // run away
                            return;
                        }
                        oTarget = GetNearestCreature(CREATURE_TYPE_PERCEPTION, PERCEPTION_SEEN, OBJECT_SELF, ++nTarget,
                                                     CREATURE_TYPE_REPUTATION, REPUTATION_TYPE_NEUTRAL);
                    }
                    nTarget = 1;
                    oTarget = GetNearestCreature(CREATURE_TYPE_PERCEPTION, PERCEPTION_HEARD_AND_NOT_SEEN, OBJECT_SELF, nTarget);
                    while(GetIsObjectValid(oTarget) && GetDistanceToObject(oTarget) <= 7.0) // only consider close creatures
                    {
                        if(!GetIsFriend(oTarget) && GetLevelByClass(CLASS_TYPE_DRUID, oTarget) == 0 && GetLevelByClass(CLASS_TYPE_RANGER, oTarget) == 0 && GetAssociateType(oTarget) != ASSOCIATE_TYPE_ANIMALCOMPANION)
                        {
                            // oTarget has neutral reputation, and is NOT a druid or ranger or Animal Companion
                            ClearAllActions();
                            ActionMoveAwayFromObject(oTarget, TRUE, 16.0); // run away
                            return;
                        }
                        oTarget = GetNearestCreature(CREATURE_TYPE_PERCEPTION, PERCEPTION_HEARD_AND_NOT_SEEN, OBJECT_SELF, ++nTarget);
                    }
                    if(!IsInConversation(OBJECT_SELF))
                    {
                        // 75% chance of randomWalking around, 25% chance of just standing there. more realistic
                        if ( (d4() != 1) && (GetCurrentAction() == ACTION_RANDOMWALK) )
                        {
                            return;
                        }
                        else if ( (d4() == 1) && (GetCurrentAction() == ACTION_RANDOMWALK) )
                        {
                            ClearAllActions();
                            return;
                        }
                        else
                        {
                            ClearAllActions();
                            ActionRandomWalk();
                            return;
                        }
                    }
                }
            }
        }
        else if (!IsInConversation(OBJECT_SELF)) // NEW BEHAVIOR - run away when attacked
        {
            // NWN2 OC uses the herbivore for NPCs, don't have them run away
            if (((GetRacialType(OBJECT_SELF) == RACIAL_TYPE_ANIMAL) || (GetRacialType(OBJECT_SELF) == RACIAL_TYPE_BEAST)) &&
                (GetAppearanceType(OBJECT_SELF) > APPEARANCE_TYPE_HUMAN))
            {
                ClearAllActions();
                ActionMoveAwayFromLocation(GetLocation(OBJECT_SELF), TRUE, 16.0);
            }
            else
            {
                ClearAllActions();
                ActionRandomWalk();
            }
        }
    }
}


int HenchGetIsEnemyPerceived()
{
    object oClosestSeen = GetNearestCreature(CREATURE_TYPE_REPUTATION, REPUTATION_TYPE_ENEMY,
                    OBJECT_SELF, 1, CREATURE_TYPE_PERCEPTION, PERCEPTION_SEEN,
                    CREATURE_TYPE_IS_ALIVE, TRUE);

    if (GetIsObjectValid(oClosestSeen))
    {
//      Jug_Debug(GetName(OBJECT_SELF) + " seen enemy " + GetName(oClosestSeen));
        return TRUE;
    }
    object oClosestHeard = GetNearestCreature(CREATURE_TYPE_REPUTATION, REPUTATION_TYPE_ENEMY,
                    OBJECT_SELF, 1, CREATURE_TYPE_PERCEPTION, PERCEPTION_HEARD_AND_NOT_SEEN,
                    CREATURE_TYPE_IS_ALIVE, TRUE);
    if (GetIsObjectValid(oClosestHeard))
    {
//      Jug_Debug(GetName(OBJECT_SELF) + " heard enemy " + GetName(oClosestHeard) + " distance " + FloatToString(GetDistanceToObject(oClosestHeard)));
        if (GetDistanceToObject(oClosestHeard) > fHenchHearingDistance)
        {
            return FALSE;
        }
        object oRealMaster = GetFactionLeader(OBJECT_SELF);
        if (GetIsObjectValid(oRealMaster))
        {
            if (GetDistanceBetween(oRealMaster, oClosestHeard) <= fHenchMasterHearingDistance)
            {
                return HenchEnemyOnOtherSideOfUncheckedDoor(oClosestHeard);
            }
        }
    }
    return FALSE;
}


// FAST BUFF SELF
int HenchTalentAdvancedBuff(float fDistance)
{
    object oPC = GetNearestCreature(CREATURE_TYPE_PLAYER_CHAR, PLAYER_CHAR_IS_PC, OBJECT_SELF, 1, CREATURE_TYPE_REPUTATION, REPUTATION_TYPE_ENEMY);
    if(GetIsObjectValid(oPC) && GetDistanceToObject(oPC) <= fDistance)
    {
        if(!GetIsFighting(OBJECT_SELF))
        {
            ClearAllActions();
            //Combat Protections
            if(GetHasSpell(SPELL_PREMONITION))
            {
                ActionCastSpellAtObject(SPELL_PREMONITION, OBJECT_SELF, METAMAGIC_NONE, FALSE, 0, PROJECTILE_PATH_TYPE_DEFAULT, TRUE);
            }
            else if(GetHasSpell(SPELL_GREATER_STONESKIN))
            {
                ActionCastSpellAtObject(SPELL_GREATER_STONESKIN, OBJECT_SELF, METAMAGIC_NONE, 0, FALSE, PROJECTILE_PATH_TYPE_DEFAULT, TRUE);
            }
            else if(GetHasSpell(SPELL_STONESKIN))
            {
                ActionCastSpellAtObject(SPELL_STONESKIN, OBJECT_SELF, METAMAGIC_NONE, FALSE, 0, PROJECTILE_PATH_TYPE_DEFAULT, TRUE);
            }
            //Visage Protections
            if(GetHasSpell(SPELL_SHADOW_SHIELD))
            {
                ActionCastSpellAtObject(SPELL_SHADOW_SHIELD, OBJECT_SELF, METAMAGIC_NONE, FALSE, 0, PROJECTILE_PATH_TYPE_DEFAULT, TRUE);
            }
            else if(GetHasSpell(SPELL_ETHEREAL_VISAGE))
            {
                ActionCastSpellAtObject(SPELL_ETHEREAL_VISAGE, OBJECT_SELF, METAMAGIC_NONE, FALSE, 0, PROJECTILE_PATH_TYPE_DEFAULT, TRUE);
            }
            else if(GetHasSpell(SPELL_GHOSTLY_VISAGE))
            {
                ActionCastSpellAtObject(SPELL_GHOSTLY_VISAGE, OBJECT_SELF, METAMAGIC_NONE, FALSE, 0, PROJECTILE_PATH_TYPE_DEFAULT, TRUE);
            }
            //Mantle Protections
            if(GetHasSpell(SPELL_GREATER_SPELL_MANTLE))
            {
                ActionCastSpellAtObject(SPELL_GREATER_SPELL_MANTLE, OBJECT_SELF, METAMAGIC_NONE, FALSE, 0, PROJECTILE_PATH_TYPE_DEFAULT, TRUE);
            }
            else if(GetHasSpell(SPELL_SPELL_MANTLE))
            {
                ActionCastSpellAtObject(SPELL_SPELL_MANTLE, OBJECT_SELF, METAMAGIC_NONE, FALSE, 0, PROJECTILE_PATH_TYPE_DEFAULT, TRUE);
            }
            else if(GetHasSpell(SPELL_LESSER_SPELL_BREACH))
            {
                ActionCastSpellAtObject(SPELL_LESSER_SPELL_BREACH, OBJECT_SELF, METAMAGIC_NONE, FALSE, 0, PROJECTILE_PATH_TYPE_DEFAULT, TRUE);
            }
            // Globes
            if(GetHasSpell(SPELL_GLOBE_OF_INVULNERABILITY))
            {
                ActionCastSpellAtObject(SPELL_GLOBE_OF_INVULNERABILITY, OBJECT_SELF, METAMAGIC_NONE, FALSE, 0, PROJECTILE_PATH_TYPE_DEFAULT, TRUE);
            }
            else if(GetHasSpell(SPELL_LESSER_GLOBE_OF_INVULNERABILITY))
            {
                ActionCastSpellAtObject(SPELL_LESSER_GLOBE_OF_INVULNERABILITY, OBJECT_SELF, METAMAGIC_NONE, FALSE, 0, PROJECTILE_PATH_TYPE_DEFAULT, TRUE);
            }

            //Misc Protections
            if(GetHasSpell(SPELL_ELEMENTAL_SHIELD))
            {
                ActionCastSpellAtObject(SPELL_ELEMENTAL_SHIELD, OBJECT_SELF, METAMAGIC_NONE, FALSE, 0, PROJECTILE_PATH_TYPE_DEFAULT, TRUE);
            }
            else if (GetHasSpell(SPELL_MESTILS_ACID_SHEATH)&& !GetHasSpellEffect(SPELL_MESTILS_ACID_SHEATH))
            {
                ActionCastSpellAtObject(SPELL_MESTILS_ACID_SHEATH, OBJECT_SELF, METAMAGIC_NONE, FALSE, 0, PROJECTILE_PATH_TYPE_DEFAULT, TRUE);
            }
            else if (GetHasSpell(SPELL_DEATH_ARMOR)&& !GetHasSpellEffect(SPELL_DEATH_ARMOR))
            {
                ActionCastSpellAtObject(SPELL_DEATH_ARMOR, OBJECT_SELF, METAMAGIC_NONE, FALSE, 0, PROJECTILE_PATH_TYPE_DEFAULT, TRUE);
            }

            //Elemental Protections
            if(GetHasSpell(SPELL_PROTECTION_FROM_ENERGY))
            {
                ActionCastSpellAtObject(SPELL_PROTECTION_FROM_ENERGY, OBJECT_SELF, METAMAGIC_NONE, FALSE, 0, PROJECTILE_PATH_TYPE_DEFAULT, TRUE);
            }
            else if(GetHasSpell(SPELL_RESIST_ENERGY))
            {
                ActionCastSpellAtObject(SPELL_RESIST_ENERGY, OBJECT_SELF, METAMAGIC_NONE, FALSE, 0, PROJECTILE_PATH_TYPE_DEFAULT, TRUE);
            }
            else if(GetHasSpell(SPELL_ENDURE_ELEMENTS))
            {
                ActionCastSpellAtObject(SPELL_ENDURE_ELEMENTS, OBJECT_SELF, METAMAGIC_NONE, FALSE, 0, PROJECTILE_PATH_TYPE_DEFAULT, TRUE);
            }

            //Mental Protections
            if(GetHasSpell(SPELL_MIND_BLANK))
            {
                ActionCastSpellAtObject(SPELL_MIND_BLANK, OBJECT_SELF, METAMAGIC_NONE, FALSE, 0, PROJECTILE_PATH_TYPE_DEFAULT, TRUE);
            }
            else if(GetHasSpell(SPELL_LESSER_MIND_BLANK))
            {
                ActionCastSpellAtObject(SPELL_LESSER_MIND_BLANK, OBJECT_SELF, METAMAGIC_NONE, FALSE, 0, PROJECTILE_PATH_TYPE_DEFAULT, TRUE);
            }
            else if(GetHasSpell(SPELL_CLARITY))
            {
                ActionCastSpellAtObject(SPELL_CLARITY, OBJECT_SELF, METAMAGIC_NONE, FALSE, 0, PROJECTILE_PATH_TYPE_DEFAULT, TRUE);
            }
            //Summon Ally
            // TODO add gate!!!!
            if(GetHasSpell(SPELL_BLACK_BLADE_OF_DISASTER))
            {
                ActionCastSpellAtLocation(SPELL_BLACK_BLADE_OF_DISASTER, GetLocation(OBJECT_SELF), METAMAGIC_NONE, FALSE, PROJECTILE_PATH_TYPE_DEFAULT, TRUE);
            }
            else if(GetHasSpell(SPELL_ELEMENTAL_SWARM))
            {
                ActionCastSpellAtLocation(SPELL_ELEMENTAL_SWARM, GetLocation(OBJECT_SELF), METAMAGIC_NONE, FALSE, PROJECTILE_PATH_TYPE_DEFAULT, TRUE);
            }
            else if(GetHasSpell(SPELL_SUMMON_CREATURE_IX))
            {
                ActionCastSpellAtLocation(SPELL_SUMMON_CREATURE_IX, GetLocation(OBJECT_SELF), METAMAGIC_NONE, FALSE, PROJECTILE_PATH_TYPE_DEFAULT, TRUE);
            }
            else if(GetHasSpell(SPELL_CREATE_GREATER_UNDEAD))
            {
                ActionCastSpellAtLocation(SPELL_CREATE_GREATER_UNDEAD, GetLocation(OBJECT_SELF), METAMAGIC_NONE, FALSE, PROJECTILE_PATH_TYPE_DEFAULT, TRUE);
            }
            else if(GetHasSpell(SPELL_GREATER_PLANAR_BINDING))
            {
                ActionCastSpellAtLocation(SPELL_GREATER_PLANAR_BINDING, GetLocation(OBJECT_SELF), METAMAGIC_NONE, FALSE, PROJECTILE_PATH_TYPE_DEFAULT, TRUE);
            }
            else if(GetHasSpell(SPELL_SUMMON_CREATURE_VIII))
            {
                ActionCastSpellAtLocation(SPELL_SUMMON_CREATURE_VIII, GetLocation(OBJECT_SELF), METAMAGIC_NONE, FALSE, PROJECTILE_PATH_TYPE_DEFAULT, TRUE);
            }
            else if(GetHasSpell(SPELL_MORDENKAINENS_SWORD))
            {
                ActionCastSpellAtLocation(SPELL_MORDENKAINENS_SWORD, GetLocation(OBJECT_SELF), METAMAGIC_NONE, FALSE, PROJECTILE_PATH_TYPE_DEFAULT, TRUE);
            }
            else if(GetHasSpell(SPELL_SUMMON_CREATURE_VII))
            {
                ActionCastSpellAtLocation(SPELL_SUMMON_CREATURE_VII, GetLocation(OBJECT_SELF), METAMAGIC_NONE, FALSE, PROJECTILE_PATH_TYPE_DEFAULT, TRUE);
            }
            else if(GetHasSpell(SPELL_CREATE_UNDEAD))
            {
                ActionCastSpellAtLocation(SPELL_CREATE_UNDEAD, GetLocation(OBJECT_SELF), METAMAGIC_NONE, FALSE, PROJECTILE_PATH_TYPE_DEFAULT, TRUE);
            }
            else if(GetHasSpell(SPELL_PLANAR_BINDING))
            {
                ActionCastSpellAtLocation(SPELL_PLANAR_BINDING, GetLocation(OBJECT_SELF), METAMAGIC_NONE, FALSE, PROJECTILE_PATH_TYPE_DEFAULT, TRUE);
            }
            else if(GetHasSpell(SPELL_SUMMON_CREATURE_VI))
            {
                ActionCastSpellAtLocation(SPELL_SUMMON_CREATURE_VI, GetLocation(OBJECT_SELF), METAMAGIC_NONE, FALSE, PROJECTILE_PATH_TYPE_DEFAULT, TRUE);
            }
            else if(GetHasSpell(SPELL_SUMMON_CREATURE_V))
            {
                ActionCastSpellAtLocation(SPELL_SUMMON_CREATURE_V, GetLocation(OBJECT_SELF), METAMAGIC_NONE, FALSE, PROJECTILE_PATH_TYPE_DEFAULT, TRUE);
            }
            else if(GetHasSpell(SPELLABILITY_SUMMON_SLAAD))
            {
                ActionCastSpellAtLocation(SPELLABILITY_SUMMON_SLAAD, GetLocation(OBJECT_SELF), METAMAGIC_NONE, FALSE, PROJECTILE_PATH_TYPE_DEFAULT, TRUE);
            }
            else if(GetHasSpell(SPELLABILITY_SUMMON_TANARRI))
            {
                ActionCastSpellAtLocation(SPELLABILITY_SUMMON_TANARRI, GetLocation(OBJECT_SELF), METAMAGIC_NONE, FALSE, PROJECTILE_PATH_TYPE_DEFAULT, TRUE);
            }
            else if(GetHasSpell(SPELLABILITY_SUMMON_MEPHIT))
            {
                ActionCastSpellAtLocation(SPELLABILITY_SUMMON_MEPHIT, GetLocation(OBJECT_SELF), METAMAGIC_NONE, FALSE, PROJECTILE_PATH_TYPE_DEFAULT, TRUE);
            }
            else if(GetHasSpell(SPELLABILITY_SUMMON_CELESTIAL))
            {
                ActionCastSpellAtLocation(SPELLABILITY_SUMMON_CELESTIAL, GetLocation(OBJECT_SELF), METAMAGIC_NONE, FALSE, PROJECTILE_PATH_TYPE_DEFAULT, TRUE);
            }
            else if(GetHasSpell(SPELL_ANIMATE_DEAD))
            {
                ActionCastSpellAtLocation(SPELL_ANIMATE_DEAD, GetLocation(OBJECT_SELF), METAMAGIC_NONE, FALSE, PROJECTILE_PATH_TYPE_DEFAULT, TRUE);
            }
            else if(GetHasSpell(SPELL_SUMMON_CREATURE_IV))
            {
                ActionCastSpellAtLocation(SPELL_SUMMON_CREATURE_IV, GetLocation(OBJECT_SELF), METAMAGIC_NONE, FALSE, PROJECTILE_PATH_TYPE_DEFAULT, TRUE);
            }
            else if(GetHasSpell(SPELL_SUMMON_CREATURE_III))
            {
                ActionCastSpellAtLocation(SPELL_SUMMON_CREATURE_III, GetLocation(OBJECT_SELF), METAMAGIC_NONE, FALSE, PROJECTILE_PATH_TYPE_DEFAULT, TRUE);
            }
            else if(GetHasSpell(SPELL_SUMMON_CREATURE_II))
            {
                ActionCastSpellAtLocation(SPELL_SUMMON_CREATURE_II, GetLocation(OBJECT_SELF), METAMAGIC_NONE, FALSE, PROJECTILE_PATH_TYPE_DEFAULT, TRUE);
            }
            else if(GetHasSpell(SPELL_SUMMON_CREATURE_I))
            {
                ActionCastSpellAtLocation(SPELL_SUMMON_CREATURE_I, GetLocation(OBJECT_SELF), METAMAGIC_NONE, FALSE, PROJECTILE_PATH_TYPE_DEFAULT, TRUE);
            }
            return TRUE;
        }
    }
    return FALSE;
}


object GetNearestTougherFriend(object oSelf, object oPC)
{
    int i = 0;

    object oFriend = oSelf;

    int nEqual = 0;
    int nNear = 0;
    while (GetIsObjectValid(oFriend))
    {
        if (GetDistanceBetween(oSelf, oFriend) < 40.0 && oFriend != oSelf)
        {
            ++nNear;
            if (GetHitDice(oFriend) > GetHitDice(oSelf))
                return oFriend;
            if (GetHitDice(oFriend) == GetHitDice(oSelf))
                ++nEqual;
        }
        ++i;
        oFriend =  GetNearestCreature(CREATURE_TYPE_REPUTATION, REPUTATION_TYPE_FRIEND,
            oSelf, i);
    }

    SetLocalInt(OBJECT_SELF,"LocalBoss",FALSE);
    if (nEqual == 0)
        if (nNear > 0 || GetHitDice(oPC) - GetHitDice(OBJECT_SELF) < 2)
    {
        SetLocalInt(OBJECT_SELF,"LocalBoss",TRUE);
    }

    return OBJECT_INVALID;
}


// Auldar: Configurable distance at which to "hide", if the PC, or PC's Associate is within that distance.
// TK 40 doesn't seem to be far enough
const float stealthDistThresh = 80.0;

int DoStealthAndWander()
{
    // Pausanias: monsters try to find you.
    int scoutMode = GetLocalInt(OBJECT_SELF, sHenchScoutMode);
    if (scoutMode == 0)
    {
        scoutMode = d2();
        SetLocalInt(OBJECT_SELF, sHenchScoutMode, scoutMode);
    }
    if (GetPlotFlag(OBJECT_SELF))
    {
        return FALSE;
    }
    int nStealthAndWander = GetHenchOption(HENCH_OPTION_STEALTH | HENCH_OPTION_WANDER);
    if (!nStealthAndWander)
    {
        return FALSE;
    }

    // Auldar: and they now stealth if they have some skill points (and not marked with plot flag)
    object oNearestHostile = GetNearestCreature(CREATURE_TYPE_REPUTATION, REPUTATION_TYPE_ENEMY);

//  Jug_Debug(GetName(OBJECT_SELF) + " nearest hostile is " + GetName(oNearestHostile));

    if (!GetIsObjectValid(oNearestHostile))
    {
        return FALSE;
    }
    object oPC = GetFactionLeader(oNearestHostile);
    if (!GetIsObjectValid(oPC))
    {
        return FALSE;
    }

//  Jug_Debug(GetName(OBJECT_SELF) + " continue wander check");

    int bActionsCleared = FALSE;
    if ((nStealthAndWander & HENCH_OPTION_STEALTH) && !GetPlotFlag(OBJECT_SELF) &&
        !GetActionMode(OBJECT_SELF, ACTION_MODE_STEALTH))
    {
        // Auldar: Checking if the NPC is hostile to the PC and has skill points in Hide
        // or move silently, and it not marked Plot. If so, go stealthy even if not flagged
        // by the module creator as Stealth on spawn, as long as the PC or associate is hostile and close.
        if (CheckStealth())
        {
                // Auldar: Check how far away the nearest hostile Creature is
            float enemyDistance = GetDistanceToObject(oNearestHostile);

            if ((enemyDistance <= stealthDistThresh) && (enemyDistance != -1.0))
            {
                ClearAllActions();
                bActionsCleared = TRUE;
                SetActionMode(OBJECT_SELF, ACTION_MODE_STEALTH, TRUE);
            }
        }
        // Auldar: here ends Auldar's NPC stealth code. Back to Paus' work :)
    }
        // Auldar: Reducing the distance from 40.0 to 25.0 to reduce the "bloodbath" effect
        // requested by FoxBat.
    if ((nStealthAndWander & HENCH_OPTION_WANDER) && GetDistanceToObject(oPC) < 25.0)
    {
        object oTarget = GetNearestTougherFriend(OBJECT_SELF,oPC);
        if (!GetLocalInt(OBJECT_SELF, "LocalBoss"))
        {
            int fDist = 15;
            if (!GetIsObjectValid(oTarget) || scoutMode == 1)
            {
                fDist = 10;
                oTarget = oPC;
                if (d10() > 5) fDist = 25;
            }
//          Jug_Debug(GetName(OBJECT_SELF) + " doing wander");
            location lNew;
            if (GetLocalInt(OBJECT_SELF, "OpenedDoor"))
            {
                lNew = GetLocalLocation(OBJECT_SELF, "ScoutZone");
                SetLocalInt(OBJECT_SELF, "OpenedDoor", FALSE);
            }
            else
            {
                vector vLoc = GetPosition(oTarget);
                vLoc.x += fDist-IntToFloat(Random(2*fDist+1));
                vLoc.y += fDist-IntToFloat(Random(2*fDist+1));
                vLoc.z += fDist-IntToFloat(Random(2*fDist+1));
                lNew = Location(GetArea(oTarget),vLoc,0.);
                SetLocalLocation(OBJECT_SELF, "ScoutZone", lNew);
            }
            if (!bActionsCleared)
            {
                ClearAllActions();
            }
            ActionMoveToLocation(lNew);
            return TRUE;
        }
    }
    return FALSE;
}


void CheckRemoveStealth()
{
    if (GetActionMode(OBJECT_SELF, ACTION_MODE_STEALTH))
    {
        int iCheckStealthAmount = GetSkillRank(SKILL_HIDE) + GetSkillRank(SKILL_MOVE_SILENTLY) + 5;

        SetActionMode(OBJECT_SELF, ACTION_MODE_STEALTH, FALSE);

        location testLocation = GetLocation(OBJECT_SELF);

        object oCreature = GetFirstObjectInShape(SHAPE_SPHERE, 15.0, testLocation, TRUE);
        while(GetIsObjectValid(oCreature))
        {
            if (GetActionMode(oCreature, ACTION_MODE_STEALTH) &&
                (GetFactionEqual(oCreature) || GetIsFriend(oCreature)) &&
                !GetIsPC(oCreature))
            {
                if (GetSkillRank(SKILL_HIDE, oCreature) + GetSkillRank(SKILL_MOVE_SILENTLY, oCreature) <= iCheckStealthAmount)
                {
//                  Jug_Debug(GetName(OBJECT_SELF) + " turning off stealth for + " + GetName(oCreature));
                    SetActionMode(oCreature, ACTION_MODE_STEALTH, FALSE);
                }
            }
            oCreature = GetNextObjectInShape(SHAPE_SPHERE, 15.0, testLocation, TRUE);
        }
    }
}


const int HENCH_STEP_FORWARD 	= 0;
const int HENCH_STEP_RIGHT 		= 1;
const int HENCH_STEP_LEFT 		= 2;
const int HENCH_STEP_NONE 		= 3;

void HenchTestStep(object oTarget, location oldLocation, int curTest)
{
//	Jug_Debug("^^^^^^^^^" + GetName(OBJECT_SELF) + " HenchTestStep" + IntToString(curTest) + " " + IntToString(GetCurrentAction(OBJECT_SELF)));
	if (GetIsPC(OBJECT_SELF))
	{
//		Jug_Debug("^^^^^^^^^" + GetName(OBJECT_SELF) + " controlled by PC");
		return;	// I am done		
	}	
	
	if (GetDistanceBetweenLocations(oldLocation, GetLocation(OBJECT_SELF)) > 0.75)
	{
//		Jug_Debug("^^^^^^^^^" + GetName(OBJECT_SELF) + " moved, do HenchDetermineCombatRound");	
		HenchDetermineCombatRound(oTarget, TRUE);
		return;
	}
	
	if (curTest >= HENCH_STEP_NONE)
	{	
//		Jug_Debug("^^^^^^^^^" + GetName(OBJECT_SELF) + " ran out of options");		
		SetLocalInt(OBJECT_SELF, HENCH_AI_BLOCKED, TRUE);
		HenchDetermineCombatRound(oTarget, TRUE);
		return;
	}	
	
    vector vTarget = GetPosition(oTarget);
    vector vSource = GetPosition(OBJECT_SELF);
    vector vDirection = vTarget - vSource;
	float fAngle = VectorToAngle(vDirection);
	
	fAngle += 10 - Random(21);
	if (curTest == HENCH_STEP_RIGHT)
	{
		fAngle += 45;
	}
	else if (curTest == HENCH_STEP_LEFT)
	{
		fAngle -= 45;
	}
	fAngle = GetNormalizedDirection(fAngle);

    vector vPoint =	AngleToVector(fAngle) * (1.2 + IntToFloat(Random(10)) / 10.0) + vSource;
   	location newLoc = Location(GetArea(OBJECT_SELF), vPoint, GetFacing(OBJECT_SELF));
	location destLocation = CalcSafeLocation(OBJECT_SELF, newLoc, 2.0, TRUE, FALSE);
//	object oTest = GetNearestObjectToLocation(OBJECT_TYPE_CREATURE, destLocation, 1);
//	Jug_Debug("^^^^^^^^^" + GetName(OBJECT_SELF) + " test object " + GetName(oTest) + " distance " + FloatToString(GetDistanceToObject(oTest)));
	
	curTest++;
	if ((GetDistanceBetweenLocations(destLocation, newLoc) <= 2.0))
	{
//		Jug_Debug("^^^^^^^^^" + GetName(OBJECT_SELF) + " step closer " + LocationToString(GetLocation(OBJECT_SELF)) +
//			" test " + LocationToString(newLoc) + " dest " + LocationToString(destLocation));
		ActionMoveToLocation(destLocation, TRUE);
		ActionDoCommand(HenchTestStep(oTarget, oldLocation, curTest));
		return;	
	}
	HenchTestStep(oTarget, oldLocation, curTest);	
}


void HenchCheckAttackSecondaryTarget(object oOriginalTarget)
{
//	Jug_Debug("^^^^^^^^^" + GetName(OBJECT_SELF) + " running second command " + IntToString(GetCurrentAction(OBJECT_SELF)));
	if (GetIsPC(OBJECT_SELF))
	{
//		Jug_Debug("^^^^^^^^^" + GetName(OBJECT_SELF) + " controlled by PC");
		return;	// I am done		
	}
//	Jug_Debug("^^^^^^^^^" + GetName(OBJECT_SELF) + " enemy target, try closest enemy instead");
	object oTestTarget = GetNearestCreature(CREATURE_TYPE_REPUTATION, REPUTATION_TYPE_ENEMY,
           OBJECT_SELF, 1, CREATURE_TYPE_PERCEPTION, PERCEPTION_SEEN,
           CREATURE_TYPE_IS_ALIVE, TRUE);
	if (oTestTarget != oOriginalTarget)
	{
//		Jug_Debug("^^^^^^^^^" + GetName(OBJECT_SELF) + " new target " + GetName(oTestTarget));
		SetLocalObject(OBJECT_SELF, sHenchLastTarget, oTestTarget);
		ActionAttack(oTestTarget);
	}
	// last ditch attempt to get unstuck
	ActionDoCommand(HenchTestStep(oTestTarget, GetLocation(OBJECT_SELF), HENCH_STEP_FORWARD));
	if (!GetLocalInt(OBJECT_SELF, HENCH_AI_SCRIPT_POLL))
	{
		SetLocalInt(OBJECT_SELF, HENCH_AI_SCRIPT_POLL, TRUE);
		DelayCommand(2.0, HenchStartCombatRoundAfterDelay(oTestTarget));
	}
}


void HenchMoveAndDetermineCombatRound(object oTarget)
{
//	Jug_Debug("^^^^^^^^^" + GetName(OBJECT_SELF) + " running second command " + IntToString(GetCurrentAction(OBJECT_SELF)));
	if (GetIsPC(OBJECT_SELF))
	{
//		Jug_Debug("^^^^^^^^^" + GetName(OBJECT_SELF) + " controlled by PC");
		return;	// I am done		
	}
	if (!GetIsObjectValid(oTarget) || (GetCurrentHitPoints(oTarget) <= HENCH_BLEED_NEGHPS))
	{
//		Jug_Debug("^^^^^^^^^" + GetName(OBJECT_SELF) + " target is dead");
		return;
	}
	if (GetDistanceToObject(oTarget) > 4.0)
	{
		location targetLocation = GetLocation(oTarget);
		vector testPosition = GetPosition(oTarget);
		testPosition += GetPosition(OBJECT_SELF);
		testPosition.x /= 2;
		testPosition.y /= 2;
		testPosition.z /= 2;
		location destLocation = CalcSafeLocation(OBJECT_SELF, Location(GetArea(OBJECT_SELF), testPosition, GetFacing(OBJECT_SELF)), 5.0, TRUE, FALSE);
		if (GetDistanceBetweenLocations(destLocation, targetLocation) < (GetDistanceToObject(oTarget) - 2.5))
		{
			ActionMoveToLocation(destLocation, TRUE);
			if (!GetLocalInt(OBJECT_SELF, HENCH_AI_SCRIPT_POLL))
			{
				SetLocalInt(OBJECT_SELF, HENCH_AI_SCRIPT_POLL, TRUE);
				DelayCommand(2.0, HenchStartCombatRoundAfterDelay(oTarget));
			}
			ActionDoCommand(HenchCheckAttackSecondaryTarget(oTarget));			
			return;
		}
		else
		{
	//		Jug_Debug(GetName(OBJECT_SELF ) + " setting location failed for " + GetName(oTarget));
			SetLocalLocation(OBJECT_SELF, sHenchLastAttackLocation, GetLocation(OBJECT_SELF));
		}
	}
	HenchCheckAttackSecondaryTarget(oTarget);
}


void HenchMoveToMaster(object oMaster)
{
//	Jug_Debug("^^^^^^^^^" + GetName(OBJECT_SELF) + " running second command " + IntToString(GetCurrentAction(OBJECT_SELF)));
	if (GetIsPC(OBJECT_SELF))
	{
//		Jug_Debug("^^^^^^^^^" + GetName(OBJECT_SELF) + " controlled by PC");
		return;	// I am done		
	}
	if (GetDistanceToObject(oMaster) > 4.0)
	{
		int nCurAction = GetCurrentAction(OBJECT_SELF);	
		if (nCurAction == ACTION_FOLLOW)
		{	
			ClearAllActions();
		}
		location targetLocation = GetLocation(oMaster);
		vector testPosition = GetPosition(oMaster);
		testPosition += GetPosition(OBJECT_SELF);
		testPosition.x /= 2;
		testPosition.y /= 2;
		testPosition.z /= 2;
		location destLocation = CalcSafeLocation(OBJECT_SELF, Location(GetArea(OBJECT_SELF), testPosition, GetFacing(OBJECT_SELF)), 5.0, TRUE, FALSE);
		if (GetDistanceBetweenLocations(destLocation, targetLocation) < (GetDistanceToObject(oMaster) - 2.5))
		{
			ActionMoveToLocation(destLocation, TRUE);
			if (!GetLocalInt(OBJECT_SELF, HENCH_AI_SCRIPT_POLL))
			{
				SetLocalInt(OBJECT_SELF, HENCH_AI_SCRIPT_POLL, TRUE);
				DelayCommand(2.0, HenchStartCombatRoundAfterDelay(OBJECT_INVALID));
			}
			return;
		}
		else
		{
	//		Jug_Debug(GetName(OBJECT_SELF ) + " setting location failed for " + GetName(oTarget));
			SetLocalLocation(OBJECT_SELF, sHenchLastAttackLocation, GetLocation(OBJECT_SELF));
		}
	}
}