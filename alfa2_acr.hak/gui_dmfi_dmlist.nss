////////////////////////////////////////////////////////////////////////////////
// gui_dmfi_dmlist - DM Friendly Initiative - GUI script for the DM 30 Entry List
// Original Scripter:  Demetrious      Design: DMFI Design Team
//------------------------------------------------------------------------------
// Last Modified By:   Demetrious           12/12/6
//------------------------------------------------------------------------------
////////////////////////////////////////////////////////////////////////////////
// NOTE: Two UIs actually run through this script.
// One is the 30 DM LIST UI and the second is the PLAYER CHOOSE LANGUAGE UI.
// Saves us one script in the package.


#include "dmfi_inc_command"

void main(string sInput)
{
	object oPC = GetControlledCharacter(OBJECT_SELF);
	object oTool = DMFI_GetTool(OBJECT_SELF);
	string sCommand, sNum, sPage, sValue, sTest, sScreen;
	int nNum, nPage, nCurrent, n;
		
	sPage = GetLocalString(OBJECT_SELF, DMFI_UI_PAGE);
	
	// HANDLE NEXT AND PREVIOUS BUTTONS
	if (sInput=="next")
	{
		nNum = GetLocalInt(OBJECT_SELF, sPage + DMFI_CURRENT);
		SetLocalInt(OBJECT_SELF, sPage + DMFI_CURRENT, nNum+1);
		DMFI_ShowDMListUI(OBJECT_SELF);
		return;
	}	
	if (sInput=="prev")
	{
		nNum = GetLocalInt(OBJECT_SELF, sPage + DMFI_CURRENT);
		SetLocalInt(OBJECT_SELF, sPage + DMFI_CURRENT, nNum-1);
		DMFI_ShowDMListUI(OBJECT_SELF);
		return;
	}	
		
	sNum = GetStringRight(sInput, (GetStringLength(sInput)-4));  // Remove 'list'
	nNum = StringToInt(sNum);	
	
	sCommand = GetLocalString(OBJECT_SELF, DMFI_LAST_UI_COM);
	
	// SPECIAL EXCEPTION FOR A LIST CALLING A SUB-LIST:  Number >> Dice >> ACTION
	if ((sPage==PG_LIST_10) && (sCommand==PRM_ROLL + PRM_))
	{
		SetLocalString(OBJECT_SELF, DMFI_LAST_UI_COM, sCommand + sNum);		
		SetLocalString(OBJECT_SELF, DMFI_UI_PAGE, PG_LIST_DICE);
		SetGUIObjectText(OBJECT_SELF, SCREEN_DMFI_DMLIST, "DMListTitle", -1, TXT_CHOOSE_TYPE);
		n=0;
		while (n<10)
		{
			sTest = GetLocalString(oTool, LIST_PREFIX + PG_LIST_DICE + "." + IntToString(n));
			SetGUIObjectText(OBJECT_SELF, SCREEN_DMFI_DMLIST, "dmlist"+IntToString(n+1), -1, sTest);
			n++;
		}		
		return;
	}
	
	CloseGUIScreen(OBJECT_SELF, SCREEN_DMFI_DMLIST);
		
	// SPECIAL EXCEPTIONS WHERE WE HAVE TO UPDATE THE COMMAND FROM "ABOVE"
	if (sCommand==PRM_SET + PRM_ + PRM_AMBIENT + PRM_)
	{
		sCommand = sCommand + GetLocalString(oTool, DMFI_AMB_NIGHT) + PRM_;
	}
	else if (sCommand==PRM_SET + PRM_ + PRM_MUSIC + PRM_)
	{
		sCommand = sCommand + GetLocalString(oTool, DMFI_MUSIC_TIME) + PRM_;
	}				
	
	sPage = GetLocalString(OBJECT_SELF, DMFI_UI_PAGE);
	nPage = GetLocalInt(OBJECT_SELF, sPage + DMFI_CURRENT);
	nCurrent = (nPage*30) + nNum-1;

	// SPECIAL EXCEPTION FOR UPDATING NUMERIC VALUES THAT ARE CURRENTLY DISPLAYED ON THE UI		
	if (FindSubString(sCommand, PRM_UPDATE)!=-1)
	{
		// Get the screen because we need it to update the values
		sScreen = GetLocalString(OBJECT_SELF, "DMFI_UI_USE");
		sScreen = SCREEN_DMFI_ + sScreen;
	
		sTest = GetStringRight(sCommand, GetStringLength(sCommand)-7);
				
		if (GetLocalInt(OBJECT_SELF, DMFI_REQ_INT)==2)
			sValue = IntToString(nCurrent);
		else if (GetLocalInt(OBJECT_SELF, DMFI_REQ_INT))
			sValue = IntToString(GetLocalInt(oTool, LIST_PREFIX + sPage + "." + IntToString(nCurrent)));
		else	
			sValue = GetLocalString(oTool, LIST_PREFIX + sPage + "." + IntToString(nCurrent));
				
		DMFI_UpdateNumberToken(oTool, sTest, sValue);
		SetGUIObjectText(OBJECT_SELF, sScreen, "update_" + sTest, -1, sValue);  // GUI Buttons must be named "update_PARAM"
		CloseGUIScreen(OBJECT_SELF, SCREEN_DMFI_DMLIST);
		return;
	}	

	// SPECIAL EXCEPTION FOR THE DISPLAY PREFIX FOR SOUND ENTRIES	
	if (FindSubString(sPage, "DISPLAY")!=-1)
		sPage = GetStringRight(sPage, GetStringLength(sPage)-7);
		
	// SPECIAL EXCEPTION TO HIDE THE CHOOSEN LANGUAGE BUTTON
	if (FindSubString(sCommand, PRM_GRANT)!=-1)
		SetGUIObjectHidden(OBJECT_SELF, SCREEN_DMFI_CHOOSE, "btn"+IntToString(nCurrent+1), TRUE);	
	
	// FINALLY FINISHED WITH EXCEPTIONS... We grab the result and run the command.
	if (GetLocalInt(OBJECT_SELF, DMFI_REQ_INT)==2)		// actual list location
		sCommand = sCommand + IntToString(nCurrent);
	else if (GetLocalInt(OBJECT_SELF, DMFI_REQ_INT))		// replaced int value
		sCommand = sCommand + IntToString(GetLocalInt(oTool, LIST_PREFIX + sPage + "." + IntToString(nCurrent)));
	else						// string value
		sCommand = sCommand + GetLocalString(oTool, LIST_PREFIX + sPage + "." + IntToString(nCurrent));

	if (sPage==PG_LIST_DMLANGUAGE)
	{  // We have to set this BEFORE the command code because we loose access to OBJECT_SELF
		sTest =  GetLocalString(oTool, LIST_PREFIX + sPage + "." + IntToString(nCurrent));
		SetLocalString(OBJECT_SELF, DMFI_LANGUAGE_TOGGLE, GetStringLowerCase(sTest));	
	}	
		
		
	oPC = DMFI_UITarget(OBJECT_SELF, oTool);
	DMFI_DefineStructure(oPC, sCommand);
	DMFI_RunCommandCode(oTool, oPC, sCommand);
}				