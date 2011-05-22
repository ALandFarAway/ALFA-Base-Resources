//:://///////////////////////////////////////////////
//:: Pilfer Magic
//:: nw_s0_pilfermagic.nss
//:: Copyright (c) 2006 Obsidian Entertainment Inc.
//::////////////////////////////////////////////////
//:: Created By: Andrew Woo (AFW-OEI)
//:: Created On: 08/07/2006
//::////////////////////////////////////////////////
/*
	Copied mostly from nw_s0_idevmagic, the Warlock
	Devour Magic spell.
	
	This Arcane Trickster spell-like ability does
	a single-target dispel effect that only strips
	one effect.  If successful, it grants the caster
	+2 attack bonus and +2 to all saves for 10 rounds. 
*/

#include "x0_i0_spells"
#include "x2_inc_spellhook"
#include "nwn2_inc_spells"



void main()
{

    //--------------------------------------------------------------------------
    /*
      Spellcast Hook Code
      Added 2003-06-20 by Georg
      If you want to make changes to all spells,
      check x2_inc_spellhook.nss to find out more
    */
    //--------------------------------------------------------------------------
    if (!X2PreSpellCastCode())
    {
        return;
    }
    // End of Spell Cast Hook


	object 	  oCaster	   = OBJECT_SELF;
    object    oTarget      = GetSpellTargetObject();
    int       nCasterLevel = GetCasterLevel(oCaster);
    effect    eVis         = EffectVisualEffect(VFX_HIT_SPELL_ABJURATION);
    effect    eImpact; // vfx now handled by spells.2da (ImpactSEF column), but this effect required for
						// DispelMagic* function
	int 	  nSpellID     = GetSpellId();
	
    if ( GetIsObjectValid(oTarget) )
    {
        //----------------------------------------------------------------------
        // Targeted Dispel - but only Dispel Best
        //----------------------------------------------------------------------
         DispelMagicWithCallback(oTarget, oCaster, nCasterLevel, eVis, eImpact, FALSE, nSpellID );
         
    }
}