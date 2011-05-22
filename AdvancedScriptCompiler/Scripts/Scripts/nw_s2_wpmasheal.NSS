//::///////////////////////////////////////////////
//:: Warpriest Mass Heal
//:: [NW_S2_WPMasHeal.nss]
//:: Copyright (c) 2006 Obisidian Entertainment, Inc.
//:://////////////////////////////////////////////
/*
	Mass Heal
	
	This acts like the Heal spell except it heals 
	multiple targets.

	Warpriest's spell-like ability to cast Mass Heal.
	Just like Mass Heal, except variable effects are
	controlled by Warpriest class level.
*/
//:://////////////////////////////////////////////
//:: Created By: Andrew Woo (AFW-OEI)
//:: Created On: 05/20/2006
//:://////////////////////////////////////////////
//:: PKM-OEI 07.11.06 - VFX Pass

//#include "NW_I0_SPELLS"    
#include "x2_inc_spellhook" 
#include "nwn2_inc_spells"

int CureFaction( int nMaxToCure, effect eVis, effect eVis2, int nCasterLvl, int nMetaMagic ); 
int CureNearby( int nMaxToCure, effect eVis, effect eVis2, int nCasterLvl, int nMetaMagic ); 

void main()
{

    if (!X2PreSpellCastCode())
    {
		// If code within the PreSpellCastHook (i.e. UMD) reports FALSE, do not run this spell
        return;
    }

    //Declare major variables
    int 	nCasterLvl 	= GetLevelByClass(CLASS_TYPE_WARPRIEST);	// AFW-OEI 05/20/2006: main difference w/ Mass Heal
    effect	eVis 		= EffectVisualEffect(VFX_IMP_SUNSTRIKE); 
    effect 	eVis2	 	= EffectVisualEffect(VFX_IMP_HEALING_M);
    effect 	eImpact 	= EffectVisualEffect(VFX_HIT_CURE_AOE);

	ApplyEffectAtLocation(DURATION_TYPE_INSTANT, eImpact, GetSpellTargetLocation());    

	int nMaxToCure = nCasterLvl;
	int nCuredInFaction = HealHarmFaction( nMaxToCure, eVis, eVis2, nCasterLvl, GetSpellId() );
	nMaxToCure = nMaxToCure - nCuredInFaction;
	HealHarmNearby( nMaxToCure, eVis, eVis2, nCasterLvl, GetSpellId() );

}



void CureObject( object oTarget, effect eVis, effect eVis2, int nCasterLvl, int nSpellId )
{
	float fDelay = GetRandomDelay();
/*
	//Check to see if the target is an undead
	if (GetRacialType(oTarget) == RACIAL_TYPE_UNDEAD && spellsIsTarget(oTarget, SPELL_TARGET_STANDARDHOSTILE, OBJECT_SELF))
	{
		DelayCommand(fDelay, HarmTarget( oTarget, OBJECT_SELF, nSpellId ) );
	}
  	else if( GetRacialType(oTarget) != RACIAL_TYPE_UNDEAD)
	{
		DelayCommand(fDelay, HealTarget( oTarget, OBJECT_SELF, nSpellId ) );
    }
*/
	int bIsHealingSpell = TRUE;
	DelayCommand(fDelay, HealHarmTarget(oTarget, nCasterLvl, nSpellId, bIsHealingSpell));
}

int CureFaction( int nMaxToCure, effect eVis, effect eVis2, int nCasterLvl, int nSpellId ) // returns the # cured
{
	int nNumCured = 0;
	int bPCOnly=FALSE;
	object oTarget = GetFirstFactionMember( OBJECT_SELF, bPCOnly );
    while ( GetIsObjectValid(oTarget) && nNumCured < nMaxToCure )
    {
		CureObject( oTarget, eVis, eVis2, nCasterLvl, nSpellId );
		nNumCured++;
		oTarget = GetNextFactionMember( OBJECT_SELF, bPCOnly );
	}

	return nNumCured;
}


int CureNearby( int nMaxToCure, effect eVis, effect eVis2, int nCasterLvl, int nSpellId ) // returns the # cured
{
	int nNumCured = 0;

    //Get first target in shape
    object oTarget = GetFirstObjectInShape(SHAPE_SPHERE, RADIUS_SIZE_LARGE, GetSpellTargetLocation());
    while ( GetIsObjectValid(oTarget) && nNumCured < nMaxToCure )
    {
		if ( !GetFactionEqual( oTarget, OBJECT_SELF ) ) // We've already done faction characters
		{
 			CureObject( oTarget, eVis, eVis2, nCasterLvl, nSpellId );
			nNumCured++;
		}

        //Get next target in the shape
        oTarget = GetNextObjectInShape(SHAPE_SPHERE, RADIUS_SIZE_LARGE, GetSpellTargetLocation());
    }

	return nNumCured;
}