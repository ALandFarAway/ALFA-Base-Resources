////////////////////////////////////////////////////////////////////////////////
// Local Var Manager
// Original Scripter:  Caos81      Design: Caos81
//------------------------------------------------------------------------------
// Last Modified By:   Caos81           27/01/2009
//------------------------------------------------------------------------------
////////////////////////////////////////////////////////////////////////////////
#include "wand_inc"
#include "wand_inc_misc"

void main(int iItemId) { 
   	
	object oSubject = OBJECT_SELF;

	// SECURITY CHECK
	if (!IsDm(oSubject)) {
		DisplayMessageBox(oSubject, -1, WAND_NO_SPAM);
        return;
    }	
	
	object oItem = IntToObject(iItemId);
	
	if (!GetIsObjectValid(oItem)) {
		DisplayMessageBox(oSubject, -1, WAND_WRONG_VALUES);
        return;
	}
	
	int iSlot1 = -1;
	int iSlot2 = -1;	
	int iSlot3 = -1;	
	string sItemName = GetName(oItem);
	object oTarget = GetPimTarget(oSubject);
	
	switch (GetBaseItemType(oItem)) {
		case BASE_ITEM_BRACER:
		case BASE_ITEM_GLOVES:		
			iSlot1 = INVENTORY_SLOT_ARMS;
			break;
			
		case BASE_ITEM_ARROW:	
			iSlot1 = INVENTORY_SLOT_ARROWS;
			break;
		
		case BASE_ITEM_BELT:	
			iSlot1 = INVENTORY_SLOT_BELT;
			break;
		
		case BASE_ITEM_BOLT:	
			iSlot1 = INVENTORY_SLOT_BOLTS;
			break;
		
		case BASE_ITEM_BOOTS:		
			iSlot1 = INVENTORY_SLOT_BOOTS;
			break;
		
		case BASE_ITEM_BULLET:		
			iSlot1 = INVENTORY_SLOT_BULLETS;
			break;
		
		case BASE_ITEM_CREATUREITEM:
			iSlot1 = INVENTORY_SLOT_CARMOUR;
			break;
		
		case BASE_ITEM_ARMOR:		
			iSlot1 = INVENTORY_SLOT_CHEST;
			break;
			
		case BASE_ITEM_CLOAK:
			iSlot1 = INVENTORY_SLOT_CLOAK;
			break;
		
		case BASE_ITEM_CBLUDGWEAPON:
		case BASE_ITEM_CPIERCWEAPON:
		case BASE_ITEM_CSLASHWEAPON:
		case BASE_ITEM_CSLSHPRCWEAP:					
			iSlot1 = INVENTORY_SLOT_CWEAPON_R;
			iSlot2 = INVENTORY_SLOT_CWEAPON_L;
			iSlot3 = INVENTORY_SLOT_CWEAPON_B;
			break;
			
		case BASE_ITEM_HELMET:		
			iSlot1 = INVENTORY_SLOT_HEAD;
			break;
		
		case BASE_ITEM_DRUM:
		case BASE_ITEM_FLUTE:
		case BASE_ITEM_MANDOLIN:
		case BASE_ITEM_LARGESHIELD:
		case BASE_ITEM_SMALLSHIELD:
		case BASE_ITEM_TORCH:
		case BASE_ITEM_TOWERSHIELD:		
			iSlot2 = INVENTORY_SLOT_LEFTHAND;
			break;
			
		case BASE_ITEM_ALLUSE_SWORD:
		case BASE_ITEM_BASTARDSWORD:
		case BASE_ITEM_BATTLEAXE:
		case BASE_ITEM_CLUB:
		case BASE_ITEM_DAGGER:
		case BASE_ITEM_DWARVENWARAXE:
		case BASE_ITEM_FLAIL:
		case BASE_ITEM_HANDAXE:
		case BASE_ITEM_KAMA:
		case BASE_ITEM_KATANA:
		case BASE_ITEM_KUKRI:
		case BASE_ITEM_LIGHTFLAIL:
		case BASE_ITEM_LIGHTHAMMER:
		case BASE_ITEM_LIGHTMACE:
		case BASE_ITEM_LONGSWORD:
		case BASE_ITEM_MACE:
		case BASE_ITEM_MORNINGSTAR:
		case BASE_ITEM_RAPIER:
		case BASE_ITEM_SCIMITAR:
		case BASE_ITEM_SHORTSWORD:
		case BASE_ITEM_SICKLE:
		case BASE_ITEM_TRAINING_CLUB:
		case BASE_ITEM_WARHAMMER:
		case BASE_ITEM_WHIP: 	
			iSlot1 = INVENTORY_SLOT_RIGHTHAND; 		
			iSlot2 = INVENTORY_SLOT_LEFTHAND;			
			break;

		case BASE_ITEM_DART:
		case BASE_ITEM_DIREMACE:
		case BASE_ITEM_DOUBLEAXE:
		case BASE_ITEM_FALCHION:
		case BASE_ITEM_GREATAXE:
		case BASE_ITEM_GREATCLUB:
		case BASE_ITEM_GREATSWORD:
		case BASE_ITEM_HALBERD:
		case BASE_ITEM_HEAVYCROSSBOW:
		case BASE_ITEM_HEAVYFLAIL:
		case BASE_ITEM_LIGHTCROSSBOW:
		case BASE_ITEM_LONGBOW:
		case BASE_ITEM_MAGICROD:
		case BASE_ITEM_QUARTERSTAFF:
		case BASE_ITEM_SCYTHE:
		case BASE_ITEM_SHORTBOW:
		case BASE_ITEM_SHORTSPEAR:
		case BASE_ITEM_SHURIKEN:
		case BASE_ITEM_SLING:
		case BASE_ITEM_SPEAR:
		case BASE_ITEM_THROWINGAXE:
		case BASE_ITEM_TWOBLADEDSWORD:
		case BASE_ITEM_WARMACE:
			iSlot1 = INVENTORY_SLOT_RIGHTHAND;
			
			if (!GetWeaponRanged(oItem) && GetHasFeat(FEAT_MONKEY_GRIP, oTarget))
				iSlot2 = INVENTORY_SLOT_LEFTHAND;
				
			break;
				
		case BASE_ITEM_RING:
			iSlot1 = INVENTORY_SLOT_RIGHTRING;	
			iSlot2 = INVENTORY_SLOT_LEFTRING;
			break;
			
		case BASE_ITEM_AMULET:	
			iSlot1 = INVENTORY_SLOT_NECK;
			break;
			
		default:
			break;	
	}	
 	SetGUIObjectText(oSubject, WAND_GUI_PC_INVENTORY, "SELECTED_ITEM_NAME", -1, sItemName);	
	
	if (iSlot1 == -1) {		
		SetGUIObjectDisabled(oSubject, WAND_GUI_PC_INVENTORY, "RADIAL_EQUIP_1_ICON", TRUE);
		SetGUIObjectDisabled(oSubject, WAND_GUI_PC_INVENTORY, "RADIAL_EQUIP_1", TRUE);
	}
	else {
		SetGUIObjectDisabled(oSubject, WAND_GUI_PC_INVENTORY, "RADIAL_EQUIP_1_ICON", FALSE);
		SetGUIObjectDisabled(oSubject, WAND_GUI_PC_INVENTORY, "RADIAL_EQUIP_1", FALSE);
		SetLocalGUIVariable(oSubject, WAND_GUI_PC_INVENTORY, 1, IntToString(iSlot1));
	}
	
	if (iSlot2 == -1) {	
		SetGUIObjectDisabled(oSubject, WAND_GUI_PC_INVENTORY, "RADIAL_EQUIP_2_ICON", TRUE);	
		SetGUIObjectDisabled(oSubject, WAND_GUI_PC_INVENTORY, "RADIAL_EQUIP_2", TRUE);
	}
	else {
		SetGUIObjectDisabled(oSubject, WAND_GUI_PC_INVENTORY, "RADIAL_EQUIP_2_ICON", FALSE);
		SetGUIObjectDisabled(oSubject, WAND_GUI_PC_INVENTORY, "RADIAL_EQUIP_2", FALSE);
		SetLocalGUIVariable(oSubject, WAND_GUI_PC_INVENTORY, 2, IntToString(iSlot2));
	}
	
	if (iSlot3 == -1) {	
		SetGUIObjectDisabled(oSubject, WAND_GUI_PC_INVENTORY, "RADIAL_EQUIP_3_ICON", TRUE);	
		SetGUIObjectDisabled(oSubject, WAND_GUI_PC_INVENTORY, "RADIAL_EQUIP_3", TRUE);
	}
	else {
		SetGUIObjectDisabled(oSubject, WAND_GUI_PC_INVENTORY, "RADIAL_EQUIP_3_ICON", FALSE);	
		SetGUIObjectDisabled(oSubject, WAND_GUI_PC_INVENTORY, "RADIAL_EQUIP_3", FALSE);
		SetLocalGUIVariable(oSubject, WAND_GUI_PC_INVENTORY, 3, IntToString(iSlot3));
	}	
}