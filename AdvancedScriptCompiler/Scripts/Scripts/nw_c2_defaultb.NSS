//::///////////////////////////////////////////////
//:: Default: On Spell Cast At
//:: NW_C2_DEFAULTB
//:: Copyright (c) 2001 Bioware Corp.
//:://////////////////////////////////////////////
/*
    This determines if the spell just cast at the
    target is harmful or not.

    GZ 2003-Oct-02 : - New AoE Behavior AI. Will use
                       Dispel Magic against AOES 
                     - Flying Creatures will ignore
                       Grease

*/
//:://////////////////////////////////////////////
//:: Created By: Preston Watamaniuk
//:: Created On: Dec 6, 2001
//:: Last Modified On: 2003-Oct-13
//:://////////////////////////////////////////////
// ChazM - 4/21/05 modified so NPC's can stay focused
// DBR 5/30/06 Added check to GetIsValidRetaliationTarget() as a fix for force attacking quest-giving NPC's
// ChazM - 1/26/07 - moved some shared code to ginc_behavior

//#include "nw_i0_generic"
//#include "x2_i0_spells"
#include "ginc_behavior"


void main()
{
    object oCaster = GetLastSpellCaster();
	int nSpellID = GetLastSpell();

    int iFocused = GetIsFocused();

	// spell cast at me so no longer partially focused
	if (iFocused == FOCUSED_PARTIAL)
		SetLocalInt(OBJECT_SELF, VAR_FOCUSED, FOCUSED_STANDARD); // no longer focused

    if (iFocused == 2) {
        // remain focused
    }
    else if(GetLastSpellHarmful())
    {
		ReactToHarmfulSpell(oCaster, nSpellID, FALSE, FALSE); // starndard creature aren't player interruptible and don't use henchman AI
    }
    else // spell was not harmful
    {
        // ---------------------------------------------------------------------
        // July 14, 2003 BK
        // If there is a valid enemy nearby and a NON HARMFUL spell has been
        // cast on me  I should call DetermineCombatRound
        // I may be invisible and casting spells on myself to buff myself up
        // ---------------------------------------------------------------------
        // Fix: JE - let's only do this if I'm currently in combat. If I'm not
        // in combat, and something casts a spell on me, it'll make me search
        // out the nearest enemy, no matter where they are on the level, which
        // is kinda dumb.
        object oEnemy =GetNearestEnemy();
        if ((GetIsObjectValid(oEnemy) == TRUE) && (GetIsInCombat() == TRUE))
        {
           // SpeakString("keep me in combat");
            DetermineCombatRound(oEnemy);
        }
    }

    // Send the user-defined event as appropriate
    if(GetSpawnInCondition(NW_FLAG_SPELL_CAST_AT_EVENT))
    {
        SignalEvent(OBJECT_SELF, EventUserDefined(EVENT_SPELL_CAST_AT));
    }


}