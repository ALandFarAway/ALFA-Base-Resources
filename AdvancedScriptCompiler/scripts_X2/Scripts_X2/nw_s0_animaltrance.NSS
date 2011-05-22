// JWR-OEI 07/02/2008
// RPGplayer1 11/22/2008: Added support for metamagic
// RPGplayer1 12/20/2008: Added SR check

#include "nw_i0_spells"
#include "x2_inc_spellhook"
#include "ginc_debug"
#include "nwn2_inc_spells"

/////////////////////////////////////////////
// helper function to cut down lines below
/////////////////////////////////////////////
int CompareTranceRace(object oTarget)
{
	int nRace = GetRacialType(oTarget);	
	switch( nRace )
	{
		case RACIAL_TYPE_ANIMAL:
		case RACIAL_TYPE_BEAST:
		case RACIAL_TYPE_MAGICAL_BEAST:
		case RACIAL_TYPE_VERMIN:
			return TRUE;
			break;
		default:
			return FALSE;
	}	
	return FALSE;
}

void main()
{

	
	// initial main variables
	int nTotalHD = d6(2); 													// total number of HD we can 'mesmerize'
	nTotalHD = ApplyMetamagicVariableMods(nTotalHD, 12);
	int nCurrHD = 0;														// how many HD we turned so far
	int nTotalLevels = GetTotalLevels(OBJECT_SELF, FALSE);					// total levels of caster												
	float fSize = 25.0 + (5.0 * (nTotalLevels/2));							// how big of radius we affect
	effect eMes;															// mesmerize effect
	int nDur = 1 * nTotalLevels;											// # of rounds effect lasts
	float fDuration = ApplyMetamagicDurationMods(RoundsToSeconds(nDur));
	int nInt;
	int nHD;
	effect eVFX, eLink;
	
	// debug
	PrettyDebug("Starting Animal Trance!! Total HD: "+IntToString(nTotalHD));

	
	
	object oTarget = GetFirstObjectInShape(SHAPE_SPHERE, fSize, GetSpellTargetLocation());
	
	while( oTarget != OBJECT_INVALID )
	{
		
		// loop through all the objects inside the sphere
		// check conditionals
		if ( CompareTranceRace(oTarget) )
		{
			nInt = GetAbilityScore(oTarget, ABILITY_INTELLIGENCE);
			nHD = GetHitDice(oTarget);
			// only applies to creatures with low intelligence
			if ( nInt < 3 && (nCurrHD + nHD) <= nTotalHD )
			{
				if (!MyResistSpell(OBJECT_SELF, oTarget))
				{
				PrettyDebug("Animal Trance :: Applying Effect to "+GetName(oTarget));
				// apply effect
				eMes = EffectMesmerize(MESMERIZE_BREAK_ON_ATTACKED);
				eVFX = EffectVisualEffect(VFX_HIT_TURN_UNDEAD);
				eLink = EffectLinkEffects(eVFX, eMes); 
				
				ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eLink, oTarget, fDuration /*RoundsToSeconds(nDur)*/);
				}
				nCurrHD += nHD;
			}
		}
		// get next object
		oTarget = GetNextObjectInShape(SHAPE_SPHERE, fSize, GetSpellTargetLocation());
	}
}