// ga_move
/*
    This moves someone to a waypoint.
        sWP             = Lists the waypoint the object is moving to. 
        nRun            = Defaults to walk, set to 1 for running
        sTagOverride    = If this is null, then OWNER runs the script. Otherwise the string is the
                          tag name of who will run it
*/
// FAB 10/5
// ChazM 6/22/05 - changed to GetTarget()
// ChazM 9/9/05	- modifed waypoint look up to also look for sWP w/o prepending "wp_"
		
#include "ginc_param_const"

void main(string sWP, int nRun, string sTagOverride)
{

    object oTarg = OBJECT_SELF;
    object oWP = GetObjectByTag( "wp_" + sWP );
	if (!GetIsObjectValid(oWP))
		oWP = GetObjectByTag(sWP );
	if (!GetIsObjectValid(oWP))
	{
		PrintString("WARNING - ga_move: couldn't find waypoint: " + sWP);	
		return;
	}

    if ( sTagOverride != "" ) 
		oTarg = GetTarget(sTagOverride);

    AssignCommand(oTarg, ActionForceMoveToObject(oWP, nRun));

}