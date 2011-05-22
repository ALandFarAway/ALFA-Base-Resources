//:://///////////////////////////////////////////////
//::Song of Discord
//:: nw_s0_sngodisc.nss
//:: Copyright (c) 2005 Obsidian Entertainment Inc.
//::////////////////////////////////////////////////
//:: Created By: Brock Heinz
//:: Created On: 08/11/05
//::////////////////////////////////////////////////
/*
        5.4.5.2.2	Song of Discord
        PHB, pg. 281
        School:		    Enchantment (Compulsion) [Mind-Affecting, Sonic]
        Components: 	Verbal, Somatic
        Range:		    Medium
        Target:		    Creature within a 20-ft.-radius
        Duration:		Round / level
        Saving Throw:	Will negates
        Spell Resist:	Yes

        This spell causes those within its area to turn on each other rather than 
        attack their foes. Each creature has a 50% chance of attacking their nearest 
        target rather than each other 


*/
//:: PKM-OEI: 08.19.06 VFX update


#include "X0_I0_SPELLS"
#include "x2_inc_spellhook"
#include "x2_i0_spells"

void main()
{
    if (!X2PreSpellCastCode())
    {
	    // If code within the PreSpellCastHook (i.e. UMD) reports FALSE, do not run this spell
        return;
    }

    //Declare major variables
	object oCaster 	= OBJECT_SELF;
    int nCasterLevel= GetCasterLevel(oCaster);
    effect eImpact 	= EffectVisualEffect(VFX_HIT_AOE_ENCHANTMENT);
    //effect eVis	 	= EffectVisualEffect(VFX_IMP_CONFUSION_S);
    effect eConfuse = EffectConfused();
    //effect eMind 	= EffectVisualEffect(VFX_DUR_MIND_AFFECTING_DISABLED);
    effect eDur 	= EffectVisualEffect( VFX_DUR_SPELL_SONG_OF_DISCORD );
	location lTarget = GetSpellTargetLocation();
    float fDelay	= 0.0f;
	int nDuration 	= 0;
    int nMetaMagic = GetMetaMagicFeat();

    //Link duration VFX and confusion effects
    effect eLink = EffectLinkEffects(eDur, eConfuse);
    //eLink = EffectLinkEffects(eLink, eDur);
	
	// Run the visual effect
    ApplyEffectAtLocation(DURATION_TYPE_INSTANT, eImpact, lTarget );

    //Search through target area
	object oTarget = GetFirstObjectInShape(SHAPE_SPHERE, RADIUS_SIZE_MEDIUM, lTarget);
	while (GetIsObjectValid(oTarget))
	{
        if ( spellsIsTarget(oTarget, SPELL_TARGET_STANDARDHOSTILE, oCaster) )
    	{
           //Fire cast spell at event for the specified target
           SignalEvent( oTarget, EventSpellCastAt(oCaster, SPELL_SONG_OF_DISCORD) );
           fDelay = GetRandomDelay();

           //Make SR Check and faction check
           if ( !MyResistSpell(oCaster, oTarget, fDelay) )
    	   {
                //Make Will Save
                if (!MySavingThrow(SAVING_THROW_WILL, oTarget, GetSpellSaveDC(), SAVING_THROW_TYPE_MIND_SPELLS, oCaster, fDelay))
                {
                   //Apply linked effect and VFX Impact
                   nDuration = GetScaledDuration( nCasterLevel, oTarget );

                   //Perform metamagic checks
                   if (nMetaMagic == METAMAGIC_EXTEND)
                   {
                       nDuration = nDuration * 2;
                   }

                   DelayCommand(fDelay, ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eLink, oTarget, RoundsToSeconds( nDuration ) ));
                   //DelayCommand(fDelay, ApplyEffectToObject(DURATION_TYPE_INSTANT, eVis, oTarget));
                }
            }
        }

        //Get next target in the shape
        oTarget = GetNextObjectInShape(SHAPE_SPHERE, RADIUS_SIZE_MEDIUM, lTarget);
	}
}