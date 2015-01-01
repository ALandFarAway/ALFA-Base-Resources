//::///////////////////////////////////////////////
//:: Identify
//:: NW_S0_Identify.nss
//:: Copyright (c) 2001 Bioware Corp.
//:://////////////////////////////////////////////
/*
    Gives the caster a boost to Lore skill of +25
    plus caster level.  Lasts for 2 rounds.
*/
//:://////////////////////////////////////////////
//:: Created By: Preston Watamaniuk
//:: Created On: Oct 22, 2001
//:://////////////////////////////////////////////


#include "x2_inc_spellhook" 

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

	// End of Spell Cast Hook

    object oTarget = GetSpellTargetObject();
    effect eDur = EffectVisualEffect( VFX_DUR_SPELL_IDENTIFY );
    int nDuration = 1;
	
    ApplyEffectToObject( DURATION_TYPE_TEMPORARY, eDur, OBJECT_SELF, RoundsToSeconds(nDuration) );
    
    if ( GetObjectType( oTarget ) == OBJECT_TYPE_ITEM )
    {
        //Fire cast spell at event for the specified target
        SetIdentified( oTarget, TRUE );
    }
    SignalEvent(oTarget, EventSpellCastAt(OBJECT_SELF, SPELL_IDENTIFY, FALSE));
}