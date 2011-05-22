//::///////////////////////////////////////////////////////////////////////////
//::
//::	gai_template_attackweakest
//::
//::	Has a creature attack the weakest character nearby.
//::
//::///////////////////////////////////////////////////////////////////////////
//  DBR 1/30/06

#include "ginc_ai"
	

void main()
{

	//Uses the AIAttackPreference command. An optional third integer parameter will set the probability (out of 100)
												//that this AI type is used in a round of combat. Default == 100.

	AIAttackPreference(OBJECT_SELF,		ATTACK_PREFERENCE_WEAKEST		);


}