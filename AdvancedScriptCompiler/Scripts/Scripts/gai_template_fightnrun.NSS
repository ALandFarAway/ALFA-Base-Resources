//::///////////////////////////////////////////////////////////////////////////
//::
//::	gai_template_fightnrun
//::
//::	Attack! When I'm low on health, Run away! If close to death, Attack again! 
//::
//::///////////////////////////////////////////////////////////////////////////
//  DBR 2/28/06

#include "ginc_ai"	
#include "x0_i0_combat"

void main()
{
	int nHealthPercent=GetHealthPercent(OBJECT_SELF);
	int nLastSection = GetLocalInt(OBJECT_SELF,"DS-LS");

	if (nHealthPercent>30)				//Standard DCR Attack if 30% or higher
	{
		if (nLastSection==1)
			return;
		SetLocalInt(OBJECT_SELF,"DS-LS",1);

		AIResetType(OBJECT_SELF);
		SetCombatCondition(X0_COMBAT_FLAG_COWARDLY,FALSE);
	}
	else if (nHealthPercent>10)								//from 15%-29%, run like the dickens
	{
		if (nLastSection==2)
			return;
		SetLocalInt(OBJECT_SELF,"DS-LS",2);

		AIResetType(OBJECT_SELF);
		SetCombatCondition(X0_COMBAT_FLAG_COWARDLY);
	}
	else
	{
		if (nLastSection==3)
			return;
		SetLocalInt(OBJECT_SELF,"DS-LS",3);
		
		AIResetType(OBJECT_SELF);
		SetCombatCondition(X0_COMBAT_FLAG_COWARDLY,FALSE);
		AITurnOffDamageSwitch();
	}


	AIDamageSwitchEndStatement();	//unless you're sure what will happen, don't remove this please.
}