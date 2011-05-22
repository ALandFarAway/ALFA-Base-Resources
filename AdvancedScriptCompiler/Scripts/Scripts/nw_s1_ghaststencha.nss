//::///////////////////////////////////////////////
//:: Ghast Stench On Enter
//:: NW_S1_ghaststencha.nss
//:: Copyright (c) 2006 Obsidian Entertainment
//:://////////////////////////////////////////////
/*
    The stink of death and corruption surrounding 
    these creatures is overwhelming. Living creatures 
    within 10 feet must succeed on a DC 15 Fortitude 
    save or be sickened for 1d6+4 minutes. A creature 
    that successfully saves cannot be affected again 
    by the same ghasts stench for 24 hours. A delay 
    poison or neutralize poison spell removes the effect 
    from a sickened creature. Creatures with immunity 
    to poison are unaffected, and creatures resistant 
    to poison receive their normal bonus on their 
    saving throws. The save DC is Charisma-based.
	
*/
//:://////////////////////////////////////////////
//:: Created By: Patrick Mills
//:: Created On: July 24, 2006
//:://////////////////////////////////////////////
#include "NW_I0_SPELLS"

void main()
{
    //Declare major variables
    object oTarget = GetEnteringObject();
    effect eCon= EffectAbilityDecrease( ABILITY_CONSTITUTION, 4 );
    effect eStr= EffectAbilityDecrease( ABILITY_STRENGTH, 4 );
    effect eDex= EffectAbilityDecrease( ABILITY_DEXTERITY, 4 );
    effect eDur = EffectVisualEffect( VFX_DUR_SICKENED );
    effect eSick1 = EffectLinkEffects( eCon, eStr );
    effect eSick2 = EffectLinkEffects( eSick1, eDex );
    effect eLink = EffectLinkEffects( eSick2, eDur );  
  
    
    if(!GetHasSpellEffect(SPELLABILITY_GHAST_STENCH, oTarget))
    {     
        if(GetIsEnemy(oTarget, GetAreaOfEffectCreator()))
            {
                //Fire cast spell at event for the specified target
                SignalEvent(oTarget, EventSpellCastAt( OBJECT_SELF, SPELLABILITY_GHAST_STENCH ));
                //Make a saving throw check
                if(!MySavingThrow(SAVING_THROW_FORT, oTarget, 15, SAVING_THROW_TYPE_POISON))
                {
                    if (!GetIsImmune(oTarget, IMMUNITY_TYPE_POISON))
                    {
                    int nDuration = (d4() + 1);
                    //Apply the VFX impact and effects for Sickness
                    ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eLink, oTarget, RoundsToSeconds( nDuration ));
                    }
                }
                
            }
        
    }
}