/*

    Companion and Monster AI

    This file contains some modifications of and additions to
    the default associate functions / behaviors.

*/
//	JSH-OEI 12/2/08: Made sure familiars always follow the leader,
//	even in puppet mode.

#include "x0_i0_assoc"
#include "hench_i0_act"
#include "ginc_companion"

// void main() {    }


// TODO move to flags?
//const string sHenchDisableAutoHide = "HenchDisableAutoHide";

// TODO move to flags ???
//const string sHenchDontCastMelee = "DoNotCastMelee";

//const string sHenchFamiliarChallenge = "NewFamiliarChallenge";
//const string sHenchFamiliarToDeath = "FamiliarToTheDeath";

//const string sHenchAniCompChallenge = "NewAniCompChallenge";
//const string sHenchAniCompToDeath = "AniCompToTheDeath";

// these constants are used for remembering associate settings between summons
const string sHenchFamiliarPreStr = "Fam";
const string sHenchAniCompPreStr = "Ani";
const string sHenchSummonPreStr = "Sum";
const string sHenchDominatePreStr = "Dom";
const string sHenchDefSettingsSet = "HENCH_DEF_SETTINGS_SET";

// constants for healing and buffing
const int HENCH_CNTX_MENU_OFF           = 0;
const int HENCH_CNTX_MENU_HEAL          = 1;
const int HENCH_CNTX_MENU_BUFF_LONG     = 2;
const int HENCH_CNTX_MENU_BUFF_MEDIUM   = 3;
const int HENCH_CNTX_MENU_BUFF_SHORT    = 4;
// constants so player controlled character gets flags set too
const int HENCH_CNTX_MENU_PC_ATTACK_NEAREST     = 100;
const int HENCH_CNTX_MENU_PC_FOLLOW_MASTER      = 101;
const int HENCH_CNTX_MENU_PC_GUARD_MASTER       = 102;
const int HENCH_CNTX_MENU_PC_STAND_GROUND       = 103;
// constants for scouting
const int HENCH_CNTX_MENU_SCOUT                 = 104;
// constants for follow
const int HENCH_CNTX_MENU_FOLLOW_TARGET         = 105;
const int HENCH_CNTX_MENU_FOLLOW_ME             = 106;
const int HENCH_CNTX_MENU_FOLLOW_NO_ONE         = 107;
const int HENCH_CNTX_MENU_FOLLOW_RESET          = 108;
const int HENCH_CNTX_MENU_FOLLOW_RESET_ALL      = 109;
const int HENCH_CNTX_MENU_FOLLOW_SINGLE         = 114;
const int HENCH_CNTX_MENU_FOLLOW_DOUBLE         = 115;
const int HENCH_CNTX_MENU_FOLLOW_NO_ONE_ALL     = 116;
// constants for guarding
const int HENCH_CNTX_MENU_GUARD_TARGET          = 110;
const int HENCH_CNTX_MENU_GUARD_ME              = 111;
const int HENCH_CNTX_MENU_GUARD_RESET           = 112;
const int HENCH_CNTX_MENU_GUARD_RESET_ALL       = 113;
// constants for weapon equipping
const int HENCH_CNTX_MENU_SET_WEAPON            = 200;
const int HENCH_CNTX_MENU_RESET_WEAPON          = 201;


const string henchHealCountStr = "HenchCurHealCount";
const string henchHealTypeStr = "HenchHealType";
const string henchHealStateStr = "HenchHealState";
const string henchHealSpellTarget =  "Henchman_Spell_Target";

// maximum scout distance
const float henchMaxScoutDistance = 35.0;

// gets the prepending string for an associate setting
string HenchGetAssocString(int iAssocType);

// sets the default settings for an associate on summons
// setting is copied to be on master too
void HenchSetDefSettings(object oCreature = OBJECT_SELF);

// gets the default settings for an associate
// (copy from master if needed)
void HenchGetDefSettings(object oCreature = OBJECT_SELF);

// Modified form of ResetHenchmenState
// sets the henchmen to commandable, deletes locals
// having to do with doors and clears actions
// Modified by Tony K to clear more things
void HenchResetHenchmenState();

// set additional behaviors supported by this AI (HENCH_ASC_*)
void SetHenchAssociateState(int nCondition, int bValid, object oCreature);

// set party behaviors supported by this AI (HENCH_PARTY_*)
void SetHenchPartyState(int nCondition, int bValid, object oCreature);

// clear out persisted information (tag and object)
void HenchClearPersistedObject(object oTarget, string storageString);

// get persisted object from target, restore object from tag if needed
// object returned must be faction, otherwise null returned
object HenchGetPersistedObject(object oTarget, string storageString);

// set persisted object for target
void HenchSetPersistedObject(object oTarget, object oObject, string storageString);

// get the creature you follow, OBJECT_INVALID if none
object HenchGetFollowLeader();

// follow your leader, or stand still if none
void HenchFollowLeader();

// set your leader to follow
void HenchSetLeader(object oTarget, object oLeader);

// set no leader to follow, stand ground
void HenchSetNoLeader(object oTarget);

// reset leader back to current master (creature PC is controlling)
void HenchSetDefaultLeader(object oTarget);

// get creature you are defending, return OBJECT_INVALID if none
object HenchGetDefendee();

// set creature you are defending
void HenchSetDefendee(object oTarget, object oDefendee);

// reset creature you are defending to current master (creature PC is controlling)
void HenchSetDefaultDefendee(object oTarget);

// turn on or off out of combat stealth
void HenchCheckOutOfCombatStealth(object oRealMaster);

// User defined event handler for possessing a party member
// Forces unpossessed, non-associates to follow the new leader
// Modified to adjust follow leader setting
void HenchPlayerControlPossessed(object oCreature);

// User defined event handler for EVENT_PLAYER_CONTROL_CHANGED (2052)
// Modified to adjust follow leader setting
void HenchHandlePlayerControlChanged(object oCreature);

// set up the GUI with all the info for the selectable states
// oPlayerObject - the player object who's looking at the GUI
// oTargetObject - the object who's information is being displayed in the GUI
// sScreen - The GUI screen being looked at.
void HenchGuiBehaviorInit(object oPlayerObject, object oTargetObject, string sScreen);


string HenchGetAssocString(int iAssocType)
{
    if (iAssocType == ASSOCIATE_TYPE_FAMILIAR)
    {
        return sHenchFamiliarPreStr;
    }
    else if (iAssocType == ASSOCIATE_TYPE_ANIMALCOMPANION)
    {
        return sHenchAniCompPreStr;
    }
    else if (iAssocType == ASSOCIATE_TYPE_SUMMONED)
    {
        return sHenchSummonPreStr;
    }
    else if (iAssocType == ASSOCIATE_TYPE_DOMINATED)
    {
        return sHenchDominatePreStr;
    }
    return "null";
}


void HenchSetDefSettings(object oCreature = OBJECT_SELF)
{
    int iAssocType = GetAssociateType(oCreature);
    if ((iAssocType == ASSOCIATE_TYPE_NONE) ||
        (iAssocType == ASSOCIATE_TYPE_HENCHMAN))
    {
        return;
    }

    string preDefStr = HenchGetAssocString(iAssocType);
    object oPC = GetMaster(oCreature);
    if (!GetIsObjectValid(oPC))
    {
        return;
    }

    SetLocalInt(oPC, preDefStr + sAssociateMasterConditionVarname, GetLocalInt(oCreature, sAssociateMasterConditionVarname));
    SetLocalInt(oPC, preDefStr + sHenchStealthMode, GetLocalInt(oCreature, sHenchStealthMode));
    SetLocalInt(oPC, preDefStr + sHenchStopCasting, GetLocalInt(oCreature, sHenchStopCasting));
    SetLocalInt(oPC, preDefStr + sHenchDontDispel, GetLocalInt(oCreature, sHenchDontDispel));
    SetLocalInt(oPC, preDefStr + henchAssociateSettings, GetLocalInt(oCreature, henchAssociateSettings));
}


void HenchGetDefSettings(object oCreature = OBJECT_SELF)
{
    if (GetLocalInt(oCreature, sHenchDefSettingsSet))
    {
        return;
    }

    SetLocalInt(oCreature, sHenchDefSettingsSet, TRUE);

    int iAssocType = GetAssociateType(oCreature);
    if ((iAssocType == ASSOCIATE_TYPE_NONE) ||
        (iAssocType == ASSOCIATE_TYPE_HENCHMAN))
    {
        return;
    }

    string preDefStr = HenchGetAssocString(iAssocType);
    object oPC = GetMaster(oCreature);
    if (!GetIsObjectValid(oPC))
    {
        return;
    }

    object oTarget;
    object oSource;
    string preSrcStr;
        // check if the PC has never had settings copied
        // for associate type
    if (!GetLocalInt(oPC, preDefStr + sHenchDefSettingsSet))
    {
        SetLocalInt(oPC, preDefStr + sHenchDefSettingsSet, TRUE);
        oTarget = oPC;
        oSource = oCreature;
        preSrcStr = preDefStr;
        preDefStr = "";
    }
    else
    {
        oTarget = oCreature;
        oSource = oPC;
        preSrcStr = "";
    }

    SetLocalInt(oTarget, preSrcStr + sAssociateMasterConditionVarname,
        GetLocalInt(oSource, preDefStr + sAssociateMasterConditionVarname));
    SetLocalInt(oTarget, preSrcStr + sHenchStealthMode,
        GetLocalInt(oSource, preDefStr + sHenchStealthMode));
    SetLocalInt(oTarget, preSrcStr + sHenchStopCasting,
        GetLocalInt(oSource, preDefStr + sHenchStopCasting));
    SetLocalInt(oTarget, preSrcStr + sHenchDontDispel,
        GetLocalInt(oSource, preDefStr + sHenchDontDispel));
    SetLocalInt(oTarget, preSrcStr + henchAssociateSettings,
        GetLocalInt(oSource, preDefStr + henchAssociateSettings));
}

/*
void HenchSetAssociateFlee(float fChallenge, int bFightToDeath)
{
    object oPC = GetPCSpeaker();
    int iAssocType = GetAssociateType(OBJECT_SELF);
    // Set the variables
    if (iAssocType == ASSOCIATE_TYPE_FAMILIAR)
    {
        SetLocalFloat(oPC, sHenchFamiliarChallenge, fChallenge);
        SetLocalInt(oPC, sHenchFamiliarToDeath, bFightToDeath);
    }
    else if (iAssocType == ASSOCIATE_TYPE_ANIMALCOMPANION)
    {
        SetLocalFloat(oPC, sHenchAniCompChallenge, fChallenge);
        SetLocalInt(oPC, sHenchAniCompToDeath, bFightToDeath);
    }
}*/


void HenchResetHenchmenState()
{
    SetCommandable(TRUE);
    DeleteLocalObject(OBJECT_SELF, "NW_GENERIC_DOOR_TO_BASH");
    DeleteLocalInt(OBJECT_SELF, "NW_GENERIC_DOOR_TO_BASH_HP");
    DeleteLocalInt(OBJECT_SELF, henchHealCountStr);
    DeleteLocalInt(OBJECT_SELF, henchHealTypeStr);
    DeleteLocalInt(OBJECT_SELF, henchHealStateStr);
    DeleteLocalObject(OBJECT_SELF, henchHealSpellTarget);
    SetAssociateState(NW_ASC_IS_BUSY, FALSE);
    ClearForceOptions();
    ClearAllActions();
}


void SetHenchAssociateState(int nCondition, int bValid, object oCreature)
{
    int nPlot = GetLocalInt(oCreature, henchAssociateSettings);
    if(bValid)
    {
        nPlot = nPlot | nCondition;
    }
    else
    {
        nPlot = nPlot & ~nCondition;
    }
    SetLocalInt(oCreature, henchAssociateSettings, nPlot);
}


void SetHenchPartyState(int nCondition, int bValid, object oCreature)
{
    object oPlayerCharacter = GetOwnedCharacter(GetFactionLeader(oCreature));
    int nPlot = GetLocalInt(oPlayerCharacter, henchPartySettings);
    if(bValid)
    {
        nPlot = nPlot | nCondition;
    }
    else
    {
        nPlot = nPlot & ~nCondition;
    }
    SetLocalInt(oPlayerCharacter, henchPartySettings, nPlot);
}


void HenchClearPersistedObject(object oTarget, string storageString)
{
    DeleteLocalObject(oTarget, storageString);
    DeleteLocalString(oTarget, storageString);
    DeleteLocalInt(oTarget, storageString);
}


object HenchGetPersistedObject(object oTarget, string storageString)
{
    object oObject = GetLocalObject(oTarget, storageString);

    if (!GetIsObjectValid(oObject))
    {
        string tagToFollow = GetLocalString(oTarget, storageString);
        if (tagToFollow != "")
        {
            oObject = GetObjectByTag(tagToFollow);
            if (GetIsObjectValid(oObject) && GetFactionEqual(oObject, oTarget))
            {
                SetLocalObject(oTarget, storageString, oObject);
            }
            else
            {
                DeleteLocalString(oTarget, storageString);
            }
//          Jug_Debug(GetName(oTarget) + " try to get persisted object from in " + GetName(oObject) + " in module " + GetName(GetModule()));
        }
    }
    if (GetIsObjectValid(oObject))
    {
        if (!GetFactionEqual(oObject, oTarget))
        {
            oObject = OBJECT_INVALID;
            HenchClearPersistedObject(oTarget, storageString);
        }
        else
        {
            int assocType = GetLocalInt(oTarget, storageString);
            if (assocType != GetAssociateType(oObject))
            {
                object oAssociate = GetAssociate(assocType, oObject);
                if (GetIsObjectValid(oObject))
                {
                    oObject = oAssociate;
                    SetLocalObject(oTarget, storageString, oObject);
                }
            }
        }
    }
    return oObject;
}


void HenchSetPersistedObject(object oTarget, object oObject, string storageString)
{
    int assocType = GetAssociateType(oObject);
    if (assocType != ASSOCIATE_TYPE_NONE)
    {
        oObject = GetMaster(oObject);
    }
    SetLocalObject(oTarget, storageString, oObject);
    SetLocalString(oTarget, storageString, GetTag(oObject));
    SetLocalInt(oTarget, storageString, assocType);

    // prevent circular leaders
    object oNextObject = oObject;
    while (GetIsObjectValid(oNextObject))
    {
        if (oNextObject == oTarget)
        {
            HenchClearPersistedObject(oNextObject, storageString);
            break;
        }
        oNextObject = HenchGetPersistedObject(oNextObject, storageString);
    }
}


const string sHenchFollowTarget = "HenchFollowTarget";

object HenchGetFollowLeader()
{
    if (GetLocalInt(OBJECT_SELF, sHenchDontAttackFlag))
    {
        return GetCurrentMaster();
    }
    else
    {
        object oLeader = HenchGetPersistedObject(OBJECT_SELF, sHenchFollowTarget);
        if (GetIsObjectValid(oLeader))
        {
//          Jug_Debug(GetName(OBJECT_SELF) + " following " + GetName(oLeader) + " in module " + GetName(GetModule()));
            return oLeader;
        }
        else if (!GetLocalInt(OBJECT_SELF, sHenchFollowTarget))
        {
//          Jug_Debug(GetName(OBJECT_SELF) + " following current master in module " + GetName(GetModule()));
            return GetCurrentMaster();
        }
        else
        {
//          Jug_Debug(GetName(OBJECT_SELF) + " not following in module " + GetName(GetModule()));
            return OBJECT_INVALID;
        }
    }
}


void HenchFollowLeader()
{
    object oLeader =  HenchGetFollowLeader();
    if (GetCurrentAction() == ACTION_FOLLOW)
    {
        ClearAllActions();
    }
	
	//	Familiars always follow their master, even in puppet mode.
	if(GetAssociateType(OBJECT_SELF) == ASSOCIATE_TYPE_FAMILIAR)
	{
		//SpeakString("I'm a familiar, being ordered to follow my master.");
	    if (!GetAssociateState(NW_ASC_MODE_STAND_GROUND) && GetIsObjectValid(oLeader))
	    {
	        ActionForceFollowObject(oLeader, GetFollowDistance());
	    }
	}
	else
	{
		if (!GetAssociateState(NW_ASC_MODE_STAND_GROUND) && !GetAssociateState(NW_ASC_MODE_PUPPET) && GetIsObjectValid(oLeader))
	    {
	        ActionForceFollowObject(oLeader, GetFollowDistance());
	    }
	}
}


void HenchSetLeader(object oTarget, object oLeader)
{
    HenchSetPersistedObject(oTarget, oLeader, sHenchFollowTarget);
    if ((GetCurrentAction(oTarget) == ACTION_FOLLOW) && !GetIsPC(oTarget))
    {
        if (oTarget == OBJECT_SELF)
        {
            HenchFollowLeader();
        }
        else
        {
            AssignCommand(oTarget, HenchFollowLeader());
        }
    }
}


void HenchSetNoLeader(object oTarget)
{
    HenchClearPersistedObject(oTarget, sHenchFollowTarget);
    SetLocalInt(oTarget, sHenchFollowTarget, TRUE);
    if ((GetCurrentAction(oTarget) == ACTION_FOLLOW) && !GetIsPC(oTarget))
    {
        if (oTarget == OBJECT_SELF)
        {
            ClearAllActions();
        }
        else
        {
            AssignCommand(oTarget, ClearAllActions());
        }
    }
}


void HenchSetDefaultLeader(object oTarget)
{
    HenchClearPersistedObject(oTarget, sHenchFollowTarget);
    if ((GetCurrentAction(oTarget) == ACTION_FOLLOW) && !GetIsPC(oTarget))
    {
        if (oTarget == OBJECT_SELF)
        {
            HenchFollowLeader();
        }
        else
        {
            AssignCommand(oTarget, HenchFollowLeader());
        }
    }
}


const string sHenchDefendTarget = "HenchDefendTarget";

object HenchGetDefendee()
{
    object oDefendee = HenchGetPersistedObject(OBJECT_SELF, sHenchDefendTarget);
    if (GetIsObjectValid(oDefendee))
    {
//      Jug_Debug(GetName(OBJECT_SELF) + " defending " + GetName(oDefendee) + " in module " + GetName(GetModule()));
        return oDefendee;
    }
//  Jug_Debug(GetName(OBJECT_SELF) + " defending current master in module " + GetName(GetModule()));
    return GetCurrentMaster();
}


void HenchSetDefendee(object oTarget, object oDefendee)
{
    HenchSetPersistedObject(oTarget, oDefendee, sHenchDefendTarget);
}


void HenchSetDefaultDefendee(object oTarget)
{
    HenchClearPersistedObject(oTarget, sHenchDefendTarget);
}


void HenchCheckOutOfCombatStealth(object oRealMaster)
{
    if (!(GetLocalInt(OBJECT_SELF, sHenchDontAttackFlag) &&
		!GetHenchPartyState(HENCH_PARTY_DISABLE_PEACEFUL_MODE)))
    {
//		Jug_Debug(GetName(OBJECT_SELF) + " checking stealth");
        // Check to see if should re-enter stealth mode
        int nStealth = GetLocalInt(GetTopMaster(), sHenchStealthMode);
        if ((nStealth == 1) || (nStealth == 2))
        {
//			Jug_Debug(GetName(OBJECT_SELF) + " going back to stealth");
            if (!GetActionMode(OBJECT_SELF, ACTION_MODE_STEALTH))
            {
                SetActionMode(OBJECT_SELF, ACTION_MODE_STEALTH, TRUE);
            }
        }
        else
        {
//			Jug_Debug(GetName(OBJECT_SELF) + " going out of stealth");
            if (GetHenchAssociateState(HENCH_ASC_DISABLE_AUTO_HIDE) ||
				!GetActionMode(oRealMaster, ACTION_MODE_STEALTH))
            {
//				Jug_Debug(GetName(OBJECT_SELF) + " turning off stealth");
                SetActionMode(OBJECT_SELF, ACTION_MODE_STEALTH, FALSE);
            }
        }
    }
}


void HenchPlayerControlPossessed(object oCreature)
{
//  Jug_Debug( "ginc_companion: " + GetName( oCreature ) + " has been possessed (EVENT_PLAYER_CONTROL_CHANGED)." );
	
	object oLeader = GetFactionLeader( oCreature );
    if ( oLeader == oCreature )
    {
        //Jug_Debug( "ginc_companion: " + GetName( oCreature ) + " is the new party leader!" );
        object oPM = GetFirstFactionMember( oCreature, FALSE );
        while ( GetIsObjectValid( oPM ) == TRUE )
        {
            // If I'm currently following somebody
            if ( GetCurrentAction( oPM ) == ACTION_FOLLOW )
            {
                //Jug_Debug(GetName(oPM) + " going to follow ");
                // But I'm not possessed, not myself, and not an associate
                if ( ( GetIsPC( oPM ) == FALSE ) &&
                     ( oPM != oLeader ) &&
                     ( GetAssociateType( oPM ) == ASSOCIATE_TYPE_NONE ) &&
					 !GetAssociateState(NW_ASC_MODE_PUPPET, oPM) )
                {
                    AssignCommand( oPM, ClearAllActions() );
                    AssignCommand( oPM, HenchFollowLeader());
                }
            }

            oPM = GetNextFactionMember( oCreature, FALSE );
        }
    }
}


void HenchHandlePlayerControlChanged(object oCreature)
{
    if (GetIsPC(oCreature))
    {
        HenchPlayerControlPossessed(oCreature);
    }
    else
    {
        PlayerControlUnpossessed(oCreature);
    }
}


void HenchGuiBehaviorInit(object oPlayerObject, object oTargetObject, string sScreen)
{
    HenchGetDefSettings(oTargetObject);
    HenchSetDefSettings(oTargetObject);

    int iState;

    // associate settings

        // weapon switching
    SetGUIObjectText(oPlayerObject, sScreen, "BEHAVIOR_DISABLE_WEAPON_SWITCH_COL_HEADER", -1, sHenchEnableWeaonSwitch);

    iState = GetHenchAssociateState(HENCH_ASC_DISABLE_AUTO_WEAPON_SWITCH, oTargetObject);
    SetGUIObjectDisabled(oPlayerObject, sScreen, "BEHAVIOR_DISABLE_WEAPON_SWITCH_STATE_BUTTON_ON", !iState);
    SetGUIObjectDisabled(oPlayerObject, sScreen, "BEHAVIOR_DISABLE_WEAPON_SWITCH_STATE_BUTTON_OFF", iState);

        // use ranged weapons
    iState = GetAssociateState(NW_ASC_USE_RANGED_WEAPON, oTargetObject);
    SetGUIObjectDisabled(oPlayerObject, sScreen, "BEHAVIOR_RANGED_WEAPONS_STATE_BUTTON_ON", iState);
    SetGUIObjectDisabled(oPlayerObject, sScreen, "BEHAVIOR_RANGED_WEAPONS_STATE_BUTTON_OFF", !iState);

        // switch to melee distance
    SetGUIObjectText(oPlayerObject, sScreen, "BEHAVIOR_MELEEDIST_COL_HEADER", -1, sHenchSwitchToMeleeDist);

    iState = GetHenchAssociateState(HENCH_ASC_MELEE_DISTANCE_NEAR, oTargetObject);
    SetGUIObjectDisabled(oPlayerObject, sScreen, "BEHAVIOR_MELEEDIST_STATE_BUTTON_NEAR", iState);
    iState = GetHenchAssociateState(HENCH_ASC_MELEE_DISTANCE_MED, oTargetObject);
    SetGUIObjectDisabled(oPlayerObject, sScreen, "BEHAVIOR_MELEEDIST_STATE_BUTTON_MED", iState);
    iState = GetHenchAssociateState(HENCH_ASC_MELEE_DISTANCE_FAR, oTargetObject);
    SetGUIObjectDisabled(oPlayerObject, sScreen, "BEHAVIOR_MELEEDIST_STATE_BUTTON_FAR", iState);

            // back away
    SetGUIObjectText(oPlayerObject, sScreen, "BEHAVIOR_BACK_AWAY_COL_HEADER", -1, sHenchEnableBackAway);
    iState = GetHenchAssociateState(HENCH_ASC_ENABLE_BACK_AWAY, oTargetObject);
    SetGUIObjectDisabled(oPlayerObject, sScreen, "BEHAVIOR_BACK_AWAY_STATE_BUTTON_ON", iState);
    SetGUIObjectDisabled(oPlayerObject, sScreen, "BEHAVIOR_BACK_AWAY_STATE_BUTTON_OFF", !iState);

        // summons
    SetGUIObjectText(oPlayerObject, sScreen, "BEHAVIOR_DISABLE_SUMMONS_COL_HEADER", -1, sHenchEnableSummons);
    iState = GetHenchAssociateState(HENCH_ASC_DISABLE_SUMMONS, oTargetObject);
    SetGUIObjectDisabled(oPlayerObject, sScreen, "BEHAVIOR_DISABLE_SUMMONS_STATE_BUTTON_ON", !iState);
    SetGUIObjectDisabled(oPlayerObject, sScreen, "BEHAVIOR_DISABLE_SUMMONS_STATE_BUTTON_OFF", iState);

        // dual wielding
    SetGUIObjectText(oPlayerObject, sScreen, "BEHAVIOR_DUAL_WIELDING_COL_HEADER", -1, sHenchDualWielding);

    iState = GetHenchAssociateState(HENCH_ASC_ENABLE_DUAL_WIELDING, oTargetObject);
    SetGUIObjectDisabled(oPlayerObject, sScreen, "BEHAVIOR_DUAL_WIELDING_STATE_BUTTON_ON", iState);
    iState = GetHenchAssociateState(HENCH_ASC_DISABLE_DUAL_WIELDING, oTargetObject);
    SetGUIObjectDisabled(oPlayerObject, sScreen, "BEHAVIOR_DUAL_WIELDING_STATE_BUTTON_OFF", iState);
    iState = GetHenchAssociateState(HENCH_ASC_ENABLE_DUAL_WIELDING, oTargetObject) || GetHenchAssociateState(HENCH_ASC_DISABLE_DUAL_WIELDING, oTargetObject);
    SetGUIObjectDisabled(oPlayerObject, sScreen, "BEHAVIOR_DUAL_WIELDING_STATE_BUTTON_DEFAULT", !iState);

    // heavy off hand
    SetGUIObjectText(oPlayerObject, sScreen, "BEHAVIOR_DISABLE_HEAVY_OFF_HAND_COL_HEADER", -1, sHenchEnableHeavyOffHand);
    iState = GetHenchAssociateState(HENCH_ASC_DISABLE_DUAL_HEAVY, oTargetObject);
    SetGUIObjectDisabled(oPlayerObject, sScreen, "BEHAVIOR_DISABLE_HEAVY_OFF_HAND_STATE_BUTTON_ON", !iState);
    SetGUIObjectDisabled(oPlayerObject, sScreen, "BEHAVIOR_DISABLE_HEAVY_OFF_HAND_STATE_BUTTON_OFF", iState);

    // shield use
    SetGUIObjectText(oPlayerObject, sScreen, "BEHAVIOR_DISABLE_SHIELD_USE_COL_HEADER", -1, sHenchEnableShieldUse);
    iState = GetHenchAssociateState(HENCH_ASC_DISABLE_SHIELD_USE, oTargetObject);
    SetGUIObjectDisabled(oPlayerObject, sScreen, "BEHAVIOR_DISABLE_SHIELD_USE_STATE_BUTTON_ON", !iState);
    SetGUIObjectDisabled(oPlayerObject, sScreen, "BEHAVIOR_DISABLE_SHIELD_USE_STATE_BUTTON_OFF", iState);

    // recover traps
    SetGUIObjectText(oPlayerObject, sScreen, "BEHAVIOR_RECOVER_TRAPS_COL_HEADER", -1, sHenchEnableRecoverTraps);
    iState = GetHenchAssociateState(HENCH_ASC_RECOVER_TRAPS, oTargetObject);
    SetGUIObjectDisabled(oPlayerObject, sScreen, "BEHAVIOR_RECOVER_TRAPS_STATE_BUTTON_ON", iState && GetHenchAssociateState(HENCH_ASC_NON_SAFE_RECOVER_TRAPS, oTargetObject));
    SetGUIObjectDisabled(oPlayerObject, sScreen, "BEHAVIOR_RECOVER_TRAPS_SAFE_STATE_BUTTON_ON", iState && !GetHenchAssociateState(HENCH_ASC_NON_SAFE_RECOVER_TRAPS, oTargetObject));
    SetGUIObjectDisabled(oPlayerObject, sScreen, "BEHAVIOR_RECOVER_TRAPS_STATE_BUTTON_OFF", !iState);

    // auto open locks
    SetGUIObjectText(oPlayerObject, sScreen, "BEHAVIOR_AUTO_OPEN_LOCKS_COL_HEADER", -1, sHenchEnableAutoOpenLocks);
    iState = GetHenchAssociateState(HENCH_ASC_AUTO_OPEN_LOCKS, oTargetObject);
    SetGUIObjectDisabled(oPlayerObject, sScreen, "BEHAVIOR_AUTO_OPEN_LOCKS_STATE_BUTTON_ON", iState);
    SetGUIObjectDisabled(oPlayerObject, sScreen, "BEHAVIOR_AUTO_OPEN_LOCKS_STATE_BUTTON_OFF", !iState);

    // auto pickup
    SetGUIObjectText(oPlayerObject, sScreen, "BEHAVIOR_AUTO_PICKUP_COL_HEADER", -1, sHenchEnableAutoPickup);
    iState = GetHenchAssociateState(HENCH_ASC_AUTO_PICKUP, oTargetObject);
    SetGUIObjectDisabled(oPlayerObject, sScreen, "BEHAVIOR_AUTO_PICKUP_STATE_BUTTON_ON", iState);
    SetGUIObjectDisabled(oPlayerObject, sScreen, "BEHAVIOR_AUTO_PICKUP_STATE_BUTTON_OFF", !iState);

    // polymorph
    SetGUIObjectText(oPlayerObject, sScreen, "BEHAVIOR_DISABLE_POLYMORPH_COL_HEADER", -1, sHenchEnablePolymorph);
    iState = GetHenchAssociateState(HENCH_ASC_DISABLE_POLYMORPH, oTargetObject);
    SetGUIObjectDisabled(oPlayerObject, sScreen, "BEHAVIOR_DISABLE_POLYMORPH_STATE_BUTTON_ON", !iState);
    SetGUIObjectDisabled(oPlayerObject, sScreen, "BEHAVIOR_DISABLE_POLYMORPH_STATE_BUTTON_OFF", iState);

    // infinite buff
    SetGUIObjectText(oPlayerObject, sScreen, "BEHAVIOR_DISABLE_INFINITE_BUFF_COL_HEADER", -1, sHenchEnableInfiniteBuff);
    iState = GetHenchAssociateState(HENCH_ASC_DISABLE_INFINITE_BUFF, oTargetObject);
    SetGUIObjectDisabled(oPlayerObject, sScreen, "BEHAVIOR_DISABLE_INFINITE_BUFF_STATE_BUTTON_ON", !iState);
    SetGUIObjectDisabled(oPlayerObject, sScreen, "BEHAVIOR_DISABLE_INFINITE_BUFF_STATE_BUTTON_OFF", iState);

    // enable cure and healing item use
    SetGUIObjectText(oPlayerObject, sScreen, "BEHAVIOR_ENABLE_HEAL_ITEM_USE_COL_HEADER", -1, sHenchEnableHealingItemUseBuff);
    iState = GetHenchAssociateState(HENCH_ASC_ENABLE_HEALING_ITEM_USE, oTargetObject);
    SetGUIObjectDisabled(oPlayerObject, sScreen, "BEHAVIOR_ENABLE_HEAL_ITEM_USE_STATE_BUTTON_ON", iState);
    SetGUIObjectDisabled(oPlayerObject, sScreen, "BEHAVIOR_ENABLE_HEAL_ITEM_USE_STATE_BUTTON_OFF", !iState);

    // disable automatic hiding
    SetGUIObjectText(oPlayerObject, sScreen, "BEHAVIOR_DISABLE_HIDING_COL_HEADER", -1, sHenchEnableAutoHide);
    iState = GetHenchAssociateState(HENCH_ASC_DISABLE_AUTO_HIDE, oTargetObject);
    SetGUIObjectDisabled(oPlayerObject, sScreen, "BEHAVIOR_DISABLE_HIDING_STATE_BUTTON_ON", !iState);
    SetGUIObjectDisabled(oPlayerObject, sScreen, "BEHAVIOR_DISABLE_HIDING_STATE_BUTTON_OFF", iState);

        // guard distance
    SetGUIObjectText(oPlayerObject, sScreen, "BEHAVIOR_GUARDDIST_COL_HEADER", -1, sHenchGuardDist);

    iState = GetHenchAssociateState(HENCH_ASC_GUARD_DISTANCE_NEAR, oTargetObject);
    SetGUIObjectDisabled(oPlayerObject, sScreen, "BEHAVIOR_GUARDDIST_STATE_BUTTON_NEAR", iState);
    iState = GetHenchAssociateState(HENCH_ASC_GUARD_DISTANCE_MED, oTargetObject);
    SetGUIObjectDisabled(oPlayerObject, sScreen, "BEHAVIOR_GUARDDIST_STATE_BUTTON_MED", iState);
    iState = GetHenchAssociateState(HENCH_ASC_GUARD_DISTANCE_FAR, oTargetObject);
    SetGUIObjectDisabled(oPlayerObject, sScreen, "BEHAVIOR_GUARDDIST_STATE_BUTTON_FAR", iState);
    iState = GetHenchAssociateState(HENCH_ASC_GUARD_DISTANCE_NEAR | HENCH_ASC_GUARD_DISTANCE_MED | HENCH_ASC_GUARD_DISTANCE_FAR, oTargetObject);
    SetGUIObjectDisabled(oPlayerObject, sScreen, "BEHAVIOR_GUARDDIST_STATE_BUTTON_DEFAULT", !iState);

    string userText = sHenchFollowing;
    object oLeader = HenchGetPersistedObject(oTargetObject, sHenchFollowTarget);
    if (GetIsObjectValid(oLeader))
    {
        userText += GetName(oLeader);
    }
    else if (!GetLocalInt(oTargetObject, sHenchFollowTarget))
    {
        if (!GetAssociateType(oTargetObject))
        {
            userText += sHenchPCC;
        }
        else
        {
            userText += sHenchMaster;
        }
    }
    else
    {
        userText += sHenchNoOne;
    }
    SetGUIObjectText(oPlayerObject, sScreen, "BEHAVIOR_FOLLOW_TARGET_BUTTON_TEXT", -1, userText);

    userText = sHenchDefending;
    object oDefender = HenchGetPersistedObject(oTargetObject, sHenchDefendTarget);
    if (GetIsObjectValid(oDefender))
    {
        userText += GetName(oDefender);
    }
    else
    {
        if (!GetAssociateType(oTargetObject))
        {
            userText += sHenchPCC;
        }
        else
        {
            userText += sHenchMaster;
        }
    }
    SetGUIObjectText(oPlayerObject, sScreen, "BEHAVIOR_DEFEND_TARGET_BUTTON_TEXT", -1, userText);

    // disable melee attacks
    SetGUIObjectText(oPlayerObject, sScreen, "BEHAVIOR_DISABLE_MELEE_ATTACK_COL_HEADER", -1, sHenchDisableMeleeAttacks);
    iState = GetHenchAssociateState(HENCH_ASC_NO_MELEE_ATTACKS, oTargetObject);
    SetGUIObjectDisabled(oPlayerObject, sScreen, "BEHAVIOR_DISABLE_MELEE_ATTACK_STATE_BUTTON_ON", iState);
    SetGUIObjectDisabled(oPlayerObject, sScreen, "BEHAVIOR_DISABLE_MELEE_ATTACK_STATE_BUTTON_OFF", !iState);

    // use melee weapons if any members of party are in melee range of target
    SetGUIObjectText(oPlayerObject, sScreen, "BEHAVIOR_ENABLE_MELEE_ANY_COL_HEADER", -1, sHenchEnableMeleeAttacksAny);
    iState = GetHenchAssociateState(HENCH_ASC_MELEE_DISTANCE_ANY, oTargetObject);
    SetGUIObjectDisabled(oPlayerObject, sScreen, "BEHAVIOR_ENABLE_MELEE_ANY_STATE_BUTTON_ON", iState);
    SetGUIObjectDisabled(oPlayerObject, sScreen, "BEHAVIOR_ENABLE_MELEE_ANY_STATE_BUTTON_OFF", !iState);

    if (sScreen == "SCREEN_CHARACTER")
    {
        // party options

        // unequip weapons outside of combat
        SetGUIObjectText(oPlayerObject, sScreen, "BEHAVIOR_UNEQUIP_WEAPONS_COL_HEADER", -1, sHenchUnequipWeapons);
        iState = GetHenchPartyState(HENCH_PARTY_UNEQUIP_WEAPONS, oTargetObject);
        SetGUIObjectDisabled(oPlayerObject, sScreen, "BEHAVIOR_UNEQUIP_WEAPONS_STATE_BUTTON_ON", iState);
        SetGUIObjectDisabled(oPlayerObject, sScreen, "BEHAVIOR_UNEQUIP_WEAPONS_STATE_BUTTON_OFF", !iState);

        // summon familiars outside of combat
        SetGUIObjectText(oPlayerObject, sScreen, "BEHAVIOR_SUMMON_FAMILIARS_COL_HEADER", -1, sHenchSummonFamiliars);
        iState = GetHenchPartyState(HENCH_PARTY_SUMMON_FAMILIARS, oTargetObject);
        SetGUIObjectDisabled(oPlayerObject, sScreen, "BEHAVIOR_SUMMON_FAMILIARS_STATE_BUTTON_ON", iState);
        SetGUIObjectDisabled(oPlayerObject, sScreen, "BEHAVIOR_SUMMON_FAMILIARS_STATE_BUTTON_OFF", !iState);

        // summon animal companions outside of combat
        SetGUIObjectText(oPlayerObject, sScreen, "BEHAVIOR_SUMMON_COMPANIONS_COL_HEADER", -1, sHenchSummonCompanions);
        iState = GetHenchPartyState(HENCH_PARTY_SUMMON_COMPANIONS, oTargetObject);
        SetGUIObjectDisabled(oPlayerObject, sScreen, "BEHAVIOR_SUMMON_COMPANIONS_STATE_BUTTON_ON", iState);
        SetGUIObjectDisabled(oPlayerObject, sScreen, "BEHAVIOR_SUMMON_COMPANIONS_STATE_BUTTON_OFF", !iState);
		
        // ally damage
		SetGUIObjectText(oPlayerObject, sScreen, "BEHAVIOR_ALLY_DAMAGE_COL_HEADER", -1, sHenchAllyDamage);
		SetGUIObjectDisabled(oPlayerObject, sScreen, "BEHAVIOR_ALLY_DAMAGE_STATE_BUTTON_LOW", GetHenchPartyState(HENCH_PARTY_LOW_ALLY_DAMAGE, oTargetObject) || 
			!(GetHenchPartyState(HENCH_PARTY_MEDIUM_ALLY_DAMAGE, oTargetObject) || GetHenchPartyState(HENCH_PARTY_HIGH_ALLY_DAMAGE, oTargetObject)));
		SetGUIObjectDisabled(oPlayerObject, sScreen, "BEHAVIOR_ALLY_DAMAGE_STATE_BUTTON_MED", GetHenchPartyState(HENCH_PARTY_MEDIUM_ALLY_DAMAGE, oTargetObject));
		SetGUIObjectDisabled(oPlayerObject, sScreen, "BEHAVIOR_ALLY_DAMAGE_STATE_BUTTON_HIGH", GetHenchPartyState(HENCH_PARTY_HIGH_ALLY_DAMAGE, oTargetObject));		

        // disable peaceful follow mode
        SetGUIObjectText(oPlayerObject, sScreen, "BEHAVIOR_PEACEFUL_FOLLOW_COL_HEADER", -1, sHenchPeacefulFollow);
        iState = GetHenchPartyState(HENCH_PARTY_DISABLE_PEACEFUL_MODE, oTargetObject);
        SetGUIObjectDisabled(oPlayerObject, sScreen, "BEHAVIOR_PEACEFUL_FOLLOW_STATE_BUTTON_ON", !iState);
        SetGUIObjectDisabled(oPlayerObject, sScreen, "BEHAVIOR_PEACEFUL_FOLLOW_STATE_BUTTON_OFF", iState);

        // disable self buff or heal
        SetGUIObjectText(oPlayerObject, sScreen, "BEHAVIOR_SELF_BUFF_OR_HEAL_COL_HEADER", -1, sHenchSelfBuffOrHeal);
        iState = GetHenchPartyState(HENCH_PARTY_DISABLE_SELF_HEAL_OR_BUFF, oTargetObject);
        SetGUIObjectDisabled(oPlayerObject, sScreen, "BEHAVIOR_SELF_BUFF_OR_HEAL_STATE_BUTTON_ON", !iState);
        SetGUIObjectDisabled(oPlayerObject, sScreen, "BEHAVIOR_SELF_BUFF_OR_HEAL_STATE_BUTTON_OFF", iState);

						
        // global options

        // monster stealth
        SetGUIObjectText(oPlayerObject, sScreen, "BEHAVIOR_MONSTER_STEALTH_COL_HEADER", -1, sHenchMonsterStealth);
        iState = GetHenchOption(HENCH_OPTION_STEALTH);
        SetGUIObjectDisabled(oPlayerObject, sScreen, "BEHAVIOR_MONSTER_STEALTH_STATE_BUTTON_ON", iState);
        SetGUIObjectDisabled(oPlayerObject, sScreen, "BEHAVIOR_MONSTER_STEALTH_STATE_BUTTON_OFF", !iState);

        // monster wander
        SetGUIObjectText(oPlayerObject, sScreen, "BEHAVIOR_MONSTER_WANDER_COL_HEADER", -1, sHenchMonsterWander);
        iState = GetHenchOption(HENCH_OPTION_WANDER);
        SetGUIObjectDisabled(oPlayerObject, sScreen, "BEHAVIOR_MONSTER_WANDER_STATE_BUTTON_ON", iState);
        SetGUIObjectDisabled(oPlayerObject, sScreen, "BEHAVIOR_MONSTER_WANDER_STATE_BUTTON_OFF", !iState);

        // monster open doors
        SetGUIObjectText(oPlayerObject, sScreen, "BEHAVIOR_MONSTER_OPEN_COL_HEADER", -1, sHenchMonsterOpen);
        iState = GetHenchOption(HENCH_OPTION_OPEN);
        SetGUIObjectDisabled(oPlayerObject, sScreen, "BEHAVIOR_MONSTER_OPEN_STATE_BUTTON_ON", iState);
        SetGUIObjectDisabled(oPlayerObject, sScreen, "BEHAVIOR_MONSTER_OPEN_STATE_BUTTON_OFF", !iState);

        // monster wander
        SetGUIObjectText(oPlayerObject, sScreen, "BEHAVIOR_MONSTER_UNLOCK_COL_HEADER", -1, sHenchMonsterUnlock);
        iState = GetHenchOption(HENCH_OPTION_UNLOCK);
        SetGUIObjectDisabled(oPlayerObject, sScreen, "BEHAVIOR_MONSTER_UNLOCK_STATE_BUTTON_ON", iState);
        SetGUIObjectDisabled(oPlayerObject, sScreen, "BEHAVIOR_MONSTER_UNLOCK_STATE_BUTTON_OFF", !iState);

        // knockdown
        SetGUIObjectText(oPlayerObject, sScreen, "BEHAVIOR_KNOCKDOWN_COL_HEADER", -1, sHenchKnockdown);
        SetGUIObjectText(oPlayerObject, sScreen, "BEHAVIOR_KNOCKDOWN_TEXT_BUTTON_SOMETIMES", -1, sHenchSometimes);
        iState = GetHenchOption(HENCH_OPTION_KNOCKDOWN_DISABLED);
        if (iState)
        {
            SetGUIObjectDisabled(oPlayerObject, sScreen, "BEHAVIOR_KNOCKDOWN_STATE_BUTTON_ON", FALSE);
            SetGUIObjectDisabled(oPlayerObject, sScreen, "BEHAVIOR_KNOCKDOWN_STATE_BUTTON_SOMETIMES", FALSE);
            SetGUIObjectDisabled(oPlayerObject, sScreen, "BEHAVIOR_KNOCKDOWN_STATE_BUTTON_OFF", TRUE);
        }
        else
        {
            iState = GetHenchOption(HENCH_OPTION_KNOCKDOWN_SOMETIMES);
            SetGUIObjectDisabled(oPlayerObject, sScreen, "BEHAVIOR_KNOCKDOWN_STATE_BUTTON_ON", !iState);
            SetGUIObjectDisabled(oPlayerObject, sScreen, "BEHAVIOR_KNOCKDOWN_STATE_BUTTON_SOMETIMES", iState);
            SetGUIObjectDisabled(oPlayerObject, sScreen, "BEHAVIOR_KNOCKDOWN_STATE_BUTTON_OFF", FALSE);
        }

        // auto behavior set
        SetGUIObjectText(oPlayerObject, sScreen, "BEHAVIOR_AUTO_BEHAVIOR_COL_HEADER", -1, sHenchAutoBehaviorSet);
        iState = GetHenchOption(HENCH_OPTION_DISABLE_AUTO_BEHAVIOR_SET);
        SetGUIObjectDisabled(oPlayerObject, sScreen, "BEHAVIOR_AUTO_BEHAVIOR_SET_STATE_BUTTON_OFF", iState);
        SetGUIObjectDisabled(oPlayerObject, sScreen, "BEHAVIOR_AUTO_BEHAVIOR_SET_STATE_BUTTON_ON", !iState);

        // non members of PC party automatically use long duration buffs at start of combat
        SetGUIObjectText(oPlayerObject, sScreen, "BEHAVIOR_AUTO_BUFF_COL_HEADER", -1, sHenchAutoBuff);
        iState = GetHenchOption(HENCH_OPTION_ENABLE_AUTO_BUFF);
        SetGUIObjectDisabled(oPlayerObject, sScreen, "BEHAVIOR_AUTO_BUFF_LONG_STATE_BUTTON_ON", iState && !GetHenchOption(HENCH_OPTION_ENABLE_AUTO_MEDIUM_BUFF));
        SetGUIObjectDisabled(oPlayerObject, sScreen, "BEHAVIOR_AUTO_BUFF_MED_STATE_BUTTON_ON", iState && GetHenchOption(HENCH_OPTION_ENABLE_AUTO_MEDIUM_BUFF));
        SetGUIObjectDisabled(oPlayerObject, sScreen, "BEHAVIOR_AUTO_BUFF_STATE_BUTTON_OFF", !iState);

        // non members of PC party get healing potions, etc. at start of combat
        SetGUIObjectText(oPlayerObject, sScreen, "BEHAVIOR_CREATE_ITEMS_COL_HEADER", -1, sHenchCreateItems);
        iState = GetHenchOption(HENCH_OPTION_ENABLE_ITEM_CREATION);
        SetGUIObjectDisabled(oPlayerObject, sScreen, "BEHAVIOR_AUTO_CREATE_ITEMS_STATE_BUTTON_ON", iState);
        SetGUIObjectDisabled(oPlayerObject, sScreen, "BEHAVIOR_AUTO_CREATE_ITEMS_STATE_BUTTON_OFF", !iState);

        // non members of PC party are able to use equipped items (run at start of combat)
        SetGUIObjectText(oPlayerObject, sScreen, "BEHAVIOR_USE_EQUIPPED_ITEMS_COL_HEADER", -1, sHenchEquipppedItems);
        iState = GetHenchOption(HENCH_OPTION_ENABLE_EQUIPPED_ITEM_USE);
        SetGUIObjectDisabled(oPlayerObject, sScreen, "BEHAVIOR_USE_EQUIPPED_ITEMS_STATE_BUTTON_ON", iState);
        SetGUIObjectDisabled(oPlayerObject, sScreen, "BEHAVIOR_USE_EQUIPPED_ITEMS_STATE_BUTTON_OFF", !iState);

        // Warlock hideous blow single round
        SetGUIObjectText(oPlayerObject, sScreen, "BEHAVIOR_HIDEOUS_BLOW_COL_HEADER", -1, sHenchHideousBlow);
        iState = GetHenchOption(HENCH_OPTION_HIDEOUS_BLOW_INSTANT);
        SetGUIObjectDisabled(oPlayerObject, sScreen, "BEHAVIOR_HIDEOUS_BLOW_STATE_BUTTON_ON", iState);
        SetGUIObjectDisabled(oPlayerObject, sScreen, "BEHAVIOR_HIDEOUS_BLOW_STATE_BUTTON_OFF", !iState);
		
        // Monster ally damage (area of effect spells)
        SetGUIObjectText(oPlayerObject, sScreen, "BEHAVIOR_MONSTER_ALLY_DAMAGE_COL_HEADER", -1, sHenchMonsterAllyDamage);
        iState = GetHenchOption(HENCH_OPTION_MONSTER_ALLY_DAMAGE);
        SetGUIObjectDisabled(oPlayerObject, sScreen, "BEHAVIOR_MONSTER_ALLY_DAMAGE_STATE_BUTTON_ON", iState);
        SetGUIObjectDisabled(oPlayerObject, sScreen, "BEHAVIOR_MONSTER_ALLY_DAMAGE_STATE_BUTTON_OFF", !iState);
	
	}
}