//::///////////////////////////////////////////////
//:: Create Greater Undead
//:: NW_S0_CrGrUnd.nss
//:: Copyright (c) 2005 Obsidian Entertainment
//:://////////////////////////////////////////////
/*
    Summons an undead type pegged to the character's
    level.
*/
//:://////////////////////////////////////////////
//:: Created By: Preston Watamaniuk
//:: Created On: April 12, 2001
//:://////////////////////////////////////////////

//:://////////////////////////////////////////////
//:: Update By: Brock H. - OEI
//:: Update On: 10/07/05
//:: Changed summoned creature resrefs
//:://////////////////////////////////////////////
//:: AFW-OEI 06/02/2006:
//::	Updated creature blueprints
//::	Changed duration from 24 hours to CL hours
//:: JSH-OEI 11/11/2008:
//::	Now summons a 15 HD vampire warrior or warlock only.


#include "x2_inc_spellhook" 

void main()
{

    if (!X2PreSpellCastCode())
    {
		// If code within the PreSpellCastHook (i.e. UMD) reports FALSE, do not run this spell
        return;
    }


    //Declare major variables
    int nMetaMagic = GetMetaMagicFeat();
    int nCasterLevel = GetCasterLevel(OBJECT_SELF);
    int nDuration = nCasterLevel;
	int nRoll = d2();
    //nDuration = 24;
    effect eSummon;
    
    //Make metamagic extend check
    if (nMetaMagic == METAMAGIC_EXTEND)
    {
        nDuration = nDuration *2;	//Duration is +100%
    }
    //Determine undead to summon based on level
    /*if (nCasterLevel <= 15)
    {
        eSummon = EffectSummonCreature("c_shadow",VFX_HIT_SPELL_SUMMON_CREATURE);
    }
    else if ((nCasterLevel >= 16) && (nCasterLevel <= 17))
    {
        eSummon = EffectSummonCreature("c_wraith",VFX_HIT_SPELL_SUMMON_CREATURE);
    }
    else if ((nCasterLevel >= 18) && (nCasterLevel <= 19))
    {
        eSummon = EffectSummonCreature("c_vampirem",VFX_HIT_SPELL_SUMMON_CREATURE);
    }
    else
    {
        eSummon = EffectSummonCreature("c_vampireelite",VFX_HIT_SPELL_SUMMON_CREATURE);
    }*/
    
	switch (nRoll)
	{
		case 1:
			eSummon = EffectSummonCreature("c_s_vampire_warrior", VFX_HIT_SPELL_SUMMON_CREATURE);
			break;
		case 2:
			eSummon = EffectSummonCreature("c_s_vampire_warlock", VFX_HIT_SPELL_SUMMON_CREATURE);
			break;
        default: 
			eSummon = EffectSummonCreature("c_s_vampire_warrior", VFX_HIT_SPELL_SUMMON_CREATURE);
			break;
	}
	
	//Apply summon effect and VFX impact.
    ApplyEffectAtLocation(DURATION_TYPE_TEMPORARY, eSummon, GetSpellTargetLocation(), RoundsToSeconds(nDuration));
    
}