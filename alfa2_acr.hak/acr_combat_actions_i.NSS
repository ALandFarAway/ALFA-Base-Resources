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

const string POWER_ATTACK_MODE_ACTIVE     = "POWER_ATTACK_MODE_ACTIVE";
const string COMBAT_EXPERTISE_MODE_ACTIVE = "COMBAT_EXPERTISE_MODE_ACTIVE";

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
    if((ACR_GetGameSecondsSinceStart() - GetLocalInt(oCreature, ACR_COMBAT_ACTION_TIMESTAMP)) < ACR_COMBAT_ACTION_COOLDOWN_TIME) {
        _NotifyCombatAction("You cannot switch combat modes yet. You must wait " + IntToString(ACR_COMBAT_ACTION_COOLDOWN_TIME) + " in between switches.", oCreature);
        return 0;
    }
    
    SetLocalInt(oCreature, ACR_COMBAT_ACTION_TIMESTAMP, ACR_GetGameSecondsSinceStart());
    
    return 1;
}

void _FightDefensively(object oCreature, int nACBonus, int nABPenalty) {

    if(IPGetIsRangedWeapon(GetItemInSlot(INVENTORY_SLOT_RIGHTHAND, oCreature))) {
        _NotifyCombatAction("You cannot fight defensively with a ranged weapon equiped.", oCreature);
    }
    
    _ClearCombatModes(oCreature);
    
    _NotifyCombatAction("You are now fighting defensively. You gain " + IntToString(nACBonus) + " AC and lose " + IntToString(nABPenalty) + " AB.", oCreature);

    ApplyEffectFromSource(
        ACR_EFFECT_SOURCE_COMBAT_ACTION,
        DURATION_TYPE_PERMANENT,
        ExtraordinaryEffect(EffectLinkEffects(EffectACIncrease(nACBonus), EffectAttackDecrease(nABPenalty))),
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
