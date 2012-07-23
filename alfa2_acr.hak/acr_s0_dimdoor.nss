//=====================================================================================
// Dimension Door
// 8/31/2011
// Zelknolf
//=====================================================================================
/*
	This spell attempts to emulate the functionality of the Dimension Door spell from
	the Player's Handbook, p 221.
*/
//=====================================================================================

#include "x2_inc_spellhook"
#include "acr_spells_i"
#include "acr_travel_i"

void main()
{
    if (!ACR_PrecastEvent())
    {
	// If code within the PreSpellCastHook (i.e. UMD) reports FALSE, do not run this spell
        return;
    }
	
	// Can the caster travel dimensionally?
	if ( !ACR_CanExtradimensionalTravel( OBJECT_SELF ) ) {
		SendMessageToPC( OBJECT_SELF, "Something prevents you from using the dimensional door!" );
		return;
	}
	
	int nCasterLevel = GetCasterLevel(OBJECT_SELF);
	
	int nTargets = nCasterLevel / 3;
	
	location lTarget = GetSpellTargetLocation();
	
	float fDelay = 0.5f;
	
	object oPC = GetFirstObjectInShape(SHAPE_SPHERE, 5.0f, GetLocation(OBJECT_SELF), TRUE);
	while(GetIsObjectValid(oPC) && nTargets > 0)
	{
		if(GetFactionEqual(oPC, OBJECT_SELF) || oPC == OBJECT_SELF)
		{
			if ( !ACR_CanExtradimensionalTravel( oPC ) ) {
				oPC = GetNextObjectInShape(SHAPE_SPHERE, 5.0f, GetLocation(OBJECT_SELF), TRUE);
				continue;
			}
		
			if(oPC != OBJECT_SELF)
			{
				int nSize = GetCreatureSize(oPC);
				if(nSize <= 3 && nTargets > 0) // medium or less
				{
					nTargets--;
					DelayCommand(fDelay, AssignCommand(oPC, JumpToLocation(lTarget)));
					SetLocalInt(oPC, "DIMENSION_DOOR_USED", 1);
				}
				else if(nSize == 4 && nTargets > 1)
				{
					nTargets -= 2;
					DelayCommand(fDelay, AssignCommand(oPC, JumpToLocation(lTarget)));
					SetLocalInt(oPC, "DIMENSION_DOOR_USED", 1);
				}
			}
			else
			{
				DelayCommand(fDelay, AssignCommand(OBJECT_SELF, JumpToLocation(lTarget)));
				SetLocalInt(OBJECT_SELF, "DIMENSION_DOOR_USED", 1);
			}
		}
		oPC = GetNextObjectInShape(SHAPE_SPHERE, 5.0f, GetLocation(OBJECT_SELF), TRUE);
	}
	
	ApplyEffectAtLocation(DURATION_TYPE_TEMPORARY, EffectNWN2SpecialEffectFile("acr_s0_dimdoor"), GetLocation(OBJECT_SELF), 3.0f);
	ApplyEffectAtLocation(DURATION_TYPE_TEMPORARY, EffectNWN2SpecialEffectFile("acr_s0_dimdoor"), lTarget, 3.0f);
}