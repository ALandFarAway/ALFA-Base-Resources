////////////////////////////////////////////////////////////////////////////////
// PC Inventory Manager
// Original Scripter:  Caos81      Design: Caos81
//------------------------------------------------------------------------------
// Last Modified By:   Caos81           28/01/2009
//------------------------------------------------------------------------------
////////////////////////////////////////////////////////////////////////////////

#include "wand_inc"
#include "wand_inc_misc"

void Error()
{
	SendMessageToPC(OBJECT_SELF, "You cannot examine that item right now; try moving into the same area as it or refreshing your GUI.");
}

void main(int iItemId)
{    	
	object oSubject = OBJECT_SELF;		
		
	if (!IsDm(oSubject)) {
		DisplayMessageBox(oSubject, -1, WAND_NO_SPAM);
		return;
	}
			
	object oItem = IntToObject(iItemId);

	if(!GetIsObjectValid(oItem) || GetArea(oSubject) != GetArea(GetItemPossessor(oItem)))
	{
		Error();
		return;
	}
	
	DisplayGuiScreen(oSubject, "SCREEN_INVENTORY", FALSE);

	oItem = CopyItem(oItem, oSubject, TRUE);
	if(!GetIsObjectValid(oItem))
	{
		Error();
		return;
	}
	SetIdentified(oItem, TRUE);
	DelayCommand(0.4, AssignCommand(oSubject, ActionExamine(oItem)));
	DestroyObject(oItem, 0.6, FALSE);
	DelayCommand(0.6, CloseGUIScreen(oSubject, "SCREEN_INVENTORY"));

}