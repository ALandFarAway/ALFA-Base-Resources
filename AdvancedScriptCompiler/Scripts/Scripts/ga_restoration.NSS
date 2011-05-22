

//ga_restoration

// "casts" greater restoration on the target.

// Parameter breakdown:
//			sTarget - tag of the creature to restore. GetTarget() parameters can be used, like $PC_SPEAKER or $OWNER
//			bFactionWide - if 1, the entire faction of sTarget gets restored as well. This Can restore the entire PC party,
//							which include companions and MP members.
//			bGroupWide - if 1, the entire group of the target is healed (if you are using ginc_group)
//			bSupressVFX - if 1, the visual effect of restoration in not played on those restored. In case you want to sly it.

// DBR 8/25/06




#include "ginc_param_const"
#include "ginc_group"

void RestoreCreature(object oCreature, int bSupressVFX);



void main(string sTarget, int bFactionWide, int bGroupWide, int bSupressVFX)
{
	object oTarget = GetTarget(sTarget);
	if (!GetIsObjectValid(oTarget))
		return;
		
	if (bFactionWide)
	{
		object oFactionMember = GetFirstFactionMember(oTarget,FALSE);
		while (GetIsObjectValid(oFactionMember))
		{
			if (oFactionMember!=oTarget)
				RestoreCreature(oFactionMember,bSupressVFX);
			oFactionMember=GetNextFactionMember(oTarget,FALSE);
		}	
	}
	if (bGroupWide)
	{
		string sGroup = GetGroupName(oTarget);
		object oGroupMember = GetFirstInGroup(sGroup);
		while (GetIsObjectValid(oGroupMember))
		{
			if (oGroupMember!=oTarget)
				RestoreCreature(oGroupMember,bSupressVFX);		
			oGroupMember = GetNextInGroup(sGroup);
		}	
	}
		
	RestoreCreature(oTarget,bSupressVFX);
}

void RestoreCreature(object oCreature, int bSupressVFX)
{
    //Declare major variables
    effect eVisual = EffectVisualEffect(VFX_IMP_RESTORATION_GREATER);

    effect eBad = GetFirstEffect(oCreature);
    //Search for negative effects
    while(GetIsEffectValid(eBad))
    {
        if ((GetEffectType(eBad) == EFFECT_TYPE_ABILITY_DECREASE ||
            GetEffectType(eBad) == EFFECT_TYPE_AC_DECREASE ||
            GetEffectType(eBad) == EFFECT_TYPE_ATTACK_DECREASE ||
            GetEffectType(eBad) == EFFECT_TYPE_DAMAGE_DECREASE ||
            GetEffectType(eBad) == EFFECT_TYPE_DAMAGE_IMMUNITY_DECREASE ||
            GetEffectType(eBad) == EFFECT_TYPE_SAVING_THROW_DECREASE ||
            GetEffectType(eBad) == EFFECT_TYPE_SPELL_RESISTANCE_DECREASE ||
            GetEffectType(eBad) == EFFECT_TYPE_SKILL_DECREASE ||
            GetEffectType(eBad) == EFFECT_TYPE_BLINDNESS ||
            GetEffectType(eBad) == EFFECT_TYPE_DEAF ||
            GetEffectType(eBad) == EFFECT_TYPE_CURSE ||
            GetEffectType(eBad) == EFFECT_TYPE_DISEASE ||
            GetEffectType(eBad) == EFFECT_TYPE_POISON ||
            GetEffectType(eBad) == EFFECT_TYPE_PARALYZE ||
            GetEffectType(eBad) == EFFECT_TYPE_CHARMED ||
            GetEffectType(eBad) == EFFECT_TYPE_DOMINATED ||
            GetEffectType(eBad) == EFFECT_TYPE_DAZED ||
            GetEffectType(eBad) == EFFECT_TYPE_CONFUSED ||
            GetEffectType(eBad) == EFFECT_TYPE_FRIGHTENED ||
            GetEffectType(eBad) == EFFECT_TYPE_NEGATIVELEVEL ||
            GetEffectType(eBad) == EFFECT_TYPE_PARALYZE ||
            GetEffectType(eBad) == EFFECT_TYPE_SLOW ||
            GetEffectType(eBad) == EFFECT_TYPE_STUNNED) &&
            GetEffectSpellId(eBad) != SPELL_ENLARGE_PERSON &&
            GetEffectSpellId(eBad) != SPELL_RIGHTEOUS_MIGHT &&
            GetEffectSpellId(eBad) != SPELL_STONE_BODY &&
            GetEffectSpellId(eBad) != SPELL_IRON_BODY &&
            GetEffectSpellId(eBad) != 803)
        {
            //Remove effect if it is negative.
            //if(!GetIsSupernaturalCurse(eBad))	// HOTU-SPECIFIC
			RemoveEffect(oCreature, eBad);
			eBad = GetFirstEffect(oCreature);
        }
		else
        	eBad = GetNextEffect(oCreature);
    }
    if(GetRacialType(oCreature) != RACIAL_TYPE_UNDEAD)
    {
        //Apply the VFX impact and effects
        int nHeal = GetMaxHitPoints(oCreature) - GetCurrentHitPoints(oCreature);
        effect eHeal = EffectHeal(nHeal);
        ApplyEffectToObject(DURATION_TYPE_INSTANT, eHeal, oCreature);
    }
    //Fire cast spell at event for the specified target
    SignalEvent(oCreature, EventSpellCastAt(OBJECT_SELF, SPELL_GREATER_RESTORATION, FALSE));
	if (!bSupressVFX)
    	ApplyEffectToObject(DURATION_TYPE_INSTANT, eVisual, oCreature);
}