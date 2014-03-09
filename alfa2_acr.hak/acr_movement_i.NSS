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
const int ACR_MOVEMENT_RECALCULATE = 7;

const string ACR_HORSE_OWNER = "ACR_HORSE_OWNER";
const string ACR_IS_WARHORSE = "ACR_IS_WARHORSE";

const string ACR_HORSE_PERS_LOC_AREA = "ACR_HORSE_PERS_LOC_AREA";
const string ACR_HORSE_PERS_LOC_X = "ACR_HORSE_PERS_LOC_X";
const string ACR_HORSE_PERS_LOC_Y = "ACR_HORSE_PERS_LOC_Y";
const string ACR_HORSE_PERS_LOC_Z = "ACR_HORSE_PERS_LOC_Z";
const string ACR_HORSE_OBJECT = "ACR_HORSE_OBJECT";
const string ACR_HORSE_ID = "ACR_HORSE_ID";

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
void CloakRemoved();

// Used to make oCreature dismount whatever horse it is on.
void Dismount(object oCreature);

// Used on area transition to determine if oCreature needs to dismount.
void MountAreaTransition(object oCreature);

// Used to check if movement rates need to change and correcting if so.
void RecalculateMovement(object oCreature);

// Used to verify that oHorse is indeed a horse who may be mounted
// by oCreature.
int GetIsHorseOwnedBy(object oHorse, object oCreature);

// Used to load and place horses
void HorseOnPCLoaded(object oPC);

// Used to look for horse objects when a PC acquires one, and spawn a
// horse if necessary.
void HorseOnAcquire();

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

void CloakRemoved()
{
  object oCreature = GetPCItemLastUnequippedBy();
  object oCloak = GetPCItemLastUnequipped();
  if(!GetIsObjectValid(oCloak)) return;
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
     GetStringLeft(GetTag(oHorse), 9) == "abr_cr_an_horse")
  {
    return TRUE;
  }
     
  if(GetLocalInt(oHorse, ACR_HORSE_OWNER) == ACR_GetCharacterID(oCreature))
  {
    return TRUE;
  }
  
  return FALSE;
}

void RecalculateMovement(object oCreature)
{
  ClearScriptParams();
  AddScriptParameterInt(ACR_MOVEMENT_RECALCULATE);
  AddScriptParameterObject(oCreature);
  ExecuteScriptEnhanced("ACR_Movement", oCreature, TRUE);
}

void SetHorseIsOwnedBy(object oHorse, object oCreature)
{
  if(GetObjectType(oHorse) != OBJECT_TYPE_CREATURE) return;
  if(GetObjectType(oCreature) != OBJECT_TYPE_CREATURE) return;
  if(!GetIsPC(oCreature)) return;
  
  SetLocalInt(oHorse, ACR_HORSE_OWNER, ACR_GetCharacterID(oCreature)); 
  SetLocalObject(oHorse, ACR_HORSE_OBJECT, oCreature);
}

void HorseOnPCLoaded(object oPC)
{
  object oCloak = GetItemInSlot(INVENTORY_SLOT_CLOAK, oPC);
  int nHorseId;
  if(GetIsObjectValid(oCloak))
  {
    nHorseId = GetLocalInt(oCloak, ACR_HORSE_ID); 
  }
  else
  {
    nHorseId = -1;
  }
  
  // 0 is wearing a cloak but not a horse. -1 is no cloak.
  // In these cases, we'll run through the movement calculations
  // just as a matter of cleanup.
  if(nHorseId <= 0)
  {
    RecalculateMovement(object oPC);
  }

  object oItem = GetFirstItemInInventory(oPC);
  while(GetIsObjectValid(oItem))
  {
    if(GetStringLeft(GetTag(oItem), 9) == "acr_horse")
    {
      if(GetLocalInt(oItem, ACR_HORSE_ID) != nHorseId) // make sure we're not already riding this horse
      {
        object oHorse = GetLocalObject(oItem, ACR_HORSE_OBJECT);
        if(!GetIsObjectValid(oHorse) || // make sure the horse isn't already spawned
           GetLocalObject(oHorse, ACR_HORSE_OBJECT) != oPC) // just in case the server reset; this might be a different thing with the same object Id.
        {
          string sResRef = "abr_cr_an_horse" + GetStringRight(GetTag(oItem), 2);
          location loc = Location(GetObjectByTag(GetLocalString(oItem, ACR_HORSE_PERS_LOC_AREA), 0),
                                  Vector(GetLocalFloat(oItem, ACR_HORSE_PERS_LOC_X),
                                        GetLocalFloat(oItem, ACR_HORSE_PERS_LOC_Y),
                                        GetLocalFloat(oItem, ACR_HORSE_PERS_LOC_Z)), 0.0f);
          if(!GetIsObjectValid(GetAreaFromLocation(loc))) loc = GetLocation(oPC);
          object oHorse = CreateObject(OBJECT_TYPE_CREATURE, sResRef, loc, TRUE, "");
          SetLocalInt(oHorse, ACR_HORSE_ID, GetLocalInt(oItem, ACR_HORSE_ID));
          SetLocalObject(oItem, ACR_HORSE_OBJECT, oHorse);
          SetHorseIsOwnedBy(oHorse, oPC);
        }
      }
    }
    oItem = GetNextItemInInventory(oPC);
  }
}

int _GetNewHorseId(object oPC)
{
  int nID = 1; // lowest ID is 1 so we can tell if a cloak is non-horse-related.
  object oItem = GetFirstItemInInventory(oPC);
  while(GetIsObjectValid(oItem))
  {
    int nNew = GetLocalInt(oItem, ACR_HORSE_ID);
    if(nNew > nID) nID = nNew;    
    oItem = GetNextItemInInventory(oPC);
  }
  nID++;
  return nID;
}

void HorseOnAcquire()
{
  object oItem = GetModuleItemAcquired();
  object oPC = GetModuleItemAcquiredBy();
  
  // If this isn't a PC, it's probably an NPC merchant. If it's a DM, we assume
  // it's just them managing a PC's horses (remember that NPCs can ride any horse)
  if(!GetIsPC(oPC)) return;
  if(GetIsDM(oPC) || GetIsDMPossessed(oPC)) return;
  
  // If this isn't a horse item, we don't care.
  if(GetStringLeft(GetTag(oItem), 9) != "acr_horse") return;
  
  // If the horse doesn't already exist, this needs to be initialized.
  object oHorse = GetLocalObject(oItem, ACR_HORSE_OBJECT);
  if(!GetIsObjectValid(oHorse))
  {
    string sResRef = "abr_cr_an_horse" + GetStringRight(GetTag(oItem), 2);
    oHorse = CreateObject(OBJECT_TYPE_CREATURE, sResRef, GetLocation(oPC), TRUE, "");
    SetLocalObject(oItem, ACR_HORSE_OBJECT, oHorse);
  }
  
  SetLocalInt(oItem, ACR_HORSE_ID, _GetNewHorseId(oPC));
  SetLocalInt(oHorse, ACR_HORSE_ID, GetLocalInt(oItem, ACR_HORSE_ID));
  SetHorseIsOwnedBy(oHorse, oPC);
}