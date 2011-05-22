//::///////////////////////////////////////////////
//:: Default On Blocked
//:: NW_C2_DEFAULTE
//:: Copyright (c) 2001 Bioware Corp.
//:://////////////////////////////////////////////
/*
    This will cause blocked creatures to open
    or smash down doors depending on int and
    str.
*/
//:://////////////////////////////////////////////
//:: Created By: Preston Watamaniuk
//:: Created On: Nov 23, 2001
//:://////////////////////////////////////////////

#include "hench_i0_generic"
#include "ginc_companion"


void main()
{
    object oDoor = GetBlockingDoor();

//    Jug_Debug("******" + GetName(OBJECT_SELF) + " is blocked by " + GetName(oDoor));
	
    if (GetObjectType(oDoor) == OBJECT_TYPE_CREATURE)
    {
        // * Increment number of times blocked
        /*SetLocalInt(OBJECT_SELF, "X2_NUMTIMES_BLOCKED", GetLocalInt(OBJECT_SELF, "X2_NUMTIMES_BLOCKED") + 1);
        if (GetLocalInt(OBJECT_SELF, "X2_NUMTIMES_BLOCKED") > 3)
        {
            SpeakString("Blocked by creature");
            SetLocalInt(OBJECT_SELF, "X2_NUMTIMES_BLOCKED",0);
            ClearAllActions();
            object oEnemy = GetNearestCreature(CREATURE_TYPE_REPUTATION, REPUTATION_TYPE_ENEMY);
            if (GetIsObjectValid(oEnemy) == TRUE)
            {
                ActionEquipMostDamagingRanged(oEnemy);
                ActionAttack(oEnemy);
            }
            return;
        }   */
        return;
    }

    if (GetAbilityScore(OBJECT_SELF, ABILITY_INTELLIGENCE) < 5)
    {
        return; // too stupid to follow (out of sight, out of mind)
        // TODO add wisdom check?
    }

    int iAggPursue = !GetLocalInt(OBJECT_SELF, sHenchScoutMode);
    if (!iAggPursue)
    {
        if (GetPlotFlag(oDoor))
        {
            return;
        }
        if (GetIsTrapped(oDoor))
        {
            return;
        }
    }

    int nSel;
    if (iAggPursue)
    {
        nSel = 0xffff;
    }
    else
    {
        nSel = GetHenchOption(HENCH_OPTION_UNLOCK | HENCH_OPTION_OPEN);
    }
    if((HENCH_OPTION_OPEN & nSel) && GetIsDoorActionPossible(oDoor, DOOR_ACTION_OPEN) &&
        GetAbilityScore(OBJECT_SELF, ABILITY_INTELLIGENCE) >= 7 &&
        GetCreatureUseItems(OBJECT_SELF))
    {
//	    Jug_Debug("******" + GetName(OBJECT_SELF) + " doing open" + GetName(oDoor) + " scout mode + " + IntToString( GetLocalInt(OBJECT_SELF, sHenchScoutMode)));

        DoDoorAction(oDoor, DOOR_ACTION_OPEN);
        if (!iAggPursue)
        {
            SetLocalInt(OBJECT_SELF,"OpenedDoor", TRUE);
        }
    }
    else if ((HENCH_OPTION_UNLOCK & nSel) && GetIsDoorActionPossible(oDoor, DOOR_ACTION_UNLOCK))
    {
        DoDoorAction(oDoor, DOOR_ACTION_UNLOCK);
    }
    else if((HENCH_OPTION_UNLOCK & nSel) && GetIsDoorActionPossible(oDoor, DOOR_ACTION_BASH))
    {
        DoDoorAction(oDoor, DOOR_ACTION_BASH);
    }
}