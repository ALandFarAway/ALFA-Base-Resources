/******************************************************************************
*****                         nwnx_craft_Item_Init                        *****
*****                               V 1                                   *****
*****                             11/29/07                                *****
******************************************************************************/

//used on : action of a dlg_nwnx_craft dialog
//purpose : stores the item within the Bioware database
// and initialize the local vars with values fetched form the plugin

//parameters :
//-------------> bStore : 0=> init mode ; 1=> Store mode
//				 first one to be called is surelly the store mode.
//-------------> iInventorySlot : a NWN INVENTORY_SLOT_* constant
//-------------> sRoadMap : the road to the element containing the desired property (refer to gff files structure)

#include "nwnx_craft_system"

void main(int bStore, int iInventorySlot, string sRoadMap)
{
    object oPC = GetPCSpeaker();
	
	//Storage of the item wihtin the bioware database
	if(bStore==1)
	{//storing a persistant object is quite a time consuming process (it creates 3 files.... )
	//so we try not to do it if it's not necessary
	 
		object oItemToCraft = GetItemInSlot(iInventorySlot,oPC);
		
		if (oItemToCraft!=OBJECT_INVALID)
		{//never too carefull	
			XPCraft_StoreItemToCraft(oPC,oItemToCraft);
			SetLocalInt(oPC,"XC_INVENT_SLOT",iInventorySlot);
			SetLocalObject(oPC,"XC_ITEM_TO_CRAFT", oItemToCraft);
			object oSavedItem = CopyItem(oItemToCraft,GetLocalObject(GetModule(),"XC_HIDDEN_CONTAINER"),TRUE);
			SetLocalObject(GetModule(),"XC_TEMP_" + XPCraft_GetPCID(oPC),oSavedItem);

			//
			// Figure out which armor pieces are part of this items armor set in case
			// we were to edit it.
			//

			XPCraft_InitArmorSetMask(oPC);
		}
		else
		{		
			//todo : there's surely things to do in this specific case... 
			XPCraft_Debug(oPC,"No Item In Slot : " + IntToString(iInventorySlot));
		}		
		return;		
	}//END


	//initialisation of local vars
	
	SetLocalString(oPC,"XC_ROAD_MAP",sRoadMap);	
	string sSubAction = GetStringLeft(sRoadMap,2);

	if(sSubAction =="Va")
	{//initialising the Variation 
		XPCraft_InitVariationValues(oPC);
	}
	
	else if(sSubAction =="Ar")
	{//initialising the ArmorVisualType 
		XPCraft_InitArmorVisualTypeValues(oPC);
	}
		
	else if(sSubAction =="AC")
	{//initialising an ArmorPart 
		XPCraft_InitItemPartValues(oPC, sRoadMap + "|Accessory");
	}
		
	else if(sSubAction == "Mo")
	{//initialising a Weapon or Shield ModelPart	
		XPCraft_InitItemPartValues(oPC, sRoadMap);
	}
	
	else
	{//shouldn't be happening with this dialog
		
	}
}
