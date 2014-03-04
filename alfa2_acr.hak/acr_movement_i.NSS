////////////////////////////////////////////////////////////////////////////////
//
//  System Name : ALFA Core Rules
//     Filename : acr_movement_i
//       Author : Zelknolf
//
//  Description
//  This library is intended for use with ALFA's systems of custom movement, such
//  as swimming, horses, or the overland map.
//
////////////////////////////////////////////////////////////////////////////////

#include "acr_pps_i"

////////////////////////////////////////////////////////////////////////////////
// Constants ///////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////

const int ACR_MOVEMENT_ENTER_WATER = 0;
const int ACR_MOVEMENT_EXIT_WATER = 1;
const int ACR_MOVEMENT_MOUNT_HORSE = 2;
const int ACR_MOVEMENT_CLOAK_REMOVED = 3;
const int ACR_MOVEMENT_ENTER_OLM = 4;
const int ACR_MOVEMENT_EXIT_OLM = 5;
const int ACR_MOVEMENT_DISMOUNT = 6;

const string ACR_HORSE_OWNER = "ACR_HORSE_OWNER";
const string ACR_IS_WARHORSE = "ACR_IS_WARHORSE";

////////////////////////////////////////////////////////////////////////////////
// Structures //////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////

////////////////////////////////////////////////////////////////////////////////
// Global Variables ////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////

////////////////////////////////////////////////////////////////////////////////
// Function Prototypes /////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////

// Used to indicate that a swimmer has entered the water.
void EnterWater(object oTrigger, object oCreature);

// Used to indicate that a swimmer has left the water.
void ExitWater(object oTrigger, object oCreature);

// Used to make oCreature mount oHorse
void MountHorse(object oHorse, object oCreature);

// Called when a cloak is unequipped, to see if that was the horse
// object, and to interpret as a command to dismount if so.
void CloakRemoved(object oCreature);

// Used to make oCreature dismount whatever horse it is on.
void Dismount(object oCreature);

// Used on area transition to determine if oCreature needs to dismount.
void MountAreaTransition(object oCreature);

// Used to verify that oHorse is indeed a horse who may be mounted
// by oCreature.
int GetIsHorseOwnedBy(object oHorse, object oCreature);

////////////////////////////////////////////////////////////////////////////////
// Includes ////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////

////////////////////////////////////////////////////////////////////////////////
// Function Definitions ////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////

void EnterWater(object oTrigger, object oCreature)
{
  ClearScriptParams();
  AddScriptParameterInt(ACR_MOVEMENT_ENTER_WATER);
  AddScriptParameterObject(oCreature);
  ExecuteScriptEnhanced("ACR_Movement", oTrigger, TRUE);
}

void ExitWater(object oTrigger, object oCreature)
{
  ClearScriptParams();
  AddScriptParameterInt(ACR_MOVEMENT_ENTER_WATER);
  AddScriptParameterObject(oCreature);
  ExecuteScriptEnhanced("ACR_Movement", oTrigger, TRUE);
}

void MountHorse(object oHorse, object oCreature)
{
  ClearScriptParams();
  AddScriptParameterInt(ACR_MOVEMENT_MOUNT_HORSE);
  AddScriptParameterObject(oCreature);
  ExecuteScriptEnhanced("ACR_Movement", oHorse, TRUE);
}

void CloakRemoved(object oCreature)
{
  object oCloak = GetPCItemLastUnequipped();
  if(!GetIsObjectValid(oCloak)) return; // no cloak; must not be mounted.
  else
  {
    string sTag = GetTag(oCloak);
    if(GetStringLeft(sTag, 13) == "acr_ooc_horse")
    {
      ClearScriptParams();
      AddScriptParameterInt(ACR_MOVEMENT_MOUNT_HORSE);
      AddScriptParameterObject(oCreature);
      ExecuteScriptEnhanced("ACR_Movement", oCreature, TRUE);
    }
  }
}

void Dismount(object oCreature)
{
  ClearScriptParams();
  AddScriptParameterInt(ACR_MOVEMENT_DISMOUNT);
  AddScriptParameterObject(oCreature);
  ExecuteScriptEnhanced("ACR_Movement", oCreature, TRUE);
}

void MountAreaTransition(object oCreature)
{
  object oCloak = GetItemInSlot(INVENTORY_SLOT_CLOAK, oCreature);
  if(!GetIsObjectValid(oCloak)) return; // no cloak; must not be mounted.
  else
  {
    string sTag = GetTag(oCloak);
    if(GetStringLeft(sTag, 13) == "acr_ooc_horse")
    {
      Dismount(oCreature);
    }
  }
}

int GetIsHorseOwnedBy(object oHorse, object oCreature)
{
  if(GetObjectType(oHorse) != OBJECT_TYPE_CREATURE) return FALSE;
  if(GetObjectType(oCreature) != OBJECT_TYPE_CREATURE) return FALSE;
  
  if((GetIsDM(oCreature) ||
     GetIsDMPossessed(oCreature) ||
     !GetIsPC(oCreature)) &&
     GetStringLeft(GetTag(oHorse), 9) == "acr_horse")
  {
    return TRUE;
  }
     
  if(GetLocalInt(oHorse, ACR_HORSE_OWNER) == ACR_GetCharacterID(oCreature))
  {
    return TRUE;
  }
  
  return FALSE;
}

void SetHorseIsOwnedBy(object oHorse, object oCreature)
{
  if(GetObjectType(oHorse) != OBJECT_TYPE_CREATURE) return;
  if(GetObjectType(oCreature) != OBJECT_TYPE_CREATURE) return;
  if(!GetIsPC(oCreature)) return;
  
  SetLocalInt(oHorse, ACR_HORSE_OWNER, ACR_GetCharacterID(oCreature));
  
}