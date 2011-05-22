// ga_scripthidden
//
// Show or Hide an NPC, using its ScriptHiddenProperty.
// 
// sTag is the tag of the object to hide.  The script will affect the nearest object of that tag.
// If there is none in the current area, it will affect whatever's returned by GetObjectByTag().
//
// If bHide is TRUE, the NPC will disappear, if not, the NPC will appear.
	
// EPF 1/9/06
	
#include "ginc_misc"
	
void main(string sTag, int bHide)
{
	object oPC = (GetPCSpeaker()==OBJECT_INVALID?OBJECT_SELF:GetPCSpeaker());
	
	object oTarget = GetNearestObjectByTag(sTag,oPC);
	if(!GetIsObjectValid(oTarget))
	{
		oTarget = GetObjectByTag(sTag);
	}

	SetScriptHidden(oTarget,bHide);
}