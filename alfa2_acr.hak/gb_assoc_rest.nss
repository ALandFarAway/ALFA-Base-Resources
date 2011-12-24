// gb_assoc_rest
/*
	Associate On Rest:
    Prevent from resting 
*/
// ChazM 2/15/07
// ChazM 2/26/07 - assign command fix
        
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
        //PrettyMessage("gb_comp_rest: no rest for " + GetName(oSelf) + "! Action are being cleared...");
        // Specultation: Doing a clear actions immediately would do nothing if the event puts the 
        // resting related actions on the queue after this executes.  Assigning the command should 
        // delay it until after those actions are added.
        AssignCommand(oSelf, ClearAllActions());
    }
}
