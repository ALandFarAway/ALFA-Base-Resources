/******************************************************************************
*****                         nwnx_craft_system                           *****
*****                               V 1                                   *****
*****                             11/29/07                                *****
******************************************************************************/  

#include "nwnx_craft"
#include "acr_tools_i"

//remember to set your nwn2 database path in the xp_craft inifile !!!


///////////////////////////////////////////////////////////////////////////////
////////////////////////////// DECLARATIONS ///////////////////////////////////
///////////////////////////////////////////////////////////////////////////////

/*****************************************************************************/
// Constants (to be switched according to your needs)

const int XP_CRAFT_USE_RACED_ARMOR_PART = FALSE;
const int XP_CRAFT_USE_SEXED_ARMOR_PART = FALSE;

const int XP_CRAFT_USE_RACED_VARIATION = TRUE;
const int XP_CRAFT_USE_SEXED_VARIATION = TRUE;


// delay from craft action->next craft action
// _should_ help in removing all dupe bugs
const float XP_CRAFT_TALK_DELAY = 1.0f;

//if you made your lists according to the filenames (ie P_HHM_Body01..)
//you'll have to set this to 1
//if you made your lists according to the toolset values (which i don't recommand)
//you'll have to set this to 0
//see nwnx_craft_set_constants for more informations about lists making.
const int XP_CRAFT_VARIATION_LISTS_BASE = 1;

//ArmorVisualType specific conditions swithes :
//theses switches only apply to Armor/clothes 
//(you can easily extend them to other equpemnts if you really wish to...
//see d_nwnx_craft_conditions)
const int XP_CRAFT_AVT_DISALLOW_NAKED_BODY = 0;//you'll never get a naked avt for armor/clothes (kinda useless actually)
const int XP_CRAFT_AVT_LIGHT_AGAINST_METAL = TRUE;//any light matarial can become any other light material (cloth, padded cloth, hide, leather, studded leather, naked)
												//and any metal-like material can become any other metal-like material (banded, scale, chainmail, half plate, full plate)
												//metal-like can't become light materials and light materials can't become metal-like materials 
												//(i, personnly speaking, like to use this switch on my PW in order to have a small amount of realism in the outfits between their actual AC and their appearance... (one can always dream))
												

const int XP_CRAFT_SHOW_VARIATIONS_TO_PLAYER = TRUE; // TRUE if variation numbers are displayed to the player.

/*****************************************************************************/
//Constants (for easier reading mainly)

//condition constants used in d_nwnx_craft_condition
const int XP_CRAFT_CONDITION_ITEM_IN_SLOT = 1;
const int XP_CRAFT_CONDITION_IS_CRAFTABLE = 2;
const int XP_CRAFT_CONDITION_IS_MULTI_MODELPART = 3;
const int XP_CRAFT_CONDITION_HAS_VISUAL_TYPE = 4;
const int XP_CRAFT_CONDITION_CHANGES_ALLOWED = 5;
const int XP_CRAFT_CONDITION_HAS_ARMOR_PIECE = 6;

//action constants used in d_nwnx_craft_action
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

//used in the user-defined function at the end of this script
const int  XP_CRAFT_CHANGE_TYPE_VARIATION = 1;
const int  XP_CRAFT_CHANGE_TYPE_AVT = 2;
const int  XP_CRAFT_CHANGE_TYPE_ARMORPART = 3;
const int  XP_CRAFT_CHANGE_TYPE_MODELPART = 4;
const int  XP_CRAFT_CHANGE_TYPE_COLOR = 5;

// Armor set presence bitmasks, set in oPC.XC_ITEM_ARMORSET_MASK if the item being edited has a particular armor piece (aside from its base piece).
const int XP_CRAFT_ARMORSET_PIECE_HELM   = 0x00000001; // Helm armor piece present
const int XP_CRAFT_ARMORSET_PIECE_GLOVES = 0x00000002; // Gloves armor piece present
const int XP_CRAFT_ARMORSET_PIECE_BOOTS  = 0x00000004; // Boots armor piece present
const int XP_CRAFT_ARMORSET_PIECE_BELT   = 0x00000008; // Belt armor piece present
const int XP_CRAFT_ARMORSET_PIECE_CLOAK  = 0x00000010; // Cloak armor piece present

/*****************************************************************************/


//Pick a new element out of a list given a specified action.
int XPCraft_PeformListSelectionAction(int iCurrentElement, string sList, int iAction, int bAllowFirstLast);


//return the new variation value (according to the ad hoc list)
//iAction contains the direction to get the value : Next or previous.. 
int XPCraft_GetNewVariationValue(object oPC, int iBaseItemType, int iAction);

//return the new ArmorPArt value (according to the ad hoc list)
//iAction contains the direction to get the value : Next or previous.. 
int XPCraft_GetNewArmorPartValue(object oPC, string sRoadMap, int iAction);

//return the new ModelPArt value (according to the ad hoc list)
//iAction contains the direction to get the value : Next or previous.. 
int XPCraft_GetNewModelPartValue(object oPC, int iBaseItemType, int iModelPartID, int iAction);


//get the name of the list containing the valid Variation values
string XPCraft_GetVariation_ListName(object oPC, int iArmorVisualType, int iBaseItemType);

//get the name of the list containing the valid ArmorVisualType values
string XPCraft_GetArmorVisualType_ListName(object oPC, int iBaseItemType);

//get the name of the list containing the valid ArmorPart values
string XPCraft_GetArmorPart_ListName(object oPC, string sRoadMap);

//get the name of the list containing the valid ModelPart values
string XPCraft_GetModelPart_ListName(object oPC, int iBaseItemType, int iModelPartID);

// Return the actual item type that we should use for the variation or armor type lists,
// which may be different than the items own type if we are dealing with a selected
// armor piece.
int XPCraft_GetEffectiveItemType(object oPC, int iBaseItemType);

/*****************************************************************************/
//ACTIONS

//returns and equip the newly crafted item
object XPCraft_ActionChangeVariation(object oPC, object oItemToCraft, int iAction);

//returns and equip the newly crafted item
object XPCraft_ActionChangeArmorVisualType(object oPC, object oItemToCraft, int iNewArmorVisualTypeValue);

//returns and equip the newly crafted item
object XPCraft_ActionChangeArmorPart(object oPC, object oItemToCraft, int iAction);

//returns and equip the newly crafted item
object XPCraft_ActionChangeModelPart(object oPC, object oItemToCraft, int iAction);

//returns and equip the newly crafted item
object XPCraft_ActionChangeColor(object oPC, int iNewColorValue);


//restore and returns the last item that was confirmed
object XPCraft_ActionCancelChanges(object oPC);

//Choose a new armor piece to edit
void XPCraft_ActionSelectArmorPiece(object oPC, int nArmorPiece);

//delete all the mess i've done, locals, temporary items, database files...
void XPCraft_CleanLocals(object oPC, int bEraseDatafile=TRUE);


/*****************************************************************************/
//UTILITY APIS

//return TRUE should a particular GFF field exists in the item being edited.
int XPCraft_DoesGFFFieldExist(object oPC, string sFieldPath);


/*****************************************************************************/
//INITIALASATION

//get vlues from the plugin and store them locally
void XPCraft_InitVariationValues(object oPC);//Variation

//get vlues from the plugin and store them locally
void XPCraft_InitArmorVisualTypeValues(object oPC);//AVT

//get vlues from the plugin and store them locally
void XPCraft_InitItemPartValues(object oPC, string sRoadMap);//ArmorPart or ModelPart

//determine which armor pieces are available for the item to edit.
void XPCraft_InitArmorSetMask(object oPC);

/*****************************************************************************/
//TO BE CODED AS YOU WISH !!!

//with this one you can control, before any craft attempt is made, 
//whether the PC has the right to change this specific item or not.
//maybe you got some items you don't want to be altered, for any reason you want ;)
int XPCraft_GetIsCraftable(object oPC, object oInventoryItem);

//after the player click to confirm his changes, this script is executed,
// in order to know if you grant the changes or not.
//you'll have acces to a switch case statement base upon he last changes made (variation, color, modelpart etc... )
//you can decide to grant the changes upon gold or craftskill roll or whatever...
int XPCraft_GetChangesAllowed(object oPC, object oInventoryItem);

//once the changes are confirmed (and granted by you) this script executes,
// in order to make whatever you wish. take gold, or whatever.
void XPCraft_OnChangesConfirmed(object oPC, object oInventoryItem);

// Check whether the edited item has a specific armor piece present.
// The craft system must have already been initialized for item that we are
// about to edit!  i.e. d_nwnx_craft_init must have been run.
int XPCraft_GetHasArmorPiece(object oPC, int nArmorPieceMsk);


int XPCraft_GetLastChangesType(object oPC, object oInventoryItem);

///////////////////////////////////////////////////////////////////////////////
////////////////////////////// IMPLEMENTATIONS ////////////////////////////////
///////////////////////////////////////////////////////////////////////////////





int XPCraft_PerformListSelectionAction(int iCurrentElement, string sList, int iAction, int bAllowFirstLast)
{
	switch(iAction)
	{
		case XP_CRAFT_ACTION_NEXT :
			iCurrentElement = GetNextEntryInStringList(sList,iCurrentElement);
			break;			
		case XP_CRAFT_ACTION_PREVIOUS :
			iCurrentElement = GetPreviousEntryInStringList(sList,iCurrentElement);
			break;
		case XP_CRAFT_ACTION_FIRST :
			if (bAllowFirstLast)
			{
				iCurrentElement = GetFirstEntryInStringList(sList);
				break;			
			}

			//
			// Fallthrough.
			//
		case XP_CRAFT_ACTION_LAST :
			if (bAllowFirstLast)
			{
				iCurrentElement = GetLastEntryInStringList(sList);
				break;			
			}

			//
			// Fallthrough.
			//
		default :
			iCurrentElement = iCurrentElement;
			break;	
	}

	return iCurrentElement;
}


int XPCraft_GetNewVariationValue(object oPC, int iBaseItemType, int iAction)
{
	int iCurrentVariationValue =  GetLocalInt(oPC,"XC_VARIATION_VALUE");
	int iNewVariationValue;
 	
	string sListName = XPCraft_GetVariation_ListName(oPC, GetLocalInt(oPC,"XC_AVT_VALUE"), iBaseItemType);
	string sVariationList = GetLocalString(GetWaypointByTag( "XC_HIDDEN_WP" ), sListName);
	string sBlacklist;
	if(sVariationList=="")
	{
		//XPCraft_Debug(oPC,"No Variation List : " + sListName);
		return iCurrentVariationValue;
	}

	sBlacklist = GetLocalString(GetWaypointByTag( "XC_HIDDEN_WP" ), sListName + "_BLACKLIST");
	iNewVariationValue = iCurrentVariationValue;

	do {
		iNewVariationValue = XPCraft_PerformListSelectionAction(iNewVariationValue,sVariationList,iAction,TRUE);
	} while ((iNewVariationValue != iCurrentVariationValue) && (IsElementInStringList( sBlacklist, iNewVariationValue )));

//XPCraft_Debug(oPC,"<b>Matrice des Variations.</b>");	
//XPCraft_Debug(oPC,"Variation Actuelle : " + IntToString(iCurrentVariationValue));
//XPCraft_Debug(oPC,"Nom de la liste : " + sListName);
//XPCraft_Debug(oPC,"Liste des Variations : " + sVariationList);
//XPCraft_Debug(oPC,"Nouvelle Variation : " + IntToString(iNewVariationValue));
			 
	return iNewVariationValue;
}

int XPCraft_GetNewArmorPartValue(object oPC, string sRoadMap, int iAction)
{
	int iCurrentArmorPartValue =  GetLocalInt(oPC,"XC_ITEM_PART_VALUE");
	int iNewArmorPartValue;
 	
	string sListName = XPCraft_GetArmorPart_ListName(oPC, sRoadMap);
	string sArmorPartList = GetLocalString(GetWaypointByTag( "XC_HIDDEN_WP" ), sListName);
	string sBlacklist;
	if(sArmorPartList=="")
	{
//XPCraft_Debugug(oPC,"No ArmorPart List : " + sListName);
		return iCurrentArmorPartValue;
	}

	sBlacklist = GetLocalString(GetWaypointByTag( "XC_HIDDEN_WP" ), sListName + "_BLACKLIST");
	iNewArmorPartValue = iCurrentArmorPartValue;
	
	do {
		iNewArmorPartValue = XPCraft_PerformListSelectionAction(iNewArmorPartValue,sArmorPartList,iAction,FALSE);
	} while ((iNewArmorPartValue != iCurrentArmorPartValue) && (IsElementInStringList( sBlacklist, iNewArmorPartValue )));

//XPCraft_Debug(oPC,"<b>Matrice des ArmorParts.</b>");	
//XPCraft_Debug(oPC,"ArmorPart Actuel : " + IntToString(iCurrentArmorPartValue));
//XPCraft_Debug(oPC,"Nom de la liste : " + sListName);
//XPCraft_Debug(oPC,"Liste des ArmorParts : " + sArmorPartList);
//XPCraft_Debug(oPC,"Nouvel ArmorPart : " + IntToString(iNewArmorPartValue));	
		 
	return iNewArmorPartValue;
}


int XPCraft_GetNewModelPartValue(object oPC, int iBaseItemType, int iModelPartID, int iAction)
{
	int iCurrentModelPartValue = GetLocalInt(oPC,"XC_ITEM_PART_VALUE"); 
	int iNewModelPartValue;
	
	string sListName =  XPCraft_GetModelPart_ListName(oPC, iBaseItemType, iModelPartID);
	string sModelPartList = GetLocalString(GetWaypointByTag( "XC_HIDDEN_WP" ), sListName);
	string sBlacklist;
	
	if(sModelPartList=="")
	{
//XPCraft_Debugug(oPC,"No ModelPart List : " + sListName);
		return iCurrentModelPartValue;
	}

	sBlacklist = GetLocalString(GetWaypointByTag( "XC_HIDDEN_WP" ), sListName + "_BLACKLIST");
	iNewModelPartValue = iCurrentModelPartValue;
	
	do {
		iNewModelPartValue = XPCraft_PerformListSelectionAction(iNewModelPartValue,sModelPartList,iAction,FALSE);
	} while ((iNewModelPartValue != iCurrentModelPartValue) && (IsElementInStringList( sBlacklist, iNewModelPartValue )));
	
//XPCraft_Debug(oPC,"<b>Matrice des ModelParts.</b>");	
//XPCraft_Debug(oPC,"ModelPart Actuel : " + IntToString(iCurrentModelPartValue));
//XPCraft_Debug(oPC,"Nom de la liste : " + sListName);
//XPCraft_Debug(oPC,"Liste des ModelParts : " + sModelPartList);
//XPCraft_Debug(oPC,"Nouveau ModelPart : " + IntToString(iNewModelPartValue));	
	
		 
	return iNewModelPartValue;
}

string XPCraft_GetVariation_ListName(object oPC, int iArmorVisualType, int iBaseItemType)
{
	string sRaceGroup = "P_HH";
	string sGender = "M_";	

	//
	// If we were editing an armor piece instead of the base appearance for this
	// item, then we actually want the appearance lists for the armor piece.
	//

	iBaseItemType = XPCraft_GetEffectiveItemType(oPC, iBaseItemType);

	if(XP_CRAFT_USE_RACED_VARIATION)
	{
		if(iBaseItemType==BASE_ITEM_HELMET)
		{
			sRaceGroup = GetStringLeft(Get2DAString("appearance","NWN2_Model_Helm",GetAppearanceType(oPC)),4);
		}
		else
		{
			sRaceGroup = GetStringLeft(Get2DAString("appearance","NWN2_Model_Body",GetAppearanceType(oPC)),4);
		}
	}
	
	if((XP_CRAFT_USE_SEXED_VARIATION) && (GetGender(oPC) == GENDER_FEMALE))
	{
		sGender = "F_";
	}	
	
	string sListName = "XC_" + sRaceGroup + sGender;
	
	switch(iArmorVisualType)
	{
		case 0 : sListName +="CL"; break; //Cloth
		case 1 : sListName +="CP"; break; //Padded Cloth
		case 2 : sListName +="LE"; break; //Leather
		case 3 : sListName +="LS"; break; //Studded Leather
		case 4 : sListName +="CH"; break; //Chainmail
		case 5 : sListName +="SC"; break; //Scale
		case 6 : sListName +="BA"; break; //Banded
		case 7 : sListName +="PH"; break; //Half-Plate
		case 8 : sListName +="PF"; break; //Full-Plate
		case 9 : sListName +="HD"; break; //Hide 
		case 10: sListName +="NK"; break; //Naked
		case 16: sListName +="DMCB"; break; //DMCB
		case 17: sListName +="ACME"; break; //ACME
	}
	
	switch(iBaseItemType)
	{
		case BASE_ITEM_BELT : sListName +="_BELT"; break; 
		case BASE_ITEM_ARMOR : sListName +="_BODY"; break; 
		case BASE_ITEM_BOOTS : sListName +="_BOOTS"; break; 
		case BASE_ITEM_CLOAK : sListName +="_CLOAK"; break; 
		case BASE_ITEM_GLOVES : sListName +="_GLOVES"; break; 
		case BASE_ITEM_HELMET : sListName +="_HELM"; break; 
	}
	
	return sListName;
}

string XPCraft_GetArmorVisualType_ListName(object oPC, int iBaseItemType)
{
	string sRaceGroup = "P_HH";
	string sGender = "M_";	

	//
	// If we were editing an armor piece instead of the base appearance for this
	// item, then we actually want the appearance lists for the armor piece.
	//

	iBaseItemType = XPCraft_GetEffectiveItemType(oPC, iBaseItemType);
	
	if(XP_CRAFT_USE_RACED_VARIATION)
	{
		if(iBaseItemType==BASE_ITEM_HELMET)
		{
			sRaceGroup = GetStringLeft(Get2DAString("appearance","NWN2_Model_Helm",GetAppearanceType(oPC)),4);
		}
		else
		{
			sRaceGroup = GetStringLeft(Get2DAString("appearance","NWN2_Model_Body",GetAppearanceType(oPC)),4);
		}
	}
	
	if((XP_CRAFT_USE_SEXED_VARIATION) && (GetGender(oPC) == GENDER_FEMALE))
	{
		sGender = "F_";
	}	
	
	string sListName = "XC_AVT_" + sRaceGroup + sGender;
	
	switch(iBaseItemType)
	{
		case BASE_ITEM_BELT : sListName +="BELT"; break; 
		case BASE_ITEM_ARMOR : sListName +="BODY"; break; 
		case BASE_ITEM_BOOTS : sListName +="BOOTS"; break; 
		case BASE_ITEM_CLOAK : sListName +="CLOAK"; break; 
		case BASE_ITEM_GLOVES : sListName +="GLOVES"; break; 
		case BASE_ITEM_HELMET : sListName +="HELM"; break; 
	}
	
	return sListName;
}

string XPCraft_GetArmorPart_ListName(object oPC, string sRoadMap)
{
	string sRaceGroup = "HH";
	string sGender = "M_";	
	
	if(XP_CRAFT_USE_RACED_ARMOR_PART)
	{
		sRaceGroup = GetSubString(Get2DAString("appearance","NWN2_Model_Body",GetAppearanceType(oPC)),2,2);
	}
	
	if((XP_CRAFT_USE_SEXED_ARMOR_PART) && (GetGender(oPC) == GENDER_FEMALE))
	{
		sGender = "F_";
	}	
	
	return "XC_A_" + sRaceGroup + sGender + sRoadMap;
}

string XPCraft_GetModelPart_ListName(object oPC, int iBaseItemType, int iModelPartID)
{
	//
	// If we were editing an armor piece instead of the base appearance for this
	// item, then we actually want the appearance lists for the armor piece.
	//

	iBaseItemType = XPCraft_GetEffectiveItemType(oPC, iBaseItemType);
	
	string sListName = "XC_" + GetStringUpperCase(Get2DAString("baseitems","ItemClass",iBaseItemType));
	
	if(iModelPartID == 1)
	{
		sListName += "_A";
	}
	else if(iModelPartID == 2)
	{
		sListName += "_B";
	}
	else
	{
		sListName += "_C";
	}
	
	return  sListName;
}

int XPCraft_GetEffectiveItemType(object oPC, int iBaseItemType)
{
	int nSelectedArmorPiece;

	nSelectedArmorPiece = GetLocalInt(oPC,"XC_ITEM_ARMORSET_PIECE_ID");

	//
	// If we were not editing a sub armor piece but the raw item itself, then
	// just take the real base item type.
	//

	if (nSelectedArmorPiece == 0)
		return iBaseItemType;

	//XPCraft_Debug(oPC, "Selecting effective base item type for selected armor piece " + IntToString(nSelectedArmorPiece));

	//
	// Otherwise manufacture a base item type approximate to that of the armor
	// piece which we are editing (i.e. helm, boots, ...).
	//

	switch (nSelectedArmorPiece)
	{

	case XP_CRAFT_ARMORSET_PIECE_HELM:
		return BASE_ITEM_HELMET;

	case XP_CRAFT_ARMORSET_PIECE_GLOVES:
		return BASE_ITEM_GLOVES;

	case XP_CRAFT_ARMORSET_PIECE_BOOTS:
		return BASE_ITEM_BOOTS;

	case XP_CRAFT_ARMORSET_PIECE_BELT:
		return BASE_ITEM_BELT;

	case XP_CRAFT_ARMORSET_PIECE_CLOAK:
		return BASE_ITEM_CLOAK;

	default:
		break;
		
	}

	XPCraft_Debug(oPC, "Unsupported armor piece (in XPCraft_GetEffectiveItemType).");
	return iBaseItemType;
}


/*****************************************************************************/
//ACTIONS

object XPCraft_ActionChangeVariation(object oPC, object oItemToCraft, int iAction)
{
	//Get The New  Value
	int iNewVariationValue = XPCraft_GetNewVariationValue(oPC, GetBaseItemType(oItemToCraft), iAction);
	string sPieceName      = GetLocalString(oPC, "XC_ITEM_ARMORSET_PIECE");
	
	//a Little check to ensure we really got something to change
	if(iNewVariationValue ==  GetLocalInt(oPC,"XC_VARIATION_VALUE"))
	{
		XPCraft_Debug(oPC,"You cannot change Variation for this item.");
		return oItemToCraft;
	}
	
	//actually change the value via the plugin		
	int iVariation_ElementIndex = GetLocalInt(oPC,"XC_VARIATION_ELEMENT_ID");
	if(iVariation_ElementIndex!=0)
	{
		XPCraft_SetValue(IntToString(iNewVariationValue-XP_CRAFT_VARIATION_LISTS_BASE), "", iVariation_ElementIndex, XPCraft_GetDatafileName(oPC));
	}
	else
	{		
		XPCraft_SetValue(IntToString(iNewVariationValue-XP_CRAFT_VARIATION_LISTS_BASE), sPieceName + "Variation", 0, XPCraft_GetDatafileName(oPC));		
	}
	XPCraft_ClearMemory();//always perform after all accesses to the plugin have been made		
	SetLocalInt(oPC,"XC_VARIATION_VALUE",iNewVariationValue);

	if (XP_CRAFT_SHOW_VARIATIONS_TO_PLAYER)
	{
		XPCraft_Debug(oPC, "Selected variation " + IntToString(iNewVariationValue) + ".");
	}

	//Get the newly crafted Item and equip it.
	return XPCraft_RetrieveAndEquipCraftedItem(oPC, oItemToCraft, GetLocalInt(oPC,"XC_INVENT_SLOT"));
}


object XPCraft_ActionChangeArmorVisualType(object oPC, object oItemToCraft, int iNewArmorVisualTypeValue)
{//while performing an AVT change, we also set the varaition, to the first valid value within tis new ArmorVisualType.

//AVT
	string sDatafileName = XPCraft_GetDatafileName(oPC);	
	string sPieceName    = GetLocalString(oPC, "XC_ITEM_ARMORSET_PIECE");

	//a Little check to ensure we really got something to change
	if(iNewArmorVisualTypeValue == GetLocalInt(oPC,"XC_AVT_VALUE"))
	{
		XPCraft_Debug(oPC,"This Armor Visual Type is already set for this Item.");
		return oItemToCraft;
	}
	
	//actually change the value via the plugin		
	int iArmorVisualType_ElementIndex = GetLocalInt(oPC,"XC_AVT_ELEMENT_ID");
	if(iArmorVisualType_ElementIndex!=0)
	{
		XPCraft_SetValue(IntToString(iNewArmorVisualTypeValue), "", iArmorVisualType_ElementIndex, sDatafileName);
	}
	else
	{		
		XPCraft_SetValue(IntToString(iNewArmorVisualTypeValue), sPieceName + "ArmorVisualType", 0, sDatafileName);		
	}
	SetLocalInt(oPC,"XC_AVT_VALUE",iNewArmorVisualTypeValue);

//Variation
		
	//the AVT has been changed, but the current variation may not be valid for this new AVT
	//=> reinitilize the variation with this new AVT
	int iNewVariationValue = XPCraft_GetNewVariationValue(oPC, GetBaseItemType(oItemToCraft), XP_CRAFT_ACTION_FIRST);
	
	//a Little check to ensure we really got something to change
	if(iNewVariationValue !=  GetLocalInt(oPC,"XC_VARIATION_VALUE"))
	{
		//actually change the value via the plugin		
		int iVariation_ElementIndex = GetLocalInt(oPC,"XC_VARIATION_ELEMENT_ID");
		if(iVariation_ElementIndex!=0)
		{
			XPCraft_SetValue(IntToString(iNewVariationValue-XP_CRAFT_VARIATION_LISTS_BASE), "", iVariation_ElementIndex, sDatafileName);
		}
		else
		{		
			XPCraft_SetValue(IntToString(iNewVariationValue-XP_CRAFT_VARIATION_LISTS_BASE), sPieceName + "Variation", 0, sDatafileName);		
		}
		SetLocalInt(oPC,"XC_VARIATION_VALUE",iNewVariationValue);
	}	

	XPCraft_ClearMemory();//always perform after all accesses to the plugin have been made	

	if (XP_CRAFT_SHOW_VARIATIONS_TO_PLAYER)
	{
		XPCraft_Debug(oPC, "Selected armor visual type " + IntToString(iNewVariationValue) + ".");
	}
	
	//Get the newly crafted Item and equip it.
	return XPCraft_RetrieveAndEquipCraftedItem(oPC, oItemToCraft, GetLocalInt(oPC,"XC_INVENT_SLOT"));
}

object  XPCraft_ActionChangeArmorPart(object oPC, object oItemToCraft, int iAction)
{
	string sRoadMap = GetLocalString(oPC,"XC_ROAD_MAP");
	
	//Get The New  Value
	int iNewItemPartValue = XPCraft_GetNewArmorPartValue(oPC, sRoadMap, iAction);
	
	//a Little check to ensure we really got something to change
	if(iNewItemPartValue ==  GetLocalInt(oPC,"XC_ITEM_PART_VALUE"))
	{
		XPCraft_Debug(oPC,"You cannot change this ArmorPart for this item.");
		return oItemToCraft;
	}
	
	//actually change the value via the plugin
	int iItemPart_ElementIndex = GetLocalInt(oPC,"XC_ITEM_PART_ELEMENT_ID");
	if(iItemPart_ElementIndex!=0)
	{
		XPCraft_SetValue(IntToString(iNewItemPartValue), "", iItemPart_ElementIndex, XPCraft_GetDatafileName(oPC));
	}
	else
	{
		XPCraft_SetValue(IntToString(iNewItemPartValue), sRoadMap + "|Accessory", 0, XPCraft_GetDatafileName(oPC));
	}
	XPCraft_ClearMemory();//always perform after all accesses to the plugin have been made		
	SetLocalInt(oPC,"XC_ITEM_PART_VALUE",iNewItemPartValue);
	
	if (XP_CRAFT_SHOW_VARIATIONS_TO_PLAYER)
	{
		XPCraft_Debug(oPC, "Selected armor accessory " + IntToString(iNewItemPartValue) + ".");
	}

	//Get the newly crafted Item and equip it.
	return XPCraft_RetrieveAndEquipCraftedItem(oPC, oItemToCraft, GetLocalInt(oPC,"XC_INVENT_SLOT"));
}

object XPCraft_ActionChangeModelPart(object oPC, object oItemToCraft, int iAction)
{
	string sRoadMap = GetLocalString(oPC,"XC_ROAD_MAP");

	//Get The New  Value
	int iNewItemPartValue = XPCraft_GetNewModelPartValue(oPC, GetBaseItemType(oItemToCraft), StringToInt(GetStringRight(sRoadMap,1)), iAction);
	
	//a Little check to ensure we really got something to change
	if(iNewItemPartValue ==  GetLocalInt(oPC,"XC_ITEM_PART_VALUE"))
	{
		XPCraft_Debug(oPC,"You cannot change this ModelPart for this item.");
		return oItemToCraft;
	}
	
	//actually change the value via the plugin
	int iItemPart_ElementIndex = GetLocalInt(oPC,"XC_ITEM_PART_ELEMENT_ID");
	if(iItemPart_ElementIndex!=0)
	{
		XPCraft_SetValue(IntToString(iNewItemPartValue), "", iItemPart_ElementIndex, XPCraft_GetDatafileName(oPC));
	}
	else
	{
		XPCraft_SetValue(IntToString(iNewItemPartValue), sRoadMap, 0, XPCraft_GetDatafileName(oPC));
	}
	XPCraft_ClearMemory();//always perform after all accesses to the plugin have been made
	SetLocalInt(oPC,"XC_ITEM_PART_VALUE",iNewItemPartValue);	

	if (XP_CRAFT_SHOW_VARIATIONS_TO_PLAYER)
	{
		XPCraft_Debug(oPC, "Selected model part " + IntToString(iNewItemPartValue) + ".");
	}

	//Get the newly crafted Item and equip it.
	return XPCraft_RetrieveAndEquipCraftedItem(oPC, oItemToCraft, GetLocalInt(oPC,"XC_INVENT_SLOT"));
}

object XPCraft_ActionChangeColor(object oPC, int iNewColorValue)
{
	int iInventorySlot = GetLocalInt(oPC,"XC_INVENT_SLOT");
	object oItemToCraft = GetItemInSlot(iInventorySlot,oPC);
	string sPieceName = GetLocalString(oPC, "XC_ITEM_ARMORSET_PIECE");
	if(oItemToCraft==OBJECT_INVALID)
	{
		XPCraft_Debug(oPC,"No Item In Slot : " + IntToString(iInventorySlot));
		//nettoyer !!
		//prévoir le coup du unequip
		return OBJECT_INVALID;
	}//END

	string sDatafileName = XPCraft_GetDatafileName(oPC);
	int iTintID = GetLocalInt(oPC,"XC_ACTION_TINT");
	string sRoadMap = GetLocalString(oPC,"XC_ROAD_MAP");
	string sRedRoadMap;
	
	if(GetStringLeft(sRoadMap,2)=="AC")
	{
		sRedRoadMap = sRoadMap + "|";
	}

	if (sPieceName == "")
	{
		sRedRoadMap+= "Tintable|Tint|" + IntToString(iTintID) + "|r";
	}
	else
	{
		sRedRoadMap+= "ArmorTint|" + IntToString(iTintID) + "|r";
	}
	
	//XPCraft_Debug(oPC,"RedRoadMap : " + sRedRoadMap);
	//XPCraft_Debug(oPC,"iTintID : " + IntToString(iTintID));
	//XPCraft_Debug(oPC,"iNewColorValue : " + IntToString(iNewColorValue));
	//XPCraft_Debug(oPC,"sDatafileName : " + sDatafileName);
	
	XPCraft_SetColor(IntToString(iNewColorValue), sPieceName + sRedRoadMap, 0, sDatafileName);
	XPCraft_ClearMemory();
	
	//Get the newly crafted Item and equip it.
	return XPCraft_RetrieveAndEquipCraftedItem(oPC, oItemToCraft, iInventorySlot);
}

object XPCraft_ActionCancelChanges(object oPC)
{
	//get the saved-before-changes-item
	object oSavedItem = GetLocalObject(GetWaypointByTag( "XC_HIDDEN_WP" ),"XC_TEMP_" + XPCraft_GetPCID(oPC));
	object oItemToEquip = OBJECT_INVALID;
	
	if(oSavedItem != OBJECT_INVALID)
	{
		DestroyObject(GetLocalObject(oPC,"XC_ITEM_TO_CRAFT"));

		oItemToEquip = CopyItem(oSavedItem,oPC,TRUE);
		int iInventorySlot = GetLocalInt(oPC,"XC_INVENT_SLOT");
		ACR_IgnoreAcquire(oItemToEquip);

		AssignCommand(oPC, ActionEquipItem(oItemToEquip, iInventorySlot));		
	}
	else
	{
		XPCraft_Debug(oPC,"Unable to retrieve unchanged item.");		
	}
	
	XPCraft_CleanLocals(oPC);
	
	return oItemToEquip;
}


void XPCraft_CleanLocals(object oPC, int bEraseDatafile=TRUE)
{
	DeleteLocalInt(oPC,"XC_INVENT_SLOT");
	DeleteLocalObject(oPC,"XC_LAST_CRAFTED");
	DeleteLocalObject(oPC,"XC_ITEM_TO_CRAFT");
	DeleteLocalString(oPC,"XC_ROAD_MAP");
	DeleteLocalInt(oPC,"XC_VARIATION_VALUE");
	DeleteLocalInt(oPC,"XC_AVT_VALUE");
	DeleteLocalInt(oPC,"XC_VARIATION_ELEMENT_ID");
	DeleteLocalInt(oPC,"XC_AVT_ELEMENT_ID");
	DeleteLocalInt(oPC,"XC_ITEM_PART_VALUE");
	DeleteLocalInt(oPC,"XC_ITEM_PART_ELEMENT_ID");
	DeleteLocalInt(oPC,"XC_ITEM_ARMORSET_MASK");
	DeleteLocalString(oPC,"XC_ITEM_ARMORSET_PIECE");
	DeleteLocalInt(oPC,"XC_ITEM_ARMORSET_PIECE_ID");
	
	DeleteLocalInt(oPC,"XC_ACTION_TINT");
	
	//destroy the saved item
	string sSavedItemVarName = "XC_TEMP_" + XPCraft_GetPCID(oPC);
	object oSavedItem = GetLocalObject(GetWaypointByTag( "XC_HIDDEN_WP" ),sSavedItemVarName);
	DestroyObject(oSavedItem);
	DeleteLocalObject(GetWaypointByTag( "XC_HIDDEN_WP" ),sSavedItemVarName);
	
	if(bEraseDatafile)
	{
		XPCraft_DestroyDataFile(oPC);
	}	
}

void XPCraft_ActionSelectArmorPiece(object oPC, int nArmorPiece)
{
	string sFieldPath;

	DeleteLocalString(oPC, "XC_ITEM_ARMORSET_PIECE");

	if (nArmorPiece == 0)
		return;

	//
	// Check that we can change this armor piece.
	//

	if (!XPCraft_GetHasArmorPiece(oPC, nArmorPiece))
	{
		XPCraft_Debug(oPC, "That item has no such armor piece " + IntToString(nArmorPiece) + ", sorry.");
		return;
	}

	switch (nArmorPiece)
	{

	case XP_CRAFT_ARMORSET_PIECE_HELM:
		sFieldPath = "Helm|";
		break;

	case XP_CRAFT_ARMORSET_PIECE_GLOVES:
		sFieldPath = "Gloves|";
		break;

	case XP_CRAFT_ARMORSET_PIECE_BOOTS:
		sFieldPath = "Boots|";
		break;

	case XP_CRAFT_ARMORSET_PIECE_BELT:
		sFieldPath = "Belt|";
		break;

	case XP_CRAFT_ARMORSET_PIECE_CLOAK:
		sFieldPath = "Cloak|";
		break;

	default:
		XPCraft_Debug(oPC, "Unsupported armor piece " + IntToString(nArmorPiece) + ", sorry.");
		return;

	}

	//
	// Now update our selection to point to this piece.
	//

	SetLocalString(oPC, "XC_ITEM_ARMORSET_PIECE", sFieldPath);
	SetLocalInt(oPC, "XC_ITEM_ARMORSET_PIECE_ID", nArmorPiece);
	//XPCraft_Debug(oPC, "Set armor set piece to " + sFieldPath + " (" + IntToString(nArmorPiece) + ")");
}
/*****************************************************************************/
//UTILITY APIS

int XPCraft_DoesGFFFieldExist(object oPC, string sFieldPath)
{
	string sDatafileName = XPCraft_GetDatafileName(oPC);

	//
	// Check if we can get a nonzero field id for this field.  If so then the
	// field must exist, otherwise it doesn't exist.
	//
	// This implementation is carefully tailored to be compatible with stock
	// xp_craft and the LWS's built-in xp_craft implementation.
	//
	// N.B.  The item to query must already be loaded for editing.
	//

	if (StringToInt(XPCraft_GetIndex(sFieldPath, sDatafileName)) != 0)
		return TRUE;
	else
		return FALSE;
}

/*****************************************************************************/
//INITIALASATION

void XPCraft_InitVariationValues(object oPC)
{

	string sDatafileName = XPCraft_GetDatafileName(oPC);
	string sPieceName    = GetLocalString(oPC, "XC_ITEM_ARMORSET_PIECE");
	
	//in order to speed up things we retrieve the Element_Index given it's roadmap.
	//any further call made with the element _Index will be much faster tahn seeking for the roadmap each time
	//be aware that any modification (addition or deletion) on the item (ie item_property, local variables etc. )
	//will change the ElementID, thus preventing the craft from working fine.
	//if you plan on adding local variables to the item during the craft process,
	//please modify the code in order to always use the roadmap instead of the Element ID
	//i'll be slower, but much more safer.
	
	int iVariation_ElementID = StringToInt(XPCraft_GetIndex(sPieceName + "Variation", sDatafileName));
	int iVariation = StringToInt(XPCraft_GetValue("" , iVariation_ElementID, sDatafileName));

	int iArmorVisualType = StringToInt(XPCraft_GetValue(sPieceName + "ArmorVisualType",0, sDatafileName));

	//very important, see nwnx_craft_system for info
	iVariation += XP_CRAFT_VARIATION_LISTS_BASE;	
		
	//init the local vars that will be used by the craft system
	SetLocalInt(oPC,"XC_VARIATION_ELEMENT_ID",iVariation_ElementID);
	SetLocalInt(oPC,"XC_VARIATION_VALUE",iVariation);

	SetLocalInt(oPC,"XC_AVT_VALUE",iArmorVisualType);

	//XPCraft_Debug(oPC,"INIT : Variation = " + IntToString(iVariation));
//XPCraft_Debug(oPC,"INIT : ArmorType = " + IntToString(iArmorVisualType));	
	
	XPCraft_ClearMemory();//always perform a clearmem after you're done interracting with the plugin
}

void XPCraft_InitArmorVisualTypeValues(object oPC)
{
	//the reason we fetch both Variation and ArmorVisualType here,
	// is that we need the AVT in order to get the proper Variation List.
	
	string sDatafileName = XPCraft_GetDatafileName(oPC);
	string sPieceName    = GetLocalString(oPC, "XC_ITEM_ARMORSET_PIECE");
	
	//in order to speed up things we retrieve the Element_Index given it's roadmap.
	//any further call made with the element _Index will be much faster than seeking for the roadmap each time
	//be aware that any modification (addition or deletion) on the item (ie item_property, local variables etc. )
	//will change the ElementID, thus preventing the craft from working fine.
	//if you plan on adding local variables to the item during the craft process,
	//please modify the code in order to always use the roadmap instead of the Element ID
	//i'll be slower, but much more safer.
	
	int iVariation_ElementID = StringToInt(XPCraft_GetIndex(sPieceName + "Variation", sDatafileName));
	int iArmorVisualType_ElementID = StringToInt(XPCraft_GetIndex(sPieceName + "ArmorVisualType", sDatafileName));
	int iArmorVisualType = StringToInt(XPCraft_GetValue( "", iArmorVisualType_ElementID, sDatafileName));

	//init the local vars that will be used by the craft system
	SetLocalInt(oPC,"XC_VARIATION_ELEMENT_ID",iVariation_ElementID);

	SetLocalInt(oPC,"XC_AVT_ELEMENT_ID",iArmorVisualType_ElementID);
	SetLocalInt(oPC,"XC_AVT_VALUE",iArmorVisualType);

//XPCraft_Debug(oPC,"INIT : ArmorType = " + IntToString(iArmorVisualType) + ", PieceName = " + sPieceName + ", ArmorVisualTypeIndex = " + IntToString(iArmorVisualType_ElementID));	
	
	XPCraft_ClearMemory();//always perform a clearmem after you're done interracting with the plugin
	
	//Gets and stores the AVT listname for this item 
	string sAVT_Listname = XPCraft_GetArmorVisualType_ListName(oPC, GetBaseItemType(GetLocalObject(oPC,"XC_ITEM_TO_CRAFT")));	

	
//XPCraft_Debug(oPC,"INIT : AVT_Listname = " + sAVT_Listname);
//XPCraft_Debug(oPC,"INIT : AVT_List = " + GetLocalString(GetWaypointByTag( "XC_HIDDEN_WP" ),sAVT_Listname));
			
	SetLocalString(oPC,"XC_AVT_LISTNAME",sAVT_Listname);
}

void XPCraft_InitItemPartValues(object oPC, string sRoadMap)
{	
	string sDatafileName = XPCraft_GetDatafileName(oPC);
	
	//in order to speed up things we retrieve the Element_Index given it's roadmap.
	//any further call made with the element _Index will be much faster tahn seeking for the roadmap each time
	//be aware that any modification (addition or deletion) on the item (ie item_property, local variables etc. )
	//will change the ElementID, thus preventing the craft from working fine.
	//if you plan on adding local variables to the item during the craft process,
	//please modify the code in order to always use the roadmap instead of the Element ID
	//i'll be slower, but much more safer.
	
	int iItemPart_ElementID = StringToInt(XPCraft_GetIndex(sRoadMap, sDatafileName));
	int iItemPartValue = StringToInt(XPCraft_GetValue("" , iItemPart_ElementID, sDatafileName));
	
	//init the local vars that will be used by the craft system
	SetLocalInt(oPC,"XC_ITEM_PART_ELEMENT_ID",iItemPart_ElementID);
	SetLocalInt(oPC,"XC_ITEM_PART_VALUE",iItemPartValue);


//XPCraft_Debug(oPC,"INIT : ItemPart = " + IntToString(iItemPartValue));
	
	XPCraft_ClearMemory();//always perform a clearmem after you're done interracting with the plugin 
}

void XPCraft_InitArmorSetMask(object oPC)
{
	int ArmorSetMask  = 0;

	//
	// Determine which armor pieces are present in this item so we know which to
	// show in the dialog UI.
	//
	// Some items may have more than just their base model, such as a chest item
	// which may provide default Boots, Belt, etc. models.
	//

	if (XPCraft_DoesGFFFieldExist(oPC, "Helm|Variation"))
		ArmorSetMask |= XP_CRAFT_ARMORSET_PIECE_HELM;
	if (XPCraft_DoesGFFFieldExist(oPC, "Gloves|Variation"))
		ArmorSetMask |= XP_CRAFT_ARMORSET_PIECE_GLOVES;
	if (XPCraft_DoesGFFFieldExist(oPC, "Boots|Variation"))
		ArmorSetMask |= XP_CRAFT_ARMORSET_PIECE_BOOTS;
	if (XPCraft_DoesGFFFieldExist(oPC, "Belt|Variation"))
		ArmorSetMask |= XP_CRAFT_ARMORSET_PIECE_BELT;
	if (XPCraft_DoesGFFFieldExist(oPC, "Cloak|Variation"))
		ArmorSetMask |= XP_CRAFT_ARMORSET_PIECE_CLOAK;

	//
	// Now update our accounting in the variable.
	//

	SetLocalInt(oPC, "XC_ITEM_ARMORSET_MASK", ArmorSetMask);
}





int XPCraft_GetLastChangesType(object oPC, object oInventoryItem)
{//note that according to the way the dialog is made,
// you can't easily know whether a Player has just modified an ArmorPart or the Color of this ArmorPart.

	int iLastChangesType;
	string sSubAction =  GetStringLeft( GetLocalString(oPC,"XC_ROAD_MAP"),2);

	if(sSubAction =="Va")
	{//changed the Variation 
		iLastChangesType = XP_CRAFT_CHANGE_TYPE_VARIATION;
	}	
	else if(sSubAction =="Ar")
	{//changed the ArmorVisualType 
		iLastChangesType = XP_CRAFT_CHANGE_TYPE_AVT;
	}		
	else if(sSubAction =="AC")
	{//changed an ArmorPart or color on an ArmorPart 
		iLastChangesType = XP_CRAFT_CHANGE_TYPE_ARMORPART;
	}		
	else if(sSubAction == "Mo")
	{//changed a Weapon or Shield ModelPart	
		iLastChangesType = XP_CRAFT_CHANGE_TYPE_MODELPART;
	}
	else
	{//changed the color (except for armorparts) //you can better this thing up if you wish)
		iLastChangesType = XP_CRAFT_CHANGE_TYPE_COLOR;		
	}	
	
	return iLastChangesType;
}

/*****************************************************************************/
//TO BE CODED AS YOU WISH !!!

int XPCraft_GetIsCraftable(object oPC, object oInventoryItem)
{
	int bReturn = TRUE;
	
	//the bReturn value decides whether the PC can craft this spécific item or not.
	//place your own requests here...(special item flags, stolen, plot...)
	
	if (GetLocalInt(oInventoryItem, "XC_NOT_CRAFTABLE"))
		bReturn = FALSE;

	switch (GetBaseItemType(oInventoryItem)) {
		case BASE_ITEM_SHURIKEN:
		case BASE_ITEM_THROWINGAXE:
		case BASE_ITEM_DART:
			bReturn = FALSE;
			break;
	}

	return bReturn;	
}

int XPCraft_GetChangesAllowed(object oPC, object oInventoryItem)
{
	int bReturn;
	bReturn = FALSE;
	
	//the bReturn value decides whether the PC is allowed to perform his changes or not.
	//place your own requests here... (gold, craft skill...)
	switch(XPCraft_GetLastChangesType(oPC, oInventoryItem))
	{
		case XP_CRAFT_CHANGE_TYPE_VARIATION:
			bReturn = TRUE;
			break;
		case XP_CRAFT_CHANGE_TYPE_AVT:
			bReturn = TRUE;
			break;	
		case XP_CRAFT_CHANGE_TYPE_ARMORPART:
			bReturn = TRUE;
			break;	
		case XP_CRAFT_CHANGE_TYPE_MODELPART:
			bReturn = TRUE;
			break;
		case XP_CRAFT_CHANGE_TYPE_COLOR:
			bReturn = TRUE;
			break;
	}		
	return bReturn;	
}

void XPCraft_OnChangesConfirmed(object oPC, object oInventoryItem)
{
	//actions to do after the item has been crafted and changes confirmed
	//place your own requests here... (take gold or whatever)
	
	switch(XPCraft_GetLastChangesType(oPC, oInventoryItem))
	{
		case XP_CRAFT_CHANGE_TYPE_VARIATION:
			//XPCraft_Debug(oPC,"you changed the Variation");						
			break;
		case XP_CRAFT_CHANGE_TYPE_AVT:
			//XPCraft_Debug(oPC,"you changed the Armor VisualType");	
			break;	
		case XP_CRAFT_CHANGE_TYPE_ARMORPART:
			//XPCraft_Debug(oPC,"you changed an ArmorPart");	
			break;	
		case XP_CRAFT_CHANGE_TYPE_MODELPART:
			//XPCraft_Debug(oPC,"you changed a ModelPart");	
			break;
		case XP_CRAFT_CHANGE_TYPE_COLOR:
			//XPCraft_Debug(oPC,"you changed a Color");	
			break;
	}
}

int XPCraft_GetHasArmorPiece(object oPC, int nArmorPieceMask)
{
    //
    // Check the cached state of whether this item's armorset had the particular
    // piece we are looking for.  This implies that the craft system must have
    // already been initialized, i.e. that XPCraft_InitArmorSetMask has run.
    //
	
    WriteTimestampedLogEntry("XP_CRAFT: GetHasArmorPiece <"+IntToString(GetLocalInt(oPC, "XC_ITEM_ARMORSET_MASK")) + "> - <" + IntToString(nArmorPieceMask)+">");

    return (GetLocalInt(oPC, "XC_ITEM_ARMORSET_MASK") & nArmorPieceMask) != 0;
}
