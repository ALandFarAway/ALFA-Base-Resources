//::///////////////////////////////////////////////
//:: [Fear]
//:: [NW_S0_Fear.nss]
//:: Copyright (c) 2000 Bioware Corp. 
//:://////////////////////////////////////////////
//:: Causes an area of fear that reduces Will Saves
//:: and applies the frightened effect.
//:://////////////////////////////////////////////
//:: Created By: Preston Watamaniuk
//:: Created On: April 23, 2001
//:://////////////////////////////////////////////
//:: VFX Pass By: Preston W, On: June 20, 2001
//:: Update Pass By: Preston W, On: July 30, 2001

// Modified by Riotnrrd for ALFA 1/7/2009
// Shape 30' Cone
// Fear effects per canon, -2 atk, -2 saves, -2 skills
// On successful save, is still shaken for 1 round

#include "X0_I0_SPELLS"
#include "x2_inc_spellhook"
#include "acr_spells_i" 

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
    int nCasterLevel = GetCasterLevel(OBJECT_SELF);
    int nMetaMagic = GetMetaMagicFeat();
    float fDuration = RoundsToSeconds(nCasterLevel);
    int nDamage;
    //effect eVis = EffectVisualEffect(VFX_HIT_SPELL_NECROMANCY);	// NWN1 VFX
    effect eVis = EffectVisualEffect( VFX_DUR_SPELL_FEAR );	// NWN2 VFX
	effect eAtk = EffectAttackDecrease(2);
	effect eSave = EffectSavingThrowDecrease(SAVING_THROW_ALL, 2);
	effect eSkill = EffectSkillDecrease(SKILL_ALL_SKILLS, 2);
	effect eFear = EffectLinkEffects( eVis, eAtk);
	eFear = EffectLinkEffects( eFear, eSave);
	eFear = EffectLinkEffects( eFear, eSkill);

    object oTarget;
    //Check for metamagic extend
	if (nMetaMagic == METAMAGIC_EXTEND)
	{
		fDuration = fDuration * 2.0;	//Duration is +100%
	}
    //Get first target in the spell cone
    oTarget = GetFirstObjectInShape(SHAPE_SPELLCONE, 9.144, GetSpellTargetLocation());
    while(GetIsObjectValid(oTarget))
    {
        if (spellsIsTarget(oTarget, SPELL_TARGET_STANDARDHOSTILE, OBJECT_SELF))
    	{
            //Fire cast spell at event for the specified target
            SignalEvent(oTarget, EventSpellCastAt(OBJECT_SELF, SPELL_FEAR));
            //Make SR Check
            if(!MyResistSpell(OBJECT_SELF, oTarget))
            {
                //Make a will save
                if(!MySavingThrow(SAVING_THROW_WILL, oTarget, GetSpellSaveDC(), SAVING_THROW_TYPE_FEAR, OBJECT_SELF))
                {
                    //Apply the linked effects and the VFX impact
					eFear = EffectLinkEffects (eFear, EffectFrightened());
                    ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eFear, oTarget, fDuration);
                }
				else { // Still shaken for 1 round
					ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eFear, oTarget, 1.0);
				}	
            }
        }
        //Get next target in the spell cone
        oTarget = GetNextObjectInShape(SHAPE_SPELLCONE, 9.144, GetSpellTargetLocation());
    }
}