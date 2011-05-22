//::///////////////////////////////////////////////////////////////////////////
//::
//::	nw_s1_kos_dotb.nss
//::
//::	This is the OnExit script for a AOE_MOB_SHADOW_PLAGUE effect.
//::
//::///////////////////////////////////////////////////////////////////////////
//::
//::	Created by: Brian Fox
//::	Created on: 8/30/06
//::
//::///////////////////////////////////////////////////////////////////////////
#include "nw_i0_spells"


void main()
{
	object oExiting = GetExitingObject();
	object oCreator = GetAreaOfEffectCreator();
	
	if ( GetHasSpellEffect(GetSpellId(), oExiting) )
	{
		RemoveSpellEffects( GetSpellId(), oCreator, oExiting );
	}
}