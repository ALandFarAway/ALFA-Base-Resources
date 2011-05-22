//::///////////////////////////////////////////////////////////////////////////
//::
//::	gai_template_groupattack
//::
//::	Has the members of a group all attack one enemy at a time.
//::
//::///////////////////////////////////////////////////////////////////////////
//  DBR 1/30/06

#include "ginc_ai"
#include "ginc_group"

void main()
{


	GroupAddMember("Group_of_Rats",OBJECT_SELF); //groups in this AI type are the same groups in ginc_group.


	//Uses the AIAttackPreference command. An optional third integer parameter will set the probability (out of 100)
												//that this AI type is used in a round of combat


	AIAttackPreference(OBJECT_SELF,		ATTACK_PREFERENCE_GROUPATTACK	);


}