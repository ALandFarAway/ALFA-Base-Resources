// KEMO 11/08
// called by kemo_sitting_conv
// destroys an existing portable stool and "puts" that stool into the PC's inventory
// now called by kemo_chairs.xml ---KEMO 3/10/09

void main()
{

	//object oPC = GetPCSpeaker();
	object oPC = OBJECT_SELF;
	object oStool = GetNearestObjectByTag("kemo_chair_4");

	CreateItemOnObject("kemoportablechair",oPC); // creates the portable stool item in inventory
	DestroyObject(oStool); // destroys the placed stool
	SetCommandable(1,oPC); // allows the PC to move again after the conversation ends
	DelayCommand(1.0f,SetOrientOnDialog(oPC,TRUE)); //fixes the post-dialogue-with-placeable bug
}