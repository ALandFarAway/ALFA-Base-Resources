/******************************************************************************
*****                    Dialog_nwnx_craft_escape_dialog                  *****
*****                               V 1                                   *****
*****                             11/29/07                                *****
******************************************************************************/

//used on : escape of the craft dialog 
//purpose : cancel the lasts changes


#include "nwnx_craft_system"
#include "dmfi_inc_inc_com"

void main()
{
    object oPC = GetPCSpeaker();
	XPCraft_Debug(oPC,"Dialog Aborted !");

	XPCraft_ActionCancelChanges(oPC);

	if (GetLocalInt(oPC, "networth_assert") < DMFI_GetNetWorth(oPC)) {
		WriteTimestampedLogEntry("NETWORTH_ASSERT: Net worth of "+GetName(oPC)+" increased from "+IntToString(GetLocalInt(oPC, "networth_assert")) + " to " + IntToString(DMFI_GetNetWorth(oPC)));
	}
	DeleteLocalInt(oPC, "networth_assert");
}
