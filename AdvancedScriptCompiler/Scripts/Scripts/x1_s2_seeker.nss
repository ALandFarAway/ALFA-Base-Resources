//::///////////////////////////////////////////////
//:: x1_s2_seeker
//:: Copyright (c) 2001 Bioware Corp.
//:://////////////////////////////////////////////
/*
    Seeker Arrow
     - creates an arrow that automatically hits target.
     - normal arrow damage, based on base item type

     - Must have shortbow or longbow in hand.


     APRIL 2003
     - gave it double damage to balance for the fact
       that since its a spell you are losing
       all your other attack actions

     SEPTEMBER 2003 (GZ)
        Added damage penetration
        Added correct enchantment bonus


*/
//:://////////////////////////////////////////////
//:: Created By:
//:: Created On:
//:://////////////////////////////////////////////
#include "X0_I0_SPELLS"
void main()
{
    int nBonus = 0;
    nBonus = ArcaneArcherCalculateBonus() ;
	
    object oTarget = GetSpellTargetObject();
	object oCaster = OBJECT_SELF;
	location lSource = GetLocation( oCaster );
	int nPathType = PROJECTILE_PATH_TYPE_HOMING;
	object oLauncher = GetItemInSlot( INVENTORY_SLOT_RIGHTHAND );
	int nLauncherBaseItemType = GetBaseItemType( oLauncher );
	if ( nLauncherBaseItemType != BASE_ITEM_LONGBOW &&
		 nLauncherBaseItemType != BASE_ITEM_SHORTBOW )
	{
		nLauncherBaseItemType = BASE_ITEM_SHORTBOW;
	}
	
    if (GetIsObjectValid(oTarget) == TRUE)
    {
		location lTarget = GetLocation( oTarget );
		float fTravelTime = GetProjectileTravelTime( lSource, lTarget, nPathType );
		
        int nDamage = ArcaneArcherDamageDoneByBow() *2;
        if (nDamage > 0)
        {
            effect ePhysical = EffectDamage(nDamage, DAMAGE_TYPE_PIERCING,IPGetDamagePowerConstantFromNumber(nBonus));
            //effect eMagic = EffectDamage(nBonus, DAMAGE_TYPE_MAGICAL);

          //Fire cast spell at event for the specified target
            SignalEvent(oTarget, EventSpellCastAt(oCaster, GetSpellId()));

			SpawnItemProjectile( OBJECT_SELF, oTarget, lSource, lTarget, nLauncherBaseItemType, nPathType, OVERRIDE_ATTACK_RESULT_HIT_SUCCESSFUL, 0 );
            DelayCommand( fTravelTime, ApplyEffectToObject(DURATION_TYPE_INSTANT, ePhysical, oTarget) );
            //DelayCommand( fTravelTime, ApplyEffectToObject(DURATION_TYPE_INSTANT, eMagic, oTarget) );
        }
    }
}