//::///////////////////////////////////////////////////////////////////////////
//::
//::	gai_template_aipref
//::
//::	I prefer to attack creatures with certain AI's over other creatures.
//::
//::///////////////////////////////////////////////////////////////////////////
//  DBR 2/28/06

#include "ginc_ai"
	

void main()
{
	//Call the AIAttackPreference command first. 												
	AIAttackPreference(OBJECT_SELF, ATTACK_PREFERENCE_AI_TYPE);

	//Then put as many of these in whatever order you want.
	AIAttackTypeInOrder(OBJECT_SELF,	AI_TYPE_PROTECTOR		);		//first AI to attack..
	AIAttackTypeInOrder(OBJECT_SELF,	AI_TYPE_RUNNING_ALARM			);		//second..



	//----*NOTES*-----

	//Acceptable parameters:
	//  AI_TYPE_RUNNING_ALARM 
	//  AI_TYPE_COWARD		
	//  AI_TYPE_PROTECTOR		
	//  AI_TYPE_TANK			
	//  AI_TYPE_COUNTER_CASTER
	//  AI_TYPE_SPELL_QUEUE	
	//  AI_TYPE_GROUP_ATTACK		

}