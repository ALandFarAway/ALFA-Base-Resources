#include "nwn2_inc_spells"
#include "nw_i0_spells"
#include "x2_inc_spellhook" 
#include "acr_spells_i"

void main()
{
	if (!ACR_PrecastEvent()) return;
	
	float fDuration = ACR_GetSpellDuration(OBJECT_SELF, ACR_DURATION_TYPE_PER_CL, ACR_DURATION_1M);
	object oTarget = GetSpellTargetObject();
	int nSpellId = GetSpellId();
	RemoveEffectsFromSpell(oTarget, nSpellId);
	PersistACBonusFromSpell(oTarget, nSpellId, AC_SHIELD_ENCHANTMENT_BONUS, 4, fDuration, EffectSpellImmunity(SPELL_MAGIC_MISSILE));
}
