void main()
{
	string parchmentVarName = "parchmentObject";
	string parchmentWritingVarName = "writing";

	object oPC = GetPCSpeaker();
	if (oPC == OBJECT_INVALID)
		return;

	object parchmentObject = GetLocalObject(oPC, parchmentVarName);
	if(parchmentObject != OBJECT_INVALID)
	{
		// is there already writing on this?
		string writtenText = GetLocalString(parchmentObject, parchmentWritingVarName);
		if (writtenText != "")
		{
			// there is already something written on this
			SendMessageToPC(oPC, "This parchment was already written on! You read: '" + writtenText + "'");
			// SendMessageToPC(oPC, "writer: " + GetLocalString(parchmentObject, "writer_char") + ", account: " + GetLocalString(parchmentObject, "writer_account"));
			
			// delete the item mark	
			DeleteLocalObject(oPC, parchmentVarName);
		}
		else
		{
			// parchment is empty
			
			// set this item as plot so it cant be sold after being written on
			SetPlotFlag(parchmentObject, TRUE);
			
			// mark the character and account name on the item for accountability
			SetLocalString(parchmentObject, "writer_char", GetName(oPC));
			SetLocalString(parchmentObject, "writer_account", GetPCPlayerName(oPC));
			
			// get the title
		    int msgref = 0;
	    	string msg = "Enter the message title (renames item to 'Parchment: (title)', 20 characters maximum):";
			DisplayInputBox (oPC, msgref, msg, "gui_ps_parchment_rename");
		}
	}
	else
	{
		// did not find parchment object
		// delete the item mark	
		DeleteLocalObject(oPC, parchmentVarName);
	}
}