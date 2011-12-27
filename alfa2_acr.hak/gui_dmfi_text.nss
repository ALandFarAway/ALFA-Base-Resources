////////////////////////////////////////////////////////////////////////////////
// gui_dmfi_text - DM Friendly Initiative - Code to run all voice throw / language code
// Original Scripter:  Demetrious      Design: DMFI Design Team
//------------------------------------------------------------------------------
// Last Modified By:   Demetrious           1/25/7
//------------------------------------------------------------------------------
////////////////////////////////////////////////////////////////////////////////
// Script runs DM and Player side code for handling text entered from input box.

#include "dmfi_inc_initial"
#include "dmfi_inc_emotes"
#include "dmfi_inc_tool"
#include "dmfi_inc_lang"
#include "dmfi_inc_command"


void main (string sInput)
{
	int nState;
	object oPC = GetControlledCharacter(OBJECT_SELF);
	object oTarget, oTool;
	string sLang = GetLocalString(OBJECT_SELF, DMFI_LANGUAGE_TOGGLE);
	string sLangTest = GetLocalString(oPC, DMFI_LANGUAGE_TOGGLE);
	string sConvertUsing, sTest;
	
	//SendText(oPC, "DEBUG: sLang from ObjectSelf: " + sLang + " : " +GetName(OBJECT_SELF));	
	
	if (sInput==".language_off")
	{ // Close button on UI
		DMFI_LanguageOff(oPC);
		return;
	}	
	
	SetGUIObjectText(oPC, SCREEN_DMFI_TEXT, "INPUT_BOX", -1, "");
	oTarget = GetPlayerCurrentTarget(oPC);

	// Shortcut to run scripts from the text entry box
	if (GetStringLeft(sInput, 1)==DMFI_CHAR_RUNSCRIPT)
	{
		if (DMFI_GetIsDM(OBJECT_SELF) || DMFI_PC_RUNSCRIPT_ALLOWED)
		{
			sInput = GetStringRight(sInput, GetStringLength(sInput)-1);
			
			if (DMFI_RUNSCRIPT_PREFIX!="")
			{
				sTest = GetStringLeft(sInput, GetStringLength(DMFI_RUNSCRIPT_PREFIX));
				if (sTest!=DMFI_RUNSCRIPT_PREFIX)
					return;
			}
			SetLocalString(OBJECT_SELF, "DMFI_CUSTOM_CMD", sInput);
			SetLocalObject(OBJECT_SELF, "DMFI_CUSTOM_SPEAKER", oPC);
			SetLocalObject(OBJECT_SELF, "DMFI_CUSTOM_TARGET", oTarget);
			ExecuteScript(sInput, OBJECT_SELF);
		}
		return;
	}	

	if (GetStringLeft(sInput, 1)==DMFI_CHAR_CMD)
	{
		// outside standards are bit different for simplicity for
		// the end user.
		SetGUIObjectText(oPC, SCREEN_DMFI_TEXT, "INPUT_BOX", -1, "");
		SetLocalString(OBJECT_SELF, "DMFI_CUSTOM_CMD", sInput);
		SetLocalObject(OBJECT_SELF, "DMFI_CUSTOM_SPEAKER", oPC);
		SetLocalObject(OBJECT_SELF, "DMFI_CUSTOM_TARGET", oTarget);
		nState = DMFI_RunCommandPlugins(OBJECT_SELF);
		
		if (!nState)
		{
			// Redefine so we can run internal code via our standard
			oPC = OBJECT_SELF;
			oTool = DMFI_GetTool(oPC);
			sInput = GetStringRight(sInput, GetStringLength(sInput)-1);
			sInput = DMFI_UnderscoreToSpace(sInput);
				
			oPC = DMFI_UITarget(oPC, oTool);
			DMFI_DefineStructure(oPC, sInput);
			DMFI_RunCommandCode(oTool, oPC, sInput);
			
		}	
		DeleteLocalInt(GetModule(), DMFI_STRING_OVERRIDE);
		return;
	}	

	if (DMFI_GetIsDM(oPC))
	{ // DMs = Throw voice anywhere valid
		if (!GetIsObjectValid(oTarget)) 
			oTarget=oPC;
	}
	else
	{ // PCs = Throw voice to Associate Only
		if ((GetMaster(oTarget)!=oPC) || (!GetIsObjectValid(oTarget)))	
			oTarget = oPC;
	}			
		
	if ((DMFI_GetIsDM(oPC)) && (GetIsPC(oTarget)) && (oTarget!=oPC))
	{  // Send Message code for DMs
		SendText(oTarget, TXT_DM_MESS + sInput, TRUE, COLOR_CYAN);
        SendText(oPC, TXT_MESSAGE_DELIVERED + GetName(oTarget), TRUE, COLOR_GREEN);
		return;
	}		
	
	
	// 2/3/7 :: EDIT THIS WAS oPC = OBJECT_SELF NOT TESTED!!!! - Have to confirm EVERYTHING 
	oTool = DMFI_GetTool(OBJECT_SELF);

	if (DMFI_EMOTES_ENABLED)
	{
		if (FindSubString(sInput, DMFI_CHAR_EMOTE)!=-1)
	    {
	    	SetGUIObjectText(oPC, SCREEN_DMFI_TEXT, "INPUT_BOX", -1, "");
			SetLocalString(OBJECT_SELF, "DMFI_CUSTOM_CMD", sInput);
			SetLocalObject(OBJECT_SELF, "DMFI_CUSTOM_SPEAKER", oPC);
			SetLocalObject(OBJECT_SELF, "DMFI_CUSTOM_TARGET", oTarget);
			nState = DMFI_RunEmotePlugins(OBJECT_SELF);
			
			if (!nState)
			{
				DMFI_UITarget(oPC, oTool);
				SetLocalString(oPC, DMFI_HEARD_TEXT, sInput);
				DMFI_RunEmotes(oTool, oTarget, sInput);
				
			}
			DeleteLocalInt(GetModule(), DMFI_STRING_OVERRIDE);	
		}
	}
	else
	//	SendText(oPC, TXT_EMOTES_DISABLED, FALSE, COLOR_RED);
	
	sLang = DMFI_NewLanguage(sLang);
	sTest = DMFI_ProcessLanguage(sInput, sLang, oTool);

	if (sInput!="")
	{
		AssignCommand(oTarget, SpeakString(sTest));

		// Handle translation and send the speech log to the correct possessed DM state.
		if (oPC!=OBJECT_SELF)
			DMFI_TranslateToSpeakers(oTarget, sInput, sLang, oPC);
		else 
			DMFI_TranslateToSpeakers(oTarget, sInput, sLang, OBJECT_SELF);

	}
	
}	