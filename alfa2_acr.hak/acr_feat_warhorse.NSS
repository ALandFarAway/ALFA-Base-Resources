#include "acr_movement_i"

void HandleSpellElapsed();

void main() 
{
  string sHorse = "abr_cr_an_horse_pal_";
  
  object oWarHorse = GetLocalObject(OBJECT_SELF, ACR_PAL_WARHORSE);
  if(GetIsObjectValid(oWarHorse))
  {
    SendMessageToPC(OBJECT_SELF, "You have already called your paladin warhorse.");
    return;
  }
   
  int nPalLevel = GetLevelByClass(CLASS_TYPE_PALADIN, OBJECT_SELF);
  
  if(nPalLevel >= 15) sHorse += "15";
  else if(nPalLevel >= 11) sHorse += "11";
  else if(nPalLevel >= 8) sHorse += "8";
  else if(nPalLevel >= 5) sHorse += "5";
  else
  {
    SendMessageToPC(OBJECT_SELF, "You don't seem to be a paladin. Why are you calling a paladin's warhorse?");
    return;
  }
  
  object oHorse = CreateObject(OBJECT_TYPE_CREATURE, sHorse, GetLocation(OBJECT_SELF), FALSE, "");
  AddHenchman(OBJECT_SELF, oHorse);
  SetHorseIsOwnedBy(oHorse, OBJECT_SELF);
  SetLocalInt(oHorse, ACR_IS_WARHORSE, 1);
  SetLocalObject(OBJECT_SELF, ACR_PAL_WARHORSE, oHorse);
  
  float fDuration = HoursToSeconds(nPalLevel) * 2;
  DelayCommand(fDuration, HandleSpellElapsed());
}

void HandleSpellElapsed()
{ 
  object oCloak = GetItemInSlot(INVENTORY_SLOT_CLOAK, OBJECT_SELF);
  if(GetLocalInt(oCloak, ACR_IS_WARHORSE))
  {
    Dismount(OBJECT_SELF);
  }
  
  object oWarHorse = GetLocalObject(OBJECT_SELF, ACR_PAL_WARHORSE);
  if(GetIsObjectValid(oWarHorse))
  {
    DestroyObject(oWarHorse);
  }
}
