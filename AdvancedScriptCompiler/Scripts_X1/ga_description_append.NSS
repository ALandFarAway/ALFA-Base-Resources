// ga_description_append(string sTarget, string sText, int nStrRef)
/*
	Description:
	Appends sText and nStrRef to the end of sTarget's description.
	
	Parameters:
    	string sTarget  = The target's tag or identifier, if blank use PC_SPEAKER
 		string sText	= Text to append (recommend using a single space if appending a sting ref)
		int nStrRef 	= string ref to append, 0 for no string ref.
*/
// ChazM 6/21/07

#include "ginc_param_const"

void main(string sTarget, string sText, int nStrRef)
{
	object oTarget = GetTarget(sTarget, TARGET_PC_SPEAKER);
	string sStringRef = "";
	if (nStrRef > 0)
		sStringRef = GetStringByStrRef(nStrRef, GetGender(oTarget));
		
	string sDescription = GetDescription(oTarget) + sText + sStringRef;
	SetDescription(oTarget, sDescription);

}