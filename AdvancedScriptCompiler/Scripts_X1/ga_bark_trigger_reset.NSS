// ga_bark_trigger_reset
/*
	Description:
	reset last bark trigger.
	
	Place this on last node of dialog (we didn't speak so reset and give someone else a chance)

*/
// ChazM 5/25/07

#include "ginc_trigger"
#include "ginc_vars"

void main()
{
	object oLastBarkTrigger = GetLocalObject(OBJECT_SELF, VAR_LAST_BARK_TRIGGER);
	MarkAsUndone(oLastBarkTrigger);
}