//::///////////////////////////////////////////////
//:: Warpriest Mass Cure Light Wounds
//:: NW_S2_WPMaCLW
//:: Copyright (c) 2006 Obsidian Entertainment, Inc.
//:://////////////////////////////////////////////
/*
// Positive energy spreads out in all directions
// from the point of origin, curing 1d8 points of
// damage plus 1 point per caster level (maximum +20)
// to nearby living allies.
//
// Like cure spells, Mass Cure damages undead in
// its area rather than curing them.
//
// This incarnation is for the Warpriest's spell-like
// ability.  It is based on the regular Mass Cure Light
// wounds; the only difference is that caster level stuff
// is replaced by Warpriest levels.
*/
//:://////////////////////////////////////////////
//:: Created By: Jesse Reynolds (JLR - OEI)
//:: Created On: August 01, 2005
//:://////////////////////////////////////////////
//:: AFW-OEI 05/20/2006: Copied from Mass CLW

#include "nwn2_inc_spells"
#include "NW_I0_SPELLS"    
#include "x2_inc_spellhook" 


// Brock H. - OEI 10/06/05 -- Added code to heal faction, then nearby, and cap based on level
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
    int nCasterLvl = GetLevelByClass(CLASS_TYPE_WARPRIEST);		// AFW-OEI 05/20/2006: the only substantive difference.
    
    int nMetaMagic = GetMetaMagicFeat();
    
    effect eVis = EffectVisualEffect(VFX_HIT_SPELL_INFLICT_2);
    effect eVis2 = EffectVisualEffect(VFX_IMP_HEALING_M);
    effect eImpact = EffectVisualEffect(VFX_HIT_AOE_CONJURATION);

	ApplyEffectAtLocation(DURATION_TYPE_INSTANT, eImpact, GetSpellTargetLocation());    

	int nMaxToCure = nCasterLvl;
	int nCuredInFaction = CureFaction( nMaxToCure, eVis, eVis2, nCasterLvl, nMetaMagic );
	nMaxToCure = nMaxToCure - nCuredInFaction;
	CureNearby( nMaxToCure, eVis, eVis2, nCasterLvl, nMetaMagic );
}


void CureObject( object oTarget, effect eVis, effect eVis2, int nCasterLvl, int nMetaMagic )
{
	int nDamagen, nModify, nHurt, nHP;
	effect eKill, eHeal;
	float fDelay = GetRandomDelay();
	int nBonus = nCasterLvl;
	if ( nBonus > 20 )
		nBonus = 20;

	//Check if racial type is undead
	if (GetRacialType(oTarget) == RACIAL_TYPE_UNDEAD )
	{
		if (spellsIsTarget(oTarget, SPELL_TARGET_STANDARDHOSTILE, OBJECT_SELF))
		{
	        //Fire cast spell at event for the specified target
	        SignalEvent(oTarget, EventSpellCastAt(OBJECT_SELF, GetSpellId()));
	        //Make SR check
	        if (!MyResistSpell(OBJECT_SELF, oTarget, fDelay))
	        {
	            nModify = d8() + nBonus;
	            //Make metamagic check
	            nModify = ApplyMetamagicVariableMods(nModify, 8 + nCasterLvl);
	
	            //Make Will save
	            if (MySavingThrow(SAVING_THROW_WILL, oTarget, GetSpellSaveDC(), SAVING_THROW_TYPE_NONE, OBJECT_SELF, fDelay))
	            {
	                nModify /= 2;
	            }
	            //Calculate damage
	            nHurt =  nModify;
	            //Set damage effect
	            eKill = EffectDamage(nHurt, DAMAGE_TYPE_POSITIVE);
	            //Apply damage effect and VFX impact
	            DelayCommand(fDelay, ApplyEffectToObject(DURATION_TYPE_INSTANT, eKill, oTarget));
	            DelayCommand(fDelay, ApplyEffectToObject(DURATION_TYPE_INSTANT, eVis, oTarget));
	        }
	    }
	}
	else
	{
	    // * May 2003: Heal Neutrals as well
		if (spellsIsTarget(oTarget, SPELL_TARGET_ALLALLIES, OBJECT_SELF) || GetFactionEqual(oTarget))
		{
	        //Fire cast spell at event for the specified target
	        SignalEvent(oTarget, EventSpellCastAt(OBJECT_SELF, GetSpellId(), FALSE));
	        nHP = d8();
	        //Enter Metamagic conditions
	        nModify = ApplyMetamagicVariableMods(nModify, 8);
	
	        if (GetHasFeat(FEAT_AUGMENT_HEALING))
	        {
	            int nSpellLvl = GetSpellLevel(GetSpellId());
	            nHP = nHP + (2 * nSpellLvl);
	        }
	        //Set healing effect
	        nHP = nHP + nBonus;
	        eHeal = EffectHeal(nHP);
	        //Apply heal effect and VFX impact
	        DelayCommand(fDelay, ApplyEffectToObject(DURATION_TYPE_INSTANT, eHeal, oTarget));
	        DelayCommand(fDelay, ApplyEffectToObject(DURATION_TYPE_INSTANT, eVis2, oTarget));
	    }
	}

}

int CureFaction( int nMaxToCure, effect eVis, effect eVis2, int nCasterLvl, int nMetaMagic ) // returns the # cured
{
	int nNumCured = 0;
	int bPCOnly=FALSE;
	object oTarget = GetFirstFactionMember( OBJECT_SELF, bPCOnly );
    while ( GetIsObjectValid(oTarget) && nNumCured < nMaxToCure )
    {
	if (GetRacialType(oTarget) != RACIAL_TYPE_UNDEAD)
	{
		CureObject( oTarget, eVis, eVis2, nCasterLvl, nMetaMagic );
		nNumCured++;
	}
		oTarget = GetNextFactionMember( OBJECT_SELF, bPCOnly );
	}

	return nNumCured;
}


int CureNearby( int nMaxToCure, effect eVis, effect eVis2, int nCasterLvl, int nMetaMagic ) // returns the # cured
{
	int nNumCured = 0;

    //Get first target in shape
    object oTarget = GetFirstObjectInShape(SHAPE_SPHERE, RADIUS_SIZE_LARGE, GetSpellTargetLocation());
    while ( GetIsObjectValid(oTarget) && nNumCured < nMaxToCure )
    {
		if ( !GetFactionEqual( oTarget, OBJECT_SELF ) || GetRacialType(oTarget) == RACIAL_TYPE_UNDEAD ) // We've already done faction checks
		{
 			CureObject( oTarget, eVis, eVis2, nCasterLvl, nMetaMagic );
			nNumCured++;
		}


        //Get next target in the shape
        oTarget = GetNextObjectInShape(SHAPE_SPHERE, RADIUS_SIZE_LARGE, GetSpellTargetLocation());
    }

	return nNumCured;
}