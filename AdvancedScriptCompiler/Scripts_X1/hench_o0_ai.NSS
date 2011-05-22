/*

    Companion and Monster AI

    This is the main AI script called by HenchDetermineCombatRound

*/

#include "ginc_companion"

#include "hench_i0_heal"
#include "hench_i0_spells"
#include "hench_i0_itemsp"
#include "hench_i0_ai"
#include "hench_i0_act"
#include "hench_i0_melee"
#include "hench_i0_initialize"
#include "hench_i0_assoc"


void main();

// Threshold challenge rating for buff spells
const float PAUSANIAS_CHALLENGE_THRESHOLD = -1.0;
const float PAUSANIAS_FAMILIAR_THRESHOLD = -2.0;
const float PAUSANIAS_DISTANCE_THRESHOLD_NEAR = 3.5;
const float PAUSANIAS_DISTANCE_THRESHOLD_MED = 5.0;
const float PAUSANIAS_DISTANCE_THRESHOLD_FAR = 6.5;


// calls back main ai routine (with a DelayCommand)
void HenchContinueAttack()
{
//Jug_Debug(GetName(OBJECT_SELF) + " doing a continue attack");
    SetLocalInt(OBJECT_SELF, HENCH_AI_SCRIPT_POLL, FALSE);
    main();
}


void main()
{
//	Jug_Debug(GetName(OBJECT_SELF) + " starting det combat action " + IntToString(GetCurrentAction()));
/*  if (GetIsObjectValid(GetMaster()))
    {
        SpawnScriptDebugger();
    } */
    object oIntruder = GetLocalObject(OBJECT_SELF, HENCH_AI_SCRIPT_INTRUDER_OBJ);
    int bForce = GetLocalInt(OBJECT_SELF, HENCH_AI_SCRIPT_FORCE);
    SetLocalInt(OBJECT_SELF, HENCH_AI_SCRIPT_RUN_STATE, HENCH_AI_SCRIPT_ALREADY_RUN);

    SetLocalInt(OBJECT_SELF, HENCH_HEAL_SELF_STATE, HENCH_HEAL_SELF_UNKNOWN);

        // destroy self if pseudo summons and master not valid, not currently enabled
 /*   if (GetLocalInt(OBJECT_SELF, sHenchPseudoSummon) && !GetIsObjectValid(GetMaster()))
    {
        DestroyObject(OBJECT_SELF, 0.1);
        ApplyEffectAtLocation(DURATION_TYPE_TEMPORARY, EffectVisualEffect(VFX_IMP_UNSUMMON), GetLocation(OBJECT_SELF));
        return;
    } */
    gICheckCreatureInfoStaleTime = 3; // maximum cache time in seconds for effect information
    InitializeCreatureInformation(OBJECT_SELF);

        //DBR 8/03/06 I am a puppet. I put nothing on the ActionQueue myself.
    if (GetAssociateState(NW_ASC_MODE_PUPPET))
    {
        return;
    }

    //DBR 9/12/06 - If there are player-queued action on me, return.
    if (GetHasPlayerQueuedAction(OBJECT_SELF))
    {
        return;
    }

    // prevent running script if PC controlled (delay commands cause call back)
    if (GetIsPC(OBJECT_SELF))
    {
        return;
    }

//	float time = IntToFloat(GetTimeSecond()) + IntToFloat(GetTimeMillisecond()) /1000.0;
//	Jug_Debug(GetName(OBJECT_SELF) + " starting det combat int = " + GetName(oIntruder) + " action " + IntToString(GetCurrentAction()) + " time " + FloatToString(time));

    if (HenchCheckEventClearAllActions(FALSE))
    {
        return;
    }
//	Jug_Debug(GetName(OBJECT_SELF) + " starting det combat int  = " + GetName(oIntruder) + " action " + IntToString(GetCurrentAction()) + " time " + FloatToString(time));

    object oMaster = HenchGetDefendee();
	
	    // MODIFIED FEBRUARY 13 2003
    // The associate will not engage in battle if in Stand Ground mode unless
    // he takes damage
    if (GetAssociateState(NW_ASC_MODE_STAND_GROUND) || GetAssociateState(NW_ASC_MODE_PUPPET))
	{ 
		if (GetIsObjectValid(GetFactionLeader(OBJECT_SELF)))
		{
			if (!GetIsObjectValid(GetLastHostileActor()))
			{
        		return;
			}
		}
		else
		{
			SetAssociateState(NW_ASC_MODE_STAND_GROUND, FALSE);
		}
	}

    int iAmMonster = !GetIsObjectValid(GetFactionLeader(OBJECT_SELF));
    int iHaveMaster = !iAmMonster && GetIsObjectValid(oMaster);
    int iAmHenchman,iAmFamiliar,iAmCompanion;
    if (iHaveMaster)
    {
        int nAssocType = GetAssociateType(OBJECT_SELF);
        iAmHenchman = (nAssocType == ASSOCIATE_TYPE_HENCHMAN) || GetIsRosterMember(OBJECT_SELF) || GetIsOwnedByPlayer(OBJECT_SELF);
        iAmFamiliar = nAssocType == ASSOCIATE_TYPE_FAMILIAR;
        iAmCompanion = nAssocType == ASSOCIATE_TYPE_ANIMALCOMPANION;
    }

    if (!GetLocalInt(OBJECT_SELF, "HenchAutoIdentify"))
    {
        SetLocalInt(OBJECT_SELF, "HenchAutoIdentify", TRUE);
        if (iAmMonster || (GetAssociateType(OBJECT_SELF) != ASSOCIATE_TYPE_NONE))
        {
            HenchIdentifyWeapons();
			
            if (GetHenchOption(HENCH_OPTION_ENABLE_AUTO_BUFF) &&
                (GetAssociateType(OBJECT_SELF) == ASSOCIATE_TYPE_NONE) &&
                !GetHasEffect(EFFECT_TYPE_SPELL_FAILURE) && !GetHasEffect(EFFECT_TYPE_SILENCE))
            {
 //               HenchQuickCastBuffs(GetHenchOption(HENCH_OPTION_ENABLE_AUTO_MEDIUM_BUFF));
            }

            if (GetHenchOption(HENCH_OPTION_ENABLE_EQUIPPED_ITEM_USE))
            {
                HenchAllowUseofEquippedItemSpells();
            }

            if (GetHenchOption(HENCH_OPTION_ENABLE_ITEM_CREATION) &&
                (GetRacialType(OBJECT_SELF) != RACIAL_TYPE_UNDEAD) &&
                (GetAbilityScore(OBJECT_SELF, ABILITY_INTELLIGENCE) >= 6) &&
                GetCreatureUseItems(OBJECT_SELF))
            {
                HenchCreateItemsToUse();
            }

            HenchDetermineCombatRound(oIntruder, TRUE); // redo combat round
            return;
        }
    }

//	Jug_Debug(GetName(OBJECT_SELF) + " monster " + IntToString(iAmMonster) + " hench " + IntToString(iAmHenchman) + " master " + IntToString(iHaveMaster));

    if (!iAmMonster)
    {
        HenchGetDefSettings();
    }

    InitializeBasicTargetInfo();

//	Jug_Debug(GetName(OBJECT_SELF) + " starting det combat 2 int = " + GetName(oIntruder) + " action " + IntToString(GetCurrentAction()) + " time " + FloatToString(time));

        // ----------------------------------------------------------------------------------------
    // 7/29/05 -- EPF, OEI
    // Due to the many, many plot-related cutscenes, we have decided to prevent anyone in the
    // PC faction from being attacked while they are in conversation.  Eventually, this should
    // probably include a check to see if the conversation itself is a plot cutscene, but for
    // now that flag is NYI.  Effectively, this is just a "pause" on combat until the
    // conversation ends.  Then the PC party is fair game.
    // 5/30/06 -- DBR, OEI
    // Flag is IN! GetIsInCutscene() now only checks for multiplayer flagged cutscenes.
    // ----------------------------------------------------------------------------------------
    if (GetIsInCutscene(ogClosestSeenOrHeardEnemy))
    {
//      Jug_Debug("DetermineCombatRound(): In cutscene.  Aborting function.");
        ClearAllActions(TRUE);
        ActionWait(3.f);
        ActionDoCommand(HenchDetermineCombatRound());
        return;
    }

    float fDistance = GetDistanceToObject(ogClosestSeenOrHeardEnemy);

    if (iHaveMaster)
    {
            // BMA-OEI 9/13/06: Player Queued Target override
        object oPreferredTarget = GetPlayerQueuedTarget( OBJECT_SELF );
        if ( ( GetIsObjectValid( oPreferredTarget ) ) &&
             ( !GetIsDead( oPreferredTarget ) ) &&
             ( GetArea( oPreferredTarget ) == GetArea( OBJECT_SELF ) ) &&
             (GetObjectSeen(oPreferredTarget) || GetObjectHeard(oPreferredTarget)))
        {
            oIntruder = oPreferredTarget;
            bForce = TRUE;
        }

        if (iAmHenchman)
        {
            DeleteLocalInt(OBJECT_SELF, HENCH_AI_WEAPON);
        }
    }
	
	int iNegEffectsOnSelf = GetCreatureNegEffects(OBJECT_SELF);

    if (iNegEffectsOnSelf & HENCH_EFFECT_DISABLED)
    {
		int disablingEffects = iNegEffectsOnSelf & HENCH_EFFECT_DISABLED;
		if (iNegEffectsOnSelf == HENCH_EFFECT_TYPE_DAZED)
		{
        // TODO dazed can walk around - move away from enemies		
		}
        return;
    }

    if(!GetIsObjectValid(oIntruder) ||
        GetIsDead(oIntruder) ||
        GetLocalInt(oIntruder, sHenchRunningAway) ||
        GetAssociateState(NW_ASC_MODE_DYING, oIntruder) ||
        GetPlotFlag(oIntruder) ||
        GetArea(OBJECT_SELF) != GetArea(oIntruder) ||
		(GetIsFriend(oIntruder) || GetFactionEqual(oIntruder)))
    {
//        Jug_Debug("@@@@@@@@@@@@@@" + GetName(OBJECT_SELF) + "removing unseen intruder to " + GetName(oIntruder));
        oIntruder = OBJECT_INVALID;
    }
    else if (!GetObjectSeen(oIntruder) && !GetObjectHeard(oIntruder))
    {
    // don't know where intruder is
//        Jug_Debug("@@@@@@@@@@@@@@" + GetName(OBJECT_SELF) + " setting unseen intruder to " + GetName(oIntruder));
        ogNotHeardOrSeenEnemy = oIntruder;
        oIntruder = OBJECT_INVALID;
		bForce = FALSE;
    }
    else if (!bForce)
    {
        oIntruder = OBJECT_INVALID;
    }
	
    gbIAmStuck = GetLocalInt(OBJECT_SELF, HENCH_AI_BLOCKED);

    // Auldar: If we are still in Search mode when we start to attack the enemy, stop searching.
    if (GetIsObjectValid(ogClosestSeenEnemy) && GetActionMode(OBJECT_SELF, ACTION_MODE_DETECT))
    {
        SetActionMode(OBJECT_SELF, ACTION_MODE_DETECT, FALSE);
    }

    if (iAmMonster)
    {
        // reset scout mode (no wandering enable pursue to open doors)
        DeleteLocalInt(OBJECT_SELF, sHenchScoutMode);
    }

    int iUseMagic = GetLocalInt(OBJECT_SELF, sHenchStopCasting) != 10;

    int iPosEffectsOnSelf = GetCreaturePosEffects(OBJECT_SELF);

    if (iHaveMaster && !bgAnyValidTarget && !GetIsObjectValid(ogNotHeardOrSeenEnemy))
    {
//        Jug_Debug(GetName(OBJECT_SELF) + " checking heal count " + IntToString(GetLocalInt(OBJECT_SELF, henchHealCountStr)));
        if (GetLocalInt(OBJECT_SELF, henchHealCountStr))
        {
            ActionDoCommand(ActionWait(2.5));
            ExecuteScript("hench_o0_heal", OBJECT_SELF);
            return;
        }
        if (HenchBashDoorCheck(iPosEffectsOnSelf & HENCH_EFFECT_TYPE_POLYMORPH))
        {
            return;
        }
    }
    if (GetLocalInt(OBJECT_SELF, henchHealCountStr))
    {
        DeleteLocalInt(OBJECT_SELF, henchHealCountStr);
        DeleteLocalInt(OBJECT_SELF, henchHealTypeStr);
        DeleteLocalInt(OBJECT_SELF, henchHealStateStr);
        DeleteLocalObject(OBJECT_SELF, henchHealSpellTarget);
    }

    // The following tweaks are implemented via Pausanias' dialog mods.
    int nClass = HenchDetermineClassToUse();
    // Herbivores should escape
   // special combat calls
    if (nClass == CLASS_TYPE_COMMONER)
    {
    // TODO later    HenchTalentHide(iEffectsOnSelf, bgMeleeAttackers);
        if (HenchTalentFlee(ogClosestSeenOrHeardEnemy))
        {
            return;
        }
    }
    if (GetCombatCondition(X0_COMBAT_FLAG_COWARDLY)
        && SpecialTacticsCowardly(ogClosestSeenOrHeardEnemy))
    {
        return;
    }

    //This check is to see if the master is being attacked and in need of help
    if (GetAssociateState(NW_ASC_MODE_DEFEND_MASTER))
    {
//		Jug_Debug(GetName(OBJECT_SELF) + " checking defend master " + GetName(oMaster));
        int bFoundTarget = FALSE;
        oIntruder = GetLastHostileActor(oMaster);
        if (!GetIsObjectValid(oIntruder) || (GetIsFriend(oIntruder) || GetFactionEqual(oIntruder)))
        {
            oIntruder = GetGoingToBeAttackedBy(oMaster);
            if (!GetIsObjectValid(oIntruder) || (GetIsFriend(oIntruder) || GetFactionEqual(oIntruder)))
            {
                oIntruder = GetLastHostileActor();
                if (!GetIsObjectValid(oIntruder) || (GetIsFriend(oIntruder) || GetFactionEqual(oIntruder)))
                {
                    if (GetHenchAssociateState(HENCH_ASC_GUARD_DISTANCE_NEAR))
                    {
                        if (fDistance > 7.0)
                        {
                            DeleteLocalObject(OBJECT_SELF, sHenchLastTarget);
                            return;
                        }
                    }
                    else if (GetHenchAssociateState(HENCH_ASC_GUARD_DISTANCE_MED))
                    {
                        if (fDistance > 13.5)
                        {
                            DeleteLocalObject(OBJECT_SELF, sHenchLastTarget);
                            return;
                        }
                    }
                    else if (GetHenchAssociateState(HENCH_ASC_GUARD_DISTANCE_FAR))
                    {
                        if (fDistance > 20.0)
                        {
                            DeleteLocalObject(OBJECT_SELF, sHenchLastTarget);
                            return;
                        }
                    }
                    else if (GetAssociateState(NW_ASC_USE_RANGED_WEAPON))
                    {
                        if (fDistance > 20.)
                        {
                            DeleteLocalObject(OBJECT_SELF, sHenchLastTarget);
                            return;
                        }
                    }
                    else if (fDistance > 7.0)
                    {
                        DeleteLocalObject(OBJECT_SELF, sHenchLastTarget);
                        return;
                    }
                }
                else
                {
//					Jug_Debug(GetName(OBJECT_SELF) + " found enemy of " + GetName(oIntruder));
                    bFoundTarget = TRUE;
                }
            }
            else
            {
//				Jug_Debug(GetName(OBJECT_SELF) + " found going to be attacked by " + GetName(oIntruder));
                bFoundTarget = TRUE;
            }
        }
        else
        {
//			Jug_Debug(GetName(OBJECT_SELF) + " found last hostile master " + GetName(oIntruder));
            bFoundTarget = TRUE;
        }
        if (bFoundTarget)
        {
            if (!GetObjectSeen(oIntruder) && !GetObjectHeard(oIntruder))
            {
            // don't know where intruder is
//                    Jug_Debug("@@@@@@@@@@@@@@" + GetName(OBJECT_SELF) + " setting unseen intruder to " + GetName(oIntruder));
                ogNotHeardOrSeenEnemy = oIntruder;
                oIntruder = OBJECT_INVALID;
            }
			else
			{
            	bForce = TRUE;
			}
        }
    }

    // NEXT: Do not attack if the master told you not to
    if (GetLocalInt(OBJECT_SELF, sHenchDontAttackFlag))
    {
		if (iAmMonster)
		{
			DeleteLocalInt(OBJECT_SELF, sHenchDontAttackFlag);
		}
		else if (!GetHenchPartyState(HENCH_PARTY_DISABLE_PEACEFUL_MODE))
		{
	        if (d10() > 7 && bgAnyValidTarget)
	        {
	            if (iAmHenchman)
	                SpeakString(sHenchHenchmanAskAttack);
	            else if (iAmFamiliar)
	                SpeakString(sHenchFamiliarAskAttack);
	            else if (iAmCompanion)
	                SpeakString("<" + GetName(OBJECT_SELF) + sHenchAnCompAskAttack);
	            else
	                SpeakString(sHenchOtherFollow1 + GetName(OBJECT_SELF) + sHenchOtherAskAttack);
	        }
	        HenchFollowLeader();
	        return;
		}
    }

    if (!bgAnyValidTarget)
    {
        DeleteLocalObject(OBJECT_SELF, sHenchLastTarget);

//		Jug_Debug(GetName(OBJECT_SELF) + " no valid target???");

        if (GetIsObjectValid(ogNotHeardOrSeenEnemy))
        {
//			Jug_Debug(GetName(OBJECT_SELF) + " setting not heard or seen target");
            SetEnemyLocation(ogNotHeardOrSeenEnemy);
        }
        else
        {
            ClearAllActions(TRUE);
            CleanCombatVars();
            ClearWeaponStates();
            if (iAmMonster)
            {
                HenchEquipDefaultWeapons();
                WalkWayPoints();
            }
            else
            {
                if (!GetHenchAssociateState(HENCH_ASC_DISABLE_AUTO_WEAPON_SWITCH))
                {
                    if (GetHenchPartyState(HENCH_PARTY_UNEQUIP_WEAPONS))
                    {
                        UnequipWeapons();
                    }
                    else
                    {
                       HenchEquipDefaultWeapons();
                    }
                }
            }
              // nothing more to do
            if (iHaveMaster)
            {
				HenchCheckOutOfCombatStealth(GetCurrentMaster());
                HenchFollowLeader();
            }
            DeleteLocalInt(OBJECT_SELF, HENCH_AI_COMBAT_EQUIP);
            return;
        }
    }
    else
    {
        ClearEnemyLocation();
    }

    SetLocalInt(OBJECT_SELF, HENCH_AI_COMBAT_EQUIP, TRUE);

    // fail safe set of last target
    if (GetIsObjectValid(ogClosestSeenOrHeardEnemy))
    {
        SetLocalObject(OBJECT_SELF, sHenchLastTarget, ogClosestSeenOrHeardEnemy);
    }

    int combatRoundCount = GetLocalInt(OBJECT_SELF, henchCombatRoundStr);
    int combatRoundIncremented;

    int currentTimeSec = GetTimeSecond();
    if (combatRoundCount == 0)
    {
        combatRoundCount ++;
        SetLocalInt(OBJECT_SELF, "LastCombatTime", currentTimeSec);
        SetLocalInt(OBJECT_SELF, henchCombatRoundStr, combatRoundCount);
        combatRoundIncremented = TRUE;
    }
    else
    {
        int lastCombatTime = GetLocalInt(OBJECT_SELF, "LastCombatTime");
        int lastCombatTimeDiff = currentTimeSec + 1 - lastCombatTime;
        if (lastCombatTimeDiff < 0)
        {
            lastCombatTimeDiff += 60;
        }
        if (lastCombatTimeDiff > 5)
        {
//          Jug_Debug(GetName(OBJECT_SELF) + " setting combat round count value " + IntToString(lastCombatTimeDiff));
            combatRoundCount ++;
            combatRoundIncremented = TRUE;
            SetLocalInt(OBJECT_SELF, henchCombatRoundStr, combatRoundCount);
            SetLocalInt(OBJECT_SELF, "LastCombatTime", currentTimeSec);
        }
    }

        //Shout that I was attacked
    if (!(iAmHenchman || iAmFamiliar || iAmCompanion) &&
        (HENCH_MONSTER_SHOUT_FREQUENCY > 0) &&
        (combatRoundCount % HENCH_MONSTER_SHOUT_FREQUENCY == 1))
    {
//      Jug_Debug(GetName(OBJECT_SELF) + " shouting I was attacked");
        SpeakString("NW_I_WAS_ATTACKED", TALKVOLUME_SILENT_TALK);
        SpeakString("NW_ATTACK_MY_TARGET", TALKVOLUME_SILENT_TALK);
    }

    // June 2/04: Fix for when henchmen is told to use stealth until next fight
    if (GetLocalInt(OBJECT_SELF, sHenchStealthMode) == 2)
    {
        SetLocalInt(OBJECT_SELF, sHenchStealthMode, 0);
    }
	
    // ----------------------------------------------------------------------------------------
    // July 27/2003 - Georg Zoeller,
    // Added to allow a replacement for determine combat round
    // If a creature has a local string variable named X2_SPECIAL_COMBAT_AI_SCRIPT
    // set, the script name specified in the variable gets run instead
    // see x2_ai_behold for details:
    // ----------------------------------------------------------------------------------------
    string sSpecialAI = GetLocalString(OBJECT_SELF,"X2_SPECIAL_COMBAT_AI_SCRIPT");
    if (sSpecialAI != "")
    {
        if (GetCurrentAction() == ACTION_INVALID)
        {
            //  Jug_Debug(GetName(OBJECT_SELF) + " special AI " + sSpecialAI);
            SetLocalObject(OBJECT_SELF,"X2_NW_I0_GENERIC_INTRUDER", oIntruder);
            ExecuteScript(sSpecialAI, OBJECT_SELF);
            if (GetLocalInt(OBJECT_SELF,"X2_SPECIAL_COMBAT_AI_SCRIPT_OK"))
            {
                //  Jug_Debug(GetName(OBJECT_SELF) + " exit special AI " + sSpecialAI);
                DeleteLocalInt(OBJECT_SELF,"X2_SPECIAL_COMBAT_AI_SCRIPT_OK");
                return;
            }
        }
        else
        {
            return;
        }
    }

//    Jug_Debug(GetName(OBJECT_SELF) + " intruder " + GetName(oIntruder));

   // Get distance closer than which henchman will swap to melee.
    float fThresholdDistance = PAUSANIAS_DISTANCE_THRESHOLD_MED;
    if (GetHenchAssociateState(HENCH_ASC_MELEE_DISTANCE_NEAR))
    {
        fThresholdDistance = PAUSANIAS_DISTANCE_THRESHOLD_NEAR;
    }
    else if (GetHenchAssociateState(HENCH_ASC_MELEE_DISTANCE_FAR))
    {
        fThresholdDistance = PAUSANIAS_DISTANCE_THRESHOLD_FAR;
    }
	
	if (!bForce && GetIsObjectValid(oIntruder) && 
		((GetDistanceToObject(oIntruder) > (fThresholdDistance + 0.5)) ||
		(GetCreatureNegEffects(oIntruder) & HENCH_EFFECT_DISABLED)))
	{	
		oIntruder = OBJECT_INVALID;
	}

    IntitializeHealingInfo(FALSE);
    HenchInitializeInvisibility(iPosEffectsOnSelf);
    InitializeTargetLists(oIntruder);

    int bAllowMeleeAttacks = !GetHenchAssociateState(HENCH_ASC_NO_MELEE_ATTACKS) || (GetInitWeaponStatus() & HENCH_AI_HAS_RANGED_WEAPON);
    if (bgAnyValidTarget && bAllowMeleeAttacks)
    {
        // multiplier because attacks are unlimited		
		if (!gbIAmStuck || (GetInitWeaponStatus() & HENCH_AI_HAS_RANGED_WEAPON))
		{
	        gfAttackTargetWeight = HenchMeleeAttack(oIntruder, iPosEffectsOnSelf,
	            (iNegEffectsOnSelf & HENCH_EFFECT_IMMOBILE) && !(GetInitWeaponStatus() & HENCH_AI_HAS_RANGED_WEAPON)) * 1.02;
		}
    }
//	gfAttackTargetWeight = 0.0;    // test code to not use melee attack
    gsAttackTargetInfo.spellID = -1;  // SPELL_ACID_FOG is zero
    gsBuffTargetInfo.spellID = -1;  // SPELL_ACID_FOG is zero

//	Jug_Debug(GetName(OBJECT_SELF) + " start check spells threshold " + FloatToString(gfAttackTargetWeight));

        // try to go invis if have sneak attack at beginning of combat (helps with sneaking)
    if (iUseMagic && !GetHenchAssociateState(HENCH_ASC_DISABLE_AUTO_HIDE) &&
        GetHasFeat(FEAT_SNEAK_ATTACK))
    {
        HenchTalentStealth(bgMeleeAttackers);
    }

    // Get challenge below which no defensive spells are cast
    // Signal to try to get some distance between self and the enemy.
    int bBackAway = GetHenchAssociateState(HENCH_ASC_ENABLE_BACK_AWAY);

    float fThresholdChallenge;
    float fChallenge;
	
    if (iAmMonster || !iHaveMaster)
    {
    	// Monsters and non-associates do not care about the challenge rating for now.
        fThresholdChallenge = -100.;
        fChallenge = 10000.0;
		InitializeMonsterAllyDamage();				
    }
    else
    {
        if (GetAssociateState(NW_ASC_SCALED_CASTING))
        {
            fThresholdChallenge = 1.0;
        }
        else if (GetAssociateState(NW_ASC_POWER_CASTING))
        {
            fThresholdChallenge = -1.0;
        }
        else if (GetAssociateState(NW_ASC_OVERKIll_CASTING))
        {
            fThresholdChallenge = -4.0;
        }
        else
        {
            if (nClass == CLASS_TYPE_WIZARD || nClass == CLASS_TYPE_SORCERER)
            {
                fThresholdChallenge = -3.;
            }
            else
            {
                fThresholdChallenge = PAUSANIAS_CHALLENGE_THRESHOLD;
            }
        }
        // Pausanias's Combined Challenge Rating (CCR)
        fChallenge = GetEnemyChallenge();
		InitializeAssociateAllyDamage();
    }

      // I am a familiar or animal companion, flee currently disabled
/*    if ((iAmFamiliar || iAmCompanion) && GetIsObjectValid(ogClosestSeenOrHeardEnemy))
    {
        // Get challenge above which familiar or animal companion will run away
        float fAssociateChallenge;
        int bFightToTheDeath;
        if (iAmFamiliar)
        {
            fAssociateChallenge = GetLocalFloat(oMaster, sHenchFamiliarChallenge);
            if (fAssociateChallenge == 0.0)
                fAssociateChallenge = PAUSANIAS_FAMILIAR_THRESHOLD;
            bFightToTheDeath = GetLocalInt(oMaster, sHenchFamiliarToDeath);
        }
        else
        {
            // default to 0.0 challenge if not set
            fAssociateChallenge = GetLocalFloat(oMaster, sHenchAniCompChallenge);
            bFightToTheDeath = GetLocalInt(oMaster, sHenchAniCompToDeath);
        }
        // Run away from tough enemies
        if (!bFightToTheDeath && (fChallenge >= fAssociateChallenge || (iHP < 40)))
        {
            if (iAmFamiliar)
            {
                switch (d10())
                {
                    case 1: SpeakString(sHenchFamiliarFlee1); return;
                    case 2: SpeakString(sHenchFamiliarFlee2); break;
                    case 3: SpeakString(sHenchFamiliarFlee3); break;
                    case 4: SpeakString(sHenchFamiliarFlee4); break;
                }
            }
            else
            {
                if (d3() == 1)
                {
                    SpeakString(sHenchAniCompFlee);
                }
            }
            ClearAllActions();
            HenchTalentHide(iPosEffectsOnSelf, bgMeleeAttackers);
            ActionMoveAwayFromObject(ogClosestSeenOrHeardEnemy,TRUE,40.);
            ActionMoveAwayFromObject(ogClosestSeenOrHeardEnemy,TRUE,40.);
            ActionMoveAwayFromObject(ogClosestSeenOrHeardEnemy,TRUE,40.);
            ActionMoveAwayFromObject(ogClosestSeenOrHeardEnemy,TRUE,40.);
            SetLocalInt(OBJECT_SELF, sHenchRunningAway,TRUE);
            return;
        }
    } */

    // Pausanias: Combat has finally begun, so we are no longer scouting
    DeleteLocalInt(OBJECT_SELF, sHenchScoutingFlag);
    DeleteLocalInt(OBJECT_SELF, sHenchRunningAway);

    int iHP = GetPercentageHPLoss(OBJECT_SELF);
    int iCheckHealing = iHP < 50;

    SetLocalInt(OBJECT_SELF, HENCH_HEAL_SELF_STATE, iCheckHealing ? HENCH_HEAL_SELF_CANT : HENCH_HEAL_SELF_WAIT);

    if (iUseMagic)
    {
        if (fChallenge < fThresholdChallenge)
        {
            gbSpellInfoCastMask = HENCH_SPELL_INFO_UNLIMITED_FLAG | HENCH_SPELL_INFO_HEAL_OR_CURE;
            gbDisableNonUnlimitedOrHealOrCure = TRUE;
        }
        else
        {
            gbSpellInfoCastMask = 0xffffffff;   // turn on every bit to allow every spell
			gbDisableHighLevelSpells = fChallenge < (fThresholdChallenge + 3.0);
        }
//      Jug_Debug(GetName(OBJECT_SELF) + (gbDisableNonUnlimitedOrHealOrCure ? " disable" : "enable") + " non unlimited, heal, or cure " + FloatToString(fChallenge));

        // do some adjustment of buff priority based on enemy threat
        float enemySum;
        float index;
        object oTest = GetLocalObject(OBJECT_SELF, sLineOfSight);
        while (GetIsObjectValid(oTest) && (index < 6.0))
        {
            index += 1.0;
            enemySum += GetLocalFloat(oTest, sThreatRating) / index;
            oTest = GetLocalObject(oTest, sLineOfSight);
        }
        float friendSum;
        index = 0.0;
        oTest = OBJECT_SELF;
        while (GetIsObjectValid(oTest) && (index < 6.0))
        {
            index += 1.0;
            friendSum += GetLocalFloat(oTest, sThreatRating) / index;
            oTest = GetLocalObject(oTest, henchAllyStr);
        }

        if (friendSum < 0.1)
        {
            gfBuffSelfWeight = 1.0;
        }
        else
        {
            gfBuffSelfWeight = enemySum / friendSum;
            if (gfBuffSelfWeight < 0.05)
            {
                gfBuffSelfWeight = 0.05;
            }
            else if (gfBuffSelfWeight > 1.5)
            {
                gfBuffSelfWeight = 1.5;
            }
        }

//      Jug_Debug(GetName(OBJECT_SELF) + " buff self weight " + FloatToString(gfBuffSelfWeight));

        // TODO adjust tactics to be more in line with HoTU overrides?
        // adjust attack and buff based on class type
		switch (nClass)
        {
            case CLASS_TYPE_WIZARD:
            case CLASS_TYPE_SORCERER:
            case CLASS_TYPE_FEY:
            case CLASS_TYPE_OUTSIDER:
            case CLASS_TYPE_WARLOCK:
                gfAttackTargetWeight *= 0.8;  // reduce chance of melee attack
                gfBuffOthersWeight = 0.3 * gfBuffSelfWeight;
                gfAttackWeight = 1.0;
                break;
			case CLASS_TYPE_BARD:
			case CLASS_TYPE_DRUID:
                gfBuffOthersWeight = 0.5 * gfBuffSelfWeight;
                gfAttackWeight = 0.9;
                break;
			case CLASS_TYPE_CLERIC:
			case CLASS_TYPE_MAGICAL_BEAST:
			case CLASS_TYPE_FAVORED_SOUL:
			case CLASS_TYPE_SPIRIT_SHAMAN:
                gfBuffOthersWeight = 0.8 * gfBuffSelfWeight;
                gfAttackWeight = 0.75;
                break;
			default:
                gfBuffOthersWeight = 0.4 * gfBuffSelfWeight;
                gfAttackWeight = 1.0;
                break;
           }

        // TODO randomize?
        if (iPosEffectsOnSelf & HENCH_EFFECT_INVISIBLE)
        {
            // while invisible do maximum amount of buffing & summoning
            gfAttackWeight *= 0.01; // try to buff up before attacking again
//          Jug_Debug(GetName(OBJECT_SELF) + " i am invisible " + IntToHexString(iPosEffectsOnSelf & HENCH_EFFECT_INVISIBLE));
            // TODO max out healing?
        }
        gfAttackTargetWeight *= gfAttackWeight;

        InitializeItemSpells(nClass, iNegEffectsOnSelf, iPosEffectsOnSelf);
  //    Jug_Debug(GetName(OBJECT_SELF) + " start cast " + GetName(oIntruder));
    }

        // if backaway or weak mage or sorcerer, try to back away when casting some spells
    if (!(iNegEffectsOnSelf & HENCH_EFFECT_IMMOBILE) &&
        (bBackAway || (iAmMonster && ((GetInitWeaponStatus() & HENCH_AI_HAS_RANGED_WEAPON)
        || (bAnySpellcastingClasses & HENCH_ARCANE_SPELLCASTING)) &&
        GetIsPlayableRacialType(OBJECT_SELF))) && CheckMoveAwayFromEnemies())
    {
//      Jug_Debug(GetName(OBJECT_SELF) + " move away enabled");
        bgEnableMoveAway = TRUE;
    }

    // NEXT priority: follow or return to master.
    if (iHaveMaster && !GetLocalInt(OBJECT_SELF, sHenchRunningAway))
    {
        DeleteLocalInt(OBJECT_SELF, sHenchScoutingFlag);
//		Jug_Debug(GetName(OBJECT_SELF) + " in follow test " + GetName(oMaster) + " distance " + FloatToString(GetDistanceToObject(oMaster)));
        if ((GetDistanceToObject(oMaster) > 15.0) && !GetObjectSeen(oMaster))
        {
//			Jug_Debug(GetName(OBJECT_SELF) + " return to master");
			ClearAllActions();
			HenchFollowLeader();
			return;
        }
    }

        // check for area effect spells damaging self
    if (CheckAOEForSelf(iNegEffectsOnSelf, iPosEffectsOnSelf)) {return;}

    /* TODO leave out for now
    if (GetCombatCondition(X0_COMBAT_FLAG_AMBUSHER)
        && SpecialTacticsAmbusher(ogClosestSeenOrHeard))
    {
        return;
    }*/

    // complain if you need healing
    if ((iAmHenchman || iAmFamiliar) && (GetLocalInt(OBJECT_SELF, HENCH_HEAL_SELF_STATE) == HENCH_HEAL_SELF_CANT))
    {
        if (iAmHenchman)
        {
            if (Random(100) > 80) VoiceHealMe();
        }
        else
        {
            SpeakString(sHenchHealMe);
        }
    }

    if (HenchCheckSpellToCast(combatRoundCount))
    {
        return;
    }

    if (!bAllowMeleeAttacks)
    {
        if (bgEnableMoveAway)
        {
    //      Jug_Debug(GetName(OBJECT_SELF) + " move away for spell " + IntToString(spInfo.spellID) + " " + Get2DAString("spells", "Label", spInfo.spellID) + " other "  + IntToString(spInfo.otherID));
            bgEnableMoveAway = FALSE;
            if (MoveAwayFromEnemies(ogClosestSeenOrHeardEnemy, 9.0))
            {
                HenchStartCombatRoundAfterAction(OBJECT_INVALID);
                return;
            }
        }
        HenchFollowLeader();
    }
    else if (bgAnyValidTarget)
    {
//		Jug_Debug("+++++++++ " + GetName(OBJECT_SELF) + " doing melee attack");
        //Attack if out of spells
        HenchTalentMeleeAttack(oIntruder, fThresholdDistance,
            iAmMonster ? 0 : (iAmHenchman ? 1 : 2), iPosEffectsOnSelf & HENCH_EFFECT_TYPE_POLYMORPH,
            (GetInitWeaponStatus() & HENCH_AI_HAS_RANGED_WEAPON) && (GetIsObjectValid(ogClosestSeenEnemy) || bgLineOfSightHeardEnemy) && gbIAmStuck);
    }
    else
    {
        // try and find enemy
        // henchmen using ranged weapons will not move to unheard and unseen enemies
        if (!bForce && !iAmMonster && (GetAssociateState(NW_ASC_USE_RANGED_WEAPON) || bBackAway))
        {
//			Jug_Debug("+++++++++ " + GetName(OBJECT_SELF) + " move to master " + GetName(oMaster));
			ActionForceFollowObject(oMaster);
            ClearEnemyLocation();
            if ((GetDistanceToObject(oMaster) >= 5.0) && !GetLocalInt(OBJECT_SELF, HENCH_AI_SCRIPT_POLL))
            {
                SetLocalInt(OBJECT_SELF, HENCH_AI_SCRIPT_POLL, TRUE);
                DelayCommand(2.0, HenchContinueAttack());
            }
			ActionDoCommand(HenchMoveToMaster(oMaster));
        }
        else if (GetLocalInt(OBJECT_SELF, sHenchLastHeardOrSeen))
        {
//			Jug_Debug(GetName(OBJECT_SELF) + " moving to last target");
            int bDoingMove = MoveToLastSeenOrHeard();
            if (bDoingMove && !GetLocalInt(OBJECT_SELF, HENCH_AI_SCRIPT_POLL))
            {
                SetLocalInt(OBJECT_SELF, HENCH_AI_SCRIPT_POLL, TRUE);
                DelayCommand(3.0, HenchContinueAttack());
            }
        }
    }
}