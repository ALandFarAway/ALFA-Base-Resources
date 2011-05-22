//::///////////////////////////////////////////////
//:: Greater Heroism
//:: NW_S0_GrHeroism.nss
//:://////////////////////////////////////////////
/*
    Target gets a +2 morale bonus to Attack, saves,
    and skill checks.
*/
//:://////////////////////////////////////////////
//:: Created By: Jesse Reynolds (JLR - OEI)
//:: Created On: August 01, 2005
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
    float fDuration = RoundsToSeconds(nCasterLvl * 10);
    int nHPs = nCasterLvl;
    if ( nHPs > 20 )
    {
        nHPs = 20;
    }

    //Enter Metamagic conditions
    fDuration = ApplyMetamagicDurationMods(fDuration);
    int nDurType = ApplyMetamagicDurationTypeMods(DURATION_TYPE_TEMPORARY);

    // Find the Familiar!
    object oTarget = GetSpellTargetObject();
	
//Prevent stacking with heroism //pkm-oei 10.20.06
	if (GetHasSpellEffect(857, oTarget))
	{
		effect eEffect = GetFirstEffect( oTarget );
		while ( GetIsEffectValid(eEffect) )
		{
			if ( GetEffectSpellId(eEffect) == 857 )
			{
				RemoveEffect( oTarget, eEffect );
			}
			
			eEffect = GetNextEffect( oTarget );
		}
	}
	
    if( oTarget != OBJECT_INVALID )
    {
        effect eAttack = EffectAttackIncrease(4);
        effect eSave = EffectSavingThrowIncrease(SAVING_THROW_ALL, 4, SAVING_THROW_TYPE_ALL);
        effect eSkill = EffectSkillIncrease(SKILL_ALL_SKILLS, 4);
        effect eHP = EffectTemporaryHitpoints(nHPs);
        effect eFear = EffectImmunity(IMMUNITY_TYPE_FEAR);
        effect eDur = EffectVisualEffect( VFX_DUR_SPELL_GREATER_HEROISM );

        effect eLink = EffectLinkEffects(eAttack, eSave);
        eLink = EffectLinkEffects(eLink, eSkill);
//        eLink = EffectLinkEffects(eLink, eHP);
        eLink = EffectLinkEffects(eLink, eFear);
        eLink = EffectLinkEffects(eLink, eDur);

        //effect eVis = EffectVisualEffect(VFX_HIT_SPELL_ENCHANTMENT);

        effect eOnDispell = EffectOnDispel(0.0f, RemoveEffectsFromSpell(oTarget, SPELL_GREATER_HEROISM));
        eLink = EffectLinkEffects(eLink, eOnDispell);
        eHP = EffectLinkEffects(eHP, eOnDispell);

        RemoveEffectsFromSpell(oTarget, GetSpellId());

        //Fire cast spell at event for the specified target
        SignalEvent(oTarget, EventSpellCastAt(OBJECT_SELF, GetSpellId(), FALSE));

        //Apply the VFX impact and effects
        //ApplyEffectToObject(DURATION_TYPE_INSTANT, eVis, oTarget);
        ApplyEffectToObject(nDurType, eHP, oTarget, fDuration);
        ApplyEffectToObject(nDurType, eLink, oTarget, fDuration);
    }
}