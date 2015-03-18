#include "acr_quest_i"

void main()
{
  int transitionTarget = -1;
  string tag = GetTag(OBJECT_SELF);

  if(tag == "DOOR_NORTH") transitionTarget = ACR_QST_CLR_COMMAND_DUNG_GO_NORTH;
  else if(tag == "DOOR_EAST") transitionTarget = ACR_QST_CLR_COMMAND_DUNG_GO_EAST;
  else if(tag == "DOOR_SOUTH") transitionTarget = ACR_QST_CLR_COMMAND_DUNG_GO_SOUTH;
  else if(tag == "DOOR_WEST") transitionTarget = ACR_QST_CLR_COMMAND_DUNG_GO_WEST;
  else if(tag == "DOOR_UP") transitionTarget = ACR_QST_CLR_COMMAND_DUNG_GO_UP;
  else if(tag == "DOOR_DOWN") transitionTarget = ACR_QST_CLR_COMMAND_DUNG_GO_DOWN;

  SendCreatureThroughDungeonTransition(GetClickingObject(), GetLocalString(GetArea(OBJECT_SELF), "DUNGEON_NAME"), transitionTarget);
}