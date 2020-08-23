////////////////////////////////////////////////////////////////////////////////
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
const int ACR_MOVEMENT_RESTORE_HORSE = 8;

const string ACR_HORSE_OWNER = "ACR_HORSE_OWNER";
const string ACR_IS_WARHORSE = "ACR_IS_WARHORSE";
const string ACR_PAL_WARHORSE = "ACR_PAL_WARHORSE";
const string ACR_HORSE_PERS_LOC_AREA = "ACR_HORSE_PERS_LOC_AREA";
const string ACR_HORSE_PERS_LOC_X = "ACR_HORSE_PERS_LOC_X";
const string ACR_HORSE_PERS_LOC_Y = "ACR_HORSE_PERS_LOC_Y";
const string ACR_HORSE_PERS_LOC_Z = "ACR_HORSE_PERS_LOC_Z";
const string ACR_HORSE_OBJECT = "ACR_HORSE_OBJECT";
const string ACR_HORSE_ID = "ACR_HORSE_ID";
const string ACR_HORSE_SUMMONED = "ACR_HORSE_SUMMONED";

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

// Set a creature's movement rate to be appropriate for an
// overland map.
void ToOverlandMap(object oCreature);

// Restore that creature's movement rate to that of a regular
// walking person.
void FromOverlandMap(object oCreature);

// Used on area transition to determine if oCreature needs to dismount, when traveling to oTargetArea.
void MountAreaTransitionWithTarget(object oCreature, object oTargetArea);

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

// Used to clean up horses in play.
void HorseOnExit(object oPC);

// Find the item that tracks the ownership of a horse with nHorseId
object GetOwnershipItemById(object oPC, int nHorseId);

// Set collision without changing DMs.
void ACR_SetCollision( object oObject, int bCollide );

// Destroy a horse and object owned by a PC
void DestroyHorse(object oPC, object oHorseTool);

////////////////////////////////////////////////////////////////////////////////
// Includes ////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////

////////////////////////////////////////////////////////////////////////////////
// Function Definitions ////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////

void _CallToMovement(int nCommand, object oTarget, object oRunOn)
{
  ClearScriptParams();
  AddScriptParameterInt(nCommand);
  AddScriptParameterObject(oTarget);
  ExecuteScriptEnhanced("ACR_Movement", oRunOn, TRUE);
}

void EnterWater(object oTrigger, object oCreature)
{
  _CallToMovement(ACR_MOVEMENT_ENTER_WATER, oCreature, oTrigger);
}

void ExitWater(object oTrigger, object oCreature)
{
  _CallToMovement(ACR_MOVEMENT_EXIT_WATER, oCreature, oTrigger);
}

void MountHorse(object oHorse, object oCreature)
{
  _CallToMovement(ACR_MOVEMENT_MOUNT_HORSE, oCreature, oHorse);
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
      Dismount(oCreature);
    }
  }
}

void Dismount(object oCreature)
{
  _CallToMovement(ACR_MOVEMENT_DISMOUNT, oCreature, oCreature);
}

void ToOverlandMap(object oCreature)
{
  _CallToMovement(ACR_MOVEMENT_ENTER_OLM, oCreature, oCreature);
}

void FromOverlandMap(object oCreature)
{
  _CallToMovement(ACR_MOVEMENT_EXIT_OLM, oCreature, oCreature);
}

void MountAreaTransitionWithTarget(object oCreature, object oTargetArea)
{
  object oCloak = GetItemInSlot(INVENTORY_SLOT_CLOAK, oCreature);
  if(!GetIsObjectValid(oCloak)) return; // no cloak; must not be mounted.
  if(!GetIsPC(oCreature)) return;
  else
  {
    if(!GetIsObjectValid(oTargetArea)) return; // no target area; no sense in dismounting for a broken AT
    if(!GetIsAreaInterior(oTargetArea)) return; // target area is another exterior; no need to dismount.
    string sTag = GetTag(oCloak);
    if(GetStringLeft(sTag, 13) == "acr_ooc_horse")
    {
      Dismount(oCreature);
    }
  }
}

void MountAreaTransition(object oCreature)
{
    object oTargetArea = GetTransitionTarget(OBJECT_SELF);
    MountAreaTransitionWithTarget(oCreature, oTargetArea);
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
  _CallToMovement(ACR_MOVEMENT_RECALCULATE, oCreature, oCreature);
}

void RestoreHorse(object oCreature)
{
  _CallToMovement(ACR_MOVEMENT_RESTORE_HORSE, oCreature, oCreature);
}

void SetHorseIsOwnedBy(object oHorse, object oCreature)
{
  if(GetObjectType(oHorse) != OBJECT_TYPE_CREATURE) return;
  if(GetObjectType(oCreature) != OBJECT_TYPE_CREATURE) return;
  if(!GetIsPC(oCreature)) return;
  
  SetLocalInt(oHorse, ACR_HORSE_OWNER, ACR_GetCharacterID(oCreature)); 
  SetLocalObject(oHorse, ACR_HORSE_OBJECT, oCreature);
}

void RemoveHorseOwnership(object oHorse)
{
  object oOwner = GetLocalObject(oHorse, ACR_HORSE_OBJECT);
  if(!GetIsObjectValid(oOwner)) return; // no owner; probably spawned by a DM.
  
  object oItem = GetFirstItemInInventory(oOwner);
  while(GetIsObjectValid(oItem))
  {
    if(OBJECT_SELF == GetLocalObject(oItem, ACR_HORSE_OBJECT))
    {
      DestroyObject(oItem); 
      return; // assume one ownership item per horse. If more than one exists, the PC 
              // owns two horses and we should let the other start spawning things.
    }
    oItem = GetNextItemInInventory(oOwner);
  }
}

void _MakeHorse(object oItem, object oPC)
{
  string sResRef = "abr_cr_an_horse" + GetStringRight(GetTag(oItem), 2);
  location loc = Location(GetObjectByTag(GetLocalString(oItem, ACR_HORSE_PERS_LOC_AREA), 0),
                          Vector(GetLocalFloat(oItem, ACR_HORSE_PERS_LOC_X),
                                GetLocalFloat(oItem, ACR_HORSE_PERS_LOC_Y),
                                GetLocalFloat(oItem, ACR_HORSE_PERS_LOC_Z)), 0.0f);
  if(!GetIsObjectValid(GetAreaFromLocation(loc))) loc = GetLocation(oPC);
  if(!GetIsObjectValid(GetAreaFromLocation(loc))) 
  {
    DelayCommand(6.0f, _MakeHorse(oItem, oPC));
    return;
  }
  object oHorse = CreateObject(OBJECT_TYPE_CREATURE, sResRef, loc, TRUE, "");
  SetLocalInt(oHorse, ACR_HORSE_ID, GetLocalInt(oItem, ACR_HORSE_ID));
  SetLocalObject(oItem, ACR_HORSE_OBJECT, oHorse);
  SetHorseIsOwnedBy(oHorse, oPC);
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
    RecalculateMovement(oPC);
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
          DelayCommand(6.0f, _MakeHorse(oItem, oPC));
        }
      }
      else
      {
        RestoreHorse(oPC);
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
  
  if(GetLocalInt(oItem, ACR_HORSE_OWNER) == ACR_GetCharacterID(oPC))
  {
    // This is the OnAcquire event that you get on first login, or the 
    // character dropped and picked back up the horse ownership item.
    return;
  }
  
  // If the horse doesn't already exist, this needs to be initialized.
  object oHorse = GetLocalObject(oItem, ACR_HORSE_OBJECT);
  if(!GetIsObjectValid(oHorse))
  {
    string sResRef = "abr_cr_an_horse" + GetStringRight(GetTag(oItem), 2);
    oHorse = CreateObject(OBJECT_TYPE_CREATURE, sResRef, GetLocation(oPC), TRUE, "");
    SetLocalObject(oItem, ACR_HORSE_OBJECT, oHorse);
  }
  
  SetLocalInt(oItem, ACR_HORSE_OWNER, ACR_GetCharacterID(oPC));
  SetLocalInt(oItem, ACR_HORSE_ID, _GetNewHorseId(oPC));
  SetLocalInt(oHorse, ACR_HORSE_ID, GetLocalInt(oItem, ACR_HORSE_ID));
  SetHorseIsOwnedBy(oHorse, oPC);
}

void HorseOnExit(object oPC)
{
  object oItem = GetFirstItemInInventory(oPC);
  while(GetIsObjectValid(oItem))
  {
    object oHorse = GetLocalObject(oItem, ACR_HORSE_OBJECT);
    if(GetIsObjectValid(oHorse) && 
       !GetIsPC(oHorse) && 
       GetLocalObject(oHorse, ACR_HORSE_OBJECT) == oPC)
    {
      DestroyObject(oHorse);
    }
    oItem = GetNextItemInInventory(oPC);
  }
  
  object oWarHorse = GetLocalObject(oPC, ACR_PAL_WARHORSE);
  if(GetIsObjectValid(oWarHorse))
  {
    DestroyObject(oWarHorse);
  }
}

void SaveHorseLocation(object oPC)
{
  object oItem = GetFirstItemInInventory(oPC);
  while(GetIsObjectValid(oItem))
  {
    if(GetStringLeft(GetTag(oItem), 9) == "acr_horse")
    {
      object oHorse = GetLocalObject(oItem, ACR_HORSE_OBJECT);
      if(GetIsObjectValid(oHorse))
      {
        vector pos = GetPosition(oHorse);
        SetLocalString(oItem, ACR_HORSE_PERS_LOC_AREA, GetTag(GetArea(oHorse)));
        SetLocalFloat(oItem, ACR_HORSE_PERS_LOC_X, pos.x);
        SetLocalFloat(oItem, ACR_HORSE_PERS_LOC_Y, pos.y);
        SetLocalFloat(oItem, ACR_HORSE_PERS_LOC_Z, pos.z);
      }
    }
    oItem = GetNextItemInInventory(oPC);
  }
}

object GetOwnershipItemById(object oPC, int nHorseId)
{
  object item = GetFirstItemInInventory(oPC);
  while(GetIsObjectValid(item) == TRUE)
  {
    if(GetLocalInt(item, ACR_HORSE_ID) == nHorseId)
    {
      return item;
    }
    item = GetNextItemInInventory(oPC);
  }
  return OBJECT_INVALID;
}

void ACR_SetCollision( object oObject, int bCollide ) {
	if ( GetIsDM( oObject ) ) return;
	SetCollision( oObject, bCollide );
}

void DestroyHorse(object oPC, object oHorseTool)
{
  object oHorse;
  if (GetIsObjectValid(oPC)) {
    Dismount(oPC);
  }

  oHorse = GetLocalObject(oHorseTool, ACR_HORSE_OBJECT);
  RemoveHorseOwnership(oHorse);

  DestroyObject(oHorse, 0.1);
  DestroyObject(oHorseTool, 0.1);
}
