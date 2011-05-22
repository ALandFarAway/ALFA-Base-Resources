// gb_attack_melee_ai
//
// Attack melee first, then casters, then ranged. 

// EPF 8/18/06

#include "ginc_ai"
	

void main()
{

	AIAttackPreference(OBJECT_SELF, ATTACK_PREFERENCE_CLASS_PRIORITY);
	
	AIAttackInOrder(OBJECT_SELF,	AI_CLASS_TYPE_MELEE		);		//so on..

	AIAttackInOrder(OBJECT_SELF,	AI_CLASS_TYPE_SPELLCASTERS		);		//first class to attack..

	AIAttackInOrder(OBJECT_SELF,	AI_CLASS_TYPE_RANGED		);		//second..

	
}