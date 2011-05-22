//::///////////////////////////////////////////////
//:: Magic Vestment
//:: NW_S0_MagVest.nss
//:: Copyright (c) 2001 Bioware Corp.
//:://////////////////////////////////////////////
//:: [Description of File]
//:://////////////////////////////////////////////
//:: Created By: [Your Name]
//:: Created On: [date]
//:://////////////////////////////////////////////
//:: VFX Pass By: Preston W, On: June 22, 2001
// MDiekmann 7/27/07 - Added signal event
void main()
{
	object oTarget = GetSpellTargetObject();
	effect eVis = EffectVisualEffect(VFX_IMP_AC_BONUS);
	
	//Fire cast spell at event for the specified target
    SignalEvent(oTarget, EventSpellCastAt(OBJECT_SELF, GetSpellId(), FALSE));
	
	ApplyEffectToObject(DURATION_TYPE_INSTANT, eVis, oTarget);

}
