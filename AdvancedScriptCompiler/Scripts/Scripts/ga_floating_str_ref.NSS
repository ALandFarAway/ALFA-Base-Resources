// ga_floating_str_ref
/*
	Do floaty str ref text on PC speaker
*/
// ChazM 6/27/06

#include "ginc_debug"

void main(int iStrRef)
{
    object oPC = (GetPCSpeaker()==OBJECT_INVALID?OBJECT_SELF:GetPCSpeaker());
	string sStrRef = GetStringByStrRef(iStrRef);
	//PrettyDebug ("Doing floaty text " + sStrRef + " on " + GetName(oPC));
	FloatingTextStrRefOnCreature(iStrRef, oPC);	
}