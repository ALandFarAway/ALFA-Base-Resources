#include "acr_movement_i"

void main()
{
  RemoveHorseOwnership(OBJECT_SELF);
  
  ExecuteScript("acf_cre_ondeath", OBJECT_SELF);
}
