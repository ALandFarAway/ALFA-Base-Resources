//::///////////////////////////////////////////////////////////////////////////
//::
//::	gai_template_classpriority
//::
//::	Used to Tell a creature to fight certain classes before others.
//::
//::///////////////////////////////////////////////////////////////////////////
//  DBR 1/30/06

#include "ginc_ai"
	

void main()
{


	//Uses the AIAttackPreference command. An optional third integer parameter can set the probability (out of 100)
												//that this AI type is used in a round of combat. Default == 100.

	AIAttackPreference(OBJECT_SELF, ATTACK_PREFERENCE_CLASS_PRIORITY);


	//Just change this! That's it! Wo-ah -oh -oh, it's MAGIC! You knooooooowww-	

	AIAttackInOrder(OBJECT_SELF,	CLASS_TYPE_WIZARD		);		//first class to attack..

	AIAttackInOrder(OBJECT_SELF,	CLASS_TYPE_SORCERER		);		//second..

	AIAttackInOrder(OBJECT_SELF,	AI_CLASS_TYPE_MELEE		);		//so on..

	AIAttackInOrder(OBJECT_SELF,	CLASS_TYPE_BARD			);


	//----*NOTES*-----

	//Any number of classes can be provided.

	//The second parameter is from the CLASS_TYPE_* constant list.	

	//There are custom constants (second paramter) that you can provide to prefer a range of classes. Those are:
		//AI_CLASS_TYPE_MELLE 			- melee users
		//AI_CLASS_TYPE_RANGED 			- ranged users
		//AI_CLASS_TYPE_SPELLCASTERS 	- magic users

}