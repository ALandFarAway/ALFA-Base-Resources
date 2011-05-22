// ga_object_events_restore
/*
	restore saved off event handlers from local vars
	and clear the local vars
	can't be used on areas or modules
*/
// ChazM 4/30/06

#include "ginc_event_handlers"

void main (string sObjectTag)
{
	object oObject = GetObjectByTag(sObjectTag);
	if (GetIsObjectValid(oObject))
	{		
		SafeRestoreEventHandlers(oObject);
	}
}