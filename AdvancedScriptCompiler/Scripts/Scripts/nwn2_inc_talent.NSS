// nwn2_inc_talent
//
// Supplemental include file for selecting talents via the chooseTactics subfunction 
// of DetermineCombatRound().  x0_i0_talent has all the talent selection functions from nwn1.

// EPF 6/5/06
// ChazM 9/19/06 modified MyGetCreatureTalent()- now calls GetCreatureTalent(); added prototypes and comments.
// ChazM 9/19/06 fix GetCreatureTalent() - return value
// ChazM 1/18/07 Evenflws updates

//void main(){}

#include "x0_inc_generic"
//#include "x2_inc_switches"
#include "ginc_debug"

//------------------------------------------
// Consts and Structs
//------------------------------------------

struct EldritchTarget
{
	int nAffected;
	object oTarget;	
};

struct EldritchShape
{
	int nSpell;
	object oTarget;
};

//------------------------------------------
// Prototypes
//------------------------------------------

// This is specifically for a Warlock choosing to cast offensive magic.  The defensive buffs are
// accounted for in the x0_i0_talent file.
int TalentWarlockSpellAttack(object oEnemy);


// private
talent MyGetCreatureTalent(int nCategory, int bRandom);
struct EldritchTarget GetBestEldritchAOETarget(int nShape, float fDimension);
struct EldritchShape GetBestEldritchShape(object oIntruder);
int GetInvocationSpellFromMetamagic(int nMeta);
int GetInvocationEssenceByIndex(int nLevel, int nIndex);
int GetRandomInvocationEssenceByLevel(int nLevel);
int GetBestInvocationEssenceMetamagic();
int GetBestEldritchBlastFeat();
talent GetWarlockInvocationTalent(int bRandom, object oIntruder);


//------------------------------------------
// Functions
//------------------------------------------

//There's another function in x0_i0_talent that does this.  The "my" is so they don't conflict, since
//this file shouldn't depend on x0_i0_talent.
talent MyGetCreatureTalent(int nCategory, int bRandom)
{
	return (GetCreatureTalent(nCategory, GetCRMax(), bRandom));

/*
	if(bRandom)
		return GetCreatureTalentRandom(nCategory);
	
	return GetCreatureTalentBest(nCategory,GetCRMax());
*/	
}


// O(n^2).  Could be a problem if anyone decides to make an Army of Warlocks mod.
struct EldritchTarget GetBestEldritchAOETarget(int nShape, float fDimension)
{
	object oCurrent;
	object oTarget;
	location lTargetLocation;
	int nCurrentAffected;
	struct EldritchTarget etReturnTarget;
	int i = 1;

//	PrettyDebug("Looking for best AOE Target.");

	etReturnTarget.nAffected = 0;
	etReturnTarget.oTarget = OBJECT_INVALID;

	oCurrent = GetNearestCreature(CREATURE_TYPE_REPUTATION,REPUTATION_TYPE_ENEMY, OBJECT_SELF, i);
	while(GetIsObjectValid(oCurrent))
	{
		nCurrentAffected = 0;
		lTargetLocation = GetLocation(oCurrent);
	
		oTarget = GetFirstObjectInShape(nShape, fDimension, lTargetLocation, TRUE, OBJECT_TYPE_CREATURE);
	    while(GetIsObjectValid(oTarget))
	    {
			if(GetIsEnemy(oTarget))
			{
		    	nCurrentAffected++;
			}
			oTarget = GetNextObjectInShape(nShape, fDimension, lTargetLocation, TRUE, OBJECT_TYPE_CREATURE);
	    }	
		if(nCurrentAffected > etReturnTarget.nAffected)
		{
			etReturnTarget.nAffected = nCurrentAffected;
			etReturnTarget.oTarget = oCurrent;
		}
		i++;
		oCurrent = GetNearestCreature(CREATURE_TYPE_REPUTATION,REPUTATION_TYPE_ENEMY,OBJECT_SELF,i);
		if(GetDistanceToObject(oCurrent) > 20.f)	//we don't want to check every enemy in the level, just close ones.
			break;
	}

//	PrettyDebug("Targeting " + GetName(etReturnTarget.oTarget) + " affects " + IntToString(etReturnTarget.nAffected) + " with current shape.");
	return etReturnTarget;
}

struct EldritchShape GetBestEldritchShape(object oIntruder)
{
	//Look for the blast effect that will do the most damage
	int nCasterLvl = GetLevelByClass(CLASS_TYPE_WARLOCK);
	int nBestSpell = -1;
	int nBestAffected = 1;
    int nAffectedChain = 0;
	location lTargetLocation = GetLocation(oIntruder);
	object oTarget;
	struct EldritchTarget etBestTarget;
	struct EldritchShape esBestShape;
	esBestShape.nSpell = -1;
	esBestShape.oTarget = oIntruder;
	
	//60 feet is the effective range of Eldritch blast.  Anything longer, use Spear.
	if(GetHasSpell(SPELL_I_ELDRITCH_SPEAR) && GetDistanceToObject(oIntruder) > FeetToMeters(60.f))
	{
//		PrettyDebug("Chain is most effective.");
		esBestShape.nSpell = SPELL_I_ELDRITCH_SPEAR;
		return esBestShape;
	}
	
//	PrettyDebug("Trying chain.");
	if(GetHasSpell(SPELL_I_ELDRITCH_CHAIN))
	{
		//Chain has our biggest potential radius, making it the best possible shape unless a different shape can
		//affect more than chain's maximum.
		if ( nCasterLvl >= 20 )      { nAffectedChain = 4; }
	    else if ( nCasterLvl >= 15 ) { nAffectedChain = 3; }
	    else if ( nCasterLvl >= 10 ) { nAffectedChain = 2; }
	    else                         { nAffectedChain = 1; }
	}

	if(nAffectedChain > nBestAffected)
	{
//		PrettyDebug("Chain is most effective.");
		nBestAffected = nAffectedChain;
		esBestShape.nSpell = SPELL_I_ELDRITCH_CHAIN;
	}
	
//	PrettyDebug("Trying cone.");
	if(GetHasSpell(SPELL_I_ELDRITCH_CONE))
	{
		etBestTarget = GetBestEldritchAOETarget(SHAPE_SPELLCONE, 11.f);
		if(etBestTarget.nAffected > nBestAffected)
		{
//			PrettyDebug("Cone is most effective.");
			nBestAffected = etBestTarget.nAffected;
			esBestShape.nSpell = SPELL_I_ELDRITCH_CONE;
			esBestShape.oTarget = etBestTarget.oTarget;
		}
	}
	
//	PrettyDebug("Trying doom.");
	if(GetHasSpell(SPELL_I_ELDRITCH_DOOM))
	{
		etBestTarget = GetBestEldritchAOETarget(SHAPE_SPHERE, RADIUS_SIZE_HUGE);
		if(etBestTarget.nAffected > nBestAffected)
		{
//			PrettyDebug("Doom is most effective.");
			nBestAffected = etBestTarget.nAffected;
			esBestShape.nSpell = SPELL_I_ELDRITCH_DOOM;
			esBestShape.oTarget = etBestTarget.oTarget;
		}	
	}
	return esBestShape;
}
		
int GetInvocationSpellFromMetamagic(int nMeta)
{
	switch(nMeta)
	{
	case METAMAGIC_INVOC_FRIGHTFUL_BLAST :
		return SPELL_I_FRIGHTFUL_BLAST;
	case METAMAGIC_INVOC_DRAINING_BLAST :
		return SPELL_I_DRAINING_BLAST;
	case METAMAGIC_INVOC_BESHADOWED_BLAST :
		return SPELL_I_BESHADOWED_BLAST;
	case METAMAGIC_INVOC_BRIMSTONE_BLAST :
		return SPELL_I_BRIMSTONE_BLAST;
	case METAMAGIC_INVOC_HELLRIME_BLAST :
		return SPELL_I_HELLRIME_BLAST;
	case METAMAGIC_INVOC_BEWITCHING_BLAST :
		return SPELL_I_BEWITCHING_BLAST;
	case METAMAGIC_INVOC_NOXIOUS_BLAST :
		return SPELL_I_NOXIOUS_BLAST;
	case METAMAGIC_INVOC_VITRIOLIC_BLAST :
		return SPELL_I_VITRIOLIC_BLAST;
	case METAMAGIC_INVOC_UTTERDARK_BLAST :
		return SPELL_I_UTTERDARK_BLAST;
	}
	return -1;
}
		
int GetInvocationEssenceByIndex(int nLevel, int nIndex)
{
	if(nLevel == 1)
	{
		switch(nIndex)
		{
		case 1: return METAMAGIC_INVOC_FRIGHTFUL_BLAST;
		case 2:	return METAMAGIC_INVOC_DRAINING_BLAST;
		}
	}
	else if (nLevel == 2)
	{
		switch(nIndex)
		{
		case 1: return METAMAGIC_INVOC_BESHADOWED_BLAST;
		case 2: return METAMAGIC_INVOC_BRIMSTONE_BLAST;
		case 3:	return METAMAGIC_INVOC_HELLRIME_BLAST;
		}
	}
	else if(nLevel == 3)
	{
		switch(nIndex)
		{
		case 1: return METAMAGIC_INVOC_BEWITCHING_BLAST;
		case 2: return METAMAGIC_INVOC_NOXIOUS_BLAST;
		case 3: return METAMAGIC_INVOC_VITRIOLIC_BLAST;
		}
	}
	else if (nLevel == 4)
	{
		switch(nIndex)
		{
		case 1: return METAMAGIC_INVOC_UTTERDARK_BLAST;
		}
	}
	PrettyError("nwn2_inc_talent - GetInvocationIndexByEssence(): Unable to locate Invocation Essence.");
	return METAMAGIC_NONE;
}

int GetRandomInvocationEssenceByLevel(int nLevel)
{
	int nSpells, nIndex;
	
	//decide how big the random roll is, based on the Warlock's current spell table.
	switch(nLevel)
	{
		case 1:
			nSpells = 2;
			break;
		case 2:
			nSpells = 3;
			break;
		case 3:
			nSpells = 3;
			break;
		case 4:
			nSpells = 1;
			break;
	}
	
	nIndex = Random(nSpells) + 1;
	int nEssence = GetInvocationEssenceByIndex(nLevel, nIndex);
	int i;
	for(i = 0; i < nSpells; i++)
	{
		//pick a random index to start from, then cycle through
		//looking for one that the player has.
		nEssence = GetInvocationEssenceByIndex(nLevel, nIndex);
		if(nEssence != METAMAGIC_NONE && GetHasSpell(GetInvocationSpellFromMetamagic(nEssence)))
			return nEssence;
		
		nIndex++;
		if(nIndex >= nSpells)
		{
			nIndex = 1;	//restart the cycle.	
		}
	}
	return METAMAGIC_NONE;
}
	
int GetBestInvocationEssenceMetamagic()
{
	int nLevel = GetLevelByClass(CLASS_TYPE_WARLOCK);
	int nEssenceLevel, nEssence;
	
	//what level of essence invocations can I cast?
	if(nLevel >= 16)
	{
		nEssenceLevel = 4;	
	}
	else if (nLevel >= 11)
	{
		nEssenceLevel = 3;	
	}
	else if(nLevel >=  6)
	{
		nEssenceLevel = 2;	
	}
	else
	{
		nEssenceLevel = 1;
	}
		
	while(nEssenceLevel > 0)
	{
		nEssence = 	GetRandomInvocationEssenceByLevel(nEssenceLevel);
		if(nEssence != METAMAGIC_NONE)
			return nEssence;
		nEssenceLevel--;
	}
	
	return METAMAGIC_NONE;
}

int GetBestEldritchBlastFeat()
{
	int nLevel = GetLevelByClass(CLASS_TYPE_WARLOCK);
	int nFeatLevel;
		
	if(nLevel < 13)
	{
		nFeatLevel = (nLevel+1) / 2;	
	}
	else if(nLevel <= 16)
	{
		nFeatLevel = 7;
	} 
	else if(nLevel <= 19)
	{
		nFeatLevel = 8;	
	}
	else
	{
		nFeatLevel = 9;
	}
	switch(nFeatLevel)
	{
		case 1:
			return FEAT_ELDRITCH_BLAST_1;
		case 2:
			return FEAT_ELDRITCH_BLAST_2;
		case 3:
			return FEAT_ELDRITCH_BLAST_3;
		case 4:
			return FEAT_ELDRITCH_BLAST_4;
		case 5:
			return FEAT_ELDRITCH_BLAST_5;
		case 6:
			return FEAT_ELDRITCH_BLAST_6;
		case 7:
			return FEAT_ELDRITCH_BLAST_7;
		case 8:
			return FEAT_ELDRITCH_BLAST_8;
		case 9:
			return FEAT_ELDRITCH_BLAST_9;
	}
	return FEAT_INVALID;
}



talent GetWarlockInvocationTalent(int bRandom, object oIntruder)
{
	talent tUse;
	int nEnemy = CheckEnemyGroupingOnTarget(oIntruder);
	int nSeed=d2()+nEnemy;
	if(GetAssociateState(NW_ASC_SCALED_CASTING)) {
		if(GetGameDifficulty()>=GAME_DIFFICULTY_CORE_RULES)
			nSeed=0;
		else nSeed-=2;
	} else if(GetAssociateState(NW_ASC_POWER_CASTING)) nSeed-=1;
	if(nSeed > 1) {
		tUse = MyGetCreatureTalent(TALENT_CATEGORY_HARMFUL_AREAEFFECT_DISCRIMINANT, bRandom);
	}
	if(!GetIsTalentValid(tUse))
    {
    	tUse = MyGetCreatureTalent(TALENT_CATEGORY_HARMFUL_RANGED, bRandom);
    }
	return tUse;
}

int TalentWarlockSpellAttack(object oIntruder)
{
    talent tUse;
    object oTarget = oIntruder;
	struct EldritchShape esBestShape;
	int nMetamagicEssence;
	int bRandomize;
	
	//find a new target if there's a problem with ours.
    /*if(!GetIsObjectValid(oTarget) || GetArea(oTarget) != GetArea(OBJECT_SELF) || GetPlotFlag(OBJECT_SELF) == TRUE)
    {
        oTarget = GetLastHostileActor();
        if(!GetIsObjectValid(oTarget)
            || GetIsDead(oTarget)
            || GetArea(oTarget) != GetArea(OBJECT_SELF)
            || GetPlotFlag(OBJECT_SELF) == TRUE)
        {
            oTarget = GetNearestSeenEnemy();
            if(!GetIsObjectValid(oTarget))
            {
                return FALSE;
            }
        }
    }*/
	
	if(Random(3) == 0)	//try a non-eldritch-blast invocation
	{
//		PrettyDebug("Regular invocation.");
		bRandomize = Random(3) > 0 ? TRUE : FALSE;	// with some probability, we randomize the Warlock's invocations so he's not always using the best one.
		
		tUse = GetWarlockInvocationTalent(bRandomize, oIntruder);
		
		// * if something was valid, attempt to use that something intelligently
	    if (GetIsTalentValid(tUse))
	    {
	       if (!GetHasSpellEffect(GetIdFromTalent(tUse), oTarget))
	       {
//		      PrettyDebug("Found invocation.  Casting.");
			  SetLastGenericSpellCast(GetIdFromTalent(tUse));
	          ActionUseTalentOnObject(tUse, oTarget);
	          return TRUE;
	       }
		}
	}
	
	//Try an eldritch blast.  Pick the optimal shape, pick the best available essence to attach as metamagic.
	esBestShape = GetBestEldritchShape(oTarget);
	nMetamagicEssence = GetBestInvocationEssenceMetamagic();
	oTarget = esBestShape.oTarget;	//the optimal shape may be centered on a different target.
	if(esBestShape.nSpell > 0)
	{
		SetLastGenericSpellCast(esBestShape.nSpell);
		ActionCastSpellAtObject(esBestShape.nSpell, oTarget, nMetamagicEssence);
		return TRUE;
	}
	else if(nMetamagicEssence != METAMAGIC_NONE)	//we can just cast the essence if we don't have a good shape for it.
	{
		SetLastGenericSpellCast(esBestShape.nSpell);
		ActionCastSpellAtObject(GetInvocationSpellFromMetamagic(nMetamagicEssence), oTarget);
		return TRUE;
	}
	else
	{
		int nFeat = GetBestEldritchBlastFeat();
		if(nFeat != FEAT_INVALID)
		{
			SetLastGenericSpellCast(844);	//844 is Eldritch Blast.
			ActionUseFeat(nFeat,oTarget);	
			return TRUE;
		}
	}


		
	return FALSE;
}