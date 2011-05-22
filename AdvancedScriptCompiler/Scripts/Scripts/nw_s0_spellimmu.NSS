//::///////////////////////////////////////////////
//:: Spell Immunity
//:: NW_S0_SpellImmu.nss
//:://////////////////////////////////////////////
/*
    Target gains Immunity to certain spells:
    Lvl  7: Fireball, Magic Missile
    Lvl 10: Lightning Bolt, Web
    Lvl 13: Stinking Cloud, Grease
*/
//:://////////////////////////////////////////////
//:: Created By: Jesse Reynolds (JLR - OEI)
//:: Created On: July 16, 2005
//:://////////////////////////////////////////////
//:: VFX Pass By: Preston W, On: June 20, 2001


// JLR - OEI 08/24/05 -- Metamagic changes
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

    effect eImmu1 = EffectSpellImmunity(SPELL_FIREBALL);
    effect eImmu2 = EffectSpellImmunity(SPELL_MAGIC_MISSILE);
    effect eLink = EffectLinkEffects(eImmu1, eImmu2);

    if ( nCasterLvl >= 10 )
    {
        effect eImmu3 = EffectSpellImmunity(SPELL_LIGHTNING_BOLT);
        effect eImmu4 = EffectSpellImmunity(SPELL_WEB);
        eLink = EffectLinkEffects(eLink, eImmu3);
        eLink = EffectLinkEffects(eLink, eImmu4);
        if ( nCasterLvl >= 13 )
        {
            effect eImmu5 = EffectSpellImmunity(SPELL_STINKING_CLOUD);
            effect eImmu6 = EffectSpellImmunity(SPELL_GREASE);
            eLink = EffectLinkEffects(eLink, eImmu5);
            eLink = EffectLinkEffects(eLink, eImmu6);
        }
    }

    effect eDur = EffectVisualEffect(VFX_DUR_CESSATE_POSITIVE);
    eLink = EffectLinkEffects(eLink, eDur);

    //Fire cast spell at event for the specified target
    SignalEvent(oTarget, EventSpellCastAt(OBJECT_SELF, GetSpellId(), FALSE));

    //Apply the VFX impact and effects
    ApplyEffectToObject(nDurType, eLink, oTarget, fDuration);
}
