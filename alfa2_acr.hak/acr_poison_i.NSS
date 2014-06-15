////////////////////////////////////////////////////////////////////////////////
//
//  System Name : ACR Poison System
//     Filename : acr_poison_i
//      Version : 1.0
//         Date : 2013-02-01
//       Author : FoamBats4All
//
//  Local Variable Prefix = ACR_PSN
//
//  Description
//    This script contains functions related to ALFA's poison delivery system.
//
////////////////////////////////////////////////////////////////////////////////

#ifndef ACR_POISON_I
#define ACR_POISON_I


////////////////////////////////////////////////////////////////////////////////
// Constants ///////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////

const string ACR_PSN_LVAR_SCRIPT_IMPACT = "acr_psn_script_impact";
const string ACR_PSN_LVAR_SCRIPT_APPLIED = "acr_psn_script_applied";
const string ACR_PSN_LVAR_SCRIPT_INCUBATED= "acr_psn_script_incubated";

const string ACR_PSN_PRIMARY_ABILITY_TO_DAMAGE = "ACR_PSN_PRIMARY_ABILITY_TO_DAMAGE";
const string ACR_PSN_PRIMARY_ABILITY_DICE_TYPE = "ACR_PSN_PRIMARY_ABILITY_DICE_TYPE";
const string ACR_PSN_PRIMARY_ABILITY_DICE_NUM = "ACR_PSN_PRIMARY_ABILITY_DICE_NUM";
const string ACR_PSN_SECONDARY_ABILITY_TO_DAMAGE = "ACR_PSN_SECONDARY_ABILITY_TO_DAMAGE";
const string ACR_PSN_SECONDARY_ABILITY_DICE_TYPE = "ACR_PSN_SECONDARY_ABILITY_DICE_TYPE";
const string ACR_PSN_SECONDARY_ABILITY_DICE_NUM = "ACR_PSN_SECONDARY_ABILITY_DICE_NUM";

////////////////////////////////////////////////////////////////////////////////
// Function Prototypes /////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////

// Manage poison's initial effect, assuming no information provided.
void ApplyPoisonInitialEffect();

// Manage poison's secondary effect, assuming that the primary effect has previously
// fired.
void ApplyPoisonSecondaryEffect();

// A simple wrapper for poison-based ability damage.
void ApplyPoisonAbilityDamage(object oTarget, int nAbilityScore, int nDamage);

////////////////////////////////////////////////////////////////////////////////
// Includes ////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////


////////////////////////////////////////////////////////////////////////////////
// Function Definitions ////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////

void ApplyPoisonInitialEffect()
{
  object oAttacker = GetLastHostileActor(OBJECT_SELF);
  object oWeapon = GetLastWeaponUsed(oAttacker);
  
  if(!GetIsObjectValid(oWeapon)) return;
  
  int nAbility = GetLocalInt(oWeapon, ACR_PSN_PRIMARY_ABILITY_TO_DAMAGE);
  int nDiceType = GetLocalInt(oWeapon, ACR_PSN_PRIMARY_ABILITY_DICE_TYPE);
  int nDiceNum = GetLocalInt(oWeapon, ACR_PSN_PRIMARY_ABILITY_DICE_NUM);
  
  int nFinalDamage = 0;
  while(nDiceNum > 0)
  {
    nFinalDamage = Random(nDiceType) + 1;
    nDiceNum--;
  }  
  if(nFinalDamage < 1) nFinalDamage = 1;
  
  ApplyPoisonAbilityDamage(OBJECT_SELF, nAbility, nFinalDamage);
  
  SetLocalInt(OBJECT_SELF, ACR_PSN_SECONDARY_ABILITY_TO_DAMAGE, GetLocalInt(oWeapon, ACR_PSN_SECONDARY_ABILITY_TO_DAMAGE));
  SetLocalInt(OBJECT_SELF, ACR_PSN_SECONDARY_ABILITY_DICE_TYPE, GetLocalInt(oWeapon, ACR_PSN_SECONDARY_ABILITY_DICE_TYPE));
  SetLocalInt(OBJECT_SELF, ACR_PSN_SECONDARY_ABILITY_DICE_NUM, GetLocalInt(oWeapon, ACR_PSN_SECONDARY_ABILITY_DICE_NUM));
}

void ApplyPoisonSecondaryEffect()
{
  int nAbility = GetLocalInt(OBJECT_SELF, ACR_PSN_SECONDARY_ABILITY_TO_DAMAGE);
  int nDiceType = GetLocalInt(OBJECT_SELF, ACR_PSN_SECONDARY_ABILITY_DICE_TYPE);
  int nDiceNum = GetLocalInt(OBJECT_SELF, ACR_PSN_SECONDARY_ABILITY_DICE_NUM);
  
  int nFinalDamage = 0;
  while(nDiceNum > 0)
  {
    nFinalDamage = Random(nDiceType) + 1;
    nDiceNum--;
  }  
  if(nFinalDamage < 1) nFinalDamage = 1;
  
  ApplyPoisonAbilityDamage(OBJECT_SELF, nAbility, nFinalDamage);
  
  DeleteLocalInt(OBJECT_SELF, ACR_PSN_SECONDARY_ABILITY_TO_DAMAGE);
  DeleteLocalInt(OBJECT_SELF, ACR_PSN_SECONDARY_ABILITY_DICE_TYPE);
  DeleteLocalInt(OBJECT_SELF, ACR_PSN_SECONDARY_ABILITY_DICE_NUM);
}

void ApplyPoisonAbilityDamage(object oTarget, int nAbilityScore, int nDamage)
{
  // TODO: Figure out a way around Death Ward
  ApplyEffectToObject(DURATION_TYPE_PERMANENT, ExtraordinaryEffect(EffectAbilityDecrease(nAbilityScore, nDamage)), oTarget, 0.0f);
}
#endif