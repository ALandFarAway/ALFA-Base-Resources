////////////////////////////////////////////////////////////////////////////////
// PC Inventory Manager
// Original Scripter:  Caos81      Design: Caos81
//------------------------------------------------------------------------------
// Last Modified By:   Caos81           28/01/2009
//------------------------------------------------------------------------------
////////////////////////////////////////////////////////////////////////////////

#include "wand_inc"
#include "wand_inc_misc"

void main(int iItemId)
{    	
	object oSubject = OBJECT_SELF;		
		
	if (!IsDm(oSubject)) {
		DisplayMessageBox(oSubject, -1, WAND_NO_SPAM);
		return;
	}
			
	object oItem = IntToObject(iItemId);
	
	DisplayGuiScreen(oSubject, "SCREEN_INVENTORY", FALSE);

	oItem = CopyItem(oItem, oSubject, TRUE);
	SetIdentified(oItem, TRUE);
	DelayCommand(0.4, AssignCommand(oSubject, ActionExamine(oItem)));
	DestroyObject(oItem, 0.6, FALSE);
	DelayCommand(0.6, CloseGUIScreen(oSubject, "SCREEN_INVENTORY"));

}