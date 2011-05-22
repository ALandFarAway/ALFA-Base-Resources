// ginc_misc
/*
    Miscellaneous useful functions
*/
// ChazM 3/4/05
// ChazM 5/5/05 added ForceExit() and SpawnCreatureAtWP()
// BMA 5/12/05 added exact/partial param to GetIsItemEquipped(), GetPartyMemberHasEquipped()
// EPF 6/9/05 ForceExit now uses GetTarget()
// ChazM 6/14/05 added PCTriggeredOnce()
// ChazM 7/7/05 added this comment	
// ChazM 8/16/05 modified SpawnCreatureAtWP
// ChazM 8/22/05 added N2_RewardPlotItem(), N2_RewardItem(), N2_RewardXP(), N2_RewardGold(), and GiveItemToAll(), included  X0_I0_PARTYWIDE
// ChazM 9/17/05 added SpawnPlaceableAtWP(), SpawnPlaceablesAtWPs(), SpawnObjectAtWP(), SpawnObjectsAtWPs(),
//			GetNumberOfObjectsInArea(), GetRandomObjectInArea(), DebugMessage()
// ChazM 9/22/05 moved DebugMessage() to ginc_debug and added as an include.
// ChazM 9/28/05 moved  N2_RewardPlotItem(), N2_RewardItem(), N2_RewardXP(), N2_RewardGold(), and GiveItemToAll() to "ginc_journal" - now included
// ChazM 9/29/05 moved most funtions to other includes and added references to 2 new includes
// ChazM 10/01/05 moved IsMarkedAsDone() and MarkAsDone() to ginc_vars
// FAB 10/14/05 bullet-proofing ForceExit so you can't talk to someone running away
// EPF 6/20/06 ForceExit turns off plot flag.
// ChazM 6/22/06 ForceExit turns on destroyable flag.
// DBR 7/18/06 - Destroyable flag needed an AssignCommand() for ForceExit().
// BMA-OEI 8/09/06 -- Added GetPCAverageXP()
// ChazM 9/18/06 - included ginc_actions, updated ForceExit() to reference ActionForceExit() in ginc_actions.

// dependent includes
#include "ginc_param_const"
	// has ActionForceExit()
#include "ginc_actions" 

// convenience only (non-dependent) includes
#include "ginc_journal"
#include "ginc_object"

//void main(){}

//-------------------------------------------------
// Function Prototypes
//-------------------------------------------------
	
object GetAnyPCBeing();

void ForceExit(string sCreatureTag, string sWPTag, int bRun=FALSE);

int PCTriggeredOnce();	// used for typical PC only triggers once triggers

// Returns average XP of PCs
int GetPCAverageXP();

//-------------------------------------------------
// Function Definitions
//-------------------------------------------------

// Find first party member character controlled by a Player
object GetAnyPCBeing()
{
      object oPC = GetFirstPC();
      object oMember = GetFirstFactionMember(oPC, FALSE);

      while (GetIsObjectValid(oMember) == TRUE)
      {
            // If oMember is controlled by a player, return.
            if (GetIsPC(oMember) == TRUE) return (oMember);
            oMember = GetNextFactionMember(oPC, FALSE);
      }

      return (OBJECT_INVALID);
}


// Force creature w/ Tag sCreatureTag to move to exit WP and destroy self or despawn if roster member
void ForceExit(string sCreatureTag, string sWPTag, int bRun=FALSE)
{
	object oCreature = GetTarget(sCreatureTag);
	AssignCommand(oCreature, ActionForceExit(sWPTag, bRun));
}

//----------------------------------------
// Trigger Related
//----------------------------------------

// Used for typical PC Triggers where trigger only runs once for the PC.
// Don't put more conditions after this call, since this will only return success once.
int PCTriggeredOnce()	
{	
	object oPC = GetEnteringObject();
	
	// check conditions
	if (IsMarkedAsDone())		
		return TRUE;
	
	if (!GetIsPC(oPC))
		return TRUE;
	
	MarkAsDone();
	return FALSE;
}

// Returns average XP of all PCs in server
int GetPCAverageXP()
{
	int nXP = 0;
	int nPCs = 0;
	object oPC = GetFirstPC();
	while ( GetIsObjectValid(oPC) == TRUE )
	{
		nXP = nXP + GetXP( oPC );
		nPCs = nPCs + 1;
		oPC = GetNextPC();
	}
	return ( nXP / nPCs );
}