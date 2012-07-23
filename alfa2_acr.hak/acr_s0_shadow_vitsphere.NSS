//::///////////////////////////////////////////////
//:: Shadow Vitriolic Sphere
//:: acr_S0_Shadow_Vitsphere.nss
//:: Copyright (c) 2001 Bioware Corp.
//:://////////////////////////////////////////////
/*
        5.1.5.4.6	Vitriolic Sphere (B)
        E-mail from WotC, up-coming Complete Arcane
        School:		    Conjuration (Creation) [Acid]
        Components: 	Verbal, Somatic
        Range:		    Long
        Target:		    10 ft. radius burst
        Duration:		Instantaneous
        Saving Throw:	Reflex half
        Spell Resist:	Yes

        You conjure a sphere of sizzling emerald acid that streams towards the 
        target and explodes. Everything within the area of affect is drenched 
        with a potent acid that deals 1d4 points of acid damage per caster level 
        (maximum 15d4). Any creature who fails their Reflex save is subject to 
        continuing acid damage in subsequent rounds. On the second round, the 
        acid deals 6d4 damage (Reflex half); on the third round, it deals 3d4 
        damage (Reflex half); and on the fourth round it deals no more damage. 
        Once an affected creature succeeds on a Reflex save, it suffers no more 
        continuing damage.

        [Art] An emerald acid ball needs to fly to the target and explode. If 
        it could sizzle and sound like Alien type of acid burning in the area 
        that would be great.

*/


// JLR - OEI 08/23/05 -- Metamagic changes
#include "nwn2_inc_spells"


#include "X0_I0_SPELLS"
#include "x2_inc_spellhook"
#include "x2_i0_spells"
#include "acr_spells_i"

const float SPELL_EFFECT_RADIUS = 3.048;
const float DELAY_ONE_ROUND     = 6.0f;

void DamageVictim(int nDice, object oVictim, object oCaster, int nSpellSaveDC, int nMetaMagic )
{
	float fDelay;
	// Returns: 0 if the saving throw roll failed
	// Returns: 1 if the saving throw roll succeeded
	// Returns: 2 if the target was immune to the save type specified
    int nSave = ReflexSave( oVictim, nSpellSaveDC, SAVING_THROW_TYPE_ACID, oCaster );

    SignalEvent(oVictim, EventSpellCastAt(oCaster, SPELL_VITRIOLIC_SPHERE));

	//SR applies to shadow spells.
	if (!MyResistSpell(OBJECT_SELF, oVictim, fDelay))
    {
		//Caster automatically disbelieves.
		if(oVictim != OBJECT_SELF)
		{
			//Make Will save to disbelieve
       		if(!MySavingThrow(SAVING_THROW_WILL, oVictim, GetSpellSaveDC(), SAVING_THROW_TYPE_NONE))
           	{
    			if ( nSave != 2 )
    			{
    				int nDamage = d4(nDice);
					int nMaxVal = nDice * 4; // nDice * d4
    				//Resolve metamagic
    				//nDamage = ApplyMetamagicVariableMods( nDamage, nMaxVal );   		
    				if (nMetaMagic == METAMAGIC_MAXIMIZE)
    				{
    				 	nDamage = nMaxVal;
    				}
    				if (nMetaMagic == METAMAGIC_EMPOWER)
    				{
    				    nDamage = nDamage + (nDamage/2);
    				}

					// A successful saving throw results in half damage
					if ( nSave == 1 )
					nDamage = nDamage / 2;

					if ((nDice > 6) && (nSave == 1))
					{
						if (GetHasFeat(FEAT_EVASION, oVictim) || GetHasFeat(FEAT_IMPROVED_EVASION, oVictim))
							nDamage = 0;
					}
					if ((nDice > 6) && (nSave == 0))
					{
						if (GetHasFeat(FEAT_IMPROVED_EVASION, oVictim))
							nDamage = nDamage / 2;
					}

					if (nDamage > 0)
       				{
       					effect eVisual = EffectVisualEffect(VFX_HIT_SPELL_ACID);
       					ApplyEffectToObject( DURATION_TYPE_INSTANT, eVisual, oVictim );        
        						
						effect eDamage  = EffectDamage(nDamage, DAMAGE_TYPE_ACID);
       					DelayCommand(0.0f, ApplyEffectToObject( DURATION_TYPE_INSTANT, eDamage, oVictim )); //FIX: if not delayed bad things happen
       				}
				}
				if ((nSave == 0) && (nDice > 6))
    			{
    	    		DelayCommand( 6.0, DamageVictim( 6, oVictim, oCaster, nSpellSaveDC, nMetaMagic ) );
    			}
    			else if ((nSave == 0) && (nDice == 6))
    			{
    			    DelayCommand( 6.0, DamageVictim( 3, oVictim, oCaster, nSpellSaveDC,  nMetaMagic ) );
    			}
			}
			else
			{
				if ( nSave != 2 )
    			{
    				int nDamage = d4(nDice);
					int nMaxVal = nDice * 4; // nDice * d4
    				//Resolve metamagic
    				//nDamage = ApplyMetamagicVariableMods( nDamage, nMaxVal );   		
    				if (nMetaMagic == METAMAGIC_MAXIMIZE)
    				{
    				 	nDamage = nMaxVal;
    				}
    				if (nMetaMagic == METAMAGIC_EMPOWER)
    				{
    				    nDamage = nDamage + (nDamage/2);
    				}

					// A successful saving throw results in half damage
					if ( nSave == 1 )
					nDamage = nDamage / 2;
					
					//Reduce for disbelief
					nDamage = (nDamage*3)/5;

					if ((nDice > 6) && (nSave == 1))
					{
						if (GetHasFeat(FEAT_EVASION, oVictim) || GetHasFeat(FEAT_IMPROVED_EVASION, oVictim))
							nDamage = 0;
					}
					if ((nDice > 6) && (nSave == 0))
					{
						if (GetHasFeat(FEAT_IMPROVED_EVASION, oVictim))
							nDamage = nDamage / 2;
					}
					

					if (nDamage > 0)
       				{
       					effect eVisual = EffectVisualEffect(VFX_HIT_SPELL_ACID);
       					ApplyEffectToObject( DURATION_TYPE_INSTANT, eVisual, oVictim );        
        						
						effect eDamage  = EffectDamage(nDamage, DAMAGE_TYPE_ACID);
       					DelayCommand(0.0f, ApplyEffectToObject( DURATION_TYPE_INSTANT, eDamage, oVictim )); //FIX: if not delayed bad things happen
       				}
				}
				if ((nSave == 0) && (nDice > 6))
    			{
    	    		DelayCommand( 6.0, DamageVictim( 6, oVictim, oCaster, nSpellSaveDC, nMetaMagic ) );
    			}
    			else if ((nSave == 0) && (nDice == 6))
    			{
    			    DelayCommand( 6.0, DamageVictim( 3, oVictim, oCaster, nSpellSaveDC,  nMetaMagic ) );
    			}
			}
		}
		else
		{
			if ( nSave != 2 )
    		{
    			int nDamage = d4(nDice);
				int nMaxVal = nDice * 4; // nDice * d4
    			//Resolve metamagic
    			//nDamage = ApplyMetamagicVariableMods( nDamage, nMaxVal );   		
    			if (nMetaMagic == METAMAGIC_MAXIMIZE)
    			{
    			 	nDamage = nMaxVal;
    			}
    			if (nMetaMagic == METAMAGIC_EMPOWER)
    			{
    			    nDamage = nDamage + (nDamage/2);
    			}

				// A successful saving throw results in half damage
				if ( nSave == 1 )
					nDamage = nDamage / 2;
				
				//Reduce for disbelief
				nDamage = (nDamage*3)/5;

				if ((nDice > 6) && (nSave == 1))
				{
					if (GetHasFeat(FEAT_EVASION, oVictim) || GetHasFeat(FEAT_IMPROVED_EVASION, oVictim))
						nDamage = 0;
				}
				if ((nDice > 6) && (nSave == 0))
				{
					if (GetHasFeat(FEAT_IMPROVED_EVASION, oVictim))
						nDamage = nDamage / 2;
				}
					
				if (nDamage > 0)
       			{
       				effect eVisual = EffectVisualEffect(VFX_HIT_SPELL_ACID);
       				ApplyEffectToObject( DURATION_TYPE_INSTANT, eVisual, oVictim );        
        						
					effect eDamage  = EffectDamage(nDamage, DAMAGE_TYPE_ACID);
       				DelayCommand(0.0f, ApplyEffectToObject( DURATION_TYPE_INSTANT, eDamage, oVictim )); //FIX: if not delayed bad things happen
       			}
			}
			if ((nSave == 0) && (nDice > 6))
    		{
    	   		DelayCommand( 6.0, DamageVictim( 6, oVictim, oCaster, nSpellSaveDC, nMetaMagic ) );
    		}
    		else if ((nSave == 0) && (nDice == 6))
    		{
    		    DelayCommand( 6.0, DamageVictim( 3, oVictim, oCaster, nSpellSaveDC,  nMetaMagic ) );
    		}
		}
	}
}


void RunRecurringEffects( location lTarget, object oCaster, int nCasterLevel, int nSpellSaveDC, int nRound )
{
	int nDice = 0;	
	if (nCasterLevel > 15)
	{
		nDice = 15;
	}
	else
	{
		nDice = nCasterLevel;
	}

	if ( nDice == 0 )
	{
		return; // WTF?
	}

    int nMetaMagic = GetMetaMagicFeat();
    object oVictim = GetFirstObjectInShape(SHAPE_SPHERE, SPELL_EFFECT_RADIUS, lTarget, TRUE, OBJECT_TYPE_CREATURE | OBJECT_TYPE_PLACEABLE );

    while ( GetIsObjectValid(oVictim) )
    {
        if ( spellsIsTarget( oVictim, SPELL_TARGET_STANDARDHOSTILE, oCaster) )
        {
			// Add a delay to the damage done to nearby victims, based on their
			// distance from the target.
            float fDistance = GetDistanceBetweenLocations( lTarget, GetLocation(oVictim) );
			float fDelay = 0.15f * fDistance;
			if ( fDelay > 1.0f )  // clamp it.. (it would be nice if this were a curve, but..)
			{
				fDelay = 1.0f;
			}
			
			//if (ReflexSave( oVictim, nSpellSaveDC, SAVING_THROW_TYPE_ACID, oCaster ))
			{
				DamageVictim( nDice, oVictim, oCaster, nSpellSaveDC, nMetaMagic );
			}
        }
        oVictim = GetNextObjectInShape(SHAPE_SPHERE, SPELL_EFFECT_RADIUS, lTarget, TRUE, OBJECT_TYPE_CREATURE | OBJECT_TYPE_PLACEABLE );
    }
}

void main()
{
	// uncomment for debugging.. 
	//SpawnScriptDebugger();
    

    //--------------------------------------------------------------------------
    // Spellcast Hook Code
    // If you want to make changes to all spells, check x2_inc_spellhook.nss to
    // find out more
    //--------------------------------------------------------------------------
    if (!ACR_PrecastEvent())
    {
        return;
    }
    // End of Spell Cast Hook


    //--------------------------------------------------------------------------
    // Get the dependent info
	// Some things (caster level, save DC), will not be valid after a delay
    //--------------------------------------------------------------------------
    object oCaster   = OBJECT_SELF;
    location lTarget = GetSpellTargetLocation();
	int nSpellSaveDC = GetSpellSaveDC();
	int nCasterLevel = GetCasterLevel(oCaster); 

	RunRecurringEffects( lTarget, oCaster, nCasterLevel, nSpellSaveDC, 1 );
}