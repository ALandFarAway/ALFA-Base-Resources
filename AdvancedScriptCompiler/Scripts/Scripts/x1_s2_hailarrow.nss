//::///////////////////////////////////////////////
//:: x1_s2_hailarrow
//:: Copyright (c) 2001 Bioware Corp.
//:://////////////////////////////////////////////
/*
    One arrow per arcane archer level at all targets

    GZ SEPTEMBER 2003
        Added damage penetration

*/
//:://////////////////////////////////////////////
//:: Created By:
//:: Created On:
//:://////////////////////////////////////////////
#include "x0_i0_spells"

// GZ: 2003-07-23 fixed criticals not being honored
void DoAttack(object oTarget)
{
    int nBonus = ArcaneArcherCalculateBonus();
    int nDamage;
    // * Roll Touch Attack
    int nTouch = TouchAttackRanged(oTarget, TRUE);
    if (nTouch > 0)
    {
        int bCrit = (nTouch == 2 && !GetIsImmune(oTarget, IMMUNITY_TYPE_CRITICAL_HIT));
        nDamage = ArcaneArcherDamageDoneByBow(bCrit);
        if (nDamage > 0)
        {
            // * GZ: Added correct damage power
            effect ePhysical = EffectDamage(nDamage, DAMAGE_TYPE_PIERCING, IPGetDamagePowerConstantFromNumber(nBonus));
            //effect eMagic = EffectDamage(nBonus, DAMAGE_TYPE_MAGICAL);
            ApplyEffectToObject(DURATION_TYPE_INSTANT, ePhysical, oTarget);
            //ApplyEffectToObject(DURATION_TYPE_INSTANT, eMagic, oTarget);
        }
    }
}

void main()
{

    object oTarget;

    int nLevel = GetLevelByClass(CLASS_TYPE_ARCANE_ARCHER, OBJECT_SELF);
	object oLauncher = GetItemInSlot( INVENTORY_SLOT_RIGHTHAND );
	int nLauncherBaseItemType = GetBaseItemType( oLauncher );
	if ( nLauncherBaseItemType != BASE_ITEM_LONGBOW &&
		 nLauncherBaseItemType != BASE_ITEM_SHORTBOW )
	{
		nLauncherBaseItemType = BASE_ITEM_SHORTBOW;
	}
	
    int i = 0;
    float fDist = 0.0;
    float fDelay = 0.0;
	float fTravelTime;
	int nPathType = PROJECTILE_PATH_TYPE_HOMING;
	location lCaster = GetLocation( OBJECT_SELF );
	location lTarget;

    for (i = 1; i <= nLevel; i++)
    {
        oTarget = GetNearestCreature(CREATURE_TYPE_REPUTATION, REPUTATION_TYPE_ENEMY, OBJECT_SELF, i);
        if (GetIsObjectValid(oTarget) == TRUE)
        {
			lTarget = GetLocation( oTarget );
			if ( i == 1 )
			{
				if ( GetDistanceBetween(OBJECT_SELF, oTarget) > 20.0f )
				{
					nPathType = PROJECTILE_PATH_TYPE_BALLISTIC;
				}
				fDelay = 0.0f;
			}
			else
			{
				//fDelay = GetRandomDelay( 0.1f, 0.3f ) + (0.5f * IntToFloat(i));
				fDelay += 0.1f;
			}
			
			fTravelTime = GetProjectileTravelTime( lCaster, lTarget, nPathType );
			
			/*
            fDist = GetDistanceBetween(OBJECT_SELF, oTarget);
            fDelay = fDist/(3.0 * log(fDist) + 2.0);
			*/

            //Fire cast spell at event for the specified target
            SignalEvent(oTarget, EventSpellCastAt(OBJECT_SELF, GetSpellId()));
            //effect eArrow = EffectVisualEffect(357);
            //ApplyEffectToObject(DURATION_TYPE_INSTANT, eArrow, oTarget);
			DelayCommand( fDelay, SpawnItemProjectile(OBJECT_SELF, oTarget, lCaster, lTarget, nLauncherBaseItemType, nPathType, OVERRIDE_ATTACK_RESULT_HIT_SUCCESSFUL, 0) );
            DelayCommand( fDelay + fTravelTime, DoAttack(oTarget) );
        }
    }
}