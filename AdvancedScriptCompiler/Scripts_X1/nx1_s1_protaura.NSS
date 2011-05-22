// Protective Aura
// nx1_s1_protaura
//
// The protective aura which surrounds angels (solars, planetars, etc.)
//
// JSH-OEI 6/6/07
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
	
    if (!GetHasSpellEffect(201, OBJECT_SELF)) // 201 = Protective Aura
	{
		effect eAOE = EffectAreaOfEffect(AOE_MOB_PROTECTION);
		SignalEvent(oTarget, EventSpellCastAt(OBJECT_SELF, 201, FALSE));
    	ApplyEffectToObject(DURATION_TYPE_PERMANENT, eAOE, oTarget);
	}
}