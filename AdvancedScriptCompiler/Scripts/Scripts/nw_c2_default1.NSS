

//:://////////////////////////////////////////////////
//:: NW_C2_DEFAULT1
/*
  Default OnHeartbeat script for NPCs.

  This script causes NPCs to perform default animations
  while not otherwise engaged.

  This script duplicates the behavior of the default
  script and just cleans up the code and removes
  redundant conditional checks.

 */
//:://////////////////////////////////////////////////
//:: Copyright (c) 2002 Floodgate Entertainment
//:: Created By: Naomi Novik
//:: Created On: 12/22/2002
//:://////////////////////////////////////////////////
// ChazM 6/20/05 if is encounter crature no longer checked - ambient anims flag set on spawn instead.
// ChazM 1/6/06 modified call to WalkWayPoints()
// ChazM 3/6/06 fixed AI level exit condition bug
// ChazM 3/23/06 added DoDebug(); no functionality changes

#include "nw_i0_generic"
#include "ginc_debug"

void DoDebug(string sMessage)
{
	
	//if ((GetTag(OBJECT_SELF) != "3030_dwarf")  && (GetTag(OBJECT_SELF) != "c_cow"))
		return;
	PrettyDebug("NW_C2_DEFAULT1 " + GetName(OBJECT_SELF) + ": " + sMessage);
}

void main()
{
	DoDebug("I'm haveing a heartbeat!!!");
    // * if not runnning normal or better Ai then exit for performance reasons
    if (GetAILevel() == AI_LEVEL_VERY_LOW)
	{
		DoDebug("goodness gracious - i have very low AI!");
		return;
	}

    // Buff ourselves up right away if we should
    if(GetSpawnInCondition(NW_FLAG_FAST_BUFF_ENEMY))
    {
        // This will return TRUE if an enemy was within 40.0 m
        // and we buffed ourselves up instantly to respond --
        // simulates a spellcaster with protections enabled
        // already.
        if(TalentAdvancedBuff(40.0))
        {
            // This is a one-shot deal
            SetSpawnInCondition(NW_FLAG_FAST_BUFF_ENEMY, FALSE);

            // This return means we skip sending the user-defined
            // heartbeat signal in this one case.
            return;
        }
    }


	//PrettyDebug("Entering big if");
    if(GetHasEffect(EFFECT_TYPE_SLEEP))
    {
        // If we're asleep and this is the result of sleeping
        // at night, apply the floating 'z's visual effect
        // every so often

        if(GetSpawnInCondition(NW_FLAG_SLEEPING_AT_NIGHT))
        {
            effect eVis = EffectVisualEffect(VFX_IMP_SLEEP);
            if(d10() > 6)
            {
                ApplyEffectToObject(DURATION_TYPE_INSTANT, eVis, OBJECT_SELF);
            }
        }
    } 
    // If we have the 'constant' waypoints flag set, walk to the next
    // waypoint.
    else if ( GetWalkCondition(NW_WALK_FLAG_CONSTANT) )
	{
		DoDebug("Calling WalkWayPoints!");
		WalkWayPoints(TRUE, "heartbeat");
	}

    // Check to see if we should be playing default animations
    // - make sure we don't have any current targets
    else if ( !GetIsObjectValid(GetAttemptedAttackTarget())
          && !GetIsObjectValid(GetAttemptedSpellTarget())
          // && !GetIsPostOrWalking())
          && !GetIsObjectValid(GetNearestSeenEnemy()))
    {
		DoDebug(" I'm gonna look at playing some animations.");
        if (GetBehaviorState(NW_FLAG_BEHAVIOR_SPECIAL) || GetBehaviorState(NW_FLAG_BEHAVIOR_OMNIVORE) ||
            GetBehaviorState(NW_FLAG_BEHAVIOR_HERBIVORE))
        {
            // This handles special attacking/fleeing behavior
            // for omnivores & herbivores.
			DoDebug("I'm gonna do something special!");
            DetermineSpecialBehavior();
        }
        else if (!IsInConversation(OBJECT_SELF))
        {
            if (GetSpawnInCondition(NW_FLAG_AMBIENT_ANIMATIONS)
                || GetSpawnInCondition(NW_FLAG_AMBIENT_ANIMATIONS_AVIAN))
                //|| GetIsEncounterCreature())
            {
				DoDebug("I'm gonna play some ambient animations!");
				//SpawnScriptDebugger();
                PlayMobileAmbientAnimations();
            }
            else if (GetSpawnInCondition(NW_FLAG_IMMOBILE_AMBIENT_ANIMATIONS))
            {
				DoDebug("I'm gonna play some immobile ambient animations!");
                PlayImmobileAmbientAnimations();
            }
			else
			{
				DoDebug("I don't have any flags telling me to play animations.");
			}
        }
		else
		{
			DoDebug("I must be in a conversation!");
		}
    }

    // Send the user-defined event signal if specified
    if(GetSpawnInCondition(NW_FLAG_HEARTBEAT_EVENT))
    {
        SignalEvent(OBJECT_SELF, EventUserDefined(EVENT_HEARTBEAT));
    }
}