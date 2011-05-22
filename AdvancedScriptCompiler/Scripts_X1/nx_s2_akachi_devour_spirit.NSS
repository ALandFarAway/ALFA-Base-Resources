// nx_s2_akachi_devour_spirit
/*
    Akachi's Spirit Eater Devour Spirit Feat
    
	Similar to standard devour spirit except for that it also takes players spirit energy 
   
*/
// MichaelD
// ChazM 5/30/07 - Mask of Betrayer Protects against Akachi's devour.
// JSH-OEI 7/5/07 - Checks to see if PC was the target before draining any spirit energy

#include "kinc_spirit_eater"
#include "nwn2_inc_spells"
#include "x0_i0_spells"
#include "x2_inc_spellhook"
#include "ginc_vars"

void main()
{
    if (!X2PreSpellCastCode())
    {   // If code within the PreSpellCastHook (i.e. UMD) reports FALSE, do not run this spell
        return;
    }
    
    object oCaster 	= OBJECT_SELF;
    object oTarget  = GetSpellTargetObject();
	object oPC		= GetSpiritEater();
	
	effect eHeal;
	
	string sItemTag = "nx1_mask_of_betrayer";// mask is protective against this spell
	int bTargetHasMask = GetIsItemEquipped(sItemTag, oTarget, TRUE);
	
	int nDamage;
    int nSpiritEnergy;
    int nTargetMaxHP = GetMaxHitPoints(oTarget);
    int nCurrentHP = GetCurrentHitPoints(oTarget);
    nDamage = (nTargetMaxHP * 15) / 100; // Target takes 15% of max
	eHeal = EffectHeal(nDamage); // heal yourself for whatever damage you inflicted
	nSpiritEnergy = -25;
    if (nDamage < 1)
        nDamage = 1;
   
    if (spellsIsTarget(oTarget, SPELL_TARGET_STANDARDHOSTILE, oCaster)
        && (GetObjectType(oTarget) == OBJECT_TYPE_CREATURE)
        && GetIsSoul(oTarget)
        )
    {
		// Visual effect on caster
	    effect eVis = EffectVisualEffect(VFX_CAST_SPELL_DEVOUR_SPIRIT);
	    ApplyEffectToObject(DURATION_TYPE_INSTANT, eVis, oCaster);
    
		// visual effect on target
    	effect eBeam = EffectBeam(VFX_HIT_SPELL_DEVOUR_SPIRIT, oCaster, BODY_NODE_HAND);
    	DelayCommand(VFX_SE_HIT_DELAY, ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eBeam, oTarget, VFX_SE_HIT_DURATION));

    	// apply effects 
    	effect eDam = EffectDamage(nDamage, DAMAGE_TYPE_NEGATIVE);
		effect eHit = EffectNWN2SpecialEffectFile("fx_a_akachi_eater_hit_b_bk");
		ApplyEffectToObject(DURATION_TYPE_INSTANT, eHit, oTarget);
    	ApplyEffectToObject(DURATION_TYPE_INSTANT, eDam, oTarget);
		ApplyEffectToObject(DURATION_TYPE_INSTANT, eHeal, oCaster);
		
		// spirit energy loss is reduced if target has mask of the betrayer
		if (bTargetHasMask)
		{
	    	nSpiritEnergy = -12;
	   	}
		
		// Check to see if target was the PC
		if (GetOwnedCharacter(GetFactionLeader(oPC)) == oTarget)
		{
			UpdateSpiritEaterPoints(IntToFloat(nSpiritEnergy));
		}
		
	    //Fire cast spell at event for the specified target
	    SignalEvent(oTarget, EventSpellCastAt(oCaster, GetSpellId(), TRUE));
    }
    else
    {   // used on invalid target, so abort and give back.
        PostFeedbackStrRef(oCaster, STR_REF_INVALID_TARGET);
        return;
    }
}