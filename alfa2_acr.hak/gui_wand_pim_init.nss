////////////////////////////////////////////////////////////////////////////////
// PC Inventory Manager
// Original Scripter:  Caos81      Design: Caos81
//------------------------------------------------------------------------------
// Last Modified By:   Caos81           28/01/2009
//------------------------------------------------------------------------------
////////////////////////////////////////////////////////////////////////////////

#include "wand_inc"

void main () {
	object oSubject = OBJECT_SELF;

	// Buttons	
	SetGUIObjectText(oSubject, WAND_GUI_PC_INVENTORY, "RADIAL_EXAMINE", -1, WAND_RADIAL_EXAMINE);
	SetGUIObjectText(oSubject, WAND_GUI_PC_INVENTORY, "RADIAL_TAKE", -1, WAND_RADIAL_TAKE);
	SetGUIObjectText(oSubject, WAND_GUI_PC_INVENTORY, "RADIAL_EQUIP_1", -1, WAND_RADIAL_EQUIP_1);
	SetGUIObjectText(oSubject, WAND_GUI_PC_INVENTORY, "RADIAL_EQUIP_2", -1, WAND_RADIAL_EQUIP_2);
	SetGUIObjectText(oSubject, WAND_GUI_PC_INVENTORY, "RADIAL_EQUIP_3", -1, WAND_RADIAL_EQUIP_3);	
	SetGUIObjectText(oSubject, WAND_GUI_PC_INVENTORY, "RADIAL_LOCAL_VAR", -1, WAND_RADIAL_LOC_VAR);
	SetGUIObjectText(oSubject, WAND_GUI_PC_INVENTORY, "RADIAL_IDENTIFIED", -1, WAND_RADIAL_IDENTIFIED);
	SetGUIObjectText(oSubject, WAND_GUI_PC_INVENTORY, "RADIAL_PLOT", -1, WAND_RADIAL_PLOT);
	SetGUIObjectText(oSubject, WAND_GUI_PC_INVENTORY, "RADIAL_CURSED", -1, WAND_RADIAL_CURSED);	
	SetGUIObjectText(oSubject, WAND_GUI_PC_INVENTORY, "RADIAL_STOLEN", -1, WAND_RADIAL_STOLEN);	
	SetGUIObjectText(oSubject, WAND_GUI_PC_INVENTORY, "RADIAL_DROPPABLE", -1, WAND_RADIAL_DROPPABLE);	
	SetGUIObjectText(oSubject, WAND_GUI_PC_INVENTORY, "RADIAL_EXAMINE_EQUIPMENT", -1, WAND_RADIAL_EXAMINE);
	SetGUIObjectText(oSubject, WAND_GUI_PC_INVENTORY, "RADIAL_TAKE_EQUIPMENT", -1, WAND_RADIAL_TAKE);
	SetGUIObjectText(oSubject, WAND_GUI_PC_INVENTORY, "RADIAL_UNEQUIP", -1, WAND_RADIAL_UNEQUIP);	
	SetGUIObjectText(oSubject, WAND_GUI_PC_INVENTORY, "RADIAL_LOCAL_VAR_EQUIPMENT", -1, WAND_RADIAL_LOC_VAR);
	SetGUIObjectText(oSubject, WAND_GUI_PC_INVENTORY, "RADIAL_PLOT_EQUIPMENT", -1, WAND_RADIAL_PLOT);
	SetGUIObjectText(oSubject, WAND_GUI_PC_INVENTORY, "RADIAL_CURSED_EQUIPMENT", -1, WAND_RADIAL_CURSED);	
	SetGUIObjectText(oSubject, WAND_GUI_PC_INVENTORY, "RADIAL_STOLEN_EQUIPMENT", -1, WAND_RADIAL_STOLEN);	
	SetGUIObjectText(oSubject, WAND_GUI_PC_INVENTORY, "RADIAL_DROPPABLE_EQUIPMENT", -1, WAND_RADIAL_DROPPABLE);	
	
	// Tooltips
	SetLocalGUIVariable(oSubject, WAND_GUI_PC_INVENTORY, 1101, WAND_PIM_GOLD);
	SetLocalGUIVariable(oSubject, WAND_GUI_PC_INVENTORY, 1102, WAND_PIM_ENCUMBRANCE);
}