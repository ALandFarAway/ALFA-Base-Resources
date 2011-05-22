//::///////////////////////////////////////////////
//:: Creeping Doom
//:: NW_S0_CrpDoom
//:: Copyright (c) 2006 Obsidian Entertainment Inc.
//:://////////////////////////////////////////////
/*
	The druid summons masses of centipedes and biting
	insects, one per two caster levels, that attack targets 
	at random within the effected area.
	
	Swarms have a BAB of +6 and must roll to hit the target
	normally.  They do 2d6 points of damage in addition
	to poisoning the target.  Swarms persist for three rounds 
	before dissipating.
	
	The swarms, when summoned, will iterate between targets
	in the defined shape, attaching themselves as a DoT
	to each target in turn. 
*/
//:://////////////////////////////////////////////
//:: Created By: Patrick Mills
//:: Created On:  August, 15 2006
//:://////////////////////////////////////////////
//pkm oei 10.20.06 - AB +6 was way too low for mid-late game.  Changed rules.
//pkm oei 10.20.06 - Now using the metamagicmod functions

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
	
	// Stacking of this spell is allowed
//	int nID = GetSpellId();
//	if ( GetHasSpellEffect(nID) )
//	{
//		effect eEffect = GetFirstEffect( OBJECT_SELF );
//		while ( GetIsEffectValid(eEffect) )
//		{
//			if ( GetEffectSpellId(eEffect) == nID )
//			{
//				RemoveEffect( OBJECT_SELF, eEffect );
//			}
//			
//			eEffect = GetNextEffect( OBJECT_SELF );
//		}
//	}
	
	//Declare major variables
	location lTarget = GetSpellTargetLocation();
	object oCaster = OBJECT_SELF; 
	int nCasterLvl = GetCasterLevel( oCaster );
	int nSwarms = ( nCasterLvl / 2 );
	int	nDuration	=	3;
	float fDuration = RoundsToSeconds(nDuration);
	effect ePedes = EffectVisualEffect( VFX_DUR_SPELL_CREEPING_DOOM );

	
	//Meta-magic fun
	fDuration = ApplyMetamagicDurationMods(fDuration);
	nDuration	=	FloatToInt(fDuration/6);
	
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
					ApplyEffectToObject( DURATION_TYPE_TEMPORARY, ePedes, oTarget, fDuration );
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
	if (!GetHasSpellEffect(SPELL_CREEPING_DOOM, oTarget))
		return;

	int nDam;
	effect ePoison = EffectPoison( POISON_SMALL_CENTIPEDE_POISON );
	
	//Roll to hit target, if true then deal damage
	if (RunRollToHit( oTarget ))
	{
		//Determine and apply damage + poison, DC save against this poison is 11
		nDam = d6(2);
		effect eHurt = EffectDamage( nDam, DAMAGE_TYPE_PIERCING );
		ApplyEffectToObject( DURATION_TYPE_INSTANT, eHurt, oTarget );
		ApplyEffectToObject( DURATION_TYPE_TEMPORARY, ePoison, oTarget, 30.0f);
	}

}

int RunRollToHit( object oTarget )
{
	//roll against the AC of the target bab +6 + caster's wisdom modifier * 2
	object	oCaster	=	OBJECT_SELF;
	int nTargetAC = GetAC( oTarget );
	int	nABonus	=	2 * (GetAbilityModifier(ABILITY_WISDOM, oCaster));
	int nRoll = d20(1);

	if (nRoll == 20)
		return TRUE;
	if (nRoll == 1)
		return FALSE;

	nRoll = nRoll + 6 + nABonus;
	
	if (nRoll >= nTargetAC)
	{
		return TRUE;
	}
	return FALSE;
}
	
	
	
	
	
	



//Old spell code
/*
//::///////////////////////////////////////////////
//:: Creeping Doom
//:: NW_S0_CrpDoom
//:: Copyright (c) 2001 Bioware Corp.
//:://////////////////////////////////////////////
/*
    The druid calls forth a mass of churning insects
    and scorpians that bite and sting all those within
    a 20ft square.  The total spell effects does
    1000 damage to all withiin the area of effect
    until all damage is dealt.

//:://////////////////////////////////////////////
//:: Created By: Preston Watamaniuk
//:: Created On:  , 2001
//:://////////////////////////////////////////////
//Needed would require an entry into the VFX_Persistant.2DA and a new AOE constant

#include "x2_inc_spellhook" 

void main()
{

/* 
  Spellcast Hook Code 
  Added 2003-06-20 by Georg
  If you want to make changes to all spells,
  check x2_inc_spellhook.nss to find out more
  
    if (!X2PreSpellCastCode())
    {
	// If code within the PreSpellCastHook (i.e. UMD) reports FALSE, do not run this spell
        return;
    }

// End of Spell Cast Hook


    //Declare major variables including Area of Effect Object
    effect eAOE = EffectAreaOfEffect(AOE_PER_CREEPING_DOOM);
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