// nx_s2_provoke_spirits
/*
    Spirit Eater Provoke Spirits Feat
	
When the spirit-eater casts this, the spirit-eater model shows briefly (can just use whatever animation
it did for Ravenous Incarnation -- should not require a new animation), and a shockwave fires outward
from him. All non-plot, neutral spirits within the radius of the spell turn hostile and attack the
caster. Provoked spirits also take a -4 penalty to AC. The SEF can be made up of existing effects,
for ease of implementation.

Should be a slight delay on the faction change that increases the farther the target is away from the
caster. Spell radius is 10m. Only effective on non-plot, neutral spirits. 

*/
// ChazM 5/29/07
// ChazM 5/30/07 - added VFX, fixed attack bug

#include "X0_I0_SPELLS"
#include "x2_inc_spellhook" 

void main()
{
    if (!X2PreSpellCastCode())
    {
	    // If code within the PreSpellCastHook (i.e. UMD) reports FALSE, do not run this spell
        return;
    }
	
	//SpawnScriptDebugger();
    //Declare major variables
    object oCaster = OBJECT_SELF;
    int nCasterLvl = GetCasterLevel(oCaster);
    float fDelay;
    
	
    //Get the spell target location as opposed to the spell target.
    location lTarget = GetLocation(oCaster); //GetSpellTargetLocation();
	int nPlotFlag;
	int nIsSpirit;
	int nIsNeutral;
	int nInSameFaction;

    //effect eVis = EffectVisualEffect(VFX_IMP_FLAME_M);

    effect eACPenalty = EffectACDecrease(4);
    effect eDur  = EffectVisualEffect( VFX_DUR_SPELL_RAGE ); // visual effect
    effect eLink = EffectLinkEffects(eACPenalty, eDur);
	    
	int nAreaOfEffectShape = SHAPE_SPHERE;
	float fRadiusOfEffect = RADIUS_SIZE_COLOSSAL; // just under 10m (~30 feet)
	int nTargetTypes = OBJECT_TYPE_CREATURE; // affects only creatures
	float fDuration = RoundsToSeconds(10);
	
    // the shockwave effect is Handled by the ImpactSEF column in spells.2da

    //Declare the spell shape, size and the location.  Capture the first target object in the shape.
    object oTarget = GetFirstObjectInShape(nAreaOfEffectShape, fRadiusOfEffect, lTarget, TRUE, nTargetTypes);
    //Cycle through the targets within the spell shape until an invalid object is captured.
    while (GetIsObjectValid(oTarget))
    {
		//SpeakString("provoke - " + GetName(oTarget));
		nIsSpirit = GetIsSpirit(oTarget);
		
		// only affects spirits
		if (nIsSpirit)
		{
			nPlotFlag = GetPlotFlag(oTarget);
			nIsNeutral = GetIsNeutral(oCaster, oTarget); // does target consider caster as neutral?
			PrettyDebug(GetName(oTarget) + " nPlotFlag=" + IntToString(nPlotFlag) + " nIsSpirit= " + IntToString(nIsSpirit) + " nIsNeutral=" + IntToString(nIsNeutral));
			nInSameFaction = GetFactionEqual(oCaster, oTarget); // are we in same party?
			// harms not plot neutral spirits
			if ((nPlotFlag==FALSE)
				&& nIsNeutral
				&& !nInSameFaction)
			{
				
				//SpeakString("provoke - passed all tests - " + GetName(oTarget));
				//Get the distance between the explosion and the target to calculate delay
				fDelay = GetDistanceBetweenLocations(lTarget, GetLocation(oTarget))/20;
				
				// Apply effects to the currently selected target.
				DelayCommand(fDelay, ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eLink, oTarget, fDuration));
				
				//DelayCommand(fDelay, ApplyEffectToObject(DURATION_TYPE_INSTANT, eVis, oTarget));
				
				// react to hostile act
				DelayCommand(fDelay, ChangeToStandardFaction(oTarget, STANDARD_FACTION_HOSTILE));
				
				// note that attacking (DCR) or signalling spell cast can cause problems if not done 
				// after ChangeToStandardFaction HOSTILE has taken efect.
				
				DelayCommand(fDelay + 0.1f, ExecuteScript("gr_dcr", oTarget));
				
				//Fire cast spell at event for the specified target
				DelayCommand(fDelay + 0.1f, SignalEvent(oTarget, EventSpellCastAt(OBJECT_SELF, GetSpellId(), TRUE))); // harmful
			}
			else 
			{
				// maybe Okku or somebody want to respond
				SignalEvent(oTarget, EventSpellCastAt(OBJECT_SELF, GetSpellId(), FALSE)); // not harmful
			}				
			
        }
       //Select the next target within the spell shape.
       oTarget = GetNextObjectInShape(nAreaOfEffectShape, fRadiusOfEffect, lTarget, TRUE, nTargetTypes);
    }
}