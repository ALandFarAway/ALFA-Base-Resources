/*  
DMFI MANAGER TOOL
Qk library scripts for the DMFI Manager tool
It controls the vector positions too
10/07


*/

#include "dmfi_inc_tool"



void main(string sValue, int nObj, float nX, float nY, float nZ)
{
	object oPC = OBJECT_SELF;
	object oArea = GetArea(oPC);
//	if (!GetIsDM(oPC)) return;
	object oTarget = GetPlayerCurrentTarget(oPC);
	if (!DMFI_GetIsDM(oPC)) return;
	int nString;
	
	if (GetStringLeft(sValue,5)=="SLOT_")
		{
		sValue = GetSubString(sValue,5,2);
		//SendMessageToPC(oPC,sValue);
		SetLocalInt(oPC,"DMFI_MNGR_TOOL",StringToInt(sValue));
		}
		
	else if (sValue == "BUT_STORE")
		{
		if ((GetObjectType(oTarget)!= 1) && (GetObjectType(oTarget)!=2))
			   {
			   SendMessageToPC(oPC,ONLY_ITEMCREAT);	
			   return;
			   }
	    nString=GetLocalInt(oPC,"DMFI_MNGR_TOOL");
	    if (nString<1)
			{
			SendMessageToPC(oPC,"Must select a slot");
			return;
			}
			string sName = GetName(oTarget);
		StoreCampaignObject(DMFI_STORE_DB,"SLOT_"+IntToString(nString),oTarget,oPC);
		SetCampaignString(DMFI_STORE_DB,"NAME_"+IntToString(nString),sName,oPC);
		SendMessageToPC(oPC,SUCCESS_ADD);
		SetGUIObjectText(oPC,SCREEN_DMFI_MNGRTOOL,"BUT_MNGR_"+IntToString(nString),0,sName);
			   
		}
		
	else if (sValue == "BUT_PICKUP")
		{
		 object oLoc = IntToObject(nObj);
         location lLoc = Location(oArea,Vector(nX,nY,nZ),GetFacing(oPC));
		 object oLod;
		 nString=GetLocalInt(oPC,"DMFI_MNGR_TOOL");
		 
		 if(GetObjectType(oLoc)==1)
		 	 oLod = RetrieveCampaignObject(DMFI_STORE_DB,"SLOT_"+IntToString(nString),GetLocation(oLoc),oLoc);
			else
			 oLod = RetrieveCampaignObject(DMFI_STORE_DB,"SLOT_"+IntToString(nString),lLoc);
		// SendMessageToPC(oPC,"n"+IntToString(GetObjectType(oLod)));


		}
	else if (sValue=="READ_MNGR")
		{
		int i;
		string sNameB;
		
		for(i=1;i<21;i++)
			{
			string sSlot=IntToString(i);
			sNameB = GetCampaignString(DMFI_STORE_DB,"NAME_"+sSlot,oPC);
			if (sNameB!="")
				SetGUIObjectText(oPC,SCREEN_DMFI_MNGRTOOL,"BUT_MNGR_"+sSlot,0,sNameB); 
			else
				SetGUIObjectText(oPC,SCREEN_DMFI_MNGRTOOL,"BUT_MNGR_"+sSlot,0,SLOT_EMPTY); 
			}
		}
		else
		SendMessageToPC(oPC, "nohayui2");
}