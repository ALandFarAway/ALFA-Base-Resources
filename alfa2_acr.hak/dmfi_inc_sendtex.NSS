////////////////////////////////////////////////////////////////////////////////
// dmfi_inc_sendtex - DM Friendly Initiative -  SendText Include File
// Original Scripter:  Demetrious      Design: DMFI Design Team
//------------------------------------------------------------------------------
// Last Modified By:   Demetrious           11/13/6 v1.01a
//------------------------------------------------------------------------------
////////////////////////////////////////////////////////////////////////////////
//#include "dmfi_inc_const"

// SendText: Use send text to single player.   FILE: dmfi_inc_sendtex
// oPC will recieve sText.  It can be floating text or not.  sColor is a COLOR_
// constant.  bFaction - should other faction members within 30M be told.
void SendText(object oPC, string sText, int bFloat=FALSE, int nColor=-1, int bFaction=FALSE);

// SendTalkText:  Use to make a PC or NPC announce something.  FILE: dmfi_inc_tool
// oPC will speak sText in sColor at nTalkVolume.  See constants for colors and
// talkvolumes.
void SendTalkText(object oPC, string sText, int nColor=-1, int nTalkVolume=TALKVOLUME_TALK);

// SendDMText: Use to send text to DMs         FILE: dmfi_inc_sendtex
// oDM will receive sText.  bFloat for floating text.  sColor is a COLOR_
// constant.  bAllDMs TRUE to send to all DMs.  oListening:  Set this to a player
// and it will ONLY message DMs who are listening to that particular player. DMFI required.
// NOTE: Valid oDM is not required if oListening is valid - so OBJECT_INVALID for oDM would
// be a valid command IF oListening is a valid PC using the DMFI.
void SendDMText(object oDM, string sText, int bFloat=FALSE, int nColor=-1, int bAllDMs=0, object oListening=OBJECT_INVALID);

// SendPartyText:  Use to send text to a party of players       FILE: dmfi_inc_sendtex
// oPCs PARTY will receive sText.  bFloat for floating text.  sColor is a COLOR_
// constant. If TRUE, bLocal will restrict to party members within 30M of oPC.
void SendPartyText(object oPC, string sText, int bFloat=FALSE, int nColor=-1, int bLocal=FALSE);

// SendVarBasedText:  Use to send variable related messages     FILE: dmfi_inc_sendtex
// Function to send text based on a variable state.  oPC is the target PC for sText.
// nFloat determines floating or not.  nColor is a COLOR_ constant.  sVar is the name
// of an INTEGER you wish to check on PCs.  nValue is the value that must be set in order
// to recieve the message - if nValue is -1 then any NON-ZERO integer will pass.  nLevel
// is 0 for PC only check, 1 for a Party check, 2 for all PCs on server check.
void SendVarBasedText(object oPC, string sText, int nFloat= FALSE, int nColor=-1, string sVar="", int nValue=-1, int nLevel=0);

// ColorText(sString, int nColor);							FILE: dmfi_inc_sendtex
// This function will make sString be the specified color as specified in nColor.  
// Obsidian's COLOR constants are all included.  Hex valus for colors are available
// in nwn2_colors.2da
string ColorText(string sString, int nColor);

// ******************************* FUNCTIONS ***********************************

void SendText(object oPC, string sText, int bFloat=FALSE, int nColor=-1, int bFaction=FALSE)
{   //Purpose: Send text to a pc or faction in color quickly
    //Original Scripter: Demetrious
    //Last Modified By: Demetrious 10/12/6
    object oFaction;
	if (nColor!=-1)	sText = ColorText(sText, nColor);
	
	if (bFloat)
		FloatingTextStringOnCreature(sText, oPC, bFaction, 3.0);
	else
	{
		if (bFaction)
        {
            oFaction = GetFirstFactionMember(oPC, TRUE);
            while (GetIsObjectValid(oFaction))
            {
                if ((GetDistanceBetween(oFaction, oPC)<30.0) && (GetArea(oFaction)==GetArea(oPC)))
                    SendMessageToPC(oPC, sText);
                oFaction = GetNextFactionMember(oPC, TRUE);
            }
        }
        else SendMessageToPC(oPC, sText);
	}	
}

void SendTalkText(object oPC, string sText, int nColor=-1, int nTalkVolume=TALKVOLUME_TALK)
{   //Purpose: Make oPC speak sText - Useful for seeing DMFI results of an NPC
	//NOTE: SPACE IS IN THIS ON PURPOSE FOR LISTENING BASED DMFI FUNCTIONS.
    //Original Scripter: Demetrious
    //Last Modified By: Demetrious 12/23/6 - check valid state to stop crash.
    if (nColor!=-1) sText = ColorText(sText, nColor);
	if (GetIsObjectValid(oPC))
    	AssignCommand(oPC, SpeakString(" " + sText, nTalkVolume));
}

void SendPartyText(object oPC, string sText, int bFloat=FALSE, int nColor=-1, int bLocal=FALSE)
{   //Purpose: Function for sending text to an entire party or just a local party.
    //Original Scripter: Demetrious
    //Last Modified By: Demetrious 10/19/6
    if (nColor!=-1) sText = ColorText(sText, nColor);
    object oTest = GetFirstFactionMember(oPC, TRUE);
    while (oTest!=OBJECT_INVALID)
    {
        if (bLocal)
		{// local test code
        	if (GetDistanceBetween(oTest, oPC)<30.0 && (GetArea(oTest)==GetArea(oPC)))		   
			{
				if (bFloat)
	            	FloatingTextStringOnCreature(sText, oTest, FALSE);
	            else
	            	SendMessageToPC(oTest, sText);
			}		
        }// local test code
        else
        {
			if (bFloat)
                FloatingTextStringOnCreature(sText, oTest, FALSE);
            else
                SendMessageToPC(oTest, sText);
        }
        oTest = GetNextFactionMember(oPC, TRUE);
    }
}

void SendDMText(object oDM, string sText, int bFloat=FALSE, int nColor=-1, int bAllDMs=0, object oListening=OBJECT_INVALID)
{   //Purpose: Function for sending text to DMs
    //Original Scripter: Demetrious
    //Last Modified By: Demetrious 5/30/6
    int n;
    int nNull;
    object oTest;
    if (nColor!=-1) sText = ColorText(sText, nColor);

    if (oListening==OBJECT_INVALID)
    { // All or One only Code
        if (!bAllDMs)
        { // message single DM
            if (bFloat)
                FloatingTextStringOnCreature(sText, oDM, FALSE);
            else
                SendMessageToPC(oDM, sText);
        } // message single DM
        else
        {
            if (bFloat)
            {
                oTest = GetFirstPC();
                while (oTest!=OBJECT_INVALID)
                {
                    if (GetIsDM(oTest) || GetIsDMPossessed(oTest))
                        FloatingTextStringOnCreature(sText, oDM, FALSE);
                    oTest = GetNextPC();
                }
            }
            else SendMessageToAllDMs(sText);
        }
    } // All or One only Code

    else if (GetLocalInt(oListening, "DMFIListenOn")==1)
    { // DM LISTENING CODE - Send the Text to any DM
        n=1;
        nNull = 0;
        oTest = GetLocalObject(oListening, "DMFIListen"+IntToString(n));
        while ((n<10) && (nNull<2))
        { // max of 9 targets can be preset
            if (GetIsObjectValid(oTest) && (!GetObjectHeard(oListening, oTest)))
            {
                if (bFloat)
                    FloatingTextStringOnCreature(sText, oTest, FALSE);
                else
                    SendMessageToPC(oTest, sText);
            }
            else nNull++;
            n++;
            oTest = GetLocalObject(oListening, "DMFIListen" + IntToString(n));
        } // max of 9 targets can be preset
    }
}

void SendVarBasedText(object oPC, string sText, int bFloat= FALSE, int nColor=-1, string sVar="", int nValue=-1, int nLevel=0)
{	//Purpose: Function for sending variable based text
    //Original Scripter: Demetrious
    //Last Modified By: Demetrious 10/18/6
	object oTest;
	
	if (nColor!=-1) sText = ColorText(sText, nColor);
	
	if (nLevel==0)
	{ // PC Only message
		if (((nValue==-1) && (GetLocalInt(oPC, sVar)!=0)) || (GetLocalInt(oPC, sVar)==nValue))
		{
			if (bFloat)
				FloatingTextStringOnCreature(sText, oPC, FALSE, 3.0);
			else
				SendMessageToPC(oPC, sText);
		}			
	}
	else if (nLevel==1)
	{  // Check PC Party for variable state
		oTest = GetFirstFactionMember(oPC, TRUE);
	
		while (oTest!=OBJECT_INVALID)
		{
			if (((nValue==-1) && (GetLocalInt(oPC, sVar)!=0)) || (GetLocalInt(oPC, sVar)==nValue))
			{
				if (bFloat)
					FloatingTextStringOnCreature(sText, oTest, FALSE, 3.0);
				else
					SendMessageToPC(oTest, sText);
			}
			oTest = GetNextFactionMember(oPC, TRUE);		
		}
	}
	else if (nLevel==2)
	{ // Check every PC on server for variable state
		oTest = GetFirstPC();
		
		while (oTest!=OBJECT_INVALID)
		{ // cycle through all PCs
			if (((nValue==-1) && (GetLocalInt(oPC, sVar)!=0)) || (GetLocalInt(oPC, sVar)==nValue))
			{
				if (bFloat)
					FloatingTextStringOnCreature(sText, oTest, FALSE, 3.0);
				else
					SendMessageToPC(oTest, sText);
				
			}			
			oTest = GetNextFactionMember(oPC, TRUE);
		}
	}
}	

string ColorText(string sString, int nColor)
{ // PURPOSE: To convert sString to specified color:  Note a few
  // colors I went to "light" versions.  This was based on my 
  // preference.  A complete list of supported colors are in 
  // nwn2_color.2da	
  //Original Scripter: Demetrious
  //Last Modified By: Demetrious 11/13/6
  
  if (nColor==COLOR_BLACK)
  	return "<color=black>"+sString+"</color>";
  else if (nColor==COLOR_BLUE)
    return "<color=cornflowerblue>"+sString+"</color>";						
  else if (nColor==COLOR_BLUE_DARK)
  	return "<color=steelblue>"+sString+"</color>"; 
  else if (nColor==COLOR_BROWN)
  	return "<color=burlywood>"+sString+"</color>";
  else if (nColor==COLOR_BROWN_DARK)
  	return "<color=saddlebrown>"+sString+"</color>";
  else if (nColor==COLOR_CYAN)
    return "<color=cyan>"+sString+"</color>";	
  else if (nColor==COLOR_GREEN)
  	return "<color=lightgreen>"+sString+"</color>";
  else if (nColor==COLOR_GREEN_DARK)
  	return "<color=darkgreen>"+sString+"</color>";		
  else if (nColor==COLOR_GREY)
    return "<color=lightgrey>"+sString+"</color>";
  else if (nColor==COLOR_MAGENTA)
  	return "<color=magenta>"+sString+"</color>";
  else if (nColor==COLOR_ORANGE)
  	return "<color=orange>"+sString+"</color>";	
  else if (nColor==COLOR_ORANGE_DARK)
  	return "<color=darkorange>"+sString+"</color>";
  else if (nColor==COLOR_RED)
  	return "<color=red>"+sString+"</color>";	
  else if (nColor==COLOR_RED_DARK)
  	return "<color=darkred>"+sString+"</color>"; 
  else if (nColor==COLOR_WHITE)
    return "<color=white>"+sString+"</color>";		
  else if (nColor==COLOR_YELLOW)
  	return "<color=yellow>"+sString+"</color>";	
  else if (nColor==COLOR_YELLOW_DARK)
  	return "<color=gold>"+sString+"</color>";
			
  return sString;
}

//void main(){}