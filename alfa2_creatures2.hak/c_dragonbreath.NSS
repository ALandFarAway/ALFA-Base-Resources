//::///////////////////////////////////////////////
//:: Souffle de dragon / Dragon breath
//:: c_dragonbreath
//:: Copyright (c) 2014 Thierry Petitjean (4760).
//:://////////////////////////////////////////////
/*

    Script to add the breath attacks by the dragons.
	
	Parameters (variables attached to the dragon):
	------------------------------------------------------
	- iDamageType1/2:
	    ° 1=Acid
		° 2=Cold
		° 3=Electricity
		° 4=Fire
		° 5=Negative energy
		° 6=Paralysis
		° 7=Poison
		° 8=Repulsion
		° 9=Sleep
		° 10=Slow
		° 11=Weaken
		° 12=Prismatic spray
	- iBreathShape1/2:
	    ° 1=line
		° 2=cone
	- iDamageDice1/2
	- iDiceNumber1/2
		
	Dragon breath list:
	---------------------
	- Black: line of acid
	- Blue: line of lightning
	- Brass: line of fire, cone of sleep
	- Bronze: line of lightning, cone of repulsion
	- Copper: line of acid, cone of slow
	- Forest (not in D&D rules): cone of acid, cone of paralyzing gas
	- Gold: cone of fire, cone of weakening gas
	- Green: cone of acid
	- Lich: cone of fire
	- Mist (not in D&D rules): line of acid, cone of fire
	- Prismatic: prismatic spray
	- Red: cone of fire
	- Shadow (not in D&D rules): cone of negative energy
	- Silver: cone of cold, cone of paralyzing gas
	- Swamp (not in D&D rules): cone of poison, line of negative energy
	- White: cone of cold
	
*/
//:://////////////////////////////////////////////
//:: Created By: Thierry Petitjean (4760)
//:: Created On: 15th March 2015
//:://////////////////////////////////////////////

int BreathDamage(int iDamageDice, int iDiceNumber)
{
    int nDamage = 1;
	// get damage value
	switch (iDamageDice)
	{
		case 2:
			nDamage += d2(iDiceNumber);
			break;
		case 3:
			nDamage += d3(iDiceNumber);
			break;
		case 4:
			nDamage += d4(iDiceNumber);
			break;
		case 6:
			nDamage += d6(iDiceNumber);
			break;
		case 8:
			nDamage += d8(iDiceNumber);
			break;
		case 10:
			nDamage += d10(iDiceNumber);
			break;
		case 12:
			nDamage += d12(iDiceNumber);
			break;
		case 20:
			nDamage += d20(iDiceNumber);
			break;
		default:
			nDamage = -1;
	}
	return nDamage;
}  

int nSpellAbilityType(int iDamageType)
{
	int nDamageType = -1;
	switch (iDamageType)
	{
		case 1: //acid
			nDamageType = SPELLABILITY_DRAGON_BREATH_ACID;
			break;
		case 2: //cold
			nDamageType = SPELLABILITY_DRAGON_BREATH_COLD;
			break;
		case 3: //electricity
			nDamageType = SPELLABILITY_DRAGON_BREATH_LIGHTNING;
			break;
		case 4: //fire
			nDamageType = SPELLABILITY_DRAGON_BREATH_FIRE;
			break;
		case 5: //negative energy
			nDamageType = SPELLABILITY_DRAGON_BREATH_NEGATIVE;
			break;
		case 6: //paralysis
			nDamageType = SPELLABILITY_DRAGON_BREATH_PARALYZE;
			break;
		case 7: //poison
			nDamageType = SPELLABILITY_DRAGON_BREATH_GAS;
			break;
		case 8: //repulsion
			nDamageType = SPELLABILITY_DRAGON_BREATH_FEAR;
			break;
		case 9: //sleep
			nDamageType = SPELLABILITY_DRAGON_BREATH_SLEEP;
			break;
		case 10: //slow
			nDamageType = SPELLABILITY_DRAGON_BREATH_SLOW;
			break;
		case 11: //weaken
			nDamageType = SPELLABILITY_DRAGON_BREATH_WEAKEN;
			break;
		case 12: //prismatic spray
			nDamageType = SPELLABILITY_DRAGON_BREATH_GAS;
			break;
	}
	return nDamageType;
}

int nDamageType(int iDamageType)
{
	int nDamageType = -1;
	switch (iDamageType)
	{
		case 1: //acid
			nDamageType = DAMAGE_TYPE_ACID;
			break;
		case 2: //cold
			nDamageType = DAMAGE_TYPE_COLD;
			break;
		case 3: //electricity
			nDamageType = DAMAGE_TYPE_ELECTRICAL;
			break;
		case 4: //fire
			nDamageType = DAMAGE_TYPE_FIRE;
			break;
		case 5: //negative energy
			nDamageType = DAMAGE_TYPE_NEGATIVE;
			break;
		case 6: //paralysis
			nDamageType = DAMAGE_TYPE_MAGICAL;
			break;
		case 7: //poison
			nDamageType = DAMAGE_TYPE_DIVINE;
			break;
		case 8: //repulsion
			nDamageType = DAMAGE_TYPE_MAGICAL;
			break;
		case 9: //sleep
			nDamageType = DAMAGE_TYPE_MAGICAL;
			break;
		case 10: //slow
			nDamageType = DAMAGE_TYPE_MAGICAL;
			break;
		case 11: //weaken
			nDamageType = DAMAGE_TYPE_DIVINE;
			break;
		case 12: //prismatic spray
			nDamageType = DAMAGE_TYPE_MAGICAL;
			break;
	}
	return nDamageType;
}

int nBreathShape(int iBreathType)
{
	int iBreathShape = -1;
	switch (iBreathType)
	{
		case 1: //line
			iBreathShape = SHAPE_SPELLCYLINDER;
			break;
		case 2: //cone
			iBreathShape = SHAPE_SPELLCONE;
			break;
		case 3: //spray/cloud
			iBreathShape = SHAPE_SPHERE;
			break;
	}
	return iBreathShape;
}

effect eVisualEffect(int iDamageType, int iBreathShape)
{
	int nDamageEffect = -1;
	switch (iDamageType)
	{
		case 1: //acid
			nDamageEffect = VFX_BEAM_ACID;
			if (iBreathShape == 2) nDamageEffect = VFX_CONE_ACID_BREATH;
			break;
		case 2: //cold
			nDamageEffect = VFX_BEAM_COLD;
			if (iBreathShape == 2) nDamageEffect = VFX_IMP_FROST_S;
			break;
		case 3: //electricity
			nDamageEffect = VFX_BEAM_LIGHTNING;
			if (iBreathShape == 2) nDamageEffect = VFX_IMP_LIGHTNING_S;
			break;
		case 4: //fire
			nDamageEffect = VFX_BEAM_FIRE;
			if (iBreathShape == 2) nDamageEffect = VFX_CONE_RED_DRAGON_FIRE;
			break;
		case 5: //negative energy
			nDamageEffect = VFX_BEAM_EVIL;
			if (iBreathShape == 2) nDamageEffect = VFX_IMP_NEGATIVE_ENERGY;
			break;
		case 6: //paralysis
			nDamageEffect = VFX_BEAM_SHOCKING_GRASP;
			if (iBreathShape == 2) nDamageEffect = VFX_IMP_STUN;
			break;
		case 7: //poison
			nDamageEffect = VFX_BEAM_POISON;
			if (iBreathShape == 2) nDamageEffect = VFX_IMP_POISON_S;
			break;
		case 8: //repulsion
			nDamageEffect = VFX_BEAM_NECROMANCY;
			if (iBreathShape == 2) nDamageEffect = VFX_IMP_DOOM;
			break;
		case 9: //sleep
			nDamageEffect = VFX_BEAM_ILLUSION;
			if (iBreathShape == 2) nDamageEffect = VFX_IMP_SLEEP;
			break;
		case 10: //slow
			nDamageEffect = VFX_BEAM_ENCHANTMENT;
			if (iBreathShape == 2) nDamageEffect = VFX_IMP_SLOW;
			break;
		case 11: //weaken
			nDamageEffect = VFX_BEAM_ICE;
			if (iBreathShape == 2) nDamageEffect = VFX_IMP_REDUCE_ABILITY_SCORE;
			break;
		case 12: //prismatic spray
			nDamageEffect = VFX_BEAM_PRISMATIC_SPRAY;
			if (iBreathShape == 2) nDamageEffect = VFX_DUR_SPELL_PRISMATIC_SPRAY;
			break;
	}
	if (nDamageEffect == -1) return EffectVisualEffect(VFX_NONE, TRUE);
	else return EffectVisualEffect(nDamageEffect);
}

void ApplyDamage(int iBreathShape, int iDamageType, int nDamage, effect eDamageEffect)
{
 	float fDelay;
    location lTargetLocation = GetSpellTargetLocation();
    object oTarget;
    //Get first target in spell area
    oTarget = GetFirstObjectInShape(iBreathShape, 11.0, lTargetLocation, TRUE);
	effect eAreaOfEffect;
    while(GetIsObjectValid(oTarget))
    {
        if(GetIsEnemy(oTarget))
        {
            //Fire cast spell at event for the specified target
            SignalEvent(oTarget, EventSpellCastAt(OBJECT_SELF, iDamageType));
            //Determine effect delay
            fDelay = GetDistanceBetween(OBJECT_SELF, oTarget)/20;
            //Set damage effect
            eAreaOfEffect = EffectDamage(nDamage, iDamageType);
            if(nDamage > 0)
            {
                //Apply the VFX impact and effects
                DelayCommand(fDelay, ApplyEffectToObject(DURATION_TYPE_INSTANT, eDamageEffect, oTarget));
                DelayCommand(fDelay, ApplyEffectToObject(DURATION_TYPE_INSTANT, eAreaOfEffect, oTarget));
            }
        }
        //Get next target in spell area
        oTarget = GetNextObjectInShape(iBreathShape, 11.0, lTargetLocation, TRUE);
    }
}

void main()
{
    //Declare major variables
	// amount of damage
    int iDamageDice1 = GetLocalInt(OBJECT_SELF, "iDamageDice1");
	int iDiceNumber1 = GetLocalInt(OBJECT_SELF, "iDiceNumber1");
    int nDamage1 = BreathDamage(iDamageDice1, iDiceNumber1);
    int iDamageDice2 = GetLocalInt(OBJECT_SELF, "iDamageDice2");
	int iDiceNumber2 = GetLocalInt(OBJECT_SELF, "iDiceNumber2");
    int nDamage2 = BreathDamage(iDamageDice2, iDiceNumber2);
	// shape of area of effect
	int iBreathShape1 = GetLocalInt(OBJECT_SELF, "iBreathShape1");
	int iBreathShape2 = GetLocalInt(OBJECT_SELF, "iBreathShape2");
	iBreathShape1 = nBreathShape(iBreathShape1);
	iBreathShape2 = nBreathShape(iBreathShape2);
	// visual breath effect
	int iDamageType1 = GetLocalInt(OBJECT_SELF, "iDamageType1");
	int iDamageType2 = GetLocalInt(OBJECT_SELF, "iDamageType2");
	effect eDamageEffect1 = eVisualEffect(iDamageType1, iBreathShape1);
	effect eDamageEffect2 = eVisualEffect(iDamageType2, iBreathShape2);
	// type of damage
	int iAbilityType1 = nSpellAbilityType(iDamageType1);
	int iAbilityType2 = nSpellAbilityType(iDamageType2);
	iDamageType1 = nDamageType(iDamageType1);
	iDamageType2 = nDamageType(iDamageType2);
	// Apply damage
	if (iDamageType2 != -1) //means the dragon has two breath types
	{
		if (Random(10) >= 4) ApplyDamage(iBreathShape1, iDamageType1, nDamage1, eDamageEffect1);
		else ApplyDamage(iBreathShape2, iDamageType2, nDamage2, eDamageEffect2);
	}
	else ApplyDamage(iBreathShape1, iDamageType1, nDamage1, eDamageEffect1);
}