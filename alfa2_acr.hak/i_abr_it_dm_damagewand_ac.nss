////////////////////////////////////////////////////////////////////////////////
//
//                     Wynna			9/18/2008   
//------------------------------------------------------------------------------
////////////////////////////////////////////////////////////////////////////////


#include "acr_spawn_i"

void main()
{
    object oDM = GetItemActivator();
	object oPC = GetItemActivatedTarget();
	int nDamage = GetLocalInt(oDM, "DM_Damage");
	
	SetLocalObject(oDM, "PC_Damage", oPC);
	AssignCommand(oDM, ActionStartConversation(oDM, "acr_damage_wand", TRUE, TRUE, TRUE, TRUE));
   

}