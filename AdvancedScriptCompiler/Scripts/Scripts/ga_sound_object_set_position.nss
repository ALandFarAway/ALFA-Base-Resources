// ga_sound_object_set_position(string sTarget, string sPositionTag, float fXoffset, float fYoffset, float fZoffset)
/*
	Sets the position of a sound object.
	Sound Object will play at the tag of the object specified.  
	A vector offset can be specified to fine tune the placement.
	A vector offset can be set relative to the origin of the area by leaving sPositionTag blank.
	
	Parameters:
		string sTarget	= tag of the sound object
		string sPositionTag = tag of an object to use as the position. not required.
		float fXoffset, float fYoffset, float fZoffset = vector offest to the sPositionTag.
*/
//ChazM 8/17/06

#include "ginc_param_const"

void main(string sTarget, string sPositionTag,  float fXoffset, float fYoffset, float fZoffset)
{
	object oTarget = GetSoundObjectByTag(sTarget);
	if (GetIsObjectValid(oTarget)) 
	{
		object oPositionTarget = OBJECT_INVALID;
		if (sPositionTag != "")
		{
			oPositionTarget = GetTarget(sPositionTag);
		}		
		//if (GetIsObjectValid (oPositionTarget))
     	vector vPosition = GetPosition(oPositionTarget); // returns 0 vector if object invalid
		vector vOffset = Vector(fXoffset, fYoffset, fZoffset);
		vPosition = vPosition + vOffset;
		SoundObjectSetPosition(oTarget, vPosition);
	}		
}