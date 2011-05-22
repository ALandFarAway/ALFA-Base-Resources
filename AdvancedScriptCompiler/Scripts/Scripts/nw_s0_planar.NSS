//::///////////////////////////////////////////////
//:: Planar Binding
//:: NW_S0_Planar.nss
//:: Copyright (c) 2001 Bioware Corp.
//:://////////////////////////////////////////////
/*
    Summons an outsider dependant on alignment, or
    holds an outsider if the creature fails a save.
*/
//:://////////////////////////////////////////////
//:: Created By: Preston Watamaniuk
//:: Created On: April 12, 2001
//:://////////////////////////////////////////////
#include "NW_I0_SPELLS"

#include "x2_inc_spellhook" 

void main()
{

/* 
  Spellcast Hook Code 
  Added 2003-06-23 by GeorgZ
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
    int nMetaMagic = GetMetaMagicFeat();
    int nCasterLevel = GetCasterLevel(OBJECT_SELF);
    int nDuration = GetCasterLevel(OBJECT_SELF);
    effect eSummon;
    //effect eGate;
	int nSaveDC = GetSpellSaveDC()+2;
	effect eParalyze = EffectParalyze(nSaveDC, SAVING_THROW_WILL);
	effect eVis = EffectVisualEffect(VFX_DUR_PARALYZED);
	eParalyze = EffectLinkEffects( eParalyze, eVis );
	effect eHit = EffectVisualEffect(VFX_HIT_SPELL_SUMMON_CREATURE);

    int nRacial = GetRacialType(oTarget);
    int nAlign = GetAlignmentGoodEvil(OBJECT_SELF);
    if(nDuration == 0)
    {
        nDuration == 1;
    }
    //Check for metamagic extend
    if (nMetaMagic == METAMAGIC_EXTEND)
    {
        nDuration = nDuration *2;	//Duration is +100%
    }
    //Check to make sure a target was selected
    if (GetIsObjectValid(oTarget))
    {
        //Check the racial type of the target
        if(nRacial == RACIAL_TYPE_OUTSIDER)
        {
        	if (spellsIsTarget(oTarget, SPELL_TARGET_STANDARDHOSTILE, OBJECT_SELF))
        	{
                //Fire cast spell at event for the specified target
                SignalEvent(oTarget, EventSpellCastAt(OBJECT_SELF, SPELL_PLANAR_BINDING));
                //Make a Will save
                if(!MySavingThrow(SAVING_THROW_WILL, oTarget, nSaveDC))
                {
                    //Apply the linked effect
                    ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eParalyze, oTarget, RoundsToSeconds(nDuration/2));
					ApplyEffectToObject(DURATION_TYPE_INSTANT, eHit, oTarget);
                }
            }
        }
    }
    else
    {
        //Set the summon effect based on the alignment of the caster
        float fDelay = 3.0;
        switch (nAlign)
        {
            case ALIGNMENT_EVIL:
                eSummon = EffectSummonCreature("c_summ_succubus",VFX_FNF_SUMMON_GATE, fDelay);
                //eGate = EffectVisualEffect(VFX_FNF_SUMMON_GATE);
            break;
            case ALIGNMENT_GOOD:
                eSummon = EffectSummonCreature("c_celestialbear", VFX_FNF_SUMMON_CELESTIAL, fDelay);
                //eGate = EffectVisualEffect(VFX_FNF_SUMMON_CELESTIAL);
            break;
            case ALIGNMENT_NEUTRAL:
                eSummon = EffectSummonCreature("c_summ_sylph",VFX_FNF_SUMMON_MONSTER_3, 1.0);
                //eGate = EffectVisualEffect(VFX_FNF_SUMMON_MONSTER_3);
                //fDelay = 1.0;
            break;
        }
        //Apply the summon effect and VFX impact
        //ApplyEffectAtLocation(DURATION_TYPE_INSTANT, eGate, GetSpellTargetLocation());
        ApplyEffectAtLocation(DURATION_TYPE_TEMPORARY, eSummon, GetSpellTargetLocation(),RoundsToSeconds(nDuration*10));	// AFW-OEI 06/02/2006: Minutes
    }
}