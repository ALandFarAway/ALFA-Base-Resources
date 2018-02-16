void main (string newname)
{
	newname = GetSubString(newname, 0, 20);

	string parchmentVarName = "parchmentObject";
	string parchmentWritingVarName = "writing";
	
	object oPC = OBJECT_SELF;
	object parchmentObject = GetLocalObject(oPC, parchmentVarName);

	if (newname != "")
	{
		SetFirstName(parchmentObject, "Parchment: " + newname);
		SetLocalString(parchmentObject, parchmentWritingVarName, "(no text)");
	}
	else
	{
		SetFirstName(parchmentObject, "Written parchment");
		SetLocalString(parchmentObject, parchmentWritingVarName, "(no text)");
	}
	
	// get the actual message text
    int msgref = 0;
    string msg = "Enter the message (200 characters maximum):";
	DisplayInputBox (oPC, msgref, msg, "gui_ps_parchment_write");
}