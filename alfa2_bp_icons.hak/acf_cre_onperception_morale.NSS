////////////////////////////////////////////////////////////////////////////////
//
//  System Name : Morale-enabled OnPerception file
//     Filename : sjc_onperception_morale
//    $Revision:: 1.3        $ current version of the file
//        $Date:: 2007-03-20#$ date the file was created or modified
//       Author : Teric & AcadiusLost
//
//    Var Prefix:
//  Dependencies:
//
//  Description
//  This script calls the ACR's OnPerception event handler for creatures
//  and any custom code a server may need. It is not updated in ACR updates.
//
//  Revision History
//  inception: Teric
//  1.1  8/26/07 AcadiusLost: added test for GetIsPC(), and return when DIVIDE BY ZERO
//  1.2  9/4/08  AcadiusLost: fixed inadvertant assignment of 0 rating, some optimization
//  1.3 10/12/08 AcadiusLost: fixed GetTag() calls, lowered check range, increased bonus for
//       outnumbering PCs, added extra penalty state for <25% health, fixed fleeing clause
////////////////////////////////////////////////////////////////////////////////

////////////////////////////////////////////////////////////////////////////////
// Includes ////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////
#include "acr_creature_i"
#include "x0_i0_assoc"
#include "x0_i0_enemy"

////////////////////////////////////////////////////////////////////////////////
// Constants ///////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////

////////////////////////////////////////////////////////////////////////////////
// Structures //////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////

////////////////////////////////////////////////////////////////////////////////
// Global Variables ////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////

////////////////////////////////////////////////////////////////////////////////
// Function Prototypes /////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////

////////////////////////////////////////////////////////////////////////////////
// Function Definitions ////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////

void main()
{
    ACR_CreatureOnPerception();
	
	//  Commenting out all of this code, Morale Disabled for now.  -AL 4/11/2010
	/*
	object oPC = GetFirstPC();
	object oSeen = GetLastPerceived();
	string sSelfTag = GetTag(OBJECT_SELF);
	//SendMessageToPC(oPC, GetName(OBJECT_SELF)+" Perceiving "+GetName(oSeen));

	// check if it's a PC being perceived, if not, return without further action.
	if (!GetIsPC(oSeen) && !GetIsPossessedFamiliar(oSeen)) 
	{
	    //SendMessageToPC(oPC, "non-PC perception, bail out");
	    return;
	}
			
	if((GetLocalInt(OBJECT_SELF, "Fleeing") == 1) && ((sSelfTag == "abr_cr_an_wild_bird") ||(sSelfTag == "abr_cr_an_wild_bat") ||(sSelfTag == "abr_cr_an_wild_rabbit") ||(sSelfTag == "abr_cr_an_wild_deer_doe") ||(sSelfTag == "abr_cr_an_wild_horse") 
		||(sSelfTag == "abr_cr_an_wild_rat") ||(sSelfTag == "abr_cr_an_wild_horse_stallion") ||(sSelfTag == "abr_cr_an_wild_deer_stag") ||(sSelfTag == "abr_cr_an_wild_bird") ||(sSelfTag == "abr_cr_an_wild_weasel") 
		||(sSelfTag == "abr_cr_an_wild_badger")||(sSelfTag == "abr_cr_an_wild_dogwolf")||(sSelfTag == "abr_cr_an_wild_bear")||(sSelfTag == "abr_cr_an_wild_boar")||(sSelfTag == "abr_cr_an_wild_badger")
		|| (FindSubString("goblin", sSelfTag) != -1)|| (FindSubString("kobold", sSelfTag) != -1)|| (FindSubString("gibberling", sSelfTag) != -1)
		|| (FindSubString("brownie", sSelfTag) != -1)|| (FindSubString("_fy_", sSelfTag) != -1)))
		{ClearAllActions(TRUE);
		 AssignCommand(OBJECT_SELF, ActionMoveAwayFromObject(GetLastAttacker(), TRUE, 200.0));
		 
		 //SpeakString("Still Running!");
		 //SendMessageToPC(oPC, "Continue Fleeing for "+GetName(OBJECT_SELF)+", now running from "+GetName(oSeen));
		 return;
	}

	
    // Morale check code Teric neDhalir 0707
		// Morale check dice roll 2D10
		int iRoll = d10(2);
		// Morale rating (set on creature as variable int SJC_MORALERATING.
		// A variable of 0 means the creature will always avoid PCs
		int iRating = GetLocalInt(OBJECT_SELF,"ACR_CRE_MORALERATING");
		// Check for amount of damage sustained and set die modifier accordingly
		int iDamageModifier;
		int iDamage = GetPercentageHPLoss(OBJECT_SELF);
			if (iDamage <= 25) {
				iDamageModifier = -8; }
			else if 
			(iDamage <= 50)
			{iDamageModifier = -4;}
			else if
			(iDamage <= 75)
			{iDamageModifier = -2;}
			else
			{iDamageModifier = 0;}
		// Check for alignment and set die modifier accordingly
		int iAlignmentModifier;
	//	int iAlignment = GetLawChaosValue(OBJECT_SELF);
	//		if 
	//		(iAlignment <= 33)
	//		{iAlignmentModifier = -1;}
	//		else if
//			(iAlignment >= 66)
	//		{iAlignmentModifier = 1;}
	//		else
	//		{iAlignmentModifier = 0;}
		// Check for ratio of enemies to allies
		int iOutnumberModifier;
		struct sSituation sitCurr = CountEnemiesAndAllies(30.0,OBJECT_SELF);
		int nNumEnemies = sitCurr.ENEMY_NUM;
		int nNumAllies = sitCurr.ALLY_NUM;
		
		    // AcadiusLost - escape the DIVIDE BY ZERO case.
		    if (nNumEnemies == 0) { return;}
			// SpeakString(IntToString(nNumEnemies)+" enemies vs. "+IntToString(nNumAllies)+" allies.");
			if
			(nNumEnemies / (nNumAllies + 1) == 1)
			{iOutnumberModifier = 0;}
			else if ((nNumAllies + 1) > nNumEnemies) {
				// extra boost when the NPCs outnumber the PCs
				iOutnumberModifier = 2 * (nNumAllies + 1) / nNumEnemies;
			} else {
				iOutnumberModifier = -(nNumEnemies / (nNumAllies + 1));
			}
		// Check for CR of testing creature
		int iCRModifier;
			if
			(GetChallengeRating(OBJECT_SELF) > 7.5)
			{iCRModifier = 3;}
			else if
			(GetChallengeRating(OBJECT_SELF) > 4.5)
			{iCRModifier = 2;}
			else if
			(GetChallengeRating(OBJECT_SELF) > 2.0)
			{iCRModifier = 1;}
			else if
			((GetChallengeRating(OBJECT_SELF) < 0.5) & (GetChallengeRating(OBJECT_SELF) > 0.25))
			{iCRModifier = -1;}
			else if
			(GetChallengeRating(OBJECT_SELF) < 0.25)
			{iCRModifier = -2;}
			else 
			{iCRModifier = 0;}
			// Work out die roll needed to pass morale test
		int iFinalScore;
		object oTarget = GetNearestSeenEnemy(OBJECT_SELF,1);
		iFinalScore = iRating + iDamageModifier + iAlignmentModifier + iOutnumberModifier + iCRModifier;
		
	    if(iRating == 0) {
				ClearAllActions(TRUE);
				AssignCommand(OBJECT_SELF, ActionMoveAwayFromObject(oTarget,TRUE,200.0));
				SetLocalInt(OBJECT_SELF, "Fleeing", 1);
				DelayCommand(180.0, DeleteLocalInt(OBJECT_SELF, "Fleeing"));
				// SpeakString("Morale zero, fleeing!");
			//SendMessageToPC(oPC, "Zero rating condition for "+GetName(OBJECT_SELF)+", fleeing from "+GetName(oTarget));
			}
			else if
			(iRoll > iFinalScore) {
				ClearAllActions(TRUE);
				AssignCommand(OBJECT_SELF, ActionMoveAwayFromObject(oTarget,TRUE,200.0));
				SetLocalInt(OBJECT_SELF, "Fleeing", 1);
				DelayCommand(180.0, DeleteLocalInt(OBJECT_SELF, "Fleeing"));
				// SpeakString("Rolled a "+IntToString(iRoll)+"/20! versus modified rating of "+IntToString(iFinalScore)+" Fleeing.");
			//SendMessageToPC(oPC, GetName(OBJECT_SELF)+": Morale Break, fleeing from "+GetName(oTarget));
			}
			else {
				//SpeakString("Sucessful check with roll= "+IntToString(iRoll)+"/20 versus modified rating of "+IntToString(iFinalScore)); 
				return;
				
			}
			
			
		// Debugging message
		//string sRoll = IntToString(iRoll);
		//string sRating = IntToString(iRating);
		//string sDamage = IntToString(iDamageModifier);
		//string sAlignment = IntToString(iAlignmentModifier);
		//string sOutnumber = IntToString(iOutnumberModifier);
		//string sCR = IntToString(iCRModifier);
		//string sFinalScore = IntToString(iFinalScore);
		//string sNumAllies = IntToString(nNumAllies);
		//SendMessageToPC( GetFirstPC(), (sRoll + " rolled, rating: " + sRating + ", Damage: " +  sDamage + ", Outnumber: " +  sOutnumber + ", Allies: "+ sNumAllies + ", CR: " +  sCR + ", Final: " +  sFinalScore) );
		// 		End morale test
		
		*/
			
			
		
		
		
	
	
	
	
	
	
	
}