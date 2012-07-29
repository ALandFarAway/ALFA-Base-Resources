#include "x2_inc_spellhook" 
#include "acr_spells_i"

void main()
{
	if (!X2PreSpellCastCode()) return;
	
	float fDuration = ACR_GetSpellDuration(OBJECT_SELF, ACR_DURATION_TYPE_PER_CL, ACR_DURATION_1H);
	effect noEffect;
	object oTarget = GetSpellTargetObject();
	int nSpellId = GetSpellId();
	RemoveEffectsFromSpell(oTarget, nSpellId);
	PersistACBonusFromSpell(oTarget, nSpellId, AC_ARMOUR_ENCHANTMENT_BONUS, 6, fDuration, noEffect);
}