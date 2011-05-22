// ginc_transition
/*

	Global include for transitions.
	
*/	
// DBR 3/2/06
// ChazM 3/3/06 - parameterized GatherPartyTransition(), added IsPartyGathered()
// DBR 4/9/6 - Changed to message box for "Gather party"
// BMA-OEI 5/01/06 - Changed IsPartyGathered() to check all party members
// BMA-OEI 6/14/06 - Added SinglePartyTransition()
// ChazM 6/22/06 - Temporarily set gather radius really large.
// BMA-OEI 6/24/06 - Moved nw_g0_transition code into AttemptAreaTransition()
// BMA-OEI 7/04/06 - Check to Remove Dominated On Transition
// ChazM 1/10/07 - Added param to IsPartyGathered();
// ChazM 7/13/07 - Added StandardAttemptAreaTransition() for more generalized use.
// MDiekmann 8/16/07 - Modified IsPartyGathered() to give additional specific feedback if party member in conversation.
// MDiekmann 8/22/07 - Modified IsPartyGathered() to ignore summoned creatures when transitioning.

//void main(){}

#include "ginc_effect"
#include "x2_inc_switches"


const float fGATHER_RADIUS = 200.0f;
const string VAR_GLOBAL_GATHER_PARTY = "bGATHER_PARTY_TRAN";
const string VAR_GLOBAL_NX2_TRANSITIONS = "bNX2_TRANSITIONS";

int RemoveDominatedFromPCParty(object oPC);
void StandardAttemptAreaTransition( object oPC, object oDestination, int bIsPartyTranstion );
void AttemptAreaTransition( object oPC, object oDestination );
void ReportPartyGather( object oPCF );
int IsPartyGathered( object oPC, float fGatherRadius = fGATHER_RADIUS );
void GatherPartyTransition( object oPC, object oTransitionTarget );
void SinglePartyTransition( object oPC, object oDestination );


// returns number of dominated that were actually found and removed.
int RemoveDominatedFromPCParty(object oPC)
{
	int nRemoved = 0;
	if ( ( GetIsPC(oPC) == TRUE ) || ( GetFactionEqual(oPC, GetFirstPC()) == TRUE ) )
	{
		object oFM = GetFirstFactionMember( oPC, FALSE );
		while ( GetIsObjectValid(oFM) == TRUE )
		{
			nRemoved = nRemoved + RemoveEffectsByType( oFM, EFFECT_TYPE_DOMINATED );
			oFM = GetNextFactionMember( oPC, FALSE );
		}
		
		/*
		if ( nRemoved > 0 )
		{
			// Abort transition if domianted effect was found and removed
			return TRUE;
		}
		*/
	}
	return nRemoved;
}

// this function assumes OBJECT_SELF is the area transition trigger, so we can look stuff up
void AttemptAreaTransition( object oPC, object oDestination )
{
	int bIsPartyTranstion = GetIsPartyTransition( OBJECT_SELF );
	StandardAttemptAreaTransition(oPC, oDestination, bIsPartyTranstion);
}

// Standard NWN2 area transition code
// Does not rely on OBJECT_SELF
void StandardAttemptAreaTransition( object oPC, object oDestination, int bIsPartyTranstion )
{
	// BMA-OEI 7/04/06 - Check if in group and using group campaign flag
	if ( GetGlobalInt(CAMPAIGN_SWITCH_REMOVE_DOMINATED_ON_TRANSITION) == TRUE )
	{
		int nRemoved = RemoveDominatedFromPCParty(oPC);
		if ( nRemoved > 0 )
		{
			// Abort transition if domianted effect was found and removed
			return;
		}
			
	}
	// need to make sure the party isn't "Bleeding out"
	// or we kill them.
	if ( GetPartyMembersDyingFlag() )
	{
		object oFM = GetFirstFactionMember( oPC, FALSE );
		while ( GetIsObjectValid( oFM ) == TRUE )
		{
			effect eEffect = GetFirstEffect(oFM);
			while(GetIsEffectValid(eEffect))
			{
				if(GetEffectType(eEffect) == EFFECT_TYPE_HITPOINT_CHANGE_WHEN_DYING)
				{
					if(GetEffectInteger(eEffect, 0) != TRUE)
					{
						effect eDeath = EffectDeath(FALSE,FALSE,TRUE,TRUE);
						ApplyEffectToObject(DURATION_TYPE_INSTANT, eDeath, oFM);
					}
				}
				
				eEffect = GetNextEffect(oFM);
			}
			oFM = GetNextFactionMember( oPC, FALSE );
		}			
	}	
	// k_mod_load.nss campaign setting - override "Gather Party" transition
	// TODO: What if oClicker is NPC?
	if ( GetGlobalInt( VAR_GLOBAL_GATHER_PARTY ) == 1 )
	{
		GatherPartyTransition( oPC, oDestination );
		return;
	}
	

	
	if ( bIsPartyTranstion == TRUE )
	{
		SinglePartyTransition( oPC, oDestination );
	}
	else
	{
		AssignCommand( oPC, JumpToObject( oDestination ) );
	}
}

// Complain that party needs to be gathered!
void ReportPartyGather(object oPCF)
{
	CloseGUIScreen(oPCF, "SCREEN_MESSAGEBOX_DEFAULT");
	
	DelayCommand(
		0.1,
		DisplayMessageBox(
			oPCF,	// Display a message box for this PC
			161846, // string ref to display
			"", 	// Message to display
			"", 	// Callback for clicking the OK button
			"", 	// Callback for clicking the Cancel button
			FALSE, 	// display the Cancel button
			"SCREEN_MESSAGEBOX_DEFAULT", // Display the tutorial message box	
			-1, 	// OK string ref
			"", 	// OK string
			-1, 	// Cancel string ref
			""  	// Cancel string
		)
	);
}	

// Check if party is gathered ( alive, not in conversation, and nearby )
int IsPartyGathered( object oPC, float fGatherRadius = fGATHER_RADIUS )
{
	object oArea = GetArea( oPC );
	
	object oFM = GetFirstFactionMember( oPC, FALSE );
	
	while ( GetIsObjectValid( oFM ) == TRUE )
	{
		// For all members in the area
		if ( GetArea( oFM ) == oArea )
		{
			// if not a summoned creature(this does not include familiars or animal companions)
			if(GetAssociateType(oFM) != ASSOCIATE_TYPE_SUMMONED)
			{
				if( GetGlobalInt( VAR_GLOBAL_NX2_TRANSITIONS ) )
				{
					//In NX2, we only care about Controlled Characters. This removes the requirement to gather your party for
					//single player, but preserves it so that you don't get yanked out of the middle of gameplay in multiplayer.
					if	( GetIsPC(oFM) )
					{
						//Also, in order to support the new death system, we no longer care whether the character is dead or not.
						if ( IsInConversation(oFM) || GetDistanceBetween( oFM, oPC ) >= fGatherRadius )
						{
							if(IsInConversation(oFM))
								SendMessageToPCByStrRef(oPC, 210771);
						}
					}
				}
				
				else
				{
					if ( ( GetIsDead( oFM ) == TRUE ) || 
						( IsInConversation( oFM ) == TRUE ) ||
					 	( GetDistanceBetween( oFM, oPC ) >= fGatherRadius ) )
					{
						if(IsInConversation(oFM))
						{
							SendMessageToPCByStrRef(oPC, 210771);
						}
						return ( FALSE );
					}
				}
			}
		}
		
		oFM = GetNextFactionMember( oPC, FALSE );
	}

	return ( TRUE );
}

// Transition to oTransitionTarget if oPC's party is gathered ( alive, not in conversation, and nearby )
// Otherwise, ask oPC to first gather the party.
void GatherPartyTransition( object oPC, object oTransitionTarget )
{
	if ( ( GetIsPC( oPC ) == FALSE ) ||
		 ( GetIsDead( oPC ) == TRUE ) ||
		 ( IsInConversation( oPC ) == TRUE ) )
	{
		return;
	}
	
	if ( IsPartyGathered( oPC ) == FALSE )
	{
		ReportPartyGather( oPC );
		return;
	}
		
	SinglePartyTransition( oPC, oTransitionTarget );	
}

// Forces oPC's faction to be alive and commandable before sending
// them to oDestination via JumpPartyToArea().
void SinglePartyTransition( object oPC, object oDestination )
{
	effect eRes = EffectResurrection();
	if( GetGlobalInt( VAR_GLOBAL_NX2_TRANSITIONS ) == FALSE )		//Under NX2's death system, we don't want them to 
	{																//ressurect on transitions.
		// For each party member, revive and set commandable
		object oFM = GetFirstFactionMember( oPC, FALSE );

		while ( GetIsObjectValid( oFM ) == TRUE )
		{
			SetCommandable( TRUE );														
			ApplyEffectToObject( DURATION_TYPE_INSTANT, eRes, oFM );		
			
			oFM = GetNextFactionMember( oPC, FALSE );
		}
	}
	// Transition and trigger FiredFromPartyTransition()
	JumpPartyToArea( oPC, oDestination );	
}