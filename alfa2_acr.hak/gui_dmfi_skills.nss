////////////////////////////////////////////////////////////////////////////////
// gui_dmfi_skills - DM Friendly Initiative - GUI script for SKILL UI
// Original Scripter:  Demetrious      Design: DMFI Design Team
//------------------------------------------------------------------------------
// Last Modified By:   Demetrious           12/12/6
//------------------------------------------------------------------------------
////////////////////////////////////////////////////////////////////////////////

#include "dmfi_inc_tool"
#include "dmfi_inc_command"
#include "dmfi_inc_sendtex"

void main(string sInput)
{
	object oPC = OBJECT_SELF;
	object oPossess;
	object oTool = DMFI_GetTool(oPC);
	string sCommand;
	string sValue;
	string sNum;
	int n;
	int nNum;
	
	sNum = GetStringRight(sInput, (GetStringLength(sInput)-4));
	nNum = StringToInt(sNum);	

	CloseGUIScreen(oPC, SCREEN_DMFI_SKILLS);
	
	sValue = GetLocalString(oTool, LIST_PREFIX + PG_LIST_SKILL + "." + IntToString(nNum-1));
	sValue = GetStringLowerCase(sValue);
			
	sCommand = PRM_ROLL + PRM_ + sValue;
	//SendText(oPC, "DEBUG: sCommand skill: " + sCommand);
	DMFI_UITarget(oPC, oTool);	
	DMFI_DefineStructure(oPC, sCommand);
	DMFI_RunCommandCode(oTool, oPC, sCommand);
}				