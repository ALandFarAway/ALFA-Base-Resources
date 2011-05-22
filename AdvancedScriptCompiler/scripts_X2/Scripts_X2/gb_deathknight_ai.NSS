// gb_deathknight_ai
//
// Determines if a death knight will choose to use its Abyssal Blast ability during combat.
//
// JSH-OEI 6/17/07

#include "ginc_misc"
#include "nw_i0_generic"

#include "hench_i0_ai"	

void main()
{
//	disable this AI
//	Jug_Debug(GetName(OBJECT_SELF) + " running override script 2");
/*	object oEnemy		= GetNearestCreature(CREATURE_TYPE_REPUTATION,REPUTATION_TYPE_ENEMY);
	int nRandom			= Random(3) + 1; // Random number between 1 and 3
	
	SetCreatureOverrideAIScriptFinished(OBJECT_SELF);
	
	if (IsMarkedAsDone(OBJECT_SELF))
	{
		chooseTactics(oEnemy);
		return;
	}
	
	if (nRandom == 3)
	{	
		ActionCastSpellAtObject(SPELLABILITY_ABYSSAL_BLAST, oEnemy, METAMAGIC_NONE, TRUE, 0, PROJECTILE_PATH_TYPE_DEFAULT, FALSE);	
		MarkAsDone(OBJECT_SELF);
	}
	else
	{
		chooseTactics(oEnemy);
	}	*/
}