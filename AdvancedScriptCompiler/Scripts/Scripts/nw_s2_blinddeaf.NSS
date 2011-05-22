//::///////////////////////////////////////////////
//:: Blindness and Deafness (Svirfneblin Racial Ability)
//:: [NW_S2_BlindDead.nss]
//:: Copyright (c) 2000 Bioware Corp.
//:://////////////////////////////////////////////
//:: Causes the target creature to make a Fort
//:: save or be blinded and deafened.
//:://////////////////////////////////////////////
//:: Created By: Preston Watamaniuk
//:: Created On: Jan 12, 2001
//:://////////////////////////////////////////////



// JLR-OEI 03/22/06: For GDD Update
// RPGplayer1 03/19/08: DC won't depend from primary ability of starting class (use CHA instead)


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


    //Declare major varibles
    object oTarget = GetSpellTargetObject();
    int nMetaMagic = GetMetaMagicFeat();
    int nDuration = GetTotalLevels(OBJECT_SELF, 1); //GetCasterLevel(OBJECT_SELF);
    int nDC = 14 + GetSpellLevel(SPELL_BLINDNESS_AND_DEAFNESS) + GetAbilityModifier(ABILITY_CHARISMA); //+4 from racial bonus
    effect eBlind =  EffectBlindness();
    effect eDeaf = EffectDeaf();
    //effect eVis = EffectVisualEffect(VFX_DUR_SPELL_BLIND_DEAF);
    effect eDur = EffectVisualEffect( VFX_DUR_SPELL_BLIND_DEAF );

    effect eLink = EffectLinkEffects(eBlind, eDeaf);
    eLink = EffectLinkEffects(eLink, eDur);
	if (spellsIsTarget(oTarget, SPELL_TARGET_STANDARDHOSTILE, OBJECT_SELF))
	{
        //Fire cast spell at event
        SignalEvent(oTarget, EventSpellCastAt(OBJECT_SELF, SPELL_BLINDNESS_AND_DEAFNESS));
        //Do SR check
        if (!MyResistSpell(OBJECT_SELF, oTarget))
        {
            // Make Fortitude save to negate
            if (!/*Fort Save*/ MySavingThrow(SAVING_THROW_FORT, oTarget, nDC))
            {
                //Metamagic check for duration
                if (nMetaMagic == METAMAGIC_EXTEND)
                {
                    nDuration = nDuration * 2;
                }
                //Apply visual and effects
                ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eLink, oTarget, RoundsToSeconds(nDuration));
                //ApplyEffectToObject(DURATION_TYPE_INSTANT, eVis, oTarget);
            }
        }
    }
}