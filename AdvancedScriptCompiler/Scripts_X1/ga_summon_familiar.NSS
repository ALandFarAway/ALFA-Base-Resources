// ga_summon_familiar
/*
	Summon a familiar
	This doesn't require and will not use up any spells or feats of the Target.
	If the Target does not have a familiar, nothing happens.
	
	 sTarget = Tag of the NPC that owns the familiar.  If blank, this defualts to the conversation owner.
*/
// TDE 6/11/07
// ChazM 6/20/07 - comment change, made global

#include "ginc_param_const"
	
void main(string sTarget)
{
	object oOwner = GetTarget(sTarget);
	//AssignCommand( oOwner, SummonFamiliar(oOwner) );
	SummonFamiliar(oOwner);
}