//:://///////////////////////////////////////////////
//:: Warlock Dark Invocation: Word of Changing
//:: nw_s0_iwordchng.nss
//:: Copyright (c) 2005 Obsidian Entertainment Inc.
//::////////////////////////////////////////////////
//:: Created By: Brock Heinz
//:: Created On: 12/08/05
//::////////////////////////////////////////////////
/*
        Word of Changing    Complete Arcane, pg. 136
        Spell Level:        2
        Class: 	            Misc

        This invocation is the equivalent of the 
        shapechange spell (9th level wizard).

        [Rules Note] In the rules this invocation is 
        the equivalent of the baleful polymorph spell. 
        That spell isn't in NWN2, so shapechange is used 
        instead.
*/


#include "x2_inc_spellhook"
#include "acr_spells_i"
#include "nwn2_inc_metmag"

void main()
{

    if (!ACR_PrecastEvent())
    {
        // If code within the PreSpellCastHook (i.e. UMD) reports FALSE, do not run this spell
        return;
    }


    //Declare major variables
    int nSpell = GetSpellId();
    object oTarget = GetSpellTargetObject();
    effect eVis = EffectVisualEffect(VFX_INVOCATION_WORD_OF_CHANGING);
    effect ePoly;
    int nPoly;
    int nMetaMagic = GetMetaMagicFeat();
    //Enter Metamagic conditions
	float fDuration = TurnsToSeconds( GetCasterLevel(OBJECT_SELF ) );
    fDuration = ApplyMetamagicDurationMods( fDuration );

    //Determine Polymorph subradial type
    if(nSpell == SPELL_I_WORD_OF_CHANGING) 
    {
        nPoly = POLYMORPH_TYPE_HORNED_DEVIL;
    }
    else
    {
        // Whoops!
        nPoly = POLYMORPH_TYPE_COW;
    }

    ePoly = EffectPolymorph(nPoly);
    ePoly = EffectLinkEffects(ePoly, eVis);
    //Fire cast spell at event for the specified target
    SignalEvent(oTarget, EventSpellCastAt(OBJECT_SELF, nSpell, FALSE));

    //Apply the VFX impact and effects
    //ApplyEffectAtLocation(DURATION_TYPE_INSTANT, eVis, GetLocation(oTarget));
    DelayCommand(0.4, AssignCommand(oTarget, ClearAllActions())); // prevents an exploit
    DelayCommand(0.5, ApplyEffectToObject(DURATION_TYPE_TEMPORARY, ePoly, oTarget, fDuration));
}