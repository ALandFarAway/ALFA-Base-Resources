//::///////////////////////////////////////////////////////////////////////////
//::
//::	gtr_pc_tran_clic.nss
//::
//::	Use this script as a trigger's OnClick event handler to ensure that the
//::	trigger is only tripped by a PC.  This is the default OnClick handler for
//::	the global PC-Only Area Transition Trigger.
//::
//::///////////////////////////////////////////////////////////////////////////
//::
//::	Created by: Brian Fox
//::	Created on: 8/19/05
//::
//::///////////////////////////////////////////////////////////////////////////
// BMA-OEI 6/24/06 - Change to use AttemptAreaTransition()

#include "ginc_transition"

void main()
{
	object oClicker = GetClickingObject();
	if ( GetIsPC( oClicker ) == FALSE ) return;
	
	object oTarget = GetTransitionTarget( OBJECT_SELF );
	SetAreaTransitionBMP( AREA_TRANSITION_RANDOM );
	
	AttemptAreaTransition( oClicker, oTarget );
}