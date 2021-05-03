/**************************************************
//DMFI
//gui_dmfi_trgtool por Qk
	A lot of new functions 
// 08/10/07
****************************************************/
#include "dmfi_inc_tool"

//Set up a popup with all party member properties
void SeeParty(object oDM);
//Makes a teleportation portal, if already there, destroys it
void DoPortal(location lLoc,int nMode);
//Destroy all dmfi portals
void DestroyPortals();
//Set up a message popup to send all players in server
void SendPopupAllPlayers(string sTexto);
//Set up a message popup to send all party of a targeted player
void SendPopupParty(string sTexto, object oTarget);
//Jump the party's target to DM location
void JumpParty(object oTarget,object oDM);
//Jump ALL players to current DM location
void JumpAllPlayers(object oDM);
//Destroys the targeted placeable
void DestroyPlaceables(object oTarget);


void main(string sValue, int n)
{
	object oPC = OBJECT_SELF;
	object oTarget = GetPlayerCurrentTarget(OBJECT_SELF);
	if (!DMFI_GetIsDM(oPC)) return;
	
	if (sValue == "SERVER_TOOL")
		{
		SetGUIObjectHidden(oPC,SCREEN_DMFI_TRGTOOL,"DMFI_ROOT1",TRUE);
		SetGUIObjectHidden(oPC,SCREEN_DMFI_TRGTOOL,"DMFI_ROOT2",FALSE);
		}
	
	else if (sValue == "OBJECT_TOOL")
		{
		SetGUIObjectHidden(oPC,SCREEN_DMFI_TRGTOOL,"DMFI_ROOT2",TRUE);
		SetGUIObjectHidden(oPC,SCREEN_DMFI_TRGTOOL,"DMFI_ROOT1",FALSE);
		}
	else if (sValue == "REPORT_LOCATION")
		{
		 SeeParty(oPC);
		}
		
	else if (sValue == "MNGR_TOOL")
		{
		 DisplayGuiScreen(oPC,SCREEN_DMFI_MNGRTOOL,FALSE,"dmfimngrtool.xml");
		}
	else if (sValue =="GET_OUT")
		{
		 ExecuteScript("gr_outofmyway",oPC);
		}
	else if (sValue =="EVENTTOOL")
		{
	     DisplayGuiScreen(oPC,"EVENT_TOOL_SCREEN",FALSE,"eventtool.xml");	 
		}
	else if (sValue =="PORTAL_A")
		{
		 DoPortal(GetLocation(oTarget),1);
		}
	else if (sValue =="PORTAL_B")
		{
		 DoPortal(GetLocation(oTarget),0);
		}
	else if (sValue =="DESTROY_PORT")
		{
		DestroyPortals();
		}
	else if (sValue =="MSGALL_POPUP")
	{
		SetLocalInt(oPC,"DMFIPOPUPMODE",0);
		DisplayGuiScreen(oPC,SCREEN_DMFI_DESC,FALSE,"dmfitextdesc.xml");
	}
	else if (sValue =="MSGPARTY_POPUP")
	{
		SetLocalInt(oPC,"DMFIPOPUPMODE",1);
		DisplayGuiScreen(oPC,SCREEN_DMFI_DESC,FALSE,"dmfitextdesc.xml");
	}
	else if (sValue == "JUMP_PARTY")
	{
		JumpParty(oTarget,oPC);
	}
	
	else if (sValue == "JUMP_ALLPLAYERS")
	{
		JumpAllPlayers(oPC);
	}
	else if (sValue == "JUMP_TOLEADER")
	{
		ExecuteScript("gr_jumpleader",oTarget);
	}
	else if (sValue == "DESTROY_PLAC")
	{
	 	if (GetObjectType(oTarget)!=64) return;
		DestroyPlaceables(oTarget);
		
	}
	else  //POPUP OPTIONS
	  {
	   string sText = DMFI_POPUPMESSAGE+sValue;
	   SetGUIObjectText(oPC,SCREEN_DMFI_DESC, "inputdescbox", -1, "");
	   CloseGUIScreen(oPC,SCREEN_DMFI_DESC);
	   int iMode = GetLocalInt(oPC,"DMFIPOPUPMODE");
	   DeleteLocalInt(oPC,"DMFIPOPUPMODE");
	   if(iMode == 0)
	  	 SendPopupAllPlayers(sText);
	   else if(iMode ==1)
	     SendPopupParty(sText,oTarget);
	   else
	    return;
	  }

		

}


/* FUNCTIONS */
/*************************************************************************/


void SeeParty(object oDM)
{
    object oParty = GetFirstPC();
    string sFin = DMFI_STATUS_SHEET;
    
    while (GetIsObjectValid(oParty))
        {
        string sName = GetName(oParty);
		string sAccount = GetPCPlayerName(oParty);
		string sCDKey = GetPCPublicCDKey(oParty);
        string sCurHp = IntToString(GetCurrentHitPoints(oParty));
        string sMaxHp = IntToString(GetMaxHitPoints(oParty));
		object oArea = GetArea(oParty);
        string sArea = GetName(oArea);
        string sDesc = GetDescription(oParty);
		string sDest = GetStringLeft(sDesc,120);
        int iIntObj = ObjectToInt(oParty);
		int iIntArea = ObjectToInt(oArea);
		string sIObj = IntToString(iIntObj);
		string sIAre = IntToString(iIntArea);
		// AcadiusLost addition for the ACR
		string sRPXP = FloatToString(GetLocalFloat(oParty, "ACR_RPXP_PERCENT"), 2, 1);
        
        
        sFin = sFin+"<b>"+sName+"</b>: ("+sCurHp+"/"+sMaxHp+")  ("+sIObj+").\nAccount: "+sAccount+" ( "+sCDKey+" ).\nLocation: <i>"+sArea+"</i> ("+sIAre+")\n<i>"+sDesc+"</i>\n"+sRPXP+"% RPXP\n";
        
        oParty = GetNextPC();
        }
        
    DisplayMessageBox(oDM,-1,sFin,"","",FALSE,SCREEN_MESSAGEBOX_REPORT,0,DONE_UI_BUTTON);	    
    
}

void DoPortal(location lLoc, int nMode)
{
   object oMOD = GetModule();
   effect ePortal1 = EffectNWN2SpecialEffectFile("fx_portal_gen_small");
   effect ePortal2 = EffectNWN2SpecialEffectFile("sp_magic_circle");
   object oPortal,oAntport;
   if (nMode ==1)
   {
   oAntport = GetLocalObject(oMOD,"DMFI_PORTAL_A");
    if (GetIsObjectValid(oAntport)){ DestroyObject(oAntport); DeleteLocalObject(oMOD,"DMFI_PORTAL_A");}	
   oPortal = CreateObject(OBJECT_TYPE_PLACEABLE,DMFI_PORTAL,lLoc,FALSE,"dmfi_portal_a");
   SetLocalObject(oMOD,"DMFI_PORTAL_A",oPortal);
   SetLocalInt(oPortal,"DMFI_DESTINATION",1);
   }
   else
   {
   oAntport = GetLocalObject(oMOD,"DMFI_PORTAL_B");
   if (GetIsObjectValid(oAntport)) { DestroyObject(oAntport); DeleteLocalObject(oMOD,"DMFI_PORTAL_b");}
   oPortal = CreateObject(OBJECT_TYPE_PLACEABLE,DMFI_PORTAL,lLoc,FALSE,"dmfi_portal_b");
   SetLocalObject(oMOD,"DMFI_PORTAL_B",oPortal);
   SetLocalInt(oPortal,"DMFI_DESTINATION",0);
   }
  ApplyEffectToObject(2,ePortal2,oPortal);
  ApplyEffectToObject(2,ePortal1,oPortal);
}

void DestroyPortals()
{
	object oMOD = GetModule();
	object oPort1 = GetLocalObject(oMOD,"DMFI_PORTAL_A");
	object oPort2 = GetLocalObject(oMOD,"DMFI_PORTAL_B");
	DestroyObject(oPort1);
	DestroyObject(oPort2);
	DeleteLocalObject(oMOD,"DMFI_PORTAL_A");
	DeleteLocalObject(oMOD,"DMFI_PORTAL_A");
}

void SendPopupAllPlayers(string sTexto)
{
	object oPlayer = GetFirstPC();
	while (GetIsObjectValid(oPlayer))
		{
		DisplayMessageBox(oPlayer,0,sTexto,"","",FALSE,SCREEN_MESSAGEBOX_DEFAULT,0,"Ok",0,"Cancel");	
		oPlayer = GetNextPC();
		}
}

void SendPopupParty(string sTexto, object oTarget)
{
	object oPlayer = GetFirstFactionMember(oTarget);
	while (GetIsObjectValid(oPlayer))
		{
		DisplayMessageBox(oPlayer,0,sTexto,"","",FALSE,SCREEN_MESSAGEBOX_DEFAULT,0,"Ok",0,"Cancel");	
		oPlayer = GetNextFactionMember(oTarget);
		}
}

void JumpParty(object oTarget,object oDM)
{
	object oPlayer = GetFirstFactionMember(oTarget);
	location lLoc = GetLocation(oDM);
		while (GetIsObjectValid(oPlayer))
		{
		AssignCommand(oPlayer,JumpToLocation(lLoc));	
		oPlayer = GetNextFactionMember(oTarget);
		}
}

void JumpAllPlayers(object oDM)
{
	object oPlayer = GetFirstPC();
	location lLoc = GetLocation(oDM);
	while (GetIsObjectValid(oPlayer))
		{
	    AssignCommand(oPlayer,JumpToLocation(lLoc));	
		oPlayer = GetNextPC();
		}
}

void DestroyPlaceables(object oTarget)
{
	SetPlotFlag(oTarget,FALSE);
	DestroyObject(oTarget,0.1,TRUE);
}
