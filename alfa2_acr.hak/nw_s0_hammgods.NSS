#include "acr_effects_i"
#include "x2_inc_spellhook"
#include "acr_spells_i"


// Spell IDs we care about.
const int SPELL_CHAOS_HAMMER  = 3153;
const int SPELL_ORDERS_WRATH  = 3154;
const int SPELL_HOLY_SMITE    = 3155;
const int SPELL_UNHOLY_BLIGHT = 3156;


void main() {
	// ACR pre-cast event hook.
    if ( !ACR_PrecastEvent() ) return;
	
	// Spellcasting data.
	object oCaster = OBJECT_SELF;
	int nSpell = GetSpellId();
	int nCasterLevel = ACR_GetCorrectCasterLevel( oCaster ) / 2;
	int nSaveDC = GetSpellSaveDC();
	
	// Find the secondary effect.
	effect eSecondary;
	float fSecondaryDuration = RoundsToSeconds( 1 );
	switch ( nSpell ) {
		case SPELL_HOLY_SMITE:
			eSecondary = EffectBlindness();
			break;
		case SPELL_UNHOLY_BLIGHT:
			eSecondary = EffectSickened();
			fSecondaryDuration = RoundsToSeconds( d4(1) );
			break;
		case SPELL_ORDERS_WRATH:
			eSecondary = EffectDazed();
			break;
		case SPELL_CHAOS_HAMMER:
			eSecondary = EffectSlow();
			fSecondaryDuration = RoundsToSeconds( d6(1) );
			break;
		default:
			eSecondary = EffectBlindness();
			break;
	}
	
	// Roll for damage on normal targets.
	int nDamageNormal = ( nCasterLevel < 10 ) ? d8( nCasterLevel / 2 ) : d8( 5 );
	int nDamageOutsiders = ( nCasterLevel < 10 ) ? d6( nCasterLevel ) : d6( 10 );
	
	// Account for metamagic.
	int nMetaMagic = GetMetaMagicFeat();
	if ( nMetaMagic == METAMAGIC_MAXIMIZE ) {
		nDamageNormal = ( nCasterLevel < 5 ) ? 8 * nCasterLevel : 8 * 5;
		nDamageOutsiders = ( nCasterLevel < 10 ) ? 6 * nCasterLevel : 6 * 10;
	} else if ( nMetaMagic == METAMAGIC_EMPOWER ) {
		nDamageNormal = FloatToInt( nDamageNormal * 1.5 );
		nDamageOutsiders = FloatToInt( nDamageOutsiders * 1.5 );
	}
	
	// Grab everyone in the target area.
	object oTarget = GetFirstObjectInShape( SHAPE_SPHERE, RADIUS_SIZE_HUGE, GetSpellTargetLocation() );
	while ( GetIsObjectValid( oTarget ) ) {
		// Signal spellcasting event.
		SignalEvent( oTarget, EventSpellCastAt( oCaster, nSpell ) );
		
		// We ignore certain alignments entirely.
		int nGoodEvil = GetAlignmentGoodEvil( oTarget );
		int nLawChaos = GetAlignmentLawChaos( oTarget );
		if ( ( nSpell == SPELL_HOLY_SMITE && nGoodEvil != ALIGNMENT_GOOD ) ||
		     ( nSpell == SPELL_UNHOLY_BLIGHT && nGoodEvil != ALIGNMENT_EVIL ) ||
			 ( nSpell == SPELL_ORDERS_WRATH && nLawChaos != ALIGNMENT_LAWFUL ) ||
			 ( nSpell == SPELL_CHAOS_HAMMER && nLawChaos != ALIGNMENT_CHAOTIC ) ) {
			// Check for Spell Resistance.
			if ( !MyResistSpell( oCaster, oTarget ) ) {
				// Determine what damage we're doing.
				int nDamage = nDamageNormal;
				int bSecondaryEffect = TRUE;
				if ( GetRacialType( oTarget ) == RACIAL_TYPE_OUTSIDER ||
				     GetRacialType( oTarget ) == RACIAL_TYPE_PLANETOUCHED ) 
				{
				     nDamage = nDamageOutsiders;
				}
				
				// If we're neutral, we take half damage.
				if ( ( nSpell == SPELL_HOLY_SMITE && nGoodEvil == ALIGNMENT_NEUTRAL ) ||
					 ( nSpell == SPELL_UNHOLY_BLIGHT && nGoodEvil == ALIGNMENT_NEUTRAL ) ||
					 ( nSpell == SPELL_ORDERS_WRATH && nLawChaos == ALIGNMENT_NEUTRAL ) ||
					 ( nSpell == SPELL_CHAOS_HAMMER && nLawChaos == ALIGNMENT_NEUTRAL ) ) {
					nDamage = nDamage / 2;
					bSecondaryEffect = FALSE;
				}
				
				// A saving throw means half damage and no secondary effect.
				if ( MySavingThrow( SAVING_THROW_WILL, oTarget, nSaveDC, SAVING_THROW_TYPE_DIVINE, OBJECT_SELF, 0.5 ) ) {
					nDamage = nDamage / 2;
				} else {
					if ( bSecondaryEffect ) ApplyEffectToObject( DURATION_TYPE_TEMPORARY, eSecondary, oTarget, fSecondaryDuration );
				}
				
				// Deal damage.
				ApplyEffectToObject( DURATION_TYPE_INSTANT, EffectDamage( nDamage ), oTarget );
			}
		}
		
		// Fetch our next target.
		oTarget = GetNextObjectInShape( SHAPE_SPHERE, RADIUS_SIZE_HUGE, GetSpellTargetLocation() );
	}
	
	// ACR post-cast event hook.
	ACR_PostcastEvent();
}
