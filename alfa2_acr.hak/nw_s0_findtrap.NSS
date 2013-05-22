//::///////////////////////////////////////////////
//:: Find Traps
//:: NW_S0_FindTrap
//:: Copyright (c) 2001 Bioware Corp.
//:://////////////////////////////////////////////
/*
    Finds and removes all traps within 30m.
*/
//:://////////////////////////////////////////////
//:: Created By: Preston Watamaniuk
//:: Created On: Oct 29, 2001
//:://////////////////////////////////////////////

// JLR - OEI 08/24/05 -- Metamagic changes
#include "nwn2_inc_spells"
#include "acr_spells_i"

void main()
{
    if (!X2PreSpellCastCode())
    {
	// If code within the PreSpellCastHook (i.e. UMD) reports FALSE, do not run this spell
        return;
    }

// End of Spell Cast Hook

	// Firstly, reveal all of the old traps. We need to be backward compatible, and they don't 
	// respect Find Traps as rogue trapfinding, so we just act like the old spell and reveal
	// all of them.
	
    effect eVis = EffectVisualEffect( VFX_DUR_SPELL_FIND_TRAPS );	// NWN2 VFX
    int nCnt = 1;
    object oTrap = GetNearestObject(OBJECT_TYPE_TRIGGER | OBJECT_TYPE_DOOR | OBJECT_TYPE_PLACEABLE, OBJECT_SELF, nCnt);
    while( GetIsObjectValid(oTrap) && GetTrapDetectable(oTrap) )	// 8/1/06 - BDF: added GetTrapDetectable check
    {
        if(GetIsTrapped(oTrap))
        {
            SetTrapDetectedBy(oTrap, OBJECT_SELF);
            ApplyEffectAtLocation(DURATION_TYPE_INSTANT, eVis, GetLocation(oTrap));	// DURATION_TYPE_INSTANT will cause only the impact SEF to play, which is OK in this case
            //DelayCommand(2.0, SetTrapDisabled(oTrap));
        }
        nCnt++;
        oTrap = GetNearestObject(OBJECT_TYPE_TRIGGER | OBJECT_TYPE_DOOR | OBJECT_TYPE_PLACEABLE, OBJECT_SELF, nCnt);
    }
	
	// Next, SetTrapDetectedBy doesn't actually reveal new traps, because we wanted to make them harder. 
	// to find than stock NWN2. Against those, you just get +1 search/2 caster levels. ACR_Traps includes
	// a check for the Find Traps spell, allowing detection of DC 20+ new traps while the spell is active.
	int nBonus = ACR_GetCorrectCasterLevel(OBJECT_SELF)/2;
	if(nBonus > 10) nBonus = 10;
	
	float fDuration = ACR_GetSpellDuration( OBJECT_SELF, ACR_DURATION_TYPE_PER_CL, 60.0f );
	
	ApplyEffectToObject(DURATION_TYPE_TEMPORARY, EffectSkillIncrease(SKILL_SEARCH, nBonus), OBJECT_SELF, fDuration);
	ApplyEffectToObject(DURATION_TYPE_INSTANT, eVis, OBJECT_SELF);
}