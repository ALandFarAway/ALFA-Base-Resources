/******************************************************************************
*****                     Dialog_nwnx_craft_condition                     *****
*****                               V 1                                   *****
*****                             11/29/07                                *****
******************************************************************************/

//used on : condition of a dlg_nwnx_craft dialog node
//purpose : do the checks and display the nodes if bReturn==TRUE.

//parameters :
//-------------> iCondition : the condtion to be checked for. possible values are listed below
//-------------> iInventorySlot : the inventory slot of the choosen item ( NWN INVENTORY_SLOT_* constant)
//-------------> iVisualType : the value of the AVT to be displayed and checked for (see ArmorVisualData.2da)

#include "nwnx_craft_system"

/*
const int XP_CRAFT_CONDITION_ITEM_IN_SLOT = 1;
const int XP_CRAFT_CONDITION_IS_CRAFTABLE = 2;
const int XP_CRAFT_CONDITION_HAS_MODEL_PART = 3;
const int XP_CRAFT_CONDITION_HAS_VISUAL_TYPE = 4;
const int XP_CRAFT_CONDITION_CHANGES_ALLOWED = 5;
const int XP_CRAFT_CONDITION_HAS_ARMOR_PIECE = 6;
*/

int StartingConditional(int iCondition, int iInventorySlot, int iVisualType)
{
	object oPC = GetPCSpeaker();
	object oInventoryItem = OBJECT_INVALID;
	
	//
	// For XP_CRAFT_CONDITION_HAS_ARMOR_PIECE, we run after the craft system has
	// initialized for an item.  The 'inventory slot' argument is in this case
	// actually the armor piece mask of the armor piece we want to check if is
	// editable.
	//

	if (iCondition != XP_CRAFT_CONDITION_HAS_ARMOR_PIECE)
		oInventoryItem = GetItemInSlot(iInventorySlot, oPC);
	
	int bReturn =FALSE;

	switch(iCondition)
	{
		case XP_CRAFT_CONDITION_ITEM_IN_SLOT :
			bReturn = (oInventoryItem!=OBJECT_INVALID);
			break;
			
		case XP_CRAFT_CONDITION_IS_CRAFTABLE ://edit nwnx_craft_system in order to code your own speciications 	
			bReturn = XPCraft_GetIsCraftable(oPC, oInventoryItem);			
			break;
			
		case XP_CRAFT_CONDITION_CHANGES_ALLOWED ://edit nwnx_craft_system in order to code your own speciications
			bReturn = XPCraft_GetChangesAllowed(oPC, oInventoryItem);
			break;
						
		case XP_CRAFT_CONDITION_IS_MULTI_MODELPART://since this list is supposably not subjet to changes, i coded it here with a case statement
			
			switch(GetBaseItemType(oInventoryItem))
			{//list of base item types that got multi model part ("_b" and "_c" .mdb)			
				case BASE_ITEM_BATTLEAXE :
				case BASE_ITEM_BASTARDSWORD :
				case BASE_ITEM_DIREMACE :
				case BASE_ITEM_FALCHION :
				case BASE_ITEM_LIGHTFLAIL :
				case BASE_ITEM_FLAIL :
				case BASE_ITEM_GREATAXE :
				case BASE_ITEM_GREATSWORD :
				case BASE_ITEM_HALBERD :
				case BASE_ITEM_KATANA :
				case BASE_ITEM_LIGHTHAMMER :
				case BASE_ITEM_LONGSWORD :
				case BASE_ITEM_MACE :
				case BASE_ITEM_MORNINGSTAR :
				case BASE_ITEM_RAPIER :
				case BASE_ITEM_SCIMITAR :
				case BASE_ITEM_SCYTHE :
				case BASE_ITEM_SHORTSWORD :
				case BASE_ITEM_WARHAMMER :
					bReturn = TRUE;
					break;
			}	
					
			break;
			
		case XP_CRAFT_CONDITION_HAS_VISUAL_TYPE :
			//conditions here are mainly exemples of restrictions you can add in this script
			// in order to control what's being done by your players.
			//currently only dealing with special behaviours on Armor/Clothes, you can extend the system to helms and boots if you wish
			
			if(GetLocalInt(oPC,"XC_INVENT_SLOT")==1)
			{//item is an armor/clothe 
				if((XP_CRAFT_AVT_DISALLOW_NAKED_BODY==1) && (iVisualType ==10))
				{//no naked avt allowed	
					bReturn = FALSE;		
				}
				else if(XP_CRAFT_AVT_LIGHT_AGAINST_METAL==1)
				{//group "light" material appearanes against "metal-like" appearances
					int iAVT_CurrentValue = GetLocalInt(oPC,"XC_AVT_VALUE");
					switch(iAVT_CurrentValue)
					{
						case 0 : //Cloth
						case 1 : //Padded Cloth
						case 2 : //Leather
						case 3 : //Studded Leather
						case 9 : //Hide 
						case 10: //Naked
							//material group "light"
							switch(iVisualType)
							{
						
								case 4 : //Chainmail
								case 5 ://Scale
								case 6 : //Banded
								case 7 : //Half-Plate
								case 8 : //Full-Plate
									//different material group : "metal-like" against "light"
									bReturn = FALSE;
									break;
								case 0 : //Cloth
								case 1 : //Padded Cloth
								case 2 : //Leather
								case 3 : //Studded Leather
								case 9 : //Hide 
								case 10: //Naked
								default: //
									//same material group : "light" -> do the condition as usual, using the lists
									bReturn = (FindSubString(GetLocalString(GetWaypointByTag( "XC_HIDDEN_WP" ),GetLocalString(oPC,"XC_AVT_LISTNAME")),"#" + IntToString(iVisualType) + "#") !=-1);
									break;
									
							}							
							break;
							
						case 4 : //Chainmail
						case 5 ://Scale
						case 6 : //Banded
						case 7 : //Half-Plate
						case 8 : //Full-Plate
							//material group "metal-like" 
							switch(iVisualType)
							{
								case 0 : //Cloth
								case 1 : //Padded Cloth
								case 2 : //Leather
								case 3 : //Studded Leather
								case 9 : //Hide 
								case 10: //Naked
									//different material group : "light" angainst "metal-like" 
 									bReturn = FALSE;
									break;
									
								case 4 : //Chainmail
								case 5 ://Scale
								case 6 : //Banded
								case 7 : //Half-Plate
								case 8 : //Full-Plate
								default:
									//same material group : "metal-like" -> do the condition as usual, using the lists
									bReturn = (FindSubString(GetLocalString(GetWaypointByTag( "XC_HIDDEN_WP" ),GetLocalString(oPC,"XC_AVT_LISTNAME")),"#" + IntToString(iVisualType) + "#") !=-1);
									break;
							}								
							break;
						// 16, 17 "custom" types
						default:
							bReturn = (FindSubString(GetLocalString(GetWaypointByTag( "XC_HIDDEN_WP" ),GetLocalString(oPC,"XC_AVT_LISTNAME")),"#" + IntToString(iVisualType) + "#") !=-1);
							break;
					}					
				
				}
				else
				{//no special switch to care about, do the condition as usual, using the lists
					bReturn = (FindSubString(GetLocalString(GetWaypointByTag( "XC_HIDDEN_WP" ),GetLocalString(oPC,"XC_AVT_LISTNAME")),"#" + IntToString(iVisualType) + "#") !=-1);
				}
			
			}
			else
			{			
				bReturn = (FindSubString(GetLocalString(GetWaypointByTag( "XC_HIDDEN_WP" ),GetLocalString(oPC,"XC_AVT_LISTNAME")),"#" + IntToString(iVisualType) + "#") !=-1);
			}

			//
			// If this visual type is blacklisted, don't permit it to be selected.
			//

			if ((bReturn) && (FindSubString(GetLocalString(GetWaypointByTag( "XC_HIDDEN_WP" ),GetLocalString(oPC,"XC_AVT_LISTNAME")+"_BLACKLIST"),"#" + IntToString(iVisualType) + "#") !=-1))
			{
				bReturn = FALSE;
			}

			break;
			
		case XP_CRAFT_CONDITION_HAS_ARMOR_PIECE: // Does the edited item have this (default) auxiliary armor piece?
			bReturn = (XPCraft_GetHasArmorPiece(oPC,iInventorySlot) ? TRUE : FALSE);
			break;		

	}
	
	return bReturn;
}
