//::///////////////////////////////////////////////
//:: Shadow Magic Missile
//:: acr_S0_Shadow_MagMiss
//:: Copyright (c) 2001 Bioware Corp.
//:://////////////////////////////////////////////
/*
// A missile of magical energy darts forth from your
// fingertip and unerringly strikes its target. The
// missile deals 1d4+1 points of damage.
//
// For every two extra levels of experience past 1st, you
// gain an additional missile.
//
// Shadow Evocation Version
*/
//:://////////////////////////////////////////////
//:: Created By: Preston Watamaniuk
//:: Created On: April 10, 2001
//:://////////////////////////////////////////////
//:: Last Updated By: NESChampion, 17 November 2011

#include "nwn2_inc_spells"


#include "NW_I0_SPELLS"    
#include "x2_inc_spellhook" 

void main()
{

/* 
  Spellcast Hook Code 
  Added 2003-06-23 by GeorgZ
  If you want to make changes to all spells,
  check x2_inc_spellhook.nss to find out more
  
*/

    if (!ACR_PrecastEvent())
    {
	// If code within the PreSpellCastHook (i.e. UMD) reports FALSE, do not run this spell
        return;
    }

// End of Spell Cast Hook


    //Declare major variables
    object oTarget = GetSpellTargetObject();
    int nCasterLvl = GetCasterLevel(OBJECT_SELF);
    int nMissiles = (nCasterLvl + 1)/2;
    //effect eMissile = EffectVisualEffect(VFX_IMP_MIRV);	// handled by SpawnSpellProjectile()
    effect eVis = EffectVisualEffect(VFX_IMP_MAGBLUE);
    float fDelay, fTime, fTime2;
	int nSpell = GetSpellId();
	int nPathType = PROJECTILE_PATH_TYPE_DEFAULT;
	location lSourceLoc = GetLocation( OBJECT_SELF );
	location lTarget = GetLocation( oTarget );
    int nCnt;
	float fTravelTime;
	
    if (spellsIsTarget(oTarget, SPELL_TARGET_STANDARDHOSTILE, OBJECT_SELF))
    {
        //Fire cast spell at event for the specified target
        SignalEvent(oTarget, EventSpellCastAt(OBJECT_SELF, SPELL_MAGIC_MISSILE));
        
		//Limit missiles to five
        if (nMissiles > 5)
        {
            nMissiles = 5;
        }

	effect eMantle = GetFirstEffect(oTarget);
	while (GetIsEffectValid(eMantle) &&
		(GetEffectSpellId(eMantle) != SPELL_LEAST_SPELL_MANTLE) &&
		(GetEffectSpellId(eMantle) != SPELL_LESSER_SPELL_MANTLE) &&
		(GetEffectSpellId(eMantle) != SPELL_SPELL_MANTLE) &&
		(GetEffectSpellId(eMantle) != SPELL_GREATER_SPELL_MANTLE))
	{
		eMantle = GetNextEffect(oTarget);
	}
	if (GetIsEffectValid(eMantle)) 
	{
		MyResistSpell(OBJECT_SELF, oTarget, fDelay);
		for (nCnt = 1; nCnt <= nMissiles; nCnt++)
		{
			fDelay = GetRandomDelay( 0.1f, 0.5f ) + (0.5f * IntToFloat(nCnt));
			DelayCommand( fDelay, SpawnSpellProjectile(OBJECT_SELF, oTarget, lSourceLoc, lTarget, nSpell, nPathType) );
		}
	}
	else
	{
		//Apply a single damage hit for each missile instead of as a single mass
		//Make Will save versus fear
        if(!MySavingThrow(SAVING_THROW_WILL, oTarget, GetSpellSaveDC(), SAVING_THROW_TYPE_NONE))
        {
			for (nCnt = 1; nCnt <= nMissiles; nCnt++)
			{
				fTravelTime = GetProjectileTravelTime( lSourceLoc, lTarget, nPathType );
				if ( nCnt == 0 )	fDelay = 0.0f;
				else				fDelay = GetRandomDelay( 0.1f, 0.5f ) + (0.5f * IntToFloat(nCnt));
			
			/*
			fTime = fDelay + ((nCnt - 1) * 0.25);
			fTime2 = ((nCnt - 1) * 0.25);
			*/			        
			
				//Make SR Check
	        	if (!MyResistSpell(OBJECT_SELF, oTarget, fDelay))
		  		{
            	    //Roll damage
                	int nDam = d4(1) + 1;
     	            //Enter Metamagic conditions
                	nDam = ApplyMetamagicVariableMods(nDam, 5);

                	//Set damage effect
                	effect eDam = EffectDamage(nDam, DAMAGE_TYPE_MAGICAL);
                	//Apply the MIRV and damage effect
                	DelayCommand(fDelay + fTravelTime, ApplyEffectToObject(DURATION_TYPE_INSTANT, eDam, oTarget));
                	DelayCommand(fDelay + fTravelTime, ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eVis, oTarget));
				}
				DelayCommand( fDelay, SpawnSpellProjectile(OBJECT_SELF, oTarget, lSourceLoc, lTarget, nSpell, nPathType) );
       		}
		}
		else
        {
			for (nCnt = 1; nCnt <= nMissiles; nCnt++)
			{
				fTravelTime = GetProjectileTravelTime( lSourceLoc, lTarget, nPathType );
				if ( nCnt == 0 )	fDelay = 0.0f;
				else				fDelay = GetRandomDelay( 0.1f, 0.5f ) + (0.5f * IntToFloat(nCnt));
			
			/*
			fTime = fDelay + ((nCnt - 1) * 0.25);
			fTime2 = ((nCnt - 1) * 0.25);
			*/			        
			
				//Make SR Check
	        	if (!MyResistSpell(OBJECT_SELF, oTarget, fDelay))
		  		{
            	    //Roll damage
                	int nDam = d4(1) + 1;
     	            //Enter Metamagic conditions
                	nDam = ApplyMetamagicVariableMods(nDam, 5);
					nDam = nDam/5;
					if(nDam < 1)
					{
						nDam = 1;
					}

                	//Set damage effect
                	effect eDam = EffectDamage(nDam, DAMAGE_TYPE_MAGICAL);
                	//Apply the MIRV and damage effect
                	DelayCommand(fDelay + fTravelTime, ApplyEffectToObject(DURATION_TYPE_INSTANT, eDam, oTarget));
                	DelayCommand(fDelay + fTravelTime, ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eVis, oTarget));
				}
				DelayCommand( fDelay, SpawnSpellProjectile(OBJECT_SELF, oTarget, lSourceLoc, lTarget, nSpell, nPathType) );
       		}
		}
	}
	}
}