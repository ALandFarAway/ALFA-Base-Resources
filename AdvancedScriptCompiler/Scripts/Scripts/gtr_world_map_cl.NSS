// gtr_world_map_cl
/*
	Transition to the world map
*/	
// EPF 
// EPF 2/2/06 -- modifying to have a default map for each act if no other map is specified.
// EPF 3/24/06 -- this is now an OnClicked event
// BMA-OEI 6/24/06 -- Added gather party check
// BMA-OEI 8/11/06 -- Autosave before transition
// ChazM 8/21/06 -- updated constant CAMPAIGN_SWITCH_REMOVE_DOMINATED_ON_TRANSITION
// BMA-OEI 8/22/06 -- Replaced auto save w/ AttemptSinglePlayerAutoSave()
// ChazM 4/26/07 
// ChazM 6/11/07 -- autosave now in DoShowWorldMap() - removed include.
	
#include "ginc_worldmap"
#include "ginc_transition"

	
void main()
{
	object oPC = GetClickingObject();
	if ( GetIsPC( oPC ) == FALSE )
	{
		return;
	}

	string sMap = GetLocalString(OBJECT_SELF, "sMap");
	string sOrigin = GetLocalString(OBJECT_SELF, "sOrigin");

	
	// BMA-OEI 7/04/06 - Check if using remove dominated campaign flag
	if ( GetGlobalInt(CAMPAIGN_SWITCH_REMOVE_DOMINATED_ON_TRANSITION) == TRUE )
	{
		int nRemoved = 0;
		object oFM = GetFirstFactionMember( oPC, FALSE );
		while ( GetIsObjectValid(oFM) == TRUE )
		{
			nRemoved = nRemoved + RemoveEffectsByType( oFM, EFFECT_TYPE_DOMINATED );
			oFM = GetNextFactionMember( oPC, FALSE );
		}
			
		if ( nRemoved > 0 )
		{
			// Abort transition if dominated effect was found and removed
			return;
		}
	}

	// BMA-OEI 6/24/06
	if ( GetGlobalInt( VAR_GLOBAL_GATHER_PARTY ) == 1 )
	{
		if ( IsPartyGathered( oPC ) == FALSE )
		{
			ReportPartyGather( oPC );
			return;
		}
	}

	DoShowWorldMap(sMap, oPC, sOrigin);
}