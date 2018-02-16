void main()
{
	string parchmentVarName = "parchmentObject";
	string parchmentWritingVarName = "writing";

	object oPC = GetPCSpeaker();
	object parchmentObject = GetLocalObject(oPC, parchmentVarName);
	
	if(parchmentObject != OBJECT_INVALID)
	{
		string writtenText = GetLocalString(parchmentObject, parchmentWritingVarName);
		if (writtenText != "")
		{
			AssignCommand(oPC, ClearAllActions());
			AssignCommand(oPC, ActionSpeakString(writtenText));
		}
		else
		{
			SendMessageToPC(oPC, "This piece of parchment is empty.");
		}
	}
	else
	{
		SendMessageToPC(oPC, "This piece of parchment is empty.");
	}
	
	// delete the item mark	
	DeleteLocalObject(oPC, parchmentVarName);
}