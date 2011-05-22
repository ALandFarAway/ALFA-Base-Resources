// ga_floating_text
/*
	Do floaty text on PC speaker
*/
// ChazM 6/27/06

#include "ginc_debug"

void main(string sText)
{
    object oPC = (GetPCSpeaker()==OBJECT_INVALID?OBJECT_SELF:GetPCSpeaker());
	// PrettyDebug ("Doing floaty text on " + GetName(oPC));
	FloatingTextStringOnCreature(sText, oPC);	
}