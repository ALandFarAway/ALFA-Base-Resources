//::///////////////////////////////////////////////
//:: Tenacious Plague
//:: NW_S0_itenplage
//:: Copyright (c) 2006 Obsidian Entertainment Inc.
//:://////////////////////////////////////////////
/*
    The warlock calls forth swarms of magical 
    locusts that harass and bite hostile targets within
    the defined area.
    
    One swarm is summoned for every three character levels.
    Swarms attack at +4 and deal 2d6 magical damage.
    
    This script is based on my implementation of 
    Creeping Doom.  Notable changes are that this 
    spell cannot stack, there are fewer swarms summoned,
    and swarms deal magical damage instead of poison.
*/
//:://////////////////////////////////////////////
//:: Created By: Patrick Mills
//:: Created On:  August, 17 2006
//:://////////////////////////////////////////////
//pkm oei 10.20.06 - AB +4 was way too low for mid-late game.  Changed rules.

#include "x2_inc_spellhook"
#include "x0_i0_spells"


int RunRollToHit( object oTarget );
void RunSwarmAttack( object oTarget, float fDuration );

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
    
    //Declare major variables
    location lTarget = GetSpellTargetLocation();
    object oCaster = OBJECT_SELF; 
    int nCasterLvl = GetCasterLevel( oCaster );
    int nSwarms = ( nCasterLvl / 3 );
    
    int nDuration = nCasterLvl;
    float fDuration = TurnsToSeconds(nDuration);
    effect ePedes = EffectVisualEffect( VFX_DUR_INVOCATION_TENACIOUS_PLAGUE );
    effect ePlague = EffectAreaOfEffect(AOE_PER_TENACIOUS_PLAGUE);
    
    //Meta-magic fun
    int nMetaMagic = GetMetaMagicFeat();
    if (nMetaMagic == METAMAGIC_EXTEND)
    {
        nDuration = nDuration * 2;    //Duration is +100%
    }
    
    int nMaxSwarms = nSwarms;
    
    //Find the first victim
    object oTarget = GetFirstObjectInShape( SHAPE_SPHERE, RADIUS_SIZE_LARGE, lTarget );
    object oTarget2 = GetNextObjectInShape( SHAPE_SPHERE, RADIUS_SIZE_LARGE, lTarget );
    //If the first object is the caster and the second object is invalid, we do not have any valid targets
    if (oTarget == OBJECT_SELF && !GetIsObjectValid( oTarget2 ))
    {
        return;
    }
    
    oTarget = GetFirstObjectInShape( SHAPE_SPHERE, RADIUS_SIZE_LARGE, lTarget );
    //While we still have swarms to assign, run the following logic
    while ( nSwarms > 0) 
    {
        if (GetIsObjectValid(oTarget))
        {
            if (spellsIsTarget(oTarget, SPELL_TARGET_STANDARDHOSTILE, OBJECT_SELF))
            {
                if ( !GetIsDead(oCaster) && GetArea(oTarget) == GetArea(oCaster) )
                {
                    object oNearestEffect = GetNearestObject(OBJECT_TYPE_AREA_OF_EFFECT, oTarget, 1);
                    if (GetDistanceBetween(oTarget, oNearestEffect) > 3.4f) // swarms cannot occupy other swarms' space.
                    {
                        DelayCommand(0.0f, ApplyEffectAtLocation( DURATION_TYPE_TEMPORARY, ePedes, GetLocation(oTarget), fDuration ));
                        //Remove a swarm
                        nSwarms--;
                    }
                }
            }
            //Grab the next target
            oTarget = GetNextObjectInShape( SHAPE_SPHERE, RADIUS_SIZE_LARGE, lTarget, FALSE, OBJECT_TYPE_CREATURE );
        }
        //If the target was not valid, go back to the first valid target
        else  
        {    //If no swarms have been applied we know there are no valid targets for the spell.
            if (nSwarms == nMaxSwarms )
            {
                return;
            }
            else
            {
                oTarget = GetFirstObjectInShape( SHAPE_SPHERE, RADIUS_SIZE_LARGE, lTarget );
            }
        }
    }
}