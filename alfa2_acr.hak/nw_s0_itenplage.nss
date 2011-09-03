//::///////////////////////////////////////////////
//:: Tenacious Plague
//:: NW_S0_itenplage
//:: Copyright (c) 2006 Obsidian Entertainment Inc.
//:://////////////////////////////////////////////
/*
	The warlock calls forth swarms of magical 
	locusts that harass and bite hostile targets within
	the defined area.
	
	One swarm is summoned for every three character levels.
	Swarms attack at +4 and deal 2d6 magical damage.
	
	This script is based on my implementation of 
	Creeping Doom.  Notable changes are that this 
	spell cannot stack, there are fewer swarms summoned,
	and swarms deal magical damage instead of poison.
*/
//:://////////////////////////////////////////////
//:: Created By: Patrick Mills
//:: Created On:  August, 17 2006
//:://////////////////////////////////////////////
//pkm oei 10.20.06 - AB +4 was way too low for mid-late game.  Changed rules.

#include "x2_inc_spellhook"
#include "x0_i0_spells"


int RunRollToHit( object oTarget );
void RunSwarmAttack( object oTarget, float fDuration );

void main()
{	

/* 
  Spellcast Hook Code 
  Added 2003-06-23 by GeorgZ
  If you want to make changes to all spells,
  check x2_inc_spellhook.nss to find out more
  
*/

    if (!X2PreSpellCastCode())
    {
	// If code within the PreSpellCastHook (i.e. UMD) reports FALSE, do not run this spell
        return;
    }
	
	/*// Prevent unwanted stacking
	int nID = GetSpellId();
	if ( GetHasSpellEffect(nID) )
	{
		effect eEffect = GetFirstEffect( OBJECT_SELF );
		while ( GetIsEffectValid(eEffect) )
		{
			if ( GetEffectSpellId(eEffect) == nID )
			{
				RemoveEffect( OBJECT_SELF, eEffect );
			}
			
			eEffect = GetNextEffect( OBJECT_SELF );
		}
	}*/
	
	//Declare major variables
	location lTarget = GetSpellTargetLocation();
	object oCaster = OBJECT_SELF; 
	int nCasterLvl = GetCasterLevel( oCaster );
	int nSwarms = ( nCasterLvl / 3 );
	
	int nDuration = 3;
	float fDuration = RoundsToSeconds(nDuration);
	effect ePedes = EffectVisualEffect( VFX_DUR_INVOCATION_TENACIOUS_PLAGUE );

	
	//Meta-magic fun
	int nMetaMagic = GetMetaMagicFeat();
	if (nMetaMagic == METAMAGIC_EXTEND)
    {
		nDuration = nDuration * 2;	//Duration is +100%
    }
	
	int nMaxSwarms = nSwarms;
	
	//Find the first victim
	object oTarget = GetFirstObjectInShape( SHAPE_SPHERE, RADIUS_SIZE_LARGE, lTarget );
	object oTarget2 = GetNextObjectInShape( SHAPE_SPHERE, RADIUS_SIZE_LARGE, lTarget );
	//If the first object is the caster and the second object is invalid, we do not have any valid targets
	if (oTarget == OBJECT_SELF && !GetIsObjectValid( oTarget2 ))
	{
		return;
	}
	
	oTarget = GetFirstObjectInShape( SHAPE_SPHERE, RADIUS_SIZE_LARGE, lTarget );
	//While we still have swarms to assign, run the following logic
	while ( nSwarms > 0) 
	{
		if (GetIsObjectValid(oTarget))
		{
			if (spellsIsTarget(oTarget, SPELL_TARGET_STANDARDHOSTILE, OBJECT_SELF))
			{
				if ( !GetIsDead(oCaster) && GetArea(oTarget) == GetArea(oCaster) )
				{
					if (!GetHasSpellEffect(SPELL_I_TENACIOUS_PLAGUE, oTarget))
					{
					DelayCommand(0.0f, ApplyEffectToObject( DURATION_TYPE_TEMPORARY, ePedes, oTarget, fDuration ));
					int i;
					for ( i = 1; i <= nDuration; i++ )
					{
						//Run Swarm function and delay the activation of each
						DelayCommand( RoundsToSeconds(i), RunSwarmAttack(oTarget, fDuration) );
					}
					//Remove a swarm
					nSwarms--;
					}
				}
			}
			//Grab the next target
			oTarget = GetNextObjectInShape( SHAPE_SPHERE, RADIUS_SIZE_LARGE, lTarget, FALSE, OBJECT_TYPE_CREATURE );
		}
		//If the target was not valid, go back to the first valid target
		else  
		{	//If no swarms have been applied we know there are no valid targets for the spell.
			if (nSwarms == nMaxSwarms )
			{
				return;
			}
			else
			{
				oTarget = GetFirstObjectInShape( SHAPE_SPHERE, RADIUS_SIZE_LARGE, lTarget );
			}
		}
	}
}

//This function deals the damage and applies the poison effect
void RunSwarmAttack( object oTarget, float fDuration )
{
	if (!GetHasSpellEffect(SPELL_I_TENACIOUS_PLAGUE, oTarget))
		return;

	int nDam;

	//effect ePoison = EffectPoison( POISON_SMALL_CENTIPEDE_POISON );
	//Apply the effects to the target.

	
	//Roll to hit target, if true then deal damage
	if (RunRollToHit( oTarget ))
	{
		//Determine and apply damage + poison, DC save against this poison is 11
		nDam = d6(2);	
		effect eHurt = EffectDamage( nDam, DAMAGE_TYPE_MAGICAL );
		ApplyEffectToObject( DURATION_TYPE_INSTANT, eHurt, oTarget );
		//ApplyEffectToObject( DURATION_TYPE_TEMPORARY, ePoison, oTarget, 30.0f);
	}

}

int RunRollToHit( object oTarget )
{
//	PrettyDebug( "Rolling to Hit", 10.0);
	//roll against the AC of the target bab 4 + caster's charisma modifier * 2
	object	oCaster	=	OBJECT_SELF;
	int		nABonus	=	2 * (GetAbilityModifier(ABILITY_CHARISMA, oCaster));
	int nTargetAC = GetAC( oTarget );
	int nRoll = d20(1);

	if (nRoll == 20)
		return TRUE;
	if (nRoll == 1)
		return FALSE;

	nRoll = nRoll + 4 + nABonus;
	
	if (nRoll >= nTargetAC)
	{
		return TRUE;
	}
	return FALSE;
}



/*
//:://////////////////////////////////////////////////////////////////////////
//:: Warlock Greater Invocation: Tenacious Plague
//:: nw_s0_itenplage.nss
//:: Created By: Brock Heinz - OEI
//:: Created On: 08/30/05
//:: Copyright (c) 2005 Obsidian Entertainment Inc.
//:://////////////////////////////////////////////////////////////////////////
/*
        Tenacious Plague [B]
        Complete Arcane, pg. 135
        Spell Level:	6
        Class: 			Misc

        This invocation functions similar to the creeping doom spell (7th level 
        druid). But the progression of damage works differently - 1d6 the first 
        round, 2d6 the second, 3d6 the third, etc. until the 10th round when the 
        invocation effect ends. Tenacious plagues cannot be stacked on top of 
        each other.

        [Rules Note] This spell is extremely different from the Complete Arcane 
        spell because in NWN2 we won't have swarms that can be summoned. So a 
        lesser version of the creeping doom spell is used here.


//:://////////////////////////////////////////////////////////////////////////

#include "x2_inc_spellhook" 

void main()
{

    if (!X2PreSpellCastCode())
    {
		// If code within the PreSpellCastHook (i.e. UMD) reports FALSE, do not run this spell
        return;
    }

	//SpawnScriptDebugger();

    //Declare major variables including Area of Effect Object
    effect eAOE = EffectAreaOfEffect(AOE_PER_TENACIOUS_PLAGUE);
    location lTarget = GetSpellTargetLocation();

	int nDuration = GetCasterLevel(OBJECT_SELF);
    int nMetaMagic = GetMetaMagicFeat();
    //Make sure duration does no equal 0
    if (nDuration < 1)
    {
        nDuration = 1;
    }
    //Check Extend metamagic feat.
    if (nMetaMagic == METAMAGIC_EXTEND)
    {
	   nDuration = nDuration *2;	//Duration is +100%
    }


    //Create an instance of the AOE Object using the Apply Effect function
    ApplyEffectAtLocation(DURATION_TYPE_TEMPORARY, eAOE, lTarget, RoundsToSeconds(nDuration));
}
*/