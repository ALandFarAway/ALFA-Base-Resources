#include "acr_i"
#include "acr_spells_i"

void main() {
	// Basic casting data.
	object oCaster = OBJECT_SELF;
	object oTarget = GetSpellTargetObject();
	int nCasterLevel = ACR_GetCorrectCasterLevel( oCaster );
	float fDuration = ACR_GetSpellDuration( oCaster, ACR_DURATION_TYPE_PER_CL, ACR_DURATION_1M );
	
	// If code within the PreSpellCastHook (i.e. UMD) reports FALSE, do not run this spell.
	if ( !ACR_PrecastEvent() ) return;
	
	// Determine bonus.
	int nBonus = 10;
	if ( nCasterLevel >= 5 ) nBonus = 20;
	if ( nCasterLevel >= 9 ) nBonus = 30;
	
	// Apply bonus.
	effect eVFX = EffectVisualEffect( VFX_DUR_SPELL_HEROISM );
	effect eBonus = EffectSkillIncrease( SKILL_JUMP, nBonus );
	effect eLink = EffectLinkEffects( eVFX, eBonus );
	ApplyEffectToObject( DURATION_TYPE_TEMPORARY, eLink, oTarget, fDuration );
	
	// Signal event.
	SignalEvent( oTarget, EventSpellCastAt( oCaster, GetSpellId(), FALSE ) );
}