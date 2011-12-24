// KEMO 2/09 --- called from KEMO_ANIM GUI
#include "kemo_includes"

void main(int iNudge, float fDistance, int iAnimate)
{
	object oPC = OBJECT_SELF;
	string sAnim = GetLocalString(oPC,"StoredAnimation");
	sAnim = sAnim + "i";
	
	vector vPC = GetPosition(oPC);
	vector vNewPosition;
	
	float fPCFace = GetFacing(oPC);
	vector vFacingFB = AngleToVector(fPCFace);
	vector vFacingLR = AngleToVector(fPCFace-90.0f); // for left-right movement, assume PC is turned
													 // 90 degrees to the right
	vFacingFB = Vector(vFacingFB.x * fDistance, vFacingFB.y * fDistance, vFacingFB.z);
	vFacingLR = Vector(vFacingLR.x * fDistance, vFacingLR.y * fDistance, vFacingLR.z);
	
	
	switch (iNudge)
	{
		case 0: vNewPosition = Vector(vPC.x + vFacingFB.x, vPC.y + vFacingFB.y, vPC.z); break; // forward
		case 1: vNewPosition = Vector(vPC.x - vFacingFB.x, vPC.y - vFacingFB.y, vPC.z); break; // backward
		case 2: vNewPosition = Vector(vPC.x - vFacingLR.x, vPC.y - vFacingLR.y, vPC.z); break; // left
		case 3: vNewPosition = Vector(vPC.x + vFacingLR.x, vPC.y + vFacingLR.y, vPC.z); break; // right
	}
	
	if (!LineOfSightVector(vPC,vNewPosition)) return; // no nudging through walls!
	
	location lDestination = Location(GetArea(oPC),vNewPosition,GetFacing(oPC));
	AssignCommand(oPC,ActionJumpToLocation(lDestination)); // moves the PC

	if (iAnimate)
		{
			AssignCommand(oPC,PlayKemoAnimation(oPC,sAnim)); // reactivates the PC's looping animation
		}
}