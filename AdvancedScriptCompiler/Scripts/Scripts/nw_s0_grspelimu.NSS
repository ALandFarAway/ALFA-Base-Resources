//::///////////////////////////////////////////////
//:: Greater Spell Immunity
//:: NW_S0_GrSpelImu.nss
//:://////////////////////////////////////////////
/*
    Target gains Immunity to certain spells:
    Lvl 15: Harm, Blade Barrier, Cone of Cold, Delayed Blast Fireball
    Lvl 17: Chain Lightning, Earthquake
    Lvl 20: Polar Ray, Firestorm
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
    object oTarget = GetSpellTargetObject();
    int nCasterLvl = GetCasterLevel(OBJECT_SELF);
    float fDuration = TurnsToSeconds(nCasterLvl * 10);

    //Enter Metamagic conditions
    fDuration = ApplyMetamagicDurationMods(fDuration);
    int nDurType = ApplyMetamagicDurationTypeMods(DURATION_TYPE_TEMPORARY);

    effect eImmu1 = EffectSpellImmunity(SPELL_HARM);
    effect eImmu2 = EffectSpellImmunity(SPELL_BLADE_BARRIER);
    effect eImmu3 = EffectSpellImmunity(SPELL_CONE_OF_COLD);
    effect eImmu4 = EffectSpellImmunity(SPELL_DELAYED_BLAST_FIREBALL);
    effect eLink = EffectLinkEffects(eImmu1, eImmu2);
    eLink = EffectLinkEffects(eLink, eImmu3);
    eLink = EffectLinkEffects(eLink, eImmu4);

    if ( nCasterLvl >= 17 )
    {
        effect eImmu5 = EffectSpellImmunity(SPELL_CHAIN_LIGHTNING);
        effect eImmu6 = EffectSpellImmunity(SPELL_EARTHQUAKE);
        eLink = EffectLinkEffects(eLink, eImmu5);
        eLink = EffectLinkEffects(eLink, eImmu6);
        if ( nCasterLvl >= 20 )
        {
            effect eImmu7 = EffectSpellImmunity(SPELL_POLAR_RAY);
            effect eImmu8 = EffectSpellImmunity(SPELL_FIRE_STORM);
            eLink = EffectLinkEffects(eLink, eImmu7);
            eLink = EffectLinkEffects(eLink, eImmu8);
        }
    }

    effect eDur = EffectVisualEffect(VFX_DUR_CESSATE_POSITIVE);
    eLink = EffectLinkEffects(eLink, eDur);

    //Fire cast spell at event for the specified target
    SignalEvent(oTarget, EventSpellCastAt(OBJECT_SELF, GetSpellId(), FALSE));

    //Apply the VFX impact and effects
    ApplyEffectToObject(nDurType, eLink, oTarget, fDuration);
}
