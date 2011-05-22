//::///////////////////////////////////////////////
//:: Silence
//:: NW_S0_Silence.nss
//:: Copyright (c) 2001 Bioware Corp.
//:://////////////////////////////////////////////
/*
    The target is surrounded by a zone of silence
    that allows them to move without sound.  Spell
    casters caught in this area will be unable to cast
    spells.
*/
//:://////////////////////////////////////////////
//:: Created By: Preston Watamaniuk
//:: Created On: Jan 7, 2002
//:://////////////////////////////////////////////
// JLR - OEI 08/23/05 -- Metamagic changes
// ChazM 1/18/07 - EvenFlw modifications


#include "nwn2_inc_spells"

#include "NW_I0_SPELLS"
#include "x2_inc_spellhook"

// this has the silence constant EVENFLW_SILENCE, and is the only reason we include it.
// Affects NW_S0_Silence & NW_S0_SilenceA
#include "nw_i0_generic"


void main()
{

/*
  Spellcast Hook Code
  Added 2003-06-23 by GeorgZ
  If you want to make changes to all spells,
  check x2_inc_spellhook.nss to find out more

*/

    if (!X2PreSpellCastCode())
    {
    // If code within the PreSpellCastHook (i.e. UMD) reports FALSE, do not run this spell
        return;
    }

// End of Spell Cast Hook

	//SpawnScriptDebugger();

    //Declare major variables including Area of Effect Object
    effect eAOE = EffectAreaOfEffect( AOE_MOB_SILENCE );
	effect eHit = EffectVisualEffect( VFX_DUR_SPELL_SILENCE );
    float fDuration = RoundsToSeconds(GetCasterLevel(OBJECT_SELF));
    object oTarget = GetSpellTargetObject();
	location lTarget = GetSpellTargetLocation();
	
    //Make sure duration does no equal 0
    if (fDuration < 1.0)
    {
        fDuration = 1.0;
    }
    //Check Extend metamagic feat.
    fDuration = ApplyMetamagicDurationMods(fDuration);
    int nDurType = ApplyMetamagicDurationTypeMods(DURATION_TYPE_TEMPORARY);

	if ( GetIsObjectValid(oTarget) )	// for when the spell is cast on a target
	{
	    if ( spellsIsTarget(oTarget, SPELL_TARGET_STANDARDHOSTILE, OBJECT_SELF) )
	    {
	        if ( !MyResistSpell(OBJECT_SELF, oTarget) )
	        {
	            if ( !MySavingThrow(SAVING_THROW_WILL, oTarget, GetSpellSaveDC()) )
	            {	
	                //Create an instance of the AOE Object using the Apply Effect function
	                ApplyEffectToObject( nDurType, eAOE, oTarget, fDuration );
					ApplyEffectToObject( DURATION_TYPE_INSTANT, eHit, oTarget );
					SetLocalInt(oTarget, EVENFLW_SILENCE, TRUE);
	            }
	        }
			if(!GetIsInCombat(oTarget))
				SignalEvent( oTarget, EventSpellCastAt(OBJECT_SELF, SPELL_SILENCE) );
	    }
	    else
	    {
			int nObjectType = GetObjectType( oTarget );
			if ( nObjectType == OBJECT_TYPE_CREATURE )
			{
				ApplyEffectToObject( nDurType, eHit, oTarget, fDuration );
				//Create an instance of the AOE Object using the Apply Effect function
	        	ApplyEffectToObject( nDurType, eAOE, oTarget, fDuration );
				SetLocalInt(oTarget, EVENFLW_SILENCE, TRUE);
	        	//Fire cast spell at event for the specified target
	        	SignalEvent( oTarget, EventSpellCastAt(OBJECT_SELF, SPELL_SILENCE, FALSE) );
			}
			else
			{
				lTarget = GetLocation( oTarget );
		        //Create an instance of the AOE Object using the Apply Effect function
		        ApplyEffectAtLocation( nDurType, eAOE, lTarget, fDuration );				
			}
	    }	
	}
	else	// for when the spell is cast at a location
	{
		//Create an instance of the AOE Object using the Apply Effect function
	    ApplyEffectAtLocation( nDurType, eAOE, lTarget, fDuration );
		//ApplyEffectAtLocation( nDurType, eHit, lTarget, fDuration );
	}
}