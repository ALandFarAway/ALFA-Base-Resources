////////////////////////////////////////////////////////////////////////////////
// PC Inventory Manager
// Original Scripter:  Caos81      Design: Caos81
//------------------------------------------------------------------------------
// Last Modified By:   Caos81           06/02/2009
//------------------------------------------------------------------------------
////////////////////////////////////////////////////////////////////////////////

void _SetLastDraggedItem (object oPc, object oItem) {
	if (GetIsObjectValid(oItem)) {
		SetLocalObject(oPc, "LAST_DRAGGED_ITEM", oItem);
	}
	else 
		DeleteLocalObject(oPc, "LAST_DRAGGED_ITEM");
}

void main (string sItemId) {
	object oPc = OBJECT_SELF;
	
	_SetLastDraggedItem (oPc, IntToObject(StringToInt(sItemId)));	
}