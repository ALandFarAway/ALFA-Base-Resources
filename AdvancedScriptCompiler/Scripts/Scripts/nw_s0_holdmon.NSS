//::///////////////////////////////////////////////
//:: Hold Monster
//:: NW_S0_HoldMon
//:: Copyright (c) 2001 Bioware Corp.
//:://////////////////////////////////////////////
/*
    Will hold any monster in place for 1
    round per caster level.
*/
//:://////////////////////////////////////////////
//:: Created By: Keith Soleski
//:: Created On: Jan 18, 2001
//:://////////////////////////////////////////////
//:: Update Pass By: Preston W, On: Aug 1, 2001

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
    int nCasterLvl = GetCasterLevel(OBJECT_SELF);
    int nMeta = GetMetaMagicFeat();
    int nDuration = nCasterLvl;
    nDuration = GetScaledDuration(nDuration, oTarget);
	int nSaveDC = GetSpellSaveDC();
    effect eParal = EffectParalyze(nSaveDC, SAVING_THROW_WILL);
	effect eHit = EffectVisualEffect( VFX_DUR_SPELL_HOLD_MONSTER );
	eParal = EffectLinkEffects( eParal, eHit );


	if (spellsIsTarget(oTarget, SPELL_TARGET_STANDARDHOSTILE, OBJECT_SELF))
	{
        //Fire cast spell at event for the specified target
        SignalEvent(oTarget, EventSpellCastAt(OBJECT_SELF, SPELL_HOLD_MONSTER));
       //Make SR check
       if (!MyResistSpell(OBJECT_SELF, oTarget))
	   {
            //Make Will save
            if (!/*Will Save*/ MySavingThrow(SAVING_THROW_WILL, oTarget, nSaveDC))
            {
                //Check for metamagic extend
                if (nMeta == METAMAGIC_EXTEND)
                {
                    nDuration = nDuration * 2;
                }
                //Apply the paralyze effect and the VFX impact
                ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eParal, oTarget, RoundsToSeconds(nDuration));
				//ApplyEffectToObject(DURATION_TYPE_INSTANT, eHit, oTarget);
            }
        }
    }
}