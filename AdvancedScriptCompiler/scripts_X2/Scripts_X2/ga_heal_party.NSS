//	ga_heal_party
/*
	Heals the entire party of the specified health percentage.
*/
//	JSH-OEI 8/7/08

void main(int nHealPercent)
{
	object oPC = GetFirstFactionMember(GetFirstPC(), FALSE);
	object oTarget;
    int nCurrentHP;
    int nHP;
    effect eHeal;
	effect eVisual = EffectNWN2SpecialEffectFile("sp_cure_critical");

    if ( nHealPercent == 0 )
		nHealPercent = 100;
	
	while(GetIsObjectValid(oPC))
	{
		nCurrentHP = GetCurrentHitPoints(oPC);
		nHP = FloatToInt(IntToFloat(GetMaxHitPoints(oPC)) * IntToFloat(nHealPercent) / 100) - nCurrentHP;
		eHeal = EffectHeal(nHP);
		ApplyEffectToObject(DURATION_TYPE_INSTANT, eHeal, oPC);
		ApplyEffectToObject(DURATION_TYPE_INSTANT, eVisual, oPC);
        oPC = GetNextFactionMember(oPC, FALSE);
	}
}