////////////////////////////////////////////////////////////////////////////////
// gui_dmfi_dmui - DM Friendly Initiative - GUI script for top level DM UI
// Original Scripter:  Demetrious      Design: DMFI Design Team
//------------------------------------------------------------------------------
// Last Modified By:   Demetrious           12/19/6  qk: 10/07/07
//------------------------------------------------------------------------------
////////////////////////////////////////////////////////////////////////////////

// This script handles the TOP LEVEL DM UI.  It performs a pretty straightforward initialization
// of the text boxes for the TOOL LEVEL UIs.  A flag is set so that we can run all the UI code
// from one single script for all "tool level" UIs.

// TRANSLATION NOTE:  TEXT HERE REQUIRES TRANSLATION

#include "dmfi_inc_command"

void main(string sInput)
{
	object oPC = OBJECT_SELF;
	object oRename, oTest, oTarget;
	object oTool = DMFI_GetTool(oPC);
	string sTest;

	// CLOSE ALL OTHER UIs Just in case		
	CloseGUIScreen(oPC, SCREEN_DMFI_VFXTOOL);
	CloseGUIScreen(oPC, SCREEN_DMFI_SNDTOOL);
	CloseGUIScreen(oPC, SCREEN_DMFI_AMBTOOL);
	CloseGUIScreen(oPC, SCREEN_DMFI_MUSICTOOL);
	CloseGUIScreen(oPC, SCREEN_DMFI_DICETOOL);
	CloseGUIScreen(oPC, SCREEN_DMFI_DMLIST);
	DMFI_ClearUIData(oPC);
	
	if (sInput=="vfx")
	{
		SetGUIObjectText(oPC, SCREEN_DMFI_VFXTOOL, "ListTitle", -1, CV_VFX + "\n" + CV_TOOL);
		DisplayGuiScreen(oPC, SCREEN_DMFI_VFXTOOL, FALSE, "dmfivfxtool.xml");
		
		SetLocalString(oPC, "DMFI_UI_USE", "VFXTOOL");
				
		sTest = GetLocalString(oTool, DMFI_VFX_DURATION);
		SetGUIObjectText(oPC, SCREEN_DMFI_VFXTOOL, "update_dur", -1, sTest);
						
		SetGUIObjectText(oPC, SCREEN_DMFI_VFXTOOL, "sub1", -1, CV_VF_SPELLS);
		SetGUIObjectText(oPC, SCREEN_DMFI_VFXTOOL, "sub2", -1, CV_VF_INVOCATION);
		SetGUIObjectText(oPC, SCREEN_DMFI_VFXTOOL, "sub3", -1, CV_VF_DURATION);
		SetGUIObjectText(oPC, SCREEN_DMFI_VFXTOOL, "sub4", -1, CV_VF_MISC);
		SetGUIObjectText(oPC, SCREEN_DMFI_VFXTOOL, "sub5", -1, CV_VF_RECENT);
	}	

	else if (sInput=="ambient")
	{
		SetGUIObjectText(oPC, SCREEN_DMFI_AMBTOOL, "ListTitle", -1, CV_AMBIENT + "\n" + CV_TOOL);
		DisplayGuiScreen(oPC, SCREEN_DMFI_AMBTOOL, FALSE, "dmfiambtool.xml");
		
		sTest = GetLocalString(oTool, DMFI_AMB_NIGHT);
		sTest = DMFI_CapitalizeWord(sTest);
		SetGUIObjectText(oPC, SCREEN_DMFI_AMBTOOL, "toggle_ambdaynight", -1, sTest);
		
		sTest = GetLocalString(oTool, DMFI_AMBIENT_VOLUME);
		SetGUIObjectText(oPC, SCREEN_DMFI_AMBTOOL, "update_vol", -1, sTest);	
				
		SetLocalString(oPC, "DMFI_UI_USE", "AMBTOOL");
		
		SetGUIObjectText(oPC, SCREEN_DMFI_AMBTOOL, "sub1", -1,CV_AM_CAVE);
		SetGUIObjectText(oPC, SCREEN_DMFI_AMBTOOL, "sub2", -1,CV_AM_MAGIC);
		SetGUIObjectText(oPC, SCREEN_DMFI_AMBTOOL, "sub3", -1,CV_AM_PEOPLE);
		SetGUIObjectText(oPC, SCREEN_DMFI_AMBTOOL, "sub4", -1,CV_AM_MISC);
		SetGUIObjectHidden(oPC, SCREEN_DMFI_AMBTOOL, "sub5", TRUE);
		
		
	}	
	else if (sInput=="sounds")
	{
		SetGUIObjectText(oPC, SCREEN_DMFI_SNDTOOL, "ListTitle", -1, CV_SOUND + "\n" + CV_TOOL);
		DisplayGuiScreen(oPC, SCREEN_DMFI_SNDTOOL, FALSE, "dmfisndtool.xml");
		
		sTest = GetLocalString(oTool, DMFI_SOUND_DELAY);
		SetGUIObjectText(oPC, SCREEN_DMFI_SNDTOOL, "update_delay", -1, sTest);	
				
		SetLocalString(oPC, "DMFI_UI_USE", "SNDTOOL");
		SetGUIObjectText(oPC, SCREEN_DMFI_SNDTOOL, "sub1", -1, CV_SD_CITY);
		SetGUIObjectText(oPC, SCREEN_DMFI_SNDTOOL, "sub2", -1, CV_SD_MAGIC);
		SetGUIObjectText(oPC, SCREEN_DMFI_SNDTOOL, "sub3", -1, CV_SD_NATURE);
		SetGUIObjectText(oPC, SCREEN_DMFI_SNDTOOL, "sub4", -1, CV_SD_PEOPLE);	
		SetGUIObjectHidden(oPC, SCREEN_DMFI_SNDTOOL, "sub5", TRUE);
	}	
	
	else if (sInput=="music")
	{
		SetGUIObjectText(oPC, SCREEN_DMFI_MUSICTOOL, "ListTitle", -1, CV_MUSIC + "\n" + CV_TOOL);
		DisplayGuiScreen(oPC, SCREEN_DMFI_MUSICTOOL, FALSE, "dmfimusictool.xml");
		
		sTest = GetLocalString(oTool, DMFI_MUSIC_TIME);
		sTest = DMFI_CapitalizeWord(sTest);
		SetGUIObjectText(oPC, SCREEN_DMFI_MUSICTOOL, "toggle_musictime", -1, sTest);
				
		SetLocalString(oPC, "DMFI_UI_USE", "MUSICTOOL");
		SetGUIObjectText(oPC, SCREEN_DMFI_MUSICTOOL, "sub1", -1, CV_MC_NWN2);
		SetGUIObjectText(oPC, SCREEN_DMFI_MUSICTOOL, "sub2", -1, CV_MC_NWN1);
		SetGUIObjectText(oPC, SCREEN_DMFI_MUSICTOOL, "sub3", -1, CV_MC_XP);
		SetGUIObjectText(oPC, SCREEN_DMFI_MUSICTOOL, "sub4", -1, CV_MC_BATTLE);
		SetGUIObjectText(oPC, SCREEN_DMFI_MUSICTOOL, "sub5", -1, CV_MC_MOTB);
		//SetGUIObjectHidden(oPC, SCREEN_DMFI_MUSICTOOL, "sub5", TRUE);
	}
	
	else if (sInput=="dice")
	{
		SetGUIObjectText(oPC, SCREEN_DMFI_DICETOOL, "ListTitle", -1, CV_DICE + "\n" + CV_TOOL);
		DisplayGuiScreen(oPC, SCREEN_DMFI_DICETOOL, FALSE, "dmfidicetool.xml");
		
		sTest = GetLocalString(oTool, DMFI_DICEBAG_DC);
		SetGUIObjectText(oPC, SCREEN_DMFI_DICETOOL, "update_dc", -1, sTest);
		
		sTest = GetLocalString(oTool, DMFI_DICEBAG_DETAIL);
		sTest = DMFI_CapitalizeWord(sTest);
		SetGUIObjectText(oPC, SCREEN_DMFI_DICETOOL, "toggle_detail", -1, sTest);	
			
		sTest = GetLocalString(oTool, DMFI_DICEBAG_REPORT);
		sTest = DMFI_CapitalizeWord(sTest);
		SetGUIObjectText(oPC, SCREEN_DMFI_DICETOOL, "toggle_report", -1, sTest);
		
		sTest = GetLocalString(oTool, DMFI_DICEBAG_ROLL);
		sTest = DMFI_CapitalizeWord(sTest);
		SetGUIObjectText(oPC, SCREEN_DMFI_DICETOOL, "toggle_roll", -1, sTest);	
			
		SetLocalString(oPC, "DMFI_UI_USE", "DICETOOL");
		SetGUIObjectText(oPC, SCREEN_DMFI_DICETOOL, "sub1", -1, CV_DI_ABIL);
		SetGUIObjectText(oPC, SCREEN_DMFI_DICETOOL, "sub2", -1, CV_DI_SKILL);
		SetGUIObjectText(oPC, SCREEN_DMFI_DICETOOL, "sub3", -1, CV_DI_DICE);	
	}
	// Follow On runs straight via here.	
	else
	{
		SetLocalString(oPC, DMFI_LAST_UI_COM, PRM_LANGUAGE + PRM_);
		SetLocalString(oPC, DMFI_UI_PAGE, PG_LIST_DMLANGUAGE);
		SetLocalString(oPC, DMFI_UI_LIST_TITLE, TXT_CHOOSE_LANGUAGE);
		DMFI_ShowDMListUI(oPC);
	}
}			