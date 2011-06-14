// KEMO 11/08
// This script creates a stool from the Portable Stool item.

void main()
{
    object oPC      = GetItemActivator();
    object oItem    = GetItemActivated();
    object oTarget  = GetItemActivatedTarget();
    location lTarget = GetItemActivatedTargetLocation();
	location lPCloc = GetLocation(oPC);

 	//Your code goes here

	object oChair = CreateObject(OBJECT_TYPE_PLACEABLE,"kemo_chair_4",lPCloc,FALSE,"kemo_chair_4");
	DelayCommand(1.0f,SetFirstName(oChair,"Portable Stool"));
	DelayCommand(2.0f,SetLocalInt(oChair,"Portable",1));
	DelayCommand(3.0f,DestroyObject(oItem,0.0f,FALSE));

}