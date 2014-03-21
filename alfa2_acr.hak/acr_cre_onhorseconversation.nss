#include "acr_movement_i"

const string ACR_HORSE_FOLLOWING = "ACR_HORSE_FOLLOWING";

void FollowHeartbeat(object oPC)
{
    if (GetDistanceBetween(oPC, OBJECT_SELF) > 10.0)
    {
        ClearAllActions(TRUE);
        ActionForceFollowObject(oPC);
    }
    else if (GetArea(oPC)!=GetArea(OBJECT_SELF))
    {
        ClearAllActions(TRUE);
        JumpToObject(oPC);
    }
    DelayCommand(6.0f, FollowHeartbeat(oPC));
}


void main()
{
  object oPC = GetPCSpeaker();
  int nID = ACR_GetCharacterID(oPC);
  if(GetLocalInt(OBJECT_SELF, ACR_HORSE_OWNER) == nID)
  {
      if(GetLocalInt(OBJECT_SELF, ACR_HORSE_FOLLOWING) > 0)
      {
          SendMessageToPC(oPC, GetName(OBJECT_SELF) + " will no longer follow you.");
          DeleteLocalInt(OBJECT_SELF, ACR_HORSE_FOLLOWING);
      }
      else
      {
          SendMessageToPC(oPC, GetName(OBJECT_SELF) + " will now follow you.");
          SetLocalInt(OBJECT_SELF, ACR_HORSE_FOLLOWING, nID);
          FollowHeartbeat(oPC);
      }
  }
  ExecuteScript("acf_cre_onconversation", OBJECT_SELF);
}
