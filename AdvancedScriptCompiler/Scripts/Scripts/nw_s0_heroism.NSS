//::///////////////////////////////////////////////
//:: Heroism
//:: NW_S0_Heroism.nss
//:://////////////////////////////////////////////
/*
    Target gets a +2 morale bonus to Attack, saves,
    and skill checks.
*/
//:://////////////////////////////////////////////
//:: Created By: Jesse Reynolds (JLR - OEI)
//:: Created On: July 11, 2005
//:://////////////////////////////////////////////
//:: VFX Pass By: Preston W, On: June 20, 2001

// JLR - OEI 08/23/05 -- Metamagic changes
#include "nwn2_inc_spells"


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
    int nCasterLvl = GetCasterLevel(OBJECT_SELF);
    float fDuration = TurnsToSeconds(nCasterLvl * 10);

    //Enter Metamagic conditions
    fDuration = ApplyMetamagicDurationMods(fDuration);
    int nDurType = ApplyMetamagicDurationTypeMods(DURATION_TYPE_TEMPORARY);

    // Find the Familiar!
    object oTarget = GetSpellTargetObject();
	
//Prevent stacking with Greater Heroism.  This spell will not fail is greater heroism is in place//pkm oei 10.20.06	
	if (GetHasSpellEffect(876, oTarget))
	{
		return;
	}
	
	
    if( oTarget != OBJECT_INVALID )
    {
        effect eAttack = EffectAttackIncrease(2);
        effect eSave = EffectSavingThrowIncrease(SAVING_THROW_ALL, 2, SAVING_THROW_TYPE_ALL);
        effect eSkill = EffectSkillIncrease(SKILL_ALL_SKILLS, 2);
        effect eDur = EffectVisualEffect( VFX_DUR_SPELL_HEROISM );

        effect eLink = EffectLinkEffects(eAttack, eSave);
        eLink = EffectLinkEffects(eLink, eSkill);
        eLink = EffectLinkEffects(eLink, eDur);

        //effect eVis = EffectVisualEffect(VFX_HIT_SPELL_ENCHANTMENT);

        //Fire cast spell at event for the specified target
        SignalEvent(oTarget, EventSpellCastAt(OBJECT_SELF, GetSpellId(), FALSE));

        //Apply the VFX impact and effects
        //ApplyEffectToObject(DURATION_TYPE_INSTANT, eVis, oTarget);
        ApplyEffectToObject(nDurType, eLink, oTarget, fDuration);
    }
}