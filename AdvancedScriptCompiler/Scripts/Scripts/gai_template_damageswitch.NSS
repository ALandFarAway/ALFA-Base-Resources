//::///////////////////////////////////////////////////////////////////////////
//::
//::	gai_template_damageswitch
//::
//::	SpawnScript that will alter a creature's behavior based on how hurt they are.
//::
//::///////////////////////////////////////////////////////////////////////////
// DBR 2/28/06

#include "ginc_ai"	
#include "x0_i0_combat"

void main()
{
	int nHealthPercent=GetHealthPercent(OBJECT_SELF);


	if (nHealthPercent>=70)				//at 70%-100%, do nothing
	{
		//DelayCommand(0.2f,SpeakString("You will never defeat me!"));
		//AIResetType(OBJECT_SELF);	//for clean AI transition, call AIResetType before setting a new AI type.
		//AIIgnoreCombat(OBJECT_SELF);
	}
	else if (nHealthPercent>=30)				//at 30%-69%, attack weakest
	{
		//DelayCommand(0.2f,SpeakString("You're stronger than I thought!!"));
		//AIResetType(OBJECT_SELF);
		//AIAttackPreference(OBJECT_SELF,ATTACK_PREFERENCE_WEAKEST);
	}
	else										//from 29% and below, run like the dickens
	{
		//DelayCommand(0.2f,SpeakString("Oh God, Not in the Face!!"));
		//AIResetType(OBJECT_SELF);
		//SetCombatCondition(X0_COMBAT_FLAG_COWARDLY);
	}



	//This line is the only REQUIRED statement for this AI type.
	AIDamageSwitchEndStatement();	//unless you're sure what will happen, don't remove this please.
}