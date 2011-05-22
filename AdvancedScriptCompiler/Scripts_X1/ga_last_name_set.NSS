// ga_last_name_set(string sTarget, string sText, int nStrRef)
/*
	Description:
	Sets sTarget's last name to sText + nStrRef.
	
	Parameters:
    	string sTarget  = The target's tag or identifier, if blank use PC_SPEAKER
 		string sText	= Text part, "" for no text.
		int nStrRef 	= string ref part, 0 for no string ref.
*/
// ChazM 4/25/07

#include "ginc_param_const"

void main(string sTarget, string sText, int nStrRef)
{
	object oTarget = GetTarget(sTarget, TARGET_PC_SPEAKER);
	string sStringRef = "";
	if (nStrRef > 0)
		sStringRef = GetStringByStrRef(nStrRef, GetGender(oTarget));
		
	string sLastName = sText + sStringRef;
	SetLastName(oTarget, sLastName);	
}