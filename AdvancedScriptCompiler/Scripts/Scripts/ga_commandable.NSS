//ga_commandable
/*
	Set's target's commandable state.
	0 = action stack can not be modified
	1 = action stack can be modified
*/
//ChazM 6/28/06

#include "ginc_param_const"

void main(string sTarget, int iCommandable)
{
	object oTarget =  GetTarget(sTarget);
	AssignCommand(oTarget, SetCommandable(iCommandable));

	int iCommandable = GetCommandable(oTarget);
	PrettyDebug(GetName(oTarget) + " commandable state is " + IntToString(iCommandable));
	
	
}
