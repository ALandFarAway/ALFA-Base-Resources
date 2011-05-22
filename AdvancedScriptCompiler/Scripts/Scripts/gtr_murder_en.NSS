// gtr_murder_en
//
// Kills creature with tag "sCreatureToMurder" when PC steps on this.
//
// EPF 7/12/05
	
#include "ginc_misc"
	
void main()
{
	string sCreatureToMurder = GetLocalString(OBJECT_SELF, "sCreatureToMurder");
	object oCreatureToMurder = GetTarget(sCreatureToMurder);
	PrintString("Murder trigger: Murdering " + GetTag(oCreatureToMurder));
	if(GetIsObjectValid(oCreatureToMurder))
	{
		//leave the corpse
		AssignCommand(oCreatureToMurder, SetIsDestroyable(FALSE,FALSE,TRUE));
		ApplyEffectToObject(DURATION_TYPE_INSTANT, EffectDeath(), oCreatureToMurder);	
	}
}