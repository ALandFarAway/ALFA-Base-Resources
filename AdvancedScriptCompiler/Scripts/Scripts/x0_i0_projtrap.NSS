//:://////////////////////////////////////////////////
//:: X0_I0_PROJTRAP
/*
Simple library for projectile traps.
 */
//:://////////////////////////////////////////////////
//:: Copyright (c) 2002 Floodgate Entertainment
//:: Created By: Naomi Novik
//:: Created On: 11/10/2002
//:://////////////////////////////////////////////////

/**********************************************************************
 * CONSTANTS
 **********************************************************************/


/**********************************************************************
 * FUNCTION PROTOTYPES
 **********************************************************************/

// Get the origin for a projectile trap. This simply returns the nearest
// object to the target that has a tag matching the tag of the trigger. 
object GetProjectileTrapOrigin(object oTarget, object oTrigger=OBJECT_SELF);

// Causes oOrigin to fire a specified spell (SPELL_*) at oTarget, 
// using the specified caster level (SEE *** COMMENTS). 
//
// *** The specified level doesn't work yet. 
// *** As a kludge, we are using the reflex save of the origin as
// *** the caster level. This kludge only works for a few spells
// *** at the moment. Other spells will fire typically at the
// *** highest caster level allowed for that spell. 
// 
// If the origin is invalid, the function will attempt to find the
// object nearest the target that has the same tag as the trigger.
// If no such object exists, we assume that the origin of the trap 
// has been destroyed, and don't fire the trap.
//
// Only creatures, placeables, and items can be used as trap origins.
//
// Note that a few spells (notably the arrow/bolt/dart/shuriken) require
// PROJECTILE_PATH_TYPE_HOMING to work correctly. 
//
// See the projectile trap trigger blueprints for usage.
// 
// 8/8/06 - BDF-OEI: sadly, the projectile origins that were used in
// 		NWN2 OC didn't have their Reflex saves set in accordance to this
// 		practice, so we are going to actually "set" them according to the
//		caster level that is being passed in as an EffectSavingThrowIncrease
//		in the event that the origin instance's Reflex save value is < 0.
void TriggerProjectileTrap(int nSpell, object oTarget, int nCasterLevel=20, object oOrigin=OBJECT_INVALID, object oTrigger=OBJECT_SELF, int nProjectilePath = PROJECTILE_PATH_TYPE_DEFAULT);




/**********************************************************************
 * FUNCTION DEFINITIONS
 **********************************************************************/

// Small private function -- this just checks to see if the item
// is a valid origin object.
int GetIsTrapOriginValid(object oOrigin)
{
    int nType = GetObjectType(oOrigin);
    switch (nType) {
    case OBJECT_TYPE_CREATURE:
    case OBJECT_TYPE_PLACEABLE:
    case OBJECT_TYPE_ITEM:
        return TRUE;
    }
    return FALSE;
}


// Get the origin for a projectile trap. This simply returns the nearest
// object to the target that has a tag matching the tag of the trigger. 
object GetProjectileTrapOrigin(object oTarget, object oTrigger=OBJECT_SELF)
{
    object oOrigin = GetNearestObjectByTag( GetTag(oTrigger), oTarget );
    int nCheck = 1;
    while (GetIsObjectValid(oOrigin) 
           && !GetIsTrapOriginValid(oOrigin) 
           && GetArea(oOrigin) == GetArea(oTarget)) 
    {
        nCheck++;
        oOrigin = GetNearestObjectByTag( GetTag(oTrigger), oTarget, nCheck );
    }

    if (GetArea(oOrigin) != GetArea(oTarget)) {
        return OBJECT_INVALID;
    }

    return oOrigin;
}


// See detailed comments above
void TriggerProjectileTrap(int nSpell, 
                           object oTarget, 
                           int nCasterLevel=20,
                           object oOrigin=OBJECT_INVALID, 
                           object oTrigger=OBJECT_SELF,
                           int nProjectilePath = PROJECTILE_PATH_TYPE_DEFAULT)
{
    object oTrapOrigin = oOrigin;
    if ( ! GetIsObjectValid(oTrapOrigin) ) {
        oTrapOrigin = GetProjectileTrapOrigin( oTarget, oTrigger );
    }

    if ( ! GetIsObjectValid(oTrapOrigin) ) {
        // Origin destroyed, nothing happens
        return;
    }
	
	
	// 8/8/06 - BDF-OEI: this is the defense for non-creature trap origins that have a Reflex
	// 	save of less than or equal to 0 (which causes the caster level to be treated as 0)
	if ( GetObjectType(oTrapOrigin) != OBJECT_TYPE_CREATURE )
	{
		int nReflex = GetReflexSavingThrow( oTrapOrigin );
		if ( nReflex <= 0 )
		{
			SetLocalInt( oTrapOrigin, "NWN2_PROJECTILE_TRAP_CASTER_LEVEL", nCasterLevel );
			//effect eReflex = EffectSavingThrowIncrease( SAVING_THROW_REFLEX, nCasterLevel - nReflex );
			//ApplyEffectToObject( DURATION_TYPE_PERMANENT, eReflex, oTrapOrigin );
		}
	}

    // Cast the spell at the target.
    AssignCommand( oTrapOrigin, 
                   ActionCastSpellAtObject(nSpell, 
                                           oTarget, 
                                           METAMAGIC_ANY,
                                           TRUE, 
                                           nCasterLevel, // this value is not actually utilized anywhere in ActionCastSpellAtObject()
                                           nProjectilePath, 
                                           TRUE) );
}


/* 
void main() {}
 /* */