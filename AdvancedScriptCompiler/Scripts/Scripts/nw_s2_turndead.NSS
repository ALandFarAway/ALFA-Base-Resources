//::///////////////////////////////////////////////
//:: Turn Undead
//:: NW_S2_TurnDead
//:: Copyright (c) 2001 Bioware Corp.
//:://////////////////////////////////////////////
/*
    Checks domain powers and class to determine
    the proper turning abilities of the casting
    character.
*/
//:://////////////////////////////////////////////
//:: Created By: Preston Watamaniuk
//:: Created On: Nov 2, 2001
//:: Updated On: Jul 15, 2003 - Georg Zoeller
//:://////////////////////////////////////////////
//:: MODIFIED MARCH 5 2003 for Blackguards
//:: MODIFIED JULY 24 2003 for Planar Turning to include turn resistance hd

//:: 6/26/06 - BDF-OEI: made a revision with excluding friendlies from being targeted
//:: 08.07.06 - PKM-OEI: Changed panic to rebuke to fix the problem of terrified undead running all over the map.  Details below.
/*  Rebuke Undead:
	The character is frozen in fear and can take no actions.  A cowering character takes -2 AC and loses her Dex bonus (if any.)
	This effect replaces the panic effect.  Lasts 10 rounds.

*/
//:: 9/06/06 - BDF-OEI: removed the outsider SR consideration b/c without Planar Turning feat
//::		it can be practiaclly impossible to turn any mid-level outsider that has 20 SR
// 10/18/06 - BDF(OEI): added the GetHasEffect check so that turned undead don't count against the HD (turn damage); per 3.5
//			added various Print functions to provide better feedback for outcome
//:: RPGPlayer 02/05/2009:
//::  Just like undead, turned outsiders will not count against HD limit for new turn attempts
//::  Turning failed message will not show for creatures that can't be turned

#include "x0_i0_spells"

//const int STRREF_TURNING_CHECK 		= 0;
const int STRREF_TURNING_LEVEL	 	= 184687;
const int STRREF_TURNING_DAMAGE 	= 184688;
const int STRREF_TURNING_ATTEMPT 	= 184689;
const int STRREF_TURNING_SUCCESS 	= 184690;
const int STRREF_TURNING_DESTROYED 	= 184691;
const int STRREF_TURNING_FAILED 	= 184692;
const int STRREF_HD_EXPENDED	 	= 184693;

const int TURN_RESULT_FAILURE 	= 0;
const int TURN_RESULT_SUCCESS 	= 1;
const int TURN_RESULT_DESTROYED = 2;

//void PrintTurningCheck( int nd20, int nChrMod );
void PrintTurningLevel( int nTurnLevel );
void PrintTurningDamage( int n2d6, int nChrMod, int nClassLevel );
void PrintTurningResult( object oTarget, int nClassLevel, int nTurnLevel, int nHDRemaining, int nResult = TURN_RESULT_FAILURE );

void main()
{

    int nClericLevel = GetLevelByClass(CLASS_TYPE_CLERIC);
    int nPaladinLevel = GetLevelByClass(CLASS_TYPE_PALADIN);
    int nBlackguardlevel = GetLevelByClass(CLASS_TYPE_BLACKGUARD);
    int nTotalLevel =  GetHitDice(OBJECT_SELF);

    int nTurnLevel = nClericLevel;
    int nClassLevel = nClericLevel;

    // GZ: Since paladin levels stack when turning, blackguard levels should stack as well
    // GZ: but not with the paladin levels (thus else if).
    if((nBlackguardlevel - 2) > 0 && (nBlackguardlevel > nPaladinLevel))
    {
        nClassLevel += (nBlackguardlevel - 2);
        nTurnLevel  += (nBlackguardlevel - 2);
    }
    else if((nPaladinLevel - 3) > 0)
    {
// JLR - OEI 06/21/05 NWN2 3.5
        nClassLevel += (nPaladinLevel - 3);
        nTurnLevel  += (nPaladinLevel - 3);
    }

    //Flags for bonus turning types
    int nElemental = GetHasFeat(FEAT_AIR_DOMAIN_POWER) + GetHasFeat(FEAT_EARTH_DOMAIN_POWER) + GetHasFeat(FEAT_FIRE_DOMAIN_POWER) + GetHasFeat(FEAT_WATER_DOMAIN_POWER);
    int nVermin = GetHasFeat(FEAT_PLANT_DOMAIN_POWER);// + GetHasFeat(FEAT_ANIMAL_COMPANION);
    int nConstructs = GetHasFeat(FEAT_DESTRUCTION_DOMAIN_POWER);
    int nGoodOrEvilDomain =  GetHasFeat(FEAT_GOOD_DOMAIN_POWER) + GetHasFeat(FEAT_EVIL_DOMAIN_POWER);
    int nPlanar = GetHasFeat(854);	// 854 maps to FEAT_EPIC_PLANAR_TURNING, which has been disabled in NWN2

    //Flag for improved turning ability
    int nSun = GetHasFeat(FEAT_SUN_DOMAIN_POWER);

    //Make a turning check roll, modify if have the Sun Domain
    int nChrMod = GetAbilityModifier(ABILITY_CHARISMA);
    int nTurnCheck = d20();              //The roll to apply to the max HD of undead that can be turned --> nTurnLevel
    if(nSun == TRUE)
    {
        nTurnCheck += d4();
    }	
	//PrintTurningCheck( nTurnCheck, nChrMod );
	nTurnCheck += nChrMod;
	
    //Determine the maximum HD of the undead that can be turned.
    if(nTurnCheck <= 0)
    {
        nTurnLevel -= 4;
    }
    else if(nTurnCheck >= 1 && nTurnCheck <= 3)
    {
        nTurnLevel -= 3;
    }
    else if(nTurnCheck >= 4 && nTurnCheck <= 6)
    {
        nTurnLevel -= 2;
    }
    else if(nTurnCheck >= 7 && nTurnCheck <= 9)
    {
        nTurnLevel -= 1;
    }
    else if(nTurnCheck >= 10 && nTurnCheck <= 12)
    {
        //Stays the same
    }
    else if(nTurnCheck >= 13 && nTurnCheck <= 15)
    {
        nTurnLevel += 1;
    }
    else if(nTurnCheck >= 16 && nTurnCheck <= 18)
    {
        nTurnLevel += 2;
    }
    else if(nTurnCheck >= 19 && nTurnCheck <= 21)
    {
        nTurnLevel += 3;
    }
    else if(nTurnCheck >= 22)
    {
        nTurnLevel += 4;
    }
	
	PrintTurningLevel( nTurnLevel );
	
    int nTurnHD = d6(2);
    if(nSun == TRUE)
    {
        nTurnHD += d6();
    }
	PrintTurningDamage( nTurnHD, nChrMod, nClassLevel );
	nTurnHD += (nChrMod + nClassLevel);   //The number of HD of undead that can be turned.
	

    //Gets all creatures in a 20m radius around the caster and turns them or not.  If the creatures
    //HD are 1/2 or less of the nClassLevel then the creature is destroyed.
    //int nCnt = 1;	// 6/26/06 - BDF-OEI: no longer necessary with GetNthObjectInShape()
    int nHD, nRacial, nHDCount, bValid, nDamage, nDex;
    nHDCount = 0;
    effect eVis = EffectVisualEffect( VFX_HIT_TURN_UNDEAD );	// only used for the impact effect on constructs; all other impact effects will be as specified in VFX_FEAT_TURN_UNDEAD
    
	
	//effect eVisTurn = EffectVisualEffect(VFX_DUR_MIND_AFFECTING_FEAR);	// no longer using NWN1 VFX
    	
	effect eVisTurn = EffectVisualEffect( VFX_HIT_TURN_UNDEAD );	// makes use of NWN2 VFX
    effect eDamage;
    effect eAC = EffectACDecrease( 2 ); //Rebuke behavior, lowers AC by 2.
	
	effect eTurned = EffectTurned();
    effect eDur = EffectVisualEffect(882);
    effect eLink = EffectLinkEffects(eVisTurn, eTurned);
	eLink = EffectLinkEffects( eLink, eAC );
    eLink = EffectLinkEffects(eLink, eDur); 

    effect eDeath = SupernaturalEffect(EffectDeath(TRUE));
	location lMyLocation = GetLocation( OBJECT_SELF );

    effect eImpactVis = EffectVisualEffect(VFX_FEAT_TURN_UNDEAD);	// no longer using NWN1 VFX
    ApplyEffectAtLocation(DURATION_TYPE_INSTANT, eImpactVis, lMyLocation);	// no longer using NWN1 VFX

    //Get nearest enemy within 20m (60ft)
    //Why are you using GetNearest instead of GetFirstObjectInShape
    //object oTarget = GetNearestCreature(CREATURE_TYPE_IS_ALIVE, TRUE , OBJECT_SELF, nCnt,CREATURE_TYPE_PERCEPTION , PERCEPTION_SEEN);
    //6/26/06 - BDF-OEI: sounds good to me
	float fSize = 2.0 * RADIUS_SIZE_COLOSSAL;	// RADIUS_SIZE_COLOSSAL ~= 30.0 ft
	object oTarget = GetFirstObjectInShape( SHAPE_SPHERE, fSize, lMyLocation, TRUE );	

	//SpawnScriptDebugger();
	
    while( GetIsObjectValid(oTarget) && nHDCount < nTurnHD )
    {
        if( spellsIsTarget(oTarget, SPELL_TARGET_STANDARDHOSTILE, OBJECT_SELF) && oTarget != OBJECT_SELF )	// AFW-OEI 06/28/2006: Hopefully, the spellsIsTarget finally excludes all friendlies
        {
            nRacial = GetRacialType(oTarget);
			nDex = GetAbilityScore( oTarget, ABILITY_DEXTERITY );
			
			/*	// NWN1 code from the days of Planar Turning (cut from NWN2)
            if ( nRacial == RACIAL_TYPE_OUTSIDER )
            {
                if ( nPlanar )
                {
                     //Planar turning decreases spell resistance against turning by 1/2
                     nHD = GetHitDice(oTarget) + (GetSpellResistance(oTarget) /2) + GetTurnResistanceHD(oTarget);
                }
                else
                {
					int nSR = GetSpellResistance(oTarget);
					int nTR = GetTurnResistanceHD(oTarget);
                    nHD = GetHitDice(oTarget) + (nSR + nTR);
                }
			}
            else //(full turn resistance)
            {
                  nHD = GetHitDice(oTarget) + GetTurnResistanceHD(oTarget);
            }
			*/
			
			nHD = GetHitDice(oTarget) + GetTurnResistanceHD(oTarget);

            if(nHD <= nTurnLevel && nHD <= (nTurnHD - nHDCount))
            {
                //Check the various domain turning types
                // 10/18/06 - BDF(OEI): added the GetHasEffect check so that turned undead don't count against the HD (turn damage); per 3.5
				if(nRacial == RACIAL_TYPE_UNDEAD && !GetHasEffect(EFFECT_TYPE_TURNED, oTarget) )	
                {
                    bValid = TRUE;
                }
                else if (nRacial == RACIAL_TYPE_VERMIN && nVermin > 0)
                {
                    bValid = TRUE;
                }
                else if (nRacial == RACIAL_TYPE_ELEMENTAL && nElemental > 0)
                {
                    bValid = TRUE;
                }
                else if (nRacial == RACIAL_TYPE_CONSTRUCT && nConstructs > 0)
                {
                    SignalEvent(oTarget, EventSpellCastAt(OBJECT_SELF, SPELLABILITY_TURN_UNDEAD));
                    nDamage = d3(nTurnLevel);
                    eDamage = EffectDamage(nDamage, DAMAGE_TYPE_MAGICAL);
                    ApplyEffectToObject(DURATION_TYPE_INSTANT, eVis, oTarget);
                    DelayCommand(0.01, ApplyEffectToObject(DURATION_TYPE_INSTANT, eDamage, oTarget));
                    nHDCount += nHD;
                }
                //FIX: turned outsiders should not count against HD limit either
                else if (nRacial == RACIAL_TYPE_OUTSIDER && (nGoodOrEvilDomain+nPlanar > 0) && !GetHasEffect(EFFECT_TYPE_TURNED, oTarget) )
                {
                    bValid = TRUE;
                }
                // * if wearing gauntlets of the lich,then can be turned
                else if (GetIsObjectValid(GetItemPossessedBy(oTarget, "x2_gauntletlich")) == TRUE)
                {
                    if (GetTag(GetItemInSlot(INVENTORY_SLOT_ARMS)) == "x2_gauntletlich")
                    {
                        bValid = TRUE;
                    }
                }

                //Apply results of the turn
                if( bValid == TRUE)
                {
                    //ApplyEffectToObject(DURATION_TYPE_INSTANT, eVis, oTarget);

                    if ( /*nPlanar>0 &&*/ nRacial == RACIAL_TYPE_OUTSIDER)
                    {
                        effect ePlane = EffectVisualEffect( VFX_HIT_SPELL_HOLY );
                        ApplyEffectToObject(DURATION_TYPE_INSTANT, ePlane, oTarget);
                    }
                    //if(IntToFloat(nClassLevel)/2.0 >= IntToFloat(nHD))
                    //{

                    if((nClassLevel/2) >= nHD)
                    {
                        if ( /*nPlanar>0 &&*/ nRacial == RACIAL_TYPE_OUTSIDER)
                        {
                            effect ePlane2 = EffectVisualEffect( VFX_IMP_UNSUMMON );
							ApplyEffectToObject(DURATION_TYPE_INSTANT, ePlane2, oTarget);
                        }

                        //effect ePlane2 = EffectVisualEffect(VFX_IMP_DIVINE_STRIKE_HOLY);	// no longer using NWN1 VFX
                        effect ePlane2 = EffectVisualEffect( VFX_HIT_SPELL_HOLY );	// makes use of NWN2 VFX

                        //Fire cast spell at event for the specified target
                        SignalEvent(oTarget, EventSpellCastAt(OBJECT_SELF, SPELLABILITY_TURN_UNDEAD));
						PrintTurningResult( oTarget, nClassLevel, nTurnLevel, (nTurnHD - nHDCount), TURN_RESULT_DESTROYED );
                        //Destroy the target
                        DelayCommand(0.1f, ApplyEffectToObject(DURATION_TYPE_INSTANT, eDeath, oTarget));
                    }
                    else
                    {
                        //Turn the target
                        //Fire cast spell at event for the specified target
                        SignalEvent(oTarget, EventSpellCastAt(OBJECT_SELF, SPELLABILITY_TURN_UNDEAD));
                        AssignCommand(oTarget, ActionMoveAwayFromObject(OBJECT_SELF, TRUE));
                        ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eLink, oTarget, RoundsToSeconds(10));
						PrintTurningResult( oTarget, nClassLevel, nTurnLevel, (nTurnHD - nHDCount), TURN_RESULT_SUCCESS );
						
						//Rebuke behavior.  If the target has Dex greater than 10, this logic reduces it to 10, everyone else is left alone.
						if ( nDex>10 ) 
						{
							int nDecrease = (nDex - 10);
							effect eDec = EffectAbilityDecrease( ABILITY_DEXTERITY, nDecrease);
							ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eDec, oTarget, RoundsToSeconds(10));
						}
                    }
                    nHDCount = nHDCount + nHD;
                }
            }
			//FIX: Don't show this message for creatures that can't be turned (only undead and outsiders can be turned in NWN2)
			else if (nRacial == RACIAL_TYPE_UNDEAD || (nRacial == RACIAL_TYPE_OUTSIDER && nGoodOrEvilDomain+nPlanar > 0))
			{
				PrintTurningResult( oTarget, nClassLevel, nTurnLevel, (nTurnHD - nHDCount) );
			}
			
            bValid = FALSE;
        }
        //nCnt++;
        //oTarget = GetNearestCreature(CREATURE_TYPE_IS_ALIVE,TRUE, OBJECT_SELF, nCnt,CREATURE_TYPE_PERCEPTION , PERCEPTION_SEEN);
		oTarget = GetNextObjectInShape( SHAPE_SPHERE, fSize, lMyLocation, TRUE );
    }
}

// Chat window feeback for the turn attempt
/*
void PrintTurningCheck( int nd20, int nChrMod )
{
	string sName = GetName( OBJECT_SELF );
	string sd20 = IntToString( nd20 );
	string sChrMod = IntToString( nChrMod );
	string sResult = IntToString( nd20 + nChrMod );
	string sLocalizedText = GetStringByStrRef( STRREF_TURNING_CHECK );
	string sTurningCheckFeedbackMsg = "<c=paleturquoise>" + 
									  sName + 
									  "</c><c=tomato> : Turning Check : " sLocalizedText + 
									  sResult + 
									  " : (" + 
									  sd20 + 
									  " + " + 
									  sChrMod + 
									  " = " + 
									  sResult + 
									  ")</c>";

	SendMessageToPC( OBJECT_SELF, sTurningCheckFeedbackMsg );
}
*/

void PrintTurningLevel( int nTurnLevel )
{
	string sName = GetName( OBJECT_SELF );
	string sTurnLevel = IntToString( nTurnLevel );
	string sLocalizedText = GetStringByStrRef( STRREF_TURNING_LEVEL );
	string sTurningLevelFeedbackMsg = "<c=tomato>" + sLocalizedText + " : </c>" +  sTurnLevel;

	SendMessageToPC( OBJECT_SELF, sTurningLevelFeedbackMsg );
}

void PrintTurningDamage( int n2d6, int nChrMod, int nClassLevel )
{
	string sName = GetName( OBJECT_SELF );
	string s2d6 = IntToString( n2d6 );
	string sChrMod = IntToString( nChrMod );
	string sClassLevel = IntToString( nClassLevel );
	string sResult = IntToString( n2d6 + nChrMod + nClassLevel );
	string sLocalizedText = GetStringByStrRef( STRREF_TURNING_DAMAGE );
	string sTurningDamageFeedbackMsg = "<c=tomato>" + sLocalizedText + " : </c>" + sResult;
	
	SendMessageToPC( OBJECT_SELF, sTurningDamageFeedbackMsg );
}

void PrintTurningResult( object oTarget, int nClassLevel, int nTurnLevel, int nHDRemaining, int nResult = TURN_RESULT_FAILURE )
{
	string sName = GetName( OBJECT_SELF );
	int nTargetHD = GetHitDice( oTarget ) + GetTurnResistanceHD( oTarget );
	string sTargetHD = IntToString( nTargetHD );
	string sTargetName = GetName( oTarget );
	string sTurnLevel = IntToString( nTurnLevel );
	string sHDRemaining = IntToString( nHDRemaining );
	string sHalfClassLevel = IntToString( nClassLevel / 2 );
	string sLocalizedTextAttempt = GetStringByStrRef( STRREF_TURNING_ATTEMPT );
	string sLocalizedTextResultFailure = GetStringByStrRef( STRREF_TURNING_FAILED );
	string sLocalizedTextResultSuccess = GetStringByStrRef( STRREF_TURNING_SUCCESS );
	string sLocalizedTextResultDestroyed = GetStringByStrRef( STRREF_TURNING_DESTROYED );
	string sLocalizedTextHDExpended = GetStringByStrRef( STRREF_HD_EXPENDED );
	string sTurningDamageFeedbackMsg = "<c=paleturquoise>" + sName + " " + sLocalizedTextAttempt + " " + sTargetName + " : </c><c=tomato>";
	
	if ( nResult == TURN_RESULT_SUCCESS )
	{
		sTurningDamageFeedbackMsg += ( sLocalizedTextResultSuccess + " (" + sTargetHD + " " + sLocalizedTextHDExpended + ")</c>" );
	}
	else if ( nResult == TURN_RESULT_DESTROYED )
	{
		sTurningDamageFeedbackMsg += ( sLocalizedTextResultDestroyed + " (" + sTargetHD + " " + sLocalizedTextHDExpended + ")</c>" );
	}
	else
	{
		sTurningDamageFeedbackMsg += sLocalizedTextResultFailure + "</c>";
	}
	
	SendMessageToPC( OBJECT_SELF, sTurningDamageFeedbackMsg );
}