// AL- changes for ALFA 3/20/2010:  "Bio" to "Description", switched to ACR persistency, only save portrait on SAVE button
//   also disabled portrait cycling.
//   2010/03/21: Fixed inspection of other PCs. -AL
//   2010/03/25: Disabled inspection notice from DMs.

#include "acr_db_persist_i"

string GetPackPortrait(string sPortrait)
{
	int iFilenameLength = GetStringLength(sPortrait) - 1;
	int iPackSize = StringToInt(GetStringRight(sPortrait,1));
	int iPackVariant = Random(iPackSize+1);
	sPortrait = GetStringLeft(sPortrait,iFilenameLength);
	return sPortrait + IntToString(iPackVariant) + ".tga";
}

//cycles through each element of the current pack, once per second, when the filename is edited
void CyclePortraits()
{
	object oPC = OBJECT_SELF; string sDB; string sPortrait; int iFilenameLength;
	int iPackSize; int iPackVariant; string sPortraitTGA;
	
	sDB = GetSubString(GetPCPlayerName(oPC), 0, 12) +
		"_" + GetSubString(GetFirstName(oPC), 0, 6) + "_" + GetSubString(GetLastName(oPC), 0, 9);
	//sPortrait = GetCampaignString(sDB,"Portrait");
	sPortrait = GetLocalString(oPC, "ACR_PORTRAIT");
	SendMessageToPC(oPC, "CyclePortrait call.");
	if (FindSubString(sPortrait,"pack") > -1)
	{
		iFilenameLength = GetStringLength(sPortrait) - 1;
		iPackSize = StringToInt(GetStringRight(sPortrait,1));
		sPortrait = GetStringLeft(sPortrait,iFilenameLength);
		iPackVariant = 0;
		while (iPackVariant <= iPackSize)
		{
			sPortraitTGA = sPortrait + IntToString(iPackVariant) + ".tga";
			DelayCommand(IntToFloat(iPackVariant)*0.5f,SetGUITexture(oPC,"KEMO_BIO_EDIT","KEMO_PORTRAIT",sPortraitTGA));
			iPackVariant++;
		}
	}
}

void main(string sAction, string sType, string sEntry)
{
	object oPC = OBJECT_SELF;
	object oDMFI_tool = GetLocalObject(oPC, "DMFITool");
	object oTarget = GetPlayerCurrentTarget(oPC);
	string sDB; 
	string sBio = GetLocalString(oDMFI_tool, "ACR_DESCRIPTION"); 
	string sPortrait = GetLocalString(oPC, "ACR_PORTRAIT"); 
	string sPortraitTGA;
	
	
	if (sAction == "display")
	{
		//sDB = GetSubString(GetPCPlayerName(oTarget), 0, 12) +
		//	"_" + GetSubString(GetFirstName(oTarget), 0, 6) +
		//	"_" + GetSubString(GetLastName(oTarget), 0, 9);
		//sBio = GetCampaignString(sDB,"Bio");
		oDMFI_tool = GetLocalObject(oTarget, "DMFITool");
		sBio = GetLocalString(oDMFI_tool, "ACR_DESCRIPTION");
		if (sBio == "") {
			// no entry on DMFI tool, try their actual GetDescription()
			sBio = GetDescription(oTarget);
			SetLocalString(oDMFI_tool, "ACR_DESCRIPTION", sBio);
		}
		//sPortrait = GetCampaignString(sDB,"Portrait");
		sPortrait = GetLocalString(oTarget, "ACR_PORTRAIT"); 
		if (sPortrait == "") {
			//No cached portrait, pick it up from the SQL
			sPortrait == ACR_GetPersistentString(oTarget, "ACR_PORTRAIT");
			if (GetStringLength(sPortrait) < 2) {
			    sPortrait = "default";
			}
			SetLocalString(oTarget, "ACR_PORTRAIT", sPortrait);
		}
		
		//filenames with "pack" in them are set up as series, 0-9
		//viewers will see one of the pack selected at random
		//editors specify the size of the pack by using the highest number
		//in the series: if x_pack_ has 5 pictures, type in x_pack_4 to
		//set the range
		if (FindSubString(sPortrait,"pack") > -1)
		{	sPortrait = GetPackPortrait(sPortrait);
			DisplayGuiScreen(oPC,"KEMO_BIO_DISPLAY",FALSE,"kemo_bio_display.xml");
			SetGUIObjectText(oPC,"KEMO_BIO_DISPLAY","INPUT_BIOTEXT",-1,sBio);
			SetGUITexture(oPC,"KEMO_BIO_DISPLAY","KEMO_PORTRAIT",sPortrait);
			DisplayGuiScreen(oPC,"KEMO_ERP",FALSE,"kemo_erp.xml");
#if 0
			if ((!GetIsDM(oPC)) && (!GetIsDMPossessed(oPC))) {
				SendMessageToPC(oTarget,"<C=gray>Someone is inspecting you. [Portrait: " + sPortrait + "]</C>");
			}
#endif
		}
		else
		{	sPortrait = sPortrait + ".tga";
			DisplayGuiScreen(oPC,"KEMO_BIO_DISPLAY",FALSE,"kemo_bio_display.xml");
			SetGUIObjectText(oPC,"KEMO_BIO_DISPLAY","INPUT_BIOTEXT",-1,sBio);
			SetGUITexture(oPC,"KEMO_BIO_DISPLAY","KEMO_PORTRAIT",sPortrait);
			DisplayGuiScreen(oPC,"KEMO_ERP",FALSE,"kemo_erp.xml");
#if 0
			if ((!GetIsDM(oPC)) && (!GetIsDMPossessed(oPC))) {
				SendMessageToPC(oTarget,"<C=gray>Someone is inspecting you.</C>");
			}
#endif
		}
		//WriteTimestampedLogEntry(GetName(oPC) + " is displaying a bio/portrait: " + sPortrait);
		
		return;
	}
	if (sAction == "edit")
	{
		WriteTimestampedLogEntry(GetName(oPC) + " is editing a description/portrait.");
		//sDB = GetSubString(GetPCPlayerName(oPC), 0, 12) +
		//	"_" + GetSubString(GetFirstName(oPC), 0, 6) +
		//	"_" + GetSubString(GetLastName(oPC), 0, 9);
		//sBio = GetCampaignString(sDB,"Bio");
		if (sBio == "") {
			// no cached value, try their actual GetDescription()
			sBio = GetDescription(oPC);
			SetLocalString(oDMFI_tool, "ACR_DESCRIPTION", sBio);
		}
		//sPortrait = GetCampaignString(sDB,"Portrait");
		//if (GetStringLength(sPortrait) < 2) sPortrait = "default";
		if (sPortrait == "") {
			//No cached portrait, pick it up from the SQL
			sPortrait = ACR_GetPersistentString(oPC, "ACR_PORTRAIT");
			if (GetStringLength(sPortrait) < 2) {
			 sPortrait = "default";
			}
			SetLocalString(oPC, "ACR_PORTRAIT", sPortrait);
		}
		sPortraitTGA = sPortrait+".tga";
		DisplayGuiScreen(oPC,"KEMO_BIO_EDIT",FALSE,"kemo_bio_edit.xml");
		SetGUIObjectText(oPC,"KEMO_BIO_EDIT","INPUT_BIOTEXT",-1,sBio);
		SetGUIObjectText(oPC,"KEMO_BIO_EDIT","PORTRAIT_INPUT_BOX",-1,sPortrait);
		SetGUITexture(oPC,"KEMO_BIO_EDIT","KEMO_PORTRAIT",sPortraitTGA);
		DisplayGuiScreen(oPC,"KEMO_ERP",FALSE,"kemo_erp.xml");
		return;
	}
	if (sAction == "save")
	{
		//sDB = GetSubString(GetPCPlayerName(oPC), 0, 12) +
		//	"_" + GetSubString(GetFirstName(oPC), 0, 6) +
		//	"_" + GetSubString(GetLastName(oPC), 0, 9);
		if (sType == "bio")
		{
			//SetCampaignString(sDB,"Bio",sEntry);
			WriteTimestampedLogEntry("Kemo Description/portrait change saved by PC: "+GetName(oPC));
			SetLocalString(oDMFI_tool, "ACR_DESCRIPTION", sEntry);
			SetDescription(oPC, sEntry);
			CloseGUIScreen(oPC,"KEMO_BIO_EDIT");
			SendMessageToPC(oPC, "Saving description and current portrait.");
			//SetCampaignString(sDB,"Portrait",GetLocalString(oPC,"ACR_PORTRAIT"));
			ACR_SetPersistentString(oPC, "ACR_PORTRAIT", GetLocalString(oPC, "ACR_PORTRAIT"));
		}
		if (sType == "portrait")
		{
			
			if (sEntry == GetLocalString(oPC,"ACR_PORTRAIT")) return;
			if (GetStringLength(sEntry) < 2) sEntry = "default";
			//SetCampaignString(sDB,"Portrait",sEntry);
			//SendMessageToPC(oPC, "Updating portrait display.");
			//CyclePortraits();
			SetLocalString(oPC, "ACR_PORTRAIT", sEntry);
			SetGUITexture(oPC,"KEMO_BIO_EDIT","KEMO_PORTRAIT",sEntry+".tga");
		}
		return;
	}
}
