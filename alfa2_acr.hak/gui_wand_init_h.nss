#include "wand_inc"

void main () {
	object oSubject = OBJECT_SELF;
		
	// Tooltips
	SetLocalGUIVariable(oSubject, WAND_GUI_H, 1000, WAND_VFX);
	SetLocalGUIVariable(oSubject, WAND_GUI_H, 1001, WAND_AMB_SOUDS);	
	SetLocalGUIVariable(oSubject, WAND_GUI_H, 1002, WAND_LOC_SOUDS);
	SetLocalGUIVariable(oSubject, WAND_GUI_H, 1003, WAND_MUSICS);	
	SetLocalGUIVariable(oSubject, WAND_GUI_H, 1004, WAND_DICE);
	SetLocalGUIVariable(oSubject, WAND_GUI_H, 1005, WAND_VOICE_WIDGET);	
	SetLocalGUIVariable(oSubject, WAND_GUI_H, 1006, WAND_FOLLOW);
	SetLocalGUIVariable(oSubject, WAND_GUI_H, 1007, WAND_INVENTORY_MANAGER);	
	SetLocalGUIVariable(oSubject, WAND_GUI_H, 1008, WAND_LOC_VAR_MANAGER);
}