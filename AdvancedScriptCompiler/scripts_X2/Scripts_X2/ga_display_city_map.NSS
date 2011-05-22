//	ga_display_city_map
/*
	Brings up the worldmap for a city location. Meant to be called from within a dialog and
	used with an Overland Map city placeable.
*/
//	JSH-OEI 4/16/08

#include "ginc_worldmap"
#include "ginc_transition"
	
void main( int nLocation = 0)
{
	object oPC = GetPCSpeaker();
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

	/*	Sets a global int since NX2 has multiple PCs, any of whom can access the exit
		transition.	*/
	SetGlobalString("00_sMap", sMap);
	SetGlobalString("00_sOrigin", sOrigin);
	
	DoShowWorldMap(sMap, oPC, sOrigin);
	SetLocalGUIVariable( oPC, "SCREEN_WORLDMAPCUSTOM", 1000, IntToString(nLocation) );
	
}