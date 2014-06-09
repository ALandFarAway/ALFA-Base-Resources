//Causes the PC to sit in the selected chair with a pose based on race and chair type. -KEMO
// called as the chair's OnUse script
// 9/28/08 - added GetIsDMPossessed option to resolve problem for DMs, fix suggested by Viconius

#include "acr_movement_i"

void main() 
{
    object oPC = GetExitingObject();
    if(GetIsObjectValid(oPC) && GetObjectType(oPC) == OBJECT_TYPE_CREATURE)
    {
        ACR_SetCollision(oPC,1);
        DestroyObject(OBJECT_SELF);
    }
}