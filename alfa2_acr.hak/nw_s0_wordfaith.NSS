//::///////////////////////////////////////////////
//:: Word of Faith, Holy Word, Blasphemy, Dictum, Word of Chaos
//:: [NW_S0_WordFaith.nss]
//:: By: Zelknolf
//:: 12/28/2011
//:://////////////////////////////////////////////
/*
    This spell replaces the default Word of Faith spell
    from the original campaign, splitting it into the
    Holy word, Dictum, Blasphemy, and Word of Chaos spells.
    PCs / NPCs who aren't updated will have the script
    try to guess which spell they'd likely be casting.
*/
//:://////////////////////////////////////////////
#include "x2_inc_spellhook"
#include "acr_spells_i" 

int SPELL_HOLY_WORD     = 3114;
int SPELL_BLASPHEMY     = 3115;
int SPELL_DICTUM        = 3116;
int SPELL_WORD_OF_CHAOS = 3117;


void main()
{
    if(!ACR_PrecastEvent()) return;
	
    effect eUpper, eMid, eLow, eVFX, eAreaVFX;
    effect eDeath = EffectDeath();
    float fUpper = RoundsToSeconds(d4(1));
    float fMid   = RoundsToSeconds(d4(2));
    float fLow   = TurnsToSeconds(d10(1));
	
    int nSpell = GetSpellId();
    int nCasterLevel = GetCasterLevel(OBJECT_SELF);
    int nSaveDC = GetSpellSaveDC() + 4;
    int nSaveType;

    if(nSpell != SPELL_HOLY_WORD &&
       nSpell != SPELL_BLASPHEMY &&
       nSpell != SPELL_DICTUM &&
       nSpell != SPELL_WORD_OF_CHAOS)
    {
        int nGoodEvil = GetAlignmentGoodEvil(OBJECT_SELF);
    	int nLawChaos = GetAlignmentLawChaos(OBJECT_SELF);
	
        if(nGoodEvil == ALIGNMENT_EVIL)
            nSpell = SPELL_BLASPHEMY;
        else if(nGoodEvil == ALIGNMENT_GOOD)
            nSpell = SPELL_HOLY_WORD;
        else if(nLawChaos == ALIGNMENT_LAWFUL)
            nSpell = SPELL_DICTUM;
        else if(nLawChaos == ALIGNMENT_CHAOTIC)
            nSpell = SPELL_WORD_OF_CHAOS;
        else
            nSpell = SPELL_HOLY_WORD;
    }

    if(nSpell == SPELL_HOLY_WORD)
    {
        eUpper   = EffectDeaf();
        eMid     = EffectBlindness();
        eLow     = EffectParalyze();
        eVFX     = EffectVisualEffect(VFX_HIT_SPELL_HOLY);
        eAreaVFX = EffectVisualEffect(VFX_FNF_LOS_HOLY_30);
        nSaveType = SAVING_THROW_TYPE_GOOD;
        if(GetHasFeat(FEAT_GOOD_DOMAIN_POWER)) nCasterLevel++;
    }
    else if(nSpell == SPELL_BLASPHEMY)
    {
        eUpper   = EffectDazed();
        eMid     = EffectAbilityDecrease(ABILITY_STRENGTH, d6(2));
        eLow     = EffectParalyze();
        eVFX     = EffectVisualEffect(VFX_HIT_SPELL_EVIL);
        eAreaVFX = EffectVisualEffect(VFX_FNF_LOS_EVIL_30);
        fUpper   = 6.0f;
        nSaveType = SAVING_THROW_TYPE_EVIL;
        if(GetHasFeat(FEAT_EVIL_DOMAIN_POWER)) nCasterLevel++;
    }
    else if(nSpell == SPELL_DICTUM)
    {
        eUpper   = EffectDeaf();
        eMid     = EffectSlow();
        eLow     = EffectParalyze();
        eVFX     = EffectVisualEffect(VFX_HIT_SPELL_SONIC);
        eAreaVFX = EffectVisualEffect(VFX_FNF_LOS_NORMAL_30);
        nSaveType = SAVING_THROW_TYPE_LAW;
        if(GetHasFeat(FEAT_LAW_DOMAIN_POWER)) nCasterLevel++;
    }
    else if(nSpell == SPELL_WORD_OF_CHAOS)
    {
        eUpper   = EffectDeaf();
        eMid     = EffectStunned();
        eLow     = EffectConfused();
        eVFX     = EffectVisualEffect(VFX_HIT_SPELL_SONIC);
        eAreaVFX = EffectVisualEffect(VFX_FNF_LOS_NORMAL_30);
        fMid     = 6.0f;
        nSaveType = SAVING_THROW_TYPE_CHAOS;
        if(GetHasFeat(FEAT_CHAOS_DOMAIN_POWER)) nCasterLevel++;
    }

    location lSource = GetLocation(OBJECT_SELF);
    ApplyEffectAtLocation(DURATION_TYPE_INSTANT, eAreaVFX, lSource);	
    object oTarget = GetFirstObjectInShape(SHAPE_SPHERE, RADIUS_SIZE_COLOSSAL, lSource);
    while(GetIsObjectValid(oTarget))
    {
        if((nSpell == SPELL_HOLY_WORD     && GetAlignmentGoodEvil(oTarget) != ALIGNMENT_GOOD) ||
           (nSpell == SPELL_BLASPHEMY     && GetAlignmentGoodEvil(oTarget) != ALIGNMENT_EVIL) ||
           (nSpell == SPELL_DICTUM        && GetAlignmentLawChaos(oTarget) != ALIGNMENT_LAWFUL) ||
           (nSpell == SPELL_WORD_OF_CHAOS && GetAlignmentLawChaos(oTarget) != ALIGNMENT_CHAOTIC))
        {
            if(!ResistSpell(OBJECT_SELF, oTarget) && !GetHasSpellEffect(SPELL_SILENCE, oTarget))
            {
                if(GetRacialType(oTarget) == RACIAL_TYPE_OUTSIDER)
                {
                    if(!WillSave(oTarget, nSaveDC, nSaveType))
                    {
                        ApplyEffectToObject(DURATION_TYPE_INSTANT, eDeath, oTarget);
                        ApplyEffectToObject(DURATION_TYPE_INSTANT, eVFX, oTarget);
                    }
                }
                if(nCasterLevel >= GetHitDice(oTarget))
                {
                    ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eUpper, oTarget, fUpper);
                    ApplyEffectToObject(DURATION_TYPE_INSTANT, eVFX, oTarget);
                }
                if((nCasterLevel - 1)  >= GetHitDice(oTarget))
                    ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eMid, oTarget, fMid);
                if((nCasterLevel - 5)  >= GetHitDice(oTarget))
                    ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eLow, oTarget, fLow);
                if((nCasterLevel - 10) >= GetHitDice(oTarget))
                    ApplyEffectToObject(DURATION_TYPE_INSTANT, eDeath, oTarget);
            }
        }
        oTarget = GetNextObjectInShape(SHAPE_SPHERE, RADIUS_SIZE_COLOSSAL, lSource);
    }
}