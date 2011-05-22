// gb_attack_caster_ai
//
// Attack casters first. Then ranged.  Then melee.  

// EPF 8/18/06

#include "ginc_ai"
	

void main()
{

	AIAttackPreference(OBJECT_SELF, ATTACK_PREFERENCE_CLASS_PRIORITY);


	AIAttackInOrder(OBJECT_SELF,	AI_CLASS_TYPE_SPELLCASTERS		);		//first class to attack..

	AIAttackInOrder(OBJECT_SELF,	AI_CLASS_TYPE_RANGED		);		//second..

	AIAttackInOrder(OBJECT_SELF,	AI_CLASS_TYPE_MELEE		);		//so on..
}