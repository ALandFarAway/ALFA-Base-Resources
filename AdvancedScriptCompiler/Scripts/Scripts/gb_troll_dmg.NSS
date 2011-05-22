//gb_troll_dmg	

//Damge script for trolls, making them un-killable by anything but fire or acid.

//DBR 6/1/6
// DBR 7/12/06 - bugfix, made sure the damaged event fires even if down to 1HP.
// MDiekmann 6/28/07 - Added command to clear combat round flag so trolls will attack players after resurrecting
#include "nw_i0_generic"


void TrollRessurect()
{
	// Clears combat round flag to prevent trolls from staring blankly at player
	SetLocalInt(OBJECT_SELF, VAR_X2_L_MUTEXCOMBATROUND, FALSE);
	ClearAllActions(TRUE);
	ApplyEffectToObject(DURATION_TYPE_INSTANT,EffectHeal(GetMaxHitPoints()),OBJECT_SELF);
	ClearAllActions(TRUE);
	SetLocalInt(OBJECT_SELF,"gb_troll_dmg_down",0);
	DetermineCombatRound();
}

void main()
{
	int nAcid = GetDamageDealtByType(DAMAGE_TYPE_ACID)+1; //returns -1 if none is dealt, 0 if acid damage was dealt, but a very meager amount
	int nFire = GetDamageDealtByType(DAMAGE_TYPE_FIRE)+1;
	if ((nFire+nAcid)!=0)
	{
		if ((GetCurrentHitPoints()<=nAcid+nFire+1)||GetLocalInt(OBJECT_SELF,"gb_troll_dmg_down"))	//if I am knocked down or near death, this kills me.
		{
			SetImmortal(OBJECT_SELF,FALSE);
			object oTroll = OBJECT_SELF;
			AssignCommand(GetLastDamager(),ApplyEffectToObject(DURATION_TYPE_INSTANT,EffectDeath(),oTroll));
			return;
		}
	}
	//If I'm down, put out a fake "weapon ineffective" message.
	if (GetLocalInt(OBJECT_SELF,"gb_troll_dmg_down")==1)
	{
		FloatingTextStrRefOnCreature(4725,GetLastDamager(),FALSE);	
	}
	else if (GetCurrentHitPoints()<=1)//If I've been beaten down, but am not in a knocked down state, put me in one.
	{	
		int nDuration = GetMaxHitPoints()/3;		
		ApplyEffectToObject(DURATION_TYPE_TEMPORARY,EffectKnockdown(),OBJECT_SELF,IntToFloat(nDuration));		
		SetLocalInt(OBJECT_SELF,"gb_troll_dmg_down",1);
		DelayCommand(IntToFloat(nDuration+1),TrollRessurect());
	}
	//otherwise, heal 1HP so that the onDamageevent does fire again.
	ApplyEffectToObject(DURATION_TYPE_INSTANT, EffectHeal(1),OBJECT_SELF);
	
	ExecuteScript("nw_c2_default6",OBJECT_SELF);
}