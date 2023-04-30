//::///////////////////////////////////////////////
//
//  System Name : Glyph of Warding
//  Filename : acr_s0_glyph_enter
//    
//  Description
//  This script handles on enter actions for the AREA OF EFFECT created by 
//	ALFA custom placeable Glyphs of Warding. Note: THIS IS NOT FOR THE SPELL
//	CAST IN GAME. This is called only by a placeable placed either in toolset
//	or by the DM ingame. This should not be on the placeable.
//	The placeable casts an Area of Effect that does have this script on it.
//	It is not updated in ACR updates.

//	Sample Glyph of Warding placeable may be found in the pallet in the
//	_ALFA_Trap_Symbol group. The glyph must be a placeable and it must be
//	tagged with "glyph_ward" as PART of the tag, but it can have any model
//	or vfx on it. The glyph must have the string ACR_CASTER_RESREF filled in
//	with the ResRef of the NPC caster that "cast" it, or it will not fire.
//	Evil, Good, and Neutral casters will cause different damage types.
//	 
//
//  Revision History
////////////////////////////////////////////////////////////////////////////////
//:: 
//:: Created By: Patrick Mills - August 01, 2006
//:: RPGplayer1 03/19/2008:
//::  Added SR check
//::  Added Reflex save for half damage
//::  Added Metamagic code
//	 Wynna - Updated for a placeable glyph - 3/17/2023

////////////////////////////////////////////////////////////////////////////////

/*
    The caster creates a trapped area which detects
    the entrance of enemy creatures into 3 m area
    around the spell location.  When tripped it
    causes an explosion that does 1d8 per
    two caster levels up to a max of 5d8 damage.
	Damage type is dependent on caster alignment.
*/
//:://////////////////////////////////////////////

#include "X0_I0_SPELLS"
#include "x2_inc_spellhook"
#include "acr_spells_i"

void main()
{

    //Declare major variables
    object oTarget = GetEnteringObject();
    string sCaster = GetLocalString(OBJECT_SELF, "ACR_CASTER_RESREF");
    location lTarget = GetLocation(OBJECT_SELF);
    effect eFreeze = EffectCutsceneImmobilize();
	effect eInvis = EffectVisualEffect(VFX_DUR_CUTSCENE_INVISIBILITY, FALSE);
	object oCaster = CreateObject(OBJECT_TYPE_CREATURE, sCaster, lTarget);
	SetFirstName(oCaster, "Glyph of");
	SetLastName(oCaster, "Warding");
	ChangeToStandardFaction(oCaster, STANDARD_FACTION_MERCHANT);
	SetStandardFactionReputation(STANDARD_FACTION_HOSTILE, 50, oCaster);
	SetStandardFactionReputation(STANDARD_FACTION_DEFENDER, 50, oCaster);
	ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eFreeze, oCaster, HoursToSeconds(100));
	ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eInvis, oCaster, HoursToSeconds(100));
	int nCasterLevel = GetLevelByClass(CLASS_TYPE_CLERIC, oCaster);
    int nAlign = GetAlignmentGoodEvil(oCaster );
	
	object oPLC = GetLocalObject(OBJECT_SELF, "ACR_GLYPH_PLC");
	DestroyObject(oCaster, 2.0);
	
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
	SendMessageToAllDMs("nDam = " + IntToString(nDam));
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
		DestroyObject( oPLC, 3.0 );
		DestroyObject( OBJECT_SELF, 3.1 );
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