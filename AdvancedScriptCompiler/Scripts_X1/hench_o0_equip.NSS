/*

    Companion and Monster AI

    Equips best weapon in general (not against specific target, used for weapon equipping outside of combat

*/

#include "hench_i0_equip"


void main()
{
	int bShowStatus = GetLocalInt(OBJECT_SELF, sHenchShowWeaponStatus);
	if (bShowStatus)
	{
		DeleteLocalInt(OBJECT_SELF, sHenchShowWeaponStatus);
	}
    if (!HenchEquipAppropriateWeapons(OBJECT_INVALID, -5., bShowStatus, GetHasEffect(EFFECT_TYPE_POLYMORPH)))
    {
        ActionDoCommand(ActionContinueEquip(OBJECT_INVALID, bShowStatus, 2));
    }
}