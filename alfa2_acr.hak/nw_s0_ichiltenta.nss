//:://////////////////////////////////////////////////////////////////////////
//:: Warlock Greater Invocation: Chilling Tentacles  ON ENTER
//:: nw_s0_chilltent.nss
//:: Created By: Brock Heinz - OEI
//:: Created On: 08/30/05
//:: Copyright (c) 2005 Obsidian Entertainment Inc.
//:://////////////////////////////////////////////////////////////////////////
/*
        Chilling Tentacles
        Complete Arcane, pg. 132
        Spell Level:	5
        Class: 		    Misc

        This functions identically to the Evard's black tentacles spell 
        (4th level wizard) except that each creature in the area of effect
        takes an additional 2d6 of cold damage per round regardless 
        if tentacles hit them or not.
	
		Upon entering the mass of "soul-chilling" rubbery tentacles the
		target is struck by 1d4 tentacles.  Each has a chance to hit of 5 + 1d20. 
		If it succeeds then it does 2d6 damage and the target must make
		a Fortitude Save versus paralysis or be paralyzed for 1 round.

*/
//:://////////////////////////////////////////////////////////////////////////

#include "X0_I0_SPELLS"
#include "x2_inc_spellhook"
#include "acr_spells_i"
#include "nwn2_inc_spells"


void main()
{
	//SpawnScriptDebugger();

    object oCaster = GetAreaOfEffectCreator();
    object oTarget = GetEnteringObject();
	int nSaveDC = GetSpellSaveDC();
    effect eDam;

    int nMetaMagic = GetMetaMagicFeat();
    int nDamage;
    int nAC = GetAC(oTarget);
    int nHits = d4();
    int nRoll;
    float fDelay;
    if (spellsIsTarget(oTarget, SPELL_TARGET_STANDARDHOSTILE, GetAreaOfEffectCreator()))
    {
        //Fire cast spell at event for the specified target
        SignalEvent(oTarget, EventSpellCastAt( oCaster, SPELL_I_CHILLING_TENTACLES));
		nHits = d4();
		float fDelta = RoundsToSeconds( 1 ) / IntToFloat( nHits );
		int nCounter;
			
        for (nCounter = 1; nCounter <= nHits; nCounter++)
        {
            fDelay = GetRandomDelay(1.0, 2.2);
			//fDelay = IntToFloat( nCounter ) * fDelta;
            nRoll = 5 + d20();
			
            if( ((nRoll >= nAC) || (nRoll == 25)) && (nRoll != 6) )
            {
                nDamage = d6() + 4;
                //Grapple damage is created by the tentacles' strength scores, not magical effects. No metamagic.
                /*if (nMetaMagic == METAMAGIC_MAXIMIZE)
                {
                    nDamage = 6 + 4;//Damage is at max
                }
                else if (nMetaMagic == METAMAGIC_EMPOWER)
                {
                    nDamage = nDamage + (nDamage/2); //Damage/Healing is +50%
                }*/
				
                eDam = EffectDamage(nDamage, DAMAGE_TYPE_BLUDGEONING, DAMAGE_POWER_PLUS_TWO);
                DelayCommand(fDelay, ApplyEffectToObject(DURATION_TYPE_INSTANT, eDam, oTarget));
            }
        }

        // Apply Cold Damage regardless of whether or not any tentacles struck the target.... 
        fDelay  = GetRandomDelay(0.4, 0.8);
        nDamage = d6(2);
        nDamage = ApplyMetamagicVariableMods( nDamage, 2*6 );
        eDam = EffectDamage(nDamage, DAMAGE_TYPE_COLD);
        DelayCommand(fDelay, ApplyEffectToObject(DURATION_TYPE_INSTANT, eDam, oTarget));
    }
}