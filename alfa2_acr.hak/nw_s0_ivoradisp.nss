//:://///////////////////////////////////////////////
//:: Warlock Lesser Invocation: Voracious Dispelling
//:: nw_s0_ivoradisp.nss
//:: Copyright (c) 2005 Obsidian Entertainment Inc.
//::////////////////////////////////////////////////
//:: Created By: Brock Heinz
//:: Created On: 08/12/05
//::////////////////////////////////////////////////
/*
        5.7.2.10	Voracious Dispelling
        Complete Arcane, pg. 136
        Spell Level:	4
        Class: 			Misc

        This is the equivalent of the dispel magic spell (3rd level wizard) 
        except if any spells on a target are dispelled the target takes 1 
        point of damage per two spell levels of the caster (no save, but magic 
        resistance applies).

        [Rules Note] In the rules the damage the target takes depends on the 
        spell level of what's removed, but the way the engine works the spell 
        level data isn't stored on an effect.


*/
//: PKM-OEI 07.08.06: VFX pass, changed abjuration hit to eldritch hit
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
    location  lLocal       = GetSpellTargetLocation();
    int       nCasterLevel = GetCasterLevel(oCaster);
    //effect    eVis         = EffectVisualEffect(VFX_HIT_SPELL_ABJURATION);// Changing this to eldritch hit to remain 
																		  //consistant with the other VFX being used here
	effect    eVis         = EffectVisualEffect(VFX_INVOCATION_ELDRITCH_HIT);
	effect	  eImpact; // Impact area now handled in spells.2da (ImpactSEF column) but
						// this effect required by the DispelMagic* function
	int 	  nSpellID     = GetSpellId();
	
    //--------------------------------------------------------------------------
    // Dispel Magic is capped at caster level 10
    //--------------------------------------------------------------------------
    if(nCasterLevel > 10)
    {
        nCasterLevel = 10;
    }

    if ( GetIsObjectValid(oTarget) )
    {
        //----------------------------------------------------------------------
        // Targeted Dispel - Dispel all
        //----------------------------------------------------------------------
         DispelMagicWithCallback(oTarget, oCaster, nCasterLevel, eVis, eImpact, TRUE, nSpellID );         
    }
    else
    {
        //----------------------------------------------------------------------
        // Area of Effect - Only dispel best effect
        //----------------------------------------------------------------------

        oTarget = GetFirstObjectInShape(SHAPE_SPHERE, RADIUS_SIZE_LARGE, lLocal, FALSE, OBJECT_TYPE_CREATURE | OBJECT_TYPE_AREA_OF_EFFECT | OBJECT_TYPE_PLACEABLE );
        while (GetIsObjectValid(oTarget))
        {
            if(GetObjectType(oTarget) == OBJECT_TYPE_AREA_OF_EFFECT)
            {
                //--------------------------------------------------------------
                // Handle Area of Effects
                //--------------------------------------------------------------
                spellsDispelAoE(oTarget, OBJECT_SELF, nCasterLevel);
            }
            else if (GetObjectType(oTarget) == OBJECT_TYPE_PLACEABLE)
            {
                SignalEvent( oTarget, EventSpellCastAt(oCaster, SPELL_I_VORACIOUS_DISPELLING) );
            }
            else
            {
                DelayCommand( GetRandomDelay(0.1, 0.3), DispelMagicWithCallback(oTarget, oCaster, nCasterLevel, eVis, eImpact, FALSE, nSpellID ) );
            }

           oTarget = GetNextObjectInShape(SHAPE_SPHERE, RADIUS_SIZE_LARGE,lLocal, FALSE, OBJECT_TYPE_CREATURE | OBJECT_TYPE_AREA_OF_EFFECT | OBJECT_TYPE_PLACEABLE);
        }
    }

}