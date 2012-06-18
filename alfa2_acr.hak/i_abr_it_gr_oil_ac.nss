#define FLOAT_RANGE_SHORT 3.0f

void main()
{
	object oPC  = GetItemActivator();
	object oTarget = GetItemActivatedTarget();

	if (GetDistanceBetween(oPC,oTarget) > FLOAT_RANGE_SHORT)
		SendMessageToPC(oPC, "You spill some oil.  You need to get closer.");
	else 
		ApplyEffectToObject(DURATION_TYPE_INSTANT,EffectDamage(1,DAMAGE_TYPE_FIRE),oTarget);
}

