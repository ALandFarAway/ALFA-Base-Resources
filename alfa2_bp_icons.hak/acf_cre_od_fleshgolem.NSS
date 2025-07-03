////////////////////////////////////////////////////////////////////////////////
//
//  System Name : ACR Configuration File
//     Filename : acf_cre_od_fleshgolem
//
//  Description
//  This script is called whenever a Flesh Golem is damaged. If the damage is
//  fire or ice, we slow down. If it is electrical, remove any slowdown.
//
////////////////////////////////////////////////////////////////////////////////

////////////////////////////////////////////////////////////////////////////////
// Includes ////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////

#include "acr_creature_i"

////////////////////////////////////////////////////////////////////////////////
// Constants ///////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////

const string LVAR_LAST_HEALTH = "golem_last_health";

////////////////////////////////////////////////////////////////////////////////
// Structures //////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////

////////////////////////////////////////////////////////////////////////////////
// Global Variables ////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////

////////////////////////////////////////////////////////////////////////////////
// Function Prototypes /////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////

////////////////////////////////////////////////////////////////////////////////
// Function Definitions ////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////

void main() {
    ACR_CreatureOnDamaged();
	
	// Get our creatures.
	object oDamager = GetLastDamager();
	object oGolem = OBJECT_SELF;
	
    // If it's set to go hostile on attack, do so.
	if ( GetLocalInt( oGolem, "ACR_MAKE_HOSTILE" ) ) {
		ChangeToStandardFaction(oGolem,STANDARD_FACTION_HOSTILE);
	}
	
	// A magical attack that deals cold or fire damage slows a flesh golem (as
	// the slowspell) for 2d6 rounds, with no saving throw.
	int nColdDamage = GetDamageDealtByType( DAMAGE_TYPE_COLD );
	int nFireDamage = GetDamageDealtByType( DAMAGE_TYPE_FIRE );
	if ( nColdDamage > 0 || nFireDamage > 0 ) {
		int nRounds = Random(6)+1 + Random(6)+1; 
		effect eSlow = EffectLinkEffects( EffectSlow(), EffectVisualEffect( VFX_DUR_SPELL_SLOW ) );
		ApplyEffectToObject( DURATION_TYPE_TEMPORARY, eSlow, oGolem, RoundsToSeconds( nRounds ) );
		FloatingTextStringOnCreature( "*The construct slows.*", oGolem, FALSE );
	}
	
	// A magical attack that deals electricity damage breaks any slow effect on
	// the golem and heals 1 point of damage for every 3 points of damage the
	// attack would otherwise deal. If the amount of heal-ing would cause the
	// golem to exceed its full normal hit points, it gains any excess as
	// temporary hit points.
	int nElectricDamage = GetDamageDealtByType( DAMAGE_TYPE_ELECTRICAL );
	if ( nElectricDamage > 0 ) {
		// How much we're healing based on the electrical damage.
		int nHealAmount = nElectricDamage;
		
		// Report to the damager (and those around) that the golem shrugs off electrical damage.
		SendMessageToPC( oDamager, "The creature resists " + IntToString( nElectricDamage ) + " electrical damage!" );
		FloatingTextStringOnCreature( "*Its wounds magical begin closing.*", oGolem, FALSE );
		
		// Remove any slowing if it has any.
		ApplyEffectToObject( DURATION_TYPE_INSTANT, EffectVisualEffect( VFX_DUR_FREEDOM_OF_MOVEMENT ), oGolem );
		RemoveEffect( oGolem, EffectSlow() );
		
		// Limit the amount healed by electrical damage by its previous health.
		int nPreviousHealth = GetLocalInt( oGolem, LVAR_LAST_HEALTH );
		if ( nHealAmount > nPreviousHealth ) {
			nHealAmount = nPreviousHealth - GetTotalDamageDealt() + nElectricDamage;
		}
		
		// We also toss on some extra healing with this damage type.
		nHealAmount += nElectricDamage / 3;
		
		// Now we finally do the healing.
		ApplyEffectToObject( DURATION_TYPE_INSTANT, EffectVisualEffect( VFX_HIT_SPELL_HEALING_STING ), oGolem );
		ApplyEffectToObject( DURATION_TYPE_INSTANT, EffectHeal( nHealAmount ), oGolem );
	}
	
	// Because we need to have this creature be Immortal for our electricity damage handling to work,
	// we now want to see if this creature should now be dead. For now we just assume that 1hp=dead.
	// To suppliment this we add 1 to the creature's maximum life.
	if ( GetCurrentHitPoints() == 1 ) {
		SetImmortal( oGolem, FALSE );
		AssignCommand( oDamager, ApplyEffectToObject( DURATION_TYPE_INSTANT, EffectDeath(), oGolem ) );
		return;
	}
	
	// Store the current health for the next script itteration.
	SetLocalInt( oGolem, LVAR_LAST_HEALTH, GetCurrentHitPoints() );
}