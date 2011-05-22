//::///////////////////////////////////////////////////////////////////////////
//::
//::	gai_template_donothing
//::
//::	Do nothing during combat.
//::
//::///////////////////////////////////////////////////////////////////////////
// DBR 2/28/06

#include "ginc_ai"
	
	
void main()
{
	SetCombatOverrides(OBJECT_SELF,OBJECT_INVALID,-1,-1,OVERRIDE_ATTACK_RESULT_DEFAULT,-1,-1,FALSE,TRUE,FALSE,FALSE);
	AIAssignDCR(OBJECT_SELF,"gai_ignore_dcr");

}