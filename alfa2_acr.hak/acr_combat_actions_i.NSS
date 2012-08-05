////////////////////////////////////////////////////////////////////////////////
//
//  System Name : ACR Configuration File
//     Filename : acr_combat_actions_i
//      Version : 1.0
//         Date : 2011-08-21
//       Author : Ronan
//
//  Local Variable Prefix = ACR_CACT
//
//
//  Dependencies external of nwscript: None
//
//  Description
//
//  Revision History
////////////////////////////////////////////////////////////////////////////////

////////////////////////////////////////////////////////////////////////////////
// Includes ////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////

#include "acr_effects_i"
#include "acr_time_i"
#include "acr_tools_i"

////////////////////////////////////////////////////////////////////////////////
// Constants ///////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////

const int ACR_COMBAT_ACTION_COOLDOWN_TIME = 6;

const string ACR_COMBAT_ACTION_TIMESTAMP = "ACR_CACT_TS";

const int POWER_EXPERT_EVENT_OPEN_MENU                  = 0;
const int POWER_EXPERT_EVENT_COMBAT_EXPERTISE_MENU      = 1;
const int POWER_EXPERT_EVENT_POWER_ATTACK_MENU          = 2;
const int POWER_EXPERT_EVENT_POWER_ATTACK_TOGGLE        = 3;
const int POWER_EXPERT_EVENT_COMBAT_EXPERTISE_TOGGLE    = 4;

const string POWER_ATTACK_MODE_ACTIVE      = "POWER_ATTACK_MODE_ACTIVE";
const string COMBAT_EXPERTISE_MODE_ACTIVE  = "COMBAT_EXPERTISE_MODE_ACTIVE";
const string POST_SPELLCAST_NO_COMBAT_MODE = "POST_SPELLCAST_NO_COMBAT_MODE";

////////////////////////////////////////////////////////////////////////////////
// Structures //////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////

////////////////////////////////////////////////////////////////////////////////
// Global Variables ////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////

////////////////////////////////////////////////////////////////////////////////
// Function Prototypes /////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////

void CombatActionsOnItemEquip(object oCreature);

//! Cancels all combat modes.
void FightNormally(object oCreature);

//! Causes oCreature to fight defensively until another combat action or
//! ClearCombatActions is called.
void FightDefensively(object oCreature);

//! Causes oCreature to fight with total defense, gaining +4 AC but not
//! attacking.
void FightTotallyDefensively(object oCreature);

//! Causes oCreature to fight defensively with expertise until another combat
//! action or ClearCombatActions is called.
void FightWithExpertise(object oCreature, int nAmount);

//! Returns TRUE if oCreature is using any sort of defensive fighting action.
int GetIsFightingDefensively(object oCreature);

void _FightDefensively(object oCreature, int nACBonus, int nABPenalty);

void _NotifyCombatAction(string sMsg, object oCreature);

int _TrySwitchModes(object oCreature);

//! Cancels all combat action modes.
void _ClearCombatModes(object oCreature);

//! Handle or force Combat Expertise/Power Attack GUI events.
void _HandlePowExpGUIEvent( object oPC, int nEvent, int nAmount );

////////////////////////////////////////////////////////////////////////////////
// Function Definitions ////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////

void CombatActionsOnEquip(object oCreature, object oItem) {
    if(GetIsFightingDefensively(oCreature) && GetWeaponRanged(oItem)) {
        _NotifyCombatAction("You cannot fight defensively with a ranged weapon equiped.", oCreature);
        _ClearCombatModes(oCreature);
    }
}

void FightNormally(object oCreature) {
    _TrySwitchModes(oCreature);
    _ClearCombatModes(oCreature);
}

void FightDefensively(object oCreature) {
    _FightDefensively(oCreature, 2, 4);
}

void FightTotallyDefensively(object oCreature) {
    _FightDefensively(oCreature, 4, 100);
}

void FightWithExpertise(object oCreature, int nAmount) {
    if(nAmount <= 0) {
        return;
    }
    
    int nBAB = GetBaseAttackBonus(oCreature);
    
    if(nAmount > nBAB) nAmount = nBAB;
    
    _FightDefensively(oCreature, nAmount, nAmount);
}

int GetIsFightingDefensively(object oCreature) {
    return CountTrackingEffectsFor(oCreature, ACR_EFFECT_SOURCE_COMBAT_ACTION);
}

int _TrySwitchModes(object oCreature) {
    int nNow = ACR_GetGameSecondsSinceStart();
    int nCombatActionTimestamp = GetLocalInt(oCreature, ACR_COMBAT_ACTION_TIMESTAMP);
    if(((nNow - nCombatActionTimestamp) < ACR_COMBAT_ACTION_COOLDOWN_TIME) &&
       (nCombatActionTimestamp != 0))
    {
        _NotifyCombatAction("You cannot switch combat modes yet. You must wait " + IntToString(ACR_COMBAT_ACTION_COOLDOWN_TIME) + " in between switches.", oCreature);
        return 0;
    }
    
    SetLocalInt(oCreature, ACR_COMBAT_ACTION_TIMESTAMP, nNow);
    
    return 1;
}

void _FightDefensively(object oCreature, int nACBonus, int nABPenalty) {

    if(GetWeaponRanged(GetItemInSlot(INVENTORY_SLOT_RIGHTHAND, oCreature))) {
        _NotifyCombatAction("You cannot fight defensively with a ranged weapon equiped.", oCreature);
    }
    
    _ClearCombatModes(oCreature);
    
    _NotifyCombatAction("You are now fighting defensively. You gain " + IntToString(nACBonus) + " AC and lose " + IntToString(nABPenalty) + " AB.", oCreature);

    ApplyEffectFromSource(
        ACR_EFFECT_SOURCE_COMBAT_ACTION,
        DURATION_TYPE_PERMANENT,
        EffectLinkEffects(ExtraordinaryEffect(EffectACIncrease(nACBonus)), ExtraordinaryEffect(EffectAttackDecrease(nABPenalty)))),
        oCreature
    );
}

void _NotifyCombatAction(string sMsg, object oCreature) {
    FloatingTextStringOnCreature(
        sMsg,
        oCreature,
        TRUE,
        6.0
    );
}

void _ClearCombatModes(object oCreature) {
    RemoveAllEffectsFromSource(oCreature, ACR_EFFECT_SOURCE_COMBAT_ACTION);
    _NotifyCombatAction("You are no longer fighting defensively.", oCreature);
}

void _HandlePowExpGUIEvent( object oPC, int nEvent, int nAmount ) {
    if(nEvent == POWER_EXPERT_EVENT_OPEN_MENU)
    {
        int bHasCE  = GetHasFeat(FEAT_ACR_COMBAT_EXPERTISE, oPC);
        int bHasPA  = GetHasFeat(FEAT_ACR_POWER_ATTACK, oPC);

        if(bHasCE)
        {
            SetGUIObjectHidden( oPC, "SCREEN_MODEBAR_2", "SHOW_CE_PAGE", FALSE );
            SetGUIObjectHidden( oPC, "SCREEN_MODEBAR_2", "CE_PAGE", FALSE );
        }
        else
        {
            SetGUIObjectHidden( oPC, "SCREEN_MODEBAR_2", "SHOW_CE_PAGE", TRUE );
            SetGUIObjectHidden( oPC, "SCREEN_MODEBAR_2", "CE_PAGE", TRUE );
        }
        if(bHasPA)
        {
            SetGUIObjectHidden( oPC, "SCREEN_MODEBAR_2", "SHOW_POW_PAGE", FALSE );
            SetGUIObjectHidden( oPC, "SCREEN_MODEBAR_2", "POW_PAGE", FALSE );
        }
        else
        {
            SetGUIObjectHidden( oPC, "SCREEN_MODEBAR_2", "SHOW_POW_PAGE", TRUE );
            SetGUIObjectHidden( oPC, "SCREEN_MODEBAR_2", "POW_PAGE", TRUE );
        }
    }
    if(nEvent == POWER_EXPERT_EVENT_COMBAT_EXPERTISE_MENU || nEvent == POWER_EXPERT_EVENT_OPEN_MENU)
    {
        int nBAB = GetBaseAttackBonus(oPC);
        int bHasCE  = GetHasFeat(FEAT_ACR_COMBAT_EXPERTISE, oPC);
        int bHasICE = GetHasFeat(FEAT_ACR_IMPROVED_COMBAT_EXPERTISE, oPC);

        ClearListBox(oPC, "SCREEN_MODEBAR_2", "CEBAR_GRID");

        if(nBAB >= 1 && bHasCE)
            SetGUIObjectHidden( oPC, "SCREEN_MODEBAR_2", "COMBAT_EXPERTISE_1", FALSE );
        else
            SetGUIObjectHidden( oPC, "SCREEN_MODEBAR_2", "COMBAT_EXPERTISE_1", TRUE );

        if(nBAB >= 2 && bHasCE)
            SetGUIObjectHidden( oPC, "SCREEN_MODEBAR_2", "COMBAT_EXPERTISE_2", FALSE );
        else
            SetGUIObjectHidden( oPC, "SCREEN_MODEBAR_2", "COMBAT_EXPERTISE_2", TRUE );

        if(nBAB >= 3 && bHasCE)
            SetGUIObjectHidden( oPC, "SCREEN_MODEBAR_2", "COMBAT_EXPERTISE_3", FALSE );
        else
            SetGUIObjectHidden( oPC, "SCREEN_MODEBAR_2", "COMBAT_EXPERTISE_3", TRUE );

        if(nBAB >= 4 && bHasCE)
            SetGUIObjectHidden( oPC, "SCREEN_MODEBAR_2", "COMBAT_EXPERTISE_4", FALSE );
        else
            SetGUIObjectHidden( oPC, "SCREEN_MODEBAR_2", "COMBAT_EXPERTISE_4", TRUE );

        if(nBAB >= 5 && bHasCE)
            SetGUIObjectHidden( oPC, "SCREEN_MODEBAR_2", "COMBAT_EXPERTISE_5", FALSE );
        else
            SetGUIObjectHidden( oPC, "SCREEN_MODEBAR_2", "COMBAT_EXPERTISE_5", TRUE );

        if(nBAB >= 6 && bHasICE)
            SetGUIObjectHidden( oPC, "SCREEN_MODEBAR_2", "COMBAT_EXPERTISE_6", FALSE );
        else
            SetGUIObjectHidden( oPC, "SCREEN_MODEBAR_2", "COMBAT_EXPERTISE_6", TRUE );

        if(nBAB >= 7 && bHasICE)
            SetGUIObjectHidden( oPC, "SCREEN_MODEBAR_2", "COMBAT_EXPERTISE_7", FALSE );
        else
            SetGUIObjectHidden( oPC, "SCREEN_MODEBAR_2", "COMBAT_EXPERTISE_7", TRUE );

        if(nBAB >= 8 && bHasICE)
            SetGUIObjectHidden( oPC, "SCREEN_MODEBAR_2", "COMBAT_EXPERTISE_8", FALSE );
        else
            SetGUIObjectHidden( oPC, "SCREEN_MODEBAR_2", "COMBAT_EXPERTISE_8", TRUE );

        if(nBAB >= 9 && bHasICE)
            SetGUIObjectHidden( oPC, "SCREEN_MODEBAR_2", "COMBAT_EXPERTISE_9", FALSE );
        else
            SetGUIObjectHidden( oPC, "SCREEN_MODEBAR_2", "COMBAT_EXPERTISE_9", TRUE );

        if(nBAB >= 10 && bHasICE)
            SetGUIObjectHidden( oPC, "SCREEN_MODEBAR_2", "COMBAT_EXPERTISE_10", FALSE );
        else
            SetGUIObjectHidden( oPC, "SCREEN_MODEBAR_2", "COMBAT_EXPERTISE_10", TRUE );

        int nMode = GetLocalInt(oPC, COMBAT_EXPERTISE_MODE_ACTIVE);
        if(nMode > 0)
        {
            string sMode = "OVERLAY_ICON_CE_"+IntToString(nMode);
            SetGUIObjectHidden( oPC, "SCREEN_MODEBAR_2", sMode, FALSE );
        }
    }
    else if(nEvent == POWER_EXPERT_EVENT_POWER_ATTACK_MENU || nEvent == POWER_EXPERT_EVENT_OPEN_MENU)
    {
        int nBAB = GetBaseAttackBonus(oPC);
        int bHasPA  = GetHasFeat(FEAT_ACR_POWER_ATTACK, oPC);
        int bHasIPA = GetHasFeat(FEAT_ACR_IMPROVED_POWER_ATTACK, oPC);

        ClearListBox(oPC, "SCREEN_MODEBAR_2", "POWBAR_GRID");

        if(nBAB >= 1 && bHasPA)
            SetGUIObjectHidden( oPC, "SCREEN_MODEBAR_2", "POWER_ATTACK_1", FALSE );
        else
            SetGUIObjectHidden( oPC, "SCREEN_MODEBAR_2", "POWER_ATTACK_1", TRUE );

        if(nBAB >= 2 && bHasPA)
            SetGUIObjectHidden( oPC, "SCREEN_MODEBAR_2", "POWER_ATTACK_2", FALSE );
        else
            SetGUIObjectHidden( oPC, "SCREEN_MODEBAR_2", "POWER_ATTACK_2", TRUE );

        if(nBAB >= 3 && bHasPA)
            SetGUIObjectHidden( oPC, "SCREEN_MODEBAR_2", "POWER_ATTACK_3", FALSE );
        else
            SetGUIObjectHidden( oPC, "SCREEN_MODEBAR_2", "POWER_ATTACK_3", TRUE );

        if(nBAB >= 4 && bHasPA)
            SetGUIObjectHidden( oPC, "SCREEN_MODEBAR_2", "POWER_ATTACK_4", FALSE );
        else
            SetGUIObjectHidden( oPC, "SCREEN_MODEBAR_2", "POWER_ATTACK_4", TRUE );

        if(nBAB >= 5 && bHasPA)
            SetGUIObjectHidden( oPC, "SCREEN_MODEBAR_2", "POWER_ATTACK_5", FALSE );
        else
            SetGUIObjectHidden( oPC, "SCREEN_MODEBAR_2", "POWER_ATTACK_5", TRUE );

        if(nBAB >= 6 && bHasIPA)
            SetGUIObjectHidden( oPC, "SCREEN_MODEBAR_2", "POWER_ATTACK_6", FALSE );
        else
            SetGUIObjectHidden( oPC, "SCREEN_MODEBAR_2", "POWER_ATTACK_6", TRUE );

        if(nBAB >= 7 && bHasIPA)
            SetGUIObjectHidden( oPC, "SCREEN_MODEBAR_2", "POWER_ATTACK_7", FALSE );
        else
            SetGUIObjectHidden( oPC, "SCREEN_MODEBAR_2", "POWER_ATTACK_7", TRUE );

        if(nBAB >= 8 && bHasIPA)
            SetGUIObjectHidden( oPC, "SCREEN_MODEBAR_2", "POWER_ATTACK_8", FALSE );
        else
            SetGUIObjectHidden( oPC, "SCREEN_MODEBAR_2", "POWER_ATTACK_8", TRUE );

        if(nBAB >= 9 && bHasIPA)
            SetGUIObjectHidden( oPC, "SCREEN_MODEBAR_2", "POWER_ATTACK_9", FALSE );
        else
            SetGUIObjectHidden( oPC, "SCREEN_MODEBAR_2", "POWER_ATTACK_9", TRUE );

        if(nBAB >= 10 && bHasIPA)
            SetGUIObjectHidden( oPC, "SCREEN_MODEBAR_2", "POWER_ATTACK_10", FALSE );
        else
            SetGUIObjectHidden( oPC, "SCREEN_MODEBAR_2", "POWER_ATTACK_10", TRUE );

        int nMode = GetLocalInt(oPC, POWER_ATTACK_MODE_ACTIVE);
        if(nMode > 0)
        {
            string sMode = "OVERLAY_ICON_PA_"+IntToString(nMode);
            SetGUIObjectHidden( oPC, "SCREEN_MODEBAR_2", sMode, FALSE );
        }
    }
    else if(nEvent == POWER_EXPERT_EVENT_COMBAT_EXPERTISE_TOGGLE)
    {
        if(!_TrySwitchModes(oPC)) return;
        int nOldMode = GetLocalInt(oPC, COMBAT_EXPERTISE_MODE_ACTIVE);
        int nNewMode = nAmount;
        if(nOldMode > 0)
        {
            string sMode = "OVERLAY_ICON_CE_"+IntToString(nOldMode);
            SetGUIObjectHidden( oPC, "SCREEN_MODEBAR_2", sMode, TRUE );
        }
        if(nNewMode == nOldMode)
        {
            FightNormally(oPC);
            DeleteLocalInt(oPC, COMBAT_EXPERTISE_MODE_ACTIVE);
        }
        else
        {
            string sMode = "OVERLAY_ICON_CE_"+IntToString(nNewMode);
            SetGUIObjectHidden( oPC, "SCREEN_MODEBAR_2", sMode, FALSE );
            SetLocalInt(oPC, COMBAT_EXPERTISE_MODE_ACTIVE, nNewMode);
            if(!GetLocalInt(oPC, POST_SPELLCAST_NO_COMBAT_MODE))
                FightWithExpertise(oPC, nNewMode);
        }
    }
    else if(nEvent == POWER_EXPERT_EVENT_POWER_ATTACK_TOGGLE)
    {
        if(!_TrySwitchModes(oPC)) return;
        int nOldMode = GetLocalInt(oPC, POWER_ATTACK_MODE_ACTIVE);
        int nNewMode = nAmount;
        if(nOldMode > 0)
        {
            string sMode = "OVERLAY_ICON_PA_"+IntToString(nOldMode);
            SetGUIObjectHidden( oPC, "SCREEN_MODEBAR_2", sMode, TRUE );
        }
        if(nNewMode == nOldMode)
        {
            SendMessageToPC(oPC, "Command to disable Power Attack received.");
            DeleteLocalInt(oPC, POWER_ATTACK_MODE_ACTIVE);
        }
        else
        {
            string sMode = "OVERLAY_ICON_PA_"+IntToString(nNewMode);
            SetGUIObjectHidden( oPC, "SCREEN_MODEBAR_2", sMode, FALSE );
            SetLocalInt(oPC, POWER_ATTACK_MODE_ACTIVE, nNewMode);
            SendMessageToPC(oPC, "Power Attack intensity set to "+IntToString(nAmount)+".");
        }
    }
}
