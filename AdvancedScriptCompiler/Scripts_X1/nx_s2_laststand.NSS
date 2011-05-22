//::///////////////////////////////////////////////
//:: Last Stand
//:: nx_s2_laststand.nss
//:: Copyright (c) 2007 Obsidian Entertainment, Inc.
//:://////////////////////////////////////////////
/*
   The character and all party members gain 20d10 temporary hitpoints
   for 1 round per Cha bonus of the character. Minimum duration is 2 rounds.
   This ability can be used once per day and requires a standard action.
*/
//:://////////////////////////////////////////////
//:: Created By: Andrew Woo (AFW-OEI)
//:: Created On: 02/22/2007
//:://////////////////////////////////////////////

#include "nwn2_inc_spells"
#include "x0_i0_spells"
#include "x2_inc_spellhook"

void main()
{
    if (!X2PreSpellCastCode())
    {   // If code within the PreSpellCastHook (i.e. UMD) reports FALSE, do not run this spell
        return;
    }

    // Create the Effects
    int nHP = d10(20);
    effect eHP   = EffectTemporaryHitpoints(nHP);
    effect eDur  = EffectVisualEffect( VFX_DUR_SPELL_LAST_STAND );
    effect eLink = EffectLinkEffects(eHP, eDur);

    // Figure out duration of effect
    int nRounds = GetAbilityModifier (ABILITY_CHARISMA);
    if (nRounds < 2)
    {   // Lasts a minimum of 2 rounds.
        nRounds = 2;
    }
    
	float fDuration = RoundsToSeconds( nRounds );
    int nDurType = DURATION_TYPE_TEMPORARY;
    
    // Apply effects to everyone in your party
    int bPCOnly = FALSE;
    object oLeader = GetFactionLeader(OBJECT_SELF);
	object oTarget = GetFirstFactionMember(oLeader, bPCOnly);
	while (GetIsObjectValid(oTarget))
	{
    	if (spellsIsTarget(oTarget, SPELL_TARGET_ALLALLIES, OBJECT_SELF) &&
            !GetHasSpellEffect(SPELLABILITY_LAST_STAND, oTarget))               // Effects don't stack
		{
    		SignalEvent(oTarget, EventSpellCastAt( OBJECT_SELF, SPELLABILITY_LAST_STAND, FALSE ));
            ApplyEffectToObject(nDurType, eLink, oTarget, fDuration);
		}        	

        oTarget = GetNextFactionMember(oLeader, bPCOnly);
	}
 }