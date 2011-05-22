//:://////////////////////////////////////////////////////////////////////////
//:: Rescue
//:: nx_s2_rescue
//:: Created By: Andrew Woo (AFW-OEI)
//:: Created On: 02/27/2007
//:: Copyright (c) 2007 Obsidian Entertainment Inc.
//:://////////////////////////////////////////////////////////////////////////
/*
    When Rescue Mode is activated (a free action), allies within 5 ft. take
    half damage; the amount of damage not taken by your allies is taken by you.
     You also gain DR 2/- while in Rescue Mode.
*/
//:: AFW-OEI 07/17/2007: NX1 VFX; up radius to 10'.

#include "x0_i0_spells"
#include "nwn2_inc_spells"

int CanRescue( object oRescuer )
{
    if ( GetHasEffect(EFFECT_TYPE_PARALYZE, oRescuer)	||
 		 GetHasEffect(EFFECT_TYPE_STUNNED, oRescuer)	||
		 GetHasEffect(EFFECT_TYPE_SLEEP, oRescuer)		||
		 GetHasEffect(EFFECT_TYPE_PETRIFY, oRescuer) )
		
	{
 		FloatingTextStrRefOnCreature(112849, oRescuer); // * You can not use this feat at this time *
		return FALSE;
	}

	return TRUE;
}

int ToggleRescue ( object oRescuer )
{
    int nRescueSpellId = FindEffectSpellId(EFFECT_TYPE_RESCUE, oRescuer);

    // Rescue is on, so toggle it off.
    if (nRescueSpellId != -1)
    {
        effect eCheck = GetFirstEffect(oRescuer);
        while (GetIsEffectValid(eCheck))
        {
            if (GetEffectType(eCheck) == EFFECT_TYPE_RESCUE)
            {
                RemoveEffect(oRescuer, eCheck);
            }
            
            eCheck = GetNextEffect(oRescuer);
        }
        return FALSE;
    }
    // Didn't find any Rescue effects, so turn it on.
    else
    {
        effect eRescue = EffectRescue(GetSpellId());
		effect eDur    = EffectVisualEffect(VFX_DUR_RESCUER);
		eRescue = EffectLinkEffects(eRescue, eDur);
        ApplyEffectToObject(DURATION_TYPE_PERMANENT, eRescue, oRescuer);
        return TRUE;
    }
}

void RunRescue(object oRescuer, int nSpellId)
{
	if ( !CanRescue( oRescuer ) )
	{
		return;	
	}
    
    // Make sure we still have an active Rescue Mode effect
    int nRescueSpellId = FindEffectSpellId(EFFECT_TYPE_RESCUE);
    if (nRescueSpellId != nSpellId)
    {   // Exit out if Rescue Mode is off.
        return;
    }
    
    float fDuration = 4.0;  // 4 seconds for each pulse.
    location lRescuerLocation = GetLocation(oRescuer);
    
    effect eDR = EffectDamageReduction(2, DAMAGE_POWER_NORMAL, 0, DR_TYPE_NONE); // DR 2/-
           eDR = ExtraordinaryEffect(eDR);
           
    effect eShare = EffectShareDamage(oRescuer);
           eShare = ExtraordinaryEffect(eShare);
    effect eVFX   = EffectBeam(VFX_BEAM_RESCUEE, oRescuer, BODY_NODE_CHEST);
           eVFX   = ExtraordinaryEffect(eVFX);
    effect eLink  = EffectLinkEffects(eShare, eVFX);
           eLink  = SetEffectSpellId(eLink, nSpellId);
    
    // See if the rescuer has any effects other than the placeholder EFFECT_RESCUE. 
    int bRescuerAlreadyHasRescueEffects = FALSE;
    effect eCheck = GetFirstEffect(oRescuer);
    while (GetIsEffectValid(eCheck))
    {
        if (GetEffectSpellId(eCheck) == nSpellId && GetEffectType(eCheck) != EFFECT_TYPE_RESCUE)
        {
            bRescuerAlreadyHasRescueEffects = TRUE;
            break;
        }   
        eCheck = GetNextEffect(oRescuer);
    }
    
    // Apply Rescue effects
    object oTarget = GetFirstObjectInShape(SHAPE_SPHERE, RADIUS_SIZE_MEDIUM, lRescuerLocation);
    while (GetIsObjectValid(oTarget))
    {
        if (!GetIsDead(oTarget))
        {
            if (!GetHasSpellEffect(nSpellId, oTarget) || (oTarget == oRescuer && !bRescuerAlreadyHasRescueEffects))
            {   // Target either has no Rescue effects yet, or is the Rescuer who has no real Rescue effects yet.
                if (oTarget == oRescuer)
                {   // Rescuer gets DR
                    ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eDR, oTarget, fDuration);
                }
                else if (spellsIsTarget(oTarget, SPELL_TARGET_ALLALLIES, oRescuer))
                {   // Everyone else gets a Share Damage effect
                    SignalEvent(oTarget, EventSpellCastAt(oRescuer, nSpellId, FALSE));
                    ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eLink, oTarget, fDuration);    // Share damage & VFX
                }
            }
            else
            {   // Refresh Rescue effect durations.
                RefreshSpellEffectDurations(oTarget, nSpellId, fDuration);
            }
        }
    
        oTarget = GetNextObjectInShape(SHAPE_SPHERE, RADIUS_SIZE_MEDIUM, lRescuerLocation);
    }
	
    // Schedule the next ping
    DelayCommand(2.5f, RunRescue(oRescuer, nSpellId));
}


void main()
{
    if (!CanRescue( OBJECT_SELF ))
	{
		return;	
	}
    
    if (ToggleRescue(OBJECT_SELF))
    {
		DelayCommand(0.1f, RunRescue(OBJECT_SELF, GetSpellId()));
    }
}