#include "acr_death_i"
#include "x2_inc_spellhook"

// Because we do a dumb thing and keep all raising dead login in acr_death_i, this is just a copy of
// the OC Raise Dead spell.

void main() {

    if (!X2PreSpellCastCode())
    {
	// If code within the PreSpellCastHook (i.e. UMD) reports FALSE, do not run this spell
        return;
    }
	
    //Declare major variables
    object oTarget = GetSpellTargetObject();
    effect eRaise = EffectResurrection();
    effect eVis = EffectVisualEffect( VFX_HIT_SPELL_CONJURATION );	
	
	if(!ACR_GetIsCorpse(oTarget)) {
		SendMessageToPC(OBJECT_SELF, "Recall spirit can only be cast on dead player characters.");
		return;
	}

    //Fire cast spell at event for the specified target
    SignalEvent(oTarget, EventSpellCastAt(OBJECT_SELF, SPELL_RECALL_SPIRIT, FALSE));
    if(GetIsDead(oTarget))
    {
        //Apply raise dead effect and VFX impact
        ApplyEffectAtLocation(DURATION_TYPE_INSTANT, eVis, GetLocation(oTarget));
        ApplyEffectToObject(DURATION_TYPE_INSTANT, eRaise, oTarget);
    }
}