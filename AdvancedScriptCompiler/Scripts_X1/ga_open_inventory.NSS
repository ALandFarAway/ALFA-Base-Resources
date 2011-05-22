//ga_open_inventory(string sCreatureTag)
/*
    opens the inventory panel of the creature
*/
// ChazM 3/8/07

#include "ginc_param_const"

void main(string sCreatureTag)
{
	object oPC = (GetPCSpeaker()==OBJECT_INVALID?OBJECT_SELF:GetPCSpeaker());
    object oCreature = GetTarget(sCreatureTag);
    PrettyDebug("Displaying inventory of " + GetName(oCreature));
    OpenInventory(oCreature, oPC);
}