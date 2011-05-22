// ga_last_name_prepend(int nStrRef, string sText, string sTarget)
/*
	Description:
	Prepends nStrRef and sText to the beginning of sTarget's last name.
	
	Parameters:
		int nStrRef 	= string ref to append, 0 for no string ref.
 		string sText	= Text to append (recommend using a single space if prepending a sting ref)
    	string sTarget  = The target's tag or identifier, if blank use PC_SPEAKER
*/
// ChazM 4/25/07

#include "ginc_param_const"

void main(int nStrRef, string sText, string sTarget)
{
	object oTarget = GetTarget(sTarget, TARGET_PC_SPEAKER);
	string sStringRef = "";
	if (nStrRef > 0)
		sStringRef = GetStringByStrRef(nStrRef, GetGender(oTarget));
		
	string sLastName =  sStringRef + sText + GetLastName(oTarget);
	SetLastName(oTarget, sLastName);	
}