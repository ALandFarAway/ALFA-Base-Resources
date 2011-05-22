// ga_camera_facing_point_party
/*
	Point the cameras of all PCs' in the Speaker's party to target sTarget.  
		Camera will be fDistance meters away from the PC, and
	pitched at fPitch degrees.  
	
	-fDistance can be between 1 and 25.  At least 5 is advisable in most cases.
	0 = use distance of current camera value
	
	-fPitch can be between 1 and 89.  89 is nearly parallel to the ground.  
	 1 is almost directly overhead.  60-70 is usually a reasonable default.
	0 = use pitch of current camera value
	
	- nTransitionType can be 0 or between 1 and 100. The higher the number, the faster the transition.
	0 = snap to new facing, no transition.
	
*/
// EPF 9/14/06
// ChazM 9/15/06 - added defaults for current cam, moved funcs to ginc_cutscene

#include "ginc_param_const"
#include "x0_i0_position"
#include "ginc_cutscene"
#include "ginc_math"

void main(string sTarget, float fDistance, float fPitch, int nTransitionType)
{
    object oPC = (GetPCSpeaker()==OBJECT_INVALID?OBJECT_SELF:GetPCSpeaker());
	
	if(!GetIsObjectValid(oPC))
	{
		return;	//if there's no PC speaker, there's no point in setting the cam anyway.
	}
	
	// SetCameraFacing() uses -1.0 to use current camera default, we'll use 0.0 as well.
	if (IsFloatNearInt(fDistance, 0))
		fDistance = -1.0f;
	if (IsFloatNearInt(fPitch, 0))
		fPitch = -1.0f;

	object oTarget = GetTarget(sTarget);
	
	if(GetIsObjectValid(oTarget))
	{	
		SetCameraFacingPointParty(oPC, oTarget, fDistance, fPitch, nTransitionType);
	}
}