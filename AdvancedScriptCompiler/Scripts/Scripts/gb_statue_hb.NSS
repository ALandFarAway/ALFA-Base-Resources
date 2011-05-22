// gb_statue_hb
/*
    Statue creature hb script to make sure that they will re-petrify after loaded save.
*/
// MDiekmann 8/30/07

#include "ginc_debug"

void main()
{
    object oTarget = OBJECT_SELF;
	SetOrientOnDialog(oTarget, FALSE);
	
    effect ePetrify = EffectPetrify();	
		
	// remove plot flag so that petrify effect can be used
	SetPlotFlag(oTarget, FALSE);
	
	// reapply effect
	ApplyEffectToObject(DURATION_TYPE_PERMANENT, ePetrify, oTarget);
	PrettyDebug(GetName(oTarget) + " petrified");
		
	// make plot so creature is indestructable	
	SetPlotFlag(oTarget, TRUE);
}