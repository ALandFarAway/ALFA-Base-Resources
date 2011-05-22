//::///////////////////////////////////////////////////////////////////////////
//::
//::	nw_s2_impreact.nss
//::
//::	    Gives the targeted creature one extra partial
//::	    action per round.
//::
//::///////////////////////////////////////////////////////////////////////////
//::
//::	Created by: Brian Fox
//::	Created on: 7/9/06
//::
//::///////////////////////////////////////////////////////////////////////////

#include "nwn2_inc_spells"
#include "x0_i0_spells"
#include "x2_inc_spellhook"
#include "ginc_henchman"

void main()
{

/*
  Spellcast Hook Code
  Added 2003-06-20 by Georg
  If you want to make changes to all spells,
  check x2_inc_spellhook.nss to find out more
*/

    if (!X2PreSpellCastCode())
    {
    // If code within the PreSpellCastHook (i.e. UMD) reports FALSE, do not run this spell
        return;
    }

// End of Spell Cast Hook

    if (GetHasSpellEffect(SPELL_EXPEDITIOUS_RETREAT, OBJECT_SELF) == TRUE)
    {
        RemoveSpellEffects(SPELL_EXPEDITIOUS_RETREAT, OBJECT_SELF, OBJECT_SELF);
    }

    if (GetHasSpellEffect(SPELL_HASTE, OBJECT_SELF) == TRUE)
    {
        RemoveSpellEffects(SPELL_HASTE, OBJECT_SELF, OBJECT_SELF);
    }

    if (GetHasSpellEffect(SPELL_MASS_HASTE, OBJECT_SELF) == TRUE)
    {
        RemoveSpellEffects(SPELL_MASS_HASTE, OBJECT_SELF, OBJECT_SELF);
    }

    int nCasterLvl = GetLevelByClass( CLASS_TYPE_DUELIST );
    float fDuration = RoundsToSeconds(nCasterLvl);

    //Fire cast spell at event for the specified target
    SignalEvent(OBJECT_SELF, EventSpellCastAt(OBJECT_SELF, SPELLABILITY_IMPROVED_REACTION, FALSE));

    // Create the Effects
    effect eHaste = EffectHaste();
    effect eDur = EffectVisualEffect( VFX_DUR_SPELL_HASTE );
    effect eLink = EffectLinkEffects(eHaste, eDur);

    // Apply effects to the currently selected target.
    ApplyEffectToObject( DURATION_TYPE_TEMPORARY, eLink, OBJECT_SELF, fDuration );
}