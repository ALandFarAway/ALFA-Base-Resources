#include "acr_movement_i"

const string ACR_HORSE_FOLLOWING = "ACR_HORSE_FOLLOWING";

void FollowHeartbeat(object oPC)
{
    object Item = GetOwnershipItemById(oPC, GetLocalInt(OBJECT_SELF, ACR_HORSE_ID));
    SetLocalString(Item, ACR_HORSE_PERS_LOC_AREA, GetTag(GetArea(OBJECT_SELF)));
    SetLocalFloat(Item, ACR_HORSE_PERS_LOC_X, GetPosition(OBJECT_SELF).x);
    SetLocalFloat(Item, ACR_HORSE_PERS_LOC_Y, GetPosition(OBJECT_SELF).y);
    SetLocalFloat(Item, ACR_HORSE_PERS_LOC_Z, GetPosition(OBJECT_SELF).z);
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
          object Item = GetOwnershipItemById(oPC, GetLocalInt(OBJECT_SELF, ACR_HORSE_ID));
          SetLocalString(Item, ACR_HORSE_PERS_LOC_AREA, GetTag(GetArea(OBJECT_SELF)));
          SetLocalFloat(Item, ACR_HORSE_PERS_LOC_X, GetPosition(OBJECT_SELF).x);
          SetLocalFloat(Item, ACR_HORSE_PERS_LOC_Y, GetPosition(OBJECT_SELF).y);
          SetLocalFloat(Item, ACR_HORSE_PERS_LOC_Z, GetPosition(OBJECT_SELF).z);
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
