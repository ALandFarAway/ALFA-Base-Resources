/*

    Companion and Monster AI

    Just does a simple melee attack of intruder, used by commoners

*/

#include "hench_i0_equip"
#include "hench_i0_ai"

void main()
{
    object oIntruder = GetLocalObject(OBJECT_SELF, HENCH_AI_SCRIPT_INTRUDER_OBJ);
    DeleteLocalObject(OBJECT_SELF, HENCH_AI_SCRIPT_INTRUDER_OBJ);
    
    HenchEquipDefaultWeapons();
    ActionAttack(oIntruder);
}