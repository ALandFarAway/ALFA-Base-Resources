// Protective Aura
// nx1_s1_protaura
//
// The protective aura which surrounds angels (solars, planetars, etc.)
//
// NLC-OEI 3/17/08
// Original Script By: Preston Watamaniuk

#include "NW_I0_SPELLS"
#include "x2_inc_spellhook"

void main()
{
    object oTarget = GetSpellTargetObject(); 
    
	if (!X2PreSpellCastCode())
    {
	// If code within the PreSpellCastHook (i.e. UMD) reports FALSE, do not run this spell
        return;
    }
	
    if (!GetHasSpellEffect(325, OBJECT_SELF)) // 325 = Drowned Aura
	{
		effect eAOE = EffectAreaOfEffect(AOE_MOB_DROWNED_AURA);
		SignalEvent(oTarget, EventSpellCastAt(OBJECT_SELF, 325, FALSE));
    	ApplyEffectToObject(DURATION_TYPE_PERMANENT, eAOE, oTarget);
	}
}