//::///////////////////////////////////////////////
//:: Haste
//:: NW_S0_Haste.nss
//:: Copyright (c) 2001 Bioware Corp.
//:://////////////////////////////////////////////
/*
    Gives the targeted creature one extra partial
    action per round.
*/ 
//:://////////////////////////////////////////////
//:: Created By: Preston Watamaniuk
//:: Created On: May 29, 2001
//:://////////////////////////////////////////////
// Modified March 2003: Remove Expeditious Retreat effects

// (Updated JLR - OEI 07/16/05 NWN2 3.5)

// JLR - OEI 08/24/05 -- Metamagic changes

// PKM-OEI 07.25.06 -- Removed special case situations and changed the spell to handle everything 
//						through the spellsIsTarget function, fixing a bug that caused the spell to 
//						not work on allies properly.  Previous script is left below, commented out

// Modified by Riotnrrd for ALFA 1/7/2009
// Properly calculates number of targets, doesnt count enemies

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

    if (!ACR_PrecastEvent())
    {
    // If code within the PreSpellCastHook (i.e. UMD) reports FALSE, do not run this spell
        return;
    }

// End of Spell Cast Hook


    //Declare major variables
    object oTarget = GetSpellTargetObject();
    //Get the spell target location as opposed to the spell target.
    location lTarget = GetSpellTargetLocation();
    // Create the Effects
    effect eHaste = EffectHaste();
    effect eDur = EffectVisualEffect( VFX_DUR_SPELL_HASTE );
    effect eLink = EffectLinkEffects(eHaste, eDur);

    if (GetHasSpellEffect(SPELL_EXPEDITIOUS_RETREAT, oTarget) == TRUE)
    {
        RemoveSpellEffects(SPELL_EXPEDITIOUS_RETREAT, OBJECT_SELF, oTarget);
    }

    if (GetHasSpellEffect( 647, oTarget ) == TRUE)
    {
        RemoveSpellEffects( 647, OBJECT_SELF, oTarget );
    }

    //if (GetHasSpellEffect( SPELL_MASS_HASTE, oTarget ) == TRUE)
    //{
    //    RemoveSpellEffects( SPELL_MASS_HASTE, OBJECT_SELF, oTarget ); //NWN2 doesn't have this spell
    //}

    int nCasterLvl = GetCasterLevel( OBJECT_SELF );
    //int nDuration = nCasterLvl;
	float fDuration = RoundsToSeconds( nCasterLvl );

    //Check for metamagic extension
	fDuration = ApplyMetamagicDurationMods( fDuration );
    int nDurType = ApplyMetamagicDurationTypeMods( DURATION_TYPE_TEMPORARY );
	/*
	int nMetaMagic = GetMetaMagicFeat();
	if (nMetaMagic == METAMAGIC_EXTEND)
    {
		nDuration = nDuration * 2;	//Duration is +100%
    }
	*/
	//Determine how many targets per cast
	int nNumTargets = nCasterLvl;
	
	object oTarget2 = GetFirstObjectInShape( SHAPE_SPHERE, RADIUS_SIZE_LARGE, lTarget, TRUE, OBJECT_TYPE_CREATURE);
	while (GetIsObjectValid(oTarget2) && (nNumTargets > 0))
	{
    	if (spellsIsTarget( oTarget2, SPELL_TARGET_ALLALLIES, OBJECT_SELF ))
    		{
        		SignalEvent( oTarget2, EventSpellCastAt( OBJECT_SELF, SPELL_HASTE, FALSE ));
				//ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eLink, oTarget2, RoundsToSeconds(nDuration));
				ApplyEffectToObject(nDurType, eLink, oTarget2, fDuration);
				nNumTargets--;
    		}        	
     	//Get the next target in the specified area around the caster
		oTarget2 = GetNextObjectInShape(SHAPE_SPHERE, RADIUS_SIZE_LARGE, lTarget, TRUE, OBJECT_TYPE_CREATURE);

	}
}