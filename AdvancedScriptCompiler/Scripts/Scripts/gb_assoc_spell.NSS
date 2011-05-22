// gb_assoc_spell
/*
    Associate On Spell Cast At
    
    This determines if the spell just cast at the
    target is harmful or not.
*/ 
// ChazM 2/15/07

//#include "X0_INC_HENAI"
//#include "x2_i0_spells"
#include "ginc_behavior"

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
    	
    if(GetLastSpellHarmful())
    {
		ReactToHarmfulSpell(oCaster, nSpellID, FALSE, TRUE); // Henchmen aren't player interruptible, they use henchman AI
    }

	if (GetSpawnInCondition(NW_FLAG_SPELL_CAST_AT_EVENT) == TRUE )
	{
		SignalEvent( OBJECT_SELF, EventUserDefined(EVENT_SPELL_CAST_AT) );
	}		    	
}