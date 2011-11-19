//::///////////////////////////////////////////////
//:: Shadow Conjuration
//:: NW_S0_ShadConj.nss
//:: Copyright (c) 2001 Bioware Corp.
//:://////////////////////////////////////////////
/*
    If the opponent is clicked on Shadow Bolt is cast.
    If the caster clicks on himself he will cast
    Mage Armor and Mirror Image.  If they click on
    the ground they will summon a Shadow.
*/
//:://////////////////////////////////////////////
//:: Created By: Preston Watamaniuk
//:: Created On: April 12, 2001
//:://////////////////////////////////////////////
//:: VFX Pass By: Preston W, On: June 25, 2001
//:: AFW-OEI 06/02/2006:
//::	Update creature blueprint
//::	Changed summon duration from hours to 3 + CL rounds

// JLR - OEI 08/24/05 -- Metamagic changes
#include "nwn2_inc_spells"


//void ShadowBolt (object oTarget, int nMetaMagic);

void main()
{
    int nMetaMagic = GetMetaMagicFeat();
    object oTarget = GetSpellTargetObject();
    int nCast;
	int nCasterLevel = GetCasterLevel(OBJECT_SELF);
    float fDuration = HoursToSeconds(nCasterLevel);
	float fSummonDuration = RoundsToSeconds(nCasterLevel + 3);
    effect eVis;

    fDuration = ApplyMetamagicDurationMods(fDuration);
	fSummonDuration = ApplyMetamagicDurationMods(fSummonDuration);
    int nDurType = ApplyMetamagicDurationTypeMods(DURATION_TYPE_TEMPORARY);

	/*
    if (GetIsObjectValid(oTarget))
    {
        if (oTarget == OBJECT_SELF)
        {
            nCast = 1;
        }
        else
        {
            nCast = 2;
        }
    }
    else
    {
        nCast = 3;
    }

    switch (nCast)
    {
        case 1:
			{
	            //eVis = EffectVisualEffect(VFX_IMP_AC_BONUS);
	            effect eAC = EffectACIncrease(4, AC_ARMOUR_ENCHANTMENT_BONUS);
	            effect eMirror = EffectVisualEffect(VFX_DUR_SPELL_MAGE_ARMOR);
	            effect eLink = EffectLinkEffects(eAC, eMirror);
	            //eLink = EffectLinkEffects(eLink, eVis);
	            ApplyEffectToObject(nDurType, eLink, OBJECT_SELF, fDuration);
			}
            break;
        case 2:
			{
	            if (!ResistSpell(OBJECT_SELF, oTarget))
		        {
	               ShadowBolt(oTarget, nMetaMagic);
				}
			}
            break;
        case 3:
			{
	            //eVis = EffectVisualEffect(VFX_HIT_SPELL_SUMMON_CREATURE);
	            int nCasterLevel = GetCasterLevel(OBJECT_SELF);
	            effect eSummon = EffectSummonCreature("c_shadow7", VFX_HIT_SPELL_SUMMON_CREATURE);
	            ApplyEffectAtLocation(nDurType, eSummon, GetSpellTargetLocation(), fSummonDuration);
	            //ApplyEffectAtLocation(DURATION_TYPE_INSTANT, eVis, GetSpellTargetLocation());
			}
            break;
    }*/
}

/*void ShadowBolt (object oTarget, int nMetaMagic)
{
    int nDamage;
    int nBolts = GetCasterLevel(OBJECT_SELF)/5;
    int nCnt;
    effect eVis2 = EffectVisualEffect(VFX_HIT_SPELL_EVIL);
    effect eDam;
    effect eBeam = EffectBeam(VFX_BEAM_EVIL, OBJECT_SELF, BODY_NODE_HAND);
    for (nCnt = 0; nCnt < nBolts; nCnt++)
    {
        int nDam = d6(2);
        //Enter Metamagic conditions
        nDamage = ApplyMetamagicVariableMods(nDamage, 12);
        if (ReflexSave(oTarget, GetSpellSaveDC()))
        {
            nDamage = nDamage/2;
        }
        eDam = EffectDamage(nDamage, DAMAGE_TYPE_NEGATIVE);
        DelayCommand(IntToFloat(nCnt), ApplyEffectToObject(DURATION_TYPE_INSTANT, eVis2, oTarget));
        DelayCommand(IntToFloat(nCnt), ApplyEffectToObject(DURATION_TYPE_INSTANT, eDam, oTarget));
    }
    ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eBeam, oTarget, 3.5);
}*/