// nx_s3_scythe_devour_spirit
/*
    Akachi's Scythe has a lesser Devour Spirit power on it
    
	Similar to standard devour spirit except for that it also takes players spirit energy 
   
*/
// MichaelD
// ChazM 5/30/07 - Mask of Betrayer Protects against Akachi's devour.
// JSH-OEI 6/11/07 - Modified for use with Akachi's Scythe

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
	
	string sItemTag = "nx1_mask_of_betrayer";// mask is protective against this spell
	int bTargetHasMask = GetIsItemEquipped(sItemTag, oTarget, TRUE);
	
	int nDamage;
    int nSpiritEnergy;
    int nTargetMaxHP = GetMaxHitPoints(oTarget);
    int nCurrentHP = GetCurrentHitPoints(oTarget);
    nDamage = (nTargetMaxHP * 5) / 100; // Target takes 5% of max
	nSpiritEnergy = -2; // Reduced from -15 for real Devour Spirit
    if (nDamage < 1)
        nDamage = 1;
   
    if (spellsIsTarget(oTarget, SPELL_TARGET_STANDARDHOSTILE, oCaster)
        && (GetObjectType(oTarget) == OBJECT_TYPE_CREATURE))
    {
		// Visual effect on caster
	    // effect eVis = EffectVisualEffect(VFX_CAST_SPELL_DEVOUR_SPIRIT);
	    // ApplyEffectToObject(DURATION_TYPE_INSTANT, eVis, oCaster);
    
		// visual effect on target
    	// effect eBeam = EffectBeam(VFX_HIT_SPELL_DEVOUR_SPIRIT, oCaster, BODY_NODE_HAND);
		effect eZap = EffectVisualEffect(VFX_HIT_SPELL_DEVOUR_SPIRIT);
    	ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eZap, oTarget, VFX_SE_HIT_DURATION);

    	// apply effects 
    	effect eDam = EffectDamage(nDamage, DAMAGE_TYPE_NEGATIVE);
		
		// Reduced spirit drain effect if Mask is equipped
		if (bTargetHasMask)
		{
			nSpiritEnergy = -1; // half damage, rounded up
		}
		
    	ApplyEffectToObject(DURATION_TYPE_INSTANT, eDam, oTarget);
		
		// Apply spirit drain ONLY if the target is also the PC
		if (oTarget == oPC)
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