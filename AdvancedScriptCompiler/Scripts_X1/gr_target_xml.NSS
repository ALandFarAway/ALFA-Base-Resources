// gr_target_xml
/*
    output creature info in XML format to log for specified creature  
*/
// ChazM 3/8/07

#include "ginc_param_const"

void main(string sCreatureTag)
{
	//object oPC = (GetPCSpeaker()==OBJECT_INVALID?OBJECT_SELF:GetPCSpeaker());
    object oCreature = GetTarget(sCreatureTag);
    PrettyDebug("outputting creature info in XML format to log for creature " + GetName(oCreature));

    ExecuteScript("gr_character_xml", oCreature);
}