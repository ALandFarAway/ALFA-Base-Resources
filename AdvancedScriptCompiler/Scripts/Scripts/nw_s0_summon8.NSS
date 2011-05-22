//::///////////////////////////////////////////////
//:: Summon Monster VIII
//:: NW_S0_Summon8
//:: Copyright (c) 2001 Bioware Corp.
//:://////////////////////////////////////////////
/*
    Summons a greater earth elemental to fight for the character
*/
//:://////////////////////////////////////////////
//:: Created By: Preston Watamaniuk
//:: Created On: April 12, 2001
//:://////////////////////////////////////////////
//:: VFX Pass By: Preston W, On: June 25, 2001

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
    int nMetaMagic = GetMetaMagicFeat();
    int nDuration = GetCasterLevel(OBJECT_SELF);
    effect eSummon;
    int nRoll = d4();
    if(GetHasFeat(FEAT_ANIMAL_DOMAIN_POWER))
    {
        switch (nRoll)
        {
            case 1:
                eSummon = EffectSummonCreature("NW_S_AIRELDER");
            break;

            case 2:
                eSummon = EffectSummonCreature("NW_S_WATERELDER");
            break;

            case 3:
                eSummon = EffectSummonCreature("NW_S_EARTHELDER");
            break;

            case 4:
                eSummon = EffectSummonCreature("NW_S_FIREELDER");
            break;

        }
    }
    else
    {
        switch (nRoll)
        {
            case 1:
                eSummon = EffectSummonCreature("NW_S_AIRGREAT");
            break;

            case 2:
                eSummon = EffectSummonCreature("NW_S_WATERGREAT");
            break;

            case 3:
                eSummon = EffectSummonCreature("NW_S_EARTHGREAT");
            break;

            case 4:
                eSummon = EffectSummonCreature("NW_S_FIREGREAT");
            break;
        }
    }

    effect eVis = EffectVisualEffect(VFX_FNF_SUMMON_MONSTER_3);
    //Make metamagic check for extend
    if (nMetaMagic == METAMAGIC_EXTEND)
    {
        nDuration = nDuration *2;   //Duration is +100%
    }
    //Apply the VFX impact and summon effect
    ApplyEffectAtLocation(DURATION_TYPE_TEMPORARY, eVis, GetSpellTargetLocation());
    ApplyEffectAtLocation(DURATION_TYPE_TEMPORARY, eSummon, GetSpellTargetLocation(), TurnsToSeconds(nDuration));
}
