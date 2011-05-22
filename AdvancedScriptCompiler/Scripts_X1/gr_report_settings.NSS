// gr_report_settings
/*
	Description:
	report various settings.
	
*/
// ChazM 6/19/07
#include "ginc_debug"

void main()
{
	object oTarget = OBJECT_SELF;
	PrettyDebug("----------- Report ------------------");
	PrettyDebug(" Module: " + GetName(GetModule()) + " / Module Tag: " + GetTag(GetModule()) );
	PrettyDebug(" Area Name: " + GetName(GetArea(oTarget)) + " / Area Tag: " + GetTag(GetArea(oTarget)) );
	PrettyDebug(" Max Num Henchmen: " + IntToString(GetMaxHenchmen()));
		
	
	PrettyDebug("----------- End Report --------------");
	
}