//::///////////////////////////////////////////////////////////////////////////
//::
//::	gai_template_mostdamagedby
//::
//::	Attack whomever has dealt the most damage to me.
//::
//::///////////////////////////////////////////////////////////////////////////
//  DBR 2/01/06

#include "ginc_ai"

void main()
{
	

	//Uses the AIAttackPreference command. An optional third integer parameter will set the probability (out of 100)
												//that this AI type is used in a round of combat

	AIAttackPreference(OBJECT_SELF,	ATTACK_PREFERENCE_MOSTDAMAGEDBY	);


}