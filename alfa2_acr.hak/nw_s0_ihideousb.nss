//::///////////////////////////////////////////////
//:: Invocation: Hideous Blow
//:: NW_S0_IHideousB.nss
//:://////////////////////////////////////////////
/*
*/
//:://////////////////////////////////////////////
//:: Created By: Jesse Reynolds (JLR - OEI)
//:: Created On: August 26, 2005
//:://////////////////////////////////////////////
//:: AFW-OEI 07/17/2007: New Essence VFX.


// JLR - OEI 08/24/05 -- Metamagic changes
#include "nwn2_inc_spells"
#include "nw_i0_spells"

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


    //Declare major variables
    object oTarget = GetSpellTargetObject();
	int nMetaMagic = GetMetaMagicFeat();
	int nDurVFX = VFX_INVOCATION_HIDEOUS_BLOW;
    //Enter Metamagic conditions

    effect eHidBlow = EffectHideousBlow( nMetaMagic );
	
	if ( nMetaMagic & METAMAGIC_INVOC_DRAINING_BLAST )         { nDurVFX = VFX_INVOCATION_DRAINING_BLOW; }
    else if ( nMetaMagic & METAMAGIC_INVOC_FRIGHTFUL_BLAST )   { nDurVFX = VFX_INVOCATION_FRIGHTFUL_BLOW; }
    else if ( nMetaMagic & METAMAGIC_INVOC_BESHADOWED_BLAST )  { nDurVFX = VFX_INVOCATION_BESHADOWED_BLOW; }
    else if ( nMetaMagic & METAMAGIC_INVOC_BRIMSTONE_BLAST )   { nDurVFX = VFX_INVOCATION_BRIMSTONE_BLOW; }
    else if ( nMetaMagic & METAMAGIC_INVOC_HELLRIME_BLAST )    { nDurVFX = VFX_INVOCATION_HELLRIME_BLOW; }
    else if ( nMetaMagic & METAMAGIC_INVOC_BEWITCHING_BLAST )  { nDurVFX = VFX_INVOCATION_BEWITCHING_BLOW; }
    else if ( nMetaMagic & METAMAGIC_INVOC_NOXIOUS_BLAST )     { nDurVFX = VFX_INVOCATION_NOXIOUS_BLOW; }
    else if ( nMetaMagic & METAMAGIC_INVOC_VITRIOLIC_BLAST )   { nDurVFX = VFX_INVOCATION_VITRIOLIC_BLOW; }
    else if ( nMetaMagic & METAMAGIC_INVOC_UTTERDARK_BLAST )   { nDurVFX = VFX_INVOCATION_UTTERDARK_BLOW; }
	else if ( nMetaMagic & METAMAGIC_INVOC_BINDING_BLAST )     { nDurVFX = VFX_INVOCATION_BINDING_BLOW; }
	else if ( nMetaMagic & METAMAGIC_INVOC_HINDERING_BLAST )   { nDurVFX = VFX_INVOCATION_HINDERING_BLOW; }

    effect eDur = EffectVisualEffect( nDurVFX );
    effect eLink = EffectLinkEffects(eHidBlow, eDur);
	
    RemoveEffectsFromSpell(OBJECT_SELF, GetSpellId());

    //Fire cast spell at event for the specified target
    SignalEvent(OBJECT_SELF, EventSpellCastAt(OBJECT_SELF, GetSpellId(), FALSE));

    //Apply the VFX impact and effects
    ApplyEffectToObject(DURATION_TYPE_PERMANENT, eLink, OBJECT_SELF);
	ActionAttack( oTarget );
}