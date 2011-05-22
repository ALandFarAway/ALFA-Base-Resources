//::///////////////////////////////////////////////
//:: Solipsism
//:: nx_s0_solipsism.nss
//:: Copyright (c) 2007 Obsidian Entertainment, Inc.
//:://////////////////////////////////////////////
/*
	Illusion (Phantasm)
	Level: Wizard/Sorcerer 7
	Components: V
	Range: Medium
	Target: One creature
	Duration: 1 round/level (D)
	Saving Throw: Will negates
	Spell Resistance: Yes
	
	You manipulate the senses of one creature so that
	it perceives itself to be the only real creature
	in all of existence and everything around it to
	be merely an illusion.
	 
	If the target fails its save, it is convinced
	of the unreality of every situation it might
	encounter. It takes no actions, not even purely
	mental actions, and instead watches the world
	around it with bemusement. The subject becomes
	effectively helpless and takes no steps to defend
	itself from any threat, since it considers any
	hostile action merely another illusion.
*/
//:://////////////////////////////////////////////
//:: Created By: Andrew Woo (AFW-OEI)
//:: Created On: 05/07/2007
//:://////////////////////////////////////////////
//:: RPGplayer1 04/11/2008:
//::  Will bypass paralysis immunity
//::  Won't be removed by spells that cancel paralysis
//:: RPGplayer1 04/19/2008: Added proper VFX

#include "NW_I0_SPELLS"    
#include "x2_inc_spellhook" 

void main()
{
    if (!X2PreSpellCastCode())
    {	// If code within the PreSpellCastHook (i.e. UMD) reports FALSE, do not run this spell
        return;
    }

    //Declare major variables
    object oTarget = GetSpellTargetObject();
    int nCasterLvl = GetCasterLevel(OBJECT_SELF);
    int nDuration = nCasterLvl;
    nDuration = GetScaledDuration(nDuration, oTarget);
	
	int nSaveDC = GetSpellSaveDC();
	
	int bSaveEveryRound = FALSE;
    //effect eParal = EffectParalyze(nSaveDC, SAVING_THROW_WILL, bSaveEveryRound);
    effect eParal = EffectCutsceneParalyze();
	//effect eHit = EffectVisualEffect( VFX_DUR_SPELL_HOLD_MONSTER );
	effect eHit = EffectVisualEffect( VFX_DUR_SPELL_SOLIPSISM );
	eParal = EffectLinkEffects( eParal, eHit );


	if (spellsIsTarget(oTarget, SPELL_TARGET_STANDARDHOSTILE, OBJECT_SELF))
	{
       //Fire cast spell at event for the specified target
       SignalEvent(oTarget, EventSpellCastAt(OBJECT_SELF, GetSpellId()));
	   
       //Make SR check
       if (!MyResistSpell(OBJECT_SELF, oTarget))
	   {
            //Make Will save
            if (/*Will Save*/ !MySavingThrow(SAVING_THROW_WILL, oTarget, nSaveDC, SAVING_THROW_TYPE_MIND_SPELLS))
            {
                if (GetIsImmune(oTarget, IMMUNITY_TYPE_MIND_SPELLS, OBJECT_SELF))
                    return;

                //Check for metamagic extend
				int nMeta = GetMetaMagicFeat();
                if (nMeta == METAMAGIC_EXTEND)
                {
                    nDuration = nDuration * 2;
                }
				
                //Apply the paralyze effect and the VFX impact
                ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eParal, oTarget, RoundsToSeconds(nDuration));
            }
        }
    }
}