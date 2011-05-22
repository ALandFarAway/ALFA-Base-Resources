// ga_party_face_target(string sFacer, string sTarget, int bLockOrientation)
/*
   This script commands the party to face sTarget.
	
   Parameters:
   	 string sFactionMember = the tag of any member of the party faction will do.  Can also be a GetTarget() constant.
     string sTarget = Tag of object that the party will orient towards.
     int bLockOrientation = If =1, dialog manager will stop adjusting sFacer's facing for the active dialog.
*/
// BMA-OEI 1/09/06
// EPF 6/22/06 second parameter now uses GetTarget so param constants can be specified for both parameters.

#include "ginc_actions"
#include "ginc_param_const"

void main(string sFactionMember, string sTarget, int bLockOrientation)
{
	object oFM = GetTarget(sFactionMember);
	object oTarget = GetTarget(sTarget);
	object oFacer;
	vector vTarget = GetPosition(oTarget);
	
	
	oFacer = GetFirstFactionMember(oFM, FALSE);
	while(GetIsObjectValid(oFacer))
	{
		AssignCommand(oFacer, ActionDoCommand(SetFacingPoint(vTarget, bLockOrientation)));
		AssignCommand(oFacer, ActionWait(0.5f));
		oFacer = GetNextFactionMember(oFM, FALSE);
	}
}