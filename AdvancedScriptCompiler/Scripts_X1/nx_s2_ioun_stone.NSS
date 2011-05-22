//::///////////////////////////////////////////////
//:: Ioun Stone
//:: nx_s2_ioun_stone.nss
//:: Copyright (c) 2007 Obsidian Entertainment, Inc.
//:://////////////////////////////////////////////
/*
     Applies the proper Ioun Stone VFX to the
     bearer of an Ioun Stone when granted the
     associated Ioun Stone feat.
*/
//:://////////////////////////////////////////////
//:: Created By: Andrew Woo (AFW-OEI)
//:: Created On: 02/28/2007
//:://////////////////////////////////////////////

#include "nw_i0_spells"
#include "x2_inc_spellhook"

void main()
{
    if (!X2PreSpellCastCode())
    {	// If code within the PreSpellCastHook (i.e. UMD) reports FALSE, do not run this spell
        return;
    }
    
    object oTarget  = GetSpellTargetObject();
    int    nSpellId = GetSpellId();

    // Toggle the VFX
	if (GetHasSpellEffect(nSpellId, oTarget))
    {
        RemoveSpellEffects(nSpellId, oTarget, oTarget);
    }
    else
	{
        int nVFX = VFX_DUR_IOUN_STONE_STR;
        switch(nSpellId)
        {
            case SPELLABILITY_IOUN_STONE_STR: nVFX = VFX_DUR_IOUN_STONE_STR; break;
            case SPELLABILITY_IOUN_STONE_DEX: nVFX = VFX_DUR_IOUN_STONE_DEX; break;
            case SPELLABILITY_IOUN_STONE_CON: nVFX = VFX_DUR_IOUN_STONE_CON; break;
            case SPELLABILITY_IOUN_STONE_INT: nVFX = VFX_DUR_IOUN_STONE_INT; break;
            case SPELLABILITY_IOUN_STONE_WIS: nVFX = VFX_DUR_IOUN_STONE_WIS; break;
            case SPELLABILITY_IOUN_STONE_CHA: nVFX = VFX_DUR_IOUN_STONE_CHA; break;
        }
        
		effect eVFX = EffectVisualEffect(nVFX);
               eVFX = ExtraordinaryEffect(eVFX);    // Should not be dispellable.
	    ApplyEffectToObject(DURATION_TYPE_PERMANENT, eVFX, oTarget);
	}
}