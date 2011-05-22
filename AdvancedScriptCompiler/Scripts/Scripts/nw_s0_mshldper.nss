//:://////////////////////////////////////////////////////////////////////////
//:: Level 7 Arcane Spell: Mass Hold Person
//:: nw_s0_mshldper.nss
//:: Created By: Brock Heinz - OEI
//:: Created On: 08/29/05
//:: Copyright (c) 2005 Obsidian Entertainment Inc.
//:://////////////////////////////////////////////////////////////////////////
/*
        Mass Hold Person
        PHB, pg. 241

        School:		    Evocation
        Components: 	Verbal, Somatic
        Range:		    Medium
        Target:		    All targets within a 30 ft. radius
        Duration:		1 round / level
        Saving Throw:	Will negates
        Spell Resist:	Yes

        Paralyzes all targets that fail their saves. Each round targets 
        can try and make a new save.

*/
//:://////////////////////////////////////////////////////////////////////////



#include "NW_I0_SPELLS"    
#include "x2_inc_spellhook" 



void HoldTarget( object oTarget, float fDuration, int nSaveDC );


void main()
{

    if (!X2PreSpellCastCode())
    {
    	// If code within the PreSpellCastHook (i.e. UMD) reports FALSE, do not run this spell
        return;
    }

//	SpawnScriptDebugger();

    //Declare major variables
    location locTarget = GetSpellTargetLocation();

    int nMeta = GetMetaMagicFeat();
	int nRounds = GetCasterLevel(OBJECT_SELF);
	//Make metamagic extend check
	if (nMeta == METAMAGIC_EXTEND)
	{
		nRounds = nRounds * 2;
	}
	int nSaveDC = GetSpellSaveDC();
	

    object oTarget = GetFirstObjectInShape( SHAPE_SPHERE, RADIUS_SIZE_LARGE, locTarget );
    while (GetIsObjectValid(oTarget) )
    {
		if (spellsIsTarget(oTarget, SPELL_TARGET_STANDARDHOSTILE, OBJECT_SELF))
		{
	
	        //Make sure the target is a humanoid
	        if (GetIsPlayableRacialType(oTarget) ||
	            GetRacialType(oTarget) == RACIAL_TYPE_HUMANOID_GOBLINOID ||
	            GetRacialType(oTarget) == RACIAL_TYPE_HUMANOID_MONSTROUS ||
	            GetRacialType(oTarget) == RACIAL_TYPE_HUMANOID_ORC ||
	            GetRacialType(oTarget) == RACIAL_TYPE_HUMANOID_REPTILIAN) 
	        {
				float fDuration = RoundsToSeconds( GetScaledDuration(nRounds, oTarget) );
	            HoldTarget( oTarget, fDuration, nSaveDC );
	        }
	    }

        //Get next target in spell area
        oTarget = GetNextObjectInShape(SHAPE_SPHERE, RADIUS_SIZE_LARGE, locTarget );
    }
}



void HoldTarget( object oTarget, float fDuration, int nSaveDC )
{

    effect eParal 	= EffectParalyze(nSaveDC, SAVING_THROW_WILL);
	effect eHit = EffectVisualEffect( VFX_DUR_SPELL_HOLD_PERSON );
	eParal = EffectLinkEffects( eParal, eHit );

	//Fire cast spell at event for the specified target
	SignalEvent(oTarget, EventSpellCastAt(OBJECT_SELF, SPELL_HOLD_PERSON));

	float fDelay = GetRandomDelay( 0.25, 1.25 );

	//Make SR Check
	if ( MyResistSpell(OBJECT_SELF, oTarget, fDelay) == 0 )
	{
		//Make Will save
		if (!/*Will Save*/ MySavingThrow(SAVING_THROW_WILL, oTarget, nSaveDC, SAVING_THROW_TYPE_NONE, OBJECT_SELF, fDelay))
		{
			//Apply paralyze effect and VFX impact
			//DelayCommand( fDelay, ApplyEffectToObject(DURATION_TYPE_INSTANT, eHit, oTarget));
			DelayCommand( fDelay, ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eParal, oTarget, fDuration ) );
		}
	}

}