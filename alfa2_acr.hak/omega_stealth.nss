void main()

	{object oDM = OBJECT_SELF;
	object oNPC = GetLocalObject(oDM, "Object_Target");
	
	
	
	if(GetActionMode(oNPC, ACTION_MODE_STEALTH) == 0)
		{SetActionMode(oNPC, ACTION_MODE_STEALTH, 1);
		SendMessageToPC(oDM, "Toggling Stealth on for " + GetName(oNPC));
	    }
	else if(GetActionMode(oNPC, ACTION_MODE_STEALTH) == 1)
		{SetActionMode(oNPC, ACTION_MODE_STEALTH, 0);
		SendMessageToPC(oDM, "Toggling Stealth off for " + GetName(oNPC));
	    }
		
		
}		