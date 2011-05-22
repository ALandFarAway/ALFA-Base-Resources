//::///////////////////////////////////////////////
//:: Blessed of Waukeen Halo
//:: nw_s0_waukeen.nss
//:: Copyright (c) 2001 Obsidian Entertainment Inc.
//:://////////////////////////////////////////////
/*
	The Blessed of Waukeen are able to conjure
	a small golden light for five minutes at a time.

*/
//:://////////////////////////////////////////////
//:: Created By: Patrick Mills
//:: Created On: Aug 31, 2006
//:://////////////////////////////////////////////


#include "x2_inc_spellhook"

void main()
{
   // If code within the PreSpellCastHook (i.e. UMD) reports FALSE, do not run
    // this spell.
    if (!X2PreSpellCastCode())
    {
        return;
    }

    object oCaster = OBJECT_SELF;

    
    effect eVis = EffectVisualEffect(902);

    int nDuration = 5;
    ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eVis, oCaster, TurnsToSeconds(nDuration));
}