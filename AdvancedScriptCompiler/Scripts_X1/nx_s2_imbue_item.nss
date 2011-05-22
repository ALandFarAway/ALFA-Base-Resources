//:://////////////////////////////////////////////////////////////////////////
//:: Imbue Item
//:: nx_s2_imbue_item
//:: Created By: Andrew Woo (AFW-OEI)
//:: Created On: 02/28/2007
//:: Copyright (c) 2007 Obsidian Entertainment Inc.
//:://////////////////////////////////////////////////////////////////////////
/*
    This is the spell script called when you use the Warlock feat Imbue Item;
    it is intended to replace the need for spell prereqs for item creation.
    
    And indeed it shall! Muhahaha!
*/
// ChazM 3/14/07

const int SPELL_IMBUE_ITEM = 1081; 

#include "x2_inc_spellhook"

void main()
{
    object oTarget = GetSpellTargetObject();

   // If code within the PreSpellCastHook (i.e. UMD) reports FALSE, do not run
    // this spell.
    if (!X2PreSpellCastCode())
    {
        return;
    }

    // SpeakString("I am the spell script stub for nx_s2_imbue_item called when you use the Imbue Item feat.");
    
    //Fire cast spell at event for the specified target
    SignalEvent(oTarget, EventSpellCastAt(OBJECT_SELF, SPELL_IMBUE_ITEM, FALSE));
    
}