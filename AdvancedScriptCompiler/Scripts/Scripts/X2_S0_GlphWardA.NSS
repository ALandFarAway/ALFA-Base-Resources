//::///////////////////////////////////////////////
//:: Glyph of Warding
//:: x2_s0_glphwarda.nss
//:: Copyright (c) 2006 Obsidian Entertainment Inc.
//:://////////////////////////////////////////////
/*
    The caster creates a trapped area which detects
    the entrance of enemy creatures into 3 m area
    around the spell location.  When tripped it
    causes an explosion that does 1d8 per
    two caster levels up to a max of 5d8 damage.
	Damage type is dependent on caster alignment.
*/
//:://////////////////////////////////////////////
//:: Created By: Patrick Mills
//:: Created On: August 01, 2006
//:://////////////////////////////////////////////
//:: RPGplayer1 03/19/2008:
//::  Added SR check
//::  Added Reflex save for half damage
//::  Added Metamagic code

#include "X0_I0_SPELLS"
#include "x2_inc_spellhook"

void main()
{

    //Declare major variables
    object oTarget = GetEnteringObject();
    object oCaster = GetAreaOfEffectCreator();
    location lTarget = GetLocation(OBJECT_SELF);
    int nCasterLevel = GetCasterLevel(oCaster);
    int nAlign = GetAlignmentGoodEvil( oCaster );
	
    //Limit caster level for purposes of damage
    if (nCasterLevel > 10)
    {
        nCasterLevel = 10;
    }
    
	//VFX   
	effect eGoodVis = EffectVisualEffect( VFX_HIT_SPELL_HOLY );
	effect eEvilVis = EffectVisualEffect( VFX_HIT_SPELL_EVIL );
	effect eNeutVis = EffectVisualEffect( VFX_HIT_SPELL_SONIC );
	
	if (spellsIsTarget( oTarget, SPELL_TARGET_STANDARDHOSTILE, oCaster))
	{
	if (!MyResistSpell(oCaster, oTarget))
	{
	//Damage
	int nDam = d8(nCasterLevel /2 );
	nDam = ApplyMetamagicVariableMods(nDam, 40);
	nDam = GetReflexAdjustedDamage(nDam, oTarget, GetSpellSaveDC(), SAVING_THROW_TYPE_SPELL, oCaster);

	effect eGoodDam = EffectDamage( nDam, DAMAGE_TYPE_DIVINE );
	effect eEvilDam = EffectDamage( nDam, DAMAGE_TYPE_NEGATIVE );
	effect eNeutDam = EffectDamage( nDam, DAMAGE_TYPE_SONIC );
	
	//Link VFX to Damage
	effect eGoodLink = EffectLinkEffects( eGoodVis, eGoodDam );
	effect eEvilLink = EffectLinkEffects( eEvilVis, eEvilDam );
	effect eNeutLink = EffectLinkEffects( eNeutVis, eNeutDam );
	
		if ( nAlign == ALIGNMENT_GOOD)
		{
			ApplyEffectToObject( DURATION_TYPE_INSTANT, eGoodLink, oTarget );
		}
		
		else if ( nAlign == ALIGNMENT_EVIL )
		{
			ApplyEffectToObject( DURATION_TYPE_INSTANT, eEvilLink, oTarget );
		}
		
		else
		{
			ApplyEffectToObject( DURATION_TYPE_INSTANT, eNeutLink, oTarget );
		}
	} //still fires off glyph for resisted targets
		DestroyObject( OBJECT_SELF, 0.3 );
	}
}
//This is the old script, for posterity.
/*
//::///////////////////////////////////////////////
//:: Glyph of Warding: On Enter
//:: X2_S0_GlphWardA
//:: Copyright (c) 2001 Bioware Corp.
//:://////////////////////////////////////////////

    This script creates a Glyph of Warding Placeable
    object.

    Check x2_o0_hhb.nss and the Glyph of Warding
    placeable object for details

//:://////////////////////////////////////////////
//:: Created By: Georg Zoeller
//:: Created On: 2003-09-02
//:://////////////////////////////////////////////


#include "NW_I0_SPELLS"
#include "x0_i0_spells"
#include "x2_inc_spellhook"

void main()
{
    object oTarget  = GetEnteringObject();
    object oPLC     = GetAreaOfEffectCreator(OBJECT_SELF);
    object oCreator = GetLocalObject(oPLC,"X2_PLC_GLYPH_CASTER") ;

    if ( GetLocalInt (oPLC,"X2_PLC_GLYPH_PLAYERCREATED") == 0 )
    {
        oCreator = oPLC;
    }

    if (!GetIsObjectValid(oPLC) || !GetIsObjectValid(oCreator)) // the placeable or creator is no longer there
    {
        DestroyObject(OBJECT_SELF);
        return;
    }

    if (spellsIsTarget(oTarget,SPELL_TARGET_STANDARDHOSTILE,oCreator))
    {
        SetLocalObject(oPLC,"X2_GLYPH_LAST_ENTER",oTarget );
        SignalEvent(oPLC,EventUserDefined(2000));
    }



}
*/