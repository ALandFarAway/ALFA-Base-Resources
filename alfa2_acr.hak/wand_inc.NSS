////////////////////////////////////////////////////////////////////////////////
// Wand System
// Original Scripter:  Caos81      Design: Caos81
//------------------------------------------------------------------------------
// Last Modified By:   Caos81           28/01/2009
//------------------------------------------------------------------------------
////////////////////////////////////////////////////////////////////////////////


#include "wand_inc_misc"
#include "wand_inc_language"


const string 	WAND_GUI_H	 						= "wand_h.xml";
const string 	WAND_GUI_V	 						= "wand_v.xml";
const string 	WAND_GUI_DMFI_H						= "wand_dmfi_h.xml";
const string 	WAND_GUI_DMFI_V						= "wand_dmfi_v.xml";
const string 	WAND_GUI_PC_INVENTORY	 			= "pc_inventory.xml";
const string 	WAND_GUI_LV_MANAGER		 			= "local_var_repository.xml";
const string	WAND_LV_MANAGER_OBJ_INV_REF 		= "OBJECT_INVALID";
const int 		WAND_PIM_SLOT_OFFSET				= 10;
const int		WAND_PIM_SLOT_TOOLTIP_OFFSET		= 1000;
const int 		WAND_MAX_ITEM_NAME_LENGTH			= 25;
const int 		WAND_INV_AND_EQ_VALUE_LENGTH		= 26;
const int 		WAND_MIN_EQ_ITEM_NAME_LENGTH		= 26;


struct strInventoryGlobalValues {
	int iTotWeight;
	int iTotValue;
};

/*********************************************************************/
/*********************************************************************/
string GetListBoxNameByItemType (int iBaseItemType) {

	string sListBox = "";
	
	switch (iBaseItemType) {
		case BASE_ITEM_ARMOR:
		case BASE_ITEM_LARGESHIELD:
		case BASE_ITEM_SMALLSHIELD:
		case BASE_ITEM_TOWERSHIELD:
		case BASE_ITEM_HELMET:
		case BASE_ITEM_BELT:
		case BASE_ITEM_BOOTS:
		case BASE_ITEM_GLOVES:
		case BASE_ITEM_CREATUREITEM:
		case BASE_ITEM_BRACER:
		case BASE_ITEM_CLOAK:
			sListBox = "INVENTORY_ARMORS_LIST";	break;
		
		case BASE_ITEM_POTIONS:
		case BASE_ITEM_SPELLSCROLL:
		case BASE_ITEM_BLANK_POTION:
		case BASE_ITEM_ENCHANTED_POTION:
		case BASE_ITEM_ENCHANTED_SCROLL:
			sListBox = "INVENTORY_USABLES_LIST";	break;
		
		case BASE_ITEM_AMULET:
		case BASE_ITEM_MAGICROD:
		case BASE_ITEM_MAGICSTAFF:
		case BASE_ITEM_MAGICWAND:
		case BASE_ITEM_RING:
		case BASE_ITEM_BLANK_WAND:
		case BASE_ITEM_ENCHANTED_WAND:
			sListBox = "INVENTORY_MAGIC_OBJS_LIST"; break;

		case BASE_ITEM_TORCH:
		case BASE_ITEM_MISCSMALL:
		case BASE_ITEM_MISCMEDIUM:
		case BASE_ITEM_MISCLARGE:
		case BASE_ITEM_HEALERSKIT:
		case BASE_ITEM_THIEVESTOOLS:
		case BASE_ITEM_TRAPKIT:
		case BASE_ITEM_KEY:
		case BASE_ITEM_LARGEBOX:
		case BASE_ITEM_BOOK:
		case BASE_ITEM_GOLD:
		case BASE_ITEM_GEM:
		case BASE_ITEM_MISCTHIN:
		case BASE_ITEM_GRENADE:
		case BASE_ITEM_CRAFTMATERIALMED:
		case BASE_ITEM_CRAFTMATERIALSML:
		case BASE_ITEM_DRUM:
		case BASE_ITEM_FLUTE:
		case BASE_ITEM_MANDOLIN:
			sListBox = "INVENTORY_MISCS_LIST";	break;
			
		default:
			sListBox = "INVENTORY_WEAPONS_LIST";	break;					
	}
	
	return sListBox;
}

/*********************************************************************/
/*********************************************************************/
void HideTabs (object oSubject) {

	SetGUIObjectHidden(oSubject, WAND_GUI_PC_INVENTORY, "INVENTORY_ARMORS_TAB", TRUE);
	SetGUIObjectHidden(oSubject, WAND_GUI_PC_INVENTORY, "INVENTORY_USABLES_TAB", TRUE);
	SetGUIObjectHidden(oSubject, WAND_GUI_PC_INVENTORY, "INVENTORY_MAGIC_OBJS_TAB", TRUE);
	SetGUIObjectHidden(oSubject, WAND_GUI_PC_INVENTORY, "INVENTORY_MISCS_TAB", TRUE);
	SetGUIObjectHidden(oSubject, WAND_GUI_PC_INVENTORY, "INVENTORY_WEAPONS_TAB", TRUE);
}

/*********************************************************************/
/*********************************************************************/
string GetTabNameByItemType (int iBaseItemType) {

	string sPane = "";
	
	switch (iBaseItemType) {
		case BASE_ITEM_ARMOR:
		case BASE_ITEM_LARGESHIELD:
		case BASE_ITEM_SMALLSHIELD:
		case BASE_ITEM_TOWERSHIELD:
		case BASE_ITEM_HELMET:
		case BASE_ITEM_BELT:
		case BASE_ITEM_BOOTS:
		case BASE_ITEM_GLOVES:
		case BASE_ITEM_CREATUREITEM:
		case BASE_ITEM_BRACER:
		case BASE_ITEM_CLOAK:
			sPane = "INVENTORY_ARMORS_TAB";	break;
		
		case BASE_ITEM_POTIONS:
		case BASE_ITEM_SPELLSCROLL:
		case BASE_ITEM_BLANK_POTION:
		case BASE_ITEM_ENCHANTED_POTION:
		case BASE_ITEM_ENCHANTED_SCROLL:
			sPane = "INVENTORY_USABLES_TAB";	break;
		
		case BASE_ITEM_AMULET:
		case BASE_ITEM_MAGICROD:
		case BASE_ITEM_MAGICSTAFF:
		case BASE_ITEM_MAGICWAND:
		case BASE_ITEM_RING:
		case BASE_ITEM_BLANK_WAND:
		case BASE_ITEM_ENCHANTED_WAND:
			sPane = "INVENTORY_MAGIC_OBJS_TAB"; break;

		case BASE_ITEM_TORCH:
		case BASE_ITEM_MISCSMALL:
		case BASE_ITEM_MISCMEDIUM:
		case BASE_ITEM_MISCLARGE:
		case BASE_ITEM_HEALERSKIT:
		case BASE_ITEM_THIEVESTOOLS:
		case BASE_ITEM_TRAPKIT:
		case BASE_ITEM_KEY:
		case BASE_ITEM_LARGEBOX:
		case BASE_ITEM_BOOK:
		case BASE_ITEM_GOLD:
		case BASE_ITEM_GEM:
		case BASE_ITEM_MISCTHIN:
		case BASE_ITEM_GRENADE:
		case BASE_ITEM_CRAFTMATERIALMED:
		case BASE_ITEM_CRAFTMATERIALSML:
		case BASE_ITEM_DRUM:
		case BASE_ITEM_FLUTE:
		case BASE_ITEM_MANDOLIN:
			sPane = "INVENTORY_MISCS_TAB";	break;
			
		default:
			sPane = "INVENTORY_WEAPONS_TAB";	break;					
	}
	
	return sPane;
}

/*********************************************************************/
/*********************************************************************/
void SelectListBoxItem (object oSubject, object oItem) {
	string sListBoxName =  GetListBoxNameByItemType(GetBaseItemType(oItem));
	string sObjectId = IntToString(ObjectToInt(oItem));
	int iBaseItemType = GetBaseItemType(oItem);
	
	HideTabs (oSubject);
	SetGUIObjectHidden(oSubject, WAND_GUI_PC_INVENTORY, "PANE_INVENTORY_RADIAL", FALSE);
	SetGUIObjectHidden(oSubject, WAND_GUI_PC_INVENTORY,  GetTabNameByItemType (iBaseItemType), FALSE);
	SetListBoxRowSelected(oSubject, WAND_GUI_PC_INVENTORY, sListBoxName, "Item_" + sObjectId);
}


/*********************************************************************/
/*********************************************************************/
string GetTrimmedString(string sValue, int iMaxLength = 17) {
	if (GetStringLength(sValue) > iMaxLength) {
		sValue = GetStringLeft(sValue, iMaxLength - 1) + "...";
	}
	
	return sValue;
}

/*********************************************************************/
/*********************************************************************/
void SetPimTarget(object oSubject, object oTarget) {
	if (GetIsObjectValid(oTarget))
		SetLocalObject(oSubject, "WAND_PIM_TARGET", oTarget);
	else
		DeleteLocalObject(oSubject, "WAND_PIM_TARGET");	
}

/*********************************************************************/
/*********************************************************************/
object GetPimTarget(object oSubject) {

	return GetLocalObject(oSubject, "WAND_PIM_TARGET");	
}

/*********************************************************************/
/*********************************************************************/
void SetLvmTarget(object oSubject, object oTarget) {
	if (GetIsObjectValid(oTarget))
		SetLocalObject(oSubject, "WAND_LVM_TARGET", oTarget);
	else
		DeleteLocalObject(oSubject, "WAND_LVM_TARGET");	
}

/*********************************************************************/
/*********************************************************************/
object GetLvmTarget(object oSubject) {

	return GetLocalObject(oSubject, "WAND_LVM_TARGET");	
}

/*********************************************************************/
/*********************************************************************/
int GetItemValue(object oItem) {
	int iValue = GetGoldPieceValue(oItem);	
	
	return iValue;
}

/*********************************************************************/
/*********************************************************************/
string GetAreaShortDesc (object oArea) {
	return GetName(oArea);
}

/*********************************************************************/
/*********************************************************************/
void InitAreaList (object oSubject) {
	object oArea = GetFirstArea();
	string sText, sVariable, sAreaId;
	
	while (GetIsObjectValid(oArea)) {
				
		sText = "VAR_LOC_AREA=" + GetAreaShortDesc (oArea);		
		
		sAreaId = IntToString(ObjectToInt(oArea));
		sVariable = "0=" + sAreaId;
	
		AddListBoxRow(oSubject, WAND_GUI_LV_MANAGER, "AREA_LIST", "Area_" + sAreaId, sText, "", sVariable, "");

		oArea = GetNextArea();
	}
}

/*********************************************************************/
/*********************************************************************/
void ResetTargetVarRepository (object oSubject) {

	ClearListBox(oSubject, WAND_GUI_LV_MANAGER, "VAR_INT_LIST");
	ClearListBox(oSubject, WAND_GUI_LV_MANAGER, "VAR_FLOAT_LIST");
	ClearListBox(oSubject, WAND_GUI_LV_MANAGER, "VAR_STR_LIST");
	ClearListBox(oSubject, WAND_GUI_LV_MANAGER, "VAR_LOC_LIST");
	ClearListBox(oSubject, WAND_GUI_LV_MANAGER, "VAR_OBJ_LIST");
}

/*********************************************************************/
/*********************************************************************/
void ResetInventoryListboxes (object oSubject) {

	ClearListBox(oSubject, WAND_GUI_PC_INVENTORY, "INVENTORY_ARMORS_LIST");
	ClearListBox(oSubject, WAND_GUI_PC_INVENTORY, "INVENTORY_WEAPONS_LIST");
	ClearListBox(oSubject, WAND_GUI_PC_INVENTORY, "INVENTORY_USABLES_LIST");
	ClearListBox(oSubject, WAND_GUI_PC_INVENTORY, "INVENTORY_MAGIC_OBJS_LIST");
	ClearListBox(oSubject, WAND_GUI_PC_INVENTORY, "INVENTORY_MISCS_LIST");
}

/*********************************************************************/
/*********************************************************************/
string GetObjectShortDesc (object oObject) {
	string sShortDesc = GetName(oObject);
	
	if (sShortDesc == "")
		sShortDesc = GetTag(oObject);
		
	if (sShortDesc == "")	
		sShortDesc = GetResRef(oObject);	

	return sShortDesc;
}

/*********************************************************************/
/*********************************************************************/
string GetEquippedItemTooltip (object oItem) {

	string sName = GetName(oItem);
	int iNameLength = GetStringLength(sName);
	
	if (iNameLength < WAND_MIN_EQ_ITEM_NAME_LENGTH) {		
		string sPaddingSpace = "                 ";
		int iPadding = (WAND_MIN_EQ_ITEM_NAME_LENGTH - iNameLength)/2 + 1;
		sPaddingSpace = GetStringLeft(sPaddingSpace, iPadding);
		sName = sPaddingSpace + sName + sPaddingSpace;
	}
	
	string sTooltip = "<b>" + sName + "</b>";
	sTooltip += "\n\n";
	sTooltip += WAND_PIM_EQUIP_VALUE + IntToString(GetGoldPieceValue(oItem));
	sTooltip += "\n\n";
	sTooltip += WAND_PIM_EQUIP_CURSED;
	sTooltip += (GetItemCursedFlag(oItem)) ? WAND_YES : WAND_NO;
	sTooltip += "\n";
	sTooltip += WAND_PIM_EQUIP_PLOT;
	sTooltip += (GetPlotFlag(oItem)) ? WAND_YES : WAND_NO;
	sTooltip += "\n";
	sTooltip += WAND_PIM_EQUIP_STOLEN;
	sTooltip += (GetStolenFlag(oItem)) ? WAND_YES : WAND_NO;
	sTooltip += "\n";
	sTooltip += WAND_PIM_EQUIP_DROPPABLE;
	sTooltip += (GetDroppableFlag(oItem)) ? WAND_YES : WAND_NO;
	
	return sTooltip;
}

/*********************************************************************/
/*********************************************************************/
string GetInventoryAndEquipmentValueTooltip (int iEquipmentValue, int iInventoryValue) {
	
	string sTooltip = WAND_PIM_TOT_VALUE;
	int iTooltipLength = GetStringLength(sTooltip);
	
	if (iTooltipLength < WAND_INV_AND_EQ_VALUE_LENGTH) {		
		string sPaddingSpace = "                 ";
		int iPadding = (WAND_INV_AND_EQ_VALUE_LENGTH - iTooltipLength)/2 + 1;
		sPaddingSpace = GetStringLeft(sPaddingSpace, iPadding);
		sTooltip = sPaddingSpace + sTooltip + sPaddingSpace;
	}
	
	sTooltip += "\n\n";
	sTooltip += WAND_PIM_EQUIPMENT_VALUE + IntToString(iEquipmentValue);
	sTooltip += "\n";
	sTooltip += WAND_PIM_INV_VALUE + IntToString(iInventoryValue);
	return sTooltip;
}

/*********************************************************************/
/*********************************************************************/
void AddEquippedItem (object oSubject, int iSlot, object oItem) {

	//SetGUIObjectHidden(oSubject, WAND_GUI_PC_INVENTORY, "SLOT_TEXTURE_" + IntToString(iSlot), FALSE);
	if (!GetIsObjectValid(oItem)) {
		SetLocalGUIVariable(oSubject, WAND_GUI_PC_INVENTORY, WAND_PIM_SLOT_TOOLTIP_OFFSET + iSlot, "");
		SetLocalGUIVariable(oSubject, WAND_GUI_PC_INVENTORY, WAND_PIM_SLOT_OFFSET + iSlot, "-1");
		SetGUITexture(oSubject, WAND_GUI_PC_INVENTORY, "SLOT_TEXTURE_" + IntToString(iSlot),"");
		SetGUIObjectDisabled(oSubject, WAND_GUI_PC_INVENTORY, "SLOT_TEXTURE_" + IntToString(iSlot), TRUE);
		return;
	}
	
	string sItemIcon;
	
	switch (GetBaseItemType(oItem)) {
		case BASE_ITEM_CBLUDGWEAPON:
		case BASE_ITEM_CPIERCWEAPON:
		case BASE_ITEM_CSLSHPRCWEAP:
			sItemIcon = "i_claw.tga";
			break;
		case BASE_ITEM_CSLASHWEAPON:
			sItemIcon = "i_bite.tga";
			break;
		case BASE_ITEM_CREATUREITEM:
			sItemIcon = "i_hide.tga";
			break;
		default:
			sItemIcon = GetItemIconResRef(oItem);
			break;
	}	 
	
	SetGUIObjectDisabled(oSubject, WAND_GUI_PC_INVENTORY, "SLOT_TEXTURE_" + IntToString(iSlot), FALSE);	
	SetGUITexture(oSubject, WAND_GUI_PC_INVENTORY, "SLOT_TEXTURE_" + IntToString(iSlot), sItemIcon);
	SetLocalGUIVariable(oSubject, WAND_GUI_PC_INVENTORY, WAND_PIM_SLOT_OFFSET + iSlot, IntToString(ObjectToInt(oItem)));
	SetLocalGUIVariable(oSubject, WAND_GUI_PC_INVENTORY, WAND_PIM_SLOT_TOOLTIP_OFFSET + iSlot, GetEquippedItemTooltip (oItem));
}

/*********************************************************************/
/*********************************************************************/
void RemoveEquippedItem (object oSubject, int iSlot) {

	SetGUIObjectHidden(oSubject, WAND_GUI_PC_INVENTORY, "SLOT_TEXTURE_" + IntToString(iSlot), FALSE);
	SetLocalGUIVariable(oSubject, WAND_GUI_PC_INVENTORY, WAND_PIM_SLOT_OFFSET + iSlot, "-1");
}

/*********************************************************************/
/*********************************************************************/
void AddVar (object oUiOwner, object oTarget, int iIndex) {

	string sListBox, sTexts, sVariables, sVarValue, sIndex;
	int iVarType = GetVariableType(oTarget, iIndex);
	string sVarName = GetVariableName(oTarget, iIndex);
		
	switch (iVarType) {
		case VARIABLE_TYPE_DWORD:
			sListBox = "VAR_OBJ_LIST";	
			sVarValue = (GetIsObjectValid(GetLocalObject(oTarget, sVarName))) ? GetTrimmedString(GetObjectShortDesc(GetLocalObject(oTarget, sVarName))) : "OBJECT_INVALID";
			break;
			
		case VARIABLE_TYPE_FLOAT:		
			sListBox = "VAR_FLOAT_LIST";	
			sVarValue = MyFloatToString(GetLocalFloat(oTarget, sVarName)) + "  ";
			break;
		
		case VARIABLE_TYPE_INT:
			sListBox = "VAR_INT_LIST";	
			sVarValue = IntToString(GetLocalInt(oTarget, sVarName)) + "  ";
			break;
		
		case VARIABLE_TYPE_LOCATION:
			sListBox = "VAR_LOC_LIST"; 
			sVarValue = GetTrimmedString(GetAreaShortDesc(GetAreaFromLocation(GetLocalLocation(oTarget, sVarName))));
			break;

		case VARIABLE_TYPE_STRING:
			sListBox = "VAR_STR_LIST";	
			sVarValue = GetTrimmedString(GetLocalString(oTarget, sVarName));
			break;
			
		default:
			return;					
	}

	sTexts = "VAR_TEXT_BUTTON=" + GetTrimmedString(sVarName) + ";";		
	sTexts += "VAR_VALUE_BUTTON=" + sVarValue + ";";
	
	sIndex = IntToString(iIndex);
	sVariables = "0=" + sIndex;
						
	AddListBoxRow(oUiOwner, WAND_GUI_LV_MANAGER, sListBox, "Var_" + sIndex, sTexts, "", sVariables, "");

}

/*********************************************************************/
/*********************************************************************/
void ModifyVar (object oUiOwner, object oTarget, int iIndex) {

	string sListBox, sTexts, sVariables, sVarValue, sIndex;
	int iVarType = GetVariableType(oTarget, iIndex);
	string sVarName = GetVariableName(oTarget, iIndex);
		
	switch (iVarType) {
		case VARIABLE_TYPE_DWORD:
			sListBox = "VAR_OBJ_LIST";	
			sVarValue = (GetIsObjectValid(GetLocalObject(oTarget, sVarName))) ? GetTrimmedString(GetObjectShortDesc(GetLocalObject(oTarget, sVarName))) : "OBJECT_INVALID";
			break;
			
		case VARIABLE_TYPE_FLOAT:		
			sListBox = "VAR_FLOAT_LIST";	
			sVarValue = MyFloatToString(GetLocalFloat(oTarget, sVarName)) + "  ";
			break;
		
		case VARIABLE_TYPE_INT:
			sListBox = "VAR_INT_LIST";	
			sVarValue = IntToString(GetLocalInt(oTarget, sVarName)) + "  ";
			break;
		
		case VARIABLE_TYPE_LOCATION:
			sListBox = "VAR_LOC_LIST"; 
			sVarValue = GetTrimmedString(GetAreaShortDesc(GetAreaFromLocation(GetLocalLocation(oTarget, sVarName))));
			break;

		case VARIABLE_TYPE_STRING:
			sListBox = "VAR_STR_LIST";	
			sVarValue = GetTrimmedString(GetLocalString(oTarget, sVarName));
			break;
			
		default:
			return;					
	}

	sTexts = "VAR_TEXT_BUTTON=" + GetTrimmedString(sVarName) + ";";		
	sTexts += "VAR_VALUE_BUTTON=" + sVarValue + ";";
	
	sIndex = IntToString(iIndex);
	sVariables = "0=" + sIndex;
			
	ModifyListBoxRow(oUiOwner, WAND_GUI_LV_MANAGER, sListBox, "Var_" + sIndex, sTexts, "", sVariables, "");

}

/*********************************************************************/
/*********************************************************************/
void AddItem (object oUiOwner, object oItem) {

	string sTexts, sTextures, sVariables, sHideUnhide;
	int iBaseItemType = GetBaseItemType(oItem);
	int iItemValue = GetItemValue(oItem);
	string sObjectId = IntToString(ObjectToInt(oItem));
	object oTarget = GetPimTarget(oUiOwner);	
	string sListBox = GetListBoxNameByItemType (iBaseItemType);

	sTexts = "ITEM_TEXT=" + GetTrimmedString(GetName(oItem), WAND_MAX_ITEM_NAME_LENGTH);
	
	// Indico la quantità se l'oggetto è impilato
   	sTexts += (GetItemStackSize(oItem) > 1) 
		? " ("+IntToString(GetItemStackSize(oItem))+");"
		: ";";
		
	sTexts += "ITEM_VALUE=" + IntToString(iItemValue)+ "  ;";
	
	sTextures = "ITEM_IMAGE=" + GetItemIconResRef(oItem);
	
	sVariables = "0=" + sObjectId;
	
	sHideUnhide += "NOT_IDENTIFIED_ICON="; 
	sHideUnhide += (GetIdentified(oItem)) 
		? "hide;"
		: "unhide;";	
	sHideUnhide += "NOT_PLOT_ICON="; 
	sHideUnhide += (GetPlotFlag(oItem)) 
		? "hide;"
		: "unhide;";	
	sHideUnhide += "NOT_CURSED_ICON="; 
	sHideUnhide += (GetItemCursedFlag(oItem)) 
		? "hide;"
		: "unhide;";
	sHideUnhide += "NOT_STOLEN_ICON="; 
	sHideUnhide += (GetStolenFlag(oItem)) 
		? "hide;"
		: "unhide;";	
	sHideUnhide += "NOT_DROPPABLE_ICON="; 
	sHideUnhide += (GetDroppableFlag(oItem)) 
		? "hide;"
		: "unhide;";
	sHideUnhide +=	"LEVEL_RESTRICTED_ICON=";
	sHideUnhide += (iItemValue <= StringToInt(Get2DAString("itemvalue", "MAXSINGLEITEMVALUE", GetHitDice(oTarget) - 1)))
		? "hide;"
		: "unhide;";				
	AddListBoxRow(oUiOwner, WAND_GUI_PC_INVENTORY, sListBox, "Item_" + sObjectId, sTexts, sTextures, sVariables, sHideUnhide);

}

/*********************************************************************/
/*********************************************************************/
void ModifyItem (object oUiOwner, object oItem) {

	string sTexts, sVariables, sHideUnhide;
	int iBaseItemType = GetBaseItemType(oItem);
	string sObjectId = IntToString(ObjectToInt(oItem));
	string sListBox = GetListBoxNameByItemType (iBaseItemType);

	sTexts = "ITEM_TEXT=" + GetTrimmedString(GetName(oItem), WAND_MAX_ITEM_NAME_LENGTH);
	
	// Indico la quantità se l'oggetto è impilato
   	sTexts += (GetItemStackSize(oItem) > 1) 
		? " ("+IntToString(GetItemStackSize(oItem))+");"
		: ";";
		
	sTexts += "ITEM_VALUE=" + IntToString(GetItemValue(oItem))+ "  ;";
	
	sVariables = "0=" + sObjectId;
	
	sHideUnhide += "NOT_IDENTIFIED_ICON="; 
	sHideUnhide += (GetIdentified(oItem)) 
		? "hide;"
		: "unhide;";	
	sHideUnhide += "NOT_PLOT_ICON="; 
	sHideUnhide += (GetPlotFlag(oItem)) 
		? "hide;"
		: "unhide;";	
	sHideUnhide += "NOT_CURSED_ICON="; 
	sHideUnhide += (GetItemCursedFlag(oItem)) 
		? "hide;"
		: "unhide;";
	sHideUnhide += "NOT_STOLEN_ICON="; 
	sHideUnhide += (GetStolenFlag(oItem)) 
		? "hide;"
		: "unhide;";	
	sHideUnhide += "NOT_DROPPABLE_ICON="; 
	sHideUnhide += (GetDroppableFlag(oItem)) 
		? "hide;"
		: "unhide;";
				
	ModifyListBoxRow(oUiOwner, WAND_GUI_PC_INVENTORY, sListBox, "Item_" + sObjectId, sTexts, "", sVariables, sHideUnhide);

}

/*********************************************************************/
/*********************************************************************/
void RemoveItem (object oUiOwner, object oItem) {
	
	int iBaseItemType = GetBaseItemType(oItem);
	string sObjectId = IntToString(ObjectToInt(oItem));
	string sListBox = GetListBoxNameByItemType (iBaseItemType);
	
	RemoveListBoxRow(oUiOwner, WAND_GUI_PC_INVENTORY, sListBox, "Item_" + sObjectId);
}

/*********************************************************************/
/*********************************************************************/
void InitTargetVarRepository (object oSubject, object oTarget) {
    
    int iIndex = 0;
	string sVarName = GetVariableName(oTarget, iIndex);
			
	while (GetVariableType(oTarget, iIndex) != -1) {

		AddVar(oSubject, oTarget, iIndex);

        iIndex++;	
    }	
}

/*********************************************************************/
/*********************************************************************/
struct strInventoryGlobalValues InitTargetInventory (object oSubject, object oTarget) {

    object oItem = GetFirstItemInInventory(oTarget);
	struct strInventoryGlobalValues sigvStruct;
    int iIndex;
	
	while (GetIsObjectValid(oItem)) {
	
		 /* We can't display magical bags with items within */
        //if (!GetIsObjectValid(GetFirstItemInInventory(oItem))) {
            AddItem(oSubject, oItem);
        //}

		sigvStruct.iTotWeight += GetWeight(oItem);
		sigvStruct.iTotValue += GetItemValue(oItem);
        oItem = GetNextItemInInventory(oTarget);
    }

	return sigvStruct;
}

/*********************************************************************/
/*********************************************************************/
struct strInventoryGlobalValues InitTargetEquipment (object oSubject, object oTarget) {
    
    int iIndex;
	object oItem;
	struct strInventoryGlobalValues sigvStruct;
			
	for (iIndex = 0; iIndex < NUM_INVENTORY_SLOTS; iIndex++) {
		
		oItem = GetItemInSlot(iIndex, oTarget);

		AddEquippedItem (oSubject, iIndex, oItem);	
		
		sigvStruct.iTotWeight += GetWeight(oItem);
		sigvStruct.iTotValue += GetItemValue(oItem);
    }
	
	return sigvStruct;
}

/*********************************************************************/
/*********************************************************************/
void DisplayInventory (object oSubject, object oTarget) {

	struct strInventoryGlobalValues sigvStructEquip = InitTargetEquipment(oSubject, oTarget);
	struct strInventoryGlobalValues sigvStructInv = InitTargetInventory(oSubject, oTarget);
	string sEncumbrance;
	int iStrength = GetAbilityScore(oTarget, ABILITY_STRENGTH);
	int iStateNormal = StringToInt(Get2DAString("encumbrance", "Normal", iStrength));
	int iStateHeavy = StringToInt(Get2DAString("encumbrance", "Heavy", iStrength));
	int iTotWeight = sigvStructEquip.iTotWeight + sigvStructInv.iTotWeight;

	if (iTotWeight > iStateHeavy) {
		sEncumbrance = "<color=red>";
	}
	else if (iTotWeight > iStateNormal) {
		sEncumbrance = "<color=yellow>";
	}
	else {
		sEncumbrance = "<color=white>";
	}
	
	sEncumbrance += IntToString(iTotWeight/10); 
	sEncumbrance += "/";
	sEncumbrance += IntToString(iStateHeavy/10);
	sEncumbrance += "</color>";
	
	SetGUIObjectText(oSubject, WAND_GUI_PC_INVENTORY, "TOT_INVENTORY_VALUE", -1, IntToString(sigvStructEquip.iTotValue + sigvStructInv.iTotValue));
	SetGUIObjectText(oSubject, WAND_GUI_PC_INVENTORY, "TOT_GOLD", -1, IntToString(GetGold(oTarget)));
	SetGUIObjectText(oSubject, WAND_GUI_PC_INVENTORY, "ENCUMBRANCE", -1, sEncumbrance);
	SetLocalGUIVariable(oSubject, WAND_GUI_PC_INVENTORY, 1100, GetInventoryAndEquipmentValueTooltip(sigvStructEquip.iTotValue, sigvStructInv.iTotValue));	
}

/*********************************************************************/
/*********************************************************************/
void ResetListBoxesSelection (object oSubject) {

	SetListBoxRowSelected(oSubject, WAND_GUI_PC_INVENTORY, "INVENTORY_ARMORS_LIST", "HIDDEN_ROW");
	SetListBoxRowSelected(oSubject, WAND_GUI_PC_INVENTORY, "INVENTORY_WEAPONS_LIST", "HIDDEN_ROW");
	SetListBoxRowSelected(oSubject, WAND_GUI_PC_INVENTORY, "INVENTORY_USABLES_LIST", "HIDDEN_ROW");
	SetListBoxRowSelected(oSubject, WAND_GUI_PC_INVENTORY, "INVENTORY_MAGIC_OBJS_LIST", "HIDDEN_ROW");
	SetListBoxRowSelected(oSubject, WAND_GUI_PC_INVENTORY, "INVENTORY_MISCS_LIST", "HIDDEN_ROW");	
}

/*********************************************************************/
/*********************************************************************/
void UpdateInventoryValue (object oSubject, object oTarget) {
    int iIndex, iValueEquipment = 0;
	object oItem;
			
	for (iIndex = 0; iIndex < NUM_INVENTORY_SLOTS; iIndex++) {
		
		oItem = GetItemInSlot(iIndex, oTarget);

		iValueEquipment += GetItemValue(oItem);
    }
	
	int iValueInventory = 0;
	oItem = GetFirstItemInInventory(oTarget);
	
	while (GetIsObjectValid(oItem)) {

		iValueInventory += GetItemValue(oItem);
		
        oItem = GetNextItemInInventory(oTarget);
    }
	
	SetGUIObjectText(oSubject, WAND_GUI_PC_INVENTORY, "TOT_INVENTORY_VALUE", -1, IntToString(iValueEquipment + iValueInventory));
	SetLocalGUIVariable(oSubject, WAND_GUI_PC_INVENTORY, 1100, GetInventoryAndEquipmentValueTooltip(iValueEquipment, iValueInventory));	
}
//void main () {}