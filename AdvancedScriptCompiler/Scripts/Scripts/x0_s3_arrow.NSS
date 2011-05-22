//::///////////////////////////////////////////////////
//:: X0_S3_ARROW
//:: Fires arrow(s) at the target and surrounding targets
//:: with increasing damage and attack bonuses for higher
//:: caster level. 
//::
//:: Copyright (c) 2002 Floodgate Entertainment
//:: Created By: Naomi Novik
//:: Created On: 11/10/2002
//::
//:: CGaw 6/3/06 - Modified to be compatible with existing trap blueprints.
//:: 8/8/06 - BDF-OEI: revised DoAttack to handle non-creature "casters"
//::	and revised main() to fire multiple projectiles at the same target
//::///////////////////////////////////////////////////


void DoAttack( object oTarget, int nDamageBonus, int nAttackBonus )
{
	int nDamage = d6() + nDamageBonus;
	// the GetSpellSaveDC() below returns 10 by default
	int nDC = GetSpellSaveDC();
	nDC += nAttackBonus;
	nDamage = GetReflexAdjustedDamage( nDamage, oTarget, nDC, SAVING_THROW_TYPE_TRAP );
	effect eDamage = EffectDamage( nDamage, DAMAGE_TYPE_PIERCING );
	
	// For creature casters we preserve the original "to hit" functionality...
	if ( GetObjectType(OBJECT_SELF) == OBJECT_TYPE_CREATURE )
	{
	    // Apply the attack bonus if we should have one
	    if (nAttackBonus > 0) 
		{
	        ApplyEffectToObject(DURATION_TYPE_TEMPORARY, EffectAttackIncrease(nAttackBonus), OBJECT_SELF, 5.0f);
	    }
    	// Don't display feedback
		int nResult = TouchAttackRanged( oTarget, FALSE );
	    if ( nResult > 0 )
	    {
			// a 2 means the attack scored a crit
			if ( nResult == 2 )	nDamage *= 2;
			eDamage = EffectDamage( nDamage, DAMAGE_TYPE_PIERCING );
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
/*	
	string sMyTag = GetTag( OBJECT_SELF );
	object oTrap = GetNearestObjectByTag( sMyTag, OBJECT_SELF );
	string sTrapLevel = GetResRef( oTrap );
*/
    //PrintString("New caster level: " + IntToString(nCasterLevel));

    // Determine the level-based changes
    int nExtraProjectiles = 0;
    int nDamageBonus = 0;
    int nAttackBonus = 0;

    // Possible levels: 1, 4, 7, 11, 15
    if (nCasterLevel < 4) {
        // no changes
    } else if (nCasterLevel < 7) {
        nExtraProjectiles = 1;
        nDamageBonus = 1;
        nAttackBonus = 1;
    } else if (nCasterLevel < 11) {
        nExtraProjectiles = 2;
        nDamageBonus = 2;
        nAttackBonus = 2;
    } else if (nCasterLevel < 15) {
        nExtraProjectiles = 3;
        nDamageBonus = 3;
        nAttackBonus = 3;
    } else {
        nExtraProjectiles = 4;
        nDamageBonus = 4;
        nAttackBonus = 4;
    }
/*
    // Possible levels: 1, 4, 7, 11, 15
    if (sTrapLevel == "x0_trapwk_arrow") {
        nExtraTargets = 0;
        nDamageBonus = 0;
        nAttackBonus = 0;
    } else if (sTrapLevel == "x0_trapavg_arrow") {
        nExtraTargets = 1;
        nDamageBonus = 1;
        nAttackBonus = 1;
    } else if (sTrapLevel == "x0_trapstr_arrow") {
        nExtraTargets = 2;
        nDamageBonus = 2;
        nAttackBonus = 2;
    } else if (sTrapLevel == "x0_trapdly_arrow") {
        nExtraTargets = 3;
        nDamageBonus = 3;
        nAttackBonus = 3;
    } else if (sTrapLevel == "x0_trapftl_arrow") {		
        nExtraTargets = 4;
        nDamageBonus = 4;
        nAttackBonus = 4;
    }
*/
        
    object oTarget = GetSpellTargetObject();
	location lTarget = GetLocation( oTarget );
	location lSource = GetLocation( OBJECT_SELF );
	int nPathType = PROJECTILE_PATH_TYPE_DEFAULT;
	float fTravelTime = GetProjectileTravelTime( lSource, lTarget, nPathType );
    DoAttack( oTarget, nDamageBonus, nAttackBonus );
    int i;
	float fDelay1 = 0.1f;
 	float fDelay2 = 0.1f;
   
	// The functionality below is not so good because there is no guarantee that
	// the next-nearest target should even be in range of the trap
	//object oNextTarget = GetNearestObject(OBJECT_TYPE_CREATURE, oTarget);
	
    for ( i = 1; i <= nExtraProjectiles; i++ ) 
	{
        // Fire another arrow at the target, but fakely
        DelayCommand( fDelay1, ActionCastFakeSpellAtObject(SPELL_TRAP_ARROW, oTarget, nPathType) );
        DelayCommand( fDelay1 + fTravelTime, DoAttack(oTarget, nDamageBonus, nAttackBonus) );
		fDelay1 += fDelay2;
        //oNextTarget = GetNearestObject( OBJECT_TYPE_CREATURE, oTarget, i+1 );
    }
}