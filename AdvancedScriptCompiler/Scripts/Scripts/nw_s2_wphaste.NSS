//::///////////////////////////////////////////////
//:: Warpriest Haste
//:: NW_S0_Haste.nss
//:: Copyright (c) 2006 Obsidain Entertainment, Inc.
//:://////////////////////////////////////////////
/*
    Gives the targeted creature one extra partial
    action per round.

	Warpriest's spell-like ability to caste Haste.
	Main difference is that it uses the Warpriest
	level for variable effects.
*/
//:://////////////////////////////////////////////
//:: Created By: Andrew Woo (AFW-OEI)
//:: Created On: 05/20/2006
//:://////////////////////////////////////////////
//:: AFW-OEI 04/24/2007: Modify to work for Favored Souls, too.
//:: RPGplayer1 03/20/2008: Will affect allies if used on caster (RADIUS_SIZE_LARGE)
//:: RPGplayer1 08/31/2008: Will not count creatures that do not pass spellsIsTarget() check

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


    //Declare major variables
    object oTarget = GetSpellTargetObject();
    //Get the spell target location as opposed to the spell target.
    location lTarget = GetSpellTargetLocation();

    if (GetHasSpellEffect(SPELL_EXPEDITIOUS_RETREAT, oTarget) == TRUE)
    {
        RemoveSpellEffects(SPELL_EXPEDITIOUS_RETREAT, OBJECT_SELF, oTarget);
    }

    if (GetHasSpellEffect(647, oTarget) == TRUE)
    {
        RemoveSpellEffects(647, OBJECT_SELF, oTarget);
    }

    if (GetHasSpellEffect(SPELL_MASS_HASTE, oTarget) == TRUE)
    {
        RemoveSpellEffects(SPELL_MASS_HASTE, OBJECT_SELF, oTarget);
    }

	
    int nCasterLvl = 0;
	int nSpellId = GetSpellId();
	if (nSpellId == SPELLABILITY_WARPRIEST_HASTE)
	{
		nCasterLvl = GetLevelByClass(CLASS_TYPE_WARPRIEST);		// AFW-OEI 05/20/2006: main difference from Haste
	}
	else if (nSpellId == SPELLABILITY_FAVORED_SOUL_HASTE)
	{
		nCasterLvl = GetLevelByClass(CLASS_TYPE_FAVORED_SOUL);
	}
	
    float fDuration = RoundsToSeconds(nCasterLvl);

    //Check for metamagic extension
    fDuration = ApplyMetamagicDurationMods(fDuration);
    int nDurType = ApplyMetamagicDurationTypeMods(DURATION_TYPE_TEMPORARY);


    // PC casters behave differently than NPC casters
    /*if ( GetIsPC( oTarget ) )
    {
        int nHenchmen = GetNumHenchmen(oTarget);
        int nCurHenchman = 0;

        // First, affect Caster...
        // Now process all target critters, starting with the Caster
        while ( GetIsObjectValid(oTarget) )
        {
            //Fire cast spell at event for the specified target
            SignalEvent(oTarget, EventSpellCastAt(OBJECT_SELF, SPELL_HASTE, FALSE));

            // Create the Effects
            effect eHaste = EffectHaste();
            //effect eVis = EffectVisualEffect(VFX_IMP_HASTE);
            effect eDur = EffectVisualEffect( VFX_DUR_SPELL_HASTE );
            effect eLink = EffectLinkEffects(eHaste, eDur);

            // Apply effects to the currently selected target.
            ApplyEffectToObject(nDurType, eLink, oTarget, fDuration);
            //ApplyEffectToObject(DURATION_TYPE_INSTANT, eVis, oTarget);

            // Now prep to do the next critter in the list...
            if ( nCurHenchman < nHenchmen )
            {
                oTarget = GetHenchman( OBJECT_SELF, nCurHenchman );
                nCurHenchman++;
            }
            else
            {
                oTarget = OBJECT_INVALID;
            }
        }
    }
    else
    */{
        // NPC Caster...
        int nNumTargets = nCasterLvl;
        object oOrigTgt = oTarget;

        // First, affect Caster...
        if ( GetIsObjectValid(oTarget) )
        {
            //Fire cast spell at event for the specified target
            SignalEvent(oTarget, EventSpellCastAt(OBJECT_SELF, SPELL_HASTE, FALSE));

            // Create the Effects
            effect eHaste = EffectHaste();
            //effect eVis = EffectVisualEffect(VFX_IMP_HASTE);
            effect eDur = EffectVisualEffect( VFX_DUR_SPELL_HASTE );
            effect eLink = EffectLinkEffects(eHaste, eDur);

            // Apply effects to the currently selected target.
            ApplyEffectToObject(nDurType, eLink, oTarget, fDuration);
            //ApplyEffectToObject(DURATION_TYPE_INSTANT, eVis, oTarget);
        }


        //Declare the spell shape, size and the location.  Capture the first target object in the shape.
        object oTarget = GetFirstObjectInShape(SHAPE_SPHERE, RADIUS_SIZE_LARGE, lTarget, TRUE, OBJECT_TYPE_CREATURE);
        //Cycle through the targets within the spell shape until an invalid object is captured.
        while (GetIsObjectValid(oTarget) && (nNumTargets > 0))
        {
            if (spellsIsTarget(oTarget, SPELL_TARGET_ALLALLIES, OBJECT_SELF))
            {
                if ( oTarget != oOrigTgt )
                {
                    //Fire cast spell at event for the specified target
                    SignalEvent(oTarget, EventSpellCastAt(OBJECT_SELF, SPELL_HASTE, FALSE));

                    // Create the Effects
                    effect eHaste = EffectHaste();
                    //effect eVis = EffectVisualEffect(VFX_IMP_HASTE);
                    effect eDur = EffectVisualEffect( VFX_DUR_SPELL_HASTE );
                    effect eLink = EffectLinkEffects(eHaste, eDur);

                    // Apply effects to the currently selected target.
                    ApplyEffectToObject(nDurType, eLink, oTarget, fDuration);
                    //ApplyEffectToObject(DURATION_TYPE_INSTANT, eVis, oTarget);
                }
                nNumTargets--; //FIX: only count allies
            }

            //Select the next target within the spell shape.
            oTarget = GetNextObjectInShape(SHAPE_SPHERE, RADIUS_SIZE_LARGE, lTarget, TRUE, OBJECT_TYPE_CREATURE);
            //nNumTargets--;
        }
    }
}