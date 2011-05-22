//::///////////////////////////////////////////////
//:: Dismissal
//:: NW_S0_Dismissal.nss
//:: Copyright (c) 2001 Bioware Corp.
//:://////////////////////////////////////////////
/*
    All summoned creatures within 30ft of caster
    make a save and SR check or be banished
*/
//:://////////////////////////////////////////////
//:: Created By: Preston Watamaniuk
//:: Created On: Oct 22, 2001
//:://////////////////////////////////////////////
//:: VFX Pass By: Preston W, On: June 20, 2001
//:: PKM - OEI 07.18.06 VFX Update, Saving throw corrected, spell now affects elementals and outsiders
//:: 11/28/06 - BDF(OEI): fixed an issue with the spell DC being calculated incorrectly

#include "X0_I0_SPELLS"
#include "x2_inc_spellhook" 

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
    object oMaster;
    effect eVis = EffectVisualEffect( VFX_HIT_AOE_ABJURATION );
	effect eDeath = EffectDeath(FALSE, TRUE, TRUE); //FIX: should work on death-immune
	effect eLink = EffectLinkEffects(eVis, eDeath);
    int nBaseSpellDC = GetSpellSaveDC();
	int nCasterLevel = GetCasterLevel ( OBJECT_SELF );
	int nRacial;
	int nHitDice;
	int nAdjustedSpellDC;
	
	nBaseSpellDC += nCasterLevel;
	
	location lTarget = GetSpellTargetLocation();
    //Get the first object in the are of effect
    object oTarget = GetFirstObjectInShape( SHAPE_SPHERE, RADIUS_SIZE_LARGE, lTarget );
	
    while(GetIsObjectValid(oTarget))
    { 	
        //does the creature have a master.
        oMaster = GetMaster(oTarget);
		nHitDice = GetHitDice ( oTarget );
		nAdjustedSpellDC = nBaseSpellDC - nHitDice;
		nRacial = GetRacialType(oTarget);
		
        //Is that master valid and is he an enemy
        if ( (GetIsObjectValid(oMaster) && spellsIsTarget(oMaster,SPELL_TARGET_STANDARDHOSTILE, OBJECT_SELF) ) ||
			 spellsIsTarget(oTarget, SPELL_TARGET_STANDARDHOSTILE, OBJECT_SELF) )
        {
		
            if ( GetAssociate(ASSOCIATE_TYPE_SUMMONED, oMaster) == oTarget ||
            	GetAssociate(ASSOCIATE_TYPE_FAMILIAR, oMaster) == oTarget ||
            	GetAssociate(ASSOCIATE_TYPE_ANIMALCOMPANION, oMaster) == oTarget ||
				nRacial == RACIAL_TYPE_OUTSIDER ||
				nRacial == RACIAL_TYPE_ELEMENTAL )
            {
                SignalEvent(oTarget, EventSpellCastAt(OBJECT_SELF, SPELL_DISMISSAL));
                //Determine correct save
               
                //Make SR and will save checks
                if (!MyResistSpell(OBJECT_SELF, oTarget) && !MySavingThrow(SAVING_THROW_WILL, oTarget, nAdjustedSpellDC))
                {
                     //Apply the VFX and delay the destruction of the summoned monster so
                     //that the script and VFX can play.
                     ApplyEffectToObject(DURATION_TYPE_INSTANT, eLink, oTarget);
                }
            }
        }
        //Get next creature in the shape.
        oTarget = GetNextObjectInShape( SHAPE_SPHERE, RADIUS_SIZE_LARGE, lTarget );
	}
}