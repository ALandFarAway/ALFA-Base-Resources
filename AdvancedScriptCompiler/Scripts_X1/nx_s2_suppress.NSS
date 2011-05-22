// nx_s2_suppress
/*
    Spirit Eater Suppress Feat
    
Suppress
Limitations: Costs 1 use of Devour Spirit
Alignment: Lawful/Good; Suppress shifts alignment 2 points towards Lawful and 1 point towards Good.
For one use of Devour Spirit, the PC may instead invest his efforts on suppressing his urge to consume 
souls. The player gains a small amount of spirit energy back (8%), equivalent to the amount he would 
receive for casting Devour Spirit on a creature without killing it, and also reduces his amount of 
corruption by 10%.
    
*/
// ChazM 2/23/07
// ChazM 4/5/07 - track use count
// ChazM 4/12/07 VFX/string update
// EPF 6/25/07 - adding energy bonus based on number of spirits nearby.
// MDiekmann 7/5/07 - various fixes for new implementation

#include "kinc_spirit_eater"
#include "x2_inc_spellhook"
#include "ginc_vars"

const float fSPIRIT_RADIUS = 20.f;
const float fSUPPRESSION_BONUS_PER_SPIRIT = 2.f;
const float fSUPPRESSION_BASE_ENERGY = 5.f;

int GetNumNearbySpirits(object oCaster)
{
	location lSource = GetLocation(oCaster);
	object oCreature = GetFirstObjectInShape(SHAPE_SPHERE,fSPIRIT_RADIUS,lSource);
	int nSpirits = 0;
	while(GetIsObjectValid(oCreature))
	{
		if(GetIsSpirit(oCreature))
		{
			nSpirits++;
		}
		oCreature = GetNextObjectInShape(SHAPE_SPHERE, fSPIRIT_RADIUS, lSource);
	}
	return nSpirits;
}

void main()
{
    if (!X2PreSpellCastCode())
    {   // If code within the PreSpellCastHook (i.e. UMD) reports FALSE, do not run this spell
        return;
    }
    object oCaster = OBJECT_SELF; // target is caster

    	
	// Visual effect on caster
    effect eCasterVis = EffectVisualEffect(VFX_CAST_SPELL_SUPPRESS);
    ApplyEffectToObject(DURATION_TYPE_INSTANT, eCasterVis, oCaster);
	
	//Fire cast spell at event for the specified target
   	SignalEvent(oCaster, EventSpellCastAt(oCaster, GetSpellId(), FALSE)); // not harmful
	int nSpirits = GetNumNearbySpirits(oCaster);
	
	// cap the bonus at 5
	if(nSpirits > 5)
	{
		nSpirits = 5;
	}
	
	float fBonus = fSUPPRESSION_BONUS_PER_SPIRIT * IntToFloat(nSpirits);
	
    UpdateSpiritEaterPoints(fSUPPRESSION_BASE_ENERGY + fBonus);
    UpdateSpiritEaterCorruption(-0.1f);            
	ModifyGlobalInt(VAR_SE_USE_COUNT_SUPPRESS, 1);
    
    // use up a suppress useage
    //DecrementRemainingFeatUses(OBJECT_SELF, FEAT_SUPPRESS);
	
	// Clear out uses of suppress since it can no longer be used this day
		if(GetHasFeat(FEAT_DEVOUR_SPIRIT_1))
		{
			int nCount;
			for(nCount = 0; nCount < 10; nCount++)
			{
				DecrementRemainingFeatUses(oCaster, FEAT_DEVOUR_SPIRIT_1);
			}
			ResetFeatUses(oCaster, FEAT_DEVOUR_SPIRIT_1, FALSE, TRUE);
			ResetFeatUses(oCaster, FEAT_DEVOUR_SPIRIT_2, FALSE, TRUE);
			ResetFeatUses(oCaster, FEAT_DEVOUR_SPIRIT_3, FALSE, TRUE);
		}
    
}