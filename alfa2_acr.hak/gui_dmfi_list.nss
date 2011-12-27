////////////////////////////////////////////////////////////////////////////////
// gui_dmfi_list - DM Friendly Initiative - GUI script for LIST UI
// Original Scripter:  Demetrious      Design: DMFI Design Team
//------------------------------------------------------------------------------
// Last Modified By:   Demetrious           12/12/6
//------------------------------------------------------------------------------
////////////////////////////////////////////////////////////////////////////////
// This UI serves 4 purposes within the player client:
//	*Abilities
//	*Languages
//	*Dice Number
//	**Dice Selection (Recursive)

#include "dmfi_inc_command"

void main(string sInput)
{
	object oPC = OBJECT_SELF;
	object oTool = DMFI_GetTool(oPC);
	object oPossess;
	string sCommand;
	string sValue;
	string sText;
	int n;
	
	int nNum = StringToInt(GetStringRight(sInput, 1));
	int nPrior = GetLocalInt(oPC, DMFI_LIST_PRIOR);
	
	if (nPrior == DMFI_LIST_NUMBER)
	{
		SetLocalString(oPC, DMFI_LAST_COMMAND, PRM_ROLL + PRM_ + IntToString(nNum));		
		SetLocalInt(oPC, DMFI_LIST_PRIOR, DMFI_LIST_TYPE);
		
		SetGUIObjectText(oPC, SCREEN_DMFI_LIST, DMFI_UI_LISTTITLE, -1, TXT_CHOOSE_TYPE);
		n=0;
		while (n<10)
		{
			sText = GetLocalString(oTool, LIST_PREFIX + PG_LIST_DICE + "." + IntToString(n));
			SetGUIObjectText(oPC, SCREEN_DMFI_LIST, DMFI_UI_LIST+IntToString(n+1), -1, sText);
			n++;
		}		
		SetLocalInt(oPC, DMFI_LIST_PRIOR, DMFI_LIST_TYPE);
	}
	else
	{	
		CloseGUIScreen(oPC, SCREEN_DMFI_LIST);
		
		if (nPrior == DMFI_LIST_TYPE)
		{
			sCommand = GetLocalString(oPC, DMFI_LAST_COMMAND);
			sCommand = sCommand + GetLocalString(oTool, LIST_PREFIX + PG_LIST_DICE + "." + IntToString(nNum-1));
		}
		else if (nPrior == DMFI_LIST_ABILITY)
		{
			sValue = GetLocalString(oTool, LIST_PREFIX + PG_LIST_ABILITY + "." + IntToString(nNum-1));
			sValue = GetStringLowerCase(sValue);
				
			sCommand = PRM_ROLL + PRM_ + sValue;
		}
		else if (nPrior == DMFI_LIST_LANG)
		{
			sValue = GetLocalString(oTool, LIST_PREFIX + PG_LIST_LANGUAGE + "." + IntToString(nNum-1));
			sValue = GetStringLowerCase(sValue);
				
			sCommand = PRM_LANGUAGE + PRM_ + sValue;
		}
		DMFI_UITarget(oPC, oTool);		
		DMFI_DefineStructure(oPC, sCommand);
		DMFI_RunCommandCode(oTool, oPC, sCommand);	
	}		
}				