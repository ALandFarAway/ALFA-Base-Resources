void main()
{
	object oTarget = GetSpellTargetObject();
	if(GetObjectType(oTarget) == OBJECT_TYPE_CREATURE)
	{
		int nTouch = TouchAttackMelee(oTarget);
		int nDamage = d6();
		if(nTouch == 2) nDamage += d6();
		if(nTouch)
		{
			if(nDamage >  GetAbilityScore(oTarget, ABILITY_STRENGTH) &&
			   !GetIsImmune(oTarget, IMMUNITY_TYPE_ABILITY_DECREASE))
			{
				ApplyEffectToObject(DURATION_TYPE_INSTANT, EffectDeath(), oTarget);
			}
			else
			{
				effect eEffect = GetFirstEffect(oTarget);
				while(GetIsEffectValid(eEffect))
				{
					if(GetEffectSpellId(eEffect) == GetSpellId())
					{
						nDamage += GetEffectInteger(eEffect, 1);
						RemoveEffect(oTarget, eEffect);
					}
					eEffect = GetNextEffect(oTarget);
				}
			}
			ApplyEffectToObject(DURATION_TYPE_PERMANENT, ExtraordinaryEffect(EffectAbilityDecrease(ABILITY_STRENGTH, nDamage)), oTarget);
		}
	}
}