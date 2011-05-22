//::///////////////////////////////////////////////
//:: Symbol of Death (On Enter)
//:: nx2_s0_symbol_of_deatha.nss
//:: Copyright (c) 2007 Obsidian Entertainment, Inc.
//:://////////////////////////////////////////////
/*

	Symbol of Death
	Necromancy[Death]
	Level: Cleric 8, Sorceror/wizard 8
	Components: V, S
	Casting Time: 
	Range:
	Duration: See text
	Saving Throw: Fortitude Negates
	Spell Resistance: Yes

*/
//:://////////////////////////////////////////////
//:: Created By: Michael Diekmann
//:: Created On: 09/05/2007
//:://////////////////////////////////////////////

#include "x0_i0_spells"
#include "ginc_debug"

void main()
{
	PrettyDebug("Active");
    //Get target
    object oTarget		= GetEnteringObject();
	object oCaster		= GetAreaOfEffectCreator();
	// Effects
	effect eDeath		= EffectDeath();
	effect eActivated 	= EffectNWN2SpecialEffectFile("fx_feat_chastisespirits_aoe01.sef");
	effect eVisual		= EffectVisualEffect(VFX_DUR_SPELL_SYMBOL_OF_DEATH);
	effect eLink		= EffectLinkEffects(eVisual, eDeath);
	float fDelay;
	
	// target valid?
	if(GetIsObjectValid(oTarget))
	{
	    if (spellsIsTarget(oTarget, SPELL_TARGET_SELECTIVEHOSTILE, oCaster))
	    {
			// now that a valid target has triggered symbol get all valid targets in a 60ft radius and apply symbol effect
			ApplyEffectToObject(DURATION_TYPE_INSTANT, eActivated, OBJECT_SELF);
			location lTarget = GetLocation(oTarget);
			oTarget = GetFirstObjectInShape(SHAPE_SPHERE, RADIUS_SIZE_VAST, lTarget);
			while(GetIsObjectValid(oTarget))
			{
				if (spellsIsTarget(oTarget, SPELL_TARGET_SELECTIVEHOSTILE, oCaster))
	    		{		
					fDelay = GetDistanceBetweenLocations(lTarget, GetLocation(oTarget))/20;
					// Get Health
					int nHealth			= GetCurrentHitPoints(oTarget);
					int nLocalDamage	= GetLocalInt(OBJECT_SELF, "Local_Damage");
					int nRemaining		= nLocalDamage - nHealth;
					PrettyDebug(IntToString(nRemaining));
					
					//if creature health is less than remaining symbol damage	
					if(nRemaining >= 0)
					{
						//Fire cast spell at event for the specified target
				        SignalEvent(oTarget, EventSpellCastAt(oCaster, SPELL_SYMBOL_OF_DEATH, TRUE));
						// saving throw
						int nSaved	= FortitudeSave(oTarget, GetSpellSaveDC(), SAVING_THROW_TYPE_DEATH, GetAreaOfEffectCreator());
				     	if(nSaved == 2)
						{
							// spell resisted
						}   
						else if(nSaved == 1)
						{
							// good saving throw
						}
						else if(nSaved == 0)
						{
							DelayCommand(fDelay, ApplyEffectToObject(DURATION_TYPE_INSTANT, eLink, oTarget));
							// update local int
							SetLocalInt(OBJECT_SELF, "Local_Damage", nRemaining);
						}
					}
					// if no more damage left destroy self
					if(nRemaining == 0)
					{
						string sType 		= GetLocalString(OBJECT_SELF, "Symbol_Type");
						string sAOETag 		= "symbol_of_" + sType;
						object oAOE 		= GetNearestObjectByTag(sAOETag);
						
						DestroyObject(oAOE);
						DestroyObject(OBJECT_SELF);
					}
				}
				oTarget = GetNextObjectInShape(SHAPE_SPHERE, RADIUS_SIZE_VAST, lTarget);
			}			
	    }
	}
}