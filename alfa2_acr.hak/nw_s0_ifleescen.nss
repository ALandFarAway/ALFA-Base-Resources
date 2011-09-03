//:://///////////////////////////////////////////////
//:: Warlock Lesser Invocation: Flee the Scene
//:: nw_s0_ifleescen.nss
//:: Copyright (c) 2005 Obsidian Entertainment Inc.
//::////////////////////////////////////////////////
//:: Created By: Brock Heinz
//:: Created On: 08/12/05
//::////////////////////////////////////////////////
/*
        5.7.2.7	Flee the Scene
        Complete Arcane, pg. 134
        Spell Level:	4
        Class: 		Misc

        The warlock gets the benefits of the expeditious retreat spell 
        (1st level wizard) for 1 hour. They also get the benefits of the haste 
        spell (3rd level wizard) for 5 rounds.

        [Rules Note] In the rules this equivalent to the dimension door spell, 
        which doesn't exist in NWN2. Instead it is replaced by Expeditious 
        Retreat and a brief bout of the haste spell. The Haste effect would 
        be incredibly powerful in pen-and-paper, but eventually boots of speed 
        and the like will mean the player perpetually has that beneficial 
        effect, so the warlock gets consistent access to it a little bit earlier.

*/


// JLR - OEI 08/24/05 -- Metamagic changes
#include "nwn2_inc_spells"

#include "NW_I0_SPELLS"
#include "x2_inc_spellhook" 

void DoExpeditiousRetreatEffects( object oCaster, object oTarget, int nMetaMagic )
{
    effect eDur     = EffectVisualEffect( VFX_DUR_SPELL_EXPEDITIOUS_RETREAT );
    effect eFast    = EffectMovementSpeedIncrease(150);
	effect eDodge 	= EffectACIncrease(2);
    effect eLink    = EffectLinkEffects(eFast, eDur);
	eLink 			= EffectLinkEffects(eLink, eDodge);
    
    float fDuration   = HoursToSeconds(1); // 1 hour

    fDuration = ApplyMetamagicDurationMods(fDuration);
    int nDurType = ApplyMetamagicDurationTypeMods(DURATION_TYPE_TEMPORARY);

	//Apply the VFX impact and effects
    ApplyEffectToObject(nDurType, eLink, oTarget, fDuration);
}


void DoHasteEffects( object oCaster, object oTarget, int nMetaMagic )
{
    int nCasterLvl  = GetCasterLevel(oCaster);
    float fDuration   = RoundsToSeconds(5); // Rounds

    //Check for metamagic extension
    fDuration = ApplyMetamagicDurationMods(fDuration);
    int nDurType = ApplyMetamagicDurationTypeMods(DURATION_TYPE_TEMPORARY);

    // Create the Effects
    effect eHaste   = EffectHaste();
    //effect eVis     = EffectVisualEffect(VFX_IMP_HASTE);
    effect eDur     = EffectVisualEffect( VFX_DUR_SPELL_HASTE );
    effect eLink    = EffectLinkEffects(eHaste, eDur);

    // Apply effects to the currently selected target.
    ApplyEffectToObject(nDurType, eLink, oTarget, fDuration);
    //ApplyEffectToObject(DURATION_TYPE_INSTANT, eVis, oTarget);
}


void main()
{

    if (!X2PreSpellCastCode())
    {
	    // If code within the PreSpellCastHook (i.e. UMD) reports FALSE, do not run this spell
        return;
    }



	//Declare major variables
    int nMetaMagic = GetMetaMagicFeat();
    object oCaster = OBJECT_SELF;
    object oTarget = GetFirstFactionMember(OBJECT_SELF, FALSE); 


    // Remove any spells that share effects with this spell

    if (GetHasSpellEffect(SPELL_HASTE, oTarget) == TRUE)
    {
        RemoveSpellEffects(SPELL_HASTE, OBJECT_SELF, oTarget);
    }

    if (GetHasSpellEffect(SPELL_EXPEDITIOUS_RETREAT, oTarget) == TRUE)
    {
        RemoveSpellEffects(SPELL_EXPEDITIOUS_RETREAT, OBJECT_SELF, oTarget);
    }

    //Fire cast spell at event for the specified target
    SignalEvent(oTarget, EventSpellCastAt(oCaster, SPELL_I_FLEE_THE_SCENE, FALSE));

//    DoExpeditiousRetreatEffects( oCaster, OBJECT_SELF, nMetaMagic );
    DoHasteEffects( oCaster, OBJECT_SELF, nMetaMagic );
	
	//Apply haste to party members
	while (GetIsObjectValid(oTarget)) 
	{
		if (GetArea(oTarget) == GetArea(OBJECT_SELF) && (oTarget != OBJECT_SELF))
		{
    		DoHasteEffects( oCaster, oTarget, nMetaMagic );
		}
		oTarget = GetNextFactionMember(OBJECT_SELF, FALSE);
	}

}