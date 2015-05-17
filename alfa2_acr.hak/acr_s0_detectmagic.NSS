// Detect Magic

#include "NW_I0_SPELLS"
#include "x2_inc_spellhook"
#include "acr_spells_i"

void main() {
	// If code within the PreSpellCastHook (i.e. UMD) reports FALSE, do not run this spell
	if ( !ACR_PrecastEvent() ) {
		return;
	}
	
	// Get casting data.
	object oCaster = OBJECT_SELF;
	int nMetaMagic = GetMetaMagicFeat();
	float fDur = TurnsToSeconds( GetCasterLevel( oCaster ) );
	if ( nMetaMagic == METAMAGIC_EXTEND ) {
		fDur = fDur * 2;
	} else if ( nMetaMagic == METAMAGIC_PERSISTENT ) {
		fDur = HoursToSeconds( 24 );
	}
	
	// Signal an event to everything in the AoE.
	object oTarget = GetFirstObjectInShape( SHAPE_SPELLCONE, 10.0, GetSpellTargetLocation(), TRUE, OBJECT_TYPE_ALL );
	while ( GetIsObjectValid( oTarget ) ) {
		SignalEvent( GetSpellTargetObject(), EventSpellCastAt( OBJECT_SELF, GetSpellId(), FALSE ) );
		
		oTarget = GetNextObjectInShape( SHAPE_SPELLCONE, 10.0, GetSpellTargetLocation(), TRUE, OBJECT_TYPE_ALL );
	}
}
