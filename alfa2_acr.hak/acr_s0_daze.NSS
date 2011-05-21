//::///////////////////////////////////////////////
//:: [Daze]
//:: [NW_S0_Daze.nss]
//:: Copyright (c) 2000 Bioware Corp.
//:://////////////////////////////////////////////
//:: Will save or the target is dazed for 1 round
//:://////////////////////////////////////////////
//:: Created By: Preston Watamaniuk 
//:: Created On: Jan 15, 2001
//:://////////////////////////////////////////////
//:: Update Pass By: Preston W, On: July 27, 2001

// Modified by Riotnrrd for ALFA 1/7/2009
// Changed duration to 1 rnd, affects only 4HD or less

#include "x0_I0_SPELLS"    
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
    object oTarget = GetSpellTargetObject();
    effect eMind = EffectVisualEffect( VFX_DUR_SPELL_DAZE );
    effect eDaze = EffectDazed();

    effect eLink = EffectLinkEffects(eMind, eDaze);
	
    int nMetaMagic = GetMetaMagicFeat();
    int nDuration = 1;
    //check meta magic for extend
    if (nMetaMagic == METAMAGIC_EXTEND)
    {
        nDuration = 2;
    }
    
    
    //Make sure the target is a humaniod
    if (AmIAHumanoid(oTarget) == TRUE)
    {
        if(GetHitDice(oTarget) <= 4)
        {
            if (spellsIsTarget(oTarget, SPELL_TARGET_STANDARDHOSTILE, OBJECT_SELF))
        	{
                //Fire cast spell at event for the specified target
                SignalEvent(oTarget, EventSpellCastAt(OBJECT_SELF, SPELL_DAZE));
               //Make SR check
               if (!MyResistSpell(OBJECT_SELF, oTarget))
        	   {
                    //Make Will Save to negate effect
                    if (!/*Will Save*/ MySavingThrow(SAVING_THROW_WILL, oTarget, GetSpellSaveDC(), SAVING_THROW_TYPE_MIND_SPELLS))
                    {
                        //Apply VFX Impact and daze effect
                        ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eLink, oTarget, RoundsToSeconds(nDuration));
						//ApplyEffectToObject(DURATION_TYPE_INSTANT, eHit, oTarget);	// NWN1 VFX
                        //ApplyEffectToObject(DURATION_TYPE_INSTANT, eVis, oTarget);	// NWN1 VFX
                    }
                }
            }
        }
    }
}