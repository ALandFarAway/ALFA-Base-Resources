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
// RPGplayer1 08.31.08 -- Will not count creatures that do not pass spellsIsTarget() check

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
    			nNumTargets--; //FIX: only count allies
    		}        	
     	//Get the next target in the specified area around the caster
		oTarget2 = GetNextObjectInShape(SHAPE_SPHERE, RADIUS_SIZE_LARGE, lTarget, TRUE, OBJECT_TYPE_CREATURE);
        //nNumTargets--;
	}
/*

PKM-OEI 07.25.06 - This is the previous spell code stuff, left it in in case something goes wrong with mine.

// PC casters behave differently than NPC casters, but we also have to account for NPCs that are in a PC party
	// Since there cannot be a party that includes a PC that is not lead by a PC, this check should capture NPCs that are in a PC party
    if ( GetIsPC(oTarget) || GetIsPC(GetFactionLeader( oTarget )) )
    {
        //int nHenchmen = GetNumHenchmen(oTarget);	// this is deprecated in NWN2
        //int nCurHenchman = 0;						// this is deprecated in NWN2
		object oPartyMember = GetFirstFactionMember( oTarget );

        // First, affect Caster...
        // Now process all target critters, starting with the Caster
        while ( GetIsObjectValid(oPartyMember) )
        {
            //Fire cast spell at event for the specified target
            SignalEvent(oTarget, EventSpellCastAt(OBJECT_SELF, SPELL_HASTE, FALSE));

            // Apply effects to the currently selected target.
            ApplyEffectToObject(nDurType, eLink, oTarget, fDuration);
            //ApplyEffectToObject(DURATION_TYPE_INSTANT, eVis, oTarget);

			// This is... anyways, this doesn't work in NWN2
			/*
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
			
			
			oPartyMember = GetNextFactionMember( oTarget );
        }
    }
    else	// this case will handle NPCs who are not a member of a PC party/faction
    {
        // NPC Caster...
        int nNumTargets = nCasterLvl;
        object oOrigTgt = oTarget;

        // First, affect Caster...
        if ( GetIsObjectValid(oTarget) )
        {
            //Fire cast spell at event for the specified target
            SignalEvent(oTarget, EventSpellCastAt(OBJECT_SELF, SPELL_HASTE, FALSE));

            // Apply effects to the currently selected target.
            ApplyEffectToObject(nDurType, eLink, oTarget, fDuration);
            //ApplyEffectToObject(DURATION_TYPE_INSTANT, eVis, oTarget);
        }


        //Declare the spell shape, size and the location.  Capture the first target object in the shape.
        object oTarget = GetFirstObjectInShape(SHAPE_SPHERE, RADIUS_SIZE_SMALL, lTarget, TRUE, OBJECT_TYPE_CREATURE);
        //Cycle through the targets within the spell shape until an invalid object is captured.
        while (GetIsObjectValid(oTarget) && (nNumTargets > 0))
        {
            if (spellsIsTarget(oTarget, SPELL_TARGET_ALLALLIES, OBJECT_SELF))
            {
                if ( oTarget != oOrigTgt )
                {
                    //Fire cast spell at event for the specified target
                    SignalEvent(oTarget, EventSpellCastAt(OBJECT_SELF, SPELL_HASTE, FALSE));

                    // Apply effects to the currently selected target.
                    ApplyEffectToObject(nDurType, eLink, oTarget, fDuration);
                    //ApplyEffectToObject(DURATION_TYPE_INSTANT, eVis, oTarget);
                }
            }

            //Select the next target within the spell shape.
            oTarget = GetNextObjectInShape(SHAPE_SPHERE, RADIUS_SIZE_SMALL, lTarget, TRUE, OBJECT_TYPE_CREATURE);
            nNumTargets--;
        }
    }
}
*/
	
}