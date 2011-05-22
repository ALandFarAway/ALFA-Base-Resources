/*

    Companion and Monster AI

    This file contains routines to find and sort priority for both allies and
    enemies. The sorted lists are stored in local variables starting from
    OBJECT_SELF

*/


#include "hench_i0_generic"


// void main() {    }

// basic intelligence ranking, can change how AI reacts
const int HENCH_INT_VERY_LOW = 0;
const int HENCH_INT_LOW = 1;
const int HENCH_INT_AVG = 2;
const int HENCH_INT_HIGH = 3;
const int HENCH_INT_VERY_HIGH = 4;

// one of the HENCH_INT_* values
int igIntelligenceLevel;

// global basic target information
object ogClosestSeenEnemy;
object ogClosestHeardEnemy;
object ogClosestNonActiveEnemy;
object ogClosestSeenOrHeardEnemy;
object ogNotHeardOrSeenEnemy;
object ogDyingEnemy;
object ogLastTarget;
object ogCharmedAlly;


// used in GetThreatRating
float fgOverrideTargetWeight;
object ogOverrideTarget;


object ogClosestSeenFriend;

float myAdjustedThreatRating;

int bgMeleeAttackers;
int bgAnyValidTarget;
int bgLineOfSightHeardEnemy;
int gbIAmStuck;


const string sObjectSeen = "HenchObjectSeen";       // seen enemy list local variable
const string sLineOfSight = "HenchLineOfSight";     // seen or heard line of sight enemy list local variable
const string henchAllyStr = "HenchAllyList";        // seen friend list


// gets initial enemy and friend information (stored in globals)
void InitializeBasicTargetInfo();

// gets adjusted threat rating of creature (last target, etc. have more weight)
// can be customized to change all target weighting
float GetThreatRating(object oTarget);

// focus on a single ally (i.e. from a menu command)
// returns TRUE if ally is seen
int InitializeSingleAlly(object oAlly);

// initialize linked list of allies, sorted by threat level, OBJECT_SELF is implied first in list
void InitializeAllyList(int bUseThreshold = TRUE);

// initialize linked list of enemies and allies, sorted by threat level
void InitializeTargetLists(object oIntruder);

// Pausanias's version of the last: float GetEnemyChallenge()
// My formula: Total Challenge of Enemy = log ( Sum (2**challenge) )
// Auldar: Changed to 1.5 at Paus' request to better mirror the 3E DMG
float GetEnemyChallenge(object oRelativeTo=OBJECT_SELF);

// does a move away from target, using source as something to move behind
int MoveToAwayFromTarget(object oTarget, object oSource, float fDistance, float fMaxDistance);

// returns TRUE if target is moving in your direction
int HenchHeadedInMyDirection(object oTarget);

// checks if move should be done, make sure good placed to move to and enemies aren't nearby
int CheckMoveAwayFromEnemies();

// checks to see if a move away from nearby enemies should be done and then does the move
// returns TRUE if move is done
int MoveAwayFromEnemies(object oTarget, float fMaxTargetRange);


// these globals are used internally
int giCurSeenCreatureCount;
int giCurHeardCreatureCount;


void SetNonActiveEnemy(object oTarget)
{
//	Jug_Debug(GetName(OBJECT_SELF) + " non active enemy " + GetName(oTarget) + " faction equal " + IntToString(GetFactionEqual(oTarget, OBJECT_SELF)));	
	if (GetFactionEqual(oTarget, OBJECT_SELF))
	{
		// ignore faction members that somehow have been marked hostile
		if (GetObjectSeen(oTarget) && (GetLocalInt(oTarget, curNegativeEffectsStr) & HENCH_EFFECT_TYPE_CHARMED))
		{
			if (!GetIsObjectValid(ogCharmedAlly) ||
				(GetRawThreatRating(oTarget) > GetRawThreatRating(ogCharmedAlly)))
			{
				ogCharmedAlly = oTarget;			
			}
		}
		return;	
	}	
    if (!GetIsObjectValid(ogClosestNonActiveEnemy))
    {
        ogClosestNonActiveEnemy = oTarget;
        return;
    }
    if (GetPlotFlag(oTarget))
    {
        return;
    }
    if (GetPlotFlag(ogClosestNonActiveEnemy))
    {
        ogClosestNonActiveEnemy = oTarget;
        return;
    }
    if (igIntelligenceLevel <= HENCH_INT_LOW)
    {
        ogClosestNonActiveEnemy = oTarget;
        return;
    }
    if (GetLocalInt(oTarget, sHenchRunningAway))
    {
        return;
    }
    if (GetLocalInt(ogClosestNonActiveEnemy, sHenchRunningAway))
    {
        ogClosestNonActiveEnemy = oTarget;
        return;
    }
}


void InitializeBasicTargetInfo()
{
    myAdjustedThreatRating = GetRawThreatRating(OBJECT_SELF);
    int iIntelligence = GetAbilityScore(OBJECT_SELF, ABILITY_INTELLIGENCE);
    if (iIntelligence < 6)
    {
        igIntelligenceLevel = HENCH_INT_VERY_LOW;
    }
    else if (iIntelligence < 8)
    {
        igIntelligenceLevel = HENCH_INT_LOW;
    }
    else if (iIntelligence < 13)
    {
        igIntelligenceLevel = HENCH_INT_AVG;
    }
    else if (iIntelligence < 17)
    {
        igIntelligenceLevel = HENCH_INT_HIGH;
    }
    else
    {
        igIntelligenceLevel = HENCH_INT_VERY_HIGH;
    }

    giCurSeenCreatureCount = 1;
    while (TRUE)
    {
        ogClosestSeenEnemy = GetNearestCreature(CREATURE_TYPE_REPUTATION, REPUTATION_TYPE_ENEMY,
            OBJECT_SELF, giCurSeenCreatureCount++, CREATURE_TYPE_PERCEPTION, PERCEPTION_SEEN,
            CREATURE_TYPE_IS_ALIVE, TRUE);
        if (!GetIsObjectValid(ogClosestSeenEnemy))
        {
            break;
        }
//      Jug_Debug("%%%%%%" + GetName(OBJECT_SELF) + " found seen enemy " + GetName(ogClosestSeenEnemy) + " seen " + IntToString(GetObjectSeen(ogClosestSeenEnemy)));
        // special test for zombies attacking Slaan
        if ((GetPlotFlag(ogClosestSeenEnemy) && ((GetTag(GetArea(OBJECT_SELF)) != "HighCliffManorExterior") || (FindSubString(GetTag(OBJECT_SELF), "ombie") < 0))) ||
            GetLocalInt(ogClosestSeenEnemy, sHenchRunningAway) || ((igIntelligenceLevel > HENCH_INT_LOW) ?
            (GetCreatureNegEffects(ogClosestSeenEnemy) & HENCH_EFFECT_DISABLED) :
			(GetCreatureNegEffects(ogClosestSeenEnemy) & HENCH_EFFECT_TYPE_CHARMED)))
        {
            SetNonActiveEnemy(ogClosestSeenEnemy);
        }
        // never consider dying henchman
        else if (!GetAssociateState(NW_ASC_MODE_DYING, ogClosestSeenEnemy))
        {
            break;
        }
    }

    giCurHeardCreatureCount = 1;
    while (TRUE)
    {
        ogClosestHeardEnemy = GetNearestCreature(CREATURE_TYPE_REPUTATION, REPUTATION_TYPE_ENEMY,
            OBJECT_SELF, giCurHeardCreatureCount++, CREATURE_TYPE_PERCEPTION, PERCEPTION_HEARD_AND_NOT_SEEN,
            CREATURE_TYPE_IS_ALIVE, TRUE);
        if (!GetIsObjectValid(ogClosestHeardEnemy))
        {
            break;
        }
//      Jug_Debug("%%%%%%" + GetName(OBJECT_SELF) + " found heard enemy " + GetName(ogClosestHeardEnemy) + " heard " + IntToString(GetObjectHeard(ogClosestHeardEnemy)));
        else if (!HenchEnemyOnOtherSideOfUncheckedDoor(ogClosestHeardEnemy))
        {
//      Jug_Debug(GetName(OBJECT_SELF) + " ignoring door creature " + GetName(ogClosestHeardEnemy));
            // ignore creatures on other side of checked door
            ogClosestHeardEnemy = OBJECT_INVALID;
            break;  // don't keep checking
        }
        else if (GetPlotFlag(ogClosestHeardEnemy) ||
            GetLocalInt(ogClosestHeardEnemy, sHenchRunningAway) || ((igIntelligenceLevel > HENCH_INT_LOW) ?
            (GetCreatureNegEffects(ogClosestHeardEnemy) & HENCH_EFFECT_DISABLED) :
			(GetCreatureNegEffects(ogClosestHeardEnemy) & HENCH_EFFECT_TYPE_CHARMED)))
        {
            SetNonActiveEnemy(ogClosestHeardEnemy);
        }
/*      else if (GetHasEffect(EFFECT_TYPE_SANCTUARY, ogClosestHeardEnemy) /*GetLocalInt(ogClosestHeardEnemy, curPostiveEffectsStr) & HENCH_EFFECT_TYPE_ETHEREAL/)
        {
            // ignore creatures with ethereal effect
//          Jug_Debug(GetName(OBJECT_SELF) + " ignoring heard creature " + GetName(ogClosestHeardEnemy));
        } */
        // never consider dying henchman
        else if (!GetAssociateState(NW_ASC_MODE_DYING, ogClosestHeardEnemy))
        {
            break;
        }
    }
    bgLineOfSightHeardEnemy = GetIsObjectValid(ogClosestHeardEnemy) && LineOfSightObject(OBJECT_SELF, ogClosestHeardEnemy);

    // find dying creatures to finish off
    int curCount = 1;
	int bNewDeathSystem = GetPartyMembersDyingFlag();
    while (1)
    {
        ogDyingEnemy = GetNearestCreature(CREATURE_TYPE_REPUTATION, REPUTATION_TYPE_ENEMY, OBJECT_SELF,
            curCount++, CREATURE_TYPE_PERCEPTION, PERCEPTION_SEEN,
			CREATURE_TYPE_IS_ALIVE, FALSE);
        if (!GetIsObjectValid(ogDyingEnemy))
        {
            break;
        }
        if (GetPlotFlag(ogDyingEnemy))
        {
            // ignore plot creatures
        }
        if ( bNewDeathSystem == FALSE && GetCurrentHitPoints(ogDyingEnemy) > HENCH_BLEED_NEGHPS )
        {
            break;
        }
    }

    if (GetIsObjectValid(ogClosestSeenEnemy))
    {
        if (GetIsObjectValid(ogClosestHeardEnemy) &&
            (GetDistanceToObject(ogClosestHeardEnemy) < GetDistanceToObject(ogClosestSeenEnemy)))
        {
            ogClosestSeenOrHeardEnemy = ogClosestHeardEnemy;
        }
        else
        {
            ogClosestSeenOrHeardEnemy = ogClosestSeenEnemy;
        }
    }
    else
    {
        ogClosestSeenOrHeardEnemy = ogClosestHeardEnemy;
    }

    bgMeleeAttackers =
        GetIsObjectValid(ogClosestSeenOrHeardEnemy) &&
        (GetDistanceToObject(ogClosestSeenOrHeardEnemy) < 5.0) &&
        (fabs(GetPosition(OBJECT_SELF).z - GetPosition(ogClosestSeenOrHeardEnemy).z) < 2.0);

    if (bgMeleeAttackers && (ogClosestSeenOrHeardEnemy == ogClosestHeardEnemy) && !bgLineOfSightHeardEnemy)
    {
        bgMeleeAttackers = FALSE;
    }

    bgAnyValidTarget = GetIsObjectValid(ogClosestSeenOrHeardEnemy) || GetIsObjectValid(ogClosestNonActiveEnemy) || GetIsObjectValid(ogDyingEnemy);
//	Jug_Debug(GetName(OBJECT_SELF) + " closest seen or heard " + GetName(ogClosestSeenOrHeardEnemy) + " non active " + GetName( ogClosestNonActiveEnemy) + " dying " + GetName(ogDyingEnemy));
}

const int HENCH_SPECIAL_TARGETING_SINGLE       = 0x01;
const int HENCH_SPECIAL_TARGETING_RACE         = 0x02;  // not currently implemented
const int HENCH_SPECIAL_TARGETING_CLASS        = 0x04;  // not currently implemented


int giSpecialTargeting;

float GetThreatRating(object oTarget)
{
    if (oTarget == OBJECT_SELF)
    {
        return myAdjustedThreatRating;
    }
    float fThreat = GetRawThreatRating(oTarget);
    if (giSpecialTargeting)
    {
        if (giSpecialTargeting & HENCH_SPECIAL_TARGETING_SINGLE)
        {
            if (oTarget == ogOverrideTarget)
            {
                return fThreat;
            }
            return 0.0;
        }
        else if (GetIsEnemy(oTarget))
        {
/*            if (giSpecialTargeting & HENCH_SPECIAL_TARGETING_RACE)
            {
                if (GetRacialType(oTarget) == x)
                {
                    fThreat *= 2;
                }
            }
            if (giSpecialTargeting & HENCH_SPECIAL_TARGETING_CLASS)
            {

            } */
        }
    }
    if (oTarget == ogOverrideTarget)
    {
        fThreat *= fgOverrideTargetWeight;
    }
    return fThreat;
}


int InitializeSingleAlly(object oAlly)
{
    giSpecialTargeting = HENCH_SPECIAL_TARGETING_SINGLE;
    ogOverrideTarget = oAlly;
    if (oAlly == OBJECT_SELF)
    {
        DeleteLocalObject(OBJECT_SELF, henchAllyStr);
    }
    else
    {
        myAdjustedThreatRating = 0.0;
        if (!GetObjectSeen(oAlly))
        {
            DeleteLocalObject(OBJECT_SELF, henchAllyStr);
            return FALSE;
        }
        SetLocalObject(OBJECT_SELF, henchAllyStr, oAlly);
        DeleteLocalObject(oAlly, henchAllyStr);
    }
    return TRUE;
}


void InitializeAllyList(int bUseThreshold = TRUE)
{
//SpawnScriptDebugger();
    int curCount = 1;
    float myThreatRating = GetRawThreatRating(OBJECT_SELF);
    DeleteLocalObject(OBJECT_SELF, henchAllyStr);

    float fThresHold = bUseThreshold ? myThreatRating * 0.50 : -1000.0;
    int nMaxNumAlliesToFind = bUseThreshold ? 5 : 15;
    float fDistanceThreshold = bgMeleeAttackers ? 5.0 : 20.0;
    int alliesFound;
    int currentCheckRep = REPUTATION_TYPE_NEUTRAL; // hack, hack, hack - members of PC party are
        // not "friends" but they can be found by searching neutrals with GetFactionEqual
    int bSkipFactionCheck;

//  Jug_Debug(GetName(OBJECT_SELF) + " adj threat rating " + FloatToString(fThresHold));
    while ((curCount <= 15) && (alliesFound <= nMaxNumAlliesToFind))
    {
        object oFriend = GetNearestCreature(CREATURE_TYPE_REPUTATION, currentCheckRep,
            OBJECT_SELF, curCount++, CREATURE_TYPE_PERCEPTION, PERCEPTION_SEEN,
            CREATURE_TYPE_IS_ALIVE, TRUE);
        if (!GetIsObjectValid(oFriend) || (GetDistanceToObject(oFriend) > fDistanceThreshold))
        {
            if (currentCheckRep == REPUTATION_TYPE_NEUTRAL)
            {
                currentCheckRep = REPUTATION_TYPE_FRIEND;
                bSkipFactionCheck = bUseThreshold;
                curCount = 1;
                continue;
            }
            else
            {
                break;
            }
        }
//		Jug_Debug(GetName(OBJECT_SELF) + " testing friend " + GetName(oFriend));
        if (bSkipFactionCheck || GetFactionEqual(oFriend))
        {
            int nAssocType = GetAssociateType(oFriend);
            if (nAssocType != ASSOCIATE_TYPE_FAMILIAR)
            {
                if (!GetIsObjectValid(ogClosestSeenFriend) || (GetDistanceToObject(oFriend) < GetDistanceToObject(ogClosestSeenFriend)))
                {
                    ogClosestSeenFriend = oFriend;
                }
            }
            // remove summon, familiar, and dominated
            if ((nAssocType != ASSOCIATE_TYPE_DOMINATED) && (nAssocType != ASSOCIATE_TYPE_SUMMONED) &&
                (nAssocType != ASSOCIATE_TYPE_FAMILIAR))
            {
                float curThreatRating = GetRawThreatRating(oFriend);
//              Jug_Debug(GetName(OBJECT_SELF) + " threat rating " + FloatToString(curThreatRating));
                if (curThreatRating >= fThresHold)
                {
                    object oPrevTestObject = OBJECT_SELF;
                    object oTestObject = GetLocalObject(OBJECT_SELF, henchAllyStr);
                    while (GetIsObjectValid(oTestObject))
                    {
                        if (GetRawThreatRating(oTestObject) < curThreatRating)
                        {
                            break;
                        }
                        oPrevTestObject = oTestObject;
                        oTestObject = GetLocalObject(oTestObject, henchAllyStr);
                    }
//					Jug_Debug("adding to friend list " + GetName(oFriend) + " threat " + FloatToString(curThreatRating));
                    SetLocalObject(oPrevTestObject, henchAllyStr, oFriend);
                    SetLocalObject(oFriend, henchAllyStr, oTestObject);

                    alliesFound++;
                }
            }
        }
    }
    // make ourselves better than our strongest friend
    object oBestFriend = GetLocalObject(OBJECT_SELF, henchAllyStr);
    if (GetIsObjectValid(oBestFriend))
    {
        float friendRating = GetRawThreatRating(oBestFriend) * 1.05;
        if (myAdjustedThreatRating < friendRating)
        {
            myAdjustedThreatRating = friendRating;
        }
    }
/*  Jug_Debug(GetName(OBJECT_SELF) + " allies found " + IntToString(alliesFound));
    object oTestObject = GetLocalObject(OBJECT_SELF, henchAllyStr);
    while (GetIsObjectValid(oTestObject))
    {
        Jug_Debug(GetName(OBJECT_SELF) + " ally found " + GetName(oTestObject));
        oTestObject = GetLocalObject(oTestObject, henchAllyStr);
    } */
}


void InitializeTargetLists(object oIntruder)
{
    InitializeAllyList();

    ogLastTarget = GetLocalObject(OBJECT_SELF, sHenchLastTarget);
    if (GetIsObjectValid(oIntruder))
    {
        ogOverrideTarget = oIntruder;
        fgOverrideTargetWeight = 10.0;
    }
    else
    {
        ogOverrideTarget = ogLastTarget;
        fgOverrideTargetWeight = 1.2;
    }

    // quick setup for low int creatures
    if (igIntelligenceLevel < HENCH_INT_AVG)
    {
        if (GetIsObjectValid(ogClosestSeenEnemy))
        {
            SetLocalObject(OBJECT_SELF, sObjectSeen, ogClosestSeenEnemy);
            DeleteLocalObject(ogClosestSeenEnemy, sObjectSeen);
            GetThreatRating(ogClosestSeenEnemy);
        }
        else
        {
            DeleteLocalObject(OBJECT_SELF, sObjectSeen);
        }
        if (GetIsObjectValid(ogClosestSeenOrHeardEnemy) && ((ogClosestSeenOrHeardEnemy == ogClosestSeenEnemy) || bgLineOfSightHeardEnemy))
        {
            SetLocalObject(OBJECT_SELF, sLineOfSight, ogClosestSeenOrHeardEnemy);
            DeleteLocalObject(ogClosestSeenOrHeardEnemy, sLineOfSight);
            GetThreatRating(ogClosestSeenOrHeardEnemy);
        }
        else
        {
            DeleteLocalObject(OBJECT_SELF, sLineOfSight);
        }
        // low int can still remember last target if seen
        if (igIntelligenceLevel == HENCH_INT_LOW && GetIsObjectValid(ogLastTarget)
            && !GetIsDead(ogLastTarget) && !GetLocalInt(ogLastTarget, sHenchRunningAway) && GetObjectSeen(ogLastTarget))
        {
            GetThreatRating(ogLastTarget);
            if (ogLastTarget != ogClosestSeenEnemy)
            {
                SetLocalObject(ogClosestSeenEnemy, sObjectSeen, ogLastTarget);
                DeleteLocalObject(ogLastTarget, sObjectSeen);
            }
            if (ogLastTarget != ogClosestSeenOrHeardEnemy)
            {
                SetLocalObject(ogClosestSeenOrHeardEnemy, sLineOfSight, ogLastTarget);
                DeleteLocalObject(ogLastTarget, sLineOfSight);
            }
        }
        return;
    }

    int iMaxNumberToFind = GetAbilityScore(OBJECT_SELF, ABILITY_INTELLIGENCE) - 5;
	if (iMaxNumberToFind > 15)
    {
        iMaxNumberToFind = 15;
    }

    if (GetIsObjectValid(ogClosestSeenEnemy))
    {
        SetLocalObject(OBJECT_SELF, sObjectSeen, ogClosestSeenEnemy);
        DeleteLocalObject(ogClosestSeenEnemy, sObjectSeen);
        GetThreatRating(ogClosestSeenEnemy);
 //     Jug_Debug("adding seen " + GetName(ogClosestSeenEnemy) + " threat " + FloatToString(GetThreatRating(ogClosestSeenEnemy)));

        while (giCurSeenCreatureCount <= iMaxNumberToFind)
        {
            object oCurSeen = GetNearestCreature(CREATURE_TYPE_REPUTATION, REPUTATION_TYPE_ENEMY,
                OBJECT_SELF, giCurSeenCreatureCount++, CREATURE_TYPE_PERCEPTION, PERCEPTION_SEEN,
                CREATURE_TYPE_IS_ALIVE, TRUE);
            if (!GetIsObjectValid(oCurSeen))
            {
                break;
            }
            if (GetAssociateState(NW_ASC_MODE_DYING, oCurSeen))
            {
                // ignore dying creatures
            }
            else if (GetPlotFlag(oCurSeen) ||
                GetLocalInt(oCurSeen, sHenchRunningAway) ||
                (GetCreatureNegEffects(oCurSeen) & HENCH_EFFECT_DISABLED))
            {
                SetNonActiveEnemy(oCurSeen);
            }
            else
            {
                float curThreat = GetThreatRating(oCurSeen);
                object oPrevTestObject = OBJECT_SELF;
                object oTestObject = GetLocalObject(OBJECT_SELF, sObjectSeen);
                while (GetIsObjectValid(oTestObject))
                {
                    if (GetThreatRating(oTestObject) < curThreat)
                    {
                        break;
                    }
                    oPrevTestObject = oTestObject;
                    oTestObject = GetLocalObject(oTestObject, sObjectSeen);
                }
//              Jug_Debug("adding seen " + GetName(oCurSeen) + " threat " + FloatToString(curThreat));
                SetLocalObject(oPrevTestObject, sObjectSeen, oCurSeen);
                SetLocalObject(oCurSeen, sObjectSeen, oTestObject);
            }
        }
    }
    else
    {
        if (GetIsObjectValid(ogClosestNonActiveEnemy) && GetObjectSeen(ogClosestNonActiveEnemy))
        {
            SetLocalObject(OBJECT_SELF, sObjectSeen, ogClosestNonActiveEnemy);
            DeleteLocalObject(ogClosestNonActiveEnemy, sObjectSeen);
        }
        else if (GetIsObjectValid(ogDyingEnemy) && GetObjectSeen(ogDyingEnemy))
        {
            SetLocalObject(OBJECT_SELF, sObjectSeen, ogDyingEnemy);
            DeleteLocalObject(ogDyingEnemy, sObjectSeen);
        }
        else
        {
            DeleteLocalObject(OBJECT_SELF, sObjectSeen);
        }
    }

    object oCurObject = OBJECT_SELF;
    while (GetIsObjectValid(oCurObject))
    {
		object oNext = GetLocalObject(oCurObject, sObjectSeen);
/*		if (GetIsObjectValid(oNext))
		{
			Jug_Debug(GetName(OBJECT_SELF) + " seen found " + GetName(oNext));
		} */
        SetLocalObject(oCurObject, sLineOfSight, oNext);
        oCurObject = oNext;
    }

    if (GetIsObjectValid(ogClosestHeardEnemy))
    {
        if (bgLineOfSightHeardEnemy)
        {
            float curThreat = GetThreatRating(ogClosestHeardEnemy);

            object oPrevTestObject = OBJECT_SELF;
            object oTestObject = GetLocalObject(OBJECT_SELF, sLineOfSight);
            while (GetIsObjectValid(oTestObject))
            {
                if (GetThreatRating(oTestObject) < curThreat)
                {
                    break;
                }
                oPrevTestObject = oTestObject;
                oTestObject = GetLocalObject(oTestObject, sLineOfSight);
            }
//          Jug_Debug("adding to line of sight " + GetName(ogClosestHeardEnemy) + " threat " + FloatToString(curThreat));
            SetLocalObject(oPrevTestObject, sLineOfSight, ogClosestHeardEnemy);
            SetLocalObject(ogClosestHeardEnemy, sLineOfSight, oTestObject);
        }

        // limit the max number of heard targets to find, limit in any case to 3
        iMaxNumberToFind /= 2;
        if (iMaxNumberToFind > 3)
        {
            iMaxNumberToFind = 3;
        }

        while (giCurHeardCreatureCount <= iMaxNumberToFind)
        {
            object oCurHeard = GetNearestCreature(CREATURE_TYPE_REPUTATION, REPUTATION_TYPE_ENEMY,
                OBJECT_SELF, giCurHeardCreatureCount++, CREATURE_TYPE_PERCEPTION, PERCEPTION_HEARD_AND_NOT_SEEN,
                CREATURE_TYPE_IS_ALIVE, TRUE);
            if (!GetIsObjectValid(oCurHeard))
            {
                break;
            }
            if (GetAssociateState(NW_ASC_MODE_DYING, oCurHeard) || !LineOfSightObject(OBJECT_SELF, oCurHeard))
            {
                // ignore dying creatures, not line of sight
            }
            else if (GetPlotFlag(oCurHeard) ||
                GetLocalInt(oCurHeard, sHenchRunningAway) ||
                (GetCreatureNegEffects(oCurHeard) & HENCH_EFFECT_DISABLED))
            {
                SetNonActiveEnemy(oCurHeard);
            }
/*          else if (GetHasEffect(EFFECT_TYPE_SANCTUARY, oCurHeard) /*GetLocalInt(oCurHeard, curPostiveEffectsStr) & HENCH_EFFECT_TYPE_ETHEREAL*)
            {
//              Jug_Debug(GetName(OBJECT_SELF) + " ignoring heard creature " + GetName(oCurHeard));
                // ignore creatures with ethereal effect
            } */
            else
            {
                float curThreat = GetThreatRating(oCurHeard);

                object oPrevTestObject = OBJECT_SELF;
                object oTestObject = GetLocalObject(OBJECT_SELF, sLineOfSight);
                while (GetIsObjectValid(oTestObject))
                {
                    if (GetThreatRating(oTestObject) < curThreat)
                    {
                        break;
                    }
                    oPrevTestObject = oTestObject;
                    oTestObject = GetLocalObject(oTestObject, sLineOfSight);
                }
    //          Jug_Debug("adding to line of sight " + GetName(ogClosestHeardEnemy) + " threat " + FloatToString(curThreat));
                SetLocalObject(oPrevTestObject, sLineOfSight, oCurHeard);
                SetLocalObject(oCurHeard, sLineOfSight, oTestObject);
            }
        }
    }

    if (!GetIsObjectValid(GetLocalObject(OBJECT_SELF, sLineOfSight)))
    {
        if (GetIsObjectValid(ogClosestNonActiveEnemy) && !GetObjectSeen(ogClosestNonActiveEnemy) &&
            LineOfSightObject(OBJECT_SELF, ogClosestNonActiveEnemy))
        {
            SetLocalObject(OBJECT_SELF, sLineOfSight, ogClosestNonActiveEnemy);
            DeleteLocalObject(ogClosestNonActiveEnemy, sLineOfSight);
        }
        else if (GetIsObjectValid(ogDyingEnemy) && !GetObjectSeen(ogDyingEnemy) &&
            LineOfSightObject(OBJECT_SELF, ogDyingEnemy))
        {
            SetLocalObject(OBJECT_SELF, sLineOfSight, ogDyingEnemy);
            DeleteLocalObject(ogDyingEnemy, sLineOfSight);
        }
    }

    // TODO add not seen or heard to line of sight if in line of sight?
/*	oCurObject = OBJECT_SELF;
    while (GetIsObjectValid(oCurObject))
    {
        object oNext = GetLocalObject(oCurObject, sLineOfSight);
        if (GetIsObjectValid(oNext))
        {
            Jug_Debug(GetName(OBJECT_SELF) + " line of sight found " + GetName(oNext) + " faction equal " + IntToString(GetFactionEqual(oNext, OBJECT_SELF)));
        }
        oCurObject = oNext;
    } */
}

const float log1point5 = 0.4054651;

// Pausanias's version of the last: float GetEnemyChallenge()
// My formula: Total Challenge of Enemy = log ( Sum (2**challenge) )
// Auldar: Changed to 1.5 at Paus' request to better mirror the 3E DMG
float GetEnemyChallenge(object oRelativeTo=OBJECT_SELF)
{
    float fChallenge;

    if (GetIsObjectValid(ogNotHeardOrSeenEnemy))
    {
//		Jug_Debug(GetName(OBJECT_SELF) + " not heard or seen");
        fChallenge = GetRawThreatRating(ogNotHeardOrSeenEnemy);
    }
	if (GetIsObjectValid(ogClosestHeardEnemy) && !bgLineOfSightHeardEnemy)
	{
        fChallenge += GetRawThreatRating(ogClosestHeardEnemy);
	}
    object oTarget = GetLocalObject(OBJECT_SELF, sLineOfSight);
    while (GetIsObjectValid(oTarget))
    {
        fChallenge += GetRawThreatRating(oTarget);
        oTarget = GetLocalObject(oTarget, sLineOfSight);
    }
    // get remaining seen and heard enemies - don't check disabled
    while (TRUE)
    {
        oTarget = GetNearestCreature(CREATURE_TYPE_REPUTATION, REPUTATION_TYPE_ENEMY,
            OBJECT_SELF, giCurSeenCreatureCount++, CREATURE_TYPE_PERCEPTION, PERCEPTION_SEEN,
            CREATURE_TYPE_IS_ALIVE, TRUE);
        if (!GetIsObjectValid(oTarget))
        {
            break;
        }
        fChallenge += GetRawThreatRating(oTarget);
    }
    while (TRUE)
    {
        oTarget = GetNearestCreature(CREATURE_TYPE_REPUTATION, REPUTATION_TYPE_ENEMY,
            OBJECT_SELF, giCurHeardCreatureCount++, CREATURE_TYPE_PERCEPTION, PERCEPTION_HEARD_AND_NOT_SEEN,
            CREATURE_TYPE_IS_ALIVE, TRUE);
        if (!GetIsObjectValid(oTarget))
        {
            break;
        }
        fChallenge += GetRawThreatRating(oTarget);
    }
	fChallenge = log(fChallenge);
	
	float fFriendChallenge;	
	oTarget = GetFirstFactionMember(oRelativeTo, FALSE);
	while (GetIsObjectValid(oTarget))
	{
		if (!GetIsDead(oTarget))
		{
        	fFriendChallenge += GetRawThreatRating(oTarget) * GetCurrentHitPoints(oTarget) / GetMaxHitPoints(oTarget);
		}
		oTarget = GetNextFactionMember(oRelativeTo, FALSE);
	}
	fFriendChallenge = log(fFriendChallenge);
	
//	Jug_Debug(GetName(OBJECT_SELF) + " enemy challenge " + FloatToString(fChallenge / log1point5 ) + " friend challenge " + FloatToString(fFriendChallenge /log1point5) + " diff " + FloatToString((fChallenge - fFriendChallenge) / log1point5));
	// factor of 3.0 is to get result close to previous version that only counted self
	return ((fChallenge - fFriendChallenge) / log1point5) + 3.0; 
}


int MoveToAwayFromTarget(object oTarget, object oSource, float fDistance, float fMaxDistance)
{
    vector vTarget = GetPosition(oTarget);
    vector vSource = GetPosition(oSource);
    vector vDirection = vTarget - vSource;
    // if at different heights, don't move
    if (fabs(vDirection.z) > 2.0)
    {
        return FALSE;
    }

    float fSourceTargetDistance = GetDistanceBetween(oTarget, oSource) + fDistance;
    if (fSourceTargetDistance > fMaxDistance)
    {
        fDistance =  fMaxDistance - GetDistanceBetween(oTarget, oSource);
        if (fDistance <= 1.0)
        {
            return FALSE;
        }
    }

    // Jug_Debug(GetName(OBJECT_SELF) + " distance actually moved " + FloatToString(fDistance));

    vector vPoint = VectorNormalize(vDirection) * -fDistance + vSource;
    location testLoc = Location(GetArea(OBJECT_SELF), vPoint, GetFacing(OBJECT_SELF));

    // check if test location is good, ignore if not
    location safeLoc = CalcSafeLocation(OBJECT_SELF, testLoc, 1.0, TRUE, FALSE);
    if (GetDistanceBetweenLocations(GetLocation(OBJECT_SELF), safeLoc) < 1.0)
    {
        // Jug_Debug(GetName(OBJECT_SELF) + " can't move to safe location for source " + GetName(oSource) + " and target " + GetName(oTarget));
        return FALSE;
    }
	
    float fRadius = GetDistanceToObject(ogClosestSeenOrHeardEnemy) + 0.5;
    object oClosestEnemy = GetFirstObjectInShape(SHAPE_SPHERE, fRadius, safeLoc, FALSE, OBJECT_TYPE_CREATURE);
    while (GetIsObjectValid(oClosestEnemy))
    {
        if (GetIsEnemy(oClosestEnemy) &&
            (GetObjectSeen(oClosestEnemy) || GetObjectHeard(oClosestEnemy)))
        {
            return FALSE;
        }
        oClosestEnemy = GetNextObjectInShape(SHAPE_SPHERE, fRadius, safeLoc, FALSE, OBJECT_TYPE_CREATURE);
    }

/*  object oTestObject = GetFirstObjectInShape(SHAPE_SPHERE, 5.0, safeLoc, FALSE, OBJECT_TYPE_PLACEABLE);
    while (GetIsObjectValid(oTestObject))
    {
    //    if (GetObjectType(oTestObject) != OBJECT_TYPE_CREATURE)
        {
            Jug_Debug("found " + GetName(oTestObject) + " of type " + IntToString(GetObjectType(oTestObject)));
        //    return FALSE;
        }
        oTestObject = GetNextObjectInShape(SHAPE_SPHERE, 5.0, safeLoc, FALSE, OBJECT_TYPE_PLACEABLE);
    } */

//	Jug_Debug(" %%%%%%%" + GetName(OBJECT_SELF) + " doing move!!!!!!!!!!!!!!!!!!!!!!");
    ClearAllActions();
    ActionMoveToLocation(safeLoc, TRUE);
    return TRUE;
}


int HenchHeadedInMyDirection(object oTarget)
{
    int nCurAction = GetCurrentAction(oTarget);
    if ((nCurAction != ACTION_MOVETOPOINT) && (nCurAction != HENCH_ACTION_MOVETOLOCATION))
    {
        return FALSE;
    }
    return GetNormalizedDirection(GetFacing(oTarget) -
        VectorToAngle(GetPosition(OBJECT_SELF) - GetPosition(oTarget)) + 15.0) < 30.0;
}


const float fMoveBackDistance = 5.0;
const float fDistanceBehindFriend = 5.0;

int bgEnableMoveAway;

int CheckMoveAwayFromEnemies()
{
    if (GetCurrentAction() != ACTION_INVALID)
    {
//      Jug_Debug(GetName(OBJECT_SELF) + " no move away due to action");
        return FALSE;
    }

    // Jug_Debug(GetName(OBJECT_SELF) + " check move from enemies");
    if (!GetIsObjectValid(ogClosestSeenOrHeardEnemy))
    {
        object oEnemy = GetLocalObject(OBJECT_SELF, sLineOfSight);
        while (GetIsObjectValid(oEnemy))
        {
            if (!(GetLocalInt(oEnemy, curNegativeEffectsStr) & HENCH_EFFECT_IMMOBILE))
            {
//              Jug_Debug(GetName(OBJECT_SELF) + " move from enemies reject " + GetName(oEnemy));
                return FALSE;
            }
            oEnemy = GetLocalObject(oEnemy, sLineOfSight);
        }
        return TRUE;
    }
    float fDistance = GetDistanceToObject(ogClosestSeenOrHeardEnemy);
    // Jug_Debug(GetName(OBJECT_SELF) + " move from enemies 2 distance " + FloatToString(fDistance));
    if (fDistance >= 15.0)
    {
        return FALSE;
    }

    float fMaxDistance;
    if (GetIsObjectValid(ogClosestSeenFriend))
    {
        fMaxDistance = GetDistanceToObject(ogClosestSeenFriend) + 3.0;
        if (fMaxDistance > 10.0)
        {
            fMaxDistance = 10.0;
        }
    }
    else
    {
        fMaxDistance = 1000.0;
    }

//  Jug_Debug(GetName(OBJECT_SELF) + " move from enemies");
    object oEnemy = GetLocalObject(OBJECT_SELF, sLineOfSight);
    while (GetIsObjectValid(oEnemy))
    {
        if (!(GetLocalInt(oEnemy, curNegativeEffectsStr) & HENCH_EFFECT_IMMOBILE))
        {
            if ((GetDistanceToObject(oEnemy) < fMaxDistance) &&
                !GetWeaponRanged(GetItemInSlot(INVENTORY_SLOT_RIGHTHAND, oEnemy)))
            {
                if ((GetAttackTarget(oEnemy) == OBJECT_SELF) || HenchHeadedInMyDirection(oEnemy))
                {
//                  Jug_Debug(GetName(OBJECT_SELF) + " move from enemies reject " + GetName(oEnemy));
                    return FALSE;
                }
            }
        }
        oEnemy = GetLocalObject(oEnemy, sLineOfSight);
    }
    return TRUE;
}


int MoveAwayFromEnemies(object oTarget, float fMaxTargetRange)
{
    if (GetDistanceToObject(oTarget) >= fMaxTargetRange)
    {
        return FALSE;
    }

    float fTestDisatnce = fMaxTargetRange - fDistanceBehindFriend;
    int index = 1;
    object oFriend = GetNearestCreature(CREATURE_TYPE_PERCEPTION, PERCEPTION_SEEN, OBJECT_SELF, index++);
    // TODO change to get closest melee char????
    while (GetIsObjectValid(oFriend) && (GetDistanceToObject(oFriend) < fTestDisatnce))
    {
        if (oFriend != OBJECT_SELF && (GetIsFriend(oFriend) || GetFactionEqual(oFriend)) &&
            (GetDistanceBetween(oTarget, oFriend) < fTestDisatnce) &&
            !(GetCreatureNegEffects(oFriend) & HENCH_EFFECT_DISABLED) &&
            ((oTarget == OBJECT_SELF) || LineOfSightObject(oFriend, oTarget)))
        {
//          Jug_Debug(";;;;;;;;;;;;;" + GetName(OBJECT_SELF) + " move from enemy behind friend " + GetName(ogClosestSeenOrHeardEnemy));
            if (MoveToAwayFromTarget(oTarget, oFriend, fDistanceBehindFriend, fMaxTargetRange))
            {
                return TRUE;
            }
        }
        oFriend = GetNearestCreature(CREATURE_TYPE_PERCEPTION, PERCEPTION_SEEN, OBJECT_SELF, index++);
    }
    if (LineOfSightObject(oTarget, OBJECT_SELF))
    {
//      Jug_Debug(";;;;;;;;;;;;;" + GetName(OBJECT_SELF) + " move from enemy " + GetName(ogClosestSeenOrHeardEnemy));
        return MoveToAwayFromTarget(oTarget, OBJECT_SELF, fMoveBackDistance, fMaxTargetRange);
    }
    return FALSE;
}