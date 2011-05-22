//::///////////////////////////////////////////////
//:: Invisibility Sphere: On Heartbeat
//:: NW_S0_InvSphC.nss
//:: Copyright (c) 2006 Obsidian Entertainment Inc.
//:://////////////////////////////////////////////
/*
    All allies within 15ft are rendered invisible.
*/
//:://////////////////////////////////////////////
//:: Created By: Patrick Mills
//:: Created On: Aug 18, 2006
//:://////////////////////////////////////////////
#include "nw_i0_spells"
#include "x2_inc_spellhook" 
#include "X0_I0_SPELLS"

void main()
{
	object oCaster = GetAreaOfEffectCreator();
	
	int nID = (92);
	if ( !GetHasSpellEffect(nID, oCaster) )
	{
		DestroyObject(OBJECT_SELF, 3.0);
	}		
}