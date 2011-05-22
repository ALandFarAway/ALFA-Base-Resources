//gr_report
/*
	info on target
*/
//ChazM 6/28/06
// ChazM 8/23/06 - added hitpoints
// BMA-OEI 8/30/06 - added plotflag, immortal

#include "ginc_param_const"
#include "x0_i0_position"
#include "ginc_event_handlers"

void main(string sTarget)
{
	object oTarget =  GetTarget(sTarget);

	PrettyDebug("----------- Report ------------------");
	PrettyDebug("Target Name: " + GetName(oTarget));
	PrettyDebug(" Hit Points: " + IntToString(GetCurrentHitPoints(oTarget)) + " of " +  IntToString(GetMaxHitPoints(oTarget)) );
	PrettyDebug(" Commandable = " + IntToString(GetCommandable(oTarget)));
	PrettyDebug(" PossessionBlocked = " + IntToString( GetIsCompanionPossessionBlocked(oTarget) ) );
	//PrettyDebug(" Destroyable = Who knows?");
	PrettyDebug(" Plot Flag   = " + IntToString(GetPlotFlag(oTarget)));
	PrettyDebug(" Immortal    = " + IntToString(GetImmortal(oTarget)));
	
    PrettyDebug(GetName(oTarget) + " is currently in:");

	PrettyDebug(" Module: " + GetName(GetModule()) + " / Module Tag: " + GetTag(GetModule()) );
	PrettyDebug(" Area Name: " + GetName(GetArea(oTarget)) + " / Area Tag: " + GetTag(GetArea(oTarget)) );
	PrettyDebug(" Position: " +  VectorToString(GetPosition(oTarget)) );
	PrettyDebug(" Facing:   " +  FloatToString(GetFacing(oTarget)) );
	ReportEventHandlers(oTarget);
	
	
	PrettyDebug("----------- End Report --------------");
	
	
}