// ga_summon_animal_companion
/*
	Summon an animal companion
	This doesn't require and will not use up any spells or feats of the Target.
	If the Target does not have an animal companion, nothing happens.
	
	 sTarget = Tag of the NPC that owns the animal companion.  If blank, this defualts to the conversation owner.
*/
// TDE 6/11/07
// ChazM 6/20/07 - comment change, made global

#include "ginc_param_const"
	
void main(string sTarget)
{
	object oOwner = GetTarget(sTarget);
	//AssignCommand( oOwner, SummonFamiliar(oOwner) );
	SummonAnimalCompanion(oOwner);
}