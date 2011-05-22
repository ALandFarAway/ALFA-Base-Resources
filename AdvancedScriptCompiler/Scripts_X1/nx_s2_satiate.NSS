// nx_s2_satiate
/*
    Spirit Eater Satiate Feat
    
Satiate
Alignment: Neutral
Limitations: 1 use/day
This is the spirit-eater affliction panic button. The player is out of uses of Devour Spirit, and his 
affliction is in its final stages. The player makes a big, permanent sacrifice to the tune of 25% of 
the XP distance to the PC’s next level, and the PC’s spirit energy is fully recharged. Conceptually, 
this is something like spirit-eater self-cannibalism – he allows the spirit-eater to feed upon his own spirit.
The player cannot lose a level by using this ability – it caps when the player is reduced to 0 XP 
beyond the last level he gained. The 1 use/day limitation prevents exploitation of this cap.
    
*/
// ChazM 2/23/07
// ChazM 4/2/07 added implementation
// ChazM 4/12/07 VFX/string update
// ChazM 6/25/07 apply a level drain for 10 mins instead of taking any more XP

#include "x2_inc_spellhook"
#include "kinc_spirit_eater"
#include "ginc_2da"

const int STR_REF_SATIATE_ERROR = 208648;

// Get the effective character level Race adjustment 
int GetRaceECL(object oTarget)
{
	int iSubRace = GetSubRace(oTarget);
	int iRet = StringToInt(Get2DAString("RacialSubTypes", "ECL", iSubRace));
	// PrettyDebug ("This character has an ECL of " + IntToString(iRet));
	return (iRet);
}

// Get the effective character level (all class levels added up + Race ECL 
int GetECL(object oTarget, int bIncludeNegativeLevels)						
{
 	int nTotalLevels = GetTotalLevels(oTarget, bIncludeNegativeLevels); // total levels, not including negative level or ECL
	int nRaceECL = GetRaceECL(oTarget);
	int nECL = nRaceECL + nTotalLevels;
	return (nECL);
}

int GetMinXPForLevel(int nLevel)
{
	int nMinXP = StringToInt(Get2DAString(EXP_TABLE_2DA, EXP_TABLE_XP_COL, nLevel-1));
	return(nMinXP);
}

void main()
{
    if (!X2PreSpellCastCode())
    {   // If code within the PreSpellCastHook (i.e. UMD) reports FALSE, do not run this spell
        return;
    }
    object oCaster = OBJECT_SELF; // target is caster
	
	//ability can only be used at spirit-eater stage 4 or worse.
	if(GetSpiritEaterStage() < 4)
	{
		FloatingTextStrRefOnCreature(STR_REF_SATIATE_ERROR,oCaster, FALSE, 4.f, COLOR_WHITE, COLOR_WHITE, 0.3f,Vector(0.f,0.f,1.f));
		IncrementRemainingFeatUses(oCaster,FEAT_SATIATE);
		return;
	}
	
	// Get all Spirit Eater Points back.
	SetSpiritEaterPoints(fSPIRIT_EATER_POINTS_MAX);  
	
	float fCraving = GetSpiritEaterCorruption();
	if(fCraving > 1.f)
	{
		SetSpiritEaterCorruption(1.f);
	}
	
	// Reduce XP by 25% of distance to next level.
	int nECL = GetECL(oCaster, FALSE);
	PrettyDebug("GetECL(oCaster, FALSE) = " + IntToString(nECL));
	
	int nXP = GetXP(oCaster);
	int nNextLevelXP = GetMinXPForLevel(nECL+1);  //StringToInt(Get2DAString(EXP_TABLE_2DA, EXP_TABLE_XP_COL, nHD));
	int nThisLevelXP = GetMinXPForLevel(nECL);  //StringToInt(Get2DAString(EXP_TABLE_2DA, EXP_TABLE_XP_COL, nHD-1));
	int nPenalty = (nNextLevelXP - nThisLevelXP)/4;
	int nNewXP = nXP - nPenalty;
	
	// can't go below what's needed for this level.
	if (nNewXP < nThisLevelXP)
	{
		nNewXP = nThisLevelXP;
		// apply a level drain for 10 mins instead of taking any more XP
    	effect eLevelDrain = EffectNegativeLevel(1);
    	ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eLevelDrain, oCaster, 600.0f);
	}
	SetXP(oCaster, nNewXP);
	
	// Visual effect on caster
    effect eCasterVis = EffectVisualEffect(VFX_CAST_SPELL_SATIATE);
    ApplyEffectToObject(DURATION_TYPE_INSTANT, eCasterVis, oCaster);
	
	//Fire cast spell at event for the specified target
   	SignalEvent(oCaster, EventSpellCastAt(oCaster, GetSpellId(), FALSE)); // not harmful
	
	// feat will automatically decrement
}