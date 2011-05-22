// ga_enable_scripts
/*
	restores the saved event handlers
*/
// ChazM 12/21/05
// 
#include "ginc_param_const"	
#include "ginc_event_handlers"
	
void main(string sTarget) 
{
	object oTarget = GetTarget(sTarget);
	RestoreEventHandlers(oTarget);
	DeleteSavedEventHandlers(oTarget);
}		
	