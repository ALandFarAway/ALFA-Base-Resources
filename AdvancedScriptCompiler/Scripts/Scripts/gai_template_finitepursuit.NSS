//::///////////////////////////////////////////////////////////////////////////
//::
//::	gai_template_finitepursuit
//::
//::	Used to ensure a creature will not stray far because of combat.
//::
//::///////////////////////////////////////////////////////////////////////////
//  DBR 1/30/06

#include "ginc_ai"
	


void main()
{

	//Adjust the 12.0f parameter to set how far the creature should be allowed to wander.

	AIFinitePursuit(OBJECT_SELF,		12.0f);



}