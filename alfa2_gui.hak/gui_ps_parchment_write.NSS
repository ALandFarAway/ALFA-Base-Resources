void main (string msgtext)
{
	msgtext = GetSubString(msgtext, 0, 200);

	string parchmentVarName = "parchmentObject";
	string parchmentWritingVarName = "writing";

	object oPC = OBJECT_SELF;
	object parchmentObject = GetLocalObject(oPC, parchmentVarName);
	if(parchmentObject != OBJECT_INVALID)
	{
		if (msgtext != "")
		{
			SetLocalString(parchmentObject, parchmentWritingVarName, msgtext);
		}
		else
		{
			SetLocalString(parchmentObject, parchmentWritingVarName, "(no text)");
		}
	}
	
	// delete the item mark	
	DeleteLocalObject(oPC, parchmentVarName);
}