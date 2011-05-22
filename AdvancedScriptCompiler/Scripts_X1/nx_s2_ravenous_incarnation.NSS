// nx_s2_ravenous_incarnation
/*
    Spirit Eater Ravenous Incarnation Feat
    
Ravenous Incarnation
Limitations: Costs 1 use of Devour Spirit
Duration: 1 round/level
Alignment: Chaotic/Evil; Ravenous Incarnation shifts alignment 2 points towards Chaotic and 2 points towards Evil. 
For a use of Devour Spirit, the PC yields control of his body to his spirit hunger. Functioning as a polymorph-type 
effect, the player takes on a terrifying spirit-eater form and gains lich-like properties as well as an unlimited 
number of uses of Devour Spirit for a limited time. 
The incarnation’s claw attack does 1d8 + 5 negative energy damage. The attack paralyzes (On Hit: Hold) at a rate 
of 5% with a DC of 22. The paralysis, if it hits, lasts 3 rounds. The incarnation gains DR 15/divine, and immunity 
to cold, electricity, and mind-affecting spells.
The PC loses the ability to cast spells, as he would with other polymorph effects. Adds 50% to corruption, plus 
whatever extra corruption is incurred by casting Devour Spirit in this mode.
    
*/
// ChazM 2/23/07
// ChazM 4/2/07 - added implementation
// ChazM 4/12/07 VFX/string update
// MDiekmann 7/5/07 - various fixes for new implementation
// MDiekmann 7/5/07 - Addition of cooldown timer

#include "kinc_spirit_eater"
#include "x2_inc_spellhook"

//const int POLYMORPH_TYPE_RAVENOUS_INCARNATION = 111;

void main()
{
    if (!X2PreSpellCastCode())
    {   // If code within the PreSpellCastHook (i.e. UMD) reports FALSE, do not run this spell
        return;
    }
    object oCaster = OBJECT_SELF;
	    
    effect ePoly = EffectPolymorph(POLYMORPH_TYPE_RAVENOUS_INCARNATION);
//	effect eVFX = EffectVisualEffect(VFX_DUR_RAVENOUS_INCARNATION);	//the visual effect is now embedded in the appearance - EPF 7/19/07
 //   effect eLink = EffectLinkEffects(ePoly, eVFX);
 
	int nDuration = 2;	//2 turns = 20 rounds = 2 minutes
	
    //Apply the VFX impact and effects
    //AssignCommand(oCaster, ClearAllActions()); // prevents an exploit (so indicated in polymorph self)
    ApplyEffectToObject(DURATION_TYPE_TEMPORARY, ePoly, oCaster, TurnsToSeconds(nDuration));

	// Adds additional 65% to corruption
	float fCorruptionDelta = 0.65f;
    UpdateSpiritEaterCorruption(fCorruptionDelta);
	
	// Set flag showing a devour ability has been used
	SetGlobalInt(VAR_SE_HAS_USED_DEVOUR_ABILITY, TRUE);
	
	// sets up cooldown timer for devour abilities
	ResetFeatUses(oCaster, FEAT_RAVENOUS_INCARNATION, FALSE, TRUE);
	DecrementRemainingFeatUses(oCaster, FEAT_DEVOUR_SOUL);
	DecrementRemainingFeatUses(oCaster, FEAT_SPIRIT_GORGE);
	DecrementRemainingFeatUses(oCaster, FEAT_ETERNAL_REST);
	DecrementRemainingFeatUses(oCaster, FEAT_RAVENOUS_INCARNATION);
	DecrementRemainingFeatUses(oCaster, FEAT_DEVOUR_SPIRIT_1);
	
	// Clear out uses of suppress since it can no longer be used this day
	if(GetHasFeat(FEAT_SUPPRESS))
	{
		int nCount;
		for(nCount = 0; nCount < 10; nCount++)
		{
			DecrementRemainingFeatUses(oCaster, FEAT_SUPPRESS);
		}
		ResetFeatUses(oCaster, FEAT_SUPPRESS, FALSE, TRUE);
	}
	
    //Fire cast spell at event for the specified target
   	SignalEvent(oCaster, EventSpellCastAt(oCaster, GetSpellId(), FALSE)); // not harmful
	
	ResetFeatUses(oCaster, FEAT_DEVOUR_SPIRIT_1, FALSE, TRUE);
	ResetFeatUses(oCaster, FEAT_DEVOUR_SPIRIT_2, FALSE, TRUE);
	ResetFeatUses(oCaster, FEAT_DEVOUR_SPIRIT_3, FALSE, TRUE);

}