void main()

	{object oDM = OBJECT_SELF;
	 location lLocation = GetItemActivatedTargetLocation();
	 object oMod = GetModule();
	 int nStart = GetLocalInt(oDM, "omega_temp_vehicle");
	 string sVehicle = "abr_plc_rowboat";
	 string sVehicleNewTag = "abr_plc_vehicle";
	 string sType = "Boat";
	 int nVehicle = GetLocalInt(oDM, "omega_vehicle");
	 if(nVehicle == 2)
	 	{sVehicle = "abr_plc_wagon";
		 sType = "Wagon";
		 }
	 int nNumber = GetLocalInt(oMod, "omega_temp_vehicle");
	 if(nStart == 0)
		{nNumber++;
		 SetLocalInt(oMod, "omega_temp_vehicle", nNumber);
		 SetLocalInt(oMod, "omega_temp_via", 0);
		 }
	int nVia = GetLocalInt(oMod, "omega_temp_via") + 1;
	if(nStart >= 2)
		{sVehicle = "abr_plc_vehicle_via";
		 sVehicleNewTag = "abr_plc_vehicle_via";
		 if(nVehicle == 3)
	 		{sVehicle = "abr_plc_vehicle_horse";
		 	 sVehicleNewTag = "abr_plc_vehicle_horse";
		 	}
		 nVia ++;
		 SetLocalInt(oMod, "omega_temp_via", nVia);
		 }
		
	nNumber = GetLocalInt(oMod, "omega_temp_vehicle");
	string sName = sType + " #" + IntToString(nNumber);
	string sViaNumber = IntToString(nVia);
	  	 
	if((nVehicle == 3) && (nStart < 2))
	 	{sVehicle = "abr_cr_an_dom_horse";
		 sType = "Horse";
		 object oVehicle = CreateObject(OBJECT_TYPE_CREATURE, "abr_cr_an_dom_horse", lLocation);
		 SetLocalInt(oVehicle, "ACR_FLOCKING", 0);
		 object oWagon = GetNearestObjectByTag("abr_plc_vehicle", oVehicle, 1);
		 SetLocalObject(oWagon, "oHorse", oVehicle);
		 }
	object oVehicle = CreateObject(OBJECT_TYPE_PLACEABLE, sVehicle, lLocation, FALSE, sVehicleNewTag);
	SetLocalInt(oVehicle, "omega_vehicle", nVehicle);
	SetFirstName(oVehicle, sName);
	if(GetTag(oVehicle) == "abr_plc_vehicle_via")
		{SetLastName(oVehicle, sViaNumber);
		}
	
	SendMessageToAllDMs("Created " + GetTag(oVehicle) + "/" + GetName(oVehicle));
	SendMessageToAllDMs("nStart = " + IntToString(nStart));
	SendMessageToAllDMs("nNumber = " + IntToString(nNumber));

}		