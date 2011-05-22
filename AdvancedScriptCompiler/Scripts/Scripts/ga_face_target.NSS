// ga_face_target(string sFacer, string sTarget, int bLockOrientation)
/*
   This script commands sFacer to face sTarget.
	
   Parameters:
     string sFacer = Tag of object that will do the facing. Default is OWNER
     string sTarget = Tag of object that sFacer will orient towards.
     int bLockOrientation = If =1, dialog manager will stop adjusting sFacer's facing for the active dialog.
*/
// BMA-OEI 1/09/06
// EPF 6/22/06 second parameter now uses GetTarget so param constants can be specified for both parameters.

#include "ginc_actions"
#include "ginc_param_const"

void main(string sFacer, string sTarget, int bLockOrientation)
{
	object oFacer = GetTarget(sFacer, TARGET_OWNER);
	object oTarget = GetTarget(sTarget);
	vector vTarget = GetPosition(oTarget);

	AssignCommand(oFacer, ActionDoCommand(SetFacingPoint(vTarget, bLockOrientation)));
	AssignCommand(oFacer, ActionWait(0.5f));

}