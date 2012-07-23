//:://///////////////////////////////////////////////
//:: Warlock Greater Invocation: Devour Magic
//:: nw_s0_idevmagic.nss
//:: Copyright (c) 2005 Obsidian Entertainment Inc.
//::////////////////////////////////////////////////
//:: Created By: Brock Heinz
//:: Created On: 08/12/05
//::////////////////////////////////////////////////
/*
	Devour Magic
	Complete Arcane, pg. 133
	Spell Level:	6
	Class: 		Misc
	
	This invocation functions as a greater dispel
	magic spell (6th level wizard). If a spell 
	effect is successfully removed, then the 
	warlock gains twice their warlock level in 
	temporary hit points (which add to their 
	maximum hit points just like the 2nd 
	level cleric spell aid). These temporary hit 
	points fade after 1 minute. 
	
	[Rules Note] In the rules the warlock gains 5 
	temporary hit points per spell level dispelled, 
	this isn't possible because the spell level 
	in the NWN2 engine isn't stored on a 
	spell effect. So this clean rule mimics that 
	effect.

*/
//: RPGplayer1 04/09/2008: Added gaining temporary HP from dispelling AoE

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
    if (!ACR_PrecastEvent())
    {
        return;
    }
    // End of Spell Cast Hook


	object 	  oCaster	   = OBJECT_SELF;
    object    oTarget      = GetSpellTargetObject();
    location  lLocal       = GetSpellTargetLocation();
    int       nCasterLevel = GetCasterLevel(oCaster);
    effect    eVis         = EffectVisualEffect(VFX_HIT_SPELL_ABJURATION);
    effect    eImpact; // vfx now handled by spells.2da (ImpactSEF column), but this effect required for
						// DispelMagic* function
	int 	  nSpellID     = GetSpellId();
	
    //--------------------------------------------------------------------------
    // Greater Dispel Magic is capped at caster level 15
    //--------------------------------------------------------------------------
    if(nCasterLevel > 15)
    {
        nCasterLevel = 15;
    }

    if ( GetIsObjectValid(oTarget) )
    {
        //----------------------------------------------------------------------
        // Targeted Dispel - Dispel all
        //----------------------------------------------------------------------
         DispelMagicWithCallback(oTarget, oCaster, nCasterLevel, eVis, eImpact, TRUE, nSpellID );
         
    }
    // No AoE allowed. Abort.

}