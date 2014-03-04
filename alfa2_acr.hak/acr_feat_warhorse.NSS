#include "acr_movement_i"

void HandleSpellElapsed();

void main() 
{
  string sHorse = "abr_cr_an_horse_pal_";
  
  int nPalLevel = GetLevelByClass(CLASS_TYPE_PALADIN, OBJECT_SELF);
  
  if(nPalLevel >= 15) sHorse += "15";
  else if(nPalLevel >= 11) sHorse += "11";
  else if(nPalLevel >= 8) sHorse += "8";
  else if(nPalLevel >= 5) sHorse += "5";
  else
  {
    SendMessageToPC(OBJECT_SELF, "You don't seem to be a paladin. Why are you summoning a paladin's warhorse?");
  }
  
  object oHorse = CreateObject(OBJECT_TYPE_CREATURE, sHorse, GetLocation(OBJECT_SELF), FALSE, "");
  AddHenchman(OBJECT_SELF, oHorse);
  SetLocalInt(oHorse, ACR_IS_WARHORSE, 1);
  
  float fDuration = HoursToSeconds(nPalLevel) * 2;
  DelayCommand(fDuration, HandleSpellElapsed());
}

void HandleSpellElapsed()
{
  int nCount = 0;
  object oHench = GetHenchman(OBJECT_SELF, nCount);
  
  Dismount(OBJECT_SELF);
  
  while(GetIsObjectValid(oHench))
  {
    if(GetStringLeft(GetTag(oHench), 20) == "abr_cr_an_horse_pal_")
    {
      DestroyObject(oHench, 0.0f, FALSE);
      return;
    }
    nCount++;
    oHench = GetHenchman(OBJECT_SELF, nCount);
  }
}