//::///////////////////////////////////////////////////
//:: X0_S3_DART
//:: Shoots a dart at the target. The dart animation is produced
//:: by the projectile specifications for this spell in the
//:: spells.2da file, so this merely does a check for a hit
//:: and applies damage as appropriate. 
//::
//:: Copyright (c) 2002 Floodgate Entertainment
//:: Created By: Naomi Novik
//:: Created On: 11/14/2002
//::
//:: CGaw 6/3/06 - Modified to be compatible with existing trap blueprints.
//:: 8/8/06 - BDF-OEI: revised to handle non-creature "casters"
//::///////////////////////////////////////////////////

void main()
{
	//SpawnScriptDebugger();
	
    int nCasterLevel;
    //PrintString("Caster level: " + IntToString(nCasterLevel));
    // Temporary kludge for placeable caster level
    if (GetObjectType(OBJECT_SELF) != OBJECT_TYPE_CREATURE) 
    {
        nCasterLevel = GetReflexSavingThrow( OBJECT_SELF );
		if ( nCasterLevel <= 0 )
		{
			nCasterLevel = GetLocalInt( OBJECT_SELF, "NWN2_PROJECTILE_TRAP_CASTER_LEVEL" );
		}
    }
	else nCasterLevel = GetCasterLevel( OBJECT_SELF );

    object oTarget = GetSpellTargetObject();
    //string sTrapLevel = GetResRef(OBJECT_SELF);
	int nDamageAmount;
	int nDCModifier = 0;
	effect eDamage;

    //if (sTrapLevel == "x0_trapwk_dart")
	if (nCasterLevel < 4)
    {
		nDamageAmount = d4();
		nDCModifier = 0;
        //effect eDamage = EffectDamage(d4());
        //ApplyEffectToObject(DURATION_TYPE_PERMANENT, eDamage, oTarget);
    }
    //else if (sTrapLevel == "x0_trapavg_dart")
	else if (nCasterLevel < 7)
    {
		nDamageAmount = d6();
		nDCModifier = 2;
        //effect eDamage = EffectDamage(d6());
        //ApplyEffectToObject(DURATION_TYPE_PERMANENT, eDamage, oTarget);
    }
    //else if (sTrapLevel == "x0_trapstr_dart")
	else if (nCasterLevel < 11)
    {
		nDamageAmount = d10();	
		nDCModifier = 4;
        //effect eDamage = EffectDamage(d10());
        //ApplyEffectToObject(DURATION_TYPE_PERMANENT, eDamage, oTarget);
    }
    //else if (sTrapLevel == "x0_trapdly_dart")
	else if (nCasterLevel < 15)	
    {
		nDamageAmount = d6(3);
		nDCModifier = 8;
        //effect eDamage = EffectDamage(d15());
        //ApplyEffectToObject(DURATION_TYPE_PERMANENT, eDamage, oTarget);
    }
    //else if (sTrapLevel == "x0_trapftl_dart")
	else
    {
		nDamageAmount = d20();
		nDCModifier = 16;
        //effect eDamage = EffectDamage(d20());
        //ApplyEffectToObject(DURATION_TYPE_PERMANENT, eDamage, oTarget);
    }
	
	// the GetSpellSaveDC() below returns 10 by default
	int nDC = GetSpellSaveDC();
	nDC += nDCModifier;
	nDamageAmount = GetReflexAdjustedDamage( nDamageAmount, oTarget, nDC, SAVING_THROW_TYPE_TRAP );
	eDamage = EffectDamage( nDamageAmount, DAMAGE_TYPE_PIERCING );
	
	// For creature casters we preserve the original "to hit" functionality...
	if ( GetObjectType(OBJECT_SELF) == OBJECT_TYPE_CREATURE )
	{
    	// Don't display feedback
		int nResult = TouchAttackRanged( oTarget, FALSE );
	    if ( nResult > 0 )
	    {
			// a 2 means the attack scored a crit
			if ( nResult == 2 )	nDamageAmount *= 2;
			eDamage = EffectDamage( nDamageAmount, DAMAGE_TYPE_PIERCING );
	        ApplyEffectToObject(DURATION_TYPE_PERMANENT, eDamage, oTarget);
	    }
	}
	else	// ...but for non-creatures, we can't apply the attack bonus so we determine "to hit" 
	{		// using a reflex saving throw, which is more consistent with most other traps.
		if ( !ReflexSave(oTarget, nDC, SAVING_THROW_TYPE_TRAP) )
		{
	        ApplyEffectToObject(DURATION_TYPE_PERMANENT, eDamage, oTarget);		
		}
	}
}