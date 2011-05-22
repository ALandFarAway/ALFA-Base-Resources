//::///////////////////////////////////////////////
//:: [Cause Fear]
//:: [NW_S0_CauseFear.nss]
//:: Copyright (c) 2000 Bioware Corp.
//:://////////////////////////////////////////////
//:: Will save or the target is scared for 1d4 rounds.
//:: NOTE THIS SPELL IS EQUAL TO **CAUSE FEAR** NOT SCARE.
//:://////////////////////////////////////////////
//:: Created By: Preston Watamaniuk
//:: Created On: Jan 30, 2001
//:://////////////////////////////////////////////
//:: Last Updated By: Preston Watamaniuk, On: April 11, 2001
//:: Modified March 2003 to give -2 attack and damage penalties

// (Updated JLR - OEI 07/05/05 NWN2 3.5)

// JLR - OEI 08/23/05 -- Metamagic changes
// RPGplayer1 12/20/2008 - Use charisma based DC, for racial version (per PnP)

#include "nwn2_inc_spells"

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
    object oTarget = GetSpellTargetObject();
	effect eDur = EffectVisualEffect(VFX_DUR_SPELL_CAUSE_FEAR);
    effect eScare = EffectFrightened();
    effect eSave = EffectSavingThrowDecrease(SAVING_THROW_WILL, 2, SAVING_THROW_TYPE_MIND_SPELLS);
    effect eDamagePenalty = EffectDamageDecrease(2);
    effect eAttackPenalty = EffectAttackDecrease(2);
    effect eLink2 = EffectLinkEffects(eSave, eScare);
    eLink2 = EffectLinkEffects(eLink2, eDamagePenalty);
    eLink2 = EffectLinkEffects(eLink2, eAttackPenalty);
	eLink2 = EffectLinkEffects(eLink2, eDur);
	
    int nDur = d4();
    int nDC = GetSpellSaveDC();

	//Has same SpellId as Cause Fear, not an item, but returns no valid class -> it's racial ability
	if (GetSpellId() == SPELL_CAUSE_FEAR && !GetIsObjectValid(GetSpellCastItem()) && GetLastSpellCastClass() == CLASS_TYPE_INVALID)
	{
		nDC = 10 + GetSpellLevel(SPELL_CAUSE_FEAR) + GetAbilityModifier(ABILITY_CHARISMA);
	}

    //Do metamagic checks
    nDur = ApplyMetamagicVariableMods(nDur, 4);
    float fDuration = RoundsToSeconds(nDur);
    fDuration = ApplyMetamagicDurationMods(fDuration);
    int nDurType = ApplyMetamagicDurationTypeMods(DURATION_TYPE_TEMPORARY);

    //Check the Hit Dice of the creature
    if ((GetHitDice(oTarget) < 6) && GetObjectType(oTarget) == OBJECT_TYPE_CREATURE)
    {
        // * added rep check April 2003
        if (spellsIsTarget(oTarget, SPELL_TARGET_STANDARDHOSTILE, OBJECT_SELF) == TRUE)
        {
            //Fire cast spell at event for the specified target
            SignalEvent(oTarget, EventSpellCastAt(OBJECT_SELF, SPELL_CAUSE_FEAR));
            //Make SR check
            if(!MyResistSpell(OBJECT_SELF, oTarget))
            {
                //Make Will save versus fear
                if(!/*Will Save*/ MySavingThrow(SAVING_THROW_WILL, oTarget, nDC, SAVING_THROW_TYPE_FEAR))
                {
                    //Apply linked effects and VFX impact
                    ApplyEffectToObject(nDurType, eLink2, oTarget, fDuration);
                }
            }
        }
    }
}