//::///////////////////////////////////////////////
//:: Battletide
//:: X2_S0_BattTide
//:: Copyright (c) 2001 Bioware Corp.
//:://////////////////////////////////////////////
/*
    You create an aura that steals energy from your
    enemies. Your enemies suffer a -2 circumstance
    penalty on saves, attack rolls, and damage rolls,
    once entering the aura. On casting, you gain a
    +2 circumstance bonus to your saves, attack rolls,
    and damage rolls.
*/
//:://////////////////////////////////////////////
//:: Created By: Andrew Nobbs
//:: Created On: Dec 04, 2002
//:://////////////////////////////////////////////
/*
    Revisions:
    Brock Heinz - OEI - 08/12/05
    modified to give an extra attack to the
    caster, similar to the Haste spell
*/


#include "NW_I0_SPELLS"
#include "x2_i0_spells"

#include "x2_inc_spellhook"

void main() {

    /*
      Spellcast Hook Code
      Added 2003-07-07 by Georg Zoeller
      If you want to make changes to all spells,
      check x2_inc_spellhook.nss to find out more

    */

    if ( !ACR_PrecastEvent() ) {
        // If code within the PreSpellCastHook (i.e. UMD) reports FALSE, do not run this spell
        return;
    }

    // End of Spell Cast Hook

    //DebugPostString( OBJECT_SELF, "x2_so_batttide main()", 100, 100, 1.0 );

    // Create the Effects
    effect eAOE = EffectAreaOfEffect( AOE_MOB_TIDE_OF_BATTLE );
    effect eHaste = EffectHaste();
    //effect eImpact = EffectVisualEffect(VFX_HIT_AOE_TRANSMUTATION);   // NWN1 VFX


    int nDuration = GetCasterLevel( OBJECT_SELF );
    //Make nDuration at least 1 round.
    if ( nDuration < 1 ) {
        nDuration = 1;
    }
    int nMetaMagic = GetMetaMagicFeat();
    //Make metamagic check for extend
    if ( nMetaMagic == METAMAGIC_EXTEND ) {
        nDuration = nDuration * 2;  //Duration is +100%
    }

    // Apply the haste effect
    //ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eHaste, OBJECT_SELF, RoundsToSeconds(nDuration));
    effect eLink = CreateGoodTideEffectsLink();
    eLink = EffectLinkEffects( eLink, eHaste );
    eAOE = EffectLinkEffects( eAOE, eLink );

    // remove any previous effects of this spell
    RemoveEffectsFromSpell( OBJECT_SELF, SPELL_BATTLETIDE );
    RemoveEffectsFromSpell( OBJECT_SELF, 963 );

    //Create the AOE object at the selected location
    DelayCommand( 0.01, ApplyEffectToObject( DURATION_TYPE_TEMPORARY, eAOE, OBJECT_SELF, RoundsToSeconds( nDuration ) ) );
    //ApplyEffectToObject(DURATION_TYPE_INSTANT, eImpact, OBJECT_SELF); // NWN1 VFX


}
