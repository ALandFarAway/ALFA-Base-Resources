/*

    Companion and Monster AI

    This file contains routines to handle locks, traps, auto pickup of items

*/

#include "hench_i0_act"
#include "hench_i0_melee"
#include "hench_i0_itemsp"
#include "hench_i0_assoc"


const string sDisarmTried = "tk_disarm_tried";
const string sLockTried = "tk_lock_tried";
const string sMasterShownFlag = "tk_master_shown_flag";
//const string sGiveToMaster = "tk_give_to_master";
const string sLastMoveDistance = "tk_last_move_distance";
const string sSomethingFishy = "tk_something_fishy";
const int DOING_MOVINGTO_ACTION = 2;
const string sGaveInventoryFullMessage = "tk_inventory_full";


// initialize item spell casting - currently disabled
void InitItemSpellCasting();

// finds the best thieves tools and returns bonus of them
int GetMaxThievesToolBonus();

// finds if closed door in way of target
int IsDoorInLineOfSight(object oTarget);

// bashes a target with spells, uses low level spells
int DoOpenWithAttackSpells(object oTarget, int bDoMoveAway = FALSE);

// bashes a target with weapons, selects best combat mode
void DoOpenWithWeapons(object oTarget);

// try to disarm the trap, selects best method spell or weapon
void DoDisarmTrap(object oTrap, int bForce = FALSE);

// try to disarm the trap, selects best method spell or weapon
void DoOpenLock(object oLocked);

// main loop to find traps, locks, and items to determine what to do
int DoSearchLoop();


int g_spellsInit;

void InitItemSpellCasting()
{
    if (!g_spellsInit)
    {
  // TODO disabled for now      InitializeItemSpells(HenchDetermineClassToUse(), GetHasEffect(EFFECT_TYPE_POLYMORPH), HENCH_INIT_LOCK_SPELLS);
        g_spellsInit = TRUE;
    }
}


int GetMaxThievesToolBonus()
{
    object oThievesTool;

    oThievesTool = GetItemPossessedBy(OBJECT_SELF, "X2_IT_PICKS002");
    if (GetIsObjectValid(oThievesTool))
    {
        return 12;
    }
    oThievesTool = GetItemPossessedBy(OBJECT_SELF, "NW_IT_PICKS004");
    if (GetIsObjectValid(oThievesTool))
    {
        return 10;
    }
    oThievesTool = GetItemPossessedBy(OBJECT_SELF, "X2_IT_PICKS001");
    if (GetIsObjectValid(oThievesTool))
    {
        return 8;
    }
    oThievesTool = GetItemPossessedBy(OBJECT_SELF, "NW_IT_PICKS003");
    if (GetIsObjectValid(oThievesTool))
    {
        return 6;
    }
    oThievesTool = GetItemPossessedBy(OBJECT_SELF, "NW_IT_PICKS002");
    if (GetIsObjectValid(oThievesTool))
    {
        return 3;
    }
    oThievesTool = GetItemPossessedBy(OBJECT_SELF, "NW_IT_PICKS001");
    if (GetIsObjectValid(oThievesTool))
    {
        return 1;
    }
    return 0;
}


int IsDoorInLineOfSight(object oTarget)
{
    float fMeDoorDist;

    object oDoor = GetFirstObjectInShape(SHAPE_SPHERE, 40.0, GetLocation(OBJECT_SELF),
                    TRUE, OBJECT_TYPE_DOOR);

    float fMeTrapDist = GetDistanceBetween(oTarget, OBJECT_SELF);

    while (GetIsObjectValid(oDoor))
    {
        fMeDoorDist = GetDistanceBetween(oDoor, OBJECT_SELF);
        if (fMeDoorDist < fMeTrapDist && !GetIsOpen(oDoor))
        {
            if (IsOnOppositeSideOfDoor(oDoor, oTarget, OBJECT_SELF))
            {
                return TRUE;
            }
        }
        oDoor = GetNextObjectInShape(SHAPE_SPHERE, 40.0, GetLocation(OBJECT_SELF),
                    TRUE, OBJECT_TYPE_DOOR);
    }
    return FALSE;
}


int DoOpenWithAttackSpells(object oTarget, int bDoMoveAway = FALSE)
{
    int nSpell;
    // TODO add support for eldritch blast?
    if (GetHasSpell(SPELL_MAGIC_MISSILE))
    {
        nSpell = SPELL_MAGIC_MISSILE;
    }
    else if (GetHasSpell(SPELL_ACID_SPLASH))
    {
        nSpell = SPELL_ACID_SPLASH;
    }
    else if (GetHasSpell(SPELL_ELECTRIC_JOLT))
    {
        nSpell = SPELL_ELECTRIC_JOLT;
    }
    else if (GetHasSpell(SPELL_RAY_OF_FROST))
    {
        nSpell = SPELL_RAY_OF_FROST;
    }
    else
    {
        return FALSE;
    }
    if (bDoMoveAway && GetDistanceToObject(oTarget) < 5.0)
    {
         ActionMoveAwayFromObject(oTarget, FALSE, 5.0);
    }
    ActionCastSpellAtObject(nSpell, oTarget);
    return TRUE;
}


void DoOpenWithWeapons(object oTarget)
{
    VoiceCanDo();
    ActionEquipMostDamagingMelee(oTarget);
    ActionWait(1.0);
    HenchAttackObject(oTarget);
    SetLocalObject(OBJECT_SELF, "NW_GENERIC_DOOR_TO_BASH", oTarget);
    ActionDoCommand(VoiceTaskComplete());
}


void DoDisarmTrap(object oTrap, int bForce = FALSE)
{
    ClearAllActions();

        // TODO spell change makes this not disable traps
/*    if (GetTrapDisarmable(oTrap) && GetLocalInt(oTrap, "NW_L_IATTEMPTEDTODISARMNOWORK") == 0)
    {
        InitItemSpellCasting();
        if (GetHasFixedSpell(SPELL_FIND_TRAPS))
        {
            CastFixedSpellOnObject(SPELL_FIND_TRAPS, OBJECT_SELF, 3);
            SetLocalInt(oTrap, "NW_L_IATTEMPTEDTODISARMNOWORK", 10);
            return;
        }
    } */
    int bIsATrigger = GetObjectType(oTrap) == OBJECT_TYPE_TRIGGER;
    int nClass = HenchDetermineClassToUse();
    int iAmMage = (nClass == CLASS_TYPE_SORCERER || nClass == CLASS_TYPE_WIZARD);
    if (iAmMage && !bIsATrigger && DoOpenWithAttackSpells(oTrap))
    {
        return;
    }
    if (!bIsATrigger)
    {
        HenchStartRangedBashDoor(oTrap);
        return;
    }
    if (!bForce)
    {
        return;
    }

    // Throw ourselves on it nobly! :-)
    ActionMoveToLocation(GetLocation(oTrap));
    SetFacingPoint(GetPositionFromLocation(GetLocation(oTrap)));
    ActionRandomWalk();
}


void DoOpenLock(object oLocked)
{
    ClearAllActions();

    int bIsTrapped = GetTrapDetectedBy(oLocked, OBJECT_SELF);
    if (bIsTrapped)
    {
        DoDisarmTrap(oLocked);
        return;
    }
    if (GetPlotFlag(oLocked))
    {
        VoiceCannotDo();
        return;
    }
    if ((GetObjectType(oLocked) == OBJECT_TYPE_DOOR) ||
        (GetObjectType(oLocked) == OBJECT_TYPE_PLACEABLE))
    {
        InitItemSpellCasting();
        if (GetHasSpell(SPELL_KNOCK))
        {
            VoiceCanDo();
            ActionCastSpellAtObject(SPELL_KNOCK, oLocked);
            ActionWait(1.0);
            return;
        }
    }
    int nClass = HenchDetermineClassToUse();
    int iAmMage = (nClass == CLASS_TYPE_SORCERER || nClass == CLASS_TYPE_WIZARD);
    if (iAmMage && DoOpenWithAttackSpells(oLocked))
    {
        return;
    }
    // TK reduced strength requirement for Xanos bashing
    int bBashPossible = GetIsDoorActionPossible(oLocked, DOOR_ACTION_BASH)
        || GetIsPlaceableObjectActionPossible(oLocked, PLACEABLE_ACTION_BASH);
    if (GetAbilityScore(OBJECT_SELF, ABILITY_STRENGTH) >= 12 && bBashPossible)
    {
        DoOpenWithWeapons(oLocked);
        return;
    }
        // try again with spells (i.e. bard with no strength using items)
    if (DoOpenWithAttackSpells(oLocked))
    {
        return;
    }
    if (bBashPossible)
    {
        DoOpenWithWeapons(oLocked);
        return;
    }
    VoiceCannotDo();
}


void GivePickupMessage(object oItem, object oRealMaster)
{
    int itemType = GetBaseItemType(oItem);
    if (itemType == BASE_ITEM_GOLD)
    {
        // gold does not need message
        return;
    }
    string displayMsg = GetName(OBJECT_SELF) + sHenchAcquiredItem;
    if (GetIdentified(oItem))
    {
        displayMsg += GetName(oItem);
    }
    else
    {
        int itemNameId = StringToInt(Get2DAString("baseitems", "Name", itemType));
        displayMsg += GetStringByStrRef(itemNameId);
    }
    ActionDoCommand(SendMessageToPC(oRealMaster, displayMsg));
//  Jug_Debug(GetName(OBJECT_SELF) + " get item " + GetName(oItem) + " base item type " + IntToString(GetBaseItemType(oItem)) + " gold self " + IntToString(GetGold(oItem)) + " gold cont " +   IntToString(GetGold(oNearestDoorOrPlaceable)));
}


int IsInventoryFull()
{
	int nCount;
	object oItem = GetFirstItemInInventory();
	while (GetIsObjectValid(oItem))
	{
		nCount++;
		oItem = GetNextItemInInventory();
	}
//	Jug_Debug(GetName(OBJECT_SELF) + " inventory count " + IntToString(nCount));
	return nCount >= 128;
}


int CheckInventoryFull()
{
	int result = IsInventoryFull();
	if (result)
	{
		if (!GetLocalInt(OBJECT_SELF, sGaveInventoryFullMessage))
		{
			SpeakString(sHenchInventoryFull);		
			SetLocalInt(OBJECT_SELF, sGaveInventoryFullMessage, TRUE);
		}
	}
	else
	{
		DeleteLocalInt(OBJECT_SELF, sGaveInventoryFullMessage);
	}
	return result;
}


void ActionCheckInventoryFull()
{
	if (CheckInventoryFull())
	{
		// prevent more pickups
		ClearAllActions();
	}
}


int DoSearchLoop()
{
    if (!GetIAmNotDoingAnything())
    {
        return FALSE;
    }

    int nDisarmTrapSkill = GetSkillRank(SKILL_DISABLE_TRAP);
    int nCanDisarm = GetHasSkill(SKILL_DISABLE_TRAP);
    int nAutoDisarm = nCanDisarm && GetAssociateState(NW_ASC_DISARM_TRAPS);
    int nCanRecoverTraps = GetHenchAssociateState(HENCH_ASC_RECOVER_TRAPS);
    int nOpenLockSkill = GetSkillRank(SKILL_OPEN_LOCK);
    int nCanOpenLock = GetHasSkill(SKILL_OPEN_LOCK) && GetHenchAssociateState(HENCH_ASC_AUTO_OPEN_LOCKS);
    int nMaxThievesToolBonus = GetMaxThievesToolBonus();
    int nCanPickUp = GetHenchAssociateState(HENCH_ASC_AUTO_PICKUP);
        // only allow associates (with inventory access) to pick up things
    if (nCanPickUp && (GetAssociateType(OBJECT_SELF) != ASSOCIATE_TYPE_NONE))
    {
        nCanPickUp = FALSE;
        SetHenchAssociateState(HENCH_ASC_AUTO_PICKUP, FALSE, OBJECT_SELF);
    }
	if (nCanPickUp)
	{
		if (CheckInventoryFull())
		{
			nCanPickUp = FALSE;		
		}
	}

 //   int nCanOpenChests = GetLocalInt(OBJECT_SELF, sHenchAutoOpenChest);
    object oMasterFailLock = GetLocalObject(OBJECT_SELF, sLockMasterFailed);
    if (GetLocalInt(oMasterFailLock, "X2_L_BASH_FALSE"))
    {
        oMasterFailLock = OBJECT_INVALID;
    }
    int nMasterFailedLock = GetIsObjectValid(oMasterFailLock);
    int bForceTrap = GetLocalInt(OBJECT_SELF, sForceTrap);

    // first check if we have completed something
    object oTrap = GetLocalObject(OBJECT_SELF, "NW_ASSOCIATES_LAST_TRAP");
    if (GetIsObjectValid(oTrap))
    {
        DeleteLocalObject(OBJECT_SELF, "NW_ASSOCIATES_LAST_TRAP");

        if (GetIsTrapped(oTrap))
        {
            int nTrapDC = GetTrapDisarmDC(oTrap);
            int nCanDisarmThisTrap = (nDisarmTrapSkill + 20) >= nTrapDC;

            if (nCanDisarmThisTrap)
            {
                DeleteLocalInt(oTrap, sDisarmTried);
            }
            else
            {
                VoiceCannotDo();
            }
        }
        else
        {
            VoiceTaskComplete();
            DeleteLocalInt(oTrap, sDisarmTried);
        }
    }

    object oLock = GetLocalObject(OBJECT_SELF, "NW_ASSOCIATES_LAST_LOCK");
    if (GetIsObjectValid(oLock))
    {
        DeleteLocalObject(OBJECT_SELF, "NW_ASSOCIATES_LAST_LOCK");
        if (GetLocked(oLock))
        {
            int nLockDC = GetLockUnlockDC(oLock);
            int nCanOpenThisLock = nOpenLockSkill + nMaxThievesToolBonus + 20 >= nLockDC;
            if (nCanOpenThisLock)
            {
                DeleteLocalInt(oLock, sLockTried);
            }
            VoiceCuss();
        }
        else
        {
            VoiceTaskComplete();
            DeleteLocalInt(oLock, sLockTried);
        }
    }
    // add check for follow mode
    if (!nMasterFailedLock && GetLocalInt(OBJECT_SELF, sHenchDontAttackFlag))
    {
        return FALSE;
    }

    object oRealMaster = GetCurrentMaster();
    if (!GetIsObjectValid(oRealMaster))
    {
        return FALSE;
    }
        // if too far away, first priority is to get back to master
    if (GetDistanceToObject(oRealMaster) > 15.5)
    {
        ClearForceOptions();
        ClearAllActions();
        ActionForceMoveToObject(oRealMaster, TRUE, 5.0, 10.0);
        return FALSE;
    }

    int iActionToDo = 0;

    object oNearestItemTrap = OBJECT_INVALID;
    float fDistanceToItemTrap = 1000.0;
    object oNearestDoorOrPlaceable = oMasterFailLock;
    float fDistanceToDoorOrPlaceable;
    if (nMasterFailedLock)
    {
        fDistanceToDoorOrPlaceable = GetDistanceToObject(oMasterFailLock);
        if (bForceTrap)
        {
            iActionToDo = ACTION_DISABLETRAP;
        }
        else
        {
            iActionToDo = ACTION_OPENLOCK;
        }
    }
    else
    {
        fDistanceToDoorOrPlaceable = 1000.0;
    }
    location oMasterLoc = GetLocation(oRealMaster);
    object oCurrent = GetFirstObjectInShape(SHAPE_SPHERE, 15.0, oMasterLoc, FALSE, OBJECT_TYPE_DOOR | OBJECT_TYPE_ITEM | OBJECT_TYPE_PLACEABLE | OBJECT_TYPE_TRIGGER);
    //Cycle through the targets within the spell shape until an invalid object is captured.
    while (!nMasterFailedLock && GetIsObjectValid(oCurrent))
    {
        int nObjectType = GetObjectType(oCurrent);
        float fDistance = GetDistanceToObject(oCurrent);

//		Jug_Debug(GetName(OBJECT_SELF) + " found " + GetName(oCurrent) + " type " + IntToString(nObjectType) + " distance " + FloatToString(fDistance));

        if (GetTrapDetectedBy(oCurrent, oRealMaster) || GetTrapDetectedBy(oCurrent, OBJECT_SELF) || GetTrapFlagged(oCurrent))
        {
            SetTrapDetectedBy(oCurrent, oRealMaster);
            SetTrapDetectedBy(oCurrent, OBJECT_SELF);
            int nTrapDC = GetTrapDisarmDC(oCurrent);
            int nTrapTried = GetLocalInt(oCurrent, sDisarmTried);
            int nCanDisarmThisTrap = nAutoDisarm && (nDisarmTrapSkill + 20 >= nTrapDC);
                // we can't disarm this : play message once to indicate failure
            if (!nAutoDisarm)
            {
                if (nObjectType == OBJECT_TYPE_TRIGGER)
                {
                    if (!nTrapTried)
                    {
                        SetLocalInt(oCurrent, sDisarmTried, TRUE);
                        SpeakString(sHenchWaitTrapsCleared);
                    }
                    // exit - stay put - trap on ground that can't be removed
                    return FALSE;
                }
            }
            if (nAutoDisarm)
            {
                if (nObjectType == OBJECT_TYPE_TRIGGER)
                {				
//					Jug_Debug(GetName(OBJECT_SELF) + " found " + GetName(oCurrent) + " type " + IntToString(nObjectType) + " distance " + FloatToString(fDistance) + " trap base type " + IntToString(GetTrapBaseType(oCurrent)));
                    if (fDistance < fDistanceToItemTrap)
                    {
                        oNearestItemTrap = oCurrent;
                        fDistanceToItemTrap = fDistance;
                    }
                }
                else if (nCanDisarmThisTrap || nTrapTried == 0)
                {
                    if (fDistance < fDistanceToDoorOrPlaceable)
                    {
                        oNearestDoorOrPlaceable = oCurrent;
                        fDistanceToDoorOrPlaceable = fDistance;
                        iActionToDo = ACTION_DISABLETRAP;
                    }
                }
            }
        }
        else if (nCanOpenLock && nObjectType == OBJECT_TYPE_PLACEABLE && GetLocked(oCurrent) && !GetLockKeyRequired(oCurrent) && !GetLocalInt(oCurrent, "X2_L_BASH_FALSE"))
        {
            int nLockDC = GetLockUnlockDC(oCurrent);
            int nLockTried = GetLocalInt(oCurrent, sLockTried);
            int nCanOpenThisLock = nOpenLockSkill + nMaxThievesToolBonus + 20 >= nLockDC;

            if (nCanOpenThisLock || nLockTried == 0)
            {
                if (fDistance < fDistanceToDoorOrPlaceable)
                {
                    oNearestDoorOrPlaceable = oCurrent;
                    fDistanceToDoorOrPlaceable = fDistance;
                    iActionToDo = ACTION_OPENLOCK;
                }
            }
        }
        else if (nCanPickUp && nObjectType == OBJECT_TYPE_ITEM && !GetLocalInt(oCurrent, sItemDropped))
        {
            if (fDistance < fDistanceToDoorOrPlaceable)
            {
                oNearestDoorOrPlaceable = oCurrent;
                fDistanceToDoorOrPlaceable = fDistance;
                iActionToDo = ACTION_PICKUPITEM;
            }
        }
        else if (nObjectType == OBJECT_TYPE_PLACEABLE && GetHasInventory(oCurrent))
        {
//          Jug_Debug(GetName(OBJECT_SELF) + " testing placeable" + GetName(oCurrent) + " tag " + GetTag(oCurrent) + " already searched " + IntToString(GetLocalInt(oCurrent, sMasterShownFlag)));
                // treat body bags as items on the ground
            if (((GetTag(oCurrent) == "Body Bag") || (GetTag(oCurrent) == "BodyBag") ||
                (GetStringLength(GetTag(oCurrent)) == 0)) &&
                !GetLocalInt(oCurrent, sMasterShownFlag))
            {
                if (nCanPickUp && !GetLocked(oCurrent))
                {
//                  Jug_Debug(GetName(OBJECT_SELF) + " checking placeable" + GetName(oCurrent));
                    if (fDistance < fDistanceToDoorOrPlaceable)
                    {
//                      Jug_Debug(GetName(OBJECT_SELF) + " using placeable" + GetName(oCurrent));
                        oNearestDoorOrPlaceable = oCurrent;
                        fDistanceToDoorOrPlaceable = fDistance;
                        iActionToDo = ACTION_USEOBJECT;
                    }
                }
            }
 /*           else if (nCanOpenChests && !GetLocked(oCurrent))
            {
                if (GetLocalInt(oCurrent, "NW_DO_ONCE"))
                {
                    // delete master shown flag if it is there
                    DeleteLocalInt(oCurrent, sMasterShownFlag);

                 // TK should this be done or just leave opened things alone?
                 // maybe just use speak string (i.e. "something has been left behind" ?
                /*
                if (GetIsValidObject(GetFirstItemInIventory())
                    {
                        if (fDistance < fDistanceToDoorOrPlaceable)
                        {
                            oNearestDoorOrPlaceable = oCurrent;
                            fDistanceToDoorOrPlaceable = fDistance;
                            iActionToDo = ACTION_USEOBJECT;
                        }
                    }
                    *
                }
                else if (!GetLocalInt(oCurrent, sMasterShownFlag))
                {
                    if (fDistance < fDistanceToDoorOrPlaceable)
                    {
                        oNearestDoorOrPlaceable = oCurrent;
                        fDistanceToDoorOrPlaceable = fDistance;
                        iActionToDo = ACTION_USEOBJECT;
                    }
                }
            } */
        }
        //Select the next object
        oCurrent = GetNextObjectInShape(SHAPE_SPHERE, 15.0, oMasterLoc, FALSE, OBJECT_TYPE_DOOR | OBJECT_TYPE_ITEM | OBJECT_TYPE_PLACEABLE | OBJECT_TYPE_TRIGGER);
    }

    float lastDistance = GetLocalFloat(OBJECT_SELF, sLastMoveDistance);

    if (GetIsObjectValid(oNearestItemTrap))
    {
//      Jug_Debug(GetName(OBJECT_SELF) + " doing something oNearestItemTrap " + GetName(oNearestItemTrap));
        if (!IsDoorInLineOfSight(oNearestItemTrap))
        {
            int nTrapDC = GetTrapDisarmDC(oNearestItemTrap);
            int nCanDisarmThisTrap = (nDisarmTrapSkill + 20 >= nTrapDC);
            int nTrapTried = GetLocalInt(oNearestItemTrap, sDisarmTried);

            if (!nCanDisarmThisTrap && nTrapTried)
            {
                    // don't do anything, can't disarm nearest trap
                return FALSE;
            }
            if (fDistanceToItemTrap > 2.0 && fDistanceToItemTrap != lastDistance)
            {
 //     Jug_Debug(GetName(OBJECT_SELF) + " doing something oNearestItemTrap " + GetName(oNearestItemTrap));

                SetLocalFloat(OBJECT_SELF, sLastMoveDistance, fDistanceToItemTrap);

                int bResult = ActionUseSkill(SKILL_DISABLE_TRAP, oNearestItemTrap);
                ClearAllActions();
//          Jug_Debug(GetName(OBJECT_SELF) + " dis trap result 2 " + IntToString(bResult));
                if (bResult)
                {
                    ActionMoveToObject(oNearestItemTrap, FALSE);
                }
                else
                {
                // trouble moving to trap, try move half way
                    vector pos = GetPosition(OBJECT_SELF) + GetPosition(oNearestItemTrap);
                    pos.x /= 2;
                    pos.y /= 2;
                    pos.z /= 2;
                    location newLoc = CalcSafeLocation(OBJECT_SELF, Location(GetArea(OBJECT_SELF), pos, GetFacing(OBJECT_SELF)), 5.0, FALSE, FALSE);
                    if (GetDistanceBetweenLocations(GetLocation(OBJECT_SELF), newLoc) > 0.5)
                    {
                        ActionMoveToLocation(newLoc, FALSE);
                    }
                }

                return DOING_MOVINGTO_ACTION;
            }
            DeleteLocalFloat(OBJECT_SELF, sLastMoveDistance);

            ClearAllActions();
			
            // recover trap - account for critical failure roll (5 below) assume roll of five (5 + 4 - 10)
			int iRecoverTreshold = GetHenchAssociateState(HENCH_ASC_NON_SAFE_RECOVER_TRAPS) ? 10 : -1;

            ActionUseSkill(SKILL_DISABLE_TRAP, oNearestItemTrap, GetTrapRecoverable(oNearestItemTrap) &&
                nCanRecoverTraps && (nDisarmTrapSkill + iRecoverTreshold >= nTrapDC) ? SUBSKILL_RECOVERTRAP : 0);

//          Jug_Debug(GetName(OBJECT_SELF) + " dis trap result " + IntToString(bResult));
            ActionDoCommand(SetLocalInt(oNearestItemTrap, sDisarmTried, TRUE));
            ActionDoCommand(SetLocalObject(OBJECT_SELF, "NW_ASSOCIATES_LAST_TRAP", oNearestItemTrap));
            return TRUE;
        }
        else if (!GetIsObjectValid(oNearestDoorOrPlaceable))
        {
            if (!GetLocalInt(oNearestItemTrap, sSomethingFishy))
            {
                SpeakString(sHenchSomethingFishy);
                SetLocalInt(oNearestItemTrap, sSomethingFishy, TRUE);
            }
        }
    }
    if (GetIsObjectValid(oNearestDoorOrPlaceable))
    {
//      Jug_Debug(GetName(OBJECT_SELF) + " doing something oNearestDoorOrPlaceable " + GetName(oNearestDoorOrPlaceable) + " action " + IntToString(iActionToDo));
        if (nMasterFailedLock || !IsDoorInLineOfSight(oNearestDoorOrPlaceable))
        {
            if (iActionToDo == ACTION_DISABLETRAP)
            {
                int nTrapDC = GetTrapDisarmDC(oNearestDoorOrPlaceable);
                int nTrapTried = GetLocalInt(oNearestDoorOrPlaceable, sDisarmTried);
                int nCanDisarmThisTrap = nCanDisarm && (nDisarmTrapSkill + 20 >= nTrapDC);

                    // only attempt to move toward trap if disarm is to be tried
                if (nCanDisarm && (nCanDisarmThisTrap || !nTrapTried))
                {
                    if (fDistanceToDoorOrPlaceable > 2.0 && fDistanceToDoorOrPlaceable != lastDistance)
                    {
                        SetLocalFloat(OBJECT_SELF, sLastMoveDistance, fDistanceToDoorOrPlaceable);
                        ClearAllActions();
                        ActionMoveToObject(oNearestDoorOrPlaceable, FALSE);
                        return DOING_MOVINGTO_ACTION;
                    }
                }
            }
            else
            {
                if (fDistanceToDoorOrPlaceable > 2.0 && fDistanceToDoorOrPlaceable != lastDistance)
                {
                    SetLocalFloat(OBJECT_SELF, sLastMoveDistance, fDistanceToDoorOrPlaceable);
                    ClearAllActions();
                    ActionMoveToObject(oNearestDoorOrPlaceable, FALSE);
                    return DOING_MOVINGTO_ACTION;
                }
            }

            DeleteLocalFloat(OBJECT_SELF, sLastMoveDistance);
            // give a last chance to check out the placeable for a trap (do a full search)
            if (GetIsTrapped(oNearestDoorOrPlaceable) && GetTrapDetectable(oNearestDoorOrPlaceable) &&
                !GetTrapDetectedBy(oNearestDoorOrPlaceable, oRealMaster))
            {
                int nDC = GetTrapDetectDC(oNearestDoorOrPlaceable);
                if (d20() + GetSkillRank(SKILL_SEARCH) >= nDC)
                {
                    SetTrapDetectedBy(oNearestDoorOrPlaceable, oRealMaster);
                    if (!nCanDisarm)
                    {
                        // start over, if asked to do lock stop doing anything
                        if (nMasterFailedLock)
                        {
                            ClearForceOptions();
                            return FALSE;
                        }
                        return TRUE;
                    }
                    iActionToDo = ACTION_DISABLETRAP;
                }
            }
            if (iActionToDo == ACTION_DISABLETRAP)
            {
                ClearForceOptions();
                int nTrapDC = GetTrapDisarmDC(oNearestDoorOrPlaceable);
                int nTrapTried = GetLocalInt(oNearestDoorOrPlaceable, sDisarmTried);
                int nCanDisarmThisTrap = nCanDisarm && (nDisarmTrapSkill + 20 >= nTrapDC);
                    // only attempt to disable trap if disarm is to be tried
                if (nCanDisarm && (nCanDisarmThisTrap || !nTrapTried))
                {
                    ClearAllActions();
                    int nTrapDC = GetTrapDisarmDC(oNearestDoorOrPlaceable);
                    // recover trap - account for critical failure roll (5 below) assume roll of five (5 + 4 - 10)
					int iRecoverTreshold = GetHenchAssociateState(HENCH_ASC_NON_SAFE_RECOVER_TRAPS) ? 10 : -1;
                    ActionUseSkill(SKILL_DISABLE_TRAP, oNearestDoorOrPlaceable, GetTrapRecoverable(oNearestDoorOrPlaceable) &&
                        nCanRecoverTraps && (nDisarmTrapSkill + iRecoverTreshold >= nTrapDC) ? SUBSKILL_RECOVERTRAP : 0);
                    ActionDoCommand(SetLocalInt(oNearestDoorOrPlaceable, sDisarmTried, TRUE));
                    ActionDoCommand(SetLocalObject(OBJECT_SELF, "NW_ASSOCIATES_LAST_TRAP", oNearestDoorOrPlaceable));
                    return TRUE;
                }
                // attempt various means to disarm trap
                else if (nMasterFailedLock)
                {
                    DoDisarmTrap(oNearestDoorOrPlaceable, TRUE);
                    return FALSE;
                }
            }
            if (iActionToDo == ACTION_OPENLOCK)
            {
                ClearAllActions();
                ClearForceOptions();

                int nLockDC = GetLockUnlockDC(oNearestDoorOrPlaceable);
                int nLockTried = GetLocalInt(oNearestDoorOrPlaceable, sLockTried);
                int nCanOpenThisLock = nOpenLockSkill + nMaxThievesToolBonus + 20 >= nLockDC;

                if (GetHasSkill(SKILL_OPEN_LOCK) && !GetLockKeyRequired(oNearestDoorOrPlaceable) &&
                    (nCanOpenThisLock || !nLockTried))
                {
               //     SetLocalInt(oNearestDoorOrPlaceable, sLockTried, TRUE);

                    object oSelThievesTool;

                    int bonusNeeded = GetLockUnlockDC(oNearestDoorOrPlaceable) - GetSkillRank(SKILL_OPEN_LOCK) - 20;

                    object oThievesTool1 = GetItemPossessedBy(OBJECT_SELF, "NW_IT_PICKS001");
                    object oThievesTool3 = GetItemPossessedBy(OBJECT_SELF, "NW_IT_PICKS002");
                    object oThievesTool6 = GetItemPossessedBy(OBJECT_SELF, "NW_IT_PICKS003");
                    object oThievesTool8 = GetItemPossessedBy(OBJECT_SELF, "X2_IT_PICKS001");
                    object oThievesTool10 = GetItemPossessedBy(OBJECT_SELF, "NW_IT_PICKS004");
                    object oThievesTool12 = GetItemPossessedBy(OBJECT_SELF, "X2_IT_PICKS002");

                    if (bonusNeeded < 1)
                    {
                        oSelThievesTool = OBJECT_INVALID;
                    }
                    else if (bonusNeeded < 2 && GetIsObjectValid(oThievesTool1))
                    {
                        oSelThievesTool = oThievesTool1;
                    }
                    else if (bonusNeeded < 4 && GetIsObjectValid(oThievesTool3))
                    {
                        oSelThievesTool = oThievesTool3;
                    }
                    else if (bonusNeeded < 7 && GetIsObjectValid(oThievesTool6))
                    {
                        oSelThievesTool = oThievesTool6;
                    }
                    else if (bonusNeeded < 9 && GetIsObjectValid(oThievesTool8))
                    {
                        oSelThievesTool = oThievesTool8;
                    }
                    else if (bonusNeeded < 11 && GetIsObjectValid(oThievesTool10))
                    {
                        oSelThievesTool = oThievesTool10;
                    }
                    else
                    {
                        oSelThievesTool = oThievesTool12;
                    }
                    VoicePicklock();
                    ActionUseSkill(SKILL_OPEN_LOCK, oNearestDoorOrPlaceable, 0, oSelThievesTool);
                    ActionDoCommand(SetLocalInt(oNearestDoorOrPlaceable, sLockTried, TRUE));
                    ActionDoCommand(SetLocalObject(OBJECT_SELF, "NW_ASSOCIATES_LAST_LOCK", oNearestDoorOrPlaceable));
                    return TRUE;
                }
                else if (nMasterFailedLock)
                {
                    DoOpenLock(oNearestDoorOrPlaceable);
                    return FALSE;
                }
            }
            if (iActionToDo == ACTION_PICKUPITEM)
            {
                ClearAllActions();
                ActionPickUpItem(oNearestDoorOrPlaceable);
                GivePickupMessage(oNearestDoorOrPlaceable, oRealMaster);
//                SetLocalInt(oNearestDoorOrPlaceable, sGiveToMaster, 1);
//                SetLocalInt(OBJECT_SELF, sGiveToMaster, 1);
                return TRUE;
            }
            if (iActionToDo == ACTION_USEOBJECT)
            {
                ClearAllActions();
//              Jug_Debug(GetName(OBJECT_SELF) + " doing using placeable");
                if ((GetTag(oNearestDoorOrPlaceable) == "Body Bag") || (GetTag(oNearestDoorOrPlaceable) == "BodyBag")
                    || (GetStringLength(GetTag(oNearestDoorOrPlaceable)) == 0))
                {
//                  Jug_Debug(GetName(OBJECT_SELF) + " doing using placeable check inv");
                    int nPlotItemFound = FALSE;
                    int nFoundAnItem = FALSE;

                    object oItem = GetFirstItemInInventory(oNearestDoorOrPlaceable);
                    while (GetIsObjectValid(oItem))
                    {
//                      Jug_Debug(GetName(OBJECT_SELF) + " checking inventory " + GetName(oItem));
                        if (GetPlotFlag(oItem))
                        {
                            if (!nPlotItemFound)
                            {
                                SpeakString(sHenchSomethingImportant);
                            }
                            nPlotItemFound = TRUE;
                        }
                        else
                        {
                            ActionTakeItem(oItem, oNearestDoorOrPlaceable);
                            GivePickupMessage(oItem, oRealMaster);
							ActionDoCommand(ActionCheckInventoryFull());
//                            SetLocalInt(oItem, sGiveToMaster, 1);
                            nFoundAnItem = TRUE;
                        }
                        oItem = GetNextItemInInventory(oNearestDoorOrPlaceable);
                    }
                    ActionDoCommand(SetLocalInt(oNearestDoorOrPlaceable, sMasterShownFlag, 1));
//                    if (nFoundAnItem)
//                    {
//                        SetLocalInt(OBJECT_SELF, sGiveToMaster, 1);
//                    }
                    return TRUE;
                }
                    // give indication of opening (doesn't actually open, just shows animation)
                AssignCommand(oNearestDoorOrPlaceable, PlayAnimation(ANIMATION_PLACEABLE_OPEN));
                if (GetPlotFlag(oNearestDoorOrPlaceable))
                {
                    SpeakString(sHenchSomethingImportant);
                    SetLocalInt(oNearestDoorOrPlaceable, sMasterShownFlag, 1);
                    return TRUE;
                }
                else
                {
                    SpeakString(sHenchFoundSomething);
                    AssignCommand(oRealMaster, ActionDoCommand(DoPlaceableObjectAction(oNearestDoorOrPlaceable, PLACEABLE_ACTION_USE)));
                    SetLocalInt(oNearestDoorOrPlaceable, sMasterShownFlag, 1);
                    return TRUE;
                }
            }
        }
    }

    ClearForceOptions();

    // give things to master if not doing anything - currently disabled, may reenable
    // if associates can ever have thieving skills
/*
    disable, leave in inventory
    if (GetLocalInt(OBJECT_SELF, sGiveToMaster))
    {
        if (GetDistanceToObject(oRealMaster) > 2.0)
        {
            ClearAllActions();
                // always run back with items
            ActionForceMoveToObject(oRealMaster, TRUE, 1.0, 10.0);
            return TRUE;
        }

        int nAnyItemsFound = FALSE;
        int iMaxGPIdentify = HenchGetMaxGPToIdentify();
        object oItem = GetFirstItemInInventory();
        while (GetIsObjectValid(oItem))
        {
            if (GetLocalInt(oItem, sGiveToMaster))
            {
                if (!nAnyItemsFound)
                {
                    ClearAllActions();
                    SpeakString(sHenchGiveThings);
                    nAnyItemsFound = TRUE;
                }
                HenchIdentifyItem(oItem, iMaxGPIdentify);
                ActionGiveItem(oItem, oRealMaster);
                DeleteLocalInt(oItem, sGiveToMaster);
            }
            oItem = GetNextItemInInventory();
        }
        if (GetGold())
        {
            if (!nAnyItemsFound)
            {
                ClearAllActions();
                SpeakString(sHenchGiveGold);
                nAnyItemsFound = TRUE;
            }
            GiveGoldToCreature(oRealMaster, GetGold());
            TakeGoldFromCreature(GetGold(), OBJECT_SELF, TRUE);
        }
        if (nAnyItemsFound)
        {
            SetCommandable(FALSE, OBJECT_SELF);
            DelayCommand(1., SetCommandable(TRUE, OBJECT_SELF));
            return TRUE;
        }
        else
        {
            DeleteLocalInt(OBJECT_SELF, sGiveToMaster);
        }
    }
*/
    return FALSE;
}


void main()
{
    // prevent running script if PC controlled
    if (GetIsPC(OBJECT_SELF))
    {
        return;
    }

    int nCurAction = GetLocalInt(OBJECT_SELF, "tk_doing_action");
    if (nCurAction)
    {
        ActionDoCommand(ActionWait(0.5));
        ActionDoCommand(ExecuteScript("hench_o0_act", OBJECT_SELF));
        SetLocalInt(OBJECT_SELF, "tk_doing_action", FALSE);
        return;
    }

    HenchGetDefSettings();

    int result = DoSearchLoop();

        // only if we did something
    if (!result)
    {
        SetLocalInt(OBJECT_SELF, "tk_doing_action", FALSE);
    }
    else
    {
        if (result != DOING_MOVINGTO_ACTION)
        {
            SetLocalInt(OBJECT_SELF, "tk_doing_action", TRUE);
        }
        else
        {
            SetLocalInt(OBJECT_SELF, "tk_doing_action", FALSE);
        }
        ActionDoCommand(ActionWait(0.5));
        ActionDoCommand(ExecuteScript("hench_o0_act", OBJECT_SELF));
    }
    SetLocalInt(OBJECT_SELF, "tk_action_result", result);
}