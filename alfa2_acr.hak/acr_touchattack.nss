void main()
{
	object oTarget = GetSpellTargetObject();
	int SaveDC = GetHitDice(OBJECT_SELF) / 2 + GetAbilityModifier(ABILITY_CHARISMA, OBJECT_SELF) + 10;

	if(GetLocalString(OBJECT_SELF, "ACR_TOUCH_ATTACK") == "WRAITH")
	{
		if(GetObjectType(oTarget) == OBJECT_TYPE_CREATURE)
		{
			int nTouch = TouchAttackMelee(oTarget);
			int nDamage = d4();
			if(nTouch == 2) nDamage += d4();
			int nDrain = d6();
			if(nTouch && !FortitudeSave(oTarget, SaveDC, SAVING_THROW_TYPE_NEGATIVE, OBJECT_SELF))
			{
				if(nDrain >  GetAbilityScore(oTarget, ABILITY_CONSTITUTION) &&
				   !GetIsImmune(oTarget, IMMUNITY_TYPE_ABILITY_DECREASE))
				{
					ApplyEffectToObject(DURATION_TYPE_INSTANT, EffectDeath(), oTarget);
				}
				else
				{
					effect eEffect = GetFirstEffect(oTarget);
					while(GetIsEffectValid(eEffect))
					{
						if(GetEffectSpellId(eEffect) == GetSpellId() &&
						   GetEffectCreator(eEffect) == OBJECT_SELF)
						{
							nDrain += GetEffectInteger(eEffect, 1);
							RemoveEffect(oTarget, eEffect);
						}
						eEffect = GetNextEffect(oTarget);
					}
				}
				ApplyEffectToObject(DURATION_TYPE_PERMANENT, SupernaturalEffect(EffectTemporaryHitpoints(5)), OBJECT_SELF);
				ApplyEffectToObject(DURATION_TYPE_PERMANENT, SupernaturalEffect(EffectAbilityDecrease(ABILITY_CONSTITUTION, nDrain)), oTarget);
				ApplyEffectToObject(DURATION_TYPE_INSTANT, EffectDamage(nDamage), oTarget);
				ApplyEffectToObject( DURATION_TYPE_INSTANT, EffectVisualEffect( VFX_IMP_PULSE_NEGATIVE ), oTarget );
			}
		}
	}
	else if(GetLocalString(OBJECT_SELF, "ACR_TOUCH_ATTACK") == "GHOST")
	{
		if(GetObjectType(oTarget) == OBJECT_TYPE_CREATURE)
		{
			int nTouch = TouchAttackMelee(oTarget);
			int nDamage = d6();
			if(nTouch == 2) nDamage += d6();
			int nDrain = d6();
			if(nTouch)
			{
				effect eEffect = GetFirstEffect(oTarget);
				while(GetIsEffectValid(eEffect))
				{
					if(GetEffectSpellId(eEffect) == GetSpellId() &&
					   GetEffectCreator(eEffect) == OBJECT_SELF)
					{
						nDrain += GetEffectInteger(eEffect, 1);
						RemoveEffect(oTarget, eEffect);
					}
					eEffect = GetNextEffect(oTarget);
				}
				int nAbility = ABILITY_STRENGTH;
				
				// TODO: Make this less metagamey (perhaps integrate with ACR_CreatureBehavior?)
				if(GetLevelByClass(CLASS_TYPE_SORCERER, oTarget) ||
				   GetLevelByClass(CLASS_TYPE_FAVORED_SOUL, oTarget) ||
				   GetLevelByClass(CLASS_TYPE_BARD, oTarget))
				{
					nAbility = ABILITY_CHARISMA;
				}
				if(GetLevelByClass(CLASS_TYPE_CLERIC, oTarget) ||
				   GetLevelByClass(CLASS_TYPE_DRUID, oTarget) ||
				   GetLevelByClass(CLASS_TYPE_SPIRIT_SHAMAN, oTarget))
				{
					nAbility = ABILITY_WISDOM;
				}
				if(GetLevelByClass(CLASS_TYPE_WIZARD, oTarget))
				{
					nAbility = ABILITY_INTELLIGENCE;
				}
				
				if(nDrain >  GetAbilityScore(oTarget, nAbility) &&
				   !GetIsImmune(oTarget, IMMUNITY_TYPE_ABILITY_DECREASE))
				{
					ApplyEffectToObject(DURATION_TYPE_INSTANT, EffectParalyze(), oTarget);
				}
        ApplyEffectToObject(DURATION_TYPE_INSTANT, EffectHeal(5), OBJECT_SELF);
				ApplyEffectToObject(DURATION_TYPE_PERMANENT, SupernaturalEffect(EffectAbilityDecrease(nAbility, nDrain)), oTarget);
				ApplyEffectToObject(DURATION_TYPE_INSTANT, EffectDamage(nDamage), oTarget);
				ApplyEffectToObject(DURATION_TYPE_INSTANT, EffectVisualEffect( VFX_IMP_PULSE_NEGATIVE ), oTarget );
			}
		}
	}
	else if(GetLocalString(OBJECT_SELF, "ACR_TOUCH_ATTACK") == "ALLIP")
	{
		if(GetObjectType(oTarget) == OBJECT_TYPE_CREATURE)
		{
			int nTouch = TouchAttackMelee(oTarget);
			int nDamage = d4();
			if(nTouch == 2) nDamage += d4();
			if(nTouch)
			{
				if(nDamage >  GetAbilityScore(oTarget, ABILITY_WISDOM) &&
				   !GetIsImmune(oTarget, IMMUNITY_TYPE_ABILITY_DECREASE))
				{
					ApplyEffectToObject(DURATION_TYPE_PERMANENT, EffectSleep(), oTarget);
				}
				else
				{
					effect eEffect = GetFirstEffect(oTarget);
					while(GetIsEffectValid(eEffect))
					{
						if(GetEffectSpellId(eEffect) == GetSpellId() &&
						   GetEffectCreator(eEffect) == OBJECT_SELF)
						{
							nDamage += GetEffectInteger(eEffect, 1);
							RemoveEffect(oTarget, eEffect);
						}
						eEffect = GetNextEffect(oTarget);
					}
				}
				ApplyEffectToObject(DURATION_TYPE_PERMANENT, SupernaturalEffect(EffectTemporaryHitpoints(5)), OBJECT_SELF);
				ApplyEffectToObject(DURATION_TYPE_PERMANENT, SupernaturalEffect(EffectAbilityDecrease(ABILITY_WISDOM, nDamage)), oTarget);
				ApplyEffectToObject( DURATION_TYPE_INSTANT, EffectVisualEffect( VFX_IMP_PULSE_NEGATIVE ), oTarget );
			}
		}
	}
	else if(GetLocalString(OBJECT_SELF, "ACR_TOUCH_ATTACK") == "WISP")
	{
		if(GetObjectType(oTarget) == OBJECT_TYPE_CREATURE)
		{
			int nTouch = TouchAttackMelee(oTarget);
			int nDamage = d8(2);
			if(nTouch == 2) nDamage += d8(2);
			if(nTouch)
			{
				ApplyEffectToObject( DURATION_TYPE_INSTANT, EffectDamage( nDamage, DAMAGE_TYPE_ELECTRICAL ), oTarget );
				ApplyEffectToObject( DURATION_TYPE_TEMPORARY, EffectBeam( VFX_BEAM_SHOCKING_GRASP, OBJECT_SELF ), oTarget, 1.0f );
			}
		}
	}
	else
	{
		if(GetObjectType(oTarget) == OBJECT_TYPE_CREATURE)
		{
			int nTouch = TouchAttackMelee(oTarget);
			int nDamage = 0;
			if(GetLocalString(OBJECT_SELF, "ACR_TOUCH_ATTACK") == "GREATER SHADOW")
			{
        nDamage = d8();
        if(nTouch == 2) nDamage += d8();
			}
			else
			{
        nDamage = d6();
        if(nTouch == 2) nDamage += d6();
			}
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
						if(GetEffectSpellId(eEffect) == GetSpellId() &&
						   GetEffectCreator(eEffect) == OBJECT_SELF)
						{
							nDamage += GetEffectInteger(eEffect, 1);
							RemoveEffect(oTarget, eEffect);
						}
						eEffect = GetNextEffect(oTarget);
					}
				}
				ApplyEffectToObject(DURATION_TYPE_PERMANENT, ExtraordinaryEffect(EffectAbilityDecrease(ABILITY_STRENGTH, nDamage)), oTarget);
				ApplyEffectToObject( DURATION_TYPE_INSTANT, EffectVisualEffect( VFX_IMP_PULSE_NEGATIVE ), oTarget );
			}
		}
	}
}