//::///////////////////////////////////////////////////////////////////////////
//::
//::	gai_template_protector
//::
//::	I follow a guy around and hurt people who try to harm him.
//::
//::///////////////////////////////////////////////////////////////////////////
//  DBR 1/30/06

#include "ginc_ai"



void main()
{
		//Make me a hired goon!

		//this is just an example. You'll probably want to set oWhatImGuarding to who/what you want guarded.

		object oWhatImGuarding = GetFirstPC();

		AIMakeProtector(OBJECT_SELF, oWhatImGuarding);
		

}