/*

    Companion and Monster AI

    This file contains a modified form of the original TalentMeleeAttack.
    Major modification to not randomly pick feats to use.

*/

#include "hench_i0_equip"
#include "hench_i0_target"
#include "hench_i0_ai"
#include "hench_i0_attack"

// void main() {    }

// actually does the melee attack, picks best combat mode and feat to use
int HenchDoTalentMeleeAttack(object oTarget, float fThresholdDistance, int iCreatureType, int bAllowFeatUse);

// used to allow equipping switchover to complete before doing melee attack
void ActionContinueMeleeAttack(object oTarget, float fThresholdDistance, int iCreatureType, int bAllowFeatUse, int iCallNumber);

// called to start a melee attack against a creature, will switch to ranged or melee depending on threshold distance
int HenchTalentMeleeAttack(object oTarget, float fThresholdDistance, int iCreatureType, int bPolymorphed, int iRangedOverride);

// door/chest bashing (can walk away a bit)
int HenchBashDoorCheck(int bPolymorphed);

// ranged door/chest bashing (can walk away a bit)
void HenchStartRangedBashDoor(object oDoor);

// used to attack non creature items (placeables and doors)
void HenchAttackObject(object oTarget);


int HenchDoTalentMeleeAttack(object oTarget, float fThresholdDistance, int iCreatureType, int bAllowFeatUse)
{
    object oRightWeapon = GetItemInSlot(INVENTORY_SLOT_RIGHTHAND);
    int bRangedWeapon = GetWeaponRanged(oRightWeapon);

    if (!bRangedWeapon && GetHenchAssociateState(HENCH_ASC_NO_MELEE_ATTACKS))
    {
		// TODO use defensive combat modes
        if (bgEnableMoveAway)
        {
//          Jug_Debug("$$$$$$$$$$" + GetName(OBJECT_SELF) + " doing move away from " + GetName(oTarget));
            if (MoveAwayFromEnemies(oTarget, 9.0))
            {
                HenchStartCombatRoundAfterAction(oTarget);
//              bgEnableMoveAway = FALSE;
//              ActionDoCommand(HenchDoTalentMeleeAttack(oTarget, fThresholdDistance, iCreatureType));
            }
        }		
	    // fight defensively
	    if (!GetLocalInt(OBJECT_SELF, N2_COMBAT_MODE_USE_DISABLED))
		{	
			if (GetHasFeat(FEAT_IMPROVED_COMBAT_EXPERTISE))
			{		
		    	SetCombatMode(ACTION_MODE_IMPROVED_COMBAT_EXPERTISE);
			}
			else if (GetHasFeat(FEAT_COMBAT_EXPERTISE))
			{		
		    	SetCombatMode(ACTION_MODE_COMBAT_EXPERTISE);		
			}
			else if ((GetSkillRank(SKILL_PARRY) > (GetAC(OBJECT_SELF) - 10)) && 
				(GetAttackTarget(oTarget) == OBJECT_SELF))
			{		
		    	SetCombatMode(ACTION_MODE_PARRY);		
			}
			else
			{
		    	SetCombatMode(-1);		
			} 
		}
		// passive attack - don't move location, turn off for now
//		ActionAttack(oTarget, TRUE);
        return FALSE;
    }

    if (!GetObjectSeen(oTarget) && !bgLineOfSightHeardEnemy)
    {
        object oTest;
        int index = 1;
        while (index <= 5)
        {
            oTest = GetNearestObject(OBJECT_TYPE_CREATURE, oTarget, index++);
            if (!GetIsObjectValid(oTest))
            {
                break;
            }
            if (!GetIsEnemy(oTest) && LineOfSightObject(oTest, oTarget))
            {
                vector vTarget = GetPosition(oTarget);
                vector vSource = GetPosition(oTest);
                vector vDirection = vTarget - vSource;
                vector vPoint = VectorNormalize(vDirection) * -6.5 + vSource;
                location targetLocation = Location(GetArea(OBJECT_SELF), vPoint, GetFacing(OBJECT_SELF));

                location destLocation = CalcSafeLocation(OBJECT_SELF, targetLocation, 5.0, TRUE, FALSE);
                if (GetDistanceBetweenLocations(destLocation, GetLocation(OBJECT_SELF)) > 0.2)
                {
//					int bResult = ActionUseSkill(SKILL_TAUNT, oTarget);
//					Jug_Debug(GetName(OBJECT_SELF) + " 2 trying move to location " + LocationToString(destLocation) + " from " + LocationToString(GetLocation(OBJECT_SELF)));
//					Jug_Debug(GetName(OBJECT_SELF) + " test " + LocationToString(GetLocation(oTest)) + " target " + LocationToString(GetLocation(oTarget)));
//                    ClearAllActions();
                    ActionMoveToLocation(destLocation, TRUE);

                    if (!GetLocalInt(OBJECT_SELF, HENCH_AI_SCRIPT_POLL))
                    {
                        SetLocalInt(OBJECT_SELF, HENCH_AI_SCRIPT_POLL, TRUE);
                        DelayCommand(2.0, HenchStartCombatRoundAfterDelay(oTarget));
                    }

//                  ActionDoCommand(HenchDetermineCombatRound(oTarget, TRUE));
                    return FALSE;
                }
                else
                {
//					Jug_Debug(GetName(OBJECT_SELF ) + " setting location failed for " + GetName(oTarget));
                    SetLocalLocation(OBJECT_SELF, sHenchLastAttackLocation, GetLocation(OBJECT_SELF));
                }
            }
        }
    }

	if (!bRangedWeapon && (GetDistanceToObject(oTarget) > 7.5))
	{	
		if (!GetLocalInt(OBJECT_SELF, HENCH_AI_SCRIPT_POLL))
		{
			SetLocalInt(OBJECT_SELF, HENCH_AI_SCRIPT_POLL, TRUE);
			DelayCommand(2.0, HenchStartCombatRoundAfterDelay(oTarget));
		}
	}

//	Jug_Debug("$$$$$$$$$$" + GetName(OBJECT_SELF) + " in HenchDoTalentMeleeAttack " + GetName(oTarget) + " action is " + IntToString(GetCurrentAction()) + " Plot " + IntToString(GetPlotFlag(oTarget)) + " allow feat use " + IntToString(bAllowFeatUse));

    int iIntCheck = GetAbilityScore(OBJECT_SELF, ABILITY_INTELLIGENCE) - 2;
    if (iIntCheck < 6)
    {
        // have less smart creatures not use best combat feats all the time
        if (iIntCheck < 1)
        {
            iIntCheck = 1;
        }
        if (iIntCheck < d6())
        {
            UseCombatAttack(oTarget);
            return TRUE;
        }
    }
	
	if (bAllowFeatUse && GetHasFeat(FEAT_STORMLORD_SHOCK_WEAPON))
	{
//		Jug_Debug(GetName(OBJECT_SELF) + " check shock");
		if (GetIsObjectValid(oRightWeapon))
		{
			int nItemType = GetBaseItemType(oRightWeapon);
			if ((nItemType == BASE_ITEM_DART) ||
				(nItemType == BASE_ITEM_SHURIKEN) ||
				(nItemType == BASE_ITEM_THROWINGAXE) ||
				(nItemType == BASE_ITEM_SPEAR))
			{			
				int bFound;			
	            itemproperty curItemProp = GetFirstItemProperty(oRightWeapon);
	            while(GetIsItemPropertyValid(curItemProp))
	            {
//	                int iItemTypeValue = GetItemPropertyType(curItemProp);
//					Jug_Debug(GetName(oRightWeapon) + " has item type value " + IntToString(iItemTypeValue) +
//						" isub type " + IntToString(GetItemPropertySubType(curItemProp)) + " cost table " + IntToString(GetItemPropertyCostTableValue(curItemProp)) +
//						" item param 1 " + IntToString(GetItemPropertyParam1(curItemProp)) + " item param 1 value " + IntToString(GetItemPropertyParam1Value(curItemProp)));				
					if ((GetItemPropertyType(curItemProp) == ITEM_PROPERTY_DAMAGE_BONUS) &&
						(GetItemPropertySubType(curItemProp) == IP_CONST_DAMAGETYPE_ELECTRICAL) &&
						(GetItemPropertyCostTableValue(curItemProp) == IP_CONST_DAMAGEBONUS_1d8))
					{					
						bFound = TRUE;
						break;
					}			
                	curItemProp = GetNextItemProperty(oRightWeapon);			
				}
				if (!bFound)
				{			
//					Jug_Debug(GetName(OBJECT_SELF) + " use shock");
					ClearAllActions();
					ActionUseFeat(FEAT_STORMLORD_SHOCK_WEAPON, OBJECT_SELF);
					return TRUE;
				}
			}
		} 
	}

    int iAC = GetAC(oTarget);
    int iNewBAB = GetBaseAttackBonus(OBJECT_SELF) + 5 + d4(2);

    int bCombatModeUseEnabled = !GetLocalInt(OBJECT_SELF, N2_COMBAT_MODE_USE_DISABLED);
	
	int bCanUseFlurryOfBlows = GetHasFeat(FEAT_FLURRY_OF_BLOWS) &&
		(!GetIsObjectValid(oRightWeapon) ||
        (GetBaseItemType(oRightWeapon) == BASE_ITEM_KAMA) ||
        (GetBaseItemType(oRightWeapon) == BASE_ITEM_QUARTERSTAFF) ||
		(GetBaseItemType(oRightWeapon) == BASE_ITEM_SHURIKEN)) &&
		(GetArmorRank(GetItemInSlot(INVENTORY_SLOT_CHEST)) == ARMOR_RANK_NONE);

    if (bRangedWeapon)
    {
        if (bgEnableMoveAway)
        {
//          Jug_Debug("$$$$$$$$$$" + GetName(OBJECT_SELF) + " doing move away from " + GetName(oTarget));
            if (MoveAwayFromEnemies(oTarget, 9.0))
            {
                HenchStartCombatRoundAfterAction(oTarget);
//              bgEnableMoveAway = FALSE;
//              ActionDoCommand(HenchDoTalentMeleeAttack(oTarget, fThresholdDistance, iCreatureType));
                return FALSE;
            }
        }
		
		if (bCombatModeUseEnabled)
		{
	        // TODO add FEAT_COMBATSTYLE_RANGER_ARCHERY_MANY_SHOT?
	        // Always use if present
	        int bHasRapidShot = GetHasFeat(FEAT_RAPID_SHOT);
	        if (!bHasRapidShot)
	        {
	            if (GetHasFeat(FEAT_COMBATSTYLE_RANGER_ARCHERY_RAPID_SHOT))
	            {
	                object oArmor = GetItemInSlot(INVENTORY_SLOT_CHEST);
	                bHasRapidShot = !GetIsObjectValid(oArmor) || GetArmorRank(oArmor) <= ARMOR_RANK_LIGHT;
	            }
	        }
	        if (bHasRapidShot)
	        {
	            int iItemType = GetBaseItemType(oRightWeapon);
	            if (iItemType == BASE_ITEM_SHORTBOW || iItemType == BASE_ITEM_LONGBOW)
	            {
	                UseCombatAttack(oTarget, -1, ACTION_MODE_RAPID_SHOT);
	                return TRUE;
	            }
	        }
			// flurry of blows with shuriken
			if (bCanUseFlurryOfBlows)
	        {
	            UseCombatAttack(oTarget, -1, ACTION_MODE_FLURRY_OF_BLOWS);
	            return TRUE;
		    }
	        // TODO power attack works with throwing axes
		}
//      Jug_Debug(GetName(OBJECT_SELF) + " doing generic ranged attack");
        UseCombatAttack(oTarget);
        return TRUE;
    }

    struct sAttackInfo attackInfo = GetMeleeAttackBonus(OBJECT_SELF, oRightWeapon, oTarget);
    iNewBAB += attackInfo.attackBonus;

    float relativeChallenge;
    if (iCreatureType == 0)
    {
        // monsters always use best feat
        relativeChallenge = -10.0;
    }
    else
    {
    // TODO change to GetRawChallengeRating?
        relativeChallenge = IntToFloat(GetHitDice(OBJECT_SELF)) * HENCH_HITDICE_TO_CR;
        relativeChallenge -= IntToFloat(GetHitDice(oTarget)) * HENCH_HITDICE_TO_CR;
    }

    int preferredActionMode;
	if (bCombatModeUseEnabled)
	{
		if (bCanUseFlurryOfBlows && (GetLevelByClass(CLASS_TYPE_MONK) >= 9))
		{
			preferredActionMode = ACTION_MODE_FLURRY_OF_BLOWS;
		}
		else
		{
			preferredActionMode = -1; 
		}
	}
	else
	{
		preferredActionMode = -2;
	}

    int bStartOfRound = bAllowFeatUse && (GetCurrentAction() == ACTION_INVALID);
    if (bStartOfRound)
    {
        // For use against them evil pests! Top - one use only anyway.
        if (GetHasFeat(FEAT_SMITE_EVIL) &&
            (GetAlignmentGoodEvil(oTarget) == ALIGNMENT_EVIL) &&
            relativeChallenge <= 2.0)
        {
            UseCombatAttack(oTarget, FEAT_SMITE_EVIL, preferredActionMode);
            return TRUE;
        }
        if (GetHasFeat(FEAT_SMITE_GOOD) &&
            (GetAlignmentGoodEvil(oTarget) == ALIGNMENT_GOOD) &&
            (relativeChallenge <= 2.0))
        {
            UseCombatAttack(oTarget, FEAT_SMITE_GOOD, preferredActionMode);
            return TRUE;
        }
        if (GetHasFeat(1761) &&     // FEAT_SMITE_INFIDEL
            (GetAlignmentGoodEvil(oTarget) != GetAlignmentGoodEvil(OBJECT_SELF)) &&
            (relativeChallenge <= 2.0))
        {
            UseCombatAttack(oTarget, 1761, preferredActionMode);
            return TRUE;
        }
        if (GetHasFeat(FEAT_SACRED_VENGEANCE) && GetHasFeat(FEAT_TURN_UNDEAD) &&
            (GetRacialType(oTarget) == RACIAL_TYPE_UNDEAD) &&
            (relativeChallenge <= 0.0))
        {
//          Jug_Debug(GetName(OBJECT_SELF) + " using sacred vengeance");
            ActionUseFeat(FEAT_SACRED_VENGEANCE, oTarget);
            UseCombatAttack(oTarget, -1, preferredActionMode);
            return TRUE;
        }
    }

    int powerAttackLevel = GetHasFeat(FEAT_IMPROVED_POWER_ATTACK) ? 2 : GetHasFeat(FEAT_POWER_ATTACK) ? 1 : 0;
    if (bCombatModeUseEnabled && powerAttackLevel)
    {
        int iOurSize = GetCreatureSize(OBJECT_SELF);
        int iWeaponSize = GetMeleeWeaponSize(oRightWeapon);

        if (!GetIsObjectValid(oRightWeapon) || (iWeaponSize >= iOurSize))
        {
            if (GetActionMode(OBJECT_SELF, ACTION_MODE_IMPROVED_POWER_ATTACK))
            {
                SetActionMode(OBJECT_SELF, ACTION_MODE_IMPROVED_POWER_ATTACK, FALSE);
            }
            if (GetActionMode(OBJECT_SELF, ACTION_MODE_POWER_ATTACK))
            {
                SetActionMode(OBJECT_SELF, ACTION_MODE_POWER_ATTACK, FALSE);
            }

            if (!GetIsWeaponEffective(oTarget))
            {
    //      Jug_Debug(GetName(OBJECT_SELF) + " weap not effective vs. " + GetName(oTarget));
                if (powerAttackLevel > 1)
                {
                    preferredActionMode = ACTION_MODE_IMPROVED_POWER_ATTACK;
                }
                else
                {
                    preferredActionMode = ACTION_MODE_POWER_ATTACK;
                }
            }
    //      else
    //      {
    //      Jug_Debug(GetName(OBJECT_SELF) + " weap is effective vs. " + GetName(oTarget));
    //      }
        }
        else
        {
            // can't use power attack with light weapons
            powerAttackLevel = 0;
        }
    }
	
    // * only the playable races have whirlwind attack
    // * Attempt to Use Whirlwind Attack
    if (bCombatModeUseEnabled && bAllowFeatUse && GetHasFeat(FEAT_WHIRLWIND_ATTACK) && GetOKToWhirl(OBJECT_SELF))
    {
        int iAttackThreshold;
        if (GetCurrentHitPoints(oTarget) <= (attackInfo.damageBonus + 5))
        {
            // a single hit is likely to kill target, check if any other targets are available
            iAttackThreshold = 2;
        }
        else
        {
            // set number of whirlwind targets needed equal to the number of attacks per round
            iAttackThreshold = (GetBaseAttackBonus(OBJECT_SELF) + 1) / 5;
        }
        float fThresholdDistance;
        int iSizeThreshold;
        if (GetHasFeat(FEAT_IMPROVED_WHIRLWIND))
        {
            fThresholdDistance = 10.0;
            iSizeThreshold = CREATURE_SIZE_HUGE;
        }
        else
        {
            fThresholdDistance = 3.0;
            iSizeThreshold = CREATURE_SIZE_MEDIUM;
        };

        object oTestTarget = GetLocalObject(OBJECT_SELF, sLineOfSight);
        while (GetIsObjectValid(oTestTarget))
        {
            if ((GetDistanceToObject(oTestTarget) <= fThresholdDistance) &&
                (GetCreatureSize(oTestTarget) <= iSizeThreshold))
            {
                --iAttackThreshold;
                if (iAttackThreshold <= 0)
                {
                    break;
                }
            }
            oTestTarget = GetLocalObject(oTestTarget, sLineOfSight);
        }
//      Jug_Debug(GetName(OBJECT_SELF) + " num attacks " + IntToString((GetBaseAttackBonus(OBJECT_SELF) + 1) / 5) + " count is " + IntToString(iAttackThreshold));
        if (iAttackThreshold <= 0)
        {
            UseCombatAttack(oTarget, FEAT_WHIRLWIND_ATTACK, preferredActionMode);
            ActionAttack(oTarget);  // must keep in attack mode after whirlwind
            return TRUE;
        }
    }
        // TODO update for HotU, dwarven defender (is same as barb rage?)
    if (relativeChallenge <= 2.0 && TryKiDamage(oTarget))
    {
        return TRUE;
    }

    if (bStartOfRound &&
        (d6() == 1) &&
        !GetIsImmune(oTarget, IMMUNITY_TYPE_CRITICAL_HIT, OBJECT_SELF) &&
        (iNewBAB >= iAC))
    {
        int bHasQuiveringPalm = GetHasFeat(FEAT_QUIVERING_PALM);
        int bHasStunningFist = GetHasFeat(FEAT_STUNNING_FIST);
        if ((bHasQuiveringPalm || bHasStunningFist) &&
            relativeChallenge <= 2.0  &&
            (GetCharacterLevel(OBJECT_SELF) / 2 + 10 + GetAbilityModifier(ABILITY_WISDOM) >=
            GetFortitudeSavingThrow(oTarget) + 5 + Random(15)))
        {
            if (!(GetCreatureNegEffects(oTarget) & HENCH_EFFECT_DISABLED))
            {
                if (bHasQuiveringPalm && !GetIsObjectValid(oRightWeapon))
                {
                    UseCombatAttack(oTarget, FEAT_QUIVERING_PALM, preferredActionMode);
                    return TRUE;
                }
                if (bHasStunningFist)
                {
                    int iMod = iNewBAB;
                    if (GetIsObjectValid(oRightWeapon) || (GetLevelByClass(CLASS_TYPE_MONK) == 0))
                    {
                        iMod -= 4;
                    }
                    if (iMod >= iAC)
                    {
                        UseCombatAttack(oTarget, FEAT_STUNNING_FIST, preferredActionMode);
                        return TRUE;
                    }
                }
            }
        }
    }
	
    int bHasImprovedKnockdown = GetHasFeat(FEAT_IMPROVED_KNOCKDOWN);
    if(bAllowFeatUse && bCombatModeUseEnabled && (bHasImprovedKnockdown || GetHasFeat(FEAT_KNOCKDOWN)) &&
        !GetHenchOption(HENCH_OPTION_KNOCKDOWN_DISABLED) &&
        (!GetHenchOption(HENCH_OPTION_KNOCKDOWN_SOMETIMES) || (d8() == 1)) &&
        !GetIsImmune(oTarget, IMMUNITY_TYPE_KNOCKDOWN, OBJECT_SELF) &&
        !GetHasFeatEffect(FEAT_KNOCKDOWN, oTarget) &&
        !GetHasFeatEffect(FEAT_IMPROVED_KNOCKDOWN, oTarget))
    {
        // By far the BEST feat to use - knocking them down lets you freely attack them!
        // These return 1-5, based on size.
        int iOurSize = GetCreatureSize(OBJECT_SELF);
        int iTheirSize = GetCreatureSize(oTarget);
        if (abs(iOurSize - iTheirSize) <= 1)
        {
            if (bHasImprovedKnockdown)
            {
                iOurSize++;
            }
            int iOurCheck = GetAbilityModifier(ABILITY_STRENGTH, OBJECT_SELF) +
                ((iOurSize - iTheirSize) * 4);
            int iOppCheck = GetAbilityModifier(ABILITY_STRENGTH, oTarget);
            int iOppDexCheck = GetAbilityModifier(ABILITY_DEXTERITY, oTarget);
            if (iOppDexCheck > iOppCheck)
            {
                iOppCheck = iOppDexCheck;
            }
//			Jug_Debug(GetName(OBJECT_SELF) + " kd " + IntToString(iOurCheck - iOppCheck));
            if(iOurCheck + d4(2) - 5 > iOppCheck)
            {
                int allyAttacking;
                int allyDoesKnockdown = 1;

                object oTest = GetFirstObjectInShape(SHAPE_SPHERE, 6.5, GetLocation(oTarget), TRUE);
                while(GetIsObjectValid(oTest))
                {
                     if ((oTest != OBJECT_SELF) && (GetAttackTarget(oTest) == oTarget))
                     {
                        if (GetObjectSeen(oTest) || GetObjectHeard(oTest))
                        {
                            allyAttacking = TRUE;
                            if (GetHasFeat(FEAT_KNOCKDOWN, oTest))
                            {
                                allyDoesKnockdown ++;
                            }
                        }
                     }
                     oTest = GetNextObjectInShape(SHAPE_SPHERE, 6.5, GetLocation(oTarget), TRUE);
                }
//				Jug_Debug(GetName(OBJECT_SELF) + " kd allay " + IntToString(allyAttacking));

                // check that we have more than one attack in a round or nearby friend also attacking
                if ((Random(allyDoesKnockdown) == 0) && (allyAttacking ||
                    (GetBaseAttackBonus(OBJECT_SELF) > 5) && ((iNewBAB - 5) >= iAC)))
                {
//					Jug_Debug(GetName(OBJECT_SELF) + " doing kd");
                    UseCombatAttack(oTarget, bHasImprovedKnockdown ? FEAT_IMPROVED_KNOCKDOWN : FEAT_KNOCKDOWN, preferredActionMode);
                    return TRUE;
                }
            }
        }
    }

    // start using expertise if have under 50% hit points
    if (bCombatModeUseEnabled && GetPercentageHPLoss(OBJECT_SELF) < 50 &&
        (GetHasFeat(FEAT_COMBAT_EXPERTISE) || GetHasFeat(FEAT_IMPROVED_COMBAT_EXPERTISE)))
    {
        // get estimation of opponent attack vs. my AC
        int iMyAC = GetAC(OBJECT_SELF);
        int iTargetsBAB = GetBaseAttackBonus(oTarget) + 3 + d4(2) + GetAttackBonus(oTarget, OBJECT_SELF).attackBonus;

        if (GetHasFeat(FEAT_IMPROVED_COMBAT_EXPERTISE) && (iTargetsBAB - 5) >= iMyAC)
        {
            UseCombatAttack(oTarget, -1, ACTION_MODE_IMPROVED_COMBAT_EXPERTISE);
            return TRUE;
        }
        if (iTargetsBAB >= iMyAC)
        {
            UseCombatAttack(oTarget, -1, ACTION_MODE_COMBAT_EXPERTISE);
            return TRUE;
        }
    }

        // TODO defensive stance, flourish, impromptu sneak attack
    // check for using feint
    if (bStartOfRound &&
        bCombatModeUseEnabled &&
        GetHasFeat(FEAT_FEINT) && GetHasFeat(FEAT_SNEAK_ATTACK) &&
        (GetAttackTarget(oTarget) == OBJECT_SELF) &&
        GetObjectSeen(oTarget) &&
        !GetIsImmune(oTarget, IMMUNITY_TYPE_SNEAK_ATTACK, OBJECT_SELF))
    {
//      Jug_Debug(GetName(OBJECT_SELF) + " test feint");
        int iTargetIntelligence = GetAbilityScore(oTarget, ABILITY_INTELLIGENCE);
        if (iTargetIntelligence > 0)
        {
            int testDC = GetSkillRank(SKILL_BLUFF) - GetBaseAttackBonus(oTarget) - GetSkillRank(SKILL_SPOT, oTarget);
            if (iTargetIntelligence <= 2)
            {
                testDC -= 8;
            }
            else if (!GetIsHumanoid(GetRacialType(oTarget)))
            {
                testDC -= 4;
            }
            testDC += 5 + d4(2);
//          Jug_Debug(GetName(OBJECT_SELF) + " test feint dc " + IntToString(testDC));
            if ((testDC > 0) && (testDC > iNewBAB - iAC - 5))
            {
//              Jug_Debug(GetName(OBJECT_SELF) + " do feint " + IntToString(testDC));
                UseCombatAttack(oTarget, FEAT_FEINT);
                return TRUE;
            }
        }
    }

    // Only use parry on an active melee attacker, and
    // only if our parry skill > our AC - 10
    // JE, Apr.14,2004: Bugfix to make this actually work. Thanks to the message board
    // members who investigated this.
    if (bCombatModeUseEnabled && GetSkillRank(SKILL_PARRY) > (GetAC(OBJECT_SELF) - 10))
    {
    // TODO add support for improved parry, etc.
        object oTargetRightWeapon = GetItemInSlot(INVENTORY_SLOT_RIGHTHAND, oTarget);
        if (GetAttackTarget(oTarget) == OBJECT_SELF &&
            GetIsObjectValid(oTargetRightWeapon) &&
            !GetWeaponRanged(oTargetRightWeapon))
        {
            int iAttackChance = GetBaseAttackBonus(oTarget) + GetAttackBonus(oTarget, OBJECT_SELF).attackBonus - GetAC(OBJECT_SELF);
            if ((iAttackChance > -20) && (GetPercentageHPLoss(OBJECT_SELF) < 65))
            {
                if (GetIsObjectValid(ogClosestSeenFriend) && GetDistanceToObject(ogClosestSeenFriend) <= 5.0)
                {
                    UseCombatAttack(oTarget, -1, ACTION_MODE_PARRY);
                    return TRUE;
                }
            }
        }
    }

    //
    // Auldar: Give 10% chance to Taunt if target is within 3.5 meters and is a challenge, if Skill points have been
    // spent in Taunt skill indicating intention to use, and a taunt isn't in effect
    //
    if (bAllowFeatUse && bCombatModeUseEnabled && (d10() == 1) && (GetSkillRank(SKILL_TAUNT, OBJECT_SELF, TRUE) > 0) &&
		((relativeChallenge <= 2.0) || (GetCharacterLevel(oTarget) > (GetCharacterLevel(OBJECT_SELF) - 2)))
        && (GetDistanceToObject(oTarget) <= 3.5))
    {
        // Auldar: Adding a check for the Taunt skill, and ensuring that no one with ONLY a CHA mod to
        // Taunt will use the skill.
        // This confirms that some points are spent in the skill indicating an intention for the NPC to use them.
        // Also using 69MEH69's idea to check for a negative modifier so we don't subtract a negative number (ie add)
        // to the skill check
        if ((GetSkillRank(SKILL_TAUNT) + 5 + d4(2)) > GetSkillRank(SKILL_CONCENTRATION, oTarget))
        {
//			Jug_Debug(GetName(OBJECT_SELF) + " use taunt " + GetName(oTarget));
			ClearAllActions();
            ActionUseSkill(SKILL_TAUNT, oTarget);
            return TRUE;
        }
    }

    if (bAllowFeatUse && bCombatModeUseEnabled && d4() == 1 && (GetHasFeat(FEAT_IMPROVED_DISARM) || (GetHasFeat(FEAT_DISARM) && d2() == 1)) &&
        GetIsCreatureDisarmable(oTarget) &&
        ((GetIsObjectValid(oRightWeapon) && !GetWeaponRanged(oRightWeapon)) || !GetIsObjectValid(oRightWeapon)))
    {
        object oTargetRightWeapon = GetItemInSlot(INVENTORY_SLOT_RIGHTHAND, oTarget);
        if (GetIsObjectValid(oTargetRightWeapon) && !GetWeaponRanged(oTargetRightWeapon))
        {
            int iOurSize = GetCreatureSize(OBJECT_SELF);
            int iTheirSize = GetCreatureSize(oTarget);

            int iWeaponSize;
            if (GetIsObjectValid(oRightWeapon))
            {
                iWeaponSize = GetMeleeWeaponSize(oRightWeapon);
            }
            else
            {
                iWeaponSize = iOurSize;
            }
            int iTargetWeaponSize = GetMeleeWeaponSize(oTargetRightWeapon);

            int iTargetsBAB = GetBaseAttackBonus(oTarget) + 5 + d4(2) + GetAttackBonus(oTarget, OBJECT_SELF).attackBonus;

            if (iNewBAB + 4 * (iOurSize - iTheirSize + iWeaponSize - iTargetWeaponSize) - 5 > iTargetsBAB)
            {
                UseCombatAttack(oTarget, GetHasFeat(FEAT_IMPROVED_DISARM) ?
                    FEAT_IMPROVED_DISARM : FEAT_DISARM);
                return TRUE;
            }
        }
    }

    if (preferredActionMode >= 0)
    {
        UseCombatAttack(oTarget, -1, preferredActionMode);
        return TRUE;
    }

    // This activates an extra attack, only unarmed and kama
    if (bCombatModeUseEnabled && bCanUseFlurryOfBlows)
    {
//		Jug_Debug(GetName(OBJECT_SELF) + " using flurry");
		UseCombatAttack(oTarget, -1, ACTION_MODE_FLURRY_OF_BLOWS);
		return TRUE;
    }

    if (bCombatModeUseEnabled && powerAttackLevel)
    {
        // -6 to hit - make sure by extra 5
        if ((powerAttackLevel > 1) && ((iNewBAB - 14) >= iAC))
        {
            UseCombatAttack(oTarget, -1, ACTION_MODE_IMPROVED_POWER_ATTACK);
            return TRUE;
        }
        // is a -3 to hit - make sure by extra 5
        if ((iNewBAB - 8) >= iAC)
        {
            UseCombatAttack(oTarget, -1, ACTION_MODE_POWER_ATTACK);
            return TRUE;
        }
    }
	
    UseCombatAttack(oTarget, -1, preferredActionMode);
	return TRUE;
}


void ActionContinueMeleeAttack(object oTarget, float fThresholdDistance, int iCreatureType, int bAllowFeatUse, int iCallNumber)
{
//  Jug_Debug(GetName(OBJECT_SELF) + " in continue melee attack vs. " + GetName(oTarget));
    if (GetLocalInt(OBJECT_SELF, "UseRangedWeapons"))
    {
        if (!EquipRangedWeapon(oTarget, iCreatureType == 1, iCallNumber))
        {
//          Jug_Debug(GetName(OBJECT_SELF) + " !EquipRangedWeapon calling ActionContinueMeleeAttack");
            ActionDoCommand(ActionContinueMeleeAttack(oTarget, fThresholdDistance, iCreatureType, bAllowFeatUse, iCallNumber + 1));
            return;
        }
    }
    else
    {
        if (!EquipMeleeWeapons(oTarget, iCreatureType == 1, iCallNumber))
        {
//          Jug_Debug(GetName(OBJECT_SELF) + " !EquipMeleeWeapons calling ActionContinueMeleeAttack");
            ActionDoCommand(ActionContinueMeleeAttack(oTarget, fThresholdDistance, iCreatureType, bAllowFeatUse, iCallNumber + 1));
            return;
        }
    }
    if (HenchDoTalentMeleeAttack(oTarget, fThresholdDistance, iCreatureType, bAllowFeatUse) && !GetLocalInt(OBJECT_SELF, HENCH_AI_BLOCKED))
	{
		ActionDoCommand(HenchMoveAndDetermineCombatRound(oTarget));
	}
}


// MELEE ATTACK OTHERS
/*
    Auldar: Made changes here to use Taunt when appropriate as well as more accurate calculations for
    To-Hit vs Target AC.

    Tony: Made major changes in using attack feats. Heavily modified code from Jasperre.
*/

int HenchTalentMeleeAttack(object oTarget, float fThresholdDistance, int iCreatureType, int bPolymorphed, int iRangedOverride)
{
    if (iCreatureType == 0)
    {
       MonsterBattleCry();
    }
    else if (iCreatureType == 1)
    {
       HenchBattleCry();
    }
    if (!GetIsObjectValid(oTarget))
    {
        oTarget = goSaveMeleeAttackTarget;
//		Jug_Debug(GetName(OBJECT_SELF) + " melee set target to " + GetName(oTarget));
    }
//    Jug_Debug(GetName(OBJECT_SELF) + " start target " + GetName(oTarget) + " distance " + FloatToString(fThresholdDistance) + " creature type " + IntToString(iCreatureType) + " poly " + IntToString(bPolymorphed) + " ranged over " + IntToString(iRangedOverride));

    if (!GetIsObjectValid(oTarget))
    {
        if (GetIsObjectValid(ogClosestSeenOrHeardEnemy))
        {
            oTarget = ogClosestSeenOrHeardEnemy;
        }
        else if (GetIsObjectValid(ogClosestNonActiveEnemy))
        {
            oTarget = ogClosestNonActiveEnemy;
        }
        else
        {
            oTarget = ogDyingEnemy;
        }
    }

    if (GetDistanceToObject(oTarget) <= fThresholdDistance)
    {
        // make sure we go melee
        fThresholdDistance = 1000.0;
    }
    else if (GetHenchAssociateState(HENCH_ASC_MELEE_DISTANCE_ANY))
    {
//		Jug_Debug(GetName(OBJECT_SELF) + " check attack distance any");
        object oFriend = GetLocalObject(OBJECT_SELF, henchAllyStr);
        while (GetIsObjectValid(oFriend))
        {
			object oClosestEnemyOfFriend = GetNearestCreature(CREATURE_TYPE_REPUTATION, REPUTATION_TYPE_ENEMY,
			    oFriend, 1, CREATURE_TYPE_PERCEPTION, PERCEPTION_SEEN,
			    CREATURE_TYPE_IS_ALIVE, TRUE);
//			Jug_Debug(GetName(oFriend) + " found seen " + GetName(oClosestEnemyOfFriend) + " dis " + FloatToString(GetDistanceBetween(oFriend, oClosestEnemyOfFriend)));
            if (GetIsObjectValid(oClosestEnemyOfFriend) &&
				(GetDistanceBetween(oFriend, oClosestEnemyOfFriend) <= fThresholdDistance))
            {
                // make sure we go melee
                fThresholdDistance = 1000.0;
                break;
            }
			oClosestEnemyOfFriend = GetNearestCreature(CREATURE_TYPE_REPUTATION, REPUTATION_TYPE_ENEMY,
			    oFriend, 1, CREATURE_TYPE_PERCEPTION, PERCEPTION_HEARD_AND_NOT_SEEN,
			    CREATURE_TYPE_IS_ALIVE, TRUE);
//			Jug_Debug(GetName(oFriend) + " found seen " + GetName(oClosestEnemyOfFriend) + " dis " + FloatToString(GetDistanceBetween(oFriend, oClosestEnemyOfFriend)));
            if (GetIsObjectValid(oClosestEnemyOfFriend) &&
				(GetDistanceBetween(oFriend, oClosestEnemyOfFriend) <= fThresholdDistance))
            {
                // make sure we go melee
                fThresholdDistance = 1000.0;
                break;
            }
            oFriend = GetLocalObject(oFriend, henchAllyStr);
        }
    }

//	Jug_Debug(GetName(OBJECT_SELF) + " start target4 " + GetName(oTarget));

 //   Jug_Debug(GetName(OBJECT_SELF) + " weapon effective " + IntToString(GetIsWeaponEffective(oTarget)));

    SetLocalObject(OBJECT_SELF, sHenchLastTarget, oTarget);

    if (!HenchEquipAppropriateWeapons(oTarget, fThresholdDistance, iCreatureType == 1, bPolymorphed, iRangedOverride))
    {
//      Jug_Debug(GetName(OBJECT_SELF) + " !HenchEquipAppropriateWeapons calling ActionContinueMeleeAttack");
        ActionDoCommand(ActionContinueMeleeAttack(oTarget, fThresholdDistance, iCreatureType, !bPolymorphed, 2));
    }
    else
    {
        if (HenchDoTalentMeleeAttack(oTarget, fThresholdDistance, iCreatureType, !bPolymorphed) && !GetLocalInt(OBJECT_SELF, HENCH_AI_BLOCKED))
		{
			ActionDoCommand(HenchMoveAndDetermineCombatRound(oTarget));
		}
    }

    return TRUE;
}


//::///////////////////////////////////////////////
//:: Bash Doors
//:: Copyright (c) 2002 Bioware Corp.
//:://////////////////////////////////////////////
/*
    Used in DetermineCombatRound to keep a
    henchmen bashing doors.
*/
//:://////////////////////////////////////////////
//:: Created By: Preston Watamaniuk
//:: Created On: April 4, 2002
//:://////////////////////////////////////////////

int HenchBashDoorCheck(int bPolymorphed)
{
    int bDoor = FALSE;
    //This code is here to make sure that henchmen keep bashing doors and placeables.
    object oDoor = GetLocalObject(OBJECT_SELF, "NW_GENERIC_DOOR_TO_BASH");

    if(GetIsObjectValid(oDoor))
    {
        int nDoorMax = GetMaxHitPoints(oDoor);
        int nDoorNow = GetCurrentHitPoints(oDoor);
        int nCnt = GetLocalInt(OBJECT_SELF,"NW_GENERIC_DOOR_TO_BASH_HP");
        if(GetLocked(oDoor) || GetIsTrapped(oDoor))
        {
            if(nDoorMax == nDoorNow)
            {
                nCnt++;
                SetLocalInt(OBJECT_SELF,"NW_GENERIC_DOOR_TO_BASH_HP", nCnt);
            }
            if(nCnt <= 2)
            {
                bDoor = TRUE;
                HenchAttackObject(oDoor);
            }
        }
        if(!bDoor)
        {
            DeleteLocalObject(OBJECT_SELF, "NW_GENERIC_DOOR_TO_BASH");
            DeleteLocalInt(OBJECT_SELF, "NW_GENERIC_DOOR_TO_BASH_HP");
            VoiceCuss();
            ActionDoCommand(HenchEquipDefaultWeapons());
        }
    }
    return bDoor;
}


void HenchStartRangedBashDoor(object oDoor)
{
    ActionEquipMostDamagingRanged(oDoor);
    if (GetDistanceToObject(oDoor) < 5.0)
    {
         ActionMoveAwayFromObject(oDoor, FALSE, 5.0);
    }
    else
    {
        ActionWait(0.5);
    }
    ActionAttack(oDoor);
    SetLocalObject(OBJECT_SELF, "NW_GENERIC_DOOR_TO_BASH", oDoor);
}


void HenchAttackObject(object oTarget)
{
    if (GetWeaponRanged(GetItemInSlot(INVENTORY_SLOT_RIGHTHAND)))
    {
        UseCombatAttack(oTarget);
    }
    else if(GetHasFeat(FEAT_IMPROVED_POWER_ATTACK))
    {
        UseCombatAttack(oTarget, FEAT_IMPROVED_POWER_ATTACK);
    }
    else if(GetHasFeat(FEAT_POWER_ATTACK))
    {
        UseCombatAttack(oTarget, FEAT_POWER_ATTACK);
    }
    else
    {
        UseCombatAttack(oTarget);
    }
}