// gp_pseudo_spawn_hb
/*
	Description:
	Signal UserDefinedEvent on the first hearbeat - simulating an onspawn.
	Useful for keeping everything together in the UD script.
*/
// ChazM 4/19/07

#include "ginc_vars"
#include "ginc_event_handlers" 

// Fire the EVENT_PLACEABLE_SPAWN event just once.
void main()
{
	// use event number as done flag number since this is unlikely to be an already used "done" flag.
	if (IsMarkedAsDone(OBJECT_SELF, EVENT_PLACEABLE_SPAWN))
		return;
	
	SignalEvent(OBJECT_SELF, EventUserDefined(EVENT_PLACEABLE_SPAWN));
	MarkAsDone(OBJECT_SELF, EVENT_PLACEABLE_SPAWN);
}