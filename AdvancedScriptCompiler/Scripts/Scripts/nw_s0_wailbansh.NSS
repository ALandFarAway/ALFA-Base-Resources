//::///////////////////////////////////////////////
//:: Wail of the Banshee
//:: NW_S0_WailBansh
//:: Copyright (c) 2001 Bioware Corp.
//:://////////////////////////////////////////////
/*
  You emit a terrible scream that kills enemy creatures who hear it
  The spell affects up to one creature per caster level. Creatures
  closest to the point of origin are affected first.
*/
//:://////////////////////////////////////////////
//:: Created By: Preston Watamaniuk
//:: Created On:  Dec 12, 2000
//:://////////////////////////////////////////////
//:: Last Updated By: Preston Watamaniuk, On: April 11, 2001
//:: VFX Pass By: Preston W, On: June 25, 2001
//:: 6/21/06 - BDF-OEI: updated to use NWN2 VFX
//:: 7.08.06 - PKM-OEI: updated VFX again to make it hot & spicy (changed darkness hit to necro hit)
//:: 8.31.08 - RPGplayer1: Will not count creatures that do not pass spellsIsTarget() check

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
    int nCasterLevel = GetCasterLevel(OBJECT_SELF);
    int nToAffect = nCasterLevel;
    object oTarget;
    float fTargetDistance;
    float fDelay;
    location lTarget;
   //effect eVis = EffectVisualEffect(VFX_IMP_DEATH);//NWN1 vfx, this works but doesn't look as cool
	effect eVis = EffectVisualEffect (VFX_HIT_SPELL_NECROMANCY);//looks cooler
    //effect eWail = EffectVisualEffect(VFX_FNF_WAIL_O_BANSHEES);	// no longer using NWN1 VFX
    effect eWail = EffectVisualEffect( VFX_HIT_SPELL_WAIL_OF_THE_BANSHEE );	// makes use of NWN2 VFX
	int nCnt = 0;
    //Apply the FNF VFX impact
    ApplyEffectAtLocation(DURATION_TYPE_INSTANT, eWail, GetSpellTargetLocation());
    //Get the closet target from the spell target location
    oTarget = GetSpellTargetObject(); // direct target
    if (!GetIsObjectValid(oTarget))
    {
      nCnt++;
      oTarget = GetNearestObjectToLocation(OBJECT_TYPE_CREATURE, GetSpellTargetLocation(), nCnt);
    }
    while (nCnt < nToAffect)
    {
        lTarget = GetLocation(oTarget);
        //Get the distance of the target from the center of the effect
        fDelay = GetRandomDelay(1.0, 2.0);//FIX: original delay was too long (3-4s)
        fTargetDistance = GetDistanceBetweenLocations(GetSpellTargetLocation(), lTarget);
        //Check that the current target is valid and closer than 10.0m
        if(GetIsObjectValid(oTarget) && fTargetDistance <= 10.0)
        {
            if (spellsIsTarget(oTarget, SPELL_TARGET_SELECTIVEHOSTILE, OBJECT_SELF))
            {
                //Fire cast spell at event for the specified target
                SignalEvent(oTarget, EventSpellCastAt(OBJECT_SELF, SPELL_WAIL_OF_THE_BANSHEE));
                //Make SR check
                if(!MyResistSpell(OBJECT_SELF, oTarget)) //, 0.1))
                {
                    //Make a fortitude save to avoid death
                    if(!MySavingThrow(SAVING_THROW_FORT, oTarget, GetSpellSaveDC(), SAVING_THROW_TYPE_DEATH)) //, OBJECT_SELF, 3.0))
                    {
                        //Apply the delay VFX impact and death effect
                        DelayCommand(fDelay, ApplyEffectToObject(DURATION_TYPE_INSTANT, eVis, oTarget));
                        effect eDeath = EffectDeath();
                        DelayCommand(fDelay, ApplyEffectToObject(DURATION_TYPE_INSTANT, eDeath, oTarget)); // no delay
                    }
                }
            }
            else nToAffect++; //FIX: do not count allies
        }
        else
        {
            //Kick out of the loop
            nCnt = nToAffect;
        }
        //Increment the count of creatures targeted
        nCnt++;
        //Get the next closest target in the spell target location.
        oTarget = GetNearestObjectToLocation(OBJECT_TYPE_CREATURE, GetSpellTargetLocation(), nCnt);
    }
}