#include "kemo_includes"

void QuickNormalizeHeight(object oPC)
{
	float fPCHeight = GetScale(oPC,SCALE_Z);
	float fPCNaturalZ = GetLocalFloat(oPC,"CharacterHeight");
	float fPCNaturalX = GetLocalFloat(oPC,"CharacterX");
	float fPCNaturalY = GetLocalFloat(oPC,"CharacterY");

	if (fPCNaturalZ != 1.0f && fPCHeight == 1.0f && fPCNaturalZ > 0.0f) // if the character is currently at normalized height, return to natural
	{
		SetScale(oPC,fPCNaturalX,fPCNaturalY,fPCNaturalZ);
	}
}

void main()
{
	object oPC = GetLocalObject(OBJECT_SELF,"StoredAnimationPC");
	string sAnim = GetLocalString(OBJECT_SELF,"StoredAnimationIdle");
	location lSpotPC = GetLocation(oPC);
	location lSpotPoint = GetLocation(OBJECT_SELF);
	vector vSpotPC = GetPositionFromLocation(lSpotPC);
	vector vSpotPoint = GetPositionFromLocation(lSpotPoint);
	
	if (!GetIsObjectValid(oPC))
	{
		DestroyObject(OBJECT_SELF,1.0,FALSE);
		return;
	}
	
	if (vSpotPC != vSpotPoint)
	{
		QuickNormalizeHeight(oPC);
		SetCollision(oPC,1); //turns collision back on.
		DeleteLocalObject(oPC,"AnimationPoint");
		DestroyObject(OBJECT_SELF,1.0,FALSE);
	}
	else
	{
		PlayKemoAnimation(oPC,sAnim);
	}
}