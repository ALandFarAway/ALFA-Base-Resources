#include "acr_movement_i"

const string ACR_HORSE_FOLLOWING = "ACR_HORSE_FOLLOWING";

void FollowHeartbeat(object oPC)
{
    if (GetArea(oPC)!=GetArea(OBJECT_SELF))
    {
        ClearAllActions(TRUE);
        JumpToLocation(GetLocation(oPC));
    }
    else if (GetDistanceBetween(oPC, OBJECT_SELF) > 10.0)
    {
        ClearAllActions(TRUE);
        ActionForceFollowObject(oPC);
    }
    if(GetLocalInt(OBJECT_SELF, ACR_HORSE_FOLLOWING))
      DelayCommand(6.0f, FollowHeartbeat(oPC));
}


void main()
{
  object oPC = GetLocalObject(OBJECT_SELF, ACR_HORSE_OBJECT);
  if(GetArea(oPC) == GetArea(OBJECT_SELF))
  {
      if(GetLocalInt(OBJECT_SELF, ACR_HORSE_FOLLOWING) > 0)
      {
          SendMessageToPC(oPC, GetName(OBJECT_SELF) + " will no longer follow you.");
          DeleteLocalInt(OBJECT_SELF, ACR_HORSE_FOLLOWING);
      }
      else
      {
          SendMessageToPC(oPC, GetName(OBJECT_SELF) + " will now follow you.");
          SetLocalInt(OBJECT_SELF, ACR_HORSE_FOLLOWING, ACR_GetCharacterID(oPC));
          FollowHeartbeat(oPC);
      }
  }
  ExecuteScript("acf_cre_onconversation", OBJECT_SELF);
}
