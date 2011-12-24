/******************************************************************************
*****                    Dialog_nwnx_craft_escape_dialog                  *****
*****                               V 1                                   *****
*****                             11/29/07                                *****
******************************************************************************/

//used on : escape of the craft dialog 
//purpose : cancel the lasts changes


#include "nwnx_craft_system"

void main()
{
    object oPC = GetPCSpeaker();
	XPCraft_Debug(oPC,"Dialog Aborted !");

	XPCraft_ActionCancelChanges(oPC);
}