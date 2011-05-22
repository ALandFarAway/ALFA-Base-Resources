////////////////////////////////////////////////////////////
// OnClick/OnAreaTransitionClick
// NW_G0_Transition.nss
// Copyright (c) 2001 Bioware Corp.
////////////////////////////////////////////////////////////
// Created By: Sydney Tang 
// Created On: 2001-10-26
// Description: This is the default script that is called
//              if no OnClick script is specified for an
//              Area Transition Trigger or
//              if no OnAreaTransitionClick script is
//              specified for a Door that has a LinkedTo
//              Destination Type other than None.
////////////////////////////////////////////////////////////
// ChazM 3/3/06 - parameterized GatherPartyTransition()
// BMA-OEI 6/24/06 - Moved transition to AttemptAreaTransition()
// NLC 10/8/08 - Recompiling to catch fixes for NX2. 
#include "ginc_transition"

void main()
{
	object oClicker = GetClickingObject();
	object oTarget = GetTransitionTarget( OBJECT_SELF );
	SetAreaTransitionBMP( AREA_TRANSITION_RANDOM );
	
	AttemptAreaTransition( oClicker, oTarget );
}