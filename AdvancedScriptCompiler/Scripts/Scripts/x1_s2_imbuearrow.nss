//::///////////////////////////////////////////////
//:: x1_s2_imbuearrow
//:: Copyright (c) 2001 Bioware Corp.
//:://////////////////////////////////////////////
/*
    Imbue Arrow
     - creates a fireball arrow that when it explodes
     acts like a fireball.
     - Must have shortbow or longbow in hand.

    GZ: Updated

*/
//:://////////////////////////////////////////////
//:: Created By:
//:: Created On:
//:://////////////////////////////////////////////
#include "X0_I0_SPELLS"


void main()
{

    //Declare major variables
    object oCaster = OBJECT_SELF;
    int nCasterLvl = GetLevelByClass(CLASS_TYPE_ARCANE_ARCHER,oCaster); // * get a bonus of +10 to make this useful for arcane archer
    int nDamage;
    float fDelay, fTravelTime;
    effect eExplode = EffectVisualEffect(VFX_FNF_FIREBALL);
    effect eVis = EffectVisualEffect(VFX_IMP_FLAME_M);
    effect eDam;
    //Get the spell target location as opposed to the spell target.
    location lTarget = GetSpellTargetLocation();
    //Limit Caster level for the purposes of damage
    if (nCasterLvl > 10)
    {
        nCasterLvl = 10 + ((nCasterLvl-10)/2);      // add some epic progression of 1d6 per 2 levels after 10
    }
    else // * preserve minimum damage of 10d6
    {
         nCasterLvl = 10;
    }
	
	object oLauncher = GetItemInSlot( INVENTORY_SLOT_RIGHTHAND );
	int nLauncherBaseItemType = GetBaseItemType( oLauncher );
	if ( nLauncherBaseItemType != BASE_ITEM_LONGBOW &&
		 nLauncherBaseItemType != BASE_ITEM_SHORTBOW )
	{
		nLauncherBaseItemType = BASE_ITEM_SHORTBOW;
	}
	
    object oTarget = GetSpellTargetObject();
	location lTargetLoc;
	location lSource = GetLocation( OBJECT_SELF );
	int nPathType = PROJECTILE_PATH_TYPE_HOMING;
	
	
    // * GZ: Add arrow damage if targeted on creature...
    if (GetIsObjectValid(oTarget))
    {
        //if (spellsIsTarget(oTarget, SPELL_TARGET_SELECTIVEHOSTILE, OBJECT_SELF))
        if (spellsIsTarget(oTarget, SPELL_TARGET_STANDARDHOSTILE, OBJECT_SELF))
        {
  		lTargetLoc = GetLocation( oTarget );
		fTravelTime = GetProjectileTravelTime( lSource, lTargetLoc, nPathType );
				
          	int nTouch = TouchAttackRanged(oTarget, TRUE);
          	if (nTouch > 0)
          	{
          	int bCrit = (nTouch == 2 && !GetIsImmune(oTarget, IMMUNITY_TYPE_CRITICAL_HIT));
            	nDamage = ArcaneArcherDamageDoneByBow(bCrit);

            	int  nBonus = ArcaneArcherCalculateBonus() ;
            	effect ePhysical = EffectDamage(nDamage, DAMAGE_TYPE_PIERCING,IPGetDamagePowerConstantFromNumber(nBonus));
            	//effect eMagic = EffectDamage(nBonus, DAMAGE_TYPE_MAGICAL);
				DelayCommand( fTravelTime, ApplyEffectToObject(DURATION_TYPE_INSTANT, ePhysical, oTarget) );
            	//DelayCommand( fTravelTime, ApplyEffectToObject(DURATION_TYPE_INSTANT, eMagic, oTarget) );
          	}
            	SpawnItemProjectile( OBJECT_SELF, oTarget, lSource, lTargetLoc, nLauncherBaseItemType, nPathType, OVERRIDE_ATTACK_RESULT_HIT_SUCCESSFUL, DAMAGE_TYPE_FIRE );
        }
    }
	else	// in order to support SpawnItemProjectile() we need a destination object; let's create a waypoint
	{
		oTarget = CreateObject( OBJECT_TYPE_WAYPOINT, "nw_waypoint001", lTarget );
		lTarget = GetLocation( oTarget );
		fTravelTime = GetProjectileTravelTime( lSource, lTarget, nPathType );
		SpawnItemProjectile( OBJECT_SELF, oTarget, lSource, lTarget, nLauncherBaseItemType, nPathType, OVERRIDE_ATTACK_RESULT_HIT_SUCCESSFUL, DAMAGE_TYPE_FIRE );
		DestroyObject( oTarget );	// clean it up!
	}

    //Apply the fireball explosion at the location captured above.
    DelayCommand( fTravelTime, ApplyEffectAtLocation(DURATION_TYPE_INSTANT, eExplode, lTarget) );
    //Declare the spell shape, size and the location.  Capture the first target object in the shape.
    oTarget = GetFirstObjectInShape(SHAPE_SPHERE, RADIUS_SIZE_HUGE, lTarget, TRUE, OBJECT_TYPE_CREATURE | OBJECT_TYPE_DOOR | OBJECT_TYPE_PLACEABLE);
    //Cycle through the targets within the spell shape until an invalid object is captured.
    while (GetIsObjectValid(oTarget))
    {
        //if(spellsIsTarget(oTarget, SPELL_TARGET_SELECTIVEHOSTILE, OBJECT_SELF) == TRUE)
        if (spellsIsTarget(oTarget, SPELL_TARGET_STANDARDHOSTILE, OBJECT_SELF))
        {

            //Fire cast spell at event for the specified target
            SignalEvent(oTarget, EventSpellCastAt(OBJECT_SELF, GetSpellId(), TRUE));
            //Get the distance between the explosion and the target to calculate delay
            fDelay = GetDistanceBetweenLocations(lTarget, GetLocation(oTarget))/20;
            if (!MyResistSpell(OBJECT_SELF, oTarget, fDelay))
            {
                //Roll damage for each target
                nDamage = d6(nCasterLvl);
                //Resolve metamagic
                //Adjust the damage based on the Reflex Save, Evasion and Improved Evasion.
                nDamage = GetReflexAdjustedDamage(nDamage, oTarget, GetSpellSaveDC(), SAVING_THROW_TYPE_FIRE);
                //Set the damage effect
                eDam = EffectDamage(nDamage, DAMAGE_TYPE_FIRE);
                if(nDamage > 0)
                {
                    // Apply effects to the currently selected target.
                    DelayCommand(fTravelTime, ApplyEffectToObject(DURATION_TYPE_INSTANT, eDam, oTarget));
                    //This visual effect is applied to the target object not the location as above.  This visual effect
                    //represents the flame that erupts on the target not on the ground.
                    DelayCommand(fTravelTime, ApplyEffectToObject(DURATION_TYPE_INSTANT, eVis, oTarget));
                }
             }
        }
       //Select the next target within the spell shape.
       oTarget = GetNextObjectInShape(SHAPE_SPHERE, RADIUS_SIZE_HUGE, lTarget, TRUE, OBJECT_TYPE_CREATURE | OBJECT_TYPE_DOOR | OBJECT_TYPE_PLACEABLE);
    }
}