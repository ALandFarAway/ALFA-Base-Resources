// nw_ch_aca
/*
	Henchman On Rest:
    Prevent from resting if var PREVENT_REST set to TRUE.
*/
// ChazM 1/8/07
// ChazM 2/14/07 - Rest prevention.
// ChazM 2/21/07 Script deprecated. Use gb_assoc_* scripts instead.

#include "ginc_event_handlers"

void main()
{
    ConvertToAssociateEventHandler(CREATURE_SCRIPT_ON_RESTED, SCRIPT_ASSOC_REST);
}    
/*
#include "ginc_debug"

//int REST_EVENTTYPE_REST_INVALID     = 0;
//int REST_EVENTTYPE_REST_STARTED     = 1;
//int REST_EVENTTYPE_REST_FINISHED    = 2;
//int REST_EVENTTYPE_REST_CANCELLED   = 3;

void main()
{
	//object oPC = GetLastPCRested();
	//int nType = GetLastRestEventType();
	object oSelf = OBJECT_SELF;
    
	//PrettyMessage("gb_comp_rest: rest event fired for " + GetName(oSelf) + " by " + GetName(oPC) + " type " + IntToString(nType));
    int bPreventRest = GetLocalInt(oSelf, "PREVENT_REST");
    //PrettyMessage("gb_comp_rest: bPreventRest=" + IntToString(bPreventRest));
    if (bPreventRest)
    {
        PrettyMessage("gb_comp_rest: no rest for " + GetName(oSelf) + "! Action are being cleared...");
        // Specultation: Doing a clear actions immediately would do nothing if the event puts the 
        // resting related actions on the queue after this executes.  Assigning the command should 
        // delay it until after those actions are added.
        AssignCommand(oSelf, ClearAllActions());
    }
}
*/