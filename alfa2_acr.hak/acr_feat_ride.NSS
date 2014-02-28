#include "acr_movement_i"

void main() 
{
	object oTarget = GetSpellTargetObject();
	
	if(oTarget == OBJECT_SELF)
	{
    Dismount(OBJECT_SELF);
	}
	else
	{
    if(GetIsHorseOwnedBy(oTarget, OBJECT_SELF))
    {
      MountHorse(oTarget, OBJECT_SELF);
    }
	}
}