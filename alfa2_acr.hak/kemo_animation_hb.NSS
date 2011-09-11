#include "kemo_includes"

const float FLT_EPSILON = 0.000001f;

int FLT_EQUAL(float f1, float f2)
{
	return fabs(f1 - f2) < FLT_EPSILON;
}

int FLT_NEQUAL(float f1, float f2)
{
	return !FLT_EQUAL(f1, f2);
}

void QuickNormalizeHeight(object oPC)
{
	float fPCHeight = GetScale(oPC,SCALE_Z);
	float fPCNaturalZ = GetLocalFloat(oPC,"CharacterHeight");
	float fPCNaturalX = GetLocalFloat(oPC,"CharacterX");
	float fPCNaturalY = GetLocalFloat(oPC,"CharacterY");

	// If we haven't set the character X/Y/Height yet then do not attempt to
	// adjust the scale downwards to zero (which makes the model appear to
	// vanish).

	if (FLT_EQUAL(fPCNaturalZ, 0.0f) || FLT_EQUAL(fPCNaturalX, 0.0f) || FLT_EQUAL(fPCNaturalY, 0.0f))
		return;

	if (FLT_NEQUAL(fPCNaturalZ, 1.0f) && FLT_EQUAL(fPCHeight, 1.0f) && fPCNaturalZ > 0.0f) // if the character is currently at normalized height, return to natural
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
