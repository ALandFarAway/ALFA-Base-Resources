//::///////////////////////////////////////////////
//:: Warpriest Battletide
//:: NW_S2_WPBattTide
//:: Copyright (c) 2006 Obsidian Entertainment, Inc.
//:://////////////////////////////////////////////
/*
    You create an aura that steals energy from your
    enemies. Your enemies suffer a -2 circumstance
    penalty on saves, attack rolls, and damage rolls,
    once entering the aura. On casting, you gain a
    +2 circumstance bonus to your saves, attack rolls,
    and damage rolls.

	Warpriest's spell-like ability; main difference
	is that is uses the Warpriest level for variable
	effects.
*/
//:://////////////////////////////////////////////
//:: Created By: Andrew Woo (AFW-OEI)
//:: Created On: 05/20/2006
//:://////////////////////////////////////////////


#include "NW_I0_SPELLS"
#include "x2_i0_spells"

#include "x2_inc_spellhook"

void main()
{

/*
  Spellcast Hook Code
  Added 2003-07-07 by Georg Zoeller
  If you want to make changes to all spells,
  check x2_inc_spellhook.nss to find out more

*/

    if (!X2PreSpellCastCode())
    {
    // If code within the PreSpellCastHook (i.e. UMD) reports FALSE, do not run this spell
        return;
    }
	
    // Create the Effects
    effect eAOE   = EffectAreaOfEffect(AOE_MOB_TIDE_OF_BATTLE);
    effect eHaste = EffectHaste();
	effect eDur = EffectVisualEffect( VFX_DUR_SPELL_HASTE );
	eHaste = EffectLinkEffects( eHaste, eDur );
	//effect eImpact = EffectVisualEffect(VFX_HIT_AOE_TRANSMUTATION);	// handled in vfx_persistent.2da

	
    int nDuration = GetLevelByClass(CLASS_TYPE_WARPRIEST);	// AFW-OEI 05/20/2006: main difference from Battletide

	// Apply the haste effect
	//ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eHaste, OBJECT_SELF, RoundsToSeconds(nDuration));
	effect eLink = CreateGoodTideEffectsLink();
	eLink = EffectLinkEffects(eLink, eHaste);
	eAOE = EffectLinkEffects(eAOE, eLink);

	// remove any previous effects of this spell
	RemoveEffectsFromSpell(OBJECT_SELF, SPELL_BATTLETIDE);
	RemoveEffectsFromSpell(OBJECT_SELF, 963);

    //Create the AOE object at the selected location
    DelayCommand(0.01, ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eAOE, OBJECT_SELF, RoundsToSeconds(nDuration)));
	//ApplyEffectToObject(DURATION_TYPE_INSTANT, eImpact, OBJECT_SELF);	// handled in vfx_persistent.2da
}