//DMFI - USING PORTALS by Qk


void main()
{
	object oMOD = GetModule();
	object oPC = GetLastUsedBy();
	int iDest = GetLocalInt(OBJECT_SELF,"DMFI_DESTINATION");
	object oDest, oIni;
	effect eTel = EffectNWN2SpecialEffectFile("fx_teleport");
	if (iDest == 1)
		{
		  oDest = GetLocalObject(oMOD,"DMFI_PORTAL_B");
		  oIni = GetLocalObject(oMOD,"DMFI_PORTAL_A");
		}
	else
		{
		  oDest = GetLocalObject(oMOD,"DMFI_PORTAL_A");
		  oIni = GetLocalObject(oMOD,"DMFI_PORTAL_B");
		}

	if (GetIsObjectValid(oDest))
		{
		 ApplyEffectAtLocation(0,eTel,GetLocation(oPC));
		 AssignCommand(oPC,JumpToObject(oDest,0));
		 
		}
	else
	   SendMessageToPC(oPC,"Seems this portal is doing nothing");	
}