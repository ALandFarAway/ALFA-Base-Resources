////////////////////////////////////////////////////////////////////////////////
// dmfi_exe_tool - DM Friendly Initiative - Script for DMFI Tool Activation
// Original Scripter:  Demetrious      Design: DMFI Design Team
//------------------------------------------------------------------------------
// Last Modified By:   Demetrious           1/5/7
//                     AcadiusLost			11/3/2007  (disabled ACR corpse renaming)
//------------------------------------------------------------------------------
////////////////////////////////////////////////////////////////////////////////

#include "dmfi_inc_initial"
#include "dmfi_inc_inc_com"
#include "acr_death_i"

void main()
{
    object oPC;
    object oTarget;
    object oTool;
    string sResRef;

    oPC = GetItemActivator();
    oTarget = GetItemActivatedTarget();
    oTool = GetItemActivated();
    sResRef = GetResRef(oTool);
	
	if ((!DMFI_GetIsDM(oPC)) && (sResRef==DMFI_TOOL_RESREF))
	{  // Make sure Players can't use a DM Tool
		SetPlotFlag(oTool, FALSE);
		DestroyObject(oTool);
		return;
	}		
	
	if (ACR_GetIsCorpseToken(oTarget)) 
	{
	    SendMessageToPC(oPC, "Renaming of corpses is not allowed."); 
	    return;
	}   
	SetLocalObject(oTool, DMFI_TARGET, oTarget);
	DMFI_RenameObject(oPC, oTarget);
}