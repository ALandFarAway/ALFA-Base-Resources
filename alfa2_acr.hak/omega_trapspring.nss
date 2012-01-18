////////////////////////////////////////////////////////////////////////////////
//
//                     Wynna			9/18/2008   
//------------------------------------------------------------------------------
////////////////////////////////////////////////////////////////////////////////


void main()
{
    object oDM = OBJECT_SELF;
	object oObject = GetLocalObject(oDM, "Object_Target");
	
	object oSpringer = CreateObject(OBJECT_TYPE_CREATURE, "003_cr_voice", GetLocation(oObject));
	SetFirstName(oSpringer, "Nothing in particular");
	DelayCommand(1.0, AssignCommand(oSpringer, ClearAllActions(TRUE)));
	DelayCommand(1.5, AssignCommand(oSpringer, ActionAttack(oObject, FALSE)));
	DelayCommand(3.0, AssignCommand(oSpringer, ClearAllActions(TRUE)));
	DelayCommand(3.5, AssignCommand(oSpringer, ActionAttack(oObject, FALSE)));
	DelayCommand(5.0, AssignCommand(oSpringer, ClearAllActions(TRUE)));
	DelayCommand(5.5, AssignCommand(oSpringer, ActionAttack(oObject, FALSE)));
	DestroyObject(oSpringer, 10.0);
	
}