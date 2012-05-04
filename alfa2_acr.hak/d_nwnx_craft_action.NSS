/******************************************************************************
*****                    Dialog_nwnx_craft_action                         *****
*****                               V 1                                   *****
*****                             11/29/07                                *****
******************************************************************************/

//used on : action of a dlg_nwnx_craft dialog node
//purpose : do the craft thing

//parameters :
//-------------> iAction : the type of action to be performed. possible values are : 
//                0 = Cancel ; 1 = Tint1 ; 2 = Tint2 ; 3 = Tint3 ;
//				  4 = First ; 5 = Previous ; 6 = Next ; 7 = Last ;
//				  8 = ArmorVisualType ; 9 = Validate ; 10 = Exit
//-------------> iAvtValue : the ArmorVisualType value when performing an AVT change (action = 8)
//				 value between 0 and 10 (cloth to naked)


#include "acr_db_persist_i"
#include "nwnx_craft_system"
#include "dmfi_inc_inc_com"


//as usual, see readme file for details

/* these constatns are declared in nwnx_craft_system 
const int XP_CRAFT_ACTION_CANCEL = 0;
const int XP_CRAFT_ACTION_TINT_1 = 1;
const int XP_CRAFT_ACTION_TINT_2 = 2;
const int XP_CRAFT_ACTION_TINT_3 = 3;
const int XP_CRAFT_ACTION_FIRST = 4;
const int XP_CRAFT_ACTION_PREVIOUS = 5;
const int XP_CRAFT_ACTION_NEXT = 6;
const int XP_CRAFT_ACTION_LAST = 7;
const int XP_CRAFT_ACTION_SET_AVT = 8;
const int XP_CRAFT_ACTION_VALIDATE = 9;
const int XP_CRAFT_ACTION_EXIT = 10;
const int XP_CRAFT_ACTION_SELECT_ARMOR_PIECE = 11;
*/

void main(int iAction, int iAvtValue)
{
	object oPC = GetPCSpeaker();//since the player speaks to himself in that dialog, one could use OBJECT_SELF instead of PCSpeaker()

	if (GetLocalInt(oPC, "XC_CRAFT_DELAY")) {
		switch (iAction) {
			// ignore forced delay
			case XP_CRAFT_ACTION_CANCEL:
			case XP_CRAFT_ACTION_EXIT:
			case XP_CRAFT_ACTION_SET_AVT:
			case XP_CRAFT_ACTION_SELECT_ARMOR_PIECE:
				break;

			// Prevent premature execution
			case XP_CRAFT_ACTION_VALIDATE:
			case XP_CRAFT_ACTION_TINT_1:
			case XP_CRAFT_ACTION_TINT_2:
			case XP_CRAFT_ACTION_TINT_3:
			default:
				return;
		}
	}

	SetLocalInt(oPC, "XC_CRAFT_DELAY", 1);
	DelayCommand(XP_CRAFT_TALK_DELAY, DeleteLocalInt(oPC, "XC_CRAFT_DELAY"));
	
	//Check for the object to craft
	int iInventorySlot = GetLocalInt(oPC,"XC_INVENT_SLOT");
	int nNetWorth = -1, nOldNetWorth = -1;
	object oLast;
	object oItemToCraft = GetItemInSlot(iInventorySlot,oPC);
	
	// SendMessageToAllDMs("Crafting attempt {"+GetName(oPC)+","+GetName(oItemToCraft)+","+IntToString(iAction)+"}");
		
	if((oItemToCraft==OBJECT_INVALID) && (iAction!=XP_CRAFT_ACTION_EXIT))
	{
		XPCraft_Debug(oPC,"No Item In Slot : " + IntToString(iInventorySlot)+ "- restoring last unchanged Item");
		XPCraft_ActionCancelChanges(oPC);		
		return;
	}//END
	
	oLast = GetLocalObject(oPC, "XC_ITEM_TO_CRAFT");
	
	if (GetIsObjectValid(oLast) && (oLast != oItemToCraft)) 
	{
		ActionEquipItem(oLast, iInventorySlot);
		oItemToCraft = oLast;
		XPCraft_Debug(oPC,"Attempting to craft incorrect item.  Restoring.");
	}	
	
	//ACTION MANGEMENT
	//since we can't declare a variable into a case statement, we do it here though it won't be used in every case.
	string sSubAction =  GetStringLeft( GetLocalString(oPC,"XC_ROAD_MAP"),2);
	//sub action we be like "Va" for Variation, "Ar" for ArmorVisualType, "AC" for ArmorParts and "Mo" for ModelParts 
	
	// cache original networth to compare at conclusion
	if (GetLocalInt(oPC, "networth_assert") == 0) {
		nNetWorth = DMFI_GetNetWorth(oPC);
		SetLocalInt(oPC, "networth_assert", nNetWorth);
	}
	
	SetLocalObject(oPC, "XC_LAST_CRAFTED", oItemToCraft);
	switch(iAction)
	{		
		case XP_CRAFT_ACTION_EXIT ://Terminate the craft dialog
			XPCraft_Debug(oPC,"Craft Session Ended");
			XPCraft_CleanLocals(oPC);
			nNetWorth = DMFI_GetNetWorth(oPC);
			nOldNetWorth = GetLocalInt(oPC, "networth_assert");

			// This should never execute, yet...
			if (nOldNetWorth <= 0)
				nOldNetWorth = nNetWorth;

			if (nOldNetWorth < nNetWorth) {
				WriteTimestampedLogEntry("NETWORTH_ASSERT: Net worth of "+GetName(oPC)+" increased from "+IntToString(nOldNetWorth) + " to " + IntToString(nNetWorth));
			}
			
			DeleteLocalInt(oPC, "networth_assert");
			break;
		
		case XP_CRAFT_ACTION_VALIDATE ://Confirm the changes made 
			ACR_IncrementStatistic("XP_CRAFT_ADJUST_ITEM");
			XPCraft_OnChangesConfirmed(oPC, oItemToCraft);
			XPCraft_CleanLocals(oPC);
			XPCraft_Debug(oPC,"Changes Confirmed"); 
			break;
			
		case XP_CRAFT_ACTION_CANCEL ://cancel the changes made 
			//récupération de l'ancien item
			XPCraft_ActionCancelChanges(oPC);
			XPCraft_ActionSelectArmorPiece(oPC, 0); // Unselect the current armor piece if we were editing one.
			XPCraft_Debug(oPC,"Changes Cancelled"); 
			break;
			
		case XP_CRAFT_ACTION_TINT_1 ://change colors (without a break once it enters the statement
		case XP_CRAFT_ACTION_TINT_2 ://it'll execute whatever comes after ;) )
		case XP_CRAFT_ACTION_TINT_3 ://
			SetLocalInt(oPC,"XC_ACTION_TINT",iAction);
			SetLocalInt(oPC, "XC_ITEM_COLOR_CRAFTED",0);
			DisplayGuiScreen(oPC,"SCREEN_COLOR_TLS",TRUE,"elechos_colortls.xml");
			break;
			
		case XP_CRAFT_ACTION_SET_AVT ://sets a new ArmorVisualType
		//previously using the same Next/Previous system  than for Vairations and ArmorPArts... ,
		// i've changed for this approach in order to make it more readeable for the end user
		//since AVTypes are number that truly means something (unlike Variations, ArmorParts or ModelParts)
			SetLocalObject(oPC,"XC_ITEM_TO_CRAFT", XPCraft_ActionChangeArmorVisualType(oPC, oItemToCraft, iAvtValue));
			break;
			
		case XP_CRAFT_ACTION_SELECT_ARMOR_PIECE:// Choose an armor piece in this items armor set to edit.
			XPCraft_ActionSelectArmorPiece(oPC, iAvtValue);
			break;

		default://any other action (next or previous, since First and Last weren't displayed in the dialog)
			//SubAction Mangement
			if(sSubAction == "Va")
			{
				SetLocalObject(oPC,"XC_ITEM_TO_CRAFT", XPCraft_ActionChangeVariation(oPC, oItemToCraft, iAction));
			}
			else if(sSubAction == "AC")
			{
				SetLocalObject(oPC,"XC_ITEM_TO_CRAFT", XPCraft_ActionChangeArmorPart(oPC, oItemToCraft, iAction));
			}
			else if(sSubAction == "Mo")
			{
				SetLocalObject(oPC,"XC_ITEM_TO_CRAFT", XPCraft_ActionChangeModelPart(oPC, oItemToCraft, iAction));
			}
			else
			{//won't actually happend with this dialog
			
			}		
			break;	
	}
	
	//SendMessageToAllDMs("Crafting completed {"+GetName(oPC)+","+GetName(oItemToCraft)+","+IntToString(iAction)+"}");
}
