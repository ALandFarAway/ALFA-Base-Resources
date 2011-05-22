//::///////////////////////////////////////////////
//:: Gate
//:: NW_S0_Gate.nss
//:: Copyright (c) 2001 Bioware Corp.
//:://////////////////////////////////////////////
//:: Summons a Balor to fight for the caster.
//:://////////////////////////////////////////////
//:: Created By: Preston Watamaniuk
//:: Created On: April 12, 2001
//:://////////////////////////////////////////////
//:: AFW-OEI 05/31/2006:
//::	Update creature blueprint (to Horned Devil).
//:: BDF-OEI 8/02/2006:
//::	Renamed CreateBalor to CreateOutsider and added a DCR to kickstart attack on the summoner
//:: EPF 8/20/07
//::	Removed check for protection from evil - the requirement is not actually part of 3.5E rules, and can cause problems
//:: 	if the summoned creature attacks non-plot NPCs,which it will do if they are Defender or Merchant.

void CreateOutsider();
#include "x2_inc_spellhook" 
#include "nw_i0_generic"

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


    //Declare major variables
    int nMetaMagic = GetMetaMagicFeat();
    int nCasterLevel = GetCasterLevel(OBJECT_SELF);
    int nDuration = GetCasterLevel(OBJECT_SELF) + 3;
    effect eSummon;
    effect eVis = EffectVisualEffect( VFX_DUR_GATE );
	effect eVis2 = EffectVisualEffect( VFX_INVOCATION_BRIMSTONE_DOOM );
    //Make metamagic extend check
    if (nMetaMagic == METAMAGIC_EXTEND)
    {
        nDuration = nDuration *2;	//Duration is +100%
    }
    location lSpellTargetLOC = GetSpellTargetLocation();

    eSummon = EffectSummonCreature( "c_summ_devilhorn", VFX_INVOCATION_BRIMSTONE_DOOM,  3.0 );
    float fSeconds = RoundsToSeconds(nDuration);
    DelayCommand(3.0, ApplyEffectAtLocation(DURATION_TYPE_TEMPORARY, eSummon, lSpellTargetLOC, fSeconds));
	ApplyEffectAtLocation ( DURATION_TYPE_TEMPORARY, eVis, lSpellTargetLOC, 5.0);
}

void CreateOutsider()
{
	object oCaster = OBJECT_SELF;
	object oOutsider = CreateObject(OBJECT_TYPE_CREATURE, "c_summ_devilhorn", GetSpellTargetLocation());
	AssignCommand( oOutsider, DetermineCombatRound(oCaster) );
}