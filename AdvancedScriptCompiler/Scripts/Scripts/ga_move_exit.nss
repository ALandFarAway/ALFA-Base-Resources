// ga_move_exit
/*
    This makes the object go to the exit (default nwc_exit) and then vanish
      nExitNumber = nwc_exit#N
      nRun = TRUE if you want the character to run there
      sWaypoint = go to waypoint nwc_#S then disappear
      sObject = if you don't want the OWNER to move, use the tag string here
*/
// FAB 9/29
// ChazM 6/29/06 - rewrote to use ForceExit() without changing functionality.

#include "ginc_misc"

string GetExitWaypoint(int nExitNumber, string sWaypoint)
{
    string sWPTag;
	
	// No other parameters on the exit are set
	if ( nExitNumber == 0 && sWaypoint == "")
	{
	    sWPTag = "nwc_exit";
	}
	// An exit number is set
	else if ( sWaypoint == "")
	{
	    sWPTag = "nwc_exit" + IntToString(nExitNumber);
	}
	// An exit string is set
	else
	{
	    sWPTag = "nwc_" + sWaypoint;
	}
	
	return (sWPTag);
}

void main(int nExitNumber, int nRun, string sWaypoint, string sObject)
{

    string sWPTag = GetExitWaypoint(nExitNumber, sWaypoint);
	object oWP = GetWaypointByTag(sWPTag); 
	PrettyDebug(" Name of generic exit: " + GetName(oWP));
	ForceExit(sObject, sWPTag, nRun);
	/*
    if ( sObject == "" )
    {
        // No other parameters on the exit are set
        if ( nExitNumber == 0 && sWaypoint == "")
        {
            ActionForceMoveToObject(oWP,nRun );
        }
        // An exit number is set
        else if ( sWaypoint == "")
        {
            ActionForceMoveToObject( GetWaypointByTag("nwc_exit" + IntToString(nExitNumber)),nRun );
        }
        // An exit string is set
        else
        {
            ActionForceMoveToObject( GetWaypointByTag("nwc_" + sWaypoint),nRun );
        }

        // Now queue up the actions for after they move
        ActionDoCommand( SetCommandable(TRUE) );
        ActionDoCommand( DestroyObject(OBJECT_SELF) );
        SetCommandable( FALSE );
    }
    else
    {
        // This is who is going to be executing the command besides the OWNER
        object oTarg = GetObjectByTag( sObject );
		int iCommandable = GetCommandable(oTarg);
		PrettyDebug(GetName(oTarg) + " commandable state is " + IntToString(iCommandable));
    	AssignCommand( oTarg, SetCommandable( TRUE ) );
		PrettyDebug(GetName(oTarg) + " is Target of MoveExit");
        // No other parameters on the exit are set
        if ( nExitNumber == 0 && sWaypoint == "")
        {
			PrettyDebug(" Using generic exit of " + GetName(oWP));
            AssignCommand( oTarg, ActionForceMoveToObject( oWP,nRun ) );
        }
        // An exit number is set
        else if ( sWaypoint == "")
        {
            AssignCommand( oTarg, ActionForceMoveToObject( GetWaypointByTag("nwc_exit" + IntToString(nExitNumber)),nRun ) );
        }
        // An exit string is set
        else
        {`
            AssignCommand( oTarg, ActionForceMoveToObject( GetWaypointByTag("nwc_" + sWaypoint),nRun ) );
        }

        // Now queue up the actions for after they move
        AssignCommand( oTarg, ActionDoCommand( SetCommandable(TRUE) ) );
        AssignCommand( oTarg, ActionDoCommand( DestroyObject(OBJECT_SELF) ) );
        AssignCommand( oTarg, SetCommandable( FALSE ) );
    }
	*/
}