// ga_object_events_clear
/*
	saves off the event handlers as local vars and clears
	the event handlers for the object
	can't be used on areas or modules
*/
// ChazM 4/30/06

#include "ginc_event_handlers"

void main (string sObjectTag)
{
	object oObject = GetObjectByTag(sObjectTag);
	if (GetIsObjectValid(oObject))
	{	
		SafeClearEventHandlers(oObject);
	}
}