// gb_comp_spell.nss
/*
	Companion OnSpellCastAt handler
	
	Based off Henchmen On Spell Cast At (NW_CH_ACB)
*/
// ChazM 12/5/05
// ChazM 5/18/05 don't react if spell cast by someone else in the same party.  reference to master now uses GetCurrentMaster() - returns master for associate or companion
// BMA-OEI 7/08/06 -- Rewrote to preserve action queue
// BMA-OEI 7/14/06 -- Follow mode interruptible
// BMA-OEI 7/17/06 -- Removed STAND_GROUND check
// DBR - 08/03/06 added support for NW_ASC_MODE_PUPPET
// BMA-OEI 09/20/06 -- AOEBEHAVIOR: Disable spell casting while Polymorphed, Removed ActionForceMove
// ChazM 1/18/07 - Script re-org - includes EvenFlw modifications
 
//#include "x0_i0_henchman"
//#include "X0_INC_HENAI"
//#include "x2_i0_spells"
#include "ginc_behavior"
//#include "ginc_companion"

void main()
{
	object oCaster 		= GetLastSpellCaster();
	int nSpellID 		= GetLastSpell();

	// if dying (but not dead), any healing will help me recover
	if ( GetIsHenchmanDying() 
		&& GetIsHealingRelatedSpell(nSpellID))
	{
		SetLocalInt( OBJECT_SELF, "X0_L_WAS_HEALED", 10 );
		WrapCommandable( TRUE, OBJECT_SELF );
		DoRespawn( oCaster, OBJECT_SELF );
	}

	// deal with a spell attack
	if ( GetLastSpellHarmful() )
	{
		ReactToHarmfulSpell(oCaster, nSpellID, TRUE, TRUE); // companions are player interruptible and use henchman AI
	}
	
	if (GetSpawnInCondition(NW_FLAG_SPELL_CAST_AT_EVENT) == TRUE )
	{
		SignalEvent( OBJECT_SELF, EventUserDefined(EVENT_SPELL_CAST_AT) );
	}		        

}