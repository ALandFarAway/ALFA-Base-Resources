//::///////////////////////////////////////////////
//:: Enhance Familiar
//:: NW_S0_EnhnceFam.nss
//:://////////////////////////////////////////////
/*
    Caster's Familiar receives +2 competence bonus
    to attack to-hit rolls, dmg rolls, saves, and
    +2 Dodge bonus to AC.
*/
//:://////////////////////////////////////////////
//:: Created By: Jesse Reynolds (JLR - OEI)
//:: Created On: June 11, 2005
//:://////////////////////////////////////////////
//:: VFX Pass By: Preston W, On: June 20, 2001

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
    int nDuration = nCasterLvl;
    int nMetaMagic = GetMetaMagicFeat();

    //Enter Metamagic conditions
    if (nMetaMagic == METAMAGIC_EXTEND)
    {
    	nDuration = nDuration *2; //Duration is +100%
    }

    // Find the Familiar!
    object oTarget = GetAssociate(ASSOCIATE_TYPE_FAMILIAR);
    if( oTarget != OBJECT_INVALID )
    {
        effect eAttack = EffectAttackIncrease(2);
        effect eDmg = EffectDamageIncrease(2, DAMAGE_TYPE_MAGICAL);
        effect eSave = EffectSavingThrowIncrease(SAVING_THROW_ALL, 1, SAVING_THROW_TYPE_ALL);
        effect eAC = EffectACIncrease(2, AC_DODGE_BONUS, AC_VS_DAMAGE_TYPE_ALL);
//        effect eDur = EffectVisualEffect(VFX_DUR_CESSATE_POSITIVE);

        effect eLink = EffectLinkEffects(eAttack, eDmg);
        eLink = EffectLinkEffects(eLink, eSave);
        eLink = EffectLinkEffects(eLink, eAC);
//        eLink = EffectLinkEffects(eLink, eDur);

//        effect eVis = EffectVisualEffect(VFX_IMP_HOLY_AID);

        //Fire cast spell at event for the specified target
        SignalEvent(oTarget, EventSpellCastAt(OBJECT_SELF, SPELL_ENHANCE_FAMILIAR, FALSE));

        //Apply the VFX impact and effects
//        ApplyEffectToObject(DURATION_TYPE_INSTANT, eVis, oTarget);
        ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eLink, oTarget, HoursToSeconds(nDuration));
    }
}
