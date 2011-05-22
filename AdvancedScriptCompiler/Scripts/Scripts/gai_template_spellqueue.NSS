//::///////////////////////////////////////////////////////////////////////////
//::
//::	gai_template_spellqueue
//::
//::	Used to Set up a spell queue on a creature.
//::
//::///////////////////////////////////////////////////////////////////////////
//  DBR 1/30/06

#include "ginc_ai"
	


void main()
{


	//---//////////////HEY!!! LOOK AT ME!!!!! Adjust these how you like.

	AISpellQueueEnqueue(OBJECT_SELF,		SPELL_RAY_OF_FROST,		"$PC");			//cast first..

	AISpellQueueEnqueue(OBJECT_SELF,		SPELL_STONESKIN,		"$SELF");		//cast second..

	AISpellQueueEnqueue(OBJECT_SELF,		SPELL_MAGIC_MISSILE,	"$ENEMY");		//cast next..

																					//and so on...

	//---------*NOTES*-----------

	//The first parameter is the spell queue caster, the second is the spell to cast (see SPELL_* const list)
		//and the third parameter is the target to cast the spell at.

	//The third parameter can be a tag of a target, or it can be "$PC", "$SELF", "$FRIEND", or "$ENEMY"
		//"$PC" = nearest PC
		//"$FRIEND" = nearest alive friend
		//"$ENEMY" = nearest person who is hostile to me
		//"$SELD" = myself

	//There can be any number of calls to AISpellQueueEnqueue()

}