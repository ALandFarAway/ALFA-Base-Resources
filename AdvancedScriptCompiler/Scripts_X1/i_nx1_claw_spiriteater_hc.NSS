// i_nx1_claw_spiriteater_hc
/*
	On-hit cast spell for Ravenous Incarnation claws. 
	If a spirit, use Devour Spirit like spell.
	If a humanoid, use Devour Soul like spell.
	If undead, use Eternal Rest like spell.
*/
// MDiekmann 7/12/07


#include "kinc_spirit_eater"

const string VFX_RAVENOUS_HIT = "fx_ravenous_hit";
const int RAVENOUS_DRAIN = 5;

void main()
{
	object oItem  		= GetSpellCastItem();    // The item casting that triggered this spellscript
	object oSpellOrigin = OBJECT_SELF ;
	object oSpellTarget = GetSpellTargetObject();

	//make sure target is a hostile creature
 	if (spellsIsTarget(oSpellTarget, SPELL_TARGET_STANDARDHOSTILE, oSpellOrigin)
        && (GetObjectType(oSpellTarget) == OBJECT_TYPE_CREATURE))
    {	
		if(Random(5) == 0)
		{
			ApplyEffectToObject(DURATION_TYPE_INSTANT, EffectNWN2SpecialEffectFile(VFX_RAVENOUS_HIT,oSpellTarget),oSpellOrigin);
			UpdateSpiritEaterPoints(IntToFloat(RAVENOUS_DRAIN));
			int nDamage = d6(2);
			effect eDam = EffectDamage(nDamage,DAMAGE_TYPE_NEGATIVE);
			ApplyEffectToObject(DURATION_TYPE_INSTANT, eDam, oSpellTarget);
			
			if(GetCurrentHitPoints(oSpellTarget) < nDamage)
			{
				DoDevourDrop(oSpellOrigin, oSpellTarget);
			}
			
	    	if(GetIsSpirit(oSpellTarget))
			{		
		    	//Fire cast spell at event for the specified target
		  	  	SignalEvent(oSpellTarget, EventSpellCastAt(oSpellOrigin, SPELLABILITY_DEVOUR_SPIRIT, TRUE));
			}
			
			// if we have a humanoid use devour soul like spell
	        else if(GetIsSoul(oSpellTarget))
	    	{	
					//Fire cast spell at event for the specified target
		    	SignalEvent(oSpellTarget, EventSpellCastAt(oSpellOrigin, SPELLABILITY_DEVOUR_SOUL, TRUE));
			}
			else if(GetIsUndead(oSpellTarget))
	    	{
				//Fire cast spell at event for the specified target
		   	 	SignalEvent(oSpellTarget, EventSpellCastAt(oSpellOrigin, SPELLABILITY_ETERNAL_REST, TRUE));
			}
		}
		
		//otherwise do nothing special
		
	}
}