////////////////////////////////////////////////////////////////////////////////
// eXtended Sleight of Hand System
// Original Scripter:  Caos81      Design: Caos81
//------------------------------------------------------------------------------
// Last Modified By:   Caos81           18/2/2007
//------------------------------------------------------------------------------
////////////////////////////////////////////////////////////////////////////////
#include "wand_inc"

void main() {    
	
	object oSubject = OBJECT_SELF;		
	
	SetListBoxRowSelected(oSubject, WAND_GUI_LV_MANAGER, "VAR_INT_LIST", "HIDDEN_ROW");
	SetListBoxRowSelected(oSubject, WAND_GUI_LV_MANAGER, "VAR_FLOAT_LIST", "HIDDEN_ROW");
	SetListBoxRowSelected(oSubject, WAND_GUI_LV_MANAGER, "VAR_STR_LIST", "HIDDEN_ROW");
	SetListBoxRowSelected(oSubject, WAND_GUI_LV_MANAGER, "VAR_LOC_LIST", "HIDDEN_ROW");
	SetListBoxRowSelected(oSubject, WAND_GUI_LV_MANAGER, "VAR_OBJ_LIST", "HIDDEN_ROW");
}