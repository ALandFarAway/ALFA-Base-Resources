void main()

	{object oDM = OBJECT_SELF;
	 location lLocation = GetItemActivatedTargetLocation();
	 object oMod = GetModule();
	 int nNumber = GetLocalInt(oMod, "omega_at_number");
	 string sName = "Temp AT #" + IntToString(nNumber);
	 int nStart = GetLocalInt(oDM, "omega_temp_at");
	if(nStart == 0)
		{nNumber++;
		 SetLocalInt(oMod,"omega_at_number", nNumber);
		 }
	object oAT = CreateObject(OBJECT_TYPE_PLACEABLE, "abr_plc_temp_at", lLocation);
	SetFirstName(oAT, sName);
	SendMessageToAllDMs("Temp AT Name = " + GetName(oAT));
	
}		